import React, { useState } from 'react';

export default function SymbolsInput({ onSymbolsChange }) {
    const [symbols, setSymbols] = useState('');

    const handleSymbolsChange = (event) => {
        const symbolList = event.target.value;
        setSymbols(symbolList);
        onSymbolInput(symbolList);
        console.log("JUST CALLED")
    };

    return (
        <div>
            <input type="text" value={symbols} onChange={handleSymbolsChange} />
        </div>
    );
}