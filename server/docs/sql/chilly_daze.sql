CREATE SCHEMA IF NOT EXISTS chilly_daze;

CREATE TABLE IF NOT EXISTS chilly_daze.achievement_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS chilly_daze.achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  category_id UUID NOT NULL REFERENCES chilly_daze.achievement_categories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chilly_daze.users (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  avatar UUID REFERENCES chilly_daze.achievements(id) ON UPDATE CASCADE ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS chilly_daze.user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id VARCHAR(255) NOT NULL REFERENCES chilly_daze.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES chilly_daze.achievements(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chilly_daze.chills (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id VARCHAR(255) NOT NULL REFERENCES chilly_daze.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMP WITH TIME ZONE,
  distance DOUBLE PRECISION NOT NULL
);

CREATE TABLE IF NOT EXISTS chilly_daze.chill_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chill_id UUID NOT NULL REFERENCES chilly_daze.chills(id) ON UPDATE CASCADE ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES chilly_daze.achievements(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chilly_daze.trace_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chill_id UUID NOT NULL REFERENCES chilly_daze.chills(id) ON UPDATE CASCADE ON DELETE CASCADE,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS chilly_daze.photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chill_id UUID NOT NULL REFERENCES chilly_daze.chills(id) ON UPDATE CASCADE ON DELETE CASCADE,
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  url VARCHAR(255) NOT NULL
);

INSERT INTO chilly_daze.ACHIEVEMENT_CATEGORIES VALUES
  ('def36fdf-8879-470c-8744-7bb88237e710', 'area', '面積'),
  ('1fe84b35-6a09-443b-bc97-96d5f4671e31', 'frequence', '回数'),
  ('2c5aa2c6-16a9-4d0d-b4a3-552a38505682', 'continuous', '連続');

INSERT INTO chilly_daze.ACHIEVEMENTS VALUES
  ('43d07cb1-d23d-42a9-b95a-28ac81aa8426', 'area1', '色水', '1日で近所の新しい景色を見た', 'def36fdf-8879-470c-8744-7bb88237e710'),
  ('dd4e3147-c6aa-4ed0-89fc-e9a62846554e', 'area2', 'ハケ', '1週間で町のまだ見ぬ景色をみた', 'def36fdf-8879-470c-8744-7bb88237e710'),
  ('45d90aa7-5428-48a8-8d98-852c0ebe58b9', 'area3', '世界', '1週間で少し遠くの新しい景色をみた', 'def36fdf-8879-470c-8744-7bb88237e710'),
  ('423a969b-76bd-4848-88bf-9f6bf494fdc7', 'frequence1', 'ケーキ', 'はじめての記録をした', '1fe84b35-6a09-443b-bc97-96d5f4671e31'),
  ('56bd20af-91d3-4dd7-aeb1-5fa27ca12f50', 'frequence2', 'リュック', '合計3回記録した', '1fe84b35-6a09-443b-bc97-96d5f4671e31'),
  ('cfeb362d-7158-4b08-98ca-4754656cec75', 'frequence3', '写真', '合計20回記録した', '1fe84b35-6a09-443b-bc97-96d5f4671e31'),
  ('71e73e6e-a8b8-49b0-a9a9-19752f156a49', 'continuous1', '星1つ', '連続で3日記録した', '2c5aa2c6-16a9-4d0d-b4a3-552a38505682'),
  ('8f9c546e-3fb1-4839-b3d2-c9c448648585', 'continuous2', '星2つ', '連続で5日記録した', '2c5aa2c6-16a9-4d0d-b4a3-552a38505682'),
  ('c541846b-ed6b-44fe-ac3b-7d310205528f', 'continuous3', '星3つ', '連続で10日記録した', '2c5aa2c6-16a9-4d0d-b4a3-552a38505682');