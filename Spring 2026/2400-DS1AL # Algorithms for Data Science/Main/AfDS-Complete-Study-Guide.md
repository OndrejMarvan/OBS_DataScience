---
tags: [afds, algorithms, compendium, complete]
---

# AfDS — Complete Course Compendium

Everything from the 10 lectures **and** the 6 seminar sheets (cheatsheets + exercises), in plain English. This is not filtered to the practice exam — it's the whole course. Use the headers to navigate.

**Contents**
1. Foundations & the machine model (L1)
2. Pseudocode & notation conventions (Seminar 1)
3. Math toolkit: asymptotics, growth rules, sums (Seminars 2–3)
4. Correctness: invariants, induction, termination (Seminar 1)
5. Running time & complexity analysis (L2–L4)
6. Divide & conquer + Master Theorem (L5, Seminar 3)
7. Searching & sorting (L5)
8. Dynamic programming + the 4-step recipe (L6, Seminar 4)
9. Dictionaries & data structures (L7, Seminar 5)
10. Graphs, networks & spatial search (L8, Seminar 6)
11. Limits of efficient computation (L9)
12. Gradient descent & neural-network training (L10)
13. Seminar problem-type catalogue
14. Practice-exam cross-reference & quick checklist

---

# 1. Foundations & the machine model (L1)

**What an algorithm is:** a *finite, unambiguous* sequence of steps that solves a problem. The course's running example is **binary search** for the ordered-search problem: halve the search range each step → `Θ(log n)`.

**Why hardware matters (silicon → Python).** Efficiency is treated as a *first-class design constraint*, not an afterthought. Key facts the lecture stresses:
- The **memory hierarchy** matters: reading from RAM costs ~100 ns, and **pointer-chasing** (data scattered in memory) is slow because it defeats the cache. Contiguous data is fast.
- `import numpy` "isn't magic" — NumPy is fast because it uses **SIMD** (one instruction processing a chunk of data at once) over contiguous arrays.
- This is why array layout (Section 9) and asymptotics (Section 3) both matter in practice.

**Two themes introduced here and used all course:** *algorithmic thinking* (divide & conquer) and *correctness* (prove your logic with invariants).

---

# 2. Pseudocode & notation conventions (Seminar 1)

These are course-specific — getting them wrong loses marks.

- `x++` means `x = x + 1`; `x--` means `x = x − 1`.
- `for i = 1 to n` runs with the **last iteration at i = n** (inclusive). Equivalent to `for i in range(1, n+1)` / `for(int i=1; i<=n; i++)`.
- `a[2..n]` declares an array with index positions **2 through n** — so it holds `n − 2 + 1 = n − 1` elements. (In pseudocode you may set the index range; Python/C++ always start at 0.)
- `a[2..n] = new array` (or "new array filled with 0s", or "new array of integers"). Default element type is integer.
- `b = a[i..j]` makes a **copy** of the subarray.
- Variables created inside a function are **automatically deleted** when it returns.
- `//`, `/* */`, `#` start comments. So `i = 2 // + 3` sets i to 2.
- Boolean shorthand: `if b` = `if b == True`; `if !b` = `if b == False`.
- **`log` always means `log₂`.** **"Running time" always means worst-case** unless stated otherwise.
- `log_b a` is the x with `bˣ = a`.

---

# 3. Math toolkit (Seminars 2–3)

## Asymptotic notation — formal definitions
- `f(n) = O(g(n))` if there are constants `C > 0, n₀ ≥ 0` with `f(n) ≤ C·g(n)` for all `n ≥ n₀`. (g is an **upper** bound.)
- `f(n) = Ω(g(n))` if `f(n) ≥ C·g(n)` for all `n ≥ n₀`. (g is a **lower** bound.) Equivalently, `f = Ω(g) ⇔ g = O(f)`.
- `f(n) = Θ(g(n))` if both hold (f and g are asymptotically equal).
- `f` is *asymptotically faster* than `g` if `g ≠ Ω(f)`.

> [!tip] The corridor picture
> `f = Θ(g)` means f eventually stays inside a corridor `C₂·g(n) ≤ f(n) ≤ C₁·g(n)`.

> [!warning] The mental flip
> "The **faster** an algorithm is, the **slower** its running time grows." Faster = less time = slower-growing curve.

## Simplification rule (only with finitely many terms)
1. Replace constant factors with 1.
2. Transform complicated terms to simpler equivalent forms.
3. Remove any term that grows slower than another.

