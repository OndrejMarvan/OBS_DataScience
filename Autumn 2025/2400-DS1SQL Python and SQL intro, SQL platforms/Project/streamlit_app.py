"""
Commodities Trading Dashboard - Streamlit Application
Author: Ondrej Marvan
Course: Python and SQL - Final Project

Analyzing 8 Instruments:
- EUA (European Union Allowance) - EUR
- OIL (Crude Oil WTI) - USD
- NG (Natural Gas) - USD
- GOLD (Gold) - USD
- SILVER (Silver) - USD
- BTC (Bitcoin) - USD
- SPX (S&P 500) - USD
- NDX (NASDAQ 100) - USD

Features:
- Login system
- Real-time price charts for all 8 instruments
- Technical indicators (SMA, Bollinger Bands, RSI)
- Backwardation/Contango analysis
- Order placement system
- Order history tracking
"""

import streamlit as st
import pandas as pd
import numpy as np
import sqlite3
import plotly.graph_objects as go
import plotly.express as px
from datetime import datetime, timedelta
import hashlib

# ============================================================================
# PAGE CONFIGURATION
# ============================================================================
st.set_page_config(
    page_title="Commodities Trading Dashboard",
    page_icon="📈",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ============================================================================
# CONSTANTS
# ============================================================================

# All 8 instruments in the system
ALL_SYMBOLS = ['EUA', 'OIL', 'NG', 'GOLD', 'SILVER', 'BTC', 'SPX', 'NDX']

# Instrument metadata
INSTRUMENT_INFO = {
    'EUA': {'name': 'EU Allowance', 'currency': 'EUR', 'type': 'Environmental'},
    'OIL': {'name': 'Crude Oil WTI', 'currency': 'USD', 'type': 'Energy'},
    'NG': {'name': 'Natural Gas', 'currency': 'USD', 'type': 'Energy'},
    'GOLD': {'name': 'Gold', 'currency': 'USD', 'type': 'Precious Metal'},
    'SILVER': {'name': 'Silver', 'currency': 'USD', 'type': 'Precious Metal'},
    'BTC': {'name': 'Bitcoin', 'currency': 'USD', 'type': 'Cryptocurrency'},
    'SPX': {'name': 'S&P 500', 'currency': 'USD', 'type': 'Equity Index'},
    'NDX': {'name': 'NASDAQ 100', 'currency': 'USD', 'type': 'Equity Index'}
}

# ============================================================================
# DATABASE FUNCTIONS
# ============================================================================

@st.cache_resource
def get_db_connection():
    """Create database connection"""
    return sqlite3.connect('commodities_trading.db', check_same_thread=False)

def load_data(symbol=None, days=365):
    """Load price data from database"""
    conn = get_db_connection()
    if symbol:
        query = f"SELECT * FROM prices WHERE Symbol = '{symbol}' ORDER BY Date DESC LIMIT {days}"
    else:
        query = f"SELECT * FROM prices ORDER BY Date DESC LIMIT {days * 4}"
    df = pd.read_sql_query(query, conn)
    df['Date'] = pd.to_datetime(df['Date'])
    return df.sort_values('Date')

def verify_login(username, password):
    """Verify user credentials"""
    conn = get_db_connection()
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    result = pd.read_sql_query(query, conn)
    return len(result) > 0

def place_order(username, symbol, order_type, quantity, price):
    """Place a new order in the database"""
    conn = get_db_connection()
    total_value = quantity * price
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO orders (username, symbol, order_type, quantity, price, total_value, status)
        VALUES (?, ?, ?, ?, ?, ?, 'Executed')
    ''', (username, symbol, order_type, quantity, price, total_value))
    conn.commit()
    return True

def get_user_orders(username):
    """Get all orders for a user"""
    conn = get_db_connection()
    query = f"SELECT * FROM orders WHERE username = '{username}' ORDER BY timestamp DESC"
    return pd.read_sql_query(query, conn)

def get_statistics():
    """Get summary statistics"""
    conn = get_db_connection()
    return pd.read_sql_query("SELECT * FROM statistics", conn)

# ============================================================================
# SESSION STATE INITIALIZATION
# ============================================================================
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False
if 'username' not in st.session_state:
    st.session_state.username = None
if 'selected_symbol' not in st.session_state:
    st.session_state.selected_symbol = 'EUA'

# ============================================================================
# LOGIN PAGE
# ============================================================================
def login_page():
    st.title("🔐 Commodities Trading Dashboard")
    st.markdown("### Please login to continue")
    
    col1, col2, col3 = st.columns([1, 2, 1])
    
    with col2:
        st.markdown("---")
        username = st.text_input("Username", placeholder="Enter your username")
        password = st.text_input("Password", type="password", placeholder="Enter your password")
        
        col_btn1, col_btn2 = st.columns(2)
        with col_btn1:
            if st.button("Login", use_container_width=True, type="primary"):
                if verify_login(username, password):
                    st.session_state.logged_in = True
                    st.session_state.username = username
                    st.success("Login successful!")
                    st.rerun()
                else:
                    st.error("Invalid username or password")
        
        with col_btn2:
            if st.button("Demo Login", use_container_width=True):
                st.session_state.logged_in = True
                st.session_state.username = "demo_user"
                st.rerun()
        
        st.markdown("---")
        st.info("**Demo Credentials:**\n\nUsername: `admin` | Password: `admin123`\n\nUsername: `trader1` | Password: `trader123`")

# ============================================================================
# MAIN DASHBOARD
# ============================================================================
def main_dashboard():
    # Sidebar
    with st.sidebar:
        st.title("📊 Navigation")
        st.markdown(f"**Welcome, {st.session_state.username}!**")
        st.markdown("---")
        
        page = st.radio(
            "Select Page:",
            ["📈 Market Overview", "📉 Technical Analysis", "🎯 Strategy Backtest", 
             "💼 Trading", "📋 Order History", "📊 Statistics"],
            label_visibility="collapsed"
        )
        
        st.markdown("---")
        
        # Symbol selector
        if st.session_state.selected_symbol not in ALL_SYMBOLS:
            st.session_state.selected_symbol = "EUA"
            
        st.session_state.selected_symbol = st.selectbox(
            "Select Instrument:",
            ALL_SYMBOLS,
            index=ALL_SYMBOLS.index(st.session_state.selected_symbol),
            format_func=lambda x: f"{x} - {INSTRUMENT_INFO[x]['name']} ({INSTRUMENT_INFO[x]['currency']})"
        )
        
        # Time period selector
        time_period = st.selectbox(
            "Time Period:",
            ["30 Days", "90 Days", "180 Days", "1 Year", "All Time"]
        )
        
        days_map = {"30 Days": 30, "90 Days": 90, "180 Days": 180, "1 Year": 365, "All Time": 10000}
        days = days_map[time_period]
        
        st.markdown("---")
        if st.button("🚪 Logout", use_container_width=True):
            st.session_state.logged_in = False
            st.session_state.username = None
            st.rerun()
    
    # Main content area
    if page == "📈 Market Overview":
        market_overview_page(days)
    elif page == "📉 Technical Analysis":
        technical_analysis_page(days)
    elif page == "🎯 Strategy Backtest":
        strategy_backtest_page(days)
    elif page == "💼 Trading":
        trading_page()
    elif page == "📋 Order History":
        order_history_page()
    elif page == "📊 Statistics":
        statistics_page()

# ============================================================================
# PAGE 1: MARKET OVERVIEW
# ============================================================================
def market_overview_page(days):
    st.title("📈 Market Overview")
    
    # Load data for all symbols
    df = load_data(days=days)
    
    # Display metrics for all instruments
    st.markdown("### Current Prices")
    
    # Display in two rows
    st.markdown("#### Energy & Environmental")
    cols = st.columns(4)
    symbols_row1 = ['EUA', 'OIL', 'NG', 'GOLD']
    
    for i, symbol in enumerate(symbols_row1):
        symbol_data = df[df['Symbol'] == symbol].tail(2)
        if len(symbol_data) >= 2:
            current_price = symbol_data.iloc[-1]['Price']
            prev_price = symbol_data.iloc[-2]['Price']
            change = ((current_price - prev_price) / prev_price) * 100
            
            with cols[i]:
                currency = INSTRUMENT_INFO[symbol]['currency']
                st.metric(
                    label=f"{symbol} ({currency})",
                    value=f"{current_price:.2f}",
                    delta=f"{change:.2f}%"
                )
    
    st.markdown("#### Precious Metals, Crypto & Indices")
    cols = st.columns(4)
    symbols_row2 = ['SILVER', 'BTC', 'SPX', 'NDX']
    
    for i, symbol in enumerate(symbols_row2):
        symbol_data = df[df['Symbol'] == symbol].tail(2)
        if len(symbol_data) >= 2:
            current_price = symbol_data.iloc[-1]['Price']
            prev_price = symbol_data.iloc[-2]['Price']
            change = ((current_price - prev_price) / prev_price) * 100
            
            with cols[i]:
                currency = INSTRUMENT_INFO[symbol]['currency']
                st.metric(
                    label=f"{symbol} ({currency})",
                    value=f"{current_price:.2f}",
                    delta=f"{change:.2f}%"
                )
    
    st.markdown("---")
    
    # Normalized price comparison
    st.markdown("### Price Performance (Normalized to 100)")
    fig = go.Figure()
    
    for symbol in ALL_SYMBOLS:
        symbol_data = df[df['Symbol'] == symbol].sort_values('Date')
        if len(symbol_data) > 0:
            normalized = (symbol_data['Price'] / symbol_data['Price'].iloc[0]) * 100
            currency = INSTRUMENT_INFO[symbol]['currency']
            fig.add_trace(go.Scatter(
                x=symbol_data['Date'],
                y=normalized,
                name=f"{symbol} ({currency})",
                mode='lines',
                line=dict(width=2)
            ))
    
    fig.update_layout(
        height=500,
        hovermode='x unified',
        xaxis_title="Date",
        yaxis_title="Normalized Price",
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
    )
    st.plotly_chart(fig, use_container_width=True)
    
    st.markdown("---")
    
    # Individual price charts - now 2x4 grid
    st.markdown("### Individual Price Charts")
    
    # First row
    col1, col2, col3, col4 = st.columns(4)
    cols_list = [col1, col2, col3, col4, col1, col2, col3, col4]
    
    for i, symbol in enumerate(ALL_SYMBOLS):
        symbol_data = df[df['Symbol'] == symbol].sort_values('Date')
        
        fig = go.Figure()
        currency = INSTRUMENT_INFO[symbol]['currency']
        fig.add_trace(go.Scatter(
            x=symbol_data['Date'],
            y=symbol_data['Price'],
            name=f"{symbol} ({currency})",
            fill='tozeroy',
            line=dict(color='rgb(0, 123, 255)', width=2)
        ))
        
        fig.update_layout(
            title=f"{symbol} - {INSTRUMENT_INFO[symbol]['name']} ({currency})",
            height=250,
            showlegend=False,
            margin=dict(l=0, r=0, t=30, b=0)
        )
        
        cols_list[i].plotly_chart(fig, use_container_width=True)

# ============================================================================
# PAGE 2: TECHNICAL ANALYSIS
# ============================================================================
def technical_analysis_page(days):
    st.title("📉 Technical Analysis")
    symbol = st.session_state.selected_symbol
    info = INSTRUMENT_INFO[symbol]
    st.markdown(f"### {symbol} - {info['name']} ({info['currency']}) Analysis")
    
    # Load data
    df = load_data(st.session_state.selected_symbol, days)
    
    if len(df) == 0:
        st.warning(f"No data available for {symbol} in the selected period")
        return
    
    # Latest metrics
    latest = df.iloc[-1]
    currency = info['currency']
    col1, col2, col3, col4 = st.columns(4)
    
    col1.metric(f"Current Price ({currency})", f"{latest['Price']:.2f}")
    col2.metric("RSI", f"{latest['RSI']:.2f}")
    col3.metric("Volume", f"{latest['Vol']:,.0f}")
    col4.metric("Daily Return", f"{latest['Daily_Return']:.2f}%")
    
    st.markdown("---")
    
    # Moving Averages Chart
    st.markdown("### Price with Moving Averages")
    fig = go.Figure()
    
    fig.add_trace(go.Scatter(x=df['Date'], y=df['Price'], name='Price', 
                             line=dict(color='black', width=2)))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['SMA_20'], name='SMA 20', 
                             line=dict(color='blue', width=1)))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['SMA_50'], name='SMA 50', 
                             line=dict(color='orange', width=1)))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['SMA_200'], name='SMA 200', 
                             line=dict(color='red', width=1)))
    
    fig.update_layout(height=400, hovermode='x unified', xaxis_title="Date", yaxis_title="Price")
    st.plotly_chart(fig, use_container_width=True)
    
    # Bollinger Bands Chart
    st.markdown("### Bollinger Bands")
    fig = go.Figure()
    
    fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Upper'], name='Upper Band',
                             line=dict(color='gray', dash='dash')))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Middle'], name='Middle Band',
                             line=dict(color='blue')))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Lower'], name='Lower Band',
                             line=dict(color='gray', dash='dash'),
                             fill='tonexty', fillcolor='rgba(173, 216, 230, 0.2)'))
    fig.add_trace(go.Scatter(x=df['Date'], y=df['Price'], name='Price',
                             line=dict(color='black', width=2)))
    
    fig.update_layout(height=400, hovermode='x unified', xaxis_title="Date", yaxis_title="Price")
    st.plotly_chart(fig, use_container_width=True)
    
    # RSI Chart
    st.markdown("### Relative Strength Index (RSI)")
    fig = go.Figure()
    
    fig.add_trace(go.Scatter(x=df['Date'], y=df['RSI'], name='RSI',
                             line=dict(color='purple', width=2)))
    fig.add_hline(y=70, line_dash="dash", line_color="red", annotation_text="Overbought (70)")
    fig.add_hline(y=30, line_dash="dash", line_color="green", annotation_text="Oversold (30)")
    fig.add_hrect(y0=30, y1=70, fillcolor="gray", opacity=0.1, line_width=0)
    
    fig.update_layout(height=300, hovermode='x unified', xaxis_title="Date", yaxis_title="RSI")
    st.plotly_chart(fig, use_container_width=True)
    
    # Volume Chart
    st.markdown("### Trading Volume")
    fig = go.Figure()
    
    colors = ['red' if row['Daily_Return'] < 0 else 'green' for _, row in df.iterrows()]
    fig.add_trace(go.Bar(x=df['Date'], y=df['Vol'], name='Volume',
                         marker_color=colors))
    
    fig.update_layout(height=300, xaxis_title="Date", yaxis_title="Volume")
    st.plotly_chart(fig, use_container_width=True)

# ============================================================================
# PAGE 3: STRATEGY BACKTEST
# ============================================================================
def strategy_backtest_page(days):
    st.title("🎯 Trading Strategy Backtest")
    symbol = st.session_state.selected_symbol
    info = INSTRUMENT_INFO[symbol]
    st.markdown(f"### {symbol} - {info['name']} Strategy Testing")
    
    # Load data
    df = load_data(st.session_state.selected_symbol, days)
    
    if len(df) == 0:
        st.warning("No data available for selected period")
        return
    
    # Strategy parameters
    col1, col2, col3 = st.columns(3)
    
    with col1:
        buy_threshold = st.slider("RSI Buy Threshold", 10, 50, 30, 
                                  help="Buy when RSI falls below this value")
    with col2:
        sell_threshold = st.slider("RSI Sell Threshold", 50, 90, 70,
                                   help="Sell when RSI rises above this value")
    with col3:
        st.markdown("### Strategy")
        st.info(f"**BUY:** RSI < {buy_threshold}  \n**SELL:** RSI > {sell_threshold}")
    
    # Run backtest
    backtest_data, trades_data = run_backtest(df, buy_threshold, sell_threshold)
    
    if len(trades_data) == 0:
        st.warning("No trades generated with current parameters. Try adjusting thresholds.")
        return
    
    # Calculate metrics
    sell_trades = trades_data[trades_data['Type'] == 'SELL']
    
    if len(sell_trades) > 0:
        total_trades = len(sell_trades)
        winning_trades = len(sell_trades[sell_trades['PnL'] > 0])
        win_rate = (winning_trades / total_trades * 100)
        avg_pnl = sell_trades['PnL_pct'].mean()
        total_pnl = sell_trades['PnL_pct'].sum()
        max_gain = sell_trades['PnL_pct'].max()
        max_loss = sell_trades['PnL_pct'].min()
        
        # Display metrics
        st.markdown("### Strategy Performance")
        col1, col2, col3, col4, col5 = st.columns(5)
        
        col1.metric("Total Trades", total_trades)
        col2.metric("Win Rate", f"{win_rate:.1f}%")
        col3.metric("Avg P&L/Trade", f"{avg_pnl:.2f}%")
        col4.metric("Total P&L", f"{total_pnl:.2f}%", 
                   delta=f"{total_pnl:.2f}%")
        col5.metric("Max Gain", f"{max_gain:.2f}%")
        
        st.markdown("---")
        
        # Price chart with signals
        st.markdown("### Price Chart with Buy/Sell Signals")
        fig = go.Figure()
        
        # Price line
        fig.add_trace(go.Scatter(
            x=backtest_data['Date'],
            y=backtest_data['Price'],
            name='Price',
            line=dict(color='black', width=1.5)
        ))
        
        # Buy signals
        buy_signals = backtest_data[backtest_data['Trade_Signal'] == 'BUY']
        if len(buy_signals) > 0:
            fig.add_trace(go.Scatter(
                x=buy_signals['Date'],
                y=buy_signals['Trade_Price'],
                mode='markers',
                name='Buy Signal',
                marker=dict(symbol='triangle-up', size=12, color='green'),
                text=[f"Buy @ {p:.2f}" for p in buy_signals['Trade_Price']],
                hovertemplate='<b>BUY</b><br>Date: %{x}<br>Price: %{y:.2f}<extra></extra>'
            ))
        
        # Sell signals
        sell_signals = backtest_data[backtest_data['Trade_Signal'] == 'SELL']
        if len(sell_signals) > 0:
            fig.add_trace(go.Scatter(
                x=sell_signals['Date'],
                y=sell_signals['Trade_Price'],
                mode='markers',
                name='Sell Signal',
                marker=dict(symbol='triangle-down', size=12, color='red'),
                text=[f"Sell @ {p:.2f}<br>P&L: {pnl:.2f}%" 
                     for p, pnl in zip(sell_signals['Trade_Price'], sell_signals['Trade_PnL'])],
                hovertemplate='<b>SELL</b><br>Date: %{x}<br>Price: %{y:.2f}<br>%{text}<extra></extra>'
            ))
        
        fig.update_layout(
            height=500,
            hovermode='x unified',
            xaxis_title="Date",
            yaxis_title=f"Price ({info['currency']})",
            legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
        )
        st.plotly_chart(fig, use_container_width=True)
        
        # Cumulative P&L chart
        st.markdown("### Cumulative Profit & Loss")
        fig = go.Figure()
        
        fig.add_trace(go.Scatter(
            x=backtest_data['Date'],
            y=backtest_data['Cumulative_PnL'],
            fill='tozeroy',
            line=dict(color='blue', width=2),
            fillcolor='rgba(0, 123, 255, 0.2)'
        ))
        
        fig.add_hline(y=0, line_dash="dash", line_color="black", line_width=1)
        
        fig.update_layout(
            height=350,
            xaxis_title="Date",
            yaxis_title="Cumulative P&L (%)",
            hovermode='x unified'
        )
        st.plotly_chart(fig, use_container_width=True)
        
        # Trade history table
        st.markdown("### Trade History")
        
        # Format trades for display
        display_trades = trades_data.copy()
        display_trades['Date'] = pd.to_datetime(display_trades['Date']).dt.strftime('%Y-%m-%d')
        display_trades['Price'] = display_trades['Price'].round(2)
        display_trades['RSI'] = display_trades['RSI'].round(1)
        
        if 'PnL_pct' in display_trades.columns:
            display_trades['PnL_pct'] = display_trades['PnL_pct'].round(2)
            display_trades = display_trades[['Date', 'Type', 'Price', 'RSI', 'PnL_pct']]
            display_trades.columns = ['Date', 'Type', 'Price', 'RSI', 'P&L (%)']
        else:
            display_trades = display_trades[['Date', 'Type', 'Price', 'RSI']]
        
        st.dataframe(display_trades, use_container_width=True, hide_index=True)

# ============================================================================
# PAGE 3: STRATEGY BACKTEST
# ============================================================================
def strategy_backtest_page(days):
    st.title("🎯 Trading Strategy Backtest")
    symbol = st.session_state.selected_symbol
    info = INSTRUMENT_INFO[symbol]
    st.markdown(f"### {symbol} - {info['name']} Strategy Testing")
    
    # Load data
    df = load_data(st.session_state.selected_symbol, days)
    
    if len(df) == 0:
        st.warning("No data available for selected period")
        return
    
    # Strategy selection tabs
    tab1, tab2, tab3, tab4 = st.tabs(["📊 RSI Strategy", "📈 MA Crossover", "📉 Bollinger Bands", "🏆 Compare All"])
    
    # TAB 1: RSI Strategy
    with tab1:
        st.markdown("### RSI-Based Strategy")
        
        col1, col2, col3 = st.columns(3)
        
        with col1:
            buy_threshold = st.slider("RSI Buy Threshold", 10, 50, 30, key="rsi_buy",
                                      help="Buy when RSI falls below this value")
        with col2:
            sell_threshold = st.slider("RSI Sell Threshold", 50, 90, 70, key="rsi_sell",
                                       help="Sell when RSI rises above this value")
        with col3:
            st.markdown("### Strategy")
            st.info(f"**BUY:** RSI < {buy_threshold}  \n**SELL:** RSI > {sell_threshold}")
        
        backtest_data, trades_data = run_rsi_backtest(df, buy_threshold, sell_threshold)
        display_strategy_results(backtest_data, trades_data, info, "RSI", 
                                f"Buy<{buy_threshold}, Sell>{sell_threshold}")
    
    # TAB 2: MA Crossover
    with tab2:
        st.markdown("### Moving Average Crossover Strategy")
        
        col1, col2, col3 = st.columns(3)
        
        with col1:
            fast_ma = st.selectbox("Fast MA Period", [10, 20, 50], index=1, key="fast_ma")
        with col2:
            slow_ma = st.selectbox("Slow MA Period", [50, 100, 200], index=0, key="slow_ma")
        with col3:
            st.markdown("### Strategy")
            st.info(f"**BUY:** {fast_ma}-MA crosses above {slow_ma}-MA (Golden Cross)  \n"
                   f"**SELL:** {fast_ma}-MA crosses below {slow_ma}-MA (Death Cross)")
        
        backtest_data, trades_data = run_ma_crossover_backtest(df, fast_ma, slow_ma)
        display_strategy_results(backtest_data, trades_data, info, "MA Crossover",
                                f"{fast_ma}/{slow_ma} Crossover")
    
    # TAB 3: Bollinger Bands
    with tab3:
        st.markdown("### Bollinger Bands Mean Reversion Strategy")
        
        col1, col2 = st.columns(2)
        
        with col1:
            st.markdown("### Strategy Rules")
            st.info("**BUY:** Price touches or falls below Lower Band  \n"
                   "**SELL:** Price touches or rises above Upper Band")
        with col2:
            st.markdown("### Parameters")
            st.write("**Period:** 20 days")
            st.write("**Std Dev:** 2")
            st.write("Mean reversion - buy oversold, sell overbought")
        
        backtest_data, trades_data = run_bollinger_backtest(df)
        display_strategy_results(backtest_data, trades_data, info, "Bollinger Bands",
                                "Touch Bands Strategy")
    
    # TAB 4: Compare All
    with tab4:
        st.markdown("### Strategy Comparison")
        
        # Run all three strategies
        rsi_data, rsi_trades = run_rsi_backtest(df, 30, 70)
        ma_data, ma_trades = run_ma_crossover_backtest(df, 20, 50)
        bb_data, bb_trades = run_bollinger_backtest(df)
        
        # Calculate metrics for all
        strategies = {
            'RSI (30/70)': (rsi_data, rsi_trades),
            'MA Cross (20/50)': (ma_data, ma_trades),
            'Bollinger Bands': (bb_data, bb_trades)
        }
        
        # Comparison metrics
        comparison_data = []
        for name, (data, trades) in strategies.items():
            sell_trades = trades[trades['Type'] == 'SELL'] if len(trades) > 0 else pd.DataFrame()
            if len(sell_trades) > 0:
                comparison_data.append({
                    'Strategy': name,
                    'Total Trades': len(sell_trades),
                    'Win Rate (%)': (len(sell_trades[sell_trades['PnL'] > 0]) / len(sell_trades) * 100),
                    'Avg P&L (%)': sell_trades['PnL_pct'].mean(),
                    'Total P&L (%)': sell_trades['PnL_pct'].sum(),
                    'Max Gain (%)': sell_trades['PnL_pct'].max(),
                    'Max Loss (%)': sell_trades['PnL_pct'].min()
                })
        
        if comparison_data:
            comp_df = pd.DataFrame(comparison_data)
            
            # Display metrics table
            st.markdown("#### Performance Metrics")
            st.dataframe(comp_df.style.highlight_max(axis=0, subset=['Total Trades', 'Win Rate (%)', 
                                                                      'Avg P&L (%)', 'Total P&L (%)', 'Max Gain (%)'])
                                        .highlight_min(axis=0, subset=['Max Loss (%)']),
                        use_container_width=True, hide_index=True)
            
            # Cumulative P&L comparison
            st.markdown("#### Cumulative P&L Comparison")
            fig = go.Figure()
            
            for name, (data, trades) in strategies.items():
                if len(data) > 0:
                    fig.add_trace(go.Scatter(
                        x=data['Date'],
                        y=data['Cumulative_PnL'],
                        name=name,
                        mode='lines',
                        line=dict(width=2.5)
                    ))
            
            fig.add_hline(y=0, line_dash="dash", line_color="black", line_width=1)
            fig.update_layout(
                height=450,
                xaxis_title="Date",
                yaxis_title="Cumulative P&L (%)",
                hovermode='x unified',
                legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
            )
            st.plotly_chart(fig, use_container_width=True)
            
            # Bar chart comparison
            col1, col2 = st.columns(2)
            
            with col1:
                fig = px.bar(comp_df, x='Strategy', y='Total P&L (%)',
                            title='Total P&L Comparison',
                            color='Total P&L (%)',
                            color_continuous_scale=['red', 'yellow', 'green'])
                fig.add_hline(y=0, line_dash="dash", line_color="black")
                st.plotly_chart(fig, use_container_width=True)
            
            with col2:
                fig = px.bar(comp_df, x='Strategy', y='Win Rate (%)',
                            title='Win Rate Comparison',
                            color='Win Rate (%)',
                            color_continuous_scale='Blues')
                st.plotly_chart(fig, use_container_width=True)
        else:
            st.warning("No trades generated for any strategy in selected period")

def display_strategy_results(backtest_data, trades_data, info, strategy_name, strategy_desc):
    """Display strategy backtest results"""
    
    if len(trades_data) == 0:
        st.warning(f"No trades generated for {strategy_name} strategy. Try different parameters or time period.")
        return
    
    sell_trades = trades_data[trades_data['Type'] == 'SELL']
    
    if len(sell_trades) > 0:
        total_trades = len(sell_trades)
        winning_trades = len(sell_trades[sell_trades['PnL'] > 0])
        win_rate = (winning_trades / total_trades * 100)
        avg_pnl = sell_trades['PnL_pct'].mean()
        total_pnl = sell_trades['PnL_pct'].sum()
        max_gain = sell_trades['PnL_pct'].max()
        max_loss = sell_trades['PnL_pct'].min()
        
        # Display metrics
        st.markdown(f"### {strategy_name} Performance - {strategy_desc}")
        col1, col2, col3, col4, col5 = st.columns(5)
        
        col1.metric("Total Trades", total_trades)
        col2.metric("Win Rate", f"{win_rate:.1f}%")
        col3.metric("Avg P&L/Trade", f"{avg_pnl:.2f}%")
        col4.metric("Total P&L", f"{total_pnl:.2f}%", delta=f"{total_pnl:.2f}%")
        col5.metric("Max Gain", f"{max_gain:.2f}%")
        
        st.markdown("---")
        
        # Price chart with signals
        st.markdown("### Price Chart with Buy/Sell Signals")
        fig = go.Figure()
        
        fig.add_trace(go.Scatter(
            x=backtest_data['Date'],
            y=backtest_data['Price'],
            name='Price',
            line=dict(color='black', width=1.5)
        ))
        
        buy_signals = backtest_data[backtest_data['Trade_Signal'] == 'BUY']
        if len(buy_signals) > 0:
            fig.add_trace(go.Scatter(
                x=buy_signals['Date'],
                y=buy_signals['Trade_Price'],
                mode='markers',
                name='Buy Signal',
                marker=dict(symbol='triangle-up', size=12, color='green'),
                hovertemplate='<b>BUY</b><br>Date: %{x}<br>Price: %{y:.2f}<extra></extra>'
            ))
        
        sell_signals = backtest_data[backtest_data['Trade_Signal'] == 'SELL']
        if len(sell_signals) > 0:
            fig.add_trace(go.Scatter(
                x=sell_signals['Date'],
                y=sell_signals['Trade_Price'],
                mode='markers',
                name='Sell Signal',
                marker=dict(symbol='triangle-down', size=12, color='red'),
                hovertemplate='<b>SELL</b><br>Date: %{x}<br>Price: %{y:.2f}<extra></extra>'
            ))
        
        fig.update_layout(
            height=500,
            hovermode='x unified',
            xaxis_title="Date",
            yaxis_title=f"Price ({info['currency']})",
            legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
        )
        st.plotly_chart(fig, use_container_width=True)
        
        # Cumulative P&L
        st.markdown("### Cumulative Profit & Loss")
        fig = go.Figure()
        
        fig.add_trace(go.Scatter(
            x=backtest_data['Date'],
            y=backtest_data['Cumulative_PnL'],
            fill='tozeroy',
            line=dict(color='blue', width=2),
            fillcolor='rgba(0, 123, 255, 0.2)'
        ))
        
        fig.add_hline(y=0, line_dash="dash", line_color="black", line_width=1)
        fig.update_layout(
            height=350,
            xaxis_title="Date",
            yaxis_title="Cumulative P&L (%)",
            hovermode='x unified'
        )
        st.plotly_chart(fig, use_container_width=True)
        
        # Trade history
        st.markdown("### Trade History")
        display_trades = trades_data.copy()
        display_trades['Date'] = pd.to_datetime(display_trades['Date']).dt.strftime('%Y-%m-%d')
        display_trades['Price'] = display_trades['Price'].round(2)
        
        if 'PnL_pct' in display_trades.columns:
            display_trades['PnL_pct'] = display_trades['PnL_pct'].round(2)
            display_trades = display_trades[['Date', 'Type', 'Price', 'PnL_pct']]
            display_trades.columns = ['Date', 'Type', 'Price', 'P&L (%)']
        else:
            display_trades = display_trades[['Date', 'Type', 'Price']]
        
        st.dataframe(display_trades, use_container_width=True, hide_index=True)

def run_rsi_backtest(df, buy_threshold, sell_threshold):
    """Run RSI backtest"""
    df = df.copy().sort_values('Date').reset_index(drop=True)
    df['Position'] = 0
    df['Trade_Signal'] = ''
    df['Trade_Price'] = np.nan
    df['Trade_PnL'] = 0.0
    df['Cumulative_PnL'] = 0.0
    
    position = 0
    entry_price = 0
    trades = []
    
    for idx in range(1, len(df)):
        current_rsi = df.loc[idx, 'RSI']
        current_price = df.loc[idx, 'Price']
        current_date = df.loc[idx, 'Date']
        
        if current_rsi < buy_threshold and position == 0:
            position = 1
            entry_price = current_price
            df.loc[idx, 'Position'] = 1
            df.loc[idx, 'Trade_Signal'] = 'BUY'
            df.loc[idx, 'Trade_Price'] = current_price
            trades.append({'Date': current_date, 'Type': 'BUY', 'Price': current_price})
        
        elif current_rsi > sell_threshold and position == 1:
            pnl = current_price - entry_price
            pnl_pct = (pnl / entry_price) * 100
            position = 0
            df.loc[idx, 'Position'] = 0
            df.loc[idx, 'Trade_Signal'] = 'SELL'
            df.loc[idx, 'Trade_Price'] = current_price
            df.loc[idx, 'Trade_PnL'] = pnl_pct
            trades.append({'Date': current_date, 'Type': 'SELL', 'Price': current_price,
                          'PnL': pnl, 'PnL_pct': pnl_pct})
        
        elif position == 1:
            df.loc[idx, 'Position'] = 1
    
    df['Cumulative_PnL'] = df['Trade_PnL'].cumsum()
    return df, pd.DataFrame(trades)

def run_ma_crossover_backtest(df, fast_period, slow_period):
    """Run MA Crossover backtest"""
    df = df.copy().sort_values('Date').reset_index(drop=True)
    df['Position'] = 0
    df['Trade_Signal'] = ''
    df['Trade_Price'] = np.nan
    df['Trade_PnL'] = 0.0
    df['Cumulative_PnL'] = 0.0
    
    fast_ma_col = f'SMA_{fast_period}'
    slow_ma_col = f'SMA_{slow_period}'
    
    position = 0
    entry_price = 0
    trades = []
    
    for idx in range(1, len(df)):
        current_price = df.loc[idx, 'Price']
        current_date = df.loc[idx, 'Date']
        fast_ma = df.loc[idx, fast_ma_col]
        slow_ma = df.loc[idx, slow_ma_col]
        prev_fast_ma = df.loc[idx-1, fast_ma_col]
        prev_slow_ma = df.loc[idx-1, slow_ma_col]
        
        # Golden Cross
        if prev_fast_ma <= prev_slow_ma and fast_ma > slow_ma and position == 0:
            position = 1
            entry_price = current_price
            df.loc[idx, 'Position'] = 1
            df.loc[idx, 'Trade_Signal'] = 'BUY'
            df.loc[idx, 'Trade_Price'] = current_price
            trades.append({'Date': current_date, 'Type': 'BUY', 'Price': current_price})
        
        # Death Cross
        elif prev_fast_ma >= prev_slow_ma and fast_ma < slow_ma and position == 1:
            pnl = current_price - entry_price
            pnl_pct = (pnl / entry_price) * 100
            position = 0
            df.loc[idx, 'Position'] = 0
            df.loc[idx, 'Trade_Signal'] = 'SELL'
            df.loc[idx, 'Trade_Price'] = current_price
            df.loc[idx, 'Trade_PnL'] = pnl_pct
            trades.append({'Date': current_date, 'Type': 'SELL', 'Price': current_price,
                          'PnL': pnl, 'PnL_pct': pnl_pct})
        
        elif position == 1:
            df.loc[idx, 'Position'] = 1
    
    df['Cumulative_PnL'] = df['Trade_PnL'].cumsum()
    return df, pd.DataFrame(trades)

def run_bollinger_backtest(df):
    """Run Bollinger Bands backtest"""
    df = df.copy().sort_values('Date').reset_index(drop=True)
    df['Position'] = 0
    df['Trade_Signal'] = ''
    df['Trade_Price'] = np.nan
    df['Trade_PnL'] = 0.0
    df['Cumulative_PnL'] = 0.0
    
    position = 0
    entry_price = 0
    trades = []
    
    for idx in range(1, len(df)):
        current_price = df.loc[idx, 'Price']
        current_date = df.loc[idx, 'Date']
        bb_upper = df.loc[idx, 'BB_Upper']
        bb_lower = df.loc[idx, 'BB_Lower']
        
        # Buy at lower band
        if current_price <= bb_lower and position == 0:
            position = 1
            entry_price = current_price
            df.loc[idx, 'Position'] = 1
            df.loc[idx, 'Trade_Signal'] = 'BUY'
            df.loc[idx, 'Trade_Price'] = current_price
            trades.append({'Date': current_date, 'Type': 'BUY', 'Price': current_price})
        
        # Sell at upper band
        elif current_price >= bb_upper and position == 1:
            pnl = current_price - entry_price
            pnl_pct = (pnl / entry_price) * 100
            position = 0
            df.loc[idx, 'Position'] = 0
            df.loc[idx, 'Trade_Signal'] = 'SELL'
            df.loc[idx, 'Trade_Price'] = current_price
            df.loc[idx, 'Trade_PnL'] = pnl_pct
            trades.append({'Date': current_date, 'Type': 'SELL', 'Price': current_price,
                          'PnL': pnl, 'PnL_pct': pnl_pct})
        
        elif position == 1:
            df.loc[idx, 'Position'] = 1
    
    df['Cumulative_PnL'] = df['Trade_PnL'].cumsum()
    return df, pd.DataFrame(trades)
    """Run backtest with given parameters"""
    df = df.copy().sort_values('Date').reset_index(drop=True)
    df['Position'] = 0
    df['Trade_Signal'] = ''
    df['Trade_Price'] = np.nan
    df['Trade_PnL'] = 0.0
    df['Cumulative_PnL'] = 0.0
    
    position = 0
    entry_price = 0
    trades = []
    
    for idx in range(1, len(df)):
        current_rsi = df.loc[idx, 'RSI']
        current_price = df.loc[idx, 'Price']
        current_date = df.loc[idx, 'Date']
        
        # Buy signal
        if current_rsi < buy_threshold and position == 0:
            position = 1
            entry_price = current_price
            df.loc[idx, 'Position'] = 1
            df.loc[idx, 'Trade_Signal'] = 'BUY'
            df.loc[idx, 'Trade_Price'] = current_price
            trades.append({
                'Date': current_date,
                'Type': 'BUY',
                'Price': current_price,
                'RSI': current_rsi
            })
        
        # Sell signal
        elif current_rsi > sell_threshold and position == 1:
            pnl = current_price - entry_price
            pnl_pct = (pnl / entry_price) * 100
            position = 0
            df.loc[idx, 'Position'] = 0
            df.loc[idx, 'Trade_Signal'] = 'SELL'
            df.loc[idx, 'Trade_Price'] = current_price
            df.loc[idx, 'Trade_PnL'] = pnl_pct
            trades.append({
                'Date': current_date,
                'Type': 'SELL',
                'Price': current_price,
                'RSI': current_rsi,
                'PnL': pnl,
                'PnL_pct': pnl_pct
            })
        
        # Maintain position
        elif position == 1:
            df.loc[idx, 'Position'] = 1
    
    # Calculate cumulative PnL
    df['Cumulative_PnL'] = df['Trade_PnL'].cumsum()
    
    return df, pd.DataFrame(trades)

# ============================================================================
# PAGE 4: TRADING
# ============================================================================
def trading_page():
    st.title("💼 Trading Platform")
    symbol = st.session_state.selected_symbol
    info = INSTRUMENT_INFO[symbol]
    st.markdown(f"### Place Orders for {symbol} - {info['name']} ({info['currency']})")
    
    # Load current data
    df = load_data(st.session_state.selected_symbol, 365)
    if len(df) == 0:
        st.warning("No data available")
        return
        
    current_price = df.iloc[-1]['Price']
    currency = info['currency']
    
    # Tabs for different order types
    tab1, tab2 = st.tabs(["📊 Market Order", "📅 Historical Order (Backtest)"])
    
    with tab1:
        st.markdown("### Live Market Order")
        col1, col2 = st.columns([1, 1])
        
        with col1:
            st.markdown("#### Order Details")
            order_type = st.selectbox("Order Type", ["Buy", "Sell"], key="market_type")
            quantity = st.number_input("Quantity", min_value=0.01, value=1.0, step=0.01, key="market_qty")
            price = st.number_input(f"Price per Unit ({currency})", min_value=0.01, 
                                   value=float(current_price), step=0.01, key="market_price")
            
            # Stop-loss and take-profit
            use_sl = st.checkbox("Set Stop-Loss", key="market_sl_check")
            stop_loss = None
            if use_sl:
                if order_type == "Buy":
                    stop_loss = st.number_input(f"Stop-Loss ({currency})", 
                                               min_value=0.01, value=float(current_price * 0.95), 
                                               step=0.01, key="market_sl_val")
                else:
                    stop_loss = st.number_input(f"Stop-Loss ({currency})", 
                                               min_value=0.01, value=float(current_price * 1.05), 
                                               step=0.01, key="market_sl_val")
            
            use_tp = st.checkbox("Set Take-Profit", key="market_tp_check")
            take_profit = None
            if use_tp:
                if order_type == "Buy":
                    take_profit = st.number_input(f"Take-Profit ({currency})", 
                                                 min_value=0.01, value=float(current_price * 1.05), 
                                                 step=0.01, key="market_tp_val")
                else:
                    take_profit = st.number_input(f"Take-Profit ({currency})", 
                                                 min_value=0.01, value=float(current_price * 0.95), 
                                                 step=0.01, key="market_tp_val")
            
            notes = st.text_area("Notes (optional)", key="market_notes")
            
            total_value = quantity * price
            st.info(f"**Total Value: {total_value:,.2f} {currency}**")
            
            if st.button("Place Market Order", type="primary", use_container_width=True):
                success = place_order_advanced(
                    st.session_state.username,
                    symbol,
                    order_type,
                    quantity,
                    price,
                    stop_loss,
                    take_profit,
                    datetime.now(),
                    notes
                )
                if success:
                    st.success(f"✅ {order_type} order placed successfully!")
                    st.balloons()
                else:
                    st.error("❌ Failed to place order")
        
        with col2:
            st.markdown("#### Current Market Info")
            st.metric(f"Current Price ({currency})", f"{current_price:.2f}")
            
            if len(df) >= 2:
                prev_price = df.iloc[-2]['Price']
                change = ((current_price - prev_price) / prev_price) * 100
                st.metric("24h Change", f"{change:.2f}%")
            
            latest = df.iloc[-1]
            st.metric("RSI", f"{latest['RSI']:.2f}")
            
            # Trading signal
            rsi = latest['RSI']
            if rsi < 30:
                st.success("📈 **Signal: OVERSOLD - Consider Buying**")
            elif rsi > 70:
                st.error("📉 **Signal: OVERBOUGHT - Consider Selling**")
            else:
                st.info("➡️ **Signal: NEUTRAL - Hold Position**")
    
    with tab2:
        st.markdown("### Historical Order (Backtesting)")
        st.info("Place orders at historical dates to test your trading strategy")
        
        col1, col2 = st.columns([1, 1])
        
        with col1:
            st.markdown("#### Order Details")
            
            # Date selection
            min_date = df['Date'].min().date()
            max_date = df['Date'].max().date()
            order_date = st.date_input("Order Date", value=max_date, 
                                       min_value=min_date, max_value=max_date,
                                       key="hist_date")
            
            # Get price at selected date
            selected_data = df[df['Date'].dt.date == order_date]
            if len(selected_data) > 0:
                historical_price = selected_data.iloc[0]['Price']
                historical_rsi = selected_data.iloc[0]['RSI']
            else:
                historical_price = current_price
                historical_rsi = 50
            
            hist_order_type = st.selectbox("Order Type", ["Buy", "Sell"], key="hist_type")
            hist_quantity = st.number_input("Quantity", min_value=0.01, value=1.0, step=0.01, key="hist_qty")
            hist_price = st.number_input(f"Entry Price ({currency})", 
                                         min_value=0.01, value=float(historical_price), 
                                         step=0.01, key="hist_price")
            
            # Stop-loss and take-profit
            hist_use_sl = st.checkbox("Set Stop-Loss", key="hist_sl_check")
            hist_stop_loss = None
            if hist_use_sl:
                if hist_order_type == "Buy":
                    hist_stop_loss = st.number_input(f"Stop-Loss ({currency})", 
                                                     min_value=0.01, value=float(hist_price * 0.95), 
                                                     step=0.01, key="hist_sl_val")
                else:
                    hist_stop_loss = st.number_input(f"Stop-Loss ({currency})", 
                                                     min_value=0.01, value=float(hist_price * 1.05), 
                                                     step=0.01, key="hist_sl_val")
            
            hist_use_tp = st.checkbox("Set Take-Profit", key="hist_tp_check")
            hist_take_profit = None
            if hist_use_tp:
                if hist_order_type == "Buy":
                    hist_take_profit = st.number_input(f"Take-Profit ({currency})", 
                                                       min_value=0.01, value=float(hist_price * 1.05), 
                                                       step=0.01, key="hist_tp_val")
                else:
                    hist_take_profit = st.number_input(f"Take-Profit ({currency})", 
                                                       min_value=0.01, value=float(hist_price * 0.95), 
                                                       step=0.01, key="hist_tp_val")
            
            hist_notes = st.text_area("Strategy/Notes", key="hist_notes",
                                      placeholder="e.g., RSI < 30 buy signal")
            
            hist_total_value = hist_quantity * hist_price
            st.info(f"**Total Value: {hist_total_value:,.2f} {currency}**")
            
            if st.button("Place Historical Order", type="primary", use_container_width=True):
                success = place_order_advanced(
                    st.session_state.username,
                    symbol,
                    hist_order_type,
                    hist_quantity,
                    hist_price,
                    hist_stop_loss,
                    hist_take_profit,
                    pd.to_datetime(order_date),
                    hist_notes
                )
                if success:
                    st.success(f"✅ Historical {hist_order_type} order placed for {order_date}!")
                else:
                    st.error("❌ Failed to place order")
        
        with col2:
            st.markdown(f"#### Market Info on {order_date}")
            st.metric(f"Price on Date ({currency})", f"{historical_price:.2f}")
            st.metric("RSI on Date", f"{historical_rsi:.2f}")
            
            # Show future price movement for analysis
            future_data = df[df['Date'].dt.date > order_date].head(30)
            if len(future_data) > 0:
                st.markdown("**Price Movement (Next 30 days)**")
                price_change = ((future_data['Price'].max() - historical_price) / historical_price) * 100
                st.metric("Max Gain Potential", f"{price_change:.2f}%")
                
                price_drop = ((future_data['Price'].min() - historical_price) / historical_price) * 100
                st.metric("Max Loss Potential", f"{price_drop:.2f}%")

def place_order_advanced(username, symbol, order_type, quantity, price, stop_loss, take_profit, timestamp, notes):
    """Place order with stop-loss and take-profit"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        total_value = quantity * price
        
        cursor.execute('''
            INSERT INTO orders (timestamp, username, symbol, order_type, quantity, price, 
                              total_value, stop_loss, take_profit, order_status, notes, execution_date)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Open', ?, ?)
        ''', (timestamp, username, symbol, order_type, quantity, price, total_value,
              stop_loss, take_profit, notes, timestamp))
        
        conn.commit()
        return True
    except Exception as e:
        st.error(f"Error: {str(e)}")
        return False

# ============================================================================
# PAGE 5: ORDER HISTORY
# ============================================================================
def order_history_page():
    st.title("📋 Order History")
    st.markdown(f"### Orders by {st.session_state.username}")
    
    orders = get_user_orders(st.session_state.username)
    
    if len(orders) == 0:
        st.info("No orders placed yet. Visit the Trading page to place your first order!")
    else:
        # Summary metrics
        total_orders = len(orders)
        buy_orders = len(orders[orders['order_type'] == 'Buy'])
        sell_orders = len(orders[orders['order_type'] == 'Sell'])
        total_value = orders['total_value'].sum()
        
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Total Orders", total_orders)
        col2.metric("Buy Orders", buy_orders)
        col3.metric("Sell Orders", sell_orders)
        col4.metric("Total Value", f"${total_value:,.2f}")
        
        st.markdown("---")
        
        # Orders table with new columns
        st.markdown("### Order Details")
        display_cols = ['timestamp', 'symbol', 'order_type', 'quantity', 'price', 'total_value']
        
        # Add optional columns if they exist
        if 'stop_loss' in orders.columns:
            display_cols.extend(['stop_loss', 'take_profit'])
        if 'order_status' in orders.columns:
            display_cols.append('order_status')
        if 'notes' in orders.columns:
            display_cols.append('notes')
        
        # Filter to existing columns
        display_cols = [col for col in display_cols if col in orders.columns]
        display_orders = orders[display_cols].copy()
        
        # Rename columns for display
        column_names = {
            'timestamp': 'Date/Time',
            'symbol': 'Symbol',
            'order_type': 'Type',
            'quantity': 'Quantity',
            'price': 'Price',
            'total_value': 'Total Value',
            'stop_loss': 'Stop-Loss',
            'take_profit': 'Take-Profit',
            'order_status': 'Status',
            'notes': 'Notes'
        }
        display_orders = display_orders.rename(columns={k: v for k, v in column_names.items() if k in display_orders.columns})
        
        st.dataframe(display_orders, use_container_width=True, hide_index=True)
        
        # Orders by symbol
        st.markdown("### Orders by Instrument")
        symbol_summary = orders.groupby('symbol').agg({
            'order_id': 'count',
            'quantity': 'sum',
            'total_value': 'sum'
        }).reset_index()
        symbol_summary.columns = ['Symbol', 'Number of Orders', 'Total Quantity', 'Total Value']
        
        col1, col2 = st.columns([1, 2])
        with col1:
            st.dataframe(symbol_summary, use_container_width=True, hide_index=True)
        
        with col2:
            fig = px.bar(symbol_summary, x='Symbol', y='Total Value',
                        title='Total Value by Instrument',
                        color='Symbol')
            fig.update_layout(showlegend=False, height=300)
            st.plotly_chart(fig, use_container_width=True)
        
        # Visualize orders on price chart
        st.markdown("---")
        st.markdown("### Orders Visualization")
        
        selected_symbol_viz = st.selectbox("Select instrument to visualize", 
                                           orders['symbol'].unique())
        
        symbol_orders = orders[orders['symbol'] == selected_symbol_viz]
        price_data = load_data(selected_symbol_viz, 365)
        
        if len(price_data) > 0:
            fig = go.Figure()
            
            # Price line
            fig.add_trace(go.Scatter(
                x=price_data['Date'],
                y=price_data['Price'],
                name='Price',
                line=dict(color='black', width=1.5)
            ))
            
            # Buy orders
            buy_orders_viz = symbol_orders[symbol_orders['order_type'] == 'Buy']
            if len(buy_orders_viz) > 0:
                fig.add_trace(go.Scatter(
                    x=pd.to_datetime(buy_orders_viz['timestamp']),
                    y=buy_orders_viz['price'],
                    mode='markers',
                    name='Your Buy Orders',
                    marker=dict(symbol='triangle-up', size=15, color='green', 
                               line=dict(width=2, color='darkgreen')),
                    text=[f"Buy @ {p:.2f}" for p in buy_orders_viz['price']],
                    hovertemplate='<b>YOUR BUY ORDER</b><br>Date: %{x}<br>Price: %{y:.2f}<extra></extra>'
                ))
            
            # Sell orders
            sell_orders_viz = symbol_orders[symbol_orders['order_type'] == 'Sell']
            if len(sell_orders_viz) > 0:
                fig.add_trace(go.Scatter(
                    x=pd.to_datetime(sell_orders_viz['timestamp']),
                    y=sell_orders_viz['price'],
                    mode='markers',
                    name='Your Sell Orders',
                    marker=dict(symbol='triangle-down', size=15, color='red',
                               line=dict(width=2, color='darkred')),
                    text=[f"Sell @ {p:.2f}" for p in sell_orders_viz['price']],
                    hovertemplate='<b>YOUR SELL ORDER</b><br>Date: %{x}<br>Price: %{y:.2f}<extra></extra>'
                ))
            
            fig.update_layout(
                title=f"{selected_symbol_viz} - Your Orders on Price Chart",
                height=500,
                xaxis_title="Date",
                yaxis_title="Price",
                hovermode='x unified',
                legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
            )
            st.plotly_chart(fig, use_container_width=True)

# ============================================================================
# PAGE 6: STATISTICS
# ============================================================================
def statistics_page():
    st.title("📊 Market Statistics")
    
    stats = get_statistics()
    
    st.markdown("### Summary Statistics by Commodity")
    st.dataframe(stats, use_container_width=True, hide_index=True)
    
    st.markdown("---")
    
    # Visualization
    col1, col2 = st.columns(2)
    
    with col1:
        fig = px.bar(stats, x='Symbol', y='Avg_Price',
                    title='Average Price by Commodity',
                    color='Symbol')
        fig.update_layout(showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        fig = px.bar(stats, x='Symbol', y='Return_Volatility',
                    title='Volatility by Commodity',
                    color='Symbol')
        fig.update_layout(showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    # Risk-Return scatter
    st.markdown("### Risk-Return Profile")
    fig = px.scatter(stats, x='Return_Volatility', y='Avg_Return',
                     text='Symbol', size='Avg_Price',
                     title='Risk vs Return',
                     labels={'Return_Volatility': 'Risk (Volatility)', 
                            'Avg_Return': 'Average Daily Return (%)'})
    fig.update_traces(textposition='top center')
    fig.update_layout(height=500)
    st.plotly_chart(fig, use_container_width=True)

# ============================================================================
# MAIN APP
# ============================================================================
def main():
    if not st.session_state.logged_in:
        login_page()
    else:
        main_dashboard()

if __name__ == "__main__":
    main()