# DecPOMDP Usage

## Decentralized POMDP
The DecPOMDP struct gives the following objects:
 - `γ`: discount factor
 - `ℐ`: agents
 - `𝒮`: state space
 - `𝒜`: joint action space
 - `𝒪`: joint observation space
 - `T`: transition function
 - `O`: joint observation function
 - `R`: joint reward function

 The agents `ℐ` are the players of the game. The joint action space `𝒜` is the set of all possible ordered pairs of actions amongst all of the agents. The joint observation space `𝒪` is the set of all possible joint observations. The transition function takes in a state `s` in `𝒮`, a joint action `a` and a new state `s'`and returns the transition probability of going from `s` to `s'` by taking action `a`. The joint observation function takes in a state, `s`, a joint action, `a`, and a joint observation `o` in `𝒪` and returns a probability of observing `o` by taking action `a` from state `s`. The joint reward function `R` takes a state and a joint action in `𝒜` and returns a reward value.
