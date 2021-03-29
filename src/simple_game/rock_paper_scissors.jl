struct RockPaperScissorsSimpleGame end

n_agents(simpleGame::RockPaperScissorsSimpleGame) = 2

ordered_actions(simpleGame::RockPaperScissorsSimpleGame, i::Int) = [:rock, :paper, :scissors]
ordered_joint_actions(simpleGame::RockPaperScissorsSimpleGame) = vec(collect(Iterators.product([actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))

n_joint_actions(simpleGame::RockPaperScissorsSimpleGame) = length(joint_actions(simpleGame))
n_actions(simpleGame::RockPaperScissorsSimpleGame, i::Int) = length(actions(simpleGame))

function reward(simpleGame::RockPaperScissorsSimpleGame, i::Int, a)
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

function joint_reward(simpleGame::RockPaperScissorsSimpleGame, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end

function get_simple_game_type(simpleGame::RockPaperScissorsSimpleGame)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end

RockPaperScissors = RockPaperScissorsSimpleGame()