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
    // update: publicProcedure
    //     .input(z.object({ ticker: z.string().min(1), name: z.string() }))
    //     .mutation(async ({ ctx, input }) => {
    //         try {
    //             const result = await ctx.db.update(stocks)
    //                 .set({ name: input.name })
    //                 .where({ ticker: input.ticker })
    //                 .execute();
    //             return result;
    //         } catch (error) {
    //             console.error("Error updating stock:", error);
    //             throw new Error("Failed to update stock.");
    //         }
    //     }),
});
