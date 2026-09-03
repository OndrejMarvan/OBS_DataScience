# Algorithms for Data Science — Exam Guide

Built from `Labs_merged`, `lectures_merged`, and the eight June 2025 past exams (Groups A–H).

**The single most important fact: all eight past exams are the same 13 tasks with different
numbers.** The format is fixed. You are not preparing for an unknown exam — you are preparing for
13 known question types. That is what this guide is organised around.

---

## 0. The blueprint

**90 minutes. 13 tasks. 60 points + 4 bonus. 14 pages.**

| # | Task | Pts | Type | Difficulty |
|---|---|---|---|---|
| 1 | Fill in blanks in a Python function from a list of snippets | 5 | Multiple choice | Medium |
| 2 | Write the recurrence T(n)=aT(n/b)+Θ(f(n)) for a given algorithm — **or the reverse**: fill blanks in the algorithm to match a given recurrence | 4 | Counting | Medium |
| 3 | Master theorem: give c, the case, and T(n) | 4 | **Pure mechanics** | Easy |
| 4 | Simplify three Θ expressions (2 pts each) | 6 | **Pure mechanics** | Easy |
| 5 | Array → complete binary tree; find the violating heap edge; fix it | 5 | **Pure mechanics** | Easy |
| 6 | Dijkstra: fill in the full dist and parent table | 9 | **Pure mechanics** | Medium |
| 7 | Draw a planar (crossing-free) graph from an adjacency matrix | 5 | Drawing | Medium |
| 8 | Insert keys into an existing BST, draw the result | 4 | **Pure mechanics** | Easy |
| 9 | Pick the best data structure for a scenario + justify | 4 | Written answer | Medium |
| 10 | Node heights, AVL invariant, find nodes X and Y | 5 | **Pure mechanics** | Medium |
| 11 | Floyd–Warshall stopped early: fill in specific δ cells | 5 | **Trick, but learnable** | Medium |
| 12 | Fix one wrong constant in a loop invariant | 4 | **Pure mechanics** | Easy once you see it |
| 13 | Bonus: P/NP, reductions, tick the correct statements | +4 | Conceptual | Hard |

**Read this:** tasks 3, 4, 5, 6, 8, 10, 11, 12 are **43 of the 60 points** and are all pure
mechanical procedures. There is no insight required — just correct execution. That is where every
hour of your remaining time should go.

Task 1 hints "the task is related to the *n*-th programming task" — these recycle the course's
graded programming assignments. **If you still have your own programming assignments, open them
tonight and skim your solutions.** That's a cheap 5 points you can't get any other way.

---

## 1. Your schedule

Revised now that we know the format. The old plan was to learn the course; the new plan is to drill
13 known question types.

