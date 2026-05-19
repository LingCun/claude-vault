-- =============================================================================
--  핑거페이 컬처캐쉬 결제수단 DB 셋업 스크립트 v03
--  (DROP + DELETE 후 재생성 — 깨끗한 재시작용)
-- =============================================================================
--  대상 DB     : MariaDB / MySQL
--  테스트 MID  : 100000098m
--  PM_CD       : 32 (META_KEY='CULTURE')
--  SPM_CD      : 07 (META_KEY='SPM_CD_CULTURE', DESC1='CULTURE')
--  PTN_CD      : 'CULT'                     ★ TBAD_CODE.PTN_CD 컬럼이 4자 제한이라 CULT 사용
--  MemberCode  : 'MOCKCULTURE1' (12자, MOCK)
--
--  ※ 이 스크립트는 v02 (CURT 명명) / 이전 v03 (CULTURE 시도) 어느 쪽이 적용되어 있어도
--    모두 깨끗이 제거 후 새로 셋업하도록 작성되었음. (구 객체 존재 여부에 무관하게 idempotent)
--
--  실행 순서:
--    §① TEARDOWN  — 구 객체/데이터 제거 (CURT + CULTURE 양쪽 다 정리)
--    §② DDL       — CULTURE 3종 테이블 생성
--    §③ 공통코드  — TBAD_CODE 등재
--    §④ 가맹점    — TBSI_PTN_CPID / TBSI_MBS_PTN_LNK / TBSI_MBS_SVC 등재
--    §⑤ 검증      — 결과 확인 쿼리
-- =============================================================================


-- =============================================================================
--  §① TEARDOWN — 구 객체/데이터 모두 제거
-- =============================================================================

-- 1-1) 가맹점 결제수단 활성화 해제 (MID=100000098m, PM_CD=32)
DELETE FROM TBSI_MBS_SVC
 WHERE MID    = '100000098m'
   AND PM_CD  = '32'
   AND SPM_CD = '07';

-- 1-2) 가맹점 ↔ 파트너 매핑 해제 (CURT / CULTURE 양쪽 다)
DELETE FROM TBSI_MBS_PTN_LNK
 WHERE MID    = '100000098m'
   AND PM_CD  = '32'
   AND SPM_CD = '07'
   AND PTN_CD IN ('CULT', 'CULTURE');

-- 1-3) 파트너 마스터 제거 (MOCK 값 양쪽 다)
DELETE FROM TBSI_PTN_CPID
 WHERE PTN_CD   IN ('CULT', 'CULTURE')
   AND PTN_CPID IN ('MOCKCURT0001', 'MOCKCULTURE1');

-- 1-4) 공통코드 — 컬쳐랜드 응답코드 매핑 (RSLT_CD/32) 5건 제거
DELETE FROM TBAD_CODE
 WHERE COL_NM = 'RSLT_CD'
   AND CODE1  = '32';

-- 1-5) 공통코드 — SPM_CD=07 (CURT/CULTURE) 제거
DELETE FROM TBAD_CODE
 WHERE COL_NM = 'SPM_CD'
   AND CODE1  = '07';

-- 1-6) PM_CD=32 META_KEY 원복 (PM_CD/32 row 는 기존 등재이므로 DELETE 금지 → META_KEY 만 NULL 로)
UPDATE TBAD_CODE
   SET META_KEY = NULL
 WHERE COL_NM = 'PM_CD'
   AND CODE1  = '32';

-- 1-7) 거래 테이블 DROP (CURT + CULTURE 양쪽 다 — 존재하면 제거)
DROP TABLE IF EXISTS TBUS_CULTURE;
DROP TABLE IF EXISTS TBTR_CULTURE;
DROP TABLE IF EXISTS TBAT_CULTURE;

DROP TABLE IF EXISTS TBUS_CURT;
DROP TABLE IF EXISTS TBTR_CURT;
DROP TABLE IF EXISTS TBAT_CURT;

COMMIT;


-- =============================================================================
--  §② CULTURE 신규 테이블 DDL (3종)
-- =============================================================================

