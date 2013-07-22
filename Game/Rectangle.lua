Rectangle = class()

function Rectangle:init(x,y,w,h)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
end

function Rectangle:clone()
    return Rectangle(self.x, self.y, self.width, self.height)
end

function Rectangle:contains(p)
    return p.x > self.x and p.x < self.x + self.width and p.y > self.y and p.y < self.y + self.height
end

function Rectangle:getPoints()
    return {vec2(self.x, self.y), vec2(self.x + self.width, self.y), 
        vec2(self.x + self.width, self.y + self.height), vec2(self.x, self.y + self.height)}
end

function Rectangle:intersects(r1)
    ps1 = self:getPoints()
    ps2 = r1:getPoints()
    for i,v in ipairs(ps1) do
        if r1:contains(v) then
            return true
        end
    end
    for i,v in ipairs(ps2) do
        if self:contains(v) then
            return true
        end
    end
    return false
end

function Rectangle:toXml()
    return tostring(XML(self, "Rectangle"))
end

function Rectangle.fromXml(xml)
    local r = Rectangle(0,0,0,0)
    for k,v in pairs(xml) do
        r[k] = tonumber(v)
    end
    return r
end