module DecisionMakingProblems

using Distributions
using Parameters
using Random
using LinearAlgebra
using GridInterpolations
using Parameters
using Statistics
using Printf

export
    MDP, HexWorld, StraightLineHexWorld, TwentyFortyEight, CartPole, MountainCar, LQR, CollisionAvoidance,
    POMDP, DiscretePOMDP, CryingBaby, MachineReplacement, Catch,
    SimpleGame, PrisonersDilemma, RockPaperScissors, Travelers,
    MG, PredatorPreyHexWorld, CirclePredatorPreyHexWorld,
    POMG, MultiCaregiverCryingBaby,
    DecPOMDP, CollaborativePredatorPreyHexWorld, SimpleCollaborativePredatorPreyHexWorld, CircleCollaborativePredatorPreyHexWorld

import Base: <, ==, rand, vec
import Distributions: pdf

include("support_code.jl")

include("mdp/mdp.jl")
include("mdp/discrete_mdp.jl")
include("mdp/2048.jl")
include("mdp/hexworld.jl")
include("mdp/simple_lqr.jl")
include("mdp/cart_pole.jl")
include("mdp/mountain_car.jl")
include("mdp/collision_avoidance.jl")

include("pomdp/pomdp.jl")
include("pomdp/discrete_pomdp.jl")
include("pomdp/crying_baby.jl")
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
