struct RockPaperScissors end

n_agents(simpleGame::RockPaperScissors) = 2

ordered_actions(simpleGame::RockPaperScissors, i::Int) = [:rock, :paper, :scissors]
ordered_joint_actions(simpleGame::RockPaperScissors) = vec(collect(Iterators.product([ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))

n_joint_actions(simpleGame::RockPaperScissors) = length(ordered_joint_actions(simpleGame))
n_actions(simpleGame::RockPaperScissors, i::Int) = length(ordered_actions(simpleGame, i))

function reward(simpleGame::RockPaperScissors, i::Int, a)
    if i == 1
        noti = 2
    else
        noti = 1
    end

    if a[i] == a[noti]
        r = 0.0
    elseif a[i] == :rock && a[noti] == :paper
        r = -1.0
    elseif a[i] == :rock && a[noti] == :scissors
        r = 1.0
    elseif a[i] == :paper && a[noti] == :rock
        r = 1.0
    elseif a[i] == :paper && a[noti] == :scissors
        r = -1.0
    elseif a[i] == :scissors && a[noti] == :rock
        r = -1.0
    elseif a[i] == :scissors && a[noti] == :paper
        r = 1.0
    end

    return r
end

function joint_reward(simpleGame::RockPaperScissors, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end

function SimpleGame(simpleGame::RockPaperScissors)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end
