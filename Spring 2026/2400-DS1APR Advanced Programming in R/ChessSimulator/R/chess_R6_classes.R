# =============================================================================
#  ChessSimulator — R6 CLASS STRUCTURE
#  Advanced Programming in R | dr Maria Kubara, WNE UW
#  File: R/chess_R6_classes.R
# =============================================================================
#
#  Classes defined here:
#    Square        — one cell of the board ("e4")
#    Piece         — a chess piece (type, colour, position)
#    Board         — the 8x8 board: pieces, move generation, attack detection
#    Player        — abstract base class for players
#    RandomPlayer  — plays a random legal move
#    GreedyPlayer  — plays the move that wins the most material right now
#    MinimaxPlayer — asks the C++ engine for the best move
#
#  WHY R6? (lecture 04)
#    - methods belong to objects:  board$apply_move(...)
#    - objects are MUTABLE, so a move updates the board in place. This matters
#      enormously for a search that plays and takes back thousands of moves.
#    - private fields protect internal state (the piece list, the board index)
#    - invisible(self) enables method chaining
#
#  THREE PLAYERS, ONE INTERFACE
#    Game only ever calls  player$choose_move(board, legal_moves).
#    RandomPlayer answers with luck, GreedyPlayer with one ply of pure R,
#    MinimaxPlayer by delegating to C++. That is polymorphism doing real work.
# =============================================================================