Example: `Θ(9999 + 0.1·2ⁿ + 100·n²·n) = Θ(2ⁿ)`.

## The two growth-comparison rules
- **POL < EXP:** any polynomial grows slower than any exponential. For constants `a` and `b > 1`, eventually `nᵃ < bⁿ`. (e.g. `n¹⁰⁰ < 1.01ⁿ` for large n.)
- **LOG < POL:** any logarithm grows slower than any polynomial. For positive `a, b, c`, eventually `(log_b n)ᵃ < n^c` (and `a·log_b n < n^c`). (e.g. `log₂ n < n^{1/4}` for all `n ≥ 65537` — *not* obvious from small n!)

## Transformation rules (logs & exponents)
- `aᵇ·aᶜ = a^{b+c}` and `(aᵇ)ᶜ = a^{bc}`.
- `log_a(b·c) = log_a b + log_a c` and `log_a(bᶜ) = c·log_a b`.
- `a = b^{log_b a}` (definition of log).
- `Θ(log_a c) = Θ(log_b c) = Θ(log c)` for constant bases — **base doesn't matter for Θ**.
- Useful consequence: `2^{2 log₂ n} = (2^{log₂ n})² = n²`; `√2^{log n} = n^{1/2} = √n`.

## Summation rules
- First n integers: `1 + 2 + … + n = n(n+1)/2 = Θ(n²)`.
- Powers of two: `1 + 2 + 4 + … + 2ⁿ = 2^{n+1} − 1 = Θ(2ⁿ)`.

## Floor & ceiling
- `⌊x⌋` rounds **down** (`⌊1.5⌋ = 1`); `⌈x⌉` rounds **up** (`⌈1.5⌉ = 2`).

---

# 4. Correctness: invariants, induction, termination (Seminar 1)

## Loop invariant
A logical statement relating the variables that is **true at the start of every loop iteration** (when the condition is checked). A good invariant is both **true** and **helpful** (lets you conclude what you want when the loop exits).

**Two-step proof:**
1. It holds at the start of the first iteration.
2. If it holds at the start of an iteration, it still holds at the end (hence at the start of the next).

> [!example] Seminar example
> For `while i ≠ n: i++; j += 2; k += 3`, the invariant `2i = j` proves `j = 2n` at the end (since the loop exits when `i = n`). The same invariant is *useless* for proving `k = 3n` — invariants must be chosen to be helpful.
> There are infinitely many true invariants; pick the one that proves your goal. An invariant alone isn't enough — you also need **termination**.

## Induction
Invariants are a special case of **proof by induction**: prove a statement for the smallest value, then show "true for i ⇒ true for i+1." This chains to cover all values. (Example proven in seminar: `2⁰ + … + 2ⁱ = 2^{i+1} − 1`.)

## Termination
Show every loop stops: find a quantity that strictly decreases toward a bound (e.g. "`n − i` drops by 1 each step, so it reaches 0").

---

# 5. Running time & complexity analysis (L2–L4)

## Reading complexity off code
Count how many times the **dominating operation** runs as a function of n.
- A **constant-length** loop contributes `O(1)`, never a factor of n.
- An inner loop whose length **depends on the outer variable** → sum a series (use the summation rules).

> [!example] Practice exam Task 1
> Inner loop of fixed length 21 → `Θ(n)`. Inner loop length depending on x, summed → `Θ(n²)`.

## Memory (space) complexity
Count **extra** memory beyond the input. Merge sort `Θ(n)`; binary search `Θ(1)`; Dijkstra `Θ(n + m)` (Section 10).

## Simplifying a count to Θ
Apply the simplification rules from Section 3 (e.g. `4n + log n + 1 = Θ(n)`; `3n·log(n³) + 100n = Θ(n log n)`).

---

# 6. Divide & conquer + Master Theorem (L5, Seminar 3)

## The paradigm
**Split** into smaller independent subproblems, **solve** recursively, **combine**. Cost: `T(n) = a·T(n/b) + f(n)` (a subproblems, size n/b each, f to split+combine). A **recursion tree** sums the work level by level; the Master Theorem is a shortcut for that sum.

