
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


So the maximum number of coins among which we can find the forged one with k weighings is exactly **3^k**.