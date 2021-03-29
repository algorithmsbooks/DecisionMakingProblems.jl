struct YouGetWhatYouBetMDP
    α::Float64
    γ::Float64
end

n_states(mdp::YouGetWhatYouBetMDP) = 1
n_actions(mdp::YouGetWhatYouBetMDP) = Inf
discount(mdp::YouGetWhatYouBetMDP) = mdp.γ
ordered_states(mdp::YouGetWhatYouBetMDP) = Int[1]
state_index(mdp::YouGetWhatYouBetMDP, s::Int) = s

generate_s(mdp::YouGetWhatYouBetMDP, s::Int, a::Float64) = 1
generate_start_state(mdp::YouGetWhatYouBetMDP) = 1
function transition(mdp::YouGetWhatYouBetMDP, s::Int, a::Float64)
    return Categorical([1.0])
end
reward(mdp::YouGetWhatYouBetMDP, s::Int, a::Float64) = a^mdp.α

function get_mdp_type(mdp::YouGetWhatYouBetMDP; γ::Float64=mdp.γ)
    return MDP(
            γ,
            ordered_states(mdp),
            nothing, # infinite actions
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

const STATIC_1D_GAUSSIAN_POLICY = (θ::Vector{Float64}, s) -> begin
        return Normal(θ[1], abs(θ[2]))
    end
const STATIC_1D_GAUSSIAN_POLICY_∇ = (θ::Vector{Float64}, a::Float64, s::Int) -> begin
        λ = θ[1]
        σ = θ[2] # note: standard dev would be abs(θ[2])
        ∇₁ = (a - λ)*exp(-(a-λ)^2/(2*σ^2)) / (sqrt(2π)*abs(σ)^3)
        ∇₂ = sign(σ)*exp(-(a-λ)^2/(2*σ^2)) * ((a-λ)^2 - σ^2)/(sqrt(2π)*σ^4)
        if abs(σ) < 1e-6
            ∇₁ = 0.0
            ∇₂ = 0.0
        end
        return [∇₁, ∇₂]
    end
const STATIC_1D_GAUSSIAN_POLICY_∇logπ = (θ::Vector{Float64}, a::Float64, s::Int) -> begin
        ∇₁ = (a - θ[1]) / θ[2]^2
        ∇₂ = ((a-θ[1])^2 - θ[2]^2)/(θ[2]^3)
        return [∇₁, ∇₂]
    end
const STATIC_1D_GAUSSIAN_POLICY_KLDIV = (θ::Vector{Float64}, θ′::Vector{Float64}, s::Int) -> begin
        μ₁ = θ[1]
        μ₂ = θ′[1]
        ν₁ = (θ[2])^2
        ν₂ = (θ′[2])^2
        return log(ν₂/ν₁) + (ν₁ + (μ₁ - μ₂)^2)/(2ν₂) - 1/2
    end
const STATIC_1D_GAUSSIAN_POLICY_H_KL = (θ::Vector{Float64}, θ′::Vector{Float64}, s::Int) -> begin
        n = length(θ)
        F = zeros(Float64,n,n)
        F[1,1] = 1/(θ′[2])^2
        F[2,1] = F[1,2] = 2*(θ[1] - θ′[1])/(θ′[2])^3
        F[2,2] = 3*((θ[1] - θ′[1])^2 + (θ[2])^2)/(θ′[2])^4 - 2/(θ′[2])^2
        return F
    end