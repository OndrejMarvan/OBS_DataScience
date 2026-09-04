# Algorithms for Data Science — Exam Guide (explained from scratch)

This version assumes you know almost nothing about the topic. Every task is explained from the
beginning: what the thing *is*, why anyone cares, then exactly what to write on the paper.

Built from your lab materials, the lecture slides, and the eight June 2025 past exams (Groups A–H).

---

## The one thing to understand before anything else

All eight past exams are **the same 13 questions with different numbers**. Task 3 is always the
Master theorem. Task 6 is always Dijkstra. Task 12 is always the broken invariant. Nothing else
appears.

So you are not learning "algorithms". You are learning **13 specific procedures**. That is a much
smaller job, and it's why this is doable in the time you have.

**90 minutes. 13 tasks. 60 points + 4 bonus.**

| # | What it asks | Pts | How hard once you know the trick |
|---|---|---|---|
| 1 | Fill blanks in a Python function (multiple choice) | 5 | Medium |
| 2 | Read a recurrence off some code, or fill code to match a recurrence | 4 | Medium |
| 3 | Master theorem: give c, the case, the answer | 4 | **Very easy** |
| 4 | Simplify three ugly expressions | 6 | **Very easy** |
| 5 | Draw an array as a tree, find the broken bit, fix it | 5 | **Easy** |
| 6 | Run Dijkstra's algorithm by hand, fill a table | 9 | Easy but slow |
| 7 | Draw a graph from a table of 0s and 1s | 5 | Medium |
| 8 | Add numbers to a tree | 4 | **Very easy** |
| 9 | Pick the right data structure and justify it | 4 | Medium |
| 10 | Measure heights in a tree, check a balance rule | 5 | Easy but fiddly |
| 11 | Run Floyd–Warshall partially, fill in 5 cells | 5 | **One trick** |
| 12 | Fix one wrong number in an equation | 4 | **One trick** |
| 13 | Bonus: theory about hard problems | +4 | Hard, skip |

**Tasks 3, 4, 5, 8, 12 alone are 23 points and are the easiest things on the paper.** Start there.

---

## Your schedule

| When | Time | Do |
|---|---|---|
| Now | 15 min | Read this section and §1. Then **sleep** — it's the middle of the night. |
| Friday, before work | 60 min | §3 and §4. Two easiest tasks, 10 points. |
| Friday evening, block 1 | 75 min | §6 Dijkstra. Biggest single task (9 pts). |
| Friday evening, block 2 | 75 min | §5, §8, §10 — the three tree tasks (14 pts). |
| Friday evening, block 3 | 60 min | §11 and §12. Two tricks, 9 points. |
| Friday evening, block 4 | 45 min | §2 and §9. |
| **Stop by 23:00** | | Sleep. Seriously. |
| Saturday 06:00–07:30 | 90 min | Sit Group E or F as a timed mock, then read §15. |

---

## 1. Vocabulary you need before the rest makes sense

Read this once slowly. Everything later depends on it.

**Algorithm.** A recipe. A finite list of steps that turns an input into a correct output.

**n.** The size of the input. If the input is a list of 1000 numbers, n = 1000. Everything in this
course is expressed in terms of n.

**Running time.** *Not* seconds. It's the number of basic steps the algorithm takes, written as a
function of n. We care how that number **grows** as n gets bigger, because that's what determines
whether your program still works when the data gets large.

**Why we ignore constants.** An algorithm taking 5n steps and one taking 100n steps are both
"linear" — double the input, double the work. An algorithm taking n² steps is fundamentally
different — double the input, *quadruple* the work. That difference matters; the 5-vs-100 doesn't.
So we throw constants away.

**Θ, O, Ω (theta, big-O, omega).** Three ways of saying "roughly how fast does this grow":
- **O(g)** = "grows *no faster than* g". An **upper** bound, a ceiling.
- **Ω(g)** = "grows *at least as fast as* g". A **lower** bound, a floor.
- **Θ(g)** = both at once = "grows *exactly like* g". This is the one you usually want.

Think of it as: O is "at most", Ω is "at least", Θ is "exactly".

**The growth ladder.** Memorise this order, slowest-growing to fastest:

```
1  <  log n  <  √n  <  n  <  n log n  <  n²  <  n³  <  2ⁿ  <  4ⁿ  <  n!
```

Concretely, for n = 1,000,000: log n ≈ 20, √n = 1000, n = a million, n² = a trillion, 2ⁿ is a number
with 300,000 digits. That's why the ladder matters.

**log n.** "How many times can I halve n before reaching 1?" For n = 8 that's 3 (8→4→2→1), so
log₂8 = 3. **In this course `log` always means log₂.** It shows up whenever an algorithm repeatedly
halves something — which is why it grows so slowly.

**Recursion.** A function that calls itself on a smaller version of the problem, until the problem is
small enough to answer directly.

**Recurrence.** An equation describing a recursive algorithm's running time in terms of itself.
`T(n) = 2T(n/2) + Θ(n)` reads: "to handle n items, I make **2** recursive calls each on **half** the
data, plus **n** units of other work." The Master theorem (§3) solves these.

**Data structure.** A way of organising data in memory. Different arrangements make different
operations fast. That's the whole subject of tasks 5, 8, 9 and 10.

**Graph.** Dots connected by lines. Dots = **vertices** (or nodes), lines = **edges**. Used to model
road networks, social networks, anything with relationships. Edges can have **weights** (a cost,
distance, or time). Tasks 6, 7 and 11 are all about graphs.

**Tree.** A special graph with no loops, drawn hanging downward from a single top node.
- **root** — the top node.
- **child / parent** — a node directly below / above another.
- **leaf** — a node with no children.
- **subtree of v** — v plus everything hanging below it.

**⚠️ Height, this course's definition.** The height of a node = **the number of nodes** on the
longest downward path starting at that node, **counting the node itself**. So:
- a leaf has height **1** (not 0)
- a missing child ("NONE") has height **0**
- **height(v) = 1 + max(height of left child, height of right child)**

Most textbooks count *edges* instead, giving answers one smaller. **The exam uses the node-counting
definition.** This is the single most common way to lose 5 points on task 10.

---

## 2. Course conventions (free marks)

