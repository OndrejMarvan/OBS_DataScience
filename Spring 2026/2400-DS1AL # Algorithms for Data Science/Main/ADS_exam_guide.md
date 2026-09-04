# Algorithms for Data Science — Exam Guide (June 2026 format)

Rebuilt from the **June 2026 papers (Groups A and B, with solutions)** and the **practice exam**.
The June 2025 papers you had earlier are a different, older format — ignore them.

---

## 0. What changed, and why it matters

The 2025 papers and the 2026 papers are different exams. Groups A and B of June 2026 are
**structurally identical to each other** — same 13 tasks, same point split, only the numbers differ.
That is your blueprint.

| | June 2025 (old) | **June 2026 (yours)** |
|---|---|---|
| Duration | 90 min | **2 hours** |
| Points | 60 + 4 | **180** |
| Aids | one page allowed | **"No aids allowed"** ← verify this |
| Floyd–Warshall stopped early | 5 pts | **gone** |
| Broken loop invariant | 4 pts | **gone** |
| Draw graph from matrix | 5 pts | **gone** |
| Kruskal / MST | — | **20 pts** |
| Gradient descent | — | **15 pts** |
| Sorting traces + lower bound | — | **15 pts** |
| DP table | — | **15 pts** |
| Hash tables | — | **10 pts** |

### ⚠ The height convention flipped

Your **lab sheets** define height as the number of **nodes** (leaf = 1, NONE = 0).
The **June 2026 exam** states, in the question itself: **"height of a leaf = 0"**, and Group B adds
**"height of empty subtree = −1"**. That's edge-counting — every answer is one smaller.

**Rule for the day: use whatever convention the question prints.** Both papers state it explicitly
in task 6(c). Read that line before you write any numbers. If nothing is stated, say which
convention you're using and be consistent.

---

## 1. The blueprint — 13 tasks, 180 points

| # | Task | Pts | What it actually asks |
|---|---|---|---|
| 1 | Asymptotic notation | 10 | Simplify 3 Θ expressions + give the complexity of a code fragment |
| 2 | Recurrences | 15 | (a) write T(n) from pseudocode; (b),(c) two Master theorem problems |
| 3 | Sorting | 15 | (a) pick a sort + justify; (b) trace MergeSort or QuickSort; (c) the Ω(n log n) argument |
| 4 | DP: stair climbing | 15 | Base cases, why the recurrence holds, fill the table, final answer, complexity |
| 5 | Graphs | 20 | Dijkstra step-by-step table, shortest path, complexity, BFS comparison |
| 6 | Heaps & BSTs | 15 | Find the heap violation + fix; insert into a BST; check AVL |
| 7 | MST — Kruskal | 20 | Sort edges, add/reject table with components, draw MST, weight, complexity |
| 8 | P and NP | 15 | Define P/NP/NP-complete, classify 5 problems, tick correct statements |
| 9 | Data structures | 15 | Three scenarios, choose from a list of 8 |
| 10 | Hash tables | 10 | Insert with chaining, worst case, hash vs AVL comparison table |
| 11 | Algorithm structure | 15 | Fill 5 blanks in BFS/Dijkstra pseudocode + put 7 scrambled steps in order |
| 12 | Gradient descent | 15 | Update rule, learning rate, convexity, two numeric steps |
| 13 | Algorithm design | 10 | Fill 5 blanks in a skeleton, complexity, run it on an example |

**Where the easy points are.** Tasks 5, 7, 10, 11 and 12 are **80 points** and almost entirely
mechanical or memorised. Task 4 is another 15 for arithmetic. That's **95 of 180** with no real
difficulty — that alone is a comfortable pass.

**Recommended order of attack:** 12 → 10 → 7 → 5 → 4 → 11 → 1 → 2 → 6 → 3 → 9 → 8 → 13.
Gradient descent first because it's 15 points of pure recall and takes five minutes.

---

## 2. Task 12 — Gradient descent (15 pts) — do this first

Identical in both papers. Pure recall, four parts.

### (a) The update rule

> **θ_{t+1} = θ_t − η · ∇L(θ_t)**

Define every symbol, because that's where the marks are: **θ_t** = the current parameters,
**η > 0** = the learning rate, **∇L(θ_t)** = the gradient of the loss at the current parameters.

**Why the minus sign:** the gradient points in the direction of **steepest increase** of L. We want
to *decrease* the loss, so we step in the opposite direction. For a small enough η this is guaranteed
to reduce the loss locally.

### (b) Learning rate

- **Too small:** training crawls; you need very many iterations to approach a minimum.
- **Too large:** the step overshoots the minimum; the loss oscillates or diverges.

### (c) Convexity

- **Convex** = the graph lies at or below the chord joining any two of its points. Equivalently:
  **it has no local minimum other than the global one.**
