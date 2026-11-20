-- ============================================================================
-- FLATFIT SEED DATA
-- 50 realistic demo users across Mumbai localities, questionnaire answers,
-- listings, sample flat 'Sunshine 301' with members, expenses, chores,
-- calendar events, notices, inventory, matches, and chats.
-- ============================================================================

-- Setup auth schema fallback if running outside local Supabase auth stack
CREATE SCHEMA IF NOT EXISTS auth;
CREATE TABLE IF NOT EXISTS auth.users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text UNIQUE,
    encrypted_password text,
    email_confirmed_at timestamptz DEFAULT now(),
    raw_app_meta_data jsonb DEFAULT '{}'::jsonb,
    raw_user_meta_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 1. Insert Questionnaire Questions
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000001', 'sleep', 'What is your typical sleep schedule on weekdays?', 'सप्ताह के दिनों में आपका सोने का सामान्य समय क्या है?', '["Early bird (Sleep before 11 PM)", "Moderate (Sleep 11 PM - 1 AM)", "Night owl (Sleep after 1 AM)"]'::jsonb, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000002', 'cleanliness', 'How clean and organized do you keep shared spaces?', 'आप साझा कमरों को कितना साफ और व्यवस्थित रखते हैं?', '["Meticulous / neat freak", "Regularly tidy (clean up weekly)", "Relaxed (clean when it gets messy)"]'::jsonb, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000003', 'food', 'What are your dietary preferences?', 'आपकी खान-पान की प्राथमिकता क्या है?', '["Strict Vegetarian", "Non-Vegetarian ok in kitchen", "Non-Vegetarian (regularly cook/eat meat)"]'::jsonb, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000004', 'cooking', 'How do you plan to manage meals and cooking?', 'आप भोजन और खाना पकाने की व्यवस्था कैसे करेंगे?', '["Hire a common cook", "Self-cooking individually", "Mostly order in / tiffin service"]'::jsonb, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000005', 'smoking', 'What is your stance on smoking in the flat?', 'फ्लैट में धूम्रपान को लेकर आपकी क्या राय है?', '["Strictly non-smoking flat", "Balcony smoking is fine", "Smoking inside room is ok"]'::jsonb, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000006', 'drinking', 'How often do you drink or have drinks at home?', 'आप कितनी बार घर पर शराब पीते हैं?', '["Non-drinker / alcohol-free home", "Occasional / social drinker", "Regular weekend drinks with friends"]'::jsonb, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000007', 'guests', 'What is your policy on overnight guests and friends visiting?', 'रात में रुकने वाले मेहमानों और दोस्तों के बारे में आपकी क्या नीति है?', '["Prior notice & consent needed", "Casual daytime visits only", "Open door / friends welcome anytime"]'::jsonb, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000008', 'noise', 'What is your sound/noise tolerance at home?', 'घर पर शोर को लेकर आपकी सहनशीलता कैसी है?', '["Pin-drop silence preferred", "Moderate ambient noise / music with earphones", "Lively music / parties welcome"]'::jsonb, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000009', 'pets', 'What is your comfort level with pets in the apartment?', 'अपार्टमेंट में पालतू जानवरों के साथ आपकी क्या सहजता है?', '["No pets allowed / allergic", "Love pets, ok to have dogs/cats", "Planning to bring my own pet"]'::jsonb, 9)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000010', 'wfh', 'How many days a week do you work from home?', 'आप सप्ताह में कितने दिन घर से काम करते हैं?', '["Full-time in office", "Hybrid (2-3 days WFH)", "100% remote / full-time WFH"]'::jsonb, 10)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000011', 'bills', 'How do you prefer handling shared utility bills?', 'आप साझा बिजली/वाईफाई बिलों का निपटान कैसे करना पसंद करते हैं?', '["Instant settlement on arrival", "Splitwise / monthly settlement", "Rotate paying bills"]'::jsonb, 11)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000012', 'rent_punctuality', 'When do you typically pay your portion of the rent?', 'आप आम तौर पर अपने हिस्से का किराया कब चुकाते हैं?', '["Strictly on or before 1st of month", "Between 1st and 5th", "Within first 10 days upon salary"]'::jsonb, 12)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000013', 'introvert_extrovert', 'How do you recharge after a busy day?', 'व्यस्त दिन के बाद आप खुद को कैसे तरोताजा करते हैं?', '["Introvert (quiet time in my own room)", "Ambivert (mix of alone time & casual chats)", "Extrovert (love hanging out in living room)"]'::jsonb, 13)
ON CONFLICT (id) DO NOTHING;
INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('11111111-0000-0000-0000-000000000014', 'conflict', 'How do you prefer addressing flatmate issues or grievances?', 'फ्लैटमेट के साथ किसी मुद्दे पर आप कैसे बात करना पसंद करते हैं?', '["Direct, calm 1-on-1 discussion", "Group chat / house meeting", "Give space and resolve gently"]'::jsonb, 14)
ON CONFLICT (id) DO NOTHING;


