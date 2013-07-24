FSprite = class(Rectangle)

function FSprite:init(name, x, y, w, h, subImages, speed)
    Rectangle.init(self, x, y, w, h)
    self.name = name
    self.subImages = subImages
    if (#self.subImages > 0) then
        self:updateSize()
    end
    
    self.speed = speed
    self.time = 0
    
    self.nbFoisJoue = 0
    self.ok = false -- gestion nbFoisJoue
end

function FSprite:setSubImages(subImages)
    self.subImages = subImages
    self:updateSize()
end

function FSprite:addSubImages(img)
    table.insert(self.subImages, img)
    self:updateSize()
end

function FSprite:resetTime()
    self.time = 0
    self.nbFoisJoue = 0
end

function FSprite:first()
    self.time = 0
end

function FSprite:next()
    local taille = #self.subImages
    self.time = (self.time + 100) % (taille * 100)
end

function FSprite:previous()
    local taille = #self.subImages
    local nextTime = (self.time - 100) % (taille * 100)
    if (nextTime < 0) then
        nextTime = (taille * 100) - 1
    end
    self.time = nextTime
end

function FSprite:last()
    local taille = #self.subImages
    self.time = (taille * 100) - 1
end
 
function FSprite:reverse()
    local name = string.sub(self.name, 1, #self.name - 1)
    name = name .. "L"
    
    local spr = FSprite(name, self.x, self.y, self.width, self.height, {}, self.speed)
    
    local subImages = {}
    for i=1,#self.subImages do
        table.insert(subImages, self.subImages[i]:reverse(self))
    end
    
    spr:setSubImages(subImages)
    
    return spr
end

function FSprite:getCurrentImg()
    local i = (self.time / 100) + 1
    --print(i)
    return self.subImages[math.floor(i)]
end

function FSprite:updateSize()
    self.width = self:getWidth()
    self.height = self:getHeight()
end

function FSprite:minX()
    local minX = self.subImages[1].x
    for k,img in pairs(self.subImages) do
        if (minX > img.x) then minX = img.x end
    end
    return minX + self.x
end

function FSprite:minY()
    local minY = self.subImages[1].y
    for k,img in pairs(self.subImages) do
        if (minY > img.y) then minY = img.y end
    end
    return minY + self.y
end

function FSprite:getWidth()
    local x = {self.subImages[1].x, self.subImages[1].width}
    for k,img in pairs(self.subImages) do
        if (x[1] + x[2] < img.x + img.width) then
            x[1] = img.x
            x[2] = img.width
        end
    end
    return self.x + x[1] + x[2] - self:minX()
end

function FSprite:getHeight()
    local y = {self.subImages[1].y, self.subImages[1].height}
    for k,img in pairs(self.subImages) do
        if (y[1] + y[2] < img.y + img.height) then
            y[1] = img.y
            y[2] = img.height
        end
    end
    return self.y + y[1] + y[2] - self:minY()
end

function FSprite:resetNbFoisJoue()
    self.nbFoisJoue = 0
end

function FSprite:fight(fighter, spr)
    local img = self:getCurrentImg():clone()
    local img1 = spr:getCurrentImg():clone()
    
    img.x = self.x + img.x
    img.y = self.y + img.y

    if (img:intersects(img1)) then
        return img:fight(fighter, img1)
    end

    return false
end

function FSprite:remakeAllSubImages()
    -- USELESS
end

function FSprite:clone()
    local spr = FSprite(self.name, self.x, self.y, self.width, self.height, {}, self.speed)
    local subImages = {}
    for k,img in pairs(self.subImages) do
        table.insert(subImages, img:clone())
    end
    spr:setSubImages(subImages)
    spr.time = self.time
    spr.nbFoisJoue = self.nbFoisJoue
    spr.ok = self.ok
    return spr
end

-- DRAW
function FSprite:drawContour()
    stroke(245, 255, 0, 255) -- YELLOW
    rect(0, 0, self.width, self.height)
end

function FSprite:draw()
    
    pushMatrix()
    translate(self.x, self.y)
    
    if (SHOW_BOXS_FIGHTER) then
        font("AmericanTypewriter")
        fill(255, 242, 0, 255)
        fontSize(15)
        text(self.x, -45, self.height + 40)
        text(self.y, -15, self.height + 40)
        text(self.width, 15, self.height + 40)
        text(self.height, 45, self.height + 40)
        noFill()
        self:drawContour()
    end
    
    self:getCurrentImg():draw()
    
    popMatrix()
    
    if (not DEV_SPRITE) then
        self.time = self.time + self.speed
    else
        fill(255, 255, 255, 255)
        fontSize(25)
        text(math.floor((self.time / 100) + 1), -25, -10)
        noFill()
    end
    
    local taille = #self.subImages
    
    if (self.time / 100) == taille and not self.ok then
        self.ok = true
        self.nbFoisJoue = self.nbFoisJoue + 1
        for i, img in pairs(self.subImages) do
            img:resetBoxs()
        end
    end
    if not ((self.time / 100) == taille) and self.ok then
        self.ok = false
    end
    
    self.time = self.time % (taille * 100)
    
end

function FSprite:toXml()
    return tostring(XML(self, "FSprite"))
end

function FSprite.fromXml(xml)
    local fs = FSprite(nil, 0, 0, 0, 0, {}, 0)
    --print("FSprite", xml)
    for k,v in pairs(xml) do
        if k == "subImages" then
            fs[k] = {}
            for _k, _v in pairs(xml[k]) do
                fs[k][tonumber(_k)] = FImage.fromXml(_v)
            end
        elseif type(fs[k]) == "number" then
            fs[k] = tonumber(v)
        else
            fs[k] = v
        end
    end
    
    return fs
end