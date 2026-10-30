import assert from 'node:assert/strict';
const base=process.argv[2]||'http://localhost:3000';
for(const path of ['/','/claims','/demo','/docs','/trust','/login','/signup','/reset','/dashboard','/review','/developers']){const r=await fetch(new URL(path,base));assert.equal(r.status,200,path);console.log(`PASS ${path}`)}
const health=await fetch(new URL('/api/v1/health',base));assert.ok([200,503].includes(health.status));console.log('HEALTH',health.status,await health.text());
const rejected=await fetch(new URL('/api/app/keys',base),{method:'POST',headers:{'Content-Type':'application/json',Origin:'https://untrusted.example'},body:JSON.stringify({label:'should never be created'})});assert.equal(rejected.status,403);console.log('PASS foreign-origin mutation denied');
const missing=await fetch(new URL('/claims/00000000-0000-4000-8000-000000000000',base));assert.equal(missing.status,404);console.log('PASS missing public record');
