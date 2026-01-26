import { ArcjetNodeRequest, slidingWindow } from "@arcjet/node";
import aj from "../config/arcjet.js";
import { Response, Request, NextFunction } from "express";

/**
 * Creates a rate limiting middleware for specific routes based on user role
 * Uses Arcjet's singleton client with per-route withRule() pattern
 *
 * @returns Express middleware function that applies role-based rate limiting
 */
export const createRateLimitMiddleware = () => {
  return async (req: Request, res: Response, next: NextFunction) => {
    if (process.env.NODE_ENV === "test") return next();

    try {
      const role: RateLimitRole = req.user?.role ?? "guest";

      let limit: number;
      let message: string;

      switch (role) {
        case "admin":
          limit = 20;
          message = "Admin request limit exceeded (20 per minute)";
          break;
        case "teacher":
          limit = 20;
          message = "Teacher request limit exceeded (20 per minute)";
          break;
        case "student":
          limit = 10;
          message =
            "Student request limit exceeded (10 per minute). Please wait.";
          break;
        default:
          limit = 5;
          message =
            "Guest request limit exceeded (5 per minute). Please Sign up for higher limit.";
      }

      // Apply rate limiting rule to the singleton client for this specific request
      const client = aj.withRule(
        slidingWindow({
          mode: "LIVE",
          interval: "1m",
          max: limit,
        }),
      );

      const arcjectRequest: ArcjetNodeRequest = {
        headers: req.headers,
        method: req.method,
        url: req.originalUrl ?? req.url,
        socket: {
          remoteAddress: req.socket.remoteAddress ?? req.ip ?? "0.0.0.0",
        },
      };

      const decision = await client.protect(arcjectRequest);

      if (decision.isDenied() && decision.reason.isRateLimit()) {
        return res.status(429).json({ error: "Forbidden", message });
      }

      next();
    } catch (error) {
      console.log("Rate limit middleware error", error);
      res
        .status(500)
        .json({ error: "Internal Error", message: "Internal Server Error" });
    }
  };
};
