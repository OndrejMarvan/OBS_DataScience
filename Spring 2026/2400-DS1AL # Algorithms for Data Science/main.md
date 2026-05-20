
## Lab 1 (25.02.2026)
Task 1.1: Coin Problem You are given eight equally looking coins and a pair of scales. One of the coins is forged and has smaller weight, whereas all the other coins weigh the same. A single weighing on the scales consists of comparing the weight of any two (disjoint) subsets of the coins. Note that the weighting instrument does not show the actual weight. 
(a) Can you find the forged coin by using the scales three times? 
(b) Is it possible to find it using the scales only two times? 
(c) If we are allowed to do k weighings, what is the maximum number of coins among which we can find the forged coin?

## Solution

### (a) Three Weighings for 8 Coins — Yes

A balance scale has **three possible outcomes** per weighing: left side lighter, right side lighter, or balanced. With 3 weighings we have 3 × 3 × 3 = 27 distinguishable outcome sequences, far more than enough to pinpoint 1 fake among 8. Here is an explicit strategy:

**Weighing 1:** {1, 2, 3} vs {4, 5, 6}

- **Left lighter** → fake is in {1, 2, 3}. Weigh 1 vs 2: the lighter one is fake; if balanced, coin 3 is fake.
- **Right lighter** → fake is in {4, 5, 6}. Weigh 4 vs 5: same logic.
- **Balanced** → fake is in {7, 8}. Weigh 7 vs 8: the lighter one is fake.

This finds the fake in at most 2 further weighings, so 3 total. ✓

### (b) Two Weighings for 8 Coins — Yes!

Since each weighing has 3 outcomes, two weighings give 3 × 3 = 9 distinguishable sequences, and 9 ≥ 8, so two weighings are enough in principle. The strategy from part (a) already demonstrates this: after the very first weighing we are left with at most 3 candidates, and one more weighing always resolves 3 candidates. The table below makes it explicit.

|Outcome of Weighing 1|Candidates|Weighing 2|How it resolves|
|---|---|---|---|
|Left lighter|{1, 2, 3}|1 vs 2|lighter one is fake; balanced → coin 3 is fake|
|Right lighter|{4, 5, 6}|4 vs 5|lighter one is fake; balanced → coin 6 is fake|
|Balanced|{7, 8}|7 vs 8|lighter one is fake (balanced is impossible since the fake exists)|

All 8 coins are resolved in exactly 2 weighings. ✓

Note: Dividing by 3 is so called **Tertiary** 

### (c) Maximum Coins with k Weighings

**The answer is 3^k coins.**

**Why we cannot do better.** Each weighing has 3 outcomes, so k weighings produce at most 3^k distinct outcome sequences. To uniquely identify the fake coin, each coin must correspond to a different sequence of outcomes, meaning we need at least as many sequences as coins. Therefore the number of coins cannot exceed 3^k.

**Why 3^k is always achievable.** At each step, divide the current candidate set into three equal groups (or as equal as possible). Weigh the first group against the second:

- If the first group is lighter, the fake is there.
- If the second group is lighter, the fake is there.
- If they balance, the fake is in the third group.

In every case the candidate pool shrinks to one third of its size. After k weighings the pool has been divided k times, handling up to 3^k coins total.

A few values for reference:
|k (weighings)|Maximum coins|
|---------------------|-----------------------|
|0                        |                             |
|1                        |                           3|
|2                        |                           9|
|3                        |                         27|
|4                        |                         81|

| First name | Last name |
| ---------- | --------- |
| Max        | Planck    |
| Marie      | Curie     |


So the maximum number of coins among which we can find the forged one with k weighings is exactly **3^k**.


Task 1.2: Divide by Two In this task, we want to divide a given integer by two without using the division operation. Consider the following algorithm. Algorithm 1: Input: integer n ≥ 0 Output: the value n/2 (possibly fractional) ℓ = 0 r = n while ℓ ̸= r do ℓ = ℓ + 1 r = r − 1 return ℓ 
(a) How often does the while loop repeat in dependence of n? 
(b) The program is not correct. What is the error? Fix the mistake! 
(c) Prove the correctness of the fixed algorithm with a loop invariant. Show also that the algorithm terminates.

E.g. Num 4 goes: 
1. 0 and 4
2. 1 and 3
3. 2 and 2

## Solution

### (a) Number of Loop Iterations

At each iteration, ℓ increases by 1 and r decreases by 1, so the difference r − ℓ shrinks by 2 per iteration. Initially r − ℓ = n.

**If n is even:** after n/2 iterations we reach ℓ = r = n/2, and the loop exits. The loop runs **n/2 times**.

**If n is odd:** after (n−1)/2 iterations we have ℓ = (n−1)/2 and r = (n+1)/2, so ℓ ≠ r and we enter another iteration, giving ℓ = (n+1)/2 and r = (n−1)/2. Now ℓ and r have **crossed**: ℓ > r, yet ℓ ≠ r still holds and they keep diverging. The loop **never terminates**.

### (b) The Error and the Fix

**The error** is that the loop condition `ℓ ≠ r` is never satisfied when n is odd, because ℓ and r skip past each other and diverge. The algorithm runs forever on any odd input.

**The fix:** replace the condition `ℓ ≠ r` with `r − ℓ > 1`. The corrected algorithm is:

```
ℓ = 0
r = n
while r − ℓ > 1 do
    ℓ = ℓ + 1
    r = r − 1
return ℓ
```

Checking small cases:
|n|Exits with (ℓ, r)|Returns ℓ|Correct floor(n/2)|
|---|---|---|---|
|0|(0, 0)|0|0 ✓|
|1|(0, 1)|0|0 ✓|
|2|(1, 1)|1|1 ✓|
|3|(1, 2)|1|1 ✓|
|4|(2, 2)|2|2 ✓|
|5|(2, 3)|2|2 ✓|

The algorithm correctly computes floor(n/2) for all n ≥ 0.

### (c) Correctness Proof via Loop Invariant

**Loop invariant:** At the start of every iteration (and after the loop), the following holds:

> ℓ + r = n, and ℓ ≤ r.

**Initialization.** Before the first iteration, ℓ = 0 and r = n, so ℓ + r = n and ℓ ≤ r (since n ≥ 0). The invariant holds.

**Maintenance.** Assume the invariant holds at the start of an iteration, with r − ℓ > 1 (so the loop is entered). After the step we have ℓ' = ℓ + 1 and r' = r − 1. Then ℓ' + r' = (ℓ+1) + (r−1) = ℓ + r = n, preserving the first part. Also r' − ℓ' = (r−1) − (ℓ+1) = r − ℓ − 2. Since r − ℓ > 1 and r − ℓ is an integer, r − ℓ ≥ 2, so r' − ℓ' ≥ 0, meaning ℓ' ≤ r'. The invariant is maintained.

**Termination.** The value r − ℓ is a non-negative integer that decreases by exactly 2 at each iteration. It must eventually reach a value ≤ 1 (either 0 or 1), at which point the condition r − ℓ > 1 is false and the loop exits. Therefore the algorithm always terminates.

**Correctness on exit.** When the loop exits, the invariant gives ℓ + r = n and ℓ ≤ r, and the negated guard gives r − ℓ ≤ 1. Since ℓ ≤ r we have r − ℓ ∈ {0, 1}.