- On a convex landscape, gradient descent **always** finds the global minimum regardless of the
  starting point, because every local minimum is the global one.
- On a **non-convex** landscape it can get stuck in a local minimum.

The picture with one smooth bowl is convex; the one with two dips is not.

### (d) The numeric part

Both papers use **L(w) = (w − a)²**, so **∇L(w) = 2(w − a)**. Then just apply
w_{t+1} = w_t − η · 2(w_t − a).

**Group A:** L(w) = (w − 3)², η = 0.5, w₀ = 0.
w₁ = 0 − 0.5·2(0 − 3) = 0 + 3 = **3**. w₂ = 3 − 0.5·2(3 − 3) = **3**.
Minimum at w* = 3. It arrives in **one step** — with η = 0.5 the step size exactly matches the
curvature of this quadratic.

**Group B:** L(w) = (w − 5)², η = 0.25, w₀ = 1.
w₁ = 1 − 0.25·2(1 − 5) = 1 + 2 = **3**. w₂ = 3 − 0.25·2(3 − 5) = 3 + 1 = **4**.
Minimum at w* = 5. It **converges but never quite arrives**: the distance halves each step
(4 → 2 → 1 → …), so convergence is geometric and asymptotic.

**Worth memorising for a variant:** for L(w) = (w − a)² the update is
w_{t+1} = w_t − 2η(w_t − a), so the distance to a is multiplied by **(1 − 2η)** each step.
η = 0.5 → lands exactly. η < 0.5 → converges gradually. η > 1 → diverges.

Also know: **batch** GD uses all n examples per step (stable, expensive); **SGD** uses one (cheap,
noisy); **mini-batch** is the practical compromise. Backpropagation is the chain rule applied layer
by layer.

---

## 3. Task 10 — Hash tables (10 pts)

### (a) Insert with separate chaining

h(k) = k mod 7, table size 7, each slot holds a linked list. Just compute each remainder and append
in insertion order.

**Group A:** keys 5, 12, 8, 3, 15, 10.
5 mod 7 = 5 · 12 mod 7 = 5 · 8 mod 7 = 1 · 3 mod 7 = 3 · 15 mod 7 = 1 · 10 mod 7 = 3

| Slot | Chain |
|---|---|
| 0 | — |
| 1 | 8 → 15 |
| 2 | — |
| 3 | 3 → 10 |
| 4 | — |
| 5 | 5 → 12 |
| 6 | — |

**Group B:** keys 6, 13, 2, 9, 20, 4 → slot 2: 2 → 9 · slot 4: 4 · slot 6: 6 → 13 → 20.

Draw **all seven slots including the empty ones** — the table is the answer.

### (b) Worst case

**Θ(n)**, when all n keys land in the same slot, giving one chain of length n. Happens with
adversarial input tailored to the hash function, or when all keys are congruent modulo the table size.

### (c) The comparison table — memorise it

| Operation | Hash table | AVL tree |
|---|---|---|
| Search | O(1) expected | O(log n) |
| Insert | O(1) amortised | O(log n) |
| Delete | O(1) expected | O(log n) |
| Sorted output of all keys | O(n log n) — must sort first | **O(n)** — in-order traversal |

**Hash table's advantage:** O(1) average operations.
**AVL's advantage:** sorted output in O(n), and **O(log n) worst case** for everything.

---

## 4. Task 7 — Minimum spanning tree, Kruskal (20 pts)

The largest task on the paper and one of the easiest. Five parts.

### The algorithm

**Repeatedly take the cheapest remaining edge that doesn't create a cycle**, until you have n − 1
edges. Cycle-checking uses **find–union**: an edge is rejected exactly when both endpoints are
already in the same component.

### (a) Sort the edges — 3 pts

List all edges by weight, non-decreasing. Write the weight beside each. Ties can go in any order but
pick one and stick to it.

### (b) The add/reject table — 10 pts, the bulk of the marks

For each edge in order, write **Add** or **Reject** and the **components after that step**.

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

**Group B** — 3-5(1), 2-3(2), 5-6(2), 1-2(3), 2-4(4), 1-3(5), 4-6(6): Add, Add, Add, Add, Add,
Reject, Reject. Total weight **12**.

**Two checks that catch errors:**
1. You must end with exactly **n − 1 edges added** (5 edges for 6 vertices).
2. Once all vertices are in one component, **every remaining edge is rejected** — no exceptions.

### (c),(d) Draw the MST and give its weight — 5 pts
Just the added edges. Group A total = 1+2+3+3+4 = **13**. Group B = 1+2+2+3+4 = **12**.

### (e) Complexity — 2 pts
**Θ(m log m)**, dominated by sorting the edges. (Find–union operations are near-constant,
Θ(α(n)) amortised.)

---