- `log` always means log₂. "Running time" always means the **worst case**.
- `a[2..n]` means an array with positions 2 through n, so it holds **n − 1** items.
- `for i = 1 to n` **includes** i = n.
- **When a node has several neighbours, process them in alphabetical order.** Stated explicitly on
  the exam; it changes your answer in task 6.

---

## 3. Task 3 — Master theorem (4 points, the easiest on the paper)

### What this is about

You're given a recurrence like `T(n) = 64·T(n/2) + Θ(n⁶)` and asked what it works out to. The Master
theorem is a lookup table that answers this in about 40 seconds. You don't need to understand *why*
it works.

### Reading the recurrence

Every one of these has the shape **T(n) = a·T(n/b) + Θ(n^d)**:

- **a** = how many recursive calls you make
- **b** = how much smaller each call's input is (n/b)
- **d** = the power of n in the extra, non-recursive work

For `T(n) = 64·T(n/2) + Θ(n⁶)`: a = 64, b = 2, d = 6.

### The rule

Compute **c = log_b a**. Then compare d with c:

| If | Case | Answer |
|---|---|---|
| d < c | **A** | Θ(n^c) |
| d = c | **B** | Θ(n^c log n) |
| d > c | **C** | Θ(n^d) |

The intuition, if it helps: c measures how much work the recursion generates, d measures the work
done outside it. Whichever is bigger wins. If they tie, you get an extra log n factor.

### How to compute c without a calculator

**c = log_b a means: what power of b gives you a?**

- a = 64, b = 2 → 2^? = 64 → 2⁶ = 64 → **c = 6**
- a = 8, b = 2 → 2³ = 8 → **c = 3**
- a = 9, b = 3 → 3² = 9 → **c = 2**
- a = 100⁴, b = 100 → **c = 4**

Handy powers of 2: 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024 → exponents 1 to 10.

**The exam disguises a.** They write it as a product or power instead of a plain number:
`T(n) = 100³·100·T(n/100)`. First simplify: 100³ · 100 = 100⁴. So a = 100⁴, b = 100, c = 4.

### Worked example 1 (Group A)

> T(n) = 64·T(n/2) + Θ(n⁶)

1. a = 64, b = 2, d = 6.
2. 2^? = 64 → **c = 6**.
3. d = 6 and c = 6, so **d = c** → **Case B**.
4. Case B says Θ(n^c log n) → **T(n) = Θ(n⁶ log n)**.

### Worked example 2 (Group C)

> T(n) = 100³·100·T(n/100) + Θ(n³)

1. a = 100³·100 = 100⁴. b = 100. d = 3.
2. 100^? = 100⁴ → **c = 4**.
3. d = 3 < c = 4 → **Case A**.
4. Case A says Θ(n^c) → **T(n) = Θ(n⁴)**.

### Traps

- **Simplify a first.** They will always disguise it.
- **Floors and ceilings don't matter.** T(n) = aT(⌈n/b⌉) + f(n) is treated identically.
- **The Master theorem never applies to T(n − 1).** It only handles *division* (n/b), not
  subtraction. If you ever see T(n−1), it's a different question. (It won't be in task 3.)
- For Case C the paper tells you to assume the extra "regularity condition" holds. Ignore it.

---

## 4. Task 4 — Simplify three expressions (6 points, 2 each)

### What this is about

You get something like `Θ(9(log₂n)³ + 7log₂(n⁵) + 2)` and must write the simplest equivalent. Three
of these, 2 points each.

### The method — three steps, always the same

**Step 1: Delete all constant factors.** A number multiplying a term contributes nothing to growth.
`9(log n)³` → `(log n)³`. A term that's *just* a constant, however big, becomes `1`.
Even `1000^1000^1000` is **Θ(1)** — it's enormous, but it doesn't grow with n.

**Step 2: Simplify each term into a clean shape** (see the conversion table below).

**Step 3: Keep only the fastest-growing term.** Delete everything else. Use the ladder:

```
1  <  log n  <  (log n)^k  <  √n  <  n  <  n log n  <  n²  <  n³  <  2ⁿ  <  4ⁿ
```

