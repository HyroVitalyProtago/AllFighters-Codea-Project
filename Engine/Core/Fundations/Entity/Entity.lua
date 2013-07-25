Entity = class()

Entity.id = 0

-- position
-- velocity
-- sprite
-- physics

function Entity:init()
    self.id = Entity.id
    Entity.id = Entity.id + 1
    
    self.stateMachine = StateMachine(self)
    EntityManager.instance:registerEntity(self)
end

function Entity:update() end

function Entity:ID() return self.id end

function Entity:changeState(newState)
    self.stateMachine:changeState(newState)
end

function Entity:handleMessage(telegram)
	return false
end