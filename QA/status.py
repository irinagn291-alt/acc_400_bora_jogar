import hashlib,json
from pathlib import Path
r=Path(__file__).resolve().parents[1];h=hashlib.sha256();latest=0
files=list((r/'BoraJogar').rglob('*'))+list((r/'BoraJogar.xcodeproj').rglob('*'))+[r/'Checks/Proof.swift']
for p in sorted(files):
 if p.is_file() and 'xcuserdata' not in p.parts and p.name!='.DS_Store':
  h.update(str(p.relative_to(r)).encode());h.update(b'\0');h.update(p.read_bytes());latest=max(latest,p.stat().st_mtime)
status={}
for name in ['iphone','ipad']:
 p=r/'QA'/name/'passed';log=r/'QA'/name/'test.log'
 status[name]='passed' if p.exists() and p.read_text().splitlines()[0]==h.hexdigest() else 'awaiting_fix' if (r/'QA'/name/'awaiting-fix').exists() else 'running' if log.exists() and log.stat().st_mtime>=latest else 'waiting'
print(json.dumps(status))
