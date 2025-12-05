# Emotion Flowerbed 프로젝트

## 프로젝트 개요
AI가 일기의 감정을 분석하여 감정에 맞는 꽃을 선물하는 감정 기록 서비스

---

## 프로젝트 정보

### 도메인 (예정)
```
emotion-flowerbed.com
```

### GitHub 저장소
- **API (Backend)**: https://github.com/Geeehyun/emotion-flowerbed-api
- **Frontend**: https://github.com/Geeehyun/emotion-flowerbed-front  
- **Docs**: https://github.com/Geeehyun/emotion-flowerbed-docs

### 기술 스택

#### Backend
- **Language**: Java 17+
- **Framework**: Spring Boot 3.x
- **Database**: MariaDB 10.x
- **ORM**: JPA (Hibernate)
- **AI**: OpenAI GPT-4 / Anthropic Claude

#### Frontend
- **Framework**: Vue 3
- **State Management**: Pinia (또는 Vuex)
- **HTTP Client**: Axios
- **Styling**: Tailwind CSS

#### DevOps
- **CI/CD**: GitHub Actions
- **Container**: Docker
- **Deployment**: (예정)

---

## 프로젝트 구조

### API (Backend)
```
emotion-flowerbed-api/
├── src/
│   ├── main/
│   │   ├── java/com/emotion/flowerbed/
│   │   │   ├── domain/
│   │   │   │   ├── User.java
│   │   │   │   ├── Diary.java
│   │   │   │   ├── Emotion.java
│   │   │   │   └── EmotionCode.java (Enum)
│   │   │   ├── controller/
│   │   │   │   ├── DiaryController.java
│   │   │   │   └── UserController.java
│   │   │   ├── service/
│   │   │   │   ├── DiaryService.java
│   │   │   │   ├── DiaryEmotionService.java
│   │   │   │   └── LLMClient.java
│   │   │   ├── repository/
│   │   │   │   ├── DiaryRepository.java
│   │   │   │   ├── UserRepository.java
│   │   │   │   └── EmotionRepository.java
│   │   │   ├── dto/
│   │   │   │   ├── DiaryEmotionRequest.java
│   │   │   │   ├── DiaryEmotionResponse.java
│   │   │   │   └── MonthlyDiariesResponse.java
│   │   │   ├── validator/
│   │   │   │   ├── DiaryContentValidator.java
│   │   │   │   └── DiarySecurityValidator.java
│   │   │   ├── config/
│   │   │   │   ├── LLMConfig.java
│   │   │   │   └── SecurityConfig.java
│   │   │   └── exception/
│   │   │       ├── GlobalExceptionHandler.java
│   │   │       └── InvalidDiaryContentException.java
│   │   └── resources/
│   │       ├── application.yml
│   │       └── db/
│   │           └── schema.sql
│   └── test/
├── Dockerfile
└── README.md
```

### Frontend
```
emotion-flowerbed-front/
├── src/
│   ├── assets/
│   │   └── flowers/
│   │       ├── 3d/          # 화단 화면용 PNG (투명 배경)
│   │       │   ├── sunflower.png
│   │       │   └── ...
│   │       └── realistic/   # 상세 화면용 JPG
│   │           ├── sunflower.jpg
│   │           └── ...
│   ├── components/
│   │   ├── DiaryEditor.vue
│   │   ├── FlowerGarden.vue
│   │   ├── FlowerCard.vue
│   │   └── EmotionChart.vue
│   ├── views/
│   │   ├── Home.vue
│   │   ├── DiaryWrite.vue
│   │   ├── DiaryDetail.vue
│   │   └── FlowerGarden.vue
│   ├── utils/
│   │   ├── emotionMapper.js
│   │   └── dateUtils.js
│   ├── api/
│   │   └── diaryApi.js
│   ├── router/
│   │   └── index.js
│   ├── store/
│   │   └── index.js
│   └── App.vue
├── public/
├── Dockerfile
└── README.md
```

### Docs
```
emotion-flowerbed-docs/
├── database-schema.sql
├── database-design.md
├── emotion-system.md
├── backend-README.md
├── frontend-README.md
├── diary-emotion-analysis.md
├── diary-validation-guide.md
├── emotion-code-guide.md
├── EmotionCode.java
└── README.md
```

---

## 핵심 기능

### 1. 일기 작성 및 감정 분석
- 일기 작성 (최대 5000자)
- AI 자동 감정 분석 (20개 감정 분류)
- 감정별 꽃 매칭
- 일기 요약 생성

### 2. 화단 (일기 목록)
- 월별 일기 조회 (2025-12, 2025-11...)
- 날짜별 꽃 3D 이미지 표시
- 감정 색상 구분 (긍정/부정)
- 월간 이동 (이전/다음 월)

### 3. 일기 상세
- 일기 전체 내용
- 감정 분석 결과 (비율)
- 선택 이유 표시
- 꽃 실사 이미지

### 4. 통계 (향후 기능)
- 월별 감정 트렌드
- 가장 많이 느낀 감정
- 감정 변화 그래프

---

## API 엔드포인트

