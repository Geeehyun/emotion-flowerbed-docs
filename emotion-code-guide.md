# 영문 감정 코드 시스템 가이드

## 개요
감정명을 한글 직접 저장 대신 **영문 코드(Enum)** 로 저장하여 다국어 확장성과 타입 안전성을 확보

---

## 변경 사항 요약

### Before (한글 직접 저장)
```sql
core_emotion VARCHAR(20)  -- '기쁨', '행복', '슬픔'...
```
```java
diary.setCoreEmotion("기쁨");  // 오타 가능
```

### After (영문 코드)
```sql
core_emotion_code VARCHAR(20)  -- 'JOY', 'HAPPINESS', 'SADNESS'...
```
```java
diary.setCoreEmotion(EmotionCode.JOY.name());  // 타입 안전
```

---

## 20개 감정 코드 매핑표

| 코드 | 한글 | 영문 | 긍정/부정 | 꽃 |
|------|------|------|-----------|-----|
| JOY | 기쁨 | Joy | 긍정 | 해바라기 |
| HAPPINESS | 행복 | Happiness | 긍정 | 코스모스 |
| GRATITUDE | 감사 | Gratitude | 긍정 | 핑크 장미 |
| EXCITEMENT | 설렘 | Excitement | 긍정 | 프리지아 |
| PEACE | 평온 | Peace | 긍정 | 은방울꽃 |
| ACHIEVEMENT | 성취감 | Achievement | 긍정 | 노란 튤립 |
| LOVE | 사랑 | Love | 긍정 | 빨간 장미 |
| HOPE | 희망 | Hope | 긍정 | 데이지 |
| VITALITY | 활력 | Vitality | 긍정 | 거베라 |
| FUN | 재미 | Fun | 긍정 | 스위트피 |
| SADNESS | 슬픔 | Sadness | 부정 | 파란 수국 |
| LONELINESS | 외로움 | Loneliness | 부정 | 물망초 |
| ANXIETY | 불안 | Anxiety | 부정 | 라벤더 |
| ANGER | 분노 | Anger | 부정 | 노란 카네이션 |
| FATIGUE | 피곤 | Fatigue | 부정 | 민트 |
| REGRET | 후회 | Regret | 부정 | 보라색 팬지 |
| LETHARGY | 무기력 | Lethargy | 부정 | 백합 |
| CONFUSION | 혼란 | Confusion | 부정 | 아네모네 |
| DISAPPOINTMENT | 실망 | Disappointment | 부정 | 노란 수선화 |
| BOREDOM | 지루함 | Boredom | 부정 | 흰 카모마일 |

---

## 데이터베이스 구조

### emotions 테이블 (flowers 대체)
```sql
CREATE TABLE emotions (
    emotion_code VARCHAR(20) PRIMARY KEY,  -- 'JOY', 'HAPPINESS'...
    emotion_name_kr VARCHAR(20) NOT NULL,  -- '기쁨', '행복'...
    emotion_name_en VARCHAR(20) NOT NULL,  -- 'Joy', 'Happiness'...
    flower_name VARCHAR(50) NOT NULL,
    flower_name_en VARCHAR(50) NULL,       -- 꽃 학명 (신규)
    flower_meaning VARCHAR(100) NOT NULL,
    image_file_3d VARCHAR(100) NOT NULL,
    image_file_realistic VARCHAR(100) NOT NULL,
    is_positive BOOLEAN NOT NULL,
    display_order INT NOT NULL,

    -- 신규 추가: 꽃 상세 정보
    color VARCHAR(50) NULL,                -- 꽃 색상
    blooming_season VARCHAR(50) NULL,      -- 개화 시기
    origin VARCHAR(100) NULL,              -- 원산지
    fragrance VARCHAR(100) NULL,           -- 향기
    meaning_story TEXT NULL,               -- 꽃말 유래
    fun_fact TEXT NULL,                    -- 재미있는 사실
    ...
);
```

### diaries 테이블
```sql
CREATE TABLE diaries (
    diary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    diary_date DATE NOT NULL,
    content TEXT NOT NULL,
    
    core_emotion_code VARCHAR(20),  -- 영문 코드
    summary TEXT,
    emotion_reason TEXT,
    emotions_json JSON,
    
    FOREIGN KEY (core_emotion_code) REFERENCES emotions(emotion_code)
    ...
);
```

---

## 백엔드 구현

### 1. EmotionCode Enum
```java
public enum EmotionCode {
    JOY("기쁨", "Joy", true),
    HAPPINESS("행복", "Happiness", true),
    SADNESS("슬픔", "Sadness", false),
    // ... 나머지 17개
    
    private final String koreanName;
    private final String englishName;
    private final boolean isPositive;
    
    // Getters...
    
    public static EmotionCode fromKorean(String korean) {
        // 한글 → 코드 변환
    }
}
```

