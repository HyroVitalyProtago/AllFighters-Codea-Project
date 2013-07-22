-- Tools Main

PROJECTNAME = "Tools"
DESCRIPTION = "Set of utility function for xml, files, string, physics"
VERSION = "1.0.10"

function setup()
    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)
    --/*
    ag = AutoGist(PROJECTNAME,DESCRIPTION,VERSION)
    ag:backup(true)
    --*/
    Dropbox.saveProject(PROJECTNAME, "AllFighters-Codea-Project")
end

function draw()
    background(0, 0, 0, 255)
end

