Name and Surname: Ondřej [Surname]

Project: EUR/PLN Exchange Rate and Interest Rate Differential
Course:  Advanced Econometrics (2400-DS1AE)
Student ID: 477001

=====================================================================
FILES AND RUN ORDER
=====================================================================
1. 00_setup.R       — install and load packages, set global paths
2. 01_data.R        — fetch EUR/PLN via API, load rate CSVs, merge
3. 02_analysis.R    — unit root tests, cointegration, ARDL/VECM, ARIMA
4. 03_plots.R       — all charts and figures for the report
5. 04_report.Rmd    — Word report (knit last, after all above are run)

=====================================================================
DATA FOLDER CONTENTS (data/)
=====================================================================
EUR/PLN exchange rate:
  → Fetched automatically via NBP API in 01_data.R (no file needed)

NBP Reference Rate:
  nbp_rate.csv
  Source: https://nbp.pl/polityka-pieniezna/decyzje-rpp/podstawowe-stopy-procentowe-nbp/
  → Click "Archiwum podstawowych stóp procentowych NBP od 1998"
  → Copy table to Excel, save as CSV with columns: date (YYYY-MM-DD), nbp_rate (%)

ECB Main Refinancing Rate:
  ecb_rate.csv
  Source: https://data.ecb.europa.eu/data/datasets/FM/FM.B.U2.EUR.4F.KR.MRR_FR.LEV
  → Export as CSV

Google Drive data link: [ADD LINK IF DATASET TOO LARGE]