## 5. Task 5 — Graphs and Dijkstra (20 pts)

Note: the 2026 graphs are **directed**. An edge 1→2 can be used only in that direction.

### (a) The step table — 8 pts

They want a row per extraction: which vertex came out, and the distance array afterwards.

**Method:** initialise d[s] = 0 and everything else ∞. Repeat: extract the **unvisited vertex with
the smallest d**, then relax each of its **outgoing** edges — if d[v] + weight < d[w], update d[w].

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

Note step 2: vertex **3 is extracted before 2** even though 2 was reached first, because d[3] = 2 < 4.
And going 1→3→2 costs 3, beating the direct edge of weight 4. That's the whole point of the question.

### (b) The shortest path — 5 pts
Follow the parents back from the target. Group A: **1 → 3 → 2 → 4 → 6**, total 2+1+5+3 = **11**.
Group B: **1 → 3 → 2 → 4 → 6**, total 3+2+2+4 = **11**.
(Both papers happen to have the same path shape — the cheapest route ignores the direct edges.)

### (c) Complexity — 4 pts
**Θ((n + m) log n)** with a binary heap.

### (d) BFS comparison — 3 pts
BFS ignores weights and counts **hops**. Run it and give the hop distances, then give one
disagreement.

Group A BFS: d = 0, 1, 1, 2, 2, 3 for vertices 1–6.
**The disagreement:** BFS says d[2] = 1 (the direct edge 1→2 is one hop), Dijkstra says d[2] = 3
(via 1→3→2, weight 2+1). BFS treats every edge as weight 1, so it is only correct on unweighted
graphs.

Group B BFS: d = 0, 1, 1, 2, 3, 3. Same disagreement at vertex 2: BFS 1 hop vs Dijkstra 5.

---

## 6. Task 4 — Dynamic programming, stair climbing (15 pts)

n steps; each move climbs a fixed set of step sizes; count the distinct ways to reach step n.

### The general recurrence

If the allowed moves are of sizes s₁, s₂, …, then
**dp[n] = dp[n − s₁] + dp[n − s₂] + …**

**Why it holds — say this explicitly, it's worth marks:** the *last* move to reach step n was either
a step of size s₁ (leaving dp[n − s₁] ways to have got there) or of size s₂ (dp[n − s₂] ways). These
cases are **disjoint and exhaustive**, so you add them.

### Base cases
**dp[0] = 1** — there is exactly one way to be at the start: don't move. (Not 0.)
Then fill in the small cases by hand where a large step is impossible.

**Group A (steps of 1 or 2):** dp[0] = 1, dp[1] = 1. This is Fibonacci.

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|---|
| dp | 1 | 1 | 2 | 3 | 5 | 8 | 13 | 21 | **34** |

**Group B (steps of 1 or 3):** dp[0] = 1, dp[1] = 1, **dp[2] = 1** (a 3-step is impossible, so only
1+1). Then dp[n] = dp[n−1] + dp[n−3].

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|
| dp | 1 | 1 | 1 | 2 | 3 | 4 | 6 | **9** |

Check the 1-or-3 row: dp[3] = dp[2]+dp[0] = 1+1 = 2 · dp[4] = dp[3]+dp[1] = 2+1 = 3 ·
dp[5] = 3+1 = 4 · dp[6] = 4+2 = 6 · dp[7] = 6+3 = 9 ✓

### Complexity
**Θ(n)** — each entry is computed once in a single left-to-right pass. (Space can be reduced to
Θ(1) by keeping only the last few entries.)

**If they change the step sizes**, redo the base cases from scratch — that's where the trap is.
For steps of 1 or 4: dp[0..3] = 1, 1, 1, 1, then dp[n] = dp[n−1] + dp[n−4].

---

## 7. Task 11 — Algorithm structure (15 pts)

Two halves: fill blanks in pseudocode, then unscramble steps. Both are pure recall — **learn these
two skeletons cold.**

### (a) Fill the blanks — 7 pts

**BFS** (asked in Group A):
```
dist[s] = 0                          ← (a) 0
parent[s] = NONE
q = new Queue
q.add(s)
while q not empty do
    v = q.extractOldest()
    for every edge (v, w) do
        if dist[w] not yet computed then    ← (b)
            dist[w] = dist[v] + 1           ← (c)
            parent[w] = v                   ← (d)
            q.add(w)                        ← (e) w
```

**Dijkstra** (asked in Group B):
```
dist[s] = 0                          ← (a) 0
dist[u] = ∞ for all u ≠ s
q = new PriorityQueue
q.add(s, 0)
while q not empty do
    v = q.extractMin()
    for every edge (v, w, c_vw) do
        if dist[w] > dist[v] + c_vw then    ← (b)
            dist[w] = dist[v] + c_vw        ← (c)
            parent[w] = v                   ← (d)
            q.add(w, dist[w])               ← (e)
```

