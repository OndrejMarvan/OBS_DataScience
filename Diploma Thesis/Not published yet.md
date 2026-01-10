1.5 Methodology
**
**

including slope gradient and aspect, are computed from the Copernicus Digital Elevation Model at 30-metre resolution. Soil data will be extracted from the European Soil Data Centre (ESDAC) and include key viticultural determinants such as texture class, pH, organic carbon content, and available water capacity.


Ground-truth data on existing vineyard locations are obtained from the CORINE Land Cover inventory (Class 2.2.1: Vineyards), which provides pan-European coverage of land use at approximately 25-hectare minimum mapping unit. These presence data are combined with pseudo-absence generation to train a Random Forest classification algorithm, selected for its capacity to model non-linear relationships and interactions between predictor variables without requiring a priori specification of functional forms (Breiman, 2001). Spatial cross-validation techniques are employed to address spatial autocorrelation and prevent overfitting to spatially clustered training data.

The model outputs comprise continuous suitability surfaces ranging from 0 (unsuitable) to 1 (highly suitable), which are subsequently reclassified into discrete suitability classes for interpretation and policy application. Variable importance metrics derived from the Random Forest algorithm provide insight into the relative contribution of climatic, topographical, and edaphic factors to suitability determination.

**