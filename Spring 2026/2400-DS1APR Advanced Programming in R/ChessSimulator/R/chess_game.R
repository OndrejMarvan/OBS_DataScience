# =============================================================================
#  ChessSimulator — GAME AND TOURNAMENT
#  File: R/chess_game.R
# =============================================================================
#
#  Game        — runs one match: whose turn, which moves are legal, when it ends
#  Tournament  — runs many games and builds a leaderboard
#
#  Game deliberately knows nothing about HOW to choose a move (that is the
#  Player's job) or how pieces are stored and how they move (that is the
#  Board's job). It only orchestrates: ask the board for legal moves, ask the
#  player to pick one, apply it, check whether the game has ended.
# =============================================================================


# -----------------------------------------------------------------------------
#  %||% : return the left side unless it is NULL
#  A custom infix operator (lecture 06) — must start and end with %.
# -----------------------------------------------------------------------------
`%||%` <- function(x, y) if (!is.null(x)) x else y


#' Game: one chess game between two players
#'
#' Generates legal moves, asks each player to choose, applies moves to the
#' board, and detects checkmate, stalemate, the fifty-move rule and
#' insufficient material.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(white, black, max_moves)}}{Construct.}
#'   \item{\code{$play(verbose)}}{Play to completion.}
#'   \item{\code{$play_one_turn(verbose)}}{Advance a single turn.}
#'   \item{\code{$generate_moves(colour)}}{All legal moves for a side.}
#'   \item{\code{$get_status()}}{\code{"ongoing"}, \code{"white_wins"},
#'     \code{"black_wins"} or \code{"draw"}.}
#'   \item{\code{$get_result_reason()}}{Why the game ended.}
#'   \item{\code{$get_turn()}}{Whose move it is.}
#'   \item{\code{$get_board()}}{The \code{\link{Board}}.}
#'   \item{\code{$get_move_log()}}{Data frame of every move played.}
#' }
#'
#' @examples
#' \dontrun{
#' g <- Game$new(RandomPlayer$new("A", "white"), RandomPlayer$new("B", "black"))
#' g$play(verbose = TRUE)
#' g$get_status()
#' }
#'
#' @export
Game <- R6::R6Class("Game",

  private = list(

    board        = NULL,
    white_player = NULL,
    black_player = NULL,

    current_colour = "white",
    status         = "ongoing",
    result_reason  = NULL,
    move_count     = 0L,
    halfmove_clock = 0L,     # plies since the last capture or pawn move
    move_log       = NULL,

    # ------------------------------------------------------------------------
    #  Insufficient material: positions where neither side can ever force
    #  mate, e.g. king versus king, or king and one minor piece versus king.
    #  Without this rule such games just shuffle until the move cap.
    # ------------------------------------------------------------------------
    insufficient_material = function() {
      pieces <- private$board$get_all_pieces()
      types  <- vapply(pieces, function(p) p$type, character(1L))
      others <- types[types != "K"]

      if (length(others) == 0L) return(TRUE)                      # K vs K
      if (length(others) == 1L && others %in% c("N", "B")) return(TRUE)
      FALSE
    }
  ),

  public = list(

    #' @field max_moves Integer safety cap on the number of plies.
    max_moves = 400L,

    #' @description Construct a Game.
    #' @param white_player A \code{\link{Player}} with colour \code{"white"}.
    #' @param black_player A \code{\link{Player}} with colour \code{"black"}.
    #' @param max_moves Integer safety cap on plies. Default 400.
    initialize = function(white_player, black_player, max_moves = 400L) {

      stopifnot(
        "white_player must be a Player" = inherits(white_player, "Player"),
        "black_player must be a Player" = inherits(black_player, "Player"),
        "white_player must have colour 'white'" = white_player$colour == "white",
        "black_player must have colour 'black'" = black_player$colour == "black"
      )

      private$board        <- Board$new()
      private$white_player <- white_player
      private$black_player <- black_player
      private$move_log     <- list()
      self$max_moves       <- as.integer(max_moves)

      invisible(self)
    },

    #' @description The player whose turn it is.
    current_player = function() {
      if (private$current_colour == "white") private$white_player
      else                                   private$black_player
    },

    #' @description The colour to move.
    get_turn = function() private$current_colour,

    #' @description The \code{\link{Board}} object.
    get_board = function() private$board,

    #' @description Game status string.
    get_status = function() private$status,

    #' @description Why the game ended, or \code{NULL} while ongoing.
    get_result_reason = function() private$result_reason,

    #' @description Every move played, as a data frame.
    get_move_log = function() {
      if (length(private$move_log) == 0L) {
        return(data.frame(move_number = integer(), colour = character(),
                          from = character(), to = character(),
                          notation = character(), stringsAsFactors = FALSE))
      }
      do.call(rbind, lapply(seq_along(private$move_log), function(i) {
        e <- private$move_log[[i]]
        data.frame(move_number = i, colour = e$colour, from = e$from,
                   to = e$to, notation = e$notation, stringsAsFactors = FALSE)
      }))
    },

    #' @description All LEGAL moves for a colour.
    #'
    #' Delegates to \code{Board$legal_moves()}. Which moves exist is a property
    #' of the position, so the board owns that knowledge; Game only needs to
    #' know whose turn it is and when the game ends.
    #'
    #' @param colour \code{"white"} or \code{"black"}.
    #' @return A list of \code{list(from = Square, to = Square)}.
    generate_moves = function(colour) private$board$legal_moves(colour),

    #' @description Is this side in check?
    #' @param colour \code{"white"} or \code{"black"}.
    king_is_attacked = function(colour) private$board$is_in_check(colour),

    #' @description Check every ending condition and set the status.
    #'
    #' @param moves Optionally the already-generated legal moves for the side
    #'   to move. Passing them in avoids generating the same list twice per
    #'   turn, which is the single biggest cost on the R side.
    #' @return \code{TRUE} if the game is over.
    is_game_over = function(moves = NULL) {

      if (private$status != "ongoing") return(TRUE)

      colour <- private$current_colour
      if (is.null(moves)) moves <- self$generate_moves(colour)

      # --- checkmate or stalemate -------------------------------------------
      if (length(moves) == 0L) {
        if (private$board$is_in_check(colour)) {
          winner <- if (colour == "white") "black" else "white"
          private$status        <- paste0(winner, "_wins")
          private$result_reason <- "checkmate"
        } else {
          private$status        <- "draw"
          private$result_reason <- "stalemate"
        }
        return(TRUE)
      }

      # --- fifty-move rule (100 plies without a capture or pawn move) --------
      if (private$halfmove_clock >= 100L) {
        private$status        <- "draw"
        private$result_reason <- "fifty-move rule"
        return(TRUE)
      }

      # --- neither side has enough material to mate --------------------------
      if (private$insufficient_material()) {
        private$status        <- "draw"
        private$result_reason <- "insufficient material"
        return(TRUE)
      }

      # --- safety cap so a demo can never hang -------------------------------
      if (private$move_count >= self$max_moves) {
        private$status        <- "draw"
        private$result_reason <- "move limit reached"
        return(TRUE)
      }

      FALSE
    },

    #' @description Play exactly one turn.
    #' @param verbose Logical; print the move as it is played.
    #' @return \code{TRUE} if the game continues, \code{FALSE} once it ends.
    play_one_turn = function(verbose = FALSE) {

      if (private$status != "ongoing") return(FALSE)

      colour <- private$current_colour
      player <- self$current_player()

      # Generate once and hand the same list to both the end-check and the
      # player, instead of regenerating it several times per turn.
      moves <- self$generate_moves(colour)
      if (self$is_game_over(moves)) return(FALSE)

      # The polymorphic call: random, greedy or minimax, same interface.
      chosen  <- player$choose_move(private$board, moves)
      from_sq <- chosen$from
      to_sq   <- chosen$to

      mover      <- private$board$get_piece_at(from_sq)
      is_capture <- !is.null(private$board$get_piece_at(to_sq))
      is_pawn    <- !is.null(mover) && mover$type == "P"

      private$board$apply_move(from_sq, to_sq)
      private$move_count <- private$move_count + 1L

      # The fifty-move clock resets on any capture or pawn move.
      private$halfmove_clock <-
        if (is_capture || is_pawn) 0L else private$halfmove_clock + 1L

      notation <- utils::tail(private$board$get_history(), 1L)
      private$move_log <- c(private$move_log, list(list(
        colour   = colour,
        from     = from_sq$to_string(),
        to       = to_sq$to_string(),
        notation = notation
      )))

      if (verbose) {
        cat(sprintf("%3d. %-5s %-12s %s\n",
                    private$move_count, colour, player$name, notation))
      }

      private$current_colour <- if (colour == "white") "black" else "white"

      if (self$is_game_over()) return(FALSE)
      TRUE
    },

    #' @description Play the game to completion.
    #' @param verbose Logical; print every move.
    play = function(verbose = FALSE) {

      if (verbose) {
        cat("=== Game start ===\n")
        cat("White:", private$white_player$name,
            "(", private$white_player$strategy(), ")\n")
        cat("Black:", private$black_player$name,
            "(", private$black_player$strategy(), ")\n\n")
      }

      while (self$play_one_turn(verbose = verbose)) {}

      self$update_player_stats()

      if (verbose) {
        cat("\n=== Game over ===\n")
        cat("Result:", private$status, "-", private$result_reason, "\n")
        cat("Moves played:", private$move_count, "\n")
      }

      invisible(self)
    },

    #' @description Update both players' win/loss/draw counters.
    update_player_stats = function() {
      switch(private$status,
        "white_wins" = {
          private$white_player$record_win()
          private$black_player$record_loss()
        },
        "black_wins" = {
          private$white_player$record_loss()
          private$black_player$record_win()
        },
        "draw" = {
          private$white_player$record_draw()
          private$black_player$record_draw()
        },
        NULL
      )
      invisible(self)
    },

    #' @description One-row data frame summarising the finished game.
    summary_df = function() {
      data.frame(
        white        = private$white_player$name,
        black        = private$black_player$name,
        result       = private$status,
        reason       = private$result_reason %||% "",
        moves_played = private$move_count,
        stringsAsFactors = FALSE
      )
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      cat("=== Chess Game ===\n")
      cat("White:", private$white_player$name, "\n")
      cat("Black:", private$black_player$name, "\n")
      cat("Status:", private$status,
          if (!is.null(private$result_reason))
            paste0("(", private$result_reason, ")") else "", "\n")
      cat("Moves played:", private$move_count, "\n")
      invisible(self)
    }
  )
)


