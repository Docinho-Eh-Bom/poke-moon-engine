local choice = {}

function choice:update(machine)
    local turn = machine.turn

    if not turn.p1Choice then
        print("Choose an action:")
        for i, move in ipairs(turn.p1.moves) do
            print(i.." - "..move.name.." PP: ("..move.currentPP.."/"..move.pp..")")
        end

        local selected = tonumber(io.read())

        if not selected or not turn.p1.moves[selected] then
            print("Invalid choice!\n")
            return
        end

        local selectedMove = turn.p1.moves[selected]
        if selectedMove.currentPP <= 0 then
            print("That move has no PP left!\n")
            return
        end

        turn.p1Choice = selectedMove
    end

    if not turn.p2Choice then
        local randomMove = math.random(#turn.p2.moves)
        turn.p2Choice = turn.p2.moves[randomMove]
    end

    if turn.p1Choice and turn.p2Choice then
        machine:change(machine.states.resolve)
    end
end

return choice