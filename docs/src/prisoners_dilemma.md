# Simple Regulator

## Problem, State and Action Space

The simple regulator problem is a simple linear quadratic regulator problem with a single state. It is an MDP with a single real-valued state and a single real-valued action.

## Transitions and Rewards
Transitions are linear Gaussian such that a successor state ``s'`` is drawn from the Gaussian distribution ``\mathcal{N}(s + a, 0.12)``. Rewards are quadratic, ``R(s, a) = −s^2``, and do not depend on the action. The examples in this text use the initial state distribution ``\mathcal{N}(0.3, 0.12)``.

## Optimal Policies
Optimal finite-horizon policies cannot be derivied using the methods from section 7.8 of Algorithms for Decision Making. In this case, ``T_s = [1], T_a = [1], R_s = [−1], R_a = [0]`` and ``w`` is drawn from ``\mathcal{N}(0, 0.12)``. Applications of the Riccati equation require that ``R_a`` be negative definite, which it is not.

The optimal policy is ``\pi(s) = −s``, resulting in a successor state distribution centered at the origin. In the policy gradient chapters we often learn parameterized policies of the form ``\pi_{\theta}(s) = \mathcal{N}(\theta_1 s, \theta_2^2)``. In such cases, the optimal parameterization for the simple regulator problem is ``\theta_1 = −1`` and ``\theta_2`` is asymptotically close to zero.

The optimal value function for the simple regulator problem is also centered about the origin, with reward decreasing quadratically:
```math
\begin{aligned}
\mathcal{U}(s) &= -s^2 + \frac{\gamma}{1 + \gamma} \mathbb{E}_{s \sim \mathcal{N}(0, 0.1^2)} \left[-s^2 \right] \\
&\approx -s^2 - 0.010\frac{\gamma}{1 + \gamma}
\end{aligned}
```
