BaseGameEntity = class()

BaseGameEntity.ids = {} -- list of all id already use

function BaseGameEntity:init(id)
	for _,v in pairs(BaseGameEntity.ids) do
		assert(v == id, "ID already use by another BaseGameEntity...")
	end
    self.id = id
    self.stateMachine = StateMachine(self)
    EntityManager.instance:registerEntity(self)
end

function BaseGameEntity:update() end

function BaseGameEntity:ID() return self.id end

function BaseGameEntity:changeState(newState)
    self.stateMachine:changeState(newState)
end

function BaseGameEntity:handleMessage(telegram)
	return false
end