- If n is **even**: r − ℓ must be 0 (because ℓ + r = n is even, so r − ℓ has the same parity as n, which is even, ruling out r − ℓ = 1). Thus ℓ = r = n/2, and the algorithm returns n/2. ✓
- If n is **odd**: r − ℓ must be 1 (same parity argument). Thus r = ℓ + 1, and ℓ + (ℓ+1) = n, giving ℓ = (n−1)/2 = floor(n/2). ✓

In both cases the algorithm returns **floor(n/2)**, which equals n/2 for even n and is the natural interpretation of "n divided by 2" for odd n. □


==Q of Prof: Looping invariant== = A loop invariant is a condition that is true immediately before and immediately after each iteration of a loop.  It serves as a logical assertion about the relationship between variables in a loop, ensuring the loop maintains correctness throughout its execution.

This may appear in exam (above)


Task 1.4: Curtain Problem - a real-world problem brought by the lecturer’s wife Suppose that you washed the curtain of your window and now you want to hang it up again. To do so, you have to attach the curtain to the five ring clips lying loosely on a rod above the window. It is important that the clips are equally spaced on the curtain, otherwise it won’t look nice. Unfortunately, you don’t have any tool to measure the distances in order to find the right position for attaching the clips. However, you are a smart student and you want to use gravity and the idea underlying binary search to solve this problem. Equally attached clips. curtain clip Only three clips attached yet. rod 
![[Pasted image 20260225192616.png]]
(a) Describe how to find equally spaced positions for the clips. Note that you can move the ring clips along the rod and that the curtain is obeying the laws of gravity. Your first step is to attach the top corners of the curtain to the left- and right-most clip. 
(b) Does your procedure also work for seven clips? 
(c) For what numbers of clips does your procedure work?

## Solution

### (a) Procedure for 5 Clips

**Key physical insight:** When a curtain hangs freely from exactly two points, gravity pulls it into a symmetric curve (a catenary). The lowest point of the curtain hangs at **exactly the horizontal midpoint** between the two attachment points. This gives us a perfect, tool-free midpoint finder.

The procedure mirrors binary search by repeatedly bisecting intervals:

**Step 1.** Attach the top-left corner of the curtain to the leftmost clip (clip 1) and the top-right corner to the rightmost clip (clip 5). Let the curtain hang — its lowest point is the exact midpoint of the whole width. Attach clip 3 there.

**Step 2.** Now attach the curtain between clip 1 and clip 3 only. The lowest point is the midpoint of that half. Attach clip 2 there.

**Step 3.** Attach the curtain between clip 3 and clip 5. The lowest point is the midpoint of the right half. Attach clip 4 there.

All five clips are now equally spaced: the four gaps are each exactly one quarter of the total curtain width. The procedure uses **3 weighings** (one per step), mirroring how binary search on 4 intervals needs log2(4) = 2 bisection levels plus the initial attachment.

### (b) Does It Work for 7 Clips?

**No.** With 7 clips there are 6 equal gaps needed. After Step 1 we place clip 4 at the midpoint of the whole width (splitting into two halves of 3 gaps each). We then bisect each half, placing clips 2 and 6 at the quarter-points (splitting each half into segments of 1.5 gaps). At this point the segments are no longer bisectable into whole equal pieces — the next midpoints would land at the 1/8-positions of the whole curtain, giving spacings of 1/8 and 1/8, not 1/6 and 1/6. The binary bisection procedure does **not** produce equal spacing for 7 clips.

### c) General Rule: Which Numbers of Clips Work?

The procedure works if and only if the number of gaps (which is one less than the number of clips) is a **power of 2**.

**Why:** Each round of bisection doubles the number of attached clips minus 1, i.e., it doubles the number of placed intervals. Starting from 1 interval (the full width), after k rounds we have 2^k equally spaced intervals and therefore 2^k + 1 clips. If the number of required gaps is not a power of 2, the bisection points never align with the required equal-spacing positions.

The procedure works exactly for clip counts of the form:

> **n = 2^k + 1** for some integer k ≥ 1

That is: **3, 5, 9, 17, 33, 65, ...**

|k|n = 2^k + 1|Bisection rounds needed|
|---|---|---|
|1|3|1|
|2|5|2|
|3|9|3|
|4|17|4|

For any such n, the procedure places all n clips in exactly k = log2(n−1) steps, each step bisecting all current open intervals simultaneously — a direct physical analogue of binary search.

===Calculator may be needed but we won't be in need for calc during exam=

## Solution

### Useful reference values

- 1 minute = 60 seconds
- 1 hour = 3 600 seconds
- 1 day = 86 400 seconds
- 1 year ≈ 31 557 600 seconds ≈ 3.16 × 10^7 seconds
- "—" means the running time exceeds 10 years

---

### Part (a): 10 operations per second

Each operation takes 0.1 seconds. Time = (number of operations) / 10.

|n|log2 n|n|n log2 n|n^2|2^n|
|---|---|---|---|---|---|
|10|0.3 sec|1 sec|3 sec|10 sec|1 min 42 sec|
|20|0.4 sec|2 sec|9 sec|40 sec|1 day 5 hours|
|21|0.4 sec|2 sec|9 sec|44 sec|2 days 10 hours|
|1 000|1 sec|1 min 40 sec|17 min|1 day 4 hours|—|
|1 000 000|2 sec|1 day 4 hours|23 days|—|—|
|1 000 000 000|3 sec|3 years|—|—|—|

**Selected calculations for part (a):**

- n=10, 2^n: 2^10 = 1024 ops → 102.4 sec ≈ 1 min 42 sec
- n=20, 2^n: 2^20 = 1 048 576 ops → 104 858 sec ≈ 1 day 5 hours
- n=10^6, n^2: 10^12 ops → 10^11 sec ≈ 3 170 years → ignored
- n=10^9, n: 10^9 ops → 10^8 sec ≈ 3.17 years

---

### Part (b): 1 000 000 operations per second

Each operation takes 1 microsecond (μs). Time = (number of operations) / 1 000 000.

|n|log2 n|n|n log2 n|n^2|2^n|
|---|---|---|---|---|---|
|10|3 μs|10 μs|33 μs|100 μs|1 ms|
|20|4 μs|20 μs|86 μs|400 μs|1 sec|
|21|4 μs|21 μs|92 μs|441 μs|2 sec|
|1 000|10 μs|1 ms|10 ms|1 sec|—|
|1 000 000|20 μs|1 sec|20 sec|11 days|—|
|1 000 000 000|30 μs|17 min|8 hours|—|—|

**Selected calculations for part (b):**

- n=20, 2^n: 2^20 = 1 048 576 ops → 1.05 sec ≈ 1 sec
- n=1000, 2^n: 2^1000 ≈ 10^301 ops → way beyond 10 years
- n=10^6, n^2: 10^12 ops → 10^6 sec ≈ 11.6 days
- n=10^9, n log2 n: 29.9 × 10^9 ops → 29 900 sec ≈ 8.3 hours

---

### Key observations

The two tables together illustrate a fundamental point. Increasing computing speed by a factor of 100 000 (from 10 to 1 000 000 ops/sec) makes the polynomial algorithms (log n, n, n log n, n^2) dramatically faster — but it barely helps the exponential algorithm (2^n). For n = 20 the exponential algorithm drops from over a day to just 1 second, but already at n = 1000 it is untouchable regardless of hardware. This is why the distinction between polynomial and exponential algorithms matters far more than the speed of the machine.

Task 1.5: Guess my number!—Level 2 Consider the variant of the game Guess my number! when there is no upper bound on the integer number x to be guessed. We only know x ≥ 8. Propose an algorithm to solve the problem using at most c · log2 x questions where c can be any constant number that does not depend on x; e.g. c = 8. Hint: First, try to find an upper bound r of x with as few questions as possible. Then, run Binary Search from the lecture. You can assume that it needs only log2 n questions when n is the size of the given interval containing x.

