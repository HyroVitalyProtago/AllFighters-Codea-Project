-- Memento (undo, redo)
Memento = class()

function Memento:init(object)
    self.object = object
    self._undo = {}
    self._redo = {}
end

-- actions = {action, undo}
function Memento:push(actions)
    self._undo[#self._undo+1] = actions
end

function Memento:undo()
    object = self.object
    if (#self._undo > 0) then
        self._redo[#self._redo+1] = {self._undo[#self._undo][2], self._undo[#self._undo][1]}
        loadstring(self._undo[#self._undo][2])
            table.remove(self._redo[#self._undo])
    end
end

function Memento:redo()
    object = self.object
    if (#self._redo > 0) then
        self._undo[#self._undo+1] = {self._redo[#self._redo][2], self._redo[#self._redo][1]}
        loadstring(self._redo[#self._redo][2])
        table.remove(self._redo[#self._redo])
    end
end


-- save and load images, xml, fighter

function loadFighters()
    local tbl = {}
    local xml = XML(file_get_contents(FIGHTERS_XML))
    for _,v in pairs(xml.racine["fighters"]) do
        tbl[#tbl+1] = v
    end
    return tbl
end