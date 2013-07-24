State = class()

function State:init() end
function State:enter(obj) end
function State:execute(obj) end
function State:exit(obj) end
function State:onMessage(entity_type, telegram) return false end