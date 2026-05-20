// =============================================================================
//  ChessSimulator - RCPP ENGINE
//  Advanced Programming in R | dr Maria Kubara, WNE UW
//  Student: Ondrej Marvan | 477001
//  File: src/chess_engine.cpp
// =============================================================================
//
//  Implements the performance-critical parts of the chess engine in C++
//  via Rcpp. Three exported functions:
//
//    1. chess_evaluate()    - scores a board position
//    2. chess_legal_moves() - generates all legal moves for one side
//    3. chess_minimax()     - minimax search with alpha-beta pruning
//
//  When packaged, this file is compiled automatically by Rcpp at install
//  time. The functions become available in R as if they were native R
//  functions (the @useDynLib + @importFrom Rcpp evalCpp in
//  ChessSimulator-package.R make this work).
//
//  BOARD ENCODING (must match Board$encode_for_engine())
//  -----------------------------------------------------
//  8x8 NumericMatrix, row 1 = rank 1, col 1 = file a.
//    White: P=1, N=3, B=3, R=5, Q=9, K=100
//    Black: same values but NEGATIVE
//    Empty: 0
// =============================================================================

#include <Rcpp.h>
using namespace Rcpp;


// =============================================================================
//  PIECE-SQUARE TABLES (in centipawns)
//  These encode standard chess positional principles.
//  Layout: [rank][file], rank 1 = index 0 (white's perspective).
//  For black, the table is read mirrored vertically.
// =============================================================================

static const int PAWN_TABLE[8][8] = {
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  { 50, 50, 50, 50, 50, 50, 50, 50 },
  { 10, 10, 20, 30, 30, 20, 10, 10 },
  {  5,  5, 10, 25, 25, 10,  5,  5 },
  {  0,  0,  0, 20, 20,  0,  0,  0 },
  {  5, -5,-10,  0,  0,-10, -5,  5 },
  {  5, 10, 10,-20,-20, 10, 10,  5 },
  {  0,  0,  0,  0,  0,  0,  0,  0 }
};

static const int KNIGHT_TABLE[8][8] = {
  {-50,-40,-30,-30,-30,-30,-40,-50 },
  {-40,-20,  0,  0,  0,  0,-20,-40 },
  {-30,  0, 10, 15, 15, 10,  0,-30 },
  {-30,  5, 15, 20, 20, 15,  5,-30 },
  {-30,  0, 15, 20, 20, 15,  0,-30 },
  {-30,  5, 10, 15, 15, 10,  5,-30 },
  {-40,-20,  0,  5,  5,  0,-20,-40 },
  {-50,-40,-30,-30,-30,-30,-40,-50 }
};

static const int ROOK_TABLE[8][8] = {
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  5, 10, 10, 10, 10, 10, 10,  5 },
  { -5,  0,  0,  0,  0,  0,  0, -5 },
  { -5,  0,  0,  0,  0,  0,  0, -5 },
  { -5,  0,  0,  0,  0,  0,  0, -5 },
  { -5,  0,  0,  0,  0,  0,  0, -5 },
  { -5,  0,  0,  0,  0,  0,  0, -5 },
  {  0,  0,  0,  5,  5,  0,  0,  0 }
};

static const int QUEEN_TABLE[8][8] = {
  {-20,-10,-10, -5, -5,-10,-10,-20 },
  {-10,  0,  0,  0,  0,  0,  0,-10 },
  {-10,  0,  5,  5,  5,  5,  0,-10 },
  { -5,  0,  5,  5,  5,  5,  0, -5 },
  {  0,  0,  5,  5,  5,  5,  0, -5 },
  {-10,  5,  5,  5,  5,  5,  0,-10 },
  {-10,  0,  5,  0,  0,  0,  0,-10 },
  {-20,-10,-10, -5, -5,-10,-10,-20 }
};

static const int KING_TABLE[8][8] = {
  {-30,-40,-40,-50,-50,-40,-40,-30 },
  {-30,-40,-40,-50,-50,-40,-40,-30 },
  {-30,-40,-40,-50,-50,-40,-40,-30 },
  {-30,-40,-40,-50,-50,-40,-40,-30 },
  {-20,-30,-30,-40,-40,-30,-30,-20 },
  {-10,-20,-20,-20,-20,-20,-20,-10 },
  { 20, 20,  0,  0,  0,  0, 20, 20 },
  { 20, 30, 10,  0,  0, 10, 30, 20 }
};


