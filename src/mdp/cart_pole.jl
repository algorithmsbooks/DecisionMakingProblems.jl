# State: 4 continuous variables
#   cart position:      ∈ [-4.8, 4.8]
#   cart speed:         ∈ [-Inf, Inf]
#   pole angle:         ∈ [-24°, 24°]
#   pole rotation rate: ∈ [-Inf, Inf]

# Action: Push cart right (1) or left (2)

struct CartPole
    γ::Float64
    force_magnitude::Float64
    pole_length::Float64 # Distance from pole to mass at end of pole
    mass_cart::Float64
    mass_pole::Float64
    gravity::Float64
    Δt::Float64  # Time to advance by with each step
    Δx_max::Float64 # Max position deviation
    Δθ_max::Float64 # Max angular deviation
end

const CART_POLE = CartPole(1.0, 10.0, 1.0, 1.0, 0.1, 9.8, 0.02, 4.8, deg2rad(24))

struct CartPoleState
    x::Float64 # cart pos [m]
    v::Float64 # cart speed [m/s]
    θ::Float64 # pole angle [rad]
    ω::Float64 # pole rotation range [rad/s]
end

n_actions(mdp::CartPole) = 2
discount(mdp::CartPole) = mdp.γ
ordered_actions(mdp::CartPole) = [1,2]

Base.vec(s::CartPoleState) = [s.x, s.v, s.θ, s.ω]

function generate_start_state(mdp::CartPole)
    U = Uniform(-0.05,0.05)
    return CartPoleState(rand(U), rand(U), rand(U), rand(U))
end

function is_terminal(mdp::CartPole, s::CartPoleState)
    return abs(s.x) > mdp.Δx_max || abs(s.θ) > mdp.Δθ_max
end

function cart_pole_transition(mdp::CartPole, s::CartPoleState, a::Int)
    @assert(1 <= a <= 2)

    if is_terminal(mdp, s)
        return s
    end

    x, v, θ, ω = s.x, s.v, s.θ, s.ω
    force = a == 1 ? mdp.force_magnitude : -mdp.force_magnitude

    cθ, sθ = cos(θ), sin(θ)
    half_length = mdp.pole_length / 2
    mass_tot = mdp.mass_cart + mdp.mass_pole
    temp = (force + half_length*sθ*ω^2) / mass_tot

    # Pole acceleration
    pole_α = (mdp.gravity*sθ - temp*cθ) / (half_length * (4.0/3.0 - mdp.mass_pole * cθ^2 / mass_tot))

    # Cart acceleration
    cart_a = temp - half_length * mdp.mass_pole * pole_α * cθ / mass_tot

    # Euler integration
    Δt = mdp.Δt
    x += Δt*v
    v += Δt*cart_a
    θ += Δt*ω
    ω += Δt*pole_α

    return CartPoleState(x,v,θ,ω)
end

function reward(mdp::CartPole, s::CartPoleState, a::Int)
    @assert(1 <= a <= 2)
    if is_terminal(mdp, s)
        return 0.0
    else
        return 1.0
    end
end

function get_mdp_type(mdp::CartPole; γ::Float64=mdp.γ)
    return MDP(
            γ,
            nothing, # no ordered states
            ordered_actions(mdp),
            nothing, # no probabilistic transition function
            (s,a) -> reward(mdp, s, a),
            (s, a)->begin
                s′ = cart_pole_transition(mdp, s, a)
                r = reward(mdp, s, a)
                return (s′, r)
            end
        )
end
