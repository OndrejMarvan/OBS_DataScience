"""
Trading Dashboard - Final Project
Student: Ondrej Marvan
Course: Python and SQL
"""

import streamlit as st
import pandas as pd
import numpy as np
import sqlite3
import plotly.graph_objects as go
import plotly.express as px
from datetime import datetime

# Page setup
st.set_page_config(
    page_title="Trading Dashboard",
    page_icon="chart_with_upwards_trend",
    layout="wide"
)

# Database connection
@st.cache_resource
def get_db_connection():
    return sqlite3.connect('commodities_trading.db', check_same_thread=False)

def load_data(symbol=None, days=365):
    conn = get_db_connection()
    if symbol:
        query = f"SELECT * FROM prices WHERE Symbol = '{symbol}' ORDER BY Date DESC LIMIT {days}"
    else:
        query = f"SELECT * FROM prices ORDER BY Date DESC LIMIT {days * 8}"
    df = pd.read_sql_query(query, conn)
    df['Date'] = pd.to_datetime(df['Date'])
    return df.sort_values('Date')

def get_statistics():
    conn = get_db_connection()
    return pd.read_sql_query("SELECT * FROM statistics", conn)

def check_login(username, password):
    conn = get_db_connection()
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    result = pd.read_sql_query(query, conn)
    return len(result) > 0

# Initialize session
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False
if 'username' not in st.session_state:
    st.session_state.username = None
if 'page' not in st.session_state:
    st.session_state.page = 'overview'
if 'selected_symbol' not in st.session_state:
    st.session_state.selected_symbol = 'EUA'

# LOGIN PAGE
if not st.session_state.logged_in:
    st.title("Trading Dashboard - Login")
    
    col1, col2, col3 = st.columns([1, 2, 1])
    
    with col2:
        st.markdown("### Please login to continue")
        
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        
        col_a, col_b = st.columns(2)
        
        with col_a:
            if st.button("Login", use_container_width=True):
                if check_login(username, password):
                    st.session_state.logged_in = True
                    st.session_state.username = username
                    st.success("Login successful!")
                    st.rerun()
                else:
                    st.error("Invalid username or password")
        
        with col_b:
            if st.button("Demo Login", use_container_width=True):
                st.session_state.logged_in = True
                st.session_state.username = "demo"
                st.rerun()
        
        st.info("Demo credentials: admin / admin123")
    
    st.stop()

# MAIN DASHBOARD (after login)
# Sidebar navigation
st.sidebar.title("Navigation")
st.sidebar.markdown(f"Welcome, **{st.session_state.username}**")
st.sidebar.markdown("---")

page = st.sidebar.radio("Go to", 
    ["Market Overview", "Technical Analysis", "Strategy Backtest", "Statistics"])

st.sidebar.markdown("---")

# Instrument selector
symbols = ['EUA', 'OIL', 'NG', 'GOLD', 'SILVER', 'BTC', 'SPX', 'NDX']
st.session_state.selected_symbol = st.sidebar.selectbox(
    "Select Instrument",
    symbols,
    index=symbols.index(st.session_state.selected_symbol)
)

# Time period
time_period = st.sidebar.selectbox(
    "Time Period",
    ["30 Days", "90 Days", "180 Days", "1 Year"]
)
days_map = {"30 Days": 30, "90 Days": 90, "180 Days": 180, "1 Year": 365}
days = days_map[time_period]

st.sidebar.markdown("---")
if st.sidebar.button("Logout"):
    st.session_state.logged_in = False
    st.session_state.username = None
    st.rerun()

