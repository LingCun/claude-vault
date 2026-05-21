-- =============================================================================
--  핑거페이 컬처캐쉬 — CULTURE_RSLT_CD 공통코드 등재 (v03 보조 패치)
--  생성일: 2026-05-21
-- =============================================================================
--  배경:
--    NICEPG 와 동일한 패턴으로 PG 자체 응답코드를 TBAD_CODE 에 등재
--    NICEPG: COL_NM='NICEPG_RSLT_CD'  (CODE1=결제수단, CODE3=PG코드, CODE4=내부매핑)
--    CULTURE: COL_NM='CULTURE_RSLT_CD' (CODE1=거래구분, CODE3=컬쳐랜드RetVal, CODE4=내부매핑)
--
--  CODE1 (거래 구분):
--    01 = 로그인 인증 (weblogin/mobilelogin 응답)
--    02 = 결제 승인  (8110/8120 응답)
--    03 = 취소       (8210/8220 응답)
--    04 = 부분취소   (부분취소 응답)
--
--  CODE4 (내부 RSLT_CD/32 매핑):
--    0000 = 정상
--    F201 = 사용자 인증 취소
--    F901 = 컬쳐랜드 통신 실패
--    3081 = 잔액 부족
--    F999 = 기타 실패
--
--  출처: [최신]쇼핑몰에러코드정의.pptx (CI 방식, 6 slides)
-- =============================================================================


-- §① TEARDOWN — 기존 CULTURE_RSLT_CD 모두 제거 (idempotent)
DELETE FROM TBAD_CODE
 WHERE COL_NM = 'CULTURE_RSLT_CD';


-- =============================================================================
--  §② INSERT — CULTURE_RSLT_CD 전수 등재
-- =============================================================================

-- 2-1) CODE1='01' 로그인 인증 응답 (slide 1)
INSERT INTO TBAD_CODE
    (COL_NM,            CODE1, CODE2, CODE3,  CODE4,  META_KEY, DESC1,                                                                              DESC2,            DESC3, DESC4, ORDER_NO, USE_FLG, WORKER,  REG_DNT,                       UPD_DNT)
VALUES
    ('CULTURE_RSLT_CD', '01',  '*',   '0000', '0000', NULL,     '정상 로그인 인증',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0450', 'F999', NULL,     'ID 또는 비밀번호를 잘못 입력하셨습니다.',                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0451', 'F999', NULL,     '사용 정지된 가맹점입니다. 문의:1577-2111',                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0452', 'F999', NULL,     '사용 제한된 IP. 문의:1577-2111',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0453', 'F999', NULL,     '불량회원으로 등록된 아이디 입니다.',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0454', 'F999', NULL,     '컬쳐랜드 정책에 따른 제한사항 발생, 고객센터문의:1577-2111',                       '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0455', 'F999', NULL,     '전문 변수중 필수값이 누락되었습니다.',                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0456', 'F999', NULL,     '컬쳐랜드 로그인(본인인증) 후 사용가능',                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0457', 'F999', NULL,     '컬쳐랜드 로그인(캠페인) 후 사용가능',                                               '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0458', 'F999', NULL,     '제한 정책에 따른 제한. 잠시후 이용하여 주십시오.',                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0459', 'F999', NULL,     '대량 로그인 시도로 인한 IP 제한 발생.',                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0460', 'F999', NULL,     'IP당 로그인 ID 갯수 초과',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0461', 'F999', NULL,     '컬쳐랜드 간편회원 사용불가 가맹점. 일반회원(본인인증) 전환 후 결제 가능합니다.',    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0462', 'F901', NULL,     'DB 입력 및 조회 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0463', 'F901', NULL,     '서비스 점검중 입니다.',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0464', 'F999', NULL,     'OTP 번호를 잘못 입력하셨습니다.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0467', 'F999', NULL,     '장기 미로그인 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0480', 'F999', NULL,     '고객확인 대상 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0481', 'F999', NULL,     '필수 파라미터 값이 누락되었습니다.',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0482', 'F999', NULL,     '회원 정보가 존재하지 않습니다.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0483', 'F999', NULL,     '고객확인 대상 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0484', 'F999', NULL,     '고객확인 대상 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0485', 'F999', NULL,     '고객확인 대상 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0486', 'F999', NULL,     '내부 심사 대상 계정, 컬쳐랜드 심사 완료 후 이용 가능',                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0488', 'F999', NULL,     '고객확인 대상 계정, 컬쳐랜드 인증 후 이용 가능',                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0489', 'F999', NULL,     '로그인 오류가 발생하였습니다. 문의:1577-2111',                                       '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0492', 'F999', NULL,     '5회 초과 실패 시 비밀번호 변경 필요',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0493', 'F999', NULL,     '5회 초과 실패, 비밀번호 변경 필요',                                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0499', 'F999', NULL,     'ID 또는 비밀번호를 잘못 입력하셨습니다.',                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0801', 'F901', NULL,     '요청전문 형식오류',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '01',  '*',   '0802', 'F901', NULL,     '로그인 중 Com 에러',                                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW());


