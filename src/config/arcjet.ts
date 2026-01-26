import arcjet, { shield, detectBot } from "@arcjet/node";
import { env } from "process";


const key =
  env.ARCJET_KEY ?? (env.NODE_ENV === "test" ? "test-key" : undefined);

if (!key) {
  throw new Error("ARCJET_KEY is not defined in environment variables");
}

// Singleton Arcjet client with base rules (shield and bot detection)
// Rate limiting is applied per-route using aj.withRule() in route handlers
const aj = arcjet({
  key, // Get your site key from https://app.arcjet.com
  rules: [
    shield({ mode: "LIVE" }),

    detectBot({
      mode: "LIVE",
      allow: [
        "CATEGORY:SEARCH_ENGINE", // Google, Bing, etc
        "CATEGORY:PREVIEW",
      ],
    }),
  ],
});

export default aj;
