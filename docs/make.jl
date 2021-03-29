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

        "MDP Models" => [
            "mountain_car.md",
           ],


        "POMDP Models" => [
            "crying_baby.md",
           ],

        # "Concepts" => [
        #     "concepts.md"
        #    ],
    ]
)

# deploydocs(
#     repo = "github.com/sisl/Alg4DMProblems.jl.git",
# )
