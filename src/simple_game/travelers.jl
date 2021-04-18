struct TravelersSimpleGame end

n_agents(simpleGame::TravelersSimpleGame) = 2

ordered_actions(simpleGame::TravelersSimpleGame, i::Int) = 2:100
ordered_joint_actions(simpleGame::TravelersSimpleGame) = vec(collect(Iterators.product([ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))

n_joint_actions(simpleGame::TravelersSimpleGame) = length(ordered_joint_actions(simpleGame))
n_actions(simpleGame::TravelersSimpleGame, i::Int) = length(ordered_actions(simpleGame, i))

function reward(simpleGame::TravelersSimpleGame, i::Int, a)
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

function joint_reward(simpleGame::TravelersSimpleGame, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end

function SimpleGame(simpleGame::TravelersSimpleGame)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end
