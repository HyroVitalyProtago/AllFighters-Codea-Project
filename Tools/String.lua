-- @Author : SkyTheCoder and Jordan
-- @Version : 1.0.1

function string.replace(s, pattern, replacement)
    return s:gsub(pattern, replacement)
end

function string.remove(s, pattern)
    return string.replace(s, pattern, "")
end

function string.startsWith(s, pattern)
    return not (not s:find("^"..pattern))
end

function string.endsWith(s, pattern)
    return not (not s:find(pattern .. "$"))
end

function string.split(s, pattern)
    local t = {}
    for w in s:gmatch("[^"..pattern.."]+") do
        table.insert(t, w)
    end
    return t
end

function string.allChars(s)
    local t = {}
    for c in s:gmatch(".") do
        table.insert(t, c)
    end
    return t
end

function string.slice(s, interval)
    t = {}
    for sl in s:gmatch(string.rep(".", interval)) do
        table.insert(t, sl)
    end
    return t
end
