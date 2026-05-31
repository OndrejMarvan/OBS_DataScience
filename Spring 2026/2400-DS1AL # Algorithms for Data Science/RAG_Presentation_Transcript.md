# RAG Retrieval Pipeline — Spoken Transcript

Matches the 23-slide deck. Two speakers, **A** and **B** (A carries the problem + BM25, B carries trigrams + fusion, both share the demo and close). Decide between you who is A and who is B. The deck is intentionally light, so move briskly — most slides are one breath.

---

**Slide 1 — RAG Retrieval Pipeline** *(A)*
Hi, we're Ondřej and Ivan. Our project is the retrieval engine that sits in front of a language model — the part that keeps its answers honest.

**Slide 2 — The Problem** *(A)*
Language models hallucinate. They give you a fluent, confident answer straight from memory, and sometimes it's just wrong.

**Slide 3 — The Fix: RAG** *(A)*
Retrieval-Augmented Generation fixes that: before the model answers, we fetch real passages from a trusted source and hand them over as context, so it grounds its answer in evidence.

**Slide 4 — What We Built** *(A)*
We built the retrieval half. Given a question and 100 paragraphs about the Apollo program, we return the 3 most relevant. No model, no embeddings, no libraries — pure standard library, so every step is visible.

**Slide 5 — The Pipeline** *(A)*
The design is two independent rankers running on the same question. One is exact, one is fuzzy. Each produces a ranked list, and a fusion step merges them into the final top 3.

**Slide 6 — Input & Output** *(A)*
Input is the question plus our 100 paragraphs; output is the best 3. The key detail: both rankers emit the same shape — document id and score — which is exactly what lets us fuse them.

**Slide 7 — Algorithm 1: BM25** *(A)*
First ranker: BM25, the classic keyword scorer. It rewards paragraphs that contain the query's words, weighting rare words more heavily, with diminishing returns for repeats.

**Slide 8 — BM25: The Score** *(A)*
This is the formula. The important parts: IDF makes rare terms count more, k1 controls how fast extra repeats stop helping, and b normalises for document length so long paragraphs aren't unfairly favoured.

**Slide 9 — BM25: Inverted Index** *(A)*
We build it on a hash map once at startup — each term points to the documents that contain it. At query time we only walk the terms in the query, never the whole corpus.

**Slide 10 — BM25: Complexity** *(A)*
Building is linear in the tokens; a query is query-terms times postings length. We use a hash map for constant-time lookup — we never need terms sorted, so a tree would just add cost. The catch: a typo is an unknown word BM25 can't match. *(hand over to B)*

**Slide 11 — Algorithm 2: Char-Trigram Overlap** *(B)*
That's where the second ranker comes in. It's fuzzy: it chops each text into overlapping three-character chunks and scores by how many chunks the query and document share.

**Slide 12 — Trigrams: How It Works** *(B)*
"apollo" becomes apo, pol, oll, llo. A typo only breaks one or two of those chunks, so a misspelling still overlaps heavily — that's where the typo tolerance comes from.

**Slide 13 — Trigrams: Score & Honest Limit** *(B)*
The score is the fraction of the query's chunks found in the document. One honest point: this gives typo tolerance, not understanding — for a whole sentence the common chunks dominate, so we use it strictly as a fuzzy safety net.

**Slide 14 — Trigrams: Complexity** *(B)*
It costs document-count times length per query, because it rescans every paragraph. We store chunks in a set because the intersection is the hot operation — near-linear for sets, quadratic for lists. This stage is our bottleneck; we'll come back to it.

**Slide 15 — Algorithm 3: RRF** *(B)*
Now we fuse. The problem: BM25 scores are unbounded, trigram scores sit between 0 and 1 — you can't just add them. Reciprocal Rank Fusion throws away the score values and uses only rank position, which is scale-free.

**Slide 16 — RRF: The Formula** *(B)*
Each document earns one over sixty-plus-its-rank from each list, and we sum those. A document missing from a list just contributes nothing. Sixty is the constant from the original RRF paper.

**Slide 17 — RRF: Min-Heap Top-K** *(B)*
To get the top 3 we don't sort all 100 — we keep a size-three min-heap, replacing its smallest whenever something better arrives, each operation logarithmic in k.

**Slide 18 — RRF: Deterministic Ties** *(B)*
So selection is D-log-k instead of D-log-D — we never order what we throw away. And we break ties deterministically — score, then best rank, then id — so the same query always gives the same result. *(both for the next stretch)*

**Slide 19 — Data Structures** *(B then A, alternate rows)*
Quick recap of why each structure earns its place: hash map for constant lookup, set for fast intersection, min-heap because we only want the top few, and a plain sorted list for BM25 where we genuinely want everything ordered.

**Slide 20 — The Bottleneck** *(A)*
Our bottleneck is the trigram ranker — it touches every document every query, while BM25 skips documents with no matching word. Fine at 100 docs; at millions you'd precompute a trigram index, the same shape as the BM25 one.

**Slide 21 — Live Demo** *(B drives, A narrates)*
Let's run it. First, a clean question — BM25 nails it, Armstrong on top. Second, and this is the point: the same question with Armstrong misspelled. BM25 alone returns nothing useful, but fusion brings the right paragraph back through the fuzzy ranker. Third, a disaster query that pulls back both Apollo 1 and Apollo 13.

**Slide 22 — Summary** *(A)*
So: two complementary rankers, fused by rank rather than score, top-k by heap, with the bottleneck identified — and every data structure chosen for how we actually access it.

**Slide 23 — Thank You** *(both)*
Thank you — we're happy to take questions.

---

### Pacing notes
- Target ~5 minutes; this is ~23 short beats, so roughly 12–13 seconds each. If you're running long, the easiest trims are slides 6 and 18 (fold them into the slides before).
- The one slide to slow down on is **21 (demo)** — let the misspelled-query result land, because that's the whole argument.
- Keep the formula slides (8, 16) to the one-line takeaway on the transcript; don't read the symbols aloud.
