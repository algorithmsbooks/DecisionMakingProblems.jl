struct Travelers end

n_agents(simpleGame::Travelers) = 2

ordered_actions(simpleGame::Travelers, i::Int) = 2:100
ordered_joint_actions(simpleGame::Travelers) = vec(collect(Iterators.product([ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))

n_joint_actions(simpleGame::Travelers) = length(ordered_joint_actions(simpleGame))
n_actions(simpleGame::Travelers, i::Int) = length(ordered_actions(simpleGame, i))

function reward(simpleGame::Travelers, i::Int, a)
    if i == 1
        noti = 2
    else
        noti = 1
    end
    if a[i] == a[noti]
        r = a[i]
    elseif a[i] < a[noti]
        r = a[i] + 2
    else
        r = a[noti] - 1
    end
    return r
end

function joint_reward(simpleGame::Travelers, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end

function SimpleGame(simpleGame::Travelers)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end