The pattern is the same in both: **condition compares, body assigns, then push the neighbour.**
BFS adds 1; Dijkstra adds the edge weight. BFS's test is "not yet seen"; Dijkstra's is "can I do
better".

### (b) Order the scrambled steps — 8 pts

The logic is always: **initialise → prepare → main loop → loop body → return.**

**Kruskal** (Group A): F(1) initialise empty MST → C(2) sort edges by weight → G(3) initialise
find–union with n singletons → E(4) for each edge in sorted order → A(5) if Find(u) ≠ Find(v), add
and Union → D(6) otherwise discard → B(7) return the MST.

**BFS** (Group B): C(1) set all dist = ∞ → G(2) create the queue → A(3) set dist[s] = 0,
parent[s] = NONE, add s → F(4) repeat until the queue is empty → D(5) extract the oldest vertex →
E(6) process its neighbours → B(7) return dist and parent.

Note in the BFS ordering that **F (the repeat/loop) comes before D and E**, because the loop
statement encloses them. Getting that nesting right is the only real difficulty.

---

## 8. Task 1 — Asymptotic notation (10 pts)

Three simplifications (2+2+3) plus one code fragment (3).

### The simplifications

Method unchanged: kill constant factors → convert → keep only the fastest-growing term.

```
1 < log n < (log n)^k < √n < n < n log n < n² < n³ < 2ⁿ < 3ⁿ < n!
```

| Seen in the papers | Answer | Key move |
|---|---|---|
| Θ(5n³ + 100n² + log n) | Θ(n³) | — |
| Θ(n log n⁴ + n²/1000) | Θ(n²) | log n⁴ = 4 log n, so term 1 is Θ(n log n) |
| Θ(2ⁿ + n¹⁰⁰⁰) | Θ(2ⁿ) | exponential beats any polynomial |
| Θ(4n² + 200n + log²n) | Θ(n²) | — |
| Θ(√n · log n + √n) | Θ(√n log n) | factor out √n: √n(log n + 1) |
| Θ(n! + 3ⁿ) | **Θ(n!)** | factorial beats any exponential |
| Θ(10 log₁₀n + √n/100 + (√2)^{log n}·log n) | Θ(√n log n) | **(√2)^{log n} = 2^{(log n)/2} = √n** |
| Θ(4n + log n + 1) | Θ(n) | — |
| Θ(3n log n³ + 100n) | Θ(n log n) | log n³ = 3 log n |

Remember: **log base doesn't matter** inside Θ; **exponential base does** (3ⁿ ≠ 2ⁿ, n! > 3ⁿ).

### The code fragment — how to count loops

| Pattern | Cost | Why |
|---|---|---|
| `for x = 1 to n` with a **constant-length** inner loop (e.g. `for y = x−10 to x+10`) | **Θ(n)** | the inner loop runs exactly 21 times — a constant |
| `for i = 1 to n` / `for j = i to n` (triangular) | **Θ(n²)** | Σ(n − i + 1) = n(n+1)/2 |
| `for x = 1 to 10n` / `while y ≥ x` counting down from 10n | **Θ(n²)** | same triangular sum |
| `for i = 1 to n` / `while j ≤ n: j = j·2` (**doubling**) | **Θ(n log n)** | doubling means ⌊log₂n⌋+1 iterations |
| three nested loops where the innermost is `for k = 1 to 10` | **Θ(n²)** | the constant loop contributes nothing |

**The two summation rules you need:**
1 + 2 + … + n = n(n+1)/2 = **Θ(n²)**  ·  1 + 2 + 4 + … + 2ⁿ = 2^{n+1} − 1 = **Θ(2ⁿ)**

**The tell for Θ(log n):** the loop variable is **multiplied or divided**, not incremented.

---

## 9. Task 2 — Recurrences (15 pts)

### (a) Write T(n) from pseudocode — 5 pts

**Count the recursive calls exactly.** This is where they set the trap.

- `while i > n − 4` starting at `i = n`, decrementing → runs for i = n, n−1, n−2, n−3, stops at
  n−4 → **exactly 4 calls** (a constant).
- `while i ≤ n − 3` starting at `i = 1`, incrementing → runs for i = 1 … n−3 → **n − 3 calls**
  (depends on n!).
- `for j = 1 to 9` → **9 calls**.
- The final `for k = 1 to n^d` loop gives **Θ(n^d)** non-recursive work.

**Group B:** 4 (while) + 12 (for) = 16 calls on ⌊n/15⌋, plus Θ(n⁸).
→ **T(n) = 16·T(⌊n/15⌋) + Θ(n⁸)**

