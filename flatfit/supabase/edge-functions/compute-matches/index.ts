// edge-functions/compute-matches/index.ts
// Background job: precompute top matches for each user using compatibility engine
// Follows Deno standard for Supabase Edge Functions

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface UserProfile {
  id: string;
  full_name: string;
  gender: string | null;
  gender_preference: string | null;
  budget_min: number | null;
  budget_max: number | null;
  move_in_date: string | null;
  city: string;
  location?: { coordinates: [number, number] } | null;
  is_active: boolean;
}

interface UserAnswer {
  user_id: string;
  question_id: string;
  topic: string;
  answer: string;
  importance: "deal_breaker" | "important" | "nice_to_have";
}

// Haversine formula to compute distance in km between two geo points
function calculateDistanceKm(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth's radius in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Calculate budget overlap percentage
function calculateBudgetOverlap(minA: number, maxA: number, minB: number, maxB: number): number {
  const overlapMin = Math.max(minA, minB);
  const overlapMax = Math.min(maxA, maxB);
  if (overlapMax <= overlapMin) return 0;
  
  const spanA = maxA - minA || 1;
  const spanB = maxB - minB || 1;
  const overlapRange = overlapMax - overlapMin;
  return (overlapRange / Math.max(spanA, spanB)) * 100;
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Optional user_id filter if triggered for a single user
    let targetUserId: string | null = null;
    if (req.method === "POST") {
      try {
        const body = await req.json();
        targetUserId = body?.user_id || null;
      } catch {
        // empty body ok
      }
    }

    // 1. Fetch active users
    let profileQuery = supabase
      .from("profiles")
      .select("id, full_name, gender, gender_preference, budget_min, budget_max, move_in_date, city, location, is_active")
      .eq("is_active", true);

    if (targetUserId) {
      // Fetch target user and peers in same city
      const { data: targetUser, error: targetError } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", targetUserId)
        .single();

      if (targetError || !targetUser) {
        return new Response(JSON.stringify({ error: "Target user not found" }), {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      profileQuery = profileQuery.eq("city", targetUser.city);
    }

    const { data: profiles, error: profilesError } = await profileQuery;
    if (profilesError) throw profilesError;

    if (!profiles || profiles.length < 2) {
      return new Response(
        JSON.stringify({ message: "Not enough active profiles to match", computed_count: 0 }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 2. Fetch all user answers with question topic
    const userIds = profiles.map((p) => p.id);
    const { data: answersData, error: answersError } = await supabase
      .from("user_answers")
      .select("user_id, question_id, answer, importance, questions(topic)")
      .in("user_id", userIds);

    if (answersError) throw answersError;

    const answersByUser: Record<string, Record<string, { answer: string; importance: string; topic: string }>> = {};
    for (const row of answersData || []) {
      if (!answersByUser[row.user_id]) {
        answersByUser[row.user_id] = {};
      }
      const topic = (row as any).questions?.topic || "general";
      answersByUser[row.user_id][row.question_id] = {
        answer: row.answer,
        importance: row.importance,
        topic,
      };
    }

    // 3. Pairwise matching
    const matchUpserts: Array<{
      user_a: string;
      user_b: string;
      score: number;
      compatible_topics: string[];
      watch_out_topics: string[];
      computed_at: string;
    }> = [];

    const now = new Date().toISOString();

    for (let i = 0; i < profiles.length; i++) {
      for (let j = i + 1; j < profiles.length; j++) {
        const uA = profiles[i];
        const uB = profiles[j];

        // If target user specified, only match involving target user
        if (targetUserId && uA.id !== targetUserId && uB.id !== targetUserId) {
          continue;
        }

        // Canonical ordering: user_a < user_b
        const [userA, userB] = uA.id < uB.id ? [uA, uB] : [uB, uA];

        // --- HARD FILTERS ---
        // Filter 1: Gender preference match
        if (userA.gender_preference && userB.gender && userA.gender_preference !== userB.gender) {
          continue; // instant reject
        }
        if (userB.gender_preference && userA.gender && userB.gender_preference !== userA.gender) {
          continue; // instant reject
        }

        // Filter 2: Budget overlap >= 20%
        const minA = Number(userA.budget_min || 0);
        const maxA = Number(userA.budget_max || 100000);
        const minB = Number(userB.budget_min || 0);
        const maxB = Number(userB.budget_max || 100000);

        const overlapPct = calculateBudgetOverlap(minA, maxA, minB, maxB);
        if (overlapPct < 20) {
          continue; // instant reject
        }

        // Filter 3: Move-in date within 30 days of each other (if both provided)
        if (userA.move_in_date && userB.move_in_date) {
          const dateA = new Date(userA.move_in_date).getTime();
          const dateB = new Date(userB.move_in_date).getTime();
          const diffDays = Math.abs(dateA - dateB) / (1000 * 60 * 60 * 24);
          if (diffDays > 30) {
            continue; // instant reject
          }
        }

        // Filter 4: Location distance within 15km (if coordinates exist)
        if (userA.location?.coordinates && userB.location?.coordinates) {
          const [lonA, latA] = userA.location.coordinates;
          const [lonB, latB] = userB.location.coordinates;
          const distance = calculateDistanceKm(latA, lonA, latB, lonB);
          if (distance > 15) {
            continue; // instant reject
          }
        }

        // --- QUESTIONNAIRE SCORING & DEAL-BREAKER CHECK ---
        const answersA = answersByUser[userA.id] || {};
        const answersB = answersByUser[userB.id] || {};

        let hasDealBreakerConflict = false;
        let earnedPoints = 0;
        let totalPossiblePoints = 0;
        const compatibleTopics = new Set<string>();
        const watchOutTopics = new Set<string>();

        const questionIds = Array.from(new Set([...Object.keys(answersA), ...Object.keys(answersB)]));

        for (const qId of questionIds) {
          const ansA = answersA[qId];
          const ansB = answersB[qId];

          if (!ansA || !ansB) continue; // skip if either hasn't answered

          const isMatch = ansA.answer.trim().toLowerCase() === ansB.answer.trim().toLowerCase();
          const isDealBreaker = ansA.importance === "deal_breaker" || ansB.importance === "deal_breaker";
          const isImportant = ansA.importance === "important" || ansB.importance === "important";

          const weight = isDealBreaker ? 30 : isImportant ? 15 : 5;
          totalPossiblePoints += weight;

          const topic = ansA.topic || ansB.topic || "general";

          if (isMatch) {
            earnedPoints += weight;
            compatibleTopics.add(topic);
          } else {
            if (isDealBreaker) {
              // Deal breaker conflict = instant reject!
              hasDealBreakerConflict = true;
              break;
            }
            watchOutTopics.add(topic);
          }
        }

        if (hasDealBreakerConflict) {
          continue; // rejected due to deal breaker
        }

        // Base questionnaire score (normalized 0 - 100)
        let compatibilityScore = totalPossiblePoints > 0
          ? Math.round((earnedPoints / totalPossiblePoints) * 100)
          : 70; // baseline if limited answers

        // Add small boost for high budget overlap
        if (overlapPct >= 60) compatibilityScore = Math.min(100, compatibilityScore + 5);

        // Clamp 0 - 100
        compatibilityScore = Math.max(0, Math.min(100, compatibilityScore));

        matchUpserts.push({
          user_a: userA.id,
          user_b: userB.id,
          score: compatibilityScore,
          compatible_topics: Array.from(compatibleTopics),
          watch_out_topics: Array.from(watchOutTopics),
          computed_at: now,
        });
      }
    }

    // 4. Batch upsert into precomputed_matches
    if (matchUpserts.length > 0) {
      const { error: upsertError } = await supabase
        .from("precomputed_matches")
        .upsert(matchUpserts, { onConflict: "user_a,user_b" });

      if (upsertError) throw upsertError;
    }

    return new Response(
      JSON.stringify({
        success: true,
        computed_count: matchUpserts.length,
        timestamp: now,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
