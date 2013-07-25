EntityManager = class()

-- Singleton pattern
function EntityManager:init()
    if EntityManager.instance ~= nil then
        assert(false, "Pattern Singleton")
    end
    self.entityMap = {}
end

function EntityManager:registerEntity(entity)
    table.insert(self.entityMap, entity:ID(), entity)
end

function EntityManager:getEntityFromID(id)
    return self.entityMap[id]
end

function EntityManager:getNameOfEntity(id)
    return self:getEntityFromID(id).name -- or "Unnamed"
end

function EntityManager:removeEntity(entity)
    table.remove(self.entityMap, entity:ID())
end

EntityManager.instance = EntityManager()