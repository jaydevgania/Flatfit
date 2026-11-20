# d:\Codestar30\flatfit\supabase\seed\generate_seed.py
import json
import uuid
import random
from datetime import datetime, date, timedelta

# Deterministic random seed for reproducible demo data
random.seed(42)

def gen_uuid():
    return str(uuid.uuid4())

# 1. Questions definition
QUESTIONS = [
    {
        "id": "11111111-0000-0000-0000-000000000001",
        "topic": "sleep",
        "text": "What is your typical sleep schedule on weekdays?",
        "text_hi": "सप्ताह के दिनों में आपका सोने का सामान्य समय क्या है?",
        "options": ["Early bird (Sleep before 11 PM)", "Moderate (Sleep 11 PM - 1 AM)", "Night owl (Sleep after 1 AM)"],
        "order": 1
    },
    {
        "id": "11111111-0000-0000-0000-000000000002",
        "topic": "cleanliness",
        "text": "How clean and organized do you keep shared spaces?",
        "text_hi": "आप साझा कमरों को कितना साफ और व्यवस्थित रखते हैं?",
        "options": ["Meticulous / neat freak", "Regularly tidy (clean up weekly)", "Relaxed (clean when it gets messy)"],
        "order": 2
    },
    {
        "id": "11111111-0000-0000-0000-000000000003",
        "topic": "food",
        "text": "What are your dietary preferences?",
        "text_hi": "आपकी खान-पान की प्राथमिकता क्या है?",
        "options": ["Strict Vegetarian", "Non-Vegetarian ok in kitchen", "Non-Vegetarian (regularly cook/eat meat)"],
        "order": 3
    },
    {
        "id": "11111111-0000-0000-0000-000000000004",
        "topic": "cooking",
        "text": "How do you plan to manage meals and cooking?",
        "text_hi": "आप भोजन और खाना पकाने की व्यवस्था कैसे करेंगे?",
        "options": ["Hire a common cook", "Self-cooking individually", "Mostly order in / tiffin service"],
        "order": 4
    },
    {
        "id": "11111111-0000-0000-0000-000000000005",
        "topic": "smoking",
        "text": "What is your stance on smoking in the flat?",
        "text_hi": "फ्लैट में धूम्रपान को लेकर आपकी क्या राय है?",
        "options": ["Strictly non-smoking flat", "Balcony smoking is fine", "Smoking inside room is ok"],
        "order": 5
    },
    {
        "id": "11111111-0000-0000-0000-000000000006",
        "topic": "drinking",
        "text": "How often do you drink or have drinks at home?",
        "text_hi": "आप कितनी बार घर पर शराब पीते हैं?",
        "options": ["Non-drinker / alcohol-free home", "Occasional / social drinker", "Regular weekend drinks with friends"],
        "order": 6
    },
    {
        "id": "11111111-0000-0000-0000-000000000007",
        "topic": "guests",
        "text": "What is your policy on overnight guests and friends visiting?",
        "text_hi": "रात में रुकने वाले मेहमानों और दोस्तों के बारे में आपकी क्या नीति है?",
        "options": ["Prior notice & consent needed", "Casual daytime visits only", "Open door / friends welcome anytime"],
        "order": 7
    },
    {
        "id": "11111111-0000-0000-0000-000000000008",
        "topic": "noise",
        "text": "What is your sound/noise tolerance at home?",
        "text_hi": "घर पर शोर को लेकर आपकी सहनशीलता कैसी है?",
        "options": ["Pin-drop silence preferred", "Moderate ambient noise / music with earphones", "Lively music / parties welcome"],
        "order": 8
    },
    {
        "id": "11111111-0000-0000-0000-000000000009",
        "topic": "pets",
        "text": "What is your comfort level with pets in the apartment?",
        "text_hi": "अपार्टमेंट में पालतू जानवरों के साथ आपकी क्या सहजता है?",
        "options": ["No pets allowed / allergic", "Love pets, ok to have dogs/cats", "Planning to bring my own pet"],
        "order": 9
    },
    {
        "id": "11111111-0000-0000-0000-000000000010",
        "topic": "wfh",
        "text": "How many days a week do you work from home?",
        "text_hi": "आप सप्ताह में कितने दिन घर से काम करते हैं?",
        "options": ["Full-time in office", "Hybrid (2-3 days WFH)", "100% remote / full-time WFH"],
        "order": 10
    },
    {
        "id": "11111111-0000-0000-0000-000000000011",
        "topic": "bills",
        "text": "How do you prefer handling shared utility bills?",
        "text_hi": "आप साझा बिजली/वाईफाई बिलों का निपटान कैसे करना पसंद करते हैं?",
        "options": ["Instant settlement on arrival", "Splitwise / monthly settlement", "Rotate paying bills"],
        "order": 11
    },
    {
        "id": "11111111-0000-0000-0000-000000000012",
        "topic": "rent_punctuality",
        "text": "When do you typically pay your portion of the rent?",
        "text_hi": "आप आम तौर पर अपने हिस्से का किराया कब चुकाते हैं?",
        "options": ["Strictly on or before 1st of month", "Between 1st and 5th", "Within first 10 days upon salary"],
        "order": 12
    },
    {
        "id": "11111111-0000-0000-0000-000000000013",
        "topic": "introvert_extrovert",
        "text": "How do you recharge after a busy day?",
        "text_hi": "व्यस्त दिन के बाद आप खुद को कैसे तरोताजा करते हैं?",
        "options": ["Introvert (quiet time in my own room)", "Ambivert (mix of alone time & casual chats)", "Extrovert (love hanging out in living room)"],
        "order": 13
    },
    {
        "id": "11111111-0000-0000-0000-000000000014",
        "topic": "conflict",
        "text": "How do you prefer addressing flatmate issues or grievances?",
        "text_hi": "फ्लैटमेट के साथ किसी मुद्दे पर आप कैसे बात करना पसंद करते हैं?",
        "options": ["Direct, calm 1-on-1 discussion", "Group chat / house meeting", "Give space and resolve gently"],
        "order": 14
    }
]

