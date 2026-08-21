local typeService = {}
local typeCache = {}

local importer = require("utils.importer")

function typeService.getType(name)
    if typeCache[name] then
        return typeCache[name]
    end

    local type, err = importer.requestType(name)
    if not type then
        return nil, err
    end

    if type then
        typeCache[name] = type
    end

    return type
end

function typeService.getTypeMoves(name)
    local type, err = typeService.getType(name)
    if not type then
        return nil, err
    end

    local t = {
        moves = {}
    }

    for i = 1, #type.moves do
        table.insert(t.moves, type.moves[i].name)
    end
    return t
end

function typeService.getTypeRelations(name)
    local type, err = typeService.getType(name)
    if not type then
        return nil, err
    end

    local t = {
        double_damage_from = {},
        double_damage_to = {},
        half_damage_from = {},
        half_damage_to = {},
        no_damage_from = {},
        no_damage_to = {}
    }

    for i = 1, #type.damage_relations.double_damage_from do
    table.insert(t.double_damage_from, type.damage_relations.double_damage_from[i].name)
    end

    for i = 1, #type.damage_relations.double_damage_to do
    table.insert(t.double_damage_to, type.damage_relations.double_damage_to[i].name)
    end

    for i = 1, #type.damage_relations.half_damage_from do
    table.insert(t.half_damage_from, type.damage_relations.half_damage_from[i].name)
    end

    for i = 1, #type.damage_relations.half_damage_to do
    table.insert(t.half_damage_to, type.damage_relations.half_damage_to[i].name)
    end

    for i = 1, #type.damage_relations.no_damage_from do
    table.insert(t.no_damage_from, type.damage_relations.no_damage_from[i].name)
    end

    for i = 1, #type.damage_relations.no_damage_to do
    table.insert(t.no_damage_to, type.damage_relations.no_damage_to[i].name)
    end

    return t
end

function typeService.printTypeRelations(name)
    local t = typeService.getTypeRelations(name)
    if t ~= nil then
        print("Type: "..name)
        for i = 1, #t.double_damage_from do
            print("Takes 2x damage from: "..t.double_damage_from[i])
        end

        for i = 1, #t.double_damage_to do
        print("Do 2x damage to: "..t.double_damage_to[i])
        end

        for i = 1, #t.half_damage_from do
        print("Takes 1.5x damage from: "..t.half_damage_from[i])
        end

        for i = 1, #t.half_damage_to do
        print("Do 1.5x damage to: "..t.half_damage_to[i])
        end

        for i = 1, #t.no_damage_from do
        print("Takes 0x damage from: "..t.no_damage_from[i])
        end

        for i = 1, #t.no_damage_to do
        print("Do 0x damage to: "..t.no_damage_to[i])
        end
    else
        print("Type not found.")
        return nil
    end
end

function typeService.printTypeMoves(name)
    local t = typeService.getTypeMoves(name)
    if t ~= nil then
        print("Type: "..name)
        print("Moves: ")
        for i = 1, #t.moves do
            print(t.moves[i])
        end
    else
        print("Type not found.")
        return nil
    end
end

return typeService