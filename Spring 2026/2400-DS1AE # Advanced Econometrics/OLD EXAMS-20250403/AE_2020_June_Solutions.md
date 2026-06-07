# Advanced Econometrics — Exam Solutions

**Paper:** June 2020 (M. Chlebus / R. Woźniak)
**Significance level:** $\alpha = 5\%$, **except Exercise 2 which uses $\alpha = 10\%$**.

---

## Exercise 1 (30%) — Logistic regression (out-of-hours submissions) + Poisson counts

Logit for `OutOfHours` (submitted before 9 a.m., after 5 p.m., weekend, or holiday). Three models: (1) country dummies (US base) + `Monday`; (2) drops `Monday`; (3) drops insignificant variables. Fit: AIC = $66886.6 / 66886.5 / \mathbf{66871.3}$, BIC = $67230.1 / 67221.3 / \mathbf{67109.2}$.

### a) How to verify the "they submit on Monday" hypothesis

Include the `Monday` dummy and **test its statistical significance**: $H_0: \beta_{\text{Monday}} = 0$ (a Wald/$z$-test on the coefficient, or equivalently a likelihood-ratio test of model (1) against model (2)).

Here $\hat\beta_{\text{Monday}} = -0.034$ and is **not significant** (no stars), and dropping it barely moves the AIC ($66886.6 \to 66886.5$, i.e. slightly *better* without it). So we **fail to reject** $H_0$ → there is **no evidence** that weekend work is shifted to Monday submissions; the Monday effect is null.

### b) Which model is most appropriate?

Use the information criteria (lower is better). Model **(3)** has the lowest **AIC (66871.3)** *and* the lowest **BIC (67109.2)**, while McFadden's $R^2$ is essentially unchanged. Model (3) — the parsimonious specification with insignificant country dummies removed — is the most appropriate.

### c) Highest vs lowest "culture of overwork"

Coefficients are log-odds relative to the **US** base.
- **Highest:** **China**, $\hat\beta = 0.790^{***}$ — the largest positive, significant coefficient. Its odds of out-of-hours submission are $e^{0.790}\approx 2.20\times$ the US baseline.
- **Lowest:** **Denmark**, $\hat\beta = -0.415^{***}$ — the most negative, significant coefficient. Danish researchers are the *least* likely to submit out of hours relative to the US.

### d) Interpretation of the Poland estimate in model (3)

$\hat\beta_{\text{Poland}} = 0.324^{*}$ (significant only at the $10\%$ level). On the odds scale, $e^{0.324} \approx 1.38$: Polish researchers' **odds of submitting out of hours are about 38% higher than the US** baseline, holding everything else fixed (weak significance).

### e) Poisson model — interpretation of `hour12`

Model: $n \sim \text{as.factor(hour)}$, Poisson; reference is hour 0 (midnight), intercept $3.728$. The coefficient $\hat\beta_{\text{hour12}} = 0.89944$ is a **log rate-ratio** relative to hour 0:
$$e^{0.89944} \approx 2.46.$$
The expected number of submissions at **12:00 (noon) is about 2.46 times** the expected number at midnight (a $\approx 146\%$ increase). Highly significant.

### f) Hour with the most submissions

The largest coefficient identifies the peak. $\hat\beta_{\text{hour16}} = 1.04376$ is the maximum (just above hour 15 at $1.028$ and hour 17 at $1.002$). So submissions peak at **16:00 (4 p.m.)**, with $e^{1.04376}\approx 2.84$ — about **2.84 times** the midnight rate.

---

## Exercise 2 (30%) — Multinomial logit: how couples meet  *(use $\alpha = 10\%$)*

`mlogit(HowTheyMet ~ 0 | Age + Gender + Degree + OppositeSexCouple)`, reference = **MetOnline**. Five alternatives: MetOnline, BarOrRestaurant, Party, ThroughCoworker, ThroughFriend. $\ln L = -133.15$, McFadden $R^2 = 0.0895$, LR test $\chi^2 = 26.17$ ($p = 0.0517$).

### a) Conditional logit instead of multinomial logit?

**No — multinomial logit is correct.** All four covariates (`Age`, `Gender`, `Degree`, `OppositeSexCouple`) are **individual-specific** characteristics: they take the same value for a person regardless of alternative (a person's age doesn't differ "per way of meeting"). A conditional logit requires **alternative-specific attributes** (variables that vary across the choice options), of which there are none here. Hence the multinomial logit, which lets each covariate have alternative-specific coefficients, is the appropriate model.

### b) Interpretation of the $R^2$