-- -----------------------------------------------------------------------------
--  2-1) TBAT_CULTURE  (FRONT - 컬쳐랜드 로그인 인증 결과)
--       대응: TBAT_AUTH (카드 3D 인증)
-- -----------------------------------------------------------------------------
CREATE TABLE TBAT_CULTURE (
    TID             VARCHAR(30)     NOT NULL                  COMMENT '거래ID',
    MID             VARCHAR(10)     NOT NULL                  COMMENT '가맹점ID',
    NONCE           VARCHAR(30)     NOT NULL                  COMMENT '논스(난수)',
    CP_CD           VARCHAR(10)                               COMMENT '결제사코드',
    PTN_CD          VARCHAR(10)                               COMMENT '파트너코드',
    VAN_CD          VARCHAR(10)                               COMMENT 'VAN사코드',

    -- 컬쳐랜드 로그인 호출 파라미터 (FRONT → 컬쳐랜드 송신)
    MBR_CD          VARCHAR(12)     NOT NULL                  COMMENT '회원사코드',
    LOGIN_DT        VARCHAR(8)                                COMMENT '로그인일자',
    LOGIN_TM        VARCHAR(6)                                COMMENT '로그인시간',
    LOGIN_HASH_CD   VARCHAR(32)                               COMMENT '로그인해시코드',
    RETURN_URL      VARCHAR(500)                              COMMENT '반환URL',
    USER_IP         VARCHAR(40)                               COMMENT '사용자IP',
    REQ_AMT         DECIMAL(15,0)                             COMMENT '요청금액',

    -- 컬쳐랜드 로그인 콜백 응답
    AUTH_RSLT_CD    VARCHAR(4)                                COMMENT '인증결과코드',
    CULTURE_USER_ID VARCHAR(12)                               COMMENT '컬쳐랜드사용자ID',
    CULTURE_CUST_ID VARCHAR(8)                                COMMENT '컬쳐랜드고객키',
    HASH_NO         VARCHAR(25)                               COMMENT '결제인증키',
    MCASH_AMT       DECIMAL(15,0)                             COMMENT '컬처캐쉬잔액',
    USE_AMT         DECIMAL(15,0)                             COMMENT '사용금액',

    -- 핑거페이 공통
    CRYPT_FLG       VARCHAR(1)      DEFAULT 'N'               COMMENT '암호화여부',
    WORKER          VARCHAR(20)                               COMMENT '작업자',
    REG_DNT         DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',

    PRIMARY KEY (TID),
    INDEX IX_TBAT_CULTURE_01 (NONCE),
    INDEX IX_TBAT_CULTURE_02 (MID, REG_DNT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='컬쳐랜드 로그인 인증 결과 (FRONT)';


-- -----------------------------------------------------------------------------
--  2-2) TBTR_CULTURE  (BLD - 컬처캐쉬 거래 원장)
--       대응: TBTR_CARD (카드 거래 원장)
-- -----------------------------------------------------------------------------
CREATE TABLE TBTR_CULTURE (
    TID             VARCHAR(30)     NOT NULL                  COMMENT '거래ID',
    TR_DT           VARCHAR(8)                                COMMENT '거래일자',
    TRX_ST_CD       VARCHAR(1)                                COMMENT '거래상태코드',

    -- 핑거페이 공통 / VAN
    PTN_CD          VARCHAR(10)                               COMMENT '파트너코드',
    VAN_CD          VARCHAR(10)                               COMMENT 'VAN사코드',
    EDI_NO          VARCHAR(20)                               COMMENT 'EDI번호',
    APP_NO          VARCHAR(20)                               COMMENT '승인번호',
    APP_AMT         DECIMAL(15,0)                             COMMENT '승인금액',
    AUTH_TYPE_CD    VARCHAR(2)                                COMMENT '인증방식코드',

    -- 컬쳐랜드 8110/8120 매핑
    MBR_CD          VARCHAR(12)                               COMMENT '회원사코드',
    MBR_CTRL_CD     VARCHAR(25)                               COMMENT '회원사거래번호',
    CTRL_CD         VARCHAR(20)                               COMMENT '컬쳐랜드거래번호',
    CULTURE_USER_ID VARCHAR(12)                               COMMENT '컬쳐랜드사용자ID',
    CULTURE_CUST_ID VARCHAR(8)                                COMMENT '컬쳐랜드고객키',
    HASH_NO         VARCHAR(25)                               COMMENT '결제인증키',
    LEVY_DT         VARCHAR(8)                                COMMENT '부과일자',
    LEVY_TM         VARCHAR(6)                                COMMENT '부과시간',
    LEVY_AMT        DECIMAL(9,0)                              COMMENT '부과금액',
    LEVY_UNIT       VARCHAR(4)                                COMMENT '부과단위',
    CTNT_CD         VARCHAR(15)                               COMMENT '컨텐츠코드',
    CTNT_NM         VARCHAR(30)                               COMMENT '컨텐츠명',
    GENRE_CD        VARCHAR(2)                                COMMENT '장르코드',
    GENRE_DTL_CD    VARCHAR(3)                                COMMENT '장르상세코드',
    PAY_TYPE        VARCHAR(2)                                COMMENT '결제유형',

    -- 도서공연 (현금영수증)
    BUY_BOOK_FLG    VARCHAR(1)      DEFAULT 'N'               COMMENT '도서공연구매여부',
    BOOK_AMT        DECIMAL(9,0)    DEFAULT 0                 COMMENT '도서공연금액',
    SHOP_AMT        DECIMAL(9,0)    DEFAULT 0                 COMMENT '일반쇼핑금액',

    -- 결제 후 잔액 (참고)
    MCASH_AMT       DECIMAL(15,0)                             COMMENT '컬처캐쉬잔액',

    -- 핑거페이 공통
    CRYPT_FLG       VARCHAR(1)      DEFAULT 'N'               COMMENT '암호화여부',
    WORKER          VARCHAR(20)                               COMMENT '작업자',
    REG_DNT         DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',

    PRIMARY KEY (TID),
    INDEX IX_TBTR_CULTURE_01 (CTRL_CD),
    INDEX IX_TBTR_CULTURE_02 (MBR_CTRL_CD),
    INDEX IX_TBTR_CULTURE_03 (TR_DT, MBR_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='컬처캐쉬 거래 원장 (BLD)';


-- -----------------------------------------------------------------------------
--  2-3) TBUS_CULTURE  (BLD - 컬처캐쉬 실패 원장)
--       대응: TBUS_CARD (카드 실패 원장)
-- -----------------------------------------------------------------------------
CREATE TABLE TBUS_CULTURE (
    LOG_ID            BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '로그ID',
    TID               VARCHAR(30)     NOT NULL                    COMMENT '거래ID',

    -- 핑거페이 공통 / VAN
    PTN_CD            VARCHAR(10)                                 COMMENT '파트너코드',
    VAN_CD            VARCHAR(10)                                 COMMENT 'VAN사코드',
    EDI_NO            VARCHAR(20)                                 COMMENT 'EDI번호',
    AUTH_TYPE_CD      VARCHAR(2)                                  COMMENT '인증방식코드',

    -- 컬쳐랜드 송신 정보 (실패한 8110/8210/8710 송신값)
    MBR_CD            VARCHAR(12)                                 COMMENT '회원사코드',
    MBR_CTRL_CD       VARCHAR(25)                                 COMMENT '회원사거래번호',
    LEVY_AMT          DECIMAL(9,0)                                COMMENT '부과금액',
    BUY_BOOK_FLG      VARCHAR(1)                                  COMMENT '도서공연구매여부',
    BOOK_AMT          DECIMAL(9,0)                                COMMENT '도서공연금액',
    SHOP_AMT          DECIMAL(9,0)                                COMMENT '일반쇼핑금액',

    -- 컬쳐랜드 응답 실패 정보
    CULTURE_RSLT_CD   VARCHAR(4)                                  COMMENT '컬쳐랜드결과코드',
    CULTURE_RSLT_MSG  VARCHAR(100)                                COMMENT '컬쳐랜드결과메시지',

    -- 핑거페이 공통
    CRYPT_FLG         VARCHAR(1)      DEFAULT 'N'                 COMMENT '암호화여부',
    WORKER            VARCHAR(20)                                 COMMENT '작업자',
    REG_DNT           DATETIME        DEFAULT CURRENT_TIMESTAMP   COMMENT '등록일시',

    PRIMARY KEY (LOG_ID),
    INDEX IX_TBUS_CULTURE_01 (TID),
    INDEX IX_TBUS_CULTURE_02 (REG_DNT),
    INDEX IX_TBUS_CULTURE_03 (CULTURE_RSLT_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='컬처캐쉬 실패 원장 (BLD)';


-- =============================================================================
--  §③ 공통 코드 등재 (TBAD_CODE)
-- =============================================================================

-- 3-1) PM_CD = 32 (컬처캐쉬) — 기존 등재 row 의 META_KEY 만 갱신
UPDATE TBAD_CODE
   SET META_KEY = 'CULTURE'
     , USE_FLG  = '1'
 WHERE COL_NM = 'PM_CD'
   AND CODE1  = '32';

-- 3-2) SPM_CD = 07 (CULTURE) ★ 신규
INSERT INTO TBAD_CODE
    (COL_NM,   CODE1, CODE2, CODE3, CODE4, META_KEY,          DESC1,     DESC2, DESC3, DESC4, ORDER_NO, USE_FLG, REG_DNT,                       WORKER)
VALUES
    ('SPM_CD', '07',  '*',   '*',   '*',   'SPM_CD_CULTURE',  'CULTURE', 'N',   'N',   'N',   '0',      '1',     DATE_FORMAT(NOW(), '%Y%m%d'),  'admin');

-- 3-3) 컬쳐랜드 응답코드 ↔ 핑거페이 결과코드 매핑 (RSLT_CD)
INSERT INTO TBAD_CODE (COL_NM,    CODE1, CODE2,  DESC1,                  DESC2,               USE_FLG, REG_DNT,                       WORKER)
VALUES
    ('RSLT_CD', '32', '0000', '정상처리',           '문화상품권 메시지', '1', DATE_FORMAT(NOW(), '%Y%m%d'),  'admin'),
    ('RSLT_CD', '32', 'F201', '사용자 인증 취소',   '문화상품권 메시지', '1', DATE_FORMAT(NOW(), '%Y%m%d'),  'admin'),
    ('RSLT_CD', '32', 'F901', '컬쳐랜드 통신 실패', '문화상품권 메시지', '1', DATE_FORMAT(NOW(), '%Y%m%d'),  'admin'),
    ('RSLT_CD', '32', '3081', '잔액 부족',           '문화상품권 메시지', '1', DATE_FORMAT(NOW(), '%Y%m%d'),  'admin'),
    ('RSLT_CD', '32', 'F999', '기타 실패',           '문화상품권 메시지', '1', DATE_FORMAT(NOW(), '%Y%m%d'),  'admin');


-- =============================================================================
--  §④ 파트너 마스터 + 가맹점 매핑 + 결제수단 활성화
-- =============================================================================

-- 4-1) TBSI_PTN_CPID — 파트너 마스터 (컬쳐랜드 가맹점 정보, MOCK)
INSERT INTO TBSI_PTN_CPID
    (PTN_CD,    PTN_TYPE, PTN_CPID,        SVC_TYPE, PM_CD, SPM_CD, CP_CD, `DESC`,                                                  DELIMITER, DATA,
     FR_DT,      TO_DT,     REG_DNT,                       WORKER)
