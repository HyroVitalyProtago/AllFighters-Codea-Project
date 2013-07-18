
function table.copy(tab, n, m)
    local results = {}
    n = n or 1
    m = m or #tab
    for i = n,m do
        table.insert(results, tab[i])
    end
    return results
end

function table.add(t1, t2)
    local results = {}
    for i = 1,#t1 do
        table.insert(results, t1[i])
    end
    for j = 1,#t2 do
        table.insert(results, t2[j])
    end
    return results
end

function table.inverse(tab)
    local result = {}
    for k, v in pairs(tab) do
        result[v] = k
    end
    return result
end

function table.print(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            table.print(v, indent+1)
        else
            print(formatting .. tostring(v))
        end
    end
end