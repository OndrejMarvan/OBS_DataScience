# Algorithms for Data Science — Complete Exam Guide

Everything you need is in this one document. It starts from the basic vocabulary and works through
all thirteen tasks of the exam, with the concepts explained before the procedures and worked examples
from both real papers.

Built from the **June 2026 exam, Groups A and B (with full solutions)** and the **practice exam**.

---

# Part 1 — What you're walking into

## 1.1 The exam

**2 hours · 13 tasks · 180 points.**

Groups A and B are **structurally identical** — the same thirteen tasks in the same order with the
same point split. Only the numbers change. That is as close to seeing the paper in advance as you
can get, and it's what this guide is built around.

**Aids:** both papers print **"No aids allowed"** on the cover. Assume nothing is permitted in the
room, and treat every sheet you have as revision material rather than something you'll carry in.

**Your lab sheets:** useful background, but they don't match this paper well. Topics they drill hard
(Floyd–Warshall stopped part-way, repairing loop invariants, drawing planar graphs from a matrix)
don't appear at all. Topics the exam weights heavily (Kruskal, gradient descent, sorting traces)
barely feature in them. **Where the labs and the exam papers disagree, follow the papers.**

## 1.2 The point map

| # | Task | Pts | What it actually asks |
|---|---|---|---|
| 1 | Asymptotic notation | 10 | Simplify 3 Θ expressions + give the complexity of a code fragment |
| 2 | Recurrences | 15 | (a) write T(n) from pseudocode; (b),(c) two Master theorem problems |
| 3 | Sorting | 15 | (a) pick a sort + justify; (b) trace MergeSort or QuickSort; (c) the Ω(n log n) argument |
| 4 | DP: stair climbing | 15 | Base cases, why the recurrence holds, fill the table, answer, complexity |
| 5 | Graphs | 20 | Dijkstra step table, shortest path, complexity, BFS comparison |
| 6 | Heaps & BSTs | 15 | Find the heap violation + fix; insert into a BST; check AVL |
| 7 | MST — Kruskal | 20 | Sort edges, add/reject table, draw MST, total weight, complexity |
| 8 | P and NP | 15 | Define the classes, classify 5 problems, tick correct statements |
| 9 | Data structures | 15 | Three scenarios, choose from a list of eight |
| 10 | Hash tables | 10 | Insert with chaining, worst case, hash vs AVL table |
| 11 | Algorithm structure | 15 | Fill 5 blanks in pseudocode + order 7 scrambled steps |
| 12 | Gradient descent | 15 | Update rule, learning rate, convexity, two numeric steps |
| 13 | Algorithm design | 10 | Fill 5 blanks in a skeleton, complexity, run it on an example |

**Tasks 5, 7, 10, 11 and 12 are 80 points** and need accurate execution rather than insight.
Add task 4 (15 more) and you have 95 of 180 from procedures alone.

**Order to attempt:** 12 → 10 → 7 → 5 → 4 → 11 → 1 → 2 → 6 → 3 → 9 → 8 → 13.
Gradient descent first: it's 15 points of pure recall and takes about five minutes.

---

# Part 2 — The vocabulary

Read this once, slowly. Everything later depends on it.

**Algorithm.** A recipe — a finite list of steps turning an input into a correct output.

**n.** The size of the input. A list of 1000 numbers means n = 1000. Everything is expressed in n.

**Running time.** Not seconds — the *number of basic steps*, as a function of n. What matters is how
that number **grows** as n gets bigger, because that determines whether the program still works when
the data gets large.

**Why constants are ignored.** An algorithm taking 5n steps and one taking 100n steps are both
linear: double the input, double the work. One taking n² steps is different in kind — double the
input, *quadruple* the work. That difference matters; 5-versus-100 doesn't.

**Θ, O, Ω.** Three ways to say roughly how fast something grows.
- **O(g)** — grows *no faster than* g. An upper bound, a ceiling.
- **Ω(g)** — grows *at least as fast as* g. A lower bound, a floor.
- **Θ(g)** — both at once, so it grows *exactly like* g. This is usually the one you want.

**The growth ladder.** Memorise the order:

```
1  <  log n  <  (log n)^k  <  √n  <  n  <  n log n  <  n²  <  n³  <  2ⁿ  <  3ⁿ  <  n!
```

For n = 1,000,000: log n ≈ 20, √n = 1000, n = a million, n² = a trillion, and 2ⁿ has 300,000 digits.
That's why the ladder matters.

**log n.** "How many times can I halve n before reaching 1?" For n = 8 that's 3 (8→4→2→1), so
log₂8 = 3. It appears whenever an algorithm repeatedly halves something, which is why it grows so
slowly. In this course `log` means log₂ unless stated otherwise.

**Recursion.** A function that calls itself on a smaller version of the problem until the problem is
small enough to answer outright.

**Recurrence.** An equation describing a recursive algorithm's running time in terms of itself.
`T(n) = 2T(n/2) + Θ(n)` reads: "to handle n items I make **2** recursive calls each on **half** the
data, plus **n** units of other work."

**Data structure.** A way of organising data in memory. Different arrangements make different
operations fast — that's the whole subject of tasks 6, 9 and 10.

**Graph.** Dots joined by lines. Dots are **vertices**, lines are **edges**. Edges may carry
**weights** (a cost, distance or time). A **directed** graph's edges only work one way: an edge 1→2
cannot be walked from 2 to 1.

**Tree.** A graph with no loops, drawn hanging from a single top node.
- **root** — the top node · **child / parent** — directly below / above · **leaf** — no children
- **subtree of v** — v plus everything below it

## ⚠ The height definition — read this before task 6

**The exam prints the convention inside the question, and you must use the one it prints.**

The 2026 papers say **"height of a leaf = 0"**, and Group B adds **"height of empty subtree = −1"**.
That is edge-counting: height = the number of *edges* on the longest downward path.

Your lab sheets use node-counting, where a leaf has height 1 — every answer comes out one larger.

Task 6(c) states the convention explicitly on both papers. **Read that line before writing any
numbers.** If nothing is stated, say which convention you're using and stay consistent.

Under the exam's convention: **h(v) = 1 + max(h(left), h(right))**, with a missing child counting as
−1, so a leaf works out to 1 + max(−1, −1) = 0.

---

# Part 3 — The thirteen tasks

The tasks below are in the order I'd attempt them, not paper order. Each has the task number.

---

## Task 12 — Gradient descent (15 pts)

### What this is about

