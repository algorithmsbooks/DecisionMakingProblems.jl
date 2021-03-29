struct BoolDistribution
    p::Float64 # probability of true
end

pdf(d::BoolDistribution, s::Bool) = s ? d.p : 1.0-d.p
rand(rng::AbstractRNG, d::BoolDistribution) = rand(rng) <= d.p
iterator(d::BoolDistribution) = [true, false]
Base.:(==)(d1::BoolDistribution, d2::BoolDistribution) = d1.p == d2.p
Base.hash(d::BoolDistribution, u::UInt64=UInt64(0)) = hash(d.p, u)
Base.length(d::BoolDistribution) = 2

mutable struct BabyPOMDP
    r_hungry::Float64
    r_feed::Float64
    r_sing::Float64
    p_become_hungry::Float64
    p_cry_when_hungry::Float64
    p_cry_when_not_hungry::Float64
    p_cry_when_hungry_in_sing::Float64
    γ::Float64
end

CryingBaby = BabyPOMDP(-10.0, -5.0, -0.5, 0.1, 0.8, 0.1, 0.9, 0.9)

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
