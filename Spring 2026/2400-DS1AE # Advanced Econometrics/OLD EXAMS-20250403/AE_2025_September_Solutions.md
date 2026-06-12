---
exam: Advanced Econometrics — September 1, 2025
tags: [econometrics/AE, exam-solutions, count, zero-inflation, multinomial-logit, cointegration]
---

# AE Exam — September 1, 2025 — Worked Solutions

> (1) Nobel-laureates vs IKEA-stores count models, (2) cat-adoption multinomial/conditional logit, (3) Lockheed/Northrop cointegration. α per exercise.

---

## Exercise 1 (30%) — Nobel laureates vs IKEA stores: count models. α = 5%
A deliberate spurious-correlation joke (the exam cites Maurage's chocolate-vs-Nobel paper). `nobel` (count, 0–420), regressors `IKEA_stores`, `ln_population`. Models: pois1 (subsample, N=61), pois2/nb1/nb2/zip (full sample, N=182).

**a) (5%) Restrict to countries with ≥1 IKEA store, or use all countries?** Use **all countries**. Restricting to countries that *have* an IKEA store (pois1, N=61) is **sample selection on a non-random subsample** — IKEA-presence correlates with wealth/development, which also drives Nobel counts. Dropping the zero-IKEA countries discards informative observations and biases the estimates. The full sample (N=182) is representative; **the selected subsample is not.**

**b) (5%) Excess zeros?** The distribution is **57.1% zeros** plus a long heavy tail (values up to 420) — that *looks* like a candidate for zero-inflation. **But the model comparison says otherwise:** the Negative Binomial (nb2, AIC 615) fits **far** better than the zero-inflated Poisson (zip, AIC 1436). So the large mass of zeros is explained by **overdispersion / a heavy-tailed count distribution**, not by a separate zero-generating process. **Conclusion: no "excess zeros" in the zero-inflation sense — the zeros are an overdispersion phenomenon**, best handled by NegBin rather than ZIP.

**c) (5%) Interpret the ZIP parameters.** ZIP estimates two equations jointly:
- **Count part** (Poisson, for "potentially-count" countries): `IKEA_stores` 0.072*** → e^0.072 = 1.075 → each extra IKEA store is associated with ~**7.5% more** expected laureates; `ln_population` 0.067** → an elasticity of ~0.067 (1% more population → ~0.067% more laureates).
- **Inflation part** (logit, probability of being a *structural* "always-zero" country): `IKEA_stores` −0.309*** and `ln_population` −0.504*** → **more IKEA stores and larger population both lower the odds of being an always-zero country** (a bigger/more-developed country is less likely to be a guaranteed zero). Intercept 4.313***.

**d) (5%) Superior model.** **nb2** — it has the **lowest AIC (615.4) and lowest BIC (628.0)** of all full-sample models, decisively beating Poisson and ZIP. The data are severely overdispersed (huge spread, 57% zeros plus values to 420), and the Negative Binomial is built for exactly that; adding `ln_population` (nb2 vs nb1) improves it further. (pois1 is on a different sample, so not comparable.)

**e) (5%) Comment on the `lrtest`.** `lrtest(POIS2, NB2)`: χ² = **1239, df = 1, p < 2.2e-16**. This is the likelihood-ratio test of Poisson vs Negative Binomial, i.e. H₀: the dispersion parameter α = 0 (no overdispersion). The enormous statistic **strongly rejects H₀ → severe overdispersion → the Negative Binomial is vastly preferred over Poisson**, confirming the AIC/BIC verdict in (d).

**f) (5%) Real or spurious?** **Spurious** — and this is the point of the exercise. IKEA stores obviously don't *cause* Nobel prizes; both are driven by a common confounder — a country's **wealth, development, and size**. The statistical association is real, but the **causal** interpretation is spurious (a textbook confounded correlation, exactly the Maurage chocolate-Nobel warning). Note this is *cross-sectional* spuriousness from an **omitted common cause**, not the time-series unit-root kind — but the moral is the same: **correlation ≠ causation.**

