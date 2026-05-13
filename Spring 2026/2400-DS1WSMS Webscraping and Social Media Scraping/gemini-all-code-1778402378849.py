# Web Scraping Master Toolkit (v5 - The Complete Edition)
# Covers: requests, BeautifulSoup, lxml, PyPDF2, Selenium, Scrapy, Playwright, and Pyppeteer

# ---------------------------------------------------------
# Setup: Additional installations required for this module
# !pip install scrapy playwright pyppeteer scrapy-selenium
# !playwright install chromium
# ---------------------------------------------------------

import requests
from bs4 import BeautifulSoup
from lxml import html
import pandas as pd
import re
from urllib.parse import urljoin
import os
import time
import io
import PyPDF2
import json
import subprocess
import asyncio

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager

# Playwright & Pyppeteer imports
from playwright.sync_api import sync_playwright
from pyppeteer import launch

print("--- Web Scraping Master Toolkit: Full Suite Initialized ---")

# Create output directories if they don't exist
os.makedirs("outputs", exist_ok=True)
os.makedirs("scripts", exist_ok=True)

# =========================================================
# PART 1 to 9: Static Scraping (BeautifulSoup, Regex, XPath, PDF)
# =========================================================
print("\n--- Running Core Static Tools ---")
email_pattern = re.compile(r'[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')
print("Test Regex:", email_pattern.findall("Contact us at test@example.com"))


# =========================================================
# PART 10 & 11: Dynamic Scraping (Selenium)
# =========================================================
print("\n--- Dynamic Tools Enabled (Selenium Ready) ---")
# To use: 
# chrome_options = Options(); chrome_options.add_argument("--headless")
# driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
# driver.quit()


# =========================================================
# PART 12: High-Performance Scraping with Scrapy
# =========================================================
print("\n--- Part 12: Scrapy (Large-Scale Asynchronous Scraping) ---")
# Scrapy uses the Twisted reactor, which can only be started once per process.
# We work around this by writing the spider to a file and running it as a subprocess.

scrapy_code = '''
import scrapy
from scrapy.crawler import CrawlerProcess

class SimpleSpider(scrapy.Spider):
    name = 'simple'
    start_urls = ['http://quotes.toscrape.com']

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').get(),
                'author': quote.css('small.author::text').get()
            }

if __name__ == "__main__":
    process = CrawlerProcess(settings={
        'LOG_LEVEL': 'ERROR',
        'FEEDS': {'outputs/scrapy_output.json': {'format': 'json', 'overwrite': True}}
    })
    process.crawl(SimpleSpider)
    process.start()
'''

with open("scripts/scraper.py", "w", encoding="utf-8") as file:
    file.write(scrapy_code)

print("Running Scrapy via subprocess...")
start_time = time.time()
subprocess.run(['python', r'scripts/scraper.py'], capture_output=True, text=True, shell=True)
print(f"Scrapy finished in {time.time() - start_time:.2f} seconds.")


# =========================================================
# PART 13: Modern Headless Browsers (Playwright & Pyppeteer)
# =========================================================
print("\n--- Part 13: Playwright & Pyppeteer ---")
url_quotes = 'http://quotes.toscrape.com'

# 13A. Playwright (Synchronous)
print("Running Playwright...")
start_time = time.time()
playwright_results = []
with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto(url_quotes)
    page.wait_for_selector('div.quote')
    
    quotes = page.query_selector_all('div.quote')
    for quote in quotes:
        playwright_results.append({
            'text': quote.query_selector('span.text').inner_text(),
            'author': quote.query_selector('small.author').inner_text()
        })
    browser.close()

with open('outputs/playwright_output.json', 'w', encoding='utf-8') as f:
    json.dump(playwright_results, f, ensure_ascii=False, indent=4)
print(f"Playwright finished in {time.time() - start_time:.2f} seconds.")

# 13B. Pyppeteer (Asynchronous)
print("Running Pyppeteer...")
async def scrape_with_pyppeteer():
    browser = await launch(headless=True, args=["--no-sandbox"])
    page = await browser.newPage()
    await page.goto(url_quotes)
    await page.waitForSelector("div.quote")
    
    # Extract via JavaScript evaluation
    results = await page.evaluate("""() => {
        const quotes = document.querySelectorAll('div.quote');
        return Array.from(quotes).map(quote => ({
            text: quote.querySelector('span.text').innerText,
            author: quote.querySelector('small.author').innerText
        }));
    }""")
    await browser.close()
    return results

start_time = time.time()
pyppeteer_results = asyncio.get_event_loop().run_until_complete(scrape_with_pyppeteer())
with open("outputs/pyppeteer_output.json", "w", encoding="utf-8") as f:
    json.dump(pyppeteer_results, f, ensure_ascii=False, indent=4)
print(f"Pyppeteer finished in {time.time() - start_time:.2f} seconds.")


# =========================================================
# PART 14: Scrapy + Selenium Integration
# =========================================================
print("\n--- Part 14: Scrapy + Selenium Integration ---")
# Best for large-scale scraping where some pages require JavaScript rendering.

scrapy_selenium_code = '''
import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy_selenium import SeleniumRequest

class QuotesSeleniumSpider(scrapy.Spider):
    name = "quotes_selenium"

    def start_requests(self):
        yield SeleniumRequest(url="http://quotes.toscrape.com", callback=self.parse)

    def parse(self, response):
        for quote in response.css("div.quote"):
            yield {
                "text": quote.css("span.text::text").get(),
                "author": quote.css("small.author::text").get(),
            }

if __name__ == "__main__":
    process = CrawlerProcess(settings={
        "LOG_LEVEL": "ERROR",
        "FEEDS": {"outputs/scrapy_selenium_output.json": {"format": "json", "overwrite": True}},
        "DOWNLOADER_MIDDLEWARES": {"scrapy_selenium.SeleniumMiddleware": 800},
        "SELENIUM_DRIVER_NAME": "chrome",
        "SELENIUM_DRIVER_ARGUMENTS": ["--headless", "--no-sandbox", "--disable-dev-shm-usage"],
    })
    process.crawl(QuotesSeleniumSpider)
    process.start()
'''

with open("scripts/scrapy_selenium_scraper.py", "w", encoding="utf-8") as file:
    file.write(scrapy_selenium_code)

print("Running Scrapy+Selenium via subprocess...")
start_time = time.time()
subprocess.run(['python', r'scripts/scrapy_selenium_scraper.py'], capture_output=True, text=True, shell=True)
print(f"Scrapy+Selenium finished in {time.time() - start_time:.2f} seconds.")

print("\n--- Processing Complete: Master File Fully Updated ---")