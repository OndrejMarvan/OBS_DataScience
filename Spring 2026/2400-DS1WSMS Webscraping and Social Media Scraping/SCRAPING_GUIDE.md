# Web Scraping Technical Guide — Defense Preparation

**Student:** Ondřej Marvan (477 001)
**Companion to:** DEFENSE_GUIDE.md
**Purpose:** Deep technical answers for any web scraping question that could come up

This guide answers the kind of technical questions professors ask to test that you actually understand *how* web scraping works, not just *that* your code runs.

---

## Table of Contents

1. [How the Web Works (Fundamentals)](#1-how-the-web-works-fundamentals)
2. [HTTP Protocol Deep Dive](#2-http-protocol-deep-dive)
3. [HTML and the DOM](#3-html-and-the-dom)
4. [CSS Selectors vs XPath](#4-css-selectors-vs-xpath)
5. [Static vs Dynamic Pages](#5-static-vs-dynamic-pages)
6. [Tool Comparison — When to Use What](#6-tool-comparison--when-to-use-what)
7. [Requests Library Internals](#7-requests-library-internals)
8. [BeautifulSoup Internals](#8-beautifulsoup-internals)
9. [lxml Internals](#9-lxml-internals)
10. [Selenium Internals](#10-selenium-internals)
11. [Scrapy Architecture](#11-scrapy-architecture)
12. [Regex Mastery](#12-regex-mastery)
13. [JSON, APIs, and Data Formats](#13-json-apis-and-data-formats)
14. [Anti-Scraping & How to Be Polite](#14-anti-scraping--how-to-be-polite)
15. [Encoding, Character Sets, and Polish Diacritics](#15-encoding-character-sets-and-polish-diacritics)
16. [Performance, Async, and Concurrency](#16-performance-async-and-concurrency)
17. [Common Errors & Debugging](#17-common-errors--debugging)
18. [Common Trick Questions](#18-common-trick-questions)

---

## 1. How the Web Works (Fundamentals)

### What happens when I open a URL in a browser?

1. **DNS Lookup** — Browser asks DNS server: "What's the IP address of `meteostat.net`?" Gets back something like `104.21.46.222`.
2. **TCP Connection** — Browser opens a TCP socket to that IP on port 443 (HTTPS).
3. **TLS Handshake** — They negotiate encryption keys for the secure connection.
4. **HTTP Request** — Browser sends: `GET /en/station/12375 HTTP/2`.
5. **Server Response** — Server returns HTTP status (200) + headers + HTML body.
6. **Browser Renders** — Browser parses the HTML, builds the DOM tree, downloads CSS/JS, applies styles, executes scripts.
7. **JavaScript Runs** — If the page is dynamic, JavaScript modifies the DOM, makes additional API calls (AJAX), populates content.
8. **Page Visible** — Final rendered page is shown to user.

**Scraping perspective:** `requests` performs steps 1–5 (gets the raw HTML response). Selenium performs all 8 steps (actually renders the page with a browser).

### Client vs Server

- **Client** = the browser (or Python script). Requests resources.
- **Server** = the web server. Responds to requests.
- **Static page** = server sends the same HTML every time. Pre-built.
- **Dynamic page** = server builds the HTML on the fly (e.g., from a database), or the browser builds it client-side via JavaScript.

### URL Anatomy

```
https://archive-api.open-meteo.com:443/v1/archive?latitude=52.135&longitude=20.939#section
└─┬─┘  └────────┬─────────────────┘└─┬─┘└──┬─────┘└─────────────┬───────────────┘└──┬──┘
scheme    host (subdomain)        port  path        query string                  fragment
```

- **Scheme:** `https` (encrypted) or `http`
- **Host:** the server's domain name
- **Port:** default 443 for HTTPS, 80 for HTTP (usually omitted)
- **Path:** what resource on the server
- **Query string:** key=value pairs after `?`, separated by `&`. The API parameters.
- **Fragment:** after `#`, never sent to server (browser-only)

---

## 2. HTTP Protocol Deep Dive

### HTTP Methods

| Method | Purpose | I used? |
|---|---|---|
| **GET** | Fetch a resource | ✓ all my scraping |
| **POST** | Submit data, create resource | No (would be for forms/uploads) |
| **PUT** | Update/replace resource | No |
| **DELETE** | Remove resource | No |
| **HEAD** | Like GET but only returns headers | No |
| **OPTIONS** | Discover what methods are allowed | No |

My project uses only GET — pulling data, never sending.

### HTTP Status Codes (the ones to know)

- **1xx** — Informational (rarely seen)
- **2xx** — Success
  - **200 OK** — Standard success
  - **201 Created** — POST/PUT succeeded
  - **204 No Content** — Success but no body
- **3xx** — Redirection
  - **301 Moved Permanently** — Resource permanently at new URL
  - **302 Found** — Temporary redirect
  - **304 Not Modified** — Cached version is fine
- **4xx** — Client error (you did something wrong)
  - **400 Bad Request** — Malformed request
  - **401 Unauthorized** — Need to log in
  - **403 Forbidden** — Server refuses, even with auth
  - **404 Not Found** — Resource doesn't exist
  - **429 Too Many Requests** — Rate limited
- **5xx** — Server error (server screwed up)
  - **500 Internal Server Error** — Generic crash
  - **502 Bad Gateway** — Upstream issue
  - **503 Service Unavailable** — Overloaded/maintenance

### HTTP Headers

Headers are key:value metadata sent with requests/responses.

**Common request headers I should know:**

| Header | Purpose |
|---|---|
| `User-Agent` | Identifies the client (browser, bot, etc.) |
| `Accept` | What content types client wants |
| `Accept-Language` | Preferred language |
| `Accept-Encoding` | Compression support (gzip, br) |
| `Cookie` | Session/state data |
| `Referer` | Page that linked here |
| `Authorization` | Credentials |

**Common response headers:**

| Header | Purpose |
|---|---|
| `Content-Type` | MIME type (e.g., `text/html`, `application/json`) |
| `Content-Length` | Size in bytes |
| `Content-Encoding` | Compression used |
| `Set-Cookie` | Tells client to store cookie |
| `Cache-Control` | How to cache the response |
| `Server` | Server software (Apache, nginx) |

### My custom User-Agent

```
WaterBudgetBot/1.0 (educational project - Ondrej Marvan)
```

**Why custom?** Default `python-requests/2.31.0` looks suspicious to some servers — they may block "obvious bot" UAs. A real-looking but honest UA (identifies me as a bot, but a polite educational one) is better practice than impersonating a browser.

### HTTP vs HTTPS

- **HTTP:** Plain text, port 80. Anyone can read traffic.
- **HTTPS:** TLS-encrypted, port 443. Default for all modern sites.
- For scraping, no functional difference — `requests` and Scrapy handle both transparently.

---

## 3. HTML and the DOM

### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Page Title</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <h1>Heading</h1>
    <div class="container" id="main">
      <a href="/path">Link</a>
      <p>Paragraph</p>
    </div>
  </body>
</html>
```

**Anatomy:**
- **Tag/Element:** `<div>`, `<a>`, `<p>` — defines what something is
- **Attributes:** `class="container"`, `id="main"`, `href="/path"` — properties of an element
- **Text content:** "Heading", "Link", "Paragraph"
- **Opening/closing tags:** `<div>...</div>` wrap content
- **Self-closing tags:** `<meta>`, `<br>`, `<img>` — no closing tag

### The DOM (Document Object Model)

When the browser parses HTML, it builds a tree structure:

```
html
├── head
│   ├── meta
│   ├── title
│   └── link
└── body
    ├── h1
    └── div (class=container, id=main)
        ├── a (href=/path)
        └── p
```

Each node is a Python object when parsed by BeautifulSoup/lxml. You navigate the tree.

### Key DOM concepts

- **Parent/Child:** `body` is the parent of `h1`. `h1` is a child of `body`.
- **Siblings:** `h1` and `div` are siblings (same parent).
- **Descendants:** `a` is a descendant of `body` (any depth below).
- **Attributes:** Stored as key-value pairs on each element.
- **classes:** A single element can have multiple classes (`<div class="a b c">`).
- **ID:** Should be unique per page (only one `id="main"`).

### Inspecting a page

In your browser:
- Right-click → "Inspect Element" — opens DevTools
- The Elements tab shows the live DOM (not the source HTML — they can differ for JS-rendered pages)
- Ctrl+F in DevTools — search using CSS selectors or XPath

This is how I figured out which selectors to use in the project.

### View source vs DevTools

- **View Source (Ctrl+U):** The original HTML sent by the server.
- **DevTools Elements tab:** The live DOM, which may have been modified by JavaScript.

**Critical insight:** For Meteostat, View Source shows almost nothing (a few script tags). DevTools shows the actual content. That's how I knew I needed Selenium.

---

## 4. CSS Selectors vs XPath

Both let you query elements from a parsed HTML tree. They're alternative query languages.

### CSS Selectors (what I used in Scrapy + BS4)

| Selector | Matches |
|---|---|
| `a` | All `<a>` tags |
| `.classname` | Elements with `class="classname"` |
| `#idname` | Element with `id="idname"` |
| `div.class` | `<div>` tags with class |
| `div > a` | `<a>` that's a *direct* child of `<div>` |
| `div a` | `<a>` that's a *descendant* of `<div>` (any depth) |
| `div + p` | `<p>` immediately following `<div>` (adjacent sibling) |
| `div ~ p` | `<p>` siblings after `<div>` (general sibling) |
| `a[href]` | `<a>` tags with href attribute |
| `a[href="/path"]` | exact match |
| `a[href^="https"]` | href starts with "https" |
| `a[href$=".pdf"]` | href ends with ".pdf" |
| `a[href*="meteo"]` | href contains "meteo" |
| `li:first-child` | First child element |
| `li:nth-child(2)` | Second child |
| `li:last-child` | Last child |

**Scrapy extensions:**
- `a::text` — extract text content
- `a::attr(href)` — extract attribute

### XPath (what I used with lxml)

| XPath | Matches |
|---|---|
| `//a` | All `<a>` anywhere |
| `/html/body/div` | Strict path from root |
| `//div[@class='container']` | div with specific class |
| `//*[@id='main']` | any tag with id="main" |
| `//a[contains(@href, '/')]` | href contains "/" |
| `//a[starts-with(@href, 'http')]` | href starts with "http" |
| `//a[text()='Link']` | tag whose text is "Link" |
| `//div//a` | `<a>` inside `<div>` (any depth) |
| `//div/a` | `<a>` directly inside `<div>` |
| `//ul/li[1]` | First `<li>` in `<ul>` (1-indexed!) |
| `//ul/li[last()]` | Last `<li>` |
| `//a/@href` | href values (not the elements) |
| `//a/text()` | text content |

### When to use which?

| Need | Preferred |
|---|---|
| Simple, common queries | CSS Selectors |
| Find by text content | XPath (`//a[text()='foo']`) |
| Find parent of something | XPath (`/..`) |
| Complex conditions | XPath |
| Speed on large docs | lxml + XPath |
| Most cases in modern scraping | CSS Selectors |

CSS selectors are more readable. XPath is more powerful. Both languages, both valid choices.

### In my project

**Scrapy spider:**
```python
response.css("a::attr(href)").getall()
```

**BeautifulSoup (Section 3a):**
```python
soup.find_all("a", href=True)
```

**lxml + XPath (Section 3a):**
```python
tree.xpath("//a/@href")
tree.xpath("//a[contains(@href, '/')]/@href")
```

I demonstrate both approaches on the same page to show I understand each.

---

## 5. Static vs Dynamic Pages

### Static page

Server sends complete HTML. Everything you see is in the response.

**Example:** IMGW's directory listing — plain Apache index page.

**Test:** Compare `view-source:url` vs DevTools Elements. If similar, it's static.

**Tools that work:** requests + BeautifulSoup, lxml, Scrapy.

### Dynamic page (server-side rendered)

Server builds HTML on the fly (from a database, template engine). The browser still receives complete HTML.

**Example:** WordPress blogs, most CMSes.

**Same scraping approach as static** — the rendering happens on the server before sending.

### Dynamic page (client-side rendered, JS-heavy)

Server sends minimal HTML. JavaScript runs in the browser and populates the content (often via AJAX/fetch to internal APIs).

**Example:** Meteostat station page. Single-page apps (React, Vue, Angular).

**Symptoms:**
- `view-source` shows mostly empty `<div id="app"></div>`
- DevTools Network tab shows lots of API calls after page load
- Content appears with a slight delay

**Tools that work:** Selenium, Playwright, Puppeteer (headless browsers).

**Alternative:** Sometimes you can find the underlying API the JS calls, and just hit that with `requests` directly — much faster than Selenium. (For Meteostat, the easier route was Selenium because their public API requires an API key.)

### How I identified Meteostat was dynamic

1. Opened the page in browser
2. Right-click → View Source
3. Saw mostly `<script>` tags and an empty `<div id="app">`
4. Opened DevTools → Elements tab
5. Saw the populated content
6. Conclusion: JavaScript rendering → need Selenium

---

## 6. Tool Comparison — When to Use What

### Decision tree

```
Need to scrape something?
│
├── Is it a clean JSON API?
│   └── YES → use Requests, parse with .json()
│
├── Is the page static HTML?
│   ├── Just one page → Requests + BeautifulSoup
│   └── Many linked pages, lots of files → Scrapy
│
└── Is the page JavaScript-rendered?
    ├── Can I find the underlying API?
    │   └── YES → Requests (much faster)
    │   └── NO  → Selenium / Playwright
    └── Otherwise → Selenium / Playwright
```

### Trade-offs

| Tool | Speed | Resources | Complexity | JS Support |
|---|---|---|---|---|
| **Requests** | ⚡⚡⚡ | Minimal | Easy | None |
| **BeautifulSoup** | ⚡⚡⚡ | Minimal | Easy | None (parses static HTML) |
| **lxml** | ⚡⚡⚡⚡ | Minimal | Medium (XPath) | None |
| **Scrapy** | ⚡⚡⚡ | Medium | Medium-Hard | None natively |
| **Selenium** | ⚡ | Heavy (full browser) | Medium | Full |
| **Playwright** | ⚡⚡ | Heavy | Medium | Full, modern |

### In my project, each tool plays to its strength

- **Scrapy** → many files to download with link-following. Perfect.
- **Requests** → clean JSON API. Perfect.
- **BeautifulSoup** → static HTML parsing. Perfect.
- **Selenium** → JS-rendered page. Necessary.
- **lxml** → demonstrated XPath because the course covered it.

---

## 7. Requests Library Internals

### Basic GET

```python
response = requests.get(url, params=dict, timeout=30)
```

### What `params=dict` does

Builds the query string for you:
```python
requests.get("https://api.com/data", params={"key": "value", "n": 5})
# Becomes: GET https://api.com/data?key=value&n=5
```

It also URL-encodes special characters automatically (spaces → `%20`, etc.).

### The Response object

```python
r = requests.get(url)
r.status_code      # 200
r.text             # Body as string (auto-decoded)
r.content          # Body as bytes (raw)
r.json()           # Parse JSON body to dict/list
r.headers          # Dict of response headers
r.url              # Final URL (after redirects)
r.history          # List of redirects
r.encoding         # Detected encoding
r.cookies          # CookieJar
r.elapsed          # Time it took
r.ok               # True if status < 400
```

### Sessions (for multi-request scraping)

```python
session = requests.Session()
session.headers.update({"User-Agent": "MyBot/1.0"})
r1 = session.get(url1)
r2 = session.get(url2)  # reuses cookies, connection
```

Sessions are more efficient than separate `.get()` calls — they reuse TCP connections (connection pooling).

### Timeouts (essential!)

```python
requests.get(url, timeout=30)
```

Without `timeout`, a request can hang forever if the server is dead. ALWAYS set a timeout. I use 30-60s in my project.

### Error handling

```python
try:
    r = requests.get(url, timeout=30)
    r.raise_for_status()  # raises if 4xx or 5xx
except requests.Timeout:
    print("Server too slow")
except requests.ConnectionError:
    print("Couldn't connect")
except requests.HTTPError as e:
    print(f"Bad status: {e}")
except requests.RequestException as e:
    print(f"Some other request error: {e}")
```

`RequestException` is the parent — catches all of the above.

---

## 8. BeautifulSoup Internals

### Creating a soup

```python
from bs4 import BeautifulSoup
soup = BeautifulSoup(html, "lxml")  # use lxml as the underlying parser
```

Parsers (in order of speed):
- `"lxml"` — fastest, most lenient (my choice)
- `"html.parser"` — built-in, no extra dependency
- `"html5lib"` — slowest but most correct (browser-like)

### Finding elements

```python
soup.find("h1")              # first <h1>
soup.find("a", href=True)    # first <a> with href attribute
soup.find("div", class_="container")  # by class (note trailing _ because class is a reserved keyword!)
soup.find(id="main")         # by id

soup.find_all("a")           # ALL <a> tags as list
soup.find_all("a", limit=5)  # first 5
soup.find_all(["h1", "h2"])  # both h1 and h2
```

### CSS selectors (alternative)

```python
soup.select("a")             # like find_all
soup.select_one("a")         # like find
soup.select("div.container > a")
```

### Extracting data

```python
tag.name                     # "a"
tag.string                   # text if it's the only child, else None
tag.get_text(strip=True)     # text content, whitespace stripped
tag.get_text(" ")            # text with " " separator
tag["href"]                  # attribute value (KeyError if missing)
tag.get("href")              # attribute value (None if missing — safer)
tag.attrs                    # dict of all attributes
```

### Navigating the tree

```python
tag.parent                   # parent element
tag.parents                  # all ancestors (generator)
tag.children                 # direct children
tag.descendants              # all descendants
tag.next_sibling             # next sibling
tag.previous_sibling
```

### What I used in my project

```python
soup = BeautifulSoup(response.text, "lxml")
all_links = soup.find_all("a", href=True)

for a_tag in all_links:
    href = a_tag["href"]
    text = a_tag.get_text(strip=True)
    if re.match(r"^(dobowe|terminowe|miesieczne)/", href):
        # process
```

### Why `lxml` as parser inside BeautifulSoup?

It's the fastest. BeautifulSoup is the *interface*; lxml is the engine. You get BS4's nice API + lxml's speed.

---

## 9. lxml Internals

### Creating a tree

```python
from lxml import html
tree = html.fromstring(response.text)
```

### XPath queries

```python
tree.xpath("//a")            # list of all <a> elements
tree.xpath("//a/@href")      # list of all href values (just strings)
tree.xpath("//a/text()")     # list of text contents (strings)
tree.xpath("count(//a)")     # number of <a> elements (returns float!)
```

### Why XPath returns strings sometimes, elements other times

- `//a` returns Element objects
- `//a/@href` returns the string values of the attribute
- `//a/text()` returns the text strings

### XPath axis (advanced)

```python
//div/parent::body          # the body that contains this div
//div/following-sibling::p  # <p> siblings after this div
//div/preceding-sibling::h1 # <h1> siblings before
//div/ancestor::*           # all ancestors
```

These are powerful but rarely needed in basic scraping.

### lxml vs BeautifulSoup quick comparison

```python
# Find all hrefs
# BeautifulSoup:
[a["href"] for a in soup.find_all("a", href=True)]

# lxml + XPath:
tree.xpath("//a/@href")
```

XPath is more concise here. But BeautifulSoup reads more like English. Both are fine.

---

## 10. Selenium Internals

### What Selenium actually does

Selenium drives a real browser via a protocol called WebDriver. Each browser has its own driver:
- Chrome → ChromeDriver
- Firefox → GeckoDriver
- Edge → EdgeDriver

Selenium sends commands ("click that button", "get page source") over HTTP to the driver, which controls the browser.

### Why `ChromeDriverManager().install()`?

Manually installing the right ChromeDriver version is annoying — it must match your Chrome version exactly. ChromeDriverManager (from webdriver-manager package) downloads the correct version automatically.

```python
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=chrome_options
)
```

### Headless mode

```python
options = Options()
options.add_argument("--headless")
```

Means the browser runs without a visible window. Faster, lower resource use, works on servers without a display.

### Other useful options

```python
options.add_argument("--no-sandbox")              # required on some Linux containers
options.add_argument("--disable-dev-shm-usage")   # avoids /dev/shm memory issues
options.add_argument("--disable-gpu")             # not needed in headless
options.add_argument("user-agent=MyBot/1.0")      # custom UA
options.add_argument("--window-size=1920,1080")   # set viewport
```

### Finding elements

```python
from selenium.webdriver.common.by import By

driver.find_element(By.ID, "main")
driver.find_element(By.CLASS_NAME, "container")
driver.find_element(By.CSS_SELECTOR, "div.quote span.text")
driver.find_element(By.XPATH, "//a[contains(@href, 'station')]")
driver.find_element(By.TAG_NAME, "h1")
driver.find_element(By.LINK_TEXT, "Click here")

driver.find_elements(...)  # plural — returns list
```

### Waiting for things to load

```python
# Bad: hope it's loaded
driver.get(url)
element = driver.find_element(...)  # might fail if JS hasn't run

# Better: sleep blindly (what I did)
driver.get(url)
time.sleep(3)
element = driver.find_element(...)

# Best: explicit wait
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

wait = WebDriverWait(driver, 10)
element = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "div.quote")))
```

### Interacting with the page

```python
element.click()
element.send_keys("text to type")
element.text                  # visible text
element.get_attribute("href") # attribute value
driver.execute_script("return document.title")  # run JavaScript
driver.page_source             # full rendered HTML
```

### Always quit!

```python
try:
    driver = webdriver.Chrome(...)
    # ... do stuff
finally:
    driver.quit()  # always close, even on error
```

Without `quit()`, the Chrome process keeps running → memory leak.

### Why `driver.quit()` not `driver.close()`?

- `close()` — closes the current tab
- `quit()` — closes the entire browser and ends the WebDriver session

Always `quit()` at the end.

---

## 11. Scrapy Architecture

### How Scrapy is different from requests

Requests is synchronous — one request at a time. Scrapy is asynchronous — many requests in flight simultaneously, scheduled by the Twisted event loop.

### Components

```
       ┌─────────────────────────────────────┐
       │            Spider (my code)         │
       │   defines what to scrape            │
       └────────────────┬────────────────────┘
                        │ yields Requests/Items
                        ▼
       ┌─────────────────────────────────────┐
       │            Scrapy Engine            │
       └───┬─────────────────────────────┬───┘
           │                             │
           ▼                             ▼
       ┌─────────┐                  ┌─────────┐
       │Scheduler│                  │Downloader│
       │ (queue) │                  │ (HTTP)   │
       └─────────┘                  └─────────┘
                                          │
                                          ▼
                              ┌─────────────────────────┐
                              │   Downloader Middleware │
                              │ (robots.txt, retries,   │
                              │  cookies, user-agent)   │
                              └─────────────────────────┘
                                          │
                                          ▼
                                      The Internet
```

### The Spider lifecycle

1. Spider's `start_requests()` yields initial Requests
2. Engine sends them to Downloader (through middlewares)
3. Downloader fetches, returns Response
4. Response goes to the Spider's parse method
5. parse() yields more Requests (to follow) or Items (data to save)
6. Items go through Item Pipelines (cleaning, deduplication, storage)
7. Repeats until no more Requests

### Why Twisted reactor matters

Twisted is Scrapy's async networking library. The "reactor" is the central event loop that schedules I/O.

**Constraint:** A Python process can only have ONE reactor instance, and once stopped, it cannot be restarted in the same process.

**Implication for Jupyter:** If you start a Scrapy crawler in a cell, it works the first time. Try to run another in the same notebook session → "ReactorAlreadyInstalledError" or hang.

**My solution (class Part 12 pattern):** Run Scrapy via `subprocess.run(['python', 'imgw_spider.py'])`. Each call spawns a fresh Python process with a fresh reactor. Works every time.

### Spider class

```python
class ImgwSynopSpider(scrapy.Spider):
    name = "imgw_synop"           # unique identifier
    start_urls = [...]             # where to start
    custom_settings = {...}        # spider-specific settings

    def parse(self, response):
        # callback for each response from start_urls
        for link in response.css("a::attr(href)").getall():
            yield scrapy.Request(url, callback=self.parse_zip_listing)

    def parse_zip_listing(self, response):
        # another callback
        ...

    def save_zip(self, response):
        # final callback
        ...
        yield {"filename": ..., "size_bytes": ...}  # this is an Item
```

### Key Settings I used

| Setting | Value | Why |
|---|---|---|
| `ROBOTSTXT_OBEY` | `True` | Respect robots.txt — legal/ethical |
| `DOWNLOAD_DELAY` | `1.0` | 1 second between requests — polite |
| `CONCURRENT_REQUESTS` | `1` | One at a time — gentle on server |
| `USER_AGENT` | Custom | Identify the bot honestly |
| `LOG_LEVEL` | `INFO` | Verbose enough to track progress |

### CrawlerProcess vs CrawlerRunner

- `CrawlerProcess` — manages reactor itself, simpler. What I use.
- `CrawlerRunner` — for embedding in your own Twisted app.

For standalone scripts, always `CrawlerProcess`.

### Why output to JSON?

```python
"FEEDS": {"output/scrapy_imgw_log.json": {"format": "json", "overwrite": True}}
```

Scrapy automatically serializes yielded Items into JSON. Easy to consume later.

---

## 12. Regex Mastery

### The metacharacters

| Symbol | Meaning |
|---|---|
| `.` | Any single character (except newline) |
| `\d` | Digit (0-9) |
| `\D` | Not a digit |
| `\w` | Word character (letter, digit, underscore) |
| `\W` | Not a word character |
| `\s` | Whitespace (space, tab, newline) |
| `\S` | Not whitespace |
| `\b` | Word boundary (zero-width) |
| `^` | Start of string (or line with re.MULTILINE) |
| `$` | End of string (or line) |
| `\` | Escape the next character |

### Quantifiers

| Symbol | Meaning |
|---|---|
| `*` | 0 or more |
| `+` | 1 or more |
| `?` | 0 or 1 (optional) |
| `{n}` | Exactly n |
| `{n,}` | n or more |
| `{n,m}` | Between n and m |
| `*?`, `+?`, `??` | Lazy (non-greedy) versions |

### Groups

| Pattern | Meaning |
|---|---|
| `(abc)` | Capturing group |
| `(?:abc)` | Non-capturing group |
| `(?P<name>abc)` | Named group |
| `[abc]` | Character class — any of a, b, c |
| `[^abc]` | NOT a, b, or c |
| `[a-z]` | Range |
| `[a-zA-Z0-9]` | Common: letters and digits |

### Greedy vs lazy

`.*` is greedy — matches as much as possible.
`.*?` is lazy — matches as little as possible.

**Example:**
- Input: `"<a>foo</a><b>bar</b>"`
- `<.*>` matches the whole thing (`<a>foo</a><b>bar</b>`)
- `<.*?>` matches just `<a>`

### Methods in Python's `re` module

| Method | Returns |
|---|---|
| `re.match(pattern, string)` | Match at START of string (or None) |
| `re.search(pattern, string)` | First match ANYWHERE (or None) |
| `re.findall(pattern, string)` | List of all matches |
| `re.finditer(pattern, string)` | Iterator of Match objects |
| `re.sub(pattern, replacement, string)` | Replace matches |
| `re.split(pattern, string)` | Split string |
| `re.compile(pattern, flags)` | Pre-compile for reuse |

### Flags

```python
re.IGNORECASE  # case-insensitive
re.MULTILINE   # ^ and $ match line starts/ends
re.DOTALL      # . matches newlines too
re.VERBOSE     # allow whitespace and comments in pattern
```

### My patterns explained line-by-line

**`r"^\d{4}_\d+_s\.zip$"` — IMGW filename:**
- `^` — start
- `\d{4}` — exactly 4 digits (year)
- `_` — literal underscore
- `\d+` — one or more digits (station code)
- `_s` — literal
- `\.` — literal dot
- `zip` — literal
- `$` — end

Matches: `2025_375_s.zip`. Doesn't match: `2025_375_s.zip.bak` or `random.zip`.

**`r"^(-?\d+\.?\d*)$"` — numeric value:**
- `^` — start
- `(-?\d+\.?\d*)` — capture group:
  - `-?` — optional minus
  - `\d+` — one or more digits
  - `\.?` — optional dot
  - `\d*` — zero or more digits after dot
- `$` — end

Matches: `12`, `12.5`, `-3.7`, `0.0`. Doesn't match: `12.`, `abc`, `12.5.6`.

**`r"WARSZAWA"` with `re.IGNORECASE` — station name:**
- Just the substring, anywhere in the value.
- Matches: `WARSZAWA`, `WARSZAWA-OKĘCIE`, `Warszawa-Bielany`.

**`r"Elevation[:\s]+(\d+)\s*m"` — extract elevation:**
- `Elevation` — literal
- `[:\s]+` — one or more of `:` or whitespace
- `(\d+)` — capture digits
- `\s*` — optional whitespace
- `m` — literal "m" (meters)

Matches: `Elevation: 106 m`, `Elevation:106m`, `Elevation 106m`.

**`r"Timezone[:\s]+([A-Z][a-z]+/[A-Z][a-z]+)"` — timezone:**
- The fix I made! Original was `(\S+)` which greedily grabbed too much.
- `([A-Z][a-z]+/[A-Z][a-z]+)` requires the format `Continent/City`
- Capital letter + lowercase letters, slash, capital + lowercase
- Matches `Europe/Warsaw`. Stops there even if followed by `Coordinates`.

### When NOT to use regex

> "Some people, when confronted with a problem, think 'I know, I'll use regex.' Now they have two problems." — Jamie Zawinski

**Don't use regex to:**
- **Parse HTML** — use BeautifulSoup/lxml. HTML is nested and irregular; regex can't handle that.
- **Parse JSON** — use `json.loads()`.
- **Parse CSV with quoted fields** — use `csv.reader`. (This is what bit me in the project!)

**Do use regex for:**
- Pattern matching in strings
- Validation (does this look like an email?)
- Extracting structured fragments
- Search and replace

---

## 13. JSON, APIs, and Data Formats

### What is an API?

API = Application Programming Interface. In the web context, it's an endpoint that returns structured data (usually JSON) instead of HTML.

**Open-Meteo example:**
```
GET https://archive-api.open-meteo.com/v1/archive?latitude=52.135&longitude=20.939&start_date=2025-01-01&end_date=2026-04-30&daily=temperature_2m_max,precipitation_sum
```

Returns:
```json
{
  "latitude": 52.135,
  "longitude": 20.939,
  "daily": {
    "time": ["2025-01-01", "2025-01-02"],
    "temperature_2m_max": [6.2, 8.8],
    "precipitation_sum": [0.0, 1.7]
  }
}
```

### Why APIs are easier than scraping HTML

- Structured data — no parsing needed
- Stable interface — won't break when designers change the page
- Often documented
- Usually allowed by terms of service
- Faster (no HTML to download)

### JSON in Python

```python
import json
import requests

# From a string
data = json.loads('{"key": "value"}')

# From a response (most common)
r = requests.get(url)
data = r.json()  # parses to dict/list

# To a string
text = json.dumps(data, indent=2, ensure_ascii=False)

# To a file
with open("data.json", "w") as f:
    json.dump(data, f, indent=2)
```

### JSON types

| JSON | Python |
|---|---|
| object | dict |
| array | list |
| string | str |
| number (int) | int |
| number (float) | float |
| true/false | True/False |
| null | None |

### REST API concepts

- **REST** = Representational State Transfer — a design style
- **Endpoint** = a specific URL like `/v1/archive`
- **Resource** = the thing returned (e.g., weather data)
- **HTTP methods** as semantic verbs: GET (read), POST (create), PUT (update), DELETE
- Open-Meteo is RESTful — read-only GET requests

### Other data formats you might encounter

- **JSON** — most common, what I used
- **XML** — older, more verbose (used by SOAP APIs)
- **CSV** — tabular text, what IMGW uses
- **YAML** — config files
- **HTML** — what we scrape

---

## 14. Anti-Scraping & How to Be Polite

### How sites detect scrapers

1. **User-Agent** — default `python-requests/x.x.x` is suspicious
2. **Request frequency** — humans don't fire 100 requests/second
3. **Request patterns** — going through every page systematically is bot-like
4. **Missing headers** — browsers send 20+ headers, requests sends 4
5. **JavaScript checks** — page has hidden JS that bots fail
6. **CAPTCHAs** — outright challenge
7. **IP-based rate limiting** — too many from one IP

### How to be polite (and avoid being blocked)

1. ✓ **Respect robots.txt** (I set `ROBOTSTXT_OBEY = True`)
2. ✓ **Set a custom User-Agent** with contact info
3. ✓ **Rate limit** (I use 1 second delay)
4. ✓ **Sequential not parallel** (I set `CONCURRENT_REQUESTS = 1`)
5. ✓ **Use APIs when available** (I use Open-Meteo's API)
6. ✓ **Cache during development** so you don't re-hit servers
7. ✓ **Don't scrape during peak hours** when possible
8. ✓ **Handle errors gracefully** (don't retry aggressively)

### Anti-scraping countermeasures (only mention if asked)

These exist, but I didn't need them because all my sources allow scraping:

- **Rotating User-Agents** — different UA per request
- **Proxy rotation** — different IPs per request
- **Browser fingerprinting evasion** — use Playwright stealth plugins
- **Solving CAPTCHAs** — use 2captcha service (questionable ethics)

**Important:** Just because you *can* bypass anti-scraping doesn't mean you *should*. Always check legality and terms of service.

### robots.txt format

```
User-agent: *               # applies to all bots
Disallow: /private/          # don't crawl /private/
Disallow: /admin/
Allow: /public/              # but /public/ is OK
Crawl-delay: 10              # wait 10s between requests

User-agent: Googlebot         # specific rule for Google
Disallow: /not-for-google/

Sitemap: https://example.com/sitemap.xml
```

For my sources:
- IMGW: no Disallow on `/data/` → I can scrape it
- Meteostat: `Allow: /` → all pages allowed
- Open-Meteo: API, robots.txt doesn't apply

---

## 15. Encoding, Character Sets, and Polish Diacritics

### Why encoding matters

Computers store text as bytes. The encoding tells you which bytes represent which characters.

- **ASCII** — 128 characters (A-Z, 0-9, basic punctuation). English only.
- **Latin-1 / ISO-8859-1** — 256 characters. Western European.
- **CP1250 (Windows-1250)** — Microsoft's Central European encoding. Used by IMGW! Has Polish characters (ą, ć, ę, ł, ń, ó, ś, ź, ż).
- **UTF-8** — Variable-length, supports ALL Unicode characters. Modern web standard.

### Why IMGW uses cp1250

IMGW publishes Excel-friendly CSVs intended for Polish Windows users. CP1250 is the Windows default for Polish locale.

### How I handle it

```python
content = f.read().decode("cp1250", errors="replace")
```

- `decode("cp1250")` — interpret bytes as CP1250
- `errors="replace"` — invalid bytes become `?` instead of raising UnicodeDecodeError

### What if I'd used UTF-8?

```python
content = f.read().decode("utf-8")
# UnicodeDecodeError on Polish character 'Ę' (byte 0xCA in cp1250)
```

### How to detect encoding

```python
import chardet  # third-party
result = chardet.detect(raw_bytes)
# {'encoding': 'cp1250', 'confidence': 0.99}
```

Or check the HTTP headers:
```
Content-Type: text/html; charset=UTF-8
```

Or HTML meta tag:
```html
<meta charset="UTF-8">
```

### Polish characters cheat sheet

| Character | UTF-8 bytes | CP1250 byte |
|---|---|---|
| ą | 0xC4 0x85 | 0xB9 |
| ę | 0xC4 0x99 | 0xEA |
| ł | 0xC5 0x82 | 0xB3 |
| ź | 0xC5 0xBA | 0x9F |
| ż | 0xC5 0xBC | 0xBF |

---

## 16. Performance, Async, and Concurrency

### Synchronous vs Asynchronous

**Synchronous (requests):**
```python
r1 = requests.get(url1)  # wait for response...
r2 = requests.get(url2)  # then start this one
r3 = requests.get(url3)
# Total time = t1 + t2 + t3
```

**Asynchronous (Scrapy):**
```python
# All three requests fired at once
# Total time = max(t1, t2, t3)
```

### Why Scrapy is fast

- Async I/O — many concurrent requests
- Connection pooling — TCP connections reused
- Intelligent scheduling

### When async is worth it

- Many requests (hundreds+)
- High-latency servers
- Independent requests (don't depend on each other's results)

### When NOT async

- Few requests (under ~10)
- Need strict ordering
- Already CPU-bound

### Concurrency vs Parallelism

- **Concurrency** — Multiple tasks in flight, switching between them. One CPU core. (Async I/O)
- **Parallelism** — Multiple tasks executing simultaneously. Multiple CPU cores. (multiprocessing)

Scraping is I/O-bound (waiting on network), so concurrency helps more than parallelism.

### Python's async ecosystem

- **`asyncio`** — built-in async framework (event loop)
- **`aiohttp`** — async HTTP library (alternative to requests)
- **`Twisted`** — older async framework (what Scrapy uses)
- **`httpx`** — modern async-capable HTTP library

For this project, Scrapy's Twisted-based async is enough. I didn't need to manually write async code.

---

## 17. Common Errors & Debugging

### `requests.exceptions.ConnectionError`

Network is unreachable, or server is down. Check internet connection. Try again later.

### `requests.exceptions.Timeout`

Server too slow or hung. Increase timeout, or accept that this source is unreliable.

### `requests.exceptions.HTTPError` (4xx/5xx)

Check `response.status_code`:
- 403 → User-Agent rejected? Need cookies?
- 404 → wrong URL
- 429 → too fast, slow down
- 500 → server problem, not yours

### `KeyError` on `tag["href"]`

The attribute doesn't exist. Use `tag.get("href")` instead, which returns None.

### `AttributeError: 'NoneType' object has no attribute 'find'`

`soup.find(...)` returned None (no match). Always check before chaining:
```python
h1 = soup.find("h1")
if h1:
    name = h1.get_text(strip=True)
```

### `UnicodeDecodeError`

Wrong encoding. Try `errors="replace"` or detect the right encoding.

### `selenium.common.exceptions.NoSuchElementException`

Element wasn't found. Either:
- The CSS selector / XPath is wrong
- The page hasn't loaded yet (need to wait longer)
- The page structure changed

### `selenium.common.exceptions.WebDriverException`

ChromeDriver couldn't start. Either:
- Chrome not installed
- ChromeDriver version mismatch
- Missing dependencies (no sandbox, /dev/shm, etc.)

### `ReactorNotRestartable`

Trying to run Scrapy twice in the same Jupyter kernel. The fix: subprocess.

### `ValueError: invalid literal for int() with base 10`

Trying to convert a non-numeric string to int. In my project, this was the `'"2025"'` quoted-field bug.

### Debugging tips

1. **Print everything** during development
2. **Save responses to disk** so you don't re-hit servers
3. **Use a small test case** before running the full pipeline
4. **Check the URL in your browser** to confirm it works manually
5. **Compare DevTools to view-source** to detect JS rendering
6. **Use `import pdb; pdb.set_trace()`** to drop into the debugger

---

## 18. Common Trick Questions

These are the slightly sneaky questions professors might use to test deeper understanding.

### "Could you have done this entire project with just `requests`?"

**Answer:** No — Meteostat requires JavaScript rendering, which `requests` can't do. I could have *tried* to find Meteostat's underlying API by inspecting Network calls in DevTools, but that's reverse-engineering a private API rather than scraping the public page they offer. Selenium was the correct choice for the public-facing page.

### "Why didn't you just use the Meteostat Python library? Wouldn't that be easier?"

**Answer:** Yes, much easier — but the course requires demonstrating web scraping tools. Calling a Python library that fetches data behind the scenes isn't scraping. The point was to show I understand the underlying techniques.

### "What's the difference between `r.text` and `r.content`?"

**Answer:** `r.content` is the raw bytes. `r.text` is the decoded string — requests auto-detects encoding based on headers or content. For binary files (ZIPs), use `r.content`. For text, use `r.text`.

### "Why did you set `errors='replace'` when decoding? Could you lose data?"

**Answer:** Yes, technically. If the CSV had a byte sequence that wasn't valid CP1250, that character becomes `?`. But IMGW's data is all in CP1250 — there's no encoding mismatch expected. The `errors='replace'` is defensive: if a single byte is somehow corrupted, the whole parser doesn't crash. It's a trade-off: robustness vs strict correctness.

### "What's a memory leak? Could your Selenium code cause one?"

**Answer:** A memory leak is when a program allocates memory and forgets to free it, eventually exhausting available RAM. Yes — if I didn't call `driver.quit()`, the Chrome process would keep running. In a loop scraping many pages without quitting, RAM would fill up. My code calls `quit()` in both success and exception paths.

### "Why parse HTML instead of just regex-matching tags?"

**Answer:** HTML is irregular — tags can be nested, self-closing, have multiple attributes in any order, contain comments. Regex can't represent nested structures (it's not a context-free grammar). A regex like `<a href="(.*)">` might work on toy examples but breaks on real-world HTML. BeautifulSoup parses the actual tree structure.

### "What's the difference between class and ID in CSS?"

**Answer:** Class is reusable — many elements can have the same class (`<div class="quote">`). ID should be unique per page (`<div id="main">`). CSS selectors: `.classname` for class, `#idname` for ID. In Python you use `class_="..."` (with trailing underscore) because `class` is a Python keyword.

### "If a website is blocked by robots.txt, can you still scrape it?"

**Answer:** Technically yes — robots.txt is a convention, not enforcement. But legally and ethically, no. Many jurisdictions recognize robots.txt violations as a form of unauthorized access. My project respects robots.txt on every source.

### "What's the difference between scraping and an API?"

**Answer:** Scraping is extracting data from HTML pages designed for humans. An API is a structured endpoint designed for programs. Open-Meteo gave me an API → easier, more reliable. Meteostat doesn't expose its data via a free public API → I had to scrape the HTML page.

### "How do you know Scrapy is actually respecting your delay?"

**Answer:** Two ways. First, Scrapy logs request timing — total time = ~63 ZIPs × 1 second = ~63s, plus parsing/network time = my actual ~80s. Second, the `DOWNLOAD_DELAY` setting is enforced by the engine itself — every request waits before being sent. I could verify by watching Wireshark, but the timing is consistent with the setting.

### "What if IMGW changed their URL structure tomorrow?"

**Answer:** My spider would break — it assumes specific directory paths. This is the fragility of scraping vs APIs. To mitigate: I check status codes, log errors, and could add more flexible selectors. But fundamentally, scraping always carries this risk. APIs have versioned contracts (e.g., `/v1/archive`) for stability.

### "Why did you choose this random offset for coordinates?"

**Answer:** Privacy. Falenty Nowe is a small village; publishing exact coordinates would essentially publish my home address. 300m is small enough that weather data is identical (weather varies on kilometer scales) but doesn't pinpoint a property. It's a deliberate choice — the project demonstrates I understand both the technical task AND its real-world implications.

### "What's a session cookie? Did you need them?"

**Answer:** A session cookie is data the server sends to the browser to track state across requests (e.g., login session). Stored client-side, sent back with every request. I didn't need them — none of my sources require login. If I did, I'd use `requests.Session()` which handles cookies automatically.

### "What's CORS? Does it affect your scraping?"

**Answer:** CORS = Cross-Origin Resource Sharing. It's a browser-only security mechanism that restricts JavaScript from one origin from accessing data on another. It doesn't affect server-to-server requests like mine — CORS only fires in browsers. So `requests.get()` and Scrapy ignore CORS entirely.

### "Why use Python for web scraping at all?"

**Answer:** Python has the best ecosystem: requests, BeautifulSoup, Scrapy, Selenium, pandas, lxml — all mature, well-documented, with huge communities. JavaScript (Node + Puppeteer/Cheerio) is also strong. Go has fewer scraping libraries but better concurrency. R is fine for one-off scrapes. Python wins on ecosystem breadth for this domain.

---

## Final Tips for the Defense

### When they show you a piece of YOUR code

1. **Take a breath.** Don't panic.
2. **Read what's actually there** — don't assume from memory.
3. **State what the code is doing**, not just naming the methods.
4. **Explain WHY** that approach was chosen.
5. **Mention alternatives** you considered but didn't use.

### Example walk-through:

> They point at: `df["water_balance_mm"] = df[precip_col].fillna(0) - df[et0_col].fillna(0)`
>
> You say:
> "This calculates the daily water balance — precipitation minus evapotranspiration. I'm using fillna(0) on both columns because if either value is missing (NaN), the arithmetic would propagate NaN and corrupt the cumulative sum downstream. Treating missing data as zero is a defensive choice — a missing day's rainfall record shouldn't break my entire time series. The result is in millimeters per day, positive meaning the soil gained water that day."

### If you don't know something

> "I'm honestly not sure about that specific detail. My understanding is roughly [your best guess], but I'd need to verify. If I needed to know definitively, I'd check [where you'd look it up]."

This is *infinitely* better than making something up. Professors respect honesty + ability to find answers.

### Confidence cues

- Speak slowly
- Use specific terminology
- Reference specific lines/sections
- Connect concepts ("this is similar to what we did in section X")
- Smile

---

**Good luck Ondřej. You built this. You understand it. Show them.**
