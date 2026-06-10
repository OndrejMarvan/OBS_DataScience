---
tags: [afds, algorithms, compendium, verified]
---

# AfDS — Complete Course Compendium (verified edition)

Everything from the 10 lectures **and** 6 seminar sheets, in plain English, with facts checked against the actual lecture text. Not filtered to the practice exam — this is the whole course. Course-specific conventions and worked examples are marked.

**Contents:** 1 Foundations · 2 Conventions · 3 Math toolkit · 4 Correctness · 5 Complexity analysis · 6 Divide & conquer · 7 Sorting · 8 Dynamic programming · 9 Data structures · 10 Graphs · 11 Limits of computation · 12 Gradient descent · 13 Seminar problems · 14 Cross-reference & checklist

---

# 1. Foundations & the machine model (L1)

**Computational problem** = a set of allowed inputs (instances) + the correct output required for each. **Algorithm** = a finite, unambiguous sequence of steps that takes a valid input, produces the correct output, and **terminates** after finitely many steps.

Running example — the **ordered-search problem**: given a nondecreasing array `a[0..n−1]` and target `v`, return the smallest `i` with `v ≤ a[i]`, or `n` if none. Solved by linear search (scan) or **binary search** (halve the range → `Θ(log n)`).

**Why hardware matters (silicon → Python).** Efficiency is a first-class design constraint:
- **Memory hierarchy:** RAM access ~100 ns; **pointer-chasing** (scattered data) defeats the cache and is slow. Contiguous data is fast.
- `import numpy` "isn't magic" — it's fast because of **SIMD** (one instruction over a contiguous chunk).

Two themes that recur all course: **algorithmic thinking** (divide & conquer) and **correctness** (prove logic with invariants).

---

# 2. Pseudocode & notation conventions (Seminar 1)

- `x++` = `x = x+1`; `x--` = `x = x−1`.
- `for i = 1 to n` includes the last iteration **i = n** (= `range(1,n+1)` = `for(i=1;i<=n;i++)`).
- `a[2..n]` = array with index positions 2…n → holds `n−1` elements. (Pseudocode lets you set the index range; Python/C++ start at 0.)
- `a[2..n] = new array` ("filled with 0s" / "of integers"; default type integer).
- `b = a[i..j]` makes a **copy** of the subarray.
- Variables created in a function are **auto-deleted** on return.
- `//`, `/* */`, `#` start comments (`i = 2 // + 3` sets i = 2).
- `if b` = `if b==True`; `if !b` = `if b==False`.
- **`log` always means `log₂`.** **"Running time" = worst case** unless stated. `log_b a` = the x with `bˣ = a`.

---

# 3. Math toolkit (Seminars 2–3)

## Asymptotic notation — definitions
- `f = O(g)`: ∃ `C>0, n₀` with `f(n) ≤ C·g(n)` for all `n ≥ n₀` (g = **upper** bound).
- `f = Ω(g)`: `f(n) ≥ C·g(n)` for large n (g = **lower** bound). Equivalently `f = Ω(g) ⇔ g = O(f)`.
- `f = Θ(g)`: both hold (asymptotically equal). The **corridor** picture: `C₂·g ≤ f ≤ C₁·g`.
- `f` is *asymptotically faster* than `g` if `g ≠ Ω(f)`.

> [!warning] Asymptotic "=" is directional
> `f = O(g)` does **not** imply `g = O(f)`. Example: `n = O(n²)` but `n² ≠ O(n)`. (Unlike ordinary equality, which is bidirectional.)

> [!tip] The mental flip
> "The **faster** an algorithm is, the **slower** its running time grows."

## Simplification rule (finitely many terms only)
Replace constant factors with 1; simplify terms; drop any term that grows slower than another.
Example: `Θ(9999 + 0.1·2ⁿ + 100·n³) = Θ(2ⁿ)`.

