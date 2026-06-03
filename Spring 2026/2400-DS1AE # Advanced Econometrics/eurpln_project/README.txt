Name and Surname: Ondřej Marvan

Project: EUR/PLN Exchange Rate and Interest Rate Differential
Course:  Advanced Econometrics (2400-DS1AE)
Student ID: 477001

=====================================================================
FILES AND RUN ORDER
=====================================================================
1. 00_setup.R       — install and load packages, set global paths
2. 01_data.R        — fetch EUR/PLN + Brent, load rate CSVs, merge, save
3. 02_analysis.R    — unit root tests, cointegration, ARDL/VECM, ARIMA
4. 03_plots.R       — all charts and figures for the report
5. 04_report.Rmd    — Word report (knit last, after all above are run)

=====================================================================
DATA FOLDER CONTENTS (data/)
=====================================================================
EUR/PLN exchange rate:
  archiwum_tab_a_2012.csv ... archiwum_tab_a_2026.csv
  Source: https://nbp.pl/.../archiwum-tabela-a-csv-xls/
  → Read automatically by 01_data.R (all archiwum_tab_a_*.csv in data/)

NBP Reference Rate:
  → Built into 01_data.R as the official MPC rate-change history.
  → To override, drop data/nbp_rate.csv (cols: date, nbp_rate) and it is used instead.
  → NOTE: verify the 2025Q4–2026 rows in the built-in table against NBP.

ECB Main Refinancing Rate:
  ECB Data Portal_*.csv  (any file in data/ whose name contains "ECB")
  Source: https://data.ecb.europa.eu/data/datasets/FM/FM.B.U2.EUR.4F.KR.MRR_FR.LEV

Brent crude oil (control):
  → Fetched automatically from stooq.com; fallback data/brent.csv

Dataset size: small — all input CSVs and the merged output/df_clean.csv are
included directly in this ZIP. No Google Drive link needed.

=====================================================================
METHOD NOTE
=====================================================================
Cointegration (Engle-Granger, Johansen) requires all series to be I(1).
If the interest rate differential tests as I(0), the ARDL bounds test
(valid for mixed I(0)/I(1) regressors) is the main specification.

=====================================================================
PRODUCING THE WORD REPORT
=====================================================================
The report is written as 04_report.Rmd and knits to a Word document.
After running 00 -> 01 -> 02 -> 03, open 04_report.Rmd in RStudio and
click "Knit" (output: Word). This produces 04_report.docx, which is the
Word deliverable to include in the submission. references.bib supplies
the bibliography.