// =============================================================================
//  HELPER: positional bonus for a piece at (row, col)
// =============================================================================
int get_piece_square_bonus(int piece_abs, int row, int col, bool is_white) {

  int r = is_white ? row : (7 - row);

  switch(piece_abs) {
    case 1:   return PAWN_TABLE[r][col];
    case 3:   return KNIGHT_TABLE[r][col];
    case 5:   return ROOK_TABLE[r][col];
    case 9:   return QUEEN_TABLE[r][col];
    case 100: return KING_TABLE[r][col];
    default:  return 0;
  }
}


//' Static board evaluation (Rcpp)
//'
//' Returns a centipawn score from white's perspective. Combines material
//' value with piece-square table positional bonuses.
//'
//' @param board_matrix 8x8 NumericMatrix. See Board$encode_for_engine().
//' @return Numeric. Score in centipawns.
//' @export
// [[Rcpp::export]]
double chess_evaluate(NumericMatrix board_matrix) {

  double score = 0.0;

  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {

      int cell = (int) board_matrix(row, col);
      if (cell == 0) continue;

      bool is_white = (cell > 0);
      int  piece    = std::abs(cell);

      double material   = (double) piece * 100.0;
      double positional = (double) get_piece_square_bonus(piece, row, col, is_white);
      double piece_score = material + positional;

      score += is_white ? piece_score : -piece_score;
    }
  }

  return score;
}


// =============================================================================
//  Internal Move struct and helpers
// =============================================================================
struct Move {
  int from;   // 0-63
  int to;     // 0-63
};


std::vector<Move> generate_moves_cpp(int board[8][8], bool is_white) {

  std::vector<Move> moves;

  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {

      int cell = board[row][col];
      if (cell == 0) continue;
      if (is_white && cell < 0) continue;
      if (!is_white && cell > 0) continue;

      int piece = std::abs(cell);

      // Pawn
      if (piece == 1) {
        int dir       = is_white ? 1 : -1;
        int start_row = is_white ? 1 : 6;
        int new_row   = row + dir;

        if (new_row >= 0 && new_row < 8) {
          if (board[new_row][col] == 0) {
            moves.push_back({row * 8 + col, new_row * 8 + col});
            int dbl_row = row + 2 * dir;
            if (row == start_row && dbl_row >= 0 && dbl_row < 8 &&
                board[dbl_row][col] == 0) {
              moves.push_back({row * 8 + col, dbl_row * 8 + col});
            }
          }
          for (int dc : {-1, 1}) {
            int new_col = col + dc;
            if (new_col >= 0 && new_col < 8) {
              int target = board[new_row][new_col];
              if ((is_white && target < 0) || (!is_white && target > 0)) {
                moves.push_back({row * 8 + col, new_row * 8 + new_col});
              }
            }
          }
        }
      }

      // Knight + bishop slides (both encoded as piece value 3)
      if (piece == 3) {
        int knight_offsets[8][2] = {
          {2,1},{2,-1},{-2,1},{-2,-1},{1,2},{1,-2},{-1,2},{-1,-2}
        };
        for (auto& off : knight_offsets) {
          int nr = row + off[0], nc = col + off[1];
          if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
            int target = board[nr][nc];
            if (target == 0 || (is_white && target < 0) ||
                               (!is_white && target > 0)) {
              moves.push_back({row * 8 + col, nr * 8 + nc});
            }
          }
        }
        int diag_dirs[4][2] = {{1,1},{1,-1},{-1,1},{-1,-1}};
        for (auto& dir : diag_dirs) {
          int nr = row + dir[0], nc = col + dir[1];
          while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
            int target = board[nr][nc];
            if (target == 0) {
              moves.push_back({row * 8 + col, nr * 8 + nc});
            } else {
              if ((is_white && target < 0) || (!is_white && target > 0))
                moves.push_back({row * 8 + col, nr * 8 + nc});
              break;
            }
            nr += dir[0]; nc += dir[1];
          }
        }
      }

      // Rook
      if (piece == 5) {
        int straight_dirs[4][2] = {{1,0},{-1,0},{0,1},{0,-1}};
        for (auto& dir : straight_dirs) {
          int nr = row + dir[0], nc = col + dir[1];
          while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
            int target = board[nr][nc];
            if (target == 0) {
              moves.push_back({row * 8 + col, nr * 8 + nc});
            } else {
              if ((is_white && target < 0) || (!is_white && target > 0))
                moves.push_back({row * 8 + col, nr * 8 + nc});
              break;
            }
            nr += dir[0]; nc += dir[1];
          }
        }
      }

      // Queen
      if (piece == 9) {
        int all_dirs[8][2] = {
          {1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1}
        };
        for (auto& dir : all_dirs) {
          int nr = row + dir[0], nc = col + dir[1];
          while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
            int target = board[nr][nc];
            if (target == 0) {
              moves.push_back({row * 8 + col, nr * 8 + nc});
            } else {
              if ((is_white && target < 0) || (!is_white && target > 0))
                moves.push_back({row * 8 + col, nr * 8 + nc});
              break;
            }
            nr += dir[0]; nc += dir[1];
          }
        }
      }

      // King
      if (piece == 100) {
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            int nr = row + dr, nc = col + dc;
            if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
              int target = board[nr][nc];
              if (target == 0 || (is_white && target < 0) ||
                                  (!is_white && target > 0)) {
                moves.push_back({row * 8 + col, nr * 8 + nc});
              }
            }
          }
        }
      }
    }
  }

  return moves;
}