## Growth-comparison rules
- **POL < EXP:** any polynomial < any exponential eventually. For constants `a, b>1`: eventually `nᵃ < bⁿ` (e.g. `n¹⁰⁰ < 1.01ⁿ`).
- **LOG < POL:** any log < any polynomial eventually. For positive `a,b,c`: `(log_b n)ᵃ < n^c` (e.g. `log₂ n < n^{1/4}` only from `n ≥ 65537` — *not* visible at small n!).

## Transformation rules
- `aᵇ·aᶜ = a^{b+c}`, `(aᵇ)ᶜ = a^{bc}`.
- `log_a(bc) = log_a b + log_a c`, `log_a(bᶜ) = c·log_a b`.
- `a = b^{log_b a}`; `Θ(log_a c) = Θ(log c)` (base-free).
- Consequences: `2^{2 log₂ n} = n²`; `√2^{log n} = √n`.

## Summation rules
- `1 + 2 + … + n = n(n+1)/2 = Θ(n²)`.
- `1 + 2 + 4 + … + 2ⁿ = 2^{n+1} − 1 = Θ(2ⁿ)`.

## Floor / ceiling
`⌊1.5⌋ = 1` (round down), `⌈1.5⌉ = 2` (round up).

---

# 4. Correctness: invariants, induction, termination (Seminar 1)

**Loop invariant** — a statement relating the variables, true at the start of every iteration (when the condition is checked). Must be **true** and **helpful**. Proof:
1. Holds at the start of the first iteration.
2. If it holds at an iteration's start, it holds at its end (⇒ at the next start).

> [!example] Seminar
> For `while i≠n: i++; j+=2; k+=3`, invariant `2i = j` proves `j = 2n` at exit (loop ends at `i=n`). It's *useless* for `k = 3n` — invariants must be chosen to help.

**Induction** — invariants are a special case. Prove for the smallest value, then "true for i ⇒ true for i+1." **Termination** — find a quantity that strictly decreases toward a bound (e.g. `n−i` drops by 1 each step → reaches 0).

---

# 5. Running time & complexity analysis (L2–L4)

## Case analysis
For fixed input size n, many instances exist. **Best / average / worst case.** Linear search: best 0 iterations (`a[0]=v`), average ≈ n/2, worst n (`a[n−1]<v`). Course convention: **worst case** unless stated. (A bad worst case can still behave well on real data.)

## The analysis model
We don't count raw RAM ops (cumbersome) nor wall-clock time (technology-dependent). We use **weighted high-level operations** — each high-level op gets a weight proportional to RAM effort — accepting **bounded distortion** (∃ `c₁,c₂`: `c₁ ≤ f(n)/g(n) ≤ c₂`), then keep only **dominating operations**. Then drop constants (asymptotics): `n` and `2n` differ only by a constant → asymptotically equal.

> [!example] "Binary Search & Destroy"
> Binary search then `a.pop(l)`: cost `log₂n + n` → dominated by the `pop` → `Θ(n)`.

## Two techniques + memory
For running time, the lecture names **counting** and **cumulative sums**. **Memory complexity** = number of cells (values stored simultaneously), as a function of n.

Worked examples:
- *Sum first half*: `Θ(n)` time, `Θ(1)` space.
- *Prefix-sum array* `b[1..n]`: `Θ(n)` time, `Θ(n)` space.

## The sandwich method (proving Θ)
Bound from both sides. For `f(n) = 10n + n²`: `n² ≤ 10n+n² ≤ 11n²` ⇒ `Ω(n²)` and `O(n²)` ⇒ **`Θ(n²)`**.

## Two-parameter analysis
When the input has two independent sizes (e.g. `a[0..k−1]`, `b[0..m−1]`, `n = k+m`), keeping **both** k and m is often more informative than collapsing to n.

> [!example] Practice exam Task 1/6
> Constant-length inner loop → `Θ(n)`; dependent inner loop → sum a series → `Θ(n²)`; simplify counts via the rules (`4n+log n+1 = Θ(n)`, etc.).

---

# 6. Divide & conquer + Master Theorem (L5, Seminar 3)

**Paradigm:** split into independent subproblems, solve recursively, combine → `T(n) = a·T(n/b) + f(n)`. A **recursion tree** sums work level by level; the Master Theorem is a shortcut.

