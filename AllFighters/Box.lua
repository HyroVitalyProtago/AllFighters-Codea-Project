Box = class(Rectangle)

Box.type = {HITTABLE=0, ATTACKING=1, COUNTER=2}

function Box:init(type, rectangle)
    Rectangle.init(self, rectangle.x, rectangle.y, rectangle.width, rectangle.height)
    assert(type >= 0 and type <= 2, "Box: type invalid : "..type)
    self.type = type
    self.fightersTouched = {}
end

function Box:getColor()
    if (self.type == Box.type.HITTABLE) then
        return color(0, 0, 255, 255) -- Blue
    elseif (self.type == Box.type.ATTACKING) then
        return color(255, 0, 0, 255) -- Red
    else
        return color(0, 255, 0, 255) -- Green
    end
end

function Box:draw()
    stroke(self:getColor())
    rect(self.x, self.y, self.width, self.height)
end

function Box:addFighter(fighter)
    table.insert(self.fightersTouched, fighter)
end

function Box:contains(fighter)
    for i,f in ipairs(self.fightersTouched) do
        if (f == fighter) then
            return true
        end
    end
    return false
end

function Box:resetFighters()
    self.fightersTouched = {}
end

function Box:clone()
    return Box(self.type, Rectangle(self.x, self.y, self.width, self.height))
end

function Box:toXml()
    return tostring(XML(self, "Box"))
end

function Box.fromXml(xml)
    local b = Box(0, Rectangle(0,0,0,0))
    for k,v in pairs(xml) do
        if type(b[k]) == "number" then
            b[k] = tonumber(v)
        else
            b[k] = v
        end
    end
    return b
end