north(s::CartesianIndex{2}) = CartesianIndex(s[1]-1, s[2])
east(s::CartesianIndex{2}) = CartesianIndex(s[1], s[2]+1)
south(s::CartesianIndex{2}) = CartesianIndex(s[1]+1, s[2])
west(s::CartesianIndex{2}) = CartesianIndex(s[1], s[2]-1)

# States are represented by 2d Cartesian indices
# Our maze is a bitmatrix where tiles are filled if the entry is true.
# You display the maze the same way Julia displays matrices.
# Increasing state[1] thus moves you south.
# Increasing state[2] thus moves you east.
struct SpelunkerJoe
    maze::BitMatrix # Tiles are either filled or not.
end

struct SpelunkerJoeTransitionDistribution
    s::CartesianIndex{2}
end
Distributions.rand(D::SpelunkerJoeTransitionDistribution) = D.s
function Distributions.pdf(D::SpelunkerJoeTransitionDistribution, s::CartesianIndex{2})
    if s == D.s
        return 1.0
    else
        return 0.0
    end
end



# Whether there is a wall in each direction.
# NOTE: We also use this as the distribution.
struct SpelunkerJoeObservation
    north::Bool
    east::Bool
    south::Bool
    west::Bool
end
Distributions.rand(O::SpelunkerJoeObservation) = O
Distributions.pdf(O::SpelunkerJoeObservation, o::SpelunkerJoeObservation) =
    O == o ? 1.0 : 0.0

function transition(pomdp::SpelunkerJoe, s::CartesianIndex{2}, a::Nothing)
    return SpelunkerJoeTransitionDistribution(s)
end

function observation(pomdp::SpelunkerJoe, a::Nothing, s′::CartesianIndex{2})
    m = pomdp.maze
    return SpelunkerJoeObservation(m[north(s′)], m[east(s′)], m[south(s′)], m[west(s′)])
end

generate_s(pomdp::SpelunkerJoe, s::CartesianIndex{2}, a::Nothing) = s
generate_so(pomdp::SpelunkerJoe, s::CartesianIndex{2}, a::Nothing) =
    (s, observation(pomdp, a, s))

function init_belief(u::SpelunkerJoe, o::SpelunkerJoeObservation, n_in_each_valid_state::Int)
    b = CartesianIndex{2}[]
    for x in 2 : size(u.maze, 1) - 1
        for y in 2 : size(u.maze, 2) - 1
            s_particle, o_particle = generate_so(u, CartesianIndex(x,y), nothing)
            if o_particle == o
                for j in 1 : n_in_each_valid_state
                    push!(b, s_particle)
                end
            end
        end
    end
    return b
end

struct SpelunkerJoeUniformStateDistribution
    pomdp::SpelunkerJoe
end
function Base.rand(D::SpelunkerJoeUniformStateDistribution)
    s = CartesianIndex(1,1)
    # Use reservoir sampling to generate an open space.
    k = 0
    for x in 1 : size(D.pomdp.maze, 1)
        for y in 1 : size(D.pomdp.maze, 2)
            if !D.pomdp.maze[x,y]
                k += 1
                if rand() <= 1/k
                    s = CartesianIndex(x,y)
                end
            end
        end
    end
    return s
end
Base.rand(D::SpelunkerJoeUniformStateDistribution, m::Int) =
    [rand(D) for i in 1 : m]