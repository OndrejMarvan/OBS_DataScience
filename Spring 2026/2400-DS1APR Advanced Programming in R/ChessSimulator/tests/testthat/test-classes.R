# =============================================================================
#  Tests for the R6 classes and the chess rules they implement
# =============================================================================

test_that("Square validates input and converts correctly", {

  s <- Square$new("e", 4)

  expect_equal(s$file, "e")
  expect_equal(s$rank, 4L)
  expect_equal(s$to_string(), "e4")
  expect_equal(s$to_index(), 29L)

  expect_equal(Square$new("a", 1)$to_index(), 1L)
  expect_equal(Square$new("h", 8)$to_index(), 64L)

  # index_to_square is the exact inverse
  for (i in c(1L, 13L, 29L, 47L, 64L)) {
    expect_equal(index_to_square(i)$to_index(), i)
  }

  expect_error(Square$new("z", 4), "file must be a-h")
  expect_error(Square$new("a", 9), "rank must be between 1 and 8")
})


test_that("square colours follow the board convention", {
  # "White on the right": h1 is light, a1 is dark.
  expect_true(Square$new("h", 1)$is_light_square())
  expect_false(Square$new("a", 1)$is_light_square())
  expect_true(Square$new("e", 4)$is_light_square())
})


test_that("Piece tracks state and reports unique engine codes", {

  p <- Piece$new("Q", "white", Square$new("d", 1))

  expect_equal(p$value(), 9)
  expect_equal(p$type_code(), 5L)
  expect_false(p$has_moved_yet())

  p$move_to(Square$new("d", 4))
  expect_true(p$has_moved_yet())
  expect_equal(p$position$to_string(), "d4")

  p$capture()
  expect_null(p$position)

  # Every piece type must have its OWN engine code. Knight and bishop sharing
  # a code is exactly the bug that made the old engine generate illegal moves.
  codes <- vapply(c("P","N","B","R","Q","K"), function(t)
    Piece$new(t, "white", Square$new("a", 1))$type_code(), integer(1L))
  expect_equal(length(unique(codes)), 6L)
})


test_that("Board starts in the standard position", {

  b <- Board$new()

  expect_equal(length(b$get_all_pieces()), 32L)
  expect_equal(length(b$get_all_pieces("white")), 16L)
  expect_equal(length(b$get_all_pieces("black")), 16L)
  expect_equal(b$material_balance(), 0)

  wk <- b$get_piece_at(Square$new("e", 1))
  expect_equal(wk$type, "K")
  expect_equal(wk$colour, "white")
  expect_equal(b$get_piece_at(Square$new("e", 8))$colour, "black")

  # Board reads with black on top, white at the bottom
  mat <- b$to_matrix()
  expect_equal(unname(mat["8", "a"]), "r")   # black rook, lowercase
  expect_equal(unname(mat["1", "a"]), "R")   # white rook, uppercase
})


test_that("encode_for_engine uses signed unique codes", {

  mat <- Board$new()$encode_for_engine()

  expect_equal(dim(mat), c(8L, 8L))
  expect_equal(mat[1, 5],  6L)    # white king on e1
  expect_equal(mat[8, 5], -6L)    # black king on e8
  expect_equal(mat[1, 2],  2L)    # white knight on b1
  expect_equal(mat[1, 3],  3L)    # white bishop on c1
  expect_equal(mat[4, 4],  0L)    # empty centre
})


test_that("apply_move and undo_move restore the position exactly", {

  b      <- Board$new()
  before <- b$to_matrix()

  rec <- b$apply_move(Square$new("e", 2), Square$new("e", 4), log = FALSE)
  expect_false(identical(before, b$to_matrix()))

  b$undo_move(rec)
  expect_identical(before, b$to_matrix())
  expect_equal(b$material_balance(), 0)
})


test_that("legal move generation matches known chess counts", {

  b <- Board$new()

  # From the starting position each side has exactly 20 legal moves:
  # 16 pawn moves and 4 knight moves.
  expect_equal(length(b$legal_moves("white")), 20L)
  expect_equal(length(b$legal_moves("black")), 20L)

  expect_true(b$has_legal_move("white"))
  expect_false(b$is_in_check("white"))
})