Two named rules from your cheatsheet:
- **LOG < POL** — any power of a logarithm loses to any positive power of n. Even `(log n)^1000`
  loses to `√n`. (It doesn't *look* true for small n — but for n ≥ 65537, log₂n < n^{1/4}.)
- **POL < EXP** — any polynomial loses to any exponential. Even `n^100` loses to `1.0001ⁿ`.

### The conversion table (step 2)

| If you see | Rewrite as | Why |
|---|---|---|
| n^a · n^b | n^{a+b} | multiplying powers adds exponents |
| n^{3/6 + 3/6} | n¹ = n | add the fractions: 3/6+3/6 = 1 |
| (n^a)^b | n^{ab} | |
| log(n^k) | k·log n → **Θ(log n)** | the exponent comes out front |
| log(5n) | log 5 + log n → **Θ(log n)** | log of a product is a sum |
| **log₃(9ⁿ)** | **2n** | the exponent n comes out: n·log₃9 = 2n. **This is linear, not logarithmic.** |
| 2^{2 log₂ n} | n² | because 2^{log₂n} = n, then squared |
| (10^{log₁₀ n})^{10} | n^{10} | same idea: 10^{log₁₀n} = n |
| (2^{n/10})² | 2^{n/5} | multiply the exponents |
| (2n)²/n | 4n | expand and cancel |
| n^{3−3} or 2^{n−n} | 1 | exponent is zero, so it's just 1 |
| 4ⁿ vs 2ⁿ | **4ⁿ is much bigger** | 4ⁿ = 2^{2n} |

The identity behind several of these is **a = b^{log_b a}** — "b raised to the log-base-b of a gives
back a". So `2^{log₂ n} = n`, `10^{log₁₀ n} = n`. Whenever you see a base and a log with the same
base, they cancel.

### Two mistakes that cost marks

**1. Never simplify 4ⁿ to 2ⁿ, or 2^{5n} to 2ⁿ.**
Log bases don't matter — Θ(log₅ n) = Θ(log₂ n) = Θ(log n), because changing log base only multiplies
by a constant. **Exponential bases absolutely do matter.** 4ⁿ = 2^{2n}, which is 2ⁿ *squared*. That
is not a constant factor.

**2. With several variables, keep every term that isn't beaten by another.**
`Θ(mk + n²)` is a perfectly good final answer. mk and n² are unrelated, so neither can be deleted.

### Worked examples from the real papers

**(a) Θ(9(log₂n)³ + 7log₂(n⁵) + 2)**
- Constants out: (log₂n)³ + log₂(n⁵) + 1
- Convert: log₂(n⁵) = 5log₂n → constant out → log₂n. So: (log₂n)³ + log₂n + 1
- Fastest: (log n)³ beats log n beats 1.
- **Answer: Θ((log₂ n)³)**

**(b) Θ(9√n + (n^{3/6+3/6})/7 + 1)**
- Constants out: √n + n^{3/6+3/6} + 1
- Convert: 3/6 + 3/6 = 1, so that term is n¹ = n.  → √n + n + 1
- Fastest: n beats √n beats 1.
- **Answer: Θ(n)**

**(c) Θ(22·n⁶ + 36·2ⁿ + 3·4ⁿ)**
- Constants out: n⁶ + 2ⁿ + 4ⁿ
- Fastest: 4ⁿ. (Exponential beats polynomial; 4ⁿ beats 2ⁿ.)
- **Answer: Θ(4ⁿ)** — *not* Θ(2ⁿ).

**More, from other groups:**

| Expression | Answer | The key move |
|---|---|---|
| Θ(4n³ + 12n²log n + 2n³) | Θ(n³) | n³ beats n² log n |
| Θ(2n^{3−3} + 5 + 2^{n−n}·4) | **Θ(1)** | every exponent is 0 — it's all constants |
| Θ((10^{log₁₀n})^{10} + (2^{n/10})²) | Θ(2^{n/5}) | n^{10} vs an exponential → exponential wins |
| Θ(3n + 4 + n^{5/10+5/10}/2) | Θ(n) | 5/10+5/10 = 1 |
| Θ(29n²⁰ + 2·11ⁿ + 40·10ⁿ) | Θ(11ⁿ) | bigger base wins |
| Θ(3(log₂n)⁵ + 5 + log₂(n⁶)) | Θ((log₂n)⁵) | log(n⁶) is only Θ(log n) |

---

## 5. Task 5 — The heap (5 points)

### What a heap is

A **heap** is a way of storing numbers in a tree so that the biggest one is always at the top.

The rule — the **heap invariant** — is: **every parent is ≥ both of its children.** That's it. Equal
values are allowed (95 above 95 is fine). Note it says nothing about left vs right; siblings can be
in any order.

Why it's useful: "give me the largest item" is instant — it's the root. That's what makes heapsort
and priority queues work.

### Array ↔ tree

A heap is stored as a plain array, and the tree shape is implied by the positions. With 1-based
indexing:

- the **children** of position i are at **2i** and **2i+1**
- the **parent** of position i is at **⌊i/2⌋** (divide by 2, round down)

So for 21 elements the levels are:

```
level 1:  index 1
level 2:  indices 2–3
level 3:  indices 4–7
level 4:  indices 8–15
level 5:  indices 16–21
```

### What the exam asks

You get a 21-element array and must:
1. draw it as a tree,
2. mark the **one** parent–child edge that breaks the rule,
3. give **j** (an index) and a **new value for a[j]** that fixes it — decreased as much as possible.

### The procedure

1. **Draw the tree, writing the index above each value.** Don't try to do this in your head.
2. **Check every parent.** For a 21-element array, only indices 1–10 have children (since 2×11 = 22
   is past the end). For each, compare against its two children.
3. **j is the index of the CHILD**, not the parent. The child is too big, so the child is what you
   shrink. (Easy to get backwards under pressure.)
4. **Choose the new value.** It must satisfy two conditions:
   - **≤ the parent's value** (otherwise you haven't fixed the violation)
   - **≥ both of j's own children** (otherwise you've created a *new* violation below)

   The exam wants the smallest legal value, which is exactly **max(a[2j], a[2j+1])** — the larger of
   j's two children.

### Full worked example (Group A)

> a = ⟨105, 90, 100, 60, 85, 95, 40, 65, 25, 80, 45, 95, 75, 35, 30, 50, 55, 20, 15, 65, 70⟩

The tree:

```
                        [1]105
              [2]90                [3]100
        [4]60      [5]85      [6]95      [7]40
   [8]65 [9]25 [10]80 [11]45 [12]95 [13]75 [14]35 [15]30
[16]50 [17]55 [18]20 [19]15 [20]65 [21]70
```

Now check each parent:

| Parent | Value | Children | OK? |
|---|---|---|---|
| 1 | 105 | 90, 100 | ✓ |
| 2 | 90 | 60, 85 | ✓ |
| 3 | 100 | 95, 40 | ✓ |
| **4** | **60** | **65**, 25 | ✗ **65 > 60** |
| 5 | 85 | 80, 45 | ✓ |
| 6 | 95 | 95, 75 | ✓ (equal is fine) |
| 7 | 40 | 35, 30 | ✓ |
| 8 | 65 | 50, 55 | ✓ |
| 9 | 25 | 20, 15 | ✓ |
| 10 | 80 | 65, 70 | ✓ |

The broken edge is between index 4 (parent, 60) and index 8 (child, 65).

**j = 8** — the child.

Now, how low can a[8] go? Its own children are a[16] = 50 and a[17] = 55. It must stay ≥ 55 so it
doesn't break the rule against its own children, and it must be ≤ 60 to fix the original problem.
Legal range: **[55, 60]**. Smallest → **a[8] = 55**.

---

## 6. Task 6 — Dijkstra's algorithm (9 points, the biggest task)

### What the problem is

You have a map: places (**vertices**) joined by roads (**edges**), each road with a cost. Starting at
place **s**, find the **cheapest** route to every other place.

⚠️ **Cheapest is not the same as shortest.** "Shortest" means fewest roads. "Cheapest" means lowest
total cost. A route with three cheap roads can beat one expensive road.

### How Dijkstra works, in plain English

Keep a running "best known cost so far" label on every place. It starts at 0 for s and ∞ for
everything else — ∞ meaning "no route found yet".

