---
course: Advanced Econometrics
lecture: "01"
topic: Introduction, variable types & coefficient interpretation
lecturers: Chlebus, Woźniak (WNE UW)
tags: [econometrics/AE, lecture-notes, intro, interpretation]
---

# AE — Lecture 01: Introduction

The first lecture sets up the whole course: what kind of **data** and **dependent variable** you face dictates which **model** you use. It also drills the single most exam-relevant skill — reading a coefficient correctly depending on the functional form.

## 1. Course logistics (quick reference)

- Grade = 20% short tests + 40% empirical project + 40% final exam. Must pass both the project and the exam.
- Project: R code + Word report, deadline **31.05.2026**.
- Exam: **90 minutes, 3 empirical problems** with subpoints. Pass mark 50%; scale rises to 5.0 at 90%.

> [!tip] You may bring **one handwritten A4 sheet** to the exam.
> This is the payoff of these notes — the cheat sheet should hold the model-selection map (§4), the interpretation rules (§5), the exact semi-elasticity formula, the Hausman/ADF/KPSS decision rules, and the $(1-\rho)$ multiplier formula. Everything else you can reconstruct.

## 2. Data types

- **Cross-sectional** — many units, one point in time ($i = 1,\dots,N$).
- **Time series** — one unit, observed over time ($t = 1,\dots,T$).
- **Panel (longitudinal)** — many units followed over time ($i,t$); the structure is a stacked `unit × year` table (e.g. `firm | year | output | labor | …`).

## 3. Variable types

- **Continuous** — any value in an interval (income, GDP). Standard OLS territory.
- **Discrete** — countable values.
- **Quantitative** — numeric meaning (counts, amounts).
- **Qualitative** — categories, split into:
  - **Ordered** — categories have a natural ranking (e.g. customer satisfaction: *strongly dissatisfied → neutral → very satisfied*).
  - **Unordered** — no ranking (e.g. colour, brand, make).
- **Limited / censored / truncated (LDV)** — the dependent variable is restricted to a range, e.g. $y \in [0,+\infty)$ (expenditures, never negative) or $y \in [a,b)$. These break OLS and motivate Tobit, count, and binary models.

> [!note] The course's organising idea
> Most of the syllabus is "what to do when the **dependent variable** is not a clean continuous number." The shape of $y$ chooses the model.

## 4. Model-selection map (the core skill)

This is exactly the page-7 exercise ("which model should be chosen?") and recurs implicitly on every exam.

| Dependent variable / situation | Model | Course topic |
|---|---|---|
| Continuous, well-behaved | OLS | — |
| Binary, $y \in \{0,1\}$ | **Logit / Probit** (estimated by Maximum Likelihood) | L3 |
| Ordered categories | **Ordered logit / probit** | L4 |
| Unordered categories | **Multinomial / Conditional logit** | L5 |
| Count, $y \in \{0,1,2,\dots\}$ | **Poisson / Negative Binomial** (+ ZIP/ZINB for excess zeros) | L6 |
| Censored / corner, $y \in [0,\infty)$ | **Tobit** (censored regression) | L7 |
| Panel structure ($i,t$) | **Fixed / Random effects** | L1–2, L15 |
| One series, forecasting | **ARMA / ARIMA** (forecasting only) | L12 |
| Relationship with lags / dynamics | **DL / ARDL** | L11 |
| Non-stationary, trending series sharing a long-run relationship | **Cointegration / ECM** | L13 |
| Endogenous regressor ($\mathrm{Cov}(x,\varepsilon)\neq 0$) | **Instrumental variables** | L14 |

Decision shortcuts: *is $y$ limited?* → which LDV model. *Time series?* → one series (ARIMA) vs relationships (ARDL/cointegration). *Endogeneity suspected?* → IV.

## 5. Functional forms & coefficient interpretation

Let the model be $g(y) = \beta_0 + \beta_1 f(x) + \varepsilon$. The interpretation of $\beta_1$ depends entirely on whether $y$ and $x$ are in levels or logs.

| Form | Specification | $\beta_1$ means | Read as |
|---|---|---|---|
| Level–level | $y = \beta_0 + \beta_1 x$ | marginal effect | $+1$ unit of $x$ → $+\beta_1$ units of $y$ |
| Log–log | $\ln y = \beta_0 + \beta_1 \ln x$ | **elasticity** | $+1\%$ of $x$ → $+\beta_1\%$ of $y$ |
| Log–level (semi-log) | $\ln y = \beta_0 + \beta_1 x$ | **semi-elasticity** | $+1$ unit of $x$ → $\approx (100\beta_1)\%$ of $y$ |
| Level–log | $y = \beta_0 + \beta_1 \ln x$ | — | $+1\%$ of $x$ → $+\beta_1/100$ units of $y$ |

