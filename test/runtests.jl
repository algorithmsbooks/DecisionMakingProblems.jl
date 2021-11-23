using DecisionMakingProblems
using Test
using Random
using LinearAlgebra
using GridInterpolations

const p = DecisionMakingProblems

# MDP

@testset "2048.jl" begin
    m = TwentyFortyEight()
    mdp = MDP(m)
    @test length(mdp.𝒜) == 4
    @test mdp.γ == 1.0
    init_state = p.initial_board()
    s′, r = mdp.TR(init_state, p.DOWN)
    @test s′ != init_state || isdone(s′)
    @test r >= -1.0
end

@testset "cart_pole.jl" begin
    # m = CartPole(1.0, 10.0, 1.0, 1.0, 0.1, 9.8, 0.02, 4.8, deg2rad(24))
    m = CartPole()
    @test p.n_actions(m) == 2
    @test p.discount(m) == 1.0
    @test p.ordered_actions(m) == 1:2
    min_state = [-4.8, -Inf, -24 * pi/180, -Inf]
    max_state = [4.8, Inf, 24 * pi/180, Inf]
    state = p.generate_start_state(m)
    @test min_state <= p.vec(state) <= max_state
    @test !p.is_terminal(m, state)
    @test min_state <= p.vec(p.cart_pole_transition(m, state, rand(1:2))) <= max_state
    @test p.reward(m, state, rand(1:2)) in [0.0, 1.0]
    mdp = MDP(m)
end

@testset "collision_avoidance.jl" begin
    m = CollisionAvoidance()
    distrib = p.CollisionAvoidanceStateDistribution()
    s = p.rand(distrib)
    simple_pol = p.SimpleCollisionAvoidancePolicy()
    optimal_pol = p.OptimalCollisionAvoidancePolicy()
    @test length(p.vec(rand(p.transition(m, s, optimal_pol(s))))) == 4
    @test p.is_terminal(m, s) == (p.vec(s)[4] < 0.0)
    @test p.reward(m, rand(p.transition(m, s, optimal_pol(s))), rand(m.𝒜)) <= 0
    policy = p.CollisionAvoidanceValueFunction(m, simple_pol)
    mdp = MDP(m)
end

@testset "hexworld.jl" begin
    m = HexWorld()
    hexes = m.hexes
    @test p.n_states(m) == length(hexes) + 1 && p.ordered_states(m) == 1:length(hexes) + 1
    @test p.n_actions(m) == 6 && p.ordered_actions(m) == 1:6
    @test p.discount(m) == 0.9
    @test p.state_index(m, 1) == 1
    state = rand(1:p.n_states(m))
    action = rand(1:p.n_actions(m))
    p.transition(m, state, action)
    state_ = p.generate_s(m, state, action)
    reward = p.reward(m, state, action)
    @test state_ in p.ordered_states(m)
    @test reward <= 10
    @test p.generate_sr(m, state, action)[1] in p.ordered_states(m) && p.generate_sr(m, state, action)[2] <= 10
    @test p.generate_start_state(m) in p.ordered_states(m)
    @test p.hex_distance(rand(hexes), rand(hexes)) >= 0
    mdp = MDP(m)
end
@testset "simple_lqr.jl" begin
    m = LQR()
    @test p.discount(m) == 1.0
    state = p.generate_start_state(m)
    @test -10 <= rand(p.transition(m, state, rand())) <= 10
    @test p.reward(m, state, rand()) <= 0
    mdp = MDP(m)
end

@testset "mountain_car.jl" begin
    m = MountainCar()
    @test p.n_actions(m) == 3 && p.ordered_actions(m) == [1, 2, 3]
    @test p.discount(m) == 1.0
    state_min = [-1.2, -0.07]
    state_max = [0.6, 0.07]
    start_state = p.generate_start_state(m)
    @test all(state_min <= start_state <= state_max)
    @test all(state_min <= p.mountain_car_transition(start_state, 1) <= state_max)
    @test p.reward(m, start_state, 1) <= 0
    mdp = MDP(m)
end


# POMDP

@testset "crying_baby.jl" begin
    m = CryingBaby()
    @test p.n_states(m) == 2 && p.ordered_states(m) == [1, 2]
    @test p.n_actions(m) == 3 && p.ordered_actions(m) == [1, 2, 3]
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == [true, false]
    @test p.discount(m) == 0.9
    p.transition(m, rand(1:2), rand(1:3))
    @test 0 <= p.observation(m, rand(1:3), rand(1:2)).p <= 1
    @test p.reward(m, rand(1:2), rand(1:3)) <= 0
    @test p.reward(m, [0.1, 0.9], rand(1:3)) <= 0
    pomdp = p.POMDP(m)
end

@testset "machine_replacement.jl" begin
    mdp = MachineReplacement()
    m = DiscretePOMDP(mdp)
    @test p.n_states(m) == 3 && p.ordered_states(m) == 1:3
    @test p.n_actions(m) == 4 && p.ordered_actions(m) == 1:4
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == 1:2
    @test p.discount(m) == 1.0
    @test rand(p.transition(m, rand(1:3), rand(1:4))) in 1:3
    @test rand(p.observation(m, rand(1:4), rand(1:3))) in 1:2
    @test p.reward(m, rand(1:3), rand(1:4)) <= 1.0
    pomdp = p.POMDP(m)
end

