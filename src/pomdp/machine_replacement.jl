# From Smallwood and Sondik, 1973
# 3 states       - 0, 1 or 2 faulty internal components
# 4 actions
#    - manufacture without examination (M)
#    - manufacture with examination (E)
#    - interrupt the line and replace failed components (I)
#    - interrupt the line and replace both components without inspection (R)
# 2 observations - defective product or not
#
# NOTE: The original paper includes "salvage values", or terminal rewards
#       equal to the number of working parts. We do not include that here.

# Component breakdowns are independent
# 10% probability that either breaks down during the manufacture of a product
# Failed components cause 50% of part being defective

@with_kw struct MachineReplacement
    γ::Float64=1.0
end

function MachineReplacement(pomdp::MachineReplacement; γ::Float64=pomdp.γ)
    T = Array{Float64}(undef, 3, 4, 3)
    R = Array{Float64}(undef, 3, 4)
    O = Array{Float64}(undef, 4, 3, 2)

    s_0 = 1 # none broken
    s_1 = 2 # one broken
    s_2 = 3 # two broken

    a_m = 1 # manufacture
    a_e = 2 # manufacture + examine
    a_i = 3 # interrupt the line, inspect components, replace failed components
    a_r = 4 # interrupt the line, replace both components

    o_n = 1 # nondefective
    o_d = 2 # defective

    T[s_0, a_m, :] = [0.81, 0.18, 0.01] # 10% independent chance of part breaking
    T[s_0, a_e, :] = [0.81, 0.18, 0.01]
    T[s_0, a_i, :] = [1.00, 0.00, 0.00]
    T[s_0, a_r, :] = [1.00, 0.00, 0.00]
    T[s_1, a_m, :] = [0.00, 0.90, 0.10] # 10% chance of remaining part breaking
    T[s_1, a_e, :] = [0.00, 0.90, 0.10]
    T[s_1, a_i, :] = [1.00, 0.00, 0.00]
    T[s_1, a_r, :] = [1.00, 0.00, 0.00]
    T[s_2, a_m, :] = [0.00, 0.00, 1.00] # stay broken
    T[s_2, a_e, :] = [0.00, 0.00, 1.00]
    T[s_2, a_i, :] = [1.00, 0.00, 0.00]
    T[s_2, a_r, :] = [1.00, 0.00, 0.00]

    # There is a profit of 1 for producing a nondefective product.
    # Thus, the expected profit for beginning with 0, 1, or 2 defective parts is
    # 0.9025, 0.475, and 0.25, respectively.
    # Examining the finished product costs 0.25.
    # The inspect action incurs a 0.5 penalty plus replacement cost for each unit of 1.
    # The straight-up replacement action has no inspection cost but does incur a 2 unit cost.
    r_examine = -0.25
    r_inspect = -0.5
    r_replace = -2.0

    R[s_0, a_m] = 0.9025
    R[s_1, a_m] = 0.475
    R[s_2, a_m] = 0.25
    R[s_0, a_e] = 0.9025 + r_examine
    R[s_1, a_e] = 0.475 + r_examine
    R[s_2, a_e] = 0.25 + r_examine
    R[s_0, a_i] = r_inspect
    R[s_1, a_i] = r_inspect - 1.0 # replace 1
    R[s_2, a_i] = r_inspect - 2.0 # replace 2
    R[s_0, a_r] = r_replace
    R[s_1, a_r] = r_replace
    R[s_2, a_r] = r_replace

    # Probabilities of observing a nondefective product are 1.0, 0.5, and 0.25 if
    # there are 0, 1, or 2 faulty internal components.
    # If we don't examine, we always observe nondefective.
    O[a_m, s_0, :] = [1.00, 0.00]
    O[a_m, s_1, :] = [1.00, 0.00]
    O[a_m, s_2, :] = [1.00, 0.00]
    O[a_e, s_0, :] = [1.00, 0.00]
    O[a_e, s_1, :] = [0.50, 0.50]
    O[a_e, s_2, :] = [0.25, 0.75]
    O[a_i, s_0, :] = [1.00, 0.00]
    O[a_i, s_1, :] = [1.00, 0.00]
    O[a_i, s_2, :] = [1.00, 0.00]
    O[a_r, s_0, :] = [1.00, 0.00]
    O[a_r, s_1, :] = [1.00, 0.00]
    O[a_r, s_2, :] = [1.00, 0.00]

    return DiscretePOMDP(T, R, O, γ)
end

# MachineReplacement = generate_machine_replacement_pomdp(1.0)

MACHINE_REPLACEMENT_ACTION_COLORS = Dict(
    1 => "pastelRed",
    2 => "pastelGreen",
    3 => "pastelBlue",
    4 => "pastelPurple",
)
MACHINE_REPLACEMENT_ACTION_NAMES = Dict(
    1 => "manufacture",
    2 => "examine",
    3 => "interrupt",
    4 => "replace",
)
