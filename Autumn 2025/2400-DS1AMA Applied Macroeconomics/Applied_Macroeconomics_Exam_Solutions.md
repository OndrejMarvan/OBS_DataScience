# Applied Macroeconomics Exam - Complete Solutions

---

## Problem 1: Social Accounting Matrix (SAM)

### Given SAM Structure:

|       | X   | Y   | K   | L   | CONS | GOVT |
|-------|-----|-----|-----|-----|------|------|
| X     | -   | -   | -   | -   | 180  | 20   |
| Y     | -   | -   | -   | -   | 50   | B    |
| K     | C   | 50  | -   | -   | -    | -    |
| L     | 150 | 50  | -   | -   | -    | -    |
| CONS  | -   | -   | 100 | A   | -    | -    |
| GOVT  | -   | -   | 0   | 0   | 70   | -    |

### Part (a): Computing A, B, and C

**Using column-row balance (each column sum = row sum):**

**Finding A (Labor income to Consumer):**
- Row L total = Column L total
- L supplies to X (150) + L supplies to Y (50) = 200
- Column CONS: K income (100) + L income (A) = Row CONS total
- Row CONS = expenditure on X (180) + expenditure on Y (50) + taxes (70) = 300
- Therefore: 100 + A = 300 → **A = 200**

**Finding B (Government spending on Y):**
- Column GOVT total = Row GOVT total
- Row GOVT: Taxes from CONS = 70
- Column GOVT: spending on X (20) + spending on Y (B) = 70
- Therefore: 20 + B = 70 → **B = 50**

**Finding C (Capital income from X):**
- Row K total = Column K total
- Row K: C + 50 = total capital income
- Column K goes to CONS: 100
- Therefore: C + 50 = 100 → **C = 50**

### Interpretation:
- **A = 200**: Total labor income paid to the household
- **B = 50**: Government expenditure on good Y
- **C = 50**: Capital income generated from production of good X

### Part (b): Benchmark Price Assumptions

To calibrate the model, we assume **benchmark prices equal to 1** for all goods and factors:
- Price of good X: $p_X = 1$
- Price of good Y: $p_Y = 1$  
- Rental rate of capital: $r = 1$
- Wage rate: $w = 1$

This normalization allows the SAM values to represent both quantities and values simultaneously.

### Part (c): Calibrating Cobb-Douglas Production Functions

Production functions: $X = A_X K_X^{\alpha_{KX}} L_X^{\alpha_{LX}}$ and $Y = A_Y K_Y^{\alpha_{KY}} L_Y^{\alpha_{LY}}$

**For Sector X:**
- Total output value = 180 + 20 = 200
- Capital payment = 50, Labor payment = 150
- Capital share: $\alpha_{KX} = \frac{50}{200} = 0.25$
- Labor share: $\alpha_{LX} = \frac{150}{200} = 0.75$
- With benchmark prices = 1: $K_X = 50$, $L_X = 150$, $X = 200$
- $A_X = \frac{X}{K_X^{0.25} L_X^{0.75}} = \frac{200}{50^{0.25} \times 150^{0.75}} = \frac{200}{2.659 \times 42.86} \approx 1.755$

**For Sector Y:**
- Total output value = 50 + 50 = 100
- Capital payment = 50, Labor payment = 50
- Capital share: $\alpha_{KY} = \frac{50}{100} = 0.5$
- Labor share: $\alpha_{LY} = \frac{50}{100} = 0.5$
- $A_Y = \frac{Y}{K_Y^{0.5} L_Y^{0.5}} = \frac{100}{50^{0.5} \times 50^{0.5}} = \frac{100}{50} = 2$

### Part (d) & (e): Consumer Utility Function

Utility function: $U = B C_1^{\beta_1} C_2^{\beta_2}$

**Deriving Demand Functions:**

The consumer maximizes utility subject to budget constraint: $p_1 C_1 + p_2 C_2 = I$

Using Lagrangian method, the demand functions are:
$$C_1 = \frac{\beta_1}{\beta_1 + \beta_2} \cdot \frac{I}{p_1}$$
$$C_2 = \frac{\beta_2}{\beta_1 + \beta_2} \cdot \frac{I}{p_2}$$

