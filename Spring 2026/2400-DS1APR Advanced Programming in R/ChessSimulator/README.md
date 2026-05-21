# ChessSimulator

A chess simulator with R6 classes, Rcpp AI, and a Shiny dashboard.
Final project for **Advanced Programming in R** (dr Maria Kubara, WNE UW).

**Student:** Ondrej Marvan (477001)

---

## What it demonstrates

1. **R6 OOP** — `Square`, `Piece`, `Board`, `Player`, `Game`, `Tournament`
   classes with inheritance (`RandomPlayer`, `MinimaxPlayer`) and
   polymorphism (`choose_move()`).
2. **Rcpp / C++** — Board evaluation with piece-square tables and minimax
   search with alpha-beta pruning, all in C++ for performance.
3. **Shiny** — Interactive dashboard for playing single games and running
   tournaments with live leaderboard.
4. **R package** — Roxygen2 documentation, NAMESPACE management, tests.

---

## Installation

### From source (for grading)

```r
# 1. Install dependencies
install.packages(c("R6", "Rcpp", "shiny", "shinydashboard",
                   "devtools", "roxygen2", "testthat"))

# 2. Build and install from the source folder
devtools::document("ChessSimulator/")
devtools::install("ChessSimulator/")
```

---

## Quick start

```r
library(ChessSimulator)

# Two random players
g <- play_game(
  white = make_player("random", "Alpha", "white"),
  black = make_player("random", "Beta",  "black"),
  verbose = TRUE
)
g$get_status()

# Tournament with a minimax player
players <- list(
  make_player("random",  "Rand_A", "white"),
  make_player("random",  "Rand_B", "white"),
  make_player("minimax", "Deep",   "white", depth = 3)
)
t <- run_tournament(players, rounds = 1)
t$leaderboard()

# Launch the Shiny dashboard
launch_dashboard()
```

---

## Package layout

```
ChessSimulator/
├── DESCRIPTION                       Package metadata
├── NAMESPACE                         Exported symbols (roxygen-generated)
├── LICENSE                           GPL-2
├── README.md
├── R/
│   ├── ChessSimulator-package.R      Package-level docs
│   ├── chess_R6_classes.R            Square, Piece, Board, Player, ...
│   ├── chess_game.R                  Game, Tournament classes
│   └── wrappers.R                    User-facing API (make_player, etc.)
├── src/
│   └── chess_engine.cpp              Rcpp engine (evaluation, minimax)
├── inst/
│   └── shiny/
│       └── app.R                     Shiny dashboard
└── tests/
    ├── testthat.R
    └── testthat/
        └── test-classes.R            Unit tests
```

---

## Build workflow (from lecture 07)

```r
library(devtools)

path <- "ChessSimulator/"

# 1. Generate documentation from roxygen2 comments
document(path)

# 2. Check the package (target: 0 errors, 0 warnings)
check(path)

# 3. Install
install(path, reload = TRUE)

# 4. Run tests
test(path)

# 5. Build distributable .tar.gz
build(path)
```

---

## Course concepts used

| Concept                    | Where to find it                                  |
|----------------------------|---------------------------------------------------|
| R6 classes + methods       | `R/chess_R6_classes.R`, `R/chess_game.R`          |
| R6 private fields          | `Piece$has_moved`, `Board$pieces`, `Game$status`  |
| R6 inheritance             | `RandomPlayer`, `MinimaxPlayer` inherit `Player`  |
| R6 super$ method calls     | `RandomPlayer$initialize`                         |
| R6 method chaining         | `invisible(self)` throughout                      |
| S3 dispatch                | `print.Square`, `print.Piece`, etc.               |
| Defensive programming      | `stopifnot()` with named assertions               |
| Custom infix operator      | `%||%` in `chess_game.R`                          |
| tryCatch() error handling  | `MinimaxPlayer$choose_move()` engine fallback     |
| Rcpp `[[Rcpp::export]]`    | `chess_evaluate`, `chess_legal_moves`, `chess_minimax` |
| Rcpp NumericMatrix         | `chess_evaluate(board_matrix)`                    |
| Shiny reactiveVal          | `game_rv`, `tournament_rv` in `app.R`             |
| Shiny observeEvent         | All button handlers                               |
| Shiny isolate              | `isolate(input$white_type)`                       |
| Shiny reactiveTimer        | Auto-play timer                                   |
| Roxygen2 documentation     | Every class, method, and function                 |
| `_PACKAGE` sentinel        | `R/ChessSimulator-package.R`                      |
| `@useDynLib` + `@importFrom Rcpp evalCpp` | `R/ChessSimulator-package.R`       |
| testthat tests             | `tests/testthat/test-classes.R`                   |

How to run: 

# 1. Make sure everything is installed (one-time)
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages(c("R6", "Rcpp", "shiny", "shinydashboard",
                   "devtools", "roxygen2", "testthat"))

# 2. Set the package path
pkg <- "/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Spring 2026/2400-DS1APR Advanced Programming in R/ChessSimulator"

# 3. Do a full dry run — compile, load, test
setwd(pkg)
devtools::load_all()

# 4. Test all four parts work
b <- Board$new()
chess_evaluate(b$encode_for_engine())   # should return ~0

g <- play_game(make_player("random", "A", "white"),
               make_player("random", "B", "black"))
g$get_status()                           # should say a result

launch_dashboard()                       # or shiny::runApp("inst/shiny/app.R")
# Click around, make sure it works, then close it

---
# === 1. Set path (adjust if different on your laptop) ===
pkg <- "/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Spring 2026/2400-DS1APR Advanced Programming in R/ChessSimulator"
setwd(pkg)

# === 2. Load the package (compiles C++, loads R files) ===
devtools::load_all()

# === 3. Quick game so they see it actually plays chess ===
g <- play_game(
  make_player("random", "Alpha", "white"),
  make_player("random", "Beta",  "black")
)
g$get_status()
g$get_result_reason()

# === 4. Launch the dashboard ===
shiny::runApp("inst/shiny/app.R")
