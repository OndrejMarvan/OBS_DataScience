---
tags: [afds, exam-prep, algorithms]
status: in-progress
---

# AfDS Exam Study Plan

A phase-based plan built around the practice exam and your lecture/lab material. It's ordered by **how often each topic shows up on the exam**, not by lecture order. Work top to bottom.

> [!note] How to use this
> Each phase has an hour estimate. Tick the checkboxes as you go. If you tell me your exam date, I'll convert the phases into real calendar days. If you're short on time, do Phase 1 + the timed mock (Phase 5) and skip the rest.

---

## Step 0 — Self-assessment (15 min)

Skim the practice exam once and rate each cluster **before** studying. This tells you where to spend time.

- [ ] **Complexity analysis** (Θ from code, simplification, memory) — Tasks 1, 6, 7, 8 → confidence: ___ / 5
- [ ] **Recurrences / Master Theorem** — Task 2 → ___ / 5
- [ ] **Sorting & lower bounds** — Tasks 3, 7, 8, 10 → ___ / 5
- [ ] **Dynamic programming** — Tasks 4, 12 → ___ / 5
- [ ] **Data structures** (BST/AVL, find-union, memory layout) — Tasks 5, 9, 11 → ___ / 5
- [ ] **Graphs & complexity classes** (Dijkstra, Floyd–Warshall, P/NP) — Tasks 7, 8, 13 → ___ / 5

> [!tip] Anything you rated 3 or below jumps to the front of its phase.

---

## Phase 1 — Complexity analysis (≈3 hrs) — *highest yield*

This is ~4 of the 13 tasks. If you nail nothing else, nail this.

**Know cold:**
- [ ] Reading Θ from nested loops. The trick is *count the dominating operation*. A loop that runs a **constant** number of times (e.g. `x-10` to `x+10` = 21 times) contributes O(1), not O(n). → *Task 1a*
- [ ] Loops where the inner bound depends on the outer variable → sum it. `Σ(10n − x + 1)` from 1 to 10n is an arithmetic series ≈ Θ(n²). → *Task 1b*
- [ ] Simplification rules:
    - Drop constants and lower-order terms: `4n + log n + 1 = Θ(n)`
    - `Θ(log nᶜ) = Θ(log n)` → so `3n·log(n³) + 100n = Θ(n log n)`
    - `√2^{log n} = n^{1/2} = √n` → so that term becomes `√n·log n`, which dominates → `Θ(√n log n)`
    → *Task 6*
- [ ] Reading complexity off **known** algorithms without re-deriving: heap sort = Θ(n log n), merge sort = Θ(n log n), inserting into a sorted array n times = Θ(n²) (shifting dominates the O(log n) search). → *Task 7*
- [ ] **Extra-memory** complexity (not counting the input): merge sort = Θ(n), binary search = Θ(1). For Dijkstra it's the dist table + priority queue. → *Task 8*

**Source material:** Labs *Cheatsheet for Exercises 1–3*; lecture sections on asymptotics and the summation/transformation rules.

**Practice:** redo Tasks 1, 6, 7, 8 **with the solutions covered**, then check.

---

## Phase 2 — Algorithm & data-structure recall table (≈2.5 hrs)

The exam rewards instant recall of standard costs. Build this table from memory, then verify against the lectures. Fill the blanks:

| Thing | Time (worst) | Extra memory | When to use |
|---|---|---|---|
| Binary search | O(log n) | O(1) | sorted array lookup |
| Merge sort | O(n log n) | O(n) | stable, guaranteed n log n |
| Heap sort | O(n log n) | O(1) | in-place n log n |
| Counting sort | O(n + k) | O(n + k) | small integer key range k |
| Radix sort | O(d·(n + k)) | O(n + k) | sort by digits/fields → *Task 3* |
| BFS / DFS | O(n + m) | O(n) | reachability, unweighted paths |
| Dijkstra (binary heap) | O((n + m) log n) | O(n + m) | non-negative weighted shortest path |
| Floyd–Warshall | O(n³) | O(n²) | all-pairs shortest path |
| AVL insert/find | O(log n) | — | balanced ordered set |
| Hash table | O(1) avg / O(n) worst | O(n) | fast unordered lookup |
| Find–union (rank + path compression) | O(α(n)) amortized | O(n) | merging disjoint sets → *Task 11* |

