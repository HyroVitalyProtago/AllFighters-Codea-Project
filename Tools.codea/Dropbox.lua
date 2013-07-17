Dropbox = {}
--[[
Dropbox.self = {}

function Dropbox.file_get(url, saveAs)
    Dropbox.self.saveAs = saveAs
    http.request(url, Dropbox.save, alert)
end

function Dropbox.save(data, status, headers)
    assert(Dropbox.self.saveAs ~= nil, "You need precised name of file that you want save")
    file_save(os.getenv("HOME").."/Documents/Dropbox.spritepack/" .. Dropbox.self.saveAs, data, true)
end
]]--
-- Dropbox.file_get("https://dl.dropboxusercontent.com/s/ej9fwl37jpumq34/Background.png?token_hash=AAHz5myJ2ViOE350gH_7a49B6hqa-tQtmxlJjDwTtJ896A&dl=1", "test")

function Dropbox.saveProject(projectName, directory)
    local dropbox = os.getenv("HOME").."/Documents/Dropbox.spritepack/"
    if directory then
        dropbox = dropbox .. directory .. "/"
    end
    for _,tab in pairs(listProjectTabs()) do
        file_save(dropbox .. projectName .. ".codea/" .. tab .. ".lua", readProjectTab(projectName .. ":" .. tab))
    end
    print("Project saved !")
end