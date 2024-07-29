import { HydrateClient } from "~/trpc/server";

export default async function Home() {
  return (
    <HydrateClient>
      <div className="min-h-full">
        Aions Edge
      </div>
    </HydrateClient>
  );
}

