ALTER TABLE "classes" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "departments" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "enrollments" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "subjects" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
DROP TABLE "classes" CASCADE;--> statement-breakpoint
DROP TABLE "departments" CASCADE;--> statement-breakpoint
DROP TABLE "enrollments" CASCADE;--> statement-breakpoint
DROP TABLE "subjects" CASCADE;--> statement-breakpoint
ALTER TABLE "session" DROP CONSTRAINT "session_session_token_unique";--> statement-breakpoint
ALTER TABLE "user" DROP CONSTRAINT "user_email_unique";--> statement-breakpoint
ALTER TABLE "verification" DROP CONSTRAINT "verification_token_unique";--> statement-breakpoint
ALTER TABLE "session" DROP CONSTRAINT "session_user_id_user_id_fk";
--> statement-breakpoint
ALTER TABLE "account" ALTER COLUMN "id" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "session" ALTER COLUMN "id" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "session" ALTER COLUMN "id" DROP IDENTITY;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "id" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "name" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "name" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "email" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "image" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "id" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "id" DROP IDENTITY;--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "identifier" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "token" text NOT NULL;--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "expires_at" timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "ip_address" text;--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "user_agent" text;--> statement-breakpoint
ALTER TABLE "verification" ADD COLUMN "value" text NOT NULL;--> statement-breakpoint
ALTER TABLE "verification" ADD COLUMN "expires_at" timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE "session" ADD CONSTRAINT "session_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "session_token_unique" ON "session" USING btree ("token");--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "session_token";--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "expires";--> statement-breakpoint
ALTER TABLE "verification" DROP COLUMN "token";--> statement-breakpoint
ALTER TABLE "verification" DROP COLUMN "expires";--> statement-breakpoint
DROP TYPE "public"."class_status";