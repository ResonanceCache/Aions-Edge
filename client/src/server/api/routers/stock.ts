import { z } from "zod";

import {
    createTRPCRouter,
    publicProcedure,
} from "~/server/api/trpc";
import { stocks } from "~/server/db/schema";

export const stockRouter = createTRPCRouter({

    create: publicProcedure
        .input(z.object({ ticker: z.string().min(1), createdById: z.string().min(1) }))
        .mutation(async ({ ctx, input }) => {
            await ctx.db.insert(stocks).values({
                ticker: input.ticker,
                createdById: input.createdById,
            });
        }),
    get: publicProcedure
        .query(async ({ ctx }) => {
            const result = await ctx.db.select().from(stocks).execute();
            return result;
        }),
    // getByTicker: publicProcedure
    //     .input(z.object({ ticker: z.string().min(1) }))
    //     .query(async ({ ctx, input }) => {
    //         const result = await ctx.db.select().from(stocks).where({ ticker: input.ticker }).execute();
    //         return result;
    //     }),
});
