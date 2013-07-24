Mesh = class()

-- Sugar for easier manipulation of animations on all attributs
local CLASS = Mesh
CLASS.sugars = {
    width = "dim.w", height = "dim.h", w = "dim.w", h = "dim.h",
    x = "pos.x", y = "pos.y", z = "pos.z", posX = "pos.x", posY = "pos.y", posZ = "pos.z",
    angleX = "angle.x", angleY = "angle.y", angleZ = "angle.z"
}

function Mesh:init(pmesh, args) -- args {width, height [, mode(CENTER|CORNER), x, y, z]}
    if args == nil then
        args = {}
    end
    
    self.mode = args.mode or CENTER
    self.mesh = pmesh

    self.dim = {
        w = args.width,
        h = args.height
    }

    self.pos = {
        x = args.x or WIDTH*0.5,
        y = args.y or HEIGHT*0.5,
        z = args.z or 5
    }
    
    self.angle = {
        x = 0,
        y = 0,
        z = 0
    }

    self.alpha = 255
    self._matrix = nil
    
end

function Mesh:show() self.alpha = 255 end

function Mesh:hide() self.alpha = 0 end

function Mesh:toggle()
    if self.alpha == 255 then
        self:hide()
    elseif self.alpha == 0 then
        self:show()
    end
end

function Mesh:fadeIn(duration, easeType, callback)
    duration = duration or .5
    tween(duration, self, {alpha=255}, easeType, callback)
end

function Mesh:fadeOut(duration, easeType, callback)
    duration = duration or .5
    tween(duration, self, {alpha=0}, easeType, callback)
end

function Mesh:draw()
    if not self.mesh then return end
    
    self.mesh:setColors(color(255,255,255,self.alpha))
    
    if self.mode == CENTER then
        translate(self.pos.x - (self.dim.w*0.5), self.pos.y - (self.dim.h*0.5), self.pos.z)
    elseif CORNER then
        translate(self.pos.x, self.pos.y, self.pos.z)
    end

    rotate(self.angle.x, self.angle.y, self.angle.z)
    -- rotate(self.angle.x, 1,0,0)
    -- rotate(self.angle.y, 0,1,0)
    -- rotate(self.angle.z, 0,0,1)

    self._matrix = modelMatrix() * viewMatrix() * projectionMatrix() -- use for touched
    
    self.mesh:draw()
end

function Mesh.makeMesh(spr, args) -- Make a plane with a sprite texture
    
    if args == nil then
        args = {}
    end
    
    local w,h = spriteSize(spr)
    args.width = args.width or w
    args.height = args.height or h

    local myMesh = mesh()

    myMesh.vertices = {
        vec3(0,0,0),
        vec3(args.width,0,0),
        vec3(args.width,args.height,0),

        vec3(0,0,0),
        vec3(0,args.height,0),
        vec3(args.width,args.height,0)
    }
    myMesh.texCoords = {
        vec2(0,0),
        vec2(1,0),
        vec2(1,1),

        vec2(0,0),
        vec2(0,1),
        vec2(1,1)
    }
    
    if not args.color then args.color = color(255, 255, 255, 255) end
    myMesh:setColors(args.color.r,args.color.g,args.color.b,args.color.a)

    myMesh.texture = spr
    
    myMesh.shader = args.shader
    
    return Mesh(myMesh, args)
end

function Mesh.makeTextMesh(str, args)
    return Mesh.makeMesh(Sprite.makeTextSprite(str, args), args)
end

function Mesh:insertIn(arrays)
    for _,array in pairs(arrays) do
        table.insert(array, self)
    end
    return self -- useful for compact syntax
end

function Mesh:isTouched(touch, offset) -- for the moment, work only with plane

    self._smatrix = self._matrix
    local tc = screentoplane(touch, vec3(0,0,0), vec3(1,0,0), vec3(0,1,0), self._smatrix)
    if tc.x < 0 or tc.x > self.dim.w or tc.y < 0 or tc.y > self.dim.h then
        return false
    end
    
    return true
end

-- focusAvailable indic if you can catch the focus (~ if an another object before have catch the focus)
-- return true if the object want catch the focus, else false
function Mesh:touched(touch, focusAvailable)
    if (touch.state == ENDED and self:isTouched(touch) and focusAvailable) then
        self:ctouched()
        return true
    end
    return false
end

-- In most of case, this function is the default behavior of an object, 
-- but if you have a really special object, you can directly @Overwrite Mesh:touched(touch, focusAvailable)
function Mesh:ctouched() end -- @Overwrite

function Mesh:keyboard(key) end -- @Overwrite

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