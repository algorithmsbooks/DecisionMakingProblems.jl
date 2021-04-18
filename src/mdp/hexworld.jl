function hex_neighbors(hex::Tuple{Int,Int})
    i,j = hex
    [(i+1,j),(i,j+1),(i-1,j+1),(i-1,j),(i,j-1),(i+1,j-1)]
end

struct HexWorldMDP
    # Problem has |hexes| + 1 states, where last state is consuming.
    hexes::Vector{Tuple{Int,Int}}

    # The exact same problem as a DiscreteMDP
    mdp::DiscreteMDP

    # The special hex rewards used to construct the MDP
    special_hex_rewards::Dict{Tuple{Int,Int}, Float64}

    function HexWorldMDP(
        hexes::Vector{Tuple{Int,Int}},
        r_bump_border::Float64,
        p_intended::Float64,
        special_hex_rewards::Dict{Tuple{Int,Int}, Float64},
        γ::Float64,
        )

        nS = length(hexes) + 1 # Hexes plus one terminal state
        nA = 6 # Six directions. 1 is east, 2 is north east, 3 is north west, etc.
               # As enumerated in hex_neighbors.

        s_absorbing = nS

        T = zeros(Float64, nS, nA, nS)
        R = zeros(Float64, nS, nA)

        p_veer = (1.0 - p_intended)/2 # Odds of veering left or right.

        for s in 1 : length(hexes)
            hex = hexes[s]
            if !haskey(special_hex_rewards, hex)
                # Action taken from a normal tile
                neighbors = hex_neighbors(hex)
                for (a,neigh) in enumerate(neighbors)
                    # Indended transition.
                    s′ = findfirst(h -> h == neigh, hexes)
                    if s′ == nothing
                        # Off the map!
                        s′ = s
                        R[s,a] += r_bump_border*p_intended
                    end
                    T[s,a,s′] += p_intended

                    # Unintended veer left.
                    a_left = mod1(a+1, nA)
                    neigh_left = neighbors[a_left]
                    s′ = findfirst(h -> h == neigh_left, hexes)
                    if s′ == nothing
                        # Off the map!
                        s′ = s
                        R[s,a] += r_bump_border*p_veer
                    end
                    T[s,a,s′] += p_veer

                    # Unintended veer right.
                    a_right = mod1(a-1, nA)
                    neigh_right = neighbors[a_right]
                    s′ = findfirst(h -> h == neigh_right, hexes)
                    if s′ == nothing
                        # Off the map!
                        s′ = s
                        R[s,a] += r_bump_border*p_veer
                    end
                    T[s,a,s′] += p_veer
                end
            else
                # Action taken from an absorbing hex
                # In absorbing hex, your action automatically takes you to the absorbing state and you get the reward.
                for a in 1 : nA
                    T[s,a,s_absorbing] = 1.0
                    R[s,a] += special_hex_rewards[hex]
                end
            end
        end

        # Absorbing state stays where it is and gets no reward.
        for a in 1 : nA
            T[s_absorbing,a,s_absorbing] = 1.0
        end

        mdp = DiscreteMDP(T,R,γ)

        return new(hexes, mdp, special_hex_rewards)
    end
end

const HexWorldRBumpBorder = -1.0 # Reward for falling off hex map
const HexWorldPIntended = 0.7 # Probability of going intended direction
const HexWorldDiscountFactor = 0.9
const HexWorld = HexWorldMDP(
    [(0,0),(1,0),(2,0),(3,0),(0,1),(1,1),(2,1),(-1,2),
     (0,2),(1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),
     (8,2),(4,1),(5,0),(6,0),(7,0),(7,1),(8,1),(9,0)],
    HexWorldRBumpBorder,
    HexWorldPIntended,
    Dict{Tuple{Int,Int}, Float64}(
        (0,1)=>  5.0, # left side reward
        (2,0)=>-10.0, # left side hazard
        (9,0)=> 10.0, # right side reward
    ),
    HexWorldDiscountFactor
)

const StraightLineHexWorld = HexWorldMDP(
    [(0,0),(1,0),(2,0),(3,0),(4,0),(5,0),(6,0)],
    HexWorldRBumpBorder,
    HexWorldPIntended,
    Dict{Tuple{Int,Int}, Float64}(
        (6,0)=> 10.0, # right side reward
    ),
    HexWorldDiscountFactor
)

n_states(mdp::HexWorldMDP) = n_states(mdp.mdp)
n_actions(mdp::HexWorldMDP) = n_actions(mdp.mdp)
discount(mdp::HexWorldMDP) = discount(mdp.mdp)
ordered_states(mdp::HexWorldMDP) = ordered_states(mdp.mdp)
ordered_actions(mdp::HexWorldMDP) = ordered_actions(mdp.mdp)
state_index(mdp::HexWorldMDP, s::Int) = s

transition(mdp::HexWorldMDP, s::Int, a::Int) = transition(mdp.mdp, s, a)
generate_s(mdp::HexWorldMDP, s::Int, a::Int) = generate_s(mdp.mdp, s, a)
reward(mdp::HexWorldMDP, s::Int, a::Int) = reward(mdp.mdp, s, a)
generate_sr(mdp::HexWorldMDP, s::Int, a::Int) = (generate_s(mdp, s, a), reward(mdp,s,a))

generate_start_state(mdp::HexWorldMDP) = rand(1:(n_states(mdp)-1)) # non-terminal state

function hex_distance(a::Tuple{Int,Int}, b::Tuple{Int,Int})
    az = -a[1] - a[2]
    bz = -b[1] - b[2]
    return max(abs(a[1] - b[1]), abs(a[2] - b[2]), abs(az - bz))
end

function DiscreteMDP(mdp::HexWorldMDP)
    return mdp.mdp
end
