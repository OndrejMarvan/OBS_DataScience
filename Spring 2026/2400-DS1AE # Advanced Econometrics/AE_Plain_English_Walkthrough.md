---
course: Advanced Econometrics
type: plain-English walkthrough (words first, minimal formulas)
pairs_with: AE_Master_Notes.md, AE_Interpretation_Guide.md
tags: [econometrics/AE, plain-english, intuition]
---

# Advanced Econometrics — Explained Like a Person

> [!info] What this file is for
> No wall of symbols. This is the course told as a **story**, in ordinary words, with pictures you can hold in your head. When you've read a topic here and it *makes sense*, then go to the master notes for the formula — and now the formula will just be a tidy summary of something you already understand, instead of a riddle.

---

## The single thing this whole course is about

Imagine you learned one tool in your first econometrics course: ordinary regression (OLS). It's a fantastic tool. You draw the best straight line through a cloud of points, and the slope tells you "when this goes up by one, that goes up by so much." Clean. Intuitive.

But OLS quietly assumes a lot of things about the world: that your outcome is a normal, continuous number that can go up or down freely; that your data points are independent strangers; that the thing you're measuring isn't secretly tangled up with the stuff you left out. **Advanced Econometrics is the whole list of "okay, but what if that's not true?"** Each topic is a rescue mission for one specific way the real world refuses to behave like a tidy OLS textbook.

So the most useful habit you can build is this: when you see a problem, don't ask "which formula?" Ask **"in what way is the world misbehaving here?"** Name the misbehaviour, and the right tool more or less raises its own hand. Is the outcome a yes/no? A count? Are the same people measured repeatedly? Is everything drifting over time? Each of those is a different rescue, and the rest of this document is just walking through them one at a time.

Two ideas come up again and again, so I'll plant them now and keep pointing back to them:

**Idea one: in the fancy models, the number the computer prints is not the answer you want.** In plain OLS the slope *is* the effect — simple. But the moment your outcome is a probability, or a count, or something squashed at a limit, the relationship stops being a straight line and becomes a curve. On a curve, the "effect" of nudging something depends on *where you're standing*. So the raw coefficient becomes a kind of backstage number, and you need an extra step to turn it into the plain-language effect you actually care about. Half the exam traps are people forgetting this and reading the backstage number as if it were the answer.

**Idea two: every statistical test is a question with a built-in default answer, and you have to know which default you're arguing against.** Some tests are set up so that "rejecting" is good news; others so that "rejecting" is bad news. If you don't keep track of which is which, you'll confidently write the exact opposite of the truth. I'll flag the direction every time it matters.

---

## Part 1 — When you measure the same things again and again (Panel data)

Picture you're studying whether being offered more often makes a university course rate better. You don't just have a snapshot of many courses once — you have the *same* courses watched across many semesters. That repetition is a gift, and panel methods are about not wasting it.

Here's why it's a gift. Every course has a personality — some unmeasurable bundle of "this professor is charismatic, this subject is inherently fun, this room has good light." You never measured that bundle, and in a one-shot study it would quietly contaminate your results. But because you watch the *same* course over time, you can let each course be **its own comparison**. You're no longer asking "do popular courses differ from unpopular ones?" (where personality muddies everything); you're asking "when *this particular* course gets offered more, does *its own* rating change?" The personality cancels out, because it's the same course. That hidden personality has a name — the **individual effect** — and the whole game is deciding what to assume about it.

There are two attitudes you can take, and they're genuinely a judgment call:

**Fixed effects** is the suspicious, careful attitude. It says: "I don't trust that hidden personality. It might be sneakily related to the things I'm measuring, and that would bias me. So I'll scrub it out entirely." It does this by, in effect, comparing each course only to itself over time. Very safe. The cost: anything about a course that *never changes* — like whether the lecturer is male or female — gets scrubbed out along with the personality, because the method can't tell a permanent trait apart from the permanent personality. So those variables simply vanish from the results. That's not a bug or an error; it's the price of the scrubbing. If you ever see a variable mysteriously missing from a fixed-effects column, that's why: it never changed, so it got swept away.

**Random effects** is the trusting, efficient attitude. It says: "I'll assume that hidden personality is just harmless random noise, unrelated to what I'm measuring." If that assumption is *true*, this approach is better — it uses the data more fully and it can keep those never-changing variables. If the assumption is *false*, though, it lies to you.

