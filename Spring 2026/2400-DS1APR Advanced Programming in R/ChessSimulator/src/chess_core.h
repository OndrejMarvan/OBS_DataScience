// =============================================================================
//  ChessSimulator — PURE C++ CORE
//  File: src/chess_core.h
// =============================================================================
//
//  WHY A SEPARATE HEADER?
//  ----------------------
//  This file contains NO Rcpp code — only plain C++. That means it can be
//  compiled and tested with an ordinary C++ compiler, independently of R.
//  chess_engine.cpp then includes this header and adds thin Rcpp wrappers.
//
//  Separating "logic" from "bindings" is standard practice: the logic can be
//  verified on its own, and the bindings stay short and readable.
//
//  BOARD REPRESENTATION
//  --------------------
//  A flat array of 64 ints. Index = row * 8 + col, where
//    row 0 = rank 1 (white's home rank), row 7 = rank 8
//    col 0 = file a,                     col 7 = file h
//  So index 0 = a1, index 4 = e1, index 63 = h8.
//
//  PIECE ENCODING  (each type has its OWN code — this matters!)
//    0 = empty
//    1 = pawn      2 = knight    3 = bishop
//    4 = rook      5 = queen     6 = king
//  White pieces are POSITIVE, black pieces are NEGATIVE.
//
//  In the first version of this project knight and bishop shared the code 3.
//  The generator could not tell them apart, so it emitted both knight jumps
//  and bishop slides for either piece — illegal moves that made the AI look
//  like it was moving at random. Unique codes fix that.
// =============================================================================

#ifndef CHESS_CORE_H
#define CHESS_CORE_H

#include <vector>
#include <algorithm>
#include <cstdlib>

