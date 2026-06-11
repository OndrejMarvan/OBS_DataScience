---
exam: Advanced Econometrics — June 17, 2024
tags: [econometrics/AE, exam-solutions, cointegration, count-data, panel]
---

# AE Exam — June 17, 2024 — Worked Solutions

> Three exercises: (1) cointegration ECM, (2) count data, (3) panel FE/RE. α as stated per exercise.

---

## Exercise 1 (40%) — Divorce rate vs "worked-to-death": cointegration & ECM
Variables: `div_rate`, `work_to_death`, 1990Q1–2022Q4 (n=132). Critical value for the cointegration test = **−2.50** (given).

**Reading the integration orders first.**
- `work_to_death` (testdf, "nc"): pick the **smallest augmentation with all Breusch–Godfrey p>0.05**. aug0 (BG.1 p=0.0001) and aug1 (BG.2 p=0.006) are dirty; **aug2 is the first clean row** → ADF = **−1.245, p=0.154 → fail to reject unit root → non-stationary**. On the **difference**, aug1 is clean → ADF = −11.25, p=0.01 → stationary. So **`work_to_death` ~ I(1)**.
- `div_rate`: **PP** Z-tau = 0.4607 > −2.892 (5%) → fail to reject → **non-stationary**; **KPSS on the difference** = 0.2267 < 0.463 (5%) → fail to reject stationarity → difference stationary. So **`div_rate` ~ I(1)**.

Both **I(1)** ✓ — cointegration is possible.

**a) (5%) Two scales — good idea?** Reasonable: the two series are on very different units and magnitudes (a count ~10–25 vs a rate ~8–18%), so a single scale would flatten one series into an unreadable line. **But** dual-scale plots must be read with caution — by independently rescaling each axis you can manufacture apparent co-movement between unrelated series, so the plot is *suggestive*, not evidence.

**b) (5%) Does visual inspection prove cointegration?** **No.** A plot can never prove cointegration. The visible co-movement (both drifting down after ~2003) only *motivates* a formal test; it could equally be two independently trending I(1) series (spurious). Proof requires: (i) confirming both are I(1), (ii) testing residual stationarity with the proper cointegration critical values.

**c) (10%) Are they cointegrated?** **Yes.**
1. Both series are **I(1)** (shown above).
2. Cointegrating regression `div_rate ~ work_to_death`: slope **1.263***** (t=39.99), R²=0.925.
3. Residual ADF (testdf "nc"): aug0 has BG.4 p=0.030 (dirty); **aug1 is the first clean row → residual ADF = −2.649**. Compare to the **cointegration critical value −2.50** (NOT the standard ADF table): −2.649 < −2.50 → **reject the unit root in the residuals → residuals stationary → COINTEGRATED**.

**d) (10%) Interpret the ECM.** `Δdiv_rate = 1.252·Δwork_to_death − 0.143·lresid` (no intercept).
- **Δwork_to_death = 1.252*** — short-run effect**: a one-unit rise in the *change* of `work_to_death` raises the *change* in `div_rate` by 1.252 the same quarter.
- **lresid = −0.143*** — speed of adjustment** (error-correction term): **negative and significant**, exactly as required. About **14.3% of any deviation from the long-run equilibrium is corrected each quarter**; the negative sign means the system self-corrects back toward equilibrium. A significant, correctly-signed error-correction term is itself confirmation of cointegration.
- Long-run relation (from the levels regression): `div_rate = −0.109 + 1.263·work_to_death`.

**e) (10%) Real or spurious?** **Real (not spurious).** Although both series are I(1) and R²=0.925 (which *would* be the spurious-regression warning sign), the residuals are **stationary** (ADF −2.649 < −2.50) and the **ECM term is negative and significant** — the hallmarks of genuine cointegration. The high R² is therefore justified, not a mirage. *Caveat worth a sentence:* cointegration is a statistical property, not proof of economic causation — given the deliberately absurd pairing, the two series likely share a common societal trend rather than a direct causal link, but econometrically the relationship is real.

---

## Exercise 2 (30%) — Number of kids: count models. α = 10%
Models: `pois1/pois2` (Poisson), `nbreg1/nbreg2` (NegBin), `zip`. Regressors: `ln_income`, `age_head`, `tenure`, (`cars` in the "1" models).

**a) (5%) Interpret pois2.** Poisson → effects are multiplicative on the expected count (IRR = e^β).
- `ln_income` 0.103***: income enters in logs, so this is an **elasticity** — a 1% rise in income raises the expected number of kids by ~0.103%.
- `age_head` 0.059***: e^0.059 = 1.061 → each extra year of (head's age − 21) → **+6.1%** expected kids.
- `tenure` 0.016* (sig at 10%): e^0.016 = 1.016 → each extra year together → **+1.6%** expected kids.
All positive; `ln_income` and `age_head` strongly significant, `tenure` marginal at 10%.

**b) (5%) Excess zeros?** **No.** The **score test for zero inflation**: χ² = 0.196, df=1, **p = 0.658 > 0.10** → fail to reject H₀ of no excess zeros. A zero-inflated model is **not** justified. (The `ks.test` rejecting plain-Poisson fit is a different, broader question — the dedicated zero test is the relevant one here.)

