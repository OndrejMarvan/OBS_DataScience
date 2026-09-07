# ChessSimulator — Defense Study Guide

**Monday: 4 hours. Tuesday morning: 1 hour. Defense Tuesday 16:00.**

Format: 12 min presentation + 8 min code defense.

The goal is not memorisation. The goal is that for **any** function in the
project you can answer three questions:

1. What does it do?
2. Why is it written this way and not another?
3. What breaks if I change it?

---

## Contents

- [Monday plan](#monday-plan)
- [Block 1 — R6 classes](#block-1--r6-classes-60-min)
- [Block 2 — C++ engine](#block-2--c-engine-60-min)
- [Block 3 — Game, Tournament, Shiny](#block-3--game-tournament-shiny-45-min)
- [Block 4 — Package and tests](#block-4--package-and-tests-30-min)
- [Block 5 — Question drill](#block-5--question-drill-45-min)
- [Tuesday morning refresher](#tuesday-morning--1-hour)

---

## Monday plan

| Block | Time | Topic |
|---|---|---|
| 1 | 60 min | R6 classes — `chess_R6_classes.R` |
| 2 | 60 min | C++ engine — `chess_core.h` |
| 3 | 45 min | Game, Tournament, Shiny |
| 4 | 30 min | Package and tests |
| 5 | 45 min | Question drill + run the demo twice |

After each block, **close the material and say out loud** what the code does.
When you get stuck, go back. This is the only part of preparation that
actually works.

---

# BLOCK 1 — R6 classes (60 min)

Open `R/chess_R6_classes.R` next to this text.

## 1.1 Why R6 and not S3 or S4

This is the first question you will get. The answer has three parts:

**Mutability.** Legal move generation plays a move, looks at the king, and
retracts it — thousands of times per game. R6 objects change in place. In S3 or
S4 every trial move would mean building a new copy of the board.

**Private fields.** `has_moved` on a piece and `grid` on the board must stay
consistent with the rest of the state. In R6 you cannot reach them from
outside. In S3 everything is public and a user can corrupt the object.

**Encapsulated syntax.** `board$apply_move(from, to)` matches how you think
about a board. That is the "encapsulated OOP" from lecture 4 — methods belong
to objects, not to generics.

> **From lecture 4:** R6 is encapsulated OOP, `object$method()`. S3 and S4 are
> functional OOP, `generic(object)`. R6 is built on S3, which is why S3
> generics work on R6 objects (`print.R6`).

## 1.2 The `Square` class

The simplest class. It does four things:

```r
Square <- R6::R6Class("Square",
  public = list(
    file = NULL,   # "a" to "h"
    rank = NULL,   # 1 to 8

    initialize = function(file, rank) {
      stopifnot(
        "file must be a single character" =
          is.character(file) && length(file) == 1L,
        "file must be a-h" = file %in% letters[1:8]
      )
      stopifnot(
        "rank must be numeric"         = is.numeric(rank),
        "rank must be between 1 and 8" = rank %in% 1:8
      )
      self$file <- file
      self$rank <- as.integer(rank)
      invisible(self)
    },
    ...
```

**What you may be asked:**

*"Why named `stopifnot()`?"* — Since R 4.0 the name becomes the error message.
Without it you get `is.character(file) is not TRUE`; with it you get
`file must be a single character`. Lecture 6 shows both `stopifnot()` and
`if (...) stop("custom message")`; the named form combines the benefits of both.

*"Why `invisible(self)`?"* — The standard R6 return. It returns the object
without printing it, which enables method chaining `obj$m1()$m2()`. Lecture 4.

*"What is `to_index()` for?"* — Converts a `Square` to a number 1–64 for the
C++ engine. `(rank - 1) * 8 + file_index`, so a1 = 1 and h8 = 64.

```r
to_index = function() {
  (self$rank - 1L) * 8L + match(self$file, letters[1:8])
}
```

*"And `is_light_square()`?"* — Square colour for the Shiny board. A square is
light when `file + rank` is **odd**. Boards are set up "white on the right":
h1 (8+1=9) is light, a1 (1+1=2) is dark.

> **This was one of the two bugs the tests caught.** It originally read
> `%% 2 == 0`, which flipped every colour. It looked plausible at a glance
> because the squares still alternated — they just started from the wrong side.

## 1.3 The `Piece` class

```r
Piece <- R6::R6Class("Piece",
  private = list(
    has_moved = FALSE      # only $move_to() and $restore_state() may change it
  ),
  public = list(
    type = NULL, colour = NULL, position = NULL,
    ...
```

**The key point: why `has_moved` is private.** If it were public, someone could
write `piece$has_moved <- TRUE` without moving the piece, and the pawn
double-step rule would break. The only way to change it is `move_to()`, which
also sets the position. State stays consistent.

> This is exactly the `showAge()` / `changeAge()` pattern from lecture 4: a
> private field guarded by a public method. `has_moved_yet()` is the getter.

**Two methods that return numbers — and the difference matters:**

```r
value = function() {          # material, for GreedyPlayer and material_balance()
  c(P = 1, N = 3, B = 3, R = 5, Q = 9, K = 0)[[self$type]]
},

type_code = function() {      # identifier for the C++ engine
  c(P = 1L, N = 2L, B = 3L, R = 4L, Q = 5L, K = 6L)[[self$type]]
}
```

**Learn this one well.** In `value()` knight and bishop are both 3 — correct,
they are worth about three pawns each. But in `type_code()` **every type has its
own code**. The fact that they shared code 3 was the main bug in the project.
More on that in Block 2.

## 1.4 The `Board` class — the most important one

Three private fields:

```r
private = list(
  pieces  = NULL,   # named list of all 32 pieces
  history = NULL,   # moves played
  grid    = NULL    # index: 64 slots, square index -> Piece (or NULL)
)
```

**Why `grid`?** Without it, `get_piece_at()` had to scan all 32 pieces. Move
generation calls it hundreds of times per position. The index turns that into
O(1) instead of O(32). It is private because it **must** stay in step with
`pieces` — only `apply_move()` and `undo_move()` may touch it.

### make / unmake — the heart of the project

```r
apply_move = function(from_sq, to_sq, log = TRUE) {
  from_idx <- from_sq$to_index()
  to_idx   <- to_sq$to_index()

  mover    <- private$grid[[from_idx]]
  captured <- private$grid[[to_idx]]

  # everything needed to restore the position exactly
  record <- list(
    from = from_sq, to = to_sq, mover = mover, captured = captured,
    had_moved = mover$has_moved_yet(),   # state before the move
    old_type  = mover$type,              # for promotion
    logged    = log
  )

  if (!is.null(captured)) captured$capture()
  mover$move_to(to_sq)
  private$grid_set(from_idx, NULL)
  private$grid_set(to_idx,   mover)

  # automatic promotion to queen
  last_rank <- if (mover$colour == "white") 8L else 1L
  if (mover$type == "P" && to_sq$rank == last_rank) mover$type <- "Q"
  ...
  invisible(record)
}
```

**Why does `record` store `old_type`?** Because of promotion. When a pawn
reaches the last rank it becomes a queen. Retracting the move must turn it back
into a pawn — without `old_type` you would end up with an extra queen.

**Why `log = FALSE`?** Trial moves (during legal move generation and inside
GreedyPlayer) must not enter the game history. The parameter controls that.

*Question you will get:* "Why not copy the board?" — Legal move generation plays
and retracts about 30 moves per position, and a game has around 40 moves. That
is thousands of operations. Copying 32 R6 objects each time would be orders of
magnitude slower. The undo record has six fields.

### Attack detection — `is_square_attacked()`

**The naive approach:** generate every opponent move and check whether any lands
on the square. Slow.

**Our approach:** look **outward** from the square:

```r
# pawns: a white pawn one rank below attacks upward, a black one from above
pr <- if (by_colour == "white") r - 1L else r + 1L
for (df in c(-1L, 1L)) if (is_enemy(at(pr, cc + df), "P")) return(TRUE)

# knights: eight jumps
for (o in list(c(2,1), c(2,-1), ...)) {
  if (is_enemy(at(r + o[1], cc + o[2]), "N")) return(TRUE)
}

# enemy king on an adjacent square
# and finally the rays:
rays <- list(
  list(dirs = list(c(1,1), c(1,-1), c(-1,1), c(-1,-1)), types = c("B","Q")),
  list(dirs = list(c(1,0), c(-1,0), c(0,1), c(0,-1)),   types = c("R","Q"))
)
```

Ray logic: walk outward. The **first** piece you meet either attacks (bishop or
queen on a diagonal, rook or queen on a rank or file) or blocks. Anything else
stops the ray.

*Key sentence for the defense:* "It is the inverted view. I do not ask where the
opponent can move, I ask who can see this square."

### Legal vs pseudo-legal moves

```r
legal_moves = function(colour) {
  pseudo <- self$pseudo_moves(colour)
  legal  <- vector("list", length(pseudo))
  n <- 0L
  for (mv in pseudo) {
    rec <- self$apply_move(mv$from, mv$to, log = FALSE)  # play
    ok  <- !self$is_in_check(colour)                     # look
    self$undo_move(rec)                                  # retract
    if (ok) { n <- n + 1L; legal[[n]] <- mv }
  }
  if (n == 0L) list() else legal[seq_len(n)]
}
```

**Pseudo-legal** = follows the movement rules of the piece.
**Legal** = additionally does not leave your own king in check.

Without this filter it is not chess. Kings were left in check, captured, and
because `find_king()` then found nothing, the game reported "stalemate". That is
exactly what the first version did.

---

# BLOCK 2 — C++ engine (60 min)

Open `src/chess_core.h`.

## 2.1 Why the engine is split into two files

- `chess_core.h` — **pure C++, no Rcpp.** All the chess logic.
- `chess_engine.cpp` — **thin Rcpp bindings.** Matrix to array and back.

**Why:** `chess_core.h` compiles with a plain `g++` and can be tested without R.
Logic you can test without the binding layer is logic you can trust.

*Strong line for the defense:* "If it were one file, testing chess correctness
would require a running R session. This way the perft test is a plain C++
program."

## 2.2 Board representation

```cpp
// flat array of 64 ints. index = row * 8 + col
// row 0 = rank 1 (white), row 7 = rank 8
// col 0 = file a,          col 7 = file h

const int EMPTY = 0;
const int PAWN = 1, KNIGHT = 2, BISHOP = 3;
const int ROOK = 4, QUEEN  = 5, KING   = 6;
// white positive, black negative: +6 white king, -1 black pawn
```

**This is where the main bug was.** Originally: `P=1, N=3, B=3, R=5, Q=9, K=100`
— material value used as the type identifier. Knight and bishop were both 3. The
move generator could not tell them apart, so for `piece == 3` it emitted **both
knight jumps and bishop diagonal slides**. The engine believed knights slide
along diagonals and bishops jump.

The fix: **separate type from value.** Type is 1–6; value is computed separately
in `piece_value()`.

*"How did you find it?"* → perft. See below.

## 2.3 perft — your strongest argument

```cpp
long perft(int b[64], int depth, bool white) {
  if (depth == 0) return 1;
  std::vector<Move> moves;
  gen_legal(b, white, moves);
  if (depth == 1) return (long) moves.size();

  long nodes = 0;
  for (size_t i = 0; i < moves.size(); i++) {
    const Undo u = make_move(b, moves[i]);
    nodes += perft(b, depth - 1, !white);
    unmake_move(b, moves[i], u);
  }
  return nodes;
}
```

Counts leaf nodes in the game tree to a given depth. From the starting position
the correct values are **published and widely known**:

| depth | nodes |
|---|---|
| 1 | 20 |
| 2 | 400 |
| 3 | 8,902 |
| 4 | 197,281 |

**Why this is powerful:** one illegal move generated, or one legal move missed,
and the counts break. It is not a test you can write so that it passes — the
numbers come from outside.

Our engine matches exactly through depth 4.

## 2.4 Alpha-beta pruning

**Minimax:** white maximises the score, black minimises it. The score is always
from white's point of view.

**Alpha-beta:** `alpha` is the best white can already guarantee, `beta` the same
for black. When `beta <= alpha`, the opponent would never allow this branch, so
there is no point searching it further.

```cpp
if (white_to_move) {
    int best = -MATE_SCORE * 2;
    for (size_t i = 0; i < moves.size(); i++) {
      const Undo u = make_move(b, moves[i]);
      const int sc = search(b, depth - 1, alpha, beta, false, ply + 1);
      unmake_move(b, moves[i], u);

      if (sc > best)  best  = sc;
      if (sc > alpha) alpha = sc;
      if (beta <= alpha) break;      // cutoff
    }
    return best;
}
```

## 2.5 Mate scores and `ply`

```cpp
if (moves.empty()) {
  if (in_check(b, white_to_move))
    return white_to_move ? -(MATE_SCORE - ply) : (MATE_SCORE - ply);
  return 0;   // stalemate = draw
}
```

**Why `- ply`?** So the engine prefers a **faster** mate. Mate in one scores
higher than mate in three, and when losing it delays mate as long as possible.
Without it the engine would see "mate is mate" and might postpone it forever.

**Why `return 0` for stalemate?** Stalemate is a draw — a zero score, not a loss.

## 2.6 Move ordering (MVV-LVA)

```cpp
int move_score(const int b[64], const Move& m) {
  int s = 0;
  const int victim   = std::abs(b[m.to]);
  const int attacker = std::abs(b[m.from]);
  if (victim != EMPTY) s += 10 * piece_value(victim) - piece_value(attacker);
  if (m.promo != 0)    s += piece_value(m.promo);
  return s;
}
```

**MVV-LVA** = Most Valuable Victim, Least Valuable Attacker. Capture the most
valuable piece with the cheapest one. Taking a queen with a pawn is tried before
taking a pawn with a queen.

**Why it matters:** alpha-beta prunes more the sooner it finds a good move. With
ordering the search visits far fewer positions at the same depth.

---

# BLOCK 3 — Game, Tournament, Shiny (45 min)

## 3.1 `Game` — who knows what

Game knows **neither** the movement rules (that is `Board`) **nor** the strategy
(that is `Player`). It only orchestrates: get legal moves → ask the player →
apply → check for the end.

```r
generate_moves = function(colour) private$board$legal_moves(colour),
```

One line — it delegates. *"Which moves exist is a property of the position, so
it belongs to the board."*

### The polymorphic call

```r
chosen <- player$choose_move(private$board, moves)
```

**This is the single line the whole project is built around.** Game has no idea
whether `player` is Random, Greedy or Minimax. Adding a fourth strategy means
writing a new class — and changing nothing in `Game`.

### End of game

```r
if (length(moves) == 0L) {
  if (private$board$is_in_check(colour)) {
    winner <- if (colour == "white") "black" else "white"
    private$status <- paste0(winner, "_wins");  private$result_reason <- "checkmate"
  } else {
    private$status <- "draw";  private$result_reason <- "stalemate"
  }
  return(TRUE)
}
```

No legal move plus check = **checkmate**. No legal move without check =
**stalemate**. That is the whole definition, exactly as the rules state it.

Also: the fifty-move rule (`halfmove_clock >= 100` plies), insufficient material
(K vs K, K plus one minor piece vs K), and a `max_moves` safety cap.

## 3.2 The three strategies

**RandomPlayer** — `sample.int()`. The baseline.

**GreedyPlayer** — one ply ahead, pure R, no C++:

```r
rec <- board$apply_move(mv$from, mv$to, log = FALSE)
score <- sign * board$material_balance()
if (board$is_in_check(opponent)) {
  if (board$has_legal_move(opponent)) score <- score + 0.5    # check
  else                                score <- score + 1000   # mate
}
board$undo_move(rec)
```

**Why the bonus for check and mate?** Without it Greedy would win every piece
and then shuffle forever, because **checkmate does not change material**. In
testing it had 0 wins and 6 draws. After adding it: 5 wins.

*Good answer to "why three strategies and not two?":* Greedy shows the same
interface can be implemented without Rcpp, and it is evidence that searching
deeper adds something beyond simply counting material.

**MinimaxPlayer** — delegates to C++, with two safety nets:

```r
idx <- tryCatch(
  chess_minimax(board$encode_for_engine(), colour_int, self$depth),
  error = function(e) { warning(...); NULL }
)

if (!is.null(idx) && length(idx) == 2L && all(idx > 0L)) {
  # verify R considers it legal
  for (mv in legal_moves) {
    if (mv$from$to_string() == from_sq$to_string() &&
        mv$to$to_string()   == to_sq$to_string()) return(mv)
  }
  warning("Engine returned a move R does not consider legal - using random.")
}
legal_moves[[sample.int(length(legal_moves), 1L)]]
```

`tryCatch` (lecture 6) for an engine failure, and a **check against the legal
move list**. R and C++ implement the same rules so it should always match — but
I would rather play a legal move than an illegal one.

## 3.3 Shiny — zones and reactivity

> **From lecture 9:** Zone 1 = outside `server()`, runs once at startup.
> Zone 2 = inside `server()`, outside `render*()` — `reactive()`,
> `eventReactive()`, `reactiveVal()`. Zone 3 = inside `render*()`.

```r
game_rv <- reactiveVal(NULL)                    # Zone 2

observeEvent(input$btn_next_move, {
  game <- game_rv()
  game$play_one_turn()   # R6 mutates the object in place
  game_rv(game)          # write back -> Shiny recomputes
})
```

**The best question you could get:** *"Why `game_rv(game)` at the end, when
`play_one_turn()` already changed the object?"*

Answer: because R6 mutates **in place**. Shiny tracks assignment into the
`reactiveVal`, not the internal state of an object. Without that last line the
game advances but the board never redraws. It is exactly where R6 mutability and
Shiny reactivity meet — and you have to connect them manually.

Also used: `reactiveTimer()` for auto-play, `isolate()` for reading without
subscribing, `withProgress()` for tournaments.

---

# BLOCK 4 — Package and tests (30 min)

## 4.1 Structure

```
ChessSimulator/
├── DESCRIPTION          LinkingTo: Rcpp
├── NAMESPACE            useDynLib + importFrom(Rcpp, evalCpp)
├── R/                   classes, game, wrappers, package docs
├── src/                 chess_core.h (pure C++) + chess_engine.cpp (Rcpp)
├── inst/shiny/app.R
└── tests/testthat/
```

**Three things she may ask:**

*"Why `LinkingTo: Rcpp` and not just `Imports`?"* — `Imports` covers the R
level; `LinkingTo` says the compiler needs Rcpp's header files.

*"Why `importFrom(Rcpp, evalCpp)`?"* — When a package uses `useDynLib`, it must
import at least one symbol from Rcpp, otherwise the dynamic library may not load
correctly. A classic Rcpp packaging trap.

*"Why `"_PACKAGE"` and not `@docType package`?"* — `@docType package` has been
deprecated since roxygen2 7.0.

## 4.2 Workflow (lecture 7)

```r
devtools::document()   # roxygen2 -> man/ + NAMESPACE
devtools::check()      # target: 0 errors, 0 warnings
devtools::install()
devtools::test()
devtools::build()      # .tar.gz
```

## 4.3 Tests — 103, and two of them found real bugs

Five kinds of test:

| test | what it verifies |
|---|---|
| perft | generator against published counts |
| R vs C++ | two independent generators must return an **identical** move set |
| make/unmake | the board must be identical after retracting a move |
| Fool's mate | a known 4-ply mate must be detected as mate |
| strength | minimax must actually beat random |

**The R vs C++ cross-validation is the methodologically interesting one.** Two
independent implementations of the same rules. If they agree at every position,
the chance that both contain the same bug is small.

**Two bugs the tests found:**

1. `to_matrix()` wrote rank-1 pieces into the row labelled "8" — the board
   displayed **vertically mirrored**, in the console and in Shiny.
2. `is_light_square()` was inverted — a1 rendered light instead of dark.

Both were invisible while only reading the code.

---

# BLOCK 5 — Question drill (45 min)

Cover the answers and respond **out loud**.

**Q: Why R6 and not S4?**
Mutability — the search plays and retracts thousands of moves, and copying the
board would be expensive. Plus private fields and encapsulated syntax. S4 would
make sense if I needed multiple dispatch, which I do not.

**Q: What is a pseudo-legal move?**
A move that follows the movement rules of the piece but may leave your own king
in check. I get legal moves by playing each pseudo-legal one, checking the king,
and retracting.

**Q: Explain alpha-beta.**
Alpha is the best value the maximising player can already guarantee, beta the
same for the minimising player. When beta drops to alpha it means the opponent
would never allow this branch, so I stop searching it.

**Q: What is perft and why is it there?**
It counts leaf nodes of the game tree to a given depth. The values from the
starting position are published (20/400/8902/197281). A single illegal or
missing move breaks them. It is the standard correctness proof for a move
generator.

**Q: Why do knight and bishop have different codes if they have the same value?**
Because the code identifies the **type**, not the value. When they shared a code
the generator could not distinguish them and produced illegal moves — knights
appeared to slide along diagonals. Material value is computed separately in
`piece_value()`.

**Q: Why `invisible(self)`?**
It returns the object without printing it, which enables method chaining. The R6
standard from lecture 4.

**Q: What does `tryCatch` do in MinimaxPlayer?**
If the C++ engine fails, neither the game nor the dashboard crashes — it falls
back to a random legal move and emits a warning. Defensive programming from
lecture 6.

**Q: Why did the tests pass while the Shiny app crashed?**
Package code resolves names through its own namespace, so it finds `base::c`.
The `app.R` script is evaluated in the global environment, where `c` had been
overwritten. It is also a good argument for packaging code rather than shipping
loose scripts.

**Q: What does your project not do?**
Castling, en passant, under-promotion. It does not detect threefold repetition
(it does handle the fifty-move rule and insufficient material). There is no
quiescence search, so it can misjudge a position in the middle of a capture
sequence.

**Q: How would you improve it?**
Quiescence search, a transposition table, iterative deepening. Each is a
measurable improvement the tournament leaderboard could verify.

---

## End of Monday: run the demo twice

```r
setwd("...ChessSimulator")
devtools::load_all()

b <- Board$new(); m <- b$encode_for_engine()
chess_perft(m, 1L, 1L); chess_perft(m, 1L, 2L); chess_perft(m, 1L, 3L)

set.seed(2026)
g <- play_game(make_player("minimax","Engine","white",3),
               make_player("random","Random","black"), verbose = TRUE)
g$get_status(); g$get_result_reason()

set.seed(2026)
tour <- run_tournament(list(
  make_player("random","Random","white"),
  make_player("greedy","Greedy","white"),
  make_player("minimax","Mini_d2","white",depth=2),
  make_player("minimax","Mini_d3","white",depth=3)), rounds = 1)
tour$leaderboard()

devtools::test()
shiny::runApp("inst/shiny/app.R")
```

**Run it the second time from a restarted R session.** That is the only way to
find out whether something is missing in a clean session.

Take your four screenshots for the presentation while you are at it.

---

# TUESDAY MORNING — 1 hour

Defense at 16:00. This section is for a quick pass, not for learning.
Do not learn anything new today.

## Schedule for the hour

| min | what |
|---|---|
| 0–15 | Read "Ten sentences" and "Code map" below |
| 15–35 | Run the demo from a **restarted** R, all of it, without reading instructions |
| 35–50 | Talk through the 14 slides out loud — headlines only |
| 50–60 | Read "When you don't know" and close the laptop |

## Ten sentences you must know without thinking

1. **Why R6:** objects are mutable, so the search plays and retracts thousands
   of moves without copying the board. Plus private fields and `object$method()`.

2. **Pseudo-legal vs legal:** pseudo-legal follows the piece's movement; legal
   additionally does not leave your own king in check. I filter by playing the
   move, checking the king, and retracting.

3. **make/unmake:** `apply_move()` returns an undo record (captured piece,
   pre-promotion type, has-moved flag). `undo_move()` restores the position
   exactly.

4. **Attack detection:** I do not look at where the opponent can move, but at
   who can see a given square — pawns on the diagonals, a knight a jump away,
   the king adjacent, and along each ray the first piece met.

5. **perft:** counts leaf nodes. 20 / 400 / 8,902 / 197,281 from the starting
   position. Published numbers; a single illegal move breaks them.

6. **Alpha-beta:** alpha is what the maximising player has secured, beta the
   minimising one. `beta <= alpha` means the opponent would never allow this
   branch → cut.

7. **MVV-LVA:** capture the most valuable piece with the cheapest one. The
   sooner a good move is found, the more alpha-beta prunes.

8. **Mate score with `ply`:** `MATE_SCORE - ply` means a faster mate scores
   higher, so the engine prefers mate in 1 over mate in 3.

9. **Polymorphism:** `Game` only calls `player$choose_move(board, moves)`.
   Random, Greedy and Minimax share the interface. A fourth strategy would
   require no change in `Game`.

10. **Shiny + R6:** `play_one_turn()` mutates in place, but Shiny tracks
    assignment into `reactiveVal` — hence `game_rv(game)` at the end of the
    observer.

## Code map — where everything lives

| If asked about... | Open | Look for |
|---|---|---|
| R6, inheritance, polymorphism | `R/chess_R6_classes.R` | `Player`, `RandomPlayer`, `GreedyPlayer`, `MinimaxPlayer` |
| private fields | `R/chess_R6_classes.R` | `has_moved` in `Piece`, `grid` in `Board` |
| make/unmake | `R/chess_R6_classes.R` | `apply_move`, `undo_move` |
| legal moves | `R/chess_R6_classes.R` | `legal_moves`, `pseudo_moves` |
| check detection | `R/chess_R6_classes.R` | `is_square_attacked` |
| defensive programming | anywhere | `stopifnot(` with named messages |
| `tryCatch` | `R/chess_R6_classes.R` | `MinimaxPlayer$choose_move` |
| custom operator | `R/chess_game.R` | `` `%||%` `` at the top |
| end of game | `R/chess_game.R` | `is_game_over` |
| tournament, leaderboard | `R/chess_game.R` | `Tournament$run`, `$leaderboard` |
| C++ search | `src/chess_core.h` | `search`, `best_move` |
| perft | `src/chess_core.h` | `perft` |
| move ordering | `src/chess_core.h` | `move_score`, `order_moves` |
| Rcpp bindings | `src/chess_engine.cpp` | `[[Rcpp::export]]` |
| Shiny reactivity | `inst/shiny/app.R` | `reactiveVal`, `observeEvent` |
| tests | `tests/testthat/` | `test-classes.R`, `test-engine.R` |

## The four techniques (if asked directly)

1. **R6 OOP** — 8 classes, `Player` → 3 children, private fields, polymorphic
   `choose_move()`, `super$initialize()`.
2. **Rcpp / C++** — evaluation, move generation, alpha-beta search. Split into
   pure logic and thin bindings.
3. **Shiny** — three tabs, `reactiveVal`, `observeEvent`, `reactiveTimer`,
   `isolate`, `withProgress`.
4. **Own package** — roxygen2, NAMESPACE, `LinkingTo: Rcpp`, testthat.

**What goes beyond the lectures** (your argument for a grade above 4):
perft verification, alpha-beta with MVV-LVA, make/unmake instead of copying,
cross-validation of two independent implementations, separating pure C++ from
Rcpp, 103 tests.

## Numbers to remember

- perft: **20 / 400 / 8,902 / 197,281**
- tests: **103**, 0 failures
- tournament: **Mini_d3 18 pts, Mini_d2 12, Greedy 4, Random 1**
- **11 of 12** games ended in checkmate
- piece values in C++ (centipawns): P 100, N 320, B 330, R 500, Q 900
- type codes: P 1, N 2, B 3, R 4, Q 5, K 6

## When you don't know

Three answers that work better than guessing:

**"That is a simplification I made deliberately — [reason]."**
Use for castling, en passant, quiescence search.

**"I would have to look at the code, may I open it?"**
Entirely legitimate. Open the file and read it with her. Being able to navigate
your own code is part of defending it.

**"I don't know, but here is how I would find out: …"**
Describing the method beats inventing an answer. An invented answer falls apart
at the next question.

**Never say "someone else wrote that" or "it's just there somehow."** If you
have no answer, say so and offer how you would find out.

## Practical checklist before 16:00

- [ ] R restarted, `devtools::load_all()` runs without error
- [ ] Shiny app opens from a clean session
- [ ] Presentation open and ready
- [ ] RStudio in a second window, `setwd()` done, demo script prepared
- [ ] **Screen sharing tested** (the defense is online)
- [ ] Email and GitHub placeholders fixed in `DESCRIPTION`
- [ ] Project submitted on Moodle (deadline 10 Sept, but submit earlier)

## One last thing

You have a working project: perft matches, 103 tests pass, the engine is
undefeated at depth 3, and the dashboard runs. None of that is invented.

When she asks something you don't know, say so. Eight minutes of defense can be
carried by what you genuinely understand — and you understand enough.

Good luck.
