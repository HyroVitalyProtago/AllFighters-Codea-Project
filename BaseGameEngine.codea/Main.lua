-- BaseGameEngine

-- Dependencies
    -- Tools

PROJECTNAME = "BaseGameEngine"
DESCRIPTION = "Library"
VERSION = "1.0.5"

-- Main - Template
function setup()
    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    Dropbox.saveProject(PROJECTNAME, "AllFighters-Codea-Project")
    --/*
    ag = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
    ag:backup(true)
    --*/
    screen = Screen()
    
    -- Test Mesh:isTouched --
    -- local img = readImage("Cargo Bot:Codea Icon")
    -- local mesh = Mesh.makeMesh(img)
    -- mesh.touched = function(self, touch)
    --     if self:isTouched(touch) and touch.state == BEGAN then
    --         alert("touch ENDED")
    --     end
    -- end
    -- table.insert(screen.meshes, mesh)
    
    -- Test : IText --
    local itext = IText()
    table.insert(screen.meshes, itext)
    
    manager = Manager(screen)
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