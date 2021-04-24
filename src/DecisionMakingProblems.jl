module DecisionMakingProblems

using Distributions
using Parameters
using Random
using LinearAlgebra
using GridInterpolations
using Parameters

import Base: ==, rand, vec

include("support_code.jl")

include("search/search.jl")
include("search/hex_world.jl")

include("mdp/mdp.jl")
include("mdp/discrete_mdp.jl")
include("mdp/sliding_tile_puzzle.jl")
include("mdp/gridworld.jl")
include("mdp/hexworld.jl")
include("mdp/you_get_what_you_bet.jl")
include("mdp/simple_lqr.jl")
include("mdp/cart_pole.jl")
include("mdp/mountain_car.jl")
include("mdp/collision_avoidance.jl")

include("pomdp/pomdp.jl")
include("pomdp/spelunker_joe.jl")
include("pomdp/crying_baby.jl")
include("pomdp/discrete_pomdp.jl")
include("pomdp/machine_replacement.jl")
include("pomdp/catch.jl")

include("simple_game/simplegame.jl")
include("simple_game/prisoners_dilemma.jl")
include("simple_game/travelers.jl")
include("simple_game/rock_paper_scissors.jl")

include("markov_game/mg.jl")
include("markov_game/predator_prey.jl")

include("pomg/pomg.jl")
include("pomg/multicaregiver.jl")

include("decpomdp/decpomdp.jl")
include("decpomdp/collab_predator_prey.jl")



end # module