## Solution

### The Core Challenge

In standard binary search we need a known interval [l, r] containing x. Here we have no upper bound, so we must first **find one** — and we must do so cheaply enough that the total question count stays within c · log2 x.

---

### Phase 1: Finding an Upper Bound by Doubling

Start with r = 8 (the given lower bound) and repeatedly double r, asking "Is x ≤ r?" until the answer is yes.

```
r = 8
while x > r do
    r = r * 2
```

When the loop exits, we know:

> r / 2 < x ≤ r

So x lies in the interval (r/2, r] of size r/2. We also know r ≤ 2x, since we only doubled past x once — the previous value r/2 was still below x, meaning r/2 < x, so r < 2x, thus **r ≤ 2x**.

**How many questions did Phase 1 use?**

Each iteration doubles r, starting from 8 = 2^3. After k iterations r = 2^(3+k). The loop stops when r ≥ x, i.e. when 2^(3+k) ≥ x, i.e. when k ≥ log2 x − 3. So the loop runs at most **log2 x** iterations, using at most log2 x questions.

---

### Phase 2: Binary Search in the Found Interval

We now run standard binary search on the interval (r/2, r], which has size r/2 ≤ x. By the assumption from the problem, binary search on an interval of size n needs log2 n questions. Here n = r/2 ≤ x, so Phase 2 uses at most **log2 x** questions.

---

### Total Question Count

Total questions ≤ (Phase 1) + (Phase 2) ≤ log2 x + log2 x = **2 · log2 x**

This satisfies the requirement with constant **c = 2**, which is much better than the allowed c = 8.

---

### Full Algorithm

```
// Phase 1: find upper bound
r = 8
while "Is x > r?" → yes:
    r = r * 2

// Now we know r/2 < x ≤ r
// Phase 2: binary search on (r/2, r]
l = r / 2
while l + 1 < r:
    m = (l + r) / 2
    if "Is x ≤ m?" → yes:
        r = m
    else:
        l = m

// x = r (or x = l+1, the only remaining candidate)
```

---

### Why the Doubling Strategy is Essential

If instead we incremented r by a fixed step s, we would need x/s questions in Phase 1, which grows linearly in x — far too slow. Doubling ensures Phase 1 costs only logarithmically many questions, matching the cost of Phase 2, so the two phases together stay within **c · log2 x** for a small constant c.


# Lab 2 (11.03.2026)
Cheatsheet is allowed during the exam but will be checked if not including something else as well. 
log of n grows slower than linear function... -> faster algorithm will grow slower than slow algorithm 

Transformation rules to follow in docs!

**Exam** Simplification of formulas (photo in phone)

# AFDS – Exercise 2 Solutions

## Task 2.1: Oh-Notation
$\Theta$ = Theta

### (a) Do you know which algorithm is faster?

**No.** $O$-notation only gives an **upper bound**, not a tight bound. Saying $A$ is $O(n \log n)$ means its running time is _at most_ roughly $n \log n$ — but it could be much less. Same for $B$ being $O(n^2)$. Without $\Theta$-bounds, we can't compare them. $B$ might actually run in $O(1)$ for all we know.

---

### (b) $\Theta(10 \cdot n^2 + 978 \cdot n + n \cdot n \cdot 2 \cdot n / 1000)$

Simplify each term:

- $10 \cdot n^2 \to n^2$
- $978 \cdot n \to n$
- $n \cdot n \cdot 2 \cdot n / 1000 = \frac{2}{1000} n^3 \to n^3$

We get $\Theta(n^2 + n + n^3)$. The dominant term is $n^3$.

$$\boxed{\Theta(n^3)}$$

---

### (c) $\Theta!\left(1000 (\log_5 n)^{1000} + \sqrt{n} \cdot 2000 + (11/10)^n\right)$

Simplify each term:

- $1000 (\log_5 n)^{1000} \to (\log n)^{1000}$ — a polylogarithmic function
- $\sqrt{n} \cdot 2000 \to n^{1/2}$ — a polynomial
- $(11/10)^n = 1.1^n$ — an exponential

By **LOG < POL**: $(\log n)^{1000}$ grows slower than $n^{1/2}$. By **POL < EXP**: $n^{1/2}$ grows slower than $1.1^n$.

$$\boxed{\Theta(1.1^n)}$$

---

### (d) $\Theta!\left(4 \cdot n^{1/4} \cdot n^{0.25} + 2^{(2n)^2 / n} + 50 \log^2(100n) + \log_3(9^n)\right)$

Simplify each term:

**Term 1:** $4 \cdot n^{1/4} \cdot n^{0.25} = 4 \cdot n^{1/4 + 1/4} = 4 \cdot n^{1/2} \to n^{1/2}$

**Term 2:** $2^{(2n)^2/n} = 2^{4n^2/n} = 2^{4n} \to 2^{4n}$. This is exponential.

**Term 3:** $50 \log^2(100n) \to \log^2 n$. Since $\log(100n) = \log 100 + \log n = \Theta(\log n)$.

**Term 4:** $\log_3(9^n) = n \cdot \log_3 9 = n \cdot 2 = 2n \to n$. This is linear.

Now compare: $\log^2 n < n^{1/2} < n$ by LOG < POL, and $n < 2^{4n}$ by POL < EXP.

$$\boxed{\Theta(2^{4n})}$$

> Note: $2^{4n} = (2^4)^n = 16^n$, so equivalently $\Theta(16^n)$.

---

### (e) $\Theta(91n + n^2 \cdot 4n^2 + 3\log n + 42n^3)$

Simplify:

- $91n \to n$
- $n^2 \cdot 4n^2 = 4n^4 \to n^4$
- $3 \log n \to \log n$
- $42n^3 \to n^3$

Ordering: $\log n < n < n^3 < n^4$.

$$\boxed{\Theta(n^4)}$$

---

### (f) $\Theta(1000^{1000^{1000}} + \frac{1}{2} \cdot 1.0001^n + 40 \cdot n^{100})$

- $1000^{1000^{1000}}$ is a gigantic but **constant** $\to 1$.
- $\frac{1}{2} \cdot 1.0001^n \to 1.0001^n$ — exponential.
- $40 \cdot n^{100} \to n^{100}$ — polynomial.

By POL < EXP: $n^{100}$ grows slower than $1.0001^n$.

$$\boxed{\Theta(1.0001^n)}$$

---

### (g) $\Theta(5\log(5n))$

$5\log(5n) = 5(\log 5 + \log n) = 5\log 5 + 5\log n$.

Drop the constant $5\log 5$ and the constant factor $5$:

$$\boxed{\Theta(\log n)}$$

---

### (h) $\Theta(5 \cdot 2^{5n+5})$

$5 \cdot 2^{5n+5} = 5 \cdot 2^5 \cdot 2^{5n} = 160 \cdot 2^{5n}$.

Drop the constant factor. Also $2^{5n} = (2^5)^n = 32^n$.

$$\boxed{\Theta(32^n)}$$

---

### (i) $\Theta(42m + k/100 + m \cdot 21 \cdot k + 22\log_2 n)$

Simplify:

- $42m \to m$
- $k/100 \to k$
- $21mk \to mk$
- $22\log_2 n \to \log n$