### Log–level: exact vs approximate semi-elasticity

For a one-unit change in $x$ (or a dummy switching $0\to1$) in a log-dependent model, the **exact** percentage change in $y$ is

$$\Delta\% y = \left(e^{\beta_1} - 1\right)\cdot 100\%.$$

The familiar $\beta_1 \cdot 100\%$ is only a **first-order approximation**, good when $|\beta_1|$ is small (rule of thumb $|\beta_1| \lesssim 0.1$). For large coefficients it breaks down badly.

> [!warning] The dummy-in-logs trap (military-expenses example)
> $\ln(\text{ARMY}) = 1.284 + 0.005\ln(\text{GDP}) - 0.01\ln(\text{POP}) - 1.10\,\text{noSEA}$.
> The naive reading of `noSEA` is "$-1.10\times100 = -110\%$", which is **impossible** (you cannot spend $110\%$ less). Use the exact formula:
> $$(e^{-1.10}-1)\cdot 100\% = (0.3329-1)\cdot 100\% \approx -66.7\%.$$
> Landlocked countries spend about **67% less** on the military, all else equal.

## 6. Percents vs percentage points

A constant source of lost marks — keep them distinct.

- A **percentage point (pp)** is an additive change in a rate. From $2\%$, "$+1$ pp" → $3\%$.
- A **percent (%)** is a relative (multiplicative) change. From $3\%$, "$+50\%$" → $3\% \times 1.5 = 4.5\%$.
- A **basis point** $= 0.01$ pp.

So when the dependent variable is itself a rate (unemployment, inflation, an interest rate), state explicitly whether a coefficient moves it by points or by a relative percentage.

## 7. Worked examples from the slides

### Food expenditure (functional-form drill)
- **Type I (level–level):** $\text{food} = 463.95 + 0.079\,\text{income}$ → one extra unit of income raises food spending by $0.079$ units.
- **Type II (log–log):** $\ln(\text{food}) = 3.697 + 0.357\ln(\text{income})$ → income **elasticity** of food is $0.357$ ($+1\%$ income → $+0.357\%$ food).
- **Eq. (3), `ln(kids)`:** coefficient $0.01$ is the elasticity w.r.t. number of kids ($+1\%$ kids → $+0.01\%$ food).
- **Type III, `kids` in levels:** $\ln(\text{food}) = \dots + 0.114\,\text{kids}$ → **semi-elasticity**: one more kid raises food spending by $(e^{0.114}-1)\cdot100 \approx 12.1\%$ (approx. $11.4\%$).
- **Type IV (time-series rates):** $\text{unmpl} = 0.011 - 0.247\,\text{gdp} - 0.310\,\text{cpi}$ → here every variable is a rate, so mind §6 when stating effects.

### Military expenses (log–log + dummy)
- $\ln(\text{GDP})$ coeff $0.005$ = elasticity: $+1\%$ GDP → $+0.005\%$ ARMY (highly inelastic).
- $\ln(\text{POP})$ coeff $-0.01$: $+1\%$ population → $-0.01\%$ ARMY.
- `noSEA` dummy: exact effect $\approx -66.7\%$ (see warning above).

### Household medical expenditure (LDV framing)
- Question: *what determines household medical spending?* Candidate determinants: number of people, number of diseases, average age, number of children, persons aged 65+, income, whether the household has medical insurance, costs.
- Key point: spending is **$y \in [0,+\infty)$** — a limited dependent variable. OLS is inappropriate; this is the kind of problem that motivates censored/Tobit-style treatment later in the course.

---

## Key formulas to memorise

$$\text{exact semi-elasticity} = (e^{\beta}-1)\cdot100\%, \qquad \text{approx (small } \beta\text{)} = \beta\cdot100\%.$$

- Log–log coefficient = **elasticity**; log–level coefficient = **semi-elasticity**.
- Approximation valid for $|\beta|\lesssim 0.1$; otherwise use the exact form.
- Percentage **points** ≠ **percent**; basis point $= 0.01$ pp.
- The dependent variable's nature (binary / ordered / unordered / count / censored / panel / time-series) selects the model — §4.