void apply_move_cpp(int board[8][8], Move mv, int new_board[8][8]) {
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      new_board[r][c] = board[r][c];

  int from_r = mv.from / 8, from_c = mv.from % 8;
  int to_r   = mv.to   / 8, to_c   = mv.to   % 8;

  new_board[to_r][to_c]     = new_board[from_r][from_c];
  new_board[from_r][from_c] = 0;
}


NumericMatrix board_to_matrix(int board[8][8]) {
  NumericMatrix mat(8, 8);
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      mat(r, c) = board[r][c];
  return mat;
}


// =============================================================================
//  MINIMAX with alpha-beta pruning (recursive, internal)
// =============================================================================
double minimax_search(int board[8][8], int depth,
                      double alpha, double beta, bool is_white) {

  if (depth == 0) {
    NumericMatrix mat = board_to_matrix(board);
    return chess_evaluate(mat);
  }

  std::vector<Move> moves = generate_moves_cpp(board, is_white);

  if (moves.empty()) {
    NumericMatrix mat = board_to_matrix(board);
    return chess_evaluate(mat);
  }

  if (is_white) {
    double best = -1e9;
    for (const Move& mv : moves) {
      int new_board[8][8];
      apply_move_cpp(board, mv, new_board);
      double score = minimax_search(new_board, depth - 1, alpha, beta, false);
      if (score > best) best = score;
      if (score > alpha) alpha = score;
      if (beta <= alpha) break;
    }
    return best;
  } else {
    double best = 1e9;
    for (const Move& mv : moves) {
      int new_board[8][8];
      apply_move_cpp(board, mv, new_board);
      double score = minimax_search(new_board, depth - 1, alpha, beta, true);
      if (score < best) best = score;
      if (score < beta) beta = score;
      if (beta <= alpha) break;
    }
    return best;
  }
}


//' Generate all pseudo-legal moves for one side (Rcpp)
//'
//' @param board_matrix 8x8 NumericMatrix.
//' @param is_white_int 1 = white, -1 = black.
//' @return Nx2 IntegerMatrix with 1-based (from, to) indices.
//' @export
// [[Rcpp::export]]
IntegerMatrix chess_legal_moves(NumericMatrix board_matrix, int is_white_int) {

  int board[8][8];
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      board[r][c] = (int) board_matrix(r, c);

  bool is_white = (is_white_int == 1);
  std::vector<Move> moves = generate_moves_cpp(board, is_white);

  int n = moves.size();
  IntegerMatrix result(n, 2);

  for (int i = 0; i < n; i++) {
    result(i, 0) = moves[i].from + 1;
    result(i, 1) = moves[i].to   + 1;
  }

  return result;
}


//' Minimax search entry point (Rcpp)
//'
//' @param board_matrix 8x8 NumericMatrix.
//' @param is_white_int 1 = white to move, -1 = black to move.
//' @param depth Positive integer. Search depth.
//' @return IntegerVector of length 2: c(from_index, to_index), 1-based.
//' @export
// [[Rcpp::export]]
IntegerVector chess_minimax(NumericMatrix board_matrix,
                            int is_white_int,
                            int depth) {

  int board[8][8];
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      board[r][c] = (int) board_matrix(r, c);

  bool is_white = (is_white_int == 1);
  std::vector<Move> moves = generate_moves_cpp(board, is_white);

  if (moves.empty()) {
    return IntegerVector::create(0, 0);
  }

  double best_score = is_white ? -1e9 : 1e9;
  Move   best_move  = moves[0];
  double alpha      = -1e9;
  double beta       =  1e9;

  for (const Move& mv : moves) {
    int new_board[8][8];
    apply_move_cpp(board, mv, new_board);
    double score = minimax_search(new_board, depth - 1, alpha, beta, !is_white);

    if (is_white && score > best_score) {
      best_score = score;
      best_move  = mv;
      if (score > alpha) alpha = score;
    } else if (!is_white && score < best_score) {
      best_score = score;
      best_move  = mv;
      if (score < beta) beta = score;
    }
  }

  return IntegerVector::create(best_move.from + 1, best_move.to + 1);
}
