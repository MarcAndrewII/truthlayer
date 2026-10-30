import {NextResponse} from 'next/server';
import {sessionDb} from '@/lib/db';
export async function GET(req:Request){const u=new URL(req.url);const code=u.searchParams.get('code');if(code){const db=await sessionDb();const {error}=await db.auth.exchangeCodeForSession(code);if(!error)return NextResponse.redirect(new URL(u.searchParams.get('next')==='/account/password'?'/account/password':'/dashboard',process.env.APP_URL||u.origin))}return NextResponse.redirect(new URL('/login?error=confirmation_failed',process.env.APP_URL||u.origin))}
