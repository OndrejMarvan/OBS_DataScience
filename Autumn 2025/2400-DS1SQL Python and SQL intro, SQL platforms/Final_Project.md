This is a fantastic pivot. Switching to **EU ETS (European Union Emissions Trading System)** and **Natural Gas** moves this from a "generic stock app" to a specialized **Commodities Analytics Tool**. This is exactly the kind of project that gets high marks because it shows domain knowledge (Energy Markets) alongside technical skills.

I assume by "backwardationtesting" you meant **Backtesting** (testing a strategy on past data), though "Backwardation" (when current prices are higher than future prices) is actually a very important signal in commodity markets!

Here is the blueprint for the **"EUA & Gas Energy Arbitrage Dashboard."**

### 1. The Data Sources (The Raw Material)

Since this is a specific market, you need the correct tickers. If you use `yfinance` (free), use these:

- **EUA (Carbon):** `ECF=F` (ICE EUA Futures) or `KRBN` (ETF proxy if futures data is messy).
    
- **Natural Gas (EU benchmark):** `TTF=F` (Dutch TTF Gas - this is the EU standard, more relevant than US gas) or `NG=F` (US Henry Hub).
    

### 2. The SQL Schema (Satisfying the SQL Requirement)

You need to store the OHLC (Open, High, Low, Close) data. Since you are comparing two assets, a "Relational" approach is best.

**Your Tables:**

1. **`assets`**: Stores the names (e.g., ID 1 = "EUA", ID 2 = "TTF Gas").
    
2. **`market_data`**: Stores the daily prices.
    

SQL

```
-- Table 1: Asset Metadata
CREATE TABLE assets (
    id INTEGER PRIMARY KEY,
    ticker TEXT NOT NULL,
    asset_name TEXT,
    currency TEXT
);

-- Table 2: Daily OHLC Data
CREATE TABLE market_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    asset_id INTEGER,
    date DATE,
    open_price REAL,
    high_price REAL,
    low_price REAL,
    close_price REAL,
    volume INTEGER,
    FOREIGN KEY(asset_id) REFERENCES assets(id)
);
```

### 3. The Python Logic (Data Wrangling & Backtest)

You will need to merge these two datasets to find correlations.

- **The Hypothesis:** High gas prices often lead to high carbon prices (because when gas is expensive, power plants switch to dirty coal, increasing demand for Carbon Allowances).
    
- **The Strategy (The "Backtest"):**
    
    - _Signal:_ If Gas Price rises by > 5% in a week, BUY EUA.
        
    - _Exit:_ Sell EUA after 14 days or if it drops 2%.
        

**Pandas Key Task:** You must use `pd.merge()` to align the dates of Gas and Carbon, as they might have different trading holidays.

### 4. Visualization (The "Fancy" Dashboard)

To get full points on visualization, you need to show you can handle different scales (since Gas prices and Carbon prices are different numbers).

- **Chart 1 (Dual Axis):** Carbon Price on Left Axis, Gas Price on Right Axis. (Shows correlation).
    
- **Chart 2 (Volatility):** A rolling standard deviation of the EUA price (Risk analysis).
    
- **Chart 3 (Heatmap):** Monthly returns of the strategy.
    

---

### Starter Code: SQL + Data Fetching

Here is a script that sets up your database and downloads the EUA data. Run this once to create your "Backend."

Python

```
import sqlite3
import yfinance as yf
import pandas as pd

# 1. Setup Database Connection
conn = sqlite3.connect('energy_markets.db')
cursor = conn.cursor()

# 2. Create SQL Tables (If they don't exist)
cursor.execute('''
CREATE TABLE IF NOT EXISTS market_data (
    date DATE,
    ticker TEXT,
    open REAL,
    high REAL,
    low REAL,
    close REAL,
    volume INTEGER
)
''')
conn.commit()

# 3. Download Data (EUA and Natural Gas)
tickers = ['ECF=F', 'TTF=F'] # EUA Futures and Dutch Gas
print("Downloading data...")

for ticker in tickers:
    # Download last 2 years of data
    df = yf.download(ticker, start="2023-01-01", end="2025-01-01")
    
    # Reset index so 'Date' is a column, not an index
    df = df.reset_index()
    
    # 4. Save to SQL (The "Magic" Step)
    # We loop through the dataframe and insert rows into SQL
    # (In a real job, we'd use df.to_sql, but doing it manually shows you understand loops)
    for index, row in df.iterrows():
        cursor.execute('''
            INSERT INTO market_data (date, ticker, open, high, low, close, volume)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (row['Date'].strftime('%Y-%m-%d'), ticker, 
              row['Open'], row['High'], row['Low'], row['Close'], row['Volume']))

conn.commit()
print("Data successfully saved to SQL database!")

# 5. Verification: Read back from SQL to prove it works
df_sql = pd.read_sql("SELECT * FROM market_data WHERE ticker = 'ECF=F' LIMIT 5", conn)
print("\nPreview of data from SQL:")
print(df_sql)

conn.close()
```

### Next Step

This script covers **SQL Integration**, **Loops**, and **Data Import**.

Would you like the code for **Streamlit (Part 2)** that reads this database and plots the "Gas vs Carbon" correlation chart?