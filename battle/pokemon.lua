local pokemon = {}

local pokemonService = require("service.pokemon_service")

function pokemon.new(specie, level)
    local pokemonBase, err = pokemonService.getPokemon(specie)
    if pokemonBase == nil then
        return nil, err
    end

    local hp = pokemonService.calcHP(specie, level)
    if not hp then
        return nil, "Failed to calculate"
    end

    local newPokemon = {
        id = pokemonBase.id, --Using pokedex id FOR NOW, change it later for an original id (full pikachu team lets go)
        name = pokemonBase.name,
        level = level,
        types = pokemonBase.types,
        stats = {
            hp = hp,
            attack = pokemonService.calcAtk(specie, level),
            specialAttack = pokemonService.calcSpeAtk(specie, level),
            defense = pokemonService.calcDef(specie, level),
            specialDefense = pokemonService.calcSpeDef(specie, level),
            speed = pokemonService.calcSpe(specie, level)
        },
        currentHP = hp,
        moves = {}
    }

    return newPokemon
end

function pokemon.takeDmg(p, dmg)
    p.currentHP = p.currentHP-dmg

    if p.currentHP < 0 then
        p.currentHP = 0
    end
end

function pokemon.isFainted(p)
    return p.currentHP <= 0
end

return pokemon