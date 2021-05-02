# [DecisionMakingProblems.jl](https://github.com/algorithmsbooks/DecisionMakingProblems.jl)
*A Julia interface to access decision models which appeared in Algorithms for Decision Making.*

## Problem Summary
The following table contains the information about each of the problems contained in this package.

| Name      | ``\mathcal{I}``   | ``\mathcal{S}``  | ``\mathcal{A}`` | ``\mathcal{O}`` | ``\gamma`` | Struct Name  | Type |
| :-------------: | :----------: | :------------------------: | :------------------------: | :------------: | :----------: | :----------: | :-----------: |
| Hexworld  | –   | varies   | 6   | -  | 0.9   | HexWorld, StraightLineHexWorld    | MDP   |
| 2048     | -  | ``\infty``  | 4    | -   | 1   | TwentyFortyEight    | MDP  |
| Cart-pole  | -  | subset of ``\mathbb{R}^4``  | 2   | -  | 1  | CartPole  | MDP  |
| Mountain Car  | -  | subset of ``\mathbb{R}^2``  | 3  | -  | 1  | MountainCar  | MDP  |
| Simple Regulator  | -  | subset of ``\mathbb{R}``  | subset of ``\mathbb{R}``  | -  | 1 or 0.9  | LQR  | MDP  |
| Aircraft collision avoidance  | -  | subset of ``\mathbb{R}^3``  | 3  | -  | 1  | CollisionAvoidance   | MDP |
| Crying baby | - | 2  | 3 | 2 | 0.9 | CryingBaby | POMDP |
| Machine Replacement | - | 3 | 4 | 2 | 1 | MachineReplacement | POMDP |
| Catch | - | 4 | 10 | 2 | 0.9 | Catch | POMDP |
| Prisoner's dilemma | 2 | - | 2 per agent | - | 1  | PrisonersDilemma  | SimpleGame |
| Rock-paper-scissors | 2 | - | 3 per agent | - | 1 | RockPaperScissors | SimpleGame |
| Traveler's Dilemma | 2 | - | 99 per agent | - | 1 | Travelers | SimpleGame |
| Predator-prey hex world | varies | varies | 6 per agent | - | 0.9 | PredatorPreyHexWorld, CirclePredatorPreyHexWorld | MG |
| Multiagent Crying Baby | 2 | 2 | 3 per agent  | 2 per agent | 0.9 | MultiCaregiverCryingBaby | POMG |
| Collaborative predator-prey hex world | varies | varies | 6 per agent | -  | 0.9  | CollaborativePredatorPreyHexWorld, SimpleCollaborativePredatorPreyHexWorld, CircleCollaborativePredatorPreyHexWorld | DecPOMDP \|

The last column has the following key:
 - MDP: Markov Decision Process
 - POMDP: Partially Observable Markov Decision Process
 - SimpleGame: Simple Game
 - MG: Markov Game
 - POMG: Partially Observable Markov Game
 - DecPOMDP: Decentralized Partially Observable Markov Decision Process


## Usage
If we look at a specific problem whose struct is named `structName` and whose type is `type` as shown in the problem summary table. Then we are able to set up an instance of the struct for that specific problem using the following:
```julia
m = structName()
decprob = type(m)   # type will be the name of one of the problem types in the last column
```
An example of this would be to create an instance of the Prisoner's Dilemma struct, we would use the following code:
```julia
m = PrisonersDilemma()
decprob = SimpleGame(m)
```
### MDP Models

```@contents
Pages = [ "hexworld.md", "2048.md", "cart_pole.md", "mountain_car.md", "simple_lqr.md", "collision_avoidance.md" ]
```

### POMDP Models

```@contents
Pages = [ "pomdp.md", "crying_baby.md", "machine_replacement.md", "catch.md" ]
```

### Simple Games

```@contents
Pages = [ "simplegame.md", "prisoners_dilemma.md", "rock_paper_scissors.md", "travelers.md" ]
```

### POMG Models

```@contents
Pages = [ "pomg.md", "multicaregiver.md" ]
```

### Markov Games

```@contents
Pages = [ "mg.md", "predator_prey.md" ]
```

### Dec-POMDP

```@contents
Pages = [ "decpomdp.md", "collab_predator_prey.md" ]
```
