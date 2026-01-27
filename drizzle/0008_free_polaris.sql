ALTER TABLE "account" DROP CONSTRAINT "account_user_id_user_id_fk";
--> statement-breakpoint
ALTER TABLE "session" DROP CONSTRAINT "session_user_id_user_id_fk";
--> statement-breakpoint
DROP INDEX "account_provider_account_unique";--> statement-breakpoint
DROP INDEX "session_token_unique";--> statement-breakpoint
ALTER TABLE "account" ALTER COLUMN "id" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "account" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (sequence name "account_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1);--> statement-breakpoint
ALTER TABLE "account" ALTER COLUMN "provider_id" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "account" ALTER COLUMN "scope" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "session" ALTER COLUMN "id" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "session" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (sequence name "session_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1);--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "name" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "name" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "email" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "user" ALTER COLUMN "image" SET DATA TYPE varchar(1024);--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "id" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (sequence name "verification_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1);--> statement-breakpoint
ALTER TABLE "verification" ALTER COLUMN "identifier" SET DATA TYPE varchar(255);--> statement-breakpoint
ALTER TABLE "account" ADD COLUMN "provider_account_id" varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE "account" ADD COLUMN "expires_at" integer;--> statement-breakpoint
ALTER TABLE "account" ADD COLUMN "token_type" varchar(255);--> statement-breakpoint
ALTER TABLE "account" ADD COLUMN "session_state" varchar(255);--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "session_token" varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE "session" ADD COLUMN "expires" timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE "verification" ADD COLUMN "token" varchar(255) NOT NULL;--> statement-breakpoint
ALTER TABLE "verification" ADD COLUMN "expires" timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE "account" ADD CONSTRAINT "account_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "session" ADD CONSTRAINT "session_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "account_provider_provider_account_id" ON "account" USING btree ("provider_id","provider_account_id");--> statement-breakpoint
ALTER TABLE "account" DROP COLUMN "access_token_expires_at";--> statement-breakpoint
ALTER TABLE "account" DROP COLUMN "refresh_token_expires_at";--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "token";--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "expires_at";--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "ip_address";--> statement-breakpoint
ALTER TABLE "session" DROP COLUMN "user_agent";--> statement-breakpoint
ALTER TABLE "verification" DROP COLUMN "value";--> statement-breakpoint
ALTER TABLE "verification" DROP COLUMN "expires_at";--> statement-breakpoint
ALTER TABLE "session" ADD CONSTRAINT "session_session_token_unique" UNIQUE("session_token");--> statement-breakpoint
ALTER TABLE "user" ADD CONSTRAINT "user_email_unique" UNIQUE("email");--> statement-breakpoint
ALTER TABLE "verification" ADD CONSTRAINT "verification_token_unique" UNIQUE("token");