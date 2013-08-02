Popover = class(Mesh)

function Popover:init(args)

	-- dimensions (with or without arrow)
	-- direction of arrow

	-- Style
	self.backgroundColor = args.backgroundColor or color(255, 255, 255, 255)
	self.strokeColor = args.strokeColor or color(0, 0, 0, 255)
    self.strokeWidth = args.strokeWidth or 3

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

	Mesh.init(self, pmesh, args)
	self:hide()

	-- self.content =
end

-- if touched began not in : hide
-- else
	-- select or scroll