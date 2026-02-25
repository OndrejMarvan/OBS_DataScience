
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