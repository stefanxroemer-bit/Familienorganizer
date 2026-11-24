// Supabase Edge Function "kalender"
// Holt die geheimen iCloud-Kalender-Links (aus den Secrets) und gibt den Inhalt an die App weiter.
// Secrets: ICAL_FAMILIE, ICAL_KIND  (Edge Functions → Secrets)
// Nur eingeloggte Nutzer dürfen aufrufen ("Verify JWT" bleibt AN).

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const quellen: Record<string, string | undefined> = {
    familie: Deno.env.get("ICAL_FAMILIE"),
    kind: Deno.env.get("ICAL_KIND"),
  };

  const ergebnis: Record<string, string | null> = {};
  for (const [name, url] of Object.entries(quellen)) {
    if (!url) { ergebnis[name] = null; continue; }
    try {
      const r = await fetch(url.trim().replace(/^webcal:/i, "https:"));
      ergebnis[name] = r.ok ? await r.text() : null;
    } catch (_) {
      ergebnis[name] = null;
    }
  }

  return new Response(JSON.stringify(ergebnis), {
    headers: { ...cors, "Content-Type": "application/json" },
  });
});