---

## Exercise 2 (30%) — Cat adoption: (mixed) multinomial logit. α = 10%
`mlogit(cat_choice ~ cat_sterilized + cat_gender + cat_age | person_age + person_superstitious + person_gender, reflevel = "White")`. Colours: Black, Ginger, Triplecolor, **White (base)**, Grey-brown.

**a) (5%) Is `cat_color` ordered or unordered?** **Unordered (nominal).** Cat colours have **no natural ranking** — no colour is "higher" than another — so an ordered model would be wrong; a multinomial/conditional (unordered) choice model is appropriate.

**b) (5%) Which variables are alternative-specific?** The **cat attributes — `cat_sterilized`, `cat_gender`, `cat_age`** — are alternative-specific: they describe the *cats* (the choice options) and enter before the `|` with a single **generic coefficient**. The person attributes (`person_age`, `person_superstitious`, `person_gender`) are **individual-specific** — constant across the alternatives for a given adopter — and get a separate coefficient **per colour** (`…:Black`, `…:Ginger`, etc.).

**c) (5%) Multinomial or conditional logit?** It's a **mixed/conditional logit, not a pure multinomial logit.** The tell-tale sign is the presence of **alternative-specific variables** (the cat characteristics with a single generic coefficient) — a pure multinomial logit contains **only individual-specific** variables (each with alternative-specific coefficients). Because this model has both alternative-specific (`cat_*`) **and** individual-specific (`person_*`) regressors, it is a **mixed conditional logit**.

**d) (5%) Interpret `cat_age`.** β = **−0.1527, z = −2.72, p = 0.0065** (significant at 10% and 5%). As an alternative-specific generic-coefficient variable: **older cats are less likely to be chosen.** e^(−0.1527) = **0.86**, so each additional year of a cat's age multiplies the odds of that cat being adopted by ~0.86 — about a **14% drop in the odds of adoption per year of age**, holding other factors fixed.

**e) (5%) Interpret `person_gender:Ginger`.** β = **4.917, z = 7.65, p < 0.001** — an individual-specific effect measured **relative to the base category (White)**. RRR = e^4.917 ≈ **137**: a **female** adopter is dramatically more likely to choose a **Ginger** cat *rather than a White* cat than a male adopter is (the odds of Ginger-vs-White are ~137× higher for women). Always phrase it "**relative to the base (White)**."

**f) (5%) Does being superstitious affect the colour chosen?** Look at the `person_superstitious` rows: coefficients ≈ **17** with **standard errors ≈ 2347** and **p ≈ 0.994** for every colour. Those are the unmistakable fingerprints of **perfect / quasi-complete separation** — superstitious adopters almost certainly chose (or avoided) some colour *deterministically* (most plausibly **avoiding black cats**), creating a near-empty cell that sends the coefficient and its standard error to infinity. **So the effect is not reliably estimated and is not statistically significant** by these numbers. Strictly: we *cannot* conclude a significant effect from standard ML output — though the separation pattern itself hints that superstition **does** relate to colour choice (just not estimable this way; it would need a penalised/exact method).

---

## Exercise 3 (40%) — Lockheed Martin vs Northrop Grumman: cointegration. α = 5%. Critical value = **−3.67**
Daily close prices, 2007–2025.

**a) (10%) Does visual inspection prove cointegration?** **No.** Visual co-movement is only *suggestive* and never proof — two defence stocks can trend together for years without a stationary long-run relationship (and dual-scale plots can exaggerate the apparent tracking). Proof requires the formal sequence: establish both are I(1), then test residual stationarity against the cointegration critical value.

