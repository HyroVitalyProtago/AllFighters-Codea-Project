-- @Author : Hyro Vitaly Protago
-- @Version : 1.0.0

function file_get_contents(filename, alert_enable)
    alert_enable = alert_enable or false
    local file, error = io.open(filename,"r")
    if file == nil then
        local msg = filename .. " @io.open : " .. error
        if alert_enable then alert(msg) else print(msg) end
        return false
    end
    local str = ""
    while 1 do
        local data = file:read()
        if data == nil then
            file:close()
            break
        end
        str = str .. data
    end
    return str
end

function file_save(filename, content, alert_enable)
    alert_enable = alert_enable or false
    local file, error = io.open(filename, "w")
    if file == nil then
        local msg = filename .. " @io.open : " .. error
        if alert_enable then alert(msg) else print(msg) end
        return false
    end
    file:write(content)
    file:close()
end

function file_append(filename, content, alert_enable)
    alert_enable = alert_enable or false
    local file, error = io.open(filename, "a")
    if file == nil then
        local msg = filename .. " @io.open : " .. error
        if alert_enable then alert(msg) else print(msg) end
        return false
    end
    file:write(content)
    file:close()
end