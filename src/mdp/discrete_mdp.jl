struct DiscreteMDP
    # TODO: Use sparse matrices?
    T::Array{Float64, 3} # T(s,a,s′)
    R::Array{Float64, 2} # R(s,a) = ∑_s' R(s,a,s')*T(s,a,s′)
    γ::Float64
end

n_states(mdp::DiscreteMDP) = size(mdp.T, 1)
n_actions(mdp::DiscreteMDP) = size(mdp.T, 2)
discount(mdp::DiscreteMDP) = mdp.γ
ordered_states(mdp::DiscreteMDP) = collect(1:n_states(mdp))
ordered_actions(mdp::DiscreteMDP) = collect(1:n_actions(mdp))
state_index(mdp::DiscreteMDP, s::Int) = s

function transition(mdp::DiscreteMDP, s::Int, a::Int)
    return Categorical(mdp.T[s,a,:])
end
function generate_s(mdp::DiscreteMDP, s::Int, a::Int)
    s′ = 1
    r = rand() - mdp.T[s,a,s′]
    while r > 0.0 && s′ < size(mdp.T, 3)
        s′ += 1
        r -= mdp.T[s,a,s′]
    end
    return s′
end
reward(mdp::DiscreteMDP, s::Int, a::Int) = mdp.R[s,a]

function MDP(mdp::DiscreteMDP; γ::Float64=discount(mdp))
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
