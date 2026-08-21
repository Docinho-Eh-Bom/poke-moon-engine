--simple battle test simulation
local Pokemon = require("battle.pokemon")
local Move = require("battle.move")
local Battle = require("battle.battle")

local charmander = Pokemon.new("charmander", 10)
local pikachu = Pokemon.new("pikachu", 10)

Move.addMove("scratch", charmander)
Move.addMove("ember", charmander)
Move.addMove("headbutt", pikachu)

local battle = Battle.new(charmander, pikachu)

while battle.active do
    battle:update()
end