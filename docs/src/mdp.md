# Markov Decision Process

## MDP Struct
The MDP struct gives the following:
 - `γ`: discount factor
 - `𝒮`: state space
 - `𝒜`: action space
 - `T`: transition function
 - `R`: reward function
 - `TR`: function allows us to sample transition and reward

## DiscreteMDP Struct
The DiscreteMDP struct gives the following objects and methods:
 - `ordered_states(m::DiscreteMDP)`: gives a vector of states
 - `ordered_actions(m::DiscreteMDP)`: gives a vector of actions
 - `T`: Matrix of transition function T(s,a,s′)
    - `transition(m::DiscreteMDP, s::Int, a::Int)`: function that gives a distribution of the transition
    - `generate_s(m::DiscreteMDP, s::Int, a::Int)`: function that samples the state from a transition
 - `R`: Matrix of reward values R(s,a) = ∑_s' R(s,a,s')*T(s,a,s′)
    - `reward(m::DiscreteMDP, s::Int, a::Int)`: function gives the reward of a state and action pair
 - `γ`: Discount factor

## Cart Pole, Mountain Car, Simple LQR
These problems all have similar usage documentation. To build an instance of one of these problems run
```julia
m = Problem()
mdp = MDP(m)
```
where `Problem` is either replaced with `CartPole`, `MountainCar`, or `LqrMDP`. Then `mdp` is a MDP struct so we get access to all of the functions describe in the MDP Struct section.

## Hex World
For Hex World, you use the DiscreteMDP struct. You can either set up the HexWorld manually by calling
```julia
m = HexWorldMDP(hexes, HexWorldRBumpBorder, HexWorldPIntended, special_hex_rewards, HexWorldDiscountFactor)
```
where `HexWorldRBumpBorder`, `HexWorldPIntended` and `HexWorldDiscountFactor` are constants, `hexes` is a list of 2 dimensional coordinates and `special_hex_rewards` is a dictionary of all nonzero rewards.
It is also possible to use one of the preset MDPs:
```julia
m = HexWorld
m = StraightLineHexWorld
```
Then running
```julia
mdp = m.mdp
```
gives an instance of a DiscreteMDP struct.

## Collision Avoidance
To create an instance of the problem, run
```julia
m = CollisionAvoidanceMDP()
```
Each of the state are instances of the struct `CollissionAvoidanceMDPState` that have the objects
- `h`: vertical separation
- `dh`: rate of change in h
- `a_prev`: last action
- `τ`: horizontal time separation
Then you the CollisionAvoidanceMDP struct has the methods:
- `transition(𝒫::CollisionAvoidanceMDP, s::CollisionAvoidanceMDPState, a::Float64)`: returns a distribution of states which can be sampled
- `is_terminal(𝒫::CollisionAvoidanceMDP, s::CollisionAvoidanceMDPState)`: determines if the state is terminal
- `reward(𝒫::CollisionAvoidanceMDP, s::CollisionAvoidanceMDPState, a::Float64)`: gives the reward
