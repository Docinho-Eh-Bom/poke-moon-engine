local check_result = {}
local finish = require("battle.statemachine.states.finish")
local start_turn = require("battle.statemachine.states.start_turn")
local pokemon = require("battle.pokemon")

function check_result:update(machine)

    local turn = machine.turn

    if pokemon.isFainted(turn.p1) then
        print(turn.p2.name.." wins!")
        machine:change(finish)
        return
    end

    if pokemon.isFainted(turn.p2) then
        print(turn.p1.name.." wins!")
        machine:change(finish)
        return
    end

    machine:change(start_turn)
end

return check_result