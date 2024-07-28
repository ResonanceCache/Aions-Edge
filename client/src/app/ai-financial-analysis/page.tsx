import { HydrateClient } from "~/trpc/server";

export default async function Home() {
  return (
    <HydrateClient>
      <div className="min-h-full">
        AI Financial Analysis
      </div>
    </HydrateClient>
  );
}

