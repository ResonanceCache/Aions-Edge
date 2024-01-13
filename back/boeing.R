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
getSymbols(Symbols="BA", from="1998-01-01", to="2024-12-01")

#Similar to DF
head(BA)
tail(BA)

#Graph it
chart_Series(BA)
# zoom_Chart("2020")
zoom_Chart("2023-01-01::2024-12-31")
start(BA)


#Create Simple Moving Average
sma <- SMA(x = Cl(BA), n = 200)
tail(sma)
chart_Series(sma)
zoom_Chart("2023")

# Create Trailing Average
add_TA(sma, on=1, lwd=1.5, col="blue")
rsi <- RSI(price = Cl(BA), n=2)
class(rsi)

# Create Exponentail Moving Average
ema_8 <- EMA(x = Cl(BA), n = 8)
ema_21 <- EMA(x = Cl(BA), n = 21)
ema_34 <- EMA(x = Cl(BA), n = 34)
ema_55 <- EMA(x = Cl(BA), n = 55)
ema_89 <- EMA(x = Cl(BA), n = 89)

# chart_Series(ema_21)

add_EMA(n=8, col="red")
add_EMA(n=21, col="blue")
add_EMA(n=34, col="green")
add_EMA(n=55, col="orange")
add_EMA(n=89, col="purple")
add_SMI(n = 13, nFast = 25, nSlow = 2, nSig = 9, maType ="EMA", bounded = TRUE)
addADX(n = 14, maType="EMA", wilder=TRUE)