namespace chess {

// --- Piece type codes --------------------------------------------------------
const int EMPTY  = 0;
const int PAWN   = 1;
const int KNIGHT = 2;
const int BISHOP = 3;
const int ROOK   = 4;
const int QUEEN  = 5;
const int KING   = 6;

// --- Material values in centipawns (100 centipawns = 1 pawn) -----------------
// The king has no material value: losing it is handled by mate detection.
inline int piece_value(int type) {
  switch (type) {
    case PAWN:   return 100;
    case KNIGHT: return 320;
    case BISHOP: return 330;
    case ROOK:   return 500;
    case QUEEN:  return 900;
    default:     return 0;
  }
}

// Score used for checkmate. Large enough to dominate any material count.
const int MATE_SCORE = 100000;

// =============================================================================
//  MOVE REPRESENTATION
//  from / to : 0-63 board indices
//  promo     : piece code to promote to (QUEEN), or 0 for a normal move
//
//  SIMPLIFICATION: pawns always promote to a queen. Under-promotion is legal
//  but almost never useful, so it is omitted to keep the code readable.
// =============================================================================
struct Move {
  int from;
  int to;
  int promo;
  Move() : from(0), to(0), promo(0) {}
  Move(int f, int t, int p = 0) : from(f), to(t), promo(p) {}
};

// Information needed to take a move back (make / unmake pattern).
struct Undo {
  int captured;      // piece standing on `to` before the move (0 if none)
  int moved_before;  // what the moving piece was before promotion
};

// =============================================================================
//  ATTACK DETECTION
//  ----------------
//  is_square_attacked() answers: "can side X capture whatever sits on sq?"
//
//  Instead of generating every enemy move and checking destinations (slow),
//  we look OUTWARD from the square itself:
//    - enemy pawns on the two attacking diagonals?
//    - an enemy knight a knight's-jump away?
//    - the enemy king adjacent?
//    - walking each diagonal, is the first piece met a bishop or queen?
//    - walking each rank/file, is the first piece met a rook or queen?
//
//  Roughly 40 cheap checks, and the most-called function in the engine:
//  legal-move generation needs it once per candidate move.
// =============================================================================
inline bool is_square_attacked(const int b[64], int sq, bool by_white) {

  const int r = sq / 8;
  const int c = sq % 8;
  const int sign = by_white ? 1 : -1;   // enemy pieces carry this sign

  // --- Pawns ---------------------------------------------------------------
  // A white pawn one row below attacks upward; a black pawn one row above.
  {
    const int pr = by_white ? r - 1 : r + 1;
    if (pr >= 0 && pr < 8) {
      if (c - 1 >= 0 && b[pr * 8 + (c - 1)] == sign * PAWN) return true;
      if (c + 1 <  8 && b[pr * 8 + (c + 1)] == sign * PAWN) return true;
    }
  }

  // --- Knights -------------------------------------------------------------
  {
    static const int KN[8][2] = {
      { 2, 1}, { 2,-1}, {-2, 1}, {-2,-1},
      { 1, 2}, { 1,-2}, {-1, 2}, {-1,-2}
    };
    for (int i = 0; i < 8; i++) {
      const int rr = r + KN[i][0], cc = c + KN[i][1];
      if (rr >= 0 && rr < 8 && cc >= 0 && cc < 8 &&
          b[rr * 8 + cc] == sign * KNIGHT) return true;
    }
  }

  // --- Enemy king on an adjacent square ------------------------------------
  for (int dr = -1; dr <= 1; dr++) {
    for (int dc = -1; dc <= 1; dc++) {
      if (dr == 0 && dc == 0) continue;
      const int rr = r + dr, cc = c + dc;
      if (rr >= 0 && rr < 8 && cc >= 0 && cc < 8 &&
          b[rr * 8 + cc] == sign * KING) return true;
    }
  }

  // --- Sliding attackers on the diagonals: bishop or queen -----------------
  {
    static const int DIAG[4][2] = { {1,1}, {1,-1}, {-1,1}, {-1,-1} };
    for (int i = 0; i < 4; i++) {
      int rr = r + DIAG[i][0], cc = c + DIAG[i][1];
      while (rr >= 0 && rr < 8 && cc >= 0 && cc < 8) {
        const int cell = b[rr * 8 + cc];
        if (cell != EMPTY) {                       // first piece met
          if (cell == sign * BISHOP || cell == sign * QUEEN) return true;
          break;                                   // anything else blocks
        }
        rr += DIAG[i][0];
        cc += DIAG[i][1];
      }
    }
  }

  // --- Sliding attackers on ranks and files: rook or queen -----------------
  {
    static const int STRAIGHT[4][2] = { {1,0}, {-1,0}, {0,1}, {0,-1} };
    for (int i = 0; i < 4; i++) {
      int rr = r + STRAIGHT[i][0], cc = c + STRAIGHT[i][1];
      while (rr >= 0 && rr < 8 && cc >= 0 && cc < 8) {
        const int cell = b[rr * 8 + cc];
        if (cell != EMPTY) {
          if (cell == sign * ROOK || cell == sign * QUEEN) return true;
          break;
        }
        rr += STRAIGHT[i][0];
        cc += STRAIGHT[i][1];
      }
    }
  }

  return false;
}

// Find the index of a side's king, or -1 if it is not on the board.
inline int find_king(const int b[64], bool white) {
  const int target = white ? KING : -KING;
  for (int i = 0; i < 64; i++) if (b[i] == target) return i;
  return -1;
}

// Is the given side currently in check?
inline bool in_check(const int b[64], bool white) {
  const int k = find_king(b, white);
  if (k < 0) return false;
  return is_square_attacked(b, k, !white);
}

// =============================================================================
//  MAKE / UNMAKE
//  The search explores thousands of hypothetical positions. Copying the whole
//  board at every node would be wasteful, so we apply a move, recurse, then
//  take the move back — restoring exactly what was there before.
// =============================================================================
inline Undo make_move(int b[64], const Move& m) {
  Undo u;
  u.captured     = b[m.to];
  u.moved_before = b[m.from];

  b[m.to]   = (m.promo != 0)
              ? (b[m.from] > 0 ? m.promo : -m.promo)   // promotion
              : b[m.from];                             // normal move
  b[m.from] = EMPTY;

  return u;
}

inline void unmake_move(int b[64], const Move& m, const Undo& u) {
  b[m.from] = u.moved_before;
  b[m.to]   = u.captured;
}

// =============================================================================
//  PSEUDO-LEGAL MOVE GENERATION
//  "Pseudo-legal" = obeys the piece's movement rules, but may still leave the
//  mover's own king in check. gen_legal() below filters those out.
// =============================================================================
inline void gen_pseudo(const int b[64], bool white, std::vector<Move>& out) {

  out.clear();

  for (int sq = 0; sq < 64; sq++) {

    const int cell = b[sq];
    if (cell == EMPTY) continue;
    if (white  && cell < 0) continue;     // not my piece
    if (!white && cell > 0) continue;

    const int type = std::abs(cell);
    const int r = sq / 8, c = sq % 8;

    // --- PAWN --------------------------------------------------------------
    if (type == PAWN) {
      const int dir       = white ? 1 : -1;   // white marches up the board
      const int start_row = white ? 1 : 6;    // rank 2 white, rank 7 black
      const int last_row  = white ? 7 : 0;    // promotion rank
      const int r1 = r + dir;

      if (r1 >= 0 && r1 < 8) {

        // one square forward, only onto an empty square
        if (b[r1 * 8 + c] == EMPTY) {
          if (r1 == last_row) out.push_back(Move(sq, r1 * 8 + c, QUEEN));
          else                out.push_back(Move(sq, r1 * 8 + c));

          // two squares from the starting rank, both must be empty
          const int r2 = r + 2 * dir;
          if (r == start_row && b[r2 * 8 + c] == EMPTY)
            out.push_back(Move(sq, r2 * 8 + c));
        }

        // diagonal captures, only onto an ENEMY piece
        for (int dc = -1; dc <= 1; dc += 2) {
          const int cc = c + dc;
          if (cc < 0 || cc >= 8) continue;
          const int target = b[r1 * 8 + cc];
          if (target != EMPTY && (target > 0) != white) {
            if (r1 == last_row) out.push_back(Move(sq, r1 * 8 + cc, QUEEN));
            else                out.push_back(Move(sq, r1 * 8 + cc));
          }
        }
      }
      continue;
    }

    // --- KNIGHT: eight L-shaped jumps, may hop over pieces ------------------
    if (type == KNIGHT) {
      static const int KN[8][2] = {
        { 2, 1}, { 2,-1}, {-2, 1}, {-2,-1},
        { 1, 2}, { 1,-2}, {-1, 2}, {-1,-2}
      };
      for (int i = 0; i < 8; i++) {
        const int rr = r + KN[i][0], cc = c + KN[i][1];
        if (rr < 0 || rr >= 8 || cc < 0 || cc >= 8) continue;
        const int target = b[rr * 8 + cc];
        if (target == EMPTY || (target > 0) != white)   // empty or enemy
          out.push_back(Move(sq, rr * 8 + cc));
      }
      continue;
    }

    // --- KING: one step in any direction ------------------------------------
    if (type == KING) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;
          const int rr = r + dr, cc = c + dc;
          if (rr < 0 || rr >= 8 || cc < 0 || cc >= 8) continue;
          const int target = b[rr * 8 + cc];
          if (target == EMPTY || (target > 0) != white)
            out.push_back(Move(sq, rr * 8 + cc));
        }
      }
      continue;
    }

    // --- SLIDING PIECES: bishop, rook, queen ---------------------------------
    // All three walk outward until blocked; only the directions differ.
    // This is precisely where the old shared knight/bishop code went wrong.
    {
      static const int DIAG[4][2]     = { {1,1}, {1,-1}, {-1,1}, {-1,-1} };
      static const int STRAIGHT[4][2] = { {1,0}, {-1,0}, {0,1},  {0,-1}  };

      if (type != BISHOP && type != ROOK && type != QUEEN) continue;

      // Bishop: diagonals. Rook: straights. Queen: both (two passes).
      const int passes = (type == QUEEN) ? 2 : 1;

      for (int pass = 0; pass < passes; pass++) {

        const int (*d)[2];
        if (type == BISHOP)    d = DIAG;
        else if (type == ROOK) d = STRAIGHT;
        else                   d = (pass == 0) ? DIAG : STRAIGHT;

        for (int i = 0; i < 4; i++) {
          int rr = r + d[i][0], cc = c + d[i][1];
          while (rr >= 0 && rr < 8 && cc >= 0 && cc < 8) {
            const int target = b[rr * 8 + cc];
            if (target == EMPTY) {
              out.push_back(Move(sq, rr * 8 + cc));      // keep sliding
            } else {
              if ((target > 0) != white)
                out.push_back(Move(sq, rr * 8 + cc));    // capture, then stop
              break;                                     // blocked either way
            }
            rr += d[i][0];
            cc += d[i][1];
          }
        }
      }
    }
  }
}

