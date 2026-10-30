import 'server-only';
import {createHmac} from 'node:crypto';
import {hashKey,activeKey} from './keys';
export {newKey} from './keys';
import {NextResponse} from 'next/server';
import {ZodError} from 'zod';
import {adminDb} from './db';
export function json(data:unknown,status=200){return NextResponse.json(data,{status,headers:{'Cache-Control':'no-store'}})}
export function failure(e:unknown){const message=e instanceof Error?e.message:'Unexpected error';const code=e instanceof ZodError?'INVALID_INPUT':['UNAUTHORIZED','FORBIDDEN','SETUP_REQUIRED','RATE_LIMITED','AI_UNAVAILABLE','INVALID_ORIGIN','NOT_FOUND'].includes(message)?message:'REQUEST_FAILED';const status=({INVALID_INPUT:400,UNAUTHORIZED:401,FORBIDDEN:403,SETUP_REQUIRED:503,RATE_LIMITED:429,AI_UNAVAILABLE:503,INVALID_ORIGIN:403,NOT_FOUND:404} as Record<string,number>)[code]??400;console.warn(JSON.stringify({event:'request_failed',code}));return json({error:{code,message:code==='INVALID_INPUT'?'Check the submitted fields.':code==='REQUEST_FAILED'?'Request could not be completed. Refresh and check your permissions and inputs.':code}},status)}
export async function body(req:Request){if(!req.headers.get('content-type')?.startsWith('application/json'))throw new Error('Invalid content type');const text=await req.text();if(text.length>70000)throw new Error('Request too large');return JSON.parse(text)}
export function origin(req:Request){const expected=new URL(process.env.APP_URL||'http://localhost:3000').origin;if(req.headers.get('origin')!==expected)throw new Error('INVALID_ORIGIN')}
export async function rate(bucket:string,limit:number,seconds=60){const {data,error}=await adminDb().rpc('consume_rate',{p_bucket:bucket,p_limit:limit,p_seconds:seconds});if(error)throw new Error('SETUP_REQUIRED');if(!data)throw new Error('RATE_LIMITED')}
export async function apiAccess(req:Request){const token=req.headers.get('authorization');if(token){if(!/^Bearer tl_live_[a-f0-9]{64}$/.test(token))throw new Error('UNAUTHORIZED');const db=adminDb();const {data:key}=await db.from('api_keys').select('id,revoked_at').eq('key_hash',hashKey(token.slice(7))).single();if(!activeKey(key))throw new Error('UNAUTHORIZED');await rate('key:'+key.id,120);const {error}=await db.from('api_usage').insert({api_key_id:key.id,endpoint:new URL(req.url).pathname});if(error)throw new Error('SETUP_REQUIRED');return}
 const secret=process.env.RATE_LIMIT_SECRET;if(!secret)throw new Error('SETUP_REQUIRED');const ip=req.headers.get('x-vercel-forwarded-for')||'local';await rate('public:'+createHmac('sha256',secret).update(ip).digest('hex'),30)}
