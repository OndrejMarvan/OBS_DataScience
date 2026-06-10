---
tags: [afds, exam-prep, algorithms, study-guide]
---

# AfDS — Complete Study Guide (plain English)

This covers everything on the practice exam, explained from scratch. For each topic: the **intuition** first, then the **facts you must know**, a **worked example** (usually a real exam task), and the **traps**. Read it top to bottom once; then use the headers to revise.

> [!note] How to read this
> If a sentence uses a word you don't know, it's defined the first time it appears. Nothing here assumes you understood the lecture notes — start fresh.

---

# 1. Asymptotic notation & complexity analysis

## The idea
We want to compare algorithms **without caring about the exact computer or the exact constants**. A program might run 5n steps on one laptop and 50n on another, but both grow *linearly* with n. Asymptotic notation throws away the constant (the 5 or the 50) and the small stuff, and keeps only **how the running time grows as the input n gets large**.

## The three symbols
Think of them as comparing your function `f(n)` to a reference function `g(n)`:

- **O(g)** — "grows *no faster than* g." An **upper** bound. `f = O(g)` means: for large n, `f(n) ≤ c·g(n)` for some constant c.
- **Ω(g)** — "grows *no slower than* g." A **lower** bound.
- **Θ(g)** — "grows *exactly like* g" (both an upper and a lower bound at once). This is the tightest, most informative one, and the one the exam usually asks for.

> [!tip] Plain-English version
> O = "at most", Ω = "at least", Θ = "exactly, up to constants". When the exam says "give the complexity in Θ notation," it wants the tight answer.

## The two rules that do 90% of the work
1. **Drop constant factors.** `5n` and `100n` are both `Θ(n)`.
2. **Keep only the fastest-growing term.** `n² + 1000n + 50` is `Θ(n²)`, because for large n the `n²` dwarfs everything else.

## Growth ordering (memorize this ladder)
From slowest-growing (best) to fastest-growing (worst):

```
1  <  log n  <  √n  <  n  <  n log n  <  n²  <  n³  <  2ⁿ  <  n!
```

When you have a sum of terms, the answer is the rightmost (biggest) one on this ladder.

## Reading complexity off code
The method is always: **count how many times the "dominating operation" runs**, as a function of n.

- A loop `for x = 1 to n` runs **n** times → factor of n.
- A loop whose length is a **constant** contributes O(1), *not* n. This is the classic trap.

> [!example] Task 1a
> ```
> for x = 1 to n:
>     for y = x-10 to x+10:   # this inner loop runs 21 times — ALWAYS
>         a = a + 1
> ```
> The inner loop runs `(x+10) − (x−10) + 1 = 21` times no matter what x is. 21 is a constant. So total work = n × 21 = **Θ(n)**, not Θ(n²).

- When the inner loop's length **depends on the outer variable**, you have to add up a series.

> [!example] Task 1b
> ```
> for x = 1 to 10n:
>     y = 10n
>     while y ≥ x: y = y - 1   # runs about (10n - x + 1) times
> ```
> Total = Σ (10n − x + 1) for x from 1 to 10n. That's an arithmetic series summing to ≈ (10n)²/2 = **Θ(n²)**.
>
> Useful fact: `1 + 2 + ... + k = k(k+1)/2 = Θ(k²)`.

## Logarithm rules (they show up constantly)
- `log(nᶜ) = c·log n` → the power becomes a constant multiplier → `Θ(log nᶜ) = Θ(log n)`.
- The base of the log doesn't matter for Θ (different bases differ by a constant). `log₂ n`, `log₁₀ n`, `ln n` are all `Θ(log n)`.
- A sneaky one from Task 6: `√2^{log n} = (2^{1/2})^{log n} = 2^{(log n)/2} = (2^{log n})^{1/2} = n^{1/2} = √n`.

> [!example] Task 6 worked
> - `4n + log n + 1` → biggest term is `4n` → **Θ(n)**
> - `3n·log(n³) + 100n` → `log(n³)=3 log n`, so first term is `9n log n` → **Θ(n log n)**
> - `10 log₁₀ n + √n/100 + √2^{log n}·log n` → last term is `√n·log n`, which beats `√n` and `log n` → **Θ(√n log n)**

## Memory (space) complexity
Same notation, but counting **extra memory used beyond the input**. The exam says "not counting the memory for the input."

