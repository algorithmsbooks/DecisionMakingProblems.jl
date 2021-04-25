# POMDP Usage

## POMDP
The MDP struct gives the following:
 - `γ`: discount factor
 - `𝒮`: state space
 - `𝒜`: action space
 - `𝒪`: observation space
 - `T`: transition function
 - `R`: reward function
 - `O`: observation function
 - `TRO`: function that allows us to sample transition, reward, and observation

The function `T` takes in a state `s` and an action `a` and returns a distribution of possible states. The reward function `R` takes in a state `s` and action `a` and returns an reward. The observation function `O` takes in a state `s` and an action `a` and returns a distribution of possible observations. Finally `TRO` takes in a state `s` and an action `a` and returns a tuple `(s', r, o)` where `s'` is the new state sampled from the transition function, `r` is the reward and `o` is an observation sampled from the observation function.
