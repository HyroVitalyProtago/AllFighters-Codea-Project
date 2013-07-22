Comportement = class()

function Comportement:init(fighter)
    self.fighter = fighter
    fighter.comportement = self
end
function Comportement:update() end