# Localities and coordinates in Mumbai
LOCALITIES = [
    {"name": "Andheri West", "lon": 72.8277, "lat": 19.1363},
    {"name": "Andheri East", "lon": 72.8697, "lat": 19.1136},
    {"name": "Bandra West", "lon": 72.8295, "lat": 19.0596},
    {"name": "Powai", "lon": 72.9051, "lat": 19.1176},
    {"name": "Lower Parel", "lon": 72.8311, "lat": 18.9953},
    {"name": "Malad West", "lon": 72.8488, "lat": 19.1860},
    {"name": "Goregaon East", "lon": 72.8656, "lat": 19.1663},
    {"name": "Thane West", "lon": 72.9781, "lat": 19.2183},
    {"name": "Navi Mumbai (Vashi)", "lon": 73.0031, "lat": 19.0771}
]

USERS_DATA = [
    ("Rohan Mehta", "male", 26, "working", "KPMG", "Lower Parel", 22000, 32000, "need_room"),
    ("Ananya Sharma", "female", 24, "working", "Google India", "Bandra West", 25000, 35000, "need_room"),
    ("Aditya Roy", "male", 27, "working", "JP Morgan", "Powai", 18000, 28000, "have_room"),
    ("Pooja Nair", "female", 25, "working", "Deloitte", "Andheri West", 15000, 24000, "need_room"),
    ("Siddharth Joshi", "male", 23, "student", "IIT Bombay", "Powai", 8000, 14000, "need_room"),
    ("Ishaan Verma", "male", 28, "working", "Morgan Stanley", "Goregaon East", 18000, 26000, "have_room"),
    ("Tanvi Kulkarni", "female", 26, "working", "Tata Consultancy Services", "Thane West", 10000, 16000, "need_room"),
    ("Varun Kapoor", "male", 29, "freelancer", "Self-Employed UI/UX", "Bandra West", 22000, 35000, "looking_together"),
    ("Sneha Deshmukh", "female", 24, "working", "Nykaa", "Lower Parel", 20000, 30000, "have_room"),
    ("Aman Gupta", "male", 25, "working", "Flipkart", "Andheri East", 14000, 22000, "need_room"),
    ("Meera Iyer", "female", 27, "working", "HDFC Bank", "Lower Parel", 22000, 32000, "need_room"),
    ("Kabir Sen", "male", 24, "student", "NMIMS Mumbai", "Andheri West", 16000, 25000, "looking_together"),
    ("Rhea Bhatia", "female", 25, "working", "Zomato", "Bandra West", 24000, 35000, "need_room"),
    ("Vikram Malhotra", "male", 30, "working", "L&T Infotech", "Powai", 16000, 24000, "have_room"),
    ("Divya Agarwal", "female", 23, "student", "SPJIMR", "Andheri West", 12000, 18000, "need_room"),
    ("Kunal Patil", "male", 26, "working", "Reliance Jio", "Navi Mumbai (Vashi)", 9000, 15000, "need_room"),
    ("Shreya Ghoshal", "female", 28, "freelancer", "Voice Artist & Musician", "Andheri West", 20000, 30000, "have_room"),
    ("Nikhil Reddy", "male", 27, "working", "Amazon Web Services", "Bandra West", 25000, 35000, "need_room"),
    ("Prerna Saxena", "female", 25, "working", "Ernst & Young", "Goregaon East", 16000, 24000, "need_room"),
    ("Arjun Nambiar", "male", 24, "working", "BrowserStack", "Andheri East", 15000, 22000, "have_room"),
    ("Bhavna Sethi", "female", 29, "working", "Standard Chartered", "Lower Parel", 25000, 35000, "need_room"),
    ("Karan Chawla", "male", 26, "working", "Kotak Mahindra", "Malad West", 12000, 19000, "need_room"),
    ("Alia Fernandes", "female", 24, "working", "Vogue India", "Bandra West", 25000, 35000, "looking_together"),
    ("Gaurav Bansal", "male", 25, "working", "PwC India", "Powai", 18000, 27000, "have_room"),
    ("Ritika Somani", "female", 26, "working", "Swiggy", "Andheri West", 18000, 26000, "need_room"),
    ("Rahul Dravid", "male", 28, "working", "Accenture", "Malad West", 14000, 20000, "need_room"),
    ("Neha Kakkar", "female", 24, "student", "HR College", "Lower Parel", 15000, 22000, "need_room"),
    ("Yash Singhania", "male", 27, "working", "Barclays", "Goregaon East", 17000, 25000, "have_room"),
    ("Pallavi Rao", "female", 26, "working", "Mindtickle", "Powai", 16000, 24000, "need_room"),
    ("Deepak Verma", "male", 25, "working", "Infosys", "Thane West", 9000, 14000, "need_room"),
    ("Sakshi Malik", "female", 23, "student", "St. Xavier's College", "Bandra West", 14000, 22000, "need_room"),
    ("Ayushmann Khurana", "male", 29, "freelancer", "Creative Copywriter", "Andheri West", 19000, 28000, "need_room"),
    ("Natasha D'Souza", "female", 25, "working", "Ogilvy & Mather", "Bandra West", 22000, 32000, "have_room"),
    ("Harsh Vardhan", "male", 26, "working", "Goldman Sachs", "Lower Parel", 26000, 35000, "need_room"),
    ("Simran Kaur", "female", 24, "working", "Cult.fit", "Andheri East", 13000, 20000, "need_room"),
    ("Manish Tiwari", "male", 27, "working", "Tata Motors", "Thane West", 10000, 16000, "need_room"),
    ("Tara Sutaria", "female", 25, "freelancer", "Fashion Stylist", "Bandra West", 22000, 32000, "looking_together"),
    ("Abhishek Bachchan", "male", 28, "working", "Zee Entertainment", "Andheri West", 18000, 28000, "have_room"),
    ("Kritika Kamra", "female", 26, "working", "Unilever", "Lower Parel", 24000, 34000, "need_room"),
    ("Sameer Khan", "male", 25, "working", "CleverTap", "Andheri East", 15000, 23000, "need_room"),
    ("Anushka Sen", "female", 23, "student", "Mithibai College", "Andheri West", 12000, 18000, "need_room"),
    ("Farhan Akhtar", "male", 29, "freelancer", "Independent Filmmaker", "Bandra West", 25000, 35000, "have_room"),
    ("Rupali Ganguly", "female", 27, "working", "ICICI Bank", "Malad West", 13000, 20000, "need_room"),
    ("Tejas Shinde", "male", 24, "working", "Capgemini", "Navi Mumbai (Vashi)", 8500, 14000, "need_room"),
    ("Isha Ambani", "female", 26, "working", "McKinsey & Co", "Lower Parel", 26000, 35000, "need_room"),
    ("Kartik Aaryan", "male", 27, "working", "Hotstar / Disney", "Andheri West", 20000, 30000, "have_room"),
    ("Radhika Madan", "female", 25, "working", "Nykaa Fashion", "Bandra West", 20000, 30000, "need_room"),
    ("Devendra Fadnavis", "male", 28, "working", "Government Analyst", "Lower Parel", 18000, 27000, "need_room"),
    ("Trisha Krishnan", "female", 26, "working", "Sony Pictures", "Andheri West", 18000, 28000, "have_room"),
    ("Vivek Oberoi", "male", 27, "working", "Adani Power", "Goregaon East", 15000, 24000, "need_room")
]