In machine learning you have a model with parameters (call them θ) and a **loss function** L(θ) that
measures how wrong the model currently is. Training means finding the θ that makes L as small as
possible. Gradient descent is the standard way to do that: start somewhere, and repeatedly take a
small step "downhill".

The **gradient** ∇L(θ) is the collection of partial derivatives. It points in the direction in which
the loss **increases** fastest.

### (a) The update rule — write it with every symbol defined

> **θ_{t+1} = θ_t − η · ∇L(θ_t)**

- **θ_t** — the current parameters
- **η > 0** — the **learning rate**, how big a step you take
- **∇L(θ_t)** — the gradient of the loss at the current parameters

**Why the minus sign.** The gradient points toward steepest *increase*. We want to *decrease* the
loss, so we step in the opposite direction. For a small enough η this is guaranteed to reduce the
loss locally.

Marks are given for defining the symbols, so define them.

### (b) The learning rate

- **Too small** — training crawls; you need very many iterations to get anywhere.
- **Too large** — the step overshoots the minimum, so the loss oscillates or diverges.

### (c) Convexity

A function is **convex** if its graph lies at or below the chord joining any two of its points.
Equivalently, and this is the phrasing that earns the mark: **it has no local minimum other than the
global one.**

- On a **convex** landscape (a single smooth bowl), gradient descent **always** reaches the global
  minimum, from any starting point, because every local minimum *is* the global one.
- On a **non-convex** landscape (two or more dips), it can get stuck in a local minimum.

The question shows two pictures and asks which is convex and where GD is guaranteed to succeed. It's
the smooth single-bowl one, for the reason above.

### (d) The numeric part

Both papers use a quadratic loss **L(w) = (w − a)²**, so **∇L(w) = 2(w − a)** and each step is

> **w ← w − η · 2(w − a)**

Rearranged, the distance to a is multiplied by **(1 − 2η)** at every step. That single fact explains
every behaviour they can ask about.

**Group A:** L(w) = (w − 3)², η = 0.5, w₀ = 0.
- w₁ = 0 − 0.5·2(0 − 3) = 0 + 3 = **3**
- w₂ = 3 − 0.5·2(3 − 3) = **3**
- The minimum is at w* = 3, and GD **lands exactly, in one step** — with η = 0.5 the factor
  (1 − 2η) is 0.

**Group B:** L(w) = (w − 5)², η = 0.25, w₀ = 1.
- w₁ = 1 − 0.25·2(1 − 5) = 1 + 2 = **3**
- w₂ = 3 − 0.25·2(3 − 5) = 3 + 1 = **4**
- The minimum is at w* = 5. GD **converges but never quite arrives** — the factor is (1 − 0.5) = 0.5,
  so the gap halves each step: 4 → 2 → 1 → … Convergence is geometric and asymptotic.

**If they change η:** η = 0.5 lands exactly · η < 0.5 approaches gradually · η > 1 diverges.

### Extra facts worth a sentence

**Batch** gradient descent uses all n training examples per step — stable but expensive.
**SGD** (stochastic) uses a single example — cheap but noisy. **Mini-batch** uses a small group and is
what's used in practice. **Backpropagation** is just the chain rule applied layer by layer to compute
the gradient in a neural network.

---

## Task 10 — Hash tables (10 pts)

### What a hash table is

A **dictionary** stores key–value pairs and answers "what's stored under key k?". A hash table does
this by running the key through a **hash function** — usually **h(k) = k mod p**, where p is the
table size — and storing the entry at that position.

Two keys can hash to the same slot. That's a **collision**, and this course resolves them by
**separate chaining**: each slot holds a list, and colliding entries are appended to it.

### (a) Insert with chaining

Compute each key mod the table size and append it to that slot's list, **in insertion order**.
**Draw every slot, including the empty ones** — the completed table is the answer.

**Group A:** keys 5, 12, 8, 3, 15, 10 into a table of size 7.
5 mod 7 = 5 · 12 mod 7 = 5 · 8 mod 7 = 1 · 3 mod 7 = 3 · 15 mod 7 = 1 · 10 mod 7 = 3

| Slot | Chain |
|---|---|
| 0 | (empty) |
| 1 | 8 → 15 |
| 2 | (empty) |
| 3 | 3 → 10 |
| 4 | (empty) |
| 5 | 5 → 12 |
| 6 | (empty) |

**Group B:** keys 6, 13, 2, 9, 20, 4 into a table of size 7.
6 mod 7 = 6 · 13 mod 7 = 6 · 2 mod 7 = 2 · 9 mod 7 = 2 · 20 mod 7 = 6 · 4 mod 7 = 4
→ slot 2: 2 → 9 · slot 4: 4 · slot 6: 6 → 13 → 20 · everything else empty.

### (b) The worst case

**Θ(n)** — when all n keys land in the same slot, giving one chain of length n that you must scan
end to end. It happens with input crafted against the hash function, or when every key happens to be
congruent modulo the table size.

This is the fact that decides task 9 questions: a hash table is fast *on average* but has **no
worst-case guarantee**.

### (c) Hash table versus AVL tree

| Operation | Hash table | AVL tree |
|---|---|---|
| Search | O(1) expected | O(log n) |
| Insert | O(1) amortised | O(log n) |
| Delete | O(1) expected | O(log n) |
| Sorted output of all keys | O(n log n) — must sort first | **O(n)** — in-order traversal |

**Hash table's advantage:** O(1) average operations, so it's faster for plain insert/search/delete.
**AVL's advantage:** **O(log n) worst case** for everything, and it can produce **sorted output**
in O(n) by walking the tree in order — something a hash table simply cannot do.

---

## Task 7 — Minimum spanning tree, Kruskal (20 pts)

### What the problem is

Given a connected weighted graph, a **spanning tree** is a subset of edges that connects every vertex
with no cycles. A **minimum spanning tree** is the one with the smallest total weight. Think: the
cheapest set of cables connecting every building.

### The algorithm

**Repeatedly take the cheapest remaining edge that doesn't create a cycle**, until you've added
n − 1 edges.

The cycle test uses **find–union** (also called disjoint-set union), a structure that tracks which
vertices are currently in the same connected group and can merge two groups. An edge is **rejected
exactly when both of its endpoints are already in the same group** — adding it would close a loop.

### (a) Sort the edges — 3 pts
List every edge with its weight, in non-decreasing order. Ties can go either way; pick one and stay
consistent.

### (b) The add/reject table — 10 pts, the bulk of the marks

For each edge in sorted order, write **Add** or **Reject**, and the **components after that step**.

