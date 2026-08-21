local battle = {}

battle.__index = battle
local turn = require("battle.turn.turn")

function battle.new(p1, p2)

    local self = setmetatable({}, battle)
    self.pokemon1 = p1
    self.pokemon2 = p2

    self.turnNumber = 1
    self.currentTurn = nil
    self.active = true

    self.currentTurn = turn.new(p1, p2, self)

    return self
end

function battle:update()
    if self.active then
        self.currentTurn:update()
    end
end

return battle