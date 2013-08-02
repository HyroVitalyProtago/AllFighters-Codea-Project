-- ISelect

ISelect = class(Mesh)
function ISelect:init(args)

	if not args then args = {} end
    args.width = args.width or 300
    args.height = args.height or 50

    -- User config
    assert(self.list, "List missing...")
    self.list = args.list
    self.size = args.size or -1 -- define number max of elements displayed
    self.value = nil
    --[[
    	-- backValue = frontValue
		example = {
			1 = "Object 1",
			2 = "Object 2",
			3 = "Object 3",
		}
    ]]--
    self.required = args.required or false
    self._nextField = args._nextField -- field selected when next tab

    -- Style config
    self.textColor = args.textColor or color(0, 0, 0, 255)
    self.backgroundColor = args.backgroundColor or color(255, 255, 255, 255)
    self.font = args.font or "Helvetica-Light"
    self.fontSize = args.fontSize or args.height/2
    self.hoverColor = args.hoverColor or color(0, 0, 0, 70)
    self.strokeColor = args.strokeColor or color(0, 0, 0, 255)
    self.strokeWidth = args.strokeWidth or 3

    -- Back
    self._hover = Mesh.makeMesh(image(args.width, args.height, function(width, height)
        fill(self.hoverColor)
        rect(0,0,width,height)
    end))
    self._hover:hide()
    self._focus()

    local iterateFunc, table = pairs(self.list)
    local backValue, frontValue = iterateFunc(table)
    self._value = backValue

    Mesh.init(self, nil, args)
    self:focusout()
end

function IText:hoverin()
    self._hover:show()
end

function IText:hoverout()
    self._hover:hide()
end

function ISelect:focusin()
end

function ISelect:focusout()
	-------------------------------------------------- Background -------------------------------------------------
    local pmesh = mesh()
    w = self.dim.w
    h = self.dim.h
    pmesh.vertices = {vec3(0,0,0),vec3(w,0,0),vec3(w,h,0),vec3(0,0,0),vec3(0,h,0),vec3(w,h,0)}
    pmesh.texCoords = {vec2(0,0),vec2(1,0), vec2(1,1), vec2(0,0),vec2(0,1), vec2(1,1)}
    pmesh:setColors(255,255,255,255)
    local spr = image(w, h, function(w, h)
        if self:focus() then
            fill(self.focusColor)
        else
            fill(self.backgroundColor)
        end
        stroke(self.strokeColor)
        strokeWidth(self.strokeWidth)
        rect(0, 0, w, h)
    end)
    pmesh.texture = spr
    self.mesh = pmesh
    ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- Text -------------------------------------------------
    self._text = Mesh.makeTextMesh(self.value, {
        font=self.font,
        fontSize=self.fontSize,
        fill=self.textColor
    })
    ---------------------------------------------------------------------------------------------------------------
end

function ISelect:makeOption(selected)

end

function ISelect:draw()
	if self._text then
        self._text.pos.x = self.pos.x - self.dim.w/2 + self._text.dim.w/2 + 10
        self._text.pos.y = self.pos.y
        self._text.pos.z = self.pos.z + 5
    end
    Mesh.draw(self)
    if self._text then self._text:draw() end

    self._hover.pos.x = self.pos.x
    self._hover.pos.y = self.pos.y
    self._hover.pos.z = self.pos.z + 15
    self._hover:draw()

end

function ISelect:val(newVal)
	if newVal == nil then return self.value end
end

function ISelect:touched(touch, focusAvailable)
	if touch.state == ENDED then
	elseif self:isTouched(touch) and not self:focus() then
        self:hoverin()
    else
        self:hoverout()
    end
end