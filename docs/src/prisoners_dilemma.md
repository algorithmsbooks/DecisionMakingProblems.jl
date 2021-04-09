# Prisoner's Dilemma

## Problem and Action Space

The prisoner’s dilemma is a classic problem in game theory involving agents with conflicting objectives. There are two prisoners that are on trial. They can choose to cooperate, remaining silent about their shared crime, or defect, blaming the other for their crime.

The game has ``\mathcal{I} = \{1, 2\}`` and ``\mathcal{A} = \mathcal{A}^{1} \times \mathcal{A}^2`` with each ``\mathcal{A}^i = \{ \text{cooperate}, \text{defect}\}``.

## Transitions and Rewards
If they both cooperate, they both serve time for one year. If agent ``i`` cooperates and the other agent ``−i`` defects, then ``i`` serves no time and ``−i`` serves four years. If both defect, then they both serve three years.

We use the table below to express individual rewards. Rows represent actions for agent 1. Columns represent actions for agent 2. The rewards for agent 1 and 2 are shown in each cell: ``R^1(a^1, a^2), R^2(a^1, a^2)``.

![Prisoners Dilemma Table](figures/img18.svg)

The game can be played once or repeated any number of times. In the infinite horizon case, we use a discount factor of ``\gamma = 0.9``.