## Master Theorem (full)
Let `T(n) = a·T(n/b) + f(n)`, `a > 0, b > 1`, f nondecreasing, and `c = log_b a`:
- **Case A:** if `f(n) = O(n^{c′})` for some `c′ < c` → `T(n) = Θ(n^c)`.
- **Case B:** if `f(n) = Θ(n^c)` → `T(n) = Θ(n^c · log n)`.
- **Case C:** if `f(n) = Ω(n^{c′})` for some `c′ > c` → `T(n) = Θ(f(n))` (plus a regularity condition `a·f(n/b) ≤ k·f(n)`, `k < 1` — *not required to learn in this course*).

Floor/ceiling don't matter: `aT(⌊n/b⌋)` and `aT(⌈n/b⌉)` give the same solution as `aT(n/b)`.

## Master Theorem "Lite" (when f is a polynomial Θ(n^d))
Compute `c = log_b a`. Then compare d to c: `d < c` → Case A; `d = c` → Case B; `d > c` → Case C. (Regularity holds automatically.)

> [!example] Practice exam Task 2
> `T(n) = 4T(n/2) + Θ(n²)`: c = log₂4 = 2, d = 2 → Case B → `Θ(n² log n)`.

> [!warning] When NO case holds (Seminar 3)
> If f sits *between* the cases — e.g. f grows faster than `n^c` but not polynomially faster (no `c′ > c` works), like `f = n^c·log n` — then **no Master-Theorem case applies**. Fall back to a recursion tree or substitution.

## Karatsuba multiplication
Naive n-digit multiplication is `Θ(n²)`. Treat each number as a degree-1 polynomial and use **3 half-size multiplications instead of 4** (recover the middle term by subtraction):
`T(n) = 3T(n/2) + Θ(n)` → c = log₂3 ≈ 1.585, d = 1 → Case A → **`Θ(n^{log₂3}) ≈ Θ(n^{1.585})`**.

## Polynomial multiplication & FFT
Multiplying polynomials = **convolution** of coefficient vectors (mix by degree, *not* component-wise). Naive `Θ(n²)`; **FFT** methods reach `Θ(n log n)`, worth it only for large n. Practical pattern: small n → trivial algorithm, large n → Karatsuba/FFT past a threshold.

---

# 7. Searching & sorting (L5)

## Searching
- **Linear search** `Θ(n)`.
- **Binary search** on a sorted array `Θ(log n)`, `Θ(1)` extra space.

## Comparison sorts
| Sort | Worst time | Extra memory | Notes |
|---|---|---|---|
| Insertion | Θ(n²) | Θ(1) | fast on nearly-sorted |
| Merge | Θ(n log n) | Θ(n) | **stable**, predictable |
| Heap | Θ(n log n) | Θ(1) | in-place |
| Quick | Θ(n²) / avg Θ(n log n) | Θ(log n) | fast in practice |

**Stable** = equal keys keep their original relative order (needed for radix sort).

## Comparison lower bound
Any comparison-only sort needs **Ω(n log n)** comparisons worst case (n! orderings; each comparison halves them; `log₂(n!) ≈ n log n`). → so `O(n·α(n))` sorting is impossible (Task 10).

## Non-comparison sorts
- **Counting sort** — integer keys in `[0,k]`: `Θ(n + k)`, stable.
- **Radix sort** — sort by one digit/field at a time (least-significant first) with a stable counting sort: `Θ(d·(n + k))`.

> [!example] Practice exam Task 3
> Sort m edges by (source, then target) in O(n+m): two stable counting-sort passes — target first, source second. **Not** BFS.

---

# 8. Dynamic programming + the 4-step recipe (L6, Seminar 4)

## When DP applies
Problems that split into **overlapping subproblems** (the same subproblem recurs). Solve each once, store it.

## The course's 4-step recipe (Seminar 4 — memorize this)
**Step 1 — Backtracking.** Write a plain recursion (divide & conquer): a base case for small subproblems, otherwise recurse on smaller `k` and combine. Parameter `k` describes *which* subproblem.

**Step 2 — Memoization.** Add a global dictionary `mem`. Wrap the body in `if k not in mem: …`; replace every `return value` with `mem[k] = value`; at the end `return mem[k]`. Now each subproblem is computed once.

**Step 3 — Bottom-up DP.** Make it iterative:
1. Find the min/max values `k_min, k_max` of k (often 0 and n).
2. Replace the dictionary with an array `mem[k_min..k_max]`.
3. Add a loop `for k = k_min to k_max` (increasing order) that fills the array.
4. Drop the `if k not in mem` guard; replace recursive calls `Algo(k′)` with array reads `mem[k′]`; return `mem[k_max]`.

