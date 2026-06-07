# Advanced Econometrics — Exam Solutions

**Paper:** September 1, 2021 (R. Woźniak)
**Significance level:** $\alpha = 5\%$ for all exercises.

> *(Exercise 0 is the obligatory honour-code sentence — no econometrics there.)*

---

## Exercise 1 (30%) — Panel data: do grades rise with course experience?

FE within model (1): `AvScore ~ Noffered + Sex`. **Unbalanced panel: n = 200, T = 4–30, N = 3131.** `Noffered` $=0.4992$ ($t=292.6$). Hausman: $\chi^2 = 0.18577$, $df=1$, **$p = 0.6521$**.

### a) Is the panel balanced?

**No — it is unbalanced.** The cross-section has $n = 200$ courses but the time dimension varies, $T = 4\text{–}30$. Note $N = 3131$ (total course–semester observations) is **not** $n \times T$ for a single $T$, which is exactly what "unbalanced" means; do not confuse $N$ (total observations) with $n$ (number of units).

### b) Why was `Sex` not estimated in model (1)?

Because `Sex` is **time-invariant** — a lecturer's sex does not change across the semesters of a course. The fixed-effects ("within") estimator demeans every variable within each unit, which **annihilates any time-invariant regressor** (it becomes a column of zeros, perfectly collinear with the individual effect). So `Sex` cannot be identified in the FE model. *(Relatedly, the within model reports no intercept: the individual effects $u_i$ absorb it, since the within transformation removes each unit's mean.)*

### c) Interpretation of the Hausman test

- $H_0$: the individual effects are uncorrelated with the regressors ⇒ **both FE and RE are consistent, but RE is efficient** (preferred).
- $H_a$: RE is inconsistent (only FE consistent).
- Result: $\chi^2 = 0.186$, $df=1$, $p = 0.6521 > 0.05$ → **fail to reject $H_0$** → choose the **random-effects** model.

