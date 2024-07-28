import { api, HydrateClient } from "~/trpc/server";

interface Stock {
  id: number;
  name?: string | null;
  createdById?: string | null;
  createdAt?: Date | null;
  updatedAt?: Date | null;
  ticker?: string | null;
}

export default async function Home() {

  const stocks: Stock[] = await api.stock.get();
  
  return (
    <HydrateClient>
      <div className="min-h-full">
        <table>
          <tbody>
            {stocks.map((stock, index) => (
              <tr key={index}>
                <td>{stock.id}</td>
                <td>{stock.name}</td>
                <td>{stock.ticker}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </HydrateClient>
  );
}