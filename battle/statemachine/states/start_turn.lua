local start_turn = {}

function start_turn:enter(machine)
    local turn = machine.turn

    turn.p1Choice = nil
    turn.p2Choice = nil
    print("Turn Started!\n")
end

function start_turn:update(machine)
    machine:change(machine.states.choice)
end

return start_turn