---
course: Advanced Econometrics
program: MSc Data Science & Business Analytics, WNE UW
lecturers: Chlebus, Woźniak; labs Bogusz/Świtała/Weychert
tags: [econometrics/AE, lecture-notes, master-note]
note: Single running notebook for the whole course. Organised by TOPIC; the index maps sessions chronologically. Lecture/lab topic mismatches are flagged inline.
---

# Advanced Econometrics — Master Notes

> [!info] How this note works
> One consolidated file for the whole course. Sections are **topic-based** (better for revision); the index below maps each lecture/lab to where its content lives. When a lab's content doesn't match its lecture number, I flag it rather than forcing the order.

## Index — sessions → topics

| Session | Source | Real topic | Section here |
|---|---|---|---|
| Lecture 01 | Intro slides + handwritten notes | Course framing, variable taxonomy, model-selection map, coefficient interpretation | §1, §3 |
| Lab 01 | Problem set + 126-slide CLRM deck + `regression_results.doc` + `tutorial_1.ipynb` | **Undergraduate OLS refresher**: CLRM, OLS properties, diagnostics, robust/clustered SEs | §2, §4, §5 |
| Lecture 02 | Text notes | **Panel data models**: pooled OLS vs FE vs RE, error-component models, the three selection tests (F, Breusch–Pagan LM, Hausman) | §6 |
| Lab 02 | Text notes (R `plm` / Python `linearmodels`) | **Panel data — practical**: estimator code, the selection decision-tree, panel-robust (clustered/HAC) SEs | §6 |
| Lecture 03 | Text notes | **Binary dependent variables**: LPM, logit, probit, marginal effects, GOF battery (LR, McFadden, HL, ROC/AUC) | §7 |
| Lab 03 | Text notes (R) | **Binary DV — practical**: `glm` estimation, `mfx` marginal effects, McFadden/hit-rate/HL/ROC code | §7 |
| Lecture 04 | Text notes | **Ordered logit & probit**: thresholds, parallel-regression (Brant) assumption, ambiguous middle categories, sum-to-zero MEs | §8 |
| Lab 04 | Text notes (R) | **Ordered models — practical**: `polr` (`MASS`), Brant test, `ocME` marginal effects, class-prediction hit rate | §8 |
| Lecture 05 | Text notes | **Multinomial & conditional logit (theory)**: random utility model, MNL/CL probability formulas, IIA & Red-Bus/Blue-Bus | §9 |
| Lab 05 | Text notes (R) | **Multinomial & conditional logit — practical**: `multinom`/`mlogit`, RRR, data reshaping, IIA (Hausman–McFadden) | §9 |
| Lecture 06 | Text notes | **Count data**: Poisson, Negative Binomial, overdispersion, zero-inflation (ZIP/ZINB), IRR | §10 |
| Lab 06 | Text notes (R) | **Count data — practical**: `glm` Poisson, `dispersiontest`, `glm.nb`, `zeroinfl`, Vuong, IRR | §10 |
| Lecture 07 | Text notes | **Censored data & sample selection**: Tobit (censoring/corner solution), Heckman two-step, Inverse Mills Ratio, exclusion restriction | §11 |
| Lab 07 | Text notes (R) | **Tobit/Heckman — practical**: `AER::tobit`, `margins`, `sampleSelection::selection`, IMR test | §11 |
| Lecture 08 | Text notes | **Monte Carlo, GETS & intro to time series**: simulation logic, project methodology/writing, `ts`/`zoo`/`xts` | §12, §13 |
| Lab 08 | Text notes (R) | **GETS practical + spurious-regression preview**: ANOVA vs Wald restriction tests, deletion pitfalls | §12, §14 |
| Lecture 09 | Text notes | **Intro to TSA & forecasting**: stationarity concept, modeling philosophies, in/out-of-sample, MAE/MSE/MAPE | §13 |
| Lab 09/10 | Text notes (R) | **Stationarity, random walks & spurious regression**: Newbold–Davis sim, Dickey–Fuller, differencing | §14, §15 |
| Lecture 10 | Text notes | **Stationarity & unit roots**: weak stationarity, ADF/PP/KPSS trio, test pitfalls | §15 |
| Lab 10/11 | Text notes (R) | **Stationarity testing in R**: `urca` (`ur.df`/`ur.pp`/`ur.kpss`), integration-order workflow, rule of three | §15 |
| Lecture 11 | Text notes | **DL & ARDL models**: multipliers, long-run formula, Breusch–Godfrey (not DW), impulse response | §16 |
| Lab 11 | Text notes (R) | **DL/ARDL — practical**: `dynlm` + `L()`, multiplier extraction, `bgtest`, pre-modeling ADF check | §16 |
| Lecture 12 | Text notes | **ARMA/ARIMA & forecasting**: AR/MA/I components, ACF/PACF identification, forecast mechanics, mean reversion | §17 |
| Lab 12 | Text notes (R) | **ARIMA in R**: `acf`/`pacf`, `Arima`/`auto.arima`, Ljung–Box residual check, `forecast` | §17 |
| Lecture 13 | Text notes | **Cointegration & ECM**: Engle–Granger two-step, special critical values, ECM speed of adjustment, ARDL bounds test | §18 |
| Lab 13 | Text notes (R) | **ARIMA & Box–Jenkins**: 4-step procedure, random-walk ACF/PACF signature, AIC vs BIC | §17 |
| Lecture 14 | Text notes | **Instrumental variables & endogeneity**: causes, IV conditions, 2SLS, weak-instrument/DWH/Sargan tests | §19 |
| Lab 14 | Text notes (R) | **IV/2SLS — practical**: `AER::ivreg`, pipe syntax, `diagnostics=TRUE`, Mroz example | §19 |

> [!warning] Lecture/lab mismatch (Session 01)
> Lecture 01 is the course **intro** (data/variable types, the model map). Lab 01 is a **CLRM/OLS refresher** — assumptions, diagnostics, robust SEs. They don't share a topic. I've placed Lab 01 under "Foundations" (§2, §4, §5) because it's prerequisite bedrock that underpins everything later, especially the General-to-Specific lecture (L8).

---

# §1 — Course framing & the model-selection map *(Lecture 01)*

The organising idea of the whole course: **the nature of the dependent variable chooses the model.** Once $y$ stops being a clean continuous number, OLS breaks and you reach for a specialised model.

**Data types:** cross-sectional (many units, one time), time series (one unit over time), panel (units × time, a stacked `id | year | …` table).

**Variable types:** continuous; discrete; quantitative (numeric meaning); qualitative (categories) split into **ordered** (ranked, e.g. satisfaction) vs **unordered** (e.g. colour/brand); and **limited** variables (censored/truncated), e.g. $y\in[0,\infty)$ — the LDV family.

### The map (this is the page-7 slide exercise, and the meta-skill behind every exam)

| Dependent variable / situation | Model | Topic |
|---|---|---|
| Continuous, well-behaved | OLS | §2 / L1 |
| Binary $y\in\{0,1\}$ | **Logit / Probit** (ML-estimated) | L3 |
| Ordered categories | **Ordered logit / probit** | L4 |
| Unordered categories | **Multinomial / Conditional logit** | L5 |
| Count $y\in\{0,1,2,\dots\}$ | **Poisson / NegBin** (+ ZIP/ZINB) | L6 |
| Censored / corner $y\in[0,\infty)$ | **Tobit** | L7 |
| Panel ($i,t$) | **Fixed / Random effects** | L1–2, L15 |
| One series, forecasting | **ARMA / ARIMA** | L12 |
| Dynamics / lags | **DL / ARDL** | L11 |
| Non-stationary series sharing a long-run path | **Cointegration / ECM** | L13 |
| Endogenous regressor | **Instrumental variables** | L14 |

> [!tip] Exam reminder
> You may bring **one handwritten A4 sheet**. Put this map, the interpretation rules (§3), the diagnostic-test decision rules (§5), and the recurring mock-exam tricks (Hausman recompute, clean-BG augmentation, KPSS direction, $(1-\rho)$ multiplier) on it.

---

# §2 — Classical Linear Regression Model & OLS *(Lab 01 foundations)*

