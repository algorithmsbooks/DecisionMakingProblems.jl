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
            # "install.md",
            # "get_started.md",
            # "concepts.md"
           ],
        "Usage" => [
            "mdp.md",
            # "pomdp.md",
            # "simplegame.md",
            # "mg.md",
            # "pomg.md",
            # "decpomdp.md"
           ],


        "MDP Models" => [
            "hexworld.md",
            "2048.md",
            "cart_pole.md",
            "mountain_car.md",
            "simple_lqr.md",
            "collision_avoidance.md"
           ],

        "POMDP Models" => [
            "crying_baby.md",
            "machine_replacement.md",
            "catch.md"
           ],

        "Simple Games" => [
            "prisoners_dilemma.md",
            "rock_paper_scissors.md",
            "travelers.md"
           ],

        "POMG Models" => [
            "multicaregiver.md",
           ],

        "Markov Game" => [
            "predator_prey.md",
           ],

        "Dec-POMDP" => [
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