-- 2-2) CODE1='02' 결제 승인 응답 (slides 2, 3)
INSERT INTO TBAD_CODE
    (COL_NM,            CODE1, CODE2, CODE3,  CODE4,  META_KEY, DESC1,                                                                              DESC2,            DESC3, DESC4, ORDER_NO, USE_FLG, WORKER,  REG_DNT,                       UPD_DNT)
VALUES
    ('CULTURE_RSLT_CD', '02',  '*',   '0000', '0000', NULL,     '정상 결제 승인',                                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0400', 'F999', NULL,     '고객정보가 일치하지 않습니다.',                                                      '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0401', 'F999', NULL,     '원장 없음',                                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0402', '3081', NULL,     '잔액 모자람',                                                                        '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0403', 'F999', NULL,     '원장 잔액수정중 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0404', 'F999', NULL,     '거래 내역생성중 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0405', 'F999', NULL,     '원장생성중 에러',                                                                   '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0406', 'F999', NULL,     '사용 정지된 가맹점입니다. 문의:1577-2111',                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0407', 'F999', NULL,     '전문 변수중 필수값이 누락되었습니다.',                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0408', '3081', NULL,     '사용요청금액이 잘못 입력되었습니다.',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0409', 'F999', NULL,     '컬쳐랜드 간편회원 사용불가 가맹점. 일반회원 전환 후 결제 가능.',                   '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0410', 'F999', NULL,     '잘못된 GENRE 값 입니다. 컬쳐랜드에 문의해 주세요.',                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0411', 'F999', NULL,     '쇼핑 사용이 제한된 가맹점 입니다. 문의:1577-2111',                                   '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0412', 'F999', NULL,     '사용승인 내역작성중 에러',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0413', '3081', NULL,     '일 사용금액 초과로 제한됨',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0414', '3081', NULL,     '월 사용금액 초과로 제한됨',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0415', 'F999', NULL,     '잘못된 결제인증번호 에러',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0416', 'F999', NULL,     '인증번호의 고객키 에러',                                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0417', 'F901', NULL,     'DB 입력 및 조회 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0418', 'F901', NULL,     '서비스 점검중 입니다.',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0419', 'F999', NULL,     '불량회원으로 등록된 아이디 입니다.',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0420', 'F999', NULL,     '사용이 제한된 아이디 입니다. 문의:1577-2111',                                        '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0421', 'F999', NULL,     '기타 에러',                                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0422', 'F999', NULL,     '중복 거래요청',                                                                      '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0431', 'F999', NULL,     '결제 실패. 잠시후 사용해주세요.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0432', 'F999', NULL,     '등록되지 않은 상품권. 다시 입력하세요.',                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0433', 'F999', NULL,     '이미 사용된 상품권 번호 입니다.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0434', 'F999', NULL,     '결제 실패. 잠시후 사용해주세요.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0435', 'F999', NULL,     '결제 실패. 잠시후 사용해주세요.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0436', 'F999', NULL,     '결제 실패. 잠시후 사용해주세요.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0437', 'F999', NULL,     '상품권 사용처가 아닙니다. 문의 1577-2111',                                           '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0439', 'F999', NULL,     '1일 상품권 10회 등록실패. 문의 1577-2111',                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0443', 'F999', NULL,     '이미 사용된 상품권 번호 입니다.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0444', 'F999', NULL,     '사용할 수 없는 상품권 입니다.',                                                      '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0477', 'F999', NULL,     '결제 실패. 잠시후 사용해주세요.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0480', 'F201', NULL,     '컬쳐랜드 푸시 로그인 승인후 사용가능',                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0481', 'F201', NULL,     '컬쳐랜드 푸시 로그인 승인후 사용가능',                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0498', 'F999', NULL,     '1인당 충전제한된 상품권. 문의 1577-2111',                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0499', 'F999', NULL,     '필수 값 누락',                                                                       '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0801', 'F901', NULL,     '요청전문 형식오류',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '02',  '*',   '0802', 'F901', NULL,     '사용요청 중 Com 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW());


-- 2-3) CODE1='03' 취소 응답 (slide 4)
INSERT INTO TBAD_CODE
    (COL_NM,            CODE1, CODE2, CODE3,  CODE4,  META_KEY, DESC1,                                                                              DESC2,            DESC3, DESC4, ORDER_NO, USE_FLG, WORKER,  REG_DNT,                       UPD_DNT)
VALUES
    ('CULTURE_RSLT_CD', '03',  '*',   '0000', '0000', NULL,     '정상 취소',                                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0471', 'F999', NULL,     '정상 승인내역이 존재하지 않습니다.',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0472', 'F999', NULL,     '전문 변수중 필수값이 누락되었습니다.',                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0473', 'F901', NULL,     '서비스 점검중 입니다.',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0474', 'F999', NULL,     '사용 정지된 가맹점입니다. 문의:1577-2111',                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0475', 'F999', NULL,     '취소 불가 거래건 입니다.',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0476', 'F999', NULL,     '취소 내역 수정 중 에러',                                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0477', 'F999', NULL,     '원장 잔액수정중 에러',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0478', '3081', NULL,     '취소 요청금액이 잘못되었습니다.',                                                    '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0479', 'F999', NULL,     '업체거래번호 중복으로 인한 취소불가',                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0480', 'F999', NULL,     '기타 에러',                                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0481', 'F999', NULL,     '이미 취소된 거래건 입니다.',                                                        '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0801', 'F901', NULL,     '요청전문 형식오류',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '03',  '*',   '0802', 'F901', NULL,     '취소 중 Com 에러',                                                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW());


-- 2-4) CODE1='04' 부분취소 응답 (slides 5, 6)
INSERT INTO TBAD_CODE
    (COL_NM,            CODE1, CODE2, CODE3,  CODE4,  META_KEY, DESC1,                                                                              DESC2,            DESC3, DESC4, ORDER_NO, USE_FLG, WORKER,  REG_DNT,                       UPD_DNT)
VALUES
    ('CULTURE_RSLT_CD', '04',  '*',   '0000', '0000', NULL,     '정상 부분취소',                                                                      '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0400', 'F999', NULL,     '고객정보가 일치하지 않음',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0401', 'F999', NULL,     '캐쉬원장 없음 에러',                                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0403', 'F999', NULL,     '캐쉬원장 수정 중 에러',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0404', 'F999', NULL,     '거래내역 작성 중 에러',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0407', 'F999', NULL,     '요청 값 확인 필요',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0413', '3081', NULL,     '일한도 금액 확인 필요',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0414', '3081', NULL,     '월한도 금액 확인 필요',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0418', 'F999', NULL,     '요청날짜 확인 필요',                                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0421', 'F999', NULL,     '사용내역 수정 중 에러',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0422', 'F999', NULL,     '취소내역 작성 중 에러',                                                             '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0424', 'F999', NULL,     '결제 취소 중 에러',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0425', 'F999', NULL,     '취소금액 0원 이하인 경우',                                                          '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0426', 'F999', NULL,     '잘못된 거래번호 (없는 거래건)',                                                      '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0427', 'F999', NULL,     '이미 취소된 경우',                                                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0471', 'F999', NULL,     '이미 취소된 경우',                                                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0473', 'F999', NULL,     '요청 날짜 확인 필요',                                                               '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0474', 'F999', NULL,     '가맹점코드 확인 필요',                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0476', 'F999', NULL,     '회원정보 확인 필요',                                                                '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0478', '3081', NULL,     '취소요청금액 확인 필요',                                                            '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0499', 'F999', NULL,     '기타',                                                                              '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0801', 'F901', NULL,     '요청전문 형식오류',                                                                 '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW()),
    ('CULTURE_RSLT_CD', '04',  '*',   '0802', 'F901', NULL,     '취소 중 Com 에러',                                                                  '컬쳐랜드응답코드','32',  'N',   0,        '1',     'admin', DATE_FORMAT(NOW(), '%Y%m%d'),  NOW());

COMMIT;


-- =============================================================================
--  §③ 검증
-- =============================================================================

-- 3-1) CODE1 별 row 개수 확인
SELECT CODE1,
       COUNT(*)                                    AS cnt,
       SUM(CASE WHEN CODE4='0000' THEN 1 ELSE 0 END) AS success_cnt,
       SUM(CASE WHEN CODE4='F201' THEN 1 ELSE 0 END) AS auth_cancel_cnt,
       SUM(CASE WHEN CODE4='F901' THEN 1 ELSE 0 END) AS comm_fail_cnt,
       SUM(CASE WHEN CODE4='3081' THEN 1 ELSE 0 END) AS balance_cnt,
       SUM(CASE WHEN CODE4='F999' THEN 1 ELSE 0 END) AS etc_cnt
  FROM TBAD_CODE
 WHERE COL_NM = 'CULTURE_RSLT_CD'
 GROUP BY CODE1
 ORDER BY CODE1;
-- 기대:
--   01 (로그인)   : 31 rows
--   02 (결제)     : 41 rows
--   03 (취소)     : 14 rows
--   04 (부분취소) : 23 rows
--   합계          : 109 rows

-- 3-2) 내부 매핑 (RSLT_CD/32) 와 JOIN 확인 — CODE4 가 RSLT_CD/32 에 존재해야 함
SELECT  c.CODE1, c.CODE3 AS culture_code, c.DESC1 AS culture_msg,
        c.CODE4 AS mapped_rslt_cd, r.DESC1 AS mapped_msg
  FROM  TBAD_CODE c
  LEFT  JOIN TBAD_CODE r ON r.COL_NM = 'RSLT_CD' AND r.CODE1 = '32' AND r.CODE2 = c.CODE4
 WHERE  c.COL_NM = 'CULTURE_RSLT_CD'
 ORDER BY c.CODE1, c.CODE3
 LIMIT 20;
-- 기대: mapped_msg 가 NULL 인 row 없어야 함 (v03 의 RSLT_CD/32 5건 모두 매핑됨)