Since $m \leq mk$ and $k \leq mk$, those are dominated. We keep $mk$ and $\log n$ (they depend on different parameters, so we can't drop either).

$$\boxed{\Theta(mk + \log n)}$$

---

## Task 2.2: Oh-Notation++

### (a) Order by growth rate

First, let's simplify some of the functions:

- $\log(n^2) = 2\log n = \Theta(\log n)$
- $4^{\log n} = (2^2)^{\log n} = 2^{2\log n} = n^2$
- $2^{\sqrt{2}\log n}$: note $2^{\log n} = n$, so $2^{\sqrt{2}\log n} = n^{\sqrt{2}} \approx n^{1.414}$

So the list becomes:

| Original             | Simplified                       |
| -------------------- | -------------------------------- |
| $\log(n^2)$          | $\log n$                         |
| $(\log n)^2$         | $(\log n)^2$                     |
| $\sqrt{n}$           | $n^{0.5}$                        |
| $2^{\sqrt{2}\log n}$ | $n^{\sqrt{2}} \approx n^{1.414}$ |
| $n^2$                | $n^2$                            |
| $4^{\log n}$         | $n^2$                            |
| $n!$                 | $n!$                             |
| $2^n$                | $2^n$                            |
| $n \cdot 2^n$        | $n \cdot 2^n$                    |

**Ordered from slowest to fastest growth:**

$$\log n ;<; (\log n)^2 ;<; n^{0.5} ;<; n^{\sqrt{2}} ;<; n^2 = 4^{\log n} ;<; 2^n ;<; n \cdot 2^n ;<; n!$$

Justification of key steps:

- $\log n < (\log n)^2$: for large $n$, squaring a growing function makes it bigger.
- $(\log n)^2 < n^{0.5}$: by LOG < POL.
- $n^{0.5} < n^{\sqrt{2}} < n^2$: polynomial with increasing exponents.
- $n^2 < 2^n$: by POL < EXP.
- $2^n < n \cdot 2^n$: multiplying by $n$ makes it grow faster.
- $n \cdot 2^n < n!$: Stirling's approximation gives $n! \approx (n/e)^n$, which dominates $n \cdot 2^n$.

---

### (b) Is $f(n) + g(n) = \Theta(\max(f(n), g(n)))$?

**Yes.** (Assuming $f, g \geq 0$.)

**Upper bound ($O$):** $f(n) + g(n) \leq \max(f,g) + \max(f,g) = 2 \cdot \max(f(n), g(n))$. So $f + g = O(\max(f,g))$ with $C = 2$.

**Lower bound ($\Omega$):** $f(n) + g(n) \geq \max(f(n), g(n))$. So $f + g = \Omega(\max(f,g))$ with $C = 1$.

Together: $f(n) + g(n) = \Theta(\max(f(n), g(n)))$. $\blacksquare$

---

### (c) Is $(n + 100)^5 = \Theta(n^5)$?

**Yes.**

**Upper bound:** For $n \geq 1$: $n + 100 \leq n + 100n = 101n$, so $(n+100)^5 \leq (101n)^5 = 101^5 \cdot n^5$. Take $C = 101^5$.

**Lower bound:** $(n+100)^5 \geq n^5$ always. Take $C = 1$.

So $(n+100)^5 = \Theta(n^5)$. $\blacksquare$

---

### (d) Is $\log_3 n + \log_5 n = \Theta(\log_7 n)$?

**Yes.** All logarithm bases differ only by constant factors:

$$\log_a n = \frac{\log_b n}{\log_b a}$$

So $\log_3 n = \frac{\log n}{\log 3}$ and $\log_5 n = \frac{\log n}{\log 5}$ and $\log_7 n = \frac{\log n}{\log 7}$.

Then: $\log_3 n + \log_5 n = \left(\frac{1}{\log 3} + \frac{1}{\log 5}\right) \log n = \Theta(\log n) = \Theta(\log_7 n)$. $\blacksquare$

---

### (e) Is $300\log(n^{n^k}) + k^k + 2^{\sqrt{k}\log k} = O(n\log n + 2^{k\log k})$?

Simplify the left side:

- $300\log(n^{n^k}) = 300 \cdot n^k \cdot \log n \to n^k \log n$
- $k^k = 2^{k \log k}$ (since $k^k = (2^{\log k})^k = 2^{k\log k}$)
- $2^{\sqrt{k}\log k} = k^{\sqrt{k}}$, which grows slower than $k^k = 2^{k\log k}$ for large $k$

So the left side is $\Theta(n^k \log n + 2^{k\log k})$.

The right side is $O(n\log n + 2^{k\log k})$.

For general $k$, $n^k \log n$ is not bounded by $n \log n$ (e.g. if $k = 2$, then $n^2 \log n$ is not $O(n\log n)$).

**No**, the statement does not hold in general. $\blacksquare$

> It would hold if $k$ is a fixed constant with $k \leq 1$, but for arbitrary $k$ it fails.

---

## Task 2.3: Oh-Notation Definitions

### (a) Multi-parameter Big-O

$f(n_1, \dots, n_i) = O(g(n_1, \dots, n_i))$ if there exist constants $C > 0$ and $n_0 \geq 0$ such that for all $n_1, \dots, n_i \geq n_0$:

$$f(n_1, \dots, n_i) \leq C \cdot g(n_1, \dots, n_i)$$

---

### (b) Prove $f(n) = \Omega(g(n))$ iff $g(n) = O(f(n))$

**($\Rightarrow$):** Assume $f(n) = \Omega(g(n))$. Then there exist $C > 0$ and $n_0$ such that for all $n \geq n_0$:

$$f(n) \geq C \cdot g(n)$$

Rearranging: $g(n) \leq \frac{1}{C} \cdot f(n)$.

Set $C' = 1/C > 0$. Then $g(n) \leq C' \cdot f(n)$ for all $n \geq n_0$, which means $g(n) = O(f(n))$.

**($\Leftarrow$):** Symmetric. Assume $g(n) = O(f(n))$, so $g(n) \leq C' \cdot f(n)$ for all $n \geq n_0$. Then $f(n) \geq \frac{1}{C'} \cdot g(n)$, so $f(n) = \Omega(g(n))$. $\blacksquare$

---

## Task 2.4: Airfield (Longest Plateau)

### Algorithm

Scan through the array once, tracking the current plateau and the best plateau found so far.

```
LongestPlateau(h[1..n]):
    bestStart = 1
    bestLen = 1
    curStart = 1
    curLen = 1

    for i = 2 to n:
        if h[i] == h[i-1]:
            curLen = curLen + 1
        else:
            curStart = i
            curLen = 1

        if curLen > bestLen:
            bestLen = curLen
            bestStart = curStart

    return bestStart
```

### Running time

We do a single pass through the array with constant work per element.

$$\boxed{\Theta(n)}$$

---

## Task 2.5: Forest Age / Salary Database

### (a) $O(1)$ extra memory solution

With only constant extra memory, for each query $q[j]$, we scan through the entire database $d$ and count matches.

```
NaiveCounting(d[1..n], q[1..m], k):
    for j = 1 to m:
        count = 0
        for i = 1 to n:
            if d[i] == q[j]:
                count = count + 1
        res[j] = count
    return res
```

**Running time:** For each of the $m$ queries, we scan all $n$ elements.

$$\boxed{\Theta(m \cdot n)}$$

---

### (b) $O(n + m + k)$ solution using counting

Use the **counting technique**: build a frequency array of size $k+1$ that counts how many times each value appears in $d$. Then answer each query in $O(1)$.

