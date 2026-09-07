# =============================================================================
#  Tests for the compiled C++ engine
# =============================================================================

# Helper: place a piece by algebraic square on an engine matrix.
# The matrix is mat[rank, file], NOT R's column-major linear index.
put <- function(mat, square, code) {
  s <- Square$new(substr(square, 1, 1), as.integer(substr(square, 2, 2)))
  mat[s$rank, match(s$file, letters[1:8])] <- as.integer(code)
  mat
}


test_that("evaluation is symmetric at the start", {
  expect_equal(chess_evaluate(Board$new()$encode_for_engine()), 0)
})


test_that("perft matches the known move counts", {

  # These numbers are the standard correctness test for any chess move
  # generator. If it produces even one illegal move, or misses one legal
  # move, the counts break immediately.
  mat <- Board$new()$encode_for_engine()

  expect_equal(chess_perft(mat, 1L, 1L), 20)
  expect_equal(chess_perft(mat, 1L, 2L), 400)
  expect_equal(chess_perft(mat, 1L, 3L), 8902)
})


test_that("C++ and R agree on the legal moves", {

  # The two move generators are written independently — one in R for the game
  # loop, one in C++ for the search. They must always return the same set,
  # otherwise the engine could suggest a move the game refuses to play.
  set.seed(4)
  g <- Game$new(RandomPlayer$new("A", "white"),
                RandomPlayer$new("B", "black"), max_moves = 40L)
  board <- g$get_board()

  for (i in 1:20) {
    colour <- g$get_turn()

    r_moves <- sort(vapply(g$generate_moves(colour), function(m)
      paste0(m$from$to_string(), m$to$to_string()), character(1L)))

    cm <- chess_legal_moves(board$encode_for_engine(),
                            if (colour == "white") 1L else -1L)
    c_moves <- if (nrow(cm) == 0L) character(0L) else
      sort(apply(cm, 1L, function(r)
        paste0(index_to_square(r[1])$to_string(),
               index_to_square(r[2])$to_string())))

    expect_identical(r_moves, c_moves)
    if (!g$play_one_turn()) break
  }
})


test_that("the engine takes a free piece", {

  mat <- matrix(0L, 8L, 8L)
  mat <- put(mat, "e1",  6)    # white king
  mat <- put(mat, "e8", -6)    # black king
  mat <- put(mat, "a1",  4)    # white rook
  mat <- put(mat, "a7", -5)    # black queen, hanging

  mv <- chess_minimax(mat, 1L, 3L)
  expect_equal(index_to_square(mv[1])$to_string(), "a1")   # the rook
  expect_equal(index_to_square(mv[2])$to_string(), "a7")   # takes the queen
})


test_that("the engine finds mate in one", {

  mat <- matrix(0L, 8L, 8L)
  mat <- put(mat, "a1",  6)    # white king
  mat <- put(mat, "h8", -6)    # black king, boxed in on the back rank
  mat <- put(mat, "b1",  4)    # white rook
  mat <- put(mat, "c7",  4)    # white rook: Rc8 delivers mate

  mv <- chess_minimax(mat, 1L, 3L)

  # Play the engine's move on a copy, then confirm black is mated.
  from <- index_to_square(mv[1]); to <- index_to_square(mv[2])
  mat2 <- mat
  mat2[to$rank,   match(to$file,   letters[1:8])] <-
    mat2[from$rank, match(from$file, letters[1:8])]
  mat2[from$rank, match(from$file, letters[1:8])] <- 0L

  expect_equal(nrow(chess_legal_moves(mat2, -1L)), 0L)
})


test_that("minimax beats random convincingly", {

  # The whole point of the engine: it must actually be good at chess.
  # A depth-2 search should beat a random mover essentially every time.
  set.seed(11)
  wins <- 0L
  for (i in 1:4) {
    g <- Game$new(MinimaxPlayer$new("M", "white", depth = 2L),
                  RandomPlayer$new("R", "black"), max_moves = 160L)
    g$play()
    if (g$get_status() == "white_wins") wins <- wins + 1L
  }
  expect_gte(wins, 3L)
})
