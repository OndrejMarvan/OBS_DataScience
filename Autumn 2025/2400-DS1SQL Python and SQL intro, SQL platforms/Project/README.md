# Multi-Strategy Trading Dashboard

**Author**: Ondřej Marvan
**Course**: Python and SQL: Intro / SQL Platforms
**Instructor**: Ewa Weychert
**University**: University of Warsaw
**Due Date**: January 7, 2026

---

## Project Overview

An interactive trading dashboard that analyzes **8 financial instruments** across **3 automated trading strategies** using Python, SQL, and Streamlit. The system backtests RSI, Moving Average Crossover, and Bollinger Bands strategies on 2025 daily data to identify the most profitable approach for each asset class.

### Research Question
*"Which trading strategy (RSI, Moving Average Crossover, or Bollinger Bands) performs best across different asset classes (commodities, cryptocurrencies, and equity indices)?"*

---

## Instruments Analyzed

| Symbol | Name | Currency | Type | File |
|--------|------|----------|------|------|
| **EUA** | EU Allowance | EUR | Environmental | `EUA_daily.csv` |
| **OIL** | Crude Oil WTI | USD | Energy | `OIL_daily.csv` |
| **NG** | Natural Gas | USD | Energy | `NG_daily.csv` |
| **GOLD** | Gold | USD | Precious Metal | `GOLD_daily.csv` |
| **SILVER** | Silver | USD | Precious Metal | `SILVER_daily.csv` |
| **BTC** | Bitcoin | USD | Cryptocurrency | `BTC_daily.csv` |
| **SPX** | S&P 500 | USD | Equity Index | `S&P500_daily.csv` |
| **NDX** | NASDAQ 100 | USD | Equity Index | `NASDAQ100_daily.csv` |

**Data Period**: January 1, 2025 - December 31, 2025 (Daily OHLC + Volume)

---

## ⚙️ Features

### Analysis (Jupyter Notebook)
- ✅ Load and clean 8 CSV files with robust error handling
- ✅ Calculate technical indicators (SMA 20/50/200, Bollinger Bands, RSI)
- ✅ Backtest 3 trading strategies automatically
- ✅ Generate 12 publication-quality visualizations
- ✅ Create SQLite database with 7 tables

### Dashboard (Streamlit)
- **Login System** with user authentication
- **Market Overview** - Real-time prices, normalized performance
- **Technical Analysis** - Interactive charts with indicators
- **Strategy Backtest** - Test 3 strategies with adjustable parameters
  - RSI Strategy (adjustable thresholds)
  - MA Crossover (customizable periods)
  - Bollinger Bands (mean reversion)
  - Compare All (head-to-head performance)
- **Trading Platform** - Place market & historical orders
  - Stop-loss and take-profit orders
  - Historical backtesting by date
- **Order History** - Visualize orders on price charts
- **Statistics** - Risk-return analysis

---

## Trading Strategies

### 1. RSI Strategy (Momentum-Based)
```
BUY:  When RSI < 30 (oversold)
SELL: When RSI > 70 (overbought)
```
**Logic**: Contrarian approach - buy when price momentum is extremely negative

### 2. Moving Average Crossover (Trend-Following)
```
BUY:  When Fast MA crosses above Slow MA (Golden Cross)
SELL: When Fast MA crosses below Slow MA (Death Cross)
```
**Logic**: Follow the trend - momentum shift indicates new direction

### 3. Bollinger Bands (Mean Reversion)
```
BUY:  When price touches or falls below Lower Band
SELL: When price touches or rises above Upper Band
```
**Logic**: Mean reversion - price returns to average after extremes

---

## Installation & Setup

### Prerequisites
- Python 3.8
- pip package manager

### Install Dependencies
```bash
pip install pandas numpy matplotlib seaborn plotly streamlit jupyter
```

### Project Structure
```
project/
│
├── data/                           # CSV files (8 instruments)
│   ├── EUA_daily.csv
│   ├── OIL_daily.csv
│   ├── NG_daily.csv
│   ├── GOLD_daily.csv
│   ├── SILVER_daily.csv
│   ├── BTC_daily.csv
│   ├── S&P500_daily.csv
│   └── NASDAQ100_daily.csv
│
├── commodities_analysis.ipynb      # Analysis notebook
├── streamlit_app.py                # Dashboard application
├── requirements.txt                # Dependencies
├── README.md                       # This file
│
├── commodities_trading.db          # SQLite database (auto-generated)
│
└── outputs/                        # Visualizations (auto-generated)
    ├── price_trends.png
    ├── bollinger_bands.png
    ├── rsi_analysis.png
    ├── strategy_comparison.png
    └── ... (8 more charts)
```

---

## How to Run

### Step 1: Prepare Your Data
Ensure all 8 CSV files are in the `data/` folder with columns:
- `Date`, `Price`, `Open`, `High`, `Low`, `Vol.`, `Change %`

### Step 2: Run Analysis (Jupyter Notebook)
```bash
jupyter notebook commodities_analysis.ipynb
```

Execute all cells to:
1. Load and clean all CSV files
2. Calculate technical indicators
3. Backtest all 3 strategies
4. Generate 12 visualizations
5. Create SQLite database

**Expected Output**:
```
✓ Loaded 365 valid records for EUA
✓ Loaded 365 valid records for OIL
...
✓ All data saved to 'commodities_trading.db'
✓ Total visualizations saved: 12 PNG files

STRATEGY BACKTEST RESULTS:
Strategy         Total P&L
RSI (30/70)      +15.3%
MA Cross (20/50) +22.7%
Bollinger Bands  +18.1%
```

