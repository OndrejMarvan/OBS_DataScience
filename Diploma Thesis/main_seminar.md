
# General
master thesis, 3 semesters to go,  
groznawstwo
Lotto coupons instead of alcohol 


# 13.10.2025

Topics of other attendees:
Floods and Gmina
Wycene Banku - x - stopa zwrotu a porownaje do IGREK
Tipsport app ()
Cheating with law stats - too many too low crimes, etc. 


APD - prace dyplomowe with prof. K., check out similar thesis 
J. Lewkowicz - doctor of law 
dependency of resources




My Idea
Decarbonisation of Energy sector by country, take to consideration weather, coal accessibility

Combine clustering (identify typologies), spatial analysis (spillovers), and Monte Carlo simulation (future scenarios) into one comprehensive model of Europe’s energy transition.

Climate change, energy prices focus, expertise on energy prices and consumption, public tenders (BIP system, public tenders)

28th May Deadline (meaning to be done mid May)


# 20.10.2025
- no updates
- R markdown - Quartoo
- Commentable -> editable, so better to keep it in Word


# 21.10.2025
### Predictive Modeling and Forecasting 📈

- **Forecasting EUA Prices with Machine Learning**: You could develop and compare different machine learning models (like LSTMs, GRUs, or Prophet) to forecast European Union Allowance (EUA) prices. This could involve using a variety of data sources, such as historical EUA prices, energy prices (natural gas, coal, electricity), industrial production indices, and even weather data.
    
- **Volatility Modeling of Carbon Markets**: This thesis could focus on modeling and forecasting the volatility of EUA prices. You could use models like GARCH and its variants to understand the dynamics of carbon market risk. The business application would be in derivatives pricing and risk management for trading firms.
    

---

### Algorithmic Trading Strategies 🤖

- **Developing an AI-Based Trading Strategy for EUAs**: You could design and backtest an algorithmic trading strategy for EUAs using reinforcement learning or other machine learning techniques. This would involve creating a simulated trading environment and training an AI agent to make profitable trading decisions.
    
- **Sentiment Analysis for Carbon Market News**: This project would involve using Natural Language Processing (NLP) to analyze news articles, policy papers, and social media to gauge market sentiment. You could then use this sentiment score as a feature in a trading or price prediction model.
    

---

### Decarbonisation and Corporate Strategy 🌍

- **Optimizing Decarbonisation Pathways for a Specific Industry**: You could choose an industry covered by the EU ETS (e.g., cement, steel, or aviation) and use optimization techniques to find the most cost-effective decarbonisation pathway. This would involve analyzing the costs of different abatement technologies versus the cost of purchasing EUAs.
    
- **Corporate Carbon Portfolio Management**: This thesis could focus on developing a framework for companies to manage their portfolio of carbon assets (EUAs). You could apply Modern Portfolio Theory to help companies optimize their EUA holdings to minimize compliance costs and risk.
    

---

### Market Analysis and Econometrics 📊

- **The Impact of Policy Announcements on EUA Prices**: You could use econometric models to analyze the impact of specific EU policy announcements (like the "Fit for 55" package) on the price and volatility of EUAs. This would involve event study analysis and time series modeling.
    
- **Causal Inference in the EU ETS Market**: This project could use causal inference techniques to understand the causal relationships between different factors in the EU ETS. For example, you could investigate the causal effect of natural gas prices on EUA prices, isolating it from other confounding factors.
    

## 03.11.2025
Wineyards - geospatial analysis
analyse temperature, precipitation, soil quality 
Create map software, some kind of calculator (how many degrees increase, based on it a forecast)
Green to prepare it. 

https://www.theguardian.com/environment/2013/apr/08/climate-change-wine-production

## 23.11.2025
**Variables:**

- `tmin` (Minimum Temperature)
    
- `tmax` (Maximum Temperature)
    
- `prec` (Precipitation)

other variables: 
Soil quality
topography maps

To share: 
- how much to submit before
- Indeces - grape ripening (dojrzewanie winogron) - important to consider min temperature in the case of northern Europe. 
- Introduction
- Scope - Most probably only Europe (on the other hand I may come to interesting results in other regions, such as finding completely new countries suitable for viticulture).
- Colletcing the data 
- Different types of wine - to analyse or not
- Data Source: **Copernicus CDS (CMIP6)** or **WorldClim**
- 
- ![[Pasted image 20251124173945.png]]




## All wineries - Features
https://github.com/oOo0oOo/winerymap?tab=readme-ov-file
[](https://github.com/oOo0oOo/winerymap?tab=readme-ov-file#features)

- 34k wineries in 2078 regions around the world
- Fully rendered client side, all data is delivered upon first page load
- Search for wineries and regions by name
- Debounced rendering of markers
- Grape varieties are available for approximately 12% of the wineries
- Simple design: Leaflet and vanilla JS
![[Pasted image 20251123191953.png]]
![Global change in viticulture suitability RCP 8.5. Change in viticulture suitability is shown between current (1961 – 2000) and 2050 (2041 – 2060) time periods, showing agreement among a 17-GCM ensemble. Areas with current suitability that decreases by midcentury are indicated in red ( > 50% GCM agreement). Areas with current suitability that is retained are indicated in light green ( > 50% GCM agreement) and dark green ( > 90% GCM agreement), whereas areas not suitable in the current time period but suitable in the future are shown in light blue ( > 50% GCM agreement) and dark blue ( > 90% GCM agreement). Insets : Greater detail for major wine-growing regions: California/western North America ( A ), Chile ( B ), Cape of South Africa ( C ), New Zealand ( D ), and Australia ( E ).](https://www.researchgate.net/profile/Gary-Tabor/publication/236140651/figure/fig1/AS:299393841418240@1448392462150/Global-change-in-viticulture-suitability-RCP-85-Change-in-viticulture-suitability-is.png)
![[Pasted image 20251123210742.png]]
## Weather conditions
The minimum climatic requirements for viticulture include an average annual temperature of at least 9°C, an average temperature of the warmest month of at least 18°C, and a maximum low temperature in winter of minus 13°C. The minimum temperature necessary for grapevine physiological activity is 10°C (50°F), which serves as the base temperature for calculating growing degree-days.

For optimal grape growth, temperatures should ideally range between 25°C and 28°C. However, grapevines can be injured by temperatures below their critical thresholds; for example, most _Vitis vinifera_ varieties are considered very tender and can be damaged at temperatures between 5°F and -5°F (-15°C to -21°C). The cold hardiness of grapevines varies by variety, with some being more tolerant of low temperatures than others.

In terms of temperature variation, diurnal temperature variation—the difference between daytime highs and nighttime lows—is an important factor, particularly for white wine production, as it helps maintain acidity in grapes. The Winkler Index, which calculates growing degree-days above 10°C from April to October in the Northern Hemisphere, is used to classify regions based on heat accumulation and is strongly correlated with grapevine phenology and berry composition at harvest.

![[Pasted image 20251124174334.png]]

![[Pasted image 20251124174346.png]]