# PAGE 1: MARKET OVERVIEW
if page == "Market Overview":
    st.title("Market Overview")
    
    df = load_data(days=days)
    
    st.subheader("Current Prices")
    cols = st.columns(4)
    
    for i, symbol in enumerate(['EUA', 'OIL', 'NG', 'GOLD']):
        symbol_data = df[df['Symbol'] == symbol].tail(2)
        if len(symbol_data) >= 2:
            current = symbol_data.iloc[-1]['Price']
            prev = symbol_data.iloc[-2]['Price']
            change = ((current - prev) / prev) * 100
            
            with cols[i]:
                st.metric(symbol, f"{current:.2f}", f"{change:.2f}%")
    
    cols = st.columns(4)
    for i, symbol in enumerate(['SILVER', 'BTC', 'SPX', 'NDX']):
        symbol_data = df[df['Symbol'] == symbol].tail(2)
        if len(symbol_data) >= 2:
            current = symbol_data.iloc[-1]['Price']
            prev = symbol_data.iloc[-2]['Price']
            change = ((current - prev) / prev) * 100
            
            with cols[i]:
                st.metric(symbol, f"{current:.2f}", f"{change:.2f}%")
    
    st.markdown("---")
    
    # Price comparison chart
    st.subheader("Price Performance (Normalized)")
    fig = go.Figure()
    
    for symbol in symbols:
        symbol_data = df[df['Symbol'] == symbol].sort_values('Date')
        if len(symbol_data) > 0:
            normalized = (symbol_data['Price'] / symbol_data['Price'].iloc[0]) * 100
            fig.add_trace(go.Scatter(
                x=symbol_data['Date'],
                y=normalized,
                name=symbol,
                mode='lines'
            ))
    
    fig.update_layout(
        height=500,
        xaxis_title="Date",
        yaxis_title="Normalized Price (Base=100)"
    )
    st.plotly_chart(fig, use_container_width=True)

# PAGE 2: TECHNICAL ANALYSIS
elif page == "Technical Analysis":
    st.title("Technical Analysis")
    symbol = st.session_state.selected_symbol
    st.subheader(f"{symbol} Analysis")
    
    df = load_data(symbol, days)
    
    if len(df) == 0:
        st.warning("No data available")
    else:
        latest = df.iloc[-1]
        
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Price", f"{latest['Price']:.2f}")
        col2.metric("RSI", f"{latest['RSI']:.2f}")
        col3.metric("Volume", f"{latest['Vol']:,.0f}")
        col4.metric("Daily Return", f"{latest['Daily_Return']:.2f}%")
        
        st.markdown("---")
        
        # Price with Moving Averages
        st.subheader("Price with Moving Averages")
        fig = go.Figure()
        fig.add_trace(go.Scatter(x=df['Date'], y=df['Price'], name='Price'))
        fig.add_trace(go.Scatter(x=df['Date'], y=df['SMA_20'], name='SMA 20'))
        fig.add_trace(go.Scatter(x=df['Date'], y=df['SMA_50'], name='SMA 50'))
        fig.update_layout(height=400, xaxis_title="Date", yaxis_title="Price")
        st.plotly_chart(fig, use_container_width=True)
        
        # RSI
        st.subheader("RSI Indicator")
        fig = go.Figure()
        fig.add_trace(go.Scatter(x=df['Date'], y=df['RSI'], name='RSI'))
        fig.add_hline(y=70, line_dash="dash", line_color="red", annotation_text="Overbought")
        fig.add_hline(y=30, line_dash="dash", line_color="green", annotation_text="Oversold")
        fig.update_layout(height=300, xaxis_title="Date", yaxis_title="RSI")
        st.plotly_chart(fig, use_container_width=True)
        
        # Bollinger Bands
        st.subheader("Bollinger Bands")
        fig = go.Figure()
        fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Upper'], name='Upper Band',
                                line=dict(color='gray', dash='dash')))
        fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Middle'], name='Middle Band',
                                line=dict(color='blue')))
        fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Lower'], name='Lower Band',
                                line=dict(color='gray', dash='dash')))
        fig.add_trace(go.Scatter(x=df['Date'], y=df['Price'], name='Price',
                                line=dict(color='black', width=2)))
        fig.update_layout(height=400, xaxis_title="Date", yaxis_title="Price")
        st.plotly_chart(fig, use_container_width=True)