def main():
    sql = []
    sql.append("-- ============================================================================")
    sql.append("-- FLATFIT SEED DATA")
    sql.append("-- 50 realistic demo users across Mumbai localities, questionnaire answers,")
    sql.append("-- listings, sample flat 'Sunshine 301' with members, expenses, chores,")
    sql.append("-- calendar events, notices, inventory, matches, and chats.")
    sql.append("-- ============================================================================\n")

    sql.append("-- Setup auth schema fallback if running outside local Supabase auth stack")
    sql.append("CREATE SCHEMA IF NOT EXISTS auth;")
    sql.append("""CREATE TABLE IF NOT EXISTS auth.users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text UNIQUE,
    encrypted_password text,
    email_confirmed_at timestamptz DEFAULT now(),
    raw_app_meta_data jsonb DEFAULT '{}'::jsonb,
    raw_user_meta_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);\n""")

    # 1. Seed Questions
    sql.append("-- 1. Insert Questionnaire Questions")
    for q in QUESTIONS:
        opts_json = json.dumps(q["options"]).replace("'", "''")
        txt = q["text"].replace("'", "''")
        txt_hi = q["text_hi"].replace("'", "''")
        sql.append(f"""INSERT INTO questions (id, topic, question_text, question_text_hi, options, display_order)
VALUES ('{q["id"]}', '{q["topic"]}', '{txt}', '{txt_hi}', '{opts_json}'::jsonb, {q["order"]})
ON CONFLICT (id) DO NOTHING;""")
    sql.append("\n")

    # 2. Seed Users & Profiles
    sql.append("-- 2. Insert 50 Users (auth.users + profiles + photos + trust_scores + verifications)")
    user_records = []
    
    for idx, u in enumerate(USERS_DATA, start=1):
        u_id = f"00000000-0000-0000-0000-{idx:012d}"
        name, gender, age, occ, comp, loc_name, b_min, b_max, goal = u
        email = f"{name.lower().replace(' ', '.').replace('\'', '')}@flatfit.demo"
        
        # Locality match
        loc_obj = next((l for l in LOCALITIES if l["name"] == loc_name), LOCALITIES[0])
        # Add slight jitter to coords
        lon = loc_obj["lon"] + random.uniform(-0.015, 0.015)
        lat = loc_obj["lat"] + random.uniform(-0.015, 0.015)

        bio = f"Hey! I'm {name.split()[0]}, {age} yo {occ} at {comp}. Looking for flatmates who value clean common spaces and mutual respect. Enjoy casual weekend filter coffee and good vibes."
        bio = bio.replace("'", "''")

        move_in = date.today() + timedelta(days=random.randint(5, 28))
        stay = random.choice(["6 months", "11 months", "1 year", "Flexible"])
        pref_locs = f"ARRAY['{loc_name}', 'Nearby Metro']"

        gender_pref = "NULL"
        if random.random() > 0.4:
            gender_pref = f"'{gender}'"

        user_records.append({
            "id": u_id,
            "name": name,
            "email": email,
            "gender": gender,
            "age": age,
            "occupation": occ,
            "company": comp,
            "locality": loc_name,
            "b_min": b_min,
            "b_max": b_max,
            "goal": goal,
            "lon": lon,
            "lat": lat,
            "bio": bio,
            "move_in": str(move_in),
            "stay": stay,
            "gender_pref": gender_pref
        })

        # Insert into auth.users
        sql.append(f"""INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES ('{u_id}', '{email}', 'mock_hash_pw_123456', now(), '{{"full_name": "{name}"}}'::jsonb)
ON CONFLICT (id) DO NOTHING;""")

        # Insert into profiles
        sql.append(f"""INSERT INTO profiles (
    id, full_name, age, gender, occupation, company_or_college, city, locality,
    bio, housing_goal, budget_min, budget_max, preferred_localities,
    location, move_in_date, stay_duration, gender_preference, profile_completion, is_active
) VALUES (
    '{u_id}', '{name}', {age}, '{gender}', '{occ}', '{comp}', 'Mumbai', '{loc_name}',
    '{bio}', '{goal}', {b_min}, {b_max}, {pref_locs},
    ST_SetSRID(ST_MakePoint({lon:.6f}, {lat:.6f}), 4326), '{move_in}', '{stay}', {gender_pref}, {random.randint(85, 100)}, true
) ON CONFLICT (id) DO NOTHING;""")

        # Photos
        photo_url_primary = f"https://images.unsplash.com/photo-{1500000000000 + idx * 12345}?auto=format&fit=crop&w=600&q=80"
        photo_url_secondary = f"https://images.unsplash.com/photo-{1510000000000 + idx * 23456}?auto=format&fit=crop&w=600&q=80"
        sql.append(f"""INSERT INTO profile_photos (profile_id, url, position, is_primary)
VALUES ('{u_id}', '{photo_url_primary}', 1, true),
       ('{u_id}', '{photo_url_secondary}', 2, false)
ON CONFLICT DO NOTHING;""")

        # Trust score & verifications
        trust = random.randint(65, 95)
        factors = json.dumps({
            "profile_complete": 20,
            "phone_verified": 15,
            "kyc_done": 25 if trust > 75 else 0,
            "reviews_avg": random.randint(15, 20),
            "response_rate": random.randint(8, 10)
        })
        sql.append(f"""INSERT INTO trust_scores (user_id, score, factors)
VALUES ('{u_id}', {trust}, '{factors}'::jsonb)
ON CONFLICT (user_id) DO NOTHING;""")

        sql.append(f"""INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('{u_id}', 'phone', 'verified', 'msg91_{idx}', now() - interval '10 days')
ON CONFLICT DO NOTHING;""")

        if trust > 75:
            sql.append(f"""INSERT INTO verifications (user_id, type, status, provider_ref, verified_at)
VALUES ('{u_id}', 'kyc', 'verified', 'kyc_aadhaar_{idx}', now() - interval '8 days')
ON CONFLICT DO NOTHING;""")

    sql.append("\n")

    # 3. Seed User Answers for all 50 users
    sql.append("-- 3. Insert Questionnaire Answers for All 50 Users")
    for u in user_records:
        u_id = u["id"]
        for q in QUESTIONS:
            q_id = q["id"]
            # choose an option
            opt = random.choice(q["options"]).replace("'", "''")
            importance = random.choice(["deal_breaker", "important", "nice_to_have", "important", "nice_to_have"])
            if q["topic"] in ["smoking", "food", "pets"] and random.random() < 0.35:
                importance = "deal_breaker"
            sql.append(f"""INSERT INTO user_answers (user_id, question_id, answer, importance)
VALUES ('{u_id}', '{q_id}', '{opt}', '{importance}')
ON CONFLICT (user_id, question_id) DO NOTHING;""")
    sql.append("\n")

    # 4. Seed 15 Realistic Listings
    sql.append("-- 4. Insert 15 Realistic Listings with Photos and Amenities")
    LISTING_TITLES = [
        ("Master Bedroom in Luxury 3BHK Hiranandani", "Powai", 32000, 60000, "single", "fully_furnished", 3),
        ("Private Room with Attached Balcony in Bandra West", "Bandra West", 28000, 50000, "single", "fully_furnished", 2),
        ("Spacious Shared Room near Metro Station", "Andheri West", 14000, 25000, "shared", "semi_furnished", 4),
        ("Sunlit 1RK Studio for Working Professional", "Lower Parel", 24000, 45000, "single", "fully_furnished", 1),
        ("Furnished Bedroom in Gated Society near Nesco", "Goregaon East", 19000, 35000, "single", "fully_furnished", 6),
        ("Peaceful Room in 2BHK near Inorbit Mall", "Malad West", 15000, 30000, "single", "semi_furnished", 2),
        ("Modern Bedroom in High-Rise near Vashi Station", "Navi Mumbai (Vashi)", 11000, 20000, "single", "fully_furnished", 16),
        ("Twin Sharing Room for Female Flatmate in Thane", "Thane West", 9500, 18000, "shared", "semi_furnished", 7),
        ("Chic Studio Room with Sea Breeze near Carter Road", "Bandra West", 34000, 70000, "single", "fully_furnished", 2),
        ("Cozy Single Room in Oberoi Splendor", "Andheri East", 21000, 40000, "single", "fully_furnished", 10),
        ("Affordable Single Room in 3BHK near IIT Main Gate", "Powai", 16000, 30000, "single", "semi_furnished", 5),
        ("Penthouse Terrace Room with Panoramic View", "Lower Parel", 35000, 75000, "single", "fully_furnished", 1),
        ("Airy Master Bedroom in Royal Palms", "Goregaon East", 17000, 32000, "master", "fully_furnished", 6),
        ("Cozy Shared Room near Lokhandwala Market", "Andheri West", 13500, 24000, "shared", "fully_furnished", 4),
        ("Bright 2BHK Flatmate Wanted in Korum Mall Vicinity", "Thane West", 12000, 22000, "single", "semi_furnished", 7)
    ]

    ALL_AMENITIES = ["High Speed WiFi", "Air Conditioner", "Washing Machine", "Geyser", "Cook Available", "Maid Service", "Gym Access", "Power Backup", "RO Water Purifier", "Car Parking", "24x7 Security", "Balcony"]

    listing_ids = []
    for l_idx, (title, loc_name, rent, dep, rtype, furn, owner_num) in enumerate(LISTING_TITLES, start=1):
        l_id = f"22222222-0000-0000-0000-{l_idx:012d}"
        listing_ids.append(l_id)
        owner_id = f"00000000-0000-0000-0000-{owner_num:012d}"
        loc_obj = next((l for l in LOCALITIES if l["name"] == loc_name), LOCALITIES[0])
        lon = loc_obj["lon"] + random.uniform(-0.01, 0.01)
        lat = loc_obj["lat"] + random.uniform(-0.01, 0.01)
        avail = date.today() + timedelta(days=random.randint(2, 20))

        rules = json.dumps({
            "smoking_allowed": "balcony_only" if l_idx % 2 == 0 else "no",
            "overnight_guests": "with_advance_notice",
            "loud_music": "quiet_after_11pm",
            "pets": "allowed" if l_idx % 3 == 0 else "not_allowed"
        })

        desc = f"Looking for a friendly, respectful flatmate for this lovely {rtype} room in {loc_name}. Society is calm, secure, and has 24/7 power backup and water supply. Close to grocery stores, gyms, and public transit. Maintenance is included in rent."

        sql.append(f"""INSERT INTO listings (
    id, owner_id, type, title, description, rent, deposit, maintenance, furnishing,
    location, locality, city, address, room_type, availability_date, quality_score, is_verified,
    house_rules, current_flatmates_count, status
) VALUES (
    '{l_id}', '{owner_id}', 'have_room', '{title}', '{desc}', {rent}, {dep}, 1500.00, '{furn}',
    ST_SetSRID(ST_MakePoint({lon:.6f}, {lat:.6f}), 4326), '{loc_name}', 'Mumbai', 'Tower B, Flat {random.randint(101, 1404)}, {loc_name}',
    '{rtype}', '{avail}', {random.randint(78, 98)}, true, '{rules}'::jsonb, {random.randint(1, 3)}, 'active'
) ON CONFLICT (id) DO NOTHING;""")

        # Photos (3 photos per listing)
        sql.append(f"""INSERT INTO listing_photos (listing_id, url, position, caption)
VALUES ('{l_id}', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', 1, 'Spacious bedroom'),
       ('{l_id}', 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', 2, 'Bright living room'),
       ('{l_id}', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 3, 'Modular kitchen')
ON CONFLICT DO NOTHING;""")

        # Amenities (5-7 amenities per listing)
        chosen_amenities = random.sample(ALL_AMENITIES, k=random.randint(6, 9))
        for a in chosen_amenities:
            sql.append(f"""INSERT INTO listing_amenities (listing_id, amenity)
VALUES ('{l_id}', '{a}') ON CONFLICT DO NOTHING;""")

    sql.append("\n")

    # 5. Seed Sample Flat: 'Sunshine 301'
    sql.append("-- 5. Insert Sample Flat 'Sunshine 301' with 3 Members, 10 Expenses, 5 Chores, Calendar, Notices")
    flat_id = "33333333-0000-0000-0000-000000000001"
    member_1 = "00000000-0000-0000-0000-000000000001" # Rohan Mehta (Admin)
    member_2 = "00000000-0000-0000-0000-000000000003" # Aditya Roy (Member)
    member_3 = "00000000-0000-0000-0000-000000000006" # Ishaan Verma (Member)

    sql.append(f"""INSERT INTO flats (id, name, listing_id, address, city)
VALUES ('{flat_id}', 'Sunshine 301', '{listing_ids[0]}', 'Flat 301, Sunshine Heights, Central Avenue, Powai', 'Mumbai')
ON CONFLICT (id) DO NOTHING;""")

    # Flat Members
    sql.append(f"""INSERT INTO flat_members (flat_id, user_id, role, joined_at)
VALUES ('{flat_id}', '{member_1}', 'admin', now() - interval '90 days'),
       ('{flat_id}', '{member_2}', 'member', now() - interval '90 days'),
       ('{flat_id}', '{member_3}', 'member', now() - interval '60 days')
ON CONFLICT (flat_id, user_id) DO NOTHING;""")

    # 10 Expenses with Splits
    expenses_data = [
        ("November Apartment Rent", 66000.00, "rent", member_1, date.today() - timedelta(days=12)),
        ("Electricity Bill (Adani Electricity)", 4200.00, "electricity", member_2, date.today() - timedelta(days=10)),
        ("JioFiber High-Speed WiFi 300Mbps", 1179.00, "wifi", member_3, date.today() - timedelta(days=8)),
        ("Cook Monthly Salary (Asha Bai)", 9000.00, "cook", member_1, date.today() - timedelta(days=7)),
        ("Maid Cleaning & Utensils Salary", 4500.00, "maid", member_2, date.today() - timedelta(days=7)),
        ("Nature's Basket Monthly Groceries & Spices", 5430.00, "groceries", member_3, date.today() - timedelta(days=5)),
        ("HP Gas Cylinder Refill", 950.00, "other", member_1, date.today() - timedelta(days=4)),
        ("Bisleri 20L Water Cans (10 pack)", 800.00, "groceries", member_2, date.today() - timedelta(days=3)),
        ("Living Room Cleaning Supplies & Detergents", 650.00, "other", member_3, date.today() - timedelta(days=2)),
        ("Society Deep Tank Cleaning Contribution", 1500.00, "other", member_1, date.today() - timedelta(days=1)),
    ]

    for e_idx, (etitle, eamt, ecat, epaidby, edate) in enumerate(expenses_data, start=1):
        exp_id = f"44444444-0000-0000-0000-{e_idx:012d}"
        sql.append(f"""INSERT INTO expenses (id, flat_id, paid_by, title, amount, category, date)
VALUES ('{exp_id}', '{flat_id}', '{epaidby}', '{etitle}', {eamt}, '{ecat}', '{edate}')
ON CONFLICT (id) DO NOTHING;""")

        # 3-way split
        split_amt = round(eamt / 3.0, 2)
        is_settled_1 = True if e_idx <= 6 else False
        is_settled_2 = True if e_idx <= 6 else (e_idx % 2 == 0)

        sql.append(f"""INSERT INTO expense_splits (expense_id, user_id, amount, is_settled, settled_at)
VALUES ('{exp_id}', '{member_1}', {split_amt}, true, now() - interval '2 days'),
       ('{exp_id}', '{member_2}', {split_amt}, {str(is_settled_1).lower()}, {'now() - interval \'2 days\'' if is_settled_1 else 'NULL'}),
       ('{exp_id}', '{member_3}', {split_amt}, {str(is_settled_2).lower()}, {'now() - interval \'2 days\'' if is_settled_2 else 'NULL'})
ON CONFLICT (expense_id, user_id) DO NOTHING;""")

    # 5 Chores & Chore Assignments
    chores_data = [
        ("Kitchen Counter & Stove Deep Clean", "weekly", member_1),
        ("Living Room Dusting & Balcony Sweep", "weekly", member_2),
        ("Trash & Wet Waste Disposal", "daily", member_3),
        ("Restock Groceries & Drinking Water", "weekly", member_1),
        ("Bathroom Deep Sanitization", "monthly", member_2)
    ]

    for c_idx, (ctitle, cfreq, cuser) in enumerate(chores_data, start=1):
        chore_id = f"55555555-0000-0000-0000-{c_idx:012d}"
        sql.append(f"""INSERT INTO chores (id, flat_id, title, frequency)
VALUES ('{chore_id}', '{flat_id}', '{ctitle}', '{cfreq}')
ON CONFLICT (id) DO NOTHING;""")

        # Assign for upcoming week
        due = date.today() + timedelta(days=c_idx)
        is_done = c_idx <= 2
        comp_at = "now() - interval '1 day'" if is_done else "NULL"
        sql.append(f"""INSERT INTO chore_assignments (chore_id, user_id, due_date, completed_at)
VALUES ('{chore_id}', '{cuser}', '{due}', {comp_at})
ON CONFLICT DO NOTHING;""")

    # Calendar Events
    cal_data = [
        ("Guest Staying Over (College Friend)", "guest", date.today() + timedelta(days=2), member_1),
        ("Society Annual Pest Control Service", "maintenance", date.today() + timedelta(days=4), member_2),
        ("Weekend Movie Night & Pizza Gathering", "party", date.today() + timedelta(days=6), member_3),
        ("Scheduled Power Maintenance (10 AM - 1 PM)", "power_cut", date.today() + timedelta(days=8), member_1),
    ]

    for ev_title, ev_type, ev_start, ev_user in cal_data:
        sql.append(f"""INSERT INTO calendar_events (flat_id, user_id, title, type, start_time, end_time)
VALUES ('{flat_id}', '{ev_user}', '{ev_title}', '{ev_type}', '{ev_start} 10:00:00+05:30', '{ev_start} 14:00:00+05:30')
ON CONFLICT DO NOTHING;""")

    # Notices
    sql.append(f"""INSERT INTO notices (flat_id, user_id, content, is_pinned)
VALUES ('{flat_id}', '{member_1}', 'Reminder: Society gate closes for delivery riders at 11:30 PM. Please collect late orders at security desk.', true),
       ('{flat_id}', '{member_2}', 'Asha Bai (cook) informed she will be on leave this coming Sunday for Diwali shopping.', false)
ON CONFLICT DO NOTHING;""")

    # Grocery items
    groceries_list = [
        ("Amul Taaza Milk 1L x 4", member_1, False),
        ("Brown Bread Loaf", member_2, True),
        ("Tata Salt & Black Pepper refill", member_3, False),
        ("Vim Dishwash Gel 750ml", member_1, True),
        ("Nescafe Classic Coffee Jar", member_2, False),
        ("Eggs (Tray of 30)", member_3, True)
    ]
    for gname, guser, gdone in groceries_list:
        sql.append(f"""INSERT INTO grocery_items (flat_id, name, added_by, is_bought)
VALUES ('{flat_id}', '{gname}', '{guser}', {str(gdone).lower()})
ON CONFLICT DO NOTHING;""")

    # House Inventory
    inventory_items = [
        ("Samsung Microwave Oven 28L", member_1, 9500.00, "2024-02-15"),
        ("Whirlpool 265L Refrigerator", member_2, 22000.00, "2024-01-10"),
        ("IKEA Ektorp 3-Seater Sofa", member_3, 18500.00, "2024-03-01"),
        ("TP-Link Archer WiFi 6 Router", member_1, 3800.00, "2024-02-01"),
        ("Kent Grand Plus RO Water Purifier", member_2, 14000.00, "2024-01-20")
    ]
    for iname, iuser, icost, idate in inventory_items:
        sql.append(f"""INSERT INTO house_inventory (flat_id, item_name, bought_by, cost, purchase_date)
VALUES ('{flat_id}', '{iname}', '{iuser}', {icost}, '{idate}')
ON CONFLICT DO NOTHING;""")

    sql.append("\n")

    # 6. Precomputed Matches
    sql.append("-- 6. Insert Precomputed Matches for Demo")
    sample_matches = [
        (1, 3, 94, ["cleanliness", "sleep", "bills", "rent_punctuality"], ["drinking"]),
        (1, 6, 88, ["food", "cleanliness", "wfh", "conflict"], ["guests"]),
        (2, 4, 92, ["sleep", "cleanliness", "introvert_extrovert", "pets"], ["cooking"]),
        (2, 9, 89, ["cleanliness", "bills", "food", "noise"], ["wfh"]),
        (3, 6, 91, ["cleanliness", "rent_punctuality", "bills", "sleep"], ["noise"]),
        (4, 11, 86, ["sleep", "wfh", "introvert_extrovert"], ["cooking"]),
        (5, 10, 84, ["food", "bills", "rent_punctuality"], ["sleep"]),
        (7, 16, 90, ["bills", "cleanliness", "conflict"], ["drinking"]),
        (8, 18, 93, ["introvert_extrovert", "wfh", "noise", "cleanliness"], ["pets"]),
        (12, 14, 87, ["food", "sleep", "bills"], ["guests"])
    ]

    for ua_num, ub_num, mscore, comp_t, watch_t in sample_matches:
        u_a = f"00000000-0000-0000-0000-{min(ua_num, ub_num):012d}"
        u_b = f"00000000-0000-0000-0000-{max(ua_num, ub_num):012d}"
        c_arr = "ARRAY[" + ", ".join([f"'{t}'" for t in comp_t]) + "]"
        w_arr = "ARRAY[" + ", ".join([f"'{t}'" for t in watch_t]) + "]"

        sql.append(f"""INSERT INTO precomputed_matches (user_a, user_b, score, compatible_topics, watch_out_topics)
VALUES ('{u_a}', '{u_b}', {mscore}, {c_arr}, {w_arr})
ON CONFLICT (user_a, user_b) DO UPDATE
SET score = EXCLUDED.score, compatible_topics = EXCLUDED.compatible_topics, watch_out_topics = EXCLUDED.watch_out_topics;""")

    sql.append("\n")

    # 7. Conversations and Messages
    sql.append("-- 7. Insert Sample Conversations and Messages")
    conv_1 = "66666666-0000-0000-0000-000000000001"
    conv_2 = "66666666-0000-0000-0000-000000000002"

    u1 = "00000000-0000-0000-0000-000000000001"
    u3 = "00000000-0000-0000-0000-000000000003"
    u2 = "00000000-0000-0000-0000-000000000002"
    u4 = "00000000-0000-0000-0000-000000000004"

    sql.append(f"""INSERT INTO conversations (id, type)
VALUES ('{conv_1}', 'direct'), ('{conv_2}', 'direct')
ON CONFLICT (id) DO NOTHING;""")

    sql.append(f"""INSERT INTO conversation_members (conversation_id, user_id)
VALUES ('{conv_1}', '{u1}'), ('{conv_1}', '{u3}'),
       ('{conv_2}', '{u2}'), ('{conv_2}', '{u4}')
ON CONFLICT DO NOTHING;""")

    chat1 = [
        (u1, "Hey Aditya! Saw your profile on FlatFit, 94% compatibility! Are you still looking for a flatmate in Powai?"),
        (u3, "Hey Rohan! Yes absolutely. We have a vacant bedroom in Sunshine 301. Clean place, chill vibe, cook already set up."),
        (u1, "Sounds ideal. I work at KPMG in Lower Parel, but love Powai's greenery and calm weekends. How do you guys manage utility bills?"),
        (u3, "We split equally on FlatFit / Splitwise at the end of each month. Rent is strictly on the 1st. Want to drop by this Saturday around 4 PM to check out the room?"),
        (u1, "Saturday 4 PM works perfectly for me. See you then!")
    ]

    for sender, msg in chat1:
        escaped_msg = msg.replace("'", "''")
        sql.append(f"""INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('{conv_1}', '{sender}', '{escaped_msg}', 'text');""")

    chat2 = [
        (u2, "Hi Pooja! Your Bandra preferences matched mine closely. Are you looking to team up for a 2BHK hunt?"),
        (u4, "Hey Ananya! Yes, looking around Pali Hill or Bandra West near Linking Road. Budget around 25k each."),
        (u2, "That aligns with my budget too! Let's shortlist a few properties together this week.")
    ]

    for sender, msg in chat2:
        escaped_msg = msg.replace("'", "''")
        sql.append(f"""INSERT INTO messages (conversation_id, sender_id, content, type)
VALUES ('{conv_2}', '{sender}', '{escaped_msg}', 'text');""")

    sql.append("\n")

    # 8. Service Partners & City Guides
    sql.append("-- 8. Insert Service Partners and City Guides")
    partners = [
        ("Urban Company Home Services", "cleaning", "Mumbai", 4.8, 1240, "+918001234567", "support@urbancompany.com"),
        ("Porter Flat Shifting & Mini Trucks", "movers", "Mumbai", 4.7, 850, "+918002345678", "help@porter.in"),
        ("Rentomojo Furniture & Appliance Rental", "furniture_rental", "Mumbai", 4.6, 620, "+918003456789", "care@rentomojo.com"),
        ("CookFind Mumbai Home Cooks", "cook", "Mumbai", 4.5, 410, "+918004567890", "cooks@cookfind.in"),
        ("UrbanClap AC Repair & Servicing", "repairs", "Mumbai", 4.7, 980, "+918005678901", "service@urbanclap.com")
    ]

    for pname, pcat, pcity, prat, prevs, pphone, pmail in partners:
        sql.append(f"""INSERT INTO service_partners (name, category, city, rating, total_reviews, contact_phone, contact_email)
VALUES ('{pname}', '{pcat}', '{pcity}', {prat}, {prevs}, '{pphone}', '{pmail}')
ON CONFLICT DO NOTHING;""")

    city_guides_data = [
        ("Mumbai", "Bandra West", "25000-45000", "Vibrant, cultural, cafe paradise, seafront promenades",
         '{"metro": "Bandra station 10 mins", "sea_link": "5 mins to Worli", "nightlife": "Top tier"}'),
        ("Mumbai", "Powai", "16000-30000", "Lakeside views, IT tech hub, startup culture, organized township",
         '{"metro": "JVLR metro line", "lake": "Powai lake jogging track", "vibe": "Cosmopolitan & green"}'),
        ("Mumbai", "Lower Parel", "22000-40000", "Corporate financial hub, high-rises, luxury dining, central location",
         '{"metro": "Monorail & Western Line", "malls": "Phoenix Palladium", "work": "Walking distance to major banks"}'),
        ("Mumbai", "Andheri West", "14000-26000", "Media hub, metro connectivity, lively street food, affordable dining",
         '{"metro": "Versova-Ghatkopar Line 1", "rail": "Andheri terminal", "hangouts": "Lokhandwala complex"}')
    ]

    for gcity, gloc, gbud, gvibe, gcomm in city_guides_data:
        sql.append(f"""INSERT INTO city_guides (city, locality, budget_range, vibe, commute_info)
VALUES ('{gcity}', '{gloc}', '{gbud}', '{gvibe}', '{gcomm}'::jsonb)
ON CONFLICT DO NOTHING;""")

    sql.append("\n-- End of seed.sql\n")

    return "\n".join(sql)

if __name__ == "__main__":
    content = main()
    with open(r"d:\Codestar30\flatfit\supabase\seed\seed.sql", "w", encoding="utf-8") as f:
        f.write(content)
    print(f"seed.sql generated successfully! ({len(content)} bytes)")