- Merge sort needs a temporary array of size n to merge → **Θ(n)** extra. (*Task 8a*)
- Binary search just keeps a couple of index variables → **Θ(1)** extra. (*Task 8b*)

> [!warning] Traps in this section
> - Constant-length loops do **not** add a factor of n.
> - "Worst case" means the input that makes the algorithm slowest — analyze that one.
> - Θ wants the *tight* answer; don't write O(n²) when Θ(n) is true.

---

# 2. Recurrences & the Master Theorem

## The idea
A **recurrence** is a formula for the running time of a *recursive* algorithm: it describes the time for input size n in terms of the time for smaller inputs. Example: merge sort splits into two halves and merges them, so `T(n) = 2·T(n/2) + (cost to merge)`.

## The standard form
```
T(n) = a · T(n/b) + f(n)
```
- **a** = how many recursive calls (subproblems) you make.
- **n/b** = the size of each subproblem (b = the shrink factor).
- **f(n)** = the extra work to split the input and combine the results (everything outside the recursive calls).

## The Master Theorem
Compute `c = log_b(a)`. Then compare the work `f(n)` against `n^c`:

| Case | Condition | Answer | Who dominates |
|---|---|---|---|
| A (1) | `f(n)` grows **slower** than `n^c` | `Θ(n^c)` | the many leaves |
| B (2) | `f(n) = Θ(n^c)` | `Θ(n^c · log n)` | balanced |
| C (3) | `f(n)` grows **faster** than `n^c` | `Θ(f(n))` | the top split/combine |

> [!example] Task 2 worked
> "Four recursive calls, each on size ⌈n/2⌉, then combine in Θ(n²)."
> → `T(n) = 4·T(n/2) + Θ(n²)`. So `a=4, b=2, f(n)=Θ(n²)`.
> `c = log₂(4) = 2`. Compare `f(n)=Θ(n²)` with `n^c = n²` → they're equal → **Case B**.
> Answer: `Θ(n^c · log n) = ` **`Θ(n² log n)`**.

> [!example] Sanity check with merge sort
> `T(n) = 2T(n/2) + Θ(n)`: a=2, b=2, c=log₂2=1, f=Θ(n)=n¹ → Case B → `Θ(n log n)`. ✓ (matches the known cost of merge sort)

> [!warning] Trap
> Compute `c = log_b a`, **not** `a/b`. And compare against `n^c`, not against `f` directly without simplifying.

---

# 3. Searching & sorting

## Searching
- **Linear search** — check elements one by one. `Θ(n)` worst case, no special requirement.
- **Binary search** — on a **sorted** array, repeatedly halve the search range. `Θ(log n)`, `Θ(1)` extra memory. Halving is where the log comes from.

## Comparison sorts (they compare pairs of elements)
| Sort | Time (worst) | Extra memory | Notes |
|---|---|---|---|
| Insertion sort | Θ(n²) | Θ(1) | fast on nearly-sorted input |
| Merge sort | Θ(n log n) | Θ(n) | **stable**, predictable |
| Heap sort | Θ(n log n) | Θ(1) | in-place; build a heap, pop the max n times |
| Quicksort | Θ(n²) worst, Θ(n log n) avg | Θ(log n) | fast in practice |

> [!example] Task 7a
> ```
> J = make_heap(a)
> for p = n down to 1: J.removeMax()
> ```
> This *is* heap sort → **Θ(n log n)**.

> [!example] Task 7c
> Inserting each of n elements into a sorted array, keeping it sorted:
> finding the spot is `O(log n)` (binary search), but **shifting** elements to make room is `Θ(n)` per insert. Shifting dominates → **Θ(n²)**.

## The comparison-sort lower bound
**Any sort that only compares elements needs Ω(n log n) comparisons in the worst case.** Intuition: there are `n!` possible orderings, each comparison has 2 outcomes, so you need at least `log₂(n!) ≈ n log n` comparisons to distinguish them all.

> [!example] Task 10
> "Can we sort with `O(n·α(n))` comparisons?" Since `α(n)` (inverse Ackermann) grows *far* slower than `log n`, `n·α(n)` is below the `Ω(n log n)` floor. So **no** — it's impossible.

## Non-comparison sorts (they beat n log n by NOT comparing)
- **Counting sort** — for integer keys in a small range `[0, k]`: count how many of each value, then place them. `Θ(n + k)` time and memory. **Stable** if implemented carefully.
- **Radix sort** — sort by one digit/field at a time, least-significant first, using a *stable* sort (counting sort) each pass. `Θ(d·(n + k))` for d digits.

