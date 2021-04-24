struct PredatorPreyHexWorldMG
    hexes::Vector{Tuple{Int, Int}}
    hexWorldDiscreteMDP::DiscreteMDP
end

n_agents(mg::PredatorPreyHexWorldMG) = 2

ordered_states(mg::PredatorPreyHexWorldMG, i::Int) = vec(collect(1:length(mg.hexes)))
ordered_states(mg::PredatorPreyHexWorldMG) = vec(collect(Iterators.product([ordered_states(mg, i) for i in 1:n_agents(mg)]...)))

ordered_actions(mg::PredatorPreyHexWorldMG, i::Int) = vec(collect(1:n_actions(mg.hexWorldDiscreteMDP)))
ordered_joint_actions(mg::PredatorPreyHexWorldMG) = vec(collect(Iterators.product([ordered_actions(mg, i) for i in 1:n_agents(mg)]...)))

n_actions(mg::PredatorPreyHexWorldMG, i::Int) = length(ordered_actions(mg, i))
n_joint_actions(mg::PredatorPreyHexWorldMG) = length(ordered_joint_actions(mg))

function transition(mg::PredatorPreyHexWorldMG, s, a, s′)
    # When a prey is caught (new prey born), it teleports to a random location and the predator remains (eating).
    # Otherwise, both transition following HexWorldMDP.
    if s[1] == s[2]
        prob = Float64(s′[1] == s[1]) / length(mg.hexes)
    else
        prob = mg.hexWorldDiscreteMDP.T[s[1], a[1], s′[1]] * mg.hexWorldDiscreteMDP.T[s[2], a[2], s′[2]]
    end
    return prob
end

function reward(mg::PredatorPreyHexWorldMG, i::Int, s, a)
    r = 0.0

    if i == 1
        # Predators get -1 for moving and 10 for catching the prey.
        if s[1] == s[2]
            return 10.0
        else
            return -1.0
        end
    elseif i == 2
        # Prey get -1 for moving and -100 for being caught.
        if s[1] == s[2]
            r = -100.0
        else
            r = -1.0
        end
    end

    return r
end

function joint_reward(mg::PredatorPreyHexWorldMG, s, a)
    return [reward(mg, i, s, a) for i in 1:n_agents(mg)]
end

function MG(mg::PredatorPreyHexWorldMG)
    return MG(
        mg.hexWorldDiscreteMDP.γ,
        vec(collect(1:n_agents(mg))),
        ordered_states(mg),
        [ordered_actions(mg, i) for i in 1:n_agents(mg)],
        (s, a, s′) -> transition(mg, s, a, s′),
        (s, a) -> joint_reward(mg, s, a)
    )
end

function PredatorPreyHexWorldMG(hexes::Vector{Tuple{Int,Int}},
                                r_bump_border::Float64,
                                p_intended::Float64,
                                γ::Float64)
    hexWorld = HexWorldMDP(hexes,
                           r_bump_border,
                           p_intended,
                           Dict{Tuple{Int64,Int64},Float64}(),
                           γ)
    mdp = hexWorld.mdp
    return PredatorPreyHexWorldMG(hexes, mdp)
end

# const CirclePredatorPreyHexWorld = PredatorPreyHexWorldMG(
#     [
#      (-1, 2), (0, 2),
#      (-1, 1), (1, 1),
#      (0, 0), (1, 0),
#      ],
#     HexWorldRBumpBorder,
#     HexWorldPIntended,
#     0.95
# )

function CirclePredatorPreyHexWorld()
    CirclePredatorPreyHexWorld = PredatorPreyHexWorldMG(
        [
         (-1, 2), (0, 2), (1, 2),
         (-1, 1), (1, 1), (3, 1), (4, 1),
         (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
         ],
        HexWorldRBumpBorder,
        HexWorldPIntended,
        0.95
    )
    return CirclePredatorPreyHexWorld
end

# const PredatorPreyHexWorld = PredatorPreyHexWorldMG(
#     [
#      (-1, 2), (0, 2), (1, 2),
#      (-1, 1), (1, 1), (3, 1), (4, 1),
#      (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
#      ],
#     HexWorldRBumpBorder,
#     HexWorldPIntended,
#     0.95
# )

function PredatorPreyHexWorld()
    PredatorPreyHexWorld = PredatorPreyHexWorldMG(
        [
         (-1, 2), (0, 2), (1, 2),
         (-1, 1), (1, 1), (3, 1), (4, 1),
         (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
         ],
        HexWorldRBumpBorder,
        HexWorldPIntended,
        0.95
    )
    return PredatorPreyHexWorld
end
