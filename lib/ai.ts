import 'server-only';
import OpenAI from 'openai';
import {extractWith,assessWith,compareWith} from './ai-core';
import type {PublicRecord} from './domain';
export const model=()=>process.env.OPENAI_MODEL||'gpt-4.1-mini';
function client(){if(!process.env.OPENAI_API_KEY)throw new Error('AI_UNAVAILABLE');return new OpenAI({apiKey:process.env.OPENAI_API_KEY,timeout:25000,maxRetries:1})}
export async function extract(text:string){return extractWith(client(),model(),text)}
export async function assess(data:unknown,urls:string[]){return assessWith(client(),model(),data,urls)}
export async function compare(question:string,records:PublicRecord[]){return compareWith(client(),model(),question,records)}
