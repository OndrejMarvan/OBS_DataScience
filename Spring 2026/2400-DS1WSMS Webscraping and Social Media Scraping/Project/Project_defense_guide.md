# Water Budget Project — Defense Preparation Guide

**Student:** Ondřej Marvan (477 001)
**Project:** Hyper-local Water Budget Calculator for a Garden in Falenty Nowe
**Defense:** May 26 or June 9, 2026

---

## Table of Contents

1. [Project Big Picture](#1-project-big-picture)
2. [The Water Budget Concept](#2-the-water-budget-concept)
3. [Data Sources Explained](#3-data-sources-explained)
4. [Tool-by-Tool Deep Dive](#4-tool-by-tool-deep-dive)
5. [Walk Through the Notebook](#5-walk-through-the-notebook)
6. [Likely Defense Questions & Answers](#6-likely-defense-questions--answers)
7. [Python Concepts to Know Cold](#7-python-concepts-to-know-cold)
8. [Web Scraping Concepts](#8-web-scraping-concepts)
9. [What to Say If You Don't Know](#9-what-to-say-if-you-dont-know)

---

## 1. Project Big Picture

### What is this project?

I built a hyper-local **Water Budget Calculator** for a garden near Falenty Nowe, Poland. The goal is to figure out, day by day, whether the garden is gaining water (from rain) or losing it (through evaporation and plant transpiration), and to track the cumulative balance over time.

### Why does this matter?

If the cumulative water balance is **negative**, the garden is in a water deficit and needs irrigation. If it's **positive**, there's a surplus and irrigation is unnecessary. Instead of guessing or relying on general weather forecasts, this gives an evidence-based answer specific to my location.

### The 60-second pitch

> "I scrape weather data from three different Polish and international sources, parse it with regex, merge it into a single DataFrame, and compute the daily water balance as Precipitation minus Evapotranspiration. The cumulative chart shows that my garden is currently in a ~317mm deficit, meaning irrigation has been needed throughout the 2025 growing season."

### Why these particular three sources?

Each source demonstrates a different scraping technique, which the course requires:

| Source         | Why I chose it                                                                                     | Tool demonstrated                |
| -------------- | -------------------------------------------------------------------------------------------------- | -------------------------------- |
| **IMGW**       | Official Polish government weather data, free to use, directory-based archive perfect for crawling | **Scrapy** + **regex**           |
| **Open-Meteo** | Clean JSON API with ET₀ already pre-calculated using FAO Penman-Monteith                           | **Requests**                     |
| **Meteostat**  | JavaScript-rendered page that requires a real browser to load                                      | **Selenium** + **BeautifulSoup** |

---

## 2. The Water Budget Concept

### The Formula

$$\Delta W = P - ET_0$$

- **ΔW** = Daily water balance (mm of water per square meter per day)
- **P** = Precipitation (rain + snowmelt) in mm
- **ET₀** = Reference evapotranspiration in mm — the amount of water that would evaporate from a reference grass surface

### Cumulative Balance

$$\text{Cumulative}_t = \sum_{i=1}^{t} (P_i - ET_{0,i})$$

This is just the running sum of all daily balances since January 1, 2025. A negative cumulative value means the soil has been losing water faster than rain replenishes it.

### What is ET₀?

ET₀ = "Reference Evapotranspiration" — the theoretical amount of water that would evaporate from a well-watered reference grass surface. It depends on:
- Temperature (warmer → more evaporation)
- Solar radiation (more sun → more evaporation)
- Wind speed (more wind → more evaporation)
- Humidity (drier air → more evaporation)

The standard formula is **FAO Penman-Monteith**, which is complex (over 10 variables). Open-Meteo computes it for me using their `et0_fao_evapotranspiration` field, saving me from implementing it manually.

### Why "Reference" Evapotranspiration?

Real evapotranspiration depends on what's actually growing (a cactus loses less than a tomato). ET₀ is the reference for a standardized grass surface — actual crop ET is computed as `Kc × ET₀`, where Kc is a crop-specific coefficient. For a generic garden, ET₀ is a good approximation.

### Realistic Numbers (Poland, Warsaw area)

- **Annual precipitation:** ~520-560 mm/year
- **Annual ET₀:** ~700-800 mm/year (depends on year)
- **Typical deficit:** -150 to -300 mm/year — Polish gardens typically need irrigation in summer
- **My result:** -317 mm cumulative deficit through May 2026 — matches reality!

---

## 3. Data Sources Explained

### 3a. IMGW (danepubliczne.imgw.pl)

**What it is:** The Polish Institute of Meteorology and Water Management — the official Polish national weather service. They publish all their historical station data as a public archive.

**What I scraped:** Daily synoptic weather files from station **Warszawa-Okęcie (WMO 12375, IMGW code 375)** — the closest official station to Falenty Nowe.

**Format:** ZIP files containing comma-separated CSV files with quoted text fields. One ZIP per station per year (e.g., `2025_375_s.zip`). The CSV inside is named `s_d_375_2025.csv`.

**CSV structure:**
```
"354220375",WARSZAWA-OKECIE,"2025","01","01",6.5,,3.8,,2.1,,-1.8,,0.2,...
```
- Field 0: 9-digit station code
- Field 1: Station name
- Field 2-4: Year, month, day (quoted!)
- Field 5: Max temperature (°C)
- Field 7: Min temperature
- Field 9: Average temperature
- Field 13: Daily precipitation (mm)

**Legal status:** Polish Open Data Policy — *"ustawa z dnia 11 sierpnia 2021 r. o otwartych danych"*. Free for private and educational use. The robots.txt doesn't disallow `/data/`.

### 3b. Open-Meteo (archive-api.open-meteo.com)

**What it is:** An open-source weather API run by **Patrick Zippenfenig** (Switzerland). It aggregates data from multiple government weather services (NOAA, ECMWF, DWD, etc.) and serves it via a clean JSON API.

**What I scraped:** Daily weather variables for my exact coordinates (52.135°N, 20.939°E), from January 1, 2025 to yesterday. Variables: temperature, precipitation, wind, solar radiation, and **ET₀** (already calculated).

**Format:** JSON response with parallel arrays:
```json
{
  "daily": {
    "time": ["2025-01-01", "2025-01-02", ...],
    "temperature_2m_max": [6.2, 8.8, ...],
    "precipitation_sum": [0.0, 1.7, ...],
    "et0_fao_evapotranspiration": [1.25, 1.69, ...]
  }
}
```

**Legal status:** Free for non-commercial use. No API key. Data under CC BY 4.0.

### 3c. Meteostat (meteostat.net)

**What it is:** An open-source weather data platform that aggregates station data from NOAA, DWD, and others. Provides clean web UI for browsing station metadata.

**What I scraped:** The station page for Warszawa-Okęcie at `/en/station/12375`. Specifically: station name, elevation, coordinates, timezone, ICAO code, nearby stations.

**Why Selenium?** The page is rendered with JavaScript — the data isn't in the initial HTML. A plain `requests.get()` returns an empty shell. Only a real browser executes the JavaScript and populates the page.

**Legal status:** robots.txt explicitly allows all crawlers (`Allow: /`). Data under CC BY-NC 4.0.

---

## 4. Tool-by-Tool Deep Dive

### 4a. Scrapy

**Where used:** Section 1 of notebook + `imgw_spider.py`

**Why it's the right tool:**
- Need to crawl multiple pages (directory tree: root → year folder → ZIP files)
- Need to download many files efficiently with polite delays
- Built-in robots.txt compliance

**Key concepts:**
- **Spider:** A class that defines what to crawl and how to parse it
- **start_urls:** Where the spider begins
- **parse():** Method called for each response — returns either more Requests (to follow) or Items (to save)
- **CrawlerProcess:** The runtime that executes the spider
- **Twisted reactor:** Scrapy's async engine — can only start once per Python process

**Pattern from class (Part 12):** Spider lives in a separate `.py` file and is run via `subprocess`. This avoids Twisted reactor conflicts in Jupyter.

**My spider's flow:**
1. Start at `/dobowe/synop/`
2. Parse the directory listing → follow year links (`2025/`, `2026/`)
3. In each year folder → match ZIP filenames with regex → download them
4. Save each ZIP to `imgw_data/`

**Polite settings:**
- `ROBOTSTXT_OBEY = True` — respects robots.txt
- `DOWNLOAD_DELAY = 1.0` — 1 second between requests
- `CONCURRENT_REQUESTS = 1` — one at a time
- Custom User-Agent identifying me as an educational bot

### 4b. Requests

**Where used:** Section 3 of notebook

**Why it's the right tool:**
- Open-Meteo is a JSON API — no need for a browser, no need for a crawler
- Simple, fast, exactly what `requests` is designed for

**Key methods used:**
- `requests.get(url, params=..., timeout=...)` — send GET request
- `response.status_code` — check HTTP status (200 = OK)
- `response.json()` — parse JSON response into Python dict
- `response.text` — get raw text response (for HTML)
- `response.raise_for_status()` — raise exception on 4xx/5xx

**Why I prefer `params=dict` over building URL strings:**
- Automatic URL encoding of special characters
- Cleaner code
- Easy to add/remove parameters

### 4c. BeautifulSoup (BS4)

**Where used:** Sections 3 and 4 of notebook

**Why it's the right tool:**
- Parses HTML into a navigable Python tree
- Easy to find elements by tag name, attributes, CSS selectors
- Works with broken/malformed HTML (lenient parser)

**Key methods used:**
- `BeautifulSoup(html, "lxml")` — create parser (using lxml as backend, faster than html.parser)
- `soup.find("h1")` — first matching tag
- `soup.find_all("a", href=True)` — all matching tags
- `tag.get_text(strip=True)` — extract text content
- `tag["href"]` — get attribute value

### 4d. lxml + XPath

**Where used:** Section 3 of notebook (alongside BS4 for demonstration)

**Why it's the right tool:**
- XPath is a query language for XML/HTML — very powerful for complex selections
- lxml is the fastest HTML parser in Python

**Key XPath patterns:**
- `//a/@href` — all href attributes of all `<a>` tags anywhere
- `//a[contains(@href, '/')]` — `<a>` tags whose href contains `/`
- `//div[@class='quote']/span/text()` — text inside `<span>` inside `<div class='quote'>`

**Why use lxml when BS4 exists?**
- XPath is often more concise than chained `.find()` calls
- Faster on large documents
- The class covered both, so I demonstrate both

### 4e. Selenium

**Where used:** Section 4 of notebook

**Why it's the right tool:**
- Meteostat renders content via JavaScript — requests would return an empty shell
- Need a real browser engine to execute JS and produce final DOM

**Key concepts:**
- **WebDriver:** Controls the browser programmatically
- **ChromeDriverManager:** Auto-downloads the correct chromedriver version
- **Options:** Browser configuration (headless mode, User-Agent, etc.)
- **Headless mode:** Browser runs invisibly in the background
- **Page source:** The fully-rendered HTML after JavaScript has run

**Pattern from class (Parts 10-11):**
```python
options = Options()
options.add_argument("--headless")
driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=options
)
driver.get(url)
time.sleep(3)  # wait for JS to render
html = driver.page_source
driver.quit()  # ALWAYS clean up!
```

**Why `time.sleep(3)` instead of WebDriverWait?**
- Simple page where I just need everything loaded
- WebDriverWait is better when waiting for a specific element to appear
- For demonstration purposes the simple approach is clearer

**Why `driver.quit()` matters:**
- Closes the browser process
- Without it, you leak processes and memory
- I use a try/except so it always runs

### 4f. Regex (Python `re` module)

**Where used:** Sections 2 and 4 of notebook

**Why it's the right tool:**
- Need to validate ZIP filenames (`2025_375_s.zip`)
- Need to parse numeric values from CSV fields
- Need to extract specific patterns from Meteostat HTML (elevation, timezone, ICAO)

**Key patterns I use:**

```python
# Compiled patterns (faster when reused)
zip_pattern = re.compile(r"^\d{4}_\d+_s\.zip$", re.IGNORECASE)
num_pattern = re.compile(r"^(-?\d+\.?\d*)$")
station_pattern = re.compile(r"WARSZAWA", re.IGNORECASE)
```

**Regex breakdown:**
- `^` and `$` — anchors (start/end of string)
- `\d` — any digit (0-9)
- `\d{4}` — exactly 4 digits
- `\d+` — one or more digits
- `\.` — literal dot (escaped — `.` alone means any character)
- `(-?\d+\.?\d*)` — optional minus, digits, optional dot, optional digits → matches numbers like `12`, `-3.5`, `0.0`
- `re.IGNORECASE` — case-insensitive matching

**Method differences:**
- `re.match()` — match at START of string
- `re.search()` — match ANYWHERE in string
- `re.findall()` — return ALL matches as list
- `pattern.search(...)` — same but on compiled pattern (faster)

### 4g. Python `csv` module

**Where used:** Section 2 of notebook (the bug fix!)

**Why it's the right tool:**
- IMGW CSV uses quoted fields: `"354220375",WARSZAWA-OKECIE,"2025","01","01",...`
- `line.split(",")` would give `'"2025"'` (with quotes), which can't be converted to int
- `csv.reader` properly handles quoted fields

```python
reader = csv.reader(io.StringIO(content))
for fields in reader:
    # fields[2] is now '2025' (no quotes) — int() works!
```

This was the bug I found that took the project from 0 parsed rows to 485 parsed rows.

---

## 5. Walk Through the Notebook

If the professors point at any section, here's exactly what's happening:

### Section 0: Setup & Imports
Just importing all libraries and setting constants (LAT, LON, ELEVATION). Creates `imgw_data/` and `output/` directories.

### Section 1: Scrapy
- Runs `imgw_spider.py` via `subprocess` (class Part 12 pattern)
- Spider downloads ~63 ZIP files from IMGW into `imgw_data/`
- Takes ~80 seconds due to 1-second polite delay × ~63 requests

### Section 2: Regex Parsing
- Defines 3 regex patterns (filename, numeric, station name)
- Tests them — including showing that invalid input correctly returns `[]`
- The `parse_imgw_zips()` function:
  1. Iterates each ZIP
  2. Opens the inner CSV (Windows Polish encoding `cp1250`)
  3. Uses `csv.reader` to handle quoted fields (the fix!)
  4. Filters rows where station name contains "WARSZAWA"
  5. Extracts date, temps, precipitation using `safe_float()` helper
- First peeks inside ZIPs to show what's there (debugging visibility)
- Returns DataFrame with ~485 daily records for Warszawa

### Section 3a: BS4 + lxml on IMGW page
- Fetches the IMGW metadata directory page with `requests.get()`
- Parses with BeautifulSoup → finds all `<a>` links
- Filters for data subdirectories (`dobowe/`, `terminowe/`, etc.)
- **Also** parses the same page with lxml XPath to demonstrate the technique
- Pure demonstration cell — doesn't affect the final data

### Section 3b: Requests on Open-Meteo
- Single `requests.get()` to the historical archive API
- Sends all parameters as a dict via `params=`
- Parses JSON response → DataFrame
- Renames columns to shorter names
- Returns ~494 days of weather data including ET₀

### Section 4: Selenium + BS4 on Meteostat
- Configures headless Chrome with custom User-Agent
- Loads the Meteostat station page
- Waits 3 seconds for JavaScript to render
- Gets the full rendered HTML via `driver.page_source`
- Passes it to BeautifulSoup
- Uses regex to extract: elevation, timezone, ICAO code, coordinates
- Finds nearby stations via `<a>` tags with `/en/station/N` pattern
- Always calls `driver.quit()` (even on error)

### Section 5: Merge & Calculate
- Joins Open-Meteo and IMGW DataFrames on the date index
- Cross-validates the precipitation values from both sources
- Calculates `water_balance_mm = precip - et0` (daily)
- Calculates `cumulative_water_mm = water_balance_mm.cumsum()` (running total)
- Groups by month to make a summary table

### Section 6: Final DataFrame
- Selects the output columns
- Saves to `output/water_budget.csv`

### Section 7: Visualization
- Creates a 3-panel chart:
  1. Daily precipitation (blue bars) vs ET₀ (orange line)
  2. Cumulative water balance — GREEN fill if surplus, RED fill if deficit
  3. Temperature: min-max range as shaded band, average as line
- Saves PNG to `output/water_budget_charts.png`

### Section 8: Summary
- Prints the final numbers: total precipitation, total ET₀, net balance, status

---

## 6. Likely Defense Questions & Answers

### Q: Why did you choose this project?

> "I wanted something with practical real-world use — knowing whether my garden needs irrigation. The Falenty area is near Warsaw, so I have access to the Warszawa-Okęcie official weather station data. The project naturally requires combining multiple data sources, which fits the course requirement to demonstrate all four scraping tools."

### Q: Why three sources instead of one?

> "Three reasons. First, the course requires demonstrating Scrapy, Requests, Selenium, and BeautifulSoup — that's hard to do with a single source. Second, cross-validation: comparing IMGW precipitation to Open-Meteo gives confidence in the numbers. Third, each source plays a specific role: Open-Meteo gives me ET₀ pre-calculated, IMGW provides official station data, Meteostat provides metadata about the station itself."

### Q: Why did you use subprocess for Scrapy instead of running it inline?

> "Scrapy is built on the Twisted async networking framework. Twisted's reactor — its event loop — can only be started once per Python process. If I tried to run a Scrapy crawler directly inside Jupyter, the first run would work, but subsequent runs in the same kernel would fail with a 'reactor already running' error. By spawning a fresh Python subprocess each time, I get a clean reactor every run. This is the same pattern shown in class Part 12."

### Q: Why csv.reader instead of split(",") for the IMGW data?

> "I initially used `line.split(',')` and got zero parsed rows. The bug was that IMGW's CSVs have quoted text fields, like `'354220375',WARSZAWA-OKECIE,'2025','01','01',...`. With `split`, field 2 came out as `'"2025"'` — with literal quote characters — and `int('"2025"')` raises ValueError. Python's csv.reader properly handles quoting per RFC 4180, so it returns `'2025'` without quotes, and int() works. This took the parser from 0 rows to 485 rows."

### Q: Why did you use Selenium for Meteostat but not for IMGW?

> "Meteostat's station page renders its content via JavaScript — if I just do `requests.get()` on it, I get an empty shell with `<div id='app'></div>` and nothing else. The actual data is loaded by JavaScript after the page loads. Only a real browser like Chrome will execute that JS. IMGW, on the other hand, serves plain HTML directory listings — no JavaScript needed — so Scrapy and Requests work fine. The general principle: use Selenium only when you have to, because it's much slower (loading a full browser) and resource-heavy."

### Q: Why headless mode?

> "Headless means Chrome runs without a visible window. It's faster, uses less memory, and works in environments without a display (like a server or CI environment). For scraping, I never need to see the browser, so headless is the default choice."

### Q: How does the regex pattern `^\d{4}_\d+_s\.zip$` work?

> "Breaking it down: `^` anchors to start of string. `\d{4}` matches exactly 4 digits — the year. `_` is a literal underscore. `\d+` is one or more digits — the station code, which varies in length. `_s` is literal text. `\.` is an escaped dot — without the backslash, `.` would match any character. `zip` is literal. `$` anchors to end of string. So this matches things like `2025_375_s.zip` but not `2025_375_s.zip.bak` or `random.zip`."

### Q: Why use compiled patterns (re.compile) versus calling re.match each time?

> "When you call `re.match(pattern, string)`, Python has to compile the pattern internally each time. If I'm matching against thousands of CSV rows, that's thousands of compilations. `re.compile()` does it once, returns a pattern object, and subsequent `.match()` calls reuse the compiled state. It's a performance optimization. The class also showed this pattern explicitly."

### Q: Is your scraping legal?

> "Yes, for all three sources. IMGW data is published under Polish Open Data Policy (Ustawa z 11 sierpnia 2021), explicitly free for private and educational use. Open-Meteo is a free API with CC BY 4.0 license. Meteostat's robots.txt has `User-agent: * / Allow: /` — explicitly allowing all crawlers — and their data is CC BY-NC 4.0, fine for non-commercial educational use. All this is documented in `legal_proof.txt`."

### Q: What does robots.txt do?

> "It's a file at the root of a website (`example.com/robots.txt`) that tells web crawlers which parts of the site they can or cannot access. It's a convention, not a technical enforcement — but respecting it is required by good practice and often by law. I set `ROBOTSTXT_OBEY = True` in my Scrapy settings so the spider automatically checks before crawling."

### Q: What's the difference between web crawling and web scraping?

> "Web *scraping* is extracting specific data from a web page. Web *crawling* is following links to discover and visit multiple pages. Scrapy does both — its spider crawls the IMGW directory tree and scrapes the file listings to find ZIP files to download. Requests-based code typically just scrapes a single known page."

### Q: What is ET₀ and how is it calculated?

> "ET₀ is the Reference Evapotranspiration — the amount of water that would evaporate from a standardized reference grass surface, in millimeters per day. The standard formula is FAO Penman-Monteith, which combines temperature, solar radiation, wind speed, and humidity into a single equation. It's complex (10+ variables), but Open-Meteo provides it pre-computed via the `et0_fao_evapotranspiration` field. For an actual crop, you'd multiply ET₀ by a crop-specific coefficient Kc, but for a general garden ET₀ is a good approximation."

### Q: Why did you randomize your coordinates?

> "Privacy. Falenty Nowe is a small village — publishing exact coordinates of my garden in a school project would essentially publish my home address. The 300m offset is small enough that weather data is identical (weather varies on scales of kilometers, not meters), but it doesn't pinpoint a specific property."

### Q: What would you improve given more time?

> "Three things. First, add the actual yesterday's data via Selenium on a live weather page — currently I rely on Open-Meteo which has a slight delay. Second, compute crop-specific evapotranspiration using Kc coefficients for typical garden crops. Third, build a simple irrigation alert system — email me when cumulative deficit crosses a threshold."

### Q: What's the biggest weakness of your project?

> "I depend on Warszawa-Okęcie airport as a proxy for Falenty Nowe — it's about 8 km away. For most variables this is fine, but local rainfall can vary significantly over short distances during summer storms. A more rigorous version would interpolate between multiple nearby stations or use a hyperlocal source like a personal weather station from Netatmo."

### Q: What if Open-Meteo had been down?

> "The notebook has a fallback structure: if Open-Meteo fails but IMGW succeeded, it uses IMGW data alone (without ET₀ — I'd have to compute it from temperature). If both fail, it generates synthetic sample data to demonstrate the rest of the pipeline. This was important during development because I sometimes worked from networks where Open-Meteo wasn't reachable."

---

## 7. Python Concepts to Know Cold

### Pandas DataFrames

**What:** Tabular data structure (rows + columns), like a spreadsheet in code.

**Key operations I used:**
- `pd.DataFrame(list_of_dicts)` — create from list
- `df.set_index("date")` — make date the row label
- `df.join(other_df, how="outer")` — merge on index
- `df["col"].fillna(0)` — replace NaN with 0
- `df["col"].cumsum()` — cumulative sum
- `df.groupby("month").agg(...)` — group and aggregate
- `df.to_csv(path)` — save to file

### NaN handling

**What:** Missing values in pandas are represented as `np.nan` (Not a Number).

**Why I use `fillna(0)`:** When computing `precip - et0`, if either is NaN, the result is NaN. Filling with 0 means a missing data point counts as "no rain/no evaporation" rather than corrupting the cumulative sum.

### datetime / date

- `datetime.now()` — current timestamp
- `date.today()` — today's date
- `timedelta(days=1)` — time difference object
- `date(2025, 1, 1)` — specific date

### File handling

- `with open(file, "r") as f:` — context manager (auto-closes)
- `Path("dir").glob("*.zip")` — find files matching pattern
- `os.makedirs(path, exist_ok=True)` — create directory if not exists
- `zipfile.ZipFile(path)` — open ZIP archive

### Encoding

- IMGW uses **cp1250** (Windows Central European) — has Polish characters
- `errors="replace"` means replace invalid bytes with `?` instead of crashing
- UTF-8 is the modern default, but legacy data sources often use older encodings

### subprocess

```python
result = subprocess.run(
    ['python', 'script.py'],     # command and args as list
    capture_output=True,         # capture stdout/stderr
    text=True,                   # decode as strings (not bytes)
    timeout=120                  # max seconds
)
result.stdout      # what the script printed
result.returncode  # 0 = success, non-zero = error
```

### try/except

```python
try:
    risky_operation()
except SpecificError as e:
    print(f"Failed: {e}")
```

Catch specific exceptions, not bare `except:` (which would catch even KeyboardInterrupt).

---

## 8. Web Scraping Concepts

### HTTP Status Codes

- **200 OK** — success
- **301/302** — redirect
- **403 Forbidden** — server refuses (often anti-scraping)
- **404 Not Found** — page doesn't exist
- **429 Too Many Requests** — rate limit
- **500** — server error

### HTML Structure

```html
<html>
  <head><title>Page</title></head>
  <body>
    <div class="container" id="main">
      <a href="/path">Link text</a>
    </div>
  </body>
</html>
```

- **Tag:** `<div>`, `<a>`, `<h1>`, etc.
- **Attribute:** `class`, `id`, `href`
- **Text content:** what's between tags
- **DOM:** the parsed tree structure

### CSS Selectors (used in Scrapy and BS4)

- `a` — all `<a>` tags
- `.classname` — by class
- `#idname` — by ID
- `div > a` — direct children
- `div a` — any descendant
- `a[href]` — `<a>` tags with href attribute
- `a::attr(href)` — extract href attribute (Scrapy syntax)
- `a::text` — extract text content (Scrapy syntax)

### XPath (used with lxml)

- `//a` — all `<a>` tags anywhere
- `//div[@class='container']` — by attribute value
- `//a/@href` — extract href attribute
- `//a[contains(@href, 'pattern')]` — partial match

### Polite scraping

- **Respect robots.txt**
- **Use a real User-Agent** identifying who you are
- **Rate-limit** (delays between requests)
- **Cache responses** during development
- **Don't scrape during peak hours** when possible
- **Use APIs when available** (much friendlier than scraping HTML)

### When to use what

| Need | Tool |
|---|---|
| Single static page | requests + BeautifulSoup |
| API with JSON | requests |
| Many pages/files, link-following | Scrapy |
| JavaScript-rendered content | Selenium (or Playwright) |
| Heavy XPath queries | lxml |
| Parsing structured text patterns | regex |

---

## 9. What to Say If You Don't Know

If they ask something I genuinely don't know:

✅ **DO say:**
- "Honestly, I'm not 100% sure. My best guess would be..."
- "I don't remember off the top of my head, but if I needed to find out, I would..."
- "I haven't worked with that specifically, but conceptually I'd expect..."
- "Let me think through it from first principles..."

❌ **DON'T:**
- Make up technical claims
- Pretend to know something you don't
- Get defensive
- Apologize excessively

**Pivot strategy:** If a question is outside what I know, pivot to what I *do* know.

> Q: "How does Twisted's reactor actually work internally?"
> A: "I know it's an event loop and that it can only start once per process — that's why my Scrapy spider runs via subprocess. The deeper internals of how it schedules callbacks, I don't know off the top of my head. But I could read the Twisted docs to learn that."

---

## Final Defense Day Checklist

**Night before:**
- [ ] Re-run the notebook end-to-end on my machine, confirm everything works
- [ ] Skim through this guide once more
- [ ] Get a good night's sleep

**Day of:**
- [ ] Have the notebook open and ready
- [ ] Have `imgw_spider.py` open in a second tab
- [ ] Have `legal_proof.txt` ready in a third tab
- [ ] Bring water

**During the defense:**
- [ ] Take a breath before answering — there's no rush
- [ ] If I don't understand the question, ask for clarification
- [ ] Speak about what the code is *doing* and *why*, not just *what* it says
- [ ] If I make a mistake, correct it calmly
- [ ] Three questions only — pace myself

**The three most likely question topics:**
1. **Scrapy subprocess pattern** — why? → Twisted reactor
2. **Selenium vs Requests** — when? → JavaScript-rendered content
3. **Regex usage** — what patterns? → filename validation, numeric parsing

Master those three answers and the rest is gravy.

---

**Good luck, Ondřej!**
