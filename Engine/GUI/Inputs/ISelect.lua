-- ISelect

ISelect = class(Mesh)
function ISelect:init(args)

	if not args then args = {} end
    args.width = args.width or 300
    args.height = args.height or 50

    -- User config
    assert(args.list, "List missing...")
    self.list = args.list
    self.size = args.size or -1 -- define number max of elements displayed (-1 for infinite)
    local iterateFunc, table = pairs(self.list)
    local backValue, frontValue = iterateFunc(table)
    self.value = backValue
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
    self.strokeWidth = args.strokeWidth or 1

    -- Back
    self._hover = Mesh.makeMesh(image(args.width, args.height, function(width, height)
        fill(self.hoverColor)
        rect(0,0,width,height)
    end))
    self._hover:hide()
    self._focus = false
	
	-------------------------------------------------- Background -------------------------------------------------
    local pmesh = mesh()
    w = args.width
    h = args.height
    pmesh.vertices = {vec3(0,0,0),vec3(w,0,0),vec3(w,h,0),vec3(0,0,0),vec3(0,h,0),vec3(w,h,0)}
    pmesh.texCoords = {vec2(0,0),vec2(1,0), vec2(1,1), vec2(0,0),vec2(0,1), vec2(1,1)}
    pmesh:setColors(255,255,255,255)
    local spr = image(w, h, function(w, h)
		fill(self.backgroundColor)
        stroke(self.strokeColor)
        strokeWidth(self.strokeWidth)
        rect(0, 0, w, h)
    end)
    pmesh.texture = spr
    Mesh.init(self, pmesh, args)
    ---------------------------------------------------------------------------------------------------------------
    self:focusout()
end

function ISelect:hoverin()
    self._hover:show()
end

function ISelect:hoverout()
    self._hover:hide()
end

function ISelect:focus(bool)
    if bool == nil then return self._focus end
    if bool and not self._focus then self:focusin() elseif not bool and self._focus then self:focusout() end
    self._focus = bool
end

function ISelect:focusin()
	self:hoverout()
	hideKeyboard()

	-- display list of options
end

function ISelect:focusout()
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