**Calibration:**
- Total consumer income = 100 + 200 - 70 = 230 (capital + labor - taxes)
- Consumer spending on X = 180, on Y = 50
- With prices = 1:
  - $\beta_1 = \frac{180}{230} \approx 0.783$
  - $\beta_2 = \frac{50}{230} \approx 0.217$
- B is a scaling constant (can be normalized to 1)

---

## Problem 2: Household Utility Maximization

### Given:
$$\max_{c_t, h_t, B_t} U = \sum_{t=0}^{\infty} \beta^t E_t[\ln c_t + \phi \ln(1-h_t)]$$

Subject to: $P_t c_t + B_t = W_t h_t + (1+i_{t-1})B_{t-1} + P_t d_t$

### Part (a): Budget Constraint in Real Terms

Define real bonds: $b_t = \frac{B_t}{P_t}$

Divide the budget constraint by $P_t$:
$$c_t + \frac{B_t}{P_t} = \frac{W_t}{P_t} h_t + (1+i_{t-1})\frac{B_{t-1}}{P_t} + d_t$$

Let $w_t = \frac{W_t}{P_t}$ (real wage) and note that $\frac{B_{t-1}}{P_t} = \frac{B_{t-1}}{P_{t-1}} \cdot \frac{P_{t-1}}{P_t} = b_{t-1} \cdot \frac{1}{1+\pi_t}$

**Real budget constraint:**
$$c_t + b_t = w_t h_t + \frac{1+i_{t-1}}{1+\pi_t} b_{t-1} + d_t$$

Or equivalently:
$$c_t + b_t = w_t h_t + (1+r_{t-1})b_{t-1} + d_t$$

where $(1+r_{t-1}) = \frac{1+i_{t-1}}{1+\pi_t}$ is the real interest rate (Fisher equation).

### Part (b): Lagrangian

$$\mathcal{L} = \sum_{t=0}^{\infty} \beta^t E_t \left[ \ln c_t + \phi \ln(1-h_t) + \lambda_t \left( w_t h_t + (1+r_{t-1})b_{t-1} + d_t - c_t - b_t \right) \right]$$

### Part (c): First-Order Conditions

**FOC with respect to $c_t$:**
$$\frac{\partial \mathcal{L}}{\partial c_t} = 0: \quad \frac{1}{c_t} = \lambda_t$$

**FOC with respect to $h_t$:**
$$\frac{\partial \mathcal{L}}{\partial h_t} = 0: \quad \frac{-\phi}{1-h_t} + \lambda_t w_t = 0$$

**FOC with respect to $b_t$:**
$$\frac{\partial \mathcal{L}}{\partial b_t} = 0: \quad -\lambda_t + \beta E_t[\lambda_{t+1}(1+r_t)] = 0$$

### Part (d): Euler Equation and Intratemporal Choice

**Euler Equation (Intertemporal Choice):**

From FOCs for $c_t$ and $b_t$:
$$\frac{1}{c_t} = \beta E_t \left[ \frac{1+r_t}{c_{t+1}} \right]$$

Or equivalently:
$$\frac{1}{c_t} = \beta E_t \left[ \frac{1+i_t}{(1+\pi_{t+1})c_{t+1}} \right]$$

**Interpretation:** The marginal utility of consuming one unit today equals the expected discounted marginal utility of saving that unit (earning interest) and consuming tomorrow. This governs the optimal allocation of consumption across time.

**Consumption-Labor (Intratemporal) Choice:**

From FOCs for $c_t$ and $h_t$:
$$\frac{\phi}{1-h_t} = \frac{w_t}{c_t}$$

Or: 
$$\frac{\phi c_t}{1-h_t} = w_t$$

**Interpretation:** The marginal rate of substitution between leisure and consumption equals the real wage. The household works until the marginal disutility of labor (in consumption units) equals the wage.

---

## Problem 3: Solow-Swan Model

