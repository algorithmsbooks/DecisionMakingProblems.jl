push!(LOAD_PATH, "../src/")

using Documenter, DecisionMakingProblems

makedocs(
    modules = [DecisionMakingProblems],
    format = Documenter.HTML(),
    sitename = "DecisionMakingProblems.jl",
    pages = [
        ##############################################
        ## MAKE SURE TO SYNC WITH docs/src/index.md ##
        ##############################################
        "Basics" => [
            "index.md",
            "mdp.md",
            # "get_started.md",
            # "concepts.md"
           ],
        # "Usage" => [
        #     "mdp.md",
        #     # "pomdp.md",
        #     # "simplegame.md",
        #     # "mg.md",
        #     # "pomg.md",
        #     # "decpomdp.md"
        #    ],


        "MDP Models" => [
            # "mdp.md",
            "hexworld.md",
            "2048.md",
            "cart_pole.md",
            "mountain_car.md",
            "simple_lqr.md",
            "collision_avoidance.md"
           ],

        "POMDP Models" => [
            "pomdp.md",
            "crying_baby.md",
            "machine_replacement.md",
            "catch.md"
           ],

        "Simple Games" => [
            "simplegame.md",
            "prisoners_dilemma.md",
            "rock_paper_scissors.md",
            "travelers.md"
           ],

        "POMG Models" => [
            "pomg.md",
            "multicaregiver.md",
           ],

        "Markov Game" => [
            "mg.md",
            "predator_prey.md",
           ],

        "Dec-POMDP" => [
            "decpomdp.md",
            "collab_predator_prey.md",
           ],
        # "Concepts" => [
        #     "concepts.md"
        #    ],
    ]
)

# deploydocs(
#     repo = "github.com/sisl/Alg4DMProblems.jl.git",
# )