**Step 4 — Minimize space.** If `mem[k]` only depends on the last `c` entries (e.g. `mem[k] = mem[k−1] + mem[k−2]` → c = 3), shrink the array to size `c` and index with `mem[k % c]`. Space drops from `Θ(n)` to `Θ(c) = Θ(1)`.

> [!note] Multi-parameter states
> If a subproblem needs several parameters `(k₁,…,k_t)`, treat k as a tuple; the DP array becomes **t-dimensional** with t nested loops (order can matter). Pass the input by pointer + parameter k (or make it global) — never copy the array per call.

## Classic problems taught
**Fibonacci (warm-up).** Naive `Θ(φⁿ)` (recomputes); DP `Θ(n)` time, `Θ(1)` space with the modulo trick. *Caveat:* treating big-integer addition as O(1) is a simplification — Fₙ has Θ(n) bits.

**0/1 Knapsack.** `DP[k][m]` = best value from first k items within weight m:
`DP[k][m] = max(DP[k−1][m], vₖ + DP[k−1][m−wₖ])`. Time & space `Θ(nM)` (**pseudo-polynomial** — M can be huge vs input bits). A greedy choice does **not** work for 0/1 knapsack.

**Longest Common Subsequence (LCS).** A subsequence skips symbols but preserves order. `L[i][j]`:
`= L[i−1][j−1]+1` if `a[i]==b[j]`, else `max(L[i−1][j], L[i][j−1])`. `Θ(nm)`.

**Edit distance.** Min insert/delete/substitute to convert one string to another:
`D[i][j] = D[i−1][j−1]` if `a[i]==b[j]`, else `1 + min(D[i−1][j] delete, D[i][j−1] insert, D[i−1][j−1] substitute)`; base `D[i][0]=i, D[0][j]=j`. `Θ(nm)`.

**Max-subarray / "block of maximum total value."** Classic DP (Kadane-style): track the best sum ending at i. `Θ(n)`.

**Non-touching selection (Seminars).** Choose array cells (or grid cells) so no two are adjacent, maximizing total value — 1D version is `max(a[p] + DP[p−2], DP[p−1])` (exactly **Task 4**); the grid generalization uses a 2D state.

## Loop invariants in DP
State precisely what each cell means *for all earlier cells* before iteration i.

> [!example] Practice exam Task 12
> Invariant: "for `j < i`, `dp[j]` = min **jumps** to reach field j, or **n** if unreachable." Init `dp=[n]*n`, `dp[0]=0`, update `dp[i]=min(dp[i], dp[i-w]+1)`, return `dp[n-1] < 4`.

---

# 9. Dictionaries & data structures (L7, Seminar 5)

## The Dictionary ADT
Stores **key→value** pairs. **Invariant:** each key appears at most once (values may repeat). `Add(k,v)` overwrites if k exists, else inserts.

## Hash tables
An array + a **hash function** `h(k)` giving a position. Common form `h(k) = k mod p` (p = array size). `k mod p` = remainder of k/p = `k − p·⌊k/p⌋`.
- **Collision** — two keys hash to the same bucket.
- **Chaining** — each bucket holds a short linked list of its pairs (the default fix here).
- **Load factor** — items ÷ buckets; kept bounded so chains stay short → expected `O(1)` lookup; worst case `O(n)`.
- **Universal hashing** — choose h randomly from a family so no fixed input forces many collisions.
- Gives fast *unordered* lookup; **no sorted order**.

## Binary Search Tree (BST)
Each `node` has `key, value, left, right, parent` (NONE where absent; empty tree ⇒ `root == NONE`).
- **BST invariant:** for every node v, all keys in its left subtree are `< v.key`, all in its right subtree are `> v.key`.
- Operations cost `O(height)`: `O(log n)` if balanced, `O(n)` if degenerate.
- Seminar algorithms drilled: `FindMin(root)` (go left), `Add(root,k,v)`, `Successor(root,k)` (smallest key > k), `SortedOutput(root)` (**in-order traversal** prints keys sorted).

## AVL tree (balanced BST)
> [!important] Course-specific height convention
> **Height of a node** = number of nodes on the longest downward path **including v**. A leaf has height **1**; `NONE` is a virtual node of height **0**. (So a single node = height 1.) A tree is **balanced** if its height is `O(log n)`.

