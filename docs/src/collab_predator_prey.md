# Collaborative Predatory-Prey Hex World

## Problem

The collaborative predator-prey hex world is an variant of the predator-prey hex world in which a team of predators chase a single moving prey. The predators must work together to capture a prey. The prey moves randomly to a neighboring cell that is not occupied by a predator.

## Observations and Rewards
Predators also only make noisy local observations of the environment. Each predator ``i`` detects whether a prey is within a neighboring cell ``\mathcal{O}^i = \{\text{prey}, \text{nothing}\}``. The predators are penalized with a ``−1`` reward for movement. They receive a reward of ``10`` if one or more of them capture the prey, meaning they are in the same
cell as the prey. At this point, the prey is randomly assigned a new cell, signifying the arrival of a new prey for the predators to begin hunting.
