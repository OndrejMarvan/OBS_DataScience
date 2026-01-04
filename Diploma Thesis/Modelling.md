This is the critical step. Since you are building a "Calculator" (computing the Huglin and Winkler indices yourself), you **cannot** just download the `bc` (Bioclimatic variables). You need the raw monthly data to plug into your formulas.

Here is your exact **"Shopping List"** for the **2.5 minute** resolution.

### 1. Which Time Periods?

You need two time horizons to show the _progression_ of climate change.

- **2041-2060** (Mid-century): This is your "near future" forecast.
    
- **2061-2080** (End-century): This shows the long-term extreme shift.
    

### 2. Which Scenarios (SSPs)?

To be scientifically rigorous, you need to compare a "moderate" future vs. a "bad" future.

- **ssp245** (Middle of the road): The world makes some effort to cut emissions.
    
- **ssp585** (Fossil-fueled development): The "business as usual" / high-emission worst case.
    

### 3. Which Variables? (Crucial!)

You must download **`tn`**, **`tx`**, and **`pr`**.

- **`tn` (Min Temp)** & **`tx` (Max Temp)**: You **NEED** these to calculate the **Huglin Index**.
    
    - _Formula:_ The Huglin Index sums up the daily average and maximum temperatures. You cannot get this from pre-calculated `bc` files.
        
- **`pr` (Precipitation):** Needed to model drought stress (important for Southern Europe vs. Northern Europe comparison).
    
- _(Note: You can skip `bc` for now. `bc` contains pre-made averages like "Mean Annual Temp", which are useful for quick checks, but your thesis requires custom indices from raw data.)_
    

### 4. Which Models (GCMs)?

**Do not download all of them.** That is too much data. **Do not download just one.** That introduces "single-model bias" (maybe that one model is just crazy hot).

In scientific papers, it is standard to use an **Ensemble** (an average) of 3 distinct models. For Europe, I recommend these three reliable ones:

1. **EC-Earth3-Veg** (A major European model, very good for EU climate).
    
2. **MPI-ESM1-2-HR** (Max Planck Institute, Germany - excellent high-resolution heritage).
    
3. **ACCESS-CM2** (A solid, independent model to balance the others).
    

---

### Your Final Download Checklist

_(Go to the row for the Model, look at the column for the SSP, and click the link that says "tn, tx, pr")_

**Batch 1: The "Moderate" Future (2041-2060)**

1. **EC-Earth3-Veg** -> **ssp245** -> Download `tn`, `tx`, `pr`
    
2. **MPI-ESM1-2-HR** -> **ssp245** -> Download `tn`, `tx`, `pr`
    
3. **ACCESS-CM2** -> **ssp245** -> Download `tn`, `tx`, `pr`
    

**Batch 2: The "Hot" Future (2041-2060)**

1. **EC-Earth3-Veg** -> **ssp585** -> Download `tn`, `tx`, `pr`
    
2. **MPI-ESM1-2-HR** -> **ssp585** -> Download `tn`, `tx`, `pr`
    
3. **ACCESS-CM2** -> **ssp585** -> Download `tn`, `tx`, `pr`
    

_(Repeat for 2061-2080 when you are ready for the second chapter of your analysis)._

**Total files to start:** 18 zip files (3 models x 2 scenarios x 3 variables). **Estimated Size:** ~5 GB. This is perfectly safe for your laptop.