```
CountingAnswer(d[1..n], q[1..m], k):
    // Step 1: build frequency table
    freq[0..k] = new array initialized to 0    // size k+1

    for i = 1 to n:
        if d[i] <= k:
            freq[d[i]] = freq[d[i]] + 1

    // Step 2: answer queries
    for j = 1 to m:
        res[j] = freq[q[j]]

    return res
```

**Running time:** Building `freq` takes $O(n)$, answering queries takes $O(m)$, initializing `freq` takes $O(k)$.

$$\boxed{\Theta(n + m + k)}$$

**Extra memory:** The `freq` array has size $k + 1$.

$$\boxed{\Theta(k)}$$

**Comparison with (a) when $m = \Theta(\sqrt{n})$ and $k = \Theta(m) = \Theta(\sqrt{n})$:**

- (a): $\Theta(m \cdot n) = \Theta(\sqrt{n} \cdot n) = \Theta(n^{3/2})$
- (b): $\Theta(n + m + k) = \Theta(n + \sqrt{n} + \sqrt{n}) = \Theta(n)$

So (b) is significantly faster in this scenario.

---

## Task 2.6: SomeSortingAlgo (Selection Sort)

### (a) Swap function

```
Swap(a, i, l):
    temp = a[i]
    a[i] = a[l]
    a[l] = temp
```

---

### (b) Best and worst case running time

The outer loop runs $n-1$ times. For each iteration $i$, the inner loop runs from $i+1$ to $n-1$ (after the fix), which is about $n - i$ iterations. The total number of inner iterations is:

$$\sum_{i=1}^{n-1}(n - i) = (n-1) + (n-2) + \dots + 1 = \frac{n(n-1)}{2}$$

This sum is the same regardless of the input (no early termination).

$$\boxed{\text{Best case} = \text{Worst case} = \Theta(n^2)}$$

---

### (c) The bug and shortest failing input

**The bug:** In line 5, the condition is `while j < n` but it should be `while j <= n` (or equivalently `j < n+1`). As written, the algorithm never checks the last element `a[n]`.

**Shortest failing input:** $a = [2, 1]$.

- $i = 1$, $minPos = 1$, $j = 2$.
- Inner while: `j < 2` is false → inner loop doesn't execute.
- $minPos = 1 = i$, so no swap. $i$ becomes 2. Outer loop ends.
- Output: $[2, 1]$ — **not sorted.**

**Fix:** Change line 5 from `while j < n` to `while j <= n`.

> Alternatively change to `while j < n + 1`, which is equivalent.

---

### (d) Proof that inner loop finds position of minimum in $a[i..n]$

**Loop invariant (for the inner while loop, lines 4–8):** At the start of each iteration with loop variable $j$, $minPos$ holds the index of a smallest element in $a[i..j-1]$.

**Initialization ($j = i + 1$):** $minPos = i$, and $a[i..i]$ contains only $a[i]$, so $a[minPos]$ is trivially the minimum.

**Maintenance:** Suppose the invariant holds for some $j$. We compare $a[j]$ with $a[minPos]$:

- If $a[j] < a[minPos]$: we set $minPos = j$. Now $minPos$ points to the smallest in $a[i..j]$.
- Otherwise: $a[minPos]$ is still the smallest in $a[i..j]$.

Then $j$ increments to $j+1$, and the invariant holds for the new $j$.

> (Using the fixed version where the condition is $j \leq n$.)

**Termination:** The loop ends when $j = n + 1$. The invariant gives us that $minPos$ is the index of a smallest element in $a[i..n]$. $\blacksquare$

---

### (e) Correctness of the whole algorithm

**Loop invariant (for the outer while, line 2):** At the start of each iteration:

1. $a[1..i-1]$ is sorted non-decreasingly.
2. Every element in $a[1..i-1]$ is $\leq$ every element in $a[i..n]$.
3. $a[1..n]$ is a permutation of the original array.

**Initialization ($i = 1$):** $a[1..0]$ is empty, so (1) and (2) hold vacuously. (3) holds since nothing changed.

**Maintenance:** Assume the invariant holds for iteration $i$. By part (d), the inner loop finds $minPos$ — the index of the minimum of $a[i..n]$.

After `Swap(a, i, minPos)`:

- $a[i]$ now contains the smallest element of $a[i..n]$.
- By (2), all elements in $a[1..i-1]$ are $\leq$ all elements in $a[i..n]$, so in particular $\leq a[i]$.
- So $a[1..i]$ is sorted non-decreasingly.
- Every element in $a[1..i]$ is $\leq$ every element in $a[i+1..n]$ (since we placed the min of $a[i..n]$ at position $i$).
- We only swapped elements, so (3) still holds.

When $i$ increments to $i+1$, the invariant holds for $i+1$.

**Termination:** The loop ends when $i = n$. The invariant gives: $a[1..n-1]$ is sorted and all elements in $a[1..n-1]$ are $\leq a[n]$. So the entire array $a[1..n]$ is sorted. $\blacksquare$

---

## Task 2.7: StrangeAlgo

### (a) Output of StrangeAlgo(1000000000000000, 8941307)

The recursion is `StrangeAlgo(n, k-2)` each time, and:

- $k = 0 \to$ return 0
- $k = 1 \to$ return 1

Since $8941307$ is odd, subtracting 2 repeatedly keeps it odd, so it eventually reaches $k = 1$.

$$\boxed{1}$$

> More generally: output is $0$ if $k$ is even, $1$ if $k$ is odd.

---

### (b) Running time

Each call does:

- Lines 7–10: a loop from 1 to 1000 → $\Theta(1)$ (constant).
- Lines 11–12: a loop from 1001 to $n$ → $\Theta(n)$.
- One recursive call with $k - 2$.

Total number of recursive calls: $\lfloor k/2 \rfloor = \Theta(k)$. Each call does $\Theta(n)$ work.

$$\boxed{\Theta(nk)}$$

---

### (c) Memory complexity

Each call allocates an array of size 1000 → $\Theta(1)$ per call. There are $\Theta(k)$ calls on the recursion stack (each waiting for the next to return).

$$\boxed{\Theta(k)}$$

> The $\Theta(k)$ accounts for the recursion stack depth. Each frame uses $\Theta(1)$ space (the 1000-element array is constant size), and there are $\Theta(k)$ frames.

---

### (d) Modify to run in $\Omega(n^k)$

Replace the linear loop with a **nested recursion** that multiplies the work. The key idea: instead of calling `StrangeAlgo(n, k-2)` once, we nest it so each level multiplies by $n$.

```
StrangeAlgoModified(n, k):
    if k == 0: return 0
    if k == 1: return 1

    i = 1
    while i <= n:
        i++

    ret = StrangeAlgoModified(n, k - 1)   // changed: k-2 → k-1
    return ret
```

Now the recursion depth is $k - 1$ (going $k, k-1, \dots, 1$). But each level does $\Theta(n)$ work, giving $\Theta(nk)$ total — that's still not $n^k$.

To get $\Omega(n^k)$, we need to call the recursion $n$ times per level:

```
StrangeAlgoPower(n, k):
    if k == 0: return 0
    if k == 1:
        i = 1
        while i <= n:   // do Theta(n) work at base case
            i++
        return 1

    i = 1
    while i <= n:        // loop n times
        StrangeAlgoPower(n, k - 1)
        i++

    return 0
```

Let $T(n, k)$ be the running time. Then:

- $T(n, 1) = \Theta(n)$
- $T(n, k) = n \cdot T(n, k-1)$

This gives $T(n, k) = \Theta(n^k)$ — which is $\Omega(n^k)$. $\blacksquare$

