local finish = {}

function finish:enter(machine)
    machine.turn.battle.active = false
    print("Battle finished!")
end

return finish