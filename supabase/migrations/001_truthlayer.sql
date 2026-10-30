-- Run in a NEW Supabase project. Additive migration; no existing data is deleted.
create type public.claim_status as enum ('DRAFT','SUBMITTED','UNDER_REVIEW','VERIFIED','DISPUTED','REJECTED','SUPERSEDED');
create table public.profiles(id uuid primary key references auth.users(id), role text not null default 'member' check(role in ('member','reviewer')), created_at timestamptz not null default now());
create function public.new_profile() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into profiles(id) values(new.id); return new; end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.new_profile();
insert into public.profiles(id) select id from auth.users on conflict do nothing;
create table public.entities(id uuid primary key default gen_random_uuid(), name text not null, normalized_name text unique not null);
create table public.claims(
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references profiles(id), entity_id uuid not null references entities(id),
 original text not null check(length(original) between 5 and 4000), platform text not null default '', predicate text not null check(length(predicate) between 2 and 120), value text not null check(length(value) between 1 and 2000),
 explanation text not null, category text not null check(category in ('Company information','Product information','Historical information','Scientific information','Technology','Public organizational information','General factual claims')),
 valid_from date, valid_to date, check(valid_to is null or valid_from is null or valid_to>=valid_from),
 status claim_status not null default 'DRAFT', published boolean not null default false, version integer not null default 1,
 request_id uuid not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), reviewed_at timestamptz,
 unique(owner_id,request_id), check(not published or status in ('VERIFIED','DISPUTED','SUPERSEDED')));
create index claims_entity_predicate on claims(entity_id,predicate);
create index claims_public_updated on claims(published,updated_at desc);
create index claims_owner on claims(owner_id);
create table public.claim_versions(id uuid primary key default gen_random_uuid(), claim_id uuid not null references claims(id), version integer not null, snapshot jsonb not null, created_at timestamptz not null default now(), unique(claim_id,version));
create table public.evidence_sources(id uuid primary key default gen_random_uuid(),claim_id uuid not null references claims(id),url text not null check(url ~ '^https://'),title text not null default '',submitted_text text not null default '', retrieval_status text not null default 'NOT_RETRIEVED' check(retrieval_status='NOT_RETRIEVED'),created_at timestamptz not null default now());
create table public.evidence_assessments(id uuid primary key default gen_random_uuid(),claim_id uuid not null references claims(id),claim_version integer not null,assessment jsonb not null,model text,created_at timestamptz not null default now());
create table public.claim_reviews(id uuid primary key default gen_random_uuid(),claim_id uuid not null references claims(id),actor_id uuid not null references profiles(id),decision claim_status not null,public_reason text not null,internal_notes text not null default '',evidence_checked boolean not null default false,created_at timestamptz not null default now());
create table public.claim_status_history(id uuid primary key default gen_random_uuid(),claim_id uuid not null references claims(id),previous_status claim_status,new_status claim_status not null,actor_id uuid not null references profiles(id),reason text not null,created_at timestamptz not null default now());
create table public.api_keys(id uuid primary key default gen_random_uuid(),owner_id uuid not null references profiles(id),label text not null,key_hash text unique not null,prefix text not null,revoked_at timestamptz,created_at timestamptz not null default now());
create table public.api_usage(id uuid primary key default gen_random_uuid(),api_key_id uuid references api_keys(id),endpoint text not null,created_at timestamptz not null default now());
create index api_usage_key_date on api_usage(api_key_id,created_at);
create table public.rate_buckets(bucket text primary key,window_start timestamptz not null,count integer not null);
create table public.audit_logs(id uuid primary key default gen_random_uuid(),actor_id uuid,action text not null,claim_id uuid references claims(id),detail jsonb not null default '{}',created_at timestamptz not null default now());
create table public.abuse_reports(id uuid primary key default gen_random_uuid(),claim_id uuid not null references claims(id),owner_id uuid not null references profiles(id),reason text not null check(length(reason) between 10 and 4000),created_at timestamptz not null default now());
create function public.is_reviewer() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from profiles where id=auth.uid() and role='reviewer') $$;
create function public.can_read_claim(cid uuid) returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from claims where id=cid and (published or owner_id=auth.uid() or is_reviewer())) $$;
-- No direct client mutations. All mutations go through narrowly scoped functions.
alter table profiles enable row level security; create policy profile_read on profiles for select using(id=auth.uid() or is_reviewer());
alter table entities enable row level security; create policy entity_read on entities for select using(exists(select 1 from claims where entity_id=entities.id and (published or owner_id=auth.uid() or is_reviewer())));
alter table claims enable row level security; create policy claim_read on claims for select using(owner_id=auth.uid() or is_reviewer());
alter table claim_versions enable row level security; create policy versions_private on claim_versions for select using(exists(select 1 from claims where id=claim_id and (owner_id=auth.uid() or is_reviewer())));
alter table evidence_sources enable row level security; create policy evidence_private on evidence_sources for select using(exists(select 1 from claims where id=claim_id and (owner_id=auth.uid() or is_reviewer())));
alter table evidence_assessments enable row level security; create policy assessment_private on evidence_assessments for select using(exists(select 1 from claims where id=claim_id and (owner_id=auth.uid() or is_reviewer())));
alter table claim_reviews enable row level security; create policy review_private on claim_reviews for select using(is_reviewer());
alter table claim_status_history enable row level security; create policy history_private on claim_status_history for select using(exists(select 1 from claims where id=claim_id and (owner_id=auth.uid() or is_reviewer())));
alter table api_keys enable row level security; create policy key_private on api_keys for select using(owner_id=auth.uid());
alter table api_usage enable row level security; create policy usage_private on api_usage for select using(exists(select 1 from api_keys where id=api_key_id and owner_id=auth.uid()));
alter table audit_logs enable row level security; create policy audit_private on audit_logs for select using(is_reviewer());
alter table abuse_reports enable row level security; create policy abuse_private on abuse_reports for select using(owner_id=auth.uid() or is_reviewer());
alter table rate_buckets enable row level security;

