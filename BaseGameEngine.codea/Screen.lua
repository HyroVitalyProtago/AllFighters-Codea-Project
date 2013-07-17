Screen = class()

function Screen:init(name)
    
    self.name = name
    
    self.x = 0
    self.y = 0
    self.z = -900
    self.eyeX = WIDTH/2
    self.eyeY = HEIGHT/2
    self.eyeZ = 150
    self.lookAtX = WIDTH/2
    self.lookAtY = HEIGHT/2
    self.lookAtZ = 0
    self.angle = {}
    self.angle.x = 0
    self.angle.y = 0
    self.angle.z = 0
    self.fieldOfView = 40
    
    -- parameter.number("X",-500,1000,self.x)
    -- parameter.number("Y",-500,500,self.y)
    -- parameter.number("Z",-500,1000,self.z)
    
    -- parameter.number("EyeX", -1000, 1000, self.eyeX)
    -- parameter.number("EyeY", -1000, 1000, self.eyeY)
    -- parameter.number("EyeZ", -1000, 1000, self.eyeZ)
    
    -- parameter.number("LookAtX", -1000, 1000, self.lookAtX)
    -- parameter.number("LookAtY", -1000, 1000, self.lookAtY)
    -- parameter.number("LookAtZ", -1000, 1000, self.lookAtZ)
    
    -- parameter.number("Angle",-360, 360, self.angle)
    -- parameter.number("FieldOfView", -140, 140, self.fieldOfView)
    
    
    self.meshes = {}
    self.background = true
    self.backgroundColor = color(255, 255, 255, 255)
    
    self.visible = true
    
    self.gravity = false
end

function Screen:start()
    --self.gravity = true
end

function Screen:fadeIn(duration, easeType, callback)
    for _, v in pairs(self.meshes) do
        v:fadeIn(duration, easeType, callback)
    end
end

function Screen:fadeOut(duration, easeType, callback)
    for _, v in pairs(self.meshes) do
        v:fadeOut(duration, easeType, callback)
    end
end

function Screen:hide()
    self.visible = false
end

function Screen:show()
    self.visible = true
end

function Screen:udraw() end
function Screen:draw()
    if not self.visible then return end
    
    table.sort(self.meshes, function(a, b)
        return a.pos.z < b.pos.z
    end)
    
    if self.gravity then
        self.angle.z = -Gravity.x*100
        self.angle.x = Gravity.y*100 + 90
        self.angle.x = Gravity.z*100
    end
    
    pushMatrix()
    pushStyle()
    
    perspective(self.fieldOfView, WIDTH/HEIGHT)
    camera(self.eyeX,self.eyeY,self.eyeZ, self.lookAtX,self.lookAtY,self.lookAtZ, 0,1,0)
    
    translate(self.x, self.y, self.z)
    rotate(self.angle.x, 1, 0, 0)
    rotate(self.angle.y, 0, 1, 0)
    rotate(self.angle.z, 0, 0, 1)
    
    noStroke()
    if self.background then
        fill(self.backgroundColor)
        rect(0,0,WIDTH,HEIGHT)
    end
    
    for k,v in pairs(self.meshes) do
        v:draw()
    end

    self:udraw()
    
    viewMatrix(matrix())
    ortho()
    
    popStyle()
    popMatrix()
end

function Screen:isEnded()
    return false
end
function Screen:ended() end

function Screen:touched(touch)
    local tbl = table.copy(self.meshes)
    table.sort(tbl, function(a, b)
        return a.pos.z > b.pos.z
    end)
    local firstElementTouch = true
    for _, v in pairs(tbl) do
        catchFocus = v:touched(touch, firstElementTouch)
        if catchFocus then
            firstElementTouch = false
        end
    end
end

function Screen:keyboard(key)
    for _, v in pairs(self.meshes) do
        v:keyboard(key)
    end
end

function Screen:removeMesh(_mesh)
    for k,v in pairs(self.meshes) do
        if v == _mesh then table.remove(self.meshes, k) end
    end
end