**Group A** — edges 3-4(1), 1-3(2), 2-3(3), 5-6(3), 3-5(4), 2-4(5), 1-2(6):

| Step | Edge | Action | Components after |
|---|---|---|---|
| 1 | 3-4 (1) | Add | {1}, {2}, {3,4}, {5}, {6} |
| 2 | 1-3 (2) | Add | {1,3,4}, {2}, {5}, {6} |
| 3 | 2-3 (3) | Add | {1,2,3,4}, {5}, {6} |
| 4 | 5-6 (3) | Add | {1,2,3,4}, {5,6} |
| 5 | 3-5 (4) | Add | {1,2,3,4,5,6} — MST complete |
| 6 | 2-4 (5) | **Reject** | 2 and 4 already connected |
| 7 | 1-2 (6) | **Reject** | 1 and 2 already connected |

**Group B** — edges 3-5(1), 2-3(2), 5-6(2), 1-2(3), 2-4(4), 1-3(5), 4-6(6):
Add, Add, Add, Add, Add, **Reject**, **Reject**.

### Two checks that catch nearly every mistake
1. You must add **exactly n − 1 edges** — five for six vertices.
2. Once every vertex is in one component, **every remaining edge is rejected**, no exceptions.

### (c),(d) Draw the MST and give its weight — 5 pts
Just the added edges. Group A total = 1+2+3+3+4 = **13**. Group B = 1+2+2+3+4 = **12**.

### (e) Complexity — 2 pts
**Θ(m log m)**, dominated by sorting the m edges. The find–union operations are near-constant,
Θ(α(n)) amortised, where α is the inverse Ackermann function.

---

## Task 5 — Graphs: Dijkstra and BFS (20 pts)

### What the problem is

You have a map: places (vertices) joined by roads (edges), each road with a cost. From a start
vertex, find the **cheapest** route to every other vertex.

⚠ **Cheapest is not shortest.** "Shortest" means fewest edges. "Cheapest" means lowest total weight.
Three cheap roads can beat one expensive one. BFS finds shortest; Dijkstra finds cheapest.

⚠ **The 2026 graphs are directed.** Relax only the **outgoing** edges of the vertex you extracted.

### How Dijkstra works

Every vertex carries a label: the best cost found so far. Start with d[s] = 0 and everything else ∞.

Then repeat: **take the unvisited vertex with the smallest label and declare it final.** For each of
its outgoing edges, ask whether going through this vertex is cheaper than the neighbour's current
label — if so, overwrite the label **and** record the parent.

**Why you may declare it final:** every other unvisited vertex already costs at least as much to
reach, and all weights are non-negative, so no detour through them could come back cheaper. That is
also exactly **why Dijkstra requires non-negative weights** — a negative edge would break the
argument.

### (a) The step table — 8 pts

They want one row per extraction: which vertex came out, and the full distance array afterwards.

**Group A** — edges 1→2(4), 1→3(2), 2→3(1), 2→4(5), 3→2(1), 3→4(8), 3→5(10), 4→5(2), 4→6(3), 5→6(1):

| Step | Extracted | d[1] | d[2] | d[3] | d[4] | d[5] | d[6] |
|---|---|---|---|---|---|---|---|
| 0 | — | 0 | ∞ | ∞ | ∞ | ∞ | ∞ |
| 1 | 1 (0) | 0 | 4 | 2 | ∞ | ∞ | ∞ |
| 2 | 3 (2) | 0 | **3** | 2 | 10 | 12 | ∞ |
| 3 | 2 (3) | 0 | 3 | 2 | **8** | 12 | ∞ |
| 4 | 4 (8) | 0 | 3 | 2 | 8 | **10** | 11 |
| 5 | 5 (10) | 0 | 3 | 2 | 8 | 10 | 11 *(10+1 = 11, no change)* |
| 6 | 6 (11) | 0 | 3 | 2 | 8 | 10 | 11 |

**Group B** — edges 1→2(6), 1→3(3), 2→4(2), 3→2(2), 3→4(9), 4→5(3), 4→6(4), 5→6(2):

| Step | Extracted | d[1] | d[2] | d[3] | d[4] | d[5] | d[6] |
|---|---|---|---|---|---|---|---|
| 1 | 1 (0) | 0 | 6 | 3 | ∞ | ∞ | ∞ |
| 2 | 3 (3) | 0 | **5** | 3 | 12 | ∞ | ∞ |
| 3 | 2 (5) | 0 | 5 | 3 | **7** | ∞ | ∞ |
| 4 | 4 (7) | 0 | 5 | 3 | 7 | 10 | 11 |
| 5 | 5 (10) | 0 | 5 | 3 | 7 | 10 | 11 *(no change)* |
| 6 | 6 (11) | — | — | — | — | — | — |

**What the question is really testing:** **extraction order is not the order vertices were first
reached.** In both papers vertex 2 is reached immediately from vertex 1, but vertex 3 has a smaller
label, so 3 comes out first — and going 1→3→2 then beats the direct edge 1→2.

### The check that saves 8 points
For every vertex w: **dist[w] = dist[parent[w]] + cost of the edge from parent[w] to w.**
Thirty seconds, catches every arithmetic slip.

### (b) The shortest path — 5 pts
Follow the parents back from the target and reverse.
Group A: **1 → 3 → 2 → 4 → 6**, total 2+1+5+3 = **11**.
Group B: **1 → 3 → 2 → 4 → 6**, total 3+2+2+4 = **11**.

### (c) Complexity — 4 pts
**Θ((n + m) log n)** with a binary heap, where n = vertices, m = edges.

### (d) BFS comparison — 3 pts

**BFS** explores level by level using a **queue**, counting **hops** and ignoring weights entirely.
Give the hop distances, then one disagreement.

Group A BFS from vertex 1: d = **0, 1, 1, 2, 2, 3** for vertices 1–6.
Group B BFS from vertex 1: d = **0, 1, 1, 2, 3, 3**.

**The disagreement (both papers):** BFS gives d[2] = 1, because 1→2 is a single hop. Dijkstra gives
3 (Group A) or 5 (Group B), because the cheap detour 1→3→2 costs less than the heavy direct edge.
**BFS treats every edge as weight 1, so it is only correct on unweighted graphs.**

---

## Task 4 — Dynamic programming: stair climbing (15 pts)

### What the problem is

A staircase with n steps. Each move climbs one of a fixed set of sizes. How many distinct ways are
there to reach step n, starting from step 0?

### The recurrence

With allowed move sizes s₁ and s₂:

> **dp[n] = dp[n − s₁] + dp[n − s₂]**