So how do you choose? There's a test (the **Hausman test**) whose only job is to referee this. Think of its starting assumption as "random effects is trustworthy." If the test finds no problem, you happily go with the more efficient random effects. If it finds trouble, you retreat to the safe fixed effects. One genuinely useful exam reflex: this test is based on a number that's easy to sanity-check, and the practice exams sometimes *misprint* the conclusion. If the underlying number is tiny, there's no problem, so it's random effects — trust your own read over a suspicious printed verdict.

There's also a softer hint that doesn't need any test. If your "units" are a specific complete set you care about exactly — all 27 EU countries, say — that leans toward fixed effects, because you're not generalising to anyone else. If your units are a random sample drawn from some big population — a survey of households — that leans toward random effects, because you *are* trying to speak about the wider population.

One last panel point worth its own sentence: because you're watching the same unit over and over, its data points are not independent strangers — this year's observation is cozy with last year's. That cosiness messes up the usual error bars, so panel work almost always recomputes them in a "clustered" way. The estimates themselves don't change; only the honesty of the uncertainty around them does.

---

## Part 2 — When your answer isn't a normal number (the limited-outcome family)

This is the biggest chunk of the course, but it's really one idea wearing five costumes. The idea: **your outcome is constrained in some way that a straight line can't respect, so you bend the line into a curve that does.** Let me take the costumes one at a time.

### Yes/no outcomes (logit and probit)

Suppose the thing you're predicting is whether something *happens* — a person votes or doesn't, a loan defaults or doesn't. The outcome is just 1 or 0. If you tried plain OLS, it would happily predict a "probability" of 1.3 or −0.2, which is nonsense. So instead of a straight line you use an **S-shaped curve** that can never go above 1 or below 0. At the bottom the curve hugs zero, then it rises through the middle, then it flattens against one at the top.

Now here's idea-one in the flesh. On that S-curve, the steepness changes depending on where you are. In the middle (around a fifty-fifty chance) a small nudge to your predictor swings the probability a lot — the curve is steep there. But out at the extremes (someone almost certain to default anyway), the same nudge barely moves anything — the curve is nearly flat. So there's no single "effect of one more unit." The coefficient the computer prints only describes the effect on some internal dial behind the curve, *not* the change in probability you actually want to talk about. To get a real answer you either (a) just state the direction — "more income makes default less likely, and it's statistically solid" — which is always safe, or (b) ask for the **marginal effect**, which is the model's honest calculation of "okay, for a typical person, one more unit changes the probability by *this many* percentage points." Logit also offers a third option, the **odds ratio**, but be careful: that talks about *odds*, which are a different beast from probability. "Triples the odds" is not "three times as likely."

Logit and probit are near-twins — they just use slightly different S-curves — and they'll basically never disagree on your conclusions. Logit is a bit more popular mostly because its odds-ratio story is tidy.

When people grade these models they can't use the familiar R-squared, so they run a little battery of checks instead. The one trap I'll flag hard: among those checks, some are set up so you *want* them to come back "nothing wrong here." In particular, one common goodness-of-fit check has "the model fits fine" as its starting assumption — so a big, comfortable p-value is the *good* result, the opposite of what your instincts scream. Beginners see a high p-value, think "not significant, must be bad," and write the wrong thing.

### Ranked outcomes (ordered logit/probit)

Now suppose the outcome has an order but the gaps aren't real numbers: a survey answer of "bad," "neutral," "good," or a credit rating from junk to pristine. You know good beats neutral, but "good minus neutral" isn't a meaningful quantity the way "$30 minus $20" is. So you can't treat it as a plain number (that would pretend the gaps are equal), and you don't want to throw away the ordering either. The fix imagines a single hidden score sliding along, with **cut-points** chopping it into the ranked bins.

The interpretation here has a sneaky trap worth memorising. If something has a *positive* effect, you can confidently say it makes the **top** category more likely and the **bottom** category less likely. But what it does to the **middle** categories is genuinely unknowable from the sign alone — the probability might bulge up or get squeezed down depending on the details. So never confidently claim a direction for a middle category; that's exactly the mistake the exam is fishing for.

### Unranked outcomes (multinomial and conditional logit)

Now the categories have *no* order at all: someone commutes by car, bus, or train; a couple met through friends, at a bar, or online. There's no "higher" or "lower." You pick one option as the reference and describe everything else relative to it.

The one distinction the exam loves: it depends on **what your explanatory variables are about.** If your variables describe the *person* — their age, their income — use the **multinomial** version, because a person's age is the same no matter which travel option you're discussing. If your variables describe the *options themselves* — the price of the bus versus the price of the train — use the **conditional** version, because those genuinely differ across the choices. Person-facts → multinomial; option-facts → conditional. That's the whole call.