// =============================================================================
//  LEGAL MOVE GENERATION
//  A move is legal only if it does not leave your OWN king attacked. We test
//  that honestly: play the move, ask whether our king is in check, take it back.
//
//  This is what makes the engine play real chess. Without it, kings can be
//  left en prise, get captured, and games end in nonsense results.
// =============================================================================
inline void gen_legal(int b[64], bool white, std::vector<Move>& out) {

  std::vector<Move> pseudo;
  gen_pseudo(b, white, pseudo);

  out.clear();
  out.reserve(pseudo.size());

  for (size_t i = 0; i < pseudo.size(); i++) {
    const Undo u = make_move(b, pseudo[i]);
    if (!in_check(b, white)) out.push_back(pseudo[i]);
    unmake_move(b, pseudo[i], u);
  }
}

// =============================================================================
//  PIECE-SQUARE TABLES
//  A bonus (centipawns) for standing on a particular square. They encode
//  simple positional wisdom: knights belong in the centre, pawns want to
//  advance, the king should stay tucked away in the opening and middlegame.
//
//  Written from WHITE's point of view with row 0 = rank 1. For black we read
//  the same table with the rows mirrored.
// =============================================================================
static const int PST_PAWN[64] = {
   0,  0,  0,  0,  0,  0,  0,  0,
   5, 10, 10,-20,-20, 10, 10,  5,
   5, -5,-10,  0,  0,-10, -5,  5,
   0,  0,  0, 20, 20,  0,  0,  0,
   5,  5, 10, 25, 25, 10,  5,  5,
  10, 10, 20, 30, 30, 20, 10, 10,
  50, 50, 50, 50, 50, 50, 50, 50,
   0,  0,  0,  0,  0,  0,  0,  0
};

