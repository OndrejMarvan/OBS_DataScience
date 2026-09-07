# =============================================================================
#  ChessSimulator - user-facing wrapper functions
#  File: R/wrappers.R
# =============================================================================
#
#  Plain R functions wrapping the R6 class constructors. Easier to
#  discover via ? and easier to document with roxygen2.
# =============================================================================


#' Create a chess player
#'
#' Factory function for the three player types. Provides a cleaner API than
#' calling the R6 constructors directly, and validates input in one place.
#'
#' The three strategies form a clear ladder of strength:
#' \describe{
#'   \item{\code{"random"}}{Picks a random legal move. The baseline.}
#'   \item{\code{"greedy"}}{Looks one ply ahead in pure R and grabs the most
#'     material, preferring checks and taking mate when offered. Beats random
#'     comfortably; loses to minimax because it never asks what the opponent
#'     will do in reply.}
#'   \item{\code{"minimax"}}{Delegates to the C++ engine: alpha-beta search
#'     with move ordering and checkmate scoring.}
#' }
#'
#' @param strategy Character. \code{"random"}, \code{"greedy"} or
#'   \code{"minimax"}.
#' @param name Character. Display name, used in logs and leaderboards.
#' @param colour Character. \code{"white"} or \code{"black"}. Tournaments
#'   reassign this per game, so any valid value works there.
#' @param depth Positive integer. Search depth for minimax; ignored by the
#'   other strategies. 2 is fast, 3 is the default, 4 is stronger.
#'
#' @return A \code{\link{RandomPlayer}}, \code{\link{GreedyPlayer}} or
#'   \code{\link{MinimaxPlayer}} object, all inheriting from
#'   \code{\link{Player}}.
#'
#' @seealso \code{\link{play_game}}, \code{\link{run_tournament}}
#'
#' @examples
#' make_player("random",  "Bot_A", "white")
#' make_player("greedy",  "Bot_B", "black")
#' make_player("minimax", "Bot_C", "white", depth = 3)
#'
#' @export
make_player <- function(strategy = c("random", "greedy", "minimax"),
                        name,
                        colour = c("white", "black"),
                        depth  = 3L) {

  # match.arg() validates against the allowed set AND allows partial matching,
  # so make_player("mini", ...) still works.
  strategy <- match.arg(strategy)
  colour   <- match.arg(colour)

  stopifnot(
    "`name` must be a non-empty character scalar" =
      is.character(name) && length(name) == 1L && nchar(name) > 0L,
    "`depth` must be a positive integer" =
      is.numeric(depth) && length(depth) == 1L && depth >= 1L
  )

  switch(strategy,
    "minimax" = MinimaxPlayer$new(name, colour, depth = as.integer(depth)),
    "greedy"  = GreedyPlayer$new(name, colour),
    "random"  = RandomPlayer$new(name, colour)
  )
}


#' Play a single chess game between two players
#'
#' @param white A Player with colour \code{"white"}.
#' @param black A Player with colour \code{"black"}.
#' @param verbose Logical. Print each move? Default FALSE.
#' @param max_moves Positive integer. Move cap. Default 500.
#'
#' @return A finished Game object (invisibly).
#'
#' @seealso \code{\link{make_player}}, \code{\link{run_tournament}}
#'
#' @examples
#' \dontrun{
#' p1 <- make_player("random", "Alpha", "white")
#' p2 <- make_player("random", "Beta",  "black")
#' g  <- play_game(p1, p2, verbose = TRUE)
#' g$get_status()
#' }
#'
#' @export
play_game <- function(white, black, verbose = FALSE, max_moves = 500L) {

  stopifnot(
    "`white` must inherit from Player" = inherits(white, "Player"),
    "`black` must inherit from Player" = inherits(black, "Player"),
    "`verbose` must be a single logical" =
      is.logical(verbose) && length(verbose) == 1L,
    "`max_moves` must be a positive integer" =
      is.numeric(max_moves) && length(max_moves) == 1L && max_moves >= 1L
  )

  g <- Game$new(white, black, max_moves = as.integer(max_moves))
  g$play(verbose = verbose)
  invisible(g)
}


#' Run a round-robin chess tournament
#'
#' Each player faces every other player twice per round.
#'
#' @param players List of Player objects (>= 2). Colours are reassigned.
#' @param rounds Positive integer. Default 1.
#' @param verbose Logical. Print moves? Default FALSE.
#'
#' @return A finished Tournament object (invisibly).
#'
#' @examples
#' \dontrun{
#' players <- list(
#'   make_player("random",  "Rand_A", "white"),
#'   make_player("random",  "Rand_B", "white"),
#'   make_player("minimax", "Deep",   "white", depth = 2)
#' )
#' t <- run_tournament(players, rounds = 1)
#' t$leaderboard()
#' }
#'
#' @export
run_tournament <- function(players, rounds = 1L, verbose = FALSE) {

  stopifnot(
    "`players` must be a list of Player objects" =
      is.list(players) && length(players) >= 2L &&
      all(vapply(players, inherits, logical(1L), "Player")),
    "`rounds` must be a positive integer" =
      is.numeric(rounds) && length(rounds) == 1L && rounds >= 1L,
    "`verbose` must be a single logical" =
      is.logical(verbose) && length(verbose) == 1L
  )

  t <- Tournament$new(players, rounds = as.integer(rounds))
  t$run(verbose = verbose)
  invisible(t)
}


#' Statically evaluate a board position
#'
#' Returns the static evaluation score in centipawns from white's
#' perspective. Positive = white better. Requires the Rcpp engine.
#'
#' @param board A Board R6 object.
#'
#' @return Numeric. Score in centipawns (100 = one pawn).
#'
#' @examples
#' \dontrun{
#' b <- Board$new()
#' evaluate_position(b)  # ~ 0
#' }
#'
#' @export
evaluate_position <- function(board) {

  stopifnot("`board` must be a Board object" = inherits(board, "Board"))

  # Board owns the engine encoding (refactored from MinimaxPlayer)
  board_mat <- board$encode_for_engine()
  chess_evaluate(board_mat)
}


#' Launch the Chess Simulator Shiny dashboard
#'
#' @param port Integer or NULL. TCP port. Default NULL (auto).
#' @param launch.browser Logical. Open browser? Default TRUE.
#'
#' @return Invisible NULL. Called for the side effect of launching the app.
#'
#' @examples
#' \dontrun{
#' launch_dashboard()
#' }
#'
#' @export
launch_dashboard <- function(port = NULL, launch.browser = TRUE) {

  stopifnot(
    "`port` must be NULL or a positive integer" =
      is.null(port) || (is.numeric(port) && port > 0),
    "`launch.browser` must be a single logical" =
      is.logical(launch.browser) && length(launch.browser) == 1L
  )

  app_dir <- system.file("shiny", package = "ChessSimulator")
  if (!nzchar(app_dir)) {
    stop(
      "Shiny app directory not found. Is ChessSimulator installed?\n",
      "If running from source, the Shiny app should live in inst/shiny/",
      call. = FALSE
    )
  }

  shiny::runApp(app_dir, port = port, launch.browser = launch.browser)
}