## Lab 05 (06.05.2026)
differ by at most 1

balanced/inbalanced 
null nodes, just put them everywhere, so it's easier and more understandable 
We cannot duplicate the value (if 5 is already placed, we cannot place it there again)

BST -> easy 

Exam will be similar to this one. 

Lab 06 (20.05.2026)

# AfDS Exercise 6 — Solutions

> Topics: Graphs, Stacks, Queues, BFS, Dijkstra, Floyd–Warshall, MST

---

## Task 6.1 — Simple Tasks: Graphs, Stack and BFS

### (a) Adjacency matrix & adjacency lists

Directed edges in the graph: $0 \to 1$, $0 \to 3$, $1 \to 2$, $1 \to 4$, $4 \to 3$.

**Adjacency lists:**

```
0 → 1 → 3 → NONE
1 → 2 → 4 → NONE
2 → NONE
3 → 0 -> N
4 → 3 → NONE
```

**Adjacency matrix** (rows = from, columns = to):

||0|1|2|3|4|
|---|---|---|---|---|---|
|**0**|0|1|0|1|0|
|**1**|0|0|1|0|1|
|**2**|0|0|0|0|0|
|**3**|0|0|0|0|0|
|**4**|0|0|0|1|0|

### (b) Stack operations (LIFO)

| Operation         | Stack (bottom → top) | Output |     |
| ----------------- | -------------------- | ------ | --- |
| `Add(0)`          | `[0]`                | —      |     |
| `Add(4)`          | `[0, 4]`             | —      |     |
| `FindNewest()`    | `[0, 4]`             | **4**  |     |
| `Add(3)`          | `[0, 4, 3]`          | —      |     |
| `ExtractNewest()` | `[0, 4]`             | **3**  |     |
| `Add(2)`          | `[0, 4, 2]`          | —      |     |
| `ExtractNewest()` | `[0, 4]`             | **2**  |     |
| `Add(1)`          | `[0, 4, 1]`          | —      |     |
| `ExtractNewest()` | `[0, 4]`             | **1**  |     |
| `ExtractNewest()` | `[0]`                | **4**  |     |
| `FindNewest()`    | `[0]`                | **0**  |     |
| `Add(2)`          | `[0, 2]`             | —      |     |
| `ExtractNewest()` | `[0]`                | **2**  |     |
| `ExtractNewest()` | `[]`                 | **0**  |     |

**Output sequence:** `4, 3, 2, 1, 4, 0, 2, 0

Output (correct**): 4, 3, 2, 1, 4, 0, 2, 0**
needs to have stuck on the side and start form the bottom. 

### (c) BFS from $s$ (alphabetical neighbor order)

Edges I read from the figure: `s–a, s–b, s–d, s–e, a–b, b–f, d–c, c–g, e–f, e–h, f–h, g–h`.

Trace:

- Extract **s** (d=0): enqueue a, b, d, e
- Extract **a** (d=1): neighbors {b, s} already known
- Extract **b** (d=1): enqueue f
- Extract **d** (d=1): enqueue c
- Extract **e** (d=1): enqueue h
- Extract **f** (d=2): nothing new
- Extract **c** (d=2): enqueue g
- Extract **h** (d=2): nothing new
- Extract **g** (d=3): done

    ||s|a|b|c|d|e|f|g|h|
|---|---|---|---|---|---|---|---|---|---|
|**distance**|0|1|1|2|1|1|2|3|2|
|**parent**|NONE|s|s|d|s|s|b|c|e|
|**removal order**|1|2|3|7|4|5|6|9|8|

---

## Task 6.2 — Drawing Graphs

### (a) Directed graph from adjacency lists

Edges: $2 \to 1$, $2 \to 3$, $4 \to 2$, $4 \to 6$, $6 \to 5$, $6 \to 7$. Vertices $1, 3, 5, 7$ are sinks.

The structure is two binary-tree-like fragments rooted at $4$:

```
        4
       / \
      2   6
     / \ / \
    1  3 5  7
```

(All arrows point downward, from parent to child. Drawing in this layout has no edge crossings.)

### (b) Undirected graph from adjacency matrix

!Undirect - that means that we have to look above or below the diagonal only, not both. 
Edges (each appears once): $1{-}2,\ 1{-}4,\ 1{-}6,\ 2{-}5,\ 3{-}4,\ 3{-}6,\ 4{-}5,\ 5{-}6$.

A planar layout without crossings — put $1, 2, 5, 6$ as a 4-cycle around the outside and $3, 4$ inside connected to it:

```
        2 ──── 5
        │  ╲ ╱ │
        │   ╳  │       (the ╳ is just visual — actual edges
        │  ╱ ╲ │        4–5 and 1–2 don’t cross)
        1 ──── 6
         ╲    ╱
          4──3
