# Advanced Econometrics — Exam Solutions

**Paper:** September 2022, onsite (internal header dates it 29 Aug 2022; R. Woźniak / M. Chlebus)
**Significance level:** $\alpha = 5\%$ throughout.

---

## Exercise 1 (40%) — Engle–Granger cointegration & ECM: Unilever NL vs UK quotations

Unilever is dual-listed (NV in Rotterdam, PLC in London) and the shares are not interchangeable. We test whether the two price series, `nl` and `uk`, share a long-run equilibrium.

**Reading the `testdf2` output:** for each series, pick the **smallest augmentation at which the Breusch–Godfrey tests are clean** (all $p_{bg} > 0.05$, no residual autocorrelation), then read the ADF result there.

### a) (10%) Integration orders of the two variables

**Levels** (`test.type = "c"`):

| Series | Chosen aug (BG clean) | ADF | $p_{adf}$ | Conclusion |
|---|---|---|---|---|
| `nl` | 2 (aug 0–1 fail BG) | $0.016$ | $0.957$ | Fail to reject — unit root |
| `uk` | 0 (BG clean already) | $-0.123$ | $0.943$ | Fail to reject — unit root |

Both level series are **non-stationary**.

**First differences** (`test.type = "nc"`):

| Series | Chosen aug | ADF | $p_{adf}$ | Conclusion |
|---|---|---|---|---|
| `dnl` | 0 | $-69.56$ | $0.01$ | Reject — stationary |
| `duk` | 0 | $-67.18$ | $0.01$ | Reject — stationary |

Differencing once makes both series stationary. Therefore:
$$\text{nl} \sim I(1), \qquad \text{uk} \sim I(1).$$
Both are **integrated of order one**, which is the necessary precondition for cointegration.

### b) (10%) Are the two variables cointegrated?

Two $I(1)$ variables are cointegrated if a linear combination of them is $I(0)$. Engle–Granger step 2: estimate the long-run (cointegrating) regression `nl ~ uk` and test its **residuals** for stationarity (`test.type = "nc"`, since residuals are mean-zero).

Residual ADF at the clean augmentation (aug 0; all $p_{bg} > 0.05$): $\text{ADF} = -2.889$, reported $p_{adf} = 0.01$.

**Caveat (important):** the residuals are *estimated*, so the proper benchmark is the **Engle–Granger / MacKinnon** critical value, which is more negative than the standard Dickey–Fuller value the software's $p_{adf}$ assumes. For one regressor the EG 5% critical value is roughly $-3.3$, so $-2.889$ is **borderline** and a strict EG reading would be cautious about rejecting "no cointegration."

**Decisive cross-check — the ECM term:** the error-correction coefficient (`lresid`) is **negative and significant** (see part d), which is the hallmark of a genuine error-correction relationship. Taken together, the evidence supports that **`nl` and `uk` are cointegrated**.

### c) (10%) Cointegrating vector and interpretation

The long-run regression is
$$\widehat{\text{nl}} = 10.5063 + 0.010777\,\text{uk}, \qquad R^2 = 0.9046.$$
Normalising on `nl`, the **cointegrating vector** is $(1,\ -0.010777)$ with constant $-10.5063$, i.e. the stationary equilibrium error is
$$\text{nl} - 0.010777\,\text{uk} - 10.5063 \;\sim\; I(0).$$

**Interpretation of the elements:**
- **Slope $0.010777$ (on `uk`):** the long-run pass-through. A one-unit rise in the UK quotation is matched, in equilibrium, by a $\approx 0.0108$-unit rise in the NL quotation. The tiny coefficient reflects that the two listings are quoted in **different units/currencies** (UK pence vs NL euros), not a weak relationship — it is essentially a scale (exchange-rate) factor linking the prices of the same underlying company.
- **Intercept $10.5063$:** the equilibrium level offset between the two series. Both elements are highly significant ($p < 2\text{e-}16$).

### d) (10%) Does the Error Correction Mechanism work?

ECM (no intercept): $\;\Delta\text{nl} = 0.010041\,\Delta\text{uk} - 0.0035975\,\text{lresid}$.

| Term | Estimate | $t$ | $p$ |
|---|---|---|---|
| $\Delta\text{uk}$ (short-run) | $0.010041$ | $62.74$ | $<2\text{e-}16$ *** |
| `lresid` (error-correction) | $-0.0035975$ | $-2.819$ | $0.00484$ ** |

