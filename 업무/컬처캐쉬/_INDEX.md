---
project: 컬처캐쉬
status: 분석완료 / 개발대기
created: 2026-05-18
updated: 2026-05-18
tags:
  - 업무
  - 핑거페이
  - 컬처캐쉬
  - 결제수단
  - 한국문화진흥
---

# 컬처캐쉬 (CURT) 결제수단 추가

> 핑거페이에 컬처캐쉬(한국문화진흥 컬쳐랜드, ID/PW 방식) 결제수단을 신규 추가하는 프로젝트.

## 프로젝트 메타

| 항목 | 값 |
|---|---|
| 대상 시스템 | 핑거페이 FRONT, BLD-v3 |
| 신규 PM_CD | `32` (CULTUREGIFT) |
| 신규 SPM_CD | `07` (CURT) — `SPM_CD_CURT`, `DESC1='CURT'` |
| 신규 PTN_CD | `CULT` |
| 신규 테이블 | `TBAT_CURT` (FRONT), `TBTR_CURT` / `TBUS_CURT` (BLD) |
| 테스트 MID | `100000098m` |
| 테스트 MemberCode | **`MOCKCURT0001`** (MOCK, 컬쳐랜드 가맹점코드 수령 후 UPDATE) |
| DB 방언 | MariaDB / MySQL |
| 취소 정책 | **전체취소 + 망상취소만** (부분취소 미지원) |
| 개발 예상 | 약 **2개월** (1인 단독 기준, 26.5 MD) |
| 진행 모드 | **Mock 우선** — 컬쳐랜드 가맹점코드 수령 전까지 stub 모드로 뒷단 프로세스 우선 개발 |

## 산출물

| 파일 | 설명 | 상태 |
|---|---|---|
| [[2026-05-18_컬처캐쉬_연동_분석보고서_v01.0\|분석 보고서 (.md)]] | CURT 테이블 명세, 컬쳐랜드 ↔ 핑거페이 매핑, 공수 산정, 테스트 환경 구성 | active |
| [가맹점용 연동 가이드 (.docx)](2026-05-18_핑거페이_가맹점연동가이드_컬처캐쉬_v01.0.docx) | 가맹점이 컬처캐쉬 연동 시 참고 | active |
| **[★ DB셋업 SQL v02 (.sql)](2026-05-18_컬처캐쉬_DB셋업_v02.sql)** | **실제 적용용** (MariaDB 방언, MID=100000098m, MOCK MemberCode, CURT 3종 DDL 포함) | **active** |
| [DB셋업 SQL v01 (.sql)](2026-05-18_컬처캐쉬_테스트환경_setup.sql) | (참고) Oracle 방언, demotest0m. v02 으로 대체됨 | superseded |

> 💡 **링크가 안 열리면**: Obsidian 설정 → Files & Links → **"Detect all file extensions"** ON 으로 켜시면 .sql / .docx 도 vault 내부에서 미리보기/네비 가능. (기본 OFF 라 .md 외 파일은 OS 기본 앱으로 열림)

## 처리 흐름 (요약)

```mermaid
sequenceDiagram
    participant 가맹점
    participant FRONT as 핑거페이 FRONT
    participant 컬쳐랜드
    participant BLD as 핑거페이 BLD
    participant 한국문화진흥
    가맹점->>FRONT: ① 결제 요청 (payMethod=CULTURE)
    FRONT->>컬쳐랜드: ② weblogin.do 팝업 호출
    컬쳐랜드-->>FRONT: ③ 인증 결과 (RetVal/HashNo/잔액/사용금액)
    FRONT-->>가맹점: ④ returnUrl 인증결과
    가맹점->>FRONT: ⑤ 승인 요청 (approvalUrl)
    FRONT->>BLD: ⑥ approval 전달
    BLD->>한국문화진흥: ⑦ 8110 승인전문 송신
    한국문화진흥-->>BLD: ⑧ 8120 승인응답
    BLD-->>FRONT: ⑨ 승인 결과
    FRONT-->>가맹점: ⑩ 결과 통보
```

## 일정 (마스터 보고 기준)