**Group A — the trap:** (n−3) (while) + 9 (for) = **n + 6** calls on ⌊n/6⌋, plus Θ(n⁵).
→ **T(n) = (n + 6)·T(n/6) + Θ(n⁵)**
⚠ **The branching factor depends on n, so the Master theorem does not apply.** Say that explicitly —
it's the point of the question. The Master theorem needs a **constant** a.

### (b),(c) Master theorem — 5 pts each

**T(n) = a·T(n/b) + Θ(n^d)**, **c = log_b a**:
**d < c → Case A → Θ(n^c)** · **d = c → Case B → Θ(n^c log n)** · **d > c → Case C → Θ(n^d)**

They want **a, b, f(n), c, the case letter, and the result**, with an explanation. Write all six.

| Seen in the papers | c | Case | Result |
|---|---|---|---|
| 8T(n/2) + Θ(n²) | log₂8 = 3 | A | Θ(n³) |
| 4T(n/2) + Θ(n²) | log₂4 = 2 | B | Θ(n² log n) |
| 27T(n/3) + Θ(n²) | log₃27 = 3 | A | Θ(n³) |
| 2T(n/2) + Θ(n) | log₂2 = 1 | B | Θ(n log n) |
| 4T(⌈n/2⌉) + Θ(n²) *(practice)* | 2 | B | Θ(n² log n) |

**c = the power of b that gives a.** Powers of 2: 2,4,8,16,32,64,128,256,512,1024 → 1…10.
Powers of 3: 3,9,27,81 → 1…4.

---

## 10. Task 6 — Heaps and BSTs (15 pts)

### (a) Heap violation — 5 pts

12-element array shown as a complete binary tree. Children of i are **2i, 2i+1**; parent is
**⌊i/2⌋**. Max-heap rule: **every parent ≥ both children**.

**Note the 2026 wording is easier than the old papers:** it asks you to "fix by changing exactly one
value", and the solution says **"any value ≤ the parent"**. In both papers the violating node is at
**index 12**, which is a leaf (2·12 = 24 > 12), so there's no lower bound at all.

Group A: A[12] = 75 > A[6] = 70 → index **12**, set it to anything ≤ 70 (e.g. 65).
Group B: A[12] = 28 > A[6] = 20 → index **12**, set it to anything ≤ 20 (e.g. 18).

⚠ If the violating node happens to **have children**, your new value must also stay **≥ both of
them**. Check before answering.

### (b) BST insertion — 5 pts
From the root: left if smaller, right if larger, drop at the first empty spot. **Never restructure.**
A key already present changes nothing.
**Check: in-order traversal must come out sorted.**

### (c) AVL check — 5 pts

⚠ **Use the convention printed in the question** — in 2026 that's **leaf = 0** (and Group B adds
empty subtree = **−1**).

Compute every node's height bottom-up, then check **|h(left) − h(right)| ≤ 1** at every node.

Group A's tree (root 15, children 9 and 22, four leaves): h(leaves) = 0, h(9) = h(22) = 1,
h(15) = 2. All balance factors 0 → **AVL**.
Group B's tree: h(2) = 0, h(3) = 1, h(8) = 0, h(5) = 2, h(12) = 0, h(15) = 1, h(10) = 3.
Balance factors 1, 1, 1, 1 → all ≤ 1 → **AVL**.

Both papers answer "yes". Don't let that make you careless — check every node anyway, and if one
fails, name it.

---

## 11. Task 3 — Sorting (15 pts)

### (a) Choose a sort — 5 pts

The scenario is always **many elements, values in a bounded range** → **Counting Sort** (or Radix).

Group A: 10⁶ integers with 1 ≤ A[i] ≤ n → counting array of size n → **Θ(n + k) = Θ(n)**.
Group B: 10⁶ integers in [0, 999] → k = 1000 is a constant relative to n → **Θ(n)**.

**Always add the punchline:** this beats any comparison-based sort, which needs Ω(n log n) — because
counting sort doesn't compare elements at all.

### (b) Trace a sort — 5 pts

**MergeSort (Group A)** on ⟨5,2,8,3,9,1,7,4⟩ — show split levels then merge levels:
```
split  L0: 5 2 8 3 9 1 7 4
       L1: 5 2 8 3 | 9 1 7 4
       L2: 5 2 | 8 3 | 9 1 | 7 4
       L3: 5 | 2 | 8 | 3 | 9 | 1 | 7 | 4
merge  L2: 2 5 | 3 8 | 1 9 | 4 7
       L1: 2 3 5 8 | 1 4 7 9
       L0: 1 2 3 4 5 7 8 9
```
Halve until singletons, then merge pairwise. Write **both phases** — the marks are for showing the
levels.

