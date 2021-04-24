struct CollaborativePredatorPreyHexWorldDecPOMDP
    hexes::Vector{Tuple{Int, Int}}
    hexWorldDiscreteMDP::DiscreteMDP
end

n_agents(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = 2

ordered_states(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, i::Int) = vec(collect(1:length(decpomdp.hexes)))
ordered_states(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = vec(collect(Iterators.product([ordered_states(decpomdp, i) for i in 1:(n_agents(decpomdp) + 1)]...)))

ordered_actions(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, i::Int) = vec(collect(1:n_actions(decpomdp.hexWorldDiscreteMDP)))
ordered_joint_actions(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = vec(collect(Iterators.product([ordered_actions(decpomdp, i) for i in 1:n_agents(decpomdp)]...)))

n_actions(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, i::Int) = length(ordered_actions(decpomdp, i))
n_joint_actions(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = length(ordered_joint_actions(decpomdp))

ordered_observations(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, i::Int) = [true, false]
ordered_joint_observations(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = vec(collect(Iterators.product([ordered_observations(decpomdp, i) for i in 1:n_agents(decpomdp)]...)))

n_observations(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, i::Int) = length(ordered_observations(decpomdp, i))
n_joint_observations(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP) = length(ordered_joint_observations(decpomdp))

function transition(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, s, a, s′)
    prob = 0.0

    predator1Hex = decpomdp.hexes[s[1]]
    predator2Hex = decpomdp.hexes[s[2]]
    preyHex = decpomdp.hexes[s[3]]
    preyHex′ = decpomdp.hexes[s′[3]]

    preyValidHexes = vcat([preyHex],
                          [hex for hex in hex_neighbors(preyHex)
                           if hex in decpomdp.hexes && hex != predator1Hex && hex != predator2Hex])

    # When a prey is caught (new prey born), it teleports to a random location and the predator remains (eating).
    # Otherwise, both transition following HexWorldMDP.
    if s[1] == s[3] && s[2] == s[3]
        prob = Float64(s′[1] == s[1] && s′[2] == s[2]) / length(decpomdp.hexes)
    elseif s[1] == s[3] && s[2] != s[3]
        prob = (Float64(s′[1] == s[1])
                * decpomdp.hexWorldDiscreteMDP.T[s[2], a[2], s′[2]]
                / length(decpomdp.hexes))
    elseif s[1] != s[3] && s[2] == s[3]
        prob = (decpomdp.hexWorldDiscreteMDP.T[s[1], a[1], s′[1]]
                * Float64(s′[2] == s[2])
                / length(decpomdp.hexes))
    else
        prob = (decpomdp.hexWorldDiscreteMDP.T[s[1], a[1], s′[1]]
                * decpomdp.hexWorldDiscreteMDP.T[s[2], a[2], s′[2]]
                * Float64(preyHex′ in preyValidHexes) / length(preyValidHexes))
    end
    return prob
end

function joint_observation(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, a, s′, o)
    prob = 1.0

    predator1Hex = decpomdp.hexes[s′[1]]
    predator2Hex = decpomdp.hexes[s′[2]]
    preyHex = decpomdp.hexes[s′[3]]

    if predator1Hex == preyHex || preyHex in hex_neighbors(predator1Hex)
        if o[1] == true
            prob *= 1.0
        else
            prob *= 0.0
        end
    else
        if o[1] == false
            prob *= 1.0
        else
            prob *= 0.0
        end
    end

    if predator2Hex == preyHex || preyHex in hex_neighbors(predator2Hex)
        if o[2] == true
            prob *= 1.0
        else
            prob *= 0.0
        end
    else
        if o[2] == false
            prob *= 1.0
        else
            prob *= 0.0
        end
    end

    return prob
end

function reward(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP, s, a)
    r = 0.0

    # Predators get -1 for moving and 10 for catching the prey.
    if s[1] == s[3] || s[2] == s[3]
        return 10.0
    else
        return -1.0
    end

    return r
end

function DecPOMDP(decpomdp::CollaborativePredatorPreyHexWorldDecPOMDP)
    return DecPOMDP(
        decpomdp.hexWorldDiscreteMDP.γ,
        vec(collect(1:n_agents(decpomdp))),
        ordered_states(decpomdp),
        [ordered_actions(decpomdp, i) for i in 1:n_agents(decpomdp)],
        [ordered_observations(decpomdp, i) for i in 1:n_agents(decpomdp)],
        (s, a, s′) -> transition(decpomdp, s, a, s′),
        (a, s′, o) -> joint_observation(decpomdp, a, s′, o),
        (s, a) -> reward(decpomdp, s, a)
    )
end

function CollaborativePredatorPreyHexWorldDecPOMDP(hexes::Vector{Tuple{Int,Int}},
                                r_bump_border::Float64,
                                p_intended::Float64,
                                γ::Float64)
    hexWorld = HexWorldMDP(hexes,
                           r_bump_border,
                           p_intended,
                           Dict{Tuple{Int64,Int64},Float64}(),
                           γ)
    mdp = hexWorld.mdp
    return CollaborativePredatorPreyHexWorldDecPOMDP(hexes, mdp)
end

# const SimpleCollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
#     [
#          (0, 1),
#      (0, 0), (1, 0),
#      ],
#     HexWorldRBumpBorder,
#     HexWorldPIntended,
#     0.95
# )

function SimpleCollaborativePredatorPreyHexWorld()
    SimpleCollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
        [
             (0, 1),
         (0, 0), (1, 0),
         ],
        HexWorldRBumpBorder,
        HexWorldPIntended,
        0.95
    )
    return SimpleCollaborativePredatorPreyHexWorld
end

# const CircleCollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
#     [
#          (-1, 2), (0, 2),
#      (-1, 1),         (1, 1),
#          (0, 0), (1, 0),
#      ],
#     HexWorldRBumpBorder,
#     HexWorldPIntended,
#     0.95
# )

function CircleCollaborativePredatorPreyHexWorld()
    CircleCollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
        [
             (-1, 2), (0, 2),
         (-1, 1),         (1, 1),
             (0, 0), (1, 0),
         ],
        HexWorldRBumpBorder,
        HexWorldPIntended,
        0.95
    )
    return CircleCollaborativePredatorPreyHexWorld
end

# const CollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
#     [
#      (-1, 2), (0, 2), (1, 2),
#      (-1, 1), (1, 1), (3, 1), (4, 1),
#      (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
#      ],
#     HexWorldRBumpBorder,
#     HexWorldPIntended,
#     0.95
# )

function CollaborativePredatorPreyHexWorld()
    CollaborativePredatorPreyHexWorld = CollaborativePredatorPreyHexWorldDecPOMDP(
        [
         (-1, 2), (0, 2), (1, 2),
         (-1, 1), (1, 1), (3, 1), (4, 1),
         (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
         ],
        HexWorldRBumpBorder,
        HexWorldPIntended,
        0.95
    )
    return CollaborativePredatorPreyHexWorld
end