```

A cleaner planar embedding: place the 6-cycle $1{-}2{-}5{-}6{-}3{-}4{-}1$ on the outside, then add the chords $1{-}6$ and $4{-}5$ on opposite sides — no crossings.

---

## Task 6.3 — Queue operations (FIFO)

|Operation|Queue (front → back)|Output|
|---|---|---|
|`Add(0)`|`[0]`|—|
|`Add(4)`|`[0, 4]`|—|
|`FindOldest()`|`[0, 4]`|**0**|
|`Add(3)`|`[0, 4, 3]`|—|
|`ExtractOldest()`|`[4, 3]`|**0**|
|`Add(2)`|`[4, 3, 2]`|—|
|`ExtractOldest()`|`[3, 2]`|**4**|
|`Add(1)`|`[3, 2, 1]`|—|
|`ExtractOldest()`|`[2, 1]`|**3**|
|`ExtractOldest()`|`[1]`|**2**|
|`FindOldest()`|`[1]`|**1**|
|`Add(2)`|`[1, 2]`|—|
|`ExtractOldest()`|`[2]`|**1**|
|`ExtractOldest()`|`[]`|**2**|

**Output sequence:** `0, 0, 4, 3, 2, 1, 1, 2`



---

## Task 6.4 — Dijkstra

Edges and weights I read from the figure:

- $s{-}a:10$, $s{-}b:60$, $s{-}d:10$, $s{-}e:30$
- $a{-}c:25$
- $b{-}f:5$
- $d{-}c:10$, $d{-}e:5$
- $e{-}f:11$, $e{-}h:15$
- $f{-}h:2$
- $c{-}g:15$
- $g{-}h:5$

Trace (`*` = removed, `→` = relaxation):

|Step|Extracted|dist update|
|---|---|---|
|1|$s$ (0)|$a{=}10,\ b{=}60,\ d{=}10,\ e{=}30$|
|2|$a$ (10)|$c{=}35$ via $a$|
|3|$d$ (10)|$c{=}20$ (parent $d$); $e{=}15$ (parent $d$)|
|4|$e$ (15)|$f{=}26$ (parent $e$); $h{=}30$ (parent $e$)|
|5|$c$ (20)|$g{=}35$ via $c$|
|6|$f$ (26)|$h{=}28$ (parent $f$); $b{=}31$ (parent $f$)|
|7|$h$ (28)|$g{=}33$ (parent $h$)|
|8|$b$ (31)|no improvement|
|9|$g$ (33)|done|

**Final table:**

||s|a|b|c|d|e|f|g|h|
|---|---|---|---|---|---|---|---|---|---|
|**distance**|0|10|31|20|10|15|26|33|28|
|**parent**|NONE|s|f|d|s|d|e|h|f|

**Edges on cheapest paths from $s$** (the shortest-path tree): $s{-}a$, $s{-}d$, $d{-}c$, $d{-}e$, $e{-}f$, $f{-}b$, $f{-}h$, $h{-}g$.


Keep the Priority queue and will be easy, professor said. 

---

## Task 6.5 — Incomplete Floyd–Warshall _(Bonus)_

The bug: the outer loop runs $k = 1, \dots, 1002$, so vertices $1003, 1004, 1005, 1006$ are **never used as intermediates**. Direct edges incident to them still count (initial values from lines 4–6), but no path can route _through_ them.

Useful facts about the graph:

- The chain $1{-}2{-}3{-}\dots{-}999{-}1000{-}1002{-}1003$ uses only weight-1 edges except the last ($1002{-}1003$ has weight 2).
- Distance $1 \to 1000$ along the chain $= 999$ (using only intermediates $\le 1000$).
- The "back side" vertices $1001, 1004, 1005, 1006$ are reachable from $1$ only via $1003$ or via the direct edges $1{-}1005,(7000)$ and $1{-}1006,(3)$, then through $1006{-}1001,(1)$, $1006{-}1004,(2)$, etc. All these "back-side hubs" have index $> 1002$.

Computing each entry — a path is admissible iff every **intermediate** vertex has index $\le 1002$:

- **$\delta[1][1002]$:** chain $1 \to 2 \to \dots \to 1000 \to 1002$. All intermediates $\le 1000 \le 1002$. Weight $= 1{+}1{+}\dots{+}1,(\text{999 ones}) + 1 = \boxed{1000}$.
    
- **$\delta[1][1001]$:** Only edges into $1001$ are $1006{-}1001$ and $1001{-}1003$. To use either as the final step, the path's penultimate vertex (an intermediate from $1$'s side) must be $1006$ or $1003$ — but both are $>1002$. So no admissible path. $\boxed{+\infty}$.
    
- **$\delta[1][1005]$:** Edges into $1005$ are $1{-}1005,(7000)$ and $1005{-}1003,(2)$. The first is a direct edge (no intermediate). Going via $1003$ would need $1003$ as an intermediate — not allowed. So $\boxed{7000}$.
    
- **$\delta[2][4]$:** $2{-}3{-}4$, intermediate $3 \le 1002$. $\boxed{2}$.
    
- **$\delta[1003][1006]$:** Best admissible path: $1003 \to 1002 \to 1000 \to 999 \to \dots \to 1 \to 1006$. Intermediates $1002, 1000, 999, \dots, 1$ are all $\le 1002$. Cost $= 2 + 1 + 999 + 3 = \boxed{1005}$. (Going $1003{-}1004{-}1006$ or $1003{-}1005{-}1$ would need $1004$ or $1005$ as intermediate — not allowed.)
    
- **$\delta[1001][1005]$:** From $1001$, neighbors are $1006$ and $1003$, both $>1002$. So the very first step from $1001$ already requires a forbidden intermediate. $\boxed{+\infty}$.
    
- **$\delta[1003][1004]$:** Direct edge, weight $1$. $\boxed{1}$.
    
- **$\delta[1001][1004]$:** Same problem as above — $1001$'s only neighbors ($1006, 1003$) are forbidden as intermediates. $\boxed{+\infty}$.
    

**Summary:**

|Cell|Value|
|---|---|
|$\delta[1][1002]$|$1000$|
|$\delta[1][1001]$|$+\infty$|
|$\delta[1][1005]$|$7000$|
|$\delta[2][4]$|$2$|
|$\delta[1003][1006]$|$1005$|
|$\delta[1001][1005]$|$+\infty$|
|$\delta[1003][1004]$|$1$|
|$\delta[1001][1004]$|$+\infty$|

---

## Task 6.6 — Minimum Spanning Tree _(Bonus)_

### (a) MST of the given graph

Edges with weights I read from the figure:

$a{-}b:13$, $a{-}c:25$, $a{-}s:?$ (no edge in fig), $s{-}b:60$, $s{-}d:12$, $s{-}e:30$, $b{-}f:6$, $d{-}c:9$, $d{-}h:5$, $e{-}f:11$, $e{-}h:10$, $f{-}h:1$, $c{-}g:15$, $g{-}h:7$.

Sort edges ascending and run **Kruskal**:

|Edge|w|Take?|Reason|
|---|---|---|---|
|$f{-}h$|1|✅|first edge|
|$d{-}h$|5|✅|connects ${d}$ to ${f,h}$|
|$b{-}f$|6|✅|connects ${b}$ to component|
|$g{-}h$|7|✅|connects ${g}$|
|$d{-}c$|9|✅|connects ${c}$|
|$e{-}h$|10|✅|connects ${e}$|
|$e{-}f$|11|❌|$e$ and $f$ already same component|
|$s{-}d$|12|✅|connects ${s}$|
|$a{-}b$|13|✅|connects ${a}$ — last needed edge ($n-1 = 8$ taken)|
|rest||❌|tree complete|

**MST edges:** ${f{-}h, d{-}h, b{-}f, g{-}h, d{-}c, e{-}h, s{-}d, a{-}b}$. **Total weight:** $1 + 5 + 6 + 7 + 9 + 10 + 12 + 13 = 63$.

### (b) Minimal spanning subgraph that isn't a tree

If some edges have **negative** weight, a minimal spanning subgraph may include extra edges to drive the total cost down.

**Example:** Triangle ${u, v, w}$ with weights $w(u,v) = -1$, $w(v,w) = -1$, $w(u,w) = -1$.

- Any tree (2 edges): total cost $-2$.
- The full triangle (3 edges): total cost $-3$, still spanning and connected, and _lower_ total weight.

So the minimal spanning subgraph is the whole triangle — which contains a cycle and therefore is **not a tree**.

```
        u
       / \
      -1   -1
     /       \
    v ── -1 ── w
```

---

## Task 6.7 — Salt and Pepper _(Bonus)_

Model: build an undirected graph $G$ with one vertex per person and an edge between every pair of friends. Two friends "can cook together" iff one has salt and the other pepper — i.e. they get **different** labels. So we need a **2-coloring** of $G$, which exists iff $G$ is **bipartite**.

### (a) Connected graph

Run **BFS** from any vertex $s$. Assign $s$ colour `SALT`. For every vertex $v$ extracted from the queue and every neighbour $w$:

- If $w$ has no colour yet: give it the opposite colour of $v$, set $\mathrm{parent}[w] = v$, enqueue.
- If $w$ already has a colour: check that $\mathrm{colour}[w] \ne \mathrm{colour}[v]$. If equal, output **"not possible"** (an odd cycle was found) and stop.

If BFS finishes with no conflict, the colouring is a valid salt/pepper assignment.

Running time: BFS visits each vertex and edge $O(1)$ times → $O(n + k)$. ✅

### (b) Disconnected graph

Loop over all vertices $1, \dots, n$. For each uncoloured vertex, start a fresh BFS from it with colour `SALT`, applying the same rule as above. This processes every connected component independently.

```text
for v = 1 to n:
    if colour[v] is unset:
        BFS_bipartite_check(v)   # as in (a)