-- 2. Insert 50 Users (auth.users + profiles + photos + trust_scores + verifications)
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000001', 'rohan.mehta@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Rohan Mehta"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000001', 'Rohan Mehta', 26, 'male', 'working', 'KPMG', 'Mumbai', 'Lower Parel',
    'Hey! I''m Rohan, 26 yo working at KPMG. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 22000, 32000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.835283, 18.981050), 4326), '2026-11-25', '11 months', NULL, 88, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1500000012345?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1510000023456?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000001', 86, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000001', 'phone', 'verified', 'msg91_1', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000001', 'kyc', 'verified', 'kyc_aadhaar_1', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000002', 'ananya.sharma@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Ananya Sharma"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000002', 'Ananya Sharma', 24, 'female', 'working', 'Google India', 'Mumbai', 'Bandra West',
    'Hey! I''m Ananya, 24 yo working at Google India. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 25000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.817108, 19.057258), 4326), '2026-11-17', '6 months', NULL, 85, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1500000024690?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1510000046912?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000002', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000002', 'phone', 'verified', 'msg91_2', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000002', 'kyc', 'verified', 'kyc_aadhaar_2', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000003', 'aditya.roy@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Aditya Roy"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000003', 'Aditya Roy', 27, 'male', 'working', 'JP Morgan', 'Mumbai', 'Powai',
    'Hey! I''m Aditya, 27 yo working at JP Morgan. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 18000, 28000, ARRAY['Powai', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.909597, 19.118948), 4326), '2026-11-24', 'Flexible', 'male', 85, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1500000037035?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1510000070368?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000003', 89, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000003', 'phone', 'verified', 'msg91_3', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000003', 'kyc', 'verified', 'kyc_aadhaar_3', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000004', 'pooja.nair@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Pooja Nair"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000004', 'Pooja Nair', 25, 'female', 'working', 'Deloitte', 'Mumbai', 'Andheri West',
    'Hey! I''m Pooja, 25 yo working at Deloitte. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 15000, 24000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.825378, 19.129636), 4326), '2026-11-23', '1 year', NULL, 97, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1500000049380?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1510000093824?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000004', 68, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 17, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000004', 'phone', 'verified', 'msg91_4', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000005', 'siddharth.joshi@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Siddharth Joshi"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000005', 'Siddharth Joshi', 23, 'male', 'student', 'IIT Bombay', 'Mumbai', 'Powai',
    'Hey! I''m Siddharth, 23 yo student at IIT Bombay. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 8000, 14000, ARRAY['Powai', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.908212, 19.126814), 4326), '2026-12-10', 'Flexible', 'male', 97, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1500000061725?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1510000117280?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000005', 67, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 19, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000005', 'phone', 'verified', 'msg91_5', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000006', 'ishaan.verma@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Ishaan Verma"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000006', 'Ishaan Verma', 28, 'male', 'working', 'Morgan Stanley', 'Mumbai', 'Goregaon East',
    'Hey! I''m Ishaan, 28 yo working at Morgan Stanley. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 18000, 26000, ARRAY['Goregaon East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.875482, 19.169856), 4326), '2026-11-28', '11 months', 'male', 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1500000074070?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1510000140736?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000006', 86, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000006', 'phone', 'verified', 'msg91_6', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000006', 'kyc', 'verified', 'kyc_aadhaar_6', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000007', 'tanvi.kulkarni@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Tanvi Kulkarni"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000007', 'Tanvi Kulkarni', 26, 'female', 'working', 'Tata Consultancy Services', 'Mumbai', 'Thane West',
    'Hey! I''m Tanvi, 26 yo working at Tata Consultancy Services. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 10000, 16000, ARRAY['Thane West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.992657, 19.228960), 4326), '2026-11-20', 'Flexible', NULL, 96, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1500000086415?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1510000164192?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000007', 70, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 17, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000007', 'phone', 'verified', 'msg91_7', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000008', 'varun.kapoor@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Varun Kapoor"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000008', 'Varun Kapoor', 29, 'male', 'freelancer', 'Self-Employed UI/UX', 'Mumbai', 'Bandra West',
    'Hey! I''m Varun, 29 yo freelancer at Self-Employed UI/UX. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'looking_together', 22000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.820785, 19.052609), 4326), '2026-12-08', '6 months', 'male', 90, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1500000098760?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1510000187648?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000008', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000008', 'phone', 'verified', 'msg91_8', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000008', 'kyc', 'verified', 'kyc_aadhaar_8', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000009', 'sneha.deshmukh@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Sneha Deshmukh"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000009', 'Sneha Deshmukh', 24, 'female', 'working', 'Nykaa', 'Mumbai', 'Lower Parel',
    'Hey! I''m Sneha, 24 yo working at Nykaa. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 20000, 30000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.821002, 18.991684), 4326), '2026-12-07', '11 months', 'female', 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1500000111105?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1510000211104?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000009', 72, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000009', 'phone', 'verified', 'msg91_9', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000010', 'aman.gupta@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Aman Gupta"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000010', 'Aman Gupta', 25, 'male', 'working', 'Flipkart', 'Mumbai', 'Andheri East',
    'Hey! I''m Aman, 25 yo working at Flipkart. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 14000, 22000, ARRAY['Andheri East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.866735, 19.100586), 4326), '2026-12-05', '1 year', NULL, 100, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1500000123450?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1510000234560?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000010', 77, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000010', 'phone', 'verified', 'msg91_10', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000010', 'kyc', 'verified', 'kyc_aadhaar_10', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000011', 'meera.iyer@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Meera Iyer"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000011', 'Meera Iyer', 27, 'female', 'working', 'HDFC Bank', 'Mumbai', 'Lower Parel',
    'Hey! I''m Meera, 27 yo working at HDFC Bank. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 22000, 32000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.820386, 18.984489), 4326), '2026-12-10', '1 year', 'female', 98, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1500000135795?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1510000258016?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000011', 93, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000011', 'phone', 'verified', 'msg91_11', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000011', 'kyc', 'verified', 'kyc_aadhaar_11', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000012', 'kabir.sen@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Kabir Sen"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000012', 'Kabir Sen', 24, 'male', 'student', 'NMIMS Mumbai', 'Mumbai', 'Andheri West',
    'Hey! I''m Kabir, 24 yo student at NMIMS Mumbai. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'looking_together', 16000, 25000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.823560, 19.151220), 4326), '2026-11-21', 'Flexible', NULL, 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1500000148140?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1510000281472?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000012', 92, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 15, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000012', 'phone', 'verified', 'msg91_12', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000012', 'kyc', 'verified', 'kyc_aadhaar_12', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000013', 'rhea.bhatia@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Rhea Bhatia"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000013', 'Rhea Bhatia', 25, 'female', 'working', 'Zomato', 'Mumbai', 'Bandra West',
    'Hey! I''m Rhea, 25 yo working at Zomato. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 24000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.833323, 19.068362), 4326), '2026-11-30', '6 months', NULL, 99, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1500000160485?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1510000304928?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000013', 81, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000013', 'phone', 'verified', 'msg91_13', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000013', 'kyc', 'verified', 'kyc_aadhaar_13', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000014', 'vikram.malhotra@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Vikram Malhotra"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000014', 'Vikram Malhotra', 30, 'male', 'working', 'L&T Infotech', 'Mumbai', 'Powai',
    'Hey! I''m Vikram, 30 yo working at L&T Infotech. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 16000, 24000, ARRAY['Powai', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.915923, 19.102944), 4326), '2026-12-10', '6 months', 'male', 93, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1500000172830?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1510000328384?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000014', 89, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000014', 'phone', 'verified', 'msg91_14', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000014', 'kyc', 'verified', 'kyc_aadhaar_14', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000015', 'divya.agarwal@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Divya Agarwal"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000015', 'Divya Agarwal', 23, 'female', 'student', 'SPJIMR', 'Mumbai', 'Andheri West',
    'Hey! I''m Divya, 23 yo student at SPJIMR. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 12000, 18000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.816047, 19.134343), 4326), '2026-12-01', '6 months', 'female', 93, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1500000185175?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1510000351840?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000015', 81, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000015', 'phone', 'verified', 'msg91_15', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000015', 'kyc', 'verified', 'kyc_aadhaar_15', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000016', 'kunal.patil@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Kunal Patil"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000016', 'Kunal Patil', 26, 'male', 'working', 'Reliance Jio', 'Mumbai', 'Navi Mumbai (Vashi)',
    'Hey! I''m Kunal, 26 yo working at Reliance Jio. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 9000, 15000, ARRAY['Navi Mumbai (Vashi)', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(73.015479, 19.088216), 4326), '2026-11-26', '11 months', NULL, 90, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000016', 'https://images.unsplash.com/photo-1500000197520?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000016', 'https://images.unsplash.com/photo-1510000375296?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000016', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000016', 'phone', 'verified', 'msg91_16', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000016', 'kyc', 'verified', 'kyc_aadhaar_16', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000017', 'shreya.ghoshal@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Shreya Ghoshal"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000017', 'Shreya Ghoshal', 28, 'female', 'freelancer', 'Voice Artist & Musician', 'Mumbai', 'Andheri West',
    'Hey! I''m Shreya, 28 yo freelancer at Voice Artist & Musician. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 20000, 30000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.830668, 19.135958), 4326), '2026-11-20', '1 year', 'female', 94, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000017', 'https://images.unsplash.com/photo-1500000209865?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000017', 'https://images.unsplash.com/photo-1510000398752?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000017', 72, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000017', 'phone', 'verified', 'msg91_17', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000018', 'nikhil.reddy@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Nikhil Reddy"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000018', 'Nikhil Reddy', 27, 'male', 'working', 'Amazon Web Services', 'Mumbai', 'Bandra West',
    'Hey! I''m Nikhil, 27 yo working at Amazon Web Services. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 25000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.840840, 19.073008), 4326), '2026-11-19', 'Flexible', 'male', 89, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000018', 'https://images.unsplash.com/photo-1500000222210?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000018', 'https://images.unsplash.com/photo-1510000422208?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000018', 69, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 20, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000018', 'phone', 'verified', 'msg91_18', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000019', 'prerna.saxena@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Prerna Saxena"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000019', 'Prerna Saxena', 25, 'female', 'working', 'Ernst & Young', 'Mumbai', 'Goregaon East',
    'Hey! I''m Prerna, 25 yo working at Ernst & Young. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 16000, 24000, ARRAY['Goregaon East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.879005, 19.156254), 4326), '2026-12-03', 'Flexible', 'female', 91, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000019', 'https://images.unsplash.com/photo-1500000234555?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000019', 'https://images.unsplash.com/photo-1510000445664?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000019', 87, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000019', 'phone', 'verified', 'msg91_19', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000019', 'kyc', 'verified', 'kyc_aadhaar_19', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000020', 'arjun.nambiar@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Arjun Nambiar"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000020', 'Arjun Nambiar', 24, 'male', 'working', 'BrowserStack', 'Mumbai', 'Andheri East',
    'Hey! I''m Arjun, 24 yo working at BrowserStack. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 15000, 22000, ARRAY['Andheri East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.884554, 19.118096), 4326), '2026-12-01', 'Flexible', NULL, 92, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000020', 'https://images.unsplash.com/photo-1500000246900?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000020', 'https://images.unsplash.com/photo-1510000469120?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000020', 67, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000020', 'phone', 'verified', 'msg91_20', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000021', 'bhavna.sethi@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Bhavna Sethi"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000021', 'Bhavna Sethi', 29, 'female', 'working', 'Standard Chartered', 'Mumbai', 'Lower Parel',
    'Hey! I''m Bhavna, 29 yo working at Standard Chartered. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 25000, 35000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.833749, 18.987203), 4326), '2026-11-24', '6 months', NULL, 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000021', 'https://images.unsplash.com/photo-1500000259245?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000021', 'https://images.unsplash.com/photo-1510000492576?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000021', 72, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000021', 'phone', 'verified', 'msg91_21', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000022', 'karan.chawla@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Karan Chawla"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000022', 'Karan Chawla', 26, 'male', 'working', 'Kotak Mahindra', 'Mumbai', 'Malad West',
    'Hey! I''m Karan, 26 yo working at Kotak Mahindra. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 12000, 19000, ARRAY['Malad West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.859589, 19.173126), 4326), '2026-11-24', '1 year', 'male', 91, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000022', 'https://images.unsplash.com/photo-1500000271590?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000022', 'https://images.unsplash.com/photo-1510000516032?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000022', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000022', 'phone', 'verified', 'msg91_22', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000022', 'kyc', 'verified', 'kyc_aadhaar_22', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000023', 'alia.fernandes@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Alia Fernandes"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000023', 'Alia Fernandes', 24, 'female', 'working', 'Vogue India', 'Mumbai', 'Bandra West',
    'Hey! I''m Alia, 24 yo working at Vogue India. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'looking_together', 25000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.842565, 19.061731), 4326), '2026-12-02', '11 months', 'female', 98, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000023', 'https://images.unsplash.com/photo-1500000283935?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000023', 'https://images.unsplash.com/photo-1510000539488?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000023', 71, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000023', 'phone', 'verified', 'msg91_23', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000024', 'gaurav.bansal@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Gaurav Bansal"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000024', 'Gaurav Bansal', 25, 'male', 'working', 'PwC India', 'Mumbai', 'Powai',
    'Hey! I''m Gaurav, 25 yo working at PwC India. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 18000, 27000, ARRAY['Powai', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.909869, 19.113229), 4326), '2026-11-30', 'Flexible', 'male', 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000024', 'https://images.unsplash.com/photo-1500000296280?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000024', 'https://images.unsplash.com/photo-1510000562944?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000024', 86, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000024', 'phone', 'verified', 'msg91_24', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000024', 'kyc', 'verified', 'kyc_aadhaar_24', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000025', 'ritika.somani@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Ritika Somani"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000025', 'Ritika Somani', 26, 'female', 'working', 'Swiggy', 'Mumbai', 'Andheri West',
    'Hey! I''m Ritika, 26 yo working at Swiggy. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 18000, 26000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.815653, 19.133379), 4326), '2026-11-27', '6 months', NULL, 91, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000025', 'https://images.unsplash.com/photo-1500000308625?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000025', 'https://images.unsplash.com/photo-1510000586400?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000025', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 18, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000025', 'phone', 'verified', 'msg91_25', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000025', 'kyc', 'verified', 'kyc_aadhaar_25', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000026', 'rahul.dravid@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Rahul Dravid"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000026', 'Rahul Dravid', 28, 'male', 'working', 'Accenture', 'Mumbai', 'Malad West',
    'Hey! I''m Rahul, 28 yo working at Accenture. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 14000, 20000, ARRAY['Malad West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.846456, 19.179356), 4326), '2026-11-24', '6 months', 'male', 88, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000026', 'https://images.unsplash.com/photo-1500000320970?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000026', 'https://images.unsplash.com/photo-1510000609856?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000026', 66, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 20, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000026', 'phone', 'verified', 'msg91_26', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000027', 'neha.kakkar@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Neha Kakkar"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000027', 'Neha Kakkar', 24, 'female', 'student', 'HR College', 'Mumbai', 'Lower Parel',
    'Hey! I''m Neha, 24 yo student at HR College. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 15000, 22000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.841181, 19.009370), 4326), '2026-11-24', '11 months', 'female', 100, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000027', 'https://images.unsplash.com/photo-1500000333315?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000027', 'https://images.unsplash.com/photo-1510000633312?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000027', 71, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 18, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000027', 'phone', 'verified', 'msg91_27', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000028', 'yash.singhania@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Yash Singhania"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000028', 'Yash Singhania', 27, 'male', 'working', 'Barclays', 'Mumbai', 'Goregaon East',
    'Hey! I''m Yash, 27 yo working at Barclays. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 17000, 25000, ARRAY['Goregaon East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.855539, 19.151365), 4326), '2026-11-29', '1 year', 'male', 99, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000028', 'https://images.unsplash.com/photo-1500000345660?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000028', 'https://images.unsplash.com/photo-1510000656768?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000028', 74, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 18, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000028', 'phone', 'verified', 'msg91_28', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000029', 'pallavi.rao@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Pallavi Rao"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000029', 'Pallavi Rao', 26, 'female', 'working', 'Mindtickle', 'Mumbai', 'Powai',
    'Hey! I''m Pallavi, 26 yo working at Mindtickle. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 16000, 24000, ARRAY['Powai', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.918820, 19.132463), 4326), '2026-12-04', 'Flexible', NULL, 94, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000029', 'https://images.unsplash.com/photo-1500000358005?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000029', 'https://images.unsplash.com/photo-1510000680224?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000029', 71, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000029', 'phone', 'verified', 'msg91_29', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000030', 'deepak.verma@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Deepak Verma"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000030', 'Deepak Verma', 25, 'male', 'working', 'Infosys', 'Mumbai', 'Thane West',
    'Hey! I''m Deepak, 25 yo working at Infosys. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 9000, 14000, ARRAY['Thane West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.985172, 19.205129), 4326), '2026-11-27', '6 months', NULL, 100, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000030', 'https://images.unsplash.com/photo-1500000370350?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000030', 'https://images.unsplash.com/photo-1510000703680?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000030', 81, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000030', 'phone', 'verified', 'msg91_30', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000030', 'kyc', 'verified', 'kyc_aadhaar_30', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000031', 'sakshi.malik@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Sakshi Malik"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000031', 'Sakshi Malik', 23, 'female', 'student', 'St. Xavier's College', 'Mumbai', 'Bandra West',
    'Hey! I''m Sakshi, 23 yo student at St. Xavier''s College. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 14000, 22000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.816206, 19.059835), 4326), '2026-11-22', '6 months', 'female', 92, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000031', 'https://images.unsplash.com/photo-1500000382695?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000031', 'https://images.unsplash.com/photo-1510000727136?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000031', 77, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 15, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000031', 'phone', 'verified', 'msg91_31', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000031', 'kyc', 'verified', 'kyc_aadhaar_31', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000032', 'ayushmann.khurana@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Ayushmann Khurana"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000032', 'Ayushmann Khurana', 29, 'male', 'freelancer', 'Creative Copywriter', 'Mumbai', 'Andheri West',
    'Hey! I''m Ayushmann, 29 yo freelancer at Creative Copywriter. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 19000, 28000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.820086, 19.139136), 4326), '2026-12-06', '6 months', 'male', 95, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000032', 'https://images.unsplash.com/photo-1500000395040?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000032', 'https://images.unsplash.com/photo-1510000750592?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000032', 94, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000032', 'phone', 'verified', 'msg91_32', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000032', 'kyc', 'verified', 'kyc_aadhaar_32', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000033', 'natasha.dsouza@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Natasha D'Souza"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000033', 'Natasha D'Souza', 25, 'female', 'working', 'Ogilvy & Mather', 'Mumbai', 'Bandra West',
    'Hey! I''m Natasha, 25 yo working at Ogilvy & Mather. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 22000, 32000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.834592, 19.054026), 4326), '2026-11-25', 'Flexible', NULL, 94, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000033', 'https://images.unsplash.com/photo-1500000407385?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000033', 'https://images.unsplash.com/photo-1510000774048?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000033', 79, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000033', 'phone', 'verified', 'msg91_33', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000033', 'kyc', 'verified', 'kyc_aadhaar_33', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000034', 'harsh.vardhan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Harsh Vardhan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000034', 'Harsh Vardhan', 26, 'male', 'working', 'Goldman Sachs', 'Mumbai', 'Lower Parel',
    'Hey! I''m Harsh, 26 yo working at Goldman Sachs. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 26000, 35000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.816379, 18.998935), 4326), '2026-12-05', '6 months', NULL, 91, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000034', 'https://images.unsplash.com/photo-1500000419730?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000034', 'https://images.unsplash.com/photo-1510000797504?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000034', 81, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000034', 'phone', 'verified', 'msg91_34', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000034', 'kyc', 'verified', 'kyc_aadhaar_34', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000035', 'simran.kaur@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Simran Kaur"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000035', 'Simran Kaur', 24, 'female', 'working', 'Cult.fit', 'Mumbai', 'Andheri East',
    'Hey! I''m Simran, 24 yo working at Cult.fit. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 13000, 20000, ARRAY['Andheri East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.882698, 19.125026), 4326), '2026-11-24', '1 year', NULL, 99, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000035', 'https://images.unsplash.com/photo-1500000432075?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000035', 'https://images.unsplash.com/photo-1510000820960?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000035', 91, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000035', 'phone', 'verified', 'msg91_35', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000035', 'kyc', 'verified', 'kyc_aadhaar_35', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000036', 'manish.tiwari@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Manish Tiwari"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000036', 'Manish Tiwari', 27, 'male', 'working', 'Tata Motors', 'Mumbai', 'Thane West',
    'Hey! I''m Manish, 27 yo working at Tata Motors. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 10000, 16000, ARRAY['Thane West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.972176, 19.232816), 4326), '2026-12-07', '6 months', 'male', 94, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000036', 'https://images.unsplash.com/photo-1500000444420?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000036', 'https://images.unsplash.com/photo-1510000844416?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000036', 94, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000036', 'phone', 'verified', 'msg91_36', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000036', 'kyc', 'verified', 'kyc_aadhaar_36', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000037', 'tara.sutaria@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Tara Sutaria"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000037', 'Tara Sutaria', 25, 'female', 'freelancer', 'Fashion Stylist', 'Mumbai', 'Bandra West',
    'Hey! I''m Tara, 25 yo freelancer at Fashion Stylist. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'looking_together', 22000, 32000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.842668, 19.048629), 4326), '2026-11-20', '6 months', 'female', 89, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000037', 'https://images.unsplash.com/photo-1500000456765?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000037', 'https://images.unsplash.com/photo-1510000867872?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000037', 73, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 17, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000037', 'phone', 'verified', 'msg91_37', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000038', 'abhishek.bachchan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Abhishek Bachchan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000038', 'Abhishek Bachchan', 28, 'male', 'working', 'Zee Entertainment', 'Mumbai', 'Andheri West',
    'Hey! I''m Abhishek, 28 yo working at Zee Entertainment. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 18000, 28000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.819019, 19.131586), 4326), '2026-12-08', '1 year', 'male', 93, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000038', 'https://images.unsplash.com/photo-1500000469110?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000038', 'https://images.unsplash.com/photo-1510000891328?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000038', 93, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 15, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000038', 'phone', 'verified', 'msg91_38', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000038', 'kyc', 'verified', 'kyc_aadhaar_38', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000039', 'kritika.kamra@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Kritika Kamra"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000039', 'Kritika Kamra', 26, 'female', 'working', 'Unilever', 'Mumbai', 'Lower Parel',
    'Hey! I''m Kritika, 26 yo working at Unilever. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 24000, 34000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.835129, 19.005180), 4326), '2026-11-18', '6 months', NULL, 89, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000039', 'https://images.unsplash.com/photo-1500000481455?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000039', 'https://images.unsplash.com/photo-1510000914784?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000039', 85, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000039', 'phone', 'verified', 'msg91_39', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000039', 'kyc', 'verified', 'kyc_aadhaar_39', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000040', 'sameer.khan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Sameer Khan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000040', 'Sameer Khan', 25, 'male', 'working', 'CleverTap', 'Mumbai', 'Andheri East',
    'Hey! I''m Sameer, 25 yo working at CleverTap. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 15000, 23000, ARRAY['Andheri East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.876937, 19.115150), 4326), '2026-11-30', '6 months', NULL, 89, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000040', 'https://images.unsplash.com/photo-1500000493800?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000040', 'https://images.unsplash.com/photo-1510000938240?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000040', 82, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 15, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000040', 'phone', 'verified', 'msg91_40', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000040', 'kyc', 'verified', 'kyc_aadhaar_40', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000041', 'anushka.sen@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Anushka Sen"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000041', 'Anushka Sen', 23, 'female', 'student', 'Mithibai College', 'Mumbai', 'Andheri West',
    'Hey! I''m Anushka, 23 yo student at Mithibai College. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 12000, 18000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.830175, 19.125743), 4326), '2026-11-21', '6 months', NULL, 86, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000041', 'https://images.unsplash.com/photo-1500000506145?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000041', 'https://images.unsplash.com/photo-1510000961696?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000041', 93, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 17, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000041', 'phone', 'verified', 'msg91_41', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000041', 'kyc', 'verified', 'kyc_aadhaar_41', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000042', 'farhan.akhtar@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Farhan Akhtar"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000042', 'Farhan Akhtar', 29, 'male', 'freelancer', 'Independent Filmmaker', 'Mumbai', 'Bandra West',
    'Hey! I''m Farhan, 29 yo freelancer at Independent Filmmaker. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 25000, 35000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.834962, 19.064608), 4326), '2026-11-28', 'Flexible', 'male', 89, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000042', 'https://images.unsplash.com/photo-1500000518490?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000042', 'https://images.unsplash.com/photo-1510000985152?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000042', 94, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 16, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000042', 'phone', 'verified', 'msg91_42', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000042', 'kyc', 'verified', 'kyc_aadhaar_42', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000043', 'rupali.ganguly@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Rupali Ganguly"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000043', 'Rupali Ganguly', 27, 'female', 'working', 'ICICI Bank', 'Mumbai', 'Malad West',
    'Hey! I''m Rupali, 27 yo working at ICICI Bank. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 13000, 20000, ARRAY['Malad West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.863086, 19.195323), 4326), '2026-11-30', '6 months', NULL, 95, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000043', 'https://images.unsplash.com/photo-1500000530835?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000043', 'https://images.unsplash.com/photo-1510001008608?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000043', 90, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 18, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000043', 'phone', 'verified', 'msg91_43', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000043', 'kyc', 'verified', 'kyc_aadhaar_43', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000044', 'tejas.shinde@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Tejas Shinde"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000044', 'Tejas Shinde', 24, 'male', 'working', 'Capgemini', 'Mumbai', 'Navi Mumbai (Vashi)',
    'Hey! I''m Tejas, 24 yo working at Capgemini. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 8500, 14000, ARRAY['Navi Mumbai (Vashi)', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(73.014022, 19.086422), 4326), '2026-11-25', '11 months', 'male', 88, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000044', 'https://images.unsplash.com/photo-1500000543180?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000044', 'https://images.unsplash.com/photo-1510001032064?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000044', 77, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 15, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000044', 'phone', 'verified', 'msg91_44', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000044', 'kyc', 'verified', 'kyc_aadhaar_44', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000045', 'isha.ambani@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Isha Ambani"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000045', 'Isha Ambani', 26, 'female', 'working', 'McKinsey & Co', 'Mumbai', 'Lower Parel',
    'Hey! I''m Isha, 26 yo working at McKinsey & Co. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 26000, 35000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.822773, 19.004798), 4326), '2026-12-01', '1 year', NULL, 92, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000045', 'https://images.unsplash.com/photo-1500000555525?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000045', 'https://images.unsplash.com/photo-1510001055520?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000045', 72, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000045', 'phone', 'verified', 'msg91_45', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000046', 'kartik.aaryan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Kartik Aaryan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000046', 'Kartik Aaryan', 27, 'male', 'working', 'Hotstar / Disney', 'Mumbai', 'Andheri West',
    'Hey! I''m Kartik, 27 yo working at Hotstar / Disney. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 20000, 30000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.818494, 19.131148), 4326), '2026-11-19', '1 year', NULL, 97, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000046', 'https://images.unsplash.com/photo-1500000567870?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000046', 'https://images.unsplash.com/photo-1510001078976?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000046', 86, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000046', 'phone', 'verified', 'msg91_46', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000046', 'kyc', 'verified', 'kyc_aadhaar_46', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000047', 'radhika.madan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Radhika Madan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000047', 'Radhika Madan', 25, 'female', 'working', 'Nykaa Fashion', 'Mumbai', 'Bandra West',
    'Hey! I''m Radhika, 25 yo working at Nykaa Fashion. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 20000, 30000, ARRAY['Bandra West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.842677, 19.048060), 4326), '2026-11-25', '11 months', 'female', 93, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000047', 'https://images.unsplash.com/photo-1500000580215?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000047', 'https://images.unsplash.com/photo-1510001102432?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000047', 66, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 15, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000047', 'phone', 'verified', 'msg91_47', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000048', 'devendra.fadnavis@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Devendra Fadnavis"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000048', 'Devendra Fadnavis', 28, 'male', 'working', 'Government Analyst', 'Mumbai', 'Lower Parel',
    'Hey! I''m Devendra, 28 yo working at Government Analyst. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 18000, 27000, ARRAY['Lower Parel', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.829137, 19.002156), 4326), '2026-11-27', 'Flexible', 'male', 88, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000048', 'https://images.unsplash.com/photo-1500000592560?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000048', 'https://images.unsplash.com/photo-1510001125888?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000048', 77, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 19, "response_rate": 8}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000048', 'phone', 'verified', 'msg91_48', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000048', 'kyc', 'verified', 'kyc_aadhaar_48', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000049', 'trisha.krishnan@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Trisha Krishnan"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000049', 'Trisha Krishnan', 26, 'female', 'working', 'Sony Pictures', 'Mumbai', 'Andheri West',
    'Hey! I''m Trisha, 26 yo working at Sony Pictures. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'have_room', 18000, 28000, ARRAY['Andheri West', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.820342, 19.142564), 4326), '2026-11-17', '11 months', NULL, 87, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000049', 'https://images.unsplash.com/photo-1500000604905?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000049', 'https://images.unsplash.com/photo-1510001149344?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000049', 95, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 9}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000049', 'phone', 'verified', 'msg91_49', now() - interval '10 days')