VALUES
    ('CULT',
     '00',
     'MOCKCULTURE1',
     '00',
     '32',
     '07',
     '00',
     '컬쳐랜드 테스트 가맹점 (MOCK - 가맹점코드 수령 대기)',
     '|',
     '{"loginUrlPc":"https://tculture.cultureland.co.kr/CashPay/weblogin.do","loginUrlMo":"https://tculture.cultureland.co.kr/popup/mobilelogin/mobilelogin.do","sockHost":"1.235.208.9","sockPort":"5949","mockMode":true}',
     '20260101',
     '99991231',
     DATE_FORMAT(NOW(), '%Y%m%d'),  'admin');

-- 4-2) TBSI_MBS_PTN_LNK — 가맹점 ↔ 컬쳐랜드 MemberCode 매핑
INSERT INTO TBSI_MBS_PTN_LNK
    (MID,           PM_CD, SPM_CD, PTN_CD,    PTN_CPID,        FR_DT,      TO_DT,        REG_DNT,                       WORKER)
VALUES
    ('100000098m', '32',  '07',   'CULT',    'MOCKCULTURE1',  '20260101', '99991231',   DATE_FORMAT(NOW(), '%Y%m%d'),  'admin');

-- 4-3) TBSI_MBS_SVC — 가맹점 결제수단 활성화
INSERT INTO TBSI_MBS_SVC
    (MID,           PM_CD, SPM_CD, USE_FLG, USE_DT,     APP_VAN1_CD, APP_VAN2_CD, REG_DNT,                       WORKER)
