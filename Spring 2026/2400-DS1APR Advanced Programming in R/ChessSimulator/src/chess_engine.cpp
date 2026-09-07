// =============================================================================
//  ChessSimulator — RCPP BINDINGS
//  File: src/chess_engine.cpp
// =============================================================================
//
//  This file is deliberately SHORT. All the chess logic lives in chess_core.h
//  as plain C++ (so it can be unit-tested without R). Here we only:
//    1. convert R's 8x8 matrix into the flat 64-int array the core uses,
//    2. call the core,
//    3. convert results back into R objects.
//
//  Four functions are exported to R:
//    chess_evaluate()    — static score of a position
//    chess_legal_moves() — all legal moves for one side
//    chess_minimax()     — best move from alpha-beta search
//    chess_perft()       — move generator self-test
//
//  BOARD MATRIX FROM R
//  Board$encode_for_engine() gives an 8x8 integer matrix where
//    row 1 = rank 1 ... row 8 = rank 8,  col 1 = file a ... col 8 = file h
//    white positive, black negative, empty 0
//    codes: 1 pawn, 2 knight, 3 bishop, 4 rook, 5 queen, 6 king
//
//  R is 1-based; the core is 0-based with index row*8+col.
//  board_from_matrix() is the single place that conversion happens.
// =============================================================================

#include <Rcpp.h>
#include "chess_core.h"

using namespace Rcpp;
using namespace chess;

// -----------------------------------------------------------------------------
//  Random source for tie-breaking. Rcpp's generated wrappers open an RNGScope,
//  so R's own random stream is used — meaning set.seed() in R makes engine
//  games reproducible.
// -----------------------------------------------------------------------------
static double r_unif() { return ::unif_rand(); }

// Convert the R matrix into the core's flat array.
static void board_from_matrix(const IntegerMatrix& m, int b[64]) {
  if (m.nrow() != 8 || m.ncol() != 8)
    stop("board matrix must be 8x8");

  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      b[r * 8 + c] = m(r, c);
}

//' Static evaluation of a chess position (C++)
//'
//' Scores a position in centipawns from white's point of view: positive means
//' white stands better, negative means black. Combines material (pawn 100,
//' knight 320, bishop 330, rook 500, queen 900) with piece-square table
//' bonuses that reward good placement.
//'
//' @param board_matrix An 8x8 integer matrix from
//'   \code{Board$encode_for_engine()}.
//' @return A single numeric value in centipawns.
//' @export
// [[Rcpp::export]]
double chess_evaluate(IntegerMatrix board_matrix) {
  int b[64];
  board_from_matrix(board_matrix, b);
  return (double) evaluate(b);
}

//' All legal moves for one side (C++)
//'
//' Generates every legal move: moves that follow the movement rules
//' \emph{and} do not leave the mover's own king in check.
//'
//' @param board_matrix An 8x8 integer matrix from
//'   \code{Board$encode_for_engine()}.
//' @param is_white_int \code{1} for white to move, \code{-1} for black.
//' @return An N x 2 integer matrix; each row is \code{c(from, to)} with
//'   1-based square indices (a1 = 1, h8 = 64). Zero rows means the side to
//'   move is checkmated or stalemated.
//' @export
// [[Rcpp::export]]
IntegerMatrix chess_legal_moves(IntegerMatrix board_matrix, int is_white_int) {

  int b[64];
  board_from_matrix(board_matrix, b);

  std::vector<Move> moves;
  gen_legal(b, is_white_int == 1, moves);

  IntegerMatrix out((int) moves.size(), 2);
  for (size_t i = 0; i < moves.size(); i++) {
    out((int) i, 0) = moves[i].from + 1;   // back to R's 1-based indexing
    out((int) i, 1) = moves[i].to   + 1;
  }
  return out;
}

//' Best move by minimax search with alpha-beta pruning (C++)
//'
//' Searches the game tree to the requested depth and returns the best move for
//' the side to move. Uses alpha-beta pruning with MVV-LVA move ordering, and
//' scores checkmate so that faster mates are preferred.
//'
//' Ties between equally good moves are broken with R's random number stream,
//' so \code{set.seed()} makes engine games reproducible.
//'
//' @param board_matrix An 8x8 integer matrix from
//'   \code{Board$encode_for_engine()}.
//' @param is_white_int \code{1} for white to move, \code{-1} for black.
//' @param depth Search depth in plies. 2 is fast and tactical, 3 is a good
//'   default, 4 is noticeably stronger and still quick.
//' @return An integer vector \code{c(from, to)} with 1-based square indices,
//'   or \code{c(0, 0)} when there are no legal moves.
//' @export
// [[Rcpp::export]]
IntegerVector chess_minimax(IntegerMatrix board_matrix,
                            int is_white_int,
                            int depth) {

  if (depth < 1) stop("depth must be at least 1");

  int b[64];
  board_from_matrix(board_matrix, b);

  Move m;
  const bool found = best_move(b, is_white_int == 1, depth, m, &r_unif);

  if (!found) return IntegerVector::create(0, 0);
  return IntegerVector::create(m.from + 1, m.to + 1);
}

//' Move generator self-test (perft)
//'
//' Counts leaf nodes in the game tree at a given depth. This is the standard
//' correctness test for a chess move generator: from the starting position the
//' counts must be 20, 400, 8902 and 197281 for depths 1 to 4. If even one
//' illegal move is generated, or one legal move missed, the counts break.
//'
//' @param board_matrix An 8x8 integer matrix from
//'   \code{Board$encode_for_engine()}.
//' @param is_white_int \code{1} for white to move, \code{-1} for black.
//' @param depth Depth in plies. Keep to 4 or less; the count grows fast.
//' @return The number of leaf nodes, as a numeric value.
//' @export
// [[Rcpp::export]]
double chess_perft(IntegerMatrix board_matrix, int is_white_int, int depth) {

  if (depth < 0) stop("depth must be non-negative");

  int b[64];
  board_from_matrix(board_matrix, b);

  return (double) perft(b, depth, is_white_int == 1);
}