### Given:
- $Y_t = A K_t^\alpha L_t^{1-\alpha}$
- $I_t = sY_t$
- $K_{t+1} = (1-\delta)K_t + I_t$
- $L_{t+1} = (1+n)L_t$

### Part (a): Per Worker Form

Define: $x_t \equiv \frac{X_t}{L_t}$ for any variable X.

**Production function per worker:**
$$y_t = \frac{Y_t}{L_t} = A \left(\frac{K_t}{L_t}\right)^\alpha = A k_t^\alpha$$

**Investment per worker:**
$$i_t = \frac{I_t}{L_t} = s \frac{Y_t}{L_t} = s y_t = s A k_t^\alpha$$

**Capital accumulation per worker:**

Starting from $K_{t+1} = (1-\delta)K_t + sY_t$, divide by $L_{t+1}$:
$$\frac{K_{t+1}}{L_{t+1}} = \frac{(1-\delta)K_t + sY_t}{L_{t+1}}$$

Since $L_{t+1} = (1+n)L_t$:
$$k_{t+1} = \frac{(1-\delta)K_t}{(1+n)L_t} + \frac{sY_t}{(1+n)L_t} = \frac{(1-\delta)k_t + sAk_t^\alpha}{1+n}$$

Or in terms of change:
$$\Delta k_{t+1} = \frac{sAk_t^\alpha - (\delta + n)k_t}{1+n}$$

Approximately (for small n):
$$\Delta k_{t+1} \approx sAk_t^\alpha - (\delta + n)k_t$$

### Part (b): Steady-State Capital per Worker

At steady state, $\Delta k = 0$:
$$sAk^{*\alpha} = (\delta + n)k^*$$

Solving for $k^*$:
$$sA(k^*)^{\alpha-1} = \delta + n$$

$$(k^*)^{\alpha-1} = \frac{\delta + n}{sA}$$

$$k^* = \left(\frac{sA}{\delta + n}\right)^{\frac{1}{1-\alpha}}$$

### Part (c): Effect of Technology Constant A

**Steady-state output per worker:**
$$y^* = A(k^*)^\alpha = A \left(\frac{sA}{\delta + n}\right)^{\frac{\alpha}{1-\alpha}} = A^{\frac{1}{1-\alpha}} \left(\frac{s}{\delta + n}\right)^{\frac{\alpha}{1-\alpha}}$$

**Conclusion:** Citizens in **high-A countries** will enjoy higher GDP per worker.

**Reasoning:**
1. Higher A directly increases output for any given level of capital
2. Higher A increases the steady-state capital per worker (numerator of $k^*$ increases)
3. Both effects work in the same direction, amplifying the positive impact
4. The exponent $\frac{1}{1-\alpha} > 1$ (since $0 < \alpha < 1$), so the effect of A on output is more than proportional

---

## Problem 4: Recursive General Equilibrium Model

### Part (a): Benchmark Growth Rates

Given:
- Labor endowment grows at rate g
- Depreciation rate δ
- Steady-state rate of return r
- Model calibrated correctly for steady-state

**Growth rate of real variables:** All real variables (output, consumption, investment) grow at rate **g** in the benchmark scenario.

**Production structure:** 
- Shares of different sectors remain **constant** over time
- Capital-labor ratio remains **constant** over time (capital grows at rate g to match labor growth)

This is because the economy follows a balanced growth path where all variables grow proportionally.

### Part (b): Persistent Increase in Government Consumption (g = 0)

#### Scenario 1: Financed by Lump-Sum Tax Increase

**Period 1:**
- Government consumption ↑
- Lump-sum taxes ↑ → Household disposable income ↓
- Household consumption ↓ (immediate crowding out)
- Investment may slightly decrease due to lower savings
- GDP effect: Neutral or slightly negative (government spending substitutes private consumption)

**Subsequent periods:**
- If investment falls, capital stock gradually decreases
- Lower capital → Lower output in future periods
- Economy settles at a lower steady-state level
- Household consumption remains permanently lower

#### Scenario 2: Financed by Budget Deficit

**Period 1:**
- Government consumption ↑
- No immediate tax increase → Household disposable income unchanged
- Household consumption relatively stable
- Investment ↓ significantly (government borrowing crowds out private investment)
- GDP may increase initially due to fiscal stimulus