**Yes, the ECM works:**
- The error-correction coefficient is **negative** ($-0.0036$) and **statistically significant** — the correct sign for stable adjustment. When `nl` sits above its long-run value relative to `uk` (a positive lagged residual), $\Delta\text{nl}$ is pushed **down** next period, pulling the system back toward equilibrium.
- The **speed of adjustment is slow**: only about $0.36\%$ of any disequilibrium is corrected per period — plausible for two near-identical assets where arbitrage is constrained (the shares cannot be exchanged).
- The short-run term $\Delta\text{uk}$ ($+0.0100$, highly significant) captures contemporaneous co-movement.

A significant, correctly-signed error-correction term is itself confirmation of cointegration, closing the loop with part (b).

---

## Exercise 2 (30%) — Binary-choice model: probability of being a smoker

Model: $\text{smoker} \sim \text{sex} + \text{age} + \text{bmi}$ (sex $=1$ for women).

### a) Probit or logit?

A **probit** model — the call specifies `family = binomial(link = "probit")`. The latent specification is $\text{smoker}^* = x'\beta + \varepsilon$, $\varepsilon \sim N(0,1)$, with $P(\text{smoker}=1\mid x) = \Phi(x'\beta)$.

### b) Interpretation of the parameters

Coefficients act on the **latent index** (the $z$-score in $\Phi(\cdot)$); only signs and significance are read directly.

| Variable | Estimate | $p$ | Reading |
|---|---|---|---|
| sex (women) | $-0.802$ | $0.00077$ *** | Significant, negative — **women are less likely to smoke** than men. |
| age | $-0.0049$ | $0.479$ | Not significant. |
| bmi | $-0.0231$ | $0.427$ | Not significant. |
| (Intercept) | $2.407$ | $0.0050$ ** | Significant baseline index. |