**Why it holds — write this out, it carries marks.** The *last* move that brought you to step n was
either a step of size s₁ (and there were dp[n − s₁] ways to have reached that point) or of size s₂
(dp[n − s₂] ways). The two cases are **disjoint and exhaustive**, so you add them.

### The base cases — the part people get wrong

**dp[0] = 1**, not 0. There is exactly one way to be at the start: don't move. Then fill in the small
values by hand wherever a larger step is impossible.

**Group A — moves of 1 or 2.** dp[0] = 1 (stand still), dp[1] = 1 (one single step). Then
dp[n] = dp[n−1] + dp[n−2] — this is Fibonacci.

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|---|
| dp | 1 | 1 | 2 | 3 | 5 | 8 | 13 | 21 | **34** |

**Group B — moves of 1 or 3.** dp[0] = 1, dp[1] = 1, and **dp[2] = 1** because a 3-step is impossible
at that point, so the only route is 1+1. Then dp[n] = dp[n−1] + dp[n−3].

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|
| dp | 1 | 1 | 1 | 2 | 3 | 4 | 6 | **9** |

Check: dp[3] = dp[2]+dp[0] = 2 · dp[4] = dp[3]+dp[1] = 3 · dp[5] = 3+1 = 4 · dp[6] = 4+2 = 6 ·
dp[7] = 6+3 = 9 ✓

### Complexity
**Θ(n)** — each entry is computed exactly once in a single left-to-right pass. Space can be reduced
to **Θ(1)** by keeping only the last few values, since dp[n] depends only on those.

### If the step sizes change
**Redo the base cases from scratch** — that's where the trap is. For moves of 1 or 4:
dp[0] = dp[1] = dp[2] = dp[3] = 1, then dp[n] = dp[n−1] + dp[n−4].

---

## Task 11 — Algorithm structure (15 pts)

Two halves, both pure memorisation. Learn these two skeletons cold.

### (a) Fill five blanks in a pseudocode — 7 pts

**BFS** (asked in Group A):
```
dist[s] = 0                                  ← (a) 0
parent[s] = NONE
q = new Queue
q.add(s)
while q not empty do
    v = q.extractOldest()
    for every edge (v, w) do
        if dist[w] not yet computed then     ← (b)
            dist[w] = dist[v] + 1            ← (c)
            parent[w] = v                    ← (d)
            q.add(w)                         ← (e) w
```

**Dijkstra** (asked in Group B):
```
dist[s] = 0                                  ← (a) 0
dist[u] = ∞ for all u ≠ s
q = new PriorityQueue
q.add(s, 0)
while q not empty do
    v = q.extractMin()
    for every edge (v, w, c_vw) do
        if dist[w] > dist[v] + c_vw then     ← (b)
            dist[w] = dist[v] + c_vw         ← (c)
            parent[w] = v                    ← (d)
            q.add(w, dist[w])                ← (e)
```

**The pattern is identical:** the condition compares, the body assigns, then you push the neighbour.
BFS adds **1** and tests "have I seen this yet"; Dijkstra adds the **edge weight** and tests "can I
do better than the current label".

### (b) Put seven scrambled steps in order — 8 pts

The logic is always: **initialise → build the structure → set up the source → the loop line →
extract → process → return.**

**Kruskal** (Group A): initialise an empty MST (1) → sort all edges by weight (2) → initialise
find–union with n singletons (3) → for each edge in sorted order (4) → if Find(u) ≠ Find(v), add the
edge and Union (5) → otherwise discard it (6) → return the MST (7).

**BFS** (Group B): set dist = ∞ for all vertices (1) → create an empty queue (2) → set dist[s] = 0,
parent[s] = NONE and add s (3) → repeat until the queue is empty (4) → extract the oldest vertex (5)
→ process its neighbours (6) → return dist and parent (7).

⚠ **The loop or "repeat until" line comes *before* the body lines it encloses.** In the BFS ordering,
"repeat until empty" is step 4 while "extract" and "process neighbours" are 5 and 6. Getting that
nesting right is the only real difficulty in an otherwise free 8 points.

---

## Task 1 — Asymptotic notation (10 pts)

Three expressions to simplify (2+2+3 pts) plus one code fragment (3 pts).

### Simplifying

Three steps: **kill constant factors → convert each term into a clean shape → keep only the
fastest-growing term.**

| When you see      | Write                           | Why                                     |
| ----------------- | ------------------------------- | --------------------------------------- |
| log(n^k)          | k·log n → **Θ(log n)**          | the exponent comes out front            |
| log(c·n)          | log c + log n → **Θ(log n)**    | log of a product is a sum               |
| (√2)^{log n}      | 2^{(log n)/2} = **√n**          | since 2^{log n} = n, halve the exponent |
| √n·log n + √n     | √n(log n + 1) = **Θ(√n log n)** | factor out                              |
| n^a · n^b         | n^{a+b}                         | exponents add                           |
| n! against 3ⁿ     | **n! wins**                     | factorial beats any exponential         |
| 2ⁿ against n^1000 | **2ⁿ wins**                     | exponential beats any polynomial        |
| a huge constant   | Θ(1)                            | it doesn't grow with n                  |

**Log bases don't matter** inside Θ — Θ(log₅n) = Θ(log₂n), because changing base multiplies by a
constant. **Exponential bases absolutely do** — 3ⁿ is nothing like 2ⁿ.

**Worked from the papers:**
Θ(5n³ + 100n² + log n) = **Θ(n³)** · Θ(n log n⁴ + n²/1000) = **Θ(n²)** *(log n⁴ = 4 log n, so the
first term is only Θ(n log n))* · Θ(2ⁿ + n¹⁰⁰⁰) = **Θ(2ⁿ)** · Θ(4n² + 200n + log²n) = **Θ(n²)** ·
Θ(√n·log n + √n) = **Θ(√n log n)** · Θ(n! + 3ⁿ) = **Θ(n!)** ·
Θ(10 log₁₀n + √n/100 + (√2)^{log n}·log n) = **Θ(√n log n)** · Θ(4n + log n + 1) = **Θ(n)** ·
Θ(3n log n³ + 100n) = **Θ(n log n)**

### The code fragment — five patterns to recognise

