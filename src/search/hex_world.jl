struct HexWorldSearchProblem
    # Problem has |hexes| states.
    hexes::Vector{Tuple{Int,Int}}

    # Rewards for entering the obsorbing hexes.
    absorbing_hex_rewards::Dict{Tuple{Int,Int}, Float64}
end

n_states(search::HexWorldSearchProblem) = length(search.hexes)
n_actions(search::HexWorldSearchProblem) = 6 # 1 is east, 2 is north east, 3 is north west, etc.
ordered_states(search::HexWorldSearchProblem) = search.hexes
ordered_actions(search::HexWorldSearchProblem) = collect(1:6)

function transition(search::HexWorldSearchProblem, s::Tuple{Int,Int}, a::Int)
    if !haskey(search.absorbing_hex_rewards, s)
        # Action taken in a normal hex
        neighbor = hex_neighbors(s)[a]
        if neighbor ∈ search.hexes
            # We transition to the neighboring hex
            return neighbor
        else
            # No transition. We bump into the border
            return s
        end
    else
        # Action taken in an absorbing hex
        # No transition
        return s
    end
end

function reward(search::HexWorldSearchProblem, s::Tuple{Int,Int}, a::Int)
    if !haskey(search.absorbing_hex_rewards, s)
        # Action taken in a normal hex
        neighbor = hex_neighbors(s)[a]
        if neighbor ∈ search.hexes
            # We transition to the neighboring hex
            return -1.0 + get(search.absorbing_hex_rewards, neighbor, 0.0)
        end
    else
        # Action taken in an absorbing hex
        # No reward
        return 0.0
    end
end

isdone(search::HexWorldSearchProblem, s::Tuple{Int,Int}) = haskey(search.absorbing_hex_rewards, s)

function valid_actions(search::HexWorldSearchProblem, s::Tuple{Int,Int})
    if isdone(search, s)
        return SlidingTileAction[]
    else
        neighbors = hex_neighbors(s)
        return filter(a->neighbors[a] ∈ search.hexes, ordered_actions(search))
    end
end

function get_search_type(search::HexWorldSearchProblem)
    return Search(
        ordered_states(search),
        s -> valid_actions(search, s),
        (s,a) -> transition(search, s, a),
        (s,a) -> reward(search, s, a)
    )
end

const HiveHexWorldSearchProblem = HexWorldSearchProblem(
    [
                (-1,6),(0,6),(1,6),(2,6),
           (-1,5),(0,5),(1,5),(2,5),(3,5),
         (-1,4),(0,4),(1,4),(2,4),(3,4),(4,4),
     (-1,3),(0,3),(1,3),(2,3),(3,3),(4,3),(5,3),
         (0,2),(1,2),(2,2),(3,2),(4,2),(5,2),
           (1,1),(2,1),(3,1),(4,1),(5,1),
              (2,0),(3,0),(4,0),(5,0),
    ],
    Dict{Tuple{Int,Int}, Float64}(
        (4,3) =>  5.0,
    ),
)