#' Square: a single cell on the chessboard
#'
#' Represents one cell identified by file (a-h) and rank (1-8), validated on
#' construction. Also converts to the 1-64 index used by the C++ engine.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(file, rank)}}{Construct a new Square.}
#'   \item{\code{$to_string()}}{Algebraic notation, e.g. \code{"e4"}.}
#'   \item{\code{$to_index()}}{Linear index 1-64 (a1 = 1, h8 = 64).}
#'   \item{\code{$is_light_square()}}{TRUE if the square is light coloured.}
#' }
#'
#' @examples
#' s <- Square$new("e", 4)
#' s$to_string()
#' s$to_index()
#'
#' @export
Square <- R6::R6Class("Square",

  public = list(

    #' @field file Character, one of \code{"a"}-\code{"h"}.
    file = NULL,

    #' @field rank Integer, 1-8.
    rank = NULL,

    #' @description Create a new Square.
    #' @param file Character, \code{"a"} through \code{"h"}.
    #' @param rank Integer, 1 through 8.
    initialize = function(file, rank) {

      # Defensive programming (lecture 06). Named assertions become readable
      # error messages instead of "is.character(file) is not TRUE".
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

    #' @description Algebraic notation of the square.
    to_string = function() paste0(self$file, self$rank),

    #' @description Linear index 1-64 used by the C++ engine.
    to_index = function() {
      (self$rank - 1L) * 8L + match(self$file, letters[1:8])
    },

    #' @description TRUE when the square is light coloured.
    #'
    #' Chess boards are laid out "white on the right": h1, the bottom-right
    #' corner from White's view, is light, and a1 is dark. So a square is
    #' light when file + rank is ODD (h1 = 8 + 1 = 9, light; a1 = 2, dark).
    is_light_square = function() {
      (match(self$file, letters[1:8]) + self$rank) %% 2 == 1
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      cat("Square:", self$to_string(), "\n")
      invisible(self)
    }
  )
)


#' Convert a 1-64 index back into a Square
#'
#' Inverse of \code{Square$to_index()}. Used to translate moves returned by
#' the C++ engine back into R objects.
#'
#' @param idx Integer between 1 and 64.
#' @return A \code{\link{Square}} object.
#'
#' @examples
#' index_to_square(29)$to_string()   # "e4"
#'
#' @export
index_to_square <- function(idx) {
  idx <- as.integer(idx)
  stopifnot("idx must be between 1 and 64" =
              length(idx) == 1L && idx >= 1L && idx <= 64L)
  Square$new(letters[((idx - 1L) %% 8L) + 1L], ((idx - 1L) %/% 8L) + 1L)
}


#' Piece: a chess piece
#'
#' Holds a type, a colour and a position. \code{has_moved} is private so it can
#' only change through \code{$move_to()}, which keeps it in step with position.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new(type, colour, position)}}{Construct a Piece.}
#'   \item{\code{$move_to(square)}}{Move, setting the has-moved flag.}
#'   \item{\code{$capture()}}{Mark as captured (\code{position <- NULL}).}
#'   \item{\code{$has_moved_yet()}}{Read the private has-moved flag.}
#'   \item{\code{$value()}}{Material value: P 1, N/B 3, R 5, Q 9, K 0.}
#'   \item{\code{$type_code()}}{Engine code: P 1, N 2, B 3, R 4, Q 5, K 6.}
#'   \item{\code{$symbol()}}{Unicode chess symbol.}
#' }
#'
#' @examples
#' p <- Piece$new("Q", "white", Square$new("d", 1))
#' p$value()
#' p$type_code()
#'
#' @export
Piece <- R6::R6Class("Piece",

  private = list(
    # Private: only $move_to() and $restore_state() may change this.
    has_moved = FALSE
  ),

  public = list(

    #' @field type Character: K, Q, R, B, N or P.
    type = NULL,

    #' @field colour Character: \code{"white"} or \code{"black"}.
    colour = NULL,

    #' @field position A \code{\link{Square}}, or \code{NULL} once captured.
    position = NULL,

    #' @description Create a new Piece.
    #' @param type Character, one of K/Q/R/B/N/P.
    #' @param colour Character, \code{"white"} or \code{"black"}.
    #' @param position A \code{\link{Square}} object.
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

    #' @description Move the piece and record that it has moved.
    #' @param new_square Destination \code{\link{Square}}.
    move_to = function(new_square) {
      stopifnot("new_square must be a Square" = inherits(new_square, "Square"))
      self$position     <- new_square
      private$has_moved <- TRUE
      invisible(self)
    },

    #' @description Mark the piece as captured.
    capture = function() {
      self$position <- NULL
      invisible(self)
    },

    #' @description Restore a previous state. Used only by
    #'   \code{Board$undo_move()} when a trial move is taken back; not
    #'   intended for general use.
    #' @param position A \code{\link{Square}} or \code{NULL}.
    #' @param type Character piece type to restore (undoes promotion).
    #' @param had_moved Logical, the previous has-moved flag.
    restore_state = function(position, type, had_moved) {
      self$position     <- position
      self$type         <- type
      private$has_moved <- had_moved
      invisible(self)
    },

    #' @description Read the private has-moved flag.
    has_moved_yet = function() private$has_moved,

    #' @description Unicode chess symbol for display.
    symbol = function() {
      symbols <- list(
        white = c(K = "\u2654", Q = "\u2655", R = "\u2656",
                  B = "\u2657", N = "\u2658", P = "\u2659"),
        black = c(K = "\u265A", Q = "\u265B", R = "\u265C",
                  B = "\u265D", N = "\u265E", P = "\u265F")
      )
      symbols[[self$colour]][[self$type]]
    },

    #' @description Material value in pawns.
    value = function() {
      c(P = 1, N = 3, B = 3, R = 5, Q = 9, K = 0)[[self$type]]
    },

    #' @description Numeric code for the C++ engine.
    #'
    #' Every piece type gets its OWN code: P 1, N 2, B 3, R 4, Q 5, K 6.
    #' This matters — an earlier version gave knights and bishops the same
    #' code, so the C++ move generator could not tell them apart and produced
    #' illegal moves, which is what made the AI look like a random walk.
    type_code = function() {
      c(P = 1L, N = 2L, B = 3L, R = 4L, Q = 5L, K = 6L)[[self$type]]
    },

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      pos <- if (is.null(self$position)) "captured" else self$position$to_string()
      cat(self$colour, self$type, "at", pos,
          if (private$has_moved) "(moved)" else "(not moved yet)", "\n")
      invisible(self)
    }
  )
)


