Screen = class()

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
    
    self.focusKeeped = false

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

function Screen:btouched(touch, focusAvailable) end -- custom touch before element
function Screen:atouched(touch, focusAvailable) end -- custom touch after element
function Screen:touched(touch)
    local tbl = table.copy(self.meshes)
    table.sort(tbl, function(a, b)
        return a.pos.z > b.pos.z
    end)

    local focusAvailable = true
    local focusCatched, focusKeeped = self:btouched(touch, focusAvailable and not self.focusKeeped)

    if focusCatched then focusAvailable = false end
    if focusKeeped and focusKeeped == 1 then self.focusKeeped = true end

    for _, v in pairs(tbl) do
        -- touched return true if object catch the focus; 1 if object keep the focus, -1 if object return the focus
        focusCatched, focusKeeped = v:touched(touch, focusAvailable and not self.focusKeeped) 
        if focusCatched then focusAvailable = false end
        if focusKeeped and focusKeeped == 1 then
            assert(focusKeeped == 1 and not self.focusKeeped, "Focus already keeped...")
            self.focusKeeped = true
        end
        if focusKeeped and focusKeeped == -1 then
            assert(focusKeeped == -1 and self.focusKeeped, "Impossible to give back focus because it was not keeped...")
            self.focusKeeped = false
        end
    end

    self:atouched(touch, focusAvailable and not self.focusKeeped)
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
