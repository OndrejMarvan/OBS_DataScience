## 1. Introduction

1.1 Background of the Study: The Climate-Viticulture Nexus 1.2 Problem Statement: Limitations of Linear Indices in a Non-Linear World 1.3 Research Objectives and Questions 1.4 Methodology Overview 1.5 Significance of the Study (Economic and Methodological) 1.6 Structure of the Thesis

## 2. Literature Review and Theoretical Background

_(Note: This chapter addresses your request to define the "domain knowledge" before applying Data Science.)_

**2.1 Fundamentals of Viticulture**

- 2.1.1 Defining the Vineyard: Biological and Agricultural Characteristics
    
- 2.1.2 Taxonomy of the Grape: _Vitis vinifera_ vs. Hybrid Varieties
    
    - _Discussion on why Vitis vinifera is the standard for quality wine but sensitive to climate._
        
- 2.1.3 The Concept of _Terroir_: Interplay of Climate, Soil, and Topography
    

**2.2 Historical Geography of Viticulture**

- 2.2.1 The Roman Optimum to the Little Ice Age: How Climate Shaped the "Old World" Map
    
- 2.2.2 The Traditional "Wine Belt" (30°–50° Latitude): Historical Boundaries
    
- 2.2.3 Recent Trends: The northward expansion (UK, Denmark, Poland) in the late 20th century.
    

**2.3 Bioclimatic Indices in Viticulture**

- 2.3.1 Temperature-Based Indices (Winkler Index, Growing Degree Days)
    
- 2.3.2 Heliothermal Indices (Huglin Index)
    
- 2.3.3 The Limitations of Traditional Indices for Future Forecasting
    

**2.4 Species Distribution Modeling (SDM) in Agriculture**

- 2.4.1 From Ecology to Economy: Adapting SDM for Crops
    
- 2.4.2 Overview of Algorithms: MaxEnt, Random Forest, and Gradient Boosting
    
- 2.4.3 Addressing Spatial Autocorrelation in Geospatial Data
    

## 3. Methodology and Data

**3.1 Study Area and Temporal Scope**

- 3.1.1 Geographical Extent: Pan-European Analysis vs. Emerging Market Focus
    
- 3.1.2 Temporal Horizons: Baseline (1991–2020) vs. Future (2041–2060, 2061–2080)
    

**3.2 Data Acquisition and Preprocessing (ETL)**

- 3.2.1 Target Data (Ground Truth): CORINE Land Cover (Class 2.2.1)
    
- 3.2.2 Climate Data: CMIP6 Downscaled Projections (WorldClim/CHELSA)
    
    - _Scenarios used: SSP2-4.5 and SSP5-8.5_
        
- 3.2.3 Topographical Data: Deriving Slope and Aspect from Copernicus DEM
    
- 3.2.4 Soil Data: ESDAC Key Variables (Texture, pH, Water Holding Capacity)
    

**3.3 Feature Engineering**

- 3.3.1 Calculation of Bioclimatic Indices (Huglin, GST) from Raw Data
    
- 3.3.2 Handling Multicollinearity among Environmental Variables
    

**3.4 Modeling Strategy**

- 3.4.1 Algorithm Selection: Random Forest Classification
    
- 3.4.2 Training and Testing Split using Spatial Cross-Validation
    
- 3.4.3 Hyperparameter Tuning
    

## 4. Results

**4.1 Model Performance and Variable Importance**

- 4.1.1 Accuracy Metrics (AUC, TSS, Kappa)
    
- 4.1.2 Which drivers matter most? (e.g., "Is Soil more important than Temperature?")
    

**4.2 Baseline Suitability Map (1991–2020)**

- 4.2.1 Comparison with known wine regions (Model Validation)
    

**4.3 Future Projections of Viticultural Suitability**

- 4.3.1 Suitability shifts under SSP2-4.5 (Sustainability Scenario)
    
- 4.3.2 Suitability shifts under SSP5-8.5 (Fossil-Fueled Scenario)
    

**4.4 Regional Case Studies: The Emerging Markets**

- 4.4.1 Poland: The expansion of potential vineyard area
    
- 4.4.2 The Baltic States and Scandinavia: From impossible to possible?
    
- 4.4.3 The United Kingdom: Consolidation of a new wine region
    

## 5. Discussion

5.1 Interpreting the "Northward Shift": Magnitude and Velocity 5.2 Economic Implications for Emerging Markets

- _Land value, tourism potential, and agricultural policy._ 5.3 The Role of Non-Climatic Factors (Soil) as constraints
    
- _Why a warmer climate doesn't guarantee good wine if the soil is wrong._ 5.4 Limitations of the Study (Resolution, Irrigation, Extreme Weather Events)
    

## 6. Conclusion and Policy Recommendations

## References

## List of Figures and Tables

## Appendices

- A. R Code Snippets for Spatial Data Processing
    
- B. Additional Suitability Maps for Specific Countries