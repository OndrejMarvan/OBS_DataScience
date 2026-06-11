---
course: Advanced Econometrics
type: in-depth explanatory companion
pairs_with: AE_Master_Notes.md
tags: [econometrics/AE, interpretation, exam-prep, explained]
---

# Advanced Econometrics — The Understanding & Interpretation Guide

> [!info] How this differs from the master notes
> `AE_Master_Notes.md` is the **compressed reference** — formulas, decision rules, cheat-blocks. **This** file is the **slow explanation**: it tells you *why* each thing is true and *exactly what to write* when you see a given R output. Read this to understand; revise from the other.

> [!tip] How to read it
> Don't read front to back in one sitting. Take one model family at a time. Each section has the same shape: **(1) the plain idea → (2) what the output looks like → (3) interpretation scenarios with sentences you can copy → (4) the traps.** The interpretation scenarios are the point.

---

## Part 0 — The one mental model for the whole course

Almost everything in this course is an answer to a single question:

> **"My dependent variable $y$ is not a nice, continuous, normally-distributed number — or my data isn't a clean random sample. So plain OLS will mislead me. What do I do instead?"**

That's it. Every model is OLS's replacement for one specific way reality refuses to cooperate. If you can name *how* $y$ or the data misbehaves, the model picks itself.

| How reality misbehaves | The fix |
|---|---|
| $y$ is yes/no (0 or 1) | logit / probit |
| $y$ is ranked categories (low/med/high) | ordered logit/probit |
| $y$ is unranked categories (car/bus/train) | multinomial / conditional logit |
| $y$ is a count (0,1,2,3…) | Poisson / Negative Binomial |
| $y$ is squashed at a limit (lots of zeros) | Tobit |
| $y$ is only seen for a self-selected group | Heckman |
| data is the same units followed over time | panel (FE/RE) |
| data is one variable over time, and it trends | the whole time-series block |
| a regressor is "contaminated" (correlated with the error) | instrumental variables |

**The second recurring theme:** in all the *non-linear* models (logit, probit, count, Tobit…), **the coefficient is NOT the effect on $y$.** This single fact is behind half the exam traps. We'll come back to it constantly.

**The third recurring theme:** a test result only means something if you know **which way its null points.** Some tests you *want* to reject; some you *want to fail to reject*. Mixing these up is the most common way to lose marks. There's a table for this at the end.

---

## Part 1 — Reading a coefficient (the foundation everything else builds on)

Before any fancy model, get rock-solid on the plain regression coefficient, because every later interpretation is a twist on this.

A coefficient $\beta$ answers: **"if this regressor goes up by one unit, how does $y$ move, holding everything else fixed?"** The phrase "holding everything else fixed" (*ceteris paribus*) is not decoration — it's the whole meaning. $\beta$ is the effect of *that one variable* after the others have already accounted for their share.

But "how does $y$ move" depends on whether $y$ and $x$ are in their raw units or in logs. There are four combinations, and the exam expects you to read the right one automatically:

| Form | Looks like | What $\beta$ means | Sentence you write |
|---|---|---|---|
| level–level | $y = \dots + \beta x$ | units → units | "a 1-unit rise in $x$ raises $y$ by $\beta$ units" |
| **log–log** | $\ln y = \dots + \beta \ln x$ | **elasticity** | "a 1% rise in $x$ raises $y$ by $\beta$%" |
| **log–level** | $\ln y = \dots + \beta x$ | **semi-elasticity** | "a 1-unit rise in $x$ raises $y$ by about $(100\beta)$%" |
| level–log | $y = \dots + \beta \ln x$ | — | "a 1% rise in $x$ raises $y$ by $\beta/100$ units" |

