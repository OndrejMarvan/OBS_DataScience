library(testthat)
library(ChessSimulator)

test_that("Square construction and methods", {

  s <- Square$new("e", 4)

  expect_equal(s$file, "e")
  expect_equal(s$rank, 4L)
  expect_equal(s$to_string(), "e4")
  expect_equal(s$to_index(), 29L)
  expect_true(s$is_light_square())

  # Invalid inputs should error
  expect_error(Square$new("z", 4), "file must be a-h")
  expect_error(Square$new("a", 9), "rank must be between 1 and 8")
})


test_that("Piece construction and mutation", {

  p <- Piece$new("Q", "white", Square$new("d", 1))

  expect_equal(p$type, "Q")
  expect_equal(p$colour, "white")
  expect_false(p$has_moved_yet())
  expect_equal(p$value(), 9)

  p$move_to(Square$new("d", 4))
  expect_true(p$has_moved_yet())
  expect_equal(p$position$to_string(), "d4")

  p$capture()
  expect_null(p$position)
})


test_that("Board starts in standard position with 32 pieces", {

  b <- Board$new()

  pieces <- b$get_all_pieces()
  expect_equal(length(pieces), 32L)
  expect_equal(length(b$get_all_pieces("white")), 16L)
  expect_equal(length(b$get_all_pieces("black")), 16L)
  expect_equal(b$material_balance(), 0)

  # White king starts on e1
  e1_piece <- b$get_piece_at(Square$new("e", 1))
  expect_equal(e1_piece$type, "K")
  expect_equal(e1_piece$colour, "white")
})


test_that("Board encoding matches engine format", {

  b   <- Board$new()
  mat <- b$encode_for_engine()

  expect_equal(dim(mat), c(8, 8))
  # White king on e1 (row 1, col 5) = 100
  expect_equal(mat[1, 5], 100L)
  # Black king on e8 (row 8, col 5) = -100
  expect_equal(mat[8, 5], -100L)
  # Centre is empty
  expect_equal(mat[4, 4], 0L)
})


test_that("RandomPlayer picks a legal move", {

  p1 <- RandomPlayer$new("A", "white")
  p2 <- RandomPlayer$new("B", "black")
  g  <- Game$new(p1, p2)

  moves <- g$generate_moves("white")
  expect_gt(length(moves), 0)

  chosen <- p1$choose_move(g$get_board(), moves)
  expect_true(inherits(chosen$from, "Square"))
  expect_true(inherits(chosen$to,   "Square"))
})


test_that("Game can play to completion", {

  p1 <- RandomPlayer$new("A", "white")
  p2 <- RandomPlayer$new("B", "black")
  g  <- Game$new(p1, p2, max_moves = 50L)

  g$play(verbose = FALSE)

  expect_true(g$get_status() %in%
                c("white_wins", "black_wins", "draw"))
  expect_gt(nrow(g$get_move_log()), 0)
})


test_that("make_player factory works", {

  p1 <- make_player("random", "Bot", "white")
  expect_true(inherits(p1, "RandomPlayer"))

  p2 <- make_player("minimax", "Bot", "black", depth = 2)
  expect_true(inherits(p2, "MinimaxPlayer"))
  expect_equal(p2$depth, 2L)

  expect_error(make_player("random", "", "white"),
               "non-empty")
})
