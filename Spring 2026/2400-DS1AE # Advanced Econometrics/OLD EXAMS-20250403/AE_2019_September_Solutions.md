# Advanced Econometrics — Exam Solutions

**Paper:** September 5, 2019 (M. Chlebus / R. Woźniak)
**Significance level:** $\alpha = 5\%$ throughout.

> Note: Exercises 1 and 3 reuse the same datasets as the 2018 September paper, **but Exercise 3 reports a different Hausman $p$-value (0.6665 vs 0.0065)**, which reverses the model choice — read part (c) carefully.

---

## Exercise 1 (Cointegration & ECM) — median age at first marriage, Female vs Male

We test for a long-run equilibrium between `Female` and `Male` median marriage ages (1947–2010). For each `testdf` block pick the **smallest augmentation where the Breusch–Godfrey tests are all clean** ($p_{bg} > 0.05$), then read the ADF there.

### a) Visual rationale for cointegration

From the figure, both series **trend upward together** over the sample and stay roughly parallel (a broadly constant gap), wandering without reverting to a fixed mean individually but moving together. That co-movement of two trending series is exactly the visual signature that motivates checking for cointegration — **yes, it is reasonable to consider it**.

### b) Do the series satisfy the basic precondition (same integration order)?

Cointegration requires both variables to be integrated of the **same order** (here, $I(1)$). Clean-augmentation ADF results:

| Series | aug | ADF | $p_{adf}$ | Conclusion |
|---|---|---|---|---|
| Female (level) | 0 | $1.84$ | $0.99$ | unit root — non-stationary |
| $\Delta$Female | 0 | $-8.45$ | $0.01$ | stationary |
| Male (level) | 0 | $1.33$ | $0.99$ | unit root — non-stationary |
| $\Delta$Male | 0 | $-7.90$ | $0.01$ | stationary |

(All BG $p$-values exceed $0.05$ at augmentation 0 in each block, so no extra augmentation is needed.)

Both series are **$I(1)$** — non-stationary in levels, stationary after one difference. The precondition is **satisfied**.

### c) Is there evidence of cointegration?

Engle–Granger step 2: estimate the long-run regression `Female ~ Male` and test its **residuals** for stationarity.

Residual ADF (aug 0, BG clean): $\text{ADF} = -5.38$, $p_{adf} = 0.01$ → **reject** the unit-root null → residuals are **stationary**. Unlike a borderline case, $-5.38$ is far beyond even the (more negative) Engle–Granger critical values, so the conclusion is robust: **the variables are cointegrated.** This is corroborated by the significant, correctly-signed error-correction term in part (e).

### d) Cointegrating vector and interpretation

Long-run regression:
$$\widehat{\text{Female}} = -4.808 + 1.102\,\text{Male}, \qquad R^2 = 0.986.$$
Normalising on `Female`, the **cointegrating vector** is $(1,\ -1.102)$ with constant $4.808$; the stationary equilibrium error is
$$\text{Female} - 1.102\,\text{Male} + 4.808 \;\sim\; I(0).$$

**Interpretation:** in the long run, a one-year increase in the male median marriage age is associated with a $1.102$-year increase in the female median marriage age — an almost one-to-one (slightly more than proportional) co-movement. The constant captures the structural gap between the two ages.

### e) Does the ECM work?

$$\Delta\text{Female} = 0.068 + 0.307\,\Delta\text{Male} - 0.270\,\text{lresid}, \qquad R^2 = 0.255,\ F = 10.28^{***}.$$

| Term | Estimate | (SE) | Reading |
|---|---|---|---|
| `lresid` (error-correction) | $-0.270$ *** | $(0.070)$ | $t \approx -3.86$; **negative & significant** — adjustment works. |
| $\Delta$Male (short-run) | $0.307$ *** | $(0.082)$ | Contemporaneous co-movement. |
| Constant | $0.068$ *** | $(0.017)$ | Common upward drift (~0.068 yr/yr). |

**Yes, the ECM works.** The error-correction coefficient $-0.270$ is negative (correct sign) and highly significant: about **27% of any deviation** from the long-run equilibrium is corrected within one year — a moderate, plausible adjustment speed. The short-run term ($+0.307$) says that within a year, female age changes move with male age changes; the constant reflects the shared upward drift. The whole model is jointly significant ($F=10.28$, $p<0.01$).

---

## Exercise 2 — Logit models: voting for Trump (BODS / SDO / RWA study)

Binary dependent variable `Trump` ($=1$ Trump, $=0$ Clinton). Four nested logit models reported.

