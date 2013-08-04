Mesh = class()

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
    if not self.mesh or self.alpha == 0 then return end
    
    pushMatrix()
    self.mesh:setColors(color(255,255,255,self.alpha))
    
    if self.mode == CENTER then
        translate(self.pos.x - (self.dim.w*0.5), self.pos.y - (self.dim.h*0.5), self.pos.z)
    elseif CORNER then
        translate(self.pos.x, self.pos.y, self.pos.z)
    end

    rotate(self.angle.x, 1,0,0)
    rotate(self.angle.y, 0,1,0)
    rotate(self.angle.z, 0,0,1)

    self._matrix = modelMatrix() * viewMatrix() * projectionMatrix() -- use for touched
    
    self.mesh:draw()
    popMatrix()
end

function Mesh.makeMesh(spr, _args) -- Make a plane with a sprite texture

    local args = {}

    -- for not change the origin table
    if _args ~= nil then
        for k,v in pairs(_args) do
            args[k] = v
        end
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
    offset = offset or {left=0, top=0, right=0, bottom=0}

    self._smatrix = self._matrix
    local tc = screentoplane(touch, vec3(0,0,0), vec3(1,0,0), vec3(0,1,0), self._smatrix)
    if tc.x < 0 - offset.left or tc.x > self.dim.w + offset.right or tc.y < 0 - offset.bottom or tc.y > self.dim.h + offset.top then
        return false
    end
    
    return true, vec2(tc.x, tc.y)
end

-- focusAvailable indic if you can catch the focus (~ if an another object before have catch the focus)
-- return true if the object want catch the focus, else false
function Mesh:touched(touch, focusAvailable)
    local isTouched, location = self:isTouched(touch)
    if (touch.state == ENDED and isTouched and focusAvailable) then
        return self:ctouched(location)
    end
    return false
end

-- In most of case, this function is the default behavior of an object, 
-- but if you have a really special object, you can directly @Overwrite Mesh:touched(touch, focusAvailable)
function Mesh:ctouched() return false end -- @Overwrite

function Mesh:keyboard(key) end -- @Overwrite

