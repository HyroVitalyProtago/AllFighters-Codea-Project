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

-- function setup()

    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    displayMode(FULLSCREEN_NO_BUTTONS)
    
    parameter.boolean("SHOW_SNAP", false)
    parameter.boolean("SHOW_BOXS", true)
    parameter.boolean("SHOW_BOXS_FIGHTER", false)
    parameter.boolean("DEV_SPRITE", false)
    parameter.number("scal", 0, 5, 1)
    FPS = 0
    
    game = Game()
    mkeyboard = Keyboard()
    MakeTakeshiYamamoto.run()
-- end
