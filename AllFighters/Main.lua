-- AllFighters

-- Dependencies
    -- BaseGameEngine
    -- Tools

PROJECTNAME = "AllFighters"
DESCRIPTION = "Plateform/Fighting Game inspired by 'Jump Ultimate Star' and 'Super Smash Bross'."
VERSION = "0.0.3"

--GITHUB = "https://raw.github.com/"
--ALL_FIGHTERS = "HyroVitalyProtago/AllFighters/master/"
SPRITES = "SpriteAllFighters/"
TAKESHI_YAMAMOTO = "TakeshiYamamoto/"

SPRITES_LOCATION = "Dropbox:" .. SPRITES

function setup()

    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    --/*
    -- ag = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
    -- ag:backup(true)
    --*/
    -- Dropbox.saveProject(PROJECTNAME, "AllFighters-Codea-Project")
    displayMode(FULLSCREEN_NO_BUTTONS)
    
    parameter.boolean("SHOW_SNAP", false)
    parameter.boolean("SHOW_BOXS", true)
    parameter.boolean("SHOW_BOXS_FIGHTER", false)
    parameter.boolean("DEV_SPRITE", false)
    parameter.number("scal", 0, 5, 1)
    FPS = 0
    --parameter.watch("FPS")
    
    game = Game()
    mkeyboard = Keyboard()
    MakeTakeshiYamamoto.run()
    -- showKeyboard()
    
    -- Test rect xml
    --[[
    r = Rectangle(2, 7, 14, 12)
    xml = r:toXml()
    r2 = Rectangle(0,0,0,0)
    r2:fromXml(xml)
    
    print(r.x, r2.x)
    ]]--
end

setup()

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