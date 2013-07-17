Fighter = class(FObject)

Fighter.state = {intro=0, stance1=1, stance2=2, walk=3, run=4, jump_up=5, jump_down=6,
                guard=7, turn=8, guard_jump=9, turn_jump=10, win=11, lose=12, hit=13, stunned=14,
                y_combo_begin=15, y_combo_end=16, forward_y=17, run_y=18, up_y=19, jump_y=20,
                x=21, run_x=22, up_x=23, jump_x=24, jump_x_down=25, special1=26, special2=27,
                special3=28, getup=29}

function Fighter:init(name)
    FObject.init(self, name, {}, true, true)
    self.speed = 4
    self.jumpForce = 6
    self.onGround = false --true
    self.map = {} -- Map map; // Sprite[2] Right - Left
    self.state = Fighter.state.stance1
    self.dir = Direction.RIGHT
    self.comportement = nil -- Comportement
    self.enchainement = nil -- Fighter_State
    self.aToucheUnEnnemi = false
    self.life = 300
    self.power = 300
    self.force = 5
    self.resistance = 1
    
    self.gravity = 0.1
    self.onGravity = true
end

function Fighter:addSprites(state, sprites)
    if (#sprites ~= 2) then
        -- assert
    end
    table.insert(self.map, state, sprites)
end

--@Override
function Fighter:addSprite(spr)
    -- assert
end

function Fighter:getSprites()
    local sprites = {}
    for k, spr in pairs(self.map) do
        table.insert(sprites, spr)
    end
    return sprites
end

function Fighter:getDirectionValue()
    return Direction.getValue(self.dir)
end

--@Override
function Fighter:getCurrentSprite()
    -- Permet la gestion de l'affichage lorsque le fighter se fait touche en l'air
    if (self.state == Fighter.state.hit and not self:isOnGround()) then
        if (self.velocity.y > 0) then
            return self.map[Fighter.state.jump_up][self:getDirectionValue()]
        else
            return self.map[Fighter.state.jump_down][self:getDirectionValue()]
        end
    else
        return self.map[self.state][self:getDirectionValue()]
    end
end

function Fighter:nextSprite()
    local first = nil
    for k,v in pairs(self.map) do
        if first == nil then
            first = k
        end
        if k > self.state then
            self:setState(k)
            return
        end
    end
    self:setState(first)
end

function Fighter:previousSprite()
    local previous = -1
    for k,v in pairs(self.map) do
        if previous ~= self.state then
            previous = k
        elseif previous == -1 then
        else
            return previous
        end
    end
    self.state = previous
end

function Fighter:isOnGround()
    return self.onGround
end

function Fighter:setOnGround(onGround)
    if ((not self.onGround) and onGround) then
        self:setState(Fighter.state.getup)
    end
    self.onGround = onGround
end

function Fighter:update() -- UPDATE COMPORTEMENT
    if (not DEV_SPRITE and self.comportement) then
        self.comportement:update()
        -- this.timeOnGroundBetweenJumpAndFall++
    end
end

function Fighter:setState(state)
    --print(state)
    if (state ~= self.state) then
        self:getCurrentSprite():resetTime()
        self.aToucheUnEnnemi = false
        self.state = state
    end
end

function Fighter:isFighter()
    return true
end

function Fighter:intersect(ennemi)
    local spr = self:getCurrentSprite():clone()
    local spr1 = ennemi:getCurrentSprite():clone()

    spr.x = self.x + spr.x
    spr.y = self.y + spr.y
    spr1.x = ennemi.x + spr1.x
    spr1.y = ennemi.y + spr1.y

    return spr:intersects(spr1)
end

function Fighter:fight(ennemi)
    -- 0 si personne ne s'attaque
    -- 1 si il attaque l'ennemi

    local spr = self:getCurrentSprite():clone()
    local spr1 = ennemi:getCurrentSprite():clone()

    spr.x = self.x + spr.x
    spr.y = self.y + spr.y
    spr1.x = ennemi.x + spr1.x
    spr1.y = ennemi.y + spr1.y

    -- Effectuer verification orientation de l'attaquant par rapport a l'ennemi
    if (self.x < ennemi.x and self.dir == Direction.LEFT) then
        return false
    end
    if (self.x > ennemi.x and self.dir == Direction.RIGHT) then
        return false
    end
    
    return spr:fight(ennemi, spr1)
end

function Fighter:jump()
    self.onGround = false
    self.velocity.y = self.jumpForce
    self:setState(Fighter.state.jump_up)
end

function Fighter:clone()
    local sprites = self.sprites:clone()
    return Fighter(self.name + "_clone", sprites, self.visible, self.solid)
end

function Fighter:move(dir, speed) -- speed can be nil
    if (speed == nil) then
        speed = self.speed
    end
    if (dir == Direction.LEFT) then
        self.velocity.x = -speed
    elseif (dir == Direction.RIGHT) then
        self.velocity.x = speed
    end
end

function Fighter:draw()
    pushMatrix()
    translate(self.x, self.y)

    if (SHOW_BOXS_FIGHTER) then
        self:drawContour()
    end

    if (self.visible) then
        self:getCurrentSprite():draw()
    end
    
    self:update()

    popMatrix()
end

function Fighter:infligerDegats(f)
    self.aToucheUnEnnemi = true
    f.dir = Direction.inverse(self.dir)
    f:recevoirDegats(self.force)
end

function Fighter:recevoirDegats(degats)
    if ((degats - self.resistance) > 0) then
        self.life = self.life - (degats - self.resistance)
        self.state = Fighter.state.hit
    end
end

function Fighter:toXml()
    return tostring(XML(self, "Fighter"))
end

function Fighter.fromXml(xml)
    local fo = Fighter(nil)
    for k,v in pairs(xml) do
        --print("Fighter", k, v)
        if k == "map" then
            fo[k] = {}
            --print("Fighter", xml[k])
            for _k, _v in pairs(xml[k]) do
                fo[k][tonumber(_k)] = {FSprite.fromXml(_v["1"]), FSprite.fromXml(_v["2"])}
            end
        elseif k == "velocity" then
            fo[k].x = tonumber(v.x)
            fo[k].y = tonumber(v.y)
        elseif type(fo[k]) == "number" then
            fo[k] = tonumber(v)
        else
            fo[k] = v
        end
    end
    
    return fo
end