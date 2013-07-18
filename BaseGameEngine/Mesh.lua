Mesh = class()

-- Sugar for easier manipulation of animations on all attributs
Mesh.sugars = {width="dim.w", height="dim.h", w="dim.w", w="dim.h", 
    posX="pos.x", posY="pos.y", posZ="pos.z", 
    angleX="angle.x", angleY="angle.y", angleZ="angle.z"}

function Mesh:init(pmesh, args)
    if args == nil then
        args = {}
    end
    
    self.mode = args.mode or CENTER
    self.mesh = pmesh
    self.dim = {}
    self.dim.w, self.dim.h = args.width, args.height
    self.pos = {}
    self.pos.x = args.x or WIDTH*0.5
    self.pos.y = args.y or HEIGHT*0.5
    self.pos.z = args.z or 5
    
    self.angle = {}
    self.angle.x = 0
    self.angle.y = 0
    self.angle.z = 0

    self.alpha = 255
    self._matrix = nil
    
end

function Mesh:show()
    self.alpha = 255
end

function Mesh:hide()
    self.alpha = 0
end

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
    pushMatrix()
    
    if not self.mesh then return end
    
    self.mesh:setColors(color(255,255,255,self.alpha))
    
    if self.mode == CENTER then
        translate(self.pos.x - (self.dim.w/2), self.pos.y - (self.dim.h/2), self.pos.z)
    elseif CORNER then
        translate(self.pos.x, self.pos.y, self.pos.z)
    end
    rotate(self.angle.x, 1,0,0)
    rotate(self.angle.y, 0,1,0)
    rotate(self.angle.z, 0,0,1)
    self._matrix = modelMatrix() * viewMatrix() * projectionMatrix()
    
    self.mesh:draw()
    popMatrix()
end

function Mesh.makeMesh(spr, args)
    
    if args == nil then
        args = {}
    end
    
    local w,h = spriteSize(spr)
    w = args.width or w
    h = args.height or h
    local myMesh = mesh()
    myMesh.vertices = {vec3(0,0,0),vec3(w,0,0),vec3(w,h,0),vec3(0,0,0),vec3(0,h,0),vec3(w,h,0)}
    myMesh.texCoords = {vec2(0,0),vec2(1,0), vec2(1,1), vec2(0,0),vec2(0,1), vec2(1,1)}
    
    if not args.color then
        args.color = color(255, 255, 255, 255)
    end
    myMesh:setColors(args.color.r,args.color.g,args.color.b,args.color.a)
    myMesh.texture = spr
    
    myMesh.shader = args.shader
    
    args.width = w
    args.height = h
    
    return Mesh(myMesh, args)
end

function Mesh.makeTextMesh(str, args)
    local spr = Sprite.makeTextSprite(str,args)
    
    local w,h = spriteSize(spr)
    local myMesh = mesh()
    myMesh.vertices = {vec3(0,0,0),vec3(w,0,0),vec3(w,h,0),vec3(0,0,0),vec3(0,h,0),vec3(w,h,0)}
    myMesh.texCoords = {vec2(0,0),vec2(1,0), vec2(1,1), vec2(0,0),vec2(0,1), vec2(1,1)}
    
    --local fillA = args.fill or color(255, 255, 255, 255)
    --myMesh:setColors(fillA.r, fillA.g, fillA.b, fillA.a)
    myMesh.texture = spr
    
    args.width = w
    args.height = h
    
    return Mesh(myMesh, args)
end

function Mesh:insertIn(arrays)
    for _,array in pairs(arrays) do
        table.insert(array, self)
    end
    return self -- useful for compact syntax
end

function Mesh:isTouched(touch, offset)

    self._smatrix = self._matrix
    local tc = screentoplane(touch, vec3(0,0,0), vec3(1,0,0), vec3(0,1,0), self._smatrix)
    -- Was the picture touched?
    if tc.x < 0 or tc.x > self.dim.w or tc.y < 0 or tc.y > self.dim.h then
        return false
    end
    
    return true
end

------------------------------------ Utils for matrix ------------------------------------
-- @Author : Andrew_Stacey
-- 

