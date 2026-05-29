-- ============================================================================
-- AirNOK A/S 시스템 - Supabase 초기 설정 SQL
-- 
-- 사용 방법:
-- 1. Supabase 프로젝트 → SQL Editor → New query
-- 2. 아래 전체 코드 복사 → 붙여넣기 → Run
-- 3. "Success. No rows returned" 메시지 확인
-- ============================================================================

-- 1. 접수 테이블
CREATE TABLE IF NOT EXISTS as_receipts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  receipt_no text UNIQUE NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  customer_name text NOT NULL,
  phone text NOT NULL,
  purchase_channel text NOT NULL,
  product_name text NOT NULL,
  purchase_date date NOT NULL,
  issue_detail text NOT NULL,
  image_urls jsonb NOT NULL DEFAULT '[]'::jsonb,
  status text NOT NULL DEFAULT 'received',
  admin_memo text NOT NULL DEFAULT '',
  privacy_agreed boolean NOT NULL DEFAULT false,
  status_logs jsonb NOT NULL DEFAULT '[]'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_receipts_created ON as_receipts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_receipts_status ON as_receipts(status);
CREATE INDEX IF NOT EXISTS idx_receipts_channel ON as_receipts(purchase_channel);

-- 2. 앱 설정 테이블 (로고/문구/컬러/비밀번호 등 모든 설정 저장)
CREATE TABLE IF NOT EXISTS app_settings (
  key text PRIMARY KEY,
  value jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- 3. RLS (Row Level Security) 활성화
ALTER TABLE as_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- 4. RLS 정책: 누구나 접수 가능 (anon 키로 INSERT)
DROP POLICY IF EXISTS "anyone can insert receipts" ON as_receipts;
CREATE POLICY "anyone can insert receipts" ON as_receipts 
  FOR INSERT TO anon WITH CHECK (true);

-- 5. RLS 정책: 누구나 접수 조회 가능 (관리자도 anon 키로 조회)
--    ⚠️ 보안 강화 시: 관리자 페이지에 비밀번호 인증을 두고 있으므로 일단 모두 허용
DROP POLICY IF EXISTS "anyone can read receipts" ON as_receipts;
CREATE POLICY "anyone can read receipts" ON as_receipts 
  FOR SELECT TO anon USING (true);

-- 6. RLS 정책: 누구나 접수 수정 가능 (관리자가 상태 변경/메모 작성)
DROP POLICY IF EXISTS "anyone can update receipts" ON as_receipts;
CREATE POLICY "anyone can update receipts" ON as_receipts 
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- 7. RLS 정책: 누구나 접수 삭제 가능 (관리자가 잘못된 접수 삭제)
DROP POLICY IF EXISTS "anyone can delete receipts" ON as_receipts;
CREATE POLICY "anyone can delete receipts" ON as_receipts 
  FOR DELETE TO anon USING (true);

-- 8. RLS 정책: 누구나 설정 조회 가능 (페이지 로딩 시 로고/문구 가져오기)
DROP POLICY IF EXISTS "anyone can read settings" ON app_settings;
CREATE POLICY "anyone can read settings" ON app_settings 
  FOR SELECT TO anon USING (true);

-- 9. RLS 정책: 누구나 설정 변경 가능 (관리자가 콘텐츠 편집)
DROP POLICY IF EXISTS "anyone can upsert settings" ON app_settings;
CREATE POLICY "anyone can upsert settings" ON app_settings 
  FOR INSERT TO anon WITH CHECK (true);

DROP POLICY IF EXISTS "anyone can update settings" ON app_settings;
CREATE POLICY "anyone can update settings" ON app_settings 
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- ============================================================================
-- Storage 버킷 정책 (이미지 업로드)
-- ⚠️ 이 부분은 SQL 실행 후 별도로 Storage 메뉴에서 버킷을 만든 다음 실행하세요
-- ============================================================================

-- 'as-images' 버킷과 'branding' 버킷을 먼저 만들고 public 체크 후 아래 실행
DROP POLICY IF EXISTS "anyone can upload images" ON storage.objects;
CREATE POLICY "anyone can upload images" ON storage.objects 
  FOR INSERT TO anon 
  WITH CHECK (bucket_id IN ('as-images', 'branding'));

DROP POLICY IF EXISTS "anyone can read images" ON storage.objects;
CREATE POLICY "anyone can read images" ON storage.objects 
  FOR SELECT TO anon 
  USING (bucket_id IN ('as-images', 'branding'));

-- ============================================================================
-- 설정 완료! 
-- 이제 HTML 파일의 SUPABASE_URL, SUPABASE_ANON_KEY를 본인 값으로 입력하세요.
-- ============================================================================
