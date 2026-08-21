local https = require("ssl.https")
local json = require("dkjson")
local importer = {}

--all req work with name or id 

function importer.requestPokemon(pkmName)
    local body, status = https.request("https://pokeapi.co/api/v2/pokemon/"..pkmName)

    if not body then
        return nil, "HTTP request failed: "..tostring(status)
    end

    if status ~= 200 then
        return nil, "HTTP "..tostring(status)
    end

    local data = json.decode(body)

    if not data then
        return nil
    end

    return data
end

function importer.requestType(typeName)
    local body, status = https.request("https://pokeapi.co/api/v2/type/"..typeName)

    if not body then
        return nil, "HTTP request failed: "..tostring(status)
    end

    if status ~= 200 then
        return nil, "HTTP "..tostring(status)
    end

    local data = json.decode(body)

    if not data then
        return nil
    end

    return data
end

function importer.requestMove(moveName)
    local body, status = https.request("https://pokeapi.co/api/v2/move/"..moveName)

    if not body then
        return nil, "HTTP request failed: "..tostring(status)
    end

    if status ~= 200 then
        return nil, "HTTP "..tostring(status)
    end

    local data = json.decode(body)

    if not data then
        return nil
    end

    return data
end

return importer