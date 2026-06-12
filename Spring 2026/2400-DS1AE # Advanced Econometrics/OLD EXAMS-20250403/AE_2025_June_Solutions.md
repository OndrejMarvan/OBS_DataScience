---
exam: Advanced Econometrics — June 13, 2025
tags: [econometrics/AE, exam-solutions, panel, count, ordered, binary, cointegration]
---

# AE Exam — June 13, 2025 — Worked Solutions

> (1) birthweight panel POLS/RE/FE, (2) the "digit-ratio" hypothesis across Poisson + ordered logit + binary models (with specification tests), (3) Boeing/Airbus cointegration. α per exercise.

---

## Exercise 1 (30%) — Birthweight panel (POLS / RE / FE). α = 5%
Abrevaya data: mothers (`i`) with up to 3 children (`t`). `birwt` = birthweight. Time-varying: `smoke`, `male`, `married`. **Time-invariant**: `hsgrad`, `somecoll`, `collgrad`, `black`.

**a) (5%) Why are `hsgrad`, `somecoll`, `collgrad`, `black` not estimated in FE?** They are **time-invariant** — a mother's education and race don't change across her successive births. Fixed effects uses the **within (demeaning) transformation**, which subtracts each mother's own average; anything constant within a mother is wiped out and becomes **perfectly collinear with the individual effects**, so it cannot be estimated. (Only `smoke`, `male`, `married` vary across a mother's births, so only those survive in FE.)

**b) (10%) Hausman finding.** `phtest(FE, RE)`: **χ² = 26.408, df = 2, p = 1.84e-06 < 0.05 → reject H₀**. H₀ is "the individual effects are uncorrelated with the regressors (RE consistent)"; rejecting it means **RE is inconsistent → use Fixed Effects**. (df = 2 because only the time-varying coefficients — `smoke`, `male` — can be compared; the time-invariant ones aren't in FE.) The drop in the `smoke` coefficient across estimators (−257 POLS → −217 RE → **−101 FE**) is itself the symptom: once you control for the mother's fixed traits, the apparent smoking effect shrinks dramatically, which is exactly what the Hausman test is detecting.

**c) (10%) Superior model.** Walk the three tests:
- `pFtest(FE, POLS)`: F = 2.804, **p < 2.2e-16 → significant individual effects → reject pooled OLS**.
- `plmtest(POLS, "bp")`: χ² = 1022, **p < 2.2e-16 → RE beats pooled** too.
- `phtest(FE, RE)`: **rejects → FE over RE.**

So the chain points to **Fixed Effects** as the superior, consistent estimator. The cost is that FE can't report the education/race effects (time-invariant), but consistency is decisive here — the Hausman test rules RE out. **Select FE.**

**d) (5%) If unobserved prenatal care is in the individual effect — RE or FE?** **FE.** Prenatal care is almost certainly **correlated with the regressors** (mothers who get good prenatal care also tend to be more educated, married, non-smoking). If that care sits inside the individual effect `ζᵢ`, then **Cov(Xβ, ζ) ≠ 0** — precisely the violation of the random-effects orthogonality assumption (the hint). RE would be biased and inconsistent; **FE differences `ζᵢ` away and stays consistent**, so choose FE.

---

## Exercise 2 (30%) — The "digit-ratio" hypothesis across three models. α = 5%
H: people whose **ring finger is longer than the index finger** are *less agreeable* (less likely to yield/be lenient). Tested on three datasets.

### Part 1 — Police (Poisson). `tcktsNarrst` ~ `…` + `ringfnglngr`
**a) (6%) Verify the hypothesis using the Poisson estimates.** In this context "less agreeable" ⇒ less lenient ⇒ **more** tickets/arrests, so the hypothesis predicts a **positive** `ringfnglngr` coefficient. Test its sign and significance: **β = 0.2635, z = 22.6, p < 2e-16 → positive and highly significant.** IRR = e^0.2635 = **1.30**, so longer-ring-finger officers issue about **30% more** tickets/arrests. → **The hypothesis is supported.** (Formally a one-sided test H₀: β ≤ 0 vs H₁: β > 0.)

### Part 2 — Student grades (ordered logit). `grade` ~ `…` + `prof_lngr_rngfngr`
**b) (6%) Verify the hypothesis using the ordered-logit estimates (ignoring spec tests).** Here "less agreeable professor" ⇒ less likely to give **high** grades, so predict a **negative** coefficient on `prof_lngr_rngfngr`. **β = −11.13, z = −28.7, p < 2e-16 → negative and highly significant** ⇒ such professors are significantly less likely to place students in the higher grade categories. → **Hypothesis supported.**

**c) (6%) Is (b) valid given the specification test?** **Yes.** The **Lipsitz goodness-of-fit test**: LR = 5.81, df = 9, **p = 0.758**. H₀ is "the model is correctly specified / fits well"; **p > 0.05 → fail to reject → no evidence of misspecification**, so the ordered logit is adequate and the conclusion in (b) **stands**. (Remember the direction: a *big* p-value is the good news for a fit test.)