> [!warning] The semi-elasticity trap (this is on the exam)
> In a **log–level** model, "$\beta \times 100\%$" is only an **approximation**, fine when $\beta$ is small (say under 0.1). The **exact** percentage change is
> $$(e^{\beta}-1)\times 100\%.$$
> Why it matters: a dummy coefficient of $-1.10$ does *not* mean "$-110\%$" (you can't fall by more than 100%). The exact answer is $(e^{-1.10}-1)\times100 \approx -67\%$. **When a coefficient is large, always use the exact formula.** When you see a log dependent variable and a big coefficient, that's your cue.

> [!example] Scenario: log-wage regression, coefficient on `educ` is 0.10
> The model is $\ln(\text{wage}) = \dots + 0.10\,\text{educ}$. This is log–level, so 0.10 is a semi-elasticity.
> **What you write:** "Each additional year of education raises the wage by approximately 10% (exactly $(e^{0.10}-1)\times100 = 10.5\%$), holding other factors constant."

> [!example] Scenario: coefficient on a dummy `female` is −0.30 in a log-wage model
> **What you write:** "Women earn about 30% less than men (exactly $(e^{-0.30}-1)\times100 = -26\%$), ceteris paribus." For dummies the exact form is worth using because the gap is usually large enough that the approximation drifts.

**Percent vs percentage point** — keep these apart whenever $y$ is itself a rate. Going from a 2% interest rate to 3% is "+1 **percentage point**" (additive) but also "+50 **percent**" (relative). If the dependent variable is unemployment, inflation, a rate — say *which* you mean.

---

## Part 2 — Why non-linear models hide the effect (the single most important idea)

This is the concept that, once it clicks, unlocks logit, probit, ordered, count, and Tobit all at once. Spend time here.

**In OLS**, the relationship is a straight line: $y = \beta x$. The slope $\beta$ is the same everywhere. Move $x$ by one unit anywhere along the line and $y$ moves by exactly $\beta$. So the coefficient *is* the effect.

**In a logit/probit**, the relationship is an **S-curve**, not a line. The outcome is a probability, trapped between 0 and 1. Near the middle of the curve (probability ≈ 0.5) it's steep — a small push in $x$ changes the probability a lot. Out near the flat ends (probability ≈ 0.02 or ≈ 0.98) it's nearly flat — the same push barely moves the probability.

So **how much a one-unit change in $x$ changes the probability depends on where you are on the curve.** There is no single "effect." The coefficient $\beta$ only describes the effect on the *input to the curve* (the "index" or "log-odds"), not on the probability you actually care about.

That's why these models force you into one of three honest readings:

1. **Sign and significance** — always safe. "$x$ has a positive, significant effect on the probability that $y=1$." You can say this from the coefficient directly.
2. **Odds ratio** ($e^\beta$, logit only) — a multiplicative statement about *odds*, not probability.
3. **Marginal effect** — the actual change in probability, but computed at a chosen point (at the average person, or averaged over everyone).

> [!important] The exam's favourite trap, stated plainly
> If an exam gives you a logit coefficient of, say, 0.30 on `income` and asks you to interpret it, the **wrong** answer is "a one-unit rise in income raises the probability of $y=1$ by 0.30." That sentence treats the S-curve as if it were a straight line. The **right** answers are: "income has a positive, statistically significant effect on the probability of $y=1$" (sign), or — if they give you the marginal effects table — "a one-unit rise in income raises the probability by [the marginal-effect number] percentage points." Never read the raw coefficient as a probability change.

Once you believe "the coefficient is not the effect," every model below is just a different curve and a different way of recovering the real effect.

---

## Part 3 — Panel data (FE vs RE): the most-tested single topic

### The plain idea
Panel data follows the **same units over time** — the same 200 courses across many semesters, the same countries across years. The power of this is that each unit can act as **its own control**. Anything about a unit that doesn't change over time (a country's culture, a lecturer's personality, a firm's industry) can be silently swept away, so it can't bias your results even though you never measured it. That hidden, unchanging, unit-specific thing is called the **individual effect**, written $u_i$.

The whole FE-vs-RE decision is one question: **is that hidden $u_i$ tangled up with your regressors, or not?**

