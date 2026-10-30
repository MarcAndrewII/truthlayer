import 'server-only';
import { createServerClient } from '@supabase/ssr';
import { createClient } from '@supabase/supabase-js';
import { cookies } from 'next/headers';
export function configured(){return !!(process.env.NEXT_PUBLIC_SUPABASE_URL&&process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY)}
export async function sessionDb(){
 if(!configured())throw new Error('SETUP_REQUIRED');const jar=await cookies();
 return createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,{cookies:{getAll:()=>jar.getAll(),setAll:items=>{try{items.forEach(({name,value,options})=>jar.set(name,value,options))}catch{/* Refreshed by proxy in server renders. */}}}});
}
export function adminDb(){if(!configured()||!process.env.SUPABASE_SERVICE_ROLE_KEY)throw new Error('SETUP_REQUIRED');return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.SUPABASE_SERVICE_ROLE_KEY,{auth:{persistSession:false,autoRefreshToken:false}})}
export async function identity(reviewer=false){const db=await sessionDb();const {data:{user},error}=await db.auth.getUser();if(error||!user)throw new Error('UNAUTHORIZED');const {data:profile}=await db.from('profiles').select('role').eq('id',user.id).single();if(reviewer&&profile?.role!=='reviewer')throw new Error('FORBIDDEN');return {db,user,reviewer:profile?.role==='reviewer'}}
