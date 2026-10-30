import {createHash,randomBytes} from 'node:crypto';
export function hashKey(key:string){return createHash('sha256').update(key).digest('hex')}
export function newKey(){const raw='tl_live_'+randomBytes(32).toString('hex');return {raw,hash:hashKey(raw),prefix:raw.slice(0,16)}}
export function activeKey(key:{id:string;revoked_at:string|null}|null):key is {id:string;revoked_at:null}{return !!key&&!key.revoked_at}
