Sprite = class()

function Sprite.makeSprite(func,w,h)
    local img = image(w,h)
    
    setContext(img)
    func()
    setContext()
    
    --saveImage("Documents:AAA", img)
    
    return img
end

function Sprite.drawTextSprite(str,args,getCoords)
    local fontA = args.font or "HelveticaNeue-UltraLight"
    local size = args.fontSize or 80
    local fillA = args.fill or color(255, 255, 255, 255)
    local textModeA = args.textMode or CORNER
    local textWrap = args.textWrapWidth or -1
    local align = args.textAlign or LEFT
    smooth()
    font(fontA)
    fontSize(size)
    fill(fillA)
    textMode(textModeA)
    textWrapWidth(textWrap)
    textAlign(align)
    if not getCoords then text(str,0,0)
    else return textSize(str) end
end

function Sprite.makeTextSprite(str,args)
    local w,h = Sprite.drawTextSprite(str,args,true)
    local f = function() Sprite.drawTextSprite(str,args) end
    return Sprite.makeSprite(f,w,h)
end