"""
Scrapy Spider: IMGW Daily Synoptic Data Downloader
===================================================
Crawls the IMGW public data archive directory tree and downloads
daily synoptic weather ZIP files for 2025 and 2026.

Legal: IMGW data is public under Polish Open Data Policy.
See legal_proof.txt for full details.

Usage (standalone):
    scrapy runspider imgw_spider.py -a years=2025,2026 -s LOG_LEVEL=INFO

Or import and run from within the Jupyter notebook (see water_budget.ipynb).
"""

import scrapy
import os
import re


class ImgwSynopSpider(scrapy.Spider):
    """
    Spider that recursively traverses the IMGW directory index pages
    to find and download daily synoptic weather data ZIP files.

    The IMGW archive at danepubliczne.imgw.pl uses plain Apache directory
    listings (HTML tables with links), so BeautifulSoup-style parsing of
    <a href="..."> tags is the core technique here, but done via Scrapy
    selectors for efficiency.

    Directory structure:
      /dane_meteorologiczne/dobowe/synop/
        ├── 2025/
        │   ├── 2025_01_s.zip   (month-level: all stations, Jan 2025)
        │   ├── 2025_02_s.zip
        │   └── ...
        ├── 2026/
        │   ├── 2026_01_s.zip
        │   └── ...
        └── s_d_format.txt      (CSV column descriptions)
    """

    name = "imgw_synop"
    custom_settings = {
        "ROBOTSTXT_OBEY": True,           # Respect robots.txt!
        "DOWNLOAD_DELAY": 1.0,            # Be polite: 1 second between requests
        "CONCURRENT_REQUESTS": 1,         # One request at a time
        "USER_AGENT": "WaterBudgetBot/1.0 (educational project; +university)",
        "LOG_LEVEL": "INFO",
    }

    # Base URL for daily synoptic data
    BASE_URL = (
        "https://danepubliczne.imgw.pl/data/"
        "dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/"
    )

    def __init__(self, years="2025,2026", output_dir="imgw_data", *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.target_years = [y.strip() for y in years.split(",")]
        self.output_dir = output_dir
        os.makedirs(self.output_dir, exist_ok=True)

    def start_requests(self):
        """Start by requesting the main synop directory listing."""
        yield scrapy.Request(self.BASE_URL, callback=self.parse_year_index)

    def parse_year_index(self, response):
        """
        Parse the top-level directory listing to find year subdirectories.
        Each year is a link like "2025/" in the Apache index page.

        Uses CSS selectors to extract <a> tags from the directory listing.
        """
        self.logger.info(f"Parsing directory index: {response.url}")

        # Extract all links from the directory listing
        links = response.css("a::attr(href)").getall()

        for link in links:
            # Use regex to match year directory names like "2025/" or "2026/"
            year_match = re.match(r"^(\d{4})/?$", link)
            if year_match:
                year = year_match.group(1)
                if year in self.target_years:
                    year_url = response.urljoin(link)
                    self.logger.info(f"Found target year directory: {year}")
                    yield scrapy.Request(
                        year_url,
                        callback=self.parse_zip_listing,
                        meta={"year": year}
                    )

    def parse_zip_listing(self, response):
        """
        Parse a year's directory listing to find ZIP files.
        Files are named like: 2025_01_s.zip, 2025_02_s.zip, etc.
        (month-level files containing all synoptic stations for that month)

        Also looks for per-station files like: 2025_100_s.zip, 2025_105_s.zip
        (station-level files for the full year).
        """
        year = response.meta["year"]
        self.logger.info(f"Parsing ZIP listing for year {year}: {response.url}")

        links = response.css("a::attr(href)").getall()

        for link in links:
            # Match ZIP file pattern: YYYY_NNN_s.zip
            # NNN can be month (01-12) or station code (100, 105, etc.)
            zip_match = re.match(
                r"^(\d{4})_(\d+)_s\.zip$", link, re.IGNORECASE
            )
            if zip_match:
                zip_url = response.urljoin(link)
                filename = zip_match.group(0)
                self.logger.info(f"  Downloading: {filename}")
                yield scrapy.Request(
                    zip_url,
                    callback=self.save_zip,
                    meta={"filename": filename, "year": year}
                )

    def save_zip(self, response):
        """Save downloaded ZIP file to the output directory."""
        filename = response.meta["filename"]
        filepath = os.path.join(self.output_dir, filename)

        with open(filepath, "wb") as f:
            f.write(response.body)

        self.logger.info(f"  Saved: {filepath} ({len(response.body)} bytes)")

        yield {
            "filename": filename,
            "year": response.meta["year"],
            "size_bytes": len(response.body),
            "url": response.url,
        }
