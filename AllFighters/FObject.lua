FObject = class(Rectangle)

function FObject:init(name, sprites, visible, solid)
    -- --[[print("new FObject : "..name)
    -- print(sprites)
    -- print(visible)
    -- print(solid)]]--
    
    Rectangle.init(self,0,0,0,0)
    self.name = name
    self.currentSprite = 0
    self.sprites = sprites
    self.visible = visible
    self.solid = solid
    
    self.velocity = {}
    self.velocity.x = 0
    self.velocity.y = 0
    
    self.gravity = false
end

function FObject:remakeAllSprite()
    for k,spr in pairs(self.sprites) do
        spr:remakeAllSubImages()
    end
end

function FObject:addSprite(spr)
    table.insert(self.sprites, spr)
end

function FObject:isFighter()
    return false
end

function FObject:nextSprite()
    self.currentSprite = self.currentSprite + 1
    if (self.currentSprite > #self.sprites) then self.currentSprite = 1 end
end

function FObject:previousSprite()
    self.currentSprite = self.currentSprite - 1
    if (self.currentSprite < 1) then self.currentSprite = #self.sprites end
end

function FObject:resetAllSprite()
    for k,spr in pairs(self.sprites) do
        spr:resetTime()
    end
end

function FObject:setCurrentSprite(currentSprite)
    if currentSprite ~= self.currentSprite then
        self:getCurrentSprite():resetTime()
        self.currentSprite = currentSprite
    end
end

function FObject:getCurrentSprite()
    if #self.sprites == 0 then return nil end
    return self.sprites[self.currentSprite]
end

function FObject:getBounds()
    return Rectangle(self.x, self.y, self.width, self.height)
end

function FObject:collide(obj)
    return self:getBounds():intersects(obj:getBounds())
end

function FObject:collideHorizontal()
    self.velocity.x = 0
end

function FObject:collideVertical()
    self.velocity.y = 0
end

-- DRAW
function FObject:drawContour()
    fill(0, 63, 255, 255) -- GRAY
    rect(0, 0, self.width, self.height)
    noFill()
end

function FObject:draw()
    pushMatrix()
    translate(self.x, self.y)
    
    if (SHOW_BOXS) then
        self:drawContour()
    end
    
    if (self.visible) then
        self:getCurrentSprite():draw()
    end
    
    popMatrix()
end

function FObject:toXml()
    return tostring(XML(self, "FObject"))
end

function FObject.fromXml(xml)
    local fo = FObject(nil, {}, false, false)
    for k,v in pairs(xml) do
        if k == "sprites" then
            fo[k] = {}
            for _k, _v in pairs(xml[k]) do
                fo[k][_k] = FSprite.fromXml(_v)
            end
        else
            fo[k] = v
        end
    end
    
    return fo
end