#' Board: the chessboard and everything on it
#'
#' Holds all 32 pieces, the move history, and a 64-slot index for fast lookup.
#' Also provides move generation, attack detection and make/unmake, which is
#' what lets the game produce genuinely legal moves.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{$new()}}{Standard starting position.}
#'   \item{\code{$get_piece_at(square)}}{Piece on a square, or \code{NULL}.}
#'   \item{\code{$apply_move(from, to, log)}}{Play a move; returns an undo record.}
#'   \item{\code{$undo_move(record)}}{Take a move back.}
#'   \item{\code{$pseudo_moves(colour)}}{Moves ignoring check.}
#'   \item{\code{$legal_moves(colour)}}{Moves that leave the king safe.}
#'   \item{\code{$has_legal_move(colour)}}{Cheap "can this side move?" test.}
#'   \item{\code{$is_square_attacked(square, by_colour)}}{Attack detection.}
#'   \item{\code{$is_in_check(colour)}}{Is this side in check?}
#'   \item{\code{$to_matrix()}}{8x8 character matrix for display.}
#'   \item{\code{$encode_for_engine()}}{8x8 integer matrix for the C++ engine.}
#'   \item{\code{$material_balance()}}{Material score, white minus black.}
#' }
#'
#' @examples
#' b <- Board$new()
#' b$display()
#' length(b$legal_moves("white"))   # 20 at the start
#'
#' @export
Board <- R6::R6Class("Board",

  private = list(

    pieces  = NULL,   # named list of all 32 Piece objects
    history = NULL,   # character vector of moves played

    # ------------------------------------------------------------------------
    #  grid: a 64-slot index from square index -> Piece (or NULL)
    #
    #  Without it, get_piece_at() had to scan all 32 pieces on every call, and
    #  move generation calls it hundreds of times per position. The index turns
    #  an O(32) scan into an O(1) lookup. It is private because it MUST stay in
    #  step with the pieces; only apply_move() and undo_move() may touch it.
    # ------------------------------------------------------------------------
    grid = NULL,

    grid_set = function(idx, piece) {
      private$grid[idx] <- list(piece)
      invisible(NULL)
    }
  ),

  public = list(

    #' @description Build a board in the standard starting position.
    initialize = function() {
      private$history <- character(0)
      private$grid    <- vector("list", 64)
      private$pieces  <- self$setup_pieces()
      invisible(self)
    },

    #' @description Create all 32 starting pieces and fill the index.
    #' @return A named list of \code{\link{Piece}} objects.
    setup_pieces = function() {

      pieces    <- list()
      back_rank <- c("R","N","B","Q","K","B","N","R")

      for (colour in c("white", "black")) {

        back      <- if (colour == "white") 1L else 8L
        pawn_rank <- if (colour == "white") 2L else 7L

        for (i in 1:8) {
          file <- letters[i]

          sq  <- Square$new(file, back)
          p   <- Piece$new(back_rank[i], colour, sq)
          pieces[[paste0(colour, "_", back_rank[i], "_", file)]] <- p
          private$grid_set(sq$to_index(), p)

          sq2 <- Square$new(file, pawn_rank)
          p2  <- Piece$new("P", colour, sq2)
          pieces[[paste0(colour, "_P_", file)]] <- p2
          private$grid_set(sq2$to_index(), p2)
        }
      }

      pieces
    },

    #' @description The piece standing on a square, or \code{NULL}.
    #' @param square A \code{\link{Square}} object.
    get_piece_at = function(square) {
      stopifnot("square must be a Square" = inherits(square, "Square"))
      private$grid[[square$to_index()]]
    },

    #' @description Play a move on the board.
    #'
    #' Handles captures and automatic pawn promotion to a queen. Returns a
    #' record that \code{$undo_move()} can use to restore the position exactly.
    #' This make/unmake pair is what allows legal-move filtering and search
    #' without copying the whole board.
    #'
    #' @param from_sq Source \code{\link{Square}}.
    #' @param to_sq Destination \code{\link{Square}}.
    #' @param log Logical; append to the history? Trial moves use \code{FALSE}
    #'   so they do not pollute the game record.
    #' @return An undo record (a list), invisibly.
    apply_move = function(from_sq, to_sq, log = TRUE) {

      stopifnot(inherits(from_sq, "Square"), inherits(to_sq, "Square"))

      from_idx <- from_sq$to_index()
      to_idx   <- to_sq$to_index()

      mover <- private$grid[[from_idx]]
      if (is.null(mover)) stop(paste("No piece at", from_sq$to_string()))

      captured <- private$grid[[to_idx]]
      if (!is.null(captured) && captured$colour == mover$colour)
        stop("Cannot capture your own piece!")

      # Everything needed to put the position back exactly as it was.
      record <- list(
        from      = from_sq,
        to        = to_sq,
        mover     = mover,
        captured  = captured,
        had_moved = mover$has_moved_yet(),
        old_type  = mover$type,
        logged    = log
      )

      if (!is.null(captured)) captured$capture()

      mover$move_to(to_sq)
      private$grid_set(from_idx, NULL)
      private$grid_set(to_idx,   mover)

      # Automatic promotion. A pawn reaching the far rank becomes a queen.
      # Under-promotion is legal but almost never useful, so it is left out.
      last_rank <- if (mover$colour == "white") 8L else 1L
      if (mover$type == "P" && to_sq$rank == last_rank) mover$type <- "Q"

      if (log) {
        note <- if (record$old_type == "P" && mover$type == "Q") "=Q" else ""
        private$history <- c(private$history,
                             paste0(from_sq$to_string(), to_sq$to_string(), note))
      }

      invisible(record)
    },

    #' @description Take a move back, restoring the exact previous position.
    #' @param record An undo record returned by \code{$apply_move()}.
    undo_move = function(record) {

      from_idx <- record$from$to_index()
      to_idx   <- record$to$to_index()

      record$mover$restore_state(record$from, record$old_type, record$had_moved)
      private$grid_set(from_idx, record$mover)

      if (!is.null(record$captured)) {
        record$captured$restore_state(record$to, record$captured$type, TRUE)
        private$grid_set(to_idx, record$captured)
      } else {
        private$grid_set(to_idx, NULL)
      }

      if (isTRUE(record$logged) && length(private$history) > 0L)
        private$history <- private$history[-length(private$history)]

      invisible(self)
    },

    #' @description The \code{\link{Square}} a side's king stands on.
    #' @param colour \code{"white"} or \code{"black"}.
    #' @return A \code{\link{Square}}, or \code{NULL} if there is no king.
    find_king = function(colour) {
      for (p in private$pieces) {
        if (p$type == "K" && p$colour == colour && !is.null(p$position))
          return(p$position)
      }
      NULL
    },

    #' @description Can a side capture whatever stands on this square?
    #'
    #' Rather than generating every enemy move (slow), this looks OUTWARD from
    #' the square: enemy pawns on the attacking diagonals, a knight a jump
    #' away, an adjacent king, and — walking each ray — whether the first piece
    #' met is a bishop/queen (diagonals) or rook/queen (ranks and files).
    #'
    #' It is the most-called function on the R side, because legal-move
    #' generation needs it once per candidate move.
    #'
    #' @param square The \code{\link{Square}} to test.
    #' @param by_colour The attacking side.
    is_square_attacked = function(square, by_colour) {

      r  <- square$rank
      cc <- match(square$file, letters[1:8])

      at <- function(rr, ff) {
        if (rr < 1L || rr > 8L || ff < 1L || ff > 8L) return(NULL)
        private$grid[[(rr - 1L) * 8L + ff]]
      }
      is_enemy <- function(p, type) {
        !is.null(p) && p$colour == by_colour && p$type == type
      }

      # pawns: a white pawn one rank below attacks upward, black one above
      pr <- if (by_colour == "white") r - 1L else r + 1L
      for (df in c(-1L, 1L)) if (is_enemy(at(pr, cc + df), "P")) return(TRUE)

      # knights
      for (o in list(c(2,1), c(2,-1), c(-2,1), c(-2,-1),
                     c(1,2), c(1,-2), c(-1,2), c(-1,-2))) {
        if (is_enemy(at(r + o[1], cc + o[2]), "N")) return(TRUE)
      }

      # enemy king adjacent
      for (dr in -1:1) for (df in -1:1) {
        if (dr == 0 && df == 0) next
        if (is_enemy(at(r + dr, cc + df), "K")) return(TRUE)
      }

      # sliding attackers: first piece met along each ray
      rays <- list(
        list(dirs = list(c(1,1), c(1,-1), c(-1,1), c(-1,-1)), types = c("B","Q")),
        list(dirs = list(c(1,0), c(-1,0), c(0,1), c(0,-1)),   types = c("R","Q"))
      )

      for (ray in rays) {
        for (d in ray$dirs) {
          rr <- r + d[1]; ff <- cc + d[2]
          while (rr >= 1L && rr <= 8L && ff >= 1L && ff <= 8L) {
            occupant <- private$grid[[(rr - 1L) * 8L + ff]]
            if (!is.null(occupant)) {
              if (occupant$colour == by_colour && occupant$type %in% ray$types)
                return(TRUE)
              break        # any other piece blocks the ray
            }
            rr <- rr + d[1]; ff <- ff + d[2]
          }
        }
      }

      FALSE
    },

    #' @description Is this side's king currently under attack?
    #' @param colour \code{"white"} or \code{"black"}.
    is_in_check = function(colour) {
      king_sq <- self$find_king(colour)
      if (is.null(king_sq)) return(FALSE)
      self$is_square_attacked(king_sq,
                              if (colour == "white") "black" else "white")
    },

    #' @description All pieces still on the board.
    #' @param colour Optional filter: \code{"white"}, \code{"black"} or
    #'   \code{NULL} for both.
    get_all_pieces = function(colour = NULL) {
      alive <- Filter(function(p) !is.null(p$position), private$pieces)
      if (!is.null(colour)) {
        stopifnot("colour must be white/black" = colour %in% c("white","black"))
        alive <- Filter(function(p) p$colour == colour, alive)
      }
      alive
    },

    #' @description Moves played so far, in algebraic notation.
    get_history = function() private$history,

    # =========================================================================
    #  MOVE GENERATION
    #  Which moves a piece may make is a property of the BOARD (movement rules
    #  plus what currently blocks what), so it lives here rather than in Game.
    #  Keeping it here also lets any Player reason about a position from the
    #  board alone — GreedyPlayer uses it to notice checkmate.
    # =========================================================================

    #' @description All pseudo-legal moves for a colour.
    #'
    #' "Pseudo-legal" means the moves obey each piece's movement rules but may
    #' still leave the mover's own king in check. Use \code{$legal_moves()}
    #' unless you specifically want the unfiltered list.
    #'
    #' @param colour \code{"white"} or \code{"black"}.
    #' @return A list of \code{list(from = Square, to = Square)}.
    pseudo_moves = function(colour) {

      moves <- list()

      for (piece in self$get_all_pieces(colour)) {

        f <- match(piece$position$file, letters[1:8])
        r <- piece$position$rank

        # helper: build a move if the target square is on the board
        mk <- function(rank, file_idx) {
          if (rank < 1L || rank > 8L || file_idx < 1L || file_idx > 8L)
            return(NULL)
          list(from = piece$position, to = Square$new(letters[file_idx], rank))
        }

        # helper: walk outwards until blocked (bishop, rook, queen)
        slide <- function(dirs) {
          out <- list()
          for (d in dirs) {
            rr <- r + d[1]; ff <- f + d[2]
            while (rr >= 1L && rr <= 8L && ff >= 1L && ff <= 8L) {
              to <- Square$new(letters[ff], rr)
              occupant <- private$grid[[(rr - 1L) * 8L + ff]]
              if (is.null(occupant)) {
                out <- c(out, list(list(from = piece$position, to = to)))
              } else {
                if (occupant$colour != piece$colour)             # capture
                  out <- c(out, list(list(from = piece$position, to = to)))
                break                                            # then stop
              }
              rr <- rr + d[1]; ff <- ff + d[2]
            }
          }
          out
        }

        type <- piece$type

        if (type == "P") {
          dir <- if (piece$colour == "white") 1L else -1L

          one <- mk(r + dir, f)
          if (!is.null(one) && is.null(self$get_piece_at(one$to))) {
            moves <- c(moves, list(one))

            start_rank <- if (piece$colour == "white") 2L else 7L
            two <- mk(r + 2L * dir, f)
            if (r == start_rank && !is.null(two) &&
                is.null(self$get_piece_at(two$to))) {
              moves <- c(moves, list(two))
            }
          }

          for (df in c(-1L, 1L)) {
            cap <- mk(r + dir, f + df)
            if (is.null(cap)) next
            occupant <- self$get_piece_at(cap$to)
            if (!is.null(occupant) && occupant$colour != piece$colour)
              moves <- c(moves, list(cap))
          }

        } else if (type == "N") {
          for (o in list(c(2,1), c(2,-1), c(-2,1), c(-2,-1),
                         c(1,2), c(1,-2), c(-1,2), c(-1,-2))) {
            mv <- mk(r + o[1], f + o[2])
            if (is.null(mv)) next
            occupant <- self$get_piece_at(mv$to)
            if (is.null(occupant) || occupant$colour != piece$colour)
              moves <- c(moves, list(mv))
          }

        } else if (type == "K") {
          for (dr in -1:1) for (df in -1:1) {
            if (dr == 0 && df == 0) next
            mv <- mk(r + dr, f + df)
            if (is.null(mv)) next
            occupant <- self$get_piece_at(mv$to)
            if (is.null(occupant) || occupant$colour != piece$colour)
              moves <- c(moves, list(mv))
          }

        } else if (type == "B") {
          moves <- c(moves, slide(list(c(1,1), c(1,-1), c(-1,1), c(-1,-1))))
        } else if (type == "R") {
          moves <- c(moves, slide(list(c(1,0), c(-1,0), c(0,1), c(0,-1))))
        } else if (type == "Q") {
          moves <- c(moves, slide(list(c(1,0), c(-1,0), c(0,1), c(0,-1),
                                       c(1,1), c(1,-1), c(-1,1), c(-1,-1))))
        }
      }

      moves
    },

    #' @description All LEGAL moves for a colour.
    #'
    #' Takes the pseudo-legal moves and keeps only those that do not leave the
    #' mover's own king in check. The test is done honestly: play the move,
    #' look at the king, take the move back — which is exactly what
    #' \code{$apply_move()} / \code{$undo_move()} exist for.
    #'
    #' This filter is what makes the simulation real chess. Without it kings
    #' can be left under attack, get captured, and games end nonsensically.
    #'
    #' @param colour \code{"white"} or \code{"black"}.
    #' @return A list of \code{list(from = Square, to = Square)}.
    legal_moves = function(colour) {

      pseudo <- self$pseudo_moves(colour)
      legal  <- vector("list", length(pseudo))
      n      <- 0L

      for (mv in pseudo) {
        rec <- self$apply_move(mv$from, mv$to, log = FALSE)
        ok  <- !self$is_in_check(colour)
        self$undo_move(rec)
        if (ok) { n <- n + 1L; legal[[n]] <- mv }
      }

      if (n == 0L) list() else legal[seq_len(n)]
    },

    #' @description Does this side have at least one legal move?
    #'
    #' Cheaper than \code{$legal_moves()} when you only need to know whether
    #' the game can continue, because it stops at the first legal move found.
    #'
    #' @param colour \code{"white"} or \code{"black"}.
    has_legal_move = function(colour) {
      for (mv in self$pseudo_moves(colour)) {
        rec <- self$apply_move(mv$from, mv$to, log = FALSE)
        ok  <- !self$is_in_check(colour)
        self$undo_move(rec)
        if (ok) return(TRUE)
      }
      FALSE
    },

    #' @description 8x8 character matrix: uppercase white, lowercase black,
    #'   \code{"."} empty.
    #'
    #' Rows are named 8 down to 1, so row 1 is rank 8 and the board reads with
    #' black at the top. Pieces are placed by row NAME, so a piece on rank 1
    #' lands in the row named "1" — the bottom one.
    to_matrix = function() {
      mat <- matrix(".", nrow = 8, ncol = 8,
                    dimnames = list(as.character(8:1), letters[1:8]))
      for (p in self$get_all_pieces()) {
        mat[as.character(p$position$rank), p$position$file] <-
          if (p$colour == "white") p$type else tolower(p$type)
      }
      mat
    },

    #' @description 8x8 integer matrix for the C++ engine.
    #'
    #' Row 1 is rank 1 and column 1 is file a. White pieces are positive, black
    #' negative, empty zero, using the unique per-type codes from
    #' \code{Piece$type_code()} (P 1, N 2, B 3, R 4, Q 5, K 6).
    #'
    #' This method lives on Board, not on MinimaxPlayer: encoding the board for
    #' the engine is the board's own business.
    encode_for_engine = function() {
      mat <- matrix(0L, nrow = 8, ncol = 8)
      for (p in self$get_all_pieces()) {
        f <- match(p$position$file, letters[1:8])
        v <- p$type_code()
        mat[p$position$rank, f] <- if (p$colour == "white") v else -v
      }
      mat
    },

    #' @description Print a readable text board to the console.
    display = function() {
      mat <- self$to_matrix()
      cat("\n")
      for (i in 1:8) cat(9L - i, " ", paste(mat[i, ], collapse = " "), "\n")
      cat("   a b c d e f g h\n\n")
      invisible(self)
    },

    #' @description Material advantage for white (positive means white leads).
    material_balance = function() {
      bal <- 0
      for (p in self$get_all_pieces()) {
        if (p$type == "K") next
        bal <- bal + if (p$colour == "white") p$value() else -p$value()
      }
      bal
    },

    #' @description Print method.
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
#' Defines the interface every player must implement:
#' \code{$choose_move(board, legal_moves)}. Calling it on the base class is an
#' error — use \code{\link{RandomPlayer}}, \code{\link{GreedyPlayer}} or
#' \code{\link{MinimaxPlayer}}.
#'
#' This is the polymorphism mechanism from lecture 04: \code{\link{Game}} calls
#' one method name and gets three completely different strategies.
#'
#' @export
Player <- R6::R6Class("Player",

  private = list(
    wins   = 0L,
    losses = 0L,
    draws  = 0L
  ),

  public = list(

    #' @field name Character, the player's display name.
    name = NULL,

    #' @field colour Character, \code{"white"} or \code{"black"}.
    colour = NULL,

    #' @description Construct a Player.
    #' @param name Character display name.
    #' @param colour \code{"white"} or \code{"black"}.
    initialize = function(name, colour) {
      stopifnot(
        "name must be a non-empty string" =
          is.character(name) && length(name) == 1L && nchar(name) > 0L,
        "colour must be white/black" = colour %in% c("white","black")
      )
      self$name   <- name
      self$colour <- colour
      invisible(self)
    },

    #' @description Abstract method. Child classes must override it.
    #' @param board The current \code{\link{Board}}.
    #' @param legal_moves List of legal moves.
    choose_move = function(board, legal_moves) {
      stop("Player$choose_move() is abstract. Use RandomPlayer, GreedyPlayer or MinimaxPlayer.")
    },

    #' @description Record a win.
    record_win  = function() { private$wins   <- private$wins   + 1L; invisible(self) },
    #' @description Record a loss.
    record_loss = function() { private$losses <- private$losses + 1L; invisible(self) },
    #' @description Record a draw.
    record_draw = function() { private$draws  <- private$draws  + 1L; invisible(self) },

    #' @description Wins, losses and draws as a named vector.
    stats = function() {
      c(wins = private$wins, losses = private$losses, draws = private$draws)
    },

    #' @description Short label describing the strategy, overridden by children.
    strategy = function() "abstract",

    #' @description Print method.
    #' @param ... Ignored.
    print = function(...) {
      s <- self$stats()
      cat(class(self)[1], ": ", self$name, " (", self$colour,
          ") - strategy: ", self$strategy(), "\n", sep = "")
      cat("  W:", s["wins"], " L:", s["losses"], " D:", s["draws"], "\n")
      invisible(self)
    }
  )
)


#' RandomPlayer: plays a random legal move
#'
#' The weakest strategy, and the baseline everything else is measured against.
#'
#' @examples
#' RandomPlayer$new("Rand", "white")
#'
#' @export
RandomPlayer <- R6::R6Class("RandomPlayer",

  inherit = Player,

  public = list(

    #' @description Construct. Delegates to the parent constructor.
    #' @param name Character display name.
    #' @param colour \code{"white"} or \code{"black"}.
    initialize = function(name, colour) {
      super$initialize(name, colour)     # like NextMethod() in S3
      invisible(self)
    },

    #' @description Pick a uniformly random legal move.
    #' @param board The current \code{\link{Board}} (unused, but part of the
    #'   shared interface so every player type is interchangeable).
    #' @param legal_moves List of legal moves.
    choose_move = function(board, legal_moves) {
      if (length(legal_moves) == 0L) stop("No legal moves available.")
      legal_moves[[sample.int(length(legal_moves), 1L)]]
    },

    #' @description Strategy label.
    strategy = function() "random"
  )
)


#' GreedyPlayer: takes the most material it can right now
#'
#' Looks one ply ahead in pure R: it plays each legal move on the board, reads
#' the material balance, takes the move back, and keeps the best. No C++ and no
#' search tree — which makes it a useful middle difficulty and a clean
#' demonstration that the same interface can be implemented without Rcpp.
#'
#' It beats \code{\link{RandomPlayer}} comfortably but loses to
#' \code{\link{MinimaxPlayer}}, because it never asks what the opponent will do
#' in reply.
#'
#' @examples
#' GreedyPlayer$new("Greedy", "white")
#'
#' @export
GreedyPlayer <- R6::R6Class("GreedyPlayer",

  inherit = Player,

  public = list(

    #' @description Construct.
    #' @param name Character display name.
    #' @param colour \code{"white"} or \code{"black"}.
    initialize = function(name, colour) {
      super$initialize(name, colour)
      invisible(self)
    },

    #' @description Choose the move that wins the most material right now.
    #'
    #' Material alone is not quite enough: a player who only counts material
    #' will happily win every piece and then shuffle forever, because
    #' delivering checkmate does not change the material count. So the score
    #' also rewards giving check, and treats checkmate as decisive.
    #'
    #' @param board The current \code{\link{Board}}.
    #' @param legal_moves List of legal moves.
    choose_move = function(board, legal_moves) {

      if (length(legal_moves) == 0L) stop("No legal moves available.")

      sign     <- if (self$colour == "white") 1 else -1
      opponent <- if (self$colour == "white") "black" else "white"
      scores   <- numeric(length(legal_moves))

      for (i in seq_along(legal_moves)) {
        mv <- legal_moves[[i]]

        # make / unmake: play it, look, take it back. log = FALSE keeps these
        # trial moves out of the real game history.
        rec <- board$apply_move(mv$from, mv$to, log = FALSE)

        score <- sign * board$material_balance()

        if (board$is_in_check(opponent)) {
          # Only now is it worth the cost of asking whether they can reply.
          if (board$has_legal_move(opponent)) score <- score + 0.5   # check
          else                                score <- score + 1000  # mate
        }

        scores[i] <- score
        board$undo_move(rec)
      }

      best <- which(scores == max(scores))          # often several
      legal_moves[[best[sample.int(length(best), 1L)]]]
    },

    #' @description Strategy label.
    strategy = function() "greedy (1 ply, pure R)"
  )
)


#' MinimaxPlayer: asks the C++ engine for the best move
#'
#' Encodes the board, calls \code{\link{chess_minimax}}, and converts the answer
#' back into \code{\link{Square}} objects. The engine searches with alpha-beta
#' pruning and understands checkmate, so this player actually plays chess.
#'
#' The call is wrapped in \code{tryCatch()}: if the compiled engine is
#' unavailable or errors, the player falls back to a random legal move instead
#' of bringing the whole game down. The returned move is also checked against
#' the legal move list before it is used.
#'
#' @examples
#' MinimaxPlayer$new("Deep", "black", depth = 3)
#'
#' @export
MinimaxPlayer <- R6::R6Class("MinimaxPlayer",

  inherit = Player,

  public = list(

    #' @field depth Integer search depth in plies.
    depth = NULL,

    #' @description Construct a MinimaxPlayer.
    #' @param name Character display name.
    #' @param colour \code{"white"} or \code{"black"}.
    #' @param depth Positive integer search depth. 2 is fast, 3 is the default,
    #'   4 is stronger and still quick.
    initialize = function(name, colour, depth = 3L) {
      super$initialize(name, colour)
      stopifnot(
        "depth must be a positive integer" =
          is.numeric(depth) && length(depth) == 1L && depth >= 1L
      )
      self$depth <- as.integer(depth)
      invisible(self)
    },

    #' @description Choose the best move using the C++ search.
    #' @param board The current \code{\link{Board}}.
    #' @param legal_moves List of legal moves.
    choose_move = function(board, legal_moves) {

      if (length(legal_moves) == 0L) stop("No legal moves available.")

      colour_int <- if (self$colour == "white") 1L else -1L

      # tryCatch (lecture 06): a broken engine degrades to a random move
      # rather than crashing the game or the dashboard.
      idx <- tryCatch(
        chess_minimax(board$encode_for_engine(), colour_int, self$depth),
        error = function(e) {
          warning("Minimax engine error: ", conditionMessage(e),
                  " - falling back to a random move.")
          NULL
        }
      )

      if (!is.null(idx) && length(idx) == 2L && all(idx > 0L)) {

        from_sq <- index_to_square(idx[1])
        to_sq   <- index_to_square(idx[2])

        # Safety net: only trust the engine's answer if it really is one of the
        # moves R considers legal. R and C++ implement the same rules, so this
        # always matches; if it ever did not, we would rather play a legal move.
        for (mv in legal_moves) {
          if (mv$from$to_string() == from_sq$to_string() &&
              mv$to$to_string()   == to_sq$to_string()) {
            return(mv)
          }
        }
        warning("Engine returned a move R does not consider legal - using random.")
      }

      legal_moves[[sample.int(length(legal_moves), 1L)]]
    },

    #' @description Strategy label.
    strategy = function() paste0("minimax depth ", self$depth, " (C++)")
  )
)
