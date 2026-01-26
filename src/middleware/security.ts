import { ArcjetNodeRequest } from "@arcjet/node";
import aj from "../config/arcjet.js";
import { Response, Request, NextFunction } from "express";

// Simplified security middleware - only handles shield and bot detection
// Rate limiting is now applied per-route in individual route handlers
const securityMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  if (process.env.NODE_ENV === "test") return next();

  try {
    const arcjetRequest: ArcjetNodeRequest = {
      headers: req.headers,
      method: req.method,
      url: req.originalUrl ?? req.url,
      socket: {
        remoteAddress: req.socket.remoteAddress ?? "0.0.0.0",
      },
    };

    const decision = await aj.protect(arcjetRequest);

    if (decision.isDenied() && decision.reason.isBot()) {
      return res
        .status(403)
        .json({ error: "Forbidden", message: "Bot traffic detected" });
    }

    if (decision.isDenied() && decision.reason.isShield()) {
      return res.status(403).json({
        error: "Forbidden",
        message: "Request blocked by security policy",
      });
    }

    next();
  } catch (error) {
    console.log("Arcjet middleware error", error);
    res
      .status(500)
      .json({ error: "Internal Error", message: "Internal Server Error" });
  }
};

export default securityMiddleware;
