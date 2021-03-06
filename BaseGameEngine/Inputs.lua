-- IText
-- Input.types = {text=0, textarea=1, select=2, checkbox=3, radio=4, slide=5, date=6, color=7}

IText = class(Mesh)
function IText:init(args)
    
    if not args then args = {} end
    args.width = args.width or 300
    args.height = args.height or 50
    
    -- User
    self.number = args.number or false
    if self.number then
        self.min = args.min
        self.max = args.max
    else
        self.maxlength = args.maxlength
        self.minlength = args.minlength
        self.pattern = args.pattern
    end
    self.placeholder = args.placeholder
    self.value = args.value or ""
    self.disabled = args.disabled
    self.required = args.required
    
    -- Style
    self.textColor = args.textColor or color(0, 0, 0, 255)
    self.backgroundColor = args.backgroundColor or color(255, 255, 255, 255)
    self.font = args.font or "Helvetica-Light"
    self.fontSize = args.fontSize or args.height/2
    self.cursorColor = args.cursorColor or color(0, 0, 255, 255)
    self.focusColor = args.focusColor or color(230, 230, 230, 255)
    -- self.hoverColor = args.hoverColor or color(0, 0, 255, 255)
    self.strokeColor = args.strokeColor or color(0, 0, 0, 255)
    self.strokeWidth = args.strokeWidth or 3
    self.cursorSpeed = args.cursorSpeed or 0.25
    -- self.borderRadius = args.borderRadius or {top=10, left=10, right=10, bottom=10}
    -- if type(self.borderRadius) == "number" then
    --     self.borderRadius = {top=self.borderRadius, left=self.borderRadius, 
    --         right=self.borderRadius, bottom=self.borderRadius}
    -- end
    
    
    -- Back
    self._focus = false
    self._hover = false
    if self.value == nil then
        self.cursor = 0
    else
        self.cursor = string.len(self.value)
    end
    
    Mesh.init(self, pmesh, args)
    self:update()
    
end

function IText:update()
    -------------------------------------------------- Background -------------------------------------------------
    local pmesh = mesh()
    w = self.dim.w
    h = self.dim.h
    pmesh.vertices = {vec3(0,0,0),vec3(w,0,0),vec3(w,h,0),vec3(0,0,0),vec3(0,h,0),vec3(w,h,0)}
    pmesh.texCoords = {vec2(0,0),vec2(1,0), vec2(1,1), vec2(0,0),vec2(0,1), vec2(1,1)}
    pmesh:setColors(255,255,255,255)
    local spr = image(w, h)
    setContext(spr)
        if self:focus() then
            fill(self.focusColor)
        else
            fill(self.backgroundColor)
        end
        stroke(self.strokeColor)
        strokeWidth(self.strokeWidth)
        rect(0, 0, w, h)
    setContext()
    pmesh.texture = spr
    self.mesh = pmesh
    ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- Text -------------------------------------------------
    if self.value then
        self._text = Mesh.makeTextMesh(self.value, {
            font=self.font,
            fontSize=self.fontSize,
            fill=self.textColor
        })
    end
    ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- Text -------------------------------------------------
    if self.placeholder then
        self._placeholder = Mesh.makeTextMesh(self.placeholder, {
            font=self.font,
            fontSize=self.fontSize,
            fill=self.textColor
        })
    end
    ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- Cursor -------------------------------------------------
    local spr = image(2, h*0.8)
    setContext(spr)
        noStroke()
        fill(self.cursorColor)
        rect(0,0,spr.width, spr.height)
    setContext()
    self._cursor = Mesh.makeMesh(spr, {})
    ---------------------------------------------------------------------------------------------------------------
end

function IText:draw()
    -- if not isKeyboardShowing() and self:focus() then showKeyboard() end
    
    if self._text then
        self._text.pos.x = self.pos.x - self.dim.w/2 + self._text.dim.w/2 + 10
        self._text.pos.y = self.pos.y
        self._text.pos.z = self.pos.z + 5
    end
    
    local value = self.value
    font(self.font)
    fontSize(self.fontSize)
    valueW, valueH = textSize(string.sub(value, 0, self.cursor))
    self._cursor.pos.x = self.pos.x - self.dim.w/2 + self._cursor.dim.w/2 + 10 + valueW
    self._cursor.pos.y = self.pos.y - self.dim.h/2 + self._cursor.dim.h/1.6
    self._cursor.pos.z = self.pos.z + 10
    
    Mesh.draw(self)
    if self._text then self._text:draw() end
    if self._placeholder and string.len(self:val()) == 0 then self._text:draw() end
    if self:focus() and self:showCursor() then self._cursor:draw() end
end

function IText:showCursor()
    if self.__lastTime == nil then
        self.__lastTime = os.clock()
    else
        if os.clock() - self.__lastTime >= self.cursorSpeed then
            self.__lastTime = os.clock()
        elseif os.clock() - self.__lastTime < self.cursorSpeed/2 then
        else
            return false
        end
    end
    return true
end

function IText:val(newval)
    if newval then self.value = newval else return self.value end
end

function IText:focus(bool)
    if bool == nil then return self._focus end
    if bool and not self._focus then self:focusin() elseif not bool and self._focus then self:focusout() end
    self._focus = bool
    self:update()
end

function IText:focusin()
    self.lastValue = self.value
    if self.value == nil then
        self.cursor = 0
    else
        self.cursor = string.len(self.value)
    end
    showKeyboard()
end

function IText:focusout()
    --hideKeyboard()
end

function IText:touched(touch, firstElementTouch)
    if touch.state == ENDED then
        if self:isTouched(touch) and firstElementTouch then
            if self:focus() then
                showKeyboard()
                -- location current cursor
                local len = string.len(self:val())
                if len == 0 then return end
                local origin = self.pos.x - self.dim.w/2 + self._cursor.dim.w/2
                local diff = touch.x - origin
                for i = 0, len do
                    local value = self.value
                    font(self.font)
                    fontSize(self.fontSize)
                    valueW, valueH = textSize(string.sub(value, 0, i))
                    -- print(i, valueW, diff)
                    if (diff < valueW) then
                        self.cursor = i-1
                        return true
                    end
                end
                self.cursor = len
            else
                self:focus(true)
            end
            return true
        else
            if self:focus() then
                self:focus(false)
            end
        end
    end
end

function IText:onchange() end

function IText:keyboard(key)
    if self:focus() then
        if string.byte(key) == 10 then -- enter
            self:focus(false)
            hideKeyboard()
        elseif string.byte(key) == nil then -- retour
            if self.cursor == 0 then return end
            self:val(string.sub(self:val(), 0, self.cursor-1) .. string.sub(self:val(), self.cursor+1, string.len(self:val())))
            self.cursor = self.cursor - 1
        else    
            if self.number and string.match(key, "%d") == nil and key ~= "." and key ~= "-" then
                -- popover || alert number...
                alert("This could be a number...")
                return
            end
            self:val(string.sub(self:val(), 0, self.cursor) .. key .. string.sub(self:val(), self.cursor+1, string.len(self:val())))
            self.cursor = self.cursor + 1
        end
        self:onchange()
        self:update()
    end
end