- **AVL invariant (simplified):** for every node, the heights of its two children differ by **at most 1** (with NONE counting as height 0).
- Therefore height is always `O(log n)` → all operations `O(log n)` guaranteed. Balance is restored after inserts/deletes by **rotations** (left/right). Red-black trees are an alternative balanced BST.

> [!example] Practice exam Task 5
> A height-3 BST on {40,10,30,20} that violates AVL: e.g. **root = 10, right child = 30, with 30's children 20 (left) and 40 (right)**. The longest path (10→30→20) has 3 nodes = height 3. At the root, the left child is NONE (height 0) and the right subtree has height 2 → differ by 2 → **the root is the violating node**. (A mirror image is the second valid answer.)

## Heaps (priority queues)
A heap is **not** a dictionary or BST. It's a **complete binary tree** (levels filled top-to-bottom, each level left-to-right). **Heap invariant:** every node's priority is `≥` its children's (max-heap) → root is the max. Duplicate priorities are allowed.
- `peek O(1)`, `insert/removeMax O(log n)`, `build-heap O(n)`. Powers heap sort and Dijkstra.

## Probabilistic structures
- **Bloom filter** — stores only bits for *approximate set membership*. Answers "possibly in set" / "definitely not": **false positives possible, false negatives never**. Tiny memory; used in networking/caches when an exact set is too big.
- **HyperLogLog** — estimates the **number of distinct items** (cardinality) in a stream using almost no memory.

## Similarity search
When exact equality isn't the point, hashing becomes a tool for *approximate similarity*:
- **Locality-Sensitive Hashing (LSH)** — hash functions that make *similar* items collide on purpose, so you can find near-duplicates fast.

## Trie
A tree keyed by **prefixes** (each edge a character); great for string lookup and autocomplete.

---

# 10. Graphs, networks & spatial search (L8, Seminar 6)

## Vocabulary (Seminar 6)
- `n` vertices (= nodes), `m` edges. **Path** = consecutive edges; its **length** = number of edges; its **cost/weight** = sum of edge weights.
- **Simple path** = no repeated vertices. **Cycle** = simple path returning to its start. **Tour** = a (not necessarily simple) closed walk that **visits all vertices**.
- **Connected** = every vertex reachable from every other. **Tree** = connected undirected graph with no cycles.
- **Subgraph** = subset of vertices+edges. **Spanning subgraph** of a connected graph = a connected subgraph containing *all* vertices; **minimal** if its total edge weight is least.
- Default assumption: graphs are undirected, unweighted, no parallel edges, no self-loops (unless stated).

## Representations
- **Adjacency matrix** — n×n; `Θ(n²)` space, O(1) edge check; good for dense graphs.
- **Adjacency list** — neighbours per vertex; `Θ(n+m)` space; good for sparse graphs (usual default).

## Traversals
- **BFS** — level by level with a **queue**; `Θ(n+m)`. Shortest paths in *unweighted* graphs, reachability.
- **DFS** — deep-first with recursion/a **stack**; `Θ(n+m)`. Cycle detection, connectivity, topological order, component discovery.

## Shortest paths
- **Dijkstra** — single-source, **non-negative** weights; greedy with a priority queue, relaxing edges. Time (binary heap) `O((n+m) log n)`; memory dist `Θ(n)` + PQ `Θ(m)`. Fails on negative weights.
- **Floyd–Warshall** — all-pairs via DP over allowed intermediate vertices; `Θ(n³)` time, `Θ(n²)` space; handles negative weights (no negative cycles).

> [!example] Practice-exam graph tasks
> T7b: Floyd–Warshall run n² times → Θ(n⁵). T8c/T8d: Dijkstra memory = dist Θ(n) + PQ Θ(m) → Θ(n) with O(n) edges, Θ(n²) with Θ(n²) edges.

## Minimum spanning tree (MST)
A spanning tree connecting all vertices with least total weight.
- **Kruskal** — sort edges by weight, add each if it doesn't form a cycle (cycle check via **find–union**). Cost dominated by the sort: `Θ(m log m) = Θ(m log n)`. "Connects a network cheaply, not quickly."
- **Prim** — grow one tree from a start vertex, repeatedly adding the cheapest edge leaving it (with a heap, `Θ(m log n)`).
- *Tree fact (proven in seminar):* removing one edge from each cycle until none remain always terminates and leaves a tree (n−1 edges, connected, acyclic).

