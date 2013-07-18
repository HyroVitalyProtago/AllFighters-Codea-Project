-- AllFighters_SDK

-- Dependencies
    -- AllFighters
    -- BaseGameEngine
    -- Tools

PROJECTNAME = "AllFighters_SDK"
DESCRIPTION = "Source Development Kit for AllFighters"
VERSION = "0.0.6"

supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN_NO_BUTTONS)

-- AllFighters_SDK config
SPRITE_DIRECTORY = "SpriteAllFighters/"
SPRITE_DIRECTORY_FULL = "Dropbox:" .. SPRITE_DIRECTORY
SDK_DIRECTORY = SPRITE_DIRECTORY_FULL .. "SDK/"
FILE_LOCATION = os.getenv("HOME").."/Documents/Dropbox.spritepack/"
FIGHTERS_XML = FILE_LOCATION .. SPRITE_DIRECTORY .. "/fighters.xml"
--

-- AllFighters config
SHOW_SNAP = true
SHOW_BOXS = true
SHOW_BOXS_FIGHTER = true
DEV_SPRITE = false
--

function setup()
    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    --/*
    ag = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
    ag:backup(true)
    --*/
    Dropbox.saveProject(PROJECTNAME, "AllFighters-Codea-Project")
    -- manager = Manager(Screen_MainMenu())
    manager = Manager()
    manager:setCurrentState(Screen_Fighter({name="Takeshi Yamamoto", directory="TakeshiYamamoto"}))
end

function draw()
    manager:draw()
end

function touched(touch)
    manager:touched(touch)
end

function keyboard(key)
    manager:keyboard(key)
end