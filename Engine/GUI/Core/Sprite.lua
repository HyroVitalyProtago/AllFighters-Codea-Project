Sprite = class()

function Sprite.drawTextSprite(str,args,getCoords)
    local fontA = args.font or "HelveticaNeue-Light"
    local size = args.fontSize or 80
    local fillA = args.fill or color(255, 255, 255, 255)
    local textModeA = args.textMode or CORNER
    local textWrap = args.textWrapWidth or -1
    local align = args.textAlign or LEFT
    pushStyle()
    smooth()
    font(fontA)
    fontSize(size)
    fill(fillA)
    textMode(textModeA)
    textWrapWidth(textWrap)
    textAlign(align)
    local txtSize = textSize(str)
    if not getCoords then
        text(str,0,0)
    end
    popStyle()
    if getCoords then
        return txtSize
    end
end

function Sprite.makeTextSprite(str,args)
    local w,h = Sprite.drawTextSprite(str,args,true)
    local f = function() Sprite.drawTextSprite(str,args) end
    return Sprite.makeSprite(f,w,h)
end