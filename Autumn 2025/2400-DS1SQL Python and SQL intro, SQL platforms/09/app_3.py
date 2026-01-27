import streamlit as st
# Import the Streamlit library and call it "st".
# This gives us access to Streamlit functions like st.title(), st.write(), etc.

st.title("Hello Streamlit!")
# Displays a big title at the top of the web app.

st.write("This is my first Streamlit app.")
# Writes regular text on the page (Streamlit can display text, numbers, tables, charts, etc.)

number = st.slider("Pick a number", 1, 10)
# Creates an interactive slider widget.
# The user can drag the slider to choose a number between 1 and 10.
# The selected value is stored in the variable "number".

st.write("Your number squared:", number**2)
# Displays the text and the result of squaring the chosen number.
# Streamlit updates automatically whenever the slider changes.

