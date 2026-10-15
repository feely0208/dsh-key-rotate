#!/bin/bash
set -uo pipefail
export PATH="/usr/local/bin:$PATH"
cd "$(dirname "$0")/.."
PASS=0; FAIL=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
bad(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }
echo ""; echo "  @deepwhale-cn/dsh-key-rotate · 双向验证"
echo "  ────────────────────────────────────────────────"
N=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${N:-0}" -ge 3 ] && ok "违规样本命中 ${N} 条" || bad "违规样本只命中 ${N} 条"
J=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --json 2>&1)
for rid in KEY-AGE KEY-NO-POLICY KEY-SHARED-ENV; do
  c=$(echo "$J" | python3 -c "
import json,sys; d=json.load(sys.stdin)
print(len([f for f in d['findings'] if f['ruleId']=='$rid']))" 2>/dev/null)
  [ "${c:-0}" -gt 0 ] && ok "$rid 报出" || bad "$rid 未报出"
done
M=$(node bin/cli.mjs --root tests/fixtures/pass/clean-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${M:-1}" = "0" ] && ok "合规样本 0 命中" || bad "误报 ${M} 条"
echo ""; echo "  【回归】**/id_rsa 必须匹配根目录的 id_rsa（2026-10-13 真实 bug）"
G=$(node --input-type=module -e "
import { globToRe } from '@deepwhale-cn/dsh-guard-core';
const cases=[['**/id_rsa','id_rsa',true],['**/id_rsa','a/b/id_rsa',true],['**/*.pem','k.pem',true],['*.pem','x/k.pem',false]];
let bad=0; for(const [g,p,w] of cases) if(globToRe(g).test(p)!==w) bad++;
console.log(bad);" 2>/dev/null)
[ "${G:-1}" = "0" ] && ok "glob **/ 语义正确" || bad "glob **/ 仍有 ${G} 个用例失败"
echo ""; echo "  【溯源】每条规则必须带 source"
python3 - <<'PY' && ok "全部规则均有 source" || bad "有规则缺 source"
import json,glob,sys
for f in glob.glob('rules/*.json'):
    r=json.load(open(f,encoding='utf-8'))
    if not r.get('source'): print('缺:',r.get('id'),file=sys.stderr); sys.exit(1)
PY
echo ""; echo "  ────────────────────────────────────────────────"
echo "  通过 $PASS · 失败 $FAIL"; echo ""
[ "$FAIL" -eq 0 ] || exit 1
