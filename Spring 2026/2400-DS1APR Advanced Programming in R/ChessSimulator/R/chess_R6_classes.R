# =============================================================================
#  ChessSimulator — R6 CLASS STRUCTURE
#  Advanced Programming in R | dr Maria Kubara, WNE UW
#  Student: Ondrej Marvan | 477001
#  File: R/chess_R6_classes.R
# =============================================================================
#
#  Defines the four core R6 classes of the chess engine:
#    1. Square  — one cell on the board (e.g. "e4")
#    2. Piece   — a chess piece (type + colour + position)
#    3. Board   — the 8x8 board holding all pieces
#    4. Player  — a chess player with a name and a strategy
#
#  Plus the two concrete Player child classes:
#    5. RandomPlayer  — random move selection
#    6. MinimaxPlayer — calls the Rcpp minimax engine
#
#  WHY R6? (from lecture 04 — OOP R6 system)
#  ------------------------------------------
#  - Methods belong to objects (encapsulated OOP), called as object$method()
#  - Objects are MUTABLE — when a piece moves, the board updates IN PLACE
#  - private fields protect internal state from accidental modification
#  - Method chaining (invisible(self)) makes game loops readable:
#      game$make_move(move)$switch_turn()$log_state()
# =============================================================================


#' Square: a single cell on the chessboard
#'
#' Represents one cell identified by file (a-h) and rank (1-8).
#' Provides validation, algebraic notation, and conversion to a 1-64
#' linear index used by the Rcpp engine.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(file, rank)}}{Construct a new Square.}
#'   \item{\code{$to_string()}}{Return the square in algebraic notation
#'     (e.g. \code{"e4"}).}
#'   \item{\code{$to_index()}}{Return the 1-64 index (a1 = 1, h8 = 64).}
#'   \item{\code{$is_light_square()}}{TRUE if the square is light-coloured.}
#' }
#'
#' @examples
#' s <- Square$new("e", 4)
#' s$to_string()
#' s$to_index()
#' s$is_light_square()
#'
#' @export
Square <- R6::R6Class("Square",

  public = list(

    #' @field file Character. The file (column), one of \code{"a"}-\code{"h"}.
    file = NULL,

    #' @field rank Integer. The rank (row), 1-8.
    rank = NULL,

    #' @description Create a new Square.
    #' @param file Character. One of \code{"a"} through \code{"h"}.
    #' @param rank Integer. 1 through 8.
    initialize = function(file, rank) {

      # Defensive programming (lecture 06): named stopifnot() assertions
      stopifnot(
        "file must be a single character" =
          is.character(file) && length(file) == 1,
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

    #' @description Return the square in algebraic notation.
    to_string = function() {
      paste0(self$file, self$rank)
    },

    #' @description Convert the square to a 1-64 integer index.
    #' Layout: a1=1, b1=2, ..., h1=8, a2=9, ..., h8=64.
    to_index = function() {
      (self$rank - 1L) * 8L + match(self$file, letters[1:8])
    },

    #' @description Returns TRUE if the square has a light colour.
    is_light_square = function() {
      file_idx <- match(self$file, letters[1:8])
      (file_idx + self$rank) %% 2 == 0
    },

    #' @description Print method — called automatically in the console.
    #' @param ... Ignored (required by the S3 generic).
    print = function(...) {
      cat("Square:", self$to_string(), "\n")
      invisible(self)
    }
  )
)


#' Piece: a chess piece
#'
#' Represents one piece with a type, colour, and current position.
#' The \code{has_moved} flag is stored in a private field and updated
#' automatically when \code{$move_to()} is called.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(type, colour, position)}}{Construct a new Piece.}
#'   \item{\code{$move_to(new_square)}}{Move to a new Square. Sets
#'     has_moved flag.}
#'   \item{\code{$capture()}}{Mark as captured (\code{position <- NULL}).}
#'   \item{\code{$has_moved_yet()}}{Public getter for the private
#'     \code{has_moved} flag.}
#'   \item{\code{$value()}}{Standard material value (P=1, N=B=3, R=5, Q=9, K=0).}
#'   \item{\code{$symbol()}}{Unicode chess symbol for display.}
#' }
#'
#' @examples
#' p <- Piece$new("Q", "white", Square$new("d", 1))
#' p$has_moved_yet()
#' p$value()
#' p$symbol()
#'
#' @export
Piece <- R6::R6Class("Piece",

  private = list(
    # Private field — protected from accidental modification.
    # Update only via $move_to(), read via $has_moved_yet().
    has_moved = FALSE
  ),

  public = list(

    #' @field type Character. One of \code{"K"}, \code{"Q"}, \code{"R"},
    #'   \code{"B"}, \code{"N"}, \code{"P"}.
    type = NULL,

    #' @field colour Character. \code{"white"} or \code{"black"}.
    colour = NULL,

    #' @field position A Square object, or \code{NULL} if captured.
    position = NULL,

    #' @description Create a new Piece.
    #' @param type Character. Piece type (K/Q/R/B/N/P).
    #' @param colour Character. \code{"white"} or \code{"black"}.
    #' @param position A Square object.
    initialize = function(type, colour, position) {

      stopifnot(
        "type must be K/Q/R/B/N/P"   = type %in% c("K","Q","R","B","N","P"),
        "colour must be white/black" = colour %in% c("white","black"),
        "position must be a Square"  = inherits(position, "Square")
      )

      self$type     <- type
      self$colour   <- colour
      self$position <- position

      invisible(self)
    },

    #' @description Move the piece to a new square. Updates has_moved flag.
    #' @param new_square A Square object — the destination.
    move_to = function(new_square) {
      stopifnot("new_square must be a Square" = inherits(new_square, "Square"))
      self$position     <- new_square
      private$has_moved <- TRUE
      invisible(self)
    },

    #' @description Mark this piece as captured by setting position to NULL.
    capture = function() {
      self$position <- NULL
      invisible(self)
    },

    #' @description Public getter for the private has_moved field.
    has_moved_yet = function() {
      private$has_moved
    },

    #' @description Return the Unicode chess symbol for this piece.
    symbol = function() {
      symbols <- list(
        white = c(K = "\u2654", Q = "\u2655", R = "\u2656",
                  B = "\u2657", N = "\u2658", P = "\u2659"),
        black = c(K = "\u265A", Q = "\u265B", R = "\u265C",
                  B = "\u265D", N = "\u265E", P = "\u265F")
      )
      symbols[[self$colour]][[self$type]]
    },

    #' @description Standard material value (P=1, N=B=3, R=5, Q=9, K=0).
    value = function() {
      vals <- c(P = 1, N = 3, B = 3, R = 5, Q = 9, K = 0)
      vals[[self$type]]
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      pos_str <- if (is.null(self$position)) "captured"
                 else self$position$to_string()
      cat(self$colour, self$type, "at", pos_str,
          if (private$has_moved) "(moved)" else "(not moved yet)", "\n")
      invisible(self)
    }
  )
)


#' Board: the full chessboard
#'
#' Holds all 32 pieces (active and captured) and the move history.
#' Pieces are stored in a private named list to prevent external code
#' from bypassing \code{$apply_move()}.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new()}}{Construct a board in the standard starting position.}
#'   \item{\code{$get_piece_at(square)}}{Piece at a given square, or NULL.}
#'   \item{\code{$apply_move(from_sq, to_sq)}}{Execute a move.}
#'   \item{\code{$get_all_pieces(colour = NULL)}}{Active pieces, optionally
#'     filtered by colour.}
#'   \item{\code{$to_matrix()}}{8x8 character matrix for display.}
#'   \item{\code{$encode_for_engine()}}{8x8 integer matrix for the Rcpp
#'     engine. Encoding: white pieces positive (P=1, N=3, B=3, R=5,
#'     Q=9, K=100), black pieces negative, empty = 0.}
#'   \item{\code{$display()}}{Print a text board to the console.}
#'   \item{\code{$material_balance()}}{Material score (white - black).}
#'   \item{\code{$get_history()}}{Character vector of moves in algebraic notation.}
#' }
#'
#' @examples
#' b <- Board$new()
#' b$display()
#' b$material_balance()
#'
#' @export
Board <- R6::R6Class("Board",

  private = list(
    pieces  = NULL,   # named list of all Piece objects
    history = NULL    # list of move strings
  ),

  public = list(

    #' @description Create a board in the standard starting position.
    initialize = function() {
      private$history <- list()
      private$pieces  <- self$setup_pieces()
      invisible(self)
    },

    #' @description Create all 32 starting pieces.
    #' @return A named list of Piece objects.
    setup_pieces = function() {

      pieces    <- list()
      back_rank <- c("R","N","B","Q","K","B","N","R")

      for (colour in c("white", "black")) {

        back      <- if (colour == "white") 1L else 8L
        pawn_rank <- if (colour == "white") 2L else 7L

        # Back-rank pieces
        for (i in seq_along(back_rank)) {
          file <- letters[i]
          type <- back_rank[i]
          key  <- paste0(colour, "_", type, "_", file)
          pieces[[key]] <- Piece$new(type, colour, Square$new(file, back))
        }

        # Pawns
        for (i in 1:8) {
          file <- letters[i]
          key  <- paste0(colour, "_P_", file)
          pieces[[key]] <- Piece$new("P", colour, Square$new(file, pawn_rank))
        }
      }

      pieces
    },

    #' @description Return the Piece at a square, or NULL if empty.
    #' @param square A Square object.
    get_piece_at = function(square) {

      stopifnot("square must be a Square" = inherits(square, "Square"))

      for (piece in private$pieces) {
        if (!is.null(piece$position) &&
            piece$position$to_string() == square$to_string()) {
          return(piece)
        }
      }
      NULL
    },

    #' @description Execute a move. Captures any enemy piece on the target.
    #' @param from_sq Square. Source of the move.
    #' @param to_sq Square. Destination of the move.
    apply_move = function(from_sq, to_sq) {

      stopifnot(inherits(from_sq, "Square"), inherits(to_sq, "Square"))

      moving_piece <- self$get_piece_at(from_sq)
      if (is.null(moving_piece)) {
        stop(paste("No piece at", from_sq$to_string()))
      }

      target_piece <- self$get_piece_at(to_sq)
      if (!is.null(target_piece)) {
        if (target_piece$colour == moving_piece$colour) {
          stop("Cannot capture your own piece!")
        }
        target_piece$capture()
      }

      moving_piece$move_to(to_sq)

      move_str <- paste0(from_sq$to_string(), to_sq$to_string())
      private$history <- c(private$history, move_str)

      invisible(moving_piece)
    },

    #' @description Return all active pieces (optionally filtered).
    #' @param colour Optional. \code{"white"}, \code{"black"}, or \code{NULL}
    #'   for all colours.
    get_all_pieces = function(colour = NULL) {

      all <- Filter(function(p) !is.null(p$position), private$pieces)

      if (!is.null(colour)) {
        stopifnot("colour must be white/black" = colour %in% c("white","black"))
        all <- Filter(function(p) p$colour == colour, all)
      }

      all
    },

    #' @description 8x8 character matrix of the board state.
    #' Empty=".", white pieces UPPERCASE, black pieces lowercase.
    to_matrix = function() {

      mat <- matrix(".", nrow = 8, ncol = 8,
                    dimnames = list(8:1, letters[1:8]))

      for (piece in self$get_all_pieces()) {
        f             <- piece$position$file
        r             <- piece$position$rank
        display_row   <- as.character(9L - r)
        symbol        <- if (piece$colour == "white") piece$type
                         else tolower(piece$type)
        mat[display_row, f] <- symbol
      }

      mat
    },

    #' @description 8x8 integer matrix for the Rcpp engine.
    #'
    #' Encoding:
    #' - White pieces: P=1, N=3, B=3, R=5, Q=9, K=100
    #' - Black pieces: same values but negative
    #' - Empty: 0
    #'
    #' Row 1 of the matrix = rank 1 (white's home rank).
    #' Col 1 of the matrix = file a.
    #'
    #' This method lives on Board (not on MinimaxPlayer) because
    #' encoding the board state for the engine is a Board responsibility.
    encode_for_engine = function() {

      piece_val <- c(P = 1, N = 3, B = 3, R = 5, Q = 9, K = 100)
      mat <- matrix(0L, nrow = 8, ncol = 8)

      for (piece in self$get_all_pieces()) {
        f   <- match(piece$position$file, letters[1:8])
        r   <- piece$position$rank
        val <- piece_val[[piece$type]]
        mat[r, f] <- if (piece$colour == "white") val else -val
      }

      mat
    },

    #' @description Print a text board to the console.
    display = function() {

      mat <- self$to_matrix()
      cat("\n")
      for (i in 1:8) {
        rank_label <- 9L - i
        cat(rank_label, " ", paste(mat[i, ], collapse = " "), "\n")
      }
      cat("   a b c d e f g h\n\n")

      invisible(self)
    },

    #' @description Move history as a character vector.
    get_history = function() {
      unlist(private$history)
    },

    #' @description Material advantage for white (positive = white ahead).
    material_balance = function() {
      pieces  <- self$get_all_pieces()
      balance <- 0
      for (p in pieces) {
        if (p$type == "K") next
        if (p$colour == "white") balance <- balance + p$value()
        else                     balance <- balance - p$value()
      }
      balance
    },

    #' @description Print method — shows board + summary stats.
    #' @param ... Ignored.
    print = function(...) {
      cat("=== Chess Board ===\n")
      self$display()
      cat("Material balance (white - black):", self$material_balance(), "\n")
      cat("Moves played:", length(private$history), "\n")
      invisible(self)
    }
  )
)


#' Player: abstract base class for chess players
#'
#' The base Player class defines the interface that every concrete player
#' must implement: \code{$choose_move(board, legal_moves)}. The base class
#' itself throws an error if \code{choose_move} is called directly — use
#' \code{\link{RandomPlayer}} or \code{\link{MinimaxPlayer}} instead.
#'
#' This is the polymorphism mechanism from lecture 04 — child classes
#' override \code{choose_move()} with concrete strategies, and the
#' \code{\link{Game}} class invokes them uniformly.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(name, colour)}}{Construct.}
#'   \item{\code{$choose_move(board, legal_moves)}}{Abstract — override.}
#'   \item{\code{$record_win() / record_loss() / record_draw()}}{Increment
#'     private stat counters.}
#'   \item{\code{$stats()}}{Named vector of W/L/D counts.}
#' }
#'
#' @export
Player <- R6::R6Class("Player",

  private = list(
    wins   = 0L,
    losses = 0L,
    draws  = 0L
  ),

  public = list(

    #' @field name Character. Display name.
    name = NULL,

    #' @field colour Character. \code{"white"} or \code{"black"}.
    colour = NULL,

    #' @description Construct a Player.
    #' @param name Character. Display name.
    #' @param colour Character. \code{"white"} or \code{"black"}.
    initialize = function(name, colour) {

      stopifnot(
        "name must be a non-empty string" =
          is.character(name) && nchar(name) > 0,
        "colour must be white/black" = colour %in% c("white","black")
      )

      self$name   <- name
      self$colour <- colour

      invisible(self)
    },

    #' @description Abstract method — must be overridden by child classes.
    #' @param board The current Board object.
    #' @param legal_moves A list of legal moves.
    choose_move = function(board, legal_moves) {
      stop(paste(
        "Player$choose_move() is abstract.",
        "Use RandomPlayer or MinimaxPlayer instead."
      ))
    },

    #' @description Increment win counter.
    record_win  = function() { private$wins   <- private$wins   + 1L; invisible(self) },
    #' @description Increment loss counter.
    record_loss = function() { private$losses <- private$losses + 1L; invisible(self) },
    #' @description Increment draw counter.
    record_draw = function() { private$draws  <- private$draws  + 1L; invisible(self) },

    #' @description Named vector of W/L/D counts.
    stats = function() {
      c(wins = private$wins, losses = private$losses, draws = private$draws)
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      s <- self$stats()
      cat("Player:", self$name, "(", self$colour, ")\n")
      cat("  W:", s["wins"], "  L:", s["losses"], "  D:", s["draws"], "\n")
      invisible(self)
    }
  )
)


#' RandomPlayer: picks a random legal move
#'
#' Concrete child of \code{\link{Player}}. Overrides \code{choose_move()}
#' with uniform random selection from the legal-move list.
#'
#' @examples
#' p <- RandomPlayer$new("Rand", "white")
#' p
#'
#' @export
RandomPlayer <- R6::R6Class("RandomPlayer",

  inherit = Player,

  public = list(

    #' @description Construct. Delegates to Player$initialize() via super$.
    #' @param name Character.
    #' @param colour Character.
    initialize = function(name, colour) {
      super$initialize(name, colour)
      invisible(self)
    },

    #' @description Pick a uniformly random move.
    #' @param board The current Board (unused — required by interface).
    #' @param legal_moves List of moves.
    choose_move = function(board, legal_moves) {
      if (length(legal_moves) == 0) stop("No legal moves available.")
      legal_moves[[ sample(length(legal_moves), 1) ]]
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      cat("RandomPlayer:", self$name, "(", self$colour,
          ") - strategy: random\n")
      s <- self$stats()
      cat("  W:", s["wins"], "  L:", s["losses"], "  D:", s["draws"], "\n")
      invisible(self)
    }
  )
)


#' MinimaxPlayer: uses the Rcpp minimax engine
#'
#' Concrete child of \code{\link{Player}}. Overrides \code{choose_move()}
#' by calling the C++ \code{chess_minimax()} function with the current
#' board state. Falls back to random move selection if the engine call
#' fails (via \code{tryCatch}).
#'
#' @examples
#' p <- MinimaxPlayer$new("Deep", "black", depth = 3)
#' p
#'
#' @export
MinimaxPlayer <- R6::R6Class("MinimaxPlayer",

  inherit = Player,

  public = list(

    #' @field depth Integer. Search depth for minimax.
    depth = NULL,

    #' @description Construct a MinimaxPlayer.
    #' @param name Character.
    #' @param colour Character.
    #' @param depth Positive integer. Search depth. Default 3.
    initialize = function(name, colour, depth = 3L) {

      super$initialize(name, colour)

      stopifnot(
        "depth must be a positive integer" =
          is.numeric(depth) && depth >= 1
      )
      self$depth <- as.integer(depth)

      invisible(self)
    },

    #' @description Choose the best move via the Rcpp minimax engine.
    #' Falls back to a random move on engine failure.
    #' @param board The current Board.
    #' @param legal_moves List of legal moves.
    choose_move = function(board, legal_moves) {

      if (length(legal_moves) == 0) {
        stop("No legal moves available.")
      }

      # Encoding is now Board's responsibility (refactored)
      board_matrix <- board$encode_for_engine()

      result <- tryCatch({
        colour_int <- if (self$colour == "white") 1L else -1L
        chess_minimax(board_matrix, colour_int, self$depth)
      }, error = function(e) {
        warning("Minimax engine error: ", conditionMessage(e),
                " - falling back to random.")
        NULL
      })

      if (!is.null(result) && length(result) == 2 && all(result > 0)) {
        from_sq <- self$index_to_square(result[1])
        to_sq   <- self$index_to_square(result[2])
        return(list(from = from_sq, to = to_sq))
      }

      legal_moves[[ sample(length(legal_moves), 1) ]]
    },

    #' @description Convert a 1-64 index back to a Square object.
    #' Inverse of \code{Square$to_index()}.
    #' @param idx Integer. 1-64.
    index_to_square = function(idx) {
      idx  <- as.integer(idx)
      rank <- ((idx - 1L) %/% 8L) + 1L
      file <- letters[((idx - 1L) %% 8L) + 1L]
      Square$new(file, rank)
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      cat("MinimaxPlayer:", self$name, "(", self$colour,
          ") - depth:", self$depth, "\n")
      s <- self$stats()
      cat("  W:", s["wins"], "  L:", s["losses"], "  D:", s["draws"], "\n")
      invisible(self)
    }
  )
)
