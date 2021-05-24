###
# 2048



import Base: rand, <, ==

# =======================================================================
# This code implements 2048 with a state type of UInt64.
# This representations fits 16 tiles using 16 nibbles (4 bits) each.
# Based on github.com/nneonneo/2048-ai, by Robert Xiao

const Row = UInt16
const Board = UInt64 # Our 2048 state representation

const TwentyFortyEightAction = UInt8
const NONE = 0xFF

const SA2048 = Tuple{Board,TwentyFortyEightAction}
const AS2048 = Tuple{TwentyFortyEightAction, Board}

# Move tables.
# Each extracted row or column has 4 nibbles, so 2^16 = 65536 possible values.
# We can thus store lookups ahead of time.
# The lookup value is 0 if there is no move, and otherwise equals a value that can easily be
# xor'ed into the current board state to update the board.
# Rows tables map rows to rows, whereas column tables map colums to expanded columns for efficiency.
const ROW_LEFT_TABLE = Vector{Row}(undef, 2^16)
const ROW_RIGHT_TABLE = Vector{Row}(undef, 2^16)
const COL_UP_TABLE = Vector{Board}(undef, 2^16)
const COL_DOWN_TABLE = Vector{Board}(undef, 2^16)
const SCORE_TABLE = Vector{Float32}(undef, 2^16)

const ROW_MASK = 0x000000000000FFFF
const COL_MASK = 0x000F000F000F000F

# The probability that a two tile is spawned
const PROB_SPAWN_TWO = 0.80f0
const PROB_SPAWN_FOUR = 1.0f0 - PROB_SPAWN_TWO

const LEFT = 0x00
const DOWN = 0x01
const RIGHT = 0x02
const UP = 0x03
const DIRECTIONS = (LEFT, DOWN, RIGHT, UP)
const TWENTY_FORTY_EIGHT_MOVE_STRINGS = ["LEFT", "DOWN", "RIGHT", "UP"]


@with_kw struct TwentyFortyEight
    γ::Float64 = 1.0
end

function transition(mdp::TwentyFortyEight, s::Board, a::TwentyFortyEightAction)
    s′ = move(s, a)
    if s′ == s # terminal state or illegal action
        return s′
    end
    s′ = insert_tile_rand(s′, draw_tile())
    return s′
end

function reward(mdp::TwentyFortyEight, s::Board, a::TwentyFortyEightAction)
    s′ = move(s, a)
    if s′ == s # terminal state or illegal action
        return -1.0
    end
    s′ = insert_tile_rand(s′, draw_tile())
    return score_board(s′) - score_board(s)
end

function transition_and_reward(mdp::TwentyFortyEight, s::Board, a::TwentyFortyEightAction)
    s′ = move(s, a)
    if s′ == s # terminal state or illegal action
        return (s′, -1.0)
    end
    s′ = insert_tile_rand(s′, draw_tile())
    r = score_board(s′) - score_board(s)
    return (s′, r)
end


function MDP(mdp::TwentyFortyEight; γ::Float64=mdp.γ)
    return MDP(
            γ,
            nothing, # no ordered states
            DIRECTIONS,
            nothing, # no probabilistic transition function
            (s,a) -> reward(mdp, s, a),
            (s, a)-> transition_and_reward(mdp, s,a)
        )
end

"""
Print out a 2048 state.
"""
function print_board(s::Board)
    for i in 1:4
        for j in 1:4
            v = (s & 0x0F) # the tile value is 2^v, where v is the nibble value
            @printf("%6u", v == 0 ? 0 : 1 << v)
            s >>= 4
        end
        println("")
    end
    println("")
end

"""
Turn a column back into a full-sized board
"""
function unpack_col(row::Row)
    x = Board(row)
    return (x | (x << 12) | (x << 24) | (x << 36)) & COL_MASK
end

"""
Reverse a 2048 row
"""
function reverse_row(row::Row)
    return (row >> 12) | ((row >> 4) & 0x00F0)  | ((row << 4) & 0x0F00) | (row << 12)
end

"""
Transpose rows/columns in a board:
  0123       048c
  4567  -->  159d
  89ab       26ae
  cdef       37bf
This method is used to easily extract columns.
"""
function transpose_board(s::Board)
    # Set a to:
    #     0426
    #     1537
    #     8cae
    #     9dbf
    a1 = s & 0xF0F00F0FF0F00F0F
    a2 = s & 0x0000F0F00000F0F0
    a3 = s & 0x0F0F00000F0F0000
    a = a1 | (a2 << 12) | (a3 >> 12)

    b1 = a & 0xFF00FF0000FF00FF
    b2 = a & 0x00FF00FF00000000
    b3 = a & 0x00000000FF00FF00
    return b1 | (b2 >> 24) | (b3 << 24)
