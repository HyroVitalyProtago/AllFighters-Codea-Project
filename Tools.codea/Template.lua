--[[
-- @Author : Hyro Vitaly Protago
PROJECTNAME = ""
DESCRIPTION = ""
VERSION = "1.0.0"
-- DEBUG = true

function setup()
    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    --/*
    ag = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
    ag:backup(true)
    --*/
end

function draw()
    background(0, 0, 0, 255)
end

function touched(touch)
end

function keyboard(key)
end

function orientationChanged(newOrientation)
end

]]-- end
function Main()
    local tpl = readProjectTab("Tools:Template")
    tpl = string.sub(tpl, 6, string.find(tpl, "-- end") - 4)
    saveProjectTab("Main", tpl)
    close()
end