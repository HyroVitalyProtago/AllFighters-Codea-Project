
function tween.runAll(listOfObject, ...)
    local time = arg[1]
    local tab = arg
    table.remove(tab, 1)
    for _, v in pairs(listOfObject) do
        tween(time, v, unpack(tab))
    end
end

function tween.runAllById(ids)
    for _, id in pairs(ids) do
        tween.play(id)
    end
end

function tween.stockAll(listOfObject, ...)
    local tweens = {}
    local time = arg[1]
    local tab = arg
    table.remove(tab, 1)
    for _, v in pairs(listOfObject) do
        local _tween = tween(time, v, unpack(tab))
        tween.reset(_tween)
        table.insert(tweens, _tween)
    end
    return tweens
end