### Part 3 — Credit approval (logit & probit). `approve` ~ `…` + `ring_longer`
**d) (6%) Verify the hypothesis using probit/logit (ignoring spec tests).** "Less agreeable approver" ⇒ less likely to approve ⇒ predict a **negative** `ring_longer` coefficient. But across **all** fitted models it is **positive and insignificant** (probit2 0.086, logit1 0.132, logit2 0.149, all ns). → **The hypothesis is NOT supported here:** ring-finger length has no significant effect on credit approval (and the sign is even the "wrong" way, though insignificantly so).

**e) (6%) Is (d) valid given the specification tests?** **Yes — the well-specified models all agree.**
- **Hosmer–Lemeshow** `probit1`: X² = 10.82, **p = 0.010 → reject good fit** — but `probit1` only contains `married` (under-specified), so we wouldn't use it.
- **Hosmer–Lemeshow** `probit2`: X² = 12.85, **p = 0.136 → fits well.**
- **Osius–Rojek (`o.r.test`)** `logit1`: z = −0.54, **p = 0.437 → well specified.**
- **Stukel test** `logit2`: stat = 4.27, **p = 0.429 → well specified.**

The fully-specified models (`probit2`, `logit1`, `logit2`) **all pass** their specification tests (p > 0.05), so the insignificance of `ring_longer` comes from sound models → **conclusion (d) is valid**. Only the deliberately bare `probit1` fails its fit test, which is expected for an under-specified model.

> **Cross-dataset takeaway:** the digit-ratio effect appears strong for tickets (Poisson) and grades (ordered) but **vanishes** for credit approval — a nice illustration that a "result" can be model/context-specific, and that specification tests are what license you to trust (or distrust) each conclusion.

---

## Exercise 3 (40%) — Boeing vs Airbus: cointegration. α = 5%. Critical value = **−3.67**
Daily close prices. Figures 2 (two-scale), 3 (single-scale levels), 4 (logs).

**a) (5%) Which figure is best for visually inspecting cointegration?** Not **Figure 2** — a **two-scale** plot can *fabricate* apparent co-movement by rescaling the axes independently, so it's misleading for judging a stable long-run relationship. The cointegration test here is run on **levels** (`boeing ~ airbus`), so **Figure 3 (single common scale, levels)** is the most faithful: with both series on one axis you can actually see whether the gap between them stays bounded. (Figure 4's logs correspond to a *different*, log-level relationship than the one tested.) → **Figure 3.**

**b) (10%) Does visual inspection prove cointegration?** **No.** A plot can only *suggest* co-movement; it can never prove cointegration. Two independent I(1) series can drift together by chance (spurious). Proof requires the formal steps: confirm both are I(1), then test residual stationarity against the special cointegration critical value.

**c) (10%) Are they cointegrated?** **No.**
1. **Both I(1):** Boeing — testdf "c" at the clean-BG augmentation gives ADF = 0.909 (p = 0.99, non-stationary), difference stationary ⇒ I(1). Airbus — **PP** = −0.131 > −2.863 (non-stationary), **KPSS on the difference** = 0.209 < 0.463 (difference stationary) ⇒ I(1).
2. Cointegrating regression `boeing ~ airbus`: slope **2.948***, R² = 0.881**.
3. **Residual ADF** (testdf "nc", first clean-BG augmentation = aug1): **−1.996**. Compare to the cointegration critical value **−3.67**: −1.996 is **not** more negative than −3.67 ⇒ **fail to reject the unit root ⇒ residuals non-stationary ⇒ NOT cointegrated.**

**d) (10%) Interpret the ECM.** `Δboeing = 0.836·Δairbus − 0.00109·lresid`.
- **Δairbus = 0.836*** — short-run co-movement** (a same-day move in Airbus's change maps to 0.836 of Boeing's change).
- **lresid = −0.00109, t = −0.757, p = 0.449 — INSIGNIFICANT.** The speed-of-adjustment term is essentially **zero and not significant**, so there is **no error correction** — nothing pulls the pair back toward an equilibrium. This is fully consistent with (c): they are **not cointegrated**, so the "equilibrium" doesn't exist and the ECM term correctly fails to show adjustment.

**e) (5%) Real or spurious?** **Spurious.** Both series are I(1) but **not cointegrated** (residual ADF −1.996 > −3.67; ECM term insignificant). The high R² = 0.881 is the **classic spurious-regression mirage** — two separately-trending I(1) stocks. There's no genuine long-run equilibrium tethering Boeing to Airbus here.

---

## Quick reference
| Ex | Answer in one line |
|---|---|
| 1a | Time-invariant ⇒ wiped out by the within transformation in FE |
| 1b | Hausman p=1.8e-6 ⇒ reject ⇒ **FE** |
| 1c | pFtest & BP reject pooled, Hausman ⇒ **FE** is superior |
| 1d | Prenatal care ⇒ Cov(X,ζ)≠0 ⇒ RE inconsistent ⇒ **FE** |
| 2a | `ringfnglngr` +0.264*** (IRR 1.30) ⇒ **supports** (more tickets) |
| 2b/2c | prof −11.13*** ⇒ supports; Lipsitz p=0.76 ⇒ valid |
| 2d/2e | `ring_longer` ns in credit ⇒ **not** supported; spec tests pass ⇒ valid |
| 3c | Residual ADF −1.996 > −3.67 ⇒ **NOT cointegrated** |
| 3d | speed −0.0011 **insignificant** ⇒ no error correction |
| 3e | **Spurious** (I(1), not cointegrated; high R² is the mirage) |
