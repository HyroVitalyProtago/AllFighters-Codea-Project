-- Engine

-- enum("test", "test1", "test2")
-- local arr = {"test", "test1", "test2"}
-- enum(arr)

function enum(...)
	local tab = {}

	if (#arg == 1 and type(arg[1]) == "table") then
		arg = arg[1]
	end

	for _, v in pairs(arg) do
		tab[v] = v
	end
	return tab
end

function ienum(...)
	local tab = {}
	local i = 1

	if (#arg == 1 and type(arg[1]) == "table") then
		arg = arg[1]
	end

	for _, v in pairs(arg) do
		tab[v] = i
		i = i + 1
	end
	return tab
end