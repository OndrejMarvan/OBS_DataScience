# Advanced Econometrics — Exam Solutions

**Paper:** June 2023 (R. Woźniak)
**Significance level:** $\alpha = 5\%$ throughout.

---

## Exercise 1 (30%) — Probit model: complaints at fast-food restaurants

**Model:** $\text{complain} \sim \text{age} + \text{grade} + \text{south} + \text{tenure} + \text{gender} + \text{income}$, estimated by probit (binomial family, probit link).

The probit is a latent-variable model:
$$y_i^* = x_i'\beta + \varepsilon_i, \quad \varepsilon_i \sim N(0,1), \qquad y_i = \mathbb{1}(y_i^* > 0), \qquad P(y_i = 1 \mid x_i) = \Phi(x_i'\beta).$$

### a) Interpretation of parameter estimates

In a probit, coefficients describe the effect of a regressor on the **latent index** $x'\beta$ (equivalently, on the $z$-score fed into $\Phi(\cdot)$), **not** directly on the probability. Only the **sign** and **statistical significance** are directly interpretable; magnitudes require marginal effects (part b).

| Variable | Estimate | $z$ | $p$ | Reading |
|---|---|---|---|---|
| age | $-0.0336$ | $-2.83$ | $0.0047$ ** | Significant, negative — older workers are **less** likely to complain. |
| gender (=1 if woman) | $+0.2976$ | $5.43$ | $5.5\text{e-}08$ *** | Significant, positive — women **more** likely to complain. |
| income | $-0.0021$ | $-3.08$ | $0.0021$ ** | Significant, negative — higher restaurant income $\Rightarrow$ **less** likely to complain. |
| grade | $+0.0331$ | $1.36$ | $0.174$ | Not significant. |
| south | $+0.0777$ | $1.42$ | $0.156$ | Not significant. |
| tenure | $-0.0030$ | $-0.03$ | $0.974$ | Not significant (essentially zero). |
| (Intercept) | $0.4024$ | $0.79$ | $0.429$ | Not significant. |

??? A positive coefficient shifts the latent index up and therefore raises $P(\text{complain}=1)$; a negative one lowers it. The **size** of e.g. $\beta_{\text{age}}=-0.0336$ is not a probability change.

### b) Interpretation of marginal effects