**c) (5%) Over/under-dispersion?** **No overdispersion.** `lrtest(pois1, nbreg1)`: χ² = 0.0011, **p = 0.973** → fail to reject H₀: α=0 → the NegBin does not improve on Poisson → **no overdispersion** (equidispersion is consistent with the data).

**d) (5%) Best model?** Naïvely `zip` has the **lowest AIC (3732.7)** — but that's the trap. The zero-inflation test (p=0.66) and the overdispersion test (p=0.97) both say **ZIP and NegBin are unjustified**. So choose a **Poisson** model. By **BIC** (which penalises the extra parameters), **pois1 is lowest (3753.5)**; since `cars` is insignificant, the parsimonious **pois2** is an equally defensible Poisson. **Bottom line: a Poisson model — not ZIP/NegBin.** *Lesson: don't pick the lowest AIC blindly; the diagnostics must justify the complexity.*

**e) (10%) Does the ordered logit give the same conclusions as the count models?** **Yes (qualitatively).** Ordered logit: `ln_income` 0.288* (sig 5%), `age_head` 0.178*** (sig), `tenure` 0.043 (sig at 10%, p=0.090). Poisson pois2: same **signs**, same **significance pattern** (income & age clearly significant, tenure marginal at 10%). The **magnitudes differ** (different parameterisations, not comparable directly), but the **directional and significance conclusions agree** at α=10%.

---

## Exercise 3 (30%) — Constitutional compliance: panel FE/RE. α = 5%
`cc_total` ~ political vars. model1/model2 = **FE**, model3/model4 = **RE**. model1/3 = sparse (Democracy, Populism, years); model2/4 = full controls.

**a) (5%) Interpret model1 (FE).** Within-country effects:
- `Democracy` 0.332***: becoming a democracy raises compliance by 0.332 (significant).
- `Populism` 0.067 (ns): no significant effect.
- `years` −0.004 (ns): years in office has no significant effect.
Being FE, these are *within-country* changes, and time-invariant variables would be dropped.

**b) (5%) Hausman conclusions.** `phtest(model1,model3)`: χ²=60.22, df=3, **p=2.2e-16 → reject → FE** (over RE). `phtest(model2,model4)`: χ²=23.34, df=12, **p=0.025 < 0.05 → reject → FE**. **Both favour fixed effects** — the individual effects are correlated with the regressors, so RE would be inconsistent. *(Ignore the `data: prod~area+labor+fert` line — a copy-paste artifact; the χ²/df/p are what matter.)*

**c) (10%) Superior model?** Hausman → **FE**, so choose between model1 and model2. **model2 (full FE)** is superior: its **within-R² jumps to 0.366** (vs 0.042 for model1), and it adds several strongly significant regressors — `Anti-pluralism` −0.380***, `Polarization` −0.112***, `Civil_soc` 1.34***, `Legit_leader` −0.146***. So model2 explains far more within-country variation with meaningful added controls.

**d) (5%) Verify Hypothesis 2** ("term length is *not* a significant predictor"). Test the significance of **`years`**. In the chosen FE model2, `years` = −0.0012 (ns) (also ns in model1) → **fail to reject β=0 → `years` is insignificant → H2 is supported**. (Ideally also test a Populism×years interaction, since the hypothesis concerns *populist* governments' tenure.)

**e) (5%) Verify Hypothesis 3** ("more anti-pluralism → lower compliance" → expect negative). Test sign & significance of **`Anti-pluralism`**: in model2 it is **−0.380*** (negative, significant at 1%) → **reject β=0 in favour of negative → H3 supported**.

---

## Quick reference
| Ex | Answer in one line |
|---|---|
| 1c | Both I(1); residual ADF −2.649 < −2.50 ⇒ **cointegrated** |
| 1d | short-run Δ 1.252***; **speed −0.143*** (≈14.3%/qtr), negative+sig** |
| 1e | **Real** — stationary residuals + significant ECM (high R² justified) |
| 2b | Score test p=0.66 ⇒ **no excess zeros** |
| 2c | LR test p=0.97 ⇒ **no overdispersion** |
| 2d | ZIP lowest AIC but unjustified ⇒ **Poisson** (BIC→pois1) |
| 2e | Ordered logit ⇒ **same conclusions** (signs & significance) |
| 3b | Both Hausman tests reject ⇒ **FE** |
| 3c | **model2 (full FE)** — within-R² 0.366 vs 0.042 |
| 3d | `years` insignificant ⇒ **H2 supported** |
| 3e | Anti-pluralism −0.380*** ⇒ **H3 supported** |
