// edge-functions/verify-kyc/index.ts
// KYC verification flow with mock verification provider (e.g., Aadhaar, DigiLocker, PAN)

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface KycRequest {
  user_id: string;
  document_type: "aadhaar" | "pan" | "passport" | "driving_license";
  document_number: string;
  document_front_url?: string;
  selfie_url?: string;
}

// Mock KYC provider verifying document against government / Digilocker database
async function mockVerifyDocument(type: string, docNumber: string): Promise<{ valid: boolean; name?: string; reason?: string }> {
  // Simulate network latency
  await new Promise((resolve) => setTimeout(resolve, 300));

  const cleanNum = docNumber.trim().toUpperCase();

  // Basic format validation
  if (type === "aadhaar") {
    // 12 digit format
    const isValid = /^\d{12}$/.test(cleanNum.replace(/\s+/g, ""));
    return isValid
      ? { valid: true, name: "Verified Citizen" }
      : { valid: false, reason: "Aadhaar must be a 12-digit number" };
  } else if (type === "pan") {
    // 5 letters, 4 digits, 1 letter
    const isValid = /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/.test(cleanNum);
    return isValid
      ? { valid: true, name: "Verified Taxpayer" }
      : { valid: false, reason: "Invalid PAN format" };
  } else if (type === "passport") {
    const isValid = /^[A-Z][0-9]{7}$/.test(cleanNum);
    return isValid
      ? { valid: true, name: "Verified Passport Holder" }
      : { valid: false, reason: "Invalid Passport format" };
  }

  return { valid: true, name: "Verified User" };
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const body: KycRequest = await req.json();
    const { user_id, document_type, document_number, document_front_url, selfie_url } = body;

    if (!user_id || !document_type || !document_number) {
      return new Response(JSON.stringify({ error: "Missing required KYC parameters" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 1. Verify document via provider
    const verificationResult = await mockVerifyDocument(document_type, document_number);
    const isSuccess = verificationResult.valid;
    const providerRef = `kyc_${Date.now()}_${Math.random().toString(36).substring(7)}`;
    const now = new Date().toISOString();

    // 2. Upsert verification record
    const { data: verificationRecord, error: verifyError } = await supabase
      .from("verifications")
      .upsert(
        {
          user_id,
          type: "kyc",
          status: isSuccess ? "verified" : "failed",
          provider_ref: providerRef,
          data: {
            document_type,
            masked_number: document_number.slice(-4).padStart(document_number.length, "*"),
            verified_name: verificationResult.name || null,
            failure_reason: verificationResult.reason || null,
            document_front_url,
            selfie_url,
          },
          verified_at: isSuccess ? now : null,
        },
        { onConflict: "user_id,type" }
      )
      .select()
      .single();

    if (verifyError) throw verifyError;

    // 3. Update or compute Trust Score
    let updatedTrustScore = 0;
    if (isSuccess) {
      // Fetch existing trust score
      const { data: existingScore } = await supabase
        .from("trust_scores")
        .select("*")
        .eq("user_id", user_id)
        .maybeSingle();

      const factors = existingScore?.factors || {
        profile_complete: 20,
        phone_verified: 15,
        response_rate: 10,
      };

      // Add KYC factor (25 points)
      factors.kyc_done = 25;

      const totalScore = Object.values(factors).reduce((acc: number, val: any) => acc + Number(val || 0), 0);
      updatedTrustScore = Math.min(100, totalScore);

      await supabase.from("trust_scores").upsert(
        {
          user_id,
          score: updatedTrustScore,
          factors,
          updated_at: now,
        },
        { onConflict: "user_id" }
      );

      // Audit log entry
      await supabase.from("audit_logs").insert({
        user_id,
        action: "kyc.verified",
        entity_type: "verification",
        entity_id: verificationRecord.id,
        metadata: {
          document_type,
          provider_ref: providerRef,
          trust_score: updatedTrustScore,
        },
      });
    }

    return new Response(
      JSON.stringify({
        success: isSuccess,
        status: isSuccess ? "verified" : "failed",
        provider_ref: providerRef,
        message: isSuccess ? "KYC verification successful" : verificationResult.reason,
        trust_score: updatedTrustScore || undefined,
        verification: verificationRecord,
      }),
      {
        status: isSuccess ? 200 : 422,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
