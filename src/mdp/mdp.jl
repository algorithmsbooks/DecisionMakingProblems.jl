struct MDP
    γ  # discount factor
    𝒮  # state space
    𝒜  # action space
    T  # transition function
    R  # reward function
    TR # sample transition and reward
end

MDP(γ, 𝒮, 𝒜, T, R) = MDP(γ, 𝒮, 𝒜, T, R, nothing)

function MDP(T::Array{Float64, 3}, R::Array{Float64, 2}, γ::Float64)
    MDP(γ, 1:size(R,1), 1:size(R,2), (s,a,s′)->T[s,a,s′], (s,a)->R[s,a], nothing)
end

function MDP(T::Array{Float64, 3}, R, γ::Float64)
    MDP(γ, 1:size(T,1), 1:size(T,2), (s,a,s′)->T[s,a,s′], R, nothing)
end

struct MDPInitialStateDistribution{MDP}
    mdp::MDP
end
Base.rand(S::MDPInitialStateDistribution) = generate_start_state(S.mdp)

function get_mdp_type(mdp; γ::Float64=discount(mdp))
    return MDP(
        γ,
        ordered_states(mdp),
        ordered_actions(mdp),
        (s,a, s′=nothing) -> begin
            S′ = transition(mdp, s, a)
            if s′ == nothing
                return S′
            end
            return pdf(S′, s′)
        end,
        (s,a) -> reward(mdp, s, a),
        (s, a)->begin
            s′ = rand(transition(mdp,s,a))
            r = reward(mdp, s, a)
            return (s′, r)
        end
    )
end