## Master Theorem (full)
`c = log_b a`:
- **Case A:** `f = O(n^{c′})`, `c′ < c` → `Θ(n^c)`.
- **Case B:** `f = Θ(n^c)` → `Θ(n^c log n)`.
- **Case C:** `f = Ω(n^{c′})`, `c′ > c` → `Θ(f(n))` (+ regularity `a·f(n/b) ≤ k·f(n)`, `k<1` — *not required to learn here*).
- Floor/ceiling don't change the answer: `aT(⌊n/b⌋) = aT(⌈n/b⌉) = aT(n/b)`.

## Master Theorem "Lite" (f = Θ(n^d))
`d < c` → A; `d = c` → B; `d > c` → C.

> [!example] Practice exam Task 2
> `T(n)=4T(n/2)+Θ(n²)`: c=log₂4=2, d=2 → B → `Θ(n² log n)`.

> [!warning] When NO case holds (Seminar 3)
> If f sits *between* cases (e.g. `f = n^c·log n` — faster than `n^c` but not polynomially faster), **no case applies**. Use a recursion tree / substitution.

## Karatsuba
`T(n) = 3T(n/2) + Θ(n)` (3 half-size multiplications, not 4; middle term recovered by subtraction) → c = log₂3 ≈ 1.585, Case A → **`Θ(n^{1.585})`**, beating naive `Θ(n²)`.

## Polynomial multiplication & FFT
Polynomial product = **convolution** of coefficients (mix by degree, not component-wise). Naive `Θ(n²)`; **FFT** `Θ(n log n)`, worth it only for large n (threshold: small n → trivial, large n → Karatsuba/FFT).

---

# 7. Searching & sorting (L5)

**Sorting problem:** rearrange `a[1..n]` into nondecreasing order. In practice it's usually a library routine.

## Comparison lower bound (theorem)
Any comparison-based sort needs **Ω(n log n)** comparisons worst case. *Decision-tree counting:* there are `n!` orderings; each comparison has 2 outcomes, so after k comparisons at most `2ᵏ` cases are distinguishable. Need `2ᵏ ≥ n!` ⇒ `k ≥ log₂(n!) ≈ n log₂ n`. So no comparison sort is worst-case `O(n)` or `O(n log log n)`; merge/heap sort are asymptotically **optimal**. (→ Task 10: `O(n·α(n))` impossible.)

## The sorts
| Sort | Worst | Best | Extra space | Stable |
|---|---|---|---|---|
| Insertion | Θ(n²) | Θ(n) (sorted) | Θ(1) | Yes |
| Merge | Θ(n log n) | Θ(n log n) | Θ(n) | Yes |
| Heap | Θ(n log n) | Θ(n log n) | Θ(1) | No |
| Quick | Θ(n²) | Θ(n log n) | Θ(log n) | No |

- **Insertion** — grow a sorted prefix; insert each new key by shifting larger elements right. Worst = reverse-sorted (`1+2+…+n = Θ(n²)`); fast for small n.
- **Stability** = equal elements keep their relative order (`[1A,2,1B] → [1A,1B,2]`). Needed by radix sort.
- **Merge** — divide & conquer: `T(n) = 2T(n/2) + Θ(n)` → `Θ(n log n)`; best = worst (always splits the same, always scans all on merge).
- **Quick** — partition around a pivot (pivot lands in final position); avg/best `Θ(n log n)`, worst `Θ(n²)` on bad pivots; fast in practice.

## Heap (array view, for heap sort)
Complete binary tree in a 1-based array: **parent(k) = ⌊k/2⌋, left(k) = 2k, right(k) = 2k+1**. With heap size i, node k is a **leaf** if `2k > i`; only `a[1..i]` is the active heap. **Max-heap property:** for `1 < k ≤ i`, `a[k] ≤ a[⌊k/2⌋]` (every child ≤ its parent → root is the max).

## Non-comparison sorts
- **Counting sort** — integer keys in `[0,k]`: `Θ(n+k)`, stable.
- **Radix sort** — sort one digit/field at a time (least-significant first) with a stable counting sort: `Θ(d·(n+k))`.