ON CONFLICT DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000049', 'kyc', 'verified', 'kyc_aadhaar_49', now() - interval '8 days')
ON CONFLICT DO NOTHING;
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('00000000-0000-0000-0000-000000000050', 'vivek.oberoi@flatfit.demo', 'mock_hash_pw_123456', now(), '{"full_name": "Vivek Oberoi"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '00000000-0000-0000-0000-000000000050', 'Vivek Oberoi', 27, 'male', 'working', 'Adani Power', 'Mumbai', 'Goregaon East',
    'Hey! I''m Vivek, 27 yo working at Adani Power. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes.', 'need_room', 15000, 24000, ARRAY['Goregaon East', 'Nearby Metro'],
    ST_SetSRID(ST_MakePoint(72.869295, 19.171202), 4326), '2026-11-20', '1 year', 'male', 98, true
) ON CONFLICT (id) DO NOTHING;
INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('00000000-0000-0000-0000-000000000050', 'https://images.unsplash.com/photo-1500000617250?auto=format&fit=crop&w=600&q=80', 1, true),
       ('00000000-0000-0000-0000-000000000050', 'https://images.unsplash.com/photo-1510001172800?auto=format&fit=crop&w=600&q=80', 2, false)
ON CONFLICT DO NOTHING;
INSERT INTO trust_scores (user_id, score, factors)
VALUES ('00000000-0000-0000-0000-000000000050', 75, '{"profile_complete": 20, "phone_verified": 15, "kyc_done": 0, "reviews_avg": 18, "response_rate": 10}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('00000000-0000-0000-0000-000000000050', 'phone', 'verified', 'msg91_50', now() - interval '10 days')
ON CONFLICT DO NOTHING;


-- 3. Insert Questionnaire Answers for All 50 Users
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000006', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000007', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000008', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000009', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000010', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000008', 'Lively music / parties welcome', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000011', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000012', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000013', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000014', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000015', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000016', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000017', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000008', 'Lively music / parties welcome', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000018', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000019', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000020', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000021', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000022', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000023', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000024', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000025', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000008', 'Lively music / parties welcome', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000026', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000027', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000028', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000029', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000030', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000031', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000032', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000033', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000034', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000035', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000036', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000037', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000038', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000039', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000040', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000041', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000042', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000002', 'Regularly tidy (clean up weekly)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000007', 'Open door / friends welcome anytime', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000043', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000044', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000008', 'Lively music / parties welcome', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000013', 'Extrovert (love hanging out in living room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000045', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000003', 'Strict Vegetarian', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000005', 'Balcony smoking is fine', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000008', 'Lively music / parties welcome', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000010', 'Full-time in office', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000046', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000001', 'Early bird (Sleep before 11 PM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000006', 'Non-drinker / alcohol-free home', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000007', 'Casual daytime visits only', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000012', 'Between 1st and 5th', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000047', '11111111-0000-0000-0000-000000000014', 'Give space and resolve gently', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000001', 'Moderate (Sleep 11 PM - 1 AM)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000002', 'Meticulous / neat freak', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000004', 'Mostly order in / tiffin service', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000009', 'Planning to bring my own pet', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000011', 'Rotate paying bills', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000012', 'Within first 10 days upon salary', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000013', 'Ambivert (mix of alone time & casual chats)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000048', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian ok in kitchen', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000004', 'Hire a common cook', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000005', 'Strictly non-smoking flat', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000006', 'Occasional / social drinker', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000008', 'Moderate ambient noise / music with earphones', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000009', 'No pets allowed / allergic', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000010', 'Hybrid (2-3 days WFH)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000011', 'Instant settlement on arrival', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000049', '11111111-0000-0000-0000-000000000014', 'Direct, calm 1-on-1 discussion', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000001', 'Night owl (Sleep after 1 AM)', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000002', 'Relaxed (clean when it gets messy)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000003', 'Non-Vegetarian (regularly cook/eat meat)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000004', 'Self-cooking individually', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000005', 'Smoking inside room is ok', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000006', 'Regular weekend drinks with friends', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000007', 'Prior notice & consent needed', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000008', 'Pin-drop silence preferred', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000009', 'Love pets, ok to have dogs/cats', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000010', '100% remote / full-time WFH', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000011', 'Splitwise / monthly settlement', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000012', 'Strictly on or before 1st of month', 'nice_to_have')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000013', 'Introvert (quiet time in my own room)', 'deal_breaker')
ON CONFLICT (user_id, question_id) DO NOTHING;
INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('00000000-0000-0000-0000-000000000050', '11111111-0000-0000-0000-000000000014', 'Group chat / house meeting', 'important')
ON CONFLICT (user_id, question_id) DO NOTHING;


-- 4. Insert 15 Realistic Listings with Photos and Amenities
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'have_room', 'Master Bedroom in Luxury 3BHK Hiranandani', 'Looking for a friendly, respectful flatmate for this lovely single room in Powai. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 32000, 60000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.915092, 19.121977), 4326), 'Powai', 'Mumbai', 'Tower B, Flat 942, Powai',
    'single', '2026-11-30', 91, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 3, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000001', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'have_room', 'Private Room with Attached Balcony in Bandra West', 'Looking for a friendly, respectful flatmate for this lovely single room in Bandra West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 28000, 50000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.829847, 19.052167), 4326), 'Bandra West', 'Mumbai', 'Tower B, Flat 1304, Bandra West',
    'single', '2026-12-01', 83, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 1, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Balcony') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000002', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000004', 'have_room', 'Spacious Shared Room near Metro Station', 'Looking for a friendly, respectful flatmate for this lovely shared room in Andheri West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 14000, 25000, 1500.00, 'semi_furnished',
    ST_SetSRID(ST_MakePoint(72.836395, 19.130809), 4326), 'Andheri West', 'Mumbai', 'Tower B, Flat 682, Andheri West',
    'shared', '2026-11-30', 80, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000003', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000003', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 'have_room', 'Sunlit 1RK Studio for Working Professional', 'Looking for a friendly, respectful flatmate for this lovely single room in Lower Parel. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 24000, 45000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.822969, 18.998120), 4326), 'Lower Parel', 'Mumbai', 'Tower B, Flat 1290, Lower Parel',
    'single', '2026-12-02', 82, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 1, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000004', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Balcony') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000004', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000006', 'have_room', 'Furnished Bedroom in Gated Society near Nesco', 'Looking for a friendly, respectful flatmate for this lovely single room in Goregaon East. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 19000, 35000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.868623, 19.171639), 4326), 'Goregaon East', 'Mumbai', 'Tower B, Flat 1366, Goregaon East',
    'single', '2026-11-27', 98, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 1, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000005', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Geyser') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000005', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', 'have_room', 'Peaceful Room in 2BHK near Inorbit Mall', 'Looking for a friendly, respectful flatmate for this lovely single room in Malad West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 15000, 30000, 1500.00, 'semi_furnished',
    ST_SetSRID(ST_MakePoint(72.847871, 19.189772), 4326), 'Malad West', 'Mumbai', 'Tower B, Flat 1001, Malad West',
    'single', '2026-11-19', 91, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000006', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Geyser') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000006', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000016', 'have_room', 'Modern Bedroom in High-Rise near Vashi Station', 'Looking for a friendly, respectful flatmate for this lovely single room in Navi Mumbai (Vashi). Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 11000, 20000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(73.012607, 19.069715), 4326), 'Navi Mumbai (Vashi)', 'Mumbai', 'Tower B, Flat 1155, Navi Mumbai (Vashi)',
    'single', '2026-11-25', 95, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 1, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000007', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Geyser') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000007', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000007', 'have_room', 'Twin Sharing Room for Female Flatmate in Thane', 'Looking for a friendly, respectful flatmate for this lovely shared room in Thane West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 9500, 18000, 1500.00, 'semi_furnished',
    ST_SetSRID(ST_MakePoint(72.969112, 19.227208), 4326), 'Thane West', 'Mumbai', 'Tower B, Flat 609, Thane West',
    'shared', '2026-11-27', 83, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000008', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Geyser') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Balcony') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000008', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000002', 'have_room', 'Chic Studio Room with Sea Breeze near Carter Road', 'Looking for a friendly, respectful flatmate for this lovely single room in Bandra West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 34000, 70000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.819964, 19.068505), 4326), 'Bandra West', 'Mumbai', 'Tower B, Flat 1037, Bandra West',
    'single', '2026-11-30', 85, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "allowed"}'::jsonb, 1, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000009', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'Balcony') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000009', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', 'have_room', 'Cozy Single Room in Oberoi Splendor', 'Looking for a friendly, respectful flatmate for this lovely single room in Andheri East. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 21000, 40000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.876643, 19.112219), 4326), 'Andheri East', 'Mumbai', 'Tower B, Flat 850, Andheri East',
    'single', '2026-11-22', 90, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000010', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'Geyser') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000010', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000005', 'have_room', 'Affordable Single Room in 3BHK near IIT Main Gate', 'Looking for a friendly, respectful flatmate for this lovely single room in Powai. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 16000, 30000, 1500.00, 'semi_furnished',
    ST_SetSRID(ST_MakePoint(72.906164, 19.109071), 4326), 'Powai', 'Mumbai', 'Tower B, Flat 1023, Powai',
    'single', '2026-11-30', 95, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000011', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'Air Conditioner') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000011', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000001', 'have_room', 'Penthouse Terrace Room with Panoramic View', 'Looking for a friendly, respectful flatmate for this lovely single room in Lower Parel. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 35000, 75000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.839879, 19.000399), 4326), 'Lower Parel', 'Mumbai', 'Tower B, Flat 1334, Lower Parel',
    'single', '2026-11-20', 94, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000012', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'Balcony') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000012', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000006', 'have_room', 'Airy Master Bedroom in Royal Palms', 'Looking for a friendly, respectful flatmate for this lovely master room in Goregaon East. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 17000, 32000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.864740, 19.168425), 4326), 'Goregaon East', 'Mumbai', 'Tower B, Flat 387, Goregaon East',
    'master', '2026-11-30', 88, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 3, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000013', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Maid Service') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', '24x7 Security') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000013', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000004', 'have_room', 'Cozy Shared Room near Lokhandwala Market', 'Looking for a friendly, respectful flatmate for this lovely shared room in Andheri West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 13500, 24000, 1500.00, 'fully_furnished',
    ST_SetSRID(ST_MakePoint(72.827497, 19.137558), 4326), 'Andheri West', 'Mumbai', 'Tower B, Flat 135, Andheri West',
    'shared', '2026-11-29', 89, true, '{"smoking_allowed": "balcony_only", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "not_allowed"}'::jsonb, 2, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000014', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'Cook Available') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'High Speed WiFi') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000014', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '22222222-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000007', 'have_room', 'Bright 2BHK Flatmate Wanted in Korum Mall Vicinity', 'Looking for a friendly, respectful flatmate for this lovely single room in Thane West. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent.', 12000, 22000, 1500.00, 'semi_furnished',
    ST_SetSRID(ST_MakePoint(72.987441, 19.223958), 4326), 'Thane West', 'Mumbai', 'Tower B, Flat 1283, Thane West',
    'single', '2026-12-02', 85, true, '{"smoking_allowed": "no", "overnight_guests": "with_advance_notice", "loud_music": "quiet_after_11pm", "pets": "allowed"}'::jsonb, 3, 'active'
) ON CONFLICT (id) DO NOTHING;
INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('22222222-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('22222222-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('22222222-0000-0000-0000-000000000015', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'Car Parking') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'Power Backup') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'Washing Machine') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'RO Water Purifier') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'Gym Access') ON CONFLICT DO NOTHING;
INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('22222222-0000-0000-0000-000000000015', 'Air Conditioner') ON CONFLICT DO NOTHING;