@testset "catch.jl" begin
    mdp = Catch()
    m = DiscretePOMDP(mdp)
    @test p.n_states(m) == 4 && p.ordered_states(m) == 1:4
    @test p.n_actions(m) == 10 && p.ordered_actions(m) == 1:10
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == 1:2
    @test p.discount(m) == 0.9
    @test rand(p.transition(m, rand(1:4), rand(1:10))) in 1:4
    @test rand(p.observation(m, rand(1:10), rand(1:4))) in 1:2
    @test p.reward(m, rand(1:4), rand(1:10)) >= 0
    pomdp = p.POMDP(m)
end


# Simple Game

@testset "prisoners_dilemma.jl" begin
    m = PrisonersDilemma()
    @test p.n_agents(m) == 2
    @test length(p.ordered_actions(m, rand(1:2))) == 2 && length(p.ordered_joint_actions(m)) == 4
    @test p.n_actions(m, rand(1:2)) == 2 && p.n_joint_actions(m) == 4
    @test p.reward(m, rand(1:2), [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= 0.0
    @test p.joint_reward(m, [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= [0.0, 0.0]
    simplegame = p.SimpleGame(m)
end

@testset "rock_paper_scissors.jl" begin
    m = RockPaperScissors()
    @test p.n_agents(m) == 2
    @test length(p.ordered_actions(m, rand(1:2))) == 3 && length(p.ordered_joint_actions(m)) == 9
    @test p.n_actions(m, rand(1:2)) == 3 && p.n_joint_actions(m) == 9
    @test -1.0 <= p.reward(m, rand(1:2), [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= 1.0
    @test [-1.0, -1.0] <= p.joint_reward(m, [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= [1.0, 1.0]
    simplegame = p.SimpleGame(m)
end

@testset "travelers.jl" begin
    m = Travelers()
    @test p.n_agents(m) == 2
    @test length(p.ordered_actions(m, rand(1:2))) == 99 && length(p.ordered_joint_actions(m)) == 99^2
    @test p.n_actions(m, rand(1:2)) == 99 && p.n_joint_actions(m) == 99^2
    @test 0.0 <= p.reward(m, rand(1:2), [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= 102
    @test [0.0, 0.0] <= p.joint_reward(m, [rand(p.ordered_actions(m, 0)), rand(p.ordered_actions(m, 0))]) <= [102, 102]
    simplegame = p.SimpleGame(m)
end


# Markov Game

@testset "predator_prey.jl" begin
    m = PredatorPreyHexWorld()
    hexes = m.hexes
    @test p.n_agents(m) == 2
    @test length(p.ordered_states(m, rand(1:2))) == length(hexes) && length(p.ordered_states(m)) == length(hexes)^2
    @test length(p.ordered_actions(m, rand(1:2))) == 6 && length(p.ordered_joint_actions(m)) == 36
    @test p.n_actions(m, rand(1:2)) == 6 && p.n_joint_actions(m) == 36

    @test 0.0 <= p.transition(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m)), rand(p.ordered_states(m))) <= 1.0
    @test -1.0 <= p.reward(m, rand(1:2), rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m))) <= 10.0
    @test [-1.0, -1.0] <= p.joint_reward(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m))) <= [10.0, 10.0]
    mg = p.MG(m)
end

# POMG

@testset "multicaregiver.jl" begin
    m = MultiCaregiverCryingBaby()
    @test p.n_agents(m) == 2
    @test length(p.ordered_states(m)) == 2
    @test length(p.ordered_actions(m, rand(1:2))) == 3 && length(p.ordered_joint_actions(m)) == 9
    @test p.n_actions(m, rand(1:2)) == 3 && p.n_joint_actions(m) == 9
    @test length(p.ordered_observations(m, rand(1:2))) == 2 && length(p.ordered_joint_observations(m)) == 4
    @test p.n_observations(m, rand(1:2)) == 2 && p.n_joint_observations(m) == 4

    @test 0.0 <= p.transition(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m)), rand(p.ordered_states(m))) <= 1.0
    @test 0.0 <= p.joint_observation(m, rand(p.ordered_joint_actions(m)), rand(p.ordered_states(m)), rand(p.ordered_joint_observations(m))) <= 1.0
    @test p.joint_reward(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m))) <= [0.0, 0.0]
    @test p.joint_reward(m, rand(Float64, 2), rand(p.ordered_joint_actions(m))) <= [0.0, 0.0]
    pomg = p.POMG(m)
end


# DecPOMDP

@testset "collab_predator_prey.jl" begin
    m = CollaborativePredatorPreyHexWorld()
    hexes = m.hexes
    @test p.n_agents(m) == 2
    @test length(p.ordered_states(m, rand(1:2))) == length(hexes) && length(p.ordered_states(m)) == length(hexes)^3
    @test length(p.ordered_actions(m, rand(1:2))) == 6 && length(p.ordered_joint_actions(m)) == 36
    @test p.n_actions(m, rand(1:2)) == 6 && p.n_joint_actions(m) == 36
    @test length(p.ordered_observations(m, rand(1:2))) == 2 && length(p.ordered_joint_observations(m)) == 4
    @test p.n_observations(m, rand(1:2)) == 2 && p.n_joint_observations(m) == 4

    @test 0.0 <= p.transition(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m)), rand(p.ordered_states(m))) <= 1.0
    @test 0.0 <= p.joint_observation(m, rand(p.ordered_joint_actions(m)), rand(p.ordered_states(m)), rand(p.ordered_joint_observations(m))) <= 1.0
    @test -1.0 <= p.reward(m, rand(p.ordered_states(m)), rand(p.ordered_joint_actions(m))) <= 10.0
    decpomdp = p.DecPOMDP(m)
end