### Model and estimator
$$y_i = \beta_0 + \beta_1 x_{1i} + \dots + \beta_k x_{ki} + \varepsilon_i, \qquad \hat{\beta} = (X'X)^{-1}X'y.$$
Estimable when $N \geq$ number of parameters and no perfect multicollinearity (no regressor is an exact linear combination of others).

### CLRM assumptions
1. **Linearity** in parameters.
2. **Non-random / exogenous** regressors: $X$ does not affect the errors.
3. **Zero-mean errors:** $E(\varepsilon_i)=0$.
4. **No autocorrelation:** $\mathrm{Cov}(\varepsilon_i,\varepsilon_j)=0$, $i\neq j$.
5. **Homoskedasticity:** $\mathrm{Var}(\varepsilon_i)=\sigma^2$ (constant).
6. *(For inference, esp. small samples)* **Normality:** $\varepsilon_i \sim \text{NIID}(0,\sigma^2)$.

### Gauss–Markov & estimator properties
Under assumptions 1–5, OLS is **BLUE** (Best Linear Unbiased Estimator).
- **Unbiased:** $E(\hat\beta)=\beta$.
- **Efficient:** minimum variance among linear unbiased estimators.
- **Consistent:** $\hat\beta \xrightarrow{p} \beta$ as $n\to\infty$.

> [!important] What heteroskedasticity / autocorrelation actually break
> OLS stays **unbiased and consistent**, but loses **efficiency**, and — crucially — the **standard errors are wrong**, so $t$/$F$ inference is invalid. The fix is corrected standard errors (robust/clustered), not necessarily a new estimator. This is the single most tested idea from Lab 1.

### Fit & model-quality measures
- $R^2 = 1 - \text{RSS}/\text{TSS}$ — share of variance explained; rises mechanically when you add *any* regressor.
- **Adjusted $R^2$** $= 1 - \frac{n-1}{n-p}(1-R^2)$ — penalises complexity; use it to compare models of different size.
- **Information criteria** (lower = better, same sample only): **AIC**, **BIC/SBC**, **HQC**. First term rewards fit, second penalises parameters. BIC penalises harder than AIC.
- **Forecast error:** MAE, MAPE (equal weight), MSE/RMSE (penalise large errors).

### Variable selection
- Test **joint** hypotheses, not a string of single ones: with $k$ independent tests at level $\alpha$, the true error rate is $\alpha^* = 1-(1-\alpha)^k \to 1$. Individually insignificant variables can be **jointly significant**.
- **General-to-specific** (preferred): start from the most general model, drop the least-significant terms in a theoretically justified order (e.g. higher lags first). The recurring exam pattern.
- Automated: **forward** (add most significant), **backward** (drop least significant), **stepwise** (add then re-check). Pick candidates by adj $R^2$ / AIC-BIC / significance / diagnostics / forecast quality.

---

# §3 — Coefficient interpretation by functional form *(Lecture 01)*

| Form | Spec | $\beta_1$ means | Read as |
|---|---|---|---|
| Level–level | $y=\beta_0+\beta_1 x$ | marginal effect | $+1$ unit $x$ → $+\beta_1$ units $y$ |
| Log–log | $\ln y=\beta_0+\beta_1\ln x$ | **elasticity** | $+1\%$ $x$ → $+\beta_1\%$ $y$ |
| Log–level | $\ln y=\beta_0+\beta_1 x$ | **semi-elasticity** | $+1$ unit $x$ → $\approx(100\beta_1)\%$ $y$ |
| Level–log | $y=\beta_0+\beta_1\ln x$ | — | $+1\%$ $x$ → $+\beta_1/100$ units $y$ |

A coefficient is a **partial / ceteris-paribus** effect: $\beta_k = \partial E(y)/\partial x_k$, holding other regressors fixed. Compare two coefficients directly only if their variables share units (otherwise standardise).

### Exact vs approximate semi-elasticity
$$\Delta\% y = (e^{\beta}-1)\cdot 100\% \quad(\text{exact}), \qquad \approx \beta\cdot 100\% \quad(\text{good for } |\beta|\lesssim 0.1).$$

> [!warning] The dummy-in-logs trap (military-expenses example, L01)
> `noSEA` coefficient $-1.10$ does **not** mean $-110\%$ (impossible). Exact: $(e^{-1.10}-1)\cdot100 \approx -66.7\%$ — landlocked countries spend ~67% less on the military.

### Percents vs percentage points
A **percentage point** is additive (2% → "+1 pp" → 3%); a **percent** is relative (3% → "+50%" → 4.5%); a **basis point** $=0.01$ pp. Always state which when the dependent variable is itself a rate.

---

# §4 — Regression diagnostics *(Lab 01 tutorial)*

A compact reference for the CLRM test battery — each row is $H_0$ / what it checks / decision / remedy.

| Test | $H_0$ | Checks | If rejected → do |
|---|---|---|---|
| **Ramsey RESET** | functional form correct | omitted nonlinearity (adds powers of $\hat y$) | add polynomials/interactions/logs |
| **Breusch–Pagan** | homoskedasticity | error variance ∝ regressors (linear) | robust (White) SE |
| **White** | homoskedasticity | heteroskedasticity incl. squares & cross-products (more general) | robust SE |
| **Durbin–Watson** | no 1st-order autocorr. | $d\in[0,4]$: $\approx2$ none, $\to0$ positive, $\to4$ negative | model the dynamics / BG follow-up |
| **Breusch–Godfrey** | no autocorr. up to order $p$ | higher-order serial correlation; stat $(n-p)R^2\sim\chi^2_p$ | add lags / dynamic model / robust SE |
| **Box–Pierce / Ljung–Box** | white noise (no autocorr. to lag $m$) | residual autocorrelation in time series | re-specify dynamics |
| **Jarque–Bera** (also Shapiro–Wilk, KS, AD) | residuals normal | non-normality | matters mainly in small $n$; try log transform |
| **Chow** | $\beta_1=\beta_2$ (no break) | parameter stability across subsamples | allow structural break / split |
| **VIF** | — (descriptive) | multicollinearity; $\text{VIF}=1/(1-R_k^2)$, $>10$ = strong | drop/centre collinear regressors |

### Unusual observations
- **Outlier** (large residual), **leverage** point (extreme regressor, $h_{ii}>2k/n$), **influential** point (removing it shifts estimates — Cook's D, DFFITS, DFBETA). Standardised residual $|r_i^*|>2$ flags ~5% of points by chance — don't drop on fit alone; justify theoretically.

### Robust & clustered standard errors
When homoskedasticity/independence fails, recompute SEs (coefficients stay the same):
- **HC0** = White / Huber–White (original).
- **HC1** = HC0 with degrees-of-freedom correction.
- **HC3** = MacKinnon–White (best in small samples).
- **Cluster-robust** = for grouped data (errors correlated within clusters), e.g. clustering by household size.

> [!note] One-line takeaway
> Robust/clustered SEs change inference (t, p, CIs), **never** the point estimates. The estimate is still OLS; you're just fixing its standard errors.

---

# §5 — Lab 01 worked exercises

### Ex 1 — Wages with interactions (`cps_small.csv`, log–level)
$\ln(\text{WAGE}) = 0.957 + 0.102\,\text{educ} - 0.256\,\text{female} - 0.184\,\text{black} + 0.065\,(\text{female}\times\text{black})$. $N=1000$, $R^2=0.273$, $F=93.4^{***}$.
- **educ** $0.102^{***}$: each extra year of schooling raises wage by $\approx 10.2\%$ (exact $(e^{0.102}-1)=10.7\%$).
- **female** $-0.256^{***}$: women earn $\approx 25.6\%$ less (exact $-22.6\%$), ceteris paribus.
- **black** $-0.184^{*}$: blacks earn $\approx 18.4\%$ less (exact $-16.8\%$).
- **female×black** $0.065$ (**ns**): no extra wage gap for black women beyond the additive female + black effects — the interaction adds nothing.
- $F$ highly significant ⇒ regressors **jointly** significant; $R^2=0.27$ is normal for a wage equation.

### Ex 2 — Housing prices, polynomial & interaction (Stockton)
$\ln(\text{PRICE})$ on `sqft, baths, vacant, stories2` (part a), then part b adds **`sqft²`** (a quadratic to capture diminishing returns to size) and the `vacant×stories2` interaction. Demonstrates polynomial terms = a variable interacted with itself (watch for the multicollinearity that induces).

### Ex 3 — Diagnostics on $\ln(\text{PRICE}) = \beta_0+\beta_1\text{sqft}+\beta_2\text{baths}+\varepsilon$
- **RESET**: rejected the linear form ⇒ omitted nonlinearity. Adding `age²`, `age³` (significant) confirmed a curved relationship; the linear `age` term alone was insignificant.
- **Breusch–Pagan**: LM $=187.5$, $p\approx 1.9\times10^{-41}$ ⇒ strong **heteroskedasticity**.
- **White**: same conclusion via the more general auxiliary regression.
- **Jarque–Bera**: tests residual normality; non-normality leaves coefficients unbiased/consistent, mainly distorting small-sample inference.
- Remedy applied: **HC3 robust SEs** — coefficients unchanged, standard errors corrected.

### Ex 4 — Alcohol expenditure, location dummies (`budgets.dta`, 31,901 HH)
Five nested models varying which `loc2…loc6` dummies are included (general-to-specific).
- **(b)** Joint insignificance of `location`: $F$-test of $H_0:\beta_{loc2}=\dots=\beta_{loc6}=0$ via $\frac{(\text{RSS}_0-\text{RSS})/q}{\text{RSS}/(n-p-1)}$.
- **(c)** Linear restriction $H_0:\beta_{loc5}=-5$: a $t$- (or $F$-) test of a *specific value*, not zero — $t=(\hat\beta_{loc5}-(-5))/\text{SE}$. (`loc5` was $\approx-5.4^{*}$, so likely not rejected.)

### Ex 5 — Fertility, robust & clustered SEs (`fertil2.csv`, 4,361 women)
`ceb ~ age + agefbrth + usemeth`. Run BP for heteroskedasticity, then re-estimate SEs four ways — **Huber–White (HC0/HC1)**, **MacKinnon–White (HC3)**, and **cluster-robust** (clustering by number of children) — and stack model (a), (c), (d), (e) into one **Quality Publication Table** (e.g. `stargazer`). The teaching point: same coefficients throughout, different SEs.

---

## Foundations cheat-block (for the A4 sheet)
- OLS = BLUE under CLRM; hetero/autocorr ⇒ still unbiased & consistent but **inefficient + wrong SEs** ⇒ use robust/clustered SEs (coeffs unchanged).
- Functional form: level-level = marginal effect; log-log = elasticity; log-level = semi-elasticity; exact $(e^\beta-1)\cdot100\%$.
- Diagnostics: RESET (form), BP/White (hetero), DW/BG (autocorr), JB (normality), VIF>10 (multicollinearity), Chow (stability).
- Selection: test **joint** hypotheses; general-to-specific; compare via adj $R^2$ / AIC / BIC.

---

# §6 — Panel data models *(Lecture 02 + Lab 02)*

> [!note] This is the theory behind a recurring exam problem
> The FE/RE/Hausman course-grades exercise appeared on the **2018, 2019, and 2021** finals. Everything below explains *why* those answers worked — `Sex` dropping out of the FE model, the Hausman decision, the pooled-OLS pitfalls. Lab 02 adds the R/Python code and the panel-robust SE fix.

### Setup and panel types
Panel data follow $n$ entities ($i=1,\dots,n$) over $T$ periods ($t=1,\dots,T$).
- **Balanced** — every entity observed the same number of times; **unbalanced** — observation counts differ (e.g. the course-grades panel, $T=4\text{–}30$).
- **Fixed panel** — same individuals throughout; **rotating panel** — some are swapped out each period.
- **Why panels help:** they control for **unobserved individual heterogeneity** (cutting omitted-variable bias), give more variation and less collinearity, add degrees of freedom, and let you study dynamics.

### The error-component model
Pooled OLS, $y_{it} = \alpha + x_{it}'\beta + u_{it}$, ignores the panel structure. Instead we split the error into an individual effect plus noise.

**One-way:** $\quad y_{it} = x_{it}'\beta + u_i + \varepsilon_{it}$
- $u_i$ — unobserved, **time-invariant** individual trait (innate ability, a country's history).
- $\varepsilon_{it}$ — idiosyncratic remainder shock.

**Two-way:** $\quad y_{it} = \alpha + x_{it}'\beta + u_i + \lambda_t + \varepsilon_{it}$
- $\lambda_t$ — **individual-invariant** time effect (macro shocks, a global policy change). Adding these is the "two-way fixed effects" fix I flagged for the trending-panel problems in the mock-exam round-up.

### Fixed Effects (within) vs Random Effects

| | **Fixed Effects (within)** | **Random Effects** |
|---|---|---|
| $u_i$ treated as | fixed parameters | random, $\text{IID}(0,\sigma_u^2)$ |
| Key assumption | $u_i$ **may correlate** with $X_{it}$ | $u_i$ **independent** of $X_{it}$ and $\varepsilon_{it}$ ($\mathrm{Cov}(u_i,x_{it})=0$) |
| Use when | the $N$ entities are a specific, non-random set (OECD countries, US states, named firms); inference conditional on them | the $N$ entities are a random sample from a big population (household surveys) |
| Time-invariant regressors | **cannot be estimated** — perfectly collinear with $u_i$, so they drop out | **can** be estimated |
| Efficiency / df | uses more parameters | more parsimonious, preserves df, more efficient *if its assumption holds* |
| R/Python call | `model = "within"` | `model = "random"` |

> [!important] Why `Sex` was dropped in the exam FE model
> The within estimator demeans each entity, wiping out anything that doesn't change over time. A lecturer's sex (or a "post-communist country" dummy) is time-invariant ⇒ perfectly collinear with $u_i$ ⇒ FE **cannot** estimate it. RE can.

### Model selection — three tests

| Test | Compares | $H_0$ | Reject ($p<0.05$) ⇒ | R command |
|---|---|---|---|---|
| **F-test for individual effects** | FE vs Pooled OLS | all $u_i = 0$ | FE preferred over POLS | `pFtest(fe, pols)` |
| **Breusch–Pagan LM** | RE vs Pooled OLS | $\sigma_u^2 = 0$ (no random effect) | RE preferred over POLS | `plmtest(pols, type="bp")` |
| **Hausman** | FE vs RE | $\mathrm{Cov}(u_i,x_{it})=0$ (RE consistent **and** efficient) | **use FE**; fail to reject ⇒ **use RE** | `phtest(fe, re)` |

The Hausman test is the decisive FE-vs-RE call: under $H_1$, RE is inconsistent while FE stays consistent. The full ladder is F-test → BP-LM → Hausman.

> [!warning] Recompute the Hausman p-value
> On the mock exams the same statistic ($\chi^2 = 0.186$, $df=1$) was printed with three different $p$-values (0.0065 / 0.6665 / 0.6521). A $\chi^2$ of 0.19 on 1 df gives $p\approx 0.66$ — nowhere near significant ⇒ **random effects**. Trust the recomputation over a misprinted number.

### Reading panel output
- **Three $R^2$:** *within* (variation over time inside entities), *between* (across entities' time-averages), *overall* (whole dataset).
- **Variance components:** `sigma_u` $=\sigma_u$ (sd of individual effects), `sigma_e` $=\sigma_\varepsilon$ (sd of idiosyncratic error), and
$$\rho = \frac{\sigma_u^2}{\sigma_u^2 + \sigma_\varepsilon^2}$$
= fraction of total variance due to the individual effects. High $\rho$ ⇒ the panel structure matters a lot.

### Practical implementation *(Lab 02)*

**Declare the panel first.** Data must be in **long format** (one row per entity–time pair), then indexed by (entity, time):
- R (`plm`): `panel <- pdata.frame(raw, index = c("entity_id", "year"))`
- Python (`linearmodels`): `panel = raw.set_index(['entity_id', 'year'])`

**Estimator code** for $y_{it} = \beta_0 + \beta_1 x_{it} + \alpha_i + \varepsilon_{it}$:

| Estimator | What it does | R (`plm`) | Python (`linearmodels`) |
|---|---|---|---|
| **Pooled OLS** | ignores panel ($\alpha_i=0$); biased under heterogeneity | `plm(y~x, model="pooling")` | `PooledOLS.from_formula('y ~ x', panel)` |
| **Fixed Effects** | time-demeans out $\alpha_i$; drops static vars | `plm(y~x, model="within")` | `PanelOLS.from_formula('y ~ x + EntityEffects', panel)` |
| **Two-way FE** | adds time effects for macro shocks | `model="within", effect="twoways"` | add `+ TimeEffects` to formula |
| **Random Effects** | FGLS; $\alpha_i$ random & uncorrelated with $X$; keeps static vars | `plm(y~x, model="random")` | `RandomEffects.from_formula('y ~ x', panel)` |

### Panel-robust standard errors *(the Lab 02 addition)*

> [!important] Panels almost always need corrected SEs
> By construction a panel has **serial correlation** (an entity's errors are correlated across its own periods) and often **heteroskedasticity**. Uncorrected, this makes SEs too small and p-values artificially significant. The fix is **clustered / HAC (Arellano–White)** standard errors — clustering by entity. As always, this changes inference (t, p), not the coefficients.
> - R: `coeftest(fe, vcov = vcovHC(fe, type="HC1", cluster="group"))`
> - Python: `.fit(cov_type='clustered', cluster_entity=True)`
>
> **Exam tip:** if a question says "correct for panel-data issues," it means recompute with clustered SEs and re-check which coefficients stay significant.


- FE assumes $u_i$ **can** correlate with $X$; RE assumes it **cannot**. FE kills time-invariant regressors; RE keeps them.
- Selection ladder: **F-test** (FE vs POLS), **BP-LM** (RE vs POLS), **Hausman** (FE vs RE: reject ⇒ FE, else RE).
- $\rho = \sigma_u^2/(\sigma_u^2+\sigma_\varepsilon^2)$; three $R^2$ = within / between / overall.
- Two-way FE (add $\lambda_t$) soaks up common time shocks — the fix for trending panels.
- Code: FE `model="within"`, RE `model="random"`, POLS `model="pooling"`; tests `pFtest` / `plmtest(type="bp")` / `phtest`.
- Panels need **clustered/HAC SEs** (serial correlation + hetero). "Correct for panel issues" = clustered SEs, then re-check significance.

---

# §7 — Binary dependent variables: LPM, Logit, Probit *(Lecture 03 + Lab 03)*

> [!note] The highest-yield exam topic
> Logit/probit appeared on **five of six** mock papers (2019 Trump vote, 2020 out-of-hours + smoker, 2021 Himalayan success, 2022 & 2023 complaints). The recurring sub-questions: interpret coefficients vs marginal effects, the LR joint-significance test, and the GOF battery.

### Why not OLS? The Linear Probability Model (LPM)
Running OLS on a binary $y\in\{0,1\}$ is the LPM. It "works" but has three fatal flaws:
- fitted **probabilities can fall outside $[0,1]$**;
- errors are **heteroskedastic by construction** (Bernoulli variance $p(1-p)$);
- errors are **non-normal**.
So we instead push the linear index through a CDF that maps $\mathbb{R}\to(0,1)$.

### The latent-variable foundation
$$y_i^* = X_i\beta + \varepsilon_i, \qquad y_i = \mathbb{1}(y_i^* > 0), \qquad P(y_i=1\mid X)=F(X_i\beta).$$
The choice of $F$ (the CDF) gives the model. Both are estimated by **Maximum Likelihood**, not OLS.

| Model | $P(y=1\mid X)$ | CDF | Error dist. |
|---|---|---|---|
| **Logit** | $\Lambda(X\beta)=\dfrac{e^{X\beta}}{1+e^{X\beta}}$ | logistic | logistic |
| **Probit** | $\Phi(X\beta)$ | standard normal | $N(0,1)$ |

### Interpreting coefficients — three levels

> [!important] Never read a logit/probit coefficient like an OLS slope
> A coefficient $\beta_k$ acts on the **latent index / log-odds**, not directly on probability. The exam's favourite trap. You have three valid readings:
> 1. **Sign & significance** — always safe: "$x_k$ has a positive, significant effect on the probability that $y=1$."
> 2. **Odds ratio (logit only):** $e^{\beta_k}$. E.g. $e^{\beta}=1.05$ ⇒ a one-unit rise in $x_k$ raises the **odds** of $y=1$ by 5%. ($e^{2.71}\approx15$ was the oxygen effect in the Himalayan logit.)
> 3. **Marginal effect** — the actual probability change (below).

### Marginal effects
$$ME_k = \frac{\partial P(y=1\mid X)}{\partial x_k} = f(X\beta)\cdot\beta_k,$$
where $f$ is the **PDF** (normal for probit, logistic for logit). Because $f(X\beta)>0$, the ME shares the coefficient's sign and significance. Two flavours:
- **MEM** — marginal effect *at the mean* of the regressors (`atmean = TRUE`).
- **AME** — *average* of the individual marginal effects (generally preferred).
- For **dummy** regressors, use the discrete change $F(\dots\mid d=1)-F(\dots\mid d=0)$, not the derivative.

On the exam these are usually pre-computed (e.g. `logitmfx` / `probitmfx` output) — your job is to read them: "using oxygen raises the probability of success by 47 pp" (Himalayan), "women are 28.5 pp less likely to smoke" (2020).

### Goodness of fit (no real $R^2$ under MLE)

| Tool                            | What it tests / measures                                 | Read it                                                                                              |
| ------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Likelihood-ratio (LR) test**  | joint significance of all slopes (OLS $F$-test analogue) | $LR = -2(\ln L_{\text{restricted}} - \ln L_{\text{full}})\sim\chi^2_q$; reject ⇒ jointly significant |
| **McFadden pseudo-$R^2$**       | relative log-likelihood improvement                      | $1 - \dfrac{\ln L_{\text{full}}}{\ln L_{\text{null}}}$; **low** ($\sim0.2$–$0.4$ already "good")     |
| **Hit rate / confusion matrix** | classification accuracy at a cutoff (usually 0.5)        | % correctly classified                                                                               |
| **Hosmer–Lemeshow**             | calibration across deciles of $\hat p$                   | $H_0$: good fit ⇒ **want $p>0.05$**                                                                  |
| **ROC / AUC**                   | sensitivity vs 1−specificity trade-off                   | AUC from 0.5 (useless) to 1.0 (perfect)                                                              |

> [!warning] Direction traps in the GOF battery
> - **LR test:** reject $H_0$ ⇒ variables *are* jointly significant (you *want* a small $p$). Himalayan: $\chi^2=64.8$, $df=4$, $p\approx10^{-13}$.
> - **Hosmer–Lemeshow & friends (mHL, Osius–Rojek):** $H_0$ is *good fit*, so you *want a large $p$* — opposite direction. In the 2022/2023 complaints probit all GOF $p$-values exceeded 0.05 ⇒ no evidence of misfit.
> - **McFadden** is *not* OLS $R^2$ — values around 0.06–0.09 (as in 2020/2021) signal weak explanatory power, not a broken model.

### Code & practical workflow *(Lab 03)*

**Estimation.** Move from `lm()` to `glm()` for logit/probit. The LPM still uses `lm()` but **must** carry robust SEs (the heteroskedasticity is built in — same lesson as Lab 1):
```R
# LPM with mandatory robust SEs
lpm <- lm(y ~ x1 + x2, data = d)
coeftest(lpm, vcov = vcovHC(lpm, type = "HC1"))   # sandwich + lmtest

# Logit / Probit via MLE
logit  <- glm(y ~ x1 + x2, data = d, family = binomial(link = "logit"))
probit <- glm(y ~ x1 + x2, data = d, family = binomial(link = "probit"))
```

**Marginal effects** (`mfx` package) — `atmean = FALSE` gives the AME (the standard reporting metric); `TRUE` gives the MEM:
```R
logitmfx(y ~ x1 + x2, data = d, atmean = FALSE)   # AME
probitmfx(y ~ x1 + x2, data = d, atmean = FALSE)
```
Reading: an AME of $0.05$ for $x_1$ ⇒ a one-unit rise in $x_1$ raises $P(y=1)$ by **5 percentage points on average**.

**Goodness of fit.**
```R
# McFadden pseudo-R^2
1 - as.numeric(logLik(model) / logLik(null_model))

# Hit rate via confusion matrix (0.5 cutoff)
p   <- predict(logit, type = "response")
yhat <- ifelse(p > 0.5, 1, 0)
table(Actual = d$y, Predicted = yhat)            # hit rate = (TP+TN)/N

# ROC / AUC
library(pROC); auc(roc(d$y, p))
```
- McFadden: $0.2$–$0.4$ is already an excellent fit (don't expect OLS-like values).
- Hosmer–Lemeshow: $H_0$ = good fit ⇒ **want $p>0.05$**.
- AUC: $0.5$ = random guessing, $\to 1.0$ = superior prediction.

## Binary-DV cheat-block (for the A4 sheet)
- LPM flaws: $\hat p\notin[0,1]$, heteroskedastic, non-normal ⇒ use logit/probit (ML).
- Coefficient = effect on **latent index / log-odds**, *not* probability. Read via sign, odds ratio $e^\beta$ (logit), or marginal effect $f(X\beta)\beta_k$.
- MEM (at mean) vs AME (averaged, preferred); dummies → discrete change.
- LR test: $-2(\ln L_r-\ln L_f)\sim\chi^2_q$, reject ⇒ jointly significant. McFadden $=1-\ln L_f/\ln L_0$ (low is normal).
- Direction: LR/joint ⇒ want small $p$; HL calibration ⇒ want **large** $p$. AUC: 0.5 useless → 1 perfect.
- Code: `glm(..., family=binomial(link="logit"/"probit"))`; AME via `logitmfx(atmean=FALSE)`; LPM needs `vcovHC` robust SEs.

---

# §8 — Ordered logit & probit *(Lecture 04 + Lab 04)*

> [!note] Where this showed up
> The 2019 paper asked how to model `FiscCons`, a 7-point *very conservative → very liberal* scale — the answer is **ordered logit/probit**. Use it whenever categories are **ranked** but the spacing between them is unknown/unequal (credit ratings AAA→C, Likert 1=Bad/2=Neutral/3=Good). Treating such a variable as continuous (OLS) wrongly assumes equal intervals; treating it as unordered (multinomial) throws away the ranking.

### Latent variable + thresholds
Same latent index as §7, but now sliced into $J$ ordered bins by **cutpoints** (thresholds) $\mu_1 < \mu_2 < \dots < \mu_{J-1}$:
$$y_i^* = X_i\beta + \varepsilon_i, \qquad y_i = j \iff \mu_{j-1} < y_i^* \le \mu_j, \quad (\mu_0=-\infty,\ \mu_J=+\infty).$$

The probability of each category is the CDF mass between its two thresholds:
$$P(y_i = j \mid X_i) = F(\mu_j - X_i\beta) - F(\mu_{j-1} - X_i\beta),$$
with $F$ = logistic (**ordered logit**) or standard normal (**ordered probit**). Estimated by ML. In R: `MASS::polr(y ~ x, method = "logistic")` (or `"probit"`); the response must be an **ordered factor**.

### The parallel-regression (proportional-odds) assumption
Standard ordered models assume the **slopes $\beta$ are the same across all categories** — only the thresholds $\mu_j$ differ. Test it with the **Brant test** (`brant::brant(model)`):
- $H_0$: parallel-regression assumption holds (coefficients invariant across categories).
- Reject ($p < 0.05$) ⇒ assumption violated ⇒ standard ordered logit is invalid; switch to a **generalised ordered logit** (separate $\beta_j$ per category).

### Interpreting coefficients — the middle-category trap

> [!warning] A positive $\beta$ only pins down the two *ends*
> A positive coefficient means $P(\text{highest category})$ **rises** and $P(\text{lowest category})$ **falls**. The effect on every **intermediate** category is *mathematically ambiguous* from the sign alone — you must compute the marginal-effect equations to get its direction. Never state a sign-based effect for a middle category.

### Marginal effects sum to zero
For any regressor $x_k$, the marginal effects across all $J$ categories must add to exactly zero (a probability shifted into some bins must come out of others):
$$\sum_{j=1}^{J} \frac{\partial P(y=j)}{\partial x_k} = 0.$$

> [!tip] Exam hack
> If you're given the marginal effects for all but one category, solve for the missing one with the sum-to-zero property rather than recomputing it.

### Joint significance — LR test
As in §7: $LR = -2(\ln L_{\text{restricted}} - \ln L_{\text{full}}) \sim \chi^2_q$, where the restricted model has only thresholds (no slopes) and $q$ = number of explanatory variables. Reject ⇒ the regressors are jointly significant.

### Code & practical workflow *(Lab 04)*

**Estimation** uses `MASS::polr()` (proportional-odds logistic regression), *not* `glm()`. Two non-obvious requirements:
- the dependent variable must be an **ordered factor**;
- set **`Hess = TRUE`** so `polr` returns the Hessian and hence standard errors (it omits them by default).
```R
library(MASS)
d$y <- factor(d$y, ordered = TRUE, levels = c("1","2","3","4"))
ologit  <- polr(y ~ x1 + x2, data = d, Hess = TRUE)                 # ordered logit (default)
oprobit <- polr(y ~ x1 + x2, data = d, Hess = TRUE, method = "probit")
```

**Brant test** (check parallel regression *before* interpreting):
```R
library(brant); brant(ologit)   # omnibus + per-variable rows
```
$p > 0.05$ ⇒ assumption holds, proceed. $p < 0.05$ ⇒ violated ⇒ abandon `polr`, use a generalised ordered logit (`VGAM::vglm`).

**Marginal effects** across all categories (`erer::ocME`) — needed because coefficients only fix the end categories:
```R
library(erer); ocME(ologit)     # matrix: rows = regressors, cols = categories
```
Each row sums to 0 (the sum-to-zero property). A cell of $-0.03$ for $x_1$ in category 2 ⇒ a one-unit rise in $x_1$ lowers $P(\text{category }2)$ by 3 pp.

**Hit rate** — ordered predictions pick the **highest-probability category**, not a 0.5 cutoff:
```R
pred <- predict(ologit, type = "class")
cm   <- table(Actual = d$y, Predicted = pred)
hit  <- sum(diag(cm)) / sum(cm)
```

> [!tip] Binary vs ordered prediction
> In §7 you threshold a single probability at 0.5. Here `predict(type="class")` assigns each observation to whichever of the $J$ categories has the largest predicted probability — there is no single cutoff.

## Ordered-model cheat-block (for the A4 sheet)
- Ordinal $y$ (ranked, unequal spacing) ⇒ ordered logit/probit; $P(y=j)=F(\mu_j-X\beta)-F(\mu_{j-1}-X\beta)$.
- One slope vector, $J-1$ thresholds. **Brant test**: reject ⇒ parallel-regression fails ⇒ generalised ordered logit.
- $+\beta$ ⇒ top category up, bottom down; **middle categories ambiguous** (need MEs).
- $\sum_j \partial P(y=j)/\partial x_k = 0$ — use to back out a missing ME.
- LR test: $\chi^2$ with $df$ = number of regressors.
- Code: `MASS::polr(..., Hess=TRUE)` (ordered factor!); `brant()` test; `erer::ocME()` for MEs; `predict(type="class")` → highest-prob category.

---

# §9 — Multinomial & conditional logit *(Lecture 05 + Lab 05)*

> [!note] Where this showed up
> The **unordered** branch — categories with no ranking. 2020 *how-couples-meet* (MNL), 2022 *heating-system choice* (conditional logit), 2019 *candidate ∈ {Trump, Clinton, Johnson, Stein, Castle}* (MNL). This is the sibling of §8: **ranked ⇒ ordered (§8); unranked ⇒ multinomial/conditional (§9)**.

### The random utility model (RUM)
The theoretical foundation for all unordered choice. Individual $i$ faces $J$ mutually exclusive alternatives; the utility of choosing $j$ is
$$U_{ij} = V_{ij} + \varepsilon_{ij},$$
with $V_{ij}$ the deterministic (explainable) part and $\varepsilon_{ij}$ a random unobservable. **Decision rule:** pick $j$ iff it yields the highest utility, $U_{ij} > U_{ik}$ for all $k\neq j$. The distributional assumption on $\varepsilon$ (i.i.d. extreme-value) produces the logit form; *what enters $V$* (traits of the person vs traits of the options) splits MNL from CL.

### Which model? It hinges on what the regressors describe

| Model | Regressors describe… | Coefficients | R function |
|---|---|---|---|
| **Multinomial logit (MNL)** | the **individual** choosing (age, income, sex) — same value across alternatives | alternative-specific (one set per non-base category) | `nnet::multinom` |
| **Conditional logit (CL)** | the **alternatives** (price, travel time, installation cost) — vary across options | generic (one per attribute) | `mlogit` with `... | 1` |
| **"Mixed" (both)** | both individual- and alternative-specific vars | both | `mlogit` with `alt-specific | indiv-specific` |

> [!important] The exam discriminator
> 2020 couples = **MNL**: every covariate (age, sex, degree) is a property of the *person*, identical across "ways of meeting" → no alternative-specific data → MNL, not conditional. 2022 heating = **conditional**: `ic`/`oc` are costs of *each system* (vary across alternatives) → conditional logit. The presence of alternative-varying attributes is what makes it conditional.
> *Terminology caution:* `mlogit`'s both-types model is loosely called "mixed" here, but modern usage reserves **mixed logit** for random-parameters models. On the exam, call the `alt | indiv` specification a conditional logit with individual-specific terms.

### Probability formulas
- **MNL** (individual-specific $X_i$, normalise base $\beta_{\text{base}}=0$, estimate $J-1$ parameter sets):
$$P(y_i=j) = \frac{\exp(X_i\beta_j)}{\sum_{k=1}^{J}\exp(X_i\beta_k)}.$$
- **CL** (alternative-specific $Z_{ij}$, a single $\gamma$ shared across alternatives):
$$P(y_i=j) = \frac{\exp(Z_{ij}\gamma)}{\sum_{k=1}^{J}\exp(Z_{ik}\gamma)}.$$

The difference in a nutshell: in MNL the regressors don't change across $j$ but the **coefficients** do; in CL the **regressors** change across $j$ but there's one coefficient per attribute.

### Interpretation — relative to the base category
Pick a **base (reference) category**; all coefficients are read against it. Raw coefficients are log-odds; exponentiate to get the **Relative Risk Ratio (RRR)**:
$$\text{RRR}_k = e^{\beta_k}.$$
RRR $=1.05$ for income in category "Gang tattoo" ⇒ a one-unit rise in income raises the odds of *that* category **relative to the base** by 5%.

> [!warning] Don't read a raw coefficient as a probability effect
> Because probabilities across all alternatives sum to 1, the marginal effect of an individual-specific variable on category $j$ is **not** just $\beta_j$ — it's a function of *all* coefficients across *all* categories, and can even flip sign. On the exam, stick to the **sign / RRR-relative-to-base** reading unless full marginal effects are provided.

### The IIA assumption (the defining caveat)
Both MNL and CL assume **Independence of Irrelevant Alternatives**: the odds ratio between any two alternatives depends only on those two, not on what else exists:
$$\frac{P(y_i=j)}{P(y_i=k)} = \exp\!\big(X_i(\beta_j-\beta_k)\big),$$
which contains no terms from any third alternative.

> [!warning] The Red Bus / Blue Bus paradox
> A commuter splits 50/50 between **Car** and **Red Bus** (odds 1:1). Introduce a **Blue Bus** identical to the red one. IIA forces the 1:1 Car-vs-RedBus odds to hold, so the model predicts **Car 33% / Red 33% / Blue 33%**. Reality: the buses are perfect substitutes, so Car should stay ~50% and the buses split the other 50% (25/25). IIA fails whenever alternatives are close substitutes — that's the assumption's Achilles heel.

Test it:
- **Hausman–McFadden** (`mlogit::hmftest`): estimate the full model, then a restricted model dropping one alternative, and compare — if IIA holds, dropping an "irrelevant" alternative shouldn't change the other coefficients.
- **Small–Hsiao** is the other standard IIA test (data-partitioning).
- $H_0$: IIA holds. $p > 0.05$ ⇒ logit is valid; $p < 0.05$ ⇒ IIA violated ⇒ switch to **nested logit** or **multinomial probit**.

### Code & practical workflow *(Lab 05)*
```R
## MNL — individual-specific regressors (nnet)
d$y <- relevel(as.factor(d$y), ref = "None")          # set base category FIRST
mnl <- nnet::multinom(y ~ age + income, data = d)
exp(coef(mnl))                                         # RRR
predict(mnl, type = "probs")                           # predicted probs (sum to 1)

## CL / mixed — alternative-specific regressors (mlogit) needs LONG data
long <- dfidx(d, choice = "choice_var", shape = "wide", varying = c(3:8))
clogit <- mlogit(choice ~ price + time | 1, data = long)          # pure conditional
mixed  <- mlogit(choice ~ price + time | income + age, data = long) # both types

## IIA — Hausman–McFadden
full <- mlogit(choice ~ price | income, data = long)
rest <- mlogit(choice ~ price | income, data = subset(long, alt != "Bus"))
hmftest(full, rest)
```
Data shape is the usual stumbling block: `multinom` takes a normal wide data frame; `mlogit` needs **long format** (one row per person × alternative, with a 0/1 chosen flag), built via `dfidx`/`mlogit.data`.

## Multinomial/conditional cheat-block (for the A4 sheet)
- Unordered $y$ ⇒ MNL/CL. **MNL** = individual-specific regressors (`multinom`); **CL** = alternative-specific (`mlogit ... | 1`); both = `mlogit alt | indiv`.
- Interpret via **RRR** $=e^\beta$ relative to the **base category**; raw coeff ≠ probability effect (MEs depend on all coefficients; probs sum to 1).
- **IIA** assumption ⇒ test with **Hausman–McFadden** / Small–Hsiao; reject ⇒ nested logit or multinomial probit.
- `mlogit` needs **long data** (`dfidx`), one row per person×alternative; set base with `relevel(ref=...)`.
- Foundation = **RUM**: $U_{ij}=V_{ij}+\varepsilon_{ij}$, choose highest utility. MNL $P=\frac{e^{X\beta_j}}{\sum e^{X\beta_k}}$; CL $P=\frac{e^{Z_{ij}\gamma}}{\sum e^{Z_{ik}\gamma}}$.
- IIA: $P(j)/P(k)=e^{X(\beta_j-\beta_k)}$ — no third alternative. Fails for close substitutes (Red/Blue Bus).

---

# §10 — Models for count data *(Lecture 06 + Lab 06)*

> [!note] Where this showed up
> 2018 *biochemist publications* (Poisson vs NegBin vs ZIP vs ZINB, the overdispersion LR test, the zero-inflation score test, AIC selection) and 2020 *submissions-by-hour* (a Poisson on `as.factor(hour)`). The exam pattern: pick the right count model and read coefficients as IRRs.

### When and why
Count data: $y \in \{0,1,2,\dots\}$ — non-negative integers counting events (doctor visits, patents, accidents). OLS is wrong: it can predict **negative counts** and ignores the discrete, right-skewed, zero-heavy shape.

### Poisson regression (PRM)
A log-linear mean keeps predicted counts positive:
$$E(y_i\mid X_i) = \mu_i = \exp(X_i\beta).$$

> [!important] Equidispersion — the Poisson's defining (and fragile) assumption
> The Poisson forces mean = variance: $\;E(y_i\mid X_i) = \mathrm{Var}(y_i\mid X_i) = \mu_i$. Real count data almost always violate this.

### Negative Binomial (NBRM)
Adds a dispersion parameter $\alpha$ to let the variance exceed the mean:
$$\mathrm{Var}(y_i\mid X_i) = \mu_i + \alpha\mu_i^2.$$
If $\alpha = 0$ the NBRM **collapses back to Poisson** — which is exactly what the overdispersion test checks.

### Overdispersion
$\mathrm{Var} > E$. **Consequence:** a Poisson on overdispersed data keeps **consistent coefficients** but **underestimates the standard errors**, inflating $t$-stats ⇒ **Type I errors** (spurious significance). Test via the **LR test on $\alpha$**:
- $H_0: \alpha = 0$ (no overdispersion ⇒ Poisson); $H_A: \alpha > 0$ (⇒ Negative Binomial).
- Reject ($p<0.05$) ⇒ Poisson invalid, use NegBin. *2018 exam: $\chi^2 = 180.2$, $df=1$, $p<2.2\text{e-}16$ ⇒ strong overdispersion ⇒ NegBin over Poisson.*

### Excess zeros — Zero-Inflated models (ZIP / ZINB)
When zeros pile up beyond what Poisson/NegBin predict (e.g. cigarettes/day — many never-smokers), model the zeros as coming from **two processes**, estimated jointly:
1. a **binary (logit/probit)** part: "always-zero" vs "potential-count" group;
2. a **count (Poisson/NegBin)** part: the count for the potential-count group.
- **Zero-inflation test:** the lecture's **Vuong test** compares a non-nested PRM vs ZIP ($p<0.05$ ⇒ zero-inflated wins). *The 2018 exam instead used a **score test for zero inflation** ($\chi^2 = 133.9$, $p<2.2\text{e-}16$ ⇒ excess zeros).* Either way, the read is the same.
- **Final choice by AIC** across the four: in 2018, **ZINB had the lowest AIC (3138.98)** ⇒ best model. The hierarchy to remember: overdispersion pushes Poisson→NegBin; excess zeros push →zero-inflated; both ⇒ ZINB.

### Interpretation — IRR
Raw coefficients aren't linear effects. Exponentiate to the **Incidence Rate Ratio**:
$$\text{IRR} = \exp(\beta_k).$$
A one-unit rise in $x_k$ multiplies the expected count by IRR: $e^{\beta}=1.25 \Rightarrow +25\%$; $e^{\beta}=0.80 \Rightarrow -20\%$. For the change in the *number* of events, use the marginal effect:
$$\frac{\partial E(y_i\mid X_i)}{\partial x_k} = \beta_k\,\exp(X_i\beta) = \beta_k\,\mu_i.$$

### Code & practical workflow *(Lab 06)*

**Step 0 — eyeball the dispersion** before modelling: compare `mean(d$y)` vs `var(d$y)`; if the variance is much larger, overdispersion is likely.

```R
## Poisson
pois <- glm(y ~ x1 + x2, data = d, family = poisson(link = "log"))

## Formal overdispersion test (Cameron–Trivedi)
library(AER); dispersiontest(pois)          # p<0.05 ⇒ overdispersed ⇒ go NegBin

## Negative Binomial (estimates alpha)
library(MASS); nb <- glm.nb(y ~ x1 + x2, data = d)
library(lmtest); lrtest(pois, nb)           # p<0.05 ⇒ NB beats Poisson

## Zero-inflated (pscl): count part | zero part
library(pscl)
zip  <- zeroinfl(y ~ x1 + x2 | z1 + z2, data = d, dist = "poisson")
zinb <- zeroinfl(y ~ x1 + x2 | z1 + z2, data = d, dist = "negbin")
vuong(pois, zip)                            # p<0.05 ⇒ zero-inflated preferred

## IRR
exp(coef(nb))                               # IRR = e^beta
```

Two test names map to the same decisions from §10: `dispersiontest` (and `lrtest` on $\alpha$) settles Poisson vs NegBin; `vuong` settles standard vs zero-inflated. The `zeroinfl` formula's two parts (`count | zero`) are the count model and the logit "always-zero" model respectively.

## Count-data cheat-block (for the A4 sheet)
- $y\in\{0,1,2,\dots\}$ ⇒ Poisson $\mu=\exp(X\beta)$; **equidispersion** mean=var.
- Overdispersion (var>mean): Poisson coeffs OK but **SEs too small** ⇒ Type I errors. LR test $\alpha=0$: reject ⇒ **NegBin** ($\mathrm{Var}=\mu+\alpha\mu^2$).
- Excess zeros ⇒ **ZIP/ZINB** (logit "always-zero" + count part); test via **Vuong** (or score test). Pick final model by **AIC** (both problems ⇒ ZINB).
- Interpret with **IRR** $=e^{\beta}$ (multiplicative on expected count); ME $=\beta_k\mu_i$.
- Code: `glm(poisson)` + `AER::dispersiontest`; `MASS::glm.nb` + `lrtest`; `pscl::zeroinfl(count | zero, dist=)` + `vuong`; IRR `exp(coef())`.

---

# §11 — Censored data & sample selection: Tobit + Heckman *(Lecture 07 + Lab 07)*

> [!note] Where this showed up
> 2023 *college GPA* censored at 2.0 — the Tobit question that asked "corner solution **or** censoring?" and for the marginal effect on $E(y)$. Heckman wasn't on the mocks I've seen, but it's squarely on the syllabus. The pairing is deliberate: both involve a "limited/missing" $y$, but the *reason* (and the fix) differ.

## A. Tobit — censored data

The dependent variable is restricted to a range, classically bounded at 0: a chunk of observations pile up at the limit, the rest are positive continuous (alcohol spending, hours worked). OLS fails **both** ways:
- on the **full** sample (zeros included) it ignores the discrete–continuous mix → biased & inconsistent;
- on the **positive-only** sub-sample it drops a non-random segment (truncation) → also biased.

**Latent-variable setup** (same machinery as §7–§8):
$$y_i^* = X_i\beta + \varepsilon_i, \qquad y_i = \begin{cases} y_i^* & \text{if } y_i^* > 0 \\ 0 & \text{if } y_i^* \le 0. \end{cases}$$
Estimated by ML.

> [!important] Interpretation trap — three different quantities
> The raw $\beta_k$ is the marginal effect on the **latent** $y^*$, **not** on the observed $y$. For the observed outcome you scale $\beta_k$ by the probability of being uncensored:
> - on $y^*$ (latent): $\beta_k$;
> - on $E(y\mid x)$ (unconditional observed): $\beta_k \cdot \Phi(X\beta/\sigma)$;
> - on $E(y\mid x, y>0)$ (uncensored only): a smaller adjusted factor.
> In the 2023 exam these three columns were printed side by side and happened to coincide (the scale factor was ≈1 because almost all mass sat above the censoring point).

> [!warning] Corner solution vs data censoring (the 2023 exam's part b)
> The Tobit math is identical, but the *interpretation* differs:
> - **Corner solution:** the pile-up is a *genuine optimal outcome* (zero hours worked, zero donation) — the limit value is real behaviour.
> - **Data censoring:** the true $y^*$ exists but is *hidden/recorded at the threshold* (GPAs below 2.0 reported as 2.0 for confidentiality). The 2023 case was **data censoring**, not a corner solution — calling it a corner solution loses the mark.

## B. Heckman — sample selection bias

**Incidental truncation:** $y$ is observed only for a non-random, *self-selected* subset (wages only for people who choose to work). If the unobservables driving the *selection* decision correlate with those driving the *outcome*, OLS on the observed subsample is biased — **sample selection bias**.

**Two equations:**
$$\text{Selection (binary): } z_i^* = W_i\gamma + u_i,\quad z_i=\mathbb{1}(z_i^*>0); \qquad \text{Outcome: } y_i = X_i\beta + \varepsilon_i \text{ (seen only if } z_i=1).$$
Bias arises iff $\rho = \mathrm{corr}(u_i,\varepsilon_i) \neq 0$.

**Heckman two-step correction:**
1. **Probit** of $z$ on $W$ over the *whole* sample → compute the **Inverse Mills Ratio** $\lambda_i$ (the "nonselection hazard") for each observation; $\lambda$ measures the size of the selection effect.
2. **OLS** of $y$ on $X$ over the *selected* sample, **adding $\lambda$ as a regressor**:
$$y_i = X_i\beta + \beta_\lambda\,\lambda_i + v_i.$$

> [!important] Exclusion restriction (the identification key)
> For the model to be identified by more than just functional-form/nonlinearity, $W$ must contain **at least one variable not in $X$** — something that affects *selection* but not the *outcome*. Classic example: number of young children drives the *decision to work* ($W$) but not the *hourly wage* ($X$). Without an exclusion restriction the Heckman correction is fragile (identified only off the IMR's nonlinearity, often collinear).

### Testing for selection bias
Look at the **$t$/$p$ on the IMR coefficient $\beta_\lambda$** in the Step-2 regression:
- $p < 0.05$ ⇒ IMR significant ⇒ **selection bias present** ⇒ keep the Heckman correction.
- $p > 0.05$ ⇒ no significant selection ⇒ plain OLS on the observed sample is consistent.

### Code & practical workflow *(Lab 07)*

```R
## Tobit — left-censored at 0 (AER; censReg also works), ML
library(AER)
tob <- tobit(y ~ x1 + x2, left = 0, right = Inf, data = d)
library(margins); margins(tob)     # marginal effects on the OBSERVED y, not the raw latent betas

## Heckman two-step (sampleSelection)
library(sampleSelection)
heck <- selection(
  selection = obs ~ w1 + w2 + x1,  # probit; w1,w2 affect selection, NOT outcome = exclusion restriction
  outcome   = y   ~ x1 + x2,       # OLS
  data = d, method = "2step")
summary(heck)                      # inspect invMillsRatio (lambda) / rho: p<0.05 ⇒ selection bias present
```
Two reminders straight from the theory: use `margins(tob)` because the raw Tobit coefficients are latent-$y^*$ effects, not observed-$y$ effects; and `w1`/`w2`-in-selection-only is the **exclusion restriction** that identifies the Heckman model.

## Censored/selection cheat-block (for the A4 sheet)
- **Tobit** = censored $y$ (pile-up at a limit). OLS biased both on full sample and positive-only. $y=\max(0,y^*)$, $y^*=X\beta+\varepsilon$, ML.
- Tobit $\beta$ = effect on **latent** $y^*$; observed effect = $\beta\cdot\Phi(X\beta/\sigma)$. **Corner solution** (real zeros) ≠ **data censoring** (hidden true value).
- **Heckman** = sample selection ($y$ seen only if selected). Bias if $\rho=\mathrm{corr}(u,\varepsilon)\neq0$.
- Two-step: (1) probit on $W$ → **IMR $\lambda$**; (2) OLS on selected sample + $\lambda$. **Exclusion restriction**: a var in $W$ not in $X$.
- Test selection: significance of $\lambda$ — significant ⇒ bias ⇒ Heckman; insignificant ⇒ OLS fine.

---

# §12 — Methodology: GETS, Monte Carlo & project tips *(Lecture 08 + Lab 08)*

> [!note] Where this showed up — and your project
> The GETS reduction *is* the mechanism behind the nested-model columns on the exams: 2019 *Trump logit* (models 1→4) and 2020 *out-of-hours logit* (models 1→3) both delete variables down to a parsimonious final model, chosen by AIC. It's also the gold-standard strategy for the **empirical project** — you *derive* the final model, you don't guess it.

### The idea
Start broad and shrink: begin with every theoretically relevant term, then prune the statistically dead wood one piece at a time until only significant, well-behaved regressors remain. The opposite of specific-to-general (adding variables until something sticks), and far less prone to data-mining bias.

### The algorithm
1. **Estimate the GUM** (General Unrestricted Model) — throw in every theoretically justified variable, plus relevant interactions and squared terms.
2. **Diagnostic-check the GUM first** — heteroskedasticity, autocorrelation, non-normality of residuals. If it fails, *fix the GUM before deleting anything* (e.g. robust SEs, a log transform, added dynamics). A reduction built on a misspecified GUM is worthless.
3. **Stepwise deletion** — find the regressor with the **highest $p$-value** (most insignificant), delete **only that one**, re-estimate, and repeat until everything left is significant (at $\alpha = 0.05$ or $0.10$).
4. **Final verification** — confirm the specific model still passes the diagnostics and makes economic sense.

> [!warning] Never delete a block of variables at once
> Because of multicollinearity, removing one variable can swing the $p$-values of the others. Drop **one at a time** and re-estimate — the single most common GETS mistake. (This is also why on the 2019 exam the individually-insignificant terms had to be checked *jointly* before removal.)

### Project / exam execution tips
- **Log-transform** a heavily skewed continuous dependent variable ($\ln y$) — often cures heteroskedasticity and non-normality in the GUM at a stroke.
- **Non-nested models** (e.g. Poisson vs log-linear OLS): $R^2$ is not comparable — choose by **AIC/BIC** (lowest wins). This is the same selection logic used across §7–§10.
- The reduction must stay **theory-disciplined**: keep a variable that's central to the hypothesis even if borderline, and don't let an automated stepwise routine override economic sense.

### Testing restrictions in practice *(Lab 08)*

When deciding whether a variable (or block) can be dropped, formally test the restriction. The goal is a **high $p$-value** ($p>0.05$): fail to reject $H_0$ ⇒ the restriction holds ⇒ safe to delete.

| Approach | Tests | Needs | R |
|---|---|---|---|
| **ANOVA** (F-test) | is the full model better than the reduced one? | **both** models estimated | `anova(reduced, full)` |
| **Wald / linear hypothesis** | specific restrictions within one model, e.g. $H_0:\beta_3=\beta_4=0$ | **only the full** model | `car::linearHypothesis(full, c("x3=0","x4=0"))` |

Two practical pitfalls from the lab exercises:
- **Block-deletion trap** (the 37-variable `crime.csv` case): don't drop ten insignificant variables at once. Multicollinearity means removing one shifts the SEs and $p$-values of the rest — a variable that looks dead in the GUM can become highly significant once a collinear partner leaves. Delete **one at a time**.
- **Dummy/categorical blocks** (the `nlsw88` `industry` variable): a categorical predictor is a *block* of dummies. Test the whole block with `anova`/Wald; if the block is jointly significant, **keep all its dummies** even if one or two individual $p$-values are high — don't cherry-pick categories.

## GETS cheat-block (for the A4 sheet)
- GUM (all terms) → **diagnose & fix first** → delete highest-$p$ var **one at a time** → re-estimate → repeat → verify diagnostics + economics.
- Never delete blocks (multicollinearity shifts $p$-values); test jointly if unsure.
- Non-nested choice ⇒ **AIC/BIC**, not $R^2$. Skewed $y$ ⇒ try $\ln y$.

### Monte Carlo simulation
A computational way to check an estimator's *true* properties (unbiasedness, efficiency) when, in real data, the population parameters are unknown. You "play God": define a known **data-generating process**, simulate it many times, and study the distribution of the estimates.
1. Fix true parameters (say $\beta_0=1$, $\beta_1=2$).
2. Randomly draw the regressors $X$ and an error $\varepsilon\sim N(0,\sigma^2)$.
3. Build $y = \beta_0 + \beta_1 X + \varepsilon$.
4. Estimate `lm(y ~ x)`; store $\hat\beta_1$ and its $p$-value.
5. Repeat ~1000 times (`N.iter = 1000`).

The histogram of the 1000 $\hat\beta_1$ values should center on the true $2$ ⇒ **unbiased**; its spread illustrates efficiency, and the share of $p<0.05$ illustrates size/power. This is the engine behind a lot of the "what happens to OLS when an assumption breaks" intuition (e.g. it stays centered but its SEs misbehave — exactly the Lab 1 / panel-robust lesson).

### Empirical-project writing — "less is more"
The lecture's explicit warning: cut the fluff. Orwell's rule — *if a word can be cut, cut it.* A good econometrics report is economic justification → methodology (GETS) → diagnostics → coefficient interpretation, and little else. (This matches your own concise-prose preference — front-load the result, keep caveats short.)

---

# §13 — Introduction to time series & forecasting *(Lecture 08 bridge + Lecture 09)*

> [!note] The course's second half starts here
> Everything from §13 onward is **time series**, where most of the remaining mock-exam questions live (stationarity/ADF, ARDL multipliers, cointegration/ECM, spurious regression). Lecture 09 picks up spurious regression next.

### Three data structures, recapped
- **Cross-sectional** — many objects, one moment (an election poll).
- **Panel** — many objects over several periods (GDP for 27 EU states over 10 years) — §6.
- **Time series** — a *single* object over many consecutive periods (daily prices, monthly inflation).

> [!important] Chronological order is information
> A time series is strictly ordered in time, and an observation today typically depends on its own past. You **cannot shuffle the rows** without destroying the structure — the opposite of a random cross-sectional sample. This dependence is exactly what the rest of the course models (and what makes OLS on trending series dangerous — the spurious-regression problem in §14).

### Stationarity — the concept *(full treatment in §15)*
A series is **stationary** if its behaviour doesn't change over time — it varies around a **constant mean** with **constant variability**. Non-stationary series (shifting mean and/or variance) are, in practice, the **rule rather than the exception**. Stationarity is the gatekeeper for the whole time-series block: it decides whether OLS is valid, whether a regression is spurious (§14), and whether two series can be cointegrated. Formal definitions and tests (ADF/KPSS/PP) come in §15.

### Three modeling philosophies
| Philosophy | Models $y_t$ from… | Examples |
|---|---|---|
| **Time-series models (TSM)** | its **own history** (autocorrelation, trend, seasonality) | ARIMA, GARCH |
| **Econometric / structural** | **other explanatory variables** | Distributed Lag (DL), OLS |
| **Hybrid** | both | ARDL, ARIMAX, ECM |

**The structural → non-structural shift.** Economists once forecast with huge structural models (thousands of equations). These failed badly in the 1970s–80s (missing stagflation and recessions) because the underlying data-generating processes kept shifting. Modern forecasting leans **non-structural**: a variable as a function of its own lags, lagged errors, and exogenous trends — exactly the ARMA/ARIMA/ARDL machinery coming up.

### Forecasting & evaluation
Forecasting — anticipating the future path of a series — is the main goal of TSA. Every forecast carries a random error; a forecast is "good" not if it's flawless but if it **beats the alternatives** (rival models or naive guessing).

**Evaluation strategy:** split the sample into an **in-sample** period (estimate the model) and an **out-of-sample** period (generate forecasts and measure error). The realised *ex-post* error proxies the unknown *ex-ante* error. With $h = T - T_s$ out-of-sample points and forecasts $y_t^*$:

$$\text{MAE} = \frac{1}{h}\sum_{t=T_s+1}^{T}\lvert y_t - y_t^*\rvert, \qquad \text{MSE} = \frac{1}{h}\sum_{t=T_s+1}^{T}(y_t - y_t^*)^2,$$
$$\text{MAPE} = \frac{1}{h}\sum_{t=T_s+1}^{T}\left\lvert\frac{y_t - y_t^*}{y_t}\right\rvert\cdot 100\%.$$

MAE and MAPE weight errors evenly; MSE punishes large misses (squared); MAPE is scale-free (a %) but blows up when $y_t$ is near zero.

### R time-series objects
A plain `data.frame` doesn't understand time; convert to a TS object first.

| Class | Package | Best for | Index requirement |
|---|---|---|---|
| **`ts`** | base R | strictly **regular** spacing (annual/quarterly/monthly macro) | rigid; can't handle irregular gaps (e.g. daily trading data skipping weekends) |
| **`zoo`** | `zoo` | **irregular** spacing | flexible — any index (dates, timestamps, or an arbitrary numeric sequence) |
| **`xts`** | `xts` | financial/economic TS (industry standard) | built on `zoo` but the index **must be a formal date/time class** (`Date`, `POSIXct`/`POSIXlt`) ⇒ enables powerful date subsetting/merging |

Rule of thumb: regular macro series → `ts`; messy/irregular → `zoo`; serious date-based financial work → `xts`.

## Time-series intro cheat-block (for the A4 sheet)
- TS = one object over ordered time; **rows can't be shuffled** (today depends on the past).
- **Stationary** = constant mean & variance over time; non-stationarity is the norm (gatekeeper for §14–§16).
- Philosophies: **TSM** (own history: ARIMA/GARCH) / **structural** (other vars: DL/OLS) / **hybrid** (ARDL/ARIMAX/ECM). Modern forecasting = non-structural.
- Evaluate out-of-sample: **MAE** (even), **MSE** (punishes big misses), **MAPE** (scale-free %, fails near $y\approx0$).
- R objects: `ts` (regular, rigid) → `zoo` (irregular, any index) → `xts` (zoo + strict date class, financial standard).
- Trending TS + OLS ⇒ spurious-regression risk (→ §14).

---

# §14 — Spurious regression *(Lab 08 + Lab 09)*

> [!note] Where this showed up
> The "is the relationship real or spurious?" question — 2020 *mink/muskrat* and 2023 *mobile vs fixed phones*. Both hinge on integration orders and cointegration. Lecture 09 will flesh out the theory; this is the practical warning from Lab 08.

### The problem
Regress a trending variable $Y$ on a completely **unrelated** trending variable $X$, and OLS will usually report a **huge $R^2$ and highly significant $t$-statistics** — purely because both grow over time, not because of any real link. This is the classic trap of two $I(1)$ series.

### Why it happens
The estimated slope is contaminated by the omitted shared time trend:
$$\hat\alpha_1 = \beta_1 + \beta_2 \cdot \frac{\mathrm{Cov}(X,\text{Time})}{\mathrm{Var}(X)}.$$
The second term is pure trend-on-trend correlation — it inflates the coefficient and its significance even when the true $\beta_1 = 0$.

### The rule
**Correlation ≠ causation**, doubly so in time series. Before trusting any time-series regression:
1. test each series for **stationarity** (ADF/KPSS — §15 to come);
2. if both are $I(1)$, test for **cointegration** — is the linear combination $Y_t - \beta X_t \sim I(0)$ stationary?

If two non-stationary series are **not cointegrated**, the regression is **spurious** and the results are meaningless. The tell-tale signs: very high $R^2$, strong $t$, but (you'll learn) a low Durbin–Watson and non-stationary residuals.

> [!tip] The exam reflex
> "Real or spurious?" is never answered from $R^2$ alone — in fact a suspiciously high $R^2$ on trending data is the *warning*, not the reassurance. Establish integration orders first, then cointegration; only a cointegrated pair (or stationary series) supports a genuine relationship. This is exactly the logic the 2020 and 2023 papers tested.

### The Newbold–Davis experiment (Monte Carlo evidence) *(Lab 09)*
The lab proves spuriousness by simulation. Generate **two completely independent random walks** $X$ and $Y$; since they're unrelated, a regression $Y\sim X$ *should* show $X$ insignificant ~95% of the time. It doesn't:

| Symptom | What you see | Why |
|---|---|---|
| **Inflated $t$-statistics** | $X$ flagged "significant" far more than 5% of the time | the shared accumulating trend correlates the levels |
| **High $R^2$** | looks like great explanatory power | spurious common drift |
| **Durbin–Watson ≈ 0** | massive positive residual autocorrelation | residuals inherit the $I(1)$ trend, nowhere near the ideal DW ≈ 2 |

The control case confirms it: regressing two independent **white-noise** series (`e1 ~ e2`) behaves correctly (insignificant ~95% of the time); only the **random-walk** pair (`y ~ x`) blows up — the 5th percentile of the simulated $t$-stats lies far outside the Student-$t$ bounds.

```R
library(lmtest)   # dwtest() — Durbin–Watson
library(fBasics)  # basicStats() — summarise the simulated t-distribution
quantile(results_yx$t, 0.05)   # 5% tail of simulated t-stats: spuriously inflated
```

> [!tip] DW is the giveaway
> A high $R^2$ with a **near-zero Durbin–Watson** is the classic spurious-regression fingerprint — the symptom that tells you to stop and test for stationarity/cointegration rather than believe the $t$-stats.

## Spurious-regression cheat-block (for the A4 sheet)
- Two unrelated $I(1)$ series ⇒ OLS gives high $R^2$ + significant $t$ but it's **meaningless**.
- Bias: $\hat\alpha_1=\beta_1+\beta_2\frac{\mathrm{Cov}(X,\text{Time})}{\mathrm{Var}(X)}$ (shared trend).
- Fix the logic: test stationarity → if $I(1)$, test cointegration; not cointegrated ⇒ spurious. High $R^2$ on trending data = red flag, not proof.

---

# §15 — Stationarity, random walks & unit-root testing *(Lab 09 + Lecture 10 + Lab 10)*

> [!note] The engine of every time-series exam question
> The integration-order analysis you ran on all six mock papers (2018/2019 marriage ages, 2020 mink/muskrat, 2021 tax, 2022 Unilever, 2023 phones) lives here. Lab 09 introduced the basic Dickey–Fuller test; Lecture 10 adds the formal definition and the **ADF/PP/KPSS** trio — the actual `testdf` exam technique.

### Stationary vs non-stationary
- **Stationary:** statistical properties constant over time — **constant mean** (no trend), **constant variance** (no changing volatility), stable autocorrelation. Canonical example: **white noise** $\varepsilon_t$ (random, mean zero, no structure).
- **Non-stationary:** trends or shifting volatility. Canonical example: the **random walk**
$$y_t = y_{t-1} + \varepsilon_t,$$
which drifts with no stable mean and an **ever-increasing variance** (today = yesterday + a fresh shock that never dies out).

### Weak (covariance) stationarity — the formal definition
$y_t$ is **weakly stationary** if all three hold:
1. **constant, finite mean:** $\mathbb{E}(y_t) = \mu < \infty$;
2. **constant, finite variance:** $\mathrm{Var}(y_t) = \sigma^2 < \infty$;
3. **stable autocovariance:** $\mathrm{Cov}(y_t, y_{t+h}) = \gamma_h$ depends only on the lag $h$, never on the time $t$.

Stationarity is what gives the usual test statistics their valid distributions — without it, standard inference (the $t$- and $F$-tests you trust in OLS) breaks down.

### Differencing — the fix
Models like ARIMA require stationary data. To tame a random walk or trend, **difference** it:
$$\Delta y_t = y_t - y_{t-1}.$$
For a pure random walk this isolates the white noise exactly: $\Delta y_t = \varepsilon_t$, which is stationary. A series needing $d$ differences to become stationary is **integrated of order $d$**, $I(d)$; a random walk is $I(1)$.

### The Dickey–Fuller (DF) test
Formal test for a **unit root** (i.e. a non-stationary random walk):
- $H_0$: the series **has a unit root** ⇒ **non-stationary**.
- $H_A$: no unit root ⇒ **stationary**.
- Decision: $p > 0.05$ ⇒ **fail to reject** ⇒ non-stationary ⇒ difference before modelling. $p < 0.05$ ⇒ stationary.

> [!important] Three DF specifications — pick by the series' look
> - **Type I** — no constant, no trend (series fluctuates around 0, e.g. a differenced series).
> - **Type II** — constant, no trend (fluctuates around a non-zero mean).
> - **Type III** — constant + trend (a trending series).
> Choosing the wrong type (e.g. a "no constant" test on a series with a large non-zero mean) costs you power and can flip the conclusion — a subtle point that mattered in the 2020 mink/muskrat reading.

> [!warning] Direction trap (carries into the exam)
> DF/ADF $H_0$ = *non-stationary*. So **failing to reject (large $p$) means a unit root / non-stationary** — the opposite intuition to most tests. The **KPSS** test (below) reverses this, and the 2021 & 2023 exams tested exactly that pairing.

### The unit-root test trio: ADF, PP, KPSS *(Lecture 10)*
The basic DF generalises to three workhorse tests. The crucial thing is **which way the null points**.

| Test | $H_0$ | Reject ($p<0.05$) ⇒ | Notes |
|---|---|---|---|
| **Augmented DF (ADF)** | unit root, $I(1)$ (non-stationary) | **stationary** | adds lagged differences to clean residual autocorrelation; **you must choose the lag/augmentation** |
| **Phillips–Perron (PP)** | unit root (non-stationary) | **stationary** | robust to heteroskedasticity; **no manual lag choice** needed |
| **KPSS** | **stationary**, $I(0)$ | **non-stationary** | reversed null; one-sided right-tailed (stat > critical ⇒ reject) |

> [!important] The KPSS reversal — the exam's favourite confusion
> ADF/PP and KPSS point in **opposite directions**. Reject in **ADF/PP** ⇒ **stationary** (safe to use). Reject in **KPSS** ⇒ **non-stationary** (needs differencing). When they *agree* you're confident; when they *conflict* (2023 Sweden phones: PP said stationary, KPSS said non-stationary) the series likely has a trend or structural break — investigate, don't cherry-pick the convenient verdict.

**The exam's ADF lag rule.** ADF needs a lag length (the "augmentations"). The `testdf` workflow you used on every paper picks it via Breusch–Godfrey: read the ADF at the **smallest augmentation where all BG $p$-values exceed 0.05** (no residual autocorrelation). PP sidesteps this choice entirely.

### Pitfalls of unit-root tests
1. **Low power near the boundary.** ADF and PP struggle to reject a unit root when a series is highly persistent but technically $I(0)$ — a near-$I(1)$ stationary process easily looks non-stationary. (Part of why the marriage-age and mink levels read as non-stationary.)
2. **Deterministic-term penalty.** Power falls as you add deterministic terms: a "constant + trend" (Type III) regression rejects a false $H_0$ far less easily than a "constant only" (Type II) one. Don't over-specify the deterministic part.

### Practical (R, from the lab)
Lab 09 used simulation tooling — `lmtest::dwtest` (Durbin–Watson), `fBasics::basicStats`, and `quantile(..., 0.05)` to expose the spurious-regression inflation in §14. Lab 10 does the real unit-root testing with the **`urca`** package (plus `tseries`, `xts`).

**The integration-order workflow:**
1. Test the series **in levels**. Stationary ⇒ $I(0)$, done.
2. If non-stationary, **difference** it (`diff.xts(y)`).
3. Test the differenced series. Stationary ⇒ the original is $I(1)$.

**The "rule of three":** run **ADF + PP + KPSS together**. If all agree, the verdict is robust; if they conflict, look at the plot and lean on the **1% level**.

```R
library(urca); library(tseries); library(xts)

## ADF — H0: unit root. type matches the series' look; AIC picks lags
adf <- ur.df(d$y, type = "drift", selectlags = "AIC")   # none / drift / trend
summary(adf)   # reject H0 (⇒ stationary) if tau stat is MORE NEGATIVE than the 5% crit

## PP — H0: unit root; non-parametric HAC correction, no lag choice
pp <- ur.pp(d$y, type = "Z-tau", model = "constant")     # constant / trend
summary(pp)   # reject (⇒ stationary) if stat smaller (more negative) than crit

## KPSS — H0: STATIONARY (reversed)
kpss <- ur.kpss(d$y, type = "mu")                        # mu = constant, tau = +trend
summary(kpss)  # reject (⇒ NON-stationary) if stat GREATER than crit
```

The `type`/`model` argument maps to the DF specifications: `none`/`drift`/`trend` (ADF), `constant`/`trend` (PP), `mu`/`tau` (KPSS). Match it to the series — around zero / around a non-zero mean / trending.

> [!example] Reading conflicting output (S&P 500)
> **Level:** ADF fails to reject, PP fails to reject, KPSS rejects ⇒ all three say **non-stationary** ⇒ `diff()` it.
> **Differenced:** ADF rejects, PP rejects, KPSS fails to reject ⇒ all three say **stationary**.
> Conclusion: the original level is **$I(1)$**. This level→difference→retest loop is exactly the integration-order reasoning behind every mock-exam answer.

## Stationarity cheat-block (for the A4 sheet)
- **Weak stationary** = constant finite mean + constant finite variance + autocovariance depends only on lag $h$ (not $t$).
- Random walk $y_t=y_{t-1}+\varepsilon_t$ = non-stationary, $I(1)$, variance grows. **Difference**: $\Delta y_t=\varepsilon_t$; needs $d$ diffs ⇒ $I(d)$.
- **ADF / PP**: $H_0$ = unit root → reject ⇒ **stationary**. **KPSS**: $H_0$ = stationary → reject ⇒ **non-stationary**. (Opposite directions — the classic trap.)
- PP robust to heteroskedasticity & no lag choice; **ADF lag = smallest augmentation with clean Breusch–Godfrey** ($p>0.05$).
- DF types: I (none), II (constant), III (constant+trend) — match to the series; more deterministic terms ⇒ less power.
- Pitfalls: low power for highly persistent (near-$I(1)$) series; conflicting ADF/KPSS ⇒ suspect trend/break.
- Code (`urca`): `ur.df(type=none/drift/trend, selectlags="AIC")`, `ur.pp(model=constant/trend)`, `ur.kpss(type=mu/tau)`. **Rule of three**: run all 3; conflict ⇒ plot + 1% level. Workflow: test level → diff → retest ⇒ $I(0)$/$I(1)$.

---

# §16 — DL & ARDL models *(Lecture 11 + Lab 11)*

> [!note] Where this showed up — the multiplier questions
> The long-run multiplier you computed on the **2020** (mink/muskrat `dl_3` → 0.19), **2021** (tax ARDL → 0.168) and **2023** (phones) papers comes straight from here. The model-selection-by-clean-residuals logic (the 2020 `dl_1`/`dl_2`/`dl_3` choice) is the Breusch–Godfrey test below.

### Why dynamic models
In cross-section, effects are instantaneous; in time series a change in $X$ today can move $Y$ today, next period, and beyond. Three ways to capture it:
- **DL** — lagged $X$ only;
- **AR** — lagged $Y$ only;
- **ARDL** — both.

### Distributed-lag (DL) model
$$y_t = \mu + \beta_0 x_t + \beta_1 x_{t-1} + \dots + \beta_p x_{t-p} + \varepsilon_t.$$
Multipliers:
- **Impact (contemporaneous):** $\beta_0$ — effect of a one-unit change in $x_t$ on $y_t$ now.
- **Interim:** $\beta_i$ — the delayed effect after $i$ periods.
- **Long-run / total:** for a finite DL, just the **sum** $\beta_{LT} = \sum_{i=0}^{p}\beta_i$ — cumulative effect of a *permanent* one-unit rise in $X$.

DL models suffer **multicollinearity** ($x_t$ and $x_{t-1}$ move together) and df loss — which motivates ARDL.

### ARDL model
$$y_t = \mu + \alpha_1 y_{t-1} + \dots + \alpha_p y_{t-p} + \beta_0 x_t + \dots + \beta_q x_{t-q} + \varepsilon_t.$$
Adding lagged $y$ acts as a parsimonious proxy for infinitely many past $X$ lags.

> [!important] The long-run multiplier — the formula you've used twice
> In steady state the variables stop changing: $y_t=y_{t-1}=y^*$, $x_t=x_{t-1}=x^*$. Solving gives
> $$\beta_{LT} = \frac{\Delta y^*}{\Delta x^*} = \frac{\sum_{i=0}^{q}\beta_i}{1-\alpha_1-\dots-\alpha_p}.$$
> A permanent one-unit rise in $X$ eventually moves $Y$ by $\beta_{LT}$. The numerator sums the $X$ coefficients; the denominator is $1$ minus the sum of the lagged-$Y$ coefficients.
> - **2020 `dl_3`:** $\dfrac{0.0623}{1-0.672} \approx 0.19$.
> - **2021 tax:** $\dfrac{0.1006}{1-0.401} \approx 0.168$.
> Forgetting the $(1-\sum\alpha)$ denominator (reporting only $\sum\beta$, the short-run/DL answer) is the classic lost mark.

### Diagnostics: use Breusch–Godfrey, NOT Durbin–Watson

> [!warning] DW is invalid with a lagged dependent variable
> An ARDL contains $y_{t-1}$, which makes the **Durbin–Watson** statistic **biased toward 2** — it will falsely signal "no autocorrelation." You must use the **Breusch–Godfrey (BG)** test instead.

BG mechanics:
1. estimate the model, take residuals $\hat\varepsilon_t$;
2. regress $\hat\varepsilon_t$ on all original regressors **plus** lagged residuals $\hat\varepsilon_{t-1},\dots,\hat\varepsilon_{t-p}$;
3. $H_0: \rho_1=\dots=\rho_p=0$ (no autocorrelation up to order $p$);
4. statistic $(T-p)R^2 \sim \chi^2_p$;
5. reject ($p<0.05$) ⇒ autocorrelation present ⇒ OLS standard errors invalid.

This is the *same* BG test doing double duty across the course: it selects the ADF augmentation in §15 (read the ADF where BG is clean) and it screens ARDL specifications (the 2020 `dl_1` was rejected for autocorrelated residuals; `dl_3` passed).

### Impulse response (intuition)
A one-off shock to $X$ in a **static** model spikes $Y$ once, then back to zero. In an **ARDL**, the autoregressive $\alpha$ terms make $Y$ **decay slowly** back to baseline over several periods — the visual proof that "history matters."

### Code & practical workflow *(Lab 11)*

Estimate dynamic models with **`dynlm`** on a `zoo`/`ts` object, using the `L()` wrapper for lags: `L(x, 1)` = $x_{t-1}$, `L(x, 0:3)` = $x_t,\dots,x_{t-3}$.

```R
library(dynlm); library(lmtest); library(zoo)
dz <- as.zoo(d)

dl   <- dynlm(y ~ L(x, 0:2), data = dz)           # distributed lag
ardl <- dynlm(y ~ L(y, 1) + L(x, 0:1), data = dz) # ARDL(1,1)
```
(The `ardl` package can auto-select lag orders by AIC/BIC instead of manual GETS reduction.)

**Multiplier extraction — worked on the 2021 tax model** `lnTAX ~ L(lnTAX,1) + VAT`, with $\beta_{\text{VAT}}=0.100$, $\alpha_1=0.401$:
- **Short-run (impact)** = the contemporaneous $X$ coefficient $= 0.100$: a 1pp VAT rise lifts $\ln\text{TAX}$ by $0.100$ *this period*.
- **Long-run** $= \dfrac{\sum\beta}{1-\sum\alpha} = \dfrac{0.100}{1-0.401} = 0.167$: the total cumulative effect of a *permanent* 1pp VAT rise.

**Diagnostics:**
```R
bgtest(ardl, order = 5, type = "Chisq")   # autocorr; want p>0.05 (clean). p<0.05 ⇒ add lags
bptest(ardl)                               # heteroskedasticity
car::vif(ardl)                             # multicollinearity (DL lags are collinear)
```

> [!warning] Pre-modelling stationarity check (mock-test strategy)
> Before any DL/ARDL, test the variables with ADF. A series non-stationary in levels but stationary in differences is $I(1)$. If your variables are $I(1)$ **and not cointegrated**, a levels regression is **spurious** (§14) — difference the data, or move to cointegration (§18). Don't run ARDL on unchecked levels.

## DL/ARDL cheat-block (for the A4 sheet)
- DL: lagged $X$. Impact $=\beta_0$; long-run $=\sum\beta_i$. Suffers multicollinearity ⇒ ARDL adds lagged $Y$.
- **ARDL long-run multiplier** $=\dfrac{\sum\beta_i}{1-\sum\alpha_i}$ (steady state). Don't forget the denominator.
- Lagged $Y$ ⇒ **DW biased to 2** ⇒ use **Breusch–Godfrey**: $(T-p)R^2\sim\chi^2_p$, reject ⇒ autocorrelation. Same BG picks the ADF augmentation (§15).
- ARDL shock ⇒ decaying impulse response (history matters); static ⇒ one spike.
- Code: `dynlm(y ~ L(y,1) + L(x,0:1))` on a `zoo`; `bgtest(order=, type="Chisq")` (want $p>0.05$), `bptest`, `vif`. Always ADF-check levels first.

---

# §17 — ARMA, ARIMA & forecasting *(Lecture 12 + Lab 12 + Lab 13)*

> [!note] "Forecasting only"
> Per the course plan, ARMA/ARIMA are framed as **simple methods for forecasting** (a series from its *own* past), in contrast to the structural DL/ARDL of §16. Lighter on the mock exams than cointegration, but the **ACF/PACF identification rules** and the **forecast-collapses-to-the-mean** logic are the testable bits.

### The three components
ARIMA uses only the past of $Y$ and past shocks — no exogenous $X$.
- **AR($p$)** — depends on $p$ past *values*: $\;y_t = \alpha + \beta_1 y_{t-1} + \dots + \beta_p y_{t-p} + \varepsilon_t.$
- **MA($q$)** — depends on $q$ past *shocks*: $\;y_t = \mu + \varepsilon_t + \theta_1\varepsilon_{t-1} + \dots + \theta_q\varepsilon_{t-q}.$
- **I($d$)** — number of differences needed for stationarity (ties straight to $I(d)$ in §15).
- **ARIMA($p,d,q$)** combines all three; if already stationary ($d=0$) it's just **ARMA($p,q$)**.

### Identifying $p$ and $q$ — ACF & PACF
- **Autocovariance:** $\gamma_j = E[(y_t-\mu)(y_{t-j}-\mu)]$.
- **Autocorrelation (ACF):** $\rho_j = \gamma_j/\gamma_0$ (standardised to $[-1,1]$).
- **Partial autocorrelation (PACF):** the *isolated* effect of lag $p$, stripping out lags $1\dots p-1$ — equal to $\hat\beta_p$ in an AR($p$) regression.

> [!important] The identification table — the core exam rule
> | Model | ACF | PACF |
> |---|---|---|
> | **AR($p$)** | gradual decay (exponential/oscillating) | **cuts off after lag $p$** |
> | **MA($q$)** | **cuts off after lag $q$** | gradual decay |
> | **ARMA($p,q$)** | gradual decay | gradual decay |
>
> Mnemonic: **PACF pins down AR order; ACF pins down MA order.** A sharp cut-off tells you the order; gradual decay on both ⇒ mixed ARMA.

### The Box–Jenkins procedure *(Lab 13)*
The standard 4-step ARIMA workflow — and notice step 3 loops back:
1. **Identification** — difference to stationarity (find $d$), then read ACF/PACF for $p,q$.
2. **Estimation** — fit by MLE, check coefficient significance.
3. **Diagnostics** — residuals must be white noise (Ljung–Box); if not, **return to step 1**.
4. **Forecasting** — predict with intervals once the model is validated.

> [!tip] Random-walk signature (a key identification case)
> For $y_t = y_{t-1}+\varepsilon_t$: the **ACF decays extremely slowly** — nearly every lag stays significant because today stays correlated with the distant past; the **PACF spikes to ≈1 at lag 1, then drops to 0** (once you know yesterday, the day before adds nothing). A slow-decaying ACF is the classic non-stationarity flag ⇒ difference before modelling (back to §15).

### AIC vs BIC — which to trust *(Lab 13)*
Both reward fit and penalise complexity; **lower is always better**, and you may **only compare models fit on the identical dataset**.
- **AIC** — smaller complexity penalty ⇒ tolerates slightly larger models ⇒ best when the goal is **prediction**.
- **BIC** — larger penalty ⇒ favours parsimonious models ⇒ best when the goal is **explanation**.
- Analogy: AIC = the student who memorised every detail (perfect on seen data, risks overfitting); BIC = the student who grasped the core (slightly worse on seen data, generalises better).

### Forecast mechanics
Forecast $f_{t,h} = E(y_{t+h\mid t})$ by projecting forward, using the key rule: a **future** shock has expectation zero, $E(\varepsilon_{t+h})=0$ for $h>0$, but **past** shocks ($\varepsilon_t, \varepsilon_{t-1},\dots$) are already observed and stay in the equation.

Worked MA(2), $y_t=\mu+\theta_1\varepsilon_{t-1}+\theta_2\varepsilon_{t-2}+\varepsilon_t$:
- $f_{t,1} = \mu + \theta_1\varepsilon_t + \theta_2\varepsilon_{t-1}$
- $f_{t,2} = \mu + \theta_2\varepsilon_t$
- $f_{t,3} = \mu$ (and flat thereafter)

> [!tip] MA($q$) forecasts go flat after $q$ steps
> Any MA($q$) forecast beyond horizon $q$ collapses to the unconditional mean $\mu$ — there are no observed shocks left to carry information. This is a clean exam fact.

### Mean reversion & the steady state
A stationary **AR(1)**, $y_t = c + \alpha y_{t-1} + \varepsilon_t$ with $|\alpha|<1$, is **mean-reverting**: over a long horizon the starting point decays away and the forecast converges to the unconditional mean
$$E(y) = \frac{c}{1-\alpha}.$$
Example: $y_t = 1 - 0.9\,y_{t-1} + \varepsilon_t$ ⇒ $E(y) = \dfrac{1}{1-(-0.9)} = \dfrac{1}{1.9} \approx 0.53$ (the negative $\alpha$ makes it oscillate as it reverts). If $|\alpha|\ge 1$ the process is non-stationary (a unit root at $\alpha=1$ — back to §15) and does **not** revert.

### Code & practical workflow *(Lab 12)*

**1 — Identify** via plots (data must be `ts`/`zoo`). Bars beyond the blue 95% bands are significant:
```R
acf(d$y);  pacf(d$y)
```
PACF cuts off after lag 2 + ACF decays ⇒ AR(2); ACF cuts off after lag 1 + PACF decays ⇒ MA(1) (the §17 table, read off the plots).

**2 — Estimate** with the `forecast` package — manual if the order is clear, automatic if ambiguous:
```R
library(forecast)
manual <- Arima(d$y, order = c(2, 0, 1))                 # ARMA(2,1): d=0
best   <- auto.arima(d$y, ic = "aicc", seasonal = FALSE) # searches p,d,q by AICc
```

**3 — Check residuals** must be white noise — **Ljung–Box**:
```R
checkresiduals(best)                                     # plots + Ljung–Box
Box.test(residuals(best), type = "Ljung-Box", lag = 10)
```
$H_0$: residuals are white noise (independent). **Want $p>0.05$** (clean); $p<0.05$ ⇒ dynamics left uncaptured ⇒ raise $p$ or $q$.

**4 — Forecast:**
```R
fc <- forecast(best, h = 12); plot(fc)
```

> [!tip] Mean reversion on the forecast plot
> For a stationary ARMA, the forecast line **curves and flattens** to the unconditional mean $E(y)=c/(1-\alpha)$ — the visual of §17's mean reversion (your `mean_reversing.R`). A forecast that never flattens signals non-stationarity.

## ARMA/ARIMA cheat-block (for the A4 sheet)
- AR($p$): own past values; MA($q$): own past shocks; I($d$): differences to stationarity. ARIMA($p,d,q$); $d=0$ ⇒ ARMA.
- **ID rule:** AR($p$) ⇒ PACF cuts at $p$, ACF decays. MA($q$) ⇒ ACF cuts at $q$, PACF decays. ARMA ⇒ both decay. (**PACF→AR, ACF→MA.**)
- Forecast: future shocks $E(\varepsilon_{t+h})=0$; past shocks stay. **MA($q$) forecast flat = $\mu$ beyond $q$.**
- AR(1) mean reversion ($|\alpha|<1$): $E(y)=c/(1-\alpha)$. $|\alpha|\ge1$ ⇒ non-stationary (no reversion).
- Code: `acf`/`pacf` to ID; `Arima(order=c(p,d,q))` or `auto.arima(ic="aicc")`; **Ljung–Box** residual check (want $p>0.05$); `forecast(h=)`.
- **Box–Jenkins:** identify → estimate → diagnose (loop back if residuals not white noise) → forecast.
- **Random walk:** ACF decays *very* slowly + PACF spike at lag 1 → 0 ⇒ non-stationary, difference it.
- **AIC vs BIC:** both lower=better, same data only. AIC = smaller penalty (prediction); BIC = bigger penalty, parsimonious (explanation).

---

# §18 — Cointegration & Error Correction Models *(Lecture 13)*

> [!note] The capstone — and the densest exam topic
> Exercise 1 of the **2018/2019** (marriage ages) and **2022** (Unilever) papers is this lecture end to end: integration orders → cointegrating regression → residual ADF → ECM. The "special critical values" rule below is exactly why the 2022 residual ADF of $-2.889$ was *borderline*, and why the **negative, significant ECM term** was the decisive evidence.

### The cointegration rescue
From §14, regressing two $I(1)$ series usually gives a **spurious** regression. The one exception: **cointegration** — two or more $I(1)$ series are cointegrated if some **linear combination of them is stationary $I(0)$**. Intuitively they share a common stochastic trend: they wander individually but are tied by a **long-run equilibrium**, and if they drift too far apart, economic forces pull them back (consumption & income, spot & futures prices, the two Unilever listings).

### Engle–Granger two-step
**Step 1 — long-run equilibrium regression** (OLS on the *levels*):
$$y_t = \beta_0 + \beta_1 x_t + e_t.$$
Extract residuals $\hat e_t$ — the "deviations from equilibrium." The coefficient vector $(1,-\beta_1)$ is the **cointegrating vector**.

**Step 2 — test the residuals for stationarity** (ADF on $\hat e_t$, *no constant or trend* since residuals centre on zero):
- $H_0$: residuals have a unit root, $\hat e_t\sim I(1)$ ⇒ **no cointegration** (spurious).
- $H_1$: residuals stationary, $\hat e_t\sim I(0)$ ⇒ **cointegration exists**.

> [!warning] Special critical values — the exam's sharpest cointegration trap
> You **cannot** use standard ADF critical values here. Because the residuals are *estimated* (not raw data), standard tables **over-reject** $H_0$. Use the **cointegration critical values** (Engle–Yoo / MacKinnon), which are **more negative** than standard ADF. This is precisely why the 2022 Unilever residual ADF of $-2.889$ was *borderline* (beyond standard DF but only marginal against EG values) — and why the ECM term, not the raw $p$-value, clinched cointegration.

### The Error Correction Model (ECM)
By the **Granger Representation Theorem**, if the variables are cointegrated the relationship *can* be written as an ECM combining short-run dynamics with the pull back to equilibrium:
$$\Delta y_t = \alpha_0 + \sum_{i=1}^{p}\phi_i\,\Delta y_{t-i} + \sum_{j=0}^{q}\theta_j\,\Delta x_{t-j} + \gamma\,\hat e_{t-1} + u_t.$$
- **Differenced terms** ($\Delta$) capture short-run shocks; being $I(0)$, their $t$-tests are valid.
- **Error-correction term** $\hat e_{t-1}$ = lagged Step-1 residual (last period's disequilibrium).
- **Speed of adjustment $\gamma$** — the key parameter.

> [!important] $\gamma$ must be negative and significant
> $\gamma$ is the fraction of disequilibrium corrected each period, and it **must be negative and statistically significant** for a valid ECM. $\gamma=-0.25$ ⇒ 25% of any gap closes next period. Negative = self-correcting (a positive gap pushes $\Delta y$ down, back toward equilibrium). On the exams: 2018/2019 `lresid` $=-0.270^{***}$ (≈27%/yr), 2022 Unilever `lresid` $=-0.0036^{**}$ (slow but significant). A significant, correctly-signed $\gamma$ is itself confirmation of cointegration.

### ARDL bounds test (Pesaran–Shin–Smith) — for mixed orders
Engle–Granger needs **all variables $I(1)$**. With a **mix of $I(0)$ and $I(1)$**, use the **bounds test**:
1. estimate an ARDL-ECM (differenced terms + lagged *level* terms);
2. **Wald/F-test** the joint significance of the lagged levels — $H_0$: no cointegration (all level coefficients $=0$);
3. compare $F$ to a **band**: lower bound (assume all $I(0)$) and upper bound (assume all $I(1)$).

| $F$ vs bounds | Decision | Conclusion |
|---|---|---|
| $F >$ **upper** | reject $H_0$ | **cointegration** (whatever the orders) |
| $F <$ **lower** | fail to reject | **no cointegration** (drift apart) |
| lower $< F <$ upper | **inconclusive** | must pin down each variable's exact order |

### Pitfalls & the spurious-vs-cointegrated tell
- **$I(2)$ breaks the bounds test** — always ADF-check first to rule out any $I(2)$ variable.
- **Spurious vs cointegrated:** $R^2=0.95$ with **DW ≈ 0.40** ⇒ almost certainly **spurious** (§14). Higher DW *and* residuals stationary by the special critical values ⇒ a genuine **cointegrated** relationship.
- **Interpreting $\gamma$:** always state both the **direction** (negative ⇒ pushes back toward equilibrium) and the **speed** (magnitude ⇒ fraction of the gap corrected per period).

## Cointegration/ECM cheat-block (for the A4 sheet)
- Cointegration = $I(1)$ series whose linear combo is $I(0)$ (shared long-run equilibrium). The exception to spurious regression.
- **Engle–Granger:** (1) OLS levels $y=\beta_0+\beta_1 x+e$ → cointegrating vector $(1,-\beta_1)$; (2) ADF on $\hat e$ (no const/trend) using **special EG/MacKinnon critical values** (more negative).
- **ECM:** $\Delta y_t = \dots + \gamma\,\hat e_{t-1}+u_t$. $\gamma$ **negative & significant** = speed of adjustment (fraction corrected/period); confirms cointegration.
- **ARDL bounds test** for mixed $I(0)/I(1)$: F > upper ⇒ cointegrated; F < lower ⇒ not; between ⇒ inconclusive. Fails if any $I(2)$.
- Tell: high $R^2$ + DW≈0 ⇒ spurious; stationary residuals (special CVs) + significant $\gamma$ ⇒ cointegrated.

---

# §19 — Instrumental variables & endogeneity *(Lecture 14 + Lab 14)*

> [!note] Where this showed up — the endogeneity questions
> The conceptual endogeneity sub-questions: 2022/2023 `tenure` (reverse causality + omitted disposition ⇒ IV probit) and 2018 mentor↔student articles (**simultaneity**). Those exams asked you to *name the mechanism and the fix* — this lecture is that fix.

### The endogeneity problem
OLS assumes regressors are **exogenous**: $\mathrm{Cov}(X,\varepsilon)=0$. Violate it and OLS is **biased and inconsistent**. Three causes:
- **Omitted-variable bias** — an unobserved factor drives both $Y$ and $X$.
- **Measurement error** — $X$ observed with noise (errors-in-variables).
- **Simultaneity / reverse causality** — $X$ affects $Y$ *and* $Y$ affects $X$ (price↔quantity; mentor↔student articles).

### The IV solution — two conditions
Find an **instrument $Z$** that captures the part of $X$'s variation that is clean of $\varepsilon$. $Z$ is valid only if:
1. **Relevance (strength):** $\mathrm{Cov}(Z,X)\neq 0$ — correlated with the endogenous regressor. ($\approx 0$ ⇒ **weak instrument**.)
2. **Exogeneity (exclusion restriction):** $\mathrm{Cov}(Z,\varepsilon)=0$ — affects $Y$ *only through* $X$, with no direct path. (Same exclusion-restriction idea as Heckman in §11.)

### Two-stage least squares (2SLS)
Strip the "bad" variation from $X$:
- **Stage 1:** regress the endogenous $X$ on the instrument(s) $Z$ and the exogenous regressors $W$: $\;X = \gamma_0 + \gamma_1 Z + \gamma_2 W + \eta$. Keep the fitted $\hat X$ (only the $Z$-driven, clean variation).
- **Stage 2:** regress $Y$ on $\hat X$ and $W$: $\;Y = \beta_0 + \beta_1\hat X + \beta_2 W + v$. Now $\hat\beta_1$ is **consistent**.

R: `AER::ivreg(y ~ x + w | z + w)` (regressors before `|`, instruments after); `summary(model, diagnostics = TRUE)` prints the three tests below.

### Diagnostic tests
| Test | Question | $H_0$ | Decision |
|---|---|---|---|
| **First-stage F** (weak instrument) | is $Z$ strong enough? | — | rule of thumb **$F<10$ ⇒ weak** instrument |
| **Durbin–Wu–Hausman** | is $X$ actually endogenous? | $X$ exogenous | $p<0.05$ ⇒ reject ⇒ **use IV** |
| **Sargan / Hansen** (overID only) | are the instruments valid? | instruments valid | $p<0.05$ ⇒ reject ⇒ **invalid** instruments |

Sargan/Hansen only works when **overidentified** (more instruments than endogenous regressors).

### OLS vs IV — the trade-off
| Situation | OLS | IV (2SLS) |
|---|---|---|
| $X$ endogenous | biased & inconsistent | **consistent** |
| $X$ exogenous | consistent & **efficient** | consistent but **inefficient** |
| weak instrument | — | **badly biased & inconsistent** |

> [!important] Don't reach for IV reflexively
> IV is **"expensive" in precision** — it inflates standard errors. So unless $X$ is *demonstrably* endogenous (Durbin–Wu–Hausman rejects) **and** you have a strong, valid instrument, **stick with OLS**. A weak instrument makes IV *worse* than the OLS it was meant to fix.

### Code & practical workflow *(Lab 14)*

> [!warning] Don't run 2SLS by hand
> Estimating the two stages as separate `lm()` calls gives the **wrong standard errors** — the second stage doesn't know $\hat X$ was itself estimated. Use `AER::ivreg`, which corrects them automatically.

```R
library(AER)
# syntax: dependent ~ endogenous + controls | instruments + controls
iv <- ivreg(log(wage) ~ educ + exper | mothereduc + exper, data = mroz)
summary(iv, diagnostics = TRUE)   # prints weak-instrument F, Wu–Hausman, Sargan
```
Classic Mroz wage example: `educ` is endogenous (ability bias), instrumented by `mothereduc`; `exper` is an exogenous control, so it appears on **both** sides of the `|`. `diagnostics = TRUE` auto-runs the three §19 tests.

## IV cheat-block (for the A4 sheet)
- Endogeneity ($\mathrm{Cov}(X,\varepsilon)\neq0$) ⇒ OLS biased & inconsistent. Causes: omitted var, measurement error, simultaneity.
- Valid instrument $Z$: **relevant** ($\mathrm{Cov}(Z,X)\neq0$) + **exogenous** ($\mathrm{Cov}(Z,\varepsilon)=0$, affects $Y$ only via $X$).
- **2SLS:** stage 1 $X$ on $Z,W$ → $\hat X$; stage 2 $Y$ on $\hat X,W$ → consistent $\hat\beta_1$.
- Tests: first-stage **$F<10$ ⇒ weak**; **DWH** reject ⇒ endogenous, use IV; **Sargan** (overID) reject ⇒ invalid instruments.
- IV inflates SEs ⇒ only use it when endogeneity is proven; weak instrument ⇒ worse than OLS.
- Code: `AER::ivreg(y ~ x + w | z + w)` (controls on both sides of `|`); `summary(., diagnostics=TRUE)`. Never two manual `lm()` (wrong SEs).