Marginal effects are computed `atmean = TRUE`, i.e. evaluated at the sample mean of all covariates. For a continuous regressor:
$$\frac{\partial P(y=1\mid x)}{\partial x_k} = \phi(x'\beta)\,\beta_k,$$
and for the dummies (`south`, `gender`, flagged as *discrete change*) the effect is $\Phi(\bar{x}'\beta \mid d=1) - \Phi(\bar{x}'\beta \mid d=0)$.

- **age:** $-0.0094$ — one additional year of age lowers the probability of complaining by about $0.94$ percentage points (pp).
- **gender:** $+0.0835$ — a woman is about $8.35$ pp more likely to complain than a man (discrete change).
- **income:** $-0.00058$ — an extra \$1{,}000 of restaurant income lowers the probability by about $0.058$ pp.
- **grade, south, tenure:** not statistically significant — no reliable marginal effect.

Note the $z$-statistics / $p$-values for the marginal effects mirror those of the coefficients (same significance pattern), because the delta-method scaling by $\phi(\cdot)$ is a positive constant.

### c) Joint significance of all variables

Use the **likelihood-ratio test** of the full model against the intercept-only (null) model:
$$LR = -2\left(\ln L_{\text{null}} - \ln L_{\text{full}}\right) = -2\big(-1402.3 - (-1376.3)\big) = 52.11, \qquad df = 6.$$
Reported $p = 1.773\text{e-}09 < 0.05$. We **reject** $H_0: \beta_{\text{age}} = \dots = \beta_{\text{income}} = 0$. The regressors are **jointly significant** — the model explains complaining behaviour better than a constant.

### d) Is `tenure` endogenous?

There are good reasons to suspect **endogeneity**, even though `tenure` is individually insignificant:

1. **Reverse causality / simultaneity.** A worker's propensity to complain can itself affect how long they stay on the job (chronic complainers may quit or be let go sooner; or, conversely, engaged workers both stay longer and speak up more). If $\text{complain}$ influences $\text{tenure}$, then $\text{tenure}$ is correlated with the model's error term.
2. **Omitted/unobserved disposition.** An unobserved trait (job satisfaction, assertiveness, conscientiousness) plausibly drives **both** how long someone stays **and** their willingness to complain. This common cause induces $\operatorname{Cov}(\text{tenure}, \varepsilon) \neq 0$.

Either channel violates the exogeneity assumption $E(\varepsilon \mid x) = 0$, making the estimate **biased and inconsistent**. The near-zero, insignificant coefficient does **not** prove exogeneity — endogeneity can bias an effect toward (or away from) zero.

**How to address it:** an instrumental-variables approach — find an instrument $z$ that is correlated with `tenure` but uncorrelated with the propensity to complain, then estimate via **IV probit** (`ivprobit`) or a **control-function** (two-stage) approach. The given output contains no endogeneity test, so the diagnosis here is conceptual.

### e) Interpretation of the diagnostic (goodness-of-fit) tests

All reported tests share $H_0$: *the model fits well / no lack of fit / correct link*.

| Test | Statistic | $p$ | Conclusion |
|---|---|---|---|
| Hosmer–Lemeshow (HL) | $\chi^2 = 4.98$, $df=8$ | $0.760$ | Fail to reject — good fit. |
| modified HL (mHL) | $F = 0.73$ | $0.681$ | Fail to reject — good fit. |
| Osius–Rojek (OsRo) | $Z = 1.27$ | $0.206$ | Fail to reject — good fit. |
| Stukel score (SstPl0.5) | $Z = 0.33$ | $0.743$ | No link misspecification. |
| Stukel LR (SllPl0.5 / SllBoth) | $\chi^2 = 0.11$ | $0.742 / 0.947$ | No link misspecification. |

Every computable $p$-value exceeds $0.05$, so we **fail to reject** the null in each case: there is **no evidence of lack of fit and no evidence that the probit link is misspecified** — the specification is adequate. The `NaN` entries (e.g. `SstPgeq0.5`, `SstBoth`) are simply non-computable (no observations in the relevant predicted-probability region) and carry no interpretation.

---

## Exercise 2 (30%) — Tobit model: college GPA, left-censored at 2.0

**Model:** $\text{gpa2} \sim \text{hsgpa} + \text{pincome} + \text{program}$, censored regression with `left = 2`, `right = Inf`.
4000 obs: **1206 left-censored**, 2794 uncensored, 0 right-censored. $\ln L = -2015.126$.

Latent specification:
$$y_i^* = x_i'\beta + \varepsilon_i, \quad \varepsilon_i \sim N(0,\sigma^2), \qquad y_i = \max(2,\, y_i^*).$$
From `logSigma` $= -0.911$, $\hat{\sigma} = e^{-0.911} \approx 0.402$.

### a) Why not a simple (OLS) regression?

Because the dependent variable is **censored** (all true GPAs below $2.0$ are recorded as $2.0$). OLS is **biased and inconsistent** here:
- On the **full** sample, treating the piled-up $2.0$ values as genuine observations flattens the fitted line.
- On the **uncensored** sub-sample only, dropping the $1206$ censored cases induces **sample-selection bias**.

Tobit uses the full likelihood — a normal density for uncensored observations and the censoring probability $\Phi\!\big((2 - x'\beta)/\sigma\big)$ for the censored ones — and recovers consistent estimates.

### b) Corner solution or (data) censoring?

This is a **data-censoring** case, **not** a corner solution.

- A **corner solution** arises when the pile-up at the limit is a *real, optimal outcome* (e.g. zero hours worked, zero charitable donation) — the limit value genuinely describes behaviour.
- Here the true GPA below $2.0$ **exists and is meaningful**; it is merely **not observed/reported** (recorded as $2.0$ for confidentiality). The underlying $y^*$ is hidden, not chosen. That is classic **censoring of the data**.

### c) Interval of the dependent variable; observations on the edge

GPA is defined on $[0,4]$, but because of left-censoring at $2.0$ and no right-censoring, the **observed** dependent variable lies in
$$[2.0,\; 4.0].$$
Observations on the **edge** of that interval = left-censored count = **1206** (all at the lower bound $2.0$); right-censored = $0$.

### d) Individually significant variables

All slope coefficients have $p < 2\text{e-}16 < 0.05$:

| Variable | Estimate | $p$ | Significant? |
|---|---|---|---|
| hsgpa | $0.6586$ | $<2\text{e-}16$ | Yes |
| pincome | $0.3159$ | $<2\text{e-}16$ | Yes |
| program | $0.5554$ | $<2\text{e-}16$ | Yes |
| (Intercept) | $-0.8903$ | $<2\text{e-}16$ | Yes |

**All three regressors are individually statistically significant.**

### e) Effect of participating in the study-skills program

`program` is a binary indicator, so the quantity of interest is its effect on the **expected observed GPA**, $E(y\mid x)$. From the marginal-effects table the effect is

$$\frac{\partial E(y\mid x)}{\partial\,\text{program}} \approx 0.555.$$

**Interpretation:** participating in the study-skills program is associated with an increase of about **$0.555$ GPA points** in expected college GPA, holding `hsgpa` and `pincome` at their means.

The three columns $y^*$, $E(y\mid x)$, $E(y\mid x, y>0)$ all report $\approx 0.555$ because, at the sample means, almost the entire mass lies above the $2.0$ threshold, so the censoring-adjustment scale factor is $\approx 1$. Correspondingly, the $\Pr(y>0\mid x)$ marginal effect is essentially $0$ (order $10^{-9}$): participation barely changes an already near-certain probability of clearing the censoring point.

---

## Exercise 3 (40%) — Panel data: mobile vs. fixed phones, 1960–2011

**Model:** $\text{Mobile} \sim \text{FixedPhones}$, `model = "within"`, `index = (Country, Year)`.
Unbalanced panel: $n = 181$, $T = 0\text{–}37$, $N = 5800$.
$\hat\beta_{\text{FixedPhones}} = 2.3916$ ($SE = 0.0512$, $t = 46.74$, $p < 2.2\text{e-}16$). $R^2 = 0.9995$.

### a) Interpretation of the coefficient on `FixedPhones`

In the within (fixed-effects) estimator the country-specific time-invariant effect is removed, so the coefficient is a **within-country** effect: holding the country's fixed effect constant, an increase of **one** fixed phone (landline) per country is associated with an increase of about **$2.39$** mobile phones per country, on average, over time.

### b) How many countries?

The number of **cross-sectional units** is $n = \mathbf{181}$ countries. (Each panel "group" indexed by *Country or Area* is one country; $N = 5800$ is the total country–year observations across the unbalanced panel, with $T$ ranging from a few up to $37$ years.)

### c) Fixed effects or random effects?

**Fixed effects.** The call specifies `model = "within"`, and the within (demeaning) transformation **is** the FE estimator: it subtracts each country's time-mean from every variable, eliminating the time-invariant individual effect $u_i$. (A side consequence: any time-invariant regressor would drop out — here there are none.)

### d) Stationarity of `Mobile` for **Poland** (ADF / `testdf`)

Choose the augmentation that removes residual autocorrelation (Breusch–Godfrey $p > 0.05$ at **all** tested lags), then read the ADF result there.

| aug | ADF | $p_{adf}$ | BG $p_1$ | BG $p_2$ | BG $p_3$ | residual autocorr.? |
|---|---|---|---|---|---|---|
| 0 | $0.958$ | $0.99$ | $\approx 0$ | $\approx 0$ | $\approx 0$ | Yes — reject |
| 1 | $1.102$ | $0.99$ | $0.832$ | $0.0002$ | $0.0003$ | Yes (lags 2–3) |
| **2** | **$1.203$** | **$0.99$** | $0.955$ | $0.987$ | $0.364$ | **No — clean** |
| 3 | $1.241$ | $0.99$ | $0.979$ | $0.992$ | $0.993$ | No |

At **augmentation 2** the BG tests are all insignificant (no autocorrelation), so this row is valid. The ADF statistic is $1.20$ with $p_{adf} = 0.99 > 0.05$: we **fail to reject** the null of a unit root.

**Conclusion:** the `Mobile` series for Poland is **non-stationary** (contains a unit root) — consistent with the explosive growth of mobile adoption; it is most likely $I(1)$.

### e) Stationarity of `Mobile` for **Sweden** (PP vs. KPSS — conflicting)

The two tests have **opposite** null hypotheses:

- **Phillips–Perron**, $H_0$: unit root. $Z\text{-tau} = -116.06$, well below the $5\%$ critical value $-2.862$. $\Rightarrow$ **reject $H_0$** $\Rightarrow$ suggests **stationary**.
- **KPSS**, $H_0$: (level) stationarity. Statistic $= 74.81 \gg$ $5\%$ critical value $0.463$. $\Rightarrow$ **reject $H_0$** $\Rightarrow$ suggests **non-stationary**.

**The two tests contradict each other.** Such a conflict typically signals that the simple unit-root/stationary dichotomy is the wrong frame — most plausibly because of a **deterministic trend and/or a structural break** in the series (Swedish mobile adoption follows a sharp S-shaped growth path).

**What should be done:**
- Re-run the tests with a **trend** specification (`type = "trend"`), not just an intercept.
- Test for / allow a **structural break** (e.g. Zivot–Andrews).
- **First-difference** the series and re-test; the differences are likely stationary, pointing to $I(1)$.

Given the explosive growth pattern, the operational conclusion is that the level series is **non-stationary**, and it should be **differenced** (or modelled around a trend/break) before use.

### f) Real or spurious relationship?

Both `Mobile` and `FixedPhones` are trending count series, and part (d) showed `Mobile` is non-stationary ($I(1)$); `FixedPhones` is almost certainly non-stationary too. Regressing one $I(1)$ series on another produces a **spurious regression** — extremely high $R^2$ ($0.9995$) and huge $t$-statistics with no genuine economic relationship — **unless the series are cointegrated**.

The reported fit shows exactly the textbook red flags of spuriousness. So the relationship is **likely spurious**; one cannot trust it without first running **panel unit-root** and **panel cointegration** tests. If they are not cointegrated, the level regression is meaningless.

### g) Ways to improve the panel model

- **Address (non-)stationarity:** test for unit roots / cointegration; if $I(1)$ and not cointegrated, estimate in **first differences**.
- **Add time effects** (two-way fixed effects): a common global technology-adoption trend affects all countries each year; controlling for it removes a major source of spurious correlation.
- **Dynamic panel:** adoption is path-dependent — include a lagged dependent variable and estimate with **Arellano–Bond / system GMM** to handle the resulting endogeneity.
- **Robust inference:** use **clustered / panel-robust standard errors** for serial correlation and heteroskedasticity.
- **Scaling & functional form:** normalise **per capita** and allow **non-linearity** (logistic S-curve), since raw counts conflate population size with diffusion.

---

### Quick-reference summary

| Ex. | Core technique | Key takeaways |
|---|---|---|
| 1 | Probit + marginal effects | Coeffs $\to$ latent index only; age($-$), gender($+$), income($-$) significant; jointly significant (LR $p\approx10^{-9}$); `tenure` plausibly endogenous (reverse causality / omitted disposition) $\to$ IV probit; diagnostics show good fit. |
| 2 | Tobit (left-censored at 2.0) | OLS biased $\to$ Tobit; **data censoring**, not corner solution; observed range $[2,4]$, 1206 on the edge; all regressors significant; program effect $\approx +0.555$ GPA on $E(y\mid x)$. |
| 3 | Within (FE) panel | $\beta=2.39$ within-country; 181 countries; FE = within estimator; Poland `Mobile` non-stationary; Sweden PP vs KPSS conflict $\to$ trend/break, difference; relationship likely **spurious** without cointegration; improve via two-way FE / dynamic GMM / differencing. |
