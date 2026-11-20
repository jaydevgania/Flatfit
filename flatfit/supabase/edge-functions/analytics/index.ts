// edge-functions/analytics/index.ts
// Log funnel events and user behavior metrics

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface AnalyticsPayload {
  event_name: string;
  user_id?: string;
  session_id?: string;
  event_category?: "acquisition" | "activation" | "engagement" | "monetization" | "retention";
  properties?: Record<string, any>;
  platform?: "android" | "ios" | "web";
  app_version?: string;
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const body = await req.json();

    // Support single event or batch of events
    const events: AnalyticsPayload[] = Array.isArray(body) ? body : [body];

    if (events.length === 0 || !events[0].event_name) {
      return new Response(JSON.stringify({ error: "Invalid payload or empty event_name" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const rowsToInsert = events.map((ev) => ({
      user_id: ev.user_id || null,
      session_id: ev.session_id || null,
      event_name: ev.event_name,
      event_category: ev.event_category || "engagement",
      properties: ev.properties || {},
      platform: ev.platform || "android",
      app_version: ev.app_version || "1.0.0",
      created_at: new Date().toISOString(),
    }));

    const { error: insertError } = await supabase
      .from("analytics_events")
      .insert(rowsToInsert);

    if (insertError) throw insertError;

    return new Response(
      JSON.stringify({
        success: true,
        logged_events_count: rowsToInsert.length,
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
