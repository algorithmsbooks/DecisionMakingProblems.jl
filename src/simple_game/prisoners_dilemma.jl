struct PrisonersDilemmaSimpleGame end

n_agents(simpleGame::PrisonersDilemmaSimpleGame) = 2

ordered_actions(simpleGame::PrisonersDilemmaSimpleGame, i::Int) = [:cooperate, :defect]
ordered_joint_actions(simpleGame::PrisonersDilemmaSimpleGame) = vec(collect(Iterators.product([ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))

n_joint_actions(simpleGame::PrisonersDilemmaSimpleGame) = length(ordered_joint_actions(simpleGame))
n_actions(simpleGame::PrisonersDilemmaSimpleGame, i::Int) = length(ordered_actions(simpleGame, i))

function reward(simpleGame::PrisonersDilemmaSimpleGame, i::Int, a)
    if i == 1
        noti = 2
    else
        noti = 1
    end

    if a[i] == :cooperate && a[noti] == :cooperate
        return -1.0
    elseif a[i] == :defect && a[noti] == :cooperate
        return 0.0
    elseif a[i] == :cooperate && a[noti] == :defect
        return -4.0
    elseif a[i] == :defect && a[noti] == :defect
        return -3.0
    end
end

function joint_reward(simpleGame::PrisonersDilemmaSimpleGame, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end

function SimpleGame(simpleGame::PrisonersDilemmaSimpleGame)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end
