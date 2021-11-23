@with_kw struct CollisionAvoidance
    ddh_max::Float64 = 1.0 # vertical acceleration limit [m/s²]
    collision_threshold::Float64 = 50.0 # collision threshold [m]
    reward_collision::Float64 = -1.0 # reward obtained if collision occurs
    reward_change::Float64 = -0.01 # reward obtained if action changes
    𝒜::Vector{Float64} = [-5.0, 0.0, 5.0] # Available actions to command for vertical rate [m/s]
    # The transition distribution produces successor states
    # with dh noise with the below probabilities.
    Pν::SetCategorical{Float64} = SetCategorical([2.0, 0.0, -2.0], [0.25, 0.5, 0.25])
end

struct CollisionAvoidanceState
    h::Float64 # vertical separation [m]
    dh::Float64 # rate of change of h [m/s]
    a_prev::Float64 # previous acceleration [m/s²]
    τ::Float64 # horizontal separation time [s]
end

Base.vec(s::CollisionAvoidanceState) = [s.h, s.dh, s.a_prev, s.τ]

function transition(𝒫::CollisionAvoidance, s::CollisionAvoidanceState, a::Float64)
    h = s.h + s.dh
    dh = s.dh
    if a != 0.0
        if abs(a - dh) < 𝒫.ddh_max
            dh += a
        else
            dh += sign(a - dh)*𝒫.ddh_max
        end
    end
    a_prev = a
    τ = max(s.τ - 1.0, -1.0)
    states = [
        CollisionAvoidanceState(h, dh + ν, a_prev, τ) for ν in 𝒫.Pν.elements
    ]
    return SetCategorical(states, 𝒫.Pν.distr.p)
end

is_terminal(𝒫::CollisionAvoidance, s::CollisionAvoidanceState) = s.τ < 0.0

function reward(𝒫::CollisionAvoidance, s::CollisionAvoidanceState, a::Float64)
    r = 0.0
    if abs(s.h) < 𝒫.collision_threshold && abs(s.τ) < eps()
        # We collided
        r += 𝒫.reward_collision
    end
    if a != s.a_prev
        # We changed our action
        r += 𝒫.reward_change
    end
    return r
end

@with_kw struct CollisionAvoidanceStateDistribution
    a_prev = 0.0
    h = Uniform(-200, 200)
    dh = Uniform(-10, 10)
    tau = 40.0
end

function rand(b::CollisionAvoidanceStateDistribution)
    return CollisionAvoidanceState(Distributions.rand(b.h), Distributions.rand(b.dh), b.a_prev, b.tau)
end

@with_kw struct SimpleCollisionAvoidancePolicy
    thresh_h = 50
    thresh_τ = 30
    𝒜 = (up = 5.0, down = -5.0, noalert = 0.0)
end

struct OptimalCollisionAvoidancePolicy
    𝒜
    grid
    Q
end

function OptimalCollisionAvoidancePolicy(mdp = CollisionAvoidance())
    𝒜 = mdp.𝒜

    hs = range(-200, 200, length=21) # discretization of h in m
    dhs = range(-10, 10, length=21) # discretization of dh in m/s
    τs = range(0, 40, length=41) # discretization of τ in s

    # Discretization grid
    grid = GridInterpolations.RectangleGrid(hs, dhs, 𝒜, τs)

    # State space
    𝒮 = [CollisionAvoidanceState(h, dh, a_prev, τ) for h in hs, dh in dhs, a_prev in mdp.𝒜, τ in τs]

    # State value function
    U = zeros(length(𝒮))

    # State-action value function
    Q = [zeros(length(𝒮)) for a in mdp.𝒜]

    # Solve with backwards induction value iteration
    for (si, s) in enumerate(𝒮)
        for (ai, a) in enumerate(mdp.𝒜)
            Tsa = transition(mdp, s, a)
            Q[ai][si] = reward(mdp, s, a)
            Q[ai][si] += sum(is_terminal(mdp, s′) ? 0.0 : Tsa.distr.p[j]*GridInterpolations.interpolate(grid, U, vec(s′)) for (j, s′) in enumerate(Tsa.elements))
        end
        U[si] = maximum(q[si] for q in Q)
    end
    return OptimalCollisionAvoidancePolicy(mdp.𝒜, grid, Q)
end

function action(policy::OptimalCollisionAvoidancePolicy, s::CollisionAvoidanceState)
    vec_s = vec(s)
    a_best = first(policy.𝒜)
    q_best = -Inf
    for (a,q) in zip(policy.𝒜, policy.Q)
        q = GridInterpolations.interpolate(policy.grid, q, vec_s)
        if q > q_best
            a_best, q_best = a, q
        end
    end
    return a_best
end

function (policy::OptimalCollisionAvoidancePolicy)(s::CollisionAvoidanceState)
    return action(policy, s)
end

function action(policy::SimpleCollisionAvoidancePolicy, s::CollisionAvoidanceState)
    if abs(s.h) < policy.thresh_h && s.τ < policy.thresh_τ
        return (s.h > 0.0) ? policy.𝒜.up : policy.𝒜.down
    end
    return policy.𝒜.noalert
end

function (policy::SimpleCollisionAvoidancePolicy)(s::CollisionAvoidanceState)
    return action(policy, s)
end


struct CollisionAvoidanceValueFunction
    grid
    U
end

function CollisionAvoidanceValueFunction(𝒫::CollisionAvoidance, policy)
    𝒜 = 𝒫.𝒜

    hs = range(-200, 200, length=21) # discretization of h in m
    dhs = range(-10, 10, length=21) # discretization of dh in m/s
    τs = range(0, 40, length=41) # discretization of τ in s

    # Discretization grid
    grid = GridInterpolations.RectangleGrid(hs, dhs, 𝒜, τs)

    # State space
    𝒮 = [CollisionAvoidanceState(h, dh, a_prev, τ) for h in hs, dh in dhs, a_prev in 𝒫.𝒜, τ in τs]

    # State value function
    U = zeros(length(𝒮))

    # Solve with backwards induction value iteration
    for (si, s) in enumerate(𝒮)
        a = action(policy, s)
        Tsa = transition(𝒫, s, a)
        q = reward(𝒫, s, a)
        q += sum(is_terminal(𝒫, s′) ? 0.0 : Tsa.distr.p[j]*GridInterpolations.interpolate(grid, U, vec(s′)) for (j, s′) in enumerate(Tsa.elements))
        U[si] = q
    end
    return CollisionAvoidanceValueFunction(grid, U)
end

function (U::CollisionAvoidanceValueFunction)(s)
    return GridInterpolations.interpolate(U.grid, U.U, vec(s))
end

function MDP(mdp::CollisionAvoidance; γ::Float64=1.0)
    return MDP(
            γ,
            nothing, # no ordered states
            mdp.𝒜,
            (s,a) -> transition(mdp,s,a), # no probabilistic transition function
            (s,a) -> reward(mdp, s, a),
            (s,a)->begin
                s′ = rand(transition(mdp,s,a))
                r = reward(mdp, s, a)
                return (s′, r)
            end
        )
end