These models also carry a famous hidden assumption with a wonderful illustration. The assumption says: adding or removing some *unrelated* third option shouldn't change how you weigh the two you care about. The classic counterexample: you're split fifty-fifty between driving and taking a red bus. Now a blue bus appears, identical to the red one in every way but colour. Common sense says your car preference should hold steady and the two buses should just split the bus-share between them. But the model, taking its assumption too literally, wrongly drags everything to thirds. The lesson: when some of your options are near-identical substitutes, this family of models can mislead, and there's a test to catch it.

### Count outcomes (Poisson and friends)

Now your outcome is a tally — number of doctor visits this year, number of papers a researcher published, number of accidents at a junction. It can't be negative, it jumps in whole numbers, and it's usually lopsided with a big lump at zero. The starting model (**Poisson**) is elegant but makes one daring promise: that the spread of the counts equals their average. Real life almost never keeps that promise — usually the spread is *bigger* than the average, a situation called **overdispersion**, often because a few cases have enormous counts or because tons of people sit at zero.

So there's a little ladder you climb. Start with Poisson. Check whether the spread really is too big; if it is, step up to the **Negative Binomial**, which is just Poisson with the rigid promise relaxed. Then check whether there are *suspiciously* many zeros — more than even the negative binomial expects; if so, step up again to a **zero-inflated** model, whose nice intuition is that zeros come from two different kinds of people: the "never would, full stop" people (a non-smoker will always report zero cigarettes) and the "could have, just didn't this time" people. The model handles those two zero-sources separately. You pick the final rung of the ladder with a fit score, lowest wins.

Why does overdispersion matter beyond being untidy? Because if you ignore it and stick with Poisson, your *estimates* are still okay but your *error bars shrink dishonestly* — everything looks more statistically significant than it really is, and you start "discovering" effects that aren't there.

### Squashed-at-a-limit outcomes (Tobit)

Last costume. Sometimes the outcome is a normal continuous number *except* it gets piled up against a wall. Household spending on alcohol: loads of households at exactly zero, the rest spread out above. Or a recorded test score where everyone below a threshold is just logged at the threshold. Plain OLS handles this badly both ways — keep the pile at zero and it drags your line down; drop them and you've thrown away a non-random crowd. **Tobit** imagines a true underlying number that you only get to *see* once it clears the wall.

There's a conceptual fork the exam likes to probe, and it's purely about the *story*, not the math. Sometimes the pile-up is **real behaviour** — a zero donation is a genuine choice, a real zero. Other times the pile-up is **hidden information** — the scores below the threshold really happened, they're just *recorded* at the threshold for privacy. Same model, different story, and you're expected to name which one you're looking at. (And, idea-one again: the printed coefficient describes the hidden underlying number, not the squashed observed one, so it needs adjusting before you talk about what you actually see.)

---

## Part 3 — When you're dealing with time and things that drift

This is the part that makes people panic, and I think it's because it's not one model — it's a **sequence of decisions**, a little flowchart you walk through. Once you hold the flowchart as a story, every time-series question becomes "okay, which step am I being asked about?" So let me tell the story first, then fill in the steps.

**The story.** Time-series data is sticky: today leans on yesterday, and you can't shuffle the rows around like you could with a survey. That stickiness is the source of all the danger. The central danger is this: **two things that both drift upward over time will look related even when they have nothing to do with each other.** Ice cream sales and drownings both rise in summer; a naive regression would "prove" ice cream causes drowning. In time-series land this is called a **spurious** relationship — a statistical mirage created by two things wandering in the same direction. The tell-tale sign is a regression that looks gorgeous (huge fit) but has a particular diagnostic flag waving wildly.

So before you trust *any* relationship between time series, you have to ask one gatekeeper question: **are these series "stable," or are they "drifters"?** A stable series wobbles around a fixed home base and keeps coming back to it — its average and its variability don't wander off. A drifter has no home base; it just rambles off wherever the random shocks push it, never returning (the textbook calls this a "random walk" or a "unit root"). Drifters are the dangerous ones, because two independent drifters will fake a relationship.