McFadden's $R^2 = 0.0895$ is a **pseudo-$R^2$** — there is no genuine $R^2$ in a nonlinear model. It measures the proportional improvement in log-likelihood over the intercept-only model, $1 - \ln L_{\text{full}}/\ln L_{\text{null}}$. At $\approx 0.09$ it indicates **weak explanatory power** (McFadden values of $0.2$–$0.4$ would signal good fit), consistent with the borderline overall LR test ($p = 0.052$).

### c) Does having a degree affect how a person finds a partner?

**No.** Every `Degree` coefficient is insignificant at the $10\%$ level across all alternatives ($p$-values $0.996$, $0.170$, $0.559$, $0.506$ for BarOrRestaurant, Party, ThroughCoworker, ThroughFriend respectively). None reaches significance → **no evidence** that holding a degree changes the way a person meets a partner.

### d) Marginal effect of `Age` on `Online`

The marginal effect of `Age` on the probability of `MetOnline` is $-0.00787$. **Interpretation:** each additional year of age **lowers** the probability of having met one's partner online by about $0.0079$ ($\approx 0.79$ percentage points), at mean covariate values — younger people are more likely to meet online.

### e) Marginal effect of `OppositeSexCouple` on `Online`

The marginal effect is $-0.2289$. **Interpretation:** being an **opposite-sex** couple (vs same-sex) **reduces** the probability of having met online by about $0.229$ ($\approx 22.9$ percentage points), at means. Equivalently, **same-sex couples are far more likely to have met online** — a well-documented empirical pattern.

### f) Formal test: do women meet partners the same way as men?

Likelihood-ratio test, restricted model drops `Female` ($\ln L_r = -134.85$) vs full ($\ln L_f = -133.15$):
$$LR = -2(\ln L_r - \ln L_f) = -2(-134.85 + 133.15) = 3.40.$$
Degrees of freedom $= 4$ (one `Female` coefficient per non-reference alternative). Critical value $\chi^2_{0.10}(4) = 7.779$.

Since $LR = 3.40 < 7.78$ (equivalently $p \approx 0.49 > 0.10$), we **fail to reject** $H_0: \beta_{\text{Female}}=0$ for all alternatives. **Conclusion: women and men find their partners in statistically the same way.**

---

## Exercise 3 (40%) — Time series: mink (predator) vs muskrat (prey), 1848–1909

`testdf2` results (`test.type = "nc"`), reading at the augmentation where Breusch–Godfrey is clean:

| Test | aug 0 ADF | $p_{adf}$ | BG clean? | Conclusion |
|---|---|---|---|---|
| **minks (level)** | $-1.04$ | $0.28$ | yes | unit root — non-stationary |
| **muskrats (level)** | $-6.32$ | $0.01$ | yes | **stationary** |
| $\Delta$minks | $-7.46$ | $0.01$ | yes | stationary |
| $\Delta$muskrats | $-10.04$ | $0.01$ | yes | stationary |
| residuals (`minks~muskrats`) | $-4.21$ | $0.01$ | yes | stationary |

(Levels tests retain 61 effective obs, differenced tests 60 — confirming which series each table belongs to.)

### a) Is it a case of spurious correlation?

You **cannot tell from the simple regression alone** — that's precisely why we run the integration/dynamics analysis. The static regression `minks ~ muskrats` has a **low $R^2 = 0.098$** and a weakly significant negative slope ($-0.0273$, $p=0.013$). Classic *spurious* regression shows the opposite signature (very high $R^2$ + strong $t$ between unrelated non-stationary series), so this doesn't look like textbook spuriousness. But because the two series differ in integration order (below), the static regression is **unbalanced and uninformative**; the genuine link must be judged from the dynamic (ARDL) model and Granger causality, which do reveal a real (if weak, unidirectional) relationship rather than a pure artefact.

### b) Visual inspection — are they integrated?

Visually the two fur series **oscillate (predator–prey cycles)** rather than drifting with a persistent stochastic trend, which is *suggestive* of stationarity/mean-reversion. But the eye cannot distinguish a stationary cycle from a near-unit-root process — **formal ADF tests are required**, performed in (c)–(d).

### c) Integration order of `minks`

ADF on the **level** fails to reject a unit root ($-1.04$, $p=0.28$, BG clean), while ADF on the **first difference** rejects strongly ($-7.46$, $p=0.01$). Therefore **`minks` is $I(1)$**.

### d) Integration order of `muskrats`

ADF on the **level already rejects** the unit root ($-6.32$, $p=0.01$, BG clean) — the series is stationary without differencing. Therefore **`muskrats` is $I(0)$**.

### e) Are minks and muskrats cointegrated?