Then repeat: **take the unfinished place with the smallest label, and declare it finished.** Its
label is now guaranteed to be the true cheapest cost. From it, check every neighbour: does going
through this place give the neighbour a cheaper route than what it currently has? If so, update the
neighbour's label and record that we arrived from here.

Why can you declare it finished? Because every other unfinished place already costs more to reach,
and all costs are positive, so no detour through them could ever come back cheaper. **This is exactly
why Dijkstra needs non-negative weights** — a negative edge would break that reasoning.

### The two tables you fill in

- **dist[v]** — the cheapest total cost from s to v.
- **parent[v]** — the place you arrived *from* on that cheapest route. `parent[s] = NONE` because you
  never arrive at the start.

Following parents backwards from any vertex reconstructs the whole route.

### The pseudocode's two odd bits

Your course's version looks strange. Don't be thrown:

```
dist[..] = INF;  parent[..] = NONE;  dist[s] = 0
q = new priority queue;  q.add(s, 0)
while q not empty:
    v = q.extractMax()
    if v removed for the first time:              ← (1)
        for every edge (v, w):
            if dist[w] > dist[v] + c(v,w):
                dist[w] = dist[v] + c(v,w)
                parent[w] = v
                q.add(w, −dist[w])                ← (2)
```

**(2)** The queue hands back the *largest* priority, but they insert **negative** distances. Negating
turns "largest" into "smallest", so it behaves as a normal smallest-first queue. It's a coding trick,
nothing more.

**(1)** A vertex can be inserted several times as its label improves, so the old entries are stale.
This line just skips them. Again, a coding detail — by hand, you simply pick the smallest unfinished
label each time.

**Neither affects what you write on the paper.** By hand it's plain Dijkstra.

### The by-hand procedure

1. Write `∞` next to every vertex on the drawing, and `0` next to s.
2. Pick the **unticked vertex with the smallest number**. Tick it — it's now final.
3. For each of its neighbours **in alphabetical order**: compute (ticked vertex's number) + (edge
   cost). If that's **less** than the neighbour's current number, cross the old one out, write the
   new one, and note the parent.
4. Go back to step 2. Stop when everything is ticked.
5. Copy your final numbers into the answer table.

### Full worked trace (small example — do this once by hand)

Vertices s, a, b, c, d. Edges:
`s–a = 4`, `s–b = 1`, `a–b = 2`, `a–c = 1`, `b–c = 5`, `b–d = 8`, `c–d = 3`.

| Step | Tick | Updates made | dist after this step |
|---|---|---|---|
| start | — | — | s=0, a=∞, b=∞, c=∞, d=∞ |
| 1 | **s** (0) | a: 0+4 = 4 ✓ (parent s)<br>b: 0+1 = 1 ✓ (parent s) | s=0, a=4, b=1, c=∞, d=∞ |
| 2 | **b** (1) | a: 1+2 = **3** < 4 ✓ (parent **b**)<br>c: 1+5 = 6 ✓ (parent b)<br>d: 1+8 = 9 ✓ (parent b) | s=0, a=3, b=1, c=6, d=9 |
| 3 | **a** (3) | c: 3+1 = **4** < 6 ✓ (parent **a**) | s=0, a=3, b=1, c=4, d=9 |
| 4 | **c** (4) | d: 4+3 = **7** < 9 ✓ (parent **c**) | s=0, a=3, b=1, c=4, d=7 |
| 5 | **d** (7) | nothing left | done |

Final answer:

| | s | a | b | c | d |
|---|---|---|---|---|---|
| dist | 0 | 3 | 1 | 4 | 7 |
| parent | NONE | b | s | a | c |

Notice step 2: `a` was already labelled 4 via the direct road from s, but going s→b→a costs 1+2 = 3,
which is cheaper. So the label **and the parent** both changed. That's the heart of the algorithm,
and it's where people make mistakes — remember to update the parent whenever you update the distance.

### The 30-second check that saves 9 points

For **every** vertex w, verify:

> **dist[w] = dist[parent[w]] + (cost of the edge from parent[w] to w)**

Above: a → dist[b] + 2 = 1 + 2 = 3 ✓. c → dist[a] + 1 = 3 + 1 = 4 ✓. d → dist[c] + 3 = 4 + 3 = 7 ✓.

If any row fails, you've made an arithmetic slip. Always do this.

### Verifying against a real exam (Group A)

| | a | b | c | d | e | f | g | h | s |
|---|---|---|---|---|---|---|---|---|---|
| dist | 20 | 1 | 3 | 7 | 13 | 16 | 14 | 10 | 0 |
| parent | f | s | b | s | c | e | e | d | NONE |

Check a few: dist[c] = dist[b] + 2 = 1 + 2 = 3 ✓. dist[e] = dist[c] + 10 = 13 ✓.
dist[f] = dist[e] + 3 = 16 ✓. dist[a] = dist[f] + 4 = 20 ✓.

### Also know for theory questions
Dijkstra runs in **Θ((n + m) log n)** with a heap, where n = vertices, m = edges. It **requires
non-negative weights**.

---

## 7. Task 7 — Draw a graph from an adjacency matrix (5 points)

### What an adjacency matrix is

A table with one row and one column per vertex. A **1** at row a, column c means "there's an edge
between a and c". A **0** means no edge.

For an **undirected** graph the table is symmetric (if a–c exists, so does c–a), so **read only the
upper triangle** — otherwise you'll count every edge twice.

### What "without edge crossings" means

Draw the graph so no two edges cross each other. **Edges may be curves** — the exam says so
explicitly. Any awkward edge can be swung as a wide arc around the outside of the whole picture,
which is the escape hatch for almost every crossing.

### The procedure

1. **List the edges** from the upper triangle.
2. **Count each vertex's degree** (how many edges touch it). High-degree vertices belong near the
   middle; degree-1 vertices dangle harmlessly off the side.
3. **Draw the obvious edges first**, then route the remaining ones as big arcs around the outside.

### Worked example (Group A)

```
     a  b  c  d  e  f
  a  0  1  1  1  1  0
  b  1  0  0  0  0  0
  c  1  0  0  1  0  1
  d  1  0  1  0  1  1
  e  1  0  0  1  0  1
  f  0  0  1  1  1  0
```