Then comes the fork:
- If your series are *stable* (or you've tamed a drifter by working with its period-to-period *changes* instead of its raw level), you can safely study how they move together and how shocks ripple through time.
- If your series are *drifters* but they drift *in lockstep* — tethered together so they never wander too far apart — that's the one magical exception called **cointegration**, where the relationship is real and worth modelling specially.
- If they're drifters that *don't* move together, then any relationship you find is the mirage, and you should work with changes instead of levels.

Everything else in this part is just a detail of one of those steps. Now the details.

### Checking whether a series is a drifter

There are tests for "is this a drifter?" and the only hard part is that they don't all phrase the question the same way, which trips everyone. Some tests start from the assumption "this is a drifter" and ask you to prove otherwise — so *rejecting* is the good outcome, it means "stable, you're safe." Another popular test flips it and starts from "this is stable" — so for *that* one, rejecting is the *bad* outcome. They're mirror images. The discipline is simple but non-negotiable: before reading any result, say out loud which test it is and which way its assumption points. (This is idea-two again, and it's where the most marks quietly leak away.)

When you run the main test you also have to pick how many "extra lags" to include to clean it up, and the rule the course uses is: include just enough that a companion check stops complaining about leftover patterns in the residuals — then read your answer at that point. If a series flunks the stability check, the standard fix is to stop modelling its raw level and instead model its *changes* from period to period; if the changes are stable, you've tamed it.

### How ripples spread (distributed-lag and ARDL models)

In the real economy, a change doesn't land all at once. Raise interest rates today and the full effect on the economy dribbles out over many months. So these models let the past values of your driver keep influencing the present — a ripple spreading out over time. The richer version also lets the outcome's *own* past feed forward, which compactly captures a very long ripple.

This is where the famous **multiplier** question lives, and it's worth getting the intuition rather than memorising the formula. There are two numbers people ask for. The **short-run** multiplier is just the immediate splash — how much the outcome moves *this period* when the driver moves. The **long-run** multiplier is the *total* eventual effect once every ripple has finished spreading and the system settles into its new resting place. The reason the long-run number is bigger than the short-run one — and the reason there's a division in its formula — is that when the outcome's own past feeds forward, each period's effect echoes into the next, and the next, and the next. The long-run multiplier adds up that whole infinite echo. The single most common mistake is reporting only the first splash and forgetting the echo, which is exactly what the formula's denominator is there to capture. So if you remember nothing else: *long-run effect = the immediate effect, amplified by its own echoes.*

A quick technical aside that's secretly important: once a model includes the outcome's own past, the usual quick autocorrelation check (Durbin–Watson) silently breaks and starts always saying "all clear" even when things aren't. So in this corner of the course you switch to a different check (Breusch–Godfrey) that still works. It's the same check, as it happens, that you used to clean up the stability test earlier — one tool, two jobs.

### Forecasting from a series' own past (ARMA / ARIMA)

Sometimes you don't care *why* something moves, you just want to predict it from its own history — tomorrow's value from today's and yesterday's. That's what this family does, and the course frames it honestly as "simple methods for forecasting." It mixes two ingredients: leaning on the series' own recent *values*, and leaning on its own recent *surprises* (the bits the model didn't see coming).

The intuition worth carrying: to *identify* which ingredients you need, you look at two diagnostic plots that show how strongly today relates to various points in its past. The pattern of those plots is like a fingerprint that tells you the recipe. And a lovely, very testable fact about forecasting: when you predict further and further into the future with a stable series, your forecast eventually gives up on the wiggles and just settles onto the series' long-run average — because the future shocks you can't see average out to nothing, and all that's left is the home base the series always returns to. A forecast that *never* settles down is itself a sign you're dealing with a drifter.

### The magical exception (cointegration and error correction)

Here's the prettiest idea in the whole time-series block. Normally, regressing two drifters on each other gives you the mirage. But occasionally two drifters are *tied together*. My favourite picture: imagine two drunk friends staggering home, each on their own random unpredictable path (each is a drifter), but they're holding hands. Individually unpredictable; together, the *distance between them* stays small, because whenever one lurches too far the hand-hold tugs them back. When two economic series behave like that — each wandering, but bound by some long-run tether — we say they're **cointegrated**, and now a relationship between them is genuinely real, not a mirage.

The way you check for it: run the relationship, then look at the "leftovers" — the gap between where the relationship predicts each point should be and where it actually is. If those leftovers are *stable* (they keep returning to zero, like the distance between the hand-holding drunks), the tether is real and you've got cointegration. (One sharp technical catch the exam loves: because these leftovers were themselves estimated rather than handed to you, you have to judge their stability against a *stricter* bar than usual — a softer bar would let you "find" cointegration too easily.)

Once you've established the tether, you model the pair with an **error-correction** setup, and it has one star parameter: the **speed of adjustment**. It answers "when the two drift apart, how fast does the tether pull them back?" It *must* come out negative — negative is the whole point, because it means a gap *this* period gets pulled *closed* next period rather than widening. And its size is just the fraction of the gap that closes each period: if it's around −0.3, then roughly 30% of any disequilibrium is corrected per period, and you can say the system fully reconverges over a handful of periods. A healthy, negative, statistically solid speed-of-adjustment is itself the clinching proof that the relationship is real.

And that closes the loop on the whole time-series story: test for drifters → if they're drifters and *not* tethered, the relationship's a mirage, so use changes → if they *are* tethered, celebrate, and model the tether with error correction.

---

## Part 4 — When a variable is "contaminated" (instrumental variables)

Here's a subtle problem that even good data has. OLS quietly assumes your explanatory variables are "clean" — that they aren't secretly entangled with the stuff you left out of the model. Often they're not clean. The classic example: you want the effect of *schooling* on *wages*, but there's an unmeasured something — call it raw ability — that pushes *both* how much school someone gets *and* how much they earn. Now schooling is "contaminated": part of what looks like the payoff to schooling is really just the payoff to the hidden ability riding along with it. Your estimate is biased and there's no amount of OLS that fixes it.

The escape trick is clever. You go hunting for an **instrument**: some *other* variable that nudges schooling around but has *no direct line* to wages except *through* schooling. If you can find one, you can isolate just the "clean" part of schooling's variation — the part driven by your instrument, which by design isn't tangled with the hidden ability — and use only that clean part to estimate the effect. It's like wanting to know if a medicine works but worried that healthier people self-select into taking it; if you could find some external reason that randomly pushed people toward the medicine (unrelated to their health), you'd lean on *that* to get a clean read.

A good instrument needs two properties, and both are common-sense once you see them. It has to actually *move* the contaminated variable (a useless nudge tells you nothing — a "weak instrument," which is actually worse than doing nothing). And it has to be *clean itself* — affecting the outcome *only* through the variable you're fixing, with no sneaky side-door. There are tests for each worry, plus a test for whether you even *needed* the instrument in the first place — because this whole procedure costs you precision, so if your variable turns out to be clean after all, you're better off with plain OLS. The exam reflex: don't reach for instruments reflexively; only when you've shown the contamination is real *and* you've got a strong, clean instrument.

---

## Part 5 — When the outcome remembers its own past in a panel (dynamic panels)

This is a tidy finale because it's really just two earlier ideas shaking hands. Sometimes in panel data the outcome is *persistent* — this year's value genuinely depends on last year's (debt, firm performance, a country's GDP). So you'd want to put the outcome's own past into the model. The trouble: doing that quietly poisons the fixed-effects approach from Part 1 (the lagged outcome ends up entangled with the scrubbing process, creating a bias that's especially bad when you've only watched each unit for a few periods).

The fix borrows from two places you've already been. First, use the "work with changes" trick from the time-series part to wipe out the unit's permanent personality. That leaves a fresh contamination problem — and you patch *that* with the instrument trick from Part 4, using the outcome's *deeper* past as the clean nudge. So it's differencing plus instruments, stapled together. As always there are a couple of diagnostic checks, and — true to form — they're set up so that you *want* them to come back quiet. One small quirk to remember: a certain low-level autocorrelation is *expected* here and you simply ignore it; it's only the next level up that would signal real trouble.

---

## The two ideas, one more time, because they carry most of the marks

If this whole document evaporated from your memory except two paragraphs, make it these.

**The printed coefficient usually isn't the answer.** Whenever the outcome is anything other than a free, continuous number — a probability, a category, a count, a squashed value — the relationship is a curve, not a line, so the effect of nudging something depends on where you're standing on that curve. The coefficient is a backstage number. To get the plain-language effect (a change in probability, a percentage change in a count), you take an extra step the model provides: a marginal effect, an odds ratio, a rate ratio. Reading the backstage number as if it were the front-of-house answer is the single most common way people lose interpretation marks.

**Every test has a default you're arguing against, and you must know which way it points.** "Rejecting" is good news in some tests (your variables matter; your series is stable) and bad news in others (there's heteroskedasticity; there's leftover autocorrelation; your model fits poorly; your series is a drifter). A handful of the tests are deliberately set up so that the *comfortable* result is "fail to reject" — and those are exactly the ones people misread. Before you write a single word about any test, say which test it is and which direction its default points. Get that habit, and a whole category of mistakes just disappears.

Everything else is detail you can look up. These two you carry in.
