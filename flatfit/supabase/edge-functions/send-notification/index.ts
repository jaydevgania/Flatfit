// edge-functions/send-notification/index.ts
// Send push / WhatsApp / SMS / Email notifications via provider interface

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type NotificationChannel = "push" | "whatsapp" | "sms" | "email";

interface NotificationPayload {
  user_id: string;
  title: string;
  body: string;
  type: string;
  channel?: NotificationChannel;
  data?: Record<string, any>;
  action_url?: string;
  phone?: string;
  email?: string;
}

// --- Provider Interfaces & Mock Implementations ---

interface ProviderResult {
  success: boolean;
  provider_ref?: string;
  channel: NotificationChannel;
  error?: string;
}

class PushProvider {
  async send(token: string, title: string, body: string, data?: Record<string, any>): Promise<ProviderResult> {
    // In production, would call Firebase Cloud Messaging (FCM) or Apple APNS
    console.log(`[PushProvider] Sending to token: ${token.substring(0, 10)}... | ${title}: ${body}`);
    return {
      success: true,
      channel: "push",
      provider_ref: `fcm_${Date.now()}_${Math.random().toString(36).substring(7)}`,
    };
  }
}

class WhatsAppProvider {
  async send(phone: string, message: string, templateData?: Record<string, any>): Promise<ProviderResult> {
    // In production, calls Gupshup, Twilio, or Meta Cloud API
    console.log(`[WhatsAppProvider] Sending to ${phone}: ${message}`);
    return {
      success: true,
      channel: "whatsapp",
      provider_ref: `wa_${Date.now()}_${Math.random().toString(36).substring(7)}`,
    };
  }
}

class SmsProvider {
  async send(phone: string, message: string): Promise<ProviderResult> {
    // In production, calls MSG91, Kaleyra, or Twilio
    console.log(`[SmsProvider] Sending SMS to ${phone}: ${message}`);
    return {
      success: true,
      channel: "sms",
      provider_ref: `sms_${Date.now()}_${Math.random().toString(36).substring(7)}`,
    };
  }
}

class EmailProvider {
  async send(email: string, subject: string, body: string): Promise<ProviderResult> {
    // In production, calls Resend or SendGrid
    console.log(`[EmailProvider] Sending Email to ${email} | Subject: ${subject}`);
    return {
      success: true,
      channel: "email",
      provider_ref: `mail_${Date.now()}_${Math.random().toString(36).substring(7)}`,
    };
  }
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const payload: NotificationPayload = await req.json();
    const { user_id, title, body, type, data = {}, action_url } = payload;

    if (!user_id || !title || !body) {
      return new Response(JSON.stringify({ error: "Missing user_id, title, or body" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 1. Fetch user's notification preferences
    const { data: prefs } = await supabase
      .from("notification_preferences")
      .select("*")
      .eq("user_id", user_id);

    // Determine target channel (default to push)
    let selectedChannel: NotificationChannel = payload.channel || "push";

    if (prefs && prefs.length > 0) {
      const channelPref = prefs.find((p) => p.channel === selectedChannel);
      if (channelPref && !channelPref.enabled) {
        // Preferred channel disabled, fallback to push or log
        const pushPref = prefs.find((p) => p.channel === "push");
        if (pushPref && pushPref.enabled) {
          selectedChannel = "push";
        }
      }
    }

    // 2. Dispatch via appropriate provider
    let result: ProviderResult = { success: false, channel: selectedChannel };

    switch (selectedChannel) {
      case "push": {
        // Find user push tokens
        const { data: tokens } = await supabase
          .from("push_tokens")
          .select("token")
          .eq("user_id", user_id)
          .eq("is_active", true);

        const pushProvider = new PushProvider();
        const primaryToken = tokens?.[0]?.token || "mock_device_token_xyz";
        result = await pushProvider.send(primaryToken, title, body, data);
        break;
      }
      case "whatsapp": {
        const waProvider = new WhatsAppProvider();
        result = await waProvider.send(payload.phone || "+919876543210", `${title}\n\n${body}`, data);
        break;
      }
      case "sms": {
        const smsProvider = new SmsProvider();
        result = await smsProvider.send(payload.phone || "+919876543210", `${title}: ${body}`);
        break;
      }
      case "email": {
        const emailProvider = new EmailProvider();
        result = await emailProvider.send(payload.email || "user@example.com", title, body);
        break;
      }
    }

    // 3. Record in notifications table
    const now = new Date().toISOString();
    const { data: insertedNotification, error: insertError } = await supabase
      .from("notifications")
      .insert({
        user_id,
        title,
        body,
        type: type || "system",
        channel: selectedChannel,
        data: {
          ...data,
          provider_ref: result.provider_ref,
        },
        action_url,
        is_read: false,
        sent_at: result.success ? now : null,
        delivered_at: result.success ? now : null,
      })
      .select()
      .single();

    if (insertError) throw insertError;

    return new Response(
      JSON.stringify({
        success: true,
        channel: selectedChannel,
        provider_ref: result.provider_ref,
        notification: insertedNotification,
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