end

"""
Count the number of empty tiles (nibbles that are zero) in a state.
Precondition: the board cannot be fully empty.
"""
function count_empty(s::Board)
    # Any set upper two bits are copied down to lower two bits, per nibble
    s |= (s >> 2) & 0x3333333333333333
    # Any set 2nd bit is copied down to the lowest bit, per nibble
    s |= (s >> 1)
    # Only keep first bits that are not set
    s = ~s & 0x1111111111111111
    # At this point each nibble is:
    #  0 if the original nibble was non-zero
    #  1 if the original nibble was zero
    # Next sum them all
    s += s >> 32
    s += s >> 16
    s += s >>  8
    s += s >>  4 # This can overflow to the next nibble if there were 16 empty positions
    return s & 0x0F
end


"""
Populate the score and move tables, which are used for quick lookups.
Note - nneoneo's heuristic score calculation has been removed.
"""
function init_2048_tables()


    for row in 0x0000 : 0xFFFF
        line = [
            (row >>  0) & 0x0F,
            (row >>  4) & 0x0F,
            (row >>  8) & 0x0F,
            (row >> 12) & 0x0F,
        ]

        # Score
        score = 0.0f0
        for rank in line
            if rank >= 2
                # The score is the total sum of the tile and all intermediate merged tiles
                score += (rank - 1) * (1 << rank)
            end
        end
        SCORE_TABLE[row+1] = score

        # Execute a move to the left
        i = 1
        while i < 4
            j = i + 1
            while j < 5
                if line[j] != 0
                    break
                end
                j += 1
            end
            if j == 5
                # No more tiles to the right
                break
            end

            if line[i] == 0
                line[i] = line[j]
                line[j] = 0
                i -= 1 # retry this entry
            elseif line[i] == line[j]
                if line[i] != 0x0F
                    # Note: Pretend that 32768 + 32768 = 32768 (representational limit).
                    line[i] += 1
                end
                line[j] = 0
            end
            i += 1
        end

        result = (line[1] <<  0) |
                 (line[2] <<  4) |
                 (line[3] <<  8) |
                 (line[4] << 12)
        rev_result = reverse_row(result)
        rev_row = reverse_row(row)

        ROW_LEFT_TABLE[     row+1] =                row  ⊻                result
        ROW_RIGHT_TABLE[rev_row+1] =            rev_row  ⊻            rev_result
        COL_UP_TABLE[       row+1] = unpack_col(    row) ⊻ unpack_col(    result)
        COL_DOWN_TABLE[ rev_row+1] = unpack_col(rev_row) ⊻ unpack_col(rev_result)
    end
end
init_2048_tables() # Initialize our score and move tables

function move_up(s::Board)
    s′ = s
    t = transpose_board(s)
    s′ ⊻= COL_UP_TABLE[((t >>  0) & ROW_MASK)+1] <<  0
    s′ ⊻= COL_UP_TABLE[((t >> 16) & ROW_MASK)+1] <<  4
    s′ ⊻= COL_UP_TABLE[((t >> 32) & ROW_MASK)+1] <<  8
    s′ ⊻= COL_UP_TABLE[((t >> 48) & ROW_MASK)+1] << 12
    return s′
end

function move_down(s::Board)
    s′ = s
    t = transpose_board(s)
    s′ ⊻= COL_DOWN_TABLE[((t >>  0) & ROW_MASK)+1] <<  0
    s′ ⊻= COL_DOWN_TABLE[((t >> 16) & ROW_MASK)+1] <<  4
    s′ ⊻= COL_DOWN_TABLE[((t >> 32) & ROW_MASK)+1] <<  8
    s′ ⊻= COL_DOWN_TABLE[((t >> 48) & ROW_MASK)+1] << 12
    return s′
end

function move_left(s::Board)
    s′ = s
    s′ ⊻= Board(ROW_LEFT_TABLE[((s >>  0) & ROW_MASK)+1]) <<  0
    s′ ⊻= Board(ROW_LEFT_TABLE[((s >> 16) & ROW_MASK)+1]) << 16
    s′ ⊻= Board(ROW_LEFT_TABLE[((s >> 32) & ROW_MASK)+1]) << 32
    s′ ⊻= Board(ROW_LEFT_TABLE[((s >> 48) & ROW_MASK)+1]) << 48
    return s′
end

function move_right(s::Board)
    s′ = s
    s′ ⊻= Board(ROW_RIGHT_TABLE[((s >>  0) & ROW_MASK)+1]) <<  0
    s′ ⊻= Board(ROW_RIGHT_TABLE[((s >> 16) & ROW_MASK)+1]) << 16
    s′ ⊻= Board(ROW_RIGHT_TABLE[((s >> 32) & ROW_MASK)+1]) << 32
    s′ ⊻= Board(ROW_RIGHT_TABLE[((s >> 48) & ROW_MASK)+1]) << 48
    return s′
