# SimpleGame Usage

## Simple Game
The SimpleGame struct gives the following objects:
 - `γ`: discount factor
 - `ℐ`: agents
 - `𝒜`: joint action space
 - `R`: joint reward function

The agents `ℐ` in a simple game are the players of the game. The joint action space `𝒜` is the set of all possible ordered pairs of actions amongst all of the agents. The joint reward function `R` takes a joint action in `𝒜` and returns a reward value.