#' Tournament: round-robin tournament with a leaderboard
#'
#' Every player meets every other player twice per round, once with each
#' colour, and results are scored three points for a win and one for a draw.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(players, rounds)}}{Construct.}
#'   \item{\code{$run(verbose, progress)}}{Play all games.}
#'   \item{\code{$leaderboard()}}{Standings, best first.}
#'   \item{\code{$get_results()}}{Game-by-game data frame.}
#' }
#'
#' @examples
#' \dontrun{
#' t <- Tournament$new(list(RandomPlayer$new("A", "white"),
#'                          GreedyPlayer$new("B", "white")), rounds = 1)
#' t$run()
#' t$leaderboard()
#' }
#'
#' @export
Tournament <- R6::R6Class("Tournament",

  private = list(
    players      = NULL,
    game_results = NULL,
    rounds       = NULL
  ),

  public = list(

    #' @description Construct a Tournament.
    #' @param players A list of at least two \code{\link{Player}} objects.
    #'   Colours are reassigned for each game, so their initial colour does
    #'   not matter.
    #' @param rounds Positive integer number of round-robin cycles.
    initialize = function(players, rounds = 1L) {

      stopifnot(
        "players must be a list"     = is.list(players),
        "need at least 2 players"    = length(players) >= 2L,
        "all must be Player objects" =
          all(vapply(players, inherits, logical(1L), "Player")),
        "rounds must be a positive integer" =
          is.numeric(rounds) && length(rounds) == 1L && rounds >= 1L
      )

      private$players      <- players
      private$rounds       <- as.integer(rounds)
      private$game_results <- data.frame(
        white = character(), black = character(), result = character(),
        reason = character(), moves_played = integer(),
        stringsAsFactors = FALSE
      )

      invisible(self)
    },

    #' @description Play every pairing.
    #' @param verbose Logical; print each move of each game (very noisy).
    #' @param progress Logical; print one line per game as it finishes.
    run = function(verbose = FALSE, progress = TRUE) {

      names_v <- vapply(private$players, function(p) p$name, character(1L))
      n <- length(private$players)

      if (progress) {
        cat("=== Tournament ===\n")
        cat("Players:", paste(names_v, collapse = ", "), "\n")
        cat("Rounds:", private$rounds, " Games:",
            private$rounds * n * (n - 1L), "\n\n")
      }

      for (round_i in seq_len(private$rounds)) {
        if (progress && private$rounds > 1L) cat("-- Round", round_i, "--\n")

        for (i in seq_len(n)) {
          for (j in seq_len(n)) {
            if (i == j) next

            p_white <- private$players[[i]]
            p_black <- private$players[[j]]
            p_white$colour <- "white"
            p_black$colour <- "black"

            if (progress)
              cat(sprintf("  %-14s vs %-14s ... ", p_white$name, p_black$name))

            game <- Game$new(p_white, p_black)
            game$play(verbose = verbose)

            private$game_results <- rbind(private$game_results,
                                          game$summary_df())

            if (progress)
              cat(sprintf("%-11s (%s, %d moves)\n",
                          game$get_status(), game$get_result_reason(),
                          nrow(game$get_move_log())))
          }
        }
      }

      if (progress) cat("\nDone.\n")
      invisible(self)
    },

    #' @description Standings sorted by points, then wins.
    #' @return A data frame, or \code{NULL} if no games have been played.
    leaderboard = function() {

      if (nrow(private$game_results) == 0L) {
        message("No games played yet. Call $run() first.")
        return(NULL)
      }

      names_v <- vapply(private$players, function(p) p$name, character(1L))

      lb <- data.frame(
        player = names_v, played = 0L, wins = 0L, draws = 0L,
        losses = 0L, points = 0L, stringsAsFactors = FALSE
      )
      rownames(lb) <- names_v

      for (i in seq_len(nrow(private$game_results))) {
        row <- private$game_results[i, ]
        w <- row$white; b <- row$black

        lb[w, "played"] <- lb[w, "played"] + 1L
        lb[b, "played"] <- lb[b, "played"] + 1L

        if (row$result == "white_wins") {
          lb[w, "wins"]   <- lb[w, "wins"]   + 1L
          lb[b, "losses"] <- lb[b, "losses"] + 1L
          lb[w, "points"] <- lb[w, "points"] + 3L
        } else if (row$result == "black_wins") {
          lb[b, "wins"]   <- lb[b, "wins"]   + 1L
          lb[w, "losses"] <- lb[w, "losses"] + 1L
          lb[b, "points"] <- lb[b, "points"] + 3L
        } else {
          lb[w, "draws"]  <- lb[w, "draws"]  + 1L
          lb[b, "draws"]  <- lb[b, "draws"]  + 1L
          lb[w, "points"] <- lb[w, "points"] + 1L
          lb[b, "points"] <- lb[b, "points"] + 1L
        }
      }

      lb <- lb[order(-lb$points, -lb$wins), ]
      rownames(lb) <- NULL
      lb
    },

    #' @description The raw game-by-game results.
    get_results = function() private$game_results,

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      cat("=== Tournament ===\n")
      cat("Games played:", nrow(private$game_results), "\n\n")
      lb <- self$leaderboard()
      if (!is.null(lb)) print(lb)
      invisible(self)
    }
  )
)
