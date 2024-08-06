'use client';

import {useState } from "react";

export default function Home() {

  const [inputValue, setInputValue] = useState("");

  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      if (inputValue) {
        window.location.href = `/stocks/${inputValue}`;
      }
    }}>
      <div className="flex flex-col items-center justify-center h-full">
        <div className="flex flex-row justify-center items-center">
          <h1 className="text-4xl text-center">Type a company to get started</h1>
          <br />
          <input
            className="border border-gray-300 rounded-md px-4 py-2"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
          />
          <button type="submit" className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            Go
          </button>
        </div>
      </div>
    </form>
  );
};
