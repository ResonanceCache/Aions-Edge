require(quantstrat)
require(IKTrading)

options("getSymbols.warning4.0"=FALSE)
rm(list=ls(.blotter), envir=.blotter)
currency("USD")
Sys.setenv(TZ="UTC")

symbols <- "SPY"
suppressMessages(getSymbols(symbols, from="1998-01-01", to="2023-12-31"))
stock(symbols, currency="USD", multiplier=1)
initDate="1990-01-01"
head(symbols)

chart_Series(SPY)
zoom_Chart("1998-01-01::2023-12-31")

tradeSize <- 100000
initEq <- tradeSize*length(symbols)

strategy.st <- portfolio.st <- account.st <- "RSI_10_6"
rm.strat(portfolio.st)
rm.strat(strategy.st)
initPortf(portfolio.st, symbols=symbols, initDate=initDate, currency="USD")
initAcct(account.st, portfolios=portfolio.st, initDate=initDate, currency="USD", initEq=initEq)
initOrders(portfolio.st, initDate=initDate)
strategy(strategy.st, store=TRUE)

# parameters
nRSI = 2
thresh1 = 10
thresh2 = 6

nSMAexit = 5
nSMAfilter = 200

period = 10
pctATR = .02
maxPct = .04

#indicators
add.indicator(strategy.st, name="lagATR", arguments=list(HLC=quote(HLC(mktdata)), n=period), label = "atrX")
add.indicator(strategy.st, name="RSI", arguments=list(price=quote(Cl(mktdata)), n=nRSI), label = "rsi")
add.indicator(strategy.st, name="SMA", arguments=list(x=quote(Cl(mktdata)), n=nSMAexit), label = "quickMA")
add.indicator(strategy.st, name="SMA", arguments=list(x=quote(Cl(mktdata)), n=nSMAfilter), label = "filterMA")

#signals
add.signal(strategy.st, name = "sigComparison", 
           arguments=list(columns=c("lose", "filterMA"), relationship="gt"), 
                          label="upTrend")

add.signal(strategy.st, name = "sigThreshold", 
           arguments=list(column="rsi", threshold=thresh1, 
                          relationship="lt", cross=FALSE), 
           label = "rsiThresh1")

add.signal(strategy.st, name = "sigThreshold", 
           arguments=list(column="rsi", threshold=thresh2, 
                          relationship="lt", cross=FALSE), 
           label="rsiThresh2")

add.signal(strategy.st, name = "sigAND", 
           arguments=list(columns=c("rsiThresh1", "upTrend"), cross=TRUE), 
           label="longEntry1")

add.signal(strategy.st, name = "sigAND", 
           arguments=list(columns=c("rsiThresh2", "upTrend"), cross=TRUE), 
           label="longEntry2")

add.signal(strategy.st, name = "sigCrossover", 
           arguments=list(columns=c("close", "quickMA"), relationship="gt"), 
           label="exitLongNormal")

add.signal(strategy.st, name = "sigCrossover", 
           arguments=list(columns=c("close", "filterMA"), relationship="lt"), 
           label="exitLongFilter")

#rules
add.rule(strategy.st, name="ruleSignal",
         arguments=list(sigcol="longEntry1",
                        sigval=TRUE,
                        ordertype="market",
                        orderside="long",
                        replace=FALSE,
                        prefer="Open",
                        osFUN=osDollarATR,
                        tradeSize=tradeSize,
                        pctATR=pctATR,
                        maxPctATR=maxPct,
                        atrMod="X"),
         type="enter", path.dep=TRUE, label="enterLong1")

add.rule(strategy.st, name="ruleSignal",
         arguments=list(sigcol="longEntry2",
                        sigval=TRUE,
                        ordertype="market",
                        orderside="long",
                        replace=FALSE,
                        prefer="Open",
                        osFUN=osDollarATR,
                        tradeSize=tradeSize,
                        pctATR=pctATR,
                        maxPctATR=maxPct,
                        atrMod="X"),
         type="enter", path.dep=TRUE, label="enterLong2")
add.rule(strategy.st, name="ruleSignal",
         arguments=list(sigcol="exitLongNormal",
                        sigval=TRUE,
                        orderqty="all",
                        ordertype="market",
                        orderside="long",
                        replace=FALSE,
                        prefer="Open"),
         type="exit", path.dep=TRUE, label="normalExitLong")

add.rule(strategy.st, name="ruleSignal",
         arguments=list(sigcol="exitLongFilter",
                        sigval=TRUE,
                        orderqty="all",
                        ordertype="market",
                        orderside="long",
                        replace=FALSE,
                        prefer="Open"),
         type="enter", path.dep=TRUE, label="filterExitLong")

t1 <- Sys.time()
out <- applyStrategy(strategy=strategy.st, portfolios=portfolio.st)
t2 <- Sys.time()
print(t2-t1)

updatePortf(portfolio.st)
dateRange <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(portfolio.st,dateRange)
updateEndEq(account.st)

args(durationStatistics)
durationStatistics(Portfolio=portfolio.st, Symbols=symbols)