-- 5. Insert Sample Flat 'Sunshine 301' with 3 Members, 10 Expenses, 5 Chores, Calendar, Notices
INSERT INTO flats (id, name, listing_id, address, city)
VALUES ('33333333-0000-0000-0000-000000000001', 'Sunshine 301', '22222222-0000-0000-0000-000000000001', 'Flat 301, Sunshine Heights, Central Avenue, Powai', 'Mumbai')
ON CONFLICT (id) DO NOTHING;
INSERT INTO flat_members (flat_id, user_id, role, joined_at)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'admin', now() - interval '90 days'),
       ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'member', now() - interval '90 days'),
       ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'member', now() - interval '60 days')
ON CONFLICT (flat_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'November Apartment Rent', 66000.0, 'rent', '2026-10-31')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 22000.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 22000.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 22000.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000002', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Electricity Bill (Adani Electricity)', 4200.0, 'electricity', '2026-11-02')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 1400.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000003', 1400.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 1400.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000003', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'JioFiber High-Speed WiFi 300Mbps', 1179.0, 'wifi', '2026-11-04')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 393.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', 393.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000006', 393.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000004', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Cook Monthly Salary (Asha Bai)', 9000.0, 'cook', '2026-11-05')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 3000.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000003', 3000.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000006', 3000.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000005', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Maid Cleaning & Utensils Salary', 4500.0, 'maid', '2026-11-05')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000001', 1500.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000003', 1500.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000006', 1500.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000006', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'Nature's Basket Monthly Groceries & Spices', 5430.0, 'groceries', '2026-11-07')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000001', 1810.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000003', 1810.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000006', 1810.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000007', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'HP Gas Cylinder Refill', 950.0, 'other', '2026-11-08')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000001', 316.67, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000003', 316.67, false, NULL),
       ('44444444-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000006', 316.67, false, NULL)
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000008', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Bisleri 20L Water Cans (10 pack)', 800.0, 'groceries', '2026-11-09')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000001', 266.67, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000003', 266.67, false, NULL),
       ('44444444-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000006', 266.67, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000009', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'Living Room Cleaning Supplies & Detergents', 650.0, 'other', '2026-11-10')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000001', 216.67, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000003', 216.67, false, NULL),
       ('44444444-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000006', 216.67, false, NULL)
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('44444444-0000-0000-0000-000000000010', '33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Society Deep Tank Cleaning Contribution', 1500.0, 'other', '2026-11-11')
ON CONFLICT (id) DO NOTHING;
INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('44444444-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 500.0, true, now() - interval '2 days'),
       ('44444444-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000003', 500.0, false, NULL),
       ('44444444-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000006', 500.0, true, now() - interval '2 days')
ON CONFLICT (expense_id, user_id) DO NOTHING;
INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('55555555-0000-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 'Kitchen Counter & Stove Deep Clean', 'weekly')
ON CONFLICT (id) DO NOTHING;
INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('55555555-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', '2026-11-13', now() - interval '1 day')
ON CONFLICT DO NOTHING;
INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('55555555-0000-0000-0000-000000000002', '33333333-0000-0000-0000-000000000001', 'Living Room Dusting & Balcony Sweep', 'weekly')
ON CONFLICT (id) DO NOTHING;
INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('55555555-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000003', '2026-11-14', now() - interval '1 day')
ON CONFLICT DO NOTHING;
INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('55555555-0000-0000-0000-000000000003', '33333333-0000-0000-0000-000000000001', 'Trash & Wet Waste Disposal', 'daily')
ON CONFLICT (id) DO NOTHING;
INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('55555555-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000006', '2026-11-15', NULL)
ON CONFLICT DO NOTHING;
INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('55555555-0000-0000-0000-000000000004', '33333333-0000-0000-0000-000000000001', 'Restock Groceries & Drinking Water', 'weekly')
ON CONFLICT (id) DO NOTHING;
INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('55555555-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', '2026-11-16', NULL)
ON CONFLICT DO NOTHING;
INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('55555555-0000-0000-0000-000000000005', '33333333-0000-0000-0000-000000000001', 'Bathroom Deep Sanitization', 'monthly')
ON CONFLICT (id) DO NOTHING;
INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('55555555-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000003', '2026-11-17', NULL)
ON CONFLICT DO NOTHING;
INSERT INTO calendar_events (flat_id, user_id, title, type, start_time, end_time)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Guest Staying Over (College Friend)', 'guest', '2026-11-14 10:00:00+05:30', '2026-11-14 14:00:00+05:30')
ON CONFLICT DO NOTHING;
INSERT INTO calendar_events (flat_id, user_id, title, type, start_time, end_time)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Society Annual Pest Control Service', 'maintenance', '2026-11-16 10:00:00+05:30', '2026-11-16 14:00:00+05:30')
ON CONFLICT DO NOTHING;
INSERT INTO calendar_events (flat_id, user_id, title, type, start_time, end_time)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'Weekend Movie Night & Pizza Gathering', 'party', '2026-11-18 10:00:00+05:30', '2026-11-18 14:00:00+05:30')
ON CONFLICT DO NOTHING;
INSERT INTO calendar_events (flat_id, user_id, title, type, start_time, end_time)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Scheduled Power Maintenance (10 AM - 1 PM)', 'power_cut', '2026-11-20 10:00:00+05:30', '2026-11-20 14:00:00+05:30')
ON CONFLICT DO NOTHING;
INSERT INTO notices (flat_id, user_id, content, is_pinned)
VALUES ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Reminder: Society gate closes for delivery riders at 11:30 PM. Please collect late orders at security desk.', true),
       ('33333333-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Asha Bai (cook) informed she will be on leave this coming Sunday for Diwali shopping.', false)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Amul Taaza Milk 1L x 4', '00000000-0000-0000-0000-000000000001', false)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Brown Bread Loaf', '00000000-0000-0000-0000-000000000003', true)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Tata Salt & Black Pepper refill', '00000000-0000-0000-0000-000000000006', false)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Vim Dishwash Gel 750ml', '00000000-0000-0000-0000-000000000001', true)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Nescafe Classic Coffee Jar', '00000000-0000-0000-0000-000000000003', false)