### Step 3: Launch Dashboard (Streamlit)
```bash
streamlit run streamlit_app.py
```

Dashboard opens at: `http://localhost:8501`

### Step 4: Login
**Demo Credentials**:
- Username: `admin` | Password: `admin123`
- Username: `trader1` | Password: `trader123`
- Or click "Demo Login"

---

## Database Schema

### Tables Created:

1. **prices** - OHLC data with technical indicators
   - Columns: Date, Symbol, Open, High, Low, Price, Vol, SMA_20, SMA_50, SMA_200, BB_Upper, BB_Middle, BB_Lower, RSI, Daily_Return

2. **instruments** - Metadata
   - Columns: Symbol, Name, Currency, Type

3. **statistics** - Aggregated metrics
   - Columns: Symbol, Avg_Price, Price_Std, Min_Price, Max_Price, Total_Volume, Avg_Return, Return_Volatility

4. **backtest_results** - Strategy performance
   - Columns: Symbol, Strategy, Total_Trades, Win_Rate, Total_PnL_pct, Avg_PnL_pct

5. **backtest_trades** - All trades
   - Columns: Date, Type, Price, PnL, PnL_pct, Symbol, Strategy

6. **users** - Authentication
   - Columns: username, password, role

7. **orders** - User orders
   - Columns: order_id, timestamp, symbol, order_type, quantity, price, stop_loss, take_profit, notes

---

## Visualizations Generated

1. **Price Trends** - 8 instruments with SMA overlays (2×4 grid)
2. **Bollinger Bands** - Volatility bands for all instruments
3. **RSI Analysis** - Momentum indicators with zones
4. **Returns Distribution** - Histogram analysis
5. **Correlation Matrix** - 8×8 heatmap
6. **Strategy Comparison** - All 3 strategies on price charts
7. **Volume Analysis** - Trading volume patterns
8. **Cumulative Returns** - Performance comparison
9. **Risk-Return Profile** - Scatter plot
10. **Normalized Performance** - Index comparison
11. **Strategy PnL** - Cumulative P&L by strategy
12. **Strategy Metrics** - Performance comparison bars

All saved as high-resolution PNG files (300 DPI).

---

## Usage Examples

### Backtesting a Strategy
```python
# In Jupyter Notebook (already implemented)
from analysis import backtest_rsi_strategy

# Load data for Bitcoin
btc_data = all_data[all_data['Symbol'] == 'BTC']

# Run RSI backtest
results, trades = backtest_rsi_strategy(btc_data, buy_threshold=30, sell_threshold=70)

# View performance
print(f"Total Trades: {len(trades)}")
print(f"Win Rate: {calculate_strategy_metrics(results, trades)['Win_Rate']:.2f}%")
```

### Querying the Database
```python
import sqlite3
import pandas as pd

# Connect to database
conn = sqlite3.connect('commodities_trading.db')

# Get all RSI strategy trades
query = "SELECT * FROM backtest_trades WHERE Strategy = 'RSI' AND Symbol = 'BTC'"
trades = pd.read_sql_query(query, conn)

# Get best performing strategy
query = """
SELECT Strategy, SUM(Total_PnL_pct) as Total_PnL
FROM backtest_results
GROUP BY Strategy
ORDER BY Total_PnL DESC
"""
performance = pd.read_sql_query(query, conn)
```

---

## Project Requirements Checklist

### Data Handling & Wrangling (Pandas + NumPy)
- Import 8 CSV files
- Handle missing values, duplicates
- Data type conversions
- Exploratory analysis
- Aggregations and transformations

### Apply Logic & Functions
- 10+ custom functions
- If-statements for trading logic
- Loops for backtesting
- Error handling

### Visualization (5-10 plots required)
- 12 different chart types
- Matplotlib & Seaborn
- Clear, story-driven plots

### SQL Integration
- SQLite database
- 7 tables with relationships
- Joins, filtering, aggregations
- Store analysis results

### Presentation Layer
- Streamlit dashboard
- 7 interactive pages
- Filters and controls
- Data visualization

---

## Troubleshooting

### Database Error: "no such table"
**Solution**: Run the Jupyter notebook first to create the database.

### CSV Loading Error
**Problem**: Column names don't match 
**Solution**: The code auto-detects columns. Ensure CSV has: Date, Price, Open, High, Low, Vol.

### Streamlit Port in Use
**Solution**: Try a different port
```bash
streamlit run streamlit_app.py --server.port 8502
```

### No Trades Generated
**Problem**: Strategy parameters too strict 
**Solution**: Adjust thresholds in Strategy Backtest page

### Technical Indicators

**RSI (Relative Strength Index)**:
- Measures momentum on 0-100 scale
- < 30 = Oversold (potential buy)
- > 70 = Overbought (potential sell)

**Moving Averages**:
- Average price over N days
- Golden Cross = bullish signal
- Death Cross = bearish signal

**Bollinger Bands**:
- Price ± 2 standard deviations
- Wide bands = high volatility
- Price at bands = extreme levels

### Performance Metrics

- **Win Rate**: % of profitable trades
- **Avg P&L**: Average profit/loss per trade
- **Total P&L**: Sum of all trade returns
- **Max Gain/Loss**: Best/worst single trade

---

## Future Enhancements

- Machine learning price prediction
- Real-time data feeds
- Portfolio optimization
- Risk management (position sizing)
- Email alerts for signals
- Multi-timeframe analysis
- Export reports to PDF

---


