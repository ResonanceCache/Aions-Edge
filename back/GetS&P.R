install.packages("dplyr")
require("dplyr")
require(devtools)
require(quantstrat)
require(DSTrading)
require(IKTrading)

#get symbols
SP500 <- read.csv("../data/constituents_csv.csv")
NASDAQ <- read.table("nasdaqlisted.txt",sep="|",header=T)

SPSymbols <- select(SP500, Symbol)
NASDAQSymbols <- select(NASDAQ, Symbol)
Symbols <- unique(rbind(SPSymbols, NASDAQSymbols))[order("Symbol")]

class(symbols)
head(symbols)
tail(symbols)

# getSymbols(Symbols=Symbols, from="2023-01-01", to="2023-12-31")
getSymbols(Symbols=(SP500[,"Symbol"]), from="2023-01-01", to="2023-12-31")

