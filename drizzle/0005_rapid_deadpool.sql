ALTER TABLE "departments" DROP CONSTRAINT "departments_name_unique";--> statement-breakpoint
DROP INDEX "enrollments_student_class_unique";--> statement-breakpoint
ALTER TABLE "classes" ALTER COLUMN "invite_code" SET DATA TYPE varchar(50);--> statement-breakpoint
ALTER TABLE "departments" ALTER COLUMN "code" SET DATA TYPE varchar(50);--> statement-breakpoint
ALTER TABLE "departments" ALTER COLUMN "description" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "subjects" ALTER COLUMN "description" SET DATA TYPE text;--> statement-breakpoint
CREATE INDEX "enrollments_student_class_unique" ON "enrollments" USING btree ("student_id","class_id");--> statement-breakpoint
ALTER TABLE "classes" DROP COLUMN "schedules";