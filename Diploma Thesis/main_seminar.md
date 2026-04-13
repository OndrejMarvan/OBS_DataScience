
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

08.12.2025
First run my own Winkler and Huglin index
Then start with my basic analysis
Once done, add topograhpy map, soil quality, etc. etc. 

## 12.01.2025 Seminar 
**climate, soil, and topography**
While W and H indeces are taking into consideration only climate (tempereure) that makes them rather more linear.

Calculates **Huglin Index** (heat sum + latitude correction)
Calculates **Winkler Index** (Growing Degree Days)

Business part - viticulture has high added value (higher than crop) and contributes to the tourism

Suitability rating - not involving topography and soil quaility, only temp. and precipitation. 

![[Pasted image 20260112184334.png]]

Combines into **weighted composite** (40% Huglin, 35% Winkler, 25% Precip)

## 13.04.2026
**Deadlines:**
till need of semester or till end of September 
appendix (what is published) or supplement (code)
no later than 

Switching from a traditional diploma thesis to a research paper (often called a **"thesis by publication"** or an **"article-based thesis"**) is a modern approach that can be incredibly beneficial, especially if you are considering a career in academia or R&D.

Essentially, instead of writing a 60–100 page monograph that might only be read by your committee, you produce a high-quality, peer-reviewed manuscript intended for a scientific journal.

---

## 1. How It Differs from a Traditional Thesis

|**Feature**|**Traditional Thesis**|**Research Paper (Article-based)**|
|---|---|---|
|**Structure**|Lengthy chapters (Intro, Lit Review, Methods, Results, Discussion).|Concise, following a specific journal’s format (IMRaD).|
|**Length**|Usually 15,000 – 30,000+ words.|Usually 3,000 – 8,000 words.|
|**Audience**|Your university supervisors and examiners.|Global experts in your specific field.|
|**Outcome**|Becomes a library record.|Becomes a citable, published work in a database.|

---

## 2. The Pros: Why Your Supervisor Is Suggesting It

- **Scientific Impact:** You contribute actual knowledge to your field. Having a published paper as a student is a massive "gold star" on your CV.
    
- **Efficiency:** You learn the "real-world" skill of academic writing. You aren't "wasting" time on fluff; every word must be precise and necessary.
    
- **Career Building:** If you plan to apply for a PhD or a high-level research job, a publication is far more valuable than a standard diploma.
    
- **Feedback:** If you submit it to a journal, you get anonymous peer review from experts, which provides a rigorous check on your work.
    

---

## 3. The Cons: Potential Challenges

- **Higher Standard of Quality:** A thesis just needs to pass; a research paper needs to be _correct, novel, and significant_ enough for a journal to accept it.
    
- **Strict Constraints:** You must adhere to strict word counts and formatting rules. There is no room for the broad, exploratory writing allowed in a traditional thesis.
    
- **External Timelines:** If your university requires the paper to be _accepted_ for publication before you graduate, you are at the mercy of journal editors, which can take months.
    

---

## 4. Key Considerations

Before you say yes, clarify these points with your supervisor:

1. **The "Mantel" (The Wrap):** Most universities still require a short introductory and concluding section (the "mantel") to bind the paper into a formal graduation document.
    
2. **Authorship:** Since it’s your degree, you should generally be the **first author**. Discuss who else (like your supervisor) will be listed as a co-author.
    
3. **Target Journal:** Have they identified a specific journal? This will dictate your entire writing style and data presentation.
    

> **Expert Tip:** Writing a paper is often _harder_ than writing a long thesis because you have to be much more concise. You have to kill your darlings—cutting out interesting but irrelevant data to keep the narrative tight.