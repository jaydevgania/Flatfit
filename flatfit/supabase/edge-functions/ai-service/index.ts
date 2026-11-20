// edge-functions/ai-service/index.ts
// Provider-agnostic LLM interface for FlatFit AI features (bio generation, match compatibility summary, listing enhancer)

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface AiRequest {
  task: "generate_bio" | "compatibility_summary" | "enhance_listing" | "dispute_mediation_suggestion";
  prompt?: string;
  context?: Record<string, any>;
}

// Provider-agnostic LLM caller (Gemini / OpenAI / fallback mock)
async function callLlmProvider(task: string, prompt: string, context?: Record<string, any>): Promise<string> {
  const geminiApiKey = Deno.env.get("GEMINI_API_KEY");
  const openAiApiKey = Deno.env.get("OPENAI_API_KEY");

  if (geminiApiKey) {
    try {
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${geminiApiKey}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [
              {
                parts: [
                  {
                    text: `You are FlatFit AI, an Indian flatmate compatibility assistant. Task: ${task}.\nContext: ${JSON.stringify(
                      context || {}
                    )}\nUser Request: ${prompt}`,
                  },
                ],
              },
            ],
          }),
        }
      );
      const data = await response.json();
      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;
      if (generatedText) return generatedText.trim();
    } catch (e) {
      console.warn("Gemini API call failed, falling back to built-in generator:", e);
    }
  }

  if (openAiApiKey) {
    try {
      const response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${openAiApiKey}`,
        },
        body: JSON.stringify({
          model: "gpt-3.5-turbo",
          messages: [
            {
              role: "system",
              content:
                "You are FlatFit AI, an Indian flatmate compatibility assistant. Provide concise, friendly, and practical responses.",
            },
            {
              role: "user",
              content: `Task: ${task}\nContext: ${JSON.stringify(context || {})}\nPrompt: ${prompt}`,
            },
          ],
        }),
      });
      const data = await response.json();
      const text = data?.choices?.[0]?.message?.content;
      if (text) return text.trim();
    } catch (e) {
      console.warn("OpenAI API call failed, falling back to built-in generator:", e);
    }
  }

  // Fallback heuristic generator when external API keys are not supplied
  switch (task) {
    case "generate_bio": {
      const name = context?.name || "Hey";
      const occupation = context?.occupation || "professional";
      const locality = context?.preferred_localities?.[0] || "Mumbai";
      const habits = context?.habits || "neat, chill, and respectful of personal space";
      return `Hi, I'm ${name}! Working in ${occupation} and looking for a compatible flat in ${locality}. I'm ${habits}. Love unwinding with good music and weekend coffee, and always prompt with bills and cleaning.`;
    }
    case "compatibility_summary": {
      const score = context?.score || 85;
      const common = context?.compatible_topics?.join(", ") || "Cleanliness, Sleep schedule, Rent punctuality";
      const watch = context?.watch_out_topics?.join(", ") || "Guest policies";
      return `You both share great compatibility (${score}% match)! Strong alignment on ${common}. The main difference is around ${watch}, so discussing that early over chai will ensure a smooth living dynamic!`;
    }
    case "enhance_listing": {
      const title = context?.title || "Spacious room in 2BHK";
      const locality = context?.locality || "Andheri West";
      const rent = context?.rent || "25,000";
      return `✨ Modern & Bright Room in ${locality} (₹${rent}/mo) ✨\n\nLooking for a chill flatmate to share this beautiful home. Fully ventilated, high-speed WiFi, attached washroom, and vibrant society near metro. Clean, peaceful vibe with shared kitchen and split bills. Move-in ready!`;
    }
    case "dispute_mediation_suggestion": {
      return `Resolution Recommendation: We suggest establishing a transparent digital ledger for split utilities and agreeing on 24-hour advance notice for overnight weekend guests. Both parties share equal deposit refund responsibilities as outlined in the FlatFit agreement.`;
    }
    default:
      return "FlatFit AI processed your request successfully.";
  }
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body: AiRequest = await req.json();
    const { task, prompt = "", context = {} } = body;

    if (!task) {
      return new Response(JSON.stringify({ error: "Missing required field: task" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const result = await callLlmProvider(task, prompt, context);

    return new Response(
      JSON.stringify({
        success: true,
        task,
        result,
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
