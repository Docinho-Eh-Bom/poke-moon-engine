local moveService = {}
local moveCache = {}

local importer = require("utils.importer")

--[[
    accuracy
    id
    learned_by_pokemon
    name
    power
    pp
    priority
    type.name 
]]

function moveService.getMove(name)
    if moveCache[name] then
        return moveCache[name]
    end

    local move, err = importer.requestMove(name)
    if not move then
        return nil, err
    end

    moveCache[name] = move
    return move
end

function moveService.getMoveAccuracy(name)
    local m = moveService.getMove(name)
    if m ~= nil then
        return m.accuracy
    else
        return nil
    end
end

function moveService.getMovePower(name)
    local m = moveService.getMove(name)
    if m ~= nil then
        return m.power
    else
        return nil
    end
end

function moveService.getMovePP(name)
    local m = moveService.getMove(name)
    if m ~= nil then
        return m.pp
    else
        return nil
    end
end

function moveService.getMovePriority(name)
    local m = moveService.getMove(name)
    if m ~= nil then
        return m.priority
    else
        return nil
    end
end

function moveService.assembleMove(name)
    local m, err = moveService.getMove(name)
    if not m then
        return nil, err
    end

    local move = {
        id = m.id,
        name = m.name,
        power = m.power,
        pp = m.pp,
        accuracy = m.accuracy,
        priority = m.priority,
        type = m.type.name,
    }
    return move
end

function moveService.canLearn(name, pokemon)
    local m, err = moveService.getMove(name)

    if not m then
        return nil, err
    end

    if not m.learned_by_pokemon then
        return false
    end

    for _, entry in ipairs(m.learned_by_pokemon) do
        if entry.name == pokemon then
            return true
        end
    end
    
    return false
end

function moveService.printMove(name)
    local m = moveService.assembleMove(name)
    if m ~= nil then
        print("id: "..m.id)
        print("Name: "..m.name)
        print("Type: "..m.type)
        print("Power: "..m.power)
        print("PP: "..m.pp)
        print("Accuracy: "..m.accuracy)
        print("Priority: "..m.priority)
    end
end

return moveService