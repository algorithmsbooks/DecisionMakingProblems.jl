function Catch(; γ::Float64=0.9)
    Θ = [20,40,60,80] # proficiencies
    𝒜 = collect(10:10:100) # throw distances

    nS = length(Θ)
    nA = length(𝒜)
    nO = 2 # catch or not

    T = zeros(nS, nA, nS)
    R = Array{Float64}(undef, nS, nA)
    O = Array{Float64}(undef, nA, nS, nO)

    o_catch = 1
    o_drop = 2

    prob_catch(d,θ) = 1 - 1/(1+exp(-(d-θ)/15))

    # Transition dynamics are 100% stationary.
    for si in 1:nS
        for ai in 1:nA
            T[si, ai, si] = 1.0
        end
    end

    # Reward equal to distance caught
    for (si,θ) in enumerate(Θ)
        for (ai,d) in enumerate(𝒜)
            R[si,ai] = d*prob_catch(d,θ) # distance caught times prob of catch
        end
    end

    # Observation is based on whether we caught or not.
    for (ai,d) in enumerate(𝒜)
        for (si′,θ) in enumerate(Θ)
            O[ai,si′,o_catch] = prob_catch(d,θ)
            O[ai,si′,o_drop] = 1 - O[ai,si′,o_catch]
        end
    end

    return DiscretePOMDP(T, R, O, γ)
end

# const Catch = generate_catch_pomdp(0.9)