**No.** Cointegration requires the variables to share the **same integration order, specifically $I(1)$**. Here `minks` is $I(1)$ but `muskrats` is $I(0)$ — **different orders**, so cointegration is not applicable. The "stationary" residual from `minks ~ muskrats` does **not** establish cointegration: with an $I(0)$ regressor on the right-hand side, that residual test is not a valid Engle–Granger cointegration test. The right tool for an $I(1)$/$I(0)$ mix is a dynamic (ARDL) model, not an ECM.

### f) Which ARDL model to select?

The decisive criterion is **no residual serial correlation** (then parsimony):

| Model | Spec | $R^2$ | BG tests (orders 1–4) | Verdict |
|---|---|---|---|---|
| `dl_1` | DL only: `muskrats + L(muskrats,1:4)` | $0.22$ | all $p < 0.01$ — **autocorrelated** | **reject** |
| `dl_2` | ARDL(4,4): adds `L(minks,1:4)` | $0.60$ | $p = 0.19, 0.16, 0.27, 0.41$ — clean | OK but over-parameterised (only `L(minks,1)` significant) |
| `dl_3` | ARDL(1,4): `muskrats + L(muskrats,1:4) + L(minks,1)` | $0.53$ | $p = 0.98, 0.84, 0.88, 0.79$ — clean | **select** |

`dl_1` fails (serially correlated residuals → biased SEs, invalid inference). `dl_2` and `dl_3` both have white-noise residuals, but `dl_3` drops the insignificant `L(minks,2:4)` terms — it is the **most parsimonious adequate model**. **Choose `dl_3`.**

### g) Short- and long-run multipliers for `dl_3`

`dl_3` coefficients: `muskrats` $=0.0061063$, `L1`$=0.0190468$, `L2`$=-0.0002385$, `L3`$=0.0128273$, `L4`$=0.0245691$; `L(minks,1)` $\rho = 0.6718956$.

**Short-run (impact) multiplier** — the contemporaneous effect:
$$\text{SR} = \hat\beta_{\text{muskrats},0} = 0.0061 \approx 0.006.$$
A one-unit rise in muskrats raises minks by about $0.006$ in the *same* year (small and individually insignificant).

**Long-run multiplier** — total effect once dynamics settle:
$$\text{LR} = \frac{\sum_{j=0}^{4}\hat\beta_{\text{muskrats},j}}{1-\hat\rho} = \frac{0.062311}{1-0.671896} = \frac{0.062311}{0.328104} \approx 0.190.$$
**Interpretation:** a *permanent* one-unit increase in muskrats is associated with about **0.19 more minks** in the long-run equilibrium. The effect is positive but economically small.

### h) What does the Granger-causality analysis indicate?

Two tests at lag order 4:

- `grangertest(x = mink, y = muskrat)`: $F = 6.658$, $p = 0.00023$ — **reject** → **mink Granger-causes muskrat**.
- `grangertest(x = muskrat, y = mink)`: $F = 1.934$, $p = 0.120$ — **fail to reject** → muskrat does **not** Granger-cause mink.

**Conclusion: unidirectional Granger causality from mink → muskrat.** Past mink (predator) numbers help predict future muskrat (prey) numbers, but not vice versa. This is consistent with the ARDL evidence in (f)–(g), where the muskrat→mink effect was weak (mostly insignificant lags, tiny long-run multiplier): the predictive/causal flow in this dataset runs predominantly from the predator to the prey.

---

### Quick-reference summary

| Ex. | Technique | Key takeaways |
|---|---|---|
| 1 | Logit + Poisson | Verify Monday via significance test on its dummy ($-0.034$, ns ⇒ rejected); model **(3)** best (lowest AIC/BIC); overwork highest **China** ($0.79$), lowest **Denmark** ($-0.42$); Poland $0.324^{*}$ ⇒ OR$\approx1.38$; Poisson `hour12` $\Rightarrow e^{0.90}\approx2.46\times$ midnight; peak at **16:00** ($e^{1.04}\approx2.84$). |
| 2 | Multinomial logit ($\alpha=10\%$) | **MNL not conditional** (all covariates individual-specific); McFadden $0.09$ ⇒ weak; Degree all insignificant ⇒ no effect; Age→Online $-0.0079$; OppSex→Online $-0.229$ (same-sex meet online more); LR test $=3.40<\chi^2_{.10}(4)=7.78$ ⇒ women meet partners like men. |
| 3 | Integration / ARDL / Granger | **minks $I(1)$, muskrats $I(0)$** ⇒ **not cointegrated** (different orders); pick **`dl_3`** (clean BG, parsimonious); SR mult $\approx0.006$, LR mult $\approx0.19$; **mink Granger-causes muskrat**, not the reverse (unidirectional predator→prey). |
