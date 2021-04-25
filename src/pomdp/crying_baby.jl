struct BoolDistribution
    p::Float64 # probability of true
end

pdf(d::BoolDistribution, s::Bool) = s ? d.p : 1.0-d.p
rand(rng::AbstractRNG, d::BoolDistribution) = rand(rng) <= d.p
iterator(d::BoolDistribution) = [true, false]
Base.:(==)(d1::BoolDistribution, d2::BoolDistribution) = d1.p == d2.p
Base.hash(d::BoolDistribution, u::UInt64=UInt64(0)) = hash(d.p, u)
Base.length(d::BoolDistribution) = 2

@with_kw struct BabyPOMDP
    r_hungry::Float64 = -10.0
    r_feed::Float64 = -5.0
    r_sing::Float64 = -0.5
    p_become_hungry::Float64 = 0.1
    p_cry_when_hungry::Float64 = 0.8
    p_cry_when_not_hungry::Float64 = 0.1
    p_cry_when_hungry_in_sing::Float64 = 0.9
    γ::Float64 = 0.9
end

# CryingBaby = BabyPOMDP(-10.0, -5.0, -0.5, 0.1, 0.8, 0.1, 0.9, 0.9)

SATED = 1
HUNGRY = 2
FEED = 1
IGNORE = 2
SING = 3
CRYING = true
QUIET = false

CRYING_BABY_ACTION_COLORS = Dict(
    FEED => "pastelBlue",
    IGNORE => "pastelGreen",
    SING => "pastelRed"
)
CRYING_BABY_ACTION_NAMES = Dict(
    FEED => "feed",
    IGNORE => "ignore",
    SING => "sing",
)

n_states(::BabyPOMDP) = 2
n_actions(::BabyPOMDP) = 3
n_observations(::BabyPOMDP) = 2
discount(pomdp::BabyPOMDP) = pomdp.γ

ordered_states(::BabyPOMDP) = [SATED, HUNGRY]
ordered_actions(::BabyPOMDP) = [FEED, IGNORE, SING]
ordered_observations(::BabyPOMDP) = [CRYING,QUIET]

two_state_categorical(p1::Float64) = Categorical([p1,1.0 - p1])
function transition(pomdp::BabyPOMDP, s::Int, a::Int)
    if a == FEED
        return two_state_categorical(1.0)
    else
        if s == HUNGRY
            return two_state_categorical(0.0)
        else
            # Did not feed when not hungry
            return two_state_categorical(1.0-pomdp.p_become_hungry)
        end
    end
end

function observation(pomdp::BabyPOMDP, a::Int, s′::Int)
    if a == SING
        if s′ == HUNGRY
            return BoolDistribution(pomdp.p_cry_when_hungry_in_sing)
        else
            return BoolDistribution(0.0)
        end
    else # FEED or IGNORE
        if s′ == HUNGRY
            return BoolDistribution(pomdp.p_cry_when_hungry)
        else
            return BoolDistribution(pomdp.p_cry_when_not_hungry)
        end
    end
end

function reward(pomdp::BabyPOMDP, s::Int, a::Int)
    r = 0.0
    if s == HUNGRY
        r += pomdp.r_hungry
    end
    if a == FEED
        r += pomdp.r_feed
    elseif a == SING
        r += pomdp.r_sing
    end
    return r
end

reward(pomdp::BabyPOMDP, b::Vector{Float64}, a::Int) = sum(reward(pomdp,s,a)*b[s] for s in ordered_states(pomdp))

function DiscretePOMDP(pomdp::BabyPOMDP; γ::Float64=pomdp.γ)
    nS = n_states(pomdp)
    nA = n_actions(pomdp)
    nO = n_observations(pomdp)

    T = zeros(nS, nA, nS)
    R = Array{Float64}(undef, nS, nA)
    O = Array{Float64}(undef, nA, nS, nO)

    s_s = 1
    s_h = 2

    a_f = 1
    a_i = 2
    a_s = 3

    o_c = 1
    o_q = 2

    T[s_s, a_f, :] = [1.0, 0.0]
    T[s_s, a_i, :] = [1.0-pomdp.p_become_hungry, pomdp.p_become_hungry]
    T[s_s, a_s, :] = [1.0-pomdp.p_become_hungry, pomdp.p_become_hungry]
    T[s_h, a_f, :] = [1.0, 0.0]
    T[s_h, a_i, :] = [0.0, 1.0]
    T[s_h, a_s, :] = [0.0, 1.0]

    R[s_s, a_f] = reward(pomdp, s_s, a_f)
    R[s_s, a_i] = reward(pomdp, s_s, a_i)
    R[s_s, a_s] = reward(pomdp, s_s, a_s)
    R[s_h, a_f] = reward(pomdp, s_h, a_f)
    R[s_h, a_i] = reward(pomdp, s_h, a_i)
    R[s_h, a_s] = reward(pomdp, s_h, a_s)

    O[a_f, s_s, :] = [observation(pomdp, a_f, s_s).p, 1 - observation(pomdp, a_f, s_s).p]
    O[a_f, s_h, :] = [observation(pomdp, a_f, s_h).p, 1 - observation(pomdp, a_f, s_h).p]
    O[a_i, s_s, :] = [observation(pomdp, a_i, s_s).p, 1 - observation(pomdp, a_i, s_s).p]
    O[a_i, s_h, :] = [observation(pomdp, a_i, s_h).p, 1 - observation(pomdp, a_i, s_h).p]
    O[a_s, s_s, :] = [observation(pomdp, a_s, s_s).p, 1 - observation(pomdp, a_s, s_s).p]
    O[a_s, s_h, :] = [observation(pomdp, a_s, s_h).p, 1 - observation(pomdp, a_s, s_h).p]

    return DiscretePOMDP(T, R, O, γ)
end

function POMDP(pomdp::BabyPOMDP; γ::Float64=pomdp.γ)
    disc_pomdp = DiscretePOMDP(pomdp)
    return POMDP(disc_pomdp)
end