home/ondrej-marvan/Documents/General/Studies/Diploma Thesis/data
├── 2021-2040
│   ├── ACCESS-CM2
│   │   ├── ssp245
│   │   │   ├── wc2.1_2.5m_bioc_ACCESS-CM2_ssp245_2021-2040.tif
│   │   │   ├── wc2.1_2.5m_prec_ACCESS-CM2_ssp245_2021-2040.tif
│   │   │   ├── wc2.1_2.5m_tmax_ACCESS-CM2_ssp245_2021-2040.tif
│   │   │   └── wc2.1_2.5m_tmin_ACCESS-CM2_ssp245_2021-2040.tif
│   │   └── ssp585
│   │       ├── wc2.1_2.5m_bioc_ACCESS-CM2_ssp585_2021-2040.tif
│   │       ├── wc2.1_2.5m_prec_ACCESS-CM2_ssp585_2021-2040.tif
│   │       ├── wc2.1_2.5m_tmax_ACCESS-CM2_ssp585_2021-2040.tif
│   │       └── wc2.1_2.5m_tmin_ACCESS-CM2_ssp585_2021-2040.tif
│   ├── EC-Earth3-Veg
│   │   ├── ssp245
│   │   │   ├── wc2.1_2.5m_bioc_EC-Earth3-Veg_ssp245_2021-2040.tif
│   │   │   ├── wc2.1_2.5m_prec_EC-Earth3-Veg_ssp245_2021-2040.tif
│   │   │   ├── wc2.1_2.5m_tmax_EC-Earth3-Veg_ssp245_2021-2040.tif
│   │   │   └── wc2.1_2.5m_tmin_EC-Earth3-Veg_ssp245_2021-2040.tif
│   │   └── ssp585
│   │       ├── wc2.1_2.5m_bioc_EC-Earth3-Veg_ssp585_2021-2040.tif
│   │       ├── wc2.1_2.5m_prec_EC-Earth3-Veg_ssp585_2021-2040.tif
│   │       ├── wc2.1_2.5m_tmax_EC-Earth3-Veg_ssp585_2021-2040.tif
│   │       └── wc2.1_2.5m_tmin_EC-Earth3-Veg_ssp585_2021-2040.tif
│   └── MPI-ESM1-2-HR
│       ├── ssp245
│       │   ├── wc2.1_2.5m_bioc_MPI-ESM1-2-HR_ssp245_2021-2040.tif
│       │   ├── wc2.1_2.5m_prec_MPI-ESM1-2-HR_ssp245_2021-2040.tif
│       │   ├── wc2.1_2.5m_tmax_MPI-ESM1-2-HR_ssp245_2021-2040.tif
│       │   └── wc2.1_2.5m_tmin_MPI-ESM1-2-HR_ssp245_2021-2040.tif
│       └── ssp585
│           ├── wc2.1_2.5m_bioc_MPI-ESM1-2-HR_ssp585_2021-2040.tif
│           ├── wc2.1_2.5m_prec_MPI-ESM1-2-HR_ssp585_2021-2040.tif
│           ├── wc2.1_2.5m_tmax_MPI-ESM1-2-HR_ssp585_2021-2040.tif
│           └── wc2.1_2.5m_tmin_MPI-ESM1-2-HR_ssp585_2021-2040.tif
└── 2041-2060
    ├── ACCESS-CM2
    │   ├── ssp245
    │   │   ├── wc2.1_2.5m_bioc_ACCESS-CM2_ssp245_2041-2060.tif
    │   │   ├── wc2.1_2.5m_prec_ACCESS-CM2_ssp245_2041-2060.tif
    │   │   ├── wc2.1_2.5m_tmax_ACCESS-CM2_ssp245_2041-2060.tif
    │   │   └── wc2.1_2.5m_tmin_ACCESS-CM2_ssp245_2041-2060.tif
    │   └── ssp585
    │       ├── wc2.1_2.5m_bioc_ACCESS-CM2_ssp585_2041-2060.tif
    │       ├── wc2.1_2.5m_prec_ACCESS-CM2_ssp585_2041-2060.tif
    │       ├── wc2.1_2.5m_tmax_ACCESS-CM2_ssp585_2041-2060.tif
    │       └── wc2.1_2.5m_tmin_ACCESS-CM2_ssp585_2041-2060.tif
    ├── EC-Earth3-Veg
    │   ├── ssp245
    │   │   ├── wc2.1_2.5m_bioc_EC-Earth3-Veg_ssp245_2041-2060.tif
    │   │   ├── wc2.1_2.5m_prec_EC-Earth3-Veg_ssp126_2041-2060.tif
    │   │   ├── wc2.1_2.5m_tmax_EC-Earth3-Veg_ssp126_2041-2060.tif
    │   │   └── wc2.1_2.5m_tmin_EC-Earth3-Veg_ssp245_2041-2060.tif
    │   └── ssp585
    │       ├── wc2.1_2.5m_bioc_EC-Earth3-Veg_ssp585_2041-2060.tif
    │       ├── wc2.1_2.5m_prec_EC-Earth3-Veg_ssp585_2041-2060.tif
    │       ├── wc2.1_2.5m_tmax_EC-Earth3-Veg_ssp585_2041-2060.tif
    │       └── wc2.1_2.5m_tmin_EC-Earth3-Veg_ssp585_2041-2060.tif
    └── MPI-ESM1-2-HR
        ├── ssp245
        │   ├── wc2.1_2.5m_bioc_MPI-ESM1-2-HR_ssp245_2041-2060.tif
        │   ├── wc2.1_2.5m_prec_MPI-ESM1-2-HR_ssp245_2041-2060.tif
        │   ├── wc2.1_2.5m_tmax_MPI-ESM1-2-HR_ssp245_2041-2060.tif
        │   └── wc2.1_2.5m_tmin_MPI-ESM1-2-HR_ssp245_2041-2060.tif
        └── ssp585
            ├── wc2.1_2.5m_bioc_MPI-ESM1-2-HR_ssp585_2041-2060.tif
            ├── wc2.1_2.5m_prec_MPI-ESM1-2-HR_ssp585_2041-2060.tif
            ├── wc2.1_2.5m_tmax_MPI-ESM1-2-HR_ssp585_2041-2060.tif
            └── wc2.1_2.5m_tmin_MPI-ESM1-2-HR_ssp585_2041-2060.tif
