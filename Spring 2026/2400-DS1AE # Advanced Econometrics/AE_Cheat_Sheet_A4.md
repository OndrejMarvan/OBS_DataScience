---
course: Advanced Econometrics
type: A4 exam cheat sheet (hand-copy onto one A4, front + back)
tags: [econometrics/AE, cheat-sheet, exam]
---

# AE — A4 Cheat Sheet

> Designed to hand-copy onto one A4 (both sides). PAGE 1 = cross-section + limited-dependent models. PAGE 2 = time series + IV + the test-direction table. **Bold = the trap they test.**

---

## ★ TWO RULES THAT CARRY MOST MARKS
1. **Non-linear models: the coefficient is NOT the effect.** logit/probit/ordered/count/Tobit → read **sign + significance**, or **odds-ratio/IRR/RRR** ($e^\beta$), or the **marginal effect**. Never read the raw $\beta$ as a probability/count change.
2. **Know which way each test's $H_0$ points** (see table, p.2). Some tests you want to reject; some you want to *fail* to reject.

## Coefficient interpretation by form
- level–level: +1 unit $x$ → $+\beta$ units $y$
- **log–log = elasticity:** +1% $x$ → $+\beta\%$ $y$
- **log–level = semi-elasticity:** +1 unit → $\approx(100\beta)\%$; **exact $(e^\beta-1)\cdot100\%$** (use for big $\beta$/dummies; $-1.10\Rightarrow-67\%$ not $-110\%$)
- percent ≠ percentage point (matters when $y$ is a rate)

