StateMachine = class()

function StateMachine:init(owner)
    self.owner = owner
    self.currentState = nil
    self.previousState = nil
    self.globalState = nil
end

function StateMachine:update()
    if self.globalState then self.globalState:execute(owner) end
    if self.currentState then self.currentState:execute(owner) end
end

function StateMachine:changeState(newState)
    assert(self.currentState and newState, "trying to change to a null state")
    self.previousState = self.currentState
    self.currentState:exit(self.owner)
    self.currentState = newState
    self.currentState:enter(self.owner)
end
function StateMachine:revertToPreviousState()
    self:changeState(self.previousState)
end

function StateMachine:isInState(state)
    return self.currentState == state
end

function StateMachine:handleMessage(telegram)
    -- first see if the current state is valid and that it can handle the message
    if (self.currentState and self.currentState:onMessage(self.owner, telegram)) then
        return true

    -- if not, and if a global state has been implemented, send the message to the global state
    elseif (self.globalState and self.globalState:onMessage(self.owner, telegram)) then
        return true

    end
    
    return false
end