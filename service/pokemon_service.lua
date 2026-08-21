local pokemonService = {}
local pkmCache = {}

local importer = require("utils.importer")

function pokemonService.getPokemon(name)
    if pkmCache[name] then
        return pkmCache[name]
    end

    local data, err = importer.requestPokemon(name)
    if not data then
        return  nil, err
    end

    local types = {}
    for _, t in ipairs(data.types) do
        table.insert(types, t.type.name)
    end

    local stats_base = {}
    for _, stat in ipairs(data.stats) do
        stats_base[stat.stat.name] = stat.base_stat
    end

    local possibleMoves = {}
    for _, entry in ipairs(data.moves) do
        table.insert(possibleMoves, entry.move.name)
    end

    local pokemon = {
        id = data.id,
        name = data.name,
        types = types,
        stats_base = stats_base,
        possibleMoves = possibleMoves
    }

    pkmCache[name] = pokemon
    return pokemon
end


function pokemonService.getPossibleMoves(name)
    local pokemon, err = pokemonService.getPokemon(name)
    if not pokemon then
        return nil, err
    end

    return pokemon.possibleMoves
end

function pokemonService.printPokemon(name)
    local pokemon, err = pokemonService.getPokemon(name)
    local pokemonTypes
    if not pokemon then
        return nil, err
    end

    if pokemon ~= nil then
        if not pokemon.types[2] then
            pokemonTypes = pokemon.types[1]
        else
            pokemonTypes = pokemon.types[1].."/"..pokemon.types[2]
        end

        print("id: "..pokemon.id)
        print("name: "..pokemon.name)
        print("types: "..pokemonTypes)
        print("hp: "..pokemon.stats_base.hp)
        print("attack: "..pokemon.stats_base.attack)
        print("defense: "..pokemon.stats_base.defense)
        print("special attack: "..pokemon.stats_base["special-attack"])
        print("special defense: "..pokemon.stats_base["special-defense"])
        print("speed: "..pokemon.stats_base.speed)
    else
        print("Pokemon not found.")
        return nil
    end
end

function pokemonService.calcHP(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseHP = pokemon.stats_base.hp
    local hp = math.floor(((pokemonBaseHP*2*level)/100)+level+10)
    return hp

end

function pokemonService.calcAtk(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseA = pokemon.stats_base.attack
    local atk = ((pokemonBaseA*2)*level/100)+5
    return atk
end

function pokemonService.calcSpeAtk(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseSpeA = pokemon.stats_base["special-attack"]
    local speAtk = ((pokemonBaseSpeA*2)*level/100)+5
    return speAtk
end

function pokemonService.calcDef(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseD = pokemon.stats_base.defense
    local def = ((pokemonBaseD*2)*level/100)+5
    return def
end

function pokemonService.calcSpeDef(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseSpeD = pokemon.stats_base["special-defense"]
    local speDef = ((pokemonBaseSpeD*2)*level/100)+5
    return speDef

end

function pokemonService.calcSpe(specie, level)
    local pokemon, err = pokemonService.getPokemon(specie)
    if not pokemon then
        return nil, err
    end

    local pokemonBaseSpe = pokemon.stats_base.speed
    local spe = ((pokemonBaseSpe*2)*level/100)+5
    return spe
end

return pokemonService