## A* search
**Dijkstra plus a heuristic** estimating remaining distance to the goal, so search heads toward the target instead of spreading in all directions.

## Network analysis
Which vertices "matter"? **Centrality measures**: degree (how many neighbours), closeness (how near to all others), betweenness (how often on shortest paths). **PageRank** turns the link graph into importance scores.

## Spatial search
Organize geometry for fast nearest-neighbour queries:
- **k-d tree** — recursively splits space along coordinate axes; search **prunes** branches that can't contain the answer.
- **Ball tree** — groups points into nested balls; adapts better than k-d trees in high dimensions / non-axis-aligned data.
- **Voronoi cell** — the region closest to a given site; if the query is in site p's cell, p is its nearest neighbour.

---

# 11. Limits of efficient computation (L9)

## Decision problems
Yes/no questions, formally a "language" (the set of yes-instances).

## The classes
- **P** — solvable in polynomial time. (e.g. "is there a path s→t?" via BFS.)
- **NP** — a YES answer has a **certificate** checkable in polynomial time. (You may not *find* it fast, but you can *verify* a given one fast.)
- **NP-hard** — at least as hard as everything in NP.
- **NP-complete** — in NP **and** NP-hard: the hardest problems *inside* NP.

## Boolean Satisfiability (SAT)
"Is there a truth assignment making this formula true?" Certificate = the assignment. SAT was the **first** proven NP-complete problem (**Cook–Levin**); other hardness proofs reduce from it.

## Reductions
"**A reduces to B**" (`A ≤ₚ B`): transform A-instances into B-instances in poly time so a B-solver solves A → **A is no harder than B**.
- Prove **B ∈ NP**: reduce B to a known NP problem / give a poly verifier.
- Prove **B is NP-hard**: reduce a *known NP-complete* problem **to** B (direction: known-hard → your problem).
- **Anything in P reduces to almost anything** (solve it, output a fixed yes/no instance — needs B to have both a yes- and a no-instance).
- If one NP-complete problem turns out to be in P, then **all** of NP collapses into P (the open P-vs-NP question).

Classic NP-complete problems: SAT, 3-SAT, Hamiltonian Cycle, TSP (decision form), Knapsack (decision form), Clique, Vertex Cover, Independent Set.

> [!example] Practice exam Task 13
> A = "path s→t?" ∈ P (BFS). B = "tour of total weight exactly n?" is NP-complete (in NP as a TSP special case; NP-hard via Hamiltonian Cycle with unit weights). So **A reduces to B** (P reduces to anything); **B ∈ P? unknown**; **B reduces to A? unknown** — both hinge on P-vs-NP.

## Time hierarchy
"For every k, there's a problem solvable in polynomial time but **not** in `O(nᵏ)`." More time genuinely buys more computational power.

## Approximation algorithms
When a problem is NP-hard, aim for **provably close** instead of exact-and-fast.
- The **decision version is at least as hard as the optimization version**.
- **2-approximation for metric TSP via MST:** build an MST, do a DFS-style walk of it, shortcut repeated vertices. By the triangle inequality the tour costs **≤ 2·OPT**.
- Problems with efficient *exact* algorithms (no approximation needed): sorting, shortest paths, MST, bipartite matching, linear programming.

---

# 12. Gradient descent & neural-network training (L10)

*The most "data science", least "classical algorithms" lecture. Not on the practice exam, but it's course material.*

## The optimization view of ML
Training = **minimizing a loss function** `L(θ)` over parameters θ, using the training data. Nets can have millions/billions of parameters, so you *search* rather than solve analytically.

## Gradient = local slope
The **gradient** `∇L(θ)` points in the direction of steepest *increase* of the loss. To *decrease* loss, move in the **negative** gradient direction — locally the fastest way down.

## The update rule
`θ_{t+1} = θ_t − η·∇L(θ_t)`, where `η` (learning rate) is the step size. Repeat until the loss stops improving.
- η too large → overshoot/diverge; too small → painfully slow.

## Stochastic gradient descent (SGD)
Computing the gradient on the whole dataset each step is expensive. **SGD** estimates it from a small random **minibatch** (or one example) — noisier but far faster, and the noise can help escape bad regions.

## Practical training issues
Learning-rate tuning, getting stuck, slow/unstable convergence. The lecture frames the path "from linear models to neural networks" as the same optimization idea scaled up.