function applymatrix4(v,m)
    return vec4(
        m[1]*v[1] + m[5]*v[2] + m[09]*v[3] + m[13]*v[4],
        m[2]*v[1] + m[6]*v[2] + m[10]*v[3] + m[14]*v[4],
        m[3]*v[1] + m[7]*v[2] + m[11]*v[3] + m[15]*v[4],
        m[4]*v[1] + m[8]*v[2] + m[12]*v[3] + m[16]*v[4]
        )
end

-- Apply a 3-matrix to a 3-vector
function applymatrix3(v,m)
    return v.x * m[1] + v.y * m[2] + v.z * m[3]
end

-- Compute the cofactor matrix of a 3x3 matrix, entries
-- hard-coded for efficiency.
-- The cofactor differs from the inverse by a scale factor, but
-- as our matrices are only well-defined up to scale, this
-- doen't matter.
function cofactor3(m)
    return {
        vec3(
            m[2].y * m[3].z - m[3].y * m[2].z,
            m[3].y * m[1].z - m[1].y * m[3].z,
            m[1].y * m[2].z - m[2].y * m[1].z
        ),
        vec3(
            m[2].z * m[3].x - m[3].z * m[2].x,
            m[3].z * m[1].x - m[1].z * m[3].x,
            m[1].z * m[2].x - m[2].z * m[1].x
        ),
        vec3(
            m[2].x * m[3].y - m[3].x * m[2].y,
            m[3].x * m[1].y - m[1].x * m[3].y,
            m[1].x * m[2].y - m[2].x * m[1].y
        )
    }
end

-- Given a plane in space, this computes the transformation
-- matrix from that plane to the screen
function __planetoscreen(o,u,v,A)
    A = A or modelMatrix() * viewMatrix() * projectionMatrix()
    o = o or vec3(0,0,0)
    u = u or vec3(1,0,0)
    v = v or vec3(0,1,0)
    -- promote to 4-vectors
    o = vec4(o.x,o.y,o.z,1)
    u = vec4(u.x,u.y,u.z,0)
    v = vec4(v.x,v.y,v.z,0)
    local oA, uA, vA
    oA = applymatrix4(o,A)
    uA = applymatrix4(u,A)
    vA = applymatrix4(v,A)
    return { vec3(uA[1], uA[2], uA[4]),
             vec3(vA[1], vA[2], vA[4]),
             vec3(oA[1], oA[2], oA[4])}
end

-- Given a plane in space, this computes the transformation
-- matrix from the screen to that plane
function screentoplane(t,o,u,v,A)
    A = A or modelMatrix() * viewMatrix() * projectionMatrix()
    o = o or vec3(0,0,0)
    u = u or vec3(1,0,0)
    v = v or vec3(0,1,0)
    t = t or CurrentTouch
    local m = __planetoscreen(o,u,v,A)
    m = cofactor3(m)
    local ndc = vec3((t.x/WIDTH - .5)*2,(t.y/HEIGHT - .5)*2,1)
    local a
    a = applymatrix3(ndc,m)
    if (a[3] == 0) then return end
    a = vec2(a[1], a[2])/a[3]
    return o + a.x*u + a.y*v
end
------------------------------------------------------------------------

-- firstElementTouch indic if a element have catch focus
-- return catchFocus
function Mesh:touched(touch, firstElementTouch) return false end
function Mesh:keyboard(key) end

function Mesh._explode(div, str)
    if div == "" then return false end
    local pos = 0
    local arr = {}
    for st, sp in function() return string.find(str, div, pos, true) end do
        table.insert(arr, string.sub(str, pos, st-1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end
function Mesh:__index(k)
    if Mesh[k] then return Mesh[k] end
    for sugarKey, key in pairs(Mesh.sugars) do
        if k == sugarKey then
            local arr = Mesh._explode(".", key)
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
function Mesh:__newindex(k, v)
    for sugarKey, key in pairs(Mesh.sugars) do
        if k == sugarKey then
            local arr = Mesh._explode(".", key)
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