## PANEL (Lec 2) — FE vs RE
- Indiv. effect $u_i$ = hidden time-invariant trait. **FE** scrubs it (safe; **drops time-invariant vars** — that's why `Sex` vanishes). **RE** assumes $u_i$ uncorrelated w/ X (efficient, keeps them).
- **Hausman:** $H_0$ = RE consistent. **reject ($p<.05$) → FE; fail → RE.** *Recompute: tiny $\chi^2$ → big p → RE (ignore misprints; $\chi^2{=}0.19$,df1 → p≈0.66).*
- F-test: FE vs pooled. BP-LM: RE vs pooled. Pooled OLS ⇒ omitted-var bias + wrong SEs.
- Hint: fixed set of units → FE; random sample → RE. Panels need **clustered SEs**.

## BINARY (Lec 3) logit/probit — S-curve, MLE
- read: **sign** (safe) / **odds ratio $e^\beta$** (logit; odds≠prob) / **marginal effect** = Δprob in pp (MEM at mean, AME averaged)
- GOF: **LR test** $H_0$ all slopes=0 → **want reject**. **McFadden** 0.2–0.4 good (low is normal). **Hosmer–Lemeshow** $H_0$=good fit → **want FAIL to reject (big p = good)**. ROC/AUC: .5 useless→1 perfect.
- LPM = OLS on 0/1: predicts outside [0,1], heteroskedastic ⇒ needs robust SE.

## ORDERED (Lec 4) — ranked Y, cut-points
- $\beta$: **sign only** → $+\beta$ ⇒ top category↑, bottom↓; **MIDDLE categories ambiguous** (need ME)
- **MEs across categories sum to 0** (back out a missing one by subtraction)
- **Brant test** $H_0$ = parallel-regression (proportional odds) holds; reject ⇒ use generalised ordered logit. Can't interpret McFadden as $R^2$.

## UNORDERED (Lec 5) — no ranking, vs base category
- **MNL = individual-specific vars** (age, income). **Conditional = alternative-specific vars** (price/time of each option). *"should we use conditional?" → No if all regressors are person-traits.*
- **RRR** $=e^\beta$ = odds of category **relative to base**; raw $\beta$ ≠ prob effect
- **IIA** assumption (Red-Bus/Blue-Bus); test **Hausman–McFadden** $H_0$=IIA holds; reject ⇒ nested logit / MNP

## COUNT (Lec 6) — Y = 0,1,2,…
- **Poisson:** mean = variance (equidispersion). **Overdispersion (var>mean)** ⇒ Poisson SEs too small (false signif.) ⇒ **NegBin** ($\text{Var}=\mu+\alpha\mu^2$; $\alpha{=}0$→Poisson). LR test $H_0:\alpha{=}0$.
- **Excess zeros** ⇒ ZIP/ZINB (zero part + count part); **Vuong / score test** $H_0$=no excess zeros. Pick final by **AIC** (both problems ⇒ ZINB).
- interpret: **IRR $=e^\beta$** (×expected count); $e^\beta{=}1.25$⇒+25%

## TOBIT / HECKMAN (Lec 7)
- **Tobit** = Y squashed at a limit (pile at 0). $\beta$ = effect on **latent $y^*$**, not observed → use ME.
- **corner solution** (real zeros, e.g. 0 hours) vs **data censoring** (true value hidden, e.g. GPA recorded at 2.0) — *name which!*
- **Heckman** = Y seen only for self-selected group. 2-step: (1) probit → **Inverse Mills Ratio λ**; (2) OLS + λ. **Exclusion restriction:** a var in selection NOT in outcome. Test selection: λ significant ⇒ bias ⇒ keep Heckman.

## GETS (Lec 8)
GUM (all vars) → **diagnose & fix first** → delete **highest-p one at a time** → re-estimate → repeat → verify. **Never delete a block** (multicollinearity shifts p). Test restriction: `anova(reduced,full)` or Wald; non-nested ⇒ **AIC/BIC** (lowest), not $R^2$.

═══════════════ PAGE 2 — TIME SERIES + IV ═══════════════

## TS FLOW (the whole logic)
test stationarity → **if I(1) & not cointegrated ⇒ spurious** (use differences) → **if I(1) & cointegrated ⇒ ECM** → if stationary ⇒ ARDL.
**Spurious tell: high $R^2$ + DW≈0.** Stationary = stable mean+var; random walk $y_t{=}y_{t-1}{+}\varepsilon$ = I(1); difference $d$ times ⇒ I(d).

## UNIT ROOT TESTS (Lec 10) — ★direction trap
- **ADF / PP:** $H_0$ = unit root (non-stat). **reject ⇒ STATIONARY (good).** PP robust to hetero, no lag choice.
- **KPSS:** $H_0$ = STATIONARY. **reject ⇒ NON-stationary** (mirror image!).
- ADF lag = **smallest augmentation where Breusch–Godfrey is clean** (all BG p>.05). Types: none / drift(const) / trend.
- workflow: test level → if non-stat, diff → retest ⇒ I(0)/I(1). All 3 agree = robust; conflict ⇒ trend/break.

## ARDL & MULTIPLIERS (Lec 11) — ★calc question
- **short-run (impact) = coeff on current $x$**
- **long-run $=\dfrac{\sum\beta}{1-\sum\alpha}$** ($\alpha$=lagged-$y$ coeffs) — **DON'T forget the $(1-\sum\alpha)$ denominator!**
- lagged $y$ ⇒ **DW invalid (biased to 2)** ⇒ use **Breusch–Godfrey** (want p>.05)

## ARMA/ARIMA (Lec 12) — forecasting only
- **ID:** AR(p) ⇒ ACF decays, **PACF cuts at p**. MA(q) ⇒ **ACF cuts at q**, PACF decays. ARMA ⇒ both decay. (PACF→AR, ACF→MA)
- random walk: ACF decays *very slowly* + PACF spike at lag1 → non-stat
- mean reversion: $E(y)=c/(1-\alpha)$, $|\alpha|<1$. MA(q) forecast flat = mean beyond q.
- **Ljung–Box** $H_0$=white-noise residuals → want p>.05. AIC=prediction / BIC=parsimony.

## COINTEGRATION & ECM (Lec 13) — ★capstone
- two I(1) series, but a combo is I(0) (tethered → long-run equilibrium)
- **Engle–Granger:** (1) OLS levels → residuals; (2) ADF on residuals **using SPECIAL (EG/MacKinnon) critical values — more negative, NOT standard ADF tables**
- **ECM:** $\Delta y_t = \dots + \gamma\,\hat e_{t-1}$; **$\gamma$ MUST be negative & significant** = speed of adjustment (frac. of gap closed/period; $-0.27$⇒27%). Significant $\gamma$ itself confirms cointegration.
- mixed I(0)/I(1) ⇒ **ARDL bounds test**: F>upper ⇒ coint; F<lower ⇒ no; between ⇒ inconclusive. Fails if any I(2).

## IV / ENDOGENEITY (Lec 14)
- endogeneity ($\text{Cov}(X,\varepsilon)\neq0$): omitted var / measurement error / simultaneity → OLS biased+inconsistent
- valid instrument Z: **relevant** ($\text{Cov}(Z,X)\neq0$) + **exogenous** ($\text{Cov}(Z,\varepsilon)=0$, affects Y only via X)
- **2SLS:** stage1 X on Z,W → $\hat X$; stage2 Y on $\hat X$,W
- tests: **first-stage F<10 ⇒ weak** (worse than OLS); **Durbin–Wu–Hausman** $H_0$=exogenous, reject⇒use IV; **Sargan** (overID) $H_0$=valid, reject⇒invalid. IV inflates SEs ⇒ only if endogeneity proven.

## DYNAMIC PANEL (Lec 15)
lagged $y$ in panel ⇒ **Nickell bias** (FE biased, short T) ⇒ **Arellano–Bond GMM** (difference out $u_i$, instrument with deeper lags). Checks (want fail-to-reject both): **AR(2)** insignif. (AR(1) expected—ignore) + **Sargan/Hansen** valid.

## ★★ WHICH WAY DOES THE TEST POINT? ★★
| Test | $H_0$ | reject (small p) = |
|---|---|---|
| t / F / LR-joint | coef=0 | **var matters (want this)** |
| BP / White | homoskedastic | heteroskedasticity |
| **Breusch–Godfrey / Ljung–Box** | no autocorr | autocorr *(want FAIL)* |
| Jarque–Bera | normal | non-normal |
| RESET | form OK | misspecified |
| Hausman (panel) | RE ok | use FE |
| **Hosmer–Lemeshow** | fits well | poor fit *(want FAIL = big p)* |
| Overdispersion | Poisson ok | use NegBin |
| **ADF / PP** | unit root | **STATIONARY (good)** |
| **KPSS** | stationary | **non-stationary** |
| DWH (IV) | exogenous | endogenous→IV |
| Sargan | instr. valid | invalid |

## INTERPRETATION TEMPLATES
- logit coef: "[x] has a [+/−], significant effect on P(outcome); coef isn't the prob change."
- ME: "+1 [x] changes P by [ME] pp."  OR: "OR $e^\beta$=__: ×odds."
- count IRR: "+1 [x] multiplies expected count by $e^\beta$ = __ (=__%)."
- Hausman fail: "fail to reject ⇒ RE consistent & efficient, preferred."
- ADF clean-BG: "at aug __ BG clean; ADF [rej/fail] unit root ⇒ [stationary/I(1)]."
- long-run mult: "$\frac{\sum\beta}{1-\sum\alpha}$=__: permanent +1 [x] → +__ [y] long run."
- ECM: "$\gamma$=__ <0 & signif ⇒ __% of disequilibrium corrected/period."
