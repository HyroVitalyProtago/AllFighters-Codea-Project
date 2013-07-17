Move = class(Action)

function Move:init(dir, fighter)
    Action.init(self, fighter)
    self.dir = dir
end

function Move:isPossible()
    return self:stateIn({Fighter.state.stance1, Fighter.state.stance2, Fighter.state.run, Fighter.state.walk, 
        Fighter.state.jump_up, Fighter.state.jump_down})
end

function Move:exec()
    self.fighter:move(self.dir)
end