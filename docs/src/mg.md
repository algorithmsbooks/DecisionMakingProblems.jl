# MG Usage

## Markov Game
The MG struct gives the following objects:
 - `γ`: discount factor
 - `ℐ`: agents
 - `𝒮`: state space
 - `𝒜`: joint action space
 - `T`: transition function
 - `R`: joint reward function

 The agents `ℐ` are the players of the game. The joint action space `𝒜` is the set of all possible ordered pairs of actions amongst all of the agents. The transition function takes in a state `s` in `𝒮`, a joint action `a` and a new state `s'` and returns the transition probability of going from `s` to `s'` by taking action `a`. The joint reward function `R` takes a state and a joint action in `𝒜` and returns a reward value.
