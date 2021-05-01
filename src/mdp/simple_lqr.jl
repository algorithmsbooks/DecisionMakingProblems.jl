@with_kw struct LQR
    γ::Float64 = 1.0
end

discount(mdp::LQR) = mdp.γ

generate_start_state(mdp::LQR) = rand(Normal(0.3,0.1))

function transition(mdp::LQR, s::Float64, a::Float64)
    # NOTE: Truncated to prevent going off to infinity with poor policies
    return Truncated(Normal(s + a, 0.1), -10.0, 10.0)
end
reward(mdp::LQR, s::Float64, a::Float64) = -s^2

function MDP(mdp::LQR; γ::Float64=mdp.γ)
    return MDP(
            γ,
            nothing, # continuous state
            nothing, # continuous action space
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

const LINEAR_1D_GAUSSIAN_POLICY = (θ::Vector{Float64}, s::Float64) -> begin
            λ = θ[1]
            σ = abs(θ[2]) + 0.00001
            return Normal(λ*s, σ)
        end
const LINEAR_1D_GAUSSIAN_POLICY_∇ = (θ::Vector{Float64}, a::Float64, s::Float64) -> begin
            λ = θ[1]
            σ = θ[2] # note: standard dev would be abs(θ[2])
            ∇₁ = s*(a - λ*s)*exp(-(a-λ*s)^2/(2*σ^2)) / (sqrt(2π)*abs(σ)^3)
            ∇₂ = sign(σ)*exp(-(a-λ*s)^2/(2*σ^2)) * ((a-λ*s)^2 - σ^2)/(sqrt(2π)*σ^4)
            if abs(σ) < 1e-6
                ∇₁ = 0.0
                ∇₂ = 0.0
            end
            return [∇₁, ∇₂]
        end
const LINEAR_1D_GAUSSIAN_POLICY_∇logπ = (θ::Vector{Float64}, a::Float64, s::Float64) -> begin
            λ = θ[1]
            σ = θ[2]
            ∇₁ = (a*s - λ*s^2) / (σ^2)
            ∇₂ = (a^2-2a*λ*s - σ^2 + λ^2*s^2)/(σ^3)
            if abs(σ) < 1e-6
                ∇₁ = 0.0
                ∇₂ = 0.0
            end
            return [∇₁, ∇₂]
        end
const LINEAR_1D_GAUSSIAN_POLICY_KLDIV = (θ::Vector{Float64}, θ′::Vector{Float64}, s::Float64) -> begin
            μ₁ = θ[1]*s
            μ₂ = θ′[1]*s
            σ₁ = abs(θ[2])
            σ₂ = abs(θ′[2])
            return log(σ₂/σ₁) + (σ₁^2 + (μ₁ - μ₂)^2)/(2*σ₂^2) - 1/2
        end
const LINEAR_1D_GAUSSIAN_POLICY_H_KL = (θ::Vector{Float64}, θ′::Vector{Float64}, s::Float64) -> begin
            F = zeros(Float64,2,2)
            λ₁ = θ[1]
            λ₂ = θ′[1]
            σ₁ = θ[2]
            σ₂ = θ′[2]
            F[1,1] = s^2/(σ₂^2)
            F[2,1] = F[1,2] = 2*s^2*(λ₁ - λ₂)/(σ₂^3)
            F[2,2] = 3*((λ₁ - λ₂)^2*s^2+σ₁^2)/(σ₂^4) - 1/(σ₂)^2
            return F
        end
