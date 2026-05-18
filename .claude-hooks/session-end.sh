#!/usr/bin/env bash
# ==============================================================================
#  vault SessionEnd hook — git add / commit / push (변경사항 있을 때만)
#  - 변경사항 없으면 silent exit
#  - 커밋 메시지: "auto: YYYY-MM-DD HH:MM by <hostname>"
#  - 에러 나도 세션 종료는 절대 막지 않음 (항상 exit 0)
# ==============================================================================
set +e

VAULT="/c/claude/vault"

[ -d "$VAULT/.git" ] || exit 0
cd "$VAULT" || exit 0
git remote get-url origin >/dev/null 2>&1 || exit 0

# 변경사항 체크: tracked 변경 + staged 변경 + untracked 신규 파일
TRACKED_CHANGED=$(git status --porcelain 2>/dev/null | head -1)
if [ -z "$TRACKED_CHANGED" ]; then
    exit 0  # nothing to commit
fi

# 커밋 메시지 (timestamp + hostname)
TS=$(date '+%Y-%m-%d %H:%M')
HOST=$(hostname 2>/dev/null || echo "unknown")
HOST=$(printf '%s' "$HOST" | tr -d '\n')
MSG="auto: ${TS} by ${HOST}"

# git add + commit + push (모든 오류 무시)
git add -A >/dev/null 2>&1
git commit -m "$MSG" >/dev/null 2>&1
git push origin main >/dev/null 2>&1

exit 0
