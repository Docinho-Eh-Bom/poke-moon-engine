local resolve = {}
local damage = require("battle.damage")
local pokemon = require("battle.pokemon")
local battleMove = require("battle.move")

function resolve:enter(machine)
    local turn = machine.turn
    local p1 = turn.p1
    local p2 = turn.p2

    turn.actionQueue = {}

    local actions = {
        {attacker = p1,
        defender = p2,
        move = turn.p1Choice},
        {attacker = p2,
        defender = p1,
        move = turn.p2Choice}
    }

    table.sort(actions, function (a, b)
        if a.move.priority ~= b.move.priority then
            return a.move.priority > b.move.priority
        end

        if a.attacker.stats.speed ~= b.attacker.stats.speed then
            return a.attacker.stats.speed > b.attacker.stats.speed
        end

        return math.random(2) == 1
    end)

    turn.actionQueue = actions
    turn.currentAction = 1
end

function resolve:update(machine)
    local turn = machine.turn
    local action = turn.actionQueue[turn.currentAction]

    if not action then
        machine:change(machine.states.check_result)
        return
    end

    if battleMove.use(action.move) then
        if battleMove.canHit(action.move) then
            local dmg, err = damage.calcDamage(action.attacker, action.defender, action.move)
            if not dmg then
                print("Failed to calculate damage: "..tostring(err))
                machine:change(machine.states.finish)
                return
            end

            pokemon.takeDmg(action.defender, dmg)

            print(action.attacker.name.." used "..action.move.name)
            print(action.defender.name.." took "..dmg.." damage!")
            print(action.defender.name.." HP: "..action.defender.currentHP.."\n")
            turn.currentAction = turn.currentAction + 1
        else
            print(action.attacker.name.." missed "..action.move.name.."!\n")
            turn.currentAction = turn.currentAction + 1
        end
    end
end

return resolve