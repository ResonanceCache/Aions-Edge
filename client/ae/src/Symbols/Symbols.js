import {React, useState} from 'react';
import SymbolsInput from './SymbolsInput/SymbolsInput.js'

export default function Symbols(){
    const [symbols, setSymbols] = useState([])

    const handleSymbolInput = (symbol) => {
        setSymbols(prevSymbols => [...prevSymbols, symbol]);
    }

    return (
        <div>
            <p>Give me the name of a symbol!</p>
            <SymbolsInput onSymbolInput={handleSymbolInput} />
            <div>
                <p>Symbols:</p>
                <ul>
                    {symbols.map((symbol, index) => (
                        <li key={index}>{symbol}</li>
                    ))}
                </ul>
            </div>
            <p>Submit for Analysis</p>
            <button>Submit!</button>
        </div>
    );
}
    