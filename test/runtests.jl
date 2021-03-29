using DecisionMakingProblems
# using PGFPlots
using Test
using Random

# @assert success(`lualatex -v`)
# using NBInclude
# @nbinclude(joinpath(dirname(@__FILE__), "..", "doc", "PGFPlots.ipynb"))
const p = DecisionMakingProblems

@testset "cart_pole.jl" begin
    m = p.CartPole(1.0, 10.0, 1.0, 1.0, 0.1, 9.8, 0.02, 4.8, deg2rad(24))
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
    p.get_mdp_type(m)
end
@testset "collision_avoidance.jl" begin
    # m = p.CollisionAvoidanceMDP()
    # distrib = p.CollisionAvoidanceStateDistribution()
    # s = p.rand(distrib)
    # simple_pol = p.SimpleCollisionAvoidancePolicy()
    # optimal_pol = p.OptimalCollisionAvoidancePolicy()
    # @test length(p.vec(p.transition(m, s, optimal_pol(s)))) == 4
    # @test p.is_terminal(m, s) == p.vec(s)[4] < 0.0
    # @test p.reward(p.transition(m, s, optimal_pol(s))) <= 0
    # p.CollisionAvoidanceValueFunction(m, simple_pol)
end

@testset "hexworld.jl" begin
    hexes = [(0,0),(1,0),(2,0),(3,0),(0,1),(1,1),(2,1),(-1,2),
     (0,2),(1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),
     (8,2),(4,1),(5,0),(6,0),(7,0),(7,1),(8,1),(9,0)]
    m = p.HexWorldMDP(
        hexes,
        -1.0,
        0.7,
        Dict{Tuple{Int,Int}, Float64}(
            (0,1)=>  5.0, # left side reward
            (2,0)=>-10.0, # left side hazard
            (9,0)=> 10.0, # right side reward
        ),
        0.9
    )
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
end
@testset "simple_lqr.jl" begin
    m = p.LqrMDP(0.9)
    @test p.discount(m) == 0.9
    state = p.generate_start_state(m)
    @test -10 <= rand(p.transition(m, state, rand())) <= 10
    @test p.reward(m, state, rand()) <= 0
    p.get_mdp_type(m)
end

@testset "mountain_car.jl" begin
    m = p.MountainCar(0.9)
    @test p.n_actions(m) == 3 && p.ordered_actions(m) == [1, 2, 3]
    @test p.discount(m) == 0.9
    state_min = [-1.2, -0.07]
    state_max = [0.6, 0.07]
    start_state = p.generate_start_state(m)
    @test all(state_min <= start_state <= state_max)
    @test all(state_min <= p.mountain_car_transition(start_state, 1) <= state_max)
    @test p.reward(m, start_state, 1) <= 0
    p.get_mdp_type(m)
end


@testset "crying_baby.jl" begin
    m = p.BabyPOMDP(-10.0, -5.0, -0.5, 0.1, 0.8, 0.1, 0.9, 0.9)
    @test p.n_states(m) == 2 && p.ordered_states(m) == [1, 2]
    @test p.n_actions(m) == 3 && p.ordered_actions(m) == [1, 2, 3]
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == [true, false]
    @test p.discount(m) == 0.9
    p.transition(m, rand(1:2), rand(1:3))
    @test 0 <= p.observation(m, rand(1:3), rand(1:2)).p <= 1
    @test p.reward(m, rand(1:2), rand(1:3)) <= 0
    @test p.reward(m, [0.1, 0.9], rand(1:3)) <= 0
end

@testset "machine_replacement.jl" begin
    m = p.generate_machine_replacement_pomdp(1.0)
    @test p.n_states(m) == 3 && p.ordered_states(m) == 1:3
    @test p.n_actions(m) == 4 && p.ordered_actions(m) == 1:4
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == 1:2
    @test p.discount(m) == 1.0
    @test rand(p.transition(m, rand(1:3), rand(1:4))) in 1:3
    @test rand(p.observation(m, rand(1:4), rand(1:3))) in 1:2
    @test p.reward(m, rand(1:3), rand(1:4)) <= 1.0
    p.get_pomdp_type(m)
end

@testset "catch.jl" begin
    m = p.generate_catch_pomdp(0.9)
    @test p.n_states(m) == 4 && p.ordered_states(m) == 1:4
    @test p.n_actions(m) == 10 && p.ordered_actions(m) == 1:10
    @test p.n_observations(m) == 2 && p.ordered_observations(m) == 1:2
    @test p.discount(m) == 0.9
    @test rand(p.transition(m, rand(1:4), rand(1:10))) in 1:4
    @test rand(p.observation(m, rand(1:10), rand(1:4))) in 1:2
    @test p.reward(m, rand(1:4), rand(1:10)) >= 0
    p.get_pomdp_type(m)
end
