local turn = {}

local stateMachine = require("battle.statemachine.state_machine")
local start_turn  = require("battle.statemachine.states.start_turn")

turn.__index = turn

function turn.new(p1, p2, battle)
    local self = setmetatable({}, turn)

    self.p1 = p1
    self.p2 = p2
    self.battle = battle

    self.p1Choice = nil
    self.p2Choice = nil

    self.actionQueue = {}
    self.currentAction = 1

    self.machine = stateMachine.new(start_turn)
    self.machine.turn = self
    self.machine.current:enter(self.machine)

    return self
end

function turn:update(...)
    self.machine:update(...)
end

return turn