**QuickSort (Group B)** on ⟨3,1,4,1,5,9,2,6⟩ with the **last element as pivot**: after partitioning,
the pivot sits in its final position, everything ≤ it on the left, everything > it on the right.
Pivot 6 → ⟨3,1,4,1,5,2 | 6 | 9⟩. Then recurse on each side, pivot 2 on the left → ⟨1,1 | 2 | 3,5,4⟩.
*(The exact left-to-right arrangement within each side depends on the partition scheme — the marked
solution shows a fully sorted left half, which Lomuto partitioning wouldn't quite produce. State
your scheme and make sure the pivot is in place with the correct split.)*

### (c) The lower bound argument — 5 pts

Learn this as a paragraph:

> Any comparison-based sorting algorithm can be drawn as a **decision tree**: each internal node is a
> comparison, each leaf a distinct permutation of the input. To sort every input correctly, all **n!**
> permutations must be reachable, so the tree has at least n! leaves. A binary tree with n! leaves has
> height at least **log₂(n!) = Θ(n log n)** (Stirling). So every comparison-based algorithm needs
> **Ω(n log n)** comparisons in the worst case, and MergeSort achieves it — hence MergeSort is optimal.

**Variants:** "can we sort in O(n log log n)?" → **No**, since n log log n = o(n log n).
"in O(n·α(n))?" → **No**, α (inverse Ackermann) grows far slower than log n.
The answer is always no for any bound below n log n **for comparison-based sorting** — and always
say "comparison-based", because counting sort is the exception.

### Reference table

| | Worst | Space | Stable |
|---|---|---|---|
| Insertion | n² (n if sorted) | 1 | Yes |
| Merge | n log n | n | Yes |
| Quick | **n²** (avg n log n) | log n | No |
| Heap | n log n | 1 | No |
| Counting | n + k | n + k | Yes |
| Radix | d(n + k) | n + k | Yes |

---

## 12. Task 9 — Choosing a data structure (15 pts)

Three scenarios, 5 points each, from a list of eight: unsorted array, sorted array, hash table,
max-heap/priority queue, BST (unbalanced), AVL tree, find–union, queue.

### Decision key

| The scenario says | Answer |
|---|---|
| "retrieve the highest priority", scheduling, triage | **Max-heap / priority queue** |
| "same group?", merging groups, connectivity | **Find–union** |
| "O(log n) **worst case**" + "**sorted output**" | **AVL tree** |
| "O(1) **average**", no ordering ever needed | **Hash table** |
| strictly first-in-first-out, only enqueue/dequeue | **Queue** |
| static data, binary search, minimal memory | **Sorted array** |
| only ever add, never search | **Unsorted array** |

### Scenarios already seen (learn these four — they recur)

- **Emergency room, retrieve highest-priority patient in O(log n)** → **Max-heap.** extractMax and
  insert both O(log n), space Θ(n). No sorted output or key search needed, so AVL/hash would be overkill.
- **Social network friend groups, "are A and B in the same group?"** → **Find–union.** Union and Find
  in Θ(α(n)) amortised, space Θ(n). Purpose-built for dynamic connectivity.
- **Leaderboard / airline bookings: O(log n) insert, delete, search *and* sorted output in O(n)** →
  **AVL tree.** Unbalanced BST degrades to O(n); a hash table can't produce sorted output.
- **Compiler symbol table: O(1) average insert and lookup, no ordering** → **Hash table.**

*(The practice exam adds: **bacteria merging on a petri dish** → find–union, same reasoning.)*

### The answer format — four parts, all worth marks
1. Name the structure. 2. Map it to the scenario. 3. **Time and space complexity.**
4. **Why the other options are worse here.** Group them: "these can't do the required operation at
all; those are slower; that one can't give sorted output."

---

## 13. Task 8 — P and NP (15 pts)

### (a) Definitions — 5 pts. Write these almost verbatim.

- **P** — decision problems solvable by a deterministic algorithm in **polynomial time**.
- **NP** — decision problems where a proposed solution (a **certificate**) can be **verified** in
  polynomial time.
- **NP-complete** — a problem X such that (1) **X ∈ NP** and (2) **every problem in NP reduces to X
  in polynomial time** (i.e. X is NP-hard). The hardest problems in NP.

### (b) Classify five problems — 6 pts

**In P** (name the algorithm): sorting (merge sort, O(n log n)) · shortest path with non-negative
weights (Dijkstra) · minimum spanning tree (Kruskal/Prim) · binary search · **bipartite / 2-colouring
check** (BFS, O(n+m)) · connectivity (BFS).

**NP-complete:** Hamiltonian cycle · SAT (**the first, Cook–Levin 1971**) · knapsack (decision
version) · independent set · vertex cover · graph colouring · TSP.

⚠ **2-colouring is in P; 3-colouring is NP-complete.** ⚠ **Shortest path is in P; Hamiltonian
path is NP-complete.** The exam relies on these near-misses.

### (c) Tick the correct statements — 4 pts