static const int PST_KNIGHT[64] = {
 -50,-40,-30,-30,-30,-30,-40,-50,
 -40,-20,  0,  5,  5,  0,-20,-40,
 -30,  5, 10, 15, 15, 10,  5,-30,
 -30,  0, 15, 20, 20, 15,  0,-30,
 -30,  5, 15, 20, 20, 15,  5,-30,
 -30,  0, 10, 15, 15, 10,  0,-30,
 -40,-20,  0,  0,  0,  0,-20,-40,
 -50,-40,-30,-30,-30,-30,-40,-50
};

static const int PST_BISHOP[64] = {
 -20,-10,-10,-10,-10,-10,-10,-20,
 -10,  5,  0,  0,  0,  0,  5,-10,
 -10, 10, 10, 10, 10, 10, 10,-10,
 -10,  0, 10, 10, 10, 10,  0,-10,
 -10,  5,  5, 10, 10,  5,  5,-10,
 -10,  0,  5, 10, 10,  5,  0,-10,
 -10,  0,  0,  0,  0,  0,  0,-10,
 -20,-10,-10,-10,-10,-10,-10,-20
};

static const int PST_ROOK[64] = {
   0,  0,  0,  5,  5,  0,  0,  0,
  -5,  0,  0,  0,  0,  0,  0, -5,
  -5,  0,  0,  0,  0,  0,  0, -5,
  -5,  0,  0,  0,  0,  0,  0, -5,
  -5,  0,  0,  0,  0,  0,  0, -5,
  -5,  0,  0,  0,  0,  0,  0, -5,
   5, 10, 10, 10, 10, 10, 10,  5,
   0,  0,  0,  0,  0,  0,  0,  0
};

static const int PST_QUEEN[64] = {
 -20,-10,-10, -5, -5,-10,-10,-20,
 -10,  0,  5,  0,  0,  0,  0,-10,
 -10,  5,  5,  5,  5,  5,  0,-10,
   0,  0,  5,  5,  5,  5,  0, -5,
  -5,  0,  5,  5,  5,  5,  0, -5,
 -10,  0,  5,  5,  5,  5,  0,-10,
 -10,  0,  0,  0,  0,  0,  0,-10,
 -20,-10,-10, -5, -5,-10,-10,-20
};

