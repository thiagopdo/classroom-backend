import { and, desc, eq, getTableColumns, ilike, or, sql } from "drizzle-orm";
import express from "express";
import { departments, subjects } from "../db/schema";
import { db } from "../db";

const router = express.Router();

const MAX_LIMIT = 100;

//Get all subjects with optional department filter and pagination
router.get("/", async (req, res) => {
  try {
    const { search, department, page = 1, limit = 10 } = req.query;

    const pageValue = Array.isArray(page) ? page[0] : page;
    const limitValue = Array.isArray(limit) ? limit[0] : limit;

    const parsedPage = parseInt(pageValue as string, 10);
    const parsedLimit = parseInt(limitValue as string, 10);

    const currentPage = Math.max(1, Number.isNaN(parsedPage) ? 1 : parsedPage);
    const limitPerPage = Math.min(
      MAX_LIMIT,
      Math.max(1, Number.isNaN(parsedLimit) ? 1 : parsedLimit),
    );

    const offset = (currentPage - 1) * limitPerPage;

    const filterConditions = [];

    //if search query exists, filter by name OR subject code
    if (search) {
      filterConditions.push(
        or(
          ilike(subjects.name, `%${search}%`),
          ilike(subjects.code, `%${search}%`),
        ),
      );
    }
    //if department query exists, filter by departmentId
    if (department) {
      const deptPattern = `%${String(department).replace(/[%_]/g, "\\$&")}%`;

      filterConditions.push(ilike(departments.name, deptPattern));
    }

    //Combine all filters using AND if any filters exist
    const whereClause =
      filterConditions.length > 0 ? and(...filterConditions) : undefined;

    const countResult = await db
      .select({ count: sql<number>`count(*)` })
      .from(subjects)
      .leftJoin(departments, eq(subjects.departmentId, departments.id))
      .where(whereClause);
    const totalCount = countResult[0]?.count ?? 0;

    const subjectsList = await db
      .select({
        ...getTableColumns(subjects),
        department: { ...getTableColumns(departments) },
      })
      .from(subjects)
      .leftJoin(departments, eq(subjects.departmentId, departments.id))
      .where(whereClause)
      .orderBy(desc(subjects.createdAt))
      .limit(limitPerPage)
      .offset(offset);

    res.status(200).json({
      data: subjectsList,
      pagination: {
        page: currentPage,
        limit: limitPerPage,
        total: totalCount,
        totalPages: Math.ceil(totalCount / limitPerPage),
      },
    });
  } catch (error) {
    console.log(`Get /subjects error: ${error}`);
    res.status(500).json({ error: "Failed to get the subjects" });
  }
});

export default router;