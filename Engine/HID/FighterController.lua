FighterController = class()

function FighterController:init(fighter)
    self.fighter = fighter
    
    self.UP = false
    self.DOWN = false
    self.LEFT = false
    self.RIGHT = false
    self.Y_COMBO = false

    self.nbKeyPressed = 0
    
end

function FighterController:update()
    --print("update controller")
    
    if (self.nbKeyPressed == 0) then
        -- fighter.setVelocityX(0)
        self.UP = false
        self.DOWN = false
        self.LEFT = false
        self.RIGHT = false
        self.Y_COMBO = false
    end
    
    if (self.UP) then
        Jump(self.fighter):execIfIsPossible()
    end
    if (self.DOWN) then
    end
    if (self.LEFT) then
        Move(Direction.LEFT, self.fighter):execIfIsPossible()
        self.LEFT = false
    end
    if (self.RIGHT) then
        Move(Direction.RIGHT, self.fighter):execIfIsPossible()
    end
    if (self.Y_Combo) then
        Y_Combo(self.fighter):execIfIsPossible()
        self.Y_COMBO = false
    end
    
end

function FighterController:keyPressed(ke)
    -- print("key Pressed " .. ke)
    
    if ke == Keyboard.key.VK_UP then
        if (DEV_SPRITE) then
            self.fighter:nextSprite()
            return
        end
        if (not self.UP) then
            -- print("UP")
            self.UP = true
            self.nbKeyPressed = self.nbKeyPressed + 1
        end
    elseif ke == Keyboard.key.VK_DOWN then
        if (DEV_SPRITE) then
            self.fighter:previousSprite()
            return
        end
        if (not self.DOWN) then
            self.DOWN = true
            self.nbKeyPressed = self.nbKeyPressed + 1
        end
    elseif ke == Keyboard.key.VK_LEFT then
        if (DEV_SPRITE) then
            self.fighter:getCurrentSprite():previous()
            return
        end
        if (not self.LEFT) then
            self.LEFT = true
            self.nbKeyPressed = self.nbKeyPressed + 1
        end
    elseif ke == Keyboard.key.VK_RIGHT then
        if (DEV_SPRITE) then
            self.fighter:getCurrentSprite():next()
            return
        end
        if (not self.RIGHT) then
            self.RIGHT = true
            self.nbKeyPressed = self.nbKeyPressed + 1
        end
    elseif ke == string.byte('y') then
        if (not self.Y_COMBO) then
            self.Y_Combo = true
            self.nbKeyPressed = self.nbKeyPressed + 1
        end
    end
end

function FighterController:keyReleased(ke)
    -- ke = string.byte(key)
    if ke == Keyboard.key.VK_UP then
        self.nbKeyPressed = self.nbKeyPressed - 1
        self.UP = false
    elseif ke == Keyboard.key.VK_DOWN then
        self.nbKeyPressed = self.nbKeyPressed - 1
        self.DOWN = false
    elseif ke == Keyboard.key.VK_LEFT then
        self.nbKeyPressed = self.nbKeyPressed - 1
        self.LEFT = false
        self.fighter.velocity.x = 0
    elseif ke == Keyboard.key.VK_RIGHT then
        self.nbKeyPressed = self.nbKeyPressed - 1
        self.RIGHT = false
        self.fighter.velocity.x = 0
    elseif ke == string.byte('y') then
        self.nbKeyPressed = self.nbKeyPressed - 1
        self.Y_Combo = false
    end
end