end


"""
This is our deterministic transition function
"""
function move(s::Board, a::TwentyFortyEightAction)
    if a == UP
        return move_up(s)
    elseif a == DOWN
        return move_down(s)
    elseif a == LEFT
        return move_left(s)
    elseif a == RIGHT
        return move_right(s)
    else
        return ~zero(UInt64) # Invalid move - return a filled board
    end
end

"""
True if the 2048 state has no valid actions.
"""
function isdone(s::Board)
    return move(s, UP   ) == s &&
           move(s, DOWN ) == s &&
           move(s, LEFT ) == s &&
           move(s, RIGHT) == s
end

"""
Get the maximum rank among tiles on the board.
"""
function get_max_rank(s::Board)
    maxrank = 0
    while s > 0
        maxrank = max(maxrank, Int(s & 0x0f))
        s >>= 4
    end
    return maxrank
end

"""
Get the number of distinct tile values.
"""
function count_distinct_tiles(s::Board)
    bitset = 0x00
    while s > 0
        bitset |= 1 << (s & 0x0f)
        s >>= 4
    end

    # Do not count empty tiles.
    bitset >>= 1

    n_distinct = 0
    while bitset > 0
        bitset &= bitset - 1
        n_distinct += 1
    end
    return n_distinct
end

"""
Randomly determine whether to spawn a 2 or a 4 tile.
"""
draw_tile()::Board = rand() < PROB_SPAWN_TWO ? 1 : 2

"""
Spawn a tile in a random square, which occurs after we move.
"""
function insert_tile_rand(s::Board, tile::Board)
    n_empty = count_empty(s)
    @assert n_empty > 0
    index = rand(1:n_empty)
    tmp = s
    while true
        while (tmp & 0x0F) != 0
            tmp >>= 4
            tile <<= 4
        end
        if index == 1
            break
        end
        index -= 1
        tmp >>= 4
        tile <<= 4
    end
    return s | tile
end

"""
Generate a starting board.
"""
function initial_board()
    s = draw_tile() << (4 * rand(0:15))
    return insert_tile_rand(s, draw_tile())
end

"""
A helper function for scoring boards.
Scoring is done row-wise using our score table.
"""
function score_helper(s::Board, table::Vector{Float32})
    return table[((s >>  0) & ROW_MASK)+1] +
           table[((s >> 16) & ROW_MASK)+1] +
           table[((s >> 32) & ROW_MASK)+1] +
           table[((s >> 48) & ROW_MASK)+1]
end

"""
Get the true score of a single board.
Note that we cannot tell the difference between a 4 that was spawned
and a 4 that was merged from two 2s. This scoring function assumes
all 4s were spawned from 2s.
"""
score_board(s::Board) = score_helper(s, SCORE_TABLE)

"""
Play 2048 randomly to completition from the given initial board state.
The final board score is returned.
"""
function rollout_to_end(s::Board)
    a = NONE
    n_valid = 0
    for a_candidate in DIRECTIONS
        s′ = move(s, a_candidate)
        if s′ != s
            # valid move; potentially accept
            n_valid += 1
            if rand() < 1/n_valid
                a = a_candidate
            end
        end
    end

    # No valid moves
    if a == NONE
        return score_board(s)
    end

    s′ = insert_tile_rand(move(s,a), draw_tile())
    return rollout_to_end(s′)
end

"""
Play 2048 to completion using the given policy.
The final score is returned.
Note that this core is "correct" in that we track whether 2 or 4 tiles are generated
and update the score appropriately.
"""
function play_game(π::Function)
    s = initial_board()

    # Number of moves.
    moveno = 0

    # Cumulative penalty for obtaining free 4 tiles, as
    # when computing the score of merged tiles we cannot distinguish between
    # merged 2-tiles and spawned 4 tiles.
    scorepenalty = score_board(s)

    while !isdone(s)

        moveno += 1
        println("Move #$(moveno), current score=$(score_board(s) - scorepenalty)")
        print_board(s)

        a = π(s)
        if a == NONE
            break
        end

        println("\ta = ", TWENTY_FORTY_EIGHT_MOVE_STRINGS[a+1])

        s′ = move(s, a)
        if s′ == s
            @warn "Illegal move!"
            moveno -= 1
            continue
        end

        tile = draw_tile()
        if tile == 2
            scorepenalty += 4
        end
        s = insert_tile_rand(s′, tile)
    end

    print_board(s)
    @printf("\nGame over. Your score is %.0f. The highest rank you achieved was %d.\n", score_board(s) - scorepenalty, get_max_rank(s));
end