create function public.consume_rate(p_bucket text,p_limit int,p_seconds int) returns boolean language plpgsql security definer set search_path=public as $$
declare n int; begin
 insert into rate_buckets(bucket,window_start,count) values(p_bucket,now(),1)
 on conflict(bucket) do update set count=case when rate_buckets.window_start < now()-make_interval(secs=>p_seconds) then 1 else rate_buckets.count+1 end,window_start=case when rate_buckets.window_start < now()-make_interval(secs=>p_seconds) then now() else rate_buckets.window_start end returning count into n;
 return n<=p_limit; end $$;

create function public.save_claim(p_id uuid,p_request uuid,p_data jsonb,p_submit boolean) returns uuid language plpgsql security definer set search_path=public as $$
declare cid uuid; eid uuid; old claims; uid uuid:=auth.uid(); next_status claim_status; begin
 if uid is null then raise exception 'Authentication required'; end if;
 if not consume_rate('save:'||uid,30,3600) then raise exception 'Rate limit exceeded'; end if;
 if length(p_data->>'entity') not between 2 and 200 or length(p_data->>'explanation') not between 10 and 6000 or length(coalesce(p_data->>'platform',''))>120 then raise exception 'Invalid claim'; end if;
 if p_data->>'publicationConsent' is distinct from 'true' then raise exception 'Publication acknowledgment required'; end if;
 if jsonb_typeof(p_data->'evidence') is distinct from 'array' then raise exception 'Evidence must be an array'; end if;
 if exists(select 1 from jsonb_array_elements(p_data->'evidence') x where jsonb_typeof(x)<>'object' or coalesce(x->>'url','') !~ '^https://[^/@?#]+([/?#]|$)' or length(x->>'url')>2000 or length(coalesce(x->>'title',''))>200 or length(coalesce(x->>'text',''))>6000) then raise exception 'Invalid evidence source'; end if;
 if jsonb_array_length(coalesce(p_data->'evidence','[]'))>8 then raise exception 'Too many sources'; end if;
 if p_submit and jsonb_array_length(coalesce(p_data->'evidence','[]'))=0 then raise exception 'Evidence required'; end if;
 if p_id is null then
  select id into cid from claims where owner_id=uid and request_id=p_request; if cid is not null then return cid; end if;
 else
  select * into old from claims where id=p_id for update;
  if old.id is null or old.owner_id<>uid or old.status<>'DRAFT' then raise exception 'Only your drafts can be edited'; end if;
 end if;
 insert into entities(name,normalized_name) values(trim(p_data->>'entity'),lower(trim(p_data->>'entity'))) on conflict(normalized_name) do update set normalized_name=excluded.normalized_name returning id into eid;
 if p_id is null and exists(select 1 from claims where owner_id=uid and entity_id=eid and original=p_data->>'original' and predicate=p_data->>'predicate' and value=p_data->>'value' and status not in ('REJECTED','SUPERSEDED')) then raise exception 'Duplicate active submission'; end if;
 next_status:=case when p_submit then 'SUBMITTED'::claim_status else 'DRAFT'::claim_status end;
 if p_id is null then
 insert into claims(owner_id,entity_id,original,platform,predicate,value,explanation,category,valid_from,valid_to,status,request_id)
 values(uid,eid,p_data->>'original',coalesce(p_data->>'platform',''),p_data->>'predicate',p_data->>'value',p_data->>'explanation',p_data->>'category',nullif(p_data->>'validFrom','')::date,nullif(p_data->>'validTo','')::date,next_status,p_request) returning id into cid;
 else
 cid:=p_id; update claims set entity_id=eid,original=p_data->>'original',platform=coalesce(p_data->>'platform',''),predicate=p_data->>'predicate',value=p_data->>'value',explanation=p_data->>'explanation',category=p_data->>'category',valid_from=nullif(p_data->>'validFrom','')::date,valid_to=nullif(p_data->>'validTo','')::date,status=next_status,version=version+1,updated_at=now() where id=cid;
 delete from evidence_sources where claim_id=cid;
 end if;
 insert into evidence_sources(claim_id,url,title,submitted_text) select cid,x->>'url',coalesce(x->>'title',''),coalesce(x->>'text','') from jsonb_array_elements(p_data->'evidence') x;
 insert into claim_versions(claim_id,version,snapshot) select cid,version,jsonb_build_object('claim',to_jsonb(c),'evidence',coalesce((select jsonb_agg(to_jsonb(e)) from evidence_sources e where claim_id=cid),'[]')) from claims c where id=cid;
 insert into claim_status_history(claim_id,previous_status,new_status,actor_id,reason) values(cid,old.status,next_status,uid,case when p_submit then 'Submitted for review' else 'Draft saved' end);
 insert into audit_logs(actor_id,action,claim_id) values(uid,'claim_saved',cid); return cid; end $$;

