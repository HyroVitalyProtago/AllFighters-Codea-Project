local ___image = image
function image(width, height, fdraw)
    local img = ___image(width, height)
    if fdraw then
        setContext(img)
        fdraw(width, height)
        setContext()
    end
    return img
end