Upper triangle gives: **a–b, a–c, a–d, a–e, c–d, c–f, d–e, d–f, e–f** (9 edges).

Degrees: a = 4, d = 4, c = 3, e = 3, f = 3, **b = 1**.

So b just hangs off a — it can never cause a crossing. The rest (a, c, d, e, f) form a denser cluster;
put d and a centrally and arrange c, e, f around them.

**The exam explicitly says: drawing every edge with some crossings scores better than leaving edges
out.** So draw them all, then fix crossings by redrawing edges as arcs.

---

## 8. Task 8 — Insert keys into a binary search tree (4 points)

### What a BST is

A **binary search tree** stores numbers in a tree so you can find any of them quickly. The rule — the
**BST invariant** — is:

> For every node v: **everything in v's left subtree is smaller than v**, and **everything in v's
> right subtree is larger than v.**

"Everything in the subtree", not just the immediate children — the rule applies all the way down.

Why it's useful: to find a number, compare it with the root. Smaller → go left. Larger → go right.
Each comparison eliminates half the tree, so lookup takes about log n steps instead of n.

### How insertion works

To insert a key, do exactly what a search does: start at the root, go left if your key is smaller and
right if it's larger. When you reach an empty spot, put it there.

### The two rules the exam states

1. **Do not restructure the existing tree.** No rebalancing, no moving nodes. Hang new nodes on.
2. **A key that's already in the tree changes nothing.** (In a real dictionary you'd update the
   stored value, but the shape stays identical.)

### Full worked example (Group A)

Starting tree: root **13**, with left child **8** and right child **19**; node **8** has a left child **3**.

```
        13
       /  \
      8    19
     /
    3
```

Insert **10, 5, 9, 19, 16, 20** in that order:

| Key | Path taken | Result |
|---|---|---|
| **10** | 10 < 13 → left to 8. 10 > 8 → right of 8 is empty. | 10 becomes 8's **right** child |
| **5** | 5 < 13 → 8. 5 < 8 → 3. 5 > 3 → right of 3 empty. | 5 becomes 3's **right** child |
| **9** | 9 < 13 → 8. 9 > 8 → 10. 9 < 10 → left of 10 empty. | 9 becomes 10's **left** child |
| **19** | 19 > 13 → right child is 19. **Already there.** | **No change** |
| **16** | 16 > 13 → 19. 16 < 19 → left of 19 empty. | 16 becomes 19's **left** child |
| **20** | 20 > 13 → 19. 20 > 19 → right of 19 empty. | 20 becomes 19's **right** child |

Final tree:

```
            13
          /    \
        8        19
       / \      /  \
      3   10   16   20
       \  /
        5 9
```

### The check that catches every mistake

Read your finished tree **in-order** — for each node: everything left, then the node, then everything
right. **The result must come out sorted.**

Here: 3, 5, 8, 9, 10, 13, 16, 19, 20 ✓. Sorted, so the tree is valid. Ten seconds, always do it.

---

## 9. Task 9 — Choose the right data structure (4 points)

### What's being asked

A short scenario, then pick one of these ten and justify it:

array indexed by keys · AVL tree · find–union · hash table · heap/priority queue · sorted linked
list · queue · stack · sorted array · unsorted array

Across Groups A–H, essentially every option is the answer somewhere — so you need to recognise all
of them, not just memorise one.

### What each one is, briefly

- **Array indexed by keys** — key 7 lives at position 7. Instant access, but you must allocate space
  for every possible key. Only viable when keys come from a small known range.
- **Unsorted array** — just dumped in. Adding is instant; finding means scanning everything.
- **Sorted array** — kept in order, so you can binary-search it in log n. But inserting means shifting
  everything, so it's for data that doesn't change.
- **Sorted linked list** — kept in order, but you can't jump to the middle, so no binary search.
  Removing a node you already hold a pointer to is instant.
- **Hash table** — a function turns each key into an array position. **Fast on average (Θ(1)), but
  Θ(n) in the worst case** if many keys collide. **This is the deciding property.**
- **AVL tree** — a BST that keeps itself balanced, so operations are **Θ(log n) guaranteed, worst
  case**. That guarantee is the entire selling point.
- **Heap / priority queue** — always hands you the largest (or highest priority) item. **You cannot
  look up an arbitrary key in it.**
- **Stack** — last in, first out. Undo, backtracking, DFS.
- **Queue** — first in, first out. Waiting lines, BFS.
- **Find–union** — tracks which items are in the same group and merges groups. Used for connectivity
  and for Kruskal's cycle test.

### Decision key

| Scenario says | Answer |
|---|---|
| small known integer key range, one contiguous memory block, simple, **worst-case** guarantee | **Array indexed by keys** |
| "always need the largest / highest priority", scheduling | **Heap / priority queue** |
| "most recently added first", undo, backtracking | **Stack** |
| "in the order they arrived", FIFO | **Queue** |
| huge or unknown key space, fast **average** lookup, worst case not critical | **Hash table** |
| **worst-case** O(log n) required, with inserts and deletes, ordered | **AVL tree** |
| data is fixed, needs binary search or ordering | **Sorted array** |
| only ever scanned, memory is the priority | **Unsorted array** |
| merging groups, connectivity | **Find–union** |
| ordered, needs O(1) removal at a known node, no random access | **Sorted linked list** |

**The single sharpest distinction:** if the scenario says **"worst case"**, hash table is wrong (it's
Θ(n) worst case) and AVL tree or array-indexed-by-keys is right. If it says **"on average"** or
doesn't mention worst case, hash table becomes attractive.

### How to write the answer — four parts

Marks are spread across all four. Write all four even if briefly.