# PAGE 3: STRATEGY BACKTEST
elif page == "Strategy Backtest":
    st.title("Strategy Backtest")
    symbol = st.session_state.selected_symbol
    st.subheader(f"{symbol} Strategy Testing")
    
    df = load_data(symbol, days)
    
    if len(df) == 0:
        st.warning("No data available")
    else:
        # Strategy selection
        strategy = st.selectbox("Select Strategy", 
            ["RSI Strategy", "MA Crossover", "Bollinger Bands"])
        
        if strategy == "RSI Strategy":
            col1, col2 = st.columns(2)
            buy_threshold = col1.slider("Buy when RSI below", 10, 50, 30)
            sell_threshold = col2.slider("Sell when RSI above", 50, 90, 70)
            
            # Simple backtest
            df_copy = df.copy()
            df_copy['Signal'] = ''
            df_copy['Position'] = 0
            position = 0
            entry_price = 0
            trades = []
            
            for i in range(len(df_copy)):
                if df_copy.iloc[i]['RSI'] < buy_threshold and position == 0:
                    df_copy.loc[df_copy.index[i], 'Signal'] = 'BUY'
                    df_copy.loc[df_copy.index[i], 'Position'] = 1
                    position = 1
                    entry_price = df_copy.iloc[i]['Price']
                    trades.append({'Date': df_copy.iloc[i]['Date'], 'Type': 'BUY', 
                                  'Price': entry_price})
                elif df_copy.iloc[i]['RSI'] > sell_threshold and position == 1:
                    df_copy.loc[df_copy.index[i], 'Signal'] = 'SELL'
                    df_copy.loc[df_copy.index[i], 'Position'] = 0
                    position = 0
                    exit_price = df_copy.iloc[i]['Price']
                    pnl = ((exit_price - entry_price) / entry_price) * 100
                    trades.append({'Date': df_copy.iloc[i]['Date'], 'Type': 'SELL', 
                                  'Price': exit_price, 'PnL': pnl})
                elif position == 1:
                    df_copy.loc[df_copy.index[i], 'Position'] = 1
            
            # Results
            trades_df = pd.DataFrame(trades)
            if len(trades_df) > 0:
                sell_trades = trades_df[trades_df['Type'] == 'SELL']
                if len(sell_trades) > 0:
                    total_trades = len(sell_trades)
                    winning = len(sell_trades[sell_trades['PnL'] > 0])
                    win_rate = (winning / total_trades) * 100
                    avg_pnl = sell_trades['PnL'].mean()
                    total_pnl = sell_trades['PnL'].sum()
                    
                    col1, col2, col3, col4 = st.columns(4)
                    col1.metric("Total Trades", total_trades)
                    col2.metric("Win Rate", f"{win_rate:.1f}%")
                    col3.metric("Avg PnL", f"{avg_pnl:.2f}%")
                    col4.metric("Total PnL", f"{total_pnl:.2f}%")
                    
                    st.markdown("---")
                    
                    # Show trade list
                    st.subheader("Trade History")
                    trades_display = trades_df.copy()
                    trades_display['Date'] = pd.to_datetime(trades_display['Date']).dt.strftime('%Y-%m-%d')
                    trades_display['Price'] = trades_display['Price'].round(2)
                    if 'PnL' in trades_display.columns:
                        trades_display['PnL'] = trades_display['PnL'].round(2)
                    st.dataframe(trades_display, use_container_width=True, hide_index=True)
            
            # Chart with signals
            st.subheader("Price with Buy/Sell Signals and Position")
            fig = go.Figure()
            
            # Show position periods as background shading
            in_position = df_copy[df_copy['Position'] == 1]
            if len(in_position) > 0:
                # Group consecutive positions
                position_starts = []
                position_ends = []
                for i in range(len(df_copy)):
                    if i == 0:
                        if df_copy.iloc[i]['Position'] == 1:
                            position_starts.append(df_copy.iloc[i]['Date'])
                    else:
                        if df_copy.iloc[i]['Position'] == 1 and df_copy.iloc[i-1]['Position'] == 0:
                            position_starts.append(df_copy.iloc[i]['Date'])
                        elif df_copy.iloc[i]['Position'] == 0 and df_copy.iloc[i-1]['Position'] == 1:
                            position_ends.append(df_copy.iloc[i-1]['Date'])
                
                # Add last position end if still open
                if len(position_starts) > len(position_ends):
                    position_ends.append(df_copy.iloc[-1]['Date'])
                
                # Add shaded regions for positions
                for start, end in zip(position_starts, position_ends):
                    fig.add_vrect(
                        x0=start, x1=end,
                        fillcolor="lightgreen", opacity=0.2,
                        layer="below", line_width=0,
                    )
            
            # Price line
            fig.add_trace(go.Scatter(x=df_copy['Date'], y=df_copy['Price'], 
                                    name='Price', line=dict(color='black', width=2)))
            
            # Buy signals
            buy_signals = df_copy[df_copy['Signal'] == 'BUY']
            if len(buy_signals) > 0:
                fig.add_trace(go.Scatter(x=buy_signals['Date'], y=buy_signals['Price'],
                                        mode='markers', name='Buy (Open Position)',
                                        marker=dict(symbol='triangle-up', size=12, color='green',
                                                   line=dict(width=2, color='darkgreen'))))
            
            # Sell signals
            sell_signals = df_copy[df_copy['Signal'] == 'SELL']
            if len(sell_signals) > 0:
                fig.add_trace(go.Scatter(x=sell_signals['Date'], y=sell_signals['Price'],
                                        mode='markers', name='Sell (Close Position)',
                                        marker=dict(symbol='triangle-down', size=12, color='red',
                                                   line=dict(width=2, color='darkred'))))
            
            fig.update_layout(
                height=500, 
                xaxis_title="Date", 
                yaxis_title="Price",
                legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
            )
            st.plotly_chart(fig, use_container_width=True)
            
            st.info("Green shaded areas = Open position (holding asset)")
        
        elif strategy == "MA Crossover":
            st.info("Buy when fast MA crosses above slow MA. Sell when crosses below.")
            
            # Simple implementation
            df_copy = df.copy()
            df_copy['Signal'] = ''
            df_copy['Position'] = 0
            position = 0
            
            for i in range(1, len(df_copy)):
                if (df_copy.iloc[i-1]['SMA_20'] <= df_copy.iloc[i-1]['SMA_50'] and 
                    df_copy.iloc[i]['SMA_20'] > df_copy.iloc[i]['SMA_50'] and position == 0):
                    df_copy.loc[df_copy.index[i], 'Signal'] = 'BUY'
                    df_copy.loc[df_copy.index[i], 'Position'] = 1
                    position = 1
                elif (df_copy.iloc[i-1]['SMA_20'] >= df_copy.iloc[i-1]['SMA_50'] and 
                      df_copy.iloc[i]['SMA_20'] < df_copy.iloc[i]['SMA_50'] and position == 1):
                    df_copy.loc[df_copy.index[i], 'Signal'] = 'SELL'
                    df_copy.loc[df_copy.index[i], 'Position'] = 0
                    position = 0
                elif position == 1:
                    df_copy.loc[df_copy.index[i], 'Position'] = 1
            
            # Chart
            fig = go.Figure()
            
            # Position shading
            in_position = df_copy[df_copy['Position'] == 1]
            if len(in_position) > 0:
                position_starts = []
                position_ends = []
                for i in range(len(df_copy)):
                    if i == 0:
                        if df_copy.iloc[i]['Position'] == 1:
                            position_starts.append(df_copy.iloc[i]['Date'])
                    else:
                        if df_copy.iloc[i]['Position'] == 1 and df_copy.iloc[i-1]['Position'] == 0:
                            position_starts.append(df_copy.iloc[i]['Date'])
                        elif df_copy.iloc[i]['Position'] == 0 and df_copy.iloc[i-1]['Position'] == 1:
                            position_ends.append(df_copy.iloc[i-1]['Date'])
                
                if len(position_starts) > len(position_ends):
                    position_ends.append(df_copy.iloc[-1]['Date'])
                
                for start, end in zip(position_starts, position_ends):
                    fig.add_vrect(
                        x0=start, x1=end,
                        fillcolor="lightgreen", opacity=0.2,
                        layer="below", line_width=0,
                    )
            
            fig.add_trace(go.Scatter(x=df_copy['Date'], y=df_copy['Price'], name='Price'))
            fig.add_trace(go.Scatter(x=df_copy['Date'], y=df_copy['SMA_20'], name='SMA 20'))
            fig.add_trace(go.Scatter(x=df_copy['Date'], y=df_copy['SMA_50'], name='SMA 50'))
            
            buy_signals = df_copy[df_copy['Signal'] == 'BUY']
            if len(buy_signals) > 0:
                fig.add_trace(go.Scatter(x=buy_signals['Date'], y=buy_signals['Price'],
                                        mode='markers', name='Buy (Open)',
                                        marker=dict(symbol='triangle-up', size=12, color='green',
                                                   line=dict(width=2, color='darkgreen'))))
            
            sell_signals = df_copy[df_copy['Signal'] == 'SELL']
            if len(sell_signals) > 0:
                fig.add_trace(go.Scatter(x=sell_signals['Date'], y=sell_signals['Price'],
                                        mode='markers', name='Sell (Close)',
                                        marker=dict(symbol='triangle-down', size=12, color='red',
                                                   line=dict(width=2, color='darkred'))))
            
            fig.update_layout(height=500, xaxis_title="Date", yaxis_title="Price")
            st.plotly_chart(fig, use_container_width=True)
            
            st.info("Green shaded areas = Open position (holding asset)")
        
        else:  # Bollinger Bands
            st.info("Buy when price touches lower band. Sell when touches upper band.")
            
            fig = go.Figure()
            fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Upper'], name='Upper Band',
                                    line=dict(dash='dash')))
            fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Middle'], name='Middle'))
            fig.add_trace(go.Scatter(x=df['Date'], y=df['BB_Lower'], name='Lower Band',
                                    line=dict(dash='dash')))
            fig.add_trace(go.Scatter(x=df['Date'], y=df['Price'], name='Price',
                                    line=dict(color='black', width=2)))
            
            fig.update_layout(height=500, xaxis_title="Date", yaxis_title="Price")
            st.plotly_chart(fig, use_container_width=True)

# PAGE 4: STATISTICS
elif page == "Statistics":
    st.title("Market Statistics")
    
    stats = get_statistics()
    
    st.subheader("Summary Statistics")
    st.dataframe(stats, use_container_width=True, hide_index=True)
    
    st.markdown("---")
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("Average Price by Instrument")
        fig = px.bar(stats, x='Symbol', y='Avg_Price', color='Symbol')
        fig.update_layout(showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("Volatility Comparison")
        fig = px.bar(stats, x='Symbol', y='Return_Volatility', color='Symbol')
        fig.update_layout(showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    st.markdown("---")
    
    st.subheader("Risk vs Return")
    fig = px.scatter(stats, x='Return_Volatility', y='Avg_Return',
                     text='Symbol', size='Avg_Price',
                     labels={'Return_Volatility': 'Risk (Volatility)', 
                            'Avg_Return': 'Average Return (%)'})
    fig.update_traces(textposition='top center')
    fig.update_layout(height=500)
    st.plotly_chart(fig, use_container_width=True)

st.sidebar.markdown("---")
st.sidebar.markdown("**Trading Dashboard**")
st.sidebar.markdown("Final Project - Ondřej Marvan")

#streamlit run streamlit_app.py