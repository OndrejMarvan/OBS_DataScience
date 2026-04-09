README
======

Student: [YOUR NAME AND SURNAME HERE]

Project: Water Budget Calculator for a Garden in Falenty Nowe, Poland
         (Precipitation vs Evapotranspiration from IMGW, Open-Meteo, Meteostat)


Files and Run Order
-------------------
1. legal_proof.txt        — Written proof that all websites are legal to scrape
2. requirements.txt       — All Python packages needed
3. water_budget.ipynb     — THE MAIN FILE: Jupyter Notebook with all code,
                            analysis, and results. Run all cells top to bottom.
4. imgw_spider.py         — Scrapy spider (imported by the notebook, can also
                            run standalone via: scrapy runspider imgw_spider.py)
5. output/                — Created at runtime: contains final CSV dataset
                            and charts


How to Run
----------
1. Install dependencies:
      pip install -r requirements.txt
      playwright install chromium   (for Selenium/Playwright if needed)

2. Open and run the notebook:
      jupyter notebook water_budget.ipynb
   Run all cells from top to bottom.

3. The notebook will:
   a) Use Scrapy to crawl IMGW and download ZIP files with daily weather CSVs
   b) Use Requests + BeautifulSoup to fetch data from Open-Meteo API
   c) Use Selenium to scrape the Meteostat station page for metadata
   d) Use Python regex to parse IMGW CSV files
   e) Merge all sources into a final DataFrame
   f) Calculate the daily Water Budget (Precipitation − ET₀)
   g) Save results to output/water_budget.csv and generate charts


Data Sources
------------
- IMGW (danepubliczne.imgw.pl) — Polish national weather data, open public data
- Open-Meteo (archive-api.open-meteo.com) — Free weather API, CC BY 4.0
- Meteostat (meteostat.net) — Open weather data platform, CC BY-NC 4.0

Google Drive link (if dataset too large): [INSERT IF NEEDED]

Attribution: "Źródłem pochodzenia danych jest Instytut Meteorologii
i Gospodarki Wodnej – Państwowy Instytut Badawczy" (IMGW-PIB)