---

# 13. Seminar problem-type catalogue

The kinds of problems drilled in seminars (good for "short tests and the exam"):

- **Divide & conquer search:** the *coin-weighing* problem (find one light coin in k weighings → up to `3ᵏ` coins; ternary search + induction lower bound).
- **Unbounded binary search:** "Guess my number" with no upper bound → **doubling** to find a range, then binary search → `O(log n)`.
- **Bug-fixing + correctness:** the *divide-by-two* algorithm (spot the non-termination on odd n, fix it, prove with an invariant + termination argument).
- **Ordering functions by growth:** given several Θ-expressions, sort by growth using POL<EXP, LOG<POL, transformation rules; and timing estimates ("how big an input in T seconds at X ops/sec").
- **Definition proofs:** e.g. prove `f = Ω(g) ⇔ g = O(f)` straight from the definitions.
- **Computing square root / array Swap / rotate-by-k:** basic algorithm design + invariants.
- **Min-finding correctness:** prove a selection-style loop finds the minimum (invariant on the running minimum position).
- **Master Theorem edge cases:** including a recurrence where **no case holds**.
- **DP problems:** "smileys" matching (here/there arrays), **non-touching cell selection** (1D and grid 2D), **max-value subarray block** — all via the 4-step recipe.
- **BST algorithms:** FindMin, Add, Successor, in-order SortedOutput.
- **Graph proofs:** the tree/cycle-removal argument; constructing a graph where **Dijkstra is forced to be very slow** in the worst case.

---

# 14. Practice-exam cross-reference & quick checklist

| Task | Topic | Section |
|---|---|---|
| 1, 6, 7, 8 | complexity from code, simplification, memory | 3, 5 |
| 2 | recurrence + Master Theorem | 6 |
| 3 | counting/radix sort | 7 |
| 4, 12 | DP transform, invariant | 8 |
| 5 | BST/AVL (height convention!) | 9 |
| 7a | heap sort | 7 |
| 7b, 8c, 8d | Floyd–Warshall, Dijkstra memory | 10 |
| 9 | array memory layout | 1, 9 |
| 10 | comparison lower bound | 7 |
| 11 | find–union | 9 |
| 13 | P/NP, reductions | 11 |

**Quick checklist**
- `log = log₂`; "running time" = worst case; `for i=1 to n` includes i=n.
- Constant loop → O(1); dependent loop → sum a series; `1+…+n = Θ(n²)`, `1+…+2ⁿ = Θ(2ⁿ)`.
- POL < EXP; LOG < POL; `Θ(log_a c) = Θ(log c)`; `√2^{log n} = √n`.
- Master Theorem: `c = log_b a`; d<c→Θ(n^c), d=c→Θ(n^c log n), d>c→Θ(f). Karatsuba `3T(n/2)+Θ(n)=Θ(n^1.585)`. Some recurrences fit no case.
- Sort lower bound Ω(n log n); counting/radix beat it (Θ(n+k)); edge-sort = two counting sorts, not BFS.
- DP 4-step recipe (backtrack→memo→bottom-up→minimize space, mod c). Knapsack Θ(nM); LCS/edit-distance Θ(nm); Fibonacci Θ(n).
- **Height counts nodes** (leaf = 1, NONE = 0); AVL children differ by ≤1; all ops O(log n).
- Hash: h(k)=k mod p, chaining, bounded load factor → O(1) avg. Bloom = no false negatives. HyperLogLog = distinct count. LSH = similarity.
- BFS/DFS Θ(n+m); Dijkstra O((n+m) log n), mem dist Θ(n)+PQ Θ(m); Floyd–Warshall Θ(n³)/Θ(n²); Kruskal Θ(m log n) with find–union; A* = Dijkstra + heuristic.
- Find–union O(α(n)), Θ(n) memory.
- P (solve) ⊆ NP (verify); NP-complete = NP + NP-hard; reduce known-hard *into* your problem; SAT first NP-complete; P reduces to everything; "unknown" answers come from P-vs-NP. Metric TSP has a 2-approx via MST.
- Gradient descent: θ ← θ − η∇L(θ); SGD = minibatch estimate.

> [!warning] Verify against your own lectures
> Dijkstra's bound (binary vs Fibonacci heap) and any figure your lecturer stated differently — trust the lecture for the exam. The height convention above is taken from your Seminar 5 cheatsheet.
