// edge-functions/listing-quality/index.ts
// Calculates listing quality score (0-100) based on completeness, verification, photos, and descriptions

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface QualityRequest {
  listing_id: string;
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const body: QualityRequest = await req.json();
    const { listing_id } = body;

    if (!listing_id) {
      return new Response(JSON.stringify({ error: "Missing listing_id" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 1. Fetch listing details along with photos and amenities
    const { data: listing, error: listingError } = await supabase
      .from("listings")
      .select("*, listing_photos(*), listing_amenities(*)")
      .eq("id", listing_id)
      .single();

    if (listingError || !listing) {
      return new Response(JSON.stringify({ error: "Listing not found" }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Fetch owner verification status
    const { data: ownerVerification } = await supabase
      .from("verifications")
      .select("status")
      .eq("user_id", listing.owner_id)
      .eq("status", "verified")
      .limit(1);

    const isOwnerVerified = !!(ownerVerification && ownerVerification.length > 0);

    // 3. Compute score breakdown
    let score = 0;
    const breakdown: Record<string, number> = {};

    // Photos (up to 25 pts)
    const photoCount = listing.listing_photos?.length || 0;
    if (photoCount >= 4) {
      breakdown.photos = 25;
    } else if (photoCount >= 2) {
      breakdown.photos = 15;
    } else if (photoCount === 1) {
      breakdown.photos = 8;
    } else {
      breakdown.photos = 0;
    }

    // Description & Title (up to 20 pts)
    const descLen = listing.description?.trim().length || 0;
    const titleLen = listing.title?.trim().length || 0;
    let textScore = 0;
    if (titleLen >= 15) textScore += 5;
    if (descLen >= 120) textScore += 15;
    else if (descLen >= 50) textScore += 8;
    breakdown.text_quality = textScore;

    // Amenities (up to 15 pts)
    const amenityCount = listing.listing_amenities?.length || 0;
    if (amenityCount >= 5) {
      breakdown.amenities = 15;
    } else if (amenityCount >= 2) {
      breakdown.amenities = 8;
    } else {
      breakdown.amenities = 0;
    }

    // Location / Address specificity (up to 15 pts)
    let locScore = 0;
    if (listing.location) locScore += 10;
    if (listing.address && listing.address.length > 10) locScore += 5;
    breakdown.location_precision = locScore;

    // House rules specified (up to 10 pts)
    const rulesCount = listing.house_rules ? Object.keys(listing.house_rules).length : 0;
    breakdown.house_rules = rulesCount > 0 ? 10 : 0;

    // Owner verified (15 pts)
    breakdown.owner_verified = isOwnerVerified ? 15 : 0;

    // Total score
    score = Object.values(breakdown).reduce((a, b) => a + b, 0);
    score = Math.min(100, score);

    // 4. Update listing quality score
    const { error: updateError } = await supabase
      .from("listings")
      .update({
        quality_score: score,
        is_verified: isOwnerVerified && score >= 70,
        updated_at: new Date().toISOString(),
      })
      .eq("id", listing_id);

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        success: true,
        listing_id,
        quality_score: score,
        breakdown,
        is_verified: isOwnerVerified && score >= 70,
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
