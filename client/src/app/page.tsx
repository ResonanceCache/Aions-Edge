import Link from "next/link";
import { getServerAuthSession } from "~/server/auth";
import { api, HydrateClient } from "~/trpc/server";

export default async function Home() {
  const hello = await api.post.hello({ text: "from tRPC" });
  const session = await getServerAuthSession();

  // void api.post.getLatest.prefetch();



  return (
    <HydrateClient>

      <h1 className="text-5xl font-extrabold tracking-tight sm:text-[5rem]">
        Aion&apos;s Edge

      </h1>
      <div>
        {hello ? hello.greeting : "Some Text"}
      </div>
    </HydrateClient>
  );
}
