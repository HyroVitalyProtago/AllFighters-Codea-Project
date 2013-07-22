Room = class(Screen)
-- Rectangle
function Room:init(name, width, height)
    Screen.init(self, name)
    
    -- self.name = name
    self.objects = {}
    
    self.snapX = width / 20
    self.snapY = height / 20
    
    self.width = width
    self.height = height
    
    --self.background = FImage(-400, 25, "Dropbox:SpriteAllFighters/Background")
    Mesh.makeMesh(image(width, height, function(width, height)
        fill(255, 255, 255, 255)
        rect(0, 0, width, height)
    end), {
        z = -1
    }):insertIn({self.meshes})
    
end

-- public
function Room:addObject(obj, x, y)
    obj.x = x
    obj.y = y
    table.insert(self.objects, obj)
end

-- public
function Room:addWall(x, y, width, height)
    obj = FObject("Wall", {}, false, true)
    --obj.visible = false
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    table.insert(self.objects, obj)
end

-- private
function Room:drawBackground()
    if (self.background == nil) then
        fill(127, 127, 127, 255)
        rect(0,0,self.width, self.height)
    else
        self.background:draw()
    end
end

-- private
function Room:drawSnap()
    -- shader
    pushStyle()
    stroke(0, 0, 0, 255)
    strokeWidth(1)
    for i = 0, self.width/self.snapX do
        line(i*self.snapX, 0, i*self.snapX, self.height)
    end
    for i = 0, self.height/self.snapY do
        line(0, i*self.snapY, self.width, i*self.snapY)
    end
    popStyle()
end

-- public
function Room:udraw()

    -- Screen.draw(self)
    -- self:drawBackground()
    
    if (SHOW_SNAP) then self:drawSnap() end -- TODO

    for i,obj in ipairs(self.objects) do
        obj:draw()
        self:update(obj)
    end

end

-- private
function Room:update(obj)
    if obj:isFighter() then
        obj:update()
        self:updateObj(obj)
        self:fight(obj)
    end
end

-- private
function Room:fight(fighter)
    for i,obj in ipairs(self.objects) do
        if (obj:isFighter() and obj ~= fighter and fighter:intersect(obj) and fighter:fight(obj)) then
            fighter:inflictDamage(obj)
            -- Ajouter un effet au point d'impact
            if (obj:getLife() <= 0) then
                -- Lancement animation ? retirer l'obj de la liste ?
            end
        end
    end
end

-- private
function Room:collision(obj)
    for i,object in ipairs(self.objects) do
        if (obj ~= object and not object:isFighter()) then
            if (obj:collide(object)) then return object end
        end
    end
    return nil
end

-- private
function Room:updateObj(obj)
    
    -- Gravity
    if (obj.onGravity) then
        obj.velocity.y = obj.velocity.y - obj.gravity
    end
    
    local obstacle
    
    -- X
    local dx = obj.velocity.x
    local oldX = obj.x
    local newX = oldX + dx
    
    obj.x = newX
    obstacle = self:collision(obj)
    if (obstacle ~= nil) then
        if (dx < 0) then
            obj.x = obstacle.x + obstacle.width
        elseif (dx > 0) then
            obj.x = obstacle.x - obj.width
        else
            obj.x = oldX
        end
    end
    
    -- Y
    local dy = obj.velocity.y
    local oldY = obj.y
    local newY = oldY + dy
    
    obj.y = newY
    obstacle = self:collision(obj)
    if (obstacle == nil) then
        if (dy < 0) then
            obj:setOnGround(false)
        end
    else
        if (dy < 0) then
            obj:setOnGround(true)
            obj.y = obstacle.y + obstacle.height
        elseif (dy > 0) then
            obj.y = obstacle.y - obj.height
        else
            obj.y = oldY
        end
        obj:collideVertical()
    end
end