ON CONFLICT DO NOTHING;
INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('33333333-0000-0000-0000-000000000001', 'Eggs (Tray of 30)', '00000000-0000-0000-0000-000000000006', true)
ON CONFLICT DO NOTHING;
INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('33333333-0000-0000-0000-000000000001', 'Samsung Microwave Oven 28L', '00000000-0000-0000-0000-000000000001', 9500.0, '2024-02-15')
ON CONFLICT DO NOTHING;
INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('33333333-0000-0000-0000-000000000001', 'Whirlpool 265L Refrigerator', '00000000-0000-0000-0000-000000000003', 22000.0, '2024-01-10')
ON CONFLICT DO NOTHING;
INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('33333333-0000-0000-0000-000000000001', 'IKEA Ektorp 3-Seater Sofa', '00000000-0000-0000-0000-000000000006', 18500.0, '2024-03-01')
ON CONFLICT DO NOTHING;
INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('33333333-0000-0000-0000-000000000001', 'TP-Link Archer WiFi 6 Router', '00000000-0000-0000-0000-000000000001', 3800.0, '2024-02-01')
ON CONFLICT DO NOTHING;
INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('33333333-0000-0000-0000-000000000001', 'Kent Grand Plus RO Water Purifier', '00000000-0000-0000-0000-000000000003', 14000.0, '2024-01-20')
ON CONFLICT DO NOTHING;


