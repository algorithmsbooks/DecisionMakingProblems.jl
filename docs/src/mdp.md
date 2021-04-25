# MDP Usage

## MDP
The MDP struct gives the following:
 - `γ`: discount factor
 - `𝒮`: state space
 - `𝒜`: action space
 - `T`: transition function
 - `R`: reward function
 - `TR`: function allows us to sample transition and reward

The function `T` takes in a state `s` and an action `a` and returns a distribution of states which can be sampled. The reward function `R` takes in a state `s` and action `a` and returns an reward. Finally `TR` takes in a state `s` and an action `a` and returns a tuple `(s', r)` where `s'` is the new state sampled from the transition function and `r` is the reward.