### 인증 (향후)
```
POST   /auth/signup      # 회원가입
POST   /auth/login       # 로그인
POST   /auth/logout      # 로그아웃
```

### 일기
```
POST   /diaries/{id}/analyze  # 일기 감정 분석
GET    /diaries?yearMonth=    # 월별 일기 목록
GET    /diaries/{id}          # 일기 상세
PUT    /diaries/{id}          # 일기 수정
DELETE /diaries/{id}          # 일기 삭제
```

### 통계 (향후)
```
GET    /statistics/monthly    # 월별 통계
GET    /statistics/emotions   # 감정별 통계
```

---

## 데이터베이스 스키마

### 주요 테이블
- `users`: 회원 정보
- `diaries`: 일기 + AI 분석 결과
- `emotions`: 20개 감정 마스터 데이터

### 감정 코드 (20개)
```
긍정: JOY, HAPPINESS, GRATITUDE, EXCITEMENT, PEACE, 
      ACHIEVEMENT, LOVE, HOPE, VITALITY, FUN

부정: SADNESS, LONELINESS, ANXIETY, ANGER, FATIGUE, 
      REGRET, LETHARGY, CONFUSION, DISAPPOINTMENT, BOREDOM
```

---

## 월별 일기 조회 방식

### API 호출
```javascript
// 2025년 12월 일기 조회
GET /diaries?yearMonth=2025-12

// 응답
{
  "yearMonth": "2025-12",
  "diaries": [
    {
      "id": 1,
      "date": "2025-12-04",
      "coreEmotion": "JOY",
      "flower": "해바라기",
      "summary": "..."
    }
  ],
  "totalCount": 15,
  "hasNextMonth": true,
  "hasPrevMonth": true
}
```

### 프론트엔드 구현
```vue
<template>
  <div class="flower-garden">
    <!-- 월 선택 -->
    <div class="month-nav">
      <button @click="prevMonth" :disabled="!hasPrev">◀ 이전</button>
      <h2>{{ currentMonth }}</h2>
      <button @click="nextMonth" :disabled="!hasNext">다음 ▶</button>
    </div>
    
    <!-- 꽃 화단 -->
    <div class="flowers">
      <flower-card 
        v-for="diary in diaries" 
        :key="diary.id"
        :diary="diary"
      />
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentMonth: '2025-12',
      diaries: [],
      hasPrev: false,
      hasNext: false
    }
  },
  methods: {
    async loadMonth() {
      const data = await this.$api.getMonthlyDiaries(this.currentMonth);
      this.diaries = data.diaries;
      this.hasPrev = data.hasPrevMonth;
      this.hasNext = data.hasNextMonth;
    },
    prevMonth() {
      // currentMonth에서 1개월 빼기
      this.loadMonth();
    },
    nextMonth() {
      // currentMonth에서 1개월 더하기
      this.loadMonth();
    }
  }
}
</script>
```

---

## 환경 변수

### Backend (.env)
```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=flowerbed
DB_USERNAME=flowerbed_user
DB_PASSWORD=your_password

# LLM API
LLM_PROVIDER=openai
LLM_API_KEY=your_openai_api_key
LLM_MODEL=gpt-4

# Server
SERVER_PORT=8080
```

### Frontend (.env)
```env
VUE_APP_API_URL=http://localhost:8080
VUE_APP_ENV=development
```

---

## 개발 시작하기

### 1. Backend 실행
```bash
cd emotion-flowerbed-api

# DB 스키마 실행
mysql -u root -p < docs/database-schema.sql

# 환경 변수 설정
cp .env.example .env
# .env 파일 수정

# 실행
./gradlew bootRun
# or
./mvnw spring-boot:run
```

### 2. Frontend 실행
```bash
cd emotion-flowerbed-front

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env 파일 수정

# 개발 서버 실행
npm run serve
```

---

## 배포 전략 (예정)

### Backend
- Docker 이미지 빌드
- AWS ECS / Azure App Service
- 또는 간단하게 Heroku

### Frontend
- Netlify / Vercel
- 또는 S3 + CloudFront

### Database
- AWS RDS (MariaDB)
- 또는 PlanetScale

---

## 로드맵

### Phase 1 - MVP (현재)
- [x] 감정 분석 시스템 설계
- [x] DB 스키마 설계
- [ ] Backend API 구현
- [ ] Frontend 기본 UI
- [ ] AI 연동

### Phase 2 - 기능 확장
- [ ] 회원 인증 (JWT)
- [ ] 일기 검색
- [ ] 태그 기능
- [ ] 감정 통계

### Phase 3 - UX 개선
- [ ] 반응형 디자인
- [ ] 다크 모드
- [ ] PWA 지원
- [ ] 알림 기능

### Phase 4 - 소셜 기능
- [ ] 일기 공개/공유
- [ ] 댓글 기능
- [ ] 친구 기능

---

## 라이선스
MIT License

---

## 팀
- **개발자**: Geeehyun
- **GitHub**: [@Geeehyun](https://github.com/Geeehyun)

---

## 문의
- **Email**: (추가 예정)
- **Issues**: 각 저장소의 Issues 탭 활용
