# variable <- 2+2
# variable

# install.packages("devtools")
# install_github("braverock/blotter") # dependency
# install_github("braverock/quantstrat")
# install.packages("zoo")
# install.packages("Defaults")
# install_github(repo="IlyaKipnis/IKTrading")
# install_github(repo="IlyaKipnis/DSTrading")

require(devtools)
require(quantstrat)
require(DSTrading)
require(IKTrading)

#Get SPY
getSymbols(Symbols="SPY", from="1998-01-01", to="2023-12-01")

#Similar to DF
head(SPY)
tail(SPY)

#Graph it
chart_Series(SPY)
zoom_Chart("2020")
zoom_Chart("2023-06-01::2024-01-12")

#Create Simple Moving Average
sma <- SMA(x = Cl(SPY), n = 200)
tail(sma)
chart_Series(sma)
zoom_Chart("2023")

# Create Trailing Average
add_TA(sma, on=1, lwd=1.5, col="blue")
rsi <- RSI(price = Cl(SPY), n=2)
class(rsi)

# Create Exponentail Moving Average
ema_8 <- EMA(x = Cl(SPY), n = 8)
ema_21 <- EMA(x = Cl(SPY), n = 21)
ema_34 <- EMA(x = Cl(SPY), n = 34)
ema_55 <- EMA(x = Cl(SPY), n = 55)
ema_89 <- EMA(x = Cl(SPY), n = 89)

chart_Series(ema_21)

add_EMA(n=8, col="red")
add_EMA(n=21, col="blue")
add_EMA(n=34, col="green")
add_EMA(n=55, col="orange")
add_EMA(n=89, col="purple")
addADX(n = 14, maType="EMA", wilder=TRUE)
