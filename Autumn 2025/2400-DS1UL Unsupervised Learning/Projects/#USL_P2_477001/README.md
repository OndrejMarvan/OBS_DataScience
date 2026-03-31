# 🌍 Reconstructing the World Map from Scratch (MDS)

Recovering the shape of the Earth using **only pairwise distances** between 5,000 cities — no coordinates, no map, no compass.

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## 📌 Overview

This project applies unsupervised dimensionality reduction to reconstruct a world map from scratch. The algorithm receives **only** a 5,000 × 5,000 distance matrix — it never sees a single latitude or longitude. By the time all cities are placed, continental outlines naturally emerge.

**Key question:** Can an algorithm rediscover the shape of the Earth using nothing but a table of distances?

### Highlights

- **25 million distances** computed via the Haversine formula, fed as the sole input
- **MDS (Multidimensional Scaling)** projects the distance matrix into a 2D plane — acting as a "blind cartographer"
- **Procrustes Analysis (SVD)** solves the rotation/mirror ambiguity to align the result with real-world orientation
- Continents self-form purely from city density — no background map, no labels

## 📂 Repository Structure

```
#USL_P2_477001/
├── README.md
├── license.txt
├── #USL_P2_477001.ipynb              # Main Jupyter Notebook
├── #USL_P2_477001.html               # Rendered HTML export
├── worldcities.csv                   # Source dataset (48,060 cities)
├── worldcities.xlsx                  # Excel version of the dataset
└── simplemaps_worldcities_basicv1.901/   # Original SimpleMaps data package
```

## 🔬 Methodology

| Step | Method | Purpose |
|------|--------|---------|
| Data prep | Top-5,000 cities by population from `worldcities.csv` | Dense enough for continent shapes; feasible on a laptop |
| Distance matrix | Haversine formula (great-circle) | Compute all 5,000 × 5,000 pairwise distances |
| Dimensionality reduction | MDS (`sklearn`, `dissimilarity="precomputed"`) | Project distance matrix → 2D coordinates |
| Alignment | Procrustes Analysis via SVD | Rotate & scale MDS output to match real-world orientation |
| Visualization | `matplotlib` scatter plot | Render the reconstructed map from point density alone |

## 🗺️ The Result

> *Every dot is placed by the algorithm. No background map, no labels — just structure emerging from distances.*

The MDS algorithm treats each distance as a constraint and searches for a 2D layout satisfying them simultaneously. Think of it as someone drawing a map using only highway mileage signs — no compass, no GPS. Procrustes analysis then solves the [Orthogonal Procrustes Problem](https://en.wikipedia.org/wiki/Orthogonal_Procrustes_problem) to fix the inevitable rotation/mirror ambiguity.

## ⚙️ Key Parameters

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| `n_cities` | 5,000 | Continent-level density without excessive runtime |
| `n_components` | 2 | Target dimensionality (2D map) |
| `n_init` | 1 | Single initialization (deterministic with `random_state=42`) |
| `n_jobs` | -1 | All CPU cores for parallel computation |

## 🛠️ Tech Stack

- **Language:** Python
- **Key packages:** `pandas`, `numpy`, `matplotlib`, `scikit-learn`
- **Data source:** [SimpleMaps World Cities](https://simplemaps.com/data/world-cities) (48,060 cities)

## 🚀 Quick Start

```bash
# Clone and open
git clone https://github.com/OndrejMarvan/world-map-mds.git
cd world-map-mds

# Install dependencies
pip install pandas numpy matplotlib scikit-learn

# Run the notebook
jupyter notebook "#USL_P2_477001.ipynb"
```

## 📊 Key Findings

- **MDS recovers geography from distances alone** — continental outlines emerge without any coordinate information.
- **Procrustes alignment is essential** — raw MDS output is rotationally arbitrary; SVD-based alignment fixes orientation in one step.
- **Haversine ≠ Euclidean** — using great-circle distances respects Earth's curvature, giving MDS a faithful input.
- **City density drives resolution** — continents with more major cities (Asia, Europe) appear sharper than sparse regions (Oceania, Antarctica).

## 📄 License

This project is licensed under the MIT License — see [`license.txt`](license.txt) for details.

## 👤 Author

**Ondřej Marvan** · MSc Data Science & Business Analytics · University of Warsaw

[GitHub](https://github.com/OndrejMarvan)