| Pattern | Cost | Why |
|---|---|---|
| `for x = 1 to n` with an inner loop of **constant** length (e.g. `for y = x−10 to x+10`) | **Θ(n)** | the inner loop runs exactly 21 times |
| `for i = 1 to n` then `for j = i to n` (**triangular**) | **Θ(n²)** | Σ(n − i + 1) = n(n+1)/2 |
| `for x = 1 to 10n` then `while y ≥ x` counting down from 10n | **Θ(n²)** | the same triangular sum |
| `for i = 1 to n` then `while j ≤ n: j = j·2` (**doubling**) | **Θ(n log n)** | doubling gives ⌊log₂n⌋+1 iterations |
| three nested loops where the innermost is `for k = 1 to 10` | **Θ(n²)** | the constant loop contributes nothing |

**The two summation rules:**
1 + 2 + … + n = n(n+1)/2 = **Θ(n²)** · 1 + 2 + 4 + … + 2ⁿ = 2^{n+1} − 1 = **Θ(2ⁿ)**

**The tell for a logarithm:** the loop variable is **multiplied or divided**, not incremented.

---

## Task 2 — Recurrences (15 pts)

### (a) Write T(n) from pseudocode — 5 pts

Read off three things and assemble **T(n) = a·T(n/b) + Θ(n^d)**:
- **a** = the total number of recursive calls, summed over *all* the loops that make them
- **b** = from the subproblem size, usually written `⌊n/b⌋`
- **Θ(n^d)** = the non-recursive work, usually the final loop's bound

**Counting calls exactly is the whole difficulty:**

| Loop | Calls |
|---|---|
| `while i > n − 4`, starting at `i = n`, decrementing | i = n, n−1, n−2, n−3 → **4** (a constant) |
| `while i ≤ n − 3`, starting at `i = 1`, incrementing | i = 1 … n−3 → **n − 3** (depends on n!) |
| `for j = 1 to 12` | **12** |
| final `for k = 1 to n^d` | contributes **Θ(n^d)** of work |

**Group B:** 4 (while) + 12 (for) = **16** calls on ⌊n/15⌋, plus a `for k = 1 to n⁸` loop.
→ **T(n) = 16·T(⌊n/15⌋) + Θ(n⁸)**

**Group A — the trap:** (n − 3) (while) + 9 (for) = **n + 6** calls on ⌊n/6⌋, plus Θ(n⁵).
→ **T(n) = (n + 6)·T(n/6) + Θ(n⁵)**
⚠ **The branching factor depends on n, so the Master theorem does not apply.** Say so explicitly —
that's the point of the question. The Master theorem needs a **constant** a.

### (b), (c) Master theorem — 5 pts each

For **T(n) = a·T(n/b) + Θ(n^d)**, compute **c = log_b a**, then:

| Condition | Case | Result |
|---|---|---|
| d < c | **A** | Θ(n^c) |
| d = c | **B** | Θ(n^c log n) |
| d > c | **C** | Θ(n^d) |

The intuition: c measures the work the recursion generates, d measures the work done outside it.
Whichever is bigger wins; if they tie you get an extra log n.

**c is the power of b that gives a.** Powers of 2: 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024 for
k = 1…10. Powers of 3: 3, 9, 27, 81.

**Write all six things** — a, b, f(n), c, the case letter, the result — because the question says
"show which case applies and explain".

| Seen in the papers | a, b | c | Case | Result |
|---|---|---|---|---|
| 8T(n/2) + Θ(n²) | 8, 2 | 3 | A | Θ(n³) |
| 4T(n/2) + Θ(n²) | 4, 2 | 2 | B | Θ(n² log n) |
| 27T(n/3) + Θ(n²) | 27, 3 | 3 | A | Θ(n³) |
| 2T(n/2) + Θ(n) | 2, 2 | 1 | B | Θ(n log n) |
| 4T(⌈n/2⌉) + Θ(n²) *(practice exam)* | 4, 2 | 2 | B | Θ(n² log n) |

Floors and ceilings make no difference. And the Master theorem **never applies to T(n − 1)** — that's
subtraction, not division; unroll such recurrences by hand instead.

---

## Task 6 — Heaps, BSTs and AVL trees (15 pts)

### (a) Heaps — 5 pts

A **heap** stores numbers in a complete binary tree so the largest is always on top. The rule — the
**heap invariant** — is: **every parent is ≥ both of its children.** Equal values are fine. Nothing
is said about left versus right; siblings may be in any order.

Stored as an array with 1-based indexing: **children of i are 2i and 2i+1**, and the **parent of i is
⌊i/2⌋**. For a 12-element array, indices 1–6 have children and **7–12 are leaves**.

**What they ask:** find the one index where the property is violated, then fix it by changing exactly
one value.

The answer index is the **child**, since the child is the one that's too big. The 2026 wording is
forgiving: the fix is **any value ≤ the parent**. In both papers the violating node is at index 12,
which is a leaf, so there's no lower bound at all.

⚠ **But if the violating node has children**, your new value must also stay **≥ both of them**, or
you create a new violation below.

Group A: A[12] = 75 > A[6] = 70 → index **12**, set it to anything ≤ 70 (e.g. 65).
Group B: A[12] = 28 > A[6] = 20 → index **12**, set it to anything ≤ 20 (e.g. 18).

### (b) BST insertion — 5 pts

A **binary search tree** stores keys so that, for every node, **everything in the left subtree is
smaller and everything in the right subtree is larger** — all the way down, not just the immediate
children. That's what makes lookup fast: each comparison discards half the tree.

To insert, do what a search does: from the root, go left if your key is smaller and right if larger,
and drop the new node at the first empty spot.

**Never restructure the tree**, and a key already present changes nothing.

**Group A:** root 15, insert 9, 22, 6, 12, 18, 25 → 9 left of 15; 22 right of 15; 6 left of 9;
12 right of 9; 18 left of 22; 25 right of 22. A perfectly balanced tree.

**Group B:** root 10, insert 5, 15, 3, 8, 12, 2 → 5 left of 10; 15 right of 10; 3 left of 5;
8 right of 5; 12 left of 15; 2 left of 3.

**Check: an in-order traversal must come out sorted.** Ten seconds, catches everything.

### (c) The AVL check — 5 pts

A plain BST can degenerate. Insert 1, 2, 3, 4, 5 in order and you get a straight line downward, so
every search walks the whole thing. An **AVL tree** prevents this with a balance rule:

> **At every node, |h(left) − h(right)| ≤ 1.**

Enforce that everywhere and the tree can never be much more than log n tall, so all operations stay
Θ(log n) in the worst case.

**Procedure:** write the height beside every node, working bottom-up, then check each node's two
children. ⚠ **Use the convention printed on the paper** (2026: leaf = 0, empty subtree = −1).