> [!example] Practice exam Task 3
> Sort m edges by (source, then target) in O(n+m): two stable counting-sort passes (target first, source second). **Not** BFS.

---

# 8. Dynamic programming + the 4-step recipe (L6, Seminar 4)

## When DP applies — two signals
**Overlapping subproblems** (same subproblem recurs) and **optimal substructure** (optimal answer built from optimal sub-answers).

## Typical workflow
Define a **state** (what one table entry means) → write a **recurrence** → **base cases** → choose evaluation order / memoize → read off the answer (sometimes reconstruct it). **Teaching rule: if the state is vague, the DP goes wrong.**

## Fibonacci (warm-up)
`F₁=F₂=1, Fₙ=Fₙ₋₁+Fₙ₋₂`. Naive recursion `T(n)=T(n−1)+T(n−2)+Θ(1) = Θ(φⁿ)` (φ≈1.618 — recomputes subproblems; "short code ≠ efficient code"). Memoized: each state once → `Θ(n)` time, `Θ(n)` space. Bottom-up: no recursion overhead.

## 0/1 Knapsack
`DP[k][m] = max(DP[k−1][m], vₖ + DP[k−1][m−wₖ])` (skip vs take item k). Time & space `Θ(nM)`. Adds to the toolbox: **multidimensional state, decision-based recurrence, table reconstruction**. A greedy choice does **not** work.

> [!warning] Pseudo-polynomial (see also §11)
> `Θ(nM)` is polynomial in the **numeric** capacity M, not in M's **bit-length** — so it's *exponential* in the input size. This is the canonical pseudo-polynomial example.

## Longest Common Subsequence (LCS)
A subsequence skips symbols but preserves order. `L(i,j)` = LCS length of prefixes `a[1..i]`, `b[1..j]`:
`= L(i−1,j−1)+1` if `aᵢ=bⱼ`, else `max(L(i−1,j), L(i,j−1))`. Base `L(i,0)=L(0,j)=0`. `Θ(nm)`. Recover the actual sequence by walking the table backward.

## Edit distance (Levenshtein)
Min insert/delete/substitute to turn one string into another. `D(i,j)`:
`= D(i−1,j−1)` if `aᵢ=bⱼ`, else `1 + min(D(i−1,j) delete, D(i,j−1) insert, D(i−1,j−1) substitute)`. Base `D(i,0)=i, D(0,j)=j`. `Θ(nm)`. (LCS = preserved order; edit distance = minimum change.)

## The 4-step recipe (Seminar 4 — memorize)
1. **Backtracking** — plain recursion: base case for small k; else recurse on smaller k and combine. Parameter k names the subproblem.
2. **Memoization** — global `mem`; wrap body in `if k not in mem`; replace `return value` with `mem[k]=value`; end with `return mem[k]`.
3. **Bottom-up DP** — find `k_min,k_max`; replace dict with array `mem[k_min..k_max]`; loop `for k=k_min to k_max` filling it; drop the guard; replace recursive calls with array reads; `return mem[k_max]`.
4. **Minimize space** — if `mem[k]` depends only on the last `c` values, shrink the array to size c and index `mem[k % c]` → space `Θ(1)`.
*Multi-parameter:* tuple state `(k₁..k_t)` → t-dimensional array + t nested loops (order can matter); pass input by pointer + k, never copy.

> [!example] Practice exam Task 12 (loop invariant)
> "For `j<i`, `dp[j]` = min **jumps** to reach field j, or **n** if unreachable." Init `dp=[n]*n`, `dp[0]=0`, update `dp[i]=min(dp[i], dp[i-w]+1)`, return `dp[n-1] < 4`.

---

# 9. Dictionaries & data structures (L7, Seminar 5)

**A data structure stores data + maintains an invariant that makes some operations efficient.** The running theme is **trade-offs**: fast lookup vs fast insertion vs low memory.

## Dictionary ADT
Stores **unique** key→value pairs. Operations `Init(), Check(k), Get(k), Add(k,v), Remove(k)`. Invariant: each key at most once (values may repeat); `Add(k,v)` overwrites if k exists else inserts.

