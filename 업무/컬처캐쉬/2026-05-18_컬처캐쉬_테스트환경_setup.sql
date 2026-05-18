-- =================================================================================
--  핑거페이 컬처캐쉬(CURT) 결제수단 테스트 환경 SETUP
--  -----------------------------------------------------------------------
--  대상 DB    : Oracle (MariaDB/MySQL 호환을 위해 SYSDATE → NOW() 로 치환)
--  대상 MID   : demotest0m
--  PM_CD      : 32 (CULTUREGIFT)
--  SPM_CD     : 07 (CURT) — 컬처캐쉬 전용 신규 코드
--               meta_key : SPM_CD_CURT
--               DESC1    : CURT
--  PTN_CD     : CULT
--  MemberCode : TESTCURT0001 (컬쳐랜드 테스트 가맹점 코드)
--  적용 일자  : 2026-05-15 ~ 9999-12-31
--  실행 순서  : ① ~ ⑦  (위에서 아래로 순차 실행)
--  -----------------------------------------------------------------------
--  주의: 운영 환경에는 절대 그대로 적용하지 말 것.
--        실제 컬쳐랜드 가맹점 코드 발급 후 'TESTCURT0001' 을 교체.
-- =================================================================================

SET DEFINE OFF;

-- ---------------------------------------------------------------------------------
--  ① TBAD_CODE — 결제수단 코드 (PM_CD = 32)
-- ---------------------------------------------------------------------------------
INSERT INTO TBAD_CODE
    (COL_NM, CODE1, CODE2, CODE3, CODE4, DESC1, DESC2, DESC3, USE_FLG, REG_DNT, WORKER)