**b) (8%) Integration order of the two series.** **Both are I(1).**
- **Lockheed**: testdf "c" at the first clean-BG augmentation → ADF = **−0.730, p = 0.788 → fail to reject unit root → non-stationary** in levels; the first difference is stationary (ADF = −69.6, p = 0.01). ⇒ **I(1)**.
- **Northrop**: **PP** Z-tau = **0.332 > −2.863** (5%) → non-stationary in levels; **KPSS on the difference** = 0.157 < 0.463 → difference stationary. ⇒ **I(1)**.

**c) (7%) Are they cointegrated?** **No.** Cointegrating regression `Lockheed ~ Northrop`: slope **0.909***, R² = 0.973**. Residual test (testdf "nc"): aug0 and aug1 have a significant BG.2, so the **first clean-BG augmentation is aug2 → residual ADF = −2.931**. Against the cointegration critical value **−3.67**: −2.931 is **not** more negative than −3.67 → **fail to reject the unit root → residuals non-stationary → NOT cointegrated.**

**d) (10%) Interpret the ECM.** `ΔLockheed = 0.653·ΔNorthrop − 0.00641·lresid`.
- **ΔNorthrop = 0.653*** — short-run co-movement** (a same-day Northrop change maps to 0.653 of Lockheed's change).
- **lresid = −0.00641, t = −3.47, p = 0.0005 — negative and statistically "significant."** *This is the trap.* It is tempting to read a significant negative speed-of-adjustment as confirming cointegration — **but it doesn't here**, for two reasons: (i) the **residual ADF test failed** (−2.931 > −3.67), which is the *primary* cointegration criterion; (ii) the coefficient is **economically negligible** (≈0.6% of any gap "corrected" per day), and with **~4,700 daily observations even a trivial effect crosses the significance threshold** (huge-N significance inflation). So the ECM term is significant on paper but does **not** override the failed residual test — there is no genuine equilibrium to revert to.

**e) (5%) Real or spurious?** **Spurious.** Both series are I(1) but **not cointegrated** (residual ADF −2.931 > −3.67). The very high R² = 0.973 is the spurious-regression mirage of two separately-trending defence stocks. The statistically-significant-but-tiny ECM term is a large-sample artifact, not evidence of a real long-run tether.

> **The two cointegration exercises side by side (worth internalising).** Boeing/Airbus (June) and Lockheed/Northrop (Sept) *both* end "not cointegrated → spurious," but they fail differently: Boeing/Airbus fails on **both** the residual test (−1.996) **and** an insignificant ECM term — an easy call. Lockheed/Northrop fails the residual test (−2.931 vs −3.67) **despite** a "significant" ECM term — the harder, more honest call. The lesson: the **residual stationarity test with the special critical value is the primary criterion**; don't let a t-significant ECM coefficient (especially on thousands of daily observations) talk you out of it.

---

## Quick reference
| Ex | Answer in one line |
|---|---|
| 1a | Use **all countries** (subsample = selection bias) |
| 1b | 57% zeros, but NB2 ≪ ZIP on AIC ⇒ overdispersion, **not** excess zeros |
| 1d | **nb2** — lowest AIC (615) & BIC (628) |
| 1e | LR χ²=1239 ⇒ severe overdispersion ⇒ **NegBin over Poisson** |
| 1f | **Spurious** — common confounder (wealth/size); correlation ≠ causation |
| 2a–c | Unordered; cat_* alternative-specific; **mixed/conditional logit** |
| 2d | cat_age −0.153** ⇒ older cats ~14% lower odds (IRR 0.86) |
| 2e | female:Ginger 4.92*** ⇒ RRR ≈ 137 vs White (base) |
| 2f | Coeffs ≈17, SE ≈2347, p≈0.99 ⇒ **separation**, not reliably estimable |
| 3b | Both **I(1)** |
| 3c | Residual ADF −2.931 > −3.67 ⇒ **NOT cointegrated** |
| 3d | ECM −0.0064 *significant but tiny* (huge-N artifact) ⇒ no real adjustment |
| 3e | **Spurious** (I(1), not cointegrated; R²=0.973 is the mirage) |