**Subsequent periods:**
- Lower investment → Capital stock declines over time
- Interest rates rise due to government borrowing
- Growing debt burden requires future tax increases or spending cuts
- GDP eventually falls as capital accumulation slows
- Long-run effects worse than lump-sum tax financing due to distortionary effects of future taxation

---

## Problem 5: Ramsey Model - Fiscal Policy Effects

*(Note: This problem includes the answer in the exam document. I'm providing a structured summary.)*

### Given Steady-State Equations:
$$k^* = \left(\frac{\alpha}{\rho(1-\tau_\alpha)(1-\tau_{tf}) + \delta}\right)^{\frac{1}{1-\alpha}}$$
$$c^* = (k^*)^\alpha - \delta k^* - g$$

### Part (a): Increase in Consumption Tax (τc)

**Effect on k*:** Decreases
- Higher τc reduces disposable income
- Lower savings → Lower investment → Lower capital accumulation

**Effect on c*:** Decreases
- Lower k* means lower output
- Tax distortion reduces efficiency
- Net effect is negative even if revenue funds productive spending

### Part (b): Increase in Capital Tax (τa) with Transfers

**Effect on k*:** Decreases
- Higher capital tax reduces after-tax return on saving
- Discourages investment and capital accumulation
- Transfers don't offset because they're lump-sum (not tied to investment)

**Effect on c*:** Decreases
- Lower k* reduces steady-state output
- While transfers boost disposable income, they don't address the underlying distortion
- Long-run consumption falls due to lower capital stock

---

## Problem 6: Business Cycles Analysis

### Given Data:
| Variable | Std. Dev. | Corr. w. y | Autocorr. |
|----------|-----------|------------|-----------|
| Output (y) | 1.68 | 1.00 | 0.78 |
| Consumption (c) | 1.11 | 0.76 | 0.63 |
| Investment (i) | 4.48 | 0.77 | 0.86 |
| Wages (w) | 0.89 | -0.06 | 0.64 |

### Part (a): Volatility Rankings

**Lowest volatility:** Wages (w) with std. dev. = 0.89

**Highest volatility:** Investment (i) with std. dev. = 4.48

### Part (b): Consumption vs Output Volatility

Consumption has **lower volatility** than output (1.11 < 1.68).

**Economic argument - Consumption Smoothing:**
Households prefer smooth consumption paths over time. According to the permanent income hypothesis:
- Households base consumption on permanent (long-run average) income, not current income
- Temporary fluctuations in output are absorbed by savings/borrowing
- This results in consumption being less volatile than income/output

### Part (c): Procyclical vs Countercyclical

**Procyclical:** Variables that move in the same direction as output (positive correlation with y)
- **Consumption** (corr = 0.76): Procyclical
- **Investment** (corr = 0.77): Procyclical

**Countercyclical:** Variables that move in the opposite direction to output (negative correlation with y)
- **Wages** (corr = -0.06): Essentially **acyclical** (nearly zero correlation)

Note: Wages show almost no correlation with output, making them effectively acyclical rather than clearly countercyclical.

---

## Problem 7: New Keynesian Model - Shocks

### Given 3-Equation Model:
- **NKPC:** $\pi_t = \beta E_t \pi_{t+1} + \kappa x_t + \varepsilon_t^\pi$
- **IS curve:** $x_t = E_t x_{t+1} - \frac{1}{\sigma}(i_t - E_t \pi_{t+1} - r_t^*) + \varepsilon_t^x$
- **Taylor rule:** $i_t = \rho_i i_{t-1} + (1-\rho_i)[\gamma_\pi(\pi_t - \pi^*) + \gamma_x x_t] + \varepsilon_t^i$

### Part (a): Positive Demand Shock ($\varepsilon_t^x > 0$)

**Immediate effects (period t):**
- **Output gap (x):** ↑ Increases (direct effect of shock)
- **Inflation (π):** ↑ Increases (via NKPC: higher x → higher π)
- **Interest rate (i):** ↑ Increases (Taylor rule responds to higher π and x)

**Subsequent periods:**
- Higher interest rate dampens demand, gradually reducing x
- As x falls, inflation pressures subside
- Economy returns to steady state as shock dissipates
- Speed of return depends on persistence of shock and policy parameters

### Part (b): Contractionary Monetary Policy Shock ($\varepsilon_t^i > 0$)

**Immediate effects (period t):**
- **Interest rate (i):** ↑ Increases (direct effect)
- **Output gap (x):** ↓ Decreases (higher real rate reduces demand via IS curve)
- **Inflation (π):** ↓ Decreases (via NKPC: lower x → lower π)

**Subsequent periods:**
- Lower inflation feeds back into lower expected inflation
- Lower expected inflation reduces actual inflation further
- As shock dissipates, interest rate normalizes
- Economy gradually returns to steady state
- Output and inflation recover

---

## Problem 8: CGE Model - Income Tax Increase

### Model Setup:
- 1 household, 2 goods (A, B), 2 factors (K, L)
- Cobb-Douglas production and utility functions
- Good A is more capital-intensive than B
- Utility shares: 0.5 for each good
- Government spending: 0.2 on A, 0.8 on B
- Investment technology: 0.8 on A, 0.2 on B
- Savings-driven investment
- 20% increase in income tax rate

### Effects of 20% Income Tax Increase:

**Part (a): Government Revenues and Budget**
- **Revenues:** Initially increase (higher tax rate × tax base)
- However, tax base shrinks as economic activity contracts
- Net effect on revenues: Likely positive but less than proportional to rate increase
- **Budget:** Moves toward surplus (since G is fixed)

**Part (b): Level of Investment**
- **Investment decreases**
- Higher taxes reduce household disposable income
- Lower income → Lower savings (fixed savings rate)
- Lower savings → Lower investment

**Part (c): Production and Prices**
- **Production of A:** Decreases more (capital-intensive, investment demand falls)
- **Production of B:** Decreases less
- **Price of A:** Increases relative to B (lower supply of A)
- **Price of B:** May decrease or increase less than A
- Overall: Reallocation toward less capital-intensive production

**Part (d): Utility of Households**
- **Utility decreases**
- Lower disposable income reduces consumption possibilities
- Both goods become less affordable
- Welfare unambiguously falls

---

## Problem 9: New Keynesian Model - Energy and Tax Shocks

### Part (a): Energy Price Increase (Oil Price Shock)

**Type of shock:** **Supply shock** (cost-push shock, $\varepsilon_t^\pi > 0$)

**Immediate effects (period t):**
- **Inflation (π):** ↑ Increases directly (cost-push)
- **Output gap (x):** ↓ Decreases (stagflation: higher costs reduce output)
- **Interest rate (i):** ↑ Increases (central bank responds to inflation)

**Subsequent periods:**
- Central bank faces trade-off between fighting inflation and supporting output
- If aggressive on inflation: Output falls more, inflation controlled faster
- If accommodative: Output recovers faster, inflation persists longer
- Eventually returns to steady state, but adjustment can be slow

**Key feature:** Supply shocks create policy dilemma (stagflation)

### Part (b): Income Tax Cut

**Type of shock:** **Demand shock** ($\varepsilon_t^x > 0$)

**Immediate effects (period t):**
- **Output gap (x):** ↑ Increases (higher disposable income → higher consumption)
- **Inflation (π):** ↑ Increases (demand-pull inflation via NKPC)
- **Interest rate (i):** ↑ Increases (Taylor rule responds)

**Subsequent periods:**
- Higher interest rate partially offsets fiscal stimulus
- Crowding out effect reduces private investment
- Economy eventually returns to steady state
- Long-run neutrality: Real variables return to original levels

---

## Problem 10: Utility Maximization with Leisure

### Given:
$$U(x, L) = x^\beta L^{1-\beta}$$
where x is consumption, L is leisure, $\bar{L}$ is total time endowment.

Budget constraint: $px = w(\bar{L} - L)$ where $(\bar{L} - L)$ is labor supply.

### Part (a): Walrasian Demand for Consumption Good x

**Maximize:** $U = x^\beta L^{1-\beta}$ subject to $px + wL = w\bar{L}$

**Lagrangian:**
$$\mathcal{L} = x^\beta L^{1-\beta} + \lambda(w\bar{L} - px - wL)$$

**FOCs:**
$$\frac{\partial \mathcal{L}}{\partial x} = \beta x^{\beta-1} L^{1-\beta} - \lambda p = 0$$
$$\frac{\partial \mathcal{L}}{\partial L} = (1-\beta) x^\beta L^{-\beta} - \lambda w = 0$$

**Dividing FOCs:**
$$\frac{\beta L}{(1-\beta)x} = \frac{p}{w}$$

**From budget constraint and optimality:**
$$x^* = \frac{\beta w \bar{L}}{p}$$

### Part (b): Labor Supply

Labor supply $= \bar{L} - L^*$

From the optimality condition:
$$L^* = \frac{(1-\beta) w \bar{L}}{w} = (1-\beta)\bar{L}$$

**Labor supply:**
$$N^s = \bar{L} - L^* = \bar{L} - (1-\beta)\bar{L} = \beta \bar{L}$$

**Note:** With Cobb-Douglas utility, labor supply is **constant** at $\beta \bar{L}$, independent of w and p. This is because income and substitution effects exactly offset.

---

## Problem 11: Two-Period Consumption Model

### Given:
$$\max U = \ln c_t + \beta \ln c_{t+1}$$
Subject to:
- $c_t + a_{t+1} = y_t$
- $c_{t+1} = (1+r)a_{t+1} + y_{t+1}$

### Part (a): First-Order Conditions

**Lagrangian:**
$$\mathcal{L} = \ln c_t + \beta \ln c_{t+1} + \lambda_1(y_t - c_t - a_{t+1}) + \lambda_2((1+r)a_{t+1} + y_{t+1} - c_{t+1})$$

**FOCs:**
$$\frac{\partial \mathcal{L}}{\partial c_t} = \frac{1}{c_t} - \lambda_1 = 0 \Rightarrow \lambda_1 = \frac{1}{c_t}$$

$$\frac{\partial \mathcal{L}}{\partial c_{t+1}} = \frac{\beta}{c_{t+1}} - \lambda_2 = 0 \Rightarrow \lambda_2 = \frac{\beta}{c_{t+1}}$$

$$\frac{\partial \mathcal{L}}{\partial a_{t+1}} = -\lambda_1 + \lambda_2(1+r) = 0$$

**Euler equation:**
$$\frac{1}{c_t} = \beta(1+r)\frac{1}{c_{t+1}}$$

$$c_{t+1} = \beta(1+r)c_t$$

### Part (b): Optimal Consumption

**Lifetime budget constraint:**
$$c_t + \frac{c_{t+1}}{1+r} = y_t + \frac{y_{t+1}}{1+r}$$

Substitute $c_{t+1} = \beta(1+r)c_t$:
$$c_t + \frac{\beta(1+r)c_t}{1+r} = y_t + \frac{y_{t+1}}{1+r}$$

$$c_t(1 + \beta) = y_t + \frac{y_{t+1}}{1+r}$$

**Optimal period-t consumption:**
$$c_t^* = \frac{1}{1+\beta}\left(y_t + \frac{y_{t+1}}{1+r}\right)$$

**Optimal period-t+1 consumption:**
$$c_{t+1}^* = \frac{\beta(1+r)}{1+\beta}\left(y_t + \frac{y_{t+1}}{1+r}\right)$$

### Part (c): Effect of Increase in $y_t$

**Effect on $c_t$:**
$$\frac{\partial c_t^*}{\partial y_t} = \frac{1}{1+\beta} > 0$$

Consumption in period t **increases**, but by less than the full increase in income.

**Effect on savings $a_{t+1}$:**
$$a_{t+1} = y_t - c_t = y_t - \frac{1}{1+\beta}\left(y_t + \frac{y_{t+1}}{1+r}\right)$$

$$\frac{\partial a_{t+1}}{\partial y_t} = 1 - \frac{1}{1+\beta} = \frac{\beta}{1+\beta} > 0$$

Savings **increase**.

**Intuition:** Consumers smooth consumption across periods. An increase in current income is partially consumed and partially saved to increase future consumption.

---

## Problem 12: RBC Model

### Given:
$$\max U = E_0\left[\sum_{t=0}^{\infty} \beta^t \ln c_t\right]$$
Subject to: $c_t + k_{t+1} = z_t k_t^\alpha + (1-\delta)k_t$

Technology: $\ln z_t = \rho_z \ln z_{t-1} + \varepsilon_t$

### Part (a): First-Order Conditions

**Lagrangian:**
$$\mathcal{L} = E_0\sum_{t=0}^{\infty} \beta^t \left[\ln c_t + \lambda_t(z_t k_t^\alpha + (1-\delta)k_t - c_t - k_{t+1})\right]$$

**FOC with respect to $c_t$:**
$$\frac{1}{c_t} = \lambda_t$$

**FOC with respect to $k_{t+1}$:**
$$\lambda_t = \beta E_t[\lambda_{t+1}(\alpha z_{t+1} k_{t+1}^{\alpha-1} + 1 - \delta)]$$

**Euler equation:**
$$\frac{1}{c_t} = \beta E_t\left[\frac{1}{c_{t+1}}(\alpha z_{t+1} k_{t+1}^{\alpha-1} + 1 - \delta)\right]$$

### Part (b): Steady State

At steady state: $z = 1$ (log of z = 0), $c_t = c_{t+1} = c^*$, $k_t = k_{t+1} = k^*$

**From Euler equation:**
$$1 = \beta(\alpha (k^*)^{\alpha-1} + 1 - \delta)$$

$$\alpha (k^*)^{\alpha-1} = \frac{1}{\beta} - 1 + \delta = \frac{1-\beta+\beta\delta}{\beta}$$

$$(k^*)^{\alpha-1} = \frac{1-\beta(1-\delta)}{\alpha\beta}$$

$$k^* = \left(\frac{\alpha\beta}{1-\beta(1-\delta)}\right)^{\frac{1}{1-\alpha}}$$

**Steady-state consumption:**
$$c^* = (k^*)^\alpha + (1-\delta)k^* - k^* = (k^*)^\alpha - \delta k^*$$

### Part (c): Response to Positive Productivity Shock

Given: $c_t = (1-\alpha\beta)z_t k_t^\alpha$ and $k_{t+1} = \alpha\beta z_t k_t^\alpha$

**With a positive shock ($z_t$ increases):**

**Consumption response:**
$$c_t = (1-\alpha\beta)z_t k_t^\alpha$$
- Consumption **increases** proportionally to the productivity shock
- Higher productivity means more output available for consumption

**Investment response:**
$$i_t = k_{t+1} - (1-\delta)k_t = \alpha\beta z_t k_t^\alpha - (1-\delta)k_t$$
- Investment **increases** (since $k_{t+1}$ increases with $z_t$)
- Positive productivity shock raises the marginal product of capital
- Higher returns encourage more investment

**Intuition:** A positive productivity shock increases total output. With the given policy rules, the household optimally splits the extra output between consumption and investment in fixed proportions. Both increase immediately in response to the shock.

---

## Summary of Key Formulas

| Model | Key Equation |
|-------|--------------|
| Solow Steady State | $k^* = \left(\frac{sA}{\delta+n}\right)^{\frac{1}{1-\alpha}}$ |
| Euler Equation | $\frac{1}{c_t} = \beta(1+r)E_t\left[\frac{1}{c_{t+1}}\right]$ |
| NKPC | $\pi_t = \beta E_t\pi_{t+1} + \kappa x_t$ |
| NK IS | $x_t = E_t x_{t+1} - \frac{1}{\sigma}(i_t - E_t\pi_{t+1} - r^*)$ |
| Taylor Rule | $i_t = \rho_i i_{t-1} + (1-\rho_i)[\gamma_\pi\pi_t + \gamma_x x_t]$ |
