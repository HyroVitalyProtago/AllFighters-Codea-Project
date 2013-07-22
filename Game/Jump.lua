Jump = class(Action)

function Jump:init(fighter)
    Action.init(self, fighter)
end

function Jump:isPossible()
    return self:stateIn({Fighter.state.stance1, Fighter.state.stance2, Fighter.state.run, Fighter.state.walk})
end

function Jump:exec()
    self.fighter:jump()
end