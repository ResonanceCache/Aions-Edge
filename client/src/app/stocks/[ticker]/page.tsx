'use client'

import React from 'react'
import { usePathname } from 'next/navigation'

const Page = () => {
    const pathname = usePathname()
    const ticker = pathname.split('/')[pathname.split('/').length - 1];
    return (
        <div>
            {ticker}
        </div>
    )
}

export default Page
