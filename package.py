from pathlib import Path
import subprocess, zipfile, re, json
r=Path(__file__).resolve().parent
subprocess.run(['ditto',str(r/'Artifacts/DeviceDerived/Build/Products/Match-iphoneos/BoraJogar.app'),str(r/'Delivery/Device/BoraJogar.app')],check=True)
for p in [r/'Delivery/Device/BoraJogar.app/BoraJogar',r/'Delivery/Device/BoraJogar.app/PlugIns/Touchline73.appex/Touchline73']:
 subprocess.run(['/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip','-S',str(p)],check=True)
 assert not re.search(rb'/Users/',p.read_bytes())
with zipfile.ZipFile(r/'Delivery/BoraJogar-unsigned-device.zip','w',zipfile.ZIP_DEFLATED) as z:
 for p in (r/'Delivery/Device').rglob('*'):
  if p.is_file():z.write(p,p.relative_to(r/'Delivery/Device'))
with zipfile.ZipFile(r/'Delivery/BoraJogar-source.zip','w',zipfile.ZIP_DEFLATED) as z:
 for folder in ['BoraJogar','BoraJogar.xcodeproj','Checks','Metadata']:
  for p in (r/folder).rglob('*'):
   if p.is_file() and 'xcuserdata' not in p.parts and p.name!='.DS_Store':z.write(p,p.relative_to(r))
 for n in ['REPORT.md','CLOUDKIT.md','QA/ACCEPTANCE.md','QA/static-audit.json','QA/run.sh','QA/host-model.log','QA/host-crypto.log','QA/host-state.log','QA/host-moderation.log']:
  z.write(r/n,n)
print('Packaged current source and unsigned device binaries; machine-path scan passed.')
