local move = {}

local moveService = require("service.moves_service")

function move.new(name, pokemon)
    local l, errL = moveService.canLearn(name, pokemon.name)
    if l == nil then
        return nil, errL
    end

    if not l then
        return nil, pokemon.name.." cannot learn "..name
    end

    local mBase, err = moveService.assembleMove(name)
    if not mBase then
        return nil, err
    end

    local m = {
        id = mBase.id,
        name = mBase.name,
        power = mBase.power,
        pp = mBase.pp,
        currentPP = mBase.pp,
        accuracy = mBase.accuracy,
        priority = mBase.priority,
        type = mBase.type
    }

    return m
end

function move.addMove(name, pokemon)
    local m, err = move.new(name, pokemon)
    if not m then
        return nil, err
    end

    table.insert(pokemon.moves, m)
    return true
end


function move.use(name)
    local m = name
    if m.currentPP <= 0 then
        return false
    end

    m.currentPP = m.currentPP - 1
    return true
end

function move.canHit(name)
    local m = name
    return math.random(100) <= m.accuracy
end


return move