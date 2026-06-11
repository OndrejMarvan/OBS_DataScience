---
exam: Advanced Econometrics — September 2, 2024
tags: [econometrics/AE, exam-solutions, DL-ARDL, count-data, ordered-logit]
---

# AE Exam — September 2, 2024 — Worked Solutions

> (1) **gfr DL models & stationarity** (new), (2) hot-dog Poisson *(identical to the 2023-Sept paper)*, (3) inheritance-tax ordered logit *(identical to the 2023-Sept paper)*. α = 5%.

---

## Exercise 1 (40%) — Fertility (gfr) distributed-lag models. α = 5%
Wooldridge `fertil3`, 1913–1984. `gfr` = general fertility rate; `pe` = real value of the personal tax exemption; `ww2` (1941–45) and `pill` (1963+) are dummies. Models (1)–(5); see the quality table.

**a) (5%) Why does `gfr` react to `pe` with a lag?** Fertility decisions take time to respond to financial incentives: a change in the tax exemption is perceived, then acted on through family-planning decisions and the ~9-month gestation lag, plus general behavioural inertia. So a change in `pe` this year influences births over **several subsequent years**, not just the current one — which is exactly what a distributed-lag specification captures.

**b) (5%) Which are DL and which are ARDL?** **All of (1)–(5) are DL/static — none are ARDL.** The decisive criterion: an **ARDL** must contain **lagged values of the dependent variable** (`L(gfr)`). No model here does. Specifically:
- **(1) and (5):** *static* (only contemporaneous `pe`, or no `pe` at all) — DL with zero lags.
- **(2):** *distributed lag* — `pe`, `pe₋₁`, `pe₋₂`.
- **(3) and (4):** *distributed lag* with a single lag of `pe`.
None include lagged `gfr` ⇒ **none are ARDL**.

**c) (5%) Superior model?** Compare by **adjusted R²** / residual SE (models aren't all nested, so use IC-type criteria, not raw R²). Adjusted R²: (1) 0.450, (2) 0.459, (3) 0.458, **(4) 0.472**, (5) 0.396; residual SE lowest for (4) at 14.104. **Model (4) is superior** — best fit with the fewest wasted parameters.

**d) (10%) Long-term multiplier for model (2).** Model (2) is a **pure DL** (no lagged `gfr`), so the long-run multiplier is simply the **sum of the `pe` coefficients — no $(1-\sum\alpha)$ denominator** (there are no lagged-`gfr` terms):
$$\beta_{LR} = 0.073 + (-0.006) + 0.034 = \mathbf{0.101}.$$
**Interpretation:** a *permanent* one-dollar rise in the personal tax exemption is associated with a long-run increase of about **0.101** in the fertility rate (births per 1,000 women), holding `ww2` and `pill` fixed. (The individual lag coefficients are insignificant due to multicollinearity, but the **joint F-test** `linearHypothesis` gives F=3.973, **p=0.0117 → the three `pe` terms are jointly significant** at 5%.)

**e) (5%) Interpret `pe`ₜ in model (2).** Coefficient **0.073 (se 0.126, insignificant)** — the **short-run / impact multiplier**: a one-dollar rise in the *current* exemption is associated with a 0.073 rise in `gfr` *the same year*, but it is **statistically insignificant** — it can't be distinguished from zero, a direct consequence of the strong multicollinearity among `pe`, `pe₋₁`, `pe₋₂`.

**f) (10%) Validity given the stationarity results.** `gfr` is **non-stationary**: testdf at the first clean-BG augmentation (aug2) gives ADF = −1.600, **p=0.103 → fail to reject the unit root**; on the difference, **KPSS = 0.182 < 0.463** and **PP = −6.069 < −2.903** → the difference is stationary. So **`gfr` ~ I(1)**. Regressing an I(1) `gfr` on `pe` **in levels** therefore risks a **spurious regression**: the high R² and significant t-statistics may be unreliable unless `gfr` and `pe` are **cointegrated**. The estimates should be treated cautiously — one should test for cointegration (and/or estimate in first differences); much of `pill`/`ww2`'s apparent strength reflects deterministic level shifts rather than a stationary relationship.

