# =============================================================================
#  ChessSimulator — package-level documentation
#  File: R/ChessSimulator-package.R
# =============================================================================
#
#  This file contains ONLY package-level documentation (the help page that
#  appears when a user types ?ChessSimulator or package?ChessSimulator).
#
#  Per modern roxygen2 conventions (>= 7.0), package documentation uses the
#  "_PACKAGE" sentinel rather than the deprecated @docType package tag.
# =============================================================================


#' ChessSimulator: Chess engine with R6 classes, Rcpp AI, and Shiny dashboard
#'
#' @description
#' A teaching-oriented chess simulator built as the final project for
#' Advanced Programming in R at WNE UW. The package demonstrates four
#' advanced R techniques working together:
#'
#' \itemize{
#'   \item \strong{R6 OOP} — Square, Piece, Board, Player, Game,
#'         and Tournament classes with inheritance and polymorphism.
#'   \item \strong{Rcpp / C++} — Board evaluation with piece-square tables
#'         and minimax search with alpha-beta pruning.
#'   \item \strong{Shiny} — Interactive dashboard for playing single games
#'         and running tournaments (see \code{\link{launch_dashboard}}).
#'   \item \strong{R package} — Roxygen2 documentation, NAMESPACE management,
#'         and standard \code{devtools} build workflow.
#' }
#'
#' @section Quick start:
#' \preformatted{
#' library(ChessSimulator)
#'
#' # Two random players
#' g <- play_game(
#'   white = make_player("random", "Alpha", "white"),
#'   black = make_player("random", "Beta",  "black"),
#'   verbose = TRUE
#' )
#'
#' # Tournament with one minimax player
#' players <- list(
#'   make_player("random",  "Rand_A", "white"),
#'   make_player("random",  "Rand_B", "white"),
#'   make_player("minimax", "Deep",   "white", depth = 3)
#' )
#' t <- run_tournament(players, rounds = 1)
#' t$leaderboard()
#'
#' # Launch the Shiny dashboard
#' launch_dashboard()
#' }
#'
#' @author Ondrej Marvan
#'
#' @keywords internal
#'
#' @importFrom R6 R6Class
#' @importFrom Rcpp evalCpp
#' @importFrom shiny shinyApp runApp
#' @useDynLib ChessSimulator, .registration = TRUE
"_PACKAGE"

# -----------------------------------------------------------------------------
#  WHY "_PACKAGE" AND NOT @docType package?
#  -----------------------------------------
#  Since roxygen2 7.0 (2019), @docType package is deprecated in favour of
#  the "_PACKAGE" sentinel.
#
#  WHY @importFrom Rcpp evalCpp?
#  -----------------------------
#  When a package uses compiled Rcpp code (via @useDynLib), it must also
#  import at least one symbol from Rcpp itself, otherwise the dynamic
#  library may not be loaded properly. evalCpp is the standard choice.
# -----------------------------------------------------------------------------