| When | Time | Do |
|---|---|---|
| **Now** | 15 min | Skim §0. Find your programming assignments. Then **sleep.** |
| Fri, 1h before work | 60 min | §3 (Master theorem) + §4 (simplification). 10 points, easiest in the exam. |
| Fri eve, block 1 | 75 min | §6 Dijkstra — 9 points, largest single item. Do Group A's and B's Dijkstra by hand. |
| Fri eve, block 2 | 75 min | §5 heap + §8 BST + §10 AVL heights. 14 points, all mechanical. |
| Fri eve, block 3 | 60 min | §11 Floyd–Warshall + §12 invariant. 9 points, both are one-trick tasks. |
| Fri eve, block 4 | 45 min | §2 recurrence-from-code + §9 data structure choice. |
| **Stop by 23:00** | — | Sleep matters more than block 5. |
| Sat 06:00–07:30 | 90 min | Do **one full past exam under time** (pick Group E or F — you won't have seen it). Then §14 cram sheet. |

Skip task 13 (bonus, hard, 0 regular points) and treat task 7 (drawing) as improvisation on the day.
That still leaves ~51 points reachable.

---

## 2. Course conventions (free marks)

- `log` **always means log₂**. "Running time" **always means worst case**.
- `a[2..n]` has **n − 1 elements**. `for i = 1 to n` **includes** i = n.
- **Height of a node = number of NODES on the longest downward path from v, including v.**
  A leaf has height **1**. A missing child ("NONE") has height **0**.
  ⚠️ Not the edge-counting definition used elsewhere. The exam states this explicitly and still
  catches people.
- Graphs: n vertices, m edges; undirected, unweighted, no self-loops unless said otherwise.
- **When a vertex has several neighbours, process them in alphabetical/lexicographic order.**
  This is stated in tasks 6 and elsewhere and it changes your answer.

---

## 3. Task 3 — Master theorem (4 pts, easiest points on the paper)

For **T(n) = a·T(n/b) + f(n)**, let **c = log_b a**.

| Case | Condition (Lite: f = Θ(n^d)) | Answer |
|---|---|---|
| **A** | d < c | Θ(n^c) |
| **B** | d = c | Θ(n^c log n) |
| **C** | d > c | Θ(n^d) |

The exam asks for exactly three things: **c**, **the case letter**, **T(n)**. Floors and ceilings are
irrelevant. For Case C you may assume the regularity condition holds (the paper says so).

**Procedure — 40 seconds:**
1. Read off a and b. Compute c = log_b a. *Trick:* write a as a power of b. If a = b^k, then c = k.
2. Read off d from Θ(n^d).
3. Compare d to c → letter → formula.

**Worked from the papers:**
- Group A: T(n) = 64·T(n/2) + Θ(n⁶). 64 = 2⁶ so **c = 6**. d = 6 = c → **Case B** → **Θ(n⁶ log n)**.
- Group C: T(n) = 100³·100·T(n/100) + Θ(n³). a = 100⁴, b = 100 → **c = 4**. d = 3 < 4 → **Case A**
  → **Θ(n⁴)**.

**Note how they disguise a:** they write it as a product or a power (100³·100, 1003·100) rather than
a plain number. Simplify a to a power of b first — that's the whole difficulty.

Useful log values: log₂2=1, log₂4=2, log₂8=3, log₂16=4, log₂32=5, log₂64=6, log₂128=7, log₂256=8,
log₂1024=10. log₃9=2, log₃27=3. log₁₀₀(100^k)=k. log₂3≈1.585, log₂7≈2.807.

⚠️ The Master theorem **never applies to T(n−1)**. If you see subtraction, it's a different question.

---

## 4. Task 4 — Simplify three Θ expressions (6 pts)

**The rule:** (1) replace constant factors with 1, (2) transform complicated terms into simple ones,
(3) keep only the fastest-growing term(s).

**Growth order:** 1 < log n < (log n)^k < n^ε < n < n log n < n² < n³ < 2ⁿ < 4ⁿ < n! < nⁿ
- **LOG < POL**: any power of a log loses to any positive power of n.
- **POL < EXP**: any polynomial loses to any exponential with base > 1.

**Transformations that actually show up:**
| See this | Becomes | Why |
|---|---|---|
| n^{a}·n^{b} | n^{a+b} | exponent addition |
| n^{3/6 + 3/6} | n¹ = n | add the fractions first |
| (n^a)^b | n^{ab} | |
| log(n^k) | k·log n | → so it's just Θ(log n) |
| log(cn) | log c + log n | → Θ(log n) |
| log₃(9ⁿ) | 2n | it's **linear**, not logarithmic — classic trap |
| 2^{2 log₂ n} | (2^{log₂n})² = n² | the a = b^{log_b a} identity |
| (10^{log₁₀ n})^{10} | n^{10} | same identity |
| 2^{n/10 · 2} | 2^{n/5} | |
| (2n)²/n | 4n | |
| n^{3−3}, 2^{n−n} | 1 | exponent is zero |
| a huge constant like 1000^{1000} | 1 | still Θ(1) |

**Two things you must not do:**
1. **Never reduce 4ⁿ to 2ⁿ, or 2^{5n} to 2ⁿ.** Exponential bases matter: 4ⁿ = (2²)ⁿ = 2^{2n}, which
   grows unboundedly faster than 2ⁿ. (Log bases *don't* matter: Θ(log₅n) = Θ(log n).)
2. **With multiple parameters (m, k, n), keep every term that isn't dominated.** Θ(mk + n²) is a
   valid final answer — mk and n² are incomparable.

**Worked from the papers:**
| Expression | Answer |
|---|---|
| Θ(9(log₂n)³ + 7log₂(n⁵) + 2) | **Θ((log₂n)³)** — second term is 35 log n, smaller |
| Θ(9√n + n^{3/6+3/6}/7 + 1) | **Θ(n)** — the middle term is n¹ |
| Θ(22n⁶ + 36·2ⁿ + 3·4ⁿ) | **Θ(4ⁿ)** — do *not* write 2ⁿ |
| Θ(4n³ + 12n²log n + 2n³) | **Θ(n³)** |
| Θ(2n^{3−3} + 5 + 2^{n−n}·4) | **Θ(1)** — everything is constant |
| Θ((10^{log₁₀n})^{10} + (2^{n/10})²) | **Θ(2^{n/5})** — n^{10} loses to the exponential |
| Θ(3n + 4 + n^{5/10+5/10}/2) | **Θ(n)** |
| Θ(29n²⁰ + 2·11ⁿ + 40·10ⁿ) | **Θ(11ⁿ)** — bigger base wins |
| Θ(3(log₂n)⁵ + 5 + log₂(n⁶)) | **Θ((log₂n)⁵)** |

---

## 5. Task 5 — Heap violation (5 pts)

You get a 21-element array. Three sub-tasks: draw it as a complete binary tree, mark the one
violating edge, then give **j** and the **new value of a[j]**.

**Array ↔ tree indexing (1-based):** children of i are **2i** and **2i+1**; parent of i is **⌊i/2⌋**.
Level structure for 21 elements: indices 1 | 2–3 | 4–7 | 8–15 | 16–21.

**Heap invariant (max-heap):** every parent's value is **≥ both children's**.

**Procedure:**
1. Draw the tree level by level, left to right. Don't shortcut this — write the index above each node.
2. Scan every parent–child pair. Exactly one violates (child > parent).
3. **j = the index of the CHILD**, not the parent. (This trips people up.)
4. The new a[j] must be **≤ the parent's value** (to fix the violation) and **≥ both of j's own
   children** (so you don't create a new violation). The exam asks for the **smallest** such value,
   which is **max(a[2j], a[2j+1])**.

**Worked (Group A):** a = ⟨105, 90, 100, 60, 85, 95, 40, 65, 25, 80, 45, 95, 75, 35, 30, 50, 55, 20,
15, 65, 70⟩.
Violation: a[4] = 60 is the parent of a[8] = 65. So **j = 8**.
a[8]'s own children are a[16] = 50 and a[17] = 55. The valid range for the new value is [55, 60].
Smallest → **a[8] = 55**.

⚠️ If j has no children (j ≥ 11 for a 21-element array), any value ≤ the parent works, so the answer
is the smallest allowed — check whether the exam wants a lower bound.

---

## 6. Task 6 — Dijkstra (9 pts, the single biggest item)

You must fill in the complete `dist` and `parent` rows for every vertex.

**Their pseudocode has two quirks — know them so they don't confuse you:**
```
dist[..] = INF;  parent[..] = NONE;  dist[s] = 0
q = new priority queue;  q.add(s, 0)
while q not empty:
    v = q.extractMax()
    if v removed for the first time:            ← lazy deletion; skip stale duplicates
        for every edge (v, w):
            if dist[w] > dist[v] + c(v,w):
                dist[w] = dist[v] + c(v,w)
                parent[w] = v
                q.add(w, −dist[w])               ← negated priority + max-heap = a min-queue
```
It is an ordinary Dijkstra. Don't overthink the negation.

**Hand procedure (this is the exam's own hint):**
1. Write `∞` next to every vertex, `0` next to s.
2. Repeat: pick the **unmarked vertex with the smallest current distance**, mark it as done (tick it).
3. For each of its neighbours **in alphabetical order**, compute dist[v] + weight. If it beats the
   neighbour's current label, cross the old value out, write the new one, and write the parent.
4. Stop when all vertices are marked.
5. **Sanity-check at the end:** for every vertex w, verify dist[w] = dist[parent[w]] + c(parent[w], w).
   This catches almost every arithmetic slip and takes 30 seconds. With 9 points on the line, do it.

Alphabetical order only matters for tie-breaking, but the exam states it explicitly, so respect it.

**Worked (Group A):**

| | a | b | c | d | e | f | g | h | s |
|---|---|---|---|---|---|---|---|---|---|
| distance | 20 | 1 | 3 | 7 | 13 | 16 | 14 | 10 | 0 |
| parent | f | s | b | s | c | e | e | d | NONE |

Check: dist[a] = 20 = dist[f] + 4 = 16 + 4 ✓. dist[f] = 16 = dist[e] + 3 = 13 + 3 ✓.
dist[e] = 13 = dist[c] + 10 = 3 + 10 ✓. dist[c] = 3 = dist[b] + 2 = 1 + 2 ✓. Every row checks out.

**Practice:** do the Dijkstra task from Groups A, B and C tonight, timed. If you can do all three in
under 8 minutes each with a clean parent check, you have those 9 points.

Also know for the theory: Dijkstra is **Θ((n+m) log n)** with a binary heap, and **requires
nonnegative weights** — a negative edge lets a vertex be finalised before its true cheapest path is
found.

---

## 7. Task 7 — Draw a planar graph from an adjacency matrix (5 pts)

You're given a symmetric 0/1 matrix and six labelled vertices already placed on the page. Draw the
edges without crossings. **Curved edges are allowed** and are usually necessary.

**Procedure:**
1. Read off the edge list from the upper triangle only (the matrix is symmetric — don't double-count).
2. Count the degree of each vertex. The highest-degree vertex goes in the middle of your mental
   layout.
3. Draw the edges you're sure about first, then route the awkward ones as wide arcs **around the
   outside** of the whole drawing. Any edge can be routed around the outside without crossing.

**The exam explicitly says: drawing all edges with crossings scores better than omitting edges.** So
if you're stuck, draw everything and then redraw the offending edge as a big loop around the figure.

Group A's matrix gives edges: a–b, a–c, a–d, a–e, c–d, c–f, d–e, d–f, e–f. Degrees: a=4, d=4, c=3,
e=3, f=3, b=1. b is a pendant — hang it off a last, it can never cause a crossing.

---

## 8. Task 8 — Insert keys into a BST (4 pts)

**BST invariant:** for every node v, *all* keys in the left subtree are **strictly less** than v.key,
and *all* keys in the right subtree are **strictly greater**.

**Procedure:** for each key in the given order, walk down from the root — go left if smaller, right
if larger — and insert at the first NONE you reach.

**The two rules the exam states:**
- **Do not restructure the existing tree.** No rebalancing. Just hang new nodes on.
- **A key already in the tree changes nothing** (only its value would be updated).

Group A: insert 10, 5, 9, 19, 16, 20 into a tree with root 13, children 8 and 19, and 3 under 8.
→ 10 goes right of 8; 5 goes right of 3; 9 goes left of 10; **19 is already there — no change**;
16 goes left of 19; 20 goes right of 19.

**Self-check: an in-order traversal of your finished tree must come out sorted.** If it doesn't, you
made an error. Ten seconds, catches everything.

---

## 9. Task 9 — Choose the data structure (4 pts)

Fixed menu of ten options across all groups: array indexed by keys, AVL tree, find–union, hash table,
heap/priority queue, sorted linked list, queue, stack, sorted array, unsorted array.

Answers seen across A–H: array indexed by keys, heap/priority queue, stack, queue, hash table,
sorted array, AVL tree, unsorted array. **So essentially every option gets used somewhere.**

**Decision key — match the scenario's keyword to the structure:**

| Scenario keyword | Answer |
|---|---|
| small known integer key range, contiguous memory, simple, **worst-case** guarantees | **Array indexed by keys** |
| "always need the largest/highest priority", scheduling | **Heap / priority queue** |
| "most recently added", undo, backtracking, DFS | **Stack** |
| "in the order they arrived", FIFO, BFS | **Queue** |
| huge/unknown key space, fast **average** lookup, worst case not critical | **Hash table** |
| **worst-case** O(log n) guaranteed, dynamic inserts and deletes, ordered | **AVL tree** |
| static data, no insertions, need binary search or order | **Sorted array** |
| just store things, only ever scan, memory is the priority | **Unsorted array** |
| merging groups / connectivity / Kruskal cycle test | **Find–union** |
| sorted, need O(1) removal given a node, no random access needed | **Sorted linked list** |

**The answer format — the exam awards marks for all four parts, so write all four:**
1. Name the structure.
2. One sentence on how it maps onto the scenario.
3. Its **time and memory complexity** for the required operations.
4. **Why every other option is worse** *under this scenario's constraints* — group them:
   "X, Y, Z don't support the required operations at all; P, Q are slower in the worst case; R uses
   more memory."

That fourth part is where the marks are, and it's the part people skip.

**Key distinctions to have ready:**
- Hash table is Θ(1) **average** but **Θ(n) worst case** → if the scenario says "worst-case
  guarantee", hash table is wrong.
- AVL gives Θ(log n) **worst case** → that's its selling point over a hash table.
- Array indexed by keys is Θ(1) worst case but costs Θ(M) memory where M is the key range → only
  viable when the range is small.
- A heap is **not** a dictionary: you cannot look a key up in it.

---

## 10. Task 10 — Heights and the AVL invariant (5 pts)

Four answers required: height of a named node, height of the root, yes/no on AVL, and nodes X and Y.

**Height, their definition:** number of **nodes** on the longest downward path from v, counting v.
Leaf = 1. NONE = 0. So **height(v) = 1 + max(height(left), height(right))**.

**Procedure:**
1. Work **bottom-up**. Write the height next to every single node — don't try to do it in your head.
   Leaves get 1, then walk up.
2. Read off the two heights asked for.
3. **AVL check:** at every node, the two children's heights must differ by **at most 1** (NONE
   counts as 0). Scan every node; if any difference is ≥ 2, the answer is "no".

**Finding X and Y — read the question carefully, it branches:**

- **If the tree VIOLATES AVL:** X = the node where the violation occurs (its children's heights
  differ by ≥ 2). Y = a node where **adding one new child restores** the invariant — i.e. a node on
  the *shorter* side whose new child lifts that subtree's height by exactly 1 and closes the gap.
- **If the tree SATISFIES AVL:** X = a node where **adding a child would cause** a violation.
  Y = the node where that violation would then **appear** (which may be an ancestor of X, and may
  equal X).

**Tie-breaking, stated in the paper:** if several X are valid, take the **alphabetically smallest**.
Then, given that X, if several Y are valid, take the alphabetically smallest.

**Worked (Group A):** height of bz = 5, height of root (dd) = 6, AVL = **no**, X = ce, Y = cd.
Here node ce's two subtrees differ in height by 2; adding a child under cd (the shorter side) raises
it by one and repairs the invariant.

This task is fiddly but entirely mechanical. Practise on Groups A and B — the tree is drawn out for
you, so the only skill is annotating heights carefully and not rushing.

---

## 11. Task 11 — Floyd–Warshall stopped early (5 pts)

This is a one-idea question. Learn the idea and it's five easy points.

```
δ[1..n][1..n] filled with +∞
for i = 1 to n:  δ[i][i] = 0
foreach edge (v, w, c):  δ[v][w] = c;  δ[w][v] = c
for k = 1 to K:                        ← the "error": K < n
    foreach pair (v, w):
        δ[v][w] = min(δ[v][w], δ[v][k] + δ[k][w])
```

**THE INVARIANT — memorise this sentence:**
> After the outer loop has run k = 1 … K, δ[v][w] is the cost of the cheapest path from v to w that
> uses **only vertices 1…K as internal vertices**. The endpoints v and w may be any vertices. If no
> such path exists, δ[v][w] is still **+∞**.

**Procedure for each cell they ask about:**
1. Is there a **direct edge** v–w? If yes, that's an upper bound (and often the answer).
2. Otherwise look for a path v → … → w where **every intermediate vertex has index ≤ K**.
   The endpoints don't count and may exceed K.
3. If no such path exists → **INF**.

**The trap, every time:** the graph is built so that a hub vertex (numbered > K) would give a short
route to everything, but it is **not permitted as an internal vertex**. So all the hub shortcuts are
unavailable and you must go the long way round the cycle — or find nothing at all.

**Worked (Group A):** n = 18. Vertices 1–17 form a big cycle, and vertex **18 is a hub connected to
all of them**. Every edge has weight 1. Loop stops at K = 13.

| Cell | Answer | Reasoning |
|---|---|---|
| δ[18][15] | **1** | direct edge (hub to 15) — no internal vertices needed |
| δ[2][12] | **10** | along the cycle 2→3→…→12; internals 3…11 are all ≤ 13 ✓. (Via 18 would be 2, but 18 > 13 is forbidden.) |
| δ[17][14] | **14** | 17→1→2→…→13→14; internals 1…13 all allowed → 14 edges |
| δ[15][3] | **INF** | going one way needs 16, 17 (> 13); the other way needs 14 (> 13); via the hub needs 18 (> 13) |
| δ[13][16] | **INF** | needs 14, 15 or 17, or the hub — all > 13 |

Note the exam's own hint: **"there are exactly two fields where the answer is INF; if you write INF
in more than two fields you get 0 for those fields."** Use that as a check — if you've got three
INFs, one of them is wrong.

---

## 12. Task 12 — Fix the broken loop invariant (4 pts)

Looks intimidating, is actually a two-equation algebra problem. This is the highest points-per-minute
task on the paper once you know the method.

You're given a loop that updates two variables, and a proposed invariant like
**A·x + C·e = D** with three constants, one of which is wrong. Change exactly one.

**Method:**
1. **Compute the per-iteration deltas.** Trace one pass of the loop body and net out the changes:
   Δx and Δe. (In Group A: `x = x+4` then `x = x−1` → **Δx = 3**; `e = e+4` then `e = e−11` →
   **Δe = −7**.)
2. **Preservation equation.** For the invariant to survive an iteration, the change must cancel:
   **A·Δx + C·Δe = 0**.
3. **Initialisation equation.** Plug in the starting values x₀, e₀:
   **A·x₀ + C·e₀ = D**.
4. You now have two equations relating three constants. **Test each constant in turn:** assume the
   *other two* are correct and see whether they're consistent with each other. Exactly one pairing
   will be consistent — the odd one out is the constant to change, and the equations give you its
   value.

**Worked (Group A):** `x=4, e=0; while x<b: t=4; x=x+t; e=e+t; x=x−1; e=e−11`.
Δx = +3, Δe = −7. Given A = 7, C = 2, D = 28.
- Preservation: 7·3 + C·(−7) = 0 → 21 = 7C → **C = 3**.
- Initialisation: 7·4 + C·0 = 28 → D = 28 ✓ (consistent with the given D).
So A and D agree with each other; C is the odd one out. **Answer: change C to 3.**

**Worked (Group C):** `u=0, l=2; while l≤h: u=u+4; r=2; l=l−r; u=u−r; l=l+8`. Invariant B·l = A·u + T.
Δu = 4 − 2 = **+2**, Δl = −2 + 8 = **+6**. Given B = 15, A = 36, T = 24.
- Preservation: B·Δl = A·Δu → 6B = 2A → **A = 3B**.
- Initialisation: B·2 = A·0 + T → **T = 2B**.
- Test B = 15: needs A = 45 and T = 30 — *both* given values wrong, so B can't be the good one.
- Test A = 36: needs B = 12 and T = 24 — **T = 24 matches the given value.** Consistent.
**Answer: change B to 12.**

The tell: the constant to change is the one whose value contradicts *both* of the others, while the
other two agree with each other.

---

## 13. Task 13 — Bonus: reductions and P/NP (+4, optional)

Same shape every time: two decision problems A and B, then tick which statements are true.
**A is always secretly polynomial-time; B is always secretly NP-complete.**

**Recognising B:** it's a disguised classic. Knapsack ("maximise total value within a budget/time
limit" — seen as choosing lecture recordings), Hamiltonian cycle/path ("visit every room exactly
once"), SAT, vertex cover, graph colouring.

**Recognising A:** it reduces to something you can run BFS/sorting/greedy on. "Is there an ordering
of *some* users from Alice to Bob where consecutive users are friends?" is just **connectivity** —
build a graph and run BFS. Note the "*some*, not necessarily all" — that's what makes it a path
question rather than a Hamiltonian one. **If it said "all users", it would be NP-complete.**

**The four true statements, every time:**
- ✅ **A can be reduced to B in polynomial time.** (Anything in P reduces to anything, trivially.)
- ✅ **A is in P.**
- ✅ **It is unknown whether B can be reduced to A in polynomial time.** (That would put an
  NP-complete problem in P.)
- ✅ **It is unknown whether B is in P.**

And the four false ones: "B can be reduced to A", "B is in P", "it is unknown whether A reduces to
B", "it is unknown whether A is in P".

Your explanation needs: (i) name the NP-complete problem B is equivalent to and map the pieces onto
it, (ii) give the polynomial algorithm for A, (iii) say that a problem in P reduces to anything, and
(iv) say that since we don't know whether NP-complete problems are in P, the reverse direction is
open.

---

## 14. Task 2 — Recurrence from code, and code from recurrence (4 pts)

Two directions appear. Groups A/B give the algorithm and ask for T(n); Groups C+ give T(n) and ask
you to fill in blanks in the algorithm.

**Direction 1 — read off T(n) = a·T(n/b) + Θ(f(n)):**
- **a = total number of recursive calls.** Count *all* of them across *all* loops. A `while i > n−9`
  starting at i = n and decrementing runs **9** times; a `for i = 1 to 5` runs 5. Total a = **14**.
- **b** comes from the subproblem size `m = ⌈n/d⌉`, so b = d. Watch for d being computed
  (`d = 3·3` → **b = 9**).
- **f(n) = the non-recursive work.** Usually a loop bound built up in stages:
  `p = n·n·n·n` then `for j = 1 to p·(n·n)` → n⁴·n² = **Θ(n⁶)**.
- Copy_Sub_Array costs Θ(m) = Θ(n/b) = Θ(n), which is dominated by f(n) — mention it, then drop it.

Group A answer: **T(n) = 14T(⌈n/9⌉) + Θ(n⁶)**.

**Direction 2 — fill the blanks to match a target recurrence.** Same equations, solved backwards:
- Target T(n) = 17T(⌈n/30⌉) + Θ(n⁸).
- The code has `m = ⌈n/(6·d)⌉` → need 6d = 30 → **d = 5**.
- The code has one loop making 6 calls and another making `?` calls → 6 + ? = 17 → **? = 11**.
- The code has `w = 1; for j = 1 to ?: w = w·n` then `for k = 1 to w` → w = n^? and we need Θ(n⁸)
  → **? = 8**.

Set up the three equations, solve, done.

---

## 15. Task 1 — Complete the Python function (5 pts)

Multiple choice from ~15 labelled snippets, 4–5 blanks. The functions are versions of the course's
**programming assignments**, so your own submitted code is the best possible revision material.

**Seen so far:**
- **Binary search on a reverse-sorted array** (Groups A, B): `left = -1; right = n-1`,
  `while left < right`, `p = (left+right+1)//2`, `if x > a[p]: right = p-1 else: left = p`.
  Note the `+1` in the midpoint and `left = p` (not `p+1`) — this is the "find the last position
  satisfying a predicate" variant, and getting the off-by-one right is the whole task.
- **Falling blocks / height dictionary** (Groups C–H): `heights = {}`, then per position
  `if x not in heights: heights[x] = 1 else: heights[x] += 1`, then `if heights[x] == h: return x`.
  Uses a **dict**, not a list — coordinates may be arbitrarily large, so `[0]*max(pos)` is wrong.

**Technique if you're unsure:** pick a tiny concrete input (n = 3, or two drop positions) and
mentally execute each candidate. Also use the structural hints the paper gives — it tells you which
lines start with `while` and `if`, which eliminates most options immediately.

---

## 16. Reference: everything else (skim only if you have spare time)

### Sorting

| Algorithm | Worst case | Extra space | Stable |
|---|---|---|---|
| Insertion | Θ(n²) (Θ(n) if sorted) | Θ(1) | Yes |
| Merge | Θ(n log n) | Θ(n) | Yes |
| Quick | Θ(n²) worst, Θ(n log n) expected | Θ(log n) | No |
| Heap | Θ(n log n) | Θ(1) | No |
| Counting | Θ(n+k) | Θ(n+k) | Yes |
| Radix | Θ(d(n+k)) | Θ(n+k) | Yes |

Comparison-based sorting is **Ω(n log n)** — log₂(n!) = Θ(n log n) possible orderings to distinguish.
Counting sort beats it by not comparing. Radix sort goes **least significant digit first** and
**depends on the inner sort being stable**.

### Data structure costs

| | Search | Insert | Remove |
|---|---|---|---|
| Array indexed by keys | Θ(1) | Θ(1) | Θ(1) |
| Unsorted array | Θ(n) | Θ(1) if key known new | Θ(n) |
| Sorted array | Θ(log n) | Θ(n) | Θ(n) |
| Sorted linked list | Θ(n) | Θ(n) | Θ(1) given node |
| Hash table (chaining) | Θ(1) avg / **Θ(n) worst** | Θ(1) avg | Θ(1) avg |
| BST | Θ(h) — **Θ(n) if input sorted** | Θ(h) | Θ(h) |
| AVL | Θ(log n) | Θ(log n) | Θ(log n) |
| Heap | — | Θ(log n) | Θ(log n) extract-max |

Dynamic array with **doubling** → **Θ(1) amortised** insertion (copies at 1,2,4,…,n sum to < 2n).
Hash function h(k) = k mod p, collisions by **separate chaining** in this course.

### Graph algorithms

| | Purpose | Time | Notes |
|---|---|---|---|
| BFS | shortest (fewest edges) | Θ(n+m) | queue |
| DFS | traversal, components | Θ(n+m) | stack |
| Dijkstra | cheapest, single source | Θ((n+m) log n) | **nonnegative weights only** |
| Floyd–Warshall | cheapest, all pairs | Θ(n³) | negatives OK, no negative cycles |
| Kruskal | MST | Θ(m log m) | cheapest edge with no cycle; find–union |

Adjacency matrix Θ(n²) space, Θ(1) edge query. Adjacency lists Θ(n+m) space — the default.
**Shortest ≠ cheapest.** A minimal spanning subgraph is a tree **only if all weights are positive**.
2-colouring / bipartiteness = BFS by levels, restart per component, O(n+m).

### Dynamic programming
Backtracking → memoisation (dict + `if k not in mem` guard) → bottom-up array → `mem[k % c]` for
space. Signals: **overlapping subproblems + optimal substructure**. Greedy fails on knapsack.
Non-adjacent cells: `mem[k] = max(mem[k−1], mem[k−2] + a[k])`.
Prefix sums: build Θ(n), query Θ(1); 1D `P[r+1] − P[ℓ]`, 2D `c1 − c2 − c3 + c4`.

### Divide and conquer
Karatsuba: 3 multiplications instead of 4 → T = 3T(n/2)+Θ(n) = Θ(n^{1.585}).
Strassen: 7 instead of 8 → Θ(n^{2.807}).

### Loop invariants (the theory behind task 12)
Prove by **initialisation** (true before the first iteration) + **maintenance** (survives one
iteration) + **termination** (combine the invariant with the negated loop condition). An invariant
alone isn't a correctness proof — you must also show the loop ends.

---

## 17. Cram sheet — read at 07:45, nothing else

```
90 min, 13 tasks, 60+4 pts. Alphabetical order for neighbours. log = log2. Worst case.
HEIGHT = NUMBER OF NODES incl. self. Leaf = 1. NONE = 0.

T3 MASTER: c = log_b a (write a as a power of b!). d<c→Θ(n^c) | d=c→Θ(n^c log n) | d>c→Θ(n^d)
T4 SIMPLIFY: constants→1, transform, keep fastest.  log n < n^ε < n < n² < 2ⁿ < 4ⁿ
    log(n^k)=k log n | log_3(9^n)=2n | 2^{2log2 n}=n² | (10^{log10 n})^10=n^10 | n^{3/6+3/6}=n
    NEVER 4ⁿ→2ⁿ. Multiple params: keep all incomparable terms.
T5 HEAP: children 2i, 2i+1; parent ⌊i/2⌋. j = the CHILD index. new value = max(a[2j], a[2j+1]).
T6 DIJKSTRA: pick smallest unmarked, relax neighbours alphabetically, tick when done.
    CHECK: dist[w] == dist[parent[w]] + c(parent[w],w) for EVERY w.
T7 GRAPH: read upper triangle only. Route hard edges as arcs AROUND the outside. Draw all edges.
T8 BST: strict < left, > right. No restructuring. Duplicate key = no change.
    CHECK: in-order traversal must come out sorted.
T9 DS: worst-case guarantee → NOT hash table. Small key range + contiguous → array indexed by keys.
    Answer in 4 parts: name / mapping / complexity / why each other option loses.
T10 AVL: annotate EVERY node's height bottom-up. h(v)=1+max(children). Violation = children differ ≥2.
    Ties → alphabetically smallest.
T11 FLOYD-WARSHALL stopped at K: cheapest path using ONLY vertices 1..K INTERNALLY. Else INF.
    The hub vertex is usually > K → all its shortcuts are FORBIDDEN. Exactly 2 INFs.
T12 INVARIANT: Δ per iteration. Preservation A·Δx + C·Δe = 0. Init A·x₀+C·e₀ = D.
    Find the two constants that agree; change the third.
T13 BONUS: A is in P, B is NP-complete. TRUE: A→B reduction exists | A in P |
    unknown if B→A | unknown if B in P.

ORDER TO ATTEMPT: 3, 4, 12, 8, 5 (quick wins) → 6, 11, 10 (big mechanical) → 2, 9, 7 → 1 → 13.
```

---

## 18. Practice plan for Saturday morning

Groups A and B are worked through above, so they're spoiled. **Use Group E or F as a clean mock.**
Do it in 90 minutes with a timer, then mark it against the printed answers.

If you only have 45 minutes, do just tasks 3, 4, 5, 6, 11, 12 from one group — that's 33 points and
takes about half an hour once you're fluent.
