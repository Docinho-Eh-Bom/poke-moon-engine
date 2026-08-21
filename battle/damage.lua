local dmgFunc = {}

local typeService = require("service.type_service")

function dmgFunc.getEffectiveness(typeAttack, typeDefense)
    local relations, err = typeService.getTypeRelations(typeAttack)
    if not relations then
        return nil, err
    end
    local typeSuperEffective = relations.double_damage_to
    local typeNotEffective = relations.half_damage_to
    local typeNoDamage = relations.no_damage_to

    if not typeNotEffective or not typeSuperEffective or not typeNoDamage then
        print("Type not found.")
        return nil
    end

    for _, effectiveType in ipairs(typeSuperEffective) do
        --print("super:"..effectiveType)
        if effectiveType == typeDefense then
            return 2
        end
    end

    for _, effectiveType in ipairs(typeNotEffective) do
        --print("not:"..effectiveType)
        if effectiveType == typeDefense then
        return 0.5
        end
    end

    for _, effectiveType in ipairs(typeNoDamage) do
        --print("no dmg:"..effectiveType)
        if effectiveType == typeDefense then
        return 0
        end
    end

    return 1
end

function dmgFunc.getTotalEffectiveness(typeAttack, defenderTypes)
    local total = 1

    for _, typeDefense in ipairs(defenderTypes) do
        local eff, err = dmgFunc.getEffectiveness(typeAttack, typeDefense)
        if not eff then
            return nil, err
        end

        total = total*eff
    end

    return total
end

function dmgFunc.stab(typeAttack, attackerTypes)
    for _, typePkmn in ipairs(attackerTypes) do
        if typeAttack == typePkmn then
            return 1.5
        end
    end

    return 1
end

function dmgFunc.damageMultiplier(typeAttack, defenderTypes, typePkmn)
    local eff, err = dmgFunc.getTotalEffectiveness(typeAttack, defenderTypes)
    if not eff then
        return nil, err
    end

    local stb = dmgFunc.stab(typeAttack, typePkmn)
    local multi = (eff*stb)
    return multi
end

function dmgFunc.randDmg(dmg)
    local rand = math.random(217,255)
    return math.floor(dmg*rand/255)
end

function dmgFunc.calcDamage(p1, p2, move)
    local m = move

    local pow = m.power
    local A = p1.stats.attack
    local D = p2.stats.defense

    local dmgMulti, err = dmgFunc.damageMultiplier(m.type, p2.types, p1.types)

    if not dmgMulti then
        return nil, err
    end

    local b1 = math.floor((2*p1.level)/5)+2
    local b2 = math.floor(b1*pow*(A/D))
    local b3 = math.floor(b2/50)+2

    local dmg = math.floor(b3*dmgMulti)

    local finalDmg = dmgFunc.randDmg(dmg)
    return finalDmg
end

return dmgFunc