- [ ] Filled the whole table from memory
- [ ] Verified every row against the lectures
- [ ] Can explain *why* each memory figure holds (esp. Dijkstra: dist table = Θ(n), PQ holds up to m entries → with Θ(n²) edges, memory = Θ(n²)) → *Tasks 8c, 8d*

> [!warning] You flagged accuracy matters — double-check Dijkstra's bound in *your* lectures. Some courses state it as O(m log n) or O(m + n log n) with a Fibonacci heap. Use whatever convention the lecture used.

**Source material:** lecture sections on heaps, hashing, graphs; Labs *Cheatsheet 4–6*.

---

## Phase 3 — Recurrences & the Master Theorem (≈1.5 hrs)

- [ ] Write a recurrence from a recursive description: "4 recursive calls on size ⌈n/2⌉, combine in Θ(n²)" → `T(n) = 4T(⌈n/2⌉) + Θ(n²)`. → *Task 2*
- [ ] Apply the Master Theorem: compute `c = log_b a`, compare `f(n)` to `n^c`:
    - `f` smaller → `Θ(n^c)` (Case A)
    - `f = Θ(n^c)` → `Θ(n^c log n)` (Case B) ← Task 2 lands here: a=4, b=2, c=2, f=Θ(n²)=Θ(n²) → **Θ(n² log n)**
    - `f` larger → `Θ(f(n))` (Case C)
- [ ] Memorize the three cases without notes.

**Source material:** Labs *Cheatsheet 3 → "Master Theorem Lite"*.

**Practice:** redo Task 2; invent 2 more recurrences and classify them.

---

## Phase 4 — Dynamic programming & reasoning tasks (≈2.5 hrs)

**DP transform (memoized recursion → bottom-up table):**
- [ ] Identify the subproblem index (here `p`), the base cases, and the recurrence. Replace the dict + recursive calls with an array filled in order. → *Task 4*
- [ ] Practice the fill-in-the-blank DP: initialize the array (`dp = [n]*n` as "infinity"), set the base case, loop, take the `min`, return the answer. → *Task 12a*
- [ ] **Loop invariants:** state what `dp[j]` means for all `j < i` *before* iteration `i` runs. For Task 12 it's "min number of **jumps** to reach field j, or n if unreachable." Practice phrasing invariants precisely — jumps vs. moves, n vs. −1 for unreachable. → *Task 12b*

**P / NP / reductions (Task 13) — the conceptual heavy one:**
- [ ] Definitions: P, NP, NP-hard, NP-complete (= in NP **and** NP-hard).
- [ ] "A reduces to B in poly time" direction matters. **Anything in P reduces to anything** → so a P-problem (like reachability via BFS) reduces to everything.
- [ ] Show a problem is in NP by reducing it *to* a known NP problem (e.g. TSP). Show NP-hardness by reducing a known NP-complete problem (Hamiltonian Cycle) *to* it.
- [ ] We don't know if NP-complete problems are in P → so "is B in P?" and "does B reduce to A?" are **open**.

**Source material:** lecture sections on dynamic programming, NP-completeness, Hamiltonian cycle / TSP reductions.

---

## Phase 5 — Timed full mock + review (≈2 hrs)

- [ ] Do the entire practice exam **closed-book, timed** (use the real exam duration if you know it).
- [ ] Grade against the solutions. Log every miss below.
- [ ] For each miss, write one sentence: *what rule did I forget?* Re-study only those.

**Misses to revisit:**
-
-
-

---

## Quick-reference traps (read the morning of)

- Constant-count inner loops are O(1), not O(n). *(T1a)*
- BFS does **not** sort edges — Counting/Radix sort does, in O(n+m). *(T3)*
- Removing from the **front** of an array/list is Θ(n) (shifting); from the **back** is O(1) amortized. C++ beats Python by a constant, but asymptotics win for large n. *(T9)*
- Comparison sorting can't beat Ω(n log n) — so O(n·α(n)) is impossible. *(T10)*
- Find–union beats AVL/hash here because it manages *mergeable disjoint sets*, not individual keys. *(T11)*
- "In NP" ≠ "NP-complete" — you need both NP membership and NP-hardness. *(T13)*

---

> [!note] Next move
> Tell me your exam date to calendarize this, or say "quiz me on Phase 1" and I'll start drilling one question at a time.