**True:**
- If X is NP-complete and X ∈ P, then **P = NP** ✓
- **P ⊆ NP** ✓
- If X is NP-complete, every problem in NP reduces to X in polynomial time ✓
- Every NP-complete problem reduces to any other NP-complete problem in polynomial time ✓
- SAT is NP-complete / SAT was the first problem proven NP-complete ✓

**False:**
- NP-complete problems can be solved in polynomial time with parallel processors ✗
- NP-complete problems cannot be solved exactly, only approximated ✗ *(they can — just not in
  polynomial time in general)*
- All NP problems require exponential time ✗ *(P ⊆ NP)*
- Hamiltonian cycle is in P ✗

### The reduction pattern (practice exam, task 13)

Given problem A (secretly in P) and B (secretly NP-complete):
✓ A reduces to B · ✓ A is in P · ✓ unknown whether B reduces to A · ✓ unknown whether B is in P.
Everything else false. **Anything in P reduces to anything**, which is why the first is free.

---

## 14. Task 13 — Algorithm design (10 pts)

A skeleton with five blanks, then complexity, then a trace. Both papers use a **single-pass scan**.

### Group A — longest strictly increasing run ("heat wave")
```
bestStart ← 1;  bestLen ← 1          (a) = 1
currStart ← 1;  currLen ← 1          (a) = 1
for i ← 2 to n do
    if T[i] > T[i−1] then            (b)
        currLen ← currLen + 1
        if currLen > bestLen then
            bestStart ← currStart    (c)
            bestLen  ← currLen       (d)
    else
        currStart ← i                (e)
        currLen ← 1
return bestStart, bestLen
```
Time **Θ(n)**, space **Θ(1)**.
Trace on ⟨22,19,20,23,21,24,27,29⟩: runs are ⟨22⟩ (len 1), ⟨19,20,23⟩ (len 3, start 2),
⟨21,24,27,29⟩ (len 4, start 5) → **start 5, length 4**.

### Group B — cheapest window of k consecutive values ("express lane")
```
windowSum ← Σ(i=1..k) w[i]                     (a)
bestStart ← 1;  bestSum ← windowSum
for i ← 2 to n − k + 1 do
    windowSum ← windowSum − w[i−1] + w[i+k−1]  (b)   ← sliding window
    if windowSum < bestSum then                (c)
        bestSum   ← windowSum                  (d)
        bestStart ← i                          (e)
return bestStart
```
Time **Θ(n)** — Θ(k) for the initial sum, then O(1) per slide. Space **Θ(1)**.
Trace on ⟨3,1,4,1,5,9,2,6⟩ with k = 3: sums 8, 6, 10, 15, 16, 17 → **start 2, total 6**.

**The sliding-window identity is the thing to memorise:**
**new sum = old sum − (element leaving) + (element entering)** = `windowSum − w[i−1] + w[i+k−1]`.

**If the variant differs** (longest non-decreasing run, maximum window, longest run of equal values),
the skeleton is identical — only the comparison in (b)/(c) flips.

---

## 15. Possible extras from the practice exam

These appear in the practice exam but not in Groups A or B. Low probability, cheap to skim.

**Memory complexity.** Asked as "**extra** memory, not counting the input":
merge sort **Θ(n)** · binary search **Θ(1)** · heapsort **Θ(1)** · Dijkstra **Θ(n + m)** (the dist
table plus the priority queue — so Θ(n) on a sparse graph, **Θ(n²)** when m = Θ(n²)).

**Composite running times.** Read them as "cost of one operation × number of operations":
- build-heap then n removeMax → heapsort → **Θ(n log n)**
- Floyd–Warshall (Θ(n³)) run inside a double loop → **Θ(n⁵)**
- n insertions into a sorted array → finding the spot is O(log n) but **shifting is Θ(n)** → **Θ(n²)**
- 100n² insertions into an AVL tree → the tree always has between n and ~100n² elements, and
  log(100n² + n) = Θ(log n), so each add is Θ(log n) → **Θ(n² log n)**

**Sorting edges of a graph in O(n + m).** Answer: **Radix sort = two passes of counting sort** —
first by target vertex, then by source. Stability makes the second pass preserve the first's order.
(BFS is the wrong answer even though its running time matches.)

**Real running time of Python vs C++.** Order by asymptotics first, then by language:
removing from the **front** of a list/vector is Θ(n) per removal → Θ(n²) total; removing from the
**back** is O(1) amortised → Θ(n). So both back-removal programs beat both front-removal ones, and
within each pair C++ beats Python.

**Turning a memoised recursion into a DP.** Replace the dictionary with an array, add a loop over
the subproblem index from smallest to largest, replace recursive calls with array lookups, drop the
`if not in memo` guard, return the last entry:
```
DP[0..n] = new array;  DP[0] = 0;  DP[1] = 0
for p = 2 to n do
    DP[p] = max(a[p] + DP[p−2], DP[p−1])
return DP[n]
```