| 단계 | 기간 |
|---|---|
| 요구사항 확정 / DDL 검토 | 0.5개월 (2주) |
| FRONT·BLD 개발 / DB 적용 | 1.0개월 (4주) |
| 통합 테스트 (QA) | 0.5개월 (2주) |
| **합계** | **2.0개월 (8주)** |

> ⚠ **리스크**: 컬처캐쉬(한국문화진흥) 측 계약 완료 → 가맹점 키(MemberCode) 발급 후 실연동 테스트 가능. 계약 일정에 따라 추가 지연 가능성.

## 외부 참고 자료 (원본 위치)

- `C:\Users\finger\Downloads\01. 작업\07. 컬처캐시 연동\` (작업 원본 폴더)
- `핑거페이_가맹점연동가이드_인증결제_v0.9.4.docx` (기존 카드 인증결제 가이드, 본 가이드의 기준)
- `FW_ Fwd_ 컬쳐캐시 연동 가이드/컬쳐캐쉬연동 전문 (IDPW 방식)/IDPW방식_결제전문.doc`
- `웹_컬쳐랜드로그인전문.docx`, `모바일웹_컬쳐랜드로그인전문.docx`

## 코드베이스 참조 (작업 원본 기준)

- `front/src/main/java/solpay/wiezon/com/payMethod/service/CultureCashService.java` — step1 일부 구현 완료
- `front/src/main/java/solpay/wiezon/com/common/inf/Constants.java` — `PM_CD_32_CULTURELAND`, `SPM_CD_07_CURT` (신규 추가 필요)
- `front/src/main/resources/templates/culture/common.html` — 컬쳐랜드 로그인 팝업 view (step1 완료)
- `bld-v3/src/main/resources/mapper/card.xml` — 신규 `curt.xml` 작성 시 참조 패턴

## 다음 액션

### Phase 1 — 데이터/스키마 적재 (지금 진행)

- [ ] [[2026-05-18_컬처캐쉬_DB셋업_v02]] 개발 DB 적용 (DDL 3종 + 공통코드 + 가맹점 등록)
- [ ] §④ 검증 쿼리 3개 실행 → 등록 확인
- [ ] DBA 협업 — DDL 자릿수/제약/인덱스 리뷰 후 정정 (필요 시)

### Phase 2 — 소스 수정 (DB 적재 후)

- [ ] FRONT `Constants.java` 에 `SPM_CD_07_CURT = "07"` 상수 추가
- [ ] FRONT `CultureCashService.doStart()` `SPM_CD_01_AUTH` → `SPM_CD_07_CURT` 교체
- [ ] FRONT `CurtMapper.xml` 신설 (TBAT_CURT INSERT/UPDATE/SELECT)
- [ ] FRONT 콜백 컨트롤러 (`/cultureReturn.do`) — **Mock 분기 포함** (MemberCode='MOCKCURT0001' 시 stub 응답)
- [ ] BLD `curt.xml` 신설 (TBTR_CURT/TBUS_CURT INSERT/UPDATE)
- [ ] BLD `CultureCashService` — **Mock 모드** : 8110/8210/8710 송신 대신 가짜 성공 응답 반환
- [ ] BLD `common.xml` saveMstr 등에 PM_CD=32 분기 추가

### Phase 3 — 실연동 (가맹점코드 수령 후)

- [ ] `UPDATE TBSI_PTN_CPID/MBS_PTN_LNK SET PTN_CPID='<실제코드>'`
- [ ] Mock 분기 코드 제거 또는 환경변수로 toggle
- [ ] 통합 테스트 시나리오 T1~T9 실행
- [ ] 운영 배포

## 변경 이력

| 일자 | 버전 | 내용 |
|---|---|---|
| 2026-05-18 | v01.0 | 최초 분석 보고서 / 가이드 / SQL setup 작성. SPM_CD 07(CURT) 신규 정의. 부분취소 미지원 반영. |
| 2026-05-18 | v02 (SQL) | DB 셋업 SQL 재작성 — MariaDB 방언, MID `100000098m`, MOCK MemberCode `MOCKCURT0001`, CURT 3종 DDL 포함. Mock 우선 전략 채택 (가맹점코드 수령 대기). |
