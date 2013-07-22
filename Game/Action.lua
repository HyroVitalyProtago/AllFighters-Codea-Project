Action = class()

function Action:init(fighter)
    self.fighter = fighter
end

function Action:stateIn(states)
    for k,v in pairs(states) do
        if self.fighter.state == v then
            return true
        end
    end
    return false
end

function Action:isPossible() end
function Action:exec() end

function Action:execIfIsPossible()
    if self:isPossible() then
        self:exec()
    end
end