Group A: h(6) = h(12) = h(18) = h(25) = 0, h(9) = h(22) = 1, h(15) = 2. Balance factors all 0 →
**yes, AVL**.
Group B: h(2) = 0, h(3) = 1, h(8) = 0, h(5) = 2, h(12) = 0, h(15) = 1, h(10) = 3. Balance factors
1, 1, 1, 1 → all ≤ 1 → **yes, AVL**.

Both papers answer "yes" — don't let that make you careless. Check every node, and if one fails,
name it.

---

## Task 3 — Sorting (15 pts)

### (a) Choose a sorting algorithm — 5 pts

The scenario is always **many elements whose values lie in a bounded range**, and the answer is
**counting sort** (radix sort is also accepted).

**Counting sort** works by counting how many times each value occurs, prefix-summing the counts, and
placing each element straight into its final position. It never compares two elements. Running time
**Θ(n + k)** where k is the size of the value range.

Group A: 10⁶ integers with 1 ≤ A[i] ≤ n → a counting array of size n → Θ(n + n) = **Θ(n)**.
Group B: 10⁶ integers in [0, 999] → k = 1000 is a constant relative to n → **Θ(n)**.

**Always add the punchline:** this **beats any comparison-based sort, which requires Ω(n log n)** —
and it can, precisely because it doesn't compare elements.

### (b) Trace a sort — 5 pts

**MergeSort** halves the array until singletons, then merges sorted halves back up. Show **both
phases** — that's where the marks are.

Group A, on ⟨5, 2, 8, 3, 9, 1, 7, 4⟩:
```
split   L0: 5 2 8 3 9 1 7 4
        L1: 5 2 8 3 | 9 1 7 4
        L2: 5 2 | 8 3 | 9 1 | 7 4
        L3: 5 | 2 | 8 | 3 | 9 | 1 | 7 | 4
merge   L2: 2 5 | 3 8 | 1 9 | 4 7
        L1: 2 3 5 8 | 1 4 7 9
        L0: 1 2 3 4 5 7 8 9
```

**QuickSort** picks a pivot, partitions so that everything ≤ the pivot is on its left and everything
greater on its right, leaving the pivot in its **final** position, then recurses on each side.

Group B, on ⟨3, 1, 4, 1, 5, 9, 2, 6⟩ with the **last element as pivot**:
pivot 6 → ⟨3, 1, 4, 1, 5, 2 | 6 | 9⟩. Then the left side with pivot 2 → ⟨1, 1 | 2 | 3, 5, 4⟩; the
right side ⟨9⟩ is a single element and already sorted.
*(The exact left-to-right arrangement within each side depends on which partition scheme you use.
State your scheme; what must be right is that the pivot is in its final position with the correct
split around it.)*

### (c) The lower-bound argument — 5 pts

Learn this as a paragraph and write it out:

> Any comparison-based sorting algorithm can be represented as a **decision tree**: each internal
> node is a comparison, each leaf a distinct permutation of the input. To sort every input correctly,
> all **n!** permutations must be reachable, so the tree has at least n! leaves. A binary tree with
> n! leaves has height at least **log₂(n!) = Θ(n log n)** (by Stirling's approximation). Therefore
> every comparison-based algorithm needs **Ω(n log n)** comparisons in the worst case — and MergeSort
> achieves this bound, so MergeSort is optimal.

**Variants:** "can we sort with O(n log log n) comparisons?" → **No.** "With O(n·α(n))?" → **No.**
Both are o(n log n), below the bound. The answer is always no for anything below n log n — and always
say **"comparison-based"**, because counting sort is exactly the exception.

### Reference table

| | Worst case | Extra space | Stable |
|---|---|---|---|
| Insertion | n² (n if already sorted) | 1 | Yes |
| Merge | n log n | n | Yes |
| Quick | **n²** (average n log n) | log n | No |
| Heap | n log n | 1 | No |
| Counting | n + k | n + k | Yes |
| Radix | d(n + k) | n + k | Yes |

**Stable** means equal keys keep their original relative order. Radix sort goes **least significant
digit first** and depends entirely on the inner sort being stable.

---

## Task 9 — Choosing a data structure (15 pts)

Three scenarios, 5 points each, chosen from: unsorted array, sorted array, hash table,
max-heap/priority queue, BST (unbalanced), AVL tree, find–union, queue.

### What each one is

- **Unsorted array** — items just dumped in. Adding is O(1) amortised; finding means scanning.
- **Sorted array** — kept in order, so binary search in O(log n). But insertion shifts everything,
  so it's for data that doesn't change.
- **Hash table** — a function maps keys to positions. **O(1) average, Θ(n) worst case.**
- **BST (unbalanced)** — ordered tree, but **degrades to Θ(n)** on sorted input.
- **AVL tree** — a self-balancing BST. **O(log n) worst case** for everything, and in-order traversal
  gives **sorted output in O(n)**.
- **Max-heap / priority queue** — always hands you the highest-priority item. Insert and extract-max
  are O(log n). **You cannot look up an arbitrary key in it.**
- **Find–union** — tracks which items are in the same group and merges groups, both in Θ(α(n))
  amortised. Dynamic connectivity only.
- **Queue** — first in, first out. O(1) enqueue and dequeue.

### Decision key

| The scenario says | Answer |
|---|---|
| "retrieve the highest priority", triage, scheduling | **Max-heap / priority queue** |
| "are A and B in the same group?", merging groups | **Find–union** |
| worst-case O(log n) **and** sorted output | **AVL tree** |
| O(1) **average**, ordering never needed | **Hash table** |
| strict first-in-first-out, only enqueue and dequeue | **Queue** |
| static data, binary search, minimal memory | **Sorted array** |
| only ever add, never search | **Unsorted array** |

**The sharpest distinction:** if the scenario says **"worst case"**, the hash table is wrong (Θ(n)
worst). If it says "on average" and never mentions ordering, the hash table is right.

### Scenarios already used — these recur

- **Emergency room, retrieve the highest-priority patient in O(log n)** → **max-heap.** extractMax
  and insert both O(log n), space Θ(n). No sorted output or key search needed, so AVL or hash would be
  overkill.
- **Social network friend groups, "are these two users in the same group?"** → **find–union.** Union
  and Find in Θ(α(n)) amortised, space Θ(n). Purpose-built for dynamic connectivity.
- **Merging bacteria on a petri dish** *(practice exam)* → **find–union**, same reasoning.
- **Leaderboard or airline bookings: O(log n) insert, delete and search, plus sorted output in O(n)**
  → **AVL tree.** An unbalanced BST degrades to O(n); a hash table can't produce sorted output.
- **Compiler symbol table: O(1) average insert and lookup, no ordering ever needed** → **hash table.**
- **Web server processing requests strictly in arrival order** → **queue.**

### The answer format — four parts, all worth marks
1. **Name** the structure.
2. **Map it** onto the scenario in a sentence.
3. Give its **time and space complexity** for the required operations.
4. **Say why every other option loses here** — grouped, not one by one: "these can't do the required
   operation at all; those are slower in the worst case; that one can't give sorted output."

Part 4 is where most of the marks are and it's the part people skip.

---

## Task 8 — P and NP (15 pts)

### (a) Definitions — 5 pts. Write these almost verbatim.

A **decision problem** is one whose answer is just YES or NO.

- **P** — the class of decision problems solvable by a deterministic algorithm in **polynomial time**.
- **NP** — the class of decision problems for which a proposed solution (a **certificate**) can be
  **verified** in polynomial time by a deterministic algorithm.
- **NP-complete** — a problem X such that (1) **X ∈ NP**, and (2) **every problem in NP reduces to X
  in polynomial time** (that second condition alone makes X NP-hard). These are the hardest problems
  in NP.

**"A reduces to B"** means: if you could solve B quickly, you could solve A quickly, by translating
A's inputs into B's. It's how hardness gets transferred between problems.

### (b) Classify five problems — 6 pts

**In P** — name the algorithm in each case:
sorting (merge sort, O(n log n)) · shortest path with non-negative weights (Dijkstra) · minimum
spanning tree (Kruskal or Prim) · binary search (O(log n)) · **checking whether a graph is bipartite
/ 2-colourable** (BFS, O(n+m)) · connectivity (BFS).

**NP-complete:**
Hamiltonian cycle · **SAT** — the first problem proved NP-complete, Cook–Levin 1971 · knapsack
(decision version) · independent set · vertex cover · **3-colouring** · travelling salesman.

⚠ The exam relies on near-misses: **2-colouring is in P but 3-colouring is NP-complete**, and
**shortest path is in P but Hamiltonian path is NP-complete**. One word changes the answer.

### (c) Tick the correct statements — 4 pts

**True:**
- If a problem X is NP-complete and X ∈ P, then **P = NP**
- **P ⊆ NP**
- If X is NP-complete, every problem in NP reduces to X in polynomial time
- Every NP-complete problem reduces to every other NP-complete problem in polynomial time
- SAT is NP-complete, and was the first proved so

**False:**
- NP-complete problems can be solved in polynomial time with parallel processors
- NP-complete problems cannot be solved exactly, only approximated *(they can be solved exactly —
  just not in polynomial time in general)*
- All NP problems require exponential time *(P ⊆ NP, and P problems are polynomial)*
- Hamiltonian cycle is in P

### The A/B reduction pattern (practice exam)

Given two problems where **A is secretly in P** and **B is secretly NP-complete**, the four true
statements are always:
✓ A can be reduced to B in polynomial time *(anything in P reduces to anything, trivially)*
✓ A is in P
✓ It is unknown whether B can be reduced to A in polynomial time
✓ It is unknown whether B is in P

**Spotting them:** B is a disguised classic — knapsack ("maximise value within a budget"),
Hamiltonian cycle ("visit every room exactly once"), SAT. A turns out to be solvable by BFS, sorting
or a greedy rule — for instance "is there a path from s to t?" is just connectivity.

---

## Task 13 — Algorithm design (10 pts)

A skeleton with five blanks, then complexity, then a trace on an example. Both papers use a
**single-pass scan**, so the complexity answer is always **Θ(n) time, Θ(1) space** — justify both in
a line.

### Group A — longest strictly increasing run ("heat wave")
```
bestStart ← 1;  bestLen ← 1              (a) = 1
currStart ← 1;  currLen ← 1              (a) = 1
for i ← 2 to n do
    if T[i] > T[i−1] then                (b)
        currLen ← currLen + 1
        if currLen > bestLen then
            bestStart ← currStart        (c)
            bestLen  ← currLen           (d)
    else
        currStart ← i                    (e)
        currLen ← 1
return bestStart, bestLen
```
Time **Θ(n)** — one pass, O(1) work per element. Space **Θ(1)** — four variables.

Trace on ⟨22, 19, 20, 23, 21, 24, 27, 29⟩: the runs are ⟨22⟩ (length 1), ⟨19, 20, 23⟩ (length 3,
starting at index 2), ⟨21, 24, 27, 29⟩ (length 4, starting at index 5).
→ **start = 5, length = 4.**

### Group B — cheapest window of k consecutive values ("express lane")
```
windowSum ← Σ(i = 1..k) w[i]                       (a)
bestStart ← 1;  bestSum ← windowSum
for i ← 2 to n − k + 1 do
    windowSum ← windowSum − w[i−1] + w[i+k−1]      (b)
    if windowSum < bestSum then                    (c)
        bestSum   ← windowSum                      (d)
        bestStart ← i                              (e)
return bestStart
```
Time **Θ(n)** — Θ(k) for the initial sum, then O(1) per slide. Space **Θ(1)**.

Trace on ⟨3, 1, 4, 1, 5, 9, 2, 6⟩ with k = 3: window sums 8, 6, 10, 15, 16, 17.
→ **start = 2, total = 6 minutes.**

### The two identities to memorise

> **Sliding window:** new sum = old sum − (element leaving) + (element entering)
> = `windowSum − w[i−1] + w[i+k−1]`

> **Longest run:** if the condition holds, extend and update the best; otherwise reset with
> `currStart ← i` and `currLen ← 1`

**Variants** — longest non-decreasing run, maximum instead of minimum window, longest run of equal
values — change only the comparison. The skeleton is identical.

---

# Part 4 — Possible extras

These appear in the practice exam but not in Groups A or B. Low probability, cheap to skim.

**Memory complexity**, asked as "**extra** memory, not counting the input":
merge sort **Θ(n)** · binary search **Θ(1)** · heapsort **Θ(1)** · Dijkstra **Θ(n + m)** — so Θ(n) on
a sparse graph, but **Θ(n²)** when m = Θ(n²), because the priority queue can hold that many entries.

**Composite running times.** Read them as "cost of one operation × number of operations":
- build-heap then n removeMax → that's heapsort → **Θ(n log n)**
- Floyd–Warshall (Θ(n³)) run inside a double loop → **Θ(n⁵)**
- n insertions into a sorted array → finding the spot is O(log n), but **shifting is Θ(n)** →
  **Θ(n²)**
- 100n² insertions into an AVL tree → the tree always holds between n and ~100n² elements, and
  log(100n² + n) = Θ(log n), so each add is Θ(log n) → **Θ(n² log n)**

**Sorting a graph's edges in O(n + m).** The answer is **radix sort = two passes of counting sort** —
first by target vertex, then by source. Stability makes the second pass preserve the first's ordering.
*(BFS is the wrong answer even though its running time matches.)*

**Ordering Python and C++ programs by real running time.** Sort by asymptotics first, then by
language. Removing from the **front** of a list or vector shifts every remaining element, so it's
Θ(n) per removal → Θ(n²) total. Removing from the **back** is O(1) amortised → Θ(n) total. So both
back-removal programs beat both front-removal ones, and within each pair the C++ one is faster.

**Turning a memoised recursion into a DP.** Replace the dictionary with an array, add a loop over the
subproblem index from smallest to largest, replace recursive calls with array lookups, drop the
`if not in memo` guard, and return the last entry:
```
DP[0..n] = new array
DP[0] = 0;  DP[1] = 0
for p = 2 to n do
    DP[p] = max(a[p] + DP[p−2], DP[p−1])
return DP[n]
```

**Draw a BST of a given height on given keys that is *not* AVL** → make it a path (each node with a
single child), then mark the node whose two subtree heights differ by 2 or more.

---

# Part 5 — Cram sheet

```
2 HOURS · 13 TASKS · 180 POINTS · NO AIDS
⚠ HEIGHT: use the convention printed in the question. 2026 = leaf 0, empty subtree −1.
ORDER: 12 → 10 → 7 → 5 → 4 → 11 → 1 → 2 → 6 → 3 → 9 → 8 → 13

T12 GRADIENT DESCENT (15)  θ_{t+1} = θ_t − η ∇L(θ_t)
   gradient points to steepest INCREASE → step the other way
   too small = slow · too large = overshoot/diverge
   convex = no local min but the global one → GD always finds it
   L = (w−a)² → ∇L = 2(w−a); distance × (1−2η) per step; η = 0.5 lands in one step

T10 HASH (10)  k mod p, separate chaining, draw ALL slots incl. empty
   worst Θ(n) = all in one chain · hash O(1) avg / AVL O(log n) worst + sorted output O(n)

T7 KRUSKAL (20)  cheapest edge that makes no cycle · find-union
   exactly n−1 edges · after one component, reject everything · Θ(m log m)

T5 DIJKSTRA (20)  DIRECTED. extract smallest d, relax OUTGOING edges.
   extraction order ≠ order first reached · Θ((n+m) log n) · weights ≥ 0
   CHECK dist[w] = dist[parent[w]] + edge
   BFS counts HOPS; disagrees where a cheap detour beats one heavy edge

T4 DP STAIRS (15)  dp[n] = dp[n−s1] + dp[n−s2] · dp[0] = 1 · last move was either → disjoint
   1-or-2 = Fibonacci: 1,1,2,3,5,8,13,21,34 · 1-or-3: 1,1,1,2,3,4,6,9 · Θ(n)

T11 SKELETONS (15)  BFS: dist[v]+1, test "not yet computed", q.add(w)
   Dijkstra: dist[v]+c, test dist[w] > dist[v]+c, q.add(w, dist[w])
   ordering: init → structure → source → LOOP LINE → extract → process → return

T1 ASYMPTOTICS (10)  constant inner loop → Θ(n) · triangular → Θ(n²) · doubling → Θ(n log n)
   log(n^k) = k log n · (√2)^{log n} = √n · n! > 3ⁿ > 2ⁿ > n^k
   log base irrelevant, exponential base is not

T2 RECURRENCES (15)  while i>n−4 from n → 4 calls · while i≤n−3 from 1 → n−3 calls
   n-dependent branching → MASTER THEOREM DOES NOT APPLY (say it)
   c = log_b a · d<c → A → n^c · d=c → B → n^c log n · d>c → C → n^d
   write a, b, f(n), c, case, result

T6 HEAP+BST+AVL (15)  children 2i, 2i+1 · answer = the CHILD's index · new value ≤ parent
   (and ≥ its own children if it has any) · BST in-order must be sorted · |hL − hR| ≤ 1

T3 SORTING (15)  bounded range → counting sort Θ(n+k), beats Ω(n log n) by never comparing
   decision tree: n! leaves → height ≥ log₂(n!) = Θ(n log n)
   anything below n log n → NO, for comparison-based sorting

T9 DATA STRUCTURES (15)  priority → heap · same group → find-union
   worst-case log n + sorted output → AVL · O(1) avg, no order → hash · FIFO → queue
   4 parts: name / fit / time AND space / why the others lose

T8 P-NP (15)  P = solvable poly · NP = verifiable poly (certificate) · NP-c = in NP + all NP reduce to it
   P: sort, Dijkstra, MST, binary search, 2-colouring, connectivity
   NP-c: Hamiltonian, SAT (first, Cook-Levin 1971), knapsack, independent set, 3-colouring
   TRUE: NP-c ∧ in P → P=NP · P⊆NP · all NP reduce to any NP-c · SAT is NP-c

T13 DESIGN (10)  single pass → Θ(n) time, Θ(1) space
   sliding window: new = old − w[i−1] + w[i+k−1]
   longest run: extend if condition holds, else currStart ← i, currLen ← 1
```

---

# Part 6 — How to use the time you have

1. **Verify the aids rule.** Both papers say no aids; confirm before planning around a cheatsheet.
2. **Memorise the pure-recall blocks first** — that's the cheapest studying available, roughly 50
   points: the gradient descent block (task 12), the two pseudocode skeletons (task 11), the
   decision-tree paragraph (task 3c), and the P/NP definitions (task 8a).
3. **Work Group A properly**, with the solutions covered, then **Group B as a timed check.** They are
   the same exam twice with different numbers.
4. **Then the practice exam**, which has the widest range of question shapes and covers the extras in
   Part 4.

### Final checks before you hand in
- Heights — did you use the convention printed on the paper?
- Kruskal — exactly n − 1 edges added?
- Dijkstra — does every dist equal the parent's dist plus the edge weight?
- BST — does the in-order traversal come out sorted?
- Recurrence — is the branching factor constant, and did you say so if it isn't?
- Task 9 — did you write why the *other* structures lose?
- dp[0] = 1, not 0.
- Master theorem — did you write all six things (a, b, f(n), c, case, result)?