-- 6. Insert Precomputed Matches for Demo
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 94, ARRAY['cleanliness', 'sleep', 'bills', 'rent_punctuality'], ARRAY['drinking'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 88, ARRAY['food', 'cleanliness', 'wfh', 'conflict'], ARRAY['guests'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004', 92, ARRAY['sleep', 'cleanliness', 'introvert_extrovert', 'pets'], ARRAY['cooking'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000009', 89, ARRAY['cleanliness', 'bills', 'food', 'noise'], ARRAY['wfh'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000006', 91, ARRAY['cleanliness', 'rent_punctuality', 'bills', 'sleep'], ARRAY['noise'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000011', 86, ARRAY['sleep', 'wfh', 'introvert_extrovert'], ARRAY['cooking'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000010', 84, ARRAY['food', 'bills', 'rent_punctuality'], ARRAY['sleep'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000016', 90, ARRAY['bills', 'cleanliness', 'conflict'], ARRAY['drinking'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000018', 93, ARRAY['introvert_extrovert', 'wfh', 'noise', 'cleanliness'], ARRAY['pets'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;
INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('00000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000014', 87, ARRAY['food', 'sleep', 'bills'], ARRAY['guests'])
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;


-- 7. Insert Sample Conversations and Messages
INSERT INTO conversations (id, type)
VALUES ('66666666-0000-0000-0000-000000000001', 'direct'), ('66666666-0000-0000-0000-000000000002', 'direct')
ON CONFLICT (id) DO NOTHING;
INSERT INTO conversation_members (conversation_id, user_id)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'), ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003'),
       ('66666666-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002'), ('66666666-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004')
ON CONFLICT DO NOTHING;
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Hey Aditya! Saw your profile on FlatFit, 94% compatibility! Are you still looking for a flatmate in Powai?', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Hey Rohan! Yes absolutely. We have a vacant bedroom in Sunshine 301. Clean place, chill vibe, cook already set up.', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Sounds ideal. I work at KPMG in Lower Parel, but love Powai''s greenery and calm weekends. How do you guys manage utility bills?', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'We split equally on FlatFit / Splitwise at the end of each month. Rent is strictly on the 1st. Want to drop by this Saturday around 4 PM to check out the room?', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Saturday 4 PM works perfectly for me. See you then!', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'Hi Pooja! Your Bandra preferences matched mine closely. Are you looking to team up for a 2BHK hunt?', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004', 'Hey Ananya! Yes, looking around Pali Hill or Bandra West near Linking Road. Budget around 25k each.', 'text');
INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('66666666-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'That aligns with my budget too! Let''s shortlist a few properties together this week.', 'text');


-- 8. Insert Service Partners and City Guides
INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('Urban Company Home Services', 'cleaning', 'Mumbai', 4.8, 1240, '+918001234567', 'support@urbancompany.com')
ON CONFLICT DO NOTHING;
INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('Porter Flat Shifting & Mini Trucks', 'movers', 'Mumbai', 4.7, 850, '+918002345678', 'help@porter.in')
ON CONFLICT DO NOTHING;
INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('Rentomojo Furniture & Appliance Rental', 'furniture_rental', 'Mumbai', 4.6, 620, '+918003456789', 'care@rentomojo.com')
ON CONFLICT DO NOTHING;
INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('CookFind Mumbai Home Cooks', 'cook', 'Mumbai', 4.5, 410, '+918004567890', 'cooks@cookfind.in')
ON CONFLICT DO NOTHING;
INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('UrbanClap AC Repair & Servicing', 'repairs', 'Mumbai', 4.7, 980, '+918005678901', 'service@urbanclap.com')
ON CONFLICT DO NOTHING;
INSERT INTO city_guides (city, locality, budget_range, vibe, commute_info)
VALUES ('Mumbai', 'Bandra West', '25000-45000', 'Vibrant, cultural, cafe paradise, seafront promenades', '{"metro": "Bandra station 10 mins", "sea_link": "5 mins to Worli", "nightlife": "Top tier"}'::jsonb)
ON CONFLICT DO NOTHING;
INSERT INTO city_guides (city, locality, budget_range, vibe, commute_info)
VALUES ('Mumbai', 'Powai', '16000-30000', 'Lakeside views, IT tech hub, startup culture, organized township', '{"metro": "JVLR metro line", "lake": "Powai lake jogging track", "vibe": "Cosmopolitan & green"}'::jsonb)
ON CONFLICT DO NOTHING;
INSERT INTO city_guides (city, locality, budget_range, vibe, commute_info)
VALUES ('Mumbai', 'Lower Parel', '22000-40000', 'Corporate financial hub, high-rises, luxury dining, central location', '{"metro": "Monorail & Western Line", "malls": "Phoenix Palladium", "work": "Walking distance to major banks"}'::jsonb)
ON CONFLICT DO NOTHING;
INSERT INTO city_guides (city, locality, budget_range, vibe, commute_info)
VALUES ('Mumbai', 'Andheri West', '14000-26000', 'Media hub, metro connectivity, lively street food, affordable dining', '{"metro": "Versova-Ghatkopar Line 1", "rail": "Andheri terminal", "hangouts": "Lokhandwala complex"}'::jsonb)
ON CONFLICT DO NOTHING;

-- End of seed.sql
