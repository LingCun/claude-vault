---
type: setup-guide
tags: [setup, git, hooks, vault, 동기화]
---

# 집 PC vault 셋업 가이드 (Windows 기준)

회사 PC 에서 만들어둔 vault sync 환경을 집 PC 에 똑같이 적용하는 절차.
**총 5분 소요.**

---

## 사전 준비물

| 항목 | 확인 |
|---|---|
| Git for Windows 설치 | `git --version` |
| Git Bash 가 PATH 에 있음 (보통 Git 설치 시 자동) | `bash --version` |
| Claude Code 설치 | `claude --version` |
| GitHub 인증 (PAT 또는 gh CLI) | `git credential-manager --version` 또는 `gh auth status` |

---

## 1단계: vault clone

```powershell
# PowerShell 또는 Git Bash 에서
mkdir C:\claude
cd C:\claude
git clone https://github.com/LingCun/claude-vault.git vault
cd vault
git log --oneline -3   # 회사 PC 와 같은 커밋 보이면 성공
```

> 만약 다른 경로(예: `D:\vault`) 에 두고 싶다면, `.claude-hooks/session-start.sh` 와 `session-end.sh` 의 `VAULT=` 경로도 수정 필요. 같은 경로(`C:\claude\vault`) 사용을 강력히 추천.

## 2단계: git 인증 설정

회사 PC 와 동일하게 둘 중 하나:

### A. GitHub CLI (가장 쉬움)

```powershell
winget install GitHub.cli
gh auth login
# → GitHub.com / HTTPS / Yes (Git credential 사용) / Browser 로 인증
```

### B. PAT (Personal Access Token)

GitHub web → Settings → Developer settings → Personal access tokens (classic) → Generate new
- scope: `repo` 만 체크
- 발급된 토큰 복사
- `git pull` 또는 `git push` 시 비번 대신 토큰 입력 → Credential Manager 가 저장

## 3단계: pull 동작 확인

```powershell
cd C:\claude\vault
git pull   # 비번 안 묻고 통과해야 함
```

## 4단계: Claude Code 전역 settings.json 에 hook 등록

`%USERPROFILE%\.claude\settings.json` 파일 열어서 (없으면 생성) 아래 내용 병합:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /c/claude/vault/.claude-hooks/session-start.sh",
            "shell": "bash",
            "timeout": 30,
            "statusMessage": "vault git pull..."
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /c/claude/vault/.claude-hooks/session-end.sh",
            "shell": "bash",
            "timeout": 60,
            "statusMessage": "vault auto commit + push..."
          }
        ]
      }
    ]
  }
}
```

> 이미 다른 설정(`theme`, `enabledPlugins` 등) 이 있으면 **기존 내용을 지우지 말고 `hooks` 키만 추가** 하세요. JSON 한 객체 안에 모두 들어가야 합니다.

## 5단계: hook 동작 확인

Claude Code 종료 후 **재시작** (settings 변경은 재시작해야 watcher 가 인식).
새 세션 열어서:

```bash
# Claude 에게 물어보세요:
# "vault 의 .claude-hooks/session-start.sh 가 잘 동작했는지 git log 로 확인해줘"
```

또는 직접:

```powershell
echo '{}' | bash /c/claude/vault/.claude-hooks/session-start.sh
echo $LASTEXITCODE   # 0 이면 성공
```

---

## 동작 정리

| 상황 | 동작 |
|---|---|
| Claude Code 세션 시작 | vault `git pull --ff-only` 자동 실행 (성공: silent / 충돌: 경고 메시지) |
| Claude Code 세션 종료 | 변경사항 있으면 `auto: YYYY-MM-DD HH:MM by <hostname>` 커밋 + push (없으면 silent) |
| 충돌 발생 시 | hook 은 블로킹 안 함. 사용자가 `cd C:\claude\vault && git status` 로 수동 해결 |

## Troubleshooting

| 증상 | 원인 / 해결 |
|---|---|
| hook 이 안 도는 것 같음 | Claude Code 완전 재시작 또는 `/hooks` 메뉴 한번 열기 (watcher 재로드) |
| pull/push 시 인증 prompt 뜸 | 2단계 인증 설정 재확인. `gh auth login` 또는 Credential Manager 캐시 |
| `bash: command not found` (Windows) | Git Bash 가 PATH 에 없음. Git for Windows 재설치 시 "Use Git from Windows Command Prompt" 옵션 체크 |
| 충돌 알림 떴을 때 | `cd C:\claude\vault && git status` → 어떤 파일 충돌인지 확인 → `git pull` 수동 실행 후 충돌 해결 → 재시작 |
| 양쪽에서 동시에 같은 파일 수정 (드물지만) | 한쪽에서 `git stash` → `git pull` → 변경 다시 적용 → `git push` |

## 참고

- vault 경로는 양쪽 PC 모두 **`C:\claude\vault`** 로 통일 추천 (hook 스크립트 내부에 절대경로 박혀있어서 다른 경로 쓰면 스크립트 수정 필요)
- 이 가이드 파일(`README_집PC_setup.md`) 자체도 vault 에 들어있어서, 회사 PC 에서 갱신하면 집 PC 에 자동 동기화됨
- 모바일에서도 보고 싶으면 vault 를 Obsidian Sync 추가하거나, GitHub Mobile 앱에서 repo 열어 markdown 직접 확인 가능

---

*최초 작성: 2026-05-18 by 회사 PC*
