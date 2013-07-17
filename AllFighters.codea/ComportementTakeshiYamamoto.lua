ComportementTakeshiYamamoto = class(Comportement)

function ComportementTakeshiYamamoto:init(fighter)
    Comportement.init(self, fighter)
end

function ComportementTakeshiYamamoto:update()
    
        -- Ne prend pas en compte le changement de direction
        if (self.fighter.state == Fighter.state.hit) then
            self.fighter.velocity.x = 0
            
            self.fighter:move(Direction.inverse(self.fighter), 0.5)
            
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then
                self.fighter.velocity.x = 0
                
                if (self.fighter:isOnGround()) then
                    self.fighter:setState(Fighter.state.stance1)
                    self:update()
                end
            else
                return
            end
        end
        
        -- Changement de direction
        if (self.fighter.velocity.x > 0) then
            self.fighter.dir = Direction.RIGHT
        elseif (self.fighter.velocity.x < 0) then
            self.fighter.dir = Direction.LEFT
        end

        if (self.fighter.enchainement ~= nil) then
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then
                self.fighter:setState(self.fighter.enchainement)
                self.fighter.enchainement = nil
                self:update()
            end
            return
        end
        
        if (self.fighter.state == Fighter.state.forward_y) then
            self.fighter.velocity.x = 0
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then      
                self.fighter:setState(Fighter.state.stance1)
                self:update()
            end
            return
        end
        
        if (self.fighter.state == Fighter.state.y_combo_begin) then
            self.fighter.velocity.x = 0
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then
                self.fighter:setState(Fighter.state.y_combo_end) -- par défaut
                self:update()
            end
            return
        end
        
        if (self.fighter.state == Fighter.state.y_combo_end) then
            self.fighter.velocity.x = 0
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then
                self.fighter:setState(Fighter_State.stance1)
                self:update()
            end
            return
        end
        
        if (self.fighter.state == Fighter.state.getup) then
            self.fighter.velocity.x = 0
            if (self.fighter:getCurrentSprite().nbFoisJoue == 1) then
                self.fighter:setState(Fighter.state.stance1)
                self:update()
            end
            return
        end
        
        if (self.fighter.velocity.y <= 0 and self.fighter.state == Fighter.state.jump_up) then
            self.fighter:setState(Fighter.state.jump_down)
            return
        end
        
        if (self.fighter.velocity.y < 0) then
            self.fighter:setState(Fighter.state.jump_down)
            return
        end
        
        if not self.fighter.onGround then return end
        if (self.fighter.velocity.x == 0 and self.fighter.velocity.y == 0 and 
                self.fighter.state ~= Fighter.state.stance1 and self.fighter.state ~= Fighter.state.stance2) then
            self.fighter:setState(Fighter.state.stance1)
        elseif (self.fighter.velocity.x ~= 0 and self.fighter.velocity.y == 0) then
            self.fighter:setState(Fighter.state.walk)
        elseif (self.fighter.velocity.y == 0) then
            if(self.fighter.state == Fighter.state.stance1 and self.fighter:getCurrentSprite().nbFoisJoue == 3) then
                self.fighter:setState(Fighter.state.stance2)
            elseif(self.fighter.state == Fighter.state.stance2 and self.fighter:getCurrentSprite().nbFoisJoue == 2) then
                self.fighter:setState(Fighter.state.stance1)
            end
        end
        
end