### 2. Entity
```java
@Entity
@Table(name = "diaries")
public class Diary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long diaryId;
    
    @Column(length = 20)
    private String coreEmotionCode;  // "JOY", "SADNESS"
    
    // Enum 변환 헬퍼
    public EmotionCode getCoreEmotion() {
        return EmotionCode.valueOf(coreEmotionCode);
    }
    
    public void setCoreEmotion(EmotionCode emotion) {
        this.coreEmotionCode = emotion.name();
    }
}
```

### 3. DTO
```java
@Data
public class DiaryEmotionResponse {
    private String summary;
    private List<EmotionPercent> emotions;
    private String coreEmotion;  // "JOY" (영문 코드)
    private String reason;
    private String flower;
    private String floriography;
    
    @Data
    public static class EmotionPercent {
        private String emotion;  // "JOY" (영문 코드)
        private Integer percent;
    }
}
```

### 4. 프롬프트 (application.yml)
```yaml
llm:
  prompt:
    template: |
      일기에서 감지되는 감정을 아래 코드에서만 선택하세요:
      긍정: JOY, HAPPINESS, GRATITUDE, EXCITEMENT, PEACE, ACHIEVEMENT, LOVE, HOPE, VITALITY, FUN
      부정: SADNESS, LONELINESS, ANXIETY, ANGER, FATIGUE, REGRET, LETHARGY, CONFUSION, DISAPPOINTMENT, BOREDOM
      
      {
        "JOY": {"flower": "해바라기", "floriography": "당신을 보면 행복해요"},
        "HAPPINESS": {"flower": "코스모스", "floriography": "평화로운 사랑"},
        ...
      }
      
      응답:
      {
        "coreEmotion": "JOY",  // 영문 코드
        "emotions": [
          {"emotion": "JOY", "percent": 70}
        ],
        ...
      }
```

---

## 프론트엔드 구현

### 1. 감정 매핑 유틸
```javascript
// src/utils/emotionMapper.js
export const EMOTION_MAP = {
  'JOY': { kr: '기쁨', en: 'Joy', flower: 'sunflower' },
  'HAPPINESS': { kr: '행복', en: 'Happiness', flower: 'cosmos' },
  // ... 나머지
};

export function getEmotionName(code, lang = 'kr') {
  return EMOTION_MAP[code]?.[lang] || code;
}

export function getFlowerImage(code, style = '3d') {
  const flower = EMOTION_MAP[code]?.flower;
  if (!flower) return null;
  
  const ext = style === '3d' ? 'png' : 'jpg';
  return require(`@/assets/flowers/${style}/${flower}.${ext}`);
}
```

### 2. 사용 예시
```vue
<template>
  <div class="diary-card">
    <!-- 감정명 표시 -->
    <h3>{{ emotionName }}</h3>
    
    <!-- 꽃 이미지 -->
    <img :src="flowerImage" :alt="emotionName" />
  </div>
</template>

<script>
import { getEmotionName, getFlowerImage } from '@/utils/emotionMapper';

export default {
  props: {
    emotion: String  // "JOY"
  },
  computed: {
    emotionName() {
      return getEmotionName(this.emotion, 'kr');  // "기쁨"
    },
    flowerImage() {
      return getFlowerImage(this.emotion, '3d');
    }
  }
}
</script>
```

---

## 주요 쿼리 패턴

### 1. 일기 저장 (분석 결과)
```java
// 백엔드
diary.setCoreEmotionCode("JOY");
diaryRepository.save(diary);
```

```sql
-- 실제 쿼리
UPDATE diaries 
SET core_emotion_code = 'JOY', 
    summary = ?, 
    emotion_reason = ?
WHERE diary_id = ?;
```

### 2. 일기 조회 (한글명 포함)
```sql
SELECT 
    d.diary_id,
    d.diary_date,
    d.core_emotion_code,
    e.emotion_name_kr,  -- 한글명 자동 조인
    e.flower_name,
    e.image_file_3d
FROM diaries d
LEFT JOIN emotions e ON d.core_emotion_code = e.emotion_code
WHERE d.user_id = ?;
```

### 3. 감정별 통계
```sql
SELECT 
    e.emotion_name_kr,
    COUNT(*) as count
FROM diaries d
JOIN emotions e ON d.core_emotion_code = e.emotion_code
WHERE d.user_id = ?
GROUP BY e.emotion_name_kr
ORDER BY count DESC;
```

---

## 다국어 확장

