struct DiscretePOMDP
    # TODO: Use sparse matrices?
    T::Array{Float64, 3} # T(s,a,s′)
    R::Array{Float64, 2} # R(s,a) = ∑_s' R(s,a,s')*T(s,a,s′)
    O::Array{Float64, 3} # O(a,s′,o)
    γ::Float64
end

n_states(pomdp::DiscretePOMDP) = size(pomdp.T, 1)
n_actions(pomdp::DiscretePOMDP) = size(pomdp.T, 2)
n_observations(pomdp::DiscretePOMDP) = size(pomdp.O, 3)
discount(pomdp::DiscretePOMDP) = pomdp.γ

ordered_states(pomdp::DiscretePOMDP) = collect(1:n_states(pomdp))
ordered_actions(pomdp::DiscretePOMDP) = collect(1:n_actions(pomdp))
ordered_observations(pomdp::DiscretePOMDP) = collect(1:n_observations(pomdp))

transition(pomdp::DiscretePOMDP, s::Int, a::Int) = Categorical(pomdp.T[s,a,:])
observation(pomdp::DiscretePOMDP, a::Int, s′::Int) = Categorical(pomdp.O[a,s′,:])
reward(pomdp::DiscretePOMDP, s::Int, a::Int) = pomdp.R[s,a]

reward(pomdp::DiscretePOMDP, b::Vector{Float64}, a::Int) = sum(reward(pomdp,s,a)*b[s] for s in ordered_states(pomdp))

function POMDP(pomdp::DiscretePOMDP; γ::Float64=discount(pomdp))
    return POMDP(
        γ,
        ordered_states(pomdp),
        ordered_actions(pomdp),
        ordered_observations(pomdp),
        (s,a, s′=nothing) -> begin
            S′ = transition(pomdp, s, a)
            if s′ == nothing
                return S′
            end
            return pdf(S′, s′)
        end,
        (s,a) -> reward(pomdp, s, a),
        (a,s′,o=nothing) -> begin
            O′ = observation(pomdp, a, s′)
            if o == nothing
                return O′
            end
            return pdf(O′, o)
        end,
        (s, a)->begin
            s′ = rand(transition(pomdp,s,a))
            r = reward(pomdp, s, a)
            o = rand(observation(pomdp,a,s′))
            return (s′, r, o)
        end
    )
end