| | (1) full | (2) | (3) | (4) |
|---|---|---|---|---|
| BODS | $0.290^{*}$ | $0.336^{**}$ | $0.333^{**}$ | $0.326^{**}$ |
| SDO | $-0.457^{***}$ | $-0.450^{***}$ | $-0.433^{***}$ | $-0.435^{***}$ |
| RWA | $-0.590^{***}$ | $-0.570^{***}$ | $-0.577^{***}$ | $-0.578^{***}$ |
| Gender | ns | ns | — | — |
| Age | $0.016$ ns | $0.015$ ns | $0.015$ ns | — |
| EDU dummies | all ns | — | — | — |
| Log-Lik | $-195.67$ | $-199.61$ | $-200.50$ | $-201.68$ |
| **AIC** | $419.33$ | $413.23$ | **$411.00$** | $411.37$ |

### a) Why a logit model instead of simple linear regression?

Because `Trump` is **binary**. A linear probability model (OLS) has fundamental flaws here:
- Fitted values can fall **outside $[0,1]$**, which are nonsensical as probabilities.
- The errors are **heteroskedastic by construction** and **non-normal** (Bernoulli), invalidating standard OLS inference.
- It imposes **constant marginal effects**, unrealistic for a probability bounded in $[0,1]$.

Logit maps the linear index through $\Lambda(x'\beta)=\frac{e^{x'\beta}}{1+e^{x'\beta}}$, guaranteeing probabilities in $(0,1)$ and a coherent odds interpretation.

### b) Most appropriate model

Use **AIC** (lower is better). The values are $419.33 > 413.23 > \mathbf{411.00} < 411.37$, so **model (3) has the lowest AIC** → choose **model (3)** (`BODS + SDO + RWA + Age`). It drops the jointly-uninformative education dummies and gender while retaining the lowest information loss; model (4) (dropping `Age`) is essentially tied but slightly worse on AIC.

### c) Interpret the parameters of the chosen model (3)

Coefficients are on the **log-odds** scale; $\exp(\beta)$ is the **odds ratio**. The significant variables:

- **BODS $= +0.333$ (**):** higher body-odour disgust sensitivity raises the odds of voting Trump. $\exp(0.333) \approx 1.40$ → each one-unit increase in BODS multiplies the odds by about $1.40$ ($\approx +40\%$). This is the article's headline finding.
- **SDO $= -0.433$ (***):** $\exp(-0.433) \approx 0.65$ → a one-unit rise in the social-dominance score multiplies the odds by $0.65$ ($\approx -35\%$).
- **RWA $= -0.578$ (***):** $\exp(-0.578) \approx 0.56$ → a one-unit rise multiplies the odds by $0.56$ ($\approx -44\%$).

`Age` is not significant. (Read the SDO/RWA *signs straight off the table* — they reflect this dataset's specific scale coding; what matters for full marks is the correct odds-ratio interpretation and significance.)

### d) Do models (1)–(4) illustrate general-to-specific?

**Yes.** General-to-specific (the LSE / "Gets" approach) starts from the most general model and sequentially deletes the least informative regressors toward a parsimonious specification. Here (1) is the general model (all covariates), and (2)→(3)→(4) progressively remove the education dummies, then gender, then age — a textbook general-to-specific reduction sequence.

### e) Modelling `candidate` ∈ {Trump, Clinton, Johnson, Stein, Castle}

Five **unordered** categories with no natural ranking → a **multinomial logit** (or conditional/multinomial logit if alternative-specific attributes were available). The binary logit no longer applies.

### f) Modelling `FiscCons` (1 = very conservative … 7 = very liberal)

A **seven-point ordinal scale** — the categories are ranked but the gaps are not necessarily equal → an **ordered logit (or ordered probit)** model. Treating it as continuous (OLS) would wrongly assume cardinal, equal-interval spacing; treating it as unordered would throw away the ordering.

---

## Exercise 3 — Panel data: do grades rise with course experience?

Within (FE) model (1) and random-effects models (2)–(5). FE call: `AvScore ~ Noffered + Sex`, `model="within"`. **Unbalanced panel: n = 200, T = 4–30, N = 3131.** Hausman: $\chi^2 = 0.18577$, $df=1$, **$p = 0.6665$**.

### a) Is the panel balanced?

**No — it is unbalanced.** The output states $T = 4\text{–}30$ (the number of semesters varies across courses, from 4 up to 30), so the units do not share a common time dimension.

### b) Why was `Sex` not estimated in the FE model?

`Sex` is **time-invariant** (a lecturer's sex does not change across the semesters of a course). The within transformation subtracts each unit's time-mean, which annihilates any time-invariant regressor — so `Sex` is perfectly collinear with the individual effect and **cannot be identified** in the fixed-effects model.

### c) Which of models (1) and (2) should be chosen?

Decide via the **Hausman test**: $\chi^2 = 0.186$, $df=1$, $p = 0.6665 > 0.05$ → **fail to reject** $H_0$. There is no evidence that the random-effects estimator is inconsistent, so we choose the **random-effects model (2)** — it is consistent here *and* more efficient than FE.

*(Contrast with the 2018 paper, whose printed $p=0.0065$ would have led to fixed effects. Always recompute: with $\chi^2=0.186$ on $1$ df the implied $p$ is $\approx 0.67$, confirming RE.)*

### d) If the individual effect (positive attitude) is correlated with grading

Then $E(u_i \mid x_{it}) \neq 0$ — the unobserved effect is **correlated with the regressors**. Random effects assumes exactly the opposite ($E(u_i\,x_{it})=0$); violating it makes RE **inconsistent**. In that case you must use the **fixed-effects** estimator, which differences the correlated effect away and stays consistent. (This is the conceptual flip-side of the Hausman logic in part c.)

### e) Interpret the Hausman test

- $H_0$: the individual effects are uncorrelated with the regressors → **both FE and RE are consistent**, but **RE is efficient** (preferred).
- $H_a$: one estimator is inconsistent (RE inconsistent; FE still consistent).
- Result: $\chi^2 = 0.186$, $p = 0.6665 > 0.05$ → **do not reject $H_0$** → use the **random-effects** model.

### f) What can go wrong with simple (pooled) OLS?

It ignores the panel structure:
- If the individual effects are correlated with regressors, OLS suffers **omitted-variable / heterogeneity bias** (biased, inconsistent estimates).
- Even if they are uncorrelated, the errors are **serially correlated within each course**, so OLS standard errors are **understated** and inference (t-, F-tests) is invalid.

### g) Did professors give higher grades in Spring? (`Semester`, 0=Fall, 1=Spring)

The `Semester` coefficient is **positive and significant**: $0.088^{***}$ in models (3)–(4) and $0.151^{***}$ in model (5) ($p<0.01$). We **reject** the null of no seasonal difference → average scores are about $0.088$ points higher in Spring (statistically significant, though small on the 0–100 scale).

### h) Does student quality increase each year? (`Year`)

The `Year` coefficient is **not significant**: $-0.010$ (SE $0.104$) in model (4) and $0.048$ (SE $0.183$) in model (5) — both with $|t| < 1$. There is **no evidence** that average scores (student quality) rise systematically year over year.

### i) Comment on model (5) — courses offered at least 10 times

Restricting to courses offered $\geq 10$ times ($N$ drops to $1504$) introduces **selection bias**. O'Connor–Cheema's own hypothesis is that *high-grading courses are more likely to be offered again* — so courses surviving to ten-plus offerings are **selected on the outcome** (`AvScore`). Conditioning on a variable that depends on the dependent variable biases the estimates and breaks representativeness. The `Noffered` slope edges down ($0.499 \to 0.476$) and the `Semester` effect grows ($0.151$), but none of this can be read causally: the sub-sample is **endogenously selected**, so model (5) mainly illustrates the *survivorship/self-selection* problem rather than a cleaner estimate.

---

### Quick-reference summary

| Ex. | Technique | Key takeaways |
|---|---|---|
| 1 | Engle–Granger + ECM | Both ages $I(1)$; residual ADF $-5.38$ ⇒ cointegrated (robust); vector $(1,-1.102)$, const $4.808$ (near 1-for-1); ECM term $-0.270$*** ⇒ ~27%/yr adjustment, works. |
| 2 | Binary / discrete choice | Logit (not LPM) for binary $Y$; AIC picks **model (3)**; BODS$+$ (OR≈1.40), SDO$-$, RWA$-$ significant; (1)→(4) = general-to-specific; 5-candidate $Y$ ⇒ multinomial logit; 7-point scale ⇒ ordered logit. |
| 3 | FE vs RE panel | Unbalanced ($T$=4–30); `Sex` dropped (time-invariant); **Hausman $p=0.67$ ⇒ random effects**; correlated effect ⇒ FE; pooled OLS ⇒ heterogeneity bias + wrong SEs; Spring effect $+0.088$*** significant; `Year` insignificant; model (5) ⇒ selection bias. |