static const int PST_KING[64] = {
  20, 30, 10,  0,  0, 10, 30, 20,
  20, 20,  0,  0,  0,  0, 20, 20,
 -10,-20,-20,-20,-20,-20,-20,-10,
 -20,-30,-30,-40,-40,-30,-30,-20,
 -30,-40,-40,-50,-50,-40,-40,-30,
 -30,-40,-40,-50,-50,-40,-40,-30,
 -30,-40,-40,-50,-50,-40,-40,-30,
 -30,-40,-40,-50,-50,-40,-40,-30
};

inline int pst_bonus(int type, int sq, bool white) {
  const int idx = white ? sq : (56 - 8 * (sq / 8) + (sq % 8));  // mirror rows
  switch (type) {
    case PAWN:   return PST_PAWN[idx];
    case KNIGHT: return PST_KNIGHT[idx];
    case BISHOP: return PST_BISHOP[idx];
    case ROOK:   return PST_ROOK[idx];
    case QUEEN:  return PST_QUEEN[idx];
    case KING:   return PST_KING[idx];
    default:     return 0;
  }
}

// =============================================================================
//  STATIC EVALUATION
//  Returns centipawns from WHITE's point of view:
//    > 0 white better, < 0 black better, 0 balanced.
// =============================================================================
inline int evaluate(const int b[64]) {

  int score = 0;

  for (int sq = 0; sq < 64; sq++) {
    const int cell = b[sq];
    if (cell == EMPTY) continue;

    const bool white = (cell > 0);
    const int  type  = std::abs(cell);
    const int  v     = piece_value(type) + pst_bonus(type, sq, white);

    score += white ? v : -v;
  }

  return score;
}

// =============================================================================
//  MOVE ORDERING
//  Alpha-beta prunes far more when good moves are tried first. The cheapest
//  useful heuristic is MVV-LVA: "Most Valuable Victim, Least Valuable
//  Attacker" — prefer taking a queen with a pawn over taking a pawn with a
//  queen. Promotions rank highly too.
//
//  Without ordering the search visits roughly ten times more positions for
//  the same depth.
// =============================================================================
inline int move_score(const int b[64], const Move& m) {
  int s = 0;
  const int victim   = std::abs(b[m.to]);
  const int attacker = std::abs(b[m.from]);
  if (victim != EMPTY) s += 10 * piece_value(victim) - piece_value(attacker);
  if (m.promo != 0)    s += piece_value(m.promo);
  return s;
}

inline void order_moves(const int b[64], std::vector<Move>& moves) {
  std::vector<std::pair<int, Move> > scored;
  scored.reserve(moves.size());
  for (size_t i = 0; i < moves.size(); i++)
    scored.push_back(std::make_pair(move_score(b, moves[i]), moves[i]));

  std::stable_sort(scored.begin(), scored.end(),
                   [](const std::pair<int, Move>& a,
                      const std::pair<int, Move>& b2) {
                     return a.first > b2.first;   // highest score first
                   });

  for (size_t i = 0; i < scored.size(); i++) moves[i] = scored[i].second;
}