create function public.review_claim(p_id uuid,p_status claim_status,p_reason text,p_notes text,p_checked boolean,p_version int) returns void language plpgsql security definer set search_path=public as $$
declare c claims; begin
 if not is_reviewer() then raise exception 'Reviewer access required'; end if;
 select * into c from claims where id=p_id for update;
 if c.id is null or c.version<>p_version then raise exception 'Record changed; refresh before review'; end if;
 if c.owner_id=auth.uid() then raise exception 'You cannot review your own claim'; end if;
 if length(trim(p_reason))<10 or length(p_reason)>4000 then raise exception 'A substantive public reason is required'; end if;
 if not ((c.status='SUBMITTED' and p_status in ('UNDER_REVIEW','REJECTED')) or (c.status='UNDER_REVIEW' and p_status in ('VERIFIED','DISPUTED','REJECTED','DRAFT')) or (c.status='VERIFIED' and p_status in ('DISPUTED','SUPERSEDED')) or (c.status='DISPUTED' and p_status in ('UNDER_REVIEW','SUPERSEDED'))) then raise exception 'Invalid status transition'; end if;
 if p_status='VERIFIED' and (not p_checked or not exists(select 1 from evidence_sources where claim_id=p_id)) then raise exception 'Independent source review required'; end if;
 update claims set status=p_status,published=case when p_status='VERIFIED' then true when p_status in ('DRAFT','UNDER_REVIEW','REJECTED') then false else published end,reviewed_at=now(),updated_at=now(),version=version+1 where id=p_id;
 insert into claim_reviews(claim_id,actor_id,decision,public_reason,internal_notes,evidence_checked) values(p_id,auth.uid(),p_status,p_reason,coalesce(p_notes,''),p_checked);
 insert into claim_status_history(claim_id,previous_status,new_status,actor_id,reason) values(p_id,c.status,p_status,auth.uid(),p_reason);
 insert into claim_versions(claim_id,version,snapshot) select p_id,version,jsonb_build_object('claim',to_jsonb(v),'evidence',coalesce((select jsonb_agg(to_jsonb(e)) from evidence_sources e where claim_id=p_id),'[]')) from claims v where id=p_id;
 insert into audit_logs(actor_id,action,claim_id,detail) values(auth.uid(),'review',p_id,jsonb_build_object('from',c.status,'to',p_status)); end $$;

