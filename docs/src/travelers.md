# Traveler's Problem

## Problem and Action Space

The traveler’s dilemma is a game where an airline loses two identical suitcases from two travelers. The airline asks the travelers to write down the value of their suitcases, which can be between `` \$ 2`` and ``\$ 100``, inclusive.

## Reward Function

If both put down the same value, then they both get that value. The traveler with the lower value gets their value plus ``\$ 2``. The traveler with the higher value gets the lower value minus ``\$ 2``. In other words, the reward function is as follows:
```math
\begin{aligned}
R_i(a_i, a_{-i}) = \begin{cases} a_i & \text{if } a_i = a_{-i} \\ a_i + 2 & \text{if } a_i < a_{-i} \\ a_{-i} - 2 & \text{otherwise} \end{cases}
\end{aligned}
```

## Optimal Policy
Most people tend to put down between `` \$ 97`` and ``\$ 100``. However, somewhat counter-intuitively, there is a unique Nash equilibrium of only ``\$ 2``.
