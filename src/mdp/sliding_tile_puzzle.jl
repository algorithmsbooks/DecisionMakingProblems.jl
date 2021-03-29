const UP = 0x00
const DOWN = 0x01
const LEFT = 0x02
const RIGHT = 0x03
const NONE = 0xFF

const SlidingTileAction = UInt8

struct SlidingTileState
    # The desired arrangement for grid is, for example:
    #  [1 2 3
    #   4 5 6
    #   7 8 0]
    # Where zero indicates the empty tile.
    grid::Matrix{UInt8}
    i::Int # index of the empty tile
end

struct SlidingTilePuzzle
    n::Int # For an n×n problem.
end

function get_terminal_state(search::SlidingTilePuzzle)
    n = search.n
    grid = convert(Vector{UInt8}, collect(1:n^2))
    grid = Matrix(reshape(grid, (n,n))')
    grid[end] = 0
    return SlidingTileState(grid, n^2)
end

Base.hash(s::SlidingTileState, h::UInt64=UInt64(0)) = hash(s.grid, h)
Base.isequal(a::SlidingTileState, b::SlidingTileState) = a.grid == b.grid
==(a::SlidingTileState, b::SlidingTileState) = isequal(a, b)

"""
Convert an index into an array of length n
into its x and y indeces when indexed as a matrix.
"""
function ind2coord(i::Int, n::Int)
    y = mod1(i,n)
    x = div(i-y,n)+1
    return (x,y)
end

ordered_actions(search::SlidingTilePuzzle) = SlidingTileAction[UP, RIGHT, DOWN, LEFT]

function isdone(search::SlidingTilePuzzle, s::SlidingTileState)
    n = search.n
    if s.i != n^2
        return false
    end
    for i in 1 : n^2-1
        x,y = ind2coord(i,n)
        if s.grid[x,y] != i
            return false
        end
    end
    return true
end

function valid_actions(search::SlidingTilePuzzle, s::SlidingTileState)
    if isdone(search, s)
        return SlidingTileAction[]
    else
        return filter(a->transition(search, s, a) != s, ordered_actions(search))
    end
end

function transition(search::SlidingTilePuzzle, s::SlidingTileState, a::SlidingTileAction)
    n = search.n
    x, y = ind2coord(s.i, n)
    grid2 = deepcopy(s.grid)
    j = s.i
    if a == UP && y > 1
        j -= 1
    end
    if a == RIGHT && x < n
        j += n
    end
    if a == DOWN &&  y < n
        j += 1
    end
    if a == LEFT && x > 1
        j -= n
    end
    grid2[s.i], grid2[j] = grid2[j], grid2[s.i]
    return SlidingTileState(grid2, j)
end

function reward(search::SlidingTilePuzzle, s::SlidingTileState, a::SlidingTileAction)
    n = search.n
    x, y = ind2coord(s.i, n)
    r = 0.0
    s′ = transition(search, s, a)
    if s == s′
        return isdone(search, s) ? 0.0 : -Inf
    else
        return isdone(search, s′) ? 0.0 : -1.0
    end
end

function get_search_type(sliding::SlidingTilePuzzle)
    return Search(
        nothing,
        s -> valid_actions(sliding, s),
        (s,a) -> transition(sliding, s, a),
        (s,a) -> reward(sliding, s, a)
    )
end