> [!example] Task 3 worked
> Sort m directed edges by `(source, then target)`, both in range `0..n−1`, in `O(n + m)`.
> **Do two counting-sort passes:** first sort by *target*, then by *source*. Because counting sort is stable, the second pass keeps the target-order intact within each source. Each pass is `O(n + m)` → total `O(n + m)`.
> Using BFS here is **wrong** even though it's also `O(n+m)` — it doesn't produce this sorted order.

> [!tip] Why "stable" matters
> A sort is **stable** if equal keys keep their original relative order. Radix sort breaks without it: the earlier passes' work would get scrambled.

---

# 4. Data structures

## Memory layout: why front-removal is slow
An array (Python `list`, C++ `vector`) is one **contiguous block** in memory. The list object just stores *where the block starts* and *how many elements* it has.

- Remove the **last** element → just decrease the count → `O(1)` amortized.
- Remove the **first** element → you must shift *every* other element one step left → `Θ(n)`.

> [!example] Task 9 worked
> - Removing from the front n/2 times → `Θ(n²)` (shifting each time).
> - Removing from the back n/2 times → `Θ(n)`.
> - C++ is faster than equivalent Python by a *constant* factor, but for large n the **asymptotics win**. So the order (fastest→slowest) is: D (back, C++) < B (back, Python) < C (front, C++) < A (front, Python).

> [!note] "Amortized" means
> Averaged over many operations. A dynamic array occasionally doubles its capacity (an `O(n)` copy), but spread across all the cheap appends, each append averages `O(1)`. That average is the *amortized* cost.

## Stacks & queues
- **Stack** — LIFO (last in, first out). Push/pop at one end. Like a stack of plates.
- **Queue** — FIFO (first in, first out). Add at back, remove at front. Like a line at a shop.

## Heap / priority queue
A **heap** is a complete binary tree stored in an array where every parent is ≥ its children (max-heap) or ≤ (min-heap). It gives you the max (or min) instantly.
- `peek` (see max): `O(1)`
- `insert`: `O(log n)`
- `removeMax`: `O(log n)`
- `build heap` from an array: `O(n)` (surprisingly — not n log n)

Used inside heap sort and Dijkstra.

## Binary Search Tree (BST) and AVL
- **BST** — each node's left subtree holds smaller keys, right subtree holds larger keys. Search/insert costs `O(height)`. If balanced, height is `O(log n)`; if it degenerates into a line, height is `O(n)`.
- **AVL tree** — a BST that **keeps itself balanced**: for every node, the heights of its left and right subtrees differ by at most 1. It does small "rotations" after inserts to restore this. Result: height is always `O(log n)`, so **every operation is `O(log n)` guaranteed**.

> [!example] Task 5
> "Draw a BST of height 3 with keys 40,10,30,20 that is **not** AVL." A chain like 40→10→30→20 (or 40→30→10→20) has height 3 and a node whose two subtrees differ in height by more than 1 — mark that node as the AVL violator.

> [!example] Task 8d
> Inserting `100n²` elements into an AVL tree: it always holds between n and ~100n² elements, and `log(100n²) = Θ(log n)`. So each insert is `Θ(log n)`, and there are `Θ(n²)` of them → **Θ(n² log n)**.

## Hash table
Maps keys to array "buckets" using a **hash function**. Average lookup/insert is `O(1)`; worst case is `O(n)` if many keys collide into the same bucket. Great for unordered fast lookup; no ordering.

## Find–union (disjoint-set / union-find)
Maintains a collection of **disjoint sets** that you can **merge**. Three operations:
- `Init(n)` — start with n separate singleton sets.
- `Find(x)` — return an ID of the set containing x.
- `Union(x, y)` — merge the two sets.

With the optimizations **union by rank + path compression**, each operation is `O(α(n))` amortized — `α` is the inverse Ackermann function, which is `≤ 4` for any n you'll ever see. So: **basically constant time**, and `Θ(n)` total memory.

> [!example] Task 11 (the bacteria problem)
> Bacteria merge when they meet; you must answer "are bacteria i and j now part of the same blob?" → **find–union**. `Init(n)`, call `Union(i,j)` on each merge, and answer a query by checking `Find(i) == Find(j)`. It beats AVL/hash/etc. because those manage *individual keys*, while find–union is the only one built for *merging sets*.

---

# 5. Dynamic programming (DP)