- **Fixed effects (FE)** assumes it *might be* tangled up. To be safe, it removes $u_i$ entirely (by subtracting each unit's own average — "within" transformation). Safe, but it pays a price: anything that doesn't change over time gets removed too.
- **Random effects (RE)** assumes $u_i$ is *not* tangled up with the regressors — it's just random noise. If that assumption is true, RE is better (more efficient, and it can keep time-invariant variables). If it's false, RE is biased and lies to you.

### What the output looks like and how to read it

> [!example] Scenario: a time-invariant variable has no coefficient in the FE model
> You see `Sex` estimated in the random-effects columns but **blank/missing** in the fixed-effects column.
> **Why:** FE removes everything that doesn't change over time by subtracting each unit's average. A lecturer's sex never changes, so subtracting the average wipes it out completely — there's nothing left to estimate.
> **What you write:** "`Sex` cannot be estimated in the fixed-effects model because it is time-invariant; the within transformation eliminates all time-constant variables, which are perfectly collinear with the individual effects."

> [!example] Scenario: the Hausman test — choosing FE vs RE
> You're given a Hausman test: $\chi^2 = 0.19$, df = 1, and a p-value.
> **The logic:** $H_0$ says "the hidden effect is NOT tangled up with the regressors" — i.e. RE is trustworthy. So:
> - **p > 0.05 (fail to reject):** RE is fine and it's more efficient → **use Random Effects.**
> - **p < 0.05 (reject):** RE is biased → **use Fixed Effects.**
> **What you write (if p = 0.66):** "The Hausman test fails to reject the null that the individual effects are uncorrelated with the regressors ($p = 0.66$), so the random-effects estimator is consistent and efficient and is preferred."
> **The trap:** the mock exams printed this *same* statistic ($\chi^2 = 0.19$ on 1 df) with three different p-values, one of them an impossible 0.0065. A chi-square of 0.19 on 1 df gives $p \approx 0.66$, nowhere near significant. **If the printed p-value contradicts the statistic, trust the statistic** — recompute mentally: tiny $\chi^2$ → big p → random effects.

> [!example] Scenario: "why not just use pooled OLS (ignore the panel structure)?"
> **What you write:** "Pooled OLS ignores the individual effects. If those effects are correlated with the regressors it suffers omitted-variable bias (inconsistent); even if they're not, the errors are correlated within each unit over time, so OLS standard errors are understated and inference is invalid."

> [!example] Scenario: interpreting a panel coefficient
> FE model, `Noffered` coefficient = 0.504, significant.
> **What you write:** "Within a given course, each additional semester it is offered raises its average score by about 0.504 points, holding the course's fixed characteristics constant." The phrase "within a given course" is the FE flavour — you're describing change *inside* a unit over time, not differences *between* units.

### The "philosophical" hint
Sometimes the question's wording tips you off before any test: if the units are a **specific, complete set you care about exactly** (all 27 EU countries, these 50 US states), that leans **FE**. If they're a **random sample drawn from a big population** (a survey of households), that leans **RE**. This is independent of the Hausman test and worth a sentence.

---

## Part 4 — Binary outcomes: logit & probit

### The plain idea
$y$ is yes/no. We model the **probability** that $y=1$. We can't use a straight line (it would predict probabilities above 1 and below 0), so we run the linear part through an S-shaped curve that politely stays between 0 and 1. Logit uses one curve (logistic), probit uses another (normal). They give almost identical conclusions; the only real difference is the interpretation tooling (logit has the tidy "odds ratio").

### Reading the output — the three honest statements
Recall Part 2: the coefficient acts on the *index*, not the probability. So:

> [!example] Scenario: probit coefficient on `age` is −0.034, significant; you're asked to "interpret the parameter"
> **What you write:** "Age has a negative and statistically significant effect on the probability of [the outcome]: older individuals are less likely to [outcome]. Because this is a probit, the coefficient itself is not the change in probability — that requires the marginal effect." That last sentence shows the examiner you know the trap.

> [!example] Scenario: a logit coefficient is 2.71 and you're asked for the odds ratio
> $e^{2.71} \approx 15$. **What you write:** "The odds ratio is about 15: using [oxygen] multiplies the odds of [success] by roughly 15 compared to not using it." Note: **odds**, not probability. Odds and probability are different animals — "15× the odds" does not mean "15× as likely in probability."

> [!example] Scenario: you're given a marginal effects table; `oxygen` marginal effect = 0.47
> **What you write:** "Using oxygen raises the probability of success by about 47 percentage points, evaluated at the average of the other variables." This is the cleanest, most direct interpretation — use it whenever marginal effects are provided.

**MEM vs AME** — two ways to compute that marginal effect. MEM = "the effect for an average individual" (plug in the means, then compute the effect). AME = "the average of the effect across all individuals" (compute each person's effect, then average). AME is usually preferred. For the exam, knowing they're close and reporting whichever is given is enough.

### Goodness of fit — and the direction trap
There's no real $R^2$ here. Instead a battery of tests, and they point in **opposite directions**, which is exactly where people lose marks:

> [!important] Which way does each fit-test point?
> - **Likelihood-ratio (LR) test of joint significance:** $H_0$ = "all slopes are zero." You **want to reject** (small p) — that means your variables matter. Like the F-test in OLS.
> - **Hosmer–Lemeshow (and friends mHL, Osius–Rojek):** $H_0$ = "the model fits well." You **want to FAIL to reject** (large p) — a *big* p-value is the good news here. This is backwards from almost every other test.
> - **McFadden pseudo-$R^2$:** don't expect OLS-like numbers. 0.2–0.4 is already "good." Seeing 0.06 doesn't mean the model is broken.

> [!example] Scenario: Hosmer–Lemeshow p-value is 0.76
> **What you write:** "The Hosmer–Lemeshow test fails to reject the null of good fit ($p = 0.76$), so there is no evidence of model misspecification." (A beginner mis-reads the high p as "insignificant, so bad" — it's the opposite.)

> [!example] Scenario: LR test $\chi^2 = 64.8$, df = 4, p ≈ 0
> **What you write:** "The likelihood-ratio test strongly rejects the null that all slope coefficients are zero, so the regressors are jointly significant."

---

## Part 5 — Ordered outcomes: ordered logit/probit

### The plain idea
$y$ is **ranked** but the gaps aren't meaningful numbers: Bad < Neutral < Good, or credit ratings C < B < A. There's one underlying S-curve-style index, sliced into bands by **cut-points** (thresholds). Where your index lands decides your category.

### The interpretation traps (this topic is almost all traps)

> [!important] A positive coefficient only tells you about the two *ends*
> If $\beta > 0$, the probability of the **highest** category goes **up** and the probability of the **lowest** category goes **down**. What happens to the **middle** categories is genuinely ambiguous from the sign alone — you cannot say. To know, you must look at the computed marginal effects for that category.
> **What you write (for a positive coefficient):** "A higher $x$ increases the probability of being in the top category and decreases the probability of the bottom category; the effect on intermediate categories is ambiguous and requires the marginal effects."

> [!example] Scenario: you're given marginal effects for categories 1 and 3 but asked for category 2
> **The shortcut:** for any variable, the marginal effects across all categories **sum to exactly zero** (a probability pushed into some categories must be pulled out of others). So category 2's effect = −(category 1 + category 3). Use subtraction, don't recompute.

---

## Part 6 — Unordered outcomes: multinomial & conditional logit

### The plain idea
$y$ is categories with **no ranking**: car/bus/train, or how a couple met. The model compares each option against one **base category** you pick.

**The MNL-vs-conditional distinction** (a guaranteed exam question) comes down to one thing — *what do your explanatory variables describe?*
- **Multinomial logit (MNL):** the variables describe the **person** (age, income, sex). A person's age is the same no matter which option you're considering.
- **Conditional logit:** the variables describe the **options** (the price of the bus vs the price of the train, travel time of each). These vary across alternatives.

> [!example] Scenario: "should we use conditional logit?" when the regressors are age, income, degree
> **What you write:** "No — multinomial logit is appropriate. All the regressors (age, income, degree) are characteristics of the individual, not of the alternatives; they don't vary across the choice options. Conditional logit requires alternative-specific variables, which we don't have here."

> [!example] Scenario: interpreting a coefficient — relative risk ratio
> Raw coefficients are log-odds *relative to the base category*. Exponentiate to get the **Relative Risk Ratio (RRR)**. RRR = 1.05 for income in the "tattoo" category → "a one-unit rise in income raises the odds of choosing a tattoo *relative to the base category* by 5%." Always say "relative to the base."

> [!important] The IIA assumption — what it is, in one image
> These models assume **Independence of Irrelevant Alternatives**: adding or removing some *other* option shouldn't change the odds between the two you're comparing. The famous counterexample: you split 50/50 between a car and a red bus. Add a blue bus identical to the red one. The model wrongly forces car down to 33%. In reality the car should stay ~50% and the two buses split the rest, because the buses are near-identical substitutes. **Test it with the Hausman–McFadden test** ($H_0$: IIA holds; reject → IIA broken → use nested logit or multinomial probit).

---

## Part 7 — Count outcomes: Poisson & Negative Binomial

### The plain idea
$y$ counts events: 0, 1, 2, 3 doctor visits. Poisson is the starting model. It makes one bold assumption — **the mean equals the variance** ("equidispersion"). Real data almost never obeys this; usually the variance is bigger (**overdispersion**), often because of lots of extra zeros or a few very large counts.

### The decision ladder (this is how the exam walks you through it)
1. Start with Poisson.
2. **Is there overdispersion?** Test it. If yes → move to **Negative Binomial** (it adds a parameter $\alpha$ that lets variance exceed the mean; if $\alpha=0$ it collapses back to Poisson).
3. **Are there too many zeros?** If yes → move to a **zero-inflated** model (ZIP or ZINB), which models the zeros as coming from two kinds of people: "never could" (structural zeros) and "could but didn't this time."
4. **Pick the winner by AIC** (lowest).

> [!example] Scenario: overdispersion LR test, $\chi^2 = 180$, p < 0.001
> **The logic:** $H_0$ = "no overdispersion ($\alpha = 0$), Poisson is fine." Rejecting means overdispersion is real.
> **What you write:** "The test strongly rejects equidispersion, so the Poisson model is inappropriate; the Negative Binomial, which allows the variance to exceed the mean, is preferred."
> **Why it matters (say this for extra marks):** "Under overdispersion, Poisson coefficients stay consistent but the standard errors are understated, inflating t-statistics and risking false significance."

> [!example] Scenario: interpreting a count coefficient — IRR
> Exponentiate to the **Incidence Rate Ratio**: $e^{\beta}$. If $e^{\beta} = 1.25$ → "a one-unit rise in $x$ increases the expected count by 25%." If $e^{\beta}=0.80$ → "decreases the expected count by 20%." It's multiplicative on the expected count, just like the RRR/odds ratio idea elsewhere.

---

## Part 8 — Squashed outcomes: the Tobit (censored data)

### The plain idea
$y$ piles up at a limit. Spending on alcohol: lots of households at exactly 0, the rest spread out positive. GPAs recorded as "2.0" for everyone who actually scored below 2.0. OLS mishandles this both ways — including the zeros drags the line down; dropping them throws away a non-random chunk. Tobit handles it with a latent-variable trick: there's a true underlying $y^*$, and you only observe it when it clears the limit.

> [!important] Corner solution vs data censoring (a 2023-exam question)
> The Tobit math is identical, but the *story* differs, and the exam tests the story:
> - **Corner solution:** the pile-up is **real behaviour** — zero hours worked, zero donation. The zero is a genuine choice.
> - **Data censoring:** the true value **exists but is hidden** — GPAs below 2.0 really happened, they're just recorded as 2.0. The value is concealed, not chosen.
> **What you write (GPA case):** "This is data censoring, not a corner solution: GPAs below 2.0 are real but recorded at the 2.0 threshold for confidentiality." Calling it a corner solution loses the mark.

> [!example] Scenario: interpreting a Tobit coefficient
> Same trap as logit: the raw coefficient is the effect on the **latent** $y^*$, not on the **observed** $y$. The observed effect is the coefficient scaled down by the probability of being uncensored. **What you write:** "The coefficient measures the effect on the latent variable; the effect on the observed outcome is smaller, scaled by the probability that the observation is uncensored — use the reported marginal effect for the observed $y$."

---

## Part 9 — Time series, the whole story as one flow

This block scares people because it's a *sequence of decisions*, not one model. Here's the entire logic as a single narrative — if you hold this story, every time-series exam question is just "which step am I on?"

> [!info] The story
> **1. Time-series data is sticky.** Today depends on yesterday. You can't shuffle the rows. This stickiness is the source of all the trouble.
>
> **2. The danger: trends fake relationships.** If two variables both drift upward over time — even for totally unrelated reasons — a regression of one on the other shows a huge $R^2$ and "significant" coefficients. This is **spurious regression**: a mirage. (The dead giveaway: high $R^2$ but a Durbin–Watson statistic near 0.)
>
> **3. So before trusting any time-series regression, ask: are my variables stationary?** "Stationary" means the series has a stable mean and variance — it wanders around a fixed level rather than drifting off. A non-stationary series (a "random walk" / "unit root" / "$I(1)$") is the dangerous kind.
>
> **4. Test stationarity** with ADF/PP/KPSS. If a series isn't stationary, **difference it** (model the *change* rather than the *level*); if the difference is stationary, the original is "$I(1)$."
>
> **5. Now the fork:**
> - If your variables are stationary (or you've differenced them to be), you can safely model relationships and dynamics → **ARDL** (Part 11).
> - If they're non-stationary BUT move together in the long run → that's **cointegration**, the one case where a levels regression of non-stationary variables is *real*, not spurious → **ECM** (Part 12).
> - If they're non-stationary and *don't* move together → the regression is spurious; difference everything.

Everything below is a detail of one of these steps.

---

## Part 10 — Stationarity testing (reading ADF / PP / KPSS)

### The plain idea
A unit-root test asks "is this series the dangerous, drifting, non-stationary kind?" The headache is that the three standard tests don't all phrase the question the same way.

> [!important] The direction trap — burn this in
> - **ADF and PP:** $H_0$ = "non-stationary (has a unit root)." So **rejecting (small p) is GOOD news** — it means stationary, safe to use.
> - **KPSS:** $H_0$ = "stationary." So **rejecting (small p) is BAD news** — it means non-stationary.
> They are mirror images. Before you read any result, say out loud which test it is and which way its null points.

> [!example] Scenario: testing the S&P 500 level — ADF p = 0.30, PP p = 0.30, KPSS rejects
> **Reading:** ADF fails to reject → non-stationary. PP fails to reject → non-stationary. KPSS rejects its stationarity null → non-stationary. All three agree.
> **What you write:** "All three tests indicate the level series is non-stationary; it must be differenced before modelling."
> Then you test the *differenced* series: ADF rejects, PP rejects, KPSS fails to reject → all say stationary. **Conclusion:** "The differenced series is stationary, so the original series is integrated of order one, $I(1)$."

> [!example] Scenario: the exam's `testdf` table with "augmentations" and Breusch–Godfrey columns
> The ADF test needs you to pick how many lags ("augmentations") to include. The rule the course uses: **read the ADF result at the smallest augmentation where the Breusch–Godfrey test is clean** (all its p-values above 0.05, meaning no leftover autocorrelation).
> **How to do it:** scan down the augmentation rows. Skip any row where a BG p-value is below 0.05 (autocorrelation still present — that row's ADF is unreliable). Stop at the first clean row. Read *its* ADF statistic and p-value.
> **What you write:** "At augmentation 2 the Breusch–Godfrey tests show no residual autocorrelation; there the ADF statistic is [value] with p = [value], so we fail to reject the unit root — the series is non-stationary."

> [!example] Scenario: PP says stationary but KPSS says non-stationary (they conflict)
> **What you write:** "The tests conflict, which typically signals a deterministic trend or a structural break rather than a clean classification. The series should be examined visually and tested with a trend specification (and/or differenced) before proceeding." Don't just pick the answer you like — name the likely cause.

---

## Part 11 — ARDL & multipliers (the calculation question)

### The plain idea
In time series, a change in $x$ doesn't hit $y$ all at once — it ripples over several periods. A **distributed-lag** model includes past values of $x$ to capture the ripple. An **ARDL** also includes past values of $y$ itself (which neatly stands in for an infinite history of $x$).

### The multiplier question (you've now seen this on three papers)

> [!important] Short-run vs long-run multiplier
> - **Short-run (impact) multiplier** = the coefficient on the *current*, unlagged $x$. The immediate, same-period effect.
> - **Long-run multiplier** = the *total* eventual effect of a permanent change in $x$, once all the ripples settle. The formula:
> $$\beta_{LR} = \frac{\text{sum of all } x \text{ coefficients}}{1 - \text{sum of all lagged-}y\text{ coefficients}}.$$
> **The crucial bit:** you divide by $(1 - \sum \alpha)$, where the $\alpha$'s are the coefficients on lagged $y$. Forgetting this denominator — reporting just the sum of the $x$ coefficients — is *the* classic lost mark.

> [!example] Scenario: $\ln\text{TAX}_t = \dots + 0.40\,\ln\text{TAX}_{t-1} + 0.10\,\text{VAT}_t$, find both multipliers
> **Short-run:** the coefficient on current VAT = **0.10**. "A 1-point VAT rise raises log-tax-revenue by 0.10 immediately."
> **Long-run:** $\dfrac{0.10}{1 - 0.40} = \dfrac{0.10}{0.60} \approx 0.167$. "A *permanent* 1-point VAT rise eventually raises log-tax-revenue by about 0.167, once all dynamics work through."
> **The intuition for the denominator:** because last period's $y$ feeds into this period's $y$, the effect echoes and compounds. Dividing by $(1-0.40)$ adds up that infinite echo. Without it you'd report only the first ripple.

> [!warning] Why Durbin–Watson is banned here
> ARDL models contain lagged $y$. The Durbin–Watson test breaks in that situation (it's biased toward 2, falsely declaring "no autocorrelation"). **Use Breusch–Godfrey instead** — it's the same test you used to pick the ADF augmentation. Want a *large* p-value (clean residuals).

---

## Part 12 — Cointegration & the Error Correction Model (the capstone)

### The plain idea
Normally, regressing two non-stationary series is the spurious-regression trap. **Cointegration is the one beautiful exception.** Two series are cointegrated if, although each one wanders non-stationarily on its own, **a combination of them stays stable** — they're tethered. Picture two drunks leaving a bar tied together by a rope: each staggers unpredictably (non-stationary), but the *distance between them* stays bounded (stationary). When they drift apart, the rope pulls them back. That "rope" is the long-run equilibrium.

### How you test and model it (Engle–Granger two-step)
**Step 1:** regress one level on the other ($y = \beta_0 + \beta_1 x + e$). Save the residuals $\hat e$ — these are the "distance between the drunks," the deviations from equilibrium.
**Step 2:** test whether $\hat e$ is stationary (ADF on the residuals). Stationary residuals = the rope holds = **cointegrated**.

> [!important] The special-critical-values trap (the sharpest cointegration point)
> When you ADF-test the Step-2 residuals, you **cannot use the normal ADF critical values.** Because the residuals were *estimated* (not raw data), the normal table makes you reject too easily. You must use the **Engle–Granger / MacKinnon** critical values, which are *more negative* (harder to beat). This is why, on the Unilever exam, a residual ADF of −2.889 looked significant against the normal table but was actually **borderline** against the correct one — and why the deciding evidence was the ECM term below, not the raw test.

### The Error Correction Model — and the one number that matters
If they're cointegrated, you model them as an ECM, which combines short-run wiggles with the pull back to equilibrium:
$$\Delta y_t = \dots + \gamma\,\hat e_{t-1} + u_t.$$
The star of the show is $\gamma$, the **speed of adjustment**.

> [!important] How to read $\gamma$ — and the rule it must obey
> $\gamma$ **must be negative and significant.** Negative is the whole point: if last period the system was *above* equilibrium (positive $\hat e_{t-1}$), a negative $\gamma$ pushes $\Delta y$ *down* this period — back toward the rope. The *size* of $\gamma$ is the **fraction of the gap closed each period**.
> **What you write:** "$\gamma = -0.27$ is negative and significant, confirming error correction: about 27% of any deviation from the long-run equilibrium is corrected each period." A correctly-signed, significant $\gamma$ is *itself* proof of cointegration — which is how you settle borderline Step-2 results.

> [!example] Scenario: "is this relationship real or spurious?" — the full answer template
> This question (2020 mink/muskrat, 2023 phones) wants the whole chain, not a yes/no:
> 1. "First check integration orders: [variable A] is $I(?)$, [variable B] is $I(?)$ (from the ADF tests)."
> 2. If different orders (one $I(0)$, one $I(1)$): "They have different integration orders, so cointegration doesn't apply." If both $I(1)$: "Both are $I(1)$, so cointegration is possible."
> 3. "Testing the residuals [stationary/not] using cointegration critical values, and noting the ECM term is [negative & significant / not], the relationship is [genuinely cointegrated / spurious]."
> A high $R^2$ alone is never the answer — on trending data it's the *warning sign*, not the proof.

---

## Part 13 — The universal "which way does the test point?" table

More marks are lost to this than to any actual computation. Whenever you read a test, find it here first.

| Test | $H_0$ (the null) | You usually WANT to… | Reject (small p) means |
|---|---|---|---|
| OLS t / F, LR joint test | coefficient(s) = 0 | **reject** | the variable(s) matter |
| Breusch–Pagan / White | homoskedastic | fail to reject | heteroskedasticity present |
| Breusch–Godfrey / Ljung–Box | no autocorrelation | **fail to reject** | autocorrelation present |
| Jarque–Bera | residuals normal | fail to reject | non-normal |
| RESET | functional form correct | fail to reject | misspecified form |
| Hausman (panel) | RE is consistent | depends | use FE |
| **Hosmer–Lemeshow** | model fits well | **fail to reject** | poor fit |
| Overdispersion LR | no overdispersion (Poisson ok) | depends | use NegBin |
| Vuong / score (zero-infl.) | no excess zeros | depends | use zero-inflated |
| **ADF / PP** | non-stationary (unit root) | depends | **stationary** (safe) |
| **KPSS** | **stationary** | depends | **non-stationary** |
| Durbin–Wu–Hausman (IV) | regressor exogenous | depends | endogenous, use IV |
| Sargan / Hansen | instruments valid | fail to reject | instruments invalid |

The three bolded "fail to reject is good" rows (Breusch–Godfrey, Hosmer–Lemeshow) and the ADF-vs-KPSS mirror are where almost everyone slips. If you memorise nothing else, memorise those.

---

## Part 14 — Interpretation sentence bank (steal these on the day)

Fill in the brackets. These are the exact phrasings examiners reward.

**OLS / functional form**
- (log–level) "A one-unit rise in [x] is associated with an approximately [100β]% change in [y], ceteris paribus."
- (log–log) "The elasticity is [β]: a 1% rise in [x] changes [y] by about [β]%."
- (dummy in logs, large) "[Group] differ by about $(e^{\beta}-1)\times100$% from the baseline, holding other factors constant."

**Binary (logit/probit)**
- (coefficient) "[x] has a [positive/negative], statistically significant effect on the probability of [outcome]; the coefficient is not itself the probability change."
- (odds ratio) "The odds of [outcome] are multiplied by $e^{\beta} =$ [value] for a one-unit rise in [x]."
- (marginal effect) "A one-unit rise in [x] changes the probability of [outcome] by about [ME] percentage points."

**Panel**
- (Hausman, fail to reject) "The Hausman test does not reject the null ($p =$ [ ]), so random effects is consistent and efficient and is preferred."
- (time-invariant dropped) "[Var] is time-invariant and is therefore eliminated by the within transformation in the fixed-effects model."

**Count**
- (IRR) "A one-unit rise in [x] multiplies the expected count of [y] by $e^{\beta} =$ [value], i.e. a [ ]% change."
- (overdispersion) "Overdispersion is present, so Poisson standard errors are understated; the Negative Binomial is preferred."

**Stationarity**
- "At the augmentation with clean Breusch–Godfrey, the ADF test [rejects/fails to reject] the unit-root null, so [x] is [stationary / $I(1)$]."
- "ADF and KPSS conflict, suggesting a trend or structural break; the series should be inspected and a trend specification tried."

**ARDL / cointegration**
- (long-run multiplier) "The long-run multiplier is $\frac{\sum\beta}{1-\sum\alpha} =$ [value]: a permanent one-unit rise in [x] eventually changes [y] by [value]."
- (ECM term) "$\gamma =$ [neg value] is negative and significant; about [|γ|×100]% of any disequilibrium is corrected each period, confirming a stable long-run relationship."

---

> [!tip] If you only do one thing with this guide
> Internalise **Part 2** ("the coefficient is not the effect") and **Part 13** ("which way does the test point"). Those two ideas, plus the sentence bank in Part 14, cover the large majority of where interpretation marks are won and lost. Everything else is detail you can look up in the reference notes.
