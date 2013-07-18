-- @Author : Hyro Vitaly Protago
-- @Version : 1.0.0

function project_replaceAll(pattern, replacement)
    local tabs = listProjectTabs()
    for k,v in pairs(tabs) do
        local file = readProjectTab(v)
        file = string.replace(file, pattern, replacement)
        saveProjectTab(v, file)
    end
end

-- Optimisations

-- table.insert => tbl[#tbl+1]