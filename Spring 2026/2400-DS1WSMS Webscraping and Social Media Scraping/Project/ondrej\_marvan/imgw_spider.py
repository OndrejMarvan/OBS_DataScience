"""
IMGW Spider - Ondřej Marvan (477 001)
=====================================
This spider crawls the IMGW public data archive and grabs daily synoptic
weather ZIP files for 2025 and 2026.

Legal: IMGW data is public under Polish Open Data Policy (see legal_proof.txt).

How to run (from notebook, like in class Part 12):
    subprocess.run(['python', 'imgw_spider.py'], capture_output=True, text=True)
"""

import scrapy
from scrapy.crawler import CrawlerProcess
import re
import os


class ImgwSynopSpider(scrapy.Spider):
    # spider name (Scrapy needs this)
    name = "imgw_synop"

    # Where I start crawling - the main IMGW directory
    start_urls = [
        "https://danepubliczne.imgw.pl/data/"
        "dane_pomiarowo_obserwacyjne/dane_meteorologiczne/dobowe/synop/"
    ]

    # Settings - be polite to the server!
    custom_settings = {
        "ROBOTSTXT_OBEY": True,           # always respect robots.txt
        "DOWNLOAD_DELAY": 1.0,            # 1 sec between requests, don't hammer the server
        "CONCURRENT_REQUESTS": 1,         # one at a time, slow but safe
        "USER_AGENT": "WaterBudgetBot/1.0 (educational project - Ondrej Marvan)",
        "LOG_LEVEL": "INFO",
    }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # which years do I want? (2025 and 2026)
        self.target_years = ["2025", "2026"]
        # make sure the output folder exists
        os.makedirs("imgw_data", exist_ok=True)

    def parse(self, response):
        """First step - find the year folders (2025/, 2026/, etc.)"""
        self.logger.info(f"Looking at directory: {response.url}")

        # grab all <a href="..."> links from the Apache directory listing
        for link in response.css("a::attr(href)").getall():
            # regex check - does the link look like "2025/" or "2026/"?
            year_match = re.match(r"^(\d{4})/?$", link)
            if year_match and year_match.group(1) in self.target_years:
                year_url = response.urljoin(link)
                self.logger.info(f"Found year folder: {year_match.group(1)}")
                # follow the link, hand off to the next parser
                yield scrapy.Request(year_url, callback=self.parse_zip_listing)

    def parse_zip_listing(self, response):
        """Inside a year folder - find all the ZIP files and download them."""
        for link in response.css("a::attr(href)").getall():
            # regex - does it look like 2025_01_s.zip or 2025_375_s.zip?
            if re.match(r"^\d{4}_\d+_s\.zip$", link, re.IGNORECASE):
                zip_url = response.urljoin(link)
                self.logger.info(f"  Grabbing: {link}")
                yield scrapy.Request(zip_url, callback=self.save_zip,
                                     meta={"filename": link})

    def save_zip(self, response):
        """Save the downloaded ZIP file to disk."""
        filename = response.meta["filename"]
        filepath = os.path.join("imgw_data", filename)

        # write the binary content to a file
        with open(filepath, "wb") as f:
            f.write(response.body)

        self.logger.info(f"  Saved: {filepath} ({len(response.body)} bytes)")

        # log what I did (Scrapy will dump this to JSON)
        yield {
            "filename": filename,
            "size_bytes": len(response.body),
            "url": response.url,
        }


# This part runs when I call: python imgw_spider.py
if __name__ == "__main__":
    # set up Scrapy and let it run the spider
    process = CrawlerProcess(settings={
        "LOG_LEVEL": "INFO",
        "FEEDS": {
            "output/scrapy_imgw_log.json": {
                "format": "json",
                "overwrite": True,
            }
        },
        "ROBOTSTXT_OBEY": True,
        "DOWNLOAD_DELAY": 1.0,
        "CONCURRENT_REQUESTS": 1,
        "USER_AGENT": "WaterBudgetBot/1.0 (educational project - Ondrej Marvan)",
    })
    process.crawl(ImgwSynopSpider)
    process.start()