// =============================================================================
//  MINIMAX SEARCH WITH ALPHA-BETA PRUNING
//  Scores are always from WHITE's perspective: white maximises, black minimises.
//
//  alpha = best score white can already guarantee
//  beta  = best score black can already guarantee
//  If beta <= alpha this branch can never be chosen — prune it.
//
//  `ply` counts depth from the root. Mate scores include it, so the engine
//  prefers mate in 1 over mate in 3, and delays being mated when losing.
// =============================================================================
inline int search(int b[64], int depth, int alpha, int beta,
                  bool white_to_move, int ply) {

  std::vector<Move> moves;
  gen_legal(b, white_to_move, moves);

  // --- No legal moves: the game ends right here ---------------------------
  if (moves.empty()) {
    if (in_check(b, white_to_move)) {
      // The side to move is checkmated.
      return white_to_move ? -(MATE_SCORE - ply) : (MATE_SCORE - ply);
    }
    return 0;   // stalemate — a draw
  }

  // --- Depth exhausted: fall back on the static evaluation -----------------
  if (depth <= 0) return evaluate(b);

  order_moves(b, moves);

  if (white_to_move) {
    int best = -MATE_SCORE * 2;
    for (size_t i = 0; i < moves.size(); i++) {
      const Undo u = make_move(b, moves[i]);
      const int sc = search(b, depth - 1, alpha, beta, false, ply + 1);
      unmake_move(b, moves[i], u);

      if (sc > best)  best  = sc;
      if (sc > alpha) alpha = sc;
      if (beta <= alpha) break;            // black would avoid this branch
    }
    return best;

  } else {
    int best = MATE_SCORE * 2;
    for (size_t i = 0; i < moves.size(); i++) {
      const Undo u = make_move(b, moves[i]);
      const int sc = search(b, depth - 1, alpha, beta, true, ply + 1);
      unmake_move(b, moves[i], u);

      if (sc < best) best = sc;
      if (sc < beta) beta = sc;
      if (beta <= alpha) break;            // white would avoid this branch
    }
    return best;
  }
}

// =============================================================================
//  ROOT SEARCH
//  Runs one level of minimax at the root and returns the best move found.
//  `rand01` supplies a uniform number in [0,1), used only to break ties
//  between equally good moves so two engines do not replay the same game.
// =============================================================================
inline bool best_move(int b[64], bool white, int depth, Move& out,
                      double (*rand01)()) {

  std::vector<Move> moves;
  gen_legal(b, white, moves);
  if (moves.empty()) return false;         // checkmate or stalemate

  order_moves(b, moves);

  int alpha = -MATE_SCORE * 2;
  int beta  =  MATE_SCORE * 2;
  int best  = white ? -MATE_SCORE * 2 : MATE_SCORE * 2;

  std::vector<Move> best_moves;

  for (size_t i = 0; i < moves.size(); i++) {
    const Undo u = make_move(b, moves[i]);
    const int sc = search(b, depth - 1, alpha, beta, !white, 1);
    unmake_move(b, moves[i], u);

    const bool better = white ? (sc > best) : (sc < best);

    if (better) {
      best = sc;
      best_moves.clear();
      best_moves.push_back(moves[i]);
      if (white) { if (sc > alpha) alpha = sc; }
      else       { if (sc < beta)  beta  = sc; }
    } else if (sc == best) {
      best_moves.push_back(moves[i]);
    }
  }

  if (best_moves.empty()) best_moves.push_back(moves[0]);

  size_t pick = 0;
  if (rand01 != 0 && best_moves.size() > 1) {
    pick = (size_t)(rand01() * (double)best_moves.size());
    if (pick >= best_moves.size()) pick = best_moves.size() - 1;
  }

  out = best_moves[pick];
  return true;
}

// =============================================================================
//  PERFT — move generator self-test
//  Counts leaf nodes at a given depth. The correct values from the starting
//  position are well known (20 / 400 / 8902 / 197281), so this is the standard
//  way to prove a move generator is right.
// =============================================================================
inline long perft(int b[64], int depth, bool white) {
  if (depth == 0) return 1;

  std::vector<Move> moves;
  gen_legal(b, white, moves);
  if (depth == 1) return (long) moves.size();

  long nodes = 0;
  for (size_t i = 0; i < moves.size(); i++) {
    const Undo u = make_move(b, moves[i]);
    nodes += perft(b, depth - 1, !white);
    unmake_move(b, moves[i], u);
  }
  return nodes;
}

// Fill an array with the standard starting position.
inline void setup_start(int b[64]) {
  for (int i = 0; i < 64; i++) b[i] = EMPTY;

  const int back[8] = { ROOK, KNIGHT, BISHOP, QUEEN, KING, BISHOP, KNIGHT, ROOK };
  for (int c = 0; c < 8; c++) {
    b[0 * 8 + c] =  back[c];   // white back rank (rank 1)
    b[1 * 8 + c] =  PAWN;      // white pawns     (rank 2)
    b[6 * 8 + c] = -PAWN;      // black pawns     (rank 7)
    b[7 * 8 + c] = -back[c];   // black back rank (rank 8)
  }
}

} // namespace chess

#endif // CHESS_CORE_H