## Implementations, in the lecture's order
- **Direct addressing** — keys are integers in `[0,M]`; store value at `a[key]`. `Init Θ(M)`, `Check/Get/Add Θ(1)`, space `Θ(M)`. Great when the key range is small & dense; **wastes memory** badly when sparse (billion-range, thousand present). *(This is Task 11's "array indexed by keys".)*
- **Unsorted array of pairs** — `Init Θ(1)`; `Check/Get/Add Θ(n)` (must scan to check existence). Memory-efficient but slow lookup. If a key is *guaranteed new*, you can append in `Θ(1)` amortized.
- **Dynamic arrays & resizing** — when full, allocate **double** size and copy. Most appends cheap; occasionally one triggers a big copy. **Amortized Θ(1)** by the doubling argument: copies happen at sizes 1,2,4,8,… so total copied after n inserts is `< 2n`. *(This is why front-removal is Θ(n) but back-append/removal is O(1) — Task 9.)*
- **Hash table** — `h(k)` maps a key to a bucket in an array of size m (common form `h(k)=k mod p`). **Collisions** fixed by **chaining** (each bucket = short linked list; hash to the bucket, scan inside). `Check/Get/Add = Θ(1) expected`, worst `Θ(n)` if many keys collide. Needs a good hash function + **bounded load factor** (items ÷ buckets). **Universal hashing** picks h randomly so no fixed input forces collisions. No sorted order.

## Trees for dictionaries
- **BST** — `node` has `key, value, left, right, parent` (NONE where absent; empty ⇒ `root==NONE`). **BST invariant:** left subtree keys `< v.key < ` right subtree keys. Search/insert cost ∝ **height h**: balanced `h=Θ(log n)`, degenerate (sorted insertion) `h=Θ(n)` — behaves like a linked list. Seminar ops: `FindMin` (go left), `Add`, `Successor` (smallest key > k), `SortedOutput` (**in-order traversal** = sorted).
- **AVL** — self-balancing BST. **Invariant:** at every node, the heights of the two children differ by **≤ 1**. **Rotations** (left/right) are local repairs preserving BST order while reducing height → `h=Θ(log n)` always → all ops `O(log n)`. Without balancing, BST guarantees collapse on unlucky insertion orders. (Red-black trees = alternative.)

> [!important] Course-specific height convention (Seminar 5)
> **Height of a node** = number of nodes on the longest downward path **including v**. A leaf has height **1**; `NONE` is a virtual node of height **0**; one node = height 1.

> [!example] Practice exam Task 5
> Height-3 BST on {40,10,30,20} violating AVL: **root=10, right child=30, with 30's children 20 (left) and 40 (right)**. Longest path 10→30→20 = 3 nodes = height 3. At the root: left child NONE (h0) vs right subtree (h2) differ by 2 → **root is the violator**. (Mirror image is the other valid answer.)

## Heap (priority queue)
**Not** a dictionary/BST — a **complete binary tree** (levels filled top→bottom, left→right). **Heap invariant:** every node's priority `≥` its children's (max-heap). Duplicate priorities allowed. `peek O(1)`, `insert/removeMax O(log n)`, `build-heap O(n)`. (Array view: §7.)

## Probabilistic structures
- **Bloom filter** — bits only, *approximate set membership*: "possibly in" / "definitely not" → **false positives possible, false negatives never**. Tiny memory; used in networking/caches.
- **HyperLogLog** — estimates the **count of distinct items** (cardinality) with almost no memory.

## Similarity search
Hashing becomes a tool for *approximate similarity* (not exact equality):
- **Locality-Sensitive Hashing (LSH)** — hash functions that make *similar* items collide on purpose → fast near-duplicate search.

## Trie
Tree keyed by **prefixes** (each edge a character); great for string lookup / autocomplete.

---

# 10. Graphs, networks & spatial search (L8, Seminar 6)

## Vocabulary (Seminar 6)
`n` vertices (= nodes), `m` edges. **Path** = consecutive edges; **length** = #edges; **cost/weight** = sum of weights. **Simple path** = no repeated vertices. **Cycle** = simple path returning to start. **Tour** = a (not necessarily simple) closed walk visiting **all** vertices. **Connected** = every vertex reachable from every other. **Tree** = connected undirected acyclic graph. **Spanning subgraph** = connected subgraph with all vertices; **minimal** if least total weight. Default: undirected, unweighted, no parallel edges, no self-loops.

## Representations
- **Adjacency matrix** — `Θ(n²)` space, O(1) edge check; dense graphs.
- **Adjacency list** — `Θ(n+m)` space; sparse graphs (usual default).

## Shortest vs cheapest
BFS gives **shortest** (fewest edges, unweighted); Dijkstra/Floyd-Warshall give **cheapest** (least weight).

## BFS
Queue (FIFO) → process vertices **layer by layer**. `dist[s]=0`, enqueue s; pop front, relax unvisited neighbours, enqueue them. Keeps a `dist` array (+ optional `parent`). Each vertex enqueued once, each edge scanned once → **`Θ(n+m)`**. Use for shortest paths in unweighted graphs, reachability.

## DFS
Stack/recursion (LIFO) → follow the newest branch deeply, then backtrack. **`Θ(n+m)`**. Use for connectivity, topological ideas, cycle detection, component discovery.

## Dijkstra
Weighted graph, **nonnegative** weights, source s. Greedy with a **priority queue**, relaxing edges (extends BFS). Time (binary heap) `O((n+m) log n)`; memory dist `Θ(n)` + PQ `Θ(m)`. Fails on negative weights.

## Floyd–Warshall (all-pairs)
DP: `dist(v,w)` using only internal vertices from a growing allowed set; init from edges; update by allowing one more intermediate vertex. **`Θ(n³)` time, `Θ(n²)` space**. Good when dense / all-pairs needed / vertex set not too large. (Single-source = Dijkstra; all-pairs = Floyd-Warshall.)

> [!example] Practice exam
> T7b: Floyd-Warshall run n² times → Θ(n⁵). T8c/8d: Dijkstra memory dist Θ(n) + PQ Θ(m) → Θ(n) with O(n) edges, Θ(n²) with Θ(n²) edges.

## Minimum spanning tree (MST)
Connect all vertices, minimum total weight, no cycles. **Kruskal** (greedy): sort edges by weight, add each if it doesn't create a cycle (**cycle test = find–union**); grows a **forest** that merges into one tree, always joining two separate components with the cheapest edge. Cost dominated by the sort: **`O(m log m)`**. **Prim** = grow one tree from a start vertex. (Choose among BFS/DFS/Dijkstra/Floyd-Warshall/Kruskal for standard path & connectivity tasks.)

## A* search
**Dijkstra + a heuristic** estimating remaining distance to the goal → search heads toward the target.

## Network analysis
**PageRank** = random-surfer importance model. **Centrality** (no single notion of "importance"): degree (#neighbours), closeness (short average distance to all), betweenness (often on shortest paths).

## Spatial search
- **k-d tree** — recursively splits space along coordinate axes; search **prunes** branches that can't hold the answer.
- **Ball tree** — nested balls; adapts better than k-d trees in high dimensions.
- **Voronoi cell** — region closest to a site; query in p's cell ⇒ p is the nearest neighbour.

---

# 11. Limits of efficient computation (L9)

## Decision problems as languages
Yes/no questions. A decision problem = a **language** S; input `w`, decide `w ∈ S?`. Encoding input as a **word** gives a precise, model-independent definition where **input size = number of letters**.

## P, NP, NP-hard, NP-complete
- **P** — solvable in time polynomial in the **input length** (not in a numeric parameter inside the input).
- **NP** — a YES answer has a **certificate** checkable in polynomial time (verify, not necessarily find).
- **NP-hard** — at least as hard as everything in NP.
- **NP-complete** — in NP **and** NP-hard: the hardest problems inside NP.

## Pseudo-polynomial (the knapsack subtlety)
Knapsack DP is `Θ(nM)` — polynomial in the **numeric** M, but M takes only `Θ(log M)` bits, so worst-case (M dominating the input) this is **exponential in input length**. Hence the knapsack *decision* problem ("value ≥ V?") is NP-complete despite the `Θ(nM)` DP.

## Reductions
"**A reduces to B**" (`A ≤ₚ B`): poly-time transform of A-instances into B-instances so a B-solver solves A → **A no harder than B**.
- Prove **B ∈ NP**: reduce B to a known NP problem / give a poly verifier.
- Prove **B is NP-hard**: reduce a *known NP-complete* problem **to** B (known-hard → your problem).
- **Anything in P reduces to almost anything** (solve it, output a fixed yes/no instance — needs B to have a yes- and a no-instance).
- If one NP-complete problem is in P, **all** of NP collapses to P (the open P-vs-NP question).

## Classic hard problems
- **SAT** — first proven NP-complete (**Cook–Levin, 1971**); certificate = the truth assignment; best exact `O(2ⁿ)` in #variables.
- **Hamiltonian Cycle** — NP-complete; best exact `O(2ⁿ·n²)`.
- **TSP (decision)** — NP-complete; **approximable within 3/2 in the metric case (Christofides)**.
- Also: Knapsack (decision), Clique, Vertex Cover, Independent Set.

> [!example] Practice exam Task 13
> A = "path s→t?" ∈ P (BFS). B = "tour of total weight exactly n?" is NP-complete (in NP as a TSP special case; NP-hard via Hamiltonian Cycle with unit weights). So **A reduces to B** (P reduces to anything); **B ∈ P? unknown**; **B reduces to A? unknown** — both hinge on P-vs-NP.

## Time Hierarchy Theorem
For every k, there is a problem solvable in poly time but **not** in `O(nᵏ)`; and a problem solvable in exponential time but not in polynomial time. (More time genuinely buys more power.)

## Approximation algorithms
For NP-hard optimization, aim **provably close**:
- The **decision version is at least as hard as the optimization version**.
- **Metric TSP, 2-approximation via MST:** build an MST, walk it (DFS-style), shortcut repeats; by the triangle inequality the tour costs **≤ 2·OPT**. **Christofides** improves this to **3/2** in the metric case.
- Problems with efficient *exact* algorithms (no approximation needed): sorting, shortest paths, MST, bipartite matching, linear programming.

---

# 12. Gradient descent & neural-network training (L10)

*Most "data science", least "classical algorithms". Not on the practice exam, but course material.*

## Optimization view of ML
A model produces a prediction `ŷ = f_θ(x)`, where `θ` = the **weights and biases**. Training = **minimize a loss function `L(θ)`** over the training data. Nets have millions/billions of parameters → search, not solve.

## Gradient = local slope
`∇L(θ)` points **uphill** (steepest increase). To decrease loss, step in the **negative** gradient direction — locally the fastest way down.

## Update rule
`θ_{t+1} = θ_t − η·∇L(θ_t)` — `η` = **learning rate** (step size).

> [!example] Worked example (from the lecture)
> Loss with `∇L(w) = 2(w−3)`, start `w₀=0`: `∇L(w₀)=−6`, step to `w₁=3`; `∇L(w₁)=0` → at the minimum.

## Learning rate & convexity
The learning rate is one of the most important **hyperparameters** (too large → overshoot/diverge; too small → very slow). **Convex** loss → no bad local minima, gradient descent finds the global optimum; **non-convex** (usual for nets) → may converge to a local minimum.

## Stochastic gradient descent (SGD)
Full-dataset gradients are expensive → estimate from a small random **minibatch** (or one example): noisier but far faster, and the noise can help escape bad regions. ("From linear models to neural networks" = the same optimization idea scaled up, with practical training issues: learning-rate tuning, slow/unstable convergence.)

---

# 13. Seminar problem-type catalogue

Problem shapes drilled in seminars ("relevant for short tests and the exam"):
- **D&C search:** *coin-weighing* (find the light coin in k weighings → up to `3ᵏ` coins; ternary split + induction lower bound).
- **Unbounded binary search:** *Guess my number* with no upper bound → **doubling** to bracket, then binary search → `O(log n)`.
- **Bug-fix + correctness:** *divide-by-two* (spot non-termination on odd n, fix it, prove via invariant + termination).
- **Ordering by growth:** sort Θ-expressions using POL<EXP / LOG<POL; timing estimates ("how big an input in T seconds at X ops/sec").
- **Definition proofs:** e.g. `f = Ω(g) ⇔ g = O(f)` from the definitions.
- **Basic design + invariants:** square root, array `Swap`, **rotate-by-k**, min-finding correctness.
- **Master Theorem edge case:** a recurrence where **no case holds**.
- **DP:** *smileys* matching (here/there arrays), **non-touching cell selection** (1D = Task 4; 2D grid generalization), **max-value subarray block** — all via the 4-step recipe.
- **BST algorithms:** FindMin, Add, Successor, in-order SortedOutput.
- **Graph proofs:** cycle-removal → tree argument; constructing a graph where **Dijkstra is forced to be very slow**.

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
| 7b, 8c, 8d | Floyd-Warshall, Dijkstra memory | 10 |
| 9 | array memory layout / dynamic arrays | 9 |
| 10 | comparison lower bound | 7 |
| 11 | find-union vs other dictionaries | 9 |
| 13 | P/NP, reductions | 11 |

**Checklist**
- `log = log₂`; running time = worst case; `for i=1 to n` includes i=n.
- Asymptotic "=" is directional (`n=O(n²)`, `n²≠O(n)`); prove Θ by sandwiching.
- Constant loop → O(1); dependent loop → sum a series; `1+…+n=Θ(n²)`, `1+…+2ⁿ=Θ(2ⁿ)`.
- POL<EXP; LOG<POL; `Θ(log_a c)=Θ(log c)`; `√2^{log n}=√n`.
- Master Theorem `c=log_b a`: d<c→Θ(n^c), d=c→Θ(n^c log n), d>c→Θ(f). Karatsuba `3T(n/2)+Θ(n)=Θ(n^1.585)`. Some recurrences fit no case.
- Sort floor Ω(n log n) via `2ᵏ≥n!`; counting/radix beat it (Θ(n+k)); insertion best Θ(n)/worst Θ(n²); merge T(n)=2T(n/2)+Θ(n); heap parent ⌊k/2⌋, children 2k/2k+1.
- DP signals: overlapping subproblems + optimal substructure. 4-step recipe. Knapsack Θ(nM) (pseudo-poly); LCS/edit-distance Θ(nm); Fibonacci Θ(n).
- Dictionaries: direct addressing Θ(M) space; unsorted array Θ(n) lookup; dynamic array doubling → amortized O(1); hash Θ(1) expected/Θ(n) worst; **height counts nodes (leaf=1, NONE=0)**, AVL children differ ≤1, all ops O(log n).
- Bloom = no false negatives; HyperLogLog = distinct count; LSH = similarity.
- BFS/DFS Θ(n+m); Dijkstra O((n+m)log n), mem dist Θ(n)+PQ Θ(m); Floyd-Warshall Θ(n³)/Θ(n²); Kruskal O(m log m) with find-union; A* = Dijkstra+heuristic.
- Find-union O(α(n)), Θ(n) memory.
- Decision problems = languages; P (poly in input length); NP (verify a certificate); NP-complete = NP+NP-hard; reduce known-hard *into* your problem; SAT first NP-complete (1971); P reduces to everything; "unknown" answers come from P-vs-NP; metric TSP: 2-approx (MST) / 3-2-approx (Christofides). Time hierarchy: more time → more power.
- Gradient descent: θ←θ−η∇L(θ); learning-rate hyperparameter; convex→global, non-convex→local; SGD = minibatch.

> [!warning] Verify against your own lectures
> Dijkstra's bound (binary vs Fibonacci heap) and any figure your lecturer stated differently — trust the lecture for the exam. The height convention is from your Seminar 5 cheatsheet.
