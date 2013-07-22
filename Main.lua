function draw()
    FPS = FPS*.9+.1/DeltaTime
    
    background(0, 0, 0, 255)
    font("AmericanTypewriter")
    spriteMode(CORNER)
    noFill()
    strokeWidth(2)
    smooth()
    
    scale(scal)
    if MakeTakeshiYamamoto.isLoaded then
        game:draw()
        mkeyboard:draw()
    else
        --sprite("Documents:Background")
        fill(255, 255, 255, 255)
        fontSize(50)
        txt = "Loading"
        local w, h = textSize(txt)
        text(txt .. "...", WIDTH/2, HEIGHT/2)
    end
    
    pushMatrix()
    resetMatrix()
    pushStyle()
    font("Copperplate-Light")
    fontSize(25)
    fill(255, 255, 255, 255)
    text(math.floor(FPS), WIDTH - 50, HEIGHT - 50)
    popStyle()
    popMatrix()
end

function touched(touch)
    local key = mkeyboard:touched(touch)
    if key then
        keyboard(key)
    end
end

function keyboard(key)
    print(key)
    game:keyboard(key)
end
