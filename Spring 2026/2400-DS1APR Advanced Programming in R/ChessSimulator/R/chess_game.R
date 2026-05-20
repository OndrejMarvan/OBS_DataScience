# =============================================================================
#  ChessSimulator — GAME AND TOURNAMENT CLASSES
#  File: R/chess_game.R
# =============================================================================
#
#  Defines the Game and Tournament R6 classes:
#    - Game        : orchestrates one match between two players
#    - Tournament  : round-robin tournament with leaderboard
#
#  Game does NOT know how pieces move (Board does) or which move to pick
#  (Player does). It only orchestrates: ask player -> validate -> apply
#  -> check end. This separation is the OOP principle from lecture 01.
# =============================================================================


# %||% : null-coalescing operator (custom infix from lecture 06)
# Returns x if not NULL, otherwise y.
`%||%` <- function(x, y) if (!is.null(x)) x else y


#' Game: a single chess game between two players
#'
#' Orchestrates a chess match. Generates legal moves, asks each player
#' to choose, applies moves to the Board, detects game-over conditions
#' (checkmate, stalemate, 50-move rule), and records results.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(white, black, max_moves)}}{Construct.}
#'   \item{\code{$play(verbose)}}{Play to completion.}
#'   \item{\code{$play_one_turn(verbose)}}{Advance by one turn.}
#'   \item{\code{$get_status()}}{\code{"ongoing"} / \code{"white_wins"} /
#'     \code{"black_wins"} / \code{"draw"}.}
#'   \item{\code{$get_result_reason()}}{e.g. \code{"checkmate"}, \code{"stalemate"}.}
#'   \item{\code{$get_board()}}{Current Board object.}
#'   \item{\code{$get_move_log()}}{Data frame of all moves played.}
#'   \item{\code{$generate_moves(colour)}}{Pseudo-legal moves for a colour.}
#' }
#'
#' @examples
#' \dontrun{
#' p1 <- RandomPlayer$new("Alpha", "white")
#' p2 <- RandomPlayer$new("Beta",  "black")
#' g  <- Game$new(p1, p2)
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

    current_colour   = "white",
    status           = "ongoing",
    result_reason    = NULL,
    move_count       = 0L,
    no_capture_count = 0L,
    move_log         = NULL
  ),

  public = list(

    #' @field max_moves Integer. Safety cap on game length.
    max_moves = 500L,

    #' @description Construct a Game.
    #' @param white_player A Player with colour \code{"white"}.
    #' @param black_player A Player with colour \code{"black"}.
    #' @param max_moves Integer. Safety cap. Default 500.
    initialize = function(white_player, black_player, max_moves = 500L) {

      stopifnot(
        "white_player must be a Player"         = inherits(white_player, "Player"),
        "black_player must be a Player"         = inherits(black_player, "Player"),
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

    #' @description Return the player whose turn it is.
    current_player = function() {
      if (private$current_colour == "white") private$white_player
      else                                   private$black_player
    },

    #' @description Get the current Board object.
    get_board = function() private$board,

    #' @description Game status string.
    get_status = function() private$status,

    #' @description Reason for game ending (e.g. \code{"checkmate"}).
    get_result_reason = function() private$result_reason,

    #' @description Move log as a data frame.
    get_move_log = function() {
      if (length(private$move_log) == 0) {
        return(data.frame(
          move_number = integer(),
          colour      = character(),
          from        = character(),
          to          = character(),
          notation    = character(),
          stringsAsFactors = FALSE
        ))
      }
      do.call(rbind, lapply(seq_along(private$move_log), function(i) {
        e <- private$move_log[[i]]
        data.frame(
          move_number = i,
          colour      = e$colour,
          from        = e$from,
          to          = e$to,
          notation    = e$notation,
          stringsAsFactors = FALSE
        )
      }))
    },

    # ========================================================================
    #  MOVE GENERATION
    # ========================================================================

    #' @description Generate all pseudo-legal moves for a colour.
    #' @param colour \code{"white"} or \code{"black"}.
    generate_moves = function(colour) {
      moves  <- list()
      pieces <- private$board$get_all_pieces(colour)
      for (piece in pieces) {
        moves <- c(moves, self$moves_for_piece(piece))
      }
      moves
    },

    #' @description Pseudo-legal moves for one piece (dispatches by type).
    #' @param piece A Piece object.
    moves_for_piece = function(piece) {
      generator <- switch(piece$type,
        "P" = self$pawn_moves,
        "N" = self$knight_moves,
        "B" = self$bishop_moves,
        "R" = self$rook_moves,
        "Q" = self$queen_moves,
        "K" = self$king_moves
      )
      generator(piece, private$board)
    },

    #' @description Pawn move generator.
    #' @param piece The pawn.
    #' @param board The board.
    pawn_moves = function(piece, board) {

      moves <- list()
      f_idx <- match(piece$position$file, letters[1:8])
      r     <- piece$position$rank
      dir   <- if (piece$colour == "white") 1L else -1L

      # Single step forward
      new_r <- r + dir
      if (new_r >= 1 && new_r <= 8) {
        target_sq <- Square$new(letters[f_idx], new_r)
        if (is.null(board$get_piece_at(target_sq))) {
          moves <- c(moves, list(list(from = piece$position, to = target_sq)))

          # Double step from starting rank
          start_rank <- if (piece$colour == "white") 2L else 7L
          if (r == start_rank && !piece$has_moved_yet()) {
            double_r  <- r + 2L * dir
            double_sq <- Square$new(letters[f_idx], double_r)
            if (is.null(board$get_piece_at(double_sq))) {
              moves <- c(moves, list(list(from = piece$position, to = double_sq)))
            }
          }
        }
      }

      # Diagonal captures
      for (df in c(-1L, 1L)) {
        cap_f <- f_idx + df
        cap_r <- r + dir
        if (cap_f >= 1 && cap_f <= 8 && cap_r >= 1 && cap_r <= 8) {
          cap_sq   <- Square$new(letters[cap_f], cap_r)
          occupant <- board$get_piece_at(cap_sq)
          if (!is.null(occupant) && occupant$colour != piece$colour) {
            moves <- c(moves, list(list(from = piece$position, to = cap_sq)))
          }
        }
      }

      moves
    },

    #' @description Knight move generator.
    #' @param piece The knight.
    #' @param board The board.
    knight_moves = function(piece, board) {
      moves   <- list()
      f_idx   <- match(piece$position$file, letters[1:8])
      r       <- piece$position$rank
      offsets <- list(c(2,1), c(2,-1), c(-2,1), c(-2,-1),
                      c(1,2), c(1,-2), c(-1,2), c(-1,-2))

      for (off in offsets) {
        new_f <- f_idx + off[1]
        new_r <- r     + off[2]
        if (new_f >= 1 && new_f <= 8 && new_r >= 1 && new_r <= 8) {
          target_sq <- Square$new(letters[new_f], new_r)
          occupant  <- board$get_piece_at(target_sq)
          if (is.null(occupant) || occupant$colour != piece$colour) {
            moves <- c(moves, list(list(from = piece$position, to = target_sq)))
          }
        }
      }
      moves
    },

    #' @description Shared helper for bishop, rook, queen.
    #' @param piece The sliding piece.
    #' @param board The board.
    #' @param directions List of c(df, dr) direction offsets.
    sliding_moves = function(piece, board, directions) {

      moves <- list()
      f_idx <- match(piece$position$file, letters[1:8])
      r     <- piece$position$rank

      for (dir in directions) {
        df    <- dir[1]
        dr    <- dir[2]
        cur_f <- f_idx + df
        cur_r <- r     + dr

        while (cur_f >= 1 && cur_f <= 8 && cur_r >= 1 && cur_r <= 8) {
          target_sq <- Square$new(letters[cur_f], cur_r)
          occupant  <- board$get_piece_at(target_sq)

          if (is.null(occupant)) {
            moves <- c(moves, list(list(from = piece$position, to = target_sq)))
          } else if (occupant$colour != piece$colour) {
            moves <- c(moves, list(list(from = piece$position, to = target_sq)))
            break
          } else {
            break
          }

          cur_f <- cur_f + df
          cur_r <- cur_r + dr
        }
      }

      moves
    },

    #' @description Bishop move generator.
    #' @param piece The bishop.
    #' @param board The board.
    bishop_moves = function(piece, board) {
      self$sliding_moves(piece, board,
        list(c(1,1), c(1,-1), c(-1,1), c(-1,-1)))
    },

    #' @description Rook move generator.
    #' @param piece The rook.
    #' @param board The board.
    rook_moves = function(piece, board) {
      self$sliding_moves(piece, board,
        list(c(1,0), c(-1,0), c(0,1), c(0,-1)))
    },

    #' @description Queen move generator.
    #' @param piece The queen.
    #' @param board The board.
    queen_moves = function(piece, board) {
      self$sliding_moves(piece, board,
        list(c(1,0),c(-1,0),c(0,1),c(0,-1),
             c(1,1),c(1,-1),c(-1,1),c(-1,-1)))
    },

    #' @description King move generator.
    #' @param piece The king.
    #' @param board The board.
    king_moves = function(piece, board) {

      moves <- list()
      f_idx <- match(piece$position$file, letters[1:8])
      r     <- piece$position$rank

      for (df in c(-1L, 0L, 1L)) {
        for (dr in c(-1L, 0L, 1L)) {
          if (df == 0 && dr == 0) next
          new_f <- f_idx + df
          new_r <- r     + dr
          if (new_f >= 1 && new_f <= 8 && new_r >= 1 && new_r <= 8) {
            target_sq <- Square$new(letters[new_f], new_r)
            occupant  <- board$get_piece_at(target_sq)
            if (is.null(occupant) || occupant$colour != piece$colour) {
              moves <- c(moves, list(list(from = piece$position, to = target_sq)))
            }
          }
        }
      }
      moves
    },

    # ========================================================================
    #  GAME-OVER DETECTION
    # ========================================================================

    #' @description Check all termination conditions. Sets status if over.
    is_game_over = function() {

      if (private$status != "ongoing") return(TRUE)

      colour <- private$current_colour
      moves  <- self$generate_moves(colour)

      # 50-move rule
      if (private$no_capture_count >= 100L) {
        private$status        <- "draw"
        private$result_reason <- "50-move rule"
        return(TRUE)
      }

      # Move cap
      if (private$move_count >= self$max_moves) {
        private$status        <- "draw"
        private$result_reason <- "move limit reached"
        return(TRUE)
      }

      # No legal moves -> checkmate or stalemate
      if (length(moves) == 0) {
        if (self$king_is_attacked(colour)) {
          opponent              <- if (colour == "white") "black" else "white"
          private$status        <- paste0(opponent, "_wins")
          private$result_reason <- "checkmate"
        } else {
          private$status        <- "draw"
          private$result_reason <- "stalemate"
        }
        return(TRUE)
      }

      FALSE
    },

    #' @description TRUE if the given colour's king is under attack.
    #' @param colour \code{"white"} or \code{"black"}.
    king_is_attacked = function(colour) {

      opponent <- if (colour == "white") "black" else "white"

      king_sq <- NULL
      for (piece in private$board$get_all_pieces(colour)) {
        if (piece$type == "K") {
          king_sq <- piece$position$to_string()
          break
        }
      }

      if (is.null(king_sq)) return(FALSE)

      opponent_moves <- self$generate_moves(opponent)
      for (move in opponent_moves) {
        if (move$to$to_string() == king_sq) return(TRUE)
      }

      FALSE
    },

    # ========================================================================
    #  GAME LOOP
    # ========================================================================

    #' @description Advance the game by one turn. Returns TRUE if continuing.
    #' @param verbose Logical. Print the move if TRUE.
    play_one_turn = function(verbose = FALSE) {

      if (private$status != "ongoing") {
        message("Game is already over: ", private$status)
        return(FALSE)
      }

      colour <- private$current_colour
      player <- self$current_player()
      moves  <- self$generate_moves(colour)

      if (self$is_game_over()) return(FALSE)

      # Polymorphic call - actual behaviour depends on player class
      chosen  <- player$choose_move(private$board, moves)
      from_sq <- chosen$from
      to_sq   <- chosen$to

      moving_piece <- private$board$get_piece_at(from_sq)
      is_capture   <- !is.null(private$board$get_piece_at(to_sq))
      is_pawn      <- !is.null(moving_piece) && moving_piece$type == "P"

      private$board$apply_move(from_sq, to_sq)
      private$move_count <- private$move_count + 1L

      if (is_capture || is_pawn) private$no_capture_count <- 0L
      else private$no_capture_count <- private$no_capture_count + 1L

      notation <- paste0(from_sq$to_string(), to_sq$to_string())
      private$move_log <- c(private$move_log, list(list(
        colour   = colour,
        from     = from_sq$to_string(),
        to       = to_sq$to_string(),
        notation = notation
      )))

      if (verbose) {
        cat(sprintf("Move %d | %s %s plays %s\n",
                    private$move_count, colour, player$name, notation))
      }

      private$current_colour <- if (colour == "white") "black" else "white"

      if (self$is_game_over()) return(FALSE)
      TRUE
    },

    #' @description Play to completion.
    #' @param verbose Logical. Print each move if TRUE.
    play = function(verbose = FALSE) {

      if (verbose) {
        cat("=== Game Start ===\n")
        cat("White:", private$white_player$name, "\n")
        cat("Black:", private$black_player$name, "\n\n")
      }

      while (self$play_one_turn(verbose = verbose)) {}

      self$update_player_stats()

      if (verbose) {
        cat("\n=== Game Over ===\n")
        cat("Result:", private$status, "\n")
        cat("Reason:", private$result_reason, "\n")
        cat("Moves played:", private$move_count, "\n")
      }

      invisible(self)
    },

    #' @description Update player win/loss/draw counters.
    update_player_stats = function() {
      status <- private$status
      if (status == "white_wins") {
        private$white_player$record_win()
        private$black_player$record_loss()
      } else if (status == "black_wins") {
        private$white_player$record_loss()
        private$black_player$record_win()
      } else if (status == "draw") {
        private$white_player$record_draw()
        private$black_player$record_draw()
      }
      invisible(self)
    },

    #' @description Single-row data frame summarising this game.
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
      cat("Status:", private$status, "\n")
      if (!is.null(private$result_reason))
        cat("Reason:", private$result_reason, "\n")
      cat("Moves played:", private$move_count, "\n")
      invisible(self)
    }
  )
)