VALUES
    ('100000098m', '32',  '07',   '1',     '20260410', NULL,        NULL,        DATE_FORMAT(NOW(), '%Y%m%d'),  'admin');

COMMIT;


-- =============================================================================
--  §⑤ 검증 쿼리
-- =============================================================================

-- 5-1) 구 객체 잔존 확인 (없어야 정상)
SHOW TABLES LIKE 'TB%CURT';
-- 기대: 0 rows

-- 5-2) 신규 테이블 3종 생성 확인
SHOW TABLES LIKE 'TB%CULTURE';
-- 기대: TBAT_CULTURE, TBTR_CULTURE, TBUS_CULTURE 3 rows

-- 5-3) 공통코드 등재 확인
SELECT COL_NM, CODE1, CODE2, META_KEY, DESC1, DESC2, USE_FLG
  FROM TBAD_CODE
 WHERE (COL_NM = 'PM_CD'   AND CODE1 = '32')                  -- META_KEY='CULTURE'
    OR (COL_NM = 'SPM_CD'  AND CODE1 = '07')                  -- META_KEY='SPM_CD_CULTURE', DESC1='CULTURE'
    OR (COL_NM = 'RSLT_CD' AND CODE1 = '32')                  -- 5건
 ORDER BY COL_NM, CODE1, CODE2;
