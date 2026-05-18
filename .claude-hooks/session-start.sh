#!/usr/bin/env bash
# ==============================================================================
#  vault SessionStart hook — git pull (fast-forward only)
#  - vault 가 git repo 가 아니면 조용히 skip
#  - 정상 pull → silent
#  - 충돌/non-FF → systemMessage 로 사용자에게 알림 (블로킹 X)
# ==============================================================================
set +e

VAULT="/c/claude/vault"

# 1) vault dir / .git 존재 체크 (없으면 silent exit)
[ -d "$VAULT/.git" ] || exit 0

cd "$VAULT" || exit 0

# 2) remote 없으면 silent exit
git remote get-url origin >/dev/null 2>&1 || exit 0

# 3) fast-forward only pull 시도
out=$(git pull --ff-only --no-rebase 2>&1)
rc=$?

# 4) 실패 시 사용자에게 알림 (절대 블로킹 X — 항상 exit 0)
if [ $rc -ne 0 ]; then
    # JSON 안전한 형태로 메시지 조립
    snippet=$(printf '%s' "$out" | tr -d '\r' | tr '\n' ' ' | tr -d '"' | tr -d '\\' | head -c 300)
    cat <<EOF
{"systemMessage":"⚠ vault git pull 실패 (충돌/non-FF) — 수동 해결: cd C:/claude/vault && git status","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"vault pull rc=$rc out=${snippet}"}}
EOF
fi

exit 0
