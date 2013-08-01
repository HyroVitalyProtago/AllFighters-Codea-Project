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

    -- Back

end

function ISelect:draw()
end

function ISelect:val(newVal)
	if newVal == nil then return self.value end
end