## The idea
Some problems break into **smaller subproblems that overlap** (the same subproblem comes up again and again). DP solves each subproblem **once** and stores the answer, instead of recomputing it. Two styles:

- **Top-down (memoization)** — write the natural recursion, but cache each result in a dictionary/array so you never recompute.
- **Bottom-up (tabulation)** — figure out the order subproblems depend on each other, then fill a table from the smallest up.

## Transforming memoized recursion → bottom-up
This is a common exam task. The recipe:
1. Find the variable that indexes the subproblems (often `p` or `i`).
2. Write the **base cases** into the table directly.
3. Translate the recursive formula into a loop that fills the table **in dependency order** (so each entry's dependencies are already filled).

> [!example] Task 4 worked
> The recursion computes `max(a[p] + f(p−2), f(p−1))` with base 0 for `p < 2`. Bottom-up:
> ```
> DP[0] = 0; DP[1] = 0
> for p = 2 to n:
>     DP[p] = max(a[p] + DP[p-2], DP[p-1])
> return DP[n]
> ```
> (This is the classic "pick non-adjacent items to maximize the sum" pattern.)

## Loop invariants
A **loop invariant** is a statement that is true **before and after every iteration** of a loop. You use it to argue the algorithm is correct. The skill is stating it *precisely*.

> [!example] Task 12
> For the jump problem, the invariant is: *"For every `j < i`, `dp[j]` is the minimum number of **jumps** needed to reach field j, or `n` if field j is unreachable."*
> Notice the precision: it's **jumps** (not all moves), and unreachable is marked with **`n`** (not `−1`). Getting these two details right is the whole question (answer A).
> The fill pattern: initialize `dp = [n]*n` (meaning "infinity"), set `dp[0]=0`, walk forward, and take `dp[i] = min(dp[i], dp[i-w]+1)` when a jump is possible. Return `dp[n-1] < 4` (reachable in ≤ 3 jumps).

> [!tip] Reading DP fill-in-the-blank questions
> Decide first: what does each cell *mean*? What's "infinity" here (`n`? `-1`?)? Then the initialization, the update, and the return all follow from that meaning.

---

# 6. Graphs

## Vocabulary
A graph has **n vertices** (nodes) and **m edges** (connections). Edges can be **directed** (one-way) or **undirected**, and **weighted** (each edge has a cost) or not.

## Two ways to store a graph
- **Adjacency matrix** — an n×n grid; cell `[i][j]` says whether/how i connects to j. Space `Θ(n²)`. Checking one edge is `O(1)`. Good for dense graphs.
- **Adjacency list** — for each vertex, a list of its neighbors. Space `Θ(n + m)`. Good for **sparse** graphs (few edges). This is the usual default.

## BFS — Breadth-First Search
Explore the graph **level by level** using a **queue** (FIFO). Visit all neighbors, then their neighbors, etc.
- Time: `Θ(n + m)`. 
- Use it for: reachability ("is there a path s→t?") and **shortest paths in unweighted graphs** (fewest edges).

## DFS — Depth-First Search
Go as **deep** as possible before backtracking, using recursion or a **stack** (LIFO).
- Time: `Θ(n + m)`.
- Use it for: cycle detection, connectivity, topological sort.

## Dijkstra — shortest path with weights
Single-source shortest paths in a graph with **non-negative** edge weights. Greedy: repeatedly take the closest unfinished vertex (using a priority queue) and relax its edges.
- Time with a binary heap: `O((n + m) log n)`.
- Memory: the `dist` array is `Θ(n)`; the priority queue can hold up to `Θ(m)` entries.
- **Fails with negative edge weights.**

> [!example] Tasks 8c / 8d
> Dijkstra's memory = `dist` table (`Θ(n)`) + priority queue (`Θ(m)`).
> - With `O(n)` edges → `Θ(n)` memory.
> - With `Θ(n²)` edges → the queue dominates → `Θ(n²)` memory.

> [!warning] Convention check
> Your lectures may state Dijkstra's time as `O(m log n)` or `O((m+n) log n)` (binary heap) or `O(m + n log n)` (Fibonacci heap). Use whichever the lecture used — they agree up to which heap is assumed.

## Floyd–Warshall — all-pairs shortest paths
Computes the shortest path between **every** pair of vertices, using DP over "allowed intermediate vertices."
- Time: `Θ(n³)`. Memory: `Θ(n²)`.
- Handles **negative** weights (but not negative cycles).

> [!example] Task 7b
> Running Floyd–Warshall inside a double loop (`n²` times), each call `Θ(n³)` → **Θ(n⁵)**.

---

# 7. Complexity classes: P, NP, NP-hard, NP-complete

## Decision problems
These classes are about **decision problems** — questions with a yes/no answer (e.g. "is there a path from s to t?").

## The classes in plain English
- **P** — problems you can **solve** in polynomial time (fast). Example: "is there a path s→t?" — solve with BFS → P.
- **NP** — problems where, if the answer is "yes," someone can hand you a **certificate** (a proposed solution) that you can **check** in polynomial time. You might not be able to *find* the answer fast, but you can *verify* a given one fast.
- **NP-hard** — **at least as hard as every problem in NP**. Formally: every NP problem reduces to it. (It need not be in NP itself.)
- **NP-complete** — the sweet spot: **in NP _and_ NP-hard**. These are the hardest problems *inside* NP. Examples: Travelling Salesman (TSP), Hamiltonian Cycle.

## Polynomial-time reduction
"**A reduces to B**" (written `A ≤ₚ B`) means: you can transform any instance of A into an instance of B in polynomial time, so that a solver for B also solves A. Reading: **A is no harder than B**.

How reductions are used:
- To prove **B is in NP**: give a poly-time verifier, or reduce B *to* a known NP problem (e.g. show B is a special case of TSP).
- To prove **B is NP-hard**: reduce a known **NP-complete** problem *to* B (e.g. reduce Hamiltonian Cycle to B). Direction matters: known-hard → your problem.
- **NP-complete = in NP + NP-hard.**

## The one weird fact you need for Task 13
**Any problem in P reduces (in poly time) to essentially any other problem.** Why: if you can *solve* A quickly, your "reduction" can just solve A and then output a fixed yes-instance or no-instance of B accordingly. (Tiny caveat: B must have at least one yes-instance and one no-instance.) So a P-problem reduces to everything — including hard problems.

> [!example] Task 13 worked (A = "path s→t?", B = "tour with total weight exactly n?")
> - **A is in P** — solve with BFS. ✓
> - **A reduces to B** — since A is in P, it reduces to anything. ✓
> - **B is NP-complete** — it's in NP (special case of TSP with cost threshold n) *and* NP-hard (reduce Hamiltonian Cycle to it by setting all edge weights to 1).
> - **Is B in P? — unknown.** That's exactly the open P-vs-NP question, since B is NP-complete.
> - **Does B reduce to A? — unknown.** If it did, then (A∈P) would force B∈P — again the open question. So this is *unknown*, not false.

> [!warning] The classic confusions
> - "In NP" does **not** mean "NP-complete." Easy problems (all of P) are also in NP.
> - Reduction direction: to prove *your* problem is hard, reduce a *known-hard* problem **into** it, not the other way.
> - "Unknown" answers on Task 13 come from P vs NP being open — they're a real answer, not a cop-out.

---

# 8. One-page mental checklist (read the morning of)

- Constant-length loop → `O(1)`, never a factor of n. *(T1a)*
- Dependent inner loop → sum a series; `1+...+k = Θ(k²)`. *(T1b)*
- `log(nᶜ)=Θ(log n)`; `√2^{log n}=√n`; keep the biggest term. *(T6)*
- Master Theorem: `c=log_b a`; equal → `Θ(n^c log n)`. *(T2)*
- Sort edges in O(n+m) → two stable counting sorts (radix), **not** BFS. *(T3)*
- Comparison sorting floor is `Ω(n log n)` → `n·α(n)` impossible. *(T10)*
- Front-removal = `Θ(n)`; back-removal = `O(1)`; asymptotics beat the C++/Python constant. *(T9)*
- Heap sort `Θ(n log n)`; merge sort extra memory `Θ(n)`; binary search extra `Θ(1)`. *(T7, T8)*
- Dijkstra memory = dist `Θ(n)` + PQ `Θ(m)`. *(T8c, T8d)*
- Floyd–Warshall `Θ(n³)` time, `Θ(n²)` space. *(T7b)*
- Mergeable sets → find–union, `O(α(n))`, `Θ(n)` memory. *(T11)*
- DP: define what a cell *means* → init, update, return all follow. State invariants precisely. *(T4, T12)*
- NP-complete = in NP + NP-hard; P reduces to everything; P-vs-NP makes some answers "unknown." *(T13)*
