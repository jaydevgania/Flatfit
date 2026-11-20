// edge-functions/process-payment/index.ts
// Payment processing edge function (Mock Razorpay integration)

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface PaymentActionRequest {
  action: "create_order" | "verify_payment" | "webhook";
  user_id: string;
  amount: number; // in INR
  type: "subscription" | "service" | "listing_fee" | "rent_collection";
  // For verify_payment:
  order_id?: string;
  payment_id?: string;
  signature?: string;
  // Metadata:
  metadata?: Record<string, any>;
  plan?: "free" | "plus";
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const body: PaymentActionRequest = await req.json();
    const { action, user_id, amount, type, order_id, payment_id, metadata = {}, plan = "plus" } = body;

    const now = new Date().toISOString();

    if (action === "create_order") {
      if (!user_id || !amount || !type) {
        return new Response(JSON.stringify({ error: "Missing user_id, amount, or type" }), {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // Generate mock Razorpay Order ID (e.g. order_EKwx712901)
      const mockOrderId = `order_${Date.now().toString(36)}_${Math.random().toString(36).substring(7)}`;

      // Insert record in payments table
      const { data: paymentRecord, error: paymentError } = await supabase
        .from("payments")
        .insert({
          user_id,
          amount,
          currency: "INR",
          type,
          status: "pending",
          provider: "razorpay",
          provider_order_id: mockOrderId,
          metadata: {
            ...metadata,
            plan: type === "subscription" ? plan : undefined,
          },
        })
        .select()
        .single();

      if (paymentError) throw paymentError;

      return new Response(
        JSON.stringify({
          success: true,
          order_id: mockOrderId,
          amount_in_paise: Math.round(amount * 100),
          currency: "INR",
          payment_record_id: paymentRecord.id,
          key_id: "rzp_test_mockKeyId123456",
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    } else if (action === "verify_payment") {
      if (!order_id || !payment_id) {
        return new Response(JSON.stringify({ error: "Missing order_id or payment_id" }), {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // 1. Fetch pending payment record
      const { data: paymentRecord, error: fetchError } = await supabase
        .from("payments")
        .select("*")
        .eq("provider_order_id", order_id)
        .single();

      if (fetchError || !paymentRecord) {
        return new Response(JSON.stringify({ error: "Payment record not found for order_id" }), {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // 2. Mark payment completed
      const { error: updateError } = await supabase
        .from("payments")
        .update({
          status: "completed",
          provider_ref: payment_id,
          updated_at: now,
        })
        .eq("id", paymentRecord.id);

      if (updateError) throw updateError;

      // 3. Post-payment actions: If subscription, activate subscription
      let subscriptionData = null;
      if (paymentRecord.type === "subscription") {
        const subPlan = paymentRecord.metadata?.plan || "plus";
        // 30 days active
        const endsAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

        const { data: subRecord, error: subError } = await supabase
          .from("subscriptions")
          .insert({
            user_id: paymentRecord.user_id,
            plan: subPlan,
            starts_at: now,
            ends_at: endsAt,
            is_active: true,
            payment_id: paymentRecord.id,
            auto_renew: true,
          })
          .select()
          .single();

        if (subError) throw subError;
        subscriptionData = subRecord;
      }

      // 4. Audit Log
      await supabase.from("audit_logs").insert({
        user_id: paymentRecord.user_id,
        action: "payment.completed",
        entity_type: "payment",
        entity_id: paymentRecord.id,
        metadata: {
          order_id,
          payment_id,
          amount: paymentRecord.amount,
          type: paymentRecord.type,
        },
      });

      return new Response(
        JSON.stringify({
          success: true,
          status: "completed",
          order_id,
          payment_id,
          subscription: subscriptionData,
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(JSON.stringify({ error: `Unsupported action: ${action}` }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