```

**Is the total running time $O(n + k)$?** Yes — the outer `for` loop itself costs $O(n)$. Each vertex and each edge is touched by exactly one BFS (the one for its component), so the BFS work summed over components is $O(n + k)$. Total: $O(n + k)$. ✅

---

## Task 6.8 — Is it true …? (Graphs) _(Bonus)_

### (a) Does every connected graph with $n-1$ edges have no cycles?

**Yes — it's true.** A connected graph on $n$ vertices needs at least $n-1$ edges. If a connected graph had both $n-1$ edges _and_ a cycle, removing one edge of the cycle would yield a connected graph with $n-2$ edges — impossible. So a connected graph with exactly $n-1$ edges is acyclic, i.e. a **tree**.

> Equivalent characterisation from the cheatsheet: _a tree is a connected undirected graph without cycles_ and has exactly $n-1$ edges.

### (b) Maximum number of edges (no parallel edges)

i. **Directed graph, self-loops allowed:** every ordered pair $(u, v)$ — including $u = v$ — can be an edge. That's $n^2$ pairs, so at most $\boxed{n^2}$ edges.

ii. **Directed graph, no self-loops:** $n^2 - n = n(n-1)$ ordered pairs with $u \ne v$. Max $\boxed{n(n-1)}$ edges.

iii. **Undirected graph, no self-loops:** unordered pairs of distinct vertices, that's $\binom{n}{2} = \boxed{\dfrac{n(n-1)}{2}}$ edges.

---

## Task 6.9 — Floyd–Warshall vs Dijkstra _(Bonus)_

Given times:

- Floyd–Warshall: $\Theta(n^3 + m)$
- Dijkstra from every vertex: $\Theta(mn \log m + n^2)$

### (a) $m = \Theta(1)$

- Floyd–Warshall: $\Theta(n^3 + 1) = \boxed{\Theta(n^3)}$
- $n$ × Dijkstra: $\Theta(1 \cdot n \cdot \log 1 + n^2) = \Theta(0 + n^2) = \boxed{\Theta(n^2)}$

➡ With very few edges, $n$ Dijkstra runs win.

### (b) $m = \Theta(n^4)$

Now $n = \Theta(m^{1/4})$, so $n^3 = \Theta(m^{3/4})$ and $n^2 = \Theta(m^{1/2})$.

- Floyd–Warshall: $\Theta(n^3 + m) = \Theta(m^{3/4} + m) = \boxed{\Theta(m)}$
- $n$ × Dijkstra: $\Theta(mn \log m + n^2) = \Theta(m \cdot m^{1/4} \log m + m^{1/2}) = \boxed{\Theta(m^{5/4} \log m)}$

➡ With a very dense (parallel-edged) graph, Floyd–Warshall wins.

---

## Task 6.10 — Dijkstra with a Normal Queue _(Bonus)_

The graph is a chain of "diamonds": at each _hub_ $0, 3, 6, 9, \dots$ there is a top route (two edges of weight $2$, total $4$) and a bottom route (two edges of weight $1$, total $2$). So the _correct_ shortest distance from $s = 0$ to the $k$-th hub is $2k$ (using only the cheap bottom path).

**Why a normal queue (FIFO) is disastrous here.** With a normal queue, vertices come out in BFS order — _roughly by hop-count, not by distance._ Each time a hub $h_k$ is dequeued with a _new, better_ tentative distance, the algorithm relaxes its outgoing edges and pushes its successors again. Because the check `dist[w] > dist[v] + c` succeeds whenever a smaller distance arrives, every hub gets re-enqueued and re-processed many times: once for the top route reaching it, once for the bottom route, and then the _improvements_ propagate all the way down the chain again.

More precisely, after the algorithm discovers a shorter route to hub $h_k$, it re-pushes $h_k$, which causes $h_{k+1}$ to be re-pushed with a better distance, which causes $h_{k+2}$ to be re-pushed, etc. Each hub can be reached with two different tentative values from the previous diamond, and each improvement cascades. The number of queue insertions per hub roughly **doubles** down the chain, giving an **exponential** blow-up of about $\Theta(2^{n/3})$ insertions in the worst case.

A **priority queue** prevents this: a hub is extracted only when its distance is final, so each vertex is processed once and each edge is relaxed once — total $O((n + m) \log n)$ instead of exponential.

---

## Task 6.11 — Output Cheapest Paths via Floyd–Warshall _(Advanced)_

### (a) Extending Floyd–Warshall, $O(n)$ output per pair

Keep an auxiliary table $\mathrm{next}[u][v]$ that stores the **next vertex on a cheapest path from $u$ to $v$**.

Initialisation: for every edge $(v, w, c)$ set $\mathrm{next}[v][w] = w$ and $\mathrm{next}[w][v] = v$. Set $\mathrm{next}[i][i] = i$.

Modify the inner relaxation:

```text
if δ[v][k] + δ[k][w] < δ[v][w]:
    δ[v][w]    = δ[v][k] + δ[k][w]
    next[v][w] = next[v][k]     # first step toward k is also first step toward w
```

To print the path from $u$ to $v$ in $O(\text{length}) \le O(n)$:

```text
print u
while u ≠ v:
    u = next[u][v]
    print u
```

### (b) Reconstructing a path from $\delta$ alone, in $O(n^2)$

We don't have the graph or `next`; we only have the table $\delta$. Edges $(x, y)$ are exactly the pairs where $\delta[x][y]$ equals the original edge weight — but we don't even know which pairs are edges, since some $\delta[x][y]$ might equal a longer shortcut weight.

**Idea:** a vertex $w$ is the next step on a shortest path from $u$ to $v$ iff $$\delta[u][w] + \delta[w][v] = \delta[u][v] \quad \text{and} \quad \delta[u][w] \text{ is the weight of an edge.}$$

We can identify edges as follows: $(u, w)$ is an edge iff there is **no** vertex $x \ne u, w$ with $\delta[u][x] + \delta[x][w] = \delta[u][w]$. (Otherwise the $\delta[u][w]$ value would be realised by a 2-step shortcut, meaning the path is not a single edge.) Checking this for one pair takes $O(n)$.

**Algorithm** (printing edges along a shortest path from $u$ to $v$):

```text
while u ≠ v:
    for each candidate w ≠ u:
        if δ[u][w] + δ[w][v] == δ[u][v]:
            # check that (u, w) is a real edge: no detour realises δ[u][w]
            is_edge ← true
            for each x ≠ u, w:
                if δ[u][x] + δ[x][w] == δ[u][w] and δ[u][x] > 0:
                    is_edge ← false; break
            if is_edge:
                print edge (u, w)
                u ← w
                break
```

**Running time.** The outer `while` runs at most $n-1$ times (the path has at most $n-1$ edges). Each iteration scans $O(n)$ candidates $w$, and for each candidate the edge check costs $O(n)$. That's $O(n^2)$ per iteration and $O(n^3)$ overall — too slow.

**Speed-up to $O(n^2)$.** Precompute, once, an $n \times n$ boolean table $\mathrm{isEdge}[x][y]$ using the criterion above. That precomputation costs $O(n^3)$ — but if we are willing to pay it once and answer many queries, each individual query then runs in $O(n^2)$: $n-1$ steps, each scanning $O(n)$ candidates with an $O(1)$ edge lookup.

If we want a _single_ query in $O(n^2)$ without the $O(n^3)$ precomputation: at each step from $u$, pick $w$ minimising $\delta[u][w]$ among vertices with $\delta[u][w] + \delta[w][v] = \delta[u][v]$. The smallest such positive $\delta[u][w]$ must correspond to a true edge (otherwise it would be a sum of two smaller positive values, contradicting minimality). Finding the minimum takes $O(n)$ per step, $n-1$ steps total → $O(n^2)$. ✅

```text
while u ≠ v:
    w* ← argmin_{w ≠ u, δ[u][w] + δ[w][v] = δ[u][v]} δ[u][w]
    print edge (u, w*)
    u ← w*
```
