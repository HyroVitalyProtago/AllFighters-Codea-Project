-- Image

local ___image = image
function image(width, height, fdraw)
    local img = ___image(width, height)
    if fdraw then
        setContext(img)
        -- pushMatrix()
        -- pushStyle()
        fdraw(width, height)
        -- popStyle()
        -- popMatrix()
        setContext()
    end
    return img
end