-- Safe public projection excludes ownership, draft versions, source excerpts, and internal notes.
create function public.public_records(p_entity text default '',p_predicate text default '',p_query text default '',p_date date default null,p_status text default '',p_category text default '',p_offset int default 0,p_limit int default 20,p_id uuid default null) returns setof jsonb language sql stable security definer set search_path=public as $$
 select jsonb_build_object('id',c.id,'entity',e.name,'original',c.original,'predicate',c.predicate,'value',c.value,'category',c.category,'status',c.status,'valid_from',c.valid_from,'valid_to',c.valid_to,'version',c.version,'last_reviewed',c.reviewed_at,'updated_at',c.updated_at,
 'versions',coalesce((select jsonb_agg(jsonb_build_object('version',v.version,'status',v.snapshot->'claim'->>'status','original',v.snapshot->'claim'->>'original','predicate',v.snapshot->'claim'->>'predicate','value',v.snapshot->'claim'->>'value','valid_from',v.snapshot->'claim'->>'valid_from','valid_to',v.snapshot->'claim'->>'valid_to','at',v.created_at) order by v.version desc) from claim_versions v where v.claim_id=c.id and v.snapshot->'claim'->>'published'='true'),'[]'),
 'sources',coalesce((select jsonb_agg(jsonb_build_object('url',s.url,'title',s.title)) from evidence_sources s where s.claim_id=c.id),'[]'),
 'history',coalesce((select jsonb_agg(jsonb_build_object('status',r.decision,'reason',r.public_reason,'at',r.created_at) order by r.created_at) from claim_reviews r where r.claim_id=c.id and r.decision in ('VERIFIED','DISPUTED','SUPERSEDED')),'[]'))
 from claims c join entities e on e.id=c.entity_id where c.published and (p_id is null or c.id=p_id)
 and (p_entity='' or e.normalized_name=lower(trim(p_entity))) and (p_predicate='' or c.predicate=p_predicate)
 and (p_query='' or position(lower(p_query) in lower(e.name||' '||c.original||' '||c.value))>0)
 and (p_status='' or c.status::text=p_status) and (p_category='' or c.category=p_category)
 and (p_date is null or ((c.valid_from is null or c.valid_from<=p_date) and (c.valid_to is null or c.valid_to>=p_date)))
 order by c.updated_at desc,c.id limit least(greatest(p_limit,1),50) offset greatest(p_offset,0) $$;

create function public.report_claim(p_id uuid,p_reason text) returns void language plpgsql security definer set search_path=public as $$ begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 if not consume_rate('report:'||auth.uid(),5,3600) then raise exception 'Rate limit exceeded'; end if;
 if not exists(select 1 from claims where id=p_id and published) then raise exception 'Public record not found'; end if;
 insert into abuse_reports(claim_id,owner_id,reason) values(p_id,auth.uid(),p_reason); end $$;

-- Strip default function execution privileges; explicitly grant only intended entry points.
revoke all on function public.new_profile(),public.is_reviewer(),public.can_read_claim(uuid),public.consume_rate(text,int,int),public.save_claim(uuid,uuid,jsonb,boolean),public.review_claim(uuid,claim_status,text,text,boolean,int),public.public_records(text,text,text,date,text,text,int,int,uuid),public.report_claim(uuid,text) from public,anon,authenticated;
grant execute on function public.is_reviewer(),public.can_read_claim(uuid) to anon,authenticated;
grant execute on function public.public_records(text,text,text,date,text,text,int,int,uuid) to service_role;
grant execute on function public.save_claim(uuid,uuid,jsonb,boolean),public.review_claim(uuid,claim_status,text,text,boolean,int),public.report_claim(uuid,text) to authenticated;
grant execute on function public.consume_rate(text,int,int) to service_role;
grant select on all tables in schema public to authenticated;
grant select on public.claims,public.entities to anon;
grant all on all tables in schema public to service_role;