**Draw a BST of height 3 on given keys that is not AVL** → make it a path (e.g. 40 → 10 → 30 → 20 or
similar chain), then mark the node whose subtree heights differ by ≥ 2.

---

## 16. Cram sheet

```
2 HOURS · 13 TASKS · 180 POINTS · CHECK WHETHER AIDS ARE ALLOWED
⚠ HEIGHT: use the convention PRINTED IN THE QUESTION. 2026 says leaf = 0, empty = −1.

ORDER: 12 → 10 → 7 → 5 → 4 → 11 → 1 → 2 → 6 → 3 → 9 → 8 → 13

T12 GRADIENT DESCENT (15)  θ_{t+1} = θ_t − η ∇L(θ_t)
   gradient points to steepest INCREASE → step the other way
   too small = slow · too large = overshoot/diverge
   convex = no local min but the global one → GD always finds it
   L=(w−a)² → ∇L=2(w−a); η=0.5 lands in one step

T10 HASH (10)  k mod 7, separate chaining, draw ALL slots
   worst Θ(n) all in one chain · hash O(1) avg / AVL O(log n) worst + sorted O(n)

T7 KRUSKAL (20)  sort edges → cheapest that makes no cycle → find-union
   must add exactly n−1 · after one component, reject everything · Θ(m log m)

T5 DIJKSTRA (20)  DIRECTED. extract smallest d, relax outgoing edges.
   Θ((n+m) log n). BFS counts HOPS and disagrees wherever a cheap detour beats a heavy edge.

T4 DP STAIRS (15)  dp[n]=dp[n−s1]+dp[n−s2] · dp[0]=1 · last move was either → disjoint
   1-or-2 = Fibonacci · 1-or-3: 1,1,1,2,3,4,6,9 · Θ(n)

T11 SKELETONS (15)  BFS: dist[v]+1, test "not yet computed", q.add(w)
   Dijkstra: dist[v]+c, test dist[w] > dist[v]+c, q.add(w, dist[w])
   ordering = init → prepare → LOOP → body → return (loop line before its body!)

T1 ASYMPTOTICS (10)  constant inner loop → Θ(n) · triangular → Θ(n²) · doubling → Θ(log n)
   log(n^k)=k log n · (√2)^{log n}=√n · n! > 3ⁿ > 2ⁿ > n^k

T2 RECURRENCES (15)  count calls EXACTLY: while i>n−4 from n → 4 · while i≤n−3 from 1 → n−3
   n-dependent branching → MASTER THEOREM DOES NOT APPLY (say it)
   c=log_b a · d<c→A→n^c · d=c→B→n^c log n · d>c→C→n^d

T6 HEAP+BST (15)  children 2i,2i+1 · violation index = the CHILD · new value ≤ parent
   (and ≥ its own children if it has any) · BST in-order must be sorted · |hL−hR| ≤ 1

T3 SORTING (15)  bounded range → counting sort Θ(n+k), beats Ω(n log n) by not comparing
   decision tree: n! leaves → height ≥ log(n!) = Θ(n log n)
   anything below n log n → NO for comparison-based

T9 DATA STRUCTURES (15)  priority → heap · same group → find-union
   worst-case log n + sorted output → AVL · O(1) avg, no order → hash · FIFO → queue
   4 parts: name / fit / complexity / why the others lose

T8 P-NP (15)  P = solvable poly · NP = verifiable poly · NP-c = in NP + all NP reduce to it
   P: sort, Dijkstra, MST, binary search, 2-colouring, connectivity
   NP-c: Hamiltonian, SAT (first, Cook-Levin), knapsack, independent set, 3-colouring
   TRUE: X NP-c ∧ X∈P → P=NP · P⊆NP · all NP reduce to any NP-c · SAT is NP-c

T13 DESIGN (10)  single pass, Θ(n) time Θ(1) space
   sliding window: new = old − w[i−1] + w[i+k−1]
   longest run: extend if T[i]>T[i−1], else currStart←i, currLen←1
```

---

## 17. What to do with the time you have left

1. **Verify the aids rule.** Both 2026 papers say no aids. Find out before you build a plan around a
   cheatsheet.
2. **Work the two 2026 papers.** They're the same exam twice with different numbers, and you have the
   solutions. Do Group A properly, then Group B as a timed check.
3. **Then the practice exam** — it's the widest sample of question shapes and covers the extras in §15.
4. Memorise, in this order: the gradient descent block (§2), the two pseudocode skeletons (§7), the
   decision-tree paragraph (§11c), the P/NP definitions (§13a). That's ~50 points of pure recall and
   it's the cheapest studying available.
