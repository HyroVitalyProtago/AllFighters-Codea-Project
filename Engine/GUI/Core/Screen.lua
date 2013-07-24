Screen = class()

-- Sugar for easier manipulation of animations on all attributs
local CLASS = Screen
CLASS.sugars = {
    x = "pos.x", y = "pos.y", z = "pos.z", posX = "pos.x", posY = "pos.y", posZ = "pos.z",
    eyeX = "eye.x", eyeY = "eye.y", eyeZ = "eye.z",
    lookAtX = "lookAt.x", lookAtY = "lookAt.y", lookAtZ = "lookAt.z",
    angleX = "angle.x", angleY = "angle.y", angleZ = "angle.z"
}

function Screen:init(name)
    
    self.name = name
    
    self.pos = {
        x = 0,
        y = 0,
        z = -900
    }

    self.eye = {
        x = WIDTH/2,
        y = HEIGHT/2,
        z = 150
    }

    self.lookAt = {
        x = WIDTH/2,
        y = HEIGHT/2,
        z = 0
    }

    self.angle = {
        x = 0,
        y = 0,
        z = 0
    }

    self.fieldOfView = 40

    self.meshes = {}

    self.background = true
    self.backgroundColor = color(255, 255, 255, 255)
    
    self.visible = true
    
    -- self.gravity = false
end

function Screen:start() end -- @Overwrite

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

function Screen:hide() self.visible = false end

function Screen:show() self.visible = true end

function Screen:udraw() end -- custom draw with view of screen
function Screen:draw()
    if not self.visible then return end
    
    table.sort(self.meshes, function(a, b)
        return a.pos.z < b.pos.z
    end)
    
    -- if self.gravity then
    --     self.angle.z = -Gravity.x*100
    --     self.angle.x = Gravity.y*100 + 90
    --     self.angle.x = Gravity.z*100
    -- end
    
    pushMatrix()
    pushStyle()
    
        perspective(self.fieldOfView, WIDTH/HEIGHT)
        camera(
            self.eye.x,self.eye.y,self.eye.z,
            self.lookAt.x,self.lookAt.y,self.lookAt.z,
            0,1,0
        )
        
        translate(self.pos.x, self.pos.y, self.pos.z)
        rotate(self.angle.x, self.angle.y, self.angle.z)
        -- rotate(self.angle.x, 1, 0, 0)
        -- rotate(self.angle.y, 0, 1, 0)
        -- rotate(self.angle.z, 0, 0, 1)
        
        if self.background then
            pushStyle()
                fill(self.backgroundColor)
                rect(0,0,WIDTH,HEIGHT)
            popStyle()
        end
        
        for _,v in pairs(self.meshes) do
            pushMatrix()
            pushStyle()
                v:draw()
            popStyle()
            popMatrix()
        end

        pushMatrix()
        pushStyle()
            self:udraw() -- custom draw()
        popStyle()
        popMatrix()
        
        viewMatrix(matrix())
        ortho()
    
    popStyle()
    popMatrix()
end

function Screen:isEnded() return false end -- @Overwrite
function Screen:ended() end -- @Overwrite

function Screen:touched(touch)
    local tbl = table.copy(self.meshes)
    table.sort(tbl, function(a, b)
        return a.pos.z > b.pos.z
    end)
    local focusAvailable = true
    for _, v in pairs(tbl) do
        focusAvailable = not v:touched(touch, focusAvailable) -- touched return true if object catch the focus
    end
end

function Screen:keyboard(key)
    for _, v in pairs(self.meshes) do
        v:keyboard(key)
    end
end

function Screen:removeMesh(mesh)
    for _,v in pairs(self.meshes) do
        if v == mesh then
            table.remove(self.meshes, k)
        end
    end
end

----------------------------------------------------------------------
-------------------------- Sugars system -----------------------------
----------------------------------------------------------------------

-- try sugars(CLASS)

function CLASS:__index(k)
    if CLASS[k] then return CLASS[k] end
    for sugarKey, key in pairs(CLASS.sugars) do
        if k == sugarKey then
            local arr = table.explode(".", key)
            if #arr == 1 then
                return self[key]
            else
                local result = self
                for _,v in pairs(arr) do
                    result = result[v]
                end
                return result
            end
        end
    end
end
function CLASS:__newindex(k, v)
    for sugarKey, key in pairs(CLASS.sugars) do
        if k == sugarKey then
            local arr = table.explode(".", key)
            if #arr == 1 then
                rawset(self, key, v)
            else
                local result = self
                for _,v in pairs(arr) do
                    beforeLastResult = result
                    result = result[v]
                end
                rawset(beforeLastResult, arr[#arr], v)
            end
        end
    end
    rawset(self, k, v)
end