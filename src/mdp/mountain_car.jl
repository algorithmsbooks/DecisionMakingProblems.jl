const MOUNTAIN_CAR_STATE_MINS = [-1.2, -0.07]
const MOUNTAIN_CAR_STATE_MAXS = [ 0.6,  0.07]
const MOUNTAIN_CAR_ACCELS = [-1.0, 0.0, 1.0]
const MOUNTAIN_CAR_START_STATE = [-0.5, 0.0]

@with_kw struct MountainCar
    γ::Float64 = 1.0
end

n_actions(mdp::MountainCar) = length(MOUNTAIN_CAR_ACCELS)
discount(mdp::MountainCar) = mdp.γ
ordered_actions(mdp::MountainCar) = collect(1:length(MOUNTAIN_CAR_ACCELS))

function generate_start_state(mdp::MountainCar)
    s = MOUNTAIN_CAR_STATE_MINS[1] + rand() * (MOUNTAIN_CAR_STATE_MAXS[1] - MOUNTAIN_CAR_STATE_MINS[1])
    v = MOUNTAIN_CAR_STATE_MINS[2] + rand() * (MOUNTAIN_CAR_STATE_MAXS[2] - MOUNTAIN_CAR_STATE_MINS[2])
    return [s,v]
end

# NOTE: Mountain car is deterministic, so we don't get a transition
#       function that produces a probability distribution.
function mountain_car_transition(s::Vector{Float64}, a::Int)
    x, v = s[1], s[2]
    if x < 0.6
        accel = MOUNTAIN_CAR_ACCELS[a]
        v = v + accel*0.001 + cos(3x)*-0.0025
        x = x + v

        x = clamp(x, MOUNTAIN_CAR_STATE_MINS[1], MOUNTAIN_CAR_STATE_MAXS[1])
        v = clamp(v, MOUNTAIN_CAR_STATE_MINS[2], MOUNTAIN_CAR_STATE_MAXS[2])
    end
    return [x,v]
end

function reward(mdp::MountainCar, s::Vector{Float64}, a::Int)
    if s[1] >= 0.6
        return 0.0
    else
        return -1.0
    end
end

function MDP(mdp::MountainCar; γ::Float64=mdp.γ)
    return MDP(
            γ,
            nothing, # no ordered states
            ordered_actions(mdp),
            (s,a, s′=nothing) -> begin
                # Technically wrong, but its probably fine
                S′ = MvNormal(mountain_car_transition(s,a), 1e-6I)
                if s′ == nothing
                    return S′
                end
                return pdf(S′, s′)
            end,
            (s,a) -> reward(mdp, s, a),
            (s, a)->begin
                s′ = mountain_car_transition(s,a)
                r = reward(mdp, s, a)
                return (s′, r)
            end
        )
end
