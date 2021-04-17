# Multi-Caregiver Crying Baby

## Problem, State, Action and Observation Space

The multi-caregiver crying baby problem is a multiagent extension of the crying baby
problem. For each caregiver ``i \in \mathcal{I} = \{1, 2\}``, the states, actions, and observations
are as follows:
```math
\begin{aligned}
\mathcal{S} &= \{\text{hungry}, \text{sated}\}  \\
\mathcal{A}^i &= \{\text{feed}, \text{sing}, \text{ignore}\}  \\
\mathcal{O}^i &= {\text{crying}, \text{quiet}}
\end{aligned}
```

## Transition and Observation Dynamics
The transition dynamics are similar to the original crying baby problem, except that either caregiver can feed to satisfy the baby:
```math
\begin{aligned}
T(\text{sated} \mid \text{hungry},(\text{feed}, \star)) = T(\text{sated} | \text{hungry},(\star, \text{feed})) = 100%
\end{aligned}
```
where ``\star`` indicates all possible other variable assignments. Otherwise, if the actions are not feed, then the baby transitions between sated to hungry as before:
```math
\begin{aligned}
T(\text{hungry} \mid \text{hungry},(\star, \star)) &= 100 \% \\
T(\text{sated} \mid \text{hungry},(\star, \star)) &= 50 \% \\
\end{aligned}
```

The observation dynamics are also similar to the single agent version, but the model ensures both caregivers make the same observation of the baby, but not necessarily of each other’s choice of caregiving action:
```math
\begin{aligned}
O((\text{cry}, \text{cry}) \mid (\text{sing}, \star), \text{hungry}) = O((\text{cry}, \text{cry}) \mid (\star, \text{sing}), \text{hungry}) &= 90\% \\
O((\text{quiet}, \text{quiet}) \mid (\text{sing}, \star), \text{hungry}) = O((\text{quiet}, \text{quiet}) \mid (\star, \text{sing}), \text{hungry}) &= 10\% \\
O((\text{cry}, \text{cry}) \mid (\text{sing}, \star), \text{staed}) = O((\text{cry}, \text{cry}) \mid (\star, \text{sing}), \text{sated}) &= 0\% \\
\end{aligned}
```
If the actions are not sing, then the observations are as follows:
```math
\begin{aligned}
O((\text{cry}, \text{cry}) \mid (\star, \star), \text{hungry}) &= 90 \% \\
O((\text{quiet}, \text{quiet}) \mid (\star, \star), \text{hungry}) &= 10 \% \\
O((\text{cry}, \text{cry}) \mid (\star, \star), \text{sated}) &= 0 \% \\
O((\text{quiet}, \text{quiet}) \mid (\star, \star), \text{sated}) &= 100 \% \\
\end{aligned}
```

## Reward
Both caregivers want to help the baby when the baby is hungry, assigning the same penalty of ``−10.0`` for both. However, the first caregiver favors feeding and the second caregiver favors singing. For feeding, the first caregiver receives an
extra penalty of only ``−2.5``, while the second caregiver receives an extra penalty of ``−5.0``. For signing, the first caregiver is penalized by ``−0.5``, while the second caregiver is penalized by only ``−0.25``.
