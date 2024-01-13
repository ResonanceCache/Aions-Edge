require(IKTrading)
require(quantstrat)
require(PerformanceAnalytics)

initDate="1990-01-01"
from="2003-01-01"
to="2012-12-31"
options(width=70)

options("getSymbols.warning4.0"=FALSE)

currency('USD')
Sys.setenv(TZ="UTC")

symbols <- c("XLB", #SPDR Materials sector
             "XLE", #SPDR Energy sector
             "XLF", #SPDR Financial sector
             "XLP", #SPDR Consumer staples sector
             "XLI", #SPDR Industrial sector
             "XLU", #SPDR Utilities sector
             "XLV", #SPDR Healthcare sector
             "XLK", #SPDR Tech sector
             "XLY", #SPDR Consumer discretionary sector
             "RWR", #SPDR Dow Jones REIT ETF
             
             "EWJ", #iShares Japan
             "EWG", #iShares Germany
             "EWU", #iShares UK
             "EWC", #iShares Canada
             "EWY", #iShares South Korea
             "EWA", #iShares Australia
             "EWH", #iShares Hong Kong
             "EWS", #iShares Singapore
             "IYZ", #iShares U.S. Telecom
             "EZU", #iShares MSCI EMU ETF
             "IYR", #iShares U.S. Real Estate
             "EWT", #iShares Taiwan
             "EWZ", #iShares Brazil
             "EFA", #iShares EAFE
             "IGE", #iShares North American Natural Resources
             "EPP", #iShares Pacific Ex Japan
             "LQD", #iShares Investment Grade Corporate Bonds
             "SHY", #iShares 1-3 year TBonds
             "IEF", #iShares 3-7 year TBonds
             "TLT" #iShares 20+ year Bonds
)

#SPDR ETFs first, iShares ETFs afterwards
if(!"XLB" %in% ls()) { 
  suppressMessages(getSymbols(symbols, from=from, to=to, src="yahoo", adjust=TRUE))  
}

stock(symbols, currency="USD", multiplier=1)

#trade sizing and initial equity settings
tradeSize <- 100000
initEq <- tradeSize*length(symbols)

strategy.st <- portfolio.st <- account.st <- "DollarVsATRos"
rm.strat(strategy.st)
initPortf(portfolio.st, symbols=symbols, initDate=initDate, currency='USD')
initAcct(account.st, portfolios=portfolio.st, initDate=initDate, currency='USD',initEq=initEq)
initOrders(portfolio.st, initDate=initDate)
strategy(strategy.st, store=TRUE)

#parameters
pctATR <- .02
period <- 10
atrOrder <- TRUE

nRSI <- 2
buyThresh <- 20
sellThresh <- 80
nSMA <- 200

#indicators
add.indicator(strategy.st, name="lagATR", 
              arguments=list(HLC=quote(HLC(mktdata)), n=period), 
              label="atrX")

add.indicator(strategy.st, name="RSI",
              arguments=list(price=quote(Cl(mktdata)), n=nRSI),
              label="rsi")

add.indicator(strategy.st, name="SMA",
              arguments=list(x=quote(Cl(mktdata)), n=nSMA),
              label="sma")
#signals
add.signal(strategy.st, name="sigComparison",
           arguments=list(columns=c("Close", "sma"), relationship="gt"),
           label="filter")

add.signal(strategy.st, name="sigThreshold",
           arguments=list(column="rsi", threshold=buyThresh, 
                          relationship="lt", cross=FALSE),
           label="rsiLtThresh")

add.signal(strategy.st, name="sigAND",
           arguments=list(columns=c("filter", "rsiLtThresh"), cross=TRUE),
           label="longEntry")

add.signal(strategy.st, name="sigThreshold",
           arguments=list(column="rsi", threshold=sellThresh,
                          relationship="gt", cross=TRUE),
           label="longExit")

add.signal(strategy.st, name="sigCrossover",
           arguments=list(columns=c("Close", "sma"), relationship="lt"),
           label="filterExit")

#rules
if(atrOrder) {
  
  add.rule(strategy.st, name="ruleSignal", 
           arguments=list(sigcol="longEntry", sigval=TRUE, ordertype="market", 
                          orderside="long", replace=FALSE, prefer="Open", 
                          osFUN=osDollarATR, tradeSize=tradeSize, 
                          pctATR=pctATR, atrMod="X"), 
           type="enter", path.dep=TRUE)
} else { 
  add.rule(strategy.st, name="ruleSignal", 
           arguments=list(sigcol="longEntry", sigval=TRUE, ordertype="market", 
                          orderside="long", replace=FALSE, prefer="Open", 
                          osFUN=osMaxDollar, tradeSize=tradeSize, maxSize=tradeSize), 
           type="enter", path.dep=TRUE)
}

add.rule(strategy.st, name="ruleSignal", 
         arguments=list(sigcol="longExit", sigval=TRUE, orderqty="all", 
                        ordertype="market", orderside="long", 
                        replace=FALSE, prefer="Open"), 
         type="exit", path.dep=TRUE)

add.rule(strategy.st, name="ruleSignal", 
         arguments=list(sigcol="filterExit", sigval=TRUE, orderqty="all", 
                        ordertype="market", orderside="long", replace=FALSE, 
                        prefer="Open"), 
         type="exit", path.dep=TRUE)

#apply strategy
t1 <- Sys.time()
out <- applyStrategy(strategy=strategy.st,portfolios=portfolio.st)
t2 <- Sys.time()
print(t2-t1)

#set up analytics
updatePortf(portfolio.st)
dateRange <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(portfolio.st,dateRange)
updateEndEq(account.st)

args(durationStatistics)
durationStatistics(Portfolio=portfolio.st, Symbols=symbols)

tStats <- tradeStats(Portfolio=portfolio.st, use="trades", inclZeroDays=FALSE)
tStats[,4:ncol(tStats)] <- round(tStats[,4:ncol(tStats)], 2)
