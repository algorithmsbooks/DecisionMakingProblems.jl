function construct_gridworld_problem(γ::Float64 = 0.9)
    # north east south west
    directions = [(-1,0),(0,1),(1,0),(0,-1)]

    nS = 101 # 10x10 grid plus one terminal state
    nA = length(directions)

    T = zeros(Float64, nS, nA, nS)
    R = zeros(Float64, nS, nA)

    r_bump_outer_border = -1.0

    # Probability of going in intended direction
    p_intended = 0.7
    p_unintended = (1.0 - p_intended)/(nA-1)

    # i, j, reward
    special_state_rewards = Dict{Tuple{Int,Int}, Float64}(
        (8,9) =>  10.0,
        (3,8) =>   3.0,
        (5,4) =>  -5.0,
        (8,4) => -10.0)

    s_absorbing = 101

    for s in 1 : 100
        i = mod1(s, 10)
        j = div(s-1, 10)+1

        for (a,dir) in enumerate(directions)
            if !haskey(special_state_rewards, (i,j))
                # Transitioning from a normal tile.

                i′ = i + dir[1]
                j′ = j + dir[2]
                if i′ < 1 || i′ > 10 || j′ < 1 || j′ > 10
                    # Hit wall
                    i′ = i
                    j′ = j
                    R[s,a] += r_bump_outer_border*p_intended
                end
                s′ = i′ + (j′-1)*10
                T[s,a,s′] += p_intended
                # R[s,a] += get(special_state_rewards, (i′, j′), 0.0)*p_intended

                # Unintended transitions
                for dir2 in directions
                    if dir2 != dir
                        i′ = i + dir2[1]
                        j′ = j + dir2[2]
                        if i′ < 1 || i′ > 10 || j′ < 1 || j′ > 10
                            # Hit wall
                            i′ = i
                            j′ = j
                            R[s,a] += r_bump_outer_border*p_unintended
                        end
                        s′ = i′ + (j′-1)*10
                        T[s,a,s′] += p_unintended
                        # R[s,a] += get(special_state_rewards, (i′, j′), 0.0)*p_unintended
                    end
                end
            else
                # In absorbing states, your action automatically takes you to the absorbing state and you get the reward.
                T[s,a,s_absorbing] = 1.0
                R[s,a] += special_state_rewards[(i,j)]
            end
        end
    end

    # Absorbing state stays where it is
    for a in 1:nA
        T[s_absorbing,a,s_absorbing] = 1.0
    end

    return DiscreteMDP(T,R,γ)
end

const GridWorld = construct_gridworld_problem()