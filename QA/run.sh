#!/bin/bash
set -euo pipefail
BORA_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
BORA_TAG="${BORA_QA_TAG:-iphone}"
BORA_EVIDENCE="$BORA_ROOT/QA/$BORA_TAG"
: "${GF_SIMULATOR_UDID:?Run through the factory simulator pool}"
: "${GF_SIMULATOR_LOCK_HELD:?Factory parent must own the activity slot}"
BORA_HASH="$(python3 - "$BORA_ROOT" <<'BORA_HASH_PY'
import hashlib,sys
from pathlib import Path
r=Path(sys.argv[1]);h=hashlib.sha256()
files=list((r/'BoraJogar').rglob('*'))+list((r/'BoraJogar.xcodeproj').rglob('*'))+[r/'Checks/Proof.swift']
for p in sorted(files):
 if p.is_file() and 'xcuserdata' not in p.parts and p.name!='.DS_Store':
  h.update(str(p.relative_to(r)).encode());h.update(b'\0');h.update(p.read_bytes())
print(h.hexdigest())
BORA_HASH_PY
)"
bora_passed() { [[ -f "$BORA_ROOT/QA/$1/passed" ]] && [[ "$(head -n 1 "$BORA_ROOT/QA/$1/passed")" == "$BORA_HASH" ]]; }
if bora_passed iphone && bora_passed ipad; then
  printf 'Both device QA runs already passed.\n'
  exit 0
fi
mkdir -p "$BORA_EVIDENCE"
rm -f "$BORA_EVIDENCE/retry" "$BORA_EVIDENCE/awaiting-fix"
BORA_RESULT="$BORA_EVIDENCE/Result.xcresult"
if [[ -e "$BORA_RESULT" ]]; then
  BORA_RESULT="$BORA_EVIDENCE/Result-$(date +%Y%m%d-%H%M%S).xcresult"
  if [[ -f "$BORA_EVIDENCE/test.log" ]]; then cp "$BORA_EVIDENCE/test.log" "${BORA_RESULT%.xcresult}.previous.log"; fi
fi
xcrun simctl boot "$GF_SIMULATOR_UDID"
xcrun simctl bootstatus "$GF_SIMULATOR_UDID" -b
xcrun simctl status_bar "$GF_SIMULATOR_UDID" override --time 9:41 --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
BORA_STATUS=0
xcodebuild -project "$BORA_ROOT/BoraJogar.xcodeproj" -scheme Courtyard73 -configuration Practice -destination "id=$GF_SIMULATOR_UDID" -parallel-testing-enabled NO -derivedDataPath "$BORA_ROOT/Artifacts/DerivedData" -resultBundlePath "$BORA_RESULT" CODE_SIGNING_ALLOWED=NO ARCHS=arm64 test > "$BORA_EVIDENCE/test.log" 2>&1 || BORA_STATUS=$?
xcrun xcresulttool export attachments --path "$BORA_RESULT" --output-path "${BORA_RESULT%.xcresult}-attachments" || true
xcrun xcresulttool get test-results summary --path "$BORA_RESULT" > "$BORA_EVIDENCE/summary.json" || true
if [[ "$BORA_STATUS" -ne 0 ]]; then
  if [[ "${BORA_QA_ATTEMPT:-0}" -lt 2 ]]; then
    touch "$BORA_EVIDENCE/awaiting-fix"
    printf 'QA awaiting a local correction for at most 180 seconds.\n'
    for BORA_WAIT in $(seq 1 180); do
      if [[ -f "$BORA_EVIDENCE/retry" ]]; then
        rm -f "$BORA_EVIDENCE/awaiting-fix" "$BORA_EVIDENCE/retry"
        xcrun simctl uninstall "$GF_SIMULATOR_UDID" org.courtyard.borajogar.a73f2 || true
        exec env BORA_QA_ATTEMPT="$(( ${BORA_QA_ATTEMPT:-0} + 1 ))" bash "$BORA_ROOT/QA/run.sh"
      fi
      sleep 1
    done
  fi
  exit "$BORA_STATUS"
fi
xcrun simctl launch "$GF_SIMULATOR_UDID" org.courtyard.borajogar.a73f2
sleep 2
xcrun simctl io "$GF_SIMULATOR_UDID" screenshot "$BORA_EVIDENCE/post-tests.png"
printf '%s\n%s\n' "$BORA_HASH" "$(basename "$BORA_RESULT")" > "$BORA_EVIDENCE/passed"
if [[ "${BORA_QA_NESTED:-0}" != 1 ]]; then
  if [[ "$BORA_TAG" == iphone* ]]; then BORA_OTHER=ipad; else BORA_OTHER=iphone; fi
  if ! bora_passed "$BORA_OTHER"; then
    xcrun simctl shutdown "$GF_SIMULATOR_UDID"
    BORA_FACTORY="${BORA_FACTORY_ROOT:-$(cd "$BORA_ROOT/../../../.." && pwd)}"
    BORA_POOL="$BORA_FACTORY/gf/genesis/simulator_pool.py"
    BORA_TEMPLATE="$(PYTHONDONTWRITEBYTECODE=1 python3 - "$BORA_POOL" "$BORA_OTHER" <<'PY'
import importlib.util,sys
spec=importlib.util.spec_from_file_location('bora_pool_reference',sys.argv[1])
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
prefix='iPad' if sys.argv[2]=='ipad' else 'iPhone'
preferred='iPad Pro 13-inch (M5)' if prefix=='iPad' else 'iPhone 18 Pro'
rows=[d for group in m.inventory()['devices'].values() for d in group if d['name'].startswith(prefix)]
rows.sort(key=lambda d:(d['name']!=preferred,d['name']))
if not rows: raise SystemExit('No required simulator template is available')
print(rows[0]['udid'])
PY
)"
    BORA_QA_TAG="$BORA_OTHER" BORA_QA_NESTED=1 python3 "$BORA_POOL" "$BORA_TEMPLATE" bash "$BORA_ROOT/QA/run.sh"
  fi
fi