test_that("Fool's mate is detected as checkmate", {

  # The fastest mate in chess: 1. f3 e6 2. g4 Qh4#
  b <- Board$new()
  b$apply_move(Square$new("f", 2), Square$new("f", 3), log = FALSE)
  b$apply_move(Square$new("e", 7), Square$new("e", 6), log = FALSE)
  b$apply_move(Square$new("g", 2), Square$new("g", 4), log = FALSE)
  b$apply_move(Square$new("d", 8), Square$new("h", 4), log = FALSE)

  expect_true(b$is_in_check("white"))
  expect_equal(length(b$legal_moves("white")), 0L)
  expect_false(b$has_legal_move("white"))
})


test_that("a king may not be left in check", {

  # 1. e4 d5 2. Bb5+ — a genuine check that is NOT mate.
  b <- Board$new()
  b$apply_move(Square$new("e", 2), Square$new("e", 4), log = FALSE)
  b$apply_move(Square$new("d", 7), Square$new("d", 5), log = FALSE)
  b$apply_move(Square$new("f", 1), Square$new("b", 5), log = FALSE)

  expect_true(b$is_in_check("black"))

  moves <- b$legal_moves("black")
  expect_gt(length(moves), 0L)          # black can answer: it is not mate

  # Every generated move must genuinely get black out of check — that is what
  # separates legal moves from merely pseudo-legal ones.
  for (mv in moves) {
    rec <- b$apply_move(mv$from, mv$to, log = FALSE)
    still_in_check <- b$is_in_check("black")
    b$undo_move(rec)
    expect_false(still_in_check)
  }
})


test_that("players implement the shared interface", {

  b <- Board$new()
  m <- b$legal_moves("white")

  # The abstract base class refuses to choose
  expect_error(Player$new("X", "white")$choose_move(b, m), "abstract")

  for (p in list(RandomPlayer$new("R", "white"),
                 GreedyPlayer$new("G", "white"))) {
    mv <- p$choose_move(b, m)
    expect_true(inherits(mv$from, "Square"))
    expect_true(inherits(mv$to,   "Square"))
  }

  p <- RandomPlayer$new("R", "white")
  expect_equal(unname(p$stats()["wins"]), 0L)
  p$record_win()
  expect_equal(unname(p$stats()["wins"]), 1L)
})


test_that("make_player builds the right classes", {

  expect_s3_class(make_player("random",  "A", "white"), "RandomPlayer")
  expect_s3_class(make_player("greedy",  "B", "white"), "GreedyPlayer")

  p <- make_player("minimax", "C", "black", depth = 2)
  expect_s3_class(p, "MinimaxPlayer")
  expect_equal(p$depth, 2L)

  expect_error(make_player("random", "", "white"), "non-empty")
})


test_that("a game runs to a real conclusion", {

  set.seed(123)
  g <- Game$new(RandomPlayer$new("A", "white"),
                RandomPlayer$new("B", "black"), max_moves = 120L)
  g$play()

  expect_true(g$get_status() %in% c("white_wins", "black_wins", "draw"))
  expect_gt(nrow(g$get_move_log()), 0L)

  # Both kings must still be on the board: a legal game never captures a king.
  b <- g$get_board()
  expect_false(is.null(b$find_king("white")))
  expect_false(is.null(b$find_king("black")))
})


test_that("tournament produces a consistent leaderboard", {

  set.seed(99)
  t <- Tournament$new(list(RandomPlayer$new("A", "white"),
                           RandomPlayer$new("B", "white")), rounds = 1L)
  t$run(progress = FALSE)

  lb <- t$leaderboard()
  expect_equal(nrow(lb), 2L)
  expect_equal(sum(lb$played), 4L)                  # 2 players, 2 games each
  expect_true(all(lb$wins + lb$draws + lb$losses == lb$played))
  expect_equal(lb$points, sort(lb$points, decreasing = TRUE))
})