1. **Name it.**
2. **One sentence mapping it to the scenario.** ("The sensor IDs are integers in a small known range,
   so they can index the array directly.")
3. **Its complexity.** ("Θ(1) worst case for insert and lookup; Θ(M) memory where M is the largest
   key, which is acceptable here since the range is small.")
4. **Why the others lose** — group them rather than listing ten: *"Find–union, stack, queue and heap
   don't support key-based lookup at all. AVL tree, hash table, sorted and unsorted arrays and sorted
   linked lists are all slower in the worst case, and none uses less memory. Also, only the array
   satisfies the requirement of a single contiguous memory block."*

Part 4 is where most of the marks are, and it's the part people skip.

---

## 10. Task 10 — Heights and the AVL invariant (5 points)

### Height, one more time

**Height of a node = the number of nodes on the longest downward path from it, counting itself.**

- leaf → **1**
- missing child (NONE) → **0**
- **height(v) = 1 + max(height(left), height(right))**

The exam prints this definition on the paper. It's still where people lose marks, because most other
sources count edges and give answers one lower.

### What an AVL tree is

A plain BST can go wrong. Insert 1, 2, 3, 4, 5 in order and you get a straight line downward — every
search walks the whole thing, so it's as slow as a plain list.

An **AVL tree** prevents this with a balance rule:

> **For every node, the heights of its two children differ by at most 1** (counting a missing child
> as height 0).

Enforce that everywhere and the tree can never be more than about log n tall, so everything stays
Θ(log n) in the worst case.

### The procedure

1. **Write the height next to every single node.** Start at the bottom — every leaf gets 1 — and work
   upward using `1 + max(children)`. Don't do it in your head; write on the paper.
2. **Read off the two heights asked for.**
3. **Check AVL:** at every node, compare its two children's heights. If any pair differs by **2 or
   more**, the answer is **no**.

### Small worked example

```
            r
          /   \
         p     q
        / \
       x   y
      /
     z
```

Bottom up: z is a leaf → **1**. y is a leaf → **1**. q is a leaf → **1**.
x has one child z (height 1) and one missing child (0) → 1 + max(1, 0) = **2**.
p has children x (2) and y (1) → 1 + max(2, 1) = **3**.
r has children p (3) and q (1) → 1 + max(3, 1) = **4**.

AVL check: at x, children are 1 and 0 → differ by 1 ✓. At p, 2 and 1 → differ by 1 ✓.
At **r**, 3 and 1 → **differ by 2** ✗. **Not AVL**, and the violation is at r.

### Finding X and Y

This part branches, so read the question carefully:

- **If the tree violates AVL:**
  **X** = the node where the violation sits (its children's heights differ by ≥ 2).
  **Y** = a node where **adding one new child repairs** it. That means a node on the **shorter**
  side, positioned so its new child raises that side's height by exactly 1 and closes the gap.
- **If the tree satisfies AVL:**
  **X** = a node where **adding a child would break** the rule.
  **Y** = the node where that break would then **appear** — possibly an ancestor of X, and possibly
  X itself.

**Tie-breaking (stated on the paper):** several valid X → choose the **alphabetically smallest**.
Then, with that X fixed, several valid Y → again alphabetically smallest.

In Group A the answers are: height of bz = 5, height of root = 6, AVL = **no**, X = **ce**, Y = **cd**.
Node ce's two subtrees differ by 2; adding a child beneath cd (on the shorter side) lifts it by one
and restores balance.

This task is fiddly but entirely mechanical. The only skill is annotating heights patiently.

---

## 11. Task 11 — Floyd–Warshall stopped early (5 points)

### What Floyd–Warshall does

Dijkstra finds cheapest routes **from one starting point**. Floyd–Warshall finds them **between every
pair of places at once**, filling in a full n × n table δ.

```
δ[1..n][1..n] filled with +∞
for i = 1 to n:  δ[i][i] = 0                   ← cost from a place to itself is 0
foreach edge (v, w, c):  δ[v][w] = c;  δ[w][v] = c    ← direct edges
for k = 1 to K:
    foreach pair (v, w):
        δ[v][w] = min(δ[v][w], δ[v][k] + δ[k][w])
```

The idea: the outer loop walks through vertices one at a time, and at step k it asks, for every pair,
"would routing **through vertex k** be cheaper than what I have?" After considering all n vertices,
every route has been found.

### The invariant — the whole task

Memorise this sentence:

> **After the outer loop has run k = 1 … K, δ[v][w] holds the cost of the cheapest route from v to w
> that passes through *only vertices numbered 1…K along the way*. If no such route exists, δ[v][w] is
> still +∞.**

Two clarifications that matter:
- "Along the way" means **internal** vertices only. **The endpoints v and w don't count** — they may
  have any number.
- If **no** route obeying that restriction exists, the answer is **INF**, even when the two places
  are obviously connected in the real graph. The algorithm simply hasn't discovered it yet.

The exam gives you a version where the loop stops at K < n, and asks what's in specific cells at
that moment.

### The procedure, per cell

1. Is there a **direct edge** v–w? If so, that cost is already in the table.
2. Otherwise, look for a route v → … → w where **every stop in the middle has a number ≤ K**.
   Take the cheapest such route.
3. If no such route exists → **INF**.

### The trap, every single time

The graph is built with a **hub vertex numbered above K** that connects to everything. It looks like a
2-step shortcut between any two places — but it's **forbidden as an internal stop**. So you must go
the long way round, or find nothing at all.

### Full worked example (Group A)

n = 18. Vertices 1–17 sit on a big ring (1–2–3–…–17–1). Vertex **18 is a hub joined to all 17**.
Every edge costs 1. The loop stops at **K = 13**, so **only vertices 1–13 may be used as internal
stops. Vertices 14, 15, 16, 17 and the hub 18 are forbidden in the middle.**

| Cell | Answer | Why |
|---|---|---|
| δ[18][15] | **1** | There's a direct edge from the hub to 15. No internal stops needed at all — endpoints are always allowed. |
| δ[2][12] | **10** | Go round the ring: 2→3→4→…→12. Internal stops are 3…11, all ≤ 13 ✓. That's 10 edges. (Via the hub it'd be 2, but 18 > 13 is forbidden.) |
| δ[17][14] | **14** | 17→1→2→…→13→14. Internal stops 1…13, all allowed ✓. 14 edges. Note 17 and 14 are the *endpoints*, so their being > 13 is fine. |
| δ[15][3] | **INF** | One way round needs 16 and 17 (both > 13). The other way needs 14 (> 13). Via the hub needs 18 (> 13). **No legal route.** |
| δ[13][16] | **INF** | Needs 14 and 15, or 17, or the hub — all > 13. **No legal route.** |

### A free check

The exam states: **"there are exactly two fields where the answer is INF; if you write INF in more
than two fields you get 0 for those fields."** So if you end up with three INFs, one is wrong — go
back and look harder for a legal route.

---

## 12. Task 12 — Fix the broken invariant (4 points)

### What a loop invariant is

A statement about the variables that stays **true every time the loop condition is checked** — the
same before the first iteration, after the first, after the second, and so on. It's how you prove a
loop does what you claim.

Simple example: `i = 0; j = 0; while i ≠ n: i = i+1; j = j+2`.
The invariant is **2i = j**. True at the start (0 = 0). And each iteration adds 1 to i and 2 to j, so
if 2i = j held before, it still holds after. So when the loop finally exits at i = n, we know
j = 2n — which is what we wanted to prove.

### What the exam asks

You get a loop that updates two variables, plus a proposed invariant like **A·x + C·e = D** with three
constants. **One of the three is wrong.** Change exactly one and give its correct value.

This looks intimidating. It's two lines of algebra.

### The method

**Step 1 — find the per-iteration change.** Trace one pass through the loop body and net out what
happens to each variable. Call these Δx and Δe.

**Step 2 — the preservation equation.** For the invariant to survive an iteration, the left side must
not change. Since x changes by Δx and e by Δe:

> **A·Δx + C·Δe = 0**

**Step 3 — the initialisation equation.** The invariant must hold before the first iteration, so plug
in the starting values x₀ and e₀:

> **A·x₀ + C·e₀ = D**

**Step 4 — find the odd one out.** You now have two equations linking three constants. Test each
constant by assuming the other two are right and checking whether they're consistent. **Exactly one
pairing will be consistent** — and the constant left over is the broken one. The equations give you
its correct value.

### Worked example 1 (Group A)

```
x = 4
e = 0
while x < b:
    t = 4
    x = x + t      → x increases by 4
    e = e + t      → e increases by 4
    x = x − 1      → x decreases by 1
    e = e − 11     → e decreases by 11
```

Given: A = 7, C = 2, D = 28, invariant `A·x + C·e = D`.

**Step 1.** Δx = +4 − 1 = **+3**. Δe = +4 − 11 = **−7**.

**Step 2 (preservation).** A·3 + C·(−7) = 0. With A = 7: 21 − 7C = 0 → **C = 3**.

**Step 3 (initialisation).** x₀ = 4, e₀ = 0. So A·4 + C·0 = D → 7·4 = 28 = D ✓ — the given D is
already correct.

**Step 4.** A and D agree with each other perfectly. C is the odd one out.

**Answer: change C to 3.**

### Worked example 2 (Group C)

```
u = 0
l = 2
while l ≤ h:
    u = u + 4
    r = 2
    l = l − r      → l decreases by 2
    u = u − r      → u decreases by 2
    l = l + 8      → l increases by 8
```

Given: B = 15, A = 36, T = 24, invariant `B·l = A·u + T`.

**Step 1.** Δu = +4 − 2 = **+2**. Δl = −2 + 8 = **+6**.

**Step 2 (preservation).** Both sides must change by the same amount: B·Δl = A·Δu →
6B = 2A → **A = 3B**.

**Step 3 (initialisation).** l₀ = 2, u₀ = 0. So B·2 = A·0 + T → **T = 2B**.

**Step 4 — test each:**
- Assume **B = 15** is right → then A should be 45 (given 36 ✗) and T should be 30 (given 24 ✗).
  *Both* others disagree, so B isn't the reliable one.
- Assume **A = 36** is right → then B = 12, and T = 2B = 24 — **and the given T is 24 ✓**. Consistent.
- Assume **T = 24** is right → B = 12, A = 36 — matches the given A ✓. Consistent.

A and T agree with each other. B is the odd one out.

**Answer: change B to 12.**

### The tell

**The constant to change is the one that contradicts both others, while those two agree with each
other.** Once you see that, this task takes three minutes.

---

## 13. Task 2 — Recurrence from code, or code from a recurrence (4 points)

Two directions appear across the groups.

### Direction 1: read T(n) = a·T(n/b) + Θ(n^d) off the code

- **a = the total number of recursive calls**, counted across *all* the loops that make them.
- **b** comes from the subproblem size, usually written `m = ⌈n/d⌉` — so b = that d. Watch for it
  being computed rather than written (`d = 3·3` means b = 9).
- **f(n) = the non-recursive work** — usually a loop whose bound was built up in stages.

**Worked (Group A):**
- `d = 3·3` = 9, and `m = ⌈n/d⌉` → **b = 9**.
- `while i > n−9` starting at `i = n` and decrementing: runs for i = n, n−1, …, n−8 → **9 calls**.
- `for i = 1 to 5` → **5 calls**. Total **a = 9 + 5 = 14**.
- `p = n·n·n·n` = n⁴, then `for j = 1 to p·(n·n)` = n⁴·n² = n⁶ → **f(n) = Θ(n⁶)**.
- The Copy_Sub_Array calls cost Θ(m) = Θ(n) each, 14 times → Θ(n), which is dwarfed by n⁶. Mention
  it, then drop it.

**Answer: T(n) = 14·T(⌈n/9⌉) + Θ(n⁶)**

### Direction 2: fill blanks in the code so it matches a given recurrence

Same equations, solved backwards.

**Worked (Group C):** target `T(n) = 17T(⌈n/30⌉) + Θ(n⁸)`.
- Code has `m = ⌈n/(6·d)⌉`. Need 6d = 30 → **d = 5**.
- One loop makes 6 calls, another makes `?` → 6 + ? = 17 → **? = 11**.
- Code has `w = 1; for j = 1 to ?: w = w·n` then `for k = 1 to w`. So w = n^?, and we need Θ(n⁸) →
  **? = 8**.

---

## 14. Task 1 — Complete the Python function (5 points)

Multiple choice: 4–5 blank lines, ~15 labelled snippets to choose from. The functions come from the
course's **programming assignments** ("the task is related to the first programming task"), so **your
own submitted code is the best revision material** — dig it out.

**Version seen in Groups A and B — binary search on a reverse-sorted array:**
```python
left = -1
right = n - 1
while left < right:                 # (G)
    p = (left + right + 1) // 2     # (O)
    if x > a[p]:                    # (A)
        right = p - 1               # (I)
    else:
        left = p                    # (C)
return left
```
The array runs largest-to-smallest, and we want the last position whose value is still ≥ x. The `+1`
in the midpoint and `left = p` (not `p+1`) are what make it terminate correctly — that's the whole
difficulty.

**Version seen in Groups C–H — falling blocks:**
```python
heights = {}                        # (O)  ← a dict, not a list
for i in range(n):
    x = pos[i]
    if x not in heights:            # (A)
        heights[x] = 1              # (I)
    else:
        heights[x] += 1             # (C)
    if heights[x] == h:             # (M)
        return x
```
It must be a **dictionary**, because coordinates can be arbitrarily large — `[0] * max(pos)` would
need impossible amounts of memory.

**Technique when unsure:** pick a tiny concrete input and mentally run each candidate. Also use the
structural hints — the paper tells you which lines start with `while` and which with `if`, which
eliminates most options straight away.

---

## 15. Task 13 — Bonus theory (+4, optional — skip unless you have time)

Same shape every time: two decision problems A and B, then tick which statements are true.

**A "decision problem" is one whose answer is just YES or NO.**
**P** = problems solvable in a reasonable (polynomial) amount of time.
**NP-complete** = the hardest problems in NP; nobody knows a fast algorithm for any of them, and
finding one for a single NP-complete problem would give fast algorithms for all of them.
**"A reduces to B"** = if you could solve B quickly, you could solve A quickly, by translating A's
inputs into B's.

**The pattern is always the same: A is secretly easy (in P), B is secretly NP-complete.**

- **Recognising B:** it's a disguised classic. Knapsack ("maximise total value within a budget or
  time limit" — dressed up as choosing lecture recordings), Hamiltonian cycle ("visit every room
  exactly once"), SAT, vertex cover, graph colouring.
- **Recognising A:** it turns out to be something BFS, sorting, or a greedy rule can solve. "Is there
  an ordering of *some* users from Alice to Bob where consecutive users are friends?" is just
  **connectivity** — build a graph and run BFS. Note "*some*, not necessarily all". **If it said
  *all* users, it would be Hamiltonian path and therefore NP-complete.**

**The four true statements, every time:**
- ✅ A can be reduced to B in polynomial time (anything in P reduces to anything, trivially)
- ✅ A is in P
- ✅ It is unknown whether B can be reduced to A in polynomial time
- ✅ It is unknown whether B is in P

And the four false ones are the mirror images: "B reduces to A", "B is in P", "unknown whether A
reduces to B", "unknown whether A is in P".

---

## 16. Cram sheet — read at 07:45, nothing else

```
90 min | 13 tasks | 60+4 pts | neighbours in ALPHABETICAL order | log = log2 | worst case
HEIGHT = NUMBER OF NODES incl. itself. Leaf = 1. NONE = 0. h(v) = 1 + max(children).

T3 MASTER  T(n)=aT(n/b)+Θ(n^d).  c = the power of b that gives a.
   d<c → Θ(n^c)   |   d=c → Θ(n^c log n)   |   d>c → Θ(n^d)
   Simplify a first — they disguise it (100³·100 = 100⁴ → c = 4).

T4 SIMPLIFY  constants→1, convert, keep the fastest term.
   1 < log n < (log n)^k < √n < n < n log n < n² < n³ < 2ⁿ < 4ⁿ
   log(n^k)=k log n → Θ(log n)  |  log₃(9ⁿ) = 2n (LINEAR!)  |  2^{2log₂n} = n²
   n^{3/6+3/6} = n  |  n^{3−3} = 1  |  huge constant = Θ(1)
   NEVER turn 4ⁿ into 2ⁿ. Several variables → keep all unbeaten terms.

T5 HEAP  children of i are 2i, 2i+1; parent ⌊i/2⌋. Parent ≥ both children (equal OK).
   j = the CHILD's index.  New value = max(a[2j], a[2j+1]).

T6 DIJKSTRA  ∞ everywhere, 0 at s. Repeat: tick the smallest unticked, relax its
   neighbours alphabetically. Update the PARENT whenever you update the distance.
   FINAL CHECK: dist[w] == dist[parent[w]] + edge cost, for EVERY w.

T7 GRAPH  read the upper triangle only. Draw ALL edges — arcs around the outside fix crossings.
   Degree-1 vertices dangle off the side.

T8 BST  left < node < right, all the way down. No restructuring. Existing key = no change.
   CHECK: in-order traversal must come out sorted.

T9 DATA STRUCTURE  "worst case" → NOT hash table (it's Θ(n) worst). AVL = guaranteed log n.
   Small key range + contiguous memory → array indexed by keys. Heap can't do lookups.
   Answer in 4 parts: name / how it fits / complexity / why every other option loses.

T10 AVL  write EVERY node's height, bottom-up. Violation = children differ by ≥ 2.
   Violates → X = where it breaks, Y = where a new child repairs it (shorter side).
   Satisfies → X = where a new child would break it, Y = where the break appears.
   Ties → alphabetically smallest.

T11 FLOYD-WARSHALL stopped at K: cheapest route using ONLY vertices 1..K as INTERNAL stops.
   Endpoints don't count. No legal route → INF. The hub is numbered > K → forbidden.
   Exactly 2 INFs — use that as a check.

T12 INVARIANT  Δ per iteration. Preservation: A·Δx + C·Δe = 0. Init: A·x₀ + C·e₀ = D.
   Two constants will agree with each other — change the third.

T13 BONUS  A is in P, B is NP-complete. TRUE: A reduces to B | A in P |
   unknown if B reduces to A | unknown if B in P.

ORDER TO ATTEMPT:  3, 4, 12, 8, 5  (quick wins, ~23 pts)
                →  6, 11, 10       (bigger, mechanical, ~19 pts)
                →  2, 9, 7  →  1  →  13
```

---

## 17. Saturday morning

Groups A and B are used as examples throughout this guide, so they're spoiled. **Keep Group E or F
unopened** and sit it as a clean timed mock at 06:00.

If you're short on time, do only tasks **3, 4, 5, 6, 11, 12** from one group — that's 33 points and
about 30 minutes once you're fluent.
