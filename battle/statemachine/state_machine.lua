    local stateMachine = {}

    stateMachine.__index = stateMachine


    function stateMachine.new(initialState) -- func for the start 
        local machine = {
            current = initialState,
            states = {
                start_turn = require("battle.statemachine.states.start_turn"),
                choice = require("battle.statemachine.states.choice"),
                resolve = require("battle.statemachine.states.resolve"),
                check_result = require("battle.statemachine.states.check_result"),
                finish = require("battle.statemachine.states.finish")
            }
        }

        setmetatable(machine, stateMachine)

        return machine
    end

    function stateMachine:change(newState)
        if self.current and self.current.exit then
            self.current:exit(self)
        end

        self.current = newState

        if self.current and self.current.enter then
            self.current:enter(self)
        end
    end


    function stateMachine:update(...)
        if self.current and self.current.update then
            self.current:update(self,...)
        end
    end

    return stateMachine