#' Tournament: round-robin tournament between players
#'
#' Runs multiple Games between a pool of Players and computes a
#' leaderboard (win=3, draw=1, loss=0).
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(players, rounds)}}{Construct.}
#'   \item{\code{$run(verbose)}}{Run all games.}
#'   \item{\code{$leaderboard()}}{Sorted standings as a data frame.}
#'   \item{\code{$get_results()}}{Raw game-by-game data frame.}
#' }
#'
#' @examples
#' \dontrun{
#' p1 <- RandomPlayer$new("Alpha", "white")
#' p2 <- RandomPlayer$new("Beta",  "white")
#' p3 <- RandomPlayer$new("Gamma", "white")
#' t <- Tournament$new(list(p1, p2, p3), rounds = 1)
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
    #' @param players List of Player objects (>= 2).
    #' @param rounds Positive integer. Number of round-robin cycles. Default 1.
    initialize = function(players, rounds = 1L) {

      stopifnot(
        "players must be a list"     = is.list(players),
        "need at least 2 players"    = length(players) >= 2,
        "all must be Player objects" =
          all(vapply(players, inherits, logical(1L), "Player")),
        "rounds must be a positive integer" =
          is.numeric(rounds) && rounds >= 1
      )

      private$players      <- players
      private$rounds       <- as.integer(rounds)
      private$game_results <- data.frame(
        white        = character(),
        black        = character(),
        result       = character(),
        reason       = character(),
        moves_played = integer(),
        stringsAsFactors = FALSE
      )

      invisible(self)
    },

    #' @description Run all games.
    #' @param verbose Passed to each Game$play().
    run = function(verbose = FALSE) {

      player_names <- vapply(private$players, function(p) p$name, character(1L))
      n            <- length(private$players)

      cat("=== Tournament Start ===\n")
      cat("Players:", paste(player_names, collapse = ", "), "\n")
      cat("Rounds:", private$rounds, "\n\n")

      for (round_i in seq_len(private$rounds)) {
        cat("--- Round", round_i, "---\n")

        for (i in 1:n) {
          for (j in 1:n) {
            if (i == j) next

            p_white <- private$players[[i]]
            p_black <- private$players[[j]]
            p_white$colour <- "white"
            p_black$colour <- "black"

            cat(sprintf("  %s (white) vs %s (black)... ",
                        p_white$name, p_black$name))

            game <- Game$new(p_white, p_black)
            game$play(verbose = verbose)

            private$game_results <- rbind(
              private$game_results,
              game$summary_df()
            )

            cat(game$get_status(), "\n")
          }
        }
      }

      cat("\n=== Tournament Complete ===\n")
      invisible(self)
    },

    #' @description Leaderboard sorted by points then wins.
    leaderboard = function() {

      if (nrow(private$game_results) == 0) {
        message("No games played yet. Call $run() first.")
        return(NULL)
      }

      player_names <- vapply(private$players, function(p) p$name, character(1L))

      lb <- data.frame(
        player = player_names,
        played = 0L,
        wins   = 0L,
        draws  = 0L,
        losses = 0L,
        points = 0L,
        stringsAsFactors = FALSE
      )
      rownames(lb) <- player_names

      for (i in seq_len(nrow(private$game_results))) {
        row    <- private$game_results[i, ]
        white  <- row$white
        black  <- row$black
        result <- row$result

        lb[white, "played"] <- lb[white, "played"] + 1L
        lb[black, "played"] <- lb[black, "played"] + 1L

        if (result == "white_wins") {
          lb[white, "wins"]   <- lb[white, "wins"]   + 1L
          lb[black, "losses"] <- lb[black, "losses"] + 1L
          lb[white, "points"] <- lb[white, "points"] + 3L
        } else if (result == "black_wins") {
          lb[black, "wins"]   <- lb[black, "wins"]   + 1L
          lb[white, "losses"] <- lb[white, "losses"] + 1L
          lb[black, "points"] <- lb[black, "points"] + 3L
        } else {
          lb[white, "draws"]  <- lb[white, "draws"]  + 1L
          lb[black, "draws"]  <- lb[black, "draws"]  + 1L
          lb[white, "points"] <- lb[white, "points"] + 1L
          lb[black, "points"] <- lb[black, "points"] + 1L
        }
      }

      lb <- lb[order(-lb$points, -lb$wins), ]
      rownames(lb) <- NULL
      lb
    },

    #' @description Raw game-by-game data frame.
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