Only `sex` matters; the magnitude itself is not a probability change (that's part d).

### c) Hypothesis tested in section (b)

A **likelihood-ratio test** of the full model against the restricted model `smoker ~ sex`:
$$H_0:\ \beta_{\text{age}} = \beta_{\text{bmi}} = 0.$$
Result: $\chi^2 = 1.454$, $df = 2$, $p = 0.4834 > 0.05$ — **fail to reject** $H_0$. **Finding:** `age` and `bmi` are **jointly insignificant**; adding them does not improve the model, so the parsimonious `smoker ~ sex` specification is adequate.

### d) Interpretation of the marginal effects (section c)

Two flavours are reported, and they agree closely:

| Variable | At mean (`atmean=TRUE`) | Average (`atmean=FALSE`) | Significance |
|---|---|---|---|
| sex (discrete) | $-0.2868$ | $-0.2852$ | *** |
| age | $-0.0019$ | $-0.0018$ | ns |
| bmi | $-0.0090$ | $-0.0085$ | ns |

- **sex:** being a woman lowers the probability of being a current smoker by about **$28.5$–$28.7$ percentage points** relative to men (computed as a discrete change, the correct treatment for a dummy).
- **age, bmi:** no significant marginal effect.

The two methods (effect *for the average individual* vs *average of individual effects*) give nearly identical numbers here, so conclusions are robust to the choice.

### e) Interpretation of the $R^2$ statistics (section d)

These are **pseudo-$R^2$** measures — in a nonlinear binary model there is no genuine $R^2$, so several analogues are reported:

| Measure | Value | Note |
|---|---|---|
| McFadden | $0.0585$ | Most commonly reported; values of $0.2$–$0.4$ indicate good fit, so **this is low**. |
| Adj. McFadden | $0.0156$ | Penalised for parameters — very low. |
| Cox–Snell | $0.0762$ | |
| Nagelkerke | $0.1027$ | Cox–Snell rescaled to $[0,1]$. |
| McKelvey–Zavoina | $0.1224$ | Based on latent-variable variance. |
| Efron | $0.0794$ | |
| Count | $0.6105$ | $61\%$ correctly classified… |
| Adj. Count | $0.0563$ | …but only $5.6\%$ improvement over always predicting the modal outcome. |

**Interpretation:** the model has **weak explanatory power**. McFadden's $\approx 0.06$ and the adjusted count $R^2$ of $\approx 0.056$ both show it barely outperforms naïvely predicting the majority class — consistent with only one significant regressor (`sex`). The raw count $R^2$ of $0.61$ is misleadingly high because the sample is unbalanced; the adjusted version corrects for that.

---

## Exercise 3 (30%) — Discrete choice: heating-system selection (California hospitals)

`mlogit(depvar ~ ic + oc | income + agehed)`, 900 obs, 5 alternatives. Reference alternative: **ec** (electric central). Log-Likelihood $-1001.5$, McFadden $R^2 = 0.0203$, LR test $\chi^2 = 41.466$ ($p = 9.3\text{e-}6$).

Choice frequencies: gc $0.637$ (dominant), gr $0.143$, er $0.093$, ec $0.071$, hp $0.056$.

### Use an unordered model — why
The five heating systems (gc, gr, ec, er, hp) have **no natural ranking**, so an **unordered** discrete-choice model is appropriate; an ordered model would impose a meaningless ordering.

### Check the variables
The regressors split into two types, which is exactly what the `|` syntax encodes:
- **Alternative-specific attributes** (vary across the 5 alternatives): `ic` (installation cost) and `oc` (operating cost) — entered with **generic** coefficients (one each).
- **Individual/case-specific characteristics** (vary across hospitals, not alternatives): `income`, `agehed` — entered with **alternative-specific** coefficients (one per non-reference alternative).

### a) Multinomial logit or conditional logit?
**Conditional logit.** The model includes **alternative-specific attributes** (`ic`, `oc` — the cost of *each* system, including the non-chosen ones). A pure multinomial logit uses only chooser characteristics; here the presence of alternative-varying cost data is what defines a conditional (McFadden) logit. (In `mlogit` terminology this mixed specification — generic + alternative-specific terms — is the conditional/"mixed" logit.)

### 2) Interpret parameters (signs only)
- **`ic` $= -0.00153$ (*, neg.):** a higher **installation cost** of an alternative **lowers** the probability of choosing it — economically sensible.
- **`oc` $= -0.00699$ (***, neg.):** a higher **operating cost** of an alternative **lowers** its choice probability — sensible and strongly significant.
- **`income` / `agehed` interactions:** mostly insignificant; signs are relative to the `ec` baseline (e.g. `agehed:er` negative and significant — older directors are less likely to pick electric-room over electric-central).

Both cost coefficients carry the expected **negative** sign: cost deters choice.

### What other variables could be used
- Already in the dataset but unused: **`rooms`** (hospital size) and **`region`** (climate proxy — coastal/mountain/valley) — both individual-specific.
- Additional alternative attributes: energy efficiency, maintenance/repair cost, fuel-price exposure, reliability, emissions/environmental rating, expected system lifetime.

### Diagnostic tests to perform
- **Likelihood-ratio test** of overall significance (shown: $\chi^2 = 41.47$, $p < 0.001$ — jointly significant, though McFadden $R^2 = 0.02$ signals weak fit).
- **IIA (Independence of Irrelevant Alternatives)** tests — the key maintained assumption of conditional/multinomial logit: **Hausman–McFadden** and **Small–Hsiao** tests (re-estimate dropping an alternative and check coefficient stability). If IIA is violated, move to a **nested logit** or **mixed/random-parameters logit**.

---

### Quick-reference summary

| Ex. | Technique | Key takeaways |
|---|---|---|
| 1 | Engle–Granger cointegration + ECM | Both `nl`, `uk` are $I(1)$; residual ADF $-2.889$ (borderline vs EG critical values) but the **negative, significant ECM term** confirms cointegration; cointegrating vector $(1,-0.0108)$, const $10.51$ (unit/currency scaling); adjustment speed only $\approx0.36\%$/period. |
| 2 | Probit + pseudo-$R^2$ | Probit (link stated); only `sex` significant (women $\approx 28.5$pp less likely to smoke); LR test $\Rightarrow$ `age`,`bmi` jointly zero ($p=0.48$); at-mean ≈ average marginal effects; pseudo-$R^2$ all **low** (McFadden $0.06$) $\Rightarrow$ weak fit. |
| 3 | Conditional logit (discrete choice) | Unordered; **conditional** logit (has alternative-specific costs `ic`,`oc`); both costs negative (deter choice); add `rooms`/`region`; diagnostics: LRT + **IIA** (Hausman–McFadden, Small–Hsiao). |
