# AirNOK A/S 접수 시스템 (Cloud 버전)

오투라이프캠핑 AirNOK 제품의 A/S 접수를 받고 관리하는 풀스택 웹 시스템입니다.

## 📦 파일 구성

- `index.html` — 메인 시스템 파일 (고객 + 관리자 페이지 통합)
- `supabase-setup.sql` — Supabase 데이터베이스 초기 설정 SQL
- `README.md` — 본 문서

## 🚀 시작하기 (1시간 가이드)

자세한 단계별 가이드는 별도 제공된 **"가입/배포 가이드 PDF"** 를 참고하세요.

빠른 요약:
1. GitHub 가입 → 저장소 생성 → 이 파일들 업로드
2. Supabase 가입 → 프로젝트 생성 → `supabase-setup.sql` 실행
3. Storage 버킷 2개 생성 (`as-images`, `branding`)
4. `index.html` 파일에서 `SUPABASE_URL`, `SUPABASE_ANON_KEY` 본인 값으로 교체
5. Vercel 가입 → GitHub 연결 → 배포

## 🎨 주요 기능

### 고객용 (자사몰 링크로 진입)
- A/S 접수 폼 (이름/연락처/구매처/제품/구매일/내용/사진)
- 모바일 최적화 + 한 손 입력 UX
- 접수번호 자동 생성 (AS-YYYYMMDD-NNNN)

### 관리자용 (`/?admin=1` 또는 헤더 버튼)
- 📋 접수 목록 (필터/검색/Excel/CSV 다운로드)
- ⚙️ 콘텐츠 편집 (텍스트/구매처 옵션)
- 🎨 로고/브랜딩 (PNG 업로드, 텍스트 로고)
- 🌈 컬러 테마 (프리셋 5종 + HEX 입력)
- 📜 약관/안내문 편집

## 💰 운영비

**월 0원** (Supabase Free + Vercel Hobby)

## 🔐 초기 비밀번호

`airnok2026` — 로그인 후 반드시 변경하세요!

## 📞 지원

- Supabase 상태: https://status.supabase.com
- Vercel 상태: https://www.vercel-status.com
