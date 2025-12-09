# Emotion Flowerbed - 감정 화단 일기 서비스

> AI가 일기의 감정을 분석하여 감정에 맞는 꽃을 선물하는 감정 기록 서비스

---

## 📖 프로젝트 소개

매일의 감정을 일기로 기록하고, AI가 감정을 분석하여 그 감정에 어울리는 꽃을 선물합니다.
한 달 동안 쌓인 꽃들은 나만의 감정 화단이 되어 감정의 여정을 보여줍니다.

### 주요 기능
- 🎨 **일기 작성**: 하루의 이야기를 자유롭게 작성
- 🤖 **AI 감정 분석**: GPT-4가 20개 감정 중 가장 적합한 감정 선택
- 🌸 **감정별 꽃 선물**: 각 감정마다 어울리는 꽃과 꽃말 제공
- 🏡 **감정 화단**: 월별로 일기를 화단처럼 시각화
- 📊 **감정 통계**: 나의 감정 패턴 분석 (예정)

---

## 🏗 프로젝트 구조

### 저장소
- **Backend API**: [emotion-flowerbed-api](https://github.com/Geeehyun/emotion-flowerbed-api)
- **Frontend**: [emotion-flowerbed-front](https://github.com/Geeehyun/emotion-flowerbed-front)
- **Docs**: [emotion-flowerbed-docs](https://github.com/Geeehyun/emotion-flowerbed-docs)

### 기술 스택
```
Backend:  Java 17 + Spring Boot 3.x + MariaDB + OpenAI GPT-4
Frontend: Vue 3 + Tailwind CSS
```

---

## 🌼 20가지 감정과 꽃

### 긍정 감정 (10개)
| 감정 | 코드 | 꽃 | 꽃말 |
|------|------|-----|------|
| 기쁨 | JOY | 해바라기 | 당신을 보면 행복해요 |
| 행복 | HAPPINESS | 코스모스 | 평화로운 사랑 |
| 감사 | GRATITUDE | 핑크 장미 | 감사, 존경 |
| 설렘 | EXCITEMENT | 프리지아 | 순수한 마음 |
| 평온 | PEACE | 은방울꽃 | 행복의 재림 |
| 성취감 | ACHIEVEMENT | 노란 튤립 | 성공, 명성 |
| 사랑 | LOVE | 빨간 장미 | 사랑, 애정 |
| 희망 | HOPE | 데이지 | 희망, 순수 |
| 활력 | VITALITY | 거베라 | 희망, 도전 |
| 재미 | FUN | 스위트피 | 즐거운 추억 |

### 부정 감정 (10개)
| 감정 | 코드 | 꽃 | 꽃말 |
|------|------|-----|------|
| 슬픔 | SADNESS | 파란 수국 | 진심, 이해 |
| 외로움 | LONELINESS | 물망초 | 나를 잊지 말아요 |
| 불안 | ANXIETY | 라벤더 | 침묵, 의심 |
| 분노 | ANGER | 노란 카네이션 | 경멸, 거절 |
| 피곤 | FATIGUE | 민트 | 휴식, 상쾌함 |
| 후회 | REGRET | 보라색 팬지 | 생각, 추억 |
| 무기력 | LETHARGY | 백합 | 순수, 재생 |
| 혼란 | CONFUSION | 아네모네 | 기대, 진실 |
| 실망 | DISAPPOINTMENT | 노란 수선화 | 불확실한 사랑 |
| 지루함 | BOREDOM | 흰 카모마일 | 역경 속의 평온 |

---

## 🗂 문서 구조

이 저장소는 프로젝트의 모든 설계 문서를 포함합니다:

### 핵심 문서
- **[PROJECT-INFO.md](PROJECT-INFO.md)** - 프로젝트 전체 정보 ⭐
- **[database-schema.sql](database-schema.sql)** - 실행 가능한 DB 스키마 ⭐
- **[EmotionCode.java](EmotionCode.java)** - Java Enum 클래스 ⭐

### 설계 문서
- **[database-design.md](database-design.md)** - DB 설계 상세 (ERD, 쿼리 패턴)
- **[emotion-system.md](emotion-system.md)** - 20개 감정 체계 정의
- **[emotion-code-guide.md](emotion-code-guide.md)** - 영문 코드 시스템 가이드

### 분석 문서
- **[diary-emotion-analysis.md](diary-emotion-analysis.md)** - 초기 분석 설계

---

## 🚀 빠른 시작

### 1. 데이터베이스 설정
```bash
# MariaDB 접속
mysql -u root -p

# 스키마 실행
source database-schema.sql

# 확인
USE flowerbed;
SELECT COUNT(*) FROM emotions;  # 20개여야 함
```

### 2. Backend 실행
```bash
git clone https://github.com/Geeehyun/emotion-flowerbed-api.git
cd emotion-flowerbed-api

# 환경 변수 설정
cp .env.example .env
# DB 정보 및 OpenAI API 키 입력

# 실행
./gradlew bootRun
```

### 3. Frontend 실행
```bash
git clone https://github.com/Geeehyun/emotion-flowerbed-front.git
cd emotion-flowerbed-front

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# API URL 설정

# 개발 서버 실행
npm run serve
```

---

## 📡 API 명세

### 일기 감정 분석
```http
POST /diaries/{diaryId}/analyze

Request:
{
  "diaryContent": "오늘은 친구와...",
  "diaryDate": "2025-12-04"
}

Response:
{
  "summary": "친구와 즐거운 시간을 보냄",
  "emotions": [
    {"emotion": "JOY", "percent": 70},
    {"emotion": "HAPPINESS", "percent": 30}
  ],
  "coreEmotion": "JOY",
  "reason": "친구와의 즐거운 시간이 강조됨",
  "flower": "해바라기",
  "floriography": "당신을 보면 행복해요"
}
```

### 월별 일기 조회
```http
GET /diaries?yearMonth=2025-12

Response:
{
  "yearMonth": "2025-12",
  "diaries": [
    {
      "id": 1,
      "date": "2025-12-04",
      "coreEmotion": "JOY",
      "flower": "해바라기",
      "summary": "친구와 즐거운 시간..."
    }
  ],
  "totalCount": 15,
  "hasNextMonth": true,
  "hasPrevMonth": true
}
```

---

## 🎨 화면 구성 (예정)

### 1. 일기 작성
- 날짜 선택
- 일기 내용 입력 (최대 5000자)
- AI 분석 버튼

### 2. 감정 화단 (월별 일기 목록)
- 월 선택 네비게이션
- 날짜별 꽃 3D 이미지 그리드
- 감정 색상 구분 (긍정=따뜻한 색, 부정=차가운 색)

### 3. 일기 상세
- 일기 전체 내용
- 감정 분석 결과 (막대 그래프)
- 꽃 실사 이미지 + 꽃말
- 선택 이유

---

## 🔐 보안 및 검증

### 1. 프롬프트 인젝션 방어
- 구분자 사용 (`[일기 내용 시작]` ~ `[끝]`)
- System Prompt 명시적 방어
- 백엔드 응답 검증

### 2. 입력 검증 (다중 레이어)
- **최소 길이**: 10자
- **최소 단어**: 3개
- **한글 비율**: 30% 이상
- **특수문자 비율**: 70% 미만
- **반복 문자**: 10번 미만

### 3. Rate Limiting
- 1분에 10번 제한

---

## 📊 데이터베이스 ERD

```
┌─────────────┐
│    users    │
│─────────────│
│ user_id (PK)│
│ email       │
│ password    │
│ nickname    │
└─────────────┘
      │ 1:N
      ↓
┌─────────────────┐         ┌──────────────────┐
│    diaries      │  N:1    │    emotions      │
│─────────────────│←────────│──────────────────│
│ diary_id (PK)   │         │ emotion_code (PK)│
│ user_id (FK)    │         │ emotion_name_kr  │
│ diary_date      │         │ emotion_name_en  │
│ content         │         │ flower_name      │
│ core_emotion────┼────────→│ flower_meaning   │
│ summary         │         │ image_file_3d    │
│ emotions_json   │         │ image_file_real  │
└─────────────────┘         └──────────────────┘
```

---

## 🛠 개발 체크리스트

### Backend
- [ ] DB 스키마 실행
- [ ] EmotionCode Enum 추가
- [ ] Entity 작성 (User, Diary)
- [ ] Repository 작성
- [ ] DiaryContentValidator 구현
- [ ] DiarySecurityValidator 구현
- [ ] LLMClient 구현 (OpenAI)
- [ ] DiaryEmotionService 구현
- [ ] DiaryController 구현
- [ ] GlobalExceptionHandler 구현
- [ ] Rate Limiting 설정
- [ ] 단위 테스트 작성

### Frontend
- [ ] 20개 꽃 이미지 생성 (3D + 실사)
- [ ] emotionMapper.js 작성
- [ ] diaryApi.js 작성
- [ ] DiaryEditor 컴포넌트
- [ ] FlowerGarden 컴포넌트
- [ ] FlowerCard 컴포넌트
- [ ] 월별 네비게이션 구현
- [ ] 로딩 상태 처리
- [ ] 에러 처리
- [ ] 반응형 디자인

---

## 📈 로드맵

### Phase 1 - MVP (진행 중)
- [x] 전체 시스템 설계
- [x] DB 스키마 설계
- [x] 감정 체계 정의
- [x] 영문 코드 시스템 도입
- [ ] Backend API 구현
- [ ] Frontend UI 구현
- [ ] AI 연동 및 테스트

### Phase 2 - 기능 확장
- [ ] 회원 인증 (JWT)
- [ ] 일기 검색 기능
- [ ] 태그 시스템
- [ ] 감정 통계 대시보드
- [ ] 월별 감정 트렌드 그래프

### Phase 3 - UX 개선
- [ ] 반응형 디자인 고도화
- [ ] 다크 모드
- [ ] PWA 지원 (오프라인 작성)
- [ ] 알림 기능
- [ ] 애니메이션 효과

### Phase 4 - 소셜 기능
- [ ] 일기 공개/공유
- [ ] 댓글 기능
- [ ] 친구 시스템
- [ ] 감정 공감 기능

---

## 🤝 기여하기

이슈나 PR은 언제나 환영입니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 라이선스

MIT License - 자유롭게 사용 가능합니다.

---

## 👤 개발자

**Geeehyun**
- GitHub: [@Geeehyun](https://github.com/Geeehyun)
- Email: (추가 예정)

---

## 🙏 감사의 말

이 프로젝트는 다음 기술들을 사용합니다:
- OpenAI GPT-4 for emotion analysis
- Spring Boot for robust backend
- Vue 3 for reactive frontend
- MariaDB for reliable data storage

---

## 📚 관련 문서

- [프로젝트 전체 정보](PROJECT-INFO.md)
- [데이터베이스 설계](database-design.md)
- [Backend 구현 가이드](backend-README.md)
- [Frontend 구현 가이드](frontend-README.md)
- [감정 체계](emotion-system.md)
- [영문 코드 가이드](emotion-code-guide.md)
- [입력 검증 가이드](diary-validation-guide.md)

---
