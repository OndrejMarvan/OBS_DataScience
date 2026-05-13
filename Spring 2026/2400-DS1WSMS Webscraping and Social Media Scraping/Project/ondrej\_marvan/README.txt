README
======

Student: Ondřej Marvan
ID: 477 001

Project: Water Budget Calculator for a Garden in Falenty Nowe, Poland
         (Precipitation vs Evapotranspiration from IMGW, Open-Meteo, Meteostat)


Files and Run Order
-------------------
1. legal_proof.txt        - Written proof that all websites are legal to scrape
2. requirements.txt       - All Python packages needed
3. water_budget.ipynb     - THE MAIN FILE: Jupyter Notebook report (run all cells top-to-bottom)
4. imgw_spider.py         - Scrapy spider (called by the notebook via subprocess)
5. output/                - Created at runtime: final CSV + charts


How to Run
----------
1. Install dependencies:
      pip install -r requirements.txt
      (Make sure Chrome is installed for Selenium)

2. Open and run the notebook:
      jupyter notebook water_budget.ipynb
   Run all cells from top to bottom.


Data Sources
------------
- IMGW (danepubliczne.imgw.pl) - Polish national weather data, open public data
- Open-Meteo (archive-api.open-meteo.com) - Free weather API, CC BY 4.0
- Meteostat (meteostat.net) - Open weather data platform, CC BY-NC 4.0

Google Drive link (if dataset too large): [INSERT IF NEEDED]