-- 기대: 총 7 rows

-- 5-4) 가맹점 컬처캐쉬 등록 종합 조회
SELECT  s.MID,
        s.PM_CD,
        s.SPM_CD,
        l.PTN_CD,
        l.PTN_CPID                  AS MBR_CD,
        c.DESC1                     AS PM_NM,
        p.`DESC`                    AS PTN_DESC,
        s.USE_FLG                   AS SVC_USE,
        l.FR_DT,
        l.TO_DT
  FROM  TBSI_MBS_SVC      s
  LEFT  JOIN TBSI_MBS_PTN_LNK l ON s.MID = l.MID  AND s.PM_CD = l.PM_CD AND s.SPM_CD = l.SPM_CD
  LEFT  JOIN TBSI_PTN_CPID    p ON l.PTN_CD = p.PTN_CD AND l.PTN_CPID = p.PTN_CPID
  LEFT  JOIN TBAD_CODE        c ON c.COL_NM = 'PM_CD' AND c.CODE1 = s.PM_CD
 WHERE  s.MID     = '100000098m'
   AND  s.PM_CD   = '32'
   AND  s.USE_FLG = '1';
-- 기대: 1 row
--   MID=100000098m  PM_CD=32  SPM_CD=07  PTN_CD=CULT  MBR_CD=MOCKCULTURE1
--   PTN_DESC='컬쳐랜드 테스트 가맹점 (MOCK - 가맹점코드 수령 대기)'  SVC_USE=1
