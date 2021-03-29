var documenterSearchIndex = {"docs":
[{"location":"hexworld/#Hex-World","page":"Hex World","title":"Hex World","text":"","category":"section"},{"location":"hexworld/#Problem","page":"Hex World","title":"Problem","text":"","category":"section"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"The hex world problem is a simple MDP in which we must traverse a tile map to reach a goal state.","category":"page"},{"location":"hexworld/#State-Space,-Action-Space-and-Transitions","page":"Hex World","title":"State Space, Action Space and Transitions","text":"","category":"section"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"Each cell in the tile map represents a state in the MDP. We can attempt to move in any of the 6 directions. The effects of these actions are stochastic. As shown in the figure below, we move 1 step in the specified direction with probability 07, and we move 1 step in one of the neighboring directions, each with probability 015. If we bump against the outer border of the grid, then we do not move at all, at cost 10.","category":"page"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"(Image: Visualization of HexWorld Actions)","category":"page"},{"location":"hexworld/#Reward-and-Termination-Condition","page":"Hex World","title":"Reward and Termination Condition","text":"","category":"section"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"Certain cells in the hex world problem are terminal states. Taking any action in these cells gives us a specified reward and then transports us to a terminal state. No further reward is received in the terminal state. The total number of states in the hex world problem is thus the number of tiles plus 1, for the terminal state.","category":"page"},{"location":"hexworld/#Optimal-Policies","page":"Hex World","title":"Optimal Policies","text":"","category":"section"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"The figure below shows an optimal policy for two hex world problem configurations.","category":"page"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"(Image: Optimal HexWorld Policy1)","category":"page"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"(Image: Optimal HexWorld Policy2)","category":"page"},{"location":"hexworld/","page":"Hex World","title":"Hex World","text":"(Image: Optimal HexWorld Policy3)","category":"page"},{"location":"catch/#Catch","page":"Catch","title":"Catch","text":"","category":"section"},{"location":"catch/#Problem","page":"Catch","title":"Problem","text":"","category":"section"},{"location":"catch/","page":"Catch","title":"Catch","text":"In the catch problem, Johnny would like to successfully catch throws from his father, and he prefers catching longer-distance throws. However, he is uncertain about the relationship between the distances of a throw and the probability of a successful catch. He does know that the probability of a successful catch is the same regardless of whether he is throwing or catching, and he has a finite number of attempted catches to maximize his expected utility before he has to go home.","category":"page"},{"location":"catch/","page":"Catch","title":"Catch","text":"As shown in the figure below, Johnny models the probability of successfully catching a ball thrown a distance d as","category":"page"},{"location":"catch/","page":"Catch","title":"Catch","text":"P(textcatch mid d) = 1 - frac11 + textexp(-fracd-s15)","category":"page"},{"location":"catch/","page":"Catch","title":"Catch","text":"where the proficiency s is unknown and does not change over time. To keep things manageable, he assumes s belongs to the discrete set mathcalS = 20 40 60 80.","category":"page"},{"location":"catch/","page":"Catch","title":"Catch","text":"(Image: Visualization of Catch Distributions)","category":"page"},{"location":"catch/#Reward-and-Action-Space","page":"Catch","title":"Reward and Action Space","text":"","category":"section"},{"location":"catch/","page":"Catch","title":"Catch","text":"The reward for a successful catch is equal to the distance. If the catch is unsuccessful, then the reward is zero. Johnny wants to maximize the reward over a finite number of attempted throws. With each throw, Johnny chooses a distance from a discrete set mathcalA = 10 20 dots 100. Johnny begins with a uniform distribution over mathcalS.","category":"page"},{"location":"machine_replacement/#Machine-Replacement","page":"Machine Replacement","title":"Machine Replacement","text":"","category":"section"},{"location":"machine_replacement/#Problem","page":"Machine Replacement","title":"Problem","text":"","category":"section"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The machine replacement problem is a discrete POMDP in which we maintain a machine that produces products. This problem is used for its relative simplicity and the varied size and shape of the optimal policy regions.","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The machine produces products for us when it is working properly. Over time, the two primary components in the machine may break down, together or individually, leading to defective product. We can indirectly observe whether the machine is faulty by examining the products, or by directly examining the components in the machine.","category":"page"},{"location":"machine_replacement/#State,-Action-and-Observation-Space","page":"Machine Replacement","title":"State, Action and Observation Space","text":"","category":"section"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The problem has states mathcalS = 0 1 2, corresponding to the number of faulty internal components. There are four actions, used prior to each production cycle:","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"manufacture, manufacture product and do not examine the product,\nexamine, manufacture product and examine the product,\ninterrupt, interrupt production, inspect, and replace failed components, and\nreplace replace both components after interrupting production.","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"When we examine the product, we can observe whether or not it is defective. All other actions only observe non-defective products.","category":"page"},{"location":"machine_replacement/#Transitions,-Reward-and-Observation-Functions","page":"Machine Replacement","title":"Transitions, Reward and Observation Functions","text":"","category":"section"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The components in the machine independently have a 10  chance of breaking down with each production cycle. Each failed component contributes a 50  chance of producing a defective product. A nondefective product nets 1 reward, whereas a defective product nets 0 reward. The transition dynamics assume that component breakdown is determined before a product is made, so the manufacture action on a fully-functional machine does not have a 100  chance of producing 1 reward.","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The manufacture action incurs no penalty. Examining the product costs 025. Interrupting the line costs 05 to inspect the machine, causes no product to be produced, and incurs 1 for each broken component. Simply replacing both components always incurs 2, but does not have an inspection cost.","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"The transition, observation, and reward functions are given in the table below.","category":"page"},{"location":"machine_replacement/#Optimal-Policies","page":"Machine Replacement","title":"Optimal Policies","text":"","category":"section"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"Optimal policies for increasing horizons are shown in the figures below:","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"(Image: Visualization of Optimal Policies)","category":"page"},{"location":"machine_replacement/","page":"Machine Replacement","title":"Machine Replacement","text":"(Image: Visualization of Optimal Policies2)","category":"page"},{"location":"mountain_car/#Mountain-Car","page":"Mountain Car","title":"Mountain Car","text":"","category":"section"},{"location":"mountain_car/#Problem","page":"Mountain Car","title":"Problem","text":"","category":"section"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"In the mountain car problem, a vehicle must drive to the right, out of a valley. The valley walls are steep enough that blindly accelerating toward the goal with insufficient speed causes the vehicle to come to a halt and slide back down. The agent must learn to accelerate left first, in order to gain enough momentum on the return to make it up the hill.","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"The mountain car problem is a good example of a problem with delayed return. Many actions are required to get to the goal state, making it difficult for an untrained agent to receive anything other than consistent unit penalties. The best learning algorithms are able to efficiently propagate knowledge from trajectories that reach the goal back to the rest of the state space.","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"(Image: Visualization of Mountain Car)","category":"page"},{"location":"mountain_car/#State-and-Action-Space","page":"Mountain Car","title":"State and Action Space","text":"","category":"section"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"The state space, action space and observation space are","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"beginaligned\nmathcalS = -12 06 times -007 007 \nmathcalA = -1 0 1 \nendaligned","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"The state is the vehicle’s horizontal position x in 12 06 and speed v in 007 007 At any given time step, the vehicle can accelerate left (a = 1), accelerate right (a = 1), or coast (a = 0).","category":"page"},{"location":"mountain_car/#Transitions","page":"Mountain Car","title":"Transitions","text":"","category":"section"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"Transitions in the mountain car problem are deterministic:","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"beginaligned\nv rightarrow v + 0001a - 00025 cos(3x) \nx rightarrow x + v\nendaligned","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"The gravitational term in the speed update is what drives the under-powered vehicle back toward the valley floor. Transitions are clamped to the bounds of the state-space.","category":"page"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"A visualization of the problem is shown below:","category":"page"},{"location":"mountain_car/#Reward-Function-and-Termination-Condition","page":"Mountain Car","title":"Reward Function and Termination Condition","text":"","category":"section"},{"location":"mountain_car/","page":"Mountain Car","title":"Mountain Car","text":"We receive 1 reward every turn, and terminate when the vehicle makes it up the right side of the valley past x = 06.","category":"page"},{"location":"cart_pole/#Cart-Pole","page":"Cart-Pole","title":"Cart-Pole","text":"","category":"section"},{"location":"cart_pole/#Problem","page":"Cart-Pole","title":"Problem","text":"","category":"section"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"The cart-pole problem, also sometimes called the pole balancing problem, has the agent move a cart back and forth. As shown in the figure below, this cart has a rigid pole attached to it by a swivel, such that as the cart moves back and forth, the pole begins to rotate. The objective is to the keep the pole vertically balanced while keeping the cart near within the allowed lateral bounds.","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"(Image: Visualization of Cart-Pole)","category":"page"},{"location":"cart_pole/#State-and-Action-Space","page":"Cart-Pole","title":"State and Action Space","text":"","category":"section"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"The actions are to either apply a left or right force F on the cart. The state space is defined by four continuous variables: the lateral position of the cart x, its lateral velocity v, the angle of the pole theta, and the pole’s angular velocity omega. The problem involves a variety of parameters including the mass of the cart m_textcart, the mass of the pole m_textpole, the pole length ell, the force magnitude F, gravitational acceleration g, the timestep Delta t, the maximum x deviation, the maximum angular deviation, and friction losses between the cart and pole or between the cart and its track.","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"The cart-pole problem is typically initialized with each random value drawn from mathcalU(-005 005).","category":"page"},{"location":"cart_pole/#Transitions","page":"Cart-Pole","title":"Transitions","text":"","category":"section"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"Given an input force F, the angular acceleration on the pole is","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"alpha = fracg sin(theta) - tau cos(theta)fracell2 left(frac43 - fracm_textpolem_textcart + m_textpole cos(theta)^2right)","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"where","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"beginaligned\ntau = fracF + omega^2 ell sin(theta2)m_textcart + m_textpole\nendaligned","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"The lateral cart acceleration is","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"beginaligned\na = tau - fracell2 alpha cos(theta) fracm_textpolem_textcart + m_textpole\nendaligned","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"The state is updated with Euler integration:","category":"page"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"beginaligned\nx rightarrow x + v Delta t \nv rightarrow v + a Delta t \ntheta rightarrow theta + omega Delta t \nomega rightarrow omega + alpha Delta t  \nendaligned","category":"page"},{"location":"cart_pole/#Reward-and-Termination-Condition","page":"Cart-Pole","title":"Reward and Termination Condition","text":"","category":"section"},{"location":"cart_pole/","page":"Cart-Pole","title":"Cart-Pole","text":"Since the objective is to the keep the pole vertically balanced while keeping the cart near within the allowed lateral bounds, 1 reward is obtained each time step in which these conditions are met, and transition to a terminal zero-reward state occurs whenever they are not.","category":"page"},{"location":"collision_avoidance/#Aircraft-Collision-Avoidance","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"","category":"section"},{"location":"collision_avoidance/#Problem","page":"Aircraft Collision Avoidance","title":"Problem","text":"","category":"section"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"The aircraft collision avoidance problem involves deciding when to issue a climb or descend advisory to our aircraft to avoid an intruder aircraft. The figure below illustrates the problem scene.","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"(Image: Visualization of Aircraft Collision Avoidance)","category":"page"},{"location":"collision_avoidance/#State-and-Action-Space","page":"Aircraft Collision Avoidance","title":"State and Action Space","text":"","category":"section"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"There are three actions corresponding to no advisory, commanding a 5 text ms descend, and commanding a 5 text ms climb. The intruder is approaching us head-on with constant horizontal closing speed. The state is specified by the altitude h of our aircraft measured relative to the intruder aircraft, our vertical rate ˙h, the previous action a_textprev, and the time to potential collision t_textcol.","category":"page"},{"location":"collision_avoidance/#Transitions","page":"Aircraft Collision Avoidance","title":"Transitions","text":"","category":"section"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"Given action a, the state variables are updated as follows:","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"beginaligned\nh rightarrow h + h Delta t \nh rightarrow (h + v)Delta t \na_textprev rightarrow a \nt_textcol rightarrow t_textcol - Delta t\nendaligned","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"where Delta t = 1 text s and v is selected from a discrete distribution over -2 0 or 2 textms^2 with associated probabilities 025 05 025. The value h is given by","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"h = begincases 0  textif  a = text no advisory  aDelta t  textif  a - hDelta t  h_textlimit  textsign(a - h)h_textlimit  textotherwise endcases","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"where h_textlimit = 1 textms^2.","category":"page"},{"location":"collision_avoidance/#Reward-and-Termination-Condition","page":"Aircraft Collision Avoidance","title":"Reward and Termination Condition","text":"","category":"section"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"The episode terminates when taking an action when t_textcol  0. There is a penalty of 1 when the intruder comes within 50 m when t_textcol = 0, and there is a penalty of 001 when a neq a_textprev.","category":"page"},{"location":"collision_avoidance/#Strategies","page":"Aircraft Collision Avoidance","title":"Strategies","text":"","category":"section"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"The aircraft collision avoidance problem can be efficiently solved over a discretized grid using backwards induction value iteration (Section 7.6 of Algorithms for Decision Making) because the dynamics deterministically reduce t_textcol. Slices of the optimal value function and policy are depicted below.","category":"page"},{"location":"collision_avoidance/","page":"Aircraft Collision Avoidance","title":"Aircraft Collision Avoidance","text":"(Image: Slices of the optimal value function)","category":"page"},{"location":"crying_baby/#Crying-Baby","page":"Crying Baby","title":"Crying Baby","text":"","category":"section"},{"location":"crying_baby/#Problem","page":"Crying Baby","title":"Problem","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The crying baby problem is a simple POMDP with two states, three actions, and two observations. Our goal is to care for a baby, and we do so by choosing at each time step whether to feed the baby, sing to the baby, or ignore the baby.","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The baby becomes hungry over time. We do not directly observe whether the baby is hungry, but instead receive a noisy observation in the form of whether or not the baby is crying.","category":"page"},{"location":"crying_baby/#State,-Action-and-Observation-Space","page":"Crying Baby","title":"State, Action and Observation Space","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The state space, action space and observation space are","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"beginaligned\nmathcalS = texthungry textsated \nmathcalA = textfeed textsing textignore \nmathcalO = textcrying textquiet\nendaligned","category":"page"},{"location":"crying_baby/#Transitions","page":"Crying Baby","title":"Transitions","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"Feeding will always sate the baby. Ignoring the baby risks a sated baby becoming hungry, and ensures that a hungry baby remains hungry. Singing to the baby is an information gathering action with the same transition dynamics as ignoring, but without the potential for crying when sated (not hungry) and with an increased chance of crying when hungry.","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The transition dynamics are:","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"beginaligned\nT(textsated mid texthungry textfeed) = 100 \nT(texthungry mid texthungry textsing) = 100 \nT(texthungry mid texthungry textignore) = 100 \nT(textsated mid textsated textfeed) = 100 \nT(texthungry mid textsated textsing) = 10 \nT(texthungry mid textsated textignore) = 10\nendaligned","category":"page"},{"location":"crying_baby/#Observations","page":"Crying Baby","title":"Observations","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The observation dynamics are:","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"beginaligned\nO(textcry mid textfeed texthungry) = 80 \nO(textcry mid textsing texthungry) = 90 \nO(textcry mid textignore texthungry) = 80 \nO(textcry mid textfeed textsated) = 10 \nO(textcry mid textsing textsated) = 0 \nO(textcry mid textignore textsated) = 10\nendaligned","category":"page"},{"location":"crying_baby/#Reward-Function","page":"Crying Baby","title":"Reward Function","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"The reward function assigns 10 reward if the baby is hungry independent of the action taken. The effort of feeding the baby adds a further 5 reward, whereas singing adds 05 reward.","category":"page"},{"location":"crying_baby/#Optimal-Infinite-Horizon-Policy","page":"Crying Baby","title":"Optimal Infinite Horizon Policy","text":"","category":"section"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"As baby caregivers, we seek the optimal infinite horizon policy with discount factor gamma = 09. This optimal policy is:","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"(Image: Optimal Caregiver Policy)","category":"page"},{"location":"crying_baby/","page":"Crying Baby","title":"Crying Baby","text":"Note that this infinite horizon solution does not recommend singing for any belief state. However, it is optimal to sing in some finite horizon versions of this problem","category":"page"},{"location":"#[DecisionMakingProblems.jl](https://github.com/JuliaPOMDP/POMDPs.jl)","page":"DecisionMakingProblems.jl","title":"DecisionMakingProblems.jl","text":"","category":"section"},{"location":"","page":"DecisionMakingProblems.jl","title":"DecisionMakingProblems.jl","text":"A Julia interface to access MDP and POMDP models which appeared in Algorithms for Decision Making.","category":"page"},{"location":"#Available-Packages","page":"DecisionMakingProblems.jl","title":"Available Packages","text":"","category":"section"},{"location":"","page":"DecisionMakingProblems.jl","title":"DecisionMakingProblems.jl","text":"The POMDPs.jl package contains the interface used for accessing Markov decision processes (MDPs) and partially observable Markov decision processes (POMDPs) in the Julia programming language.","category":"page"},{"location":"#MDP-Models","page":"DecisionMakingProblems.jl","title":"MDP Models","text":"","category":"section"},{"location":"","page":"DecisionMakingProblems.jl","title":"DecisionMakingProblems.jl","text":"Pages = [ \"hexworld.md\", \"cart_pole.md\", \"mountain_car.md\", \"simple_lqr.md\", \"collision_avoidance.md\" ]","category":"page"},{"location":"#POMDP-Models","page":"DecisionMakingProblems.jl","title":"POMDP Models","text":"","category":"section"},{"location":"","page":"DecisionMakingProblems.jl","title":"DecisionMakingProblems.jl","text":"Pages = [ \"crying_baby.md\", \"machine_replacement.md\", \"catch.md\" ]","category":"page"},{"location":"simple_lqr/#Simple-Regulator","page":"Simple Regulator","title":"Simple Regulator","text":"","category":"section"},{"location":"simple_lqr/#Problem,-State-and-Action-Space","page":"Simple Regulator","title":"Problem, State and Action Space","text":"","category":"section"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"The simple regulator problem is a simple linear quadratic regulator problem with a single state. It is an MDP with a single real-valued state and a single real-valued action.","category":"page"},{"location":"simple_lqr/#Transitions-and-Rewards","page":"Simple Regulator","title":"Transitions and Rewards","text":"","category":"section"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"Transitions are linear Gaussian such that a successor state s is drawn from the Gaussian distribution mathcalN(s + a 012). Rewards are quadratic, R(s a) = s^2, and do not depend on the action. The examples in this text use the initial state distribution mathcalN(03 012). \u0001","category":"page"},{"location":"simple_lqr/#Optimal-Policies","page":"Simple Regulator","title":"Optimal Policies","text":"","category":"section"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"Optimal finite-horizon policies cannot be derivied using the methods from section 7.8 of Algorithms for Decision Making. In this case, T_s = 1 T_a = 1 R_s = 1 R_a = 0 and w is drawn from mathcalN(0 012). Applications of the Riccati equation require that R_a be negative definite, which it is not.","category":"page"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"The optimal policy is pi(s) = s, resulting in a successor state distribution centered at the origin. In the policy gradient chapters we often learn parameterized policies of the form pi_theta(s) = mathcalN(theta_1 s theta_2^2). In such cases, the optimal parameterization for the simple regulator problem is theta_1 = 1 and theta_2 is asymptotically close to zero.","category":"page"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"The optimal value function for the simple regulator problem is also centered about the origin, with reward decreasing quadratically:","category":"page"},{"location":"simple_lqr/","page":"Simple Regulator","title":"Simple Regulator","text":"beginaligned\nmathcalU(s) = -s^2 + fracgamma1 + gamma mathbbE_s sim mathcalN(0 01^2) left-s^2 right \napprox -s^2 - 0010fracgamma1 + gamma\nendaligned","category":"page"}]
}