---

## Exercise 2 (30%) — Hot-dog eating: Poisson count. α = 5%
*Identical to the 2023-September paper — see `AE_2023_September_Solutions.md` for the full write-up. Summary:*
`y` (hot dogs) ~ `ever_champion` + `bmi` + `neck` + `exper`, Poisson.

- **a) IRRs:** ever_champion +15.8% (e^0.146), bmi +21.2% (e^0.192), **neck −5.4%** (e^−0.0556), exper +9.8% (e^0.093) — all significant; interpret as % change in expected count, not pp.
- **b) Neck hypothesis** (shorter → more): test sign+significance of `neck`. Coefficient **−0.0556, z=−18.56, p<2e-16** → negative and significant → **supports** "shorter neck ⇒ more hot dogs."
- **c) Other models:** Negative Binomial (residual deviance 7766/995 df ≈ **7.8 ⇒ strong overdispersion**, so NegBin is the natural alternative), and ZIP/ZINB or hurdle if excess zeros.
- **d) Extra variable:** any justified capacity/physiology measure not already included (e.g. **sex/gender, height/weight, stomach or torso size, training intensity**), not collinear with current regressors.
- **e) Add `neck²` — LR test:** LL_restricted = −213.1799, LL_unrestricted = −212.5207. **LR = −2(−213.1799 − (−212.5207)) = 1.318**, df=1; χ²(1,.95) = 3.841. **1.318 < 3.841 → fail to reject → keep the ORIGINAL model** (the quadratic term adds nothing significant).

---

## Exercise 3 (30%) — Inheritance & gift tax: ordered logit. α = 5%
*Identical to the 2023-September paper — see `AE_2023_September_Solutions.md`. Summary:*
Dependent = tax-design type (0–3, ordered). Models (1)–(4).

- **a) Ordered logit appropriate?** Yes — the dependent variable is **ordered** (0=no tax … 3=progressive with exemptions) but the gaps aren't cardinal, so OLS (assumes equal spacing) and multinomial (discards order) are both wrong; ordered logit uses the ranking correctly.
- **b) Significant in model (1) at 5%:** **75+ share (281.55***), Aging ratio (−15.79***), Big countries (15.82***)**. (Life expectancy −0.61* is only significant at 10%, so *not* at 5%.)
- **c) Superior model:** **model (1)** — lowest **AIC (403.6)** *and* lowest **BIC (460.2)**.
- **d) Verify Hypothesis 4** (taxation depends *positively* on elderly-to-young ratio = `Aging ratio`): test sign+significance. `Aging ratio` = **−15.79*** (negative & significant)** → the effect is opposite to predicted → **H4 is NOT supported**.
- **e) Verify Hypothesis 5** (Big countries tax more): `Big countries` = **+15.82*** (positive & significant)** → **H5 supported**.
- **f) Diagnostic tests for ordered models:** Brant test (parallel-regression / proportional-odds), Lipsitz test, Hosmer–Lemeshow, Pulkstenis–Robinson, the LR joint-significance test, McFadden pseudo-R², AIC/BIC, and hit-rate/confusion matrix.

---

## Quick reference
| Ex | Answer in one line |
|---|---|
| 1b | **All DL/static; none ARDL** (no lagged `gfr`) |
| 1c | **Model (4)** — highest adjusted R² (0.472) |
| 1d | LRM = Σβ = **0.101** (pure DL, no denominator); joint F p=0.012 |
| 1e | `pe`ₜ = 0.073 **insignificant** (multicollinearity) — impact multiplier |
| 1f | `gfr` is **I(1)** ⇒ levels regression risks **spurious**; check cointegration |
| 2e | LR = 1.318 < 3.841 ⇒ **keep original** (drop `neck²`) |
| 3c | **Model (1)** — lowest AIC & BIC |
| 3d/3e | Aging ratio − ⇒ **H4 rejected**; Big + ⇒ **H5 supported** |
