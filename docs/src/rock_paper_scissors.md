# Rock-Paper-Scissors

## Problem and Action Space

One common game played around the world is rock-paper-scissors. There are two agents who can choose either rock, paper, or scissors. Rock beats scissors, resulting in a unit reward for the agent playing rock and a unit penalty for the agent playing scissors. Scissors beats paper, resulting in a unit reward for the agent playing scissors and a unit penalty for the agent playing paper. Finally, paper beats rock, resulting in a unit reward for the agent playing paper and a unit penalty for the agent playing rock.

We have ``\mathcal{I} = \{1, 2\}`` and ``\mathcal{A} = \mathcal{A}^{1} \times \mathcal{A}^2`` with each ``\mathcal{A}^i = \{ \text{rock}, \text{paper}, \text{scissors}\}``.

## Transitions and Rewards
The table below shows the rewards associated with the game, with each cell denoting ``R^1(a^1, a^2), R^2(a^1, a^2)``.

![RPS Table](figures/img19.svg)

The game can be played once or repeated any number of times. In the infinite horizon case, we use a discount factor of ``\gamma = 0.9``.
