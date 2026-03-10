# 🌍 Global Energy Mix Regimes — Unsupervised Learning Project

> Clustering countries by their per-capita energy mix to reveal distinct "Energy Regimes" and uncover how wealth, emissions, and geography shape the global energy landscape.

[![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)]()

---

## 📌 Overview

This project applies unsupervised learning techniques (K-Means, PAM, Hierarchical Clustering) to identify natural groupings of countries based on how they produce and consume energy. Beyond raw energy data, I integrate GDP per capita, CO₂ emissions, and population density to build a richer picture of each regime.

**Key question:** *Do countries naturally fall into distinct "energy strategy" groups — and what drives those differences?*

### Highlights

- **5 distinct energy regimes** identified across 100+ countries (1965–2024)
- **"Energy Addition" paradox** — wealthier nations add renewables *on top of* fossil fuels rather than replacing them
- **Case study: Czech Republic** — cluster-based solar capacity forecast for 2030
- **Single-year (2023) clustering** for a cleaner, policy-relevant snapshot

---

## 📂 Repository Structure

```
├── README.md
├── USL_Project1.Rmd            # Main R Markdown source
├── USL_Project1.pdf            # Rendered report with all plots
├── data/
│   ├── per-capita-energy-stacked.csv
│   ├── gdp-per-capita-worldbank.csv
│   ├── co2-emissions-per-capita.csv
│   └── population-density.csv
└── figures/                    # Exported plots
```

---

## 🔬 Methodology

| Step | Method | Purpose |
|------|--------|---------|
| Data prep | Filtering, NA handling, outlier removal (Iceland) | Clean country-level panel data |
| EDA | Correlation matrix, stacked area charts | Understand global energy trends |
| Optimal *k* | Elbow + Silhouette methods | Determine number of clusters |
| Clustering | K-Means → PAM (K-Medoids) | Robust clustering resistant to outliers |
| Validation | Hierarchical dendrogram (Ward's D2) | Confirm cluster structure |
| Profiling | GDP, CO₂, Solar/Oil averages per cluster | Interpret regime characteristics |
| Mapping | `ggplot2` + `map_data("world")` | Geographical visualization |
| Forecasting | Cluster-aggregated growth rates | Reduce variance in solar forecast |

---

## 🗺️ The 5 Energy Regimes (2023 Snapshot)

| Cluster | Label | Key Members | Characteristics |
|---------|-------|-------------|-----------------|
| 1 | Developing World | India, Indonesia, most of Africa | Low energy access, limited diversification |
| 2 | Coal-Dependent Transitional | South Africa, Kazakhstan, Poland | Heavy coal reliance, mining-based economies |
| 3 | Green-Leaning Wealthy | Nordics, Western Europe | High GDP, strong renewables adoption |
| 4 | Nuclear & Diversified Industrial | Czechia, France, USA, South Korea | High nuclear share, diversified fossil + clean mix |
| 5 | Oil/Gas Exporters | Gulf states, Turkmenistan | Extreme fossil fuel concentration |

---

## 🇨🇿 Case Study: Czech Republic

Czechia sits in **Cluster 4** (Nuclear & Diversified Industrial), alongside France, the US, and South Korea. Using the cluster's average solar growth rate as an aggregated forecast:

> **Projection:** If Czechia follows its cluster's adoption trajectory, it will surpass **1,000 kWh per capita** in solar energy by 2030.

This cluster-based approach reduces forecast variance compared to a single-country time series.

---

## 🛠️ Tech Stack

- **Language:** R
- **Key packages:** `tidyverse`, `cluster`, `factoextra`, `corrplot`, `ggplot2`, `maps`
- **Data sources:** [Our World in Data](https://ourworldindata.org/energy), [World Bank](https://data.worldbank.org/)

---

## 🚀 Quick Start

```r
# Clone and open
git clone https://github.com/OndrejMarvan/energy-mix-regimes.git

# Install dependencies
install.packages(c("tidyverse", "cluster", "factoextra", "corrplot", "maps"))

# Knit the report
rmarkdown::render("USL_Project1.Rmd")
```

---

## 📊 Key Findings

1. **GDP drives energy volume, not greenness** — Oil correlates with GDP (0.71) far more than Solar (0.26).
2. **Renewables are additive** — global fossil fuel consumption has not declined in absolute terms; solar and wind are layered on top.
3. **Single-year clustering is cleaner** — avoids mixing 1970s Germany with 2020s Germany in the same dataset.
4. **PAM > K-Means** for energy data — real-country medoids resist distortion from outliers like Qatar.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

**Ondřej Marvan** · MSc Data Science & Business Analytics · University of Warsaw

[![GitHub](https://img.shields.io/badge/GitHub-OndrejMarvan-181717?style=flat&logo=github)](https://github.com/OndrejMarvan)
