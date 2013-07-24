Player = class()

function Player:init(fighter, controller)
    self.fighter = fighter
    self.controller = controller
end

function Player:getLocation()
    return self.fighter:getLocation()
end

function Player:updateControl()
    self.controller:update()
end