### 영어 서비스 추가 시
```javascript
// 프론트엔드에서 언어만 변경
export function getEmotionName(code, lang = 'kr') {
  const emotion = EMOTION_MAP[code];
  if (!emotion) return code;
  
  switch(lang) {
    case 'en':
      return emotion.en;  // 'Joy'
    case 'kr':
    default:
      return emotion.kr;  // '기쁨'
  }
}
```

### DB에 일본어 추가
```sql
ALTER TABLE emotions 
ADD COLUMN emotion_name_jp VARCHAR(20) AFTER emotion_name_en;

UPDATE emotions SET emotion_name_jp = '喜び' WHERE emotion_code = 'JOY';
UPDATE emotions SET emotion_name_jp = '幸せ' WHERE emotion_code = 'HAPPINESS';
-- ...
```

---

## 마이그레이션 (이미 개발 시작한 경우)

### 1. 새 테이블 생성
```sql
-- emotions 테이블 생성
CREATE TABLE emotions (...);

-- 초기 데이터 INSERT
INSERT INTO emotions VALUES
('JOY', '기쁨', 'Joy', '해바라기', ...),
('HAPPINESS', '행복', 'Happiness', '코스모스', ...);
```

### 2. 기존 diaries 테이블 수정
```sql
-- 새 컬럼 추가
ALTER TABLE diaries 
ADD COLUMN core_emotion_code VARCHAR(20) AFTER content;

-- 데이터 변환 (한글 → 영문 코드)
UPDATE diaries SET core_emotion_code = 'JOY' WHERE core_emotion = '기쁨';
UPDATE diaries SET core_emotion_code = 'HAPPINESS' WHERE core_emotion = '행복';
-- ... 나머지 18개

-- 외래키 추가
ALTER TABLE diaries
ADD FOREIGN KEY (core_emotion_code) REFERENCES emotions(emotion_code);

-- 기존 컬럼 삭제 (확인 후)
ALTER TABLE diaries 
DROP COLUMN core_emotion,
DROP COLUMN flower_name,
DROP COLUMN flower_meaning;
```

---

## 장점 요약

### 1. 타입 안전성
```java
// Before: 오타 가능
diary.setCoreEmotion("기뽐");  // 오타!

// After: 컴파일 에러
diary.setCoreEmotion(EmotionCode.JOYYY);  // 컴파일 에러!
```

### 2. 다국어 확장
```javascript
// 한국어 서비스
getEmotionName('JOY', 'kr')  // "기쁨"

// 영어 서비스 확장
getEmotionName('JOY', 'en')  // "Joy"

// 일본어 서비스 확장
getEmotionName('JOY', 'jp')  // "喜び"
```

### 3. 데이터 무결성
```sql
-- 외래키로 잘못된 감정 코드 입력 방지
INSERT INTO diaries (core_emotion_code) VALUES ('INVALID');
-- ERROR: foreign key constraint fails
```

### 4. 성능
```sql
-- 짧은 ASCII 문자열 (3-15자)
core_emotion_code = 'JOY'  -- 3 bytes

-- 한글은 더 많은 공간
core_emotion = '기쁨'  -- 9 bytes (UTF-8)
```

---

## 주의사항

### 1. LLM 응답 검증
```java
// 반드시 유효한 코드인지 검증
if (!VALID_EMOTIONS.contains(response.getCoreEmotion())) {
    throw new InvalidEmotionException();
}
```

### 2. 프론트엔드 매핑 필수
```javascript
// 영문 코드를 직접 사용자에게 보여주지 말 것
❌ "Your emotion: JOY"
✅ "당신의 감정: 기쁨"
```

### 3. DB 초기 데이터 필수
```sql
-- emotions 테이블에 20개 데이터 반드시 INSERT
-- 없으면 외래키 제약조건 위반
```

---

## 파일 위치

- **스키마**: `/database-schema.sql`
- **Enum**: `/EmotionCode.java`
- **백엔드 가이드**: `/backend-README.md`
- **프론트 가이드**: `/frontend-README.md`
- **DB 설계 문서**: `/database-design.md`

---

## FAQ

### Q1. 왜 숫자 ID 대신 문자열 코드?
A. 가독성과 성능의 균형. 'JOY'는 1보다 의미가 명확하면서도 충분히 짧음.

### Q2. 한글명도 DB에 저장하는 이유?
A. 백엔드에서 한글명이 필요한 경우 JOIN 없이 바로 조회 가능. 프론트 부담 감소.

### Q3. emotions 테이블 없이 Enum만?
A. 가능하지만 꽃말/이미지 변경 시 재배포 필요. DB 관리가 더 유연.

### Q4. 감정 추가/삭제 시?
A. emotions 테이블 INSERT/DELETE + Enum 수정 + 프롬프트 업데이트 필요.
