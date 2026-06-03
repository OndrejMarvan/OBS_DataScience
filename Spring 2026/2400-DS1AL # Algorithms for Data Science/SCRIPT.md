# Presentation Script — RAG Retrieval Pipeline

**Two presenters · ~5 minutes · plain language**

- **Person A** = first half (cover → BM25)
- **Person B** = second half (trigrams → complexity)
- 🔻 = hand-off cue · say it out loud so the switch is clean.

Speak slowly — it always feels faster to the audience than to you. If you run
long, the line marked *(cut if short on time)* can be dropped.

---

### Cover — Person A · (0:00–0:20)
> "Our project is a **RAG retrieval
> pipeline**. In plain terms: you ask a question, and it finds the few
> paragraphs that actually answer it — out of a big pile of text."

### 01 · The Problem — Person A · (0:20–0:55)
> "You've all used ChatGPT. The problem is that when a model answers purely from
> memory, it sometimes just **makes things up** — that's called hallucination.
> The fix is called **RAG**, and the idea is simple: *before* answering, first
> go fetch real paragraphs from a trusted source, and let the model answer using
> those. Our project builds that **fetching step**. Our trusted source is 100
> paragraphs about the Apollo moon program."

### 02 · The Pipeline — Person A · (0:55–1:30)
> "Here's the whole system on one slide. A question comes in, and we search it
> **two different ways at the same time**. BM25 is **keyword search** — great
> when the words match exactly. Trigram is **fuzzy search** — great when they
> *almost* match. Each one gives back its own ranked list. Then we **merge** the
> two lists and keep only the **top 3** paragraphs."

### 03 · BM25 · Index — Person A · (1:30–2:00)
> "First ranker, BM25. Before any question arrives, we build an **index** — a
> lookup table. For every word, we store which paragraphs contain it. So the
> word 'moon' points to documents 12, 34, 44. Because it's a **hash map**,
> looking a word up is basically instant — and we never waste time reading
> paragraphs that don't contain the word."

### 04 · BM25 · Query — Person A · (2:00–2:30)
> "Now a question arrives — say 'first person moon'. We split it into words, look
> each one up, and add up a score for every paragraph. **Rare words count more**
> — almost every paragraph says 'first', but few say 'moon', so 'moon' is the
> strong signal. The output is a ranked list. *(Quick note: 'doc 12' just means
> paragraph number 12 in our collection.)*
> 🔻 Over to Person B."

### 05 · Trigrams — Person B · (2:30–3:05)
> "BM25 is great when words match exactly — but what if they don't?
> That's the second ranker. We chop every text into **3-letter chunks**.
> 'Apollo' becomes 'apo', 'pol', 'oll', 'llo'. To compare a question and a
> paragraph, we just **count how many chunks they share** — that's this overlap
> in the middle. More overlap, more similar. We use a **set** for this, which
> makes finding the shared chunks really fast."

### 06 · Typo Tolerance — Person B · (3:05–3:30)
> "Why bother? Two reasons. **Typos**: if someone writes 'apolo' with one L,
> keyword search finds nothing — but most of the 3-letter chunks still match, so
> we still find the right paragraph."

### 07 · RRF Fusion — Person B · (3:30–4:05)
> "Now we have two ranked lists and need to combine them. The catch: their
> scores aren't on the same scale, so we can't just add them. The trick is to
> **ignore the scores and use the rank position** — 1st, 2nd, 3rd. Each
> paragraph earns points based on where it lands in each list. A paragraph
> that's high in **both** lists gets boosted to the top — like doc 12 here.
> That's the fusion."

### 08 · Min-Heap Top-3 — Person B · (4:05–4:35)
> "Last step: out of all those scores we only want the **best 3**. Instead of
> sorting everything, we keep a small container that holds just 3 items — a
> **min-heap**. The smallest of the three sits on top, so the moment a better
> score arrives, we kick the smallest out. We never sort the whole list — that's
> the speed win when the collection gets big."

### 09 · Complexity — Person B · (4:30–4:55)
> "Now how fast each step is — in plain words.
> - **Building the BM25 table — O(N):** we read all the text once. We pay this
>   only at startup.
> - **BM25 search — O(Q·P):** it only checks the paragraphs that actually
>   contain your words, and skips all the rest — so it's fast.
> - **Trigram search — O(D·L):** this one reads *every* paragraph in full,
>   *every* time someone asks. That's the slow step.
> - **Merging the lists and picking the top 3 — O(R·D) and O(D·log k):** both
>   are just quick bookkeeping — almost free.
>
> So nearly everything is cheap, because it either *skips* paragraphs or does a
> *tiny* bit of work each. The one exception is trigram, which reads everything
> every time — **that's our bottleneck**. At 100 paragraphs it's fine; at
> millions we'd index it too, just like BM25."

### Thank you · (4:55–5:00)


---

## If you have a spare minute (optional live demo)
> `python rag_retrieval/main.py --demo`
Run query **"car on the moon"** — it surfaces lunar-rover paragraphs that never
use the word "car". That's fusion working in real life.

## Likely questions (one-line answers)
- **Why not just BM25?** It misses typos and paraphrases — that's why we add trigrams.
- **Why not embeddings / AI vectors?** Out of scope for this course — no external libraries; we used a simpler fuzzy method.
- **Why rank-based fusion, not adding scores?** The two scores aren't comparable; rank position is.
- **What's the bottleneck at scale?** Trigram re-scanning every doc — fix it with a trigram index, just like BM25.
