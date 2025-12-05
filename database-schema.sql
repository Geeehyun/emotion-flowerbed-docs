-- =========================================
-- Flowerbed 일기 감정 분석 서비스
-- Database: flowerbed
-- DBMS: MariaDB 10.x
-- =========================================

CREATE DATABASE IF NOT EXISTS flowerbed
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE flowerbed;

-- =========================================
-- 1. 회원 테이블
-- =========================================
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 ID',
    email VARCHAR(255) UNIQUE NOT NULL COMMENT '이메일 (로그인 ID)',
    password VARCHAR(255) NOT NULL COMMENT '암호화된 비밀번호',
    nickname VARCHAR(50) NOT NULL COMMENT '닉네임',
    profile_image VARCHAR(255) NULL COMMENT '프로필 이미지 URL',
    
    -- 메타데이터
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    deleted_at DATETIME NULL COMMENT '탈퇴일시 (soft delete)',
    
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='회원';

-- =========================================
-- 2. 감정 마스터 테이블 (flowers 대체)
-- =========================================
CREATE TABLE emotions (
    emotion_code VARCHAR(20) PRIMARY KEY COMMENT '감정 코드 (영문)',
    emotion_name_kr VARCHAR(20) NOT NULL COMMENT '감정명 (한글)',
    emotion_name_en VARCHAR(20) NOT NULL COMMENT '감정명 (영문)',
    flower_name VARCHAR(50) NOT NULL COMMENT '꽃 이름',
    flower_meaning VARCHAR(100) NOT NULL COMMENT '꽃말',
    image_file_3d VARCHAR(100) NOT NULL COMMENT '3D 이미지 파일명',
    image_file_realistic VARCHAR(100) NOT NULL COMMENT '실사 이미지 파일명',
    is_positive BOOLEAN NOT NULL COMMENT '긍정 감정 여부',
    display_order INT NOT NULL COMMENT '표시 순서',
    
    -- 메타데이터
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    INDEX idx_display_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='감정 마스터';

-- =========================================
-- 3. 일기 테이블
-- =========================================
CREATE TABLE diaries (
    diary_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '일기 ID',
    user_id BIGINT NOT NULL COMMENT '작성자 ID',
    diary_date DATE NOT NULL COMMENT '일기 날짜',
    content TEXT NOT NULL COMMENT '일기 내용',
    
    -- AI 분석 결과
    summary TEXT COMMENT '일기 요약',
    core_emotion_code VARCHAR(20) COMMENT '대표 감정 코드 (영문)',
    emotion_reason TEXT COMMENT '대표 감정 선택 이유',
    emotions_json JSON COMMENT '전체 감정 배열 JSON',
    
    -- 분석 상태
    is_analyzed BOOLEAN DEFAULT FALSE COMMENT '분석 완료 여부',
    analyzed_at DATETIME NULL COMMENT '분석 완료 일시',
    
    -- 메타데이터
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    deleted_at DATETIME NULL COMMENT '삭제일시 (soft delete)',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (core_emotion_code) REFERENCES emotions(emotion_code),
    UNIQUE KEY uk_user_date (user_id, diary_date) COMMENT '하루 1개 일기',
    INDEX idx_user_date (user_id, diary_date),
    INDEX idx_user_created (user_id, created_at DESC),
    INDEX idx_emotion (core_emotion_code),
    INDEX idx_analyzed (is_analyzed, analyzed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='일기';

-- =========================================
-- 초기 데이터: 20개 감정별 꽃 정보
-- =========================================
INSERT INTO emotions (emotion_code, emotion_name_kr, emotion_name_en, flower_name, flower_meaning, image_file_3d, image_file_realistic, is_positive, display_order) VALUES
-- 긍정 감정 (1-10)
('JOY', '기쁨', 'Joy', '해바라기', '당신을 보면 행복해요', 'sunflower.png', 'sunflower.jpg', TRUE, 1),
('HAPPINESS', '행복', 'Happiness', '코스모스', '평화로운 사랑', 'cosmos.png', 'cosmos.jpg', TRUE, 2),
('GRATITUDE', '감사', 'Gratitude', '핑크 장미', '감사, 존경', 'pink-rose.png', 'pink-rose.jpg', TRUE, 3),
('EXCITEMENT', '설렘', 'Excitement', '프리지아', '순수한 마음', 'freesia.png', 'freesia.jpg', TRUE, 4),
('PEACE', '평온', 'Peace', '은방울꽃', '행복의 재림', 'lily-valley.png', 'lily-valley.jpg', TRUE, 5),
('ACHIEVEMENT', '성취감', 'Achievement', '노란 튤립', '성공, 명성', 'yellow-tulip.png', 'yellow-tulip.jpg', TRUE, 6),
('LOVE', '사랑', 'Love', '빨간 장미', '사랑, 애정', 'red-rose.png', 'red-rose.jpg', TRUE, 7),
('HOPE', '희망', 'Hope', '데이지', '희망, 순수', 'daisy.png', 'daisy.jpg', TRUE, 8),
('VITALITY', '활력', 'Vitality', '거베라', '희망, 도전', 'gerbera.png', 'gerbera.jpg', TRUE, 9),
('FUN', '재미', 'Fun', '스위트피', '즐거운 추억', 'sweet-pea.png', 'sweet-pea.jpg', TRUE, 10),

-- 부정 감정 (11-20)
('SADNESS', '슬픔', 'Sadness', '파란 수국', '진심, 이해', 'blue-hydrangea.png', 'blue-hydrangea.jpg', FALSE, 11),
('LONELINESS', '외로움', 'Loneliness', '물망초', '나를 잊지 말아요', 'forget-me-not.png', 'forget-me-not.jpg', FALSE, 12),
('ANXIETY', '불안', 'Anxiety', '라벤더', '침묵, 의심', 'lavender.png', 'lavender.jpg', FALSE, 13),
('ANGER', '분노', 'Anger', '노란 카네이션', '경멸, 거절', 'yellow-carnation.png', 'yellow-carnation.jpg', FALSE, 14),
('FATIGUE', '피곤', 'Fatigue', '민트', '휴식, 상쾌함', 'mint.png', 'mint.jpg', FALSE, 15),
('REGRET', '후회', 'Regret', '보라색 팬지', '생각, 추억', 'purple-pansy.png', 'purple-pansy.jpg', FALSE, 16),
('LETHARGY', '무기력', 'Lethargy', '백합', '순수, 재생', 'lily.png', 'lily.jpg', FALSE, 17),
('CONFUSION', '혼란', 'Confusion', '아네모네', '기대, 진실', 'anemone.png', 'anemone.jpg', FALSE, 18),
('DISAPPOINTMENT', '실망', 'Disappointment', '노란 수선화', '불확실한 사랑', 'yellow-daffodil.png', 'yellow-daffodil.jpg', FALSE, 19),
('BOREDOM', '지루함', 'Boredom', '흰 카모마일', '역경 속의 평온', 'white-chamomile.png', 'white-chamomile.jpg', FALSE, 20);

-- =========================================
-- 뷰 (View) 정의
-- =========================================

-- 사용자별 최근 일기 목록 (삭제되지 않은 것만)
CREATE OR REPLACE VIEW v_user_recent_diaries AS
SELECT 
    d.diary_id,
    d.user_id,
    d.diary_date,
    d.content,
    d.summary,
    d.core_emotion_code,
    e.emotion_name_kr,
    e.emotion_name_en,
    e.flower_name,
    e.flower_meaning,
    d.created_at,
    e.image_file_3d,
    e.image_file_realistic,
    e.is_positive
FROM diaries d
LEFT JOIN emotions e ON d.core_emotion_code = e.emotion_code
WHERE d.deleted_at IS NULL
ORDER BY d.diary_date DESC;

-- 사용자별 감정 통계 (최근 30일)
CREATE OR REPLACE VIEW v_user_emotion_stats_30d AS
SELECT 
    d.user_id,
    d.core_emotion_code,
    e.emotion_name_kr,
    e.emotion_name_en,
    e.flower_name,
    e.is_positive,
    COUNT(*) as count,
    MAX(d.diary_date) as last_date
FROM diaries d
LEFT JOIN emotions e ON d.core_emotion_code = e.emotion_code
WHERE d.deleted_at IS NULL
  AND d.diary_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY d.user_id, d.core_emotion_code, e.emotion_name_kr, e.emotion_name_en, e.flower_name, e.is_positive;

-- =========================================
-- 인덱스 최적화 팁
-- =========================================
-- 1. 월별 일기 조회: idx_user_date 사용
--    SELECT * FROM diaries 
--    WHERE user_id = ? AND YEAR(diary_date) = 2025 AND MONTH(diary_date) = 12;
--
-- 2. 특정 날짜 일기 조회: uk_user_date 사용
--    SELECT * FROM diaries WHERE user_id = ? AND diary_date = ?;
--
-- 3. 감정별 통계: idx_emotion 사용
--    SELECT core_emotion_code, COUNT(*) FROM diaries GROUP BY core_emotion_code;
--
-- 4. 분석 대기 목록: idx_analyzed 사용
--    SELECT * FROM diaries WHERE is_analyzed = FALSE;

-- =========================================
-- 샘플 쿼리
-- =========================================

-- 사용자 회원가입
-- INSERT INTO users (email, password, nickname) VALUES (?, ?, ?);

-- 일기 작성
-- INSERT INTO diaries (user_id, diary_date, content) VALUES (?, ?, ?);

-- 일기 분석 결과 저장
-- UPDATE diaries 
-- SET summary = ?, core_emotion_code = ?, emotion_reason = ?,
--     emotions_json = ?, is_analyzed = TRUE, analyzed_at = NOW()
-- WHERE diary_id = ?;

-- 월별 일기 조회 (2025년 12월)
-- SELECT d.*, e.emotion_name_kr, e.flower_name, e.image_file_3d
-- FROM diaries d
-- LEFT JOIN emotions e ON d.core_emotion_code = e.emotion_code
-- WHERE d.user_id = ?
--   AND YEAR(d.diary_date) = 2025
--   AND MONTH(d.diary_date) = 12
--   AND d.deleted_at IS NULL
-- ORDER BY d.diary_date DESC;

-- 특정 월에 일기가 있는지 확인
-- SELECT COUNT(*) > 0 FROM diaries
-- WHERE user_id = ?
--   AND YEAR(diary_date) = 2025
--   AND MONTH(diary_date) = 12
--   AND deleted_at IS NULL;

-- 특정 날짜 일기 조회
-- SELECT d.*, e.emotion_name_kr, e.flower_name, e.image_file_3d, e.image_file_realistic
-- FROM diaries d
-- LEFT JOIN emotions e ON d.core_emotion_code = e.emotion_code
-- WHERE d.user_id = ? AND d.diary_date = ? AND d.deleted_at IS NULL;

-- =========================================
-- 성능 최적화 참고사항
-- =========================================
-- 1. emotions_json 필드는 조회 빈도가 낮으면 별도 테이블로 분리 고려
-- 2. 대용량 트래픽 시 diaries 테이블 파티셔닝 (diary_date 기준)
-- 3. 읽기 전용 슬레이브 DB 구성 고려
-- 4. Redis 캐싱: emotions 마스터 데이터, 최근 일기 목록
-- 5. core_emotion_code는 외래키로 데이터 무결성 보장