*(Sanity check: $\chi^2 = 0.19$ on $1$ df indeed gives $p \approx 0.65$ — internally consistent, unlike the 2018 paper's misprinted $0.0065$.)*

### d) What can go wrong with simple (pooled) OLS?

Pooled OLS ignores the panel structure:
- If the unobserved individual effects are **correlated with the regressors**, OLS suffers **omitted-variable / heterogeneity bias** → biased, inconsistent estimates.
- Even if they are uncorrelated, the composite error is **serially correlated within each course** (and often heteroskedastic), so the OLS standard errors are **understated** and all $t$/$F$ inference is invalid.

### e) Interpretation of the parameters of model (4)

Model (4) is the random-effects model with all four regressors:

| Variable | Estimate | Sig. | Interpretation |
|---|---|---|---|
| `Noffered` | $0.504$ | *** | Each additional semester a course is offered raises its average score by about **$0.504$ points** (0–100 scale) — the core "evaluations rise with experience" effect. |
| `Sex` (1=female) | $-0.651$ | ns | Female lecturers score $\approx 0.65$ points lower than males, but **not significant** → no gender difference. |
| `Semester` (1=Spring) | $0.088$ | *** | Spring courses average about **$0.088$ points higher** than Fall — small but significant. |
| `Year` | $-0.010$ | ns | **Not significant** → no evidence average scores trend up or down year to year. |
| Constant | $104.026$ | ns | Baseline; imprecisely estimated (huge SE once `Year` enters), not meaningfully interpretable. |

Substantively: experience (`Noffered`) and the Spring dummy matter; lecturer sex and the calendar year do not.

---

## Exercise 2 (30%) — ARDL for tax revenues

Model (an ARDL(1,0)): $\ln(\text{TAX})_t = \beta_0 + \rho\,\ln(\text{TAX})_{t-1} + \beta_{\text{VAT}}\,\text{VAT}_t + \epsilon_t$.

| Term | Estimate | $t$ | $p$ |
|---|---|---|---|
| Intercept | $2.0391$ | $2.86$ | $0.004$ *** |
| $\ln(\text{TAX})_{t-1}$ | $0.4013$ | $3.96$ | $7.4\text{e-}05$ *** |
| VAT | $0.1006$ | $9.71$ | $<2\text{e-}16$ *** |

Stationarity diagnostics:

| Series | Test | Statistic | Decision |
|---|---|---|---|
| $\ln(\text{TAX})$ level | ADF (aug 0, BG clean) | $-3.40$, $p=0.01$ | reject unit root → **$I(0)$** |
| $\Delta\ln(\text{TAX})$ | ADF | $-9.27$, $p=0.01$ | stationary |
| VAT | KPSS ($H_0$: stationary) | $0.0597 < 0.463$ | fail to reject → **$I(0)$** |
| $\Delta$VAT | KPSS | $0.0309 < 0.463$ | stationary |

### a) Economic (not econometric) reason for an autoregressive model

Tax revenues are **persistent / inertial**: the tax base (incomes, consumption, the stock of registered taxpayers, ongoing economic activity) carries over from one period to the next, so this period's revenue depends mechanically on last period's. There are institutional lags — collection schedules, arrears, gradual behavioural adjustment to rates. Economically, revenue has **momentum**, which the lagged dependent variable captures; a pure distributed-lag model in VAT alone would miss this self-perpetuating dynamic.

### b) Keep or drop the lagged taxes?

**Keep them.** $\ln(\text{TAX})_{t-1}$ has coefficient $0.401$ with $t = 3.96$, $p = 7.4\text{e-}05$ — **highly significant**. Dropping a significant lagged dependent variable would omit the persistence dynamics and almost certainly reintroduce serial correlation in the residuals, biasing inference.

### c) Are $\ln(\text{TAX})$ and VAT cointegrated?

**No — the question does not even arise.** Cointegration is a property of **$I(1)$ (non-stationary)** variables: it asks whether a linear combination of integrated series is stationary. Here **both** series are **$I(0)$** — $\ln(\text{TAX})$ is stationary in levels (ADF rejects the unit root, $-3.40$, $p=0.01$) and VAT is stationary (KPSS fails to reject stationarity). Two already-stationary series cannot be cointegrated; there is no stochastic trend to share. The regression is simply a standard (balanced, stationary) ARDL and is valid as estimated — no cointegration/ECM machinery is needed.

### d) Steady-state value of $\ln(\text{TAX})$ when $\text{VAT}^* = 10$

In steady state $\ln(\text{TAX})_t = \ln(\text{TAX})_{t-1} = \ln(\text{TAX})^*$, so:
$$\ln(\text{TAX})^* = \frac{\beta_0 + \beta_{\text{VAT}}\,\text{VAT}^*}{1-\rho} = \frac{2.0391 + 0.1006\times 10}{1 - 0.4013} = \frac{3.0452}{0.5987} \approx \mathbf{5.087}.$$
Equilibrium log-tax-revenue is about $5.09$ (i.e. $\text{TAX}^* = e^{5.087}\approx 162$ in the original units) when the VAT rate is fixed at $10$.

### e) Long-term multiplier

$$\text{LR multiplier} = \frac{\beta_{\text{VAT}}}{1-\rho} = \frac{0.1006}{0.5987} \approx \mathbf{0.168}.$$
**Interpretation:** because the dependent variable is in logs and VAT is in levels, this is a long-run **semi-elasticity**. A *permanent* one-unit (one-percentage-point) increase in the VAT rate raises $\ln(\text{TAX})$ by about $0.168$ in the long run — i.e. roughly a **$16.8\%$ long-run increase in tax revenue** per extra point of VAT. (The short-run/impact effect is just $\beta_{\text{VAT}} = 0.101$, about $10\%$; the rest accumulates through the persistence term.)

---

## Exercise 3 (40%) — Logit: success of Himalayan expeditions (2019)

`glm(success ~ members + hired_staff + oxygen_used + month, family = binomial(link="logit"))`. Null deviance $182.59$ (168 df), residual deviance $117.76$ (164 df), AIC $127.76$.

| Variable | Coef. | $z$ | $p$ | Marginal effect (atmean) |
|---|---|---|---|---|
| (Intercept) | $-6.201$ | $-2.72$ | $0.0065$ ** | — |
| members | $-0.0257$ | $-0.23$ | $0.818$ | $-0.0030$ ns |
| hired_staff | $0.1788$ | $1.54$ | $0.125$ | $0.0206$ . |
| oxygen_used (TRUE) | $2.712$ | $5.01$ | $5.5\text{e-}07$ *** | $0.4743$ *** |
| month | $1.235$ | $2.35$ | $0.0187$ * | $0.1426$ * |

### a) Why is the topic important? (economic reasons)

Himalayan mountaineering is a **major industry for Nepal** — permit fees, guiding, porters/Sherpa wages, equipment, oxygen, lodging and insurance all generate substantial revenue and employment. Understanding the drivers of expedition success supports efficient **resource allocation** (how much oxygen/staff to buy), **risk pricing** (insurance, operator pricing), and **policy** (safety regulation, permit design, seasonal management). Both private operators and the Nepali government have direct economic stakes in knowing what makes expeditions succeed safely.

### b) Are the variables jointly significant?

**Yes.** Likelihood-ratio test of the full model vs the intercept-only model: $\chi^2 = 64.828$, $df = 4$, $p = 2.8\text{e-}13 < 0.05$ → **reject** $H_0$ that all slope coefficients are zero. The regressors are jointly significant.

### c) Interpretation of the logit parameters

Coefficients are on the **log-odds** scale; $\exp(\beta)$ gives the odds ratio.

- **oxygen_used $= 2.712$ (***):** the strongest predictor. $\exp(2.712) \approx 15.1$ — using supplemental oxygen multiplies the **odds of success by about 15** versus not using it (a discrete change, since it is a dummy).
- **month $= 1.235$ (*):** $\exp(1.235) \approx 3.44$ — each later month (March→April→May) multiplies the odds of success by about $3.4$; May (peak season, better weather) is far more favourable than March.
- **hired_staff $= 0.179$ (ns at 5%):** $\exp(0.179)\approx 1.20$ — each extra Sherpa raises the odds by $\approx 20\%$, but only borderline (significant at 10%, not 5%).
- **members $= -0.026$ (ns):** essentially no effect ($\exp\approx 0.97$) and insignificant.
- **Intercept $= -6.201$:** baseline log-odds when all covariates are zero — not substantively meaningful here (members $\geq 1$, month $\geq 3$).

Significant drivers at 5%: **oxygen use** (large positive) and **month** (positive).

### d) Interpretation of the marginal effects (at means)

- **oxygen_used $= 0.474$ (***):** using supplemental oxygen raises the **probability of success by about 47.4 percentage points**, evaluated at mean covariates (discrete change). A dominant effect.
- **month $= 0.143$ (*):** each later month raises the success probability by about **14.3 pp**.
- **hired_staff $= 0.021$ (.):** each additional Sherpa adds about **2.1 pp** to the success probability — weakly significant (10% only).
- **members $= -0.003$ (ns):** negligible and insignificant.

### e) Testing for an optimal expedition size

A single linear `members` term can only capture a monotonic effect. An **optimum** (an interior maximum) implies an **inverted-U**: success first rises, then falls, with size. To test this, estimate a logit that **adds a quadratic term, `members²`** (i.e. `success ~ members + I(members^2) + ...`).

An optimal size exists if the coefficient on `members` is positive and on `members²` is **negative and significant**; the implied optimum is
$$\text{members}^* = -\frac{\beta_{\text{members}}}{2\,\beta_{\text{members}^2}}.$$
So: estimate the **logit augmented with the square of `members`**, and inspect the sign/significance of the squared term.

---

### Quick-reference summary

| Ex. | Technique | Key takeaways |
|---|---|---|
| 1 | FE vs RE panel | Unbalanced ($T$=4–30); `Sex` dropped (time-invariant), no FE intercept; **Hausman $p=0.65$ ⇒ random effects**; pooled OLS ⇒ heterogeneity bias + invalid SEs; model (4): `Noffered` $+0.504$*** and Spring $+0.088$*** matter, `Sex`/`Year` insignificant. |
| 2 | ARDL + stationarity | AR term reflects revenue **persistence**; keep lag ($p\approx10^{-5}$); **both series $I(0)$ ⇒ no cointegration question**; steady state $\ln\text{TAX}^*\approx5.09$ at VAT=10; long-run multiplier $\approx0.168$ (≈16.8%/pp). |
| 3 | Logit + marginal effects | Important: Nepal mountaineering economy; LR $\chi^2=64.8$, $p\approx10^{-13}$ ⇒ jointly significant; **oxygen** OR$\approx15$ (ME $+47$pp) and **month** OR$\approx3.4$ (ME $+14$pp) significant; for optimal size add **`members²`** (inverted-U). |