VALUES
    ('PM_CD', '32', NULL, NULL, NULL, '컬처캐쉬', 'CULTUREGIFT', 'CULT', '1', SYSDATE, 'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ② TBAD_CODE — 서브 결제수단 코드 (SPM_CD = 07, 컬처캐쉬 전용 신규)
--    CODE1  : 07           (신규 SPM_CD)
--    CODE2  : 32           (소속 PM_CD)
--    DESC1  : CURT         (식별자)
--    DESC2  : CULTURECASH  (영문명)
--    DESC3  : SPM_CD_CURT  (Constants.java 상수명 / meta_key)
--  ※ Constants.java 에 'String SPM_CD_07_CURT = "07";' 상수 추가 필요.
-- ---------------------------------------------------------------------------------
INSERT INTO TBAD_CODE
    (COL_NM, CODE1, CODE2, CODE3, CODE4, DESC1, DESC2, DESC3, USE_FLG, REG_DNT, WORKER)
VALUES
    ('SPM_CD', '07', '32', NULL, NULL, 'CURT', 'CULTURECASH', 'SPM_CD_CURT', '1', SYSDATE, 'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ③ TBAD_CODE — 파트너 코드 (PTN_CD = CULT)
-- ---------------------------------------------------------------------------------
INSERT INTO TBAD_CODE
    (COL_NM, CODE1, CODE2, CODE3, CODE4, DESC1, DESC2, DESC3, USE_FLG, REG_DNT, WORKER)
VALUES
    ('PTN_CD', 'CULT', '32', '07', NULL, '한국문화진흥', 'CULTURELAND', '컬쳐랜드', '1', SYSDATE, 'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ④ TBAD_CODE — 컬쳐랜드 응답코드 ↔ 핑거페이 결과코드 매핑 (CURT_RSLT_CD)
--    CODE1 : 컬쳐랜드 RetVal
--    CODE2 : 핑거페이 결과코드 (TBTR_MSTR.RSLT_CD 에 매핑)
--    DESC1 : 표시 메시지
--    DESC2 : 분류 (정상/취소/실패)
--  ※ 실제 운영 시 [최신]쇼핑몰에러코드정의.pptx 에서 전수 등재 필요.
-- ---------------------------------------------------------------------------------
INSERT INTO TBAD_CODE (COL_NM, CODE1, CODE2, DESC1, DESC2, USE_FLG, REG_DNT, WORKER)
VALUES ('CURT_RSLT_CD', '0000', '0000', '정상처리',           '정상', '1', SYSDATE, 'SYSTEM');

INSERT INTO TBAD_CODE (COL_NM, CODE1, CODE2, DESC1, DESC2, USE_FLG, REG_DNT, WORKER)
VALUES ('CURT_RSLT_CD', '9999', 'F201', '사용자 인증 취소',   '취소', '1', SYSDATE, 'SYSTEM');

INSERT INTO TBAD_CODE (COL_NM, CODE1, CODE2, DESC1, DESC2, USE_FLG, REG_DNT, WORKER)
VALUES ('CURT_RSLT_CD', '0001', 'F901', '컬쳐랜드 통신 실패', '실패', '1', SYSDATE, 'SYSTEM');

INSERT INTO TBAD_CODE (COL_NM, CODE1, CODE2, DESC1, DESC2, USE_FLG, REG_DNT, WORKER)
VALUES ('CURT_RSLT_CD', '0050', '3081', '잔액 부족',           '실패', '1', SYSDATE, 'SYSTEM');

INSERT INTO TBAD_CODE (COL_NM, CODE1, CODE2, DESC1, DESC2, USE_FLG, REG_DNT, WORKER)
VALUES ('CURT_RSLT_CD', '0099', 'F999', '기타 실패',           '실패', '1', SYSDATE, 'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ⑤ TBSI_PTN_CPID — 파트너 마스터 (컬쳐랜드 MemberCode 단위)
--    PTN_CD       : CULT
--    PTN_CPID     : 컬쳐랜드 MemberCode (12자)
--    DATA(JSON)   : 로그인 URL / Socket 호스트·포트
-- ---------------------------------------------------------------------------------
INSERT INTO TBSI_PTN_CPID
    (PTN_CD, PTN_CPID, PM_CD, SPM_CD, "DESC", DELIMITER, DATA, FR_DT, TO_DT, USE_FLG, REG_DNT, WORKER)
VALUES
    ('CULT',
     'TESTCURT0001',
     '32',
     '07',
     '컬쳐랜드 테스트 가맹점',
     '|',
     '{"loginUrlPc":"https://tculture.cultureland.co.kr/CashPay/weblogin.do","loginUrlMo":"https://tculture.cultureland.co.kr/popup/mobilelogin/mobilelogin.do","sockHost":"1.235.208.9","sockPort":"5949"}',
     '20260101',
     '99991231',
     '1',
     SYSDATE,
     'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ⑥ TBSI_MBS_PTN_LNK — 가맹점 ↔ 컬쳐랜드 MemberCode 매핑
--    가맹점(demotest0m) 이 사용할 컬쳐랜드 코드(TESTCURT0001) 연결.
-- ---------------------------------------------------------------------------------
INSERT INTO TBSI_MBS_PTN_LNK
    (MID, PM_CD, SPM_CD, PTN_CD, PTN_CPID, FR_DT, TO_DT, USE_FLG, REG_DNT, WORKER)
VALUES
    ('demotest0m',
     '32',
     '07',
     'CULT',
     'TESTCURT0001',
     '20260101',
     '99991231',
     '1',
     SYSDATE,
     'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ⑦ TBSI_MBS_SVC — 가맹점 결제수단 활성화
--    가맹점 demotest0m 에 대해 PM_CD=32 결제수단을 사용 가능하도록 등록.
-- ---------------------------------------------------------------------------------
INSERT INTO TBSI_MBS_SVC
    (MID, PM_CD, SPM_CD, USE_FLG, USE_DT, APP_VAN1_CD, APP_VAN2_CD, REG_DNT, WORKER)
VALUES
    ('demotest0m',
     '32',
     '07',
     '1',
     '99999999',
     NULL,
     NULL,
     SYSDATE,
     'SYSTEM');


-- ---------------------------------------------------------------------------------
--  ⑧ TBSI_STMT_CYCLE — 정산주기 (옵션)
--  ※ 정산을 사용하지 않으면 본 INSERT 는 스킵.
-- ---------------------------------------------------------------------------------
-- INSERT INTO TBSI_STMT_CYCLE
--     (MID, PM_CD, SPM_CD, STMT_CYCLE_CD, FR_DT, TO_DT, USE_FLG, REG_DNT, WORKER)
-- VALUES
--     ('demotest0m', '32', '07', 'D01', '20260101', '99991231', '1', SYSDATE, 'SYSTEM');


COMMIT;


-- =================================================================================
--  검증 쿼리 — 위 등록이 모두 잘 들어갔는지 확인.
-- =================================================================================
SELECT  s.MID,
        s.PM_CD,
        s.SPM_CD,
        l.PTN_CD,
        l.PTN_CPID                  AS MBR_CD,
        c.DESC1                     AS PM_NM,
        p."DESC"                    AS PTN_NM,
        s.USE_FLG                   AS SVC_USE,
        l.FR_DT,
        l.TO_DT
  FROM  TBSI_MBS_SVC      s
  LEFT  JOIN TBSI_MBS_PTN_LNK l ON s.MID = l.MID  AND s.PM_CD = l.PM_CD AND s.SPM_CD = l.SPM_CD
  LEFT  JOIN TBSI_PTN_CPID    p ON l.PTN_CD = p.PTN_CD AND l.PTN_CPID = p.PTN_CPID
  LEFT  JOIN TBAD_CODE        c ON c.COL_NM = 'PM_CD' AND c.CODE1 = s.PM_CD
 WHERE  s.MID     = 'demotest0m'
   AND  s.PM_CD   = '32'
   AND  s.USE_FLG = '1';
-- 기대 결과:
--   MID=demotest0m  PM_CD=32  SPM_CD=07  PTN_CD=CULT  MBR_CD=TESTCURT0001
--   PM_NM=컬처캐쉬  PTN_NM='컬쳐랜드 테스트 가맹점'  SVC_USE=1


-- =================================================================================
--  ROLLBACK 스크립트 (테스트 환경 정리)
--  -----------------------------------------------------------------------
--  필요 시 아래 DELETE 문을 순서대로 실행 (역순).
-- =================================================================================
-- DELETE FROM TBSI_STMT_CYCLE   WHERE MID='demotest0m' AND PM_CD='32' AND SPM_CD='07';
-- DELETE FROM TBSI_MBS_SVC      WHERE MID='demotest0m' AND PM_CD='32' AND SPM_CD='07';
-- DELETE FROM TBSI_MBS_PTN_LNK  WHERE MID='demotest0m' AND PM_CD='32' AND SPM_CD='07' AND PTN_CD='CULT';
-- DELETE FROM TBSI_PTN_CPID     WHERE PTN_CD='CULT' AND PTN_CPID='TESTCURT0001';
-- DELETE FROM TBAD_CODE         WHERE COL_NM='CURT_RSLT_CD';
-- DELETE FROM TBAD_CODE         WHERE COL_NM='PTN_CD' AND CODE1='CULT';
-- DELETE FROM TBAD_CODE         WHERE COL_NM='SPM_CD' AND CODE1='07' AND CODE2='32';
-- DELETE FROM TBAD_CODE         WHERE COL_NM='PM_CD'  AND CODE1='32';
-- COMMIT;