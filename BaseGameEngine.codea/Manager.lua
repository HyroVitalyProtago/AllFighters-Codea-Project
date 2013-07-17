Manager = class()

Manager.FPS = 0

function Manager:init(screen, viewTouches, customConfig)
    self.currentState = nil
    self.viewTouches = viewTouches or false
    self.touches = {}
    self.customConfig = customConfig
    
    --hideKeyboard()
    
    if screen then self:setCurrentState(MadeWithCodea(screen)) end
end

function Manager:draw()
    Manager.FPS = Manager.FPS*.9+.1/DeltaTime
    
    background(0, 0, 0, 255)
    noFill()
    stroke(255, 255, 255, 255)
    strokeWidth(5)
    font("HelveticaNeue-Light")
    if self.customConfig then self.customConfig() end
    
    if self.currentState == nil then
        return
    end
    
    self.currentState:draw()
    if self.currentState:isEnded() then
        self.currentState:ended()
    end
    
    for k,touch in pairs(self.touches) do
        if (self.viewTouches) then 
            math.randomseed(touch.id)
            fill(math.random(255),math.random(255),math.random(255))
            ellipse(touch.x, touch.y, 100, 100)
        end
        if self.currentState ~= nil then
            self.currentState:touched(touch)
        end
    end

end

function Manager:setCurrentState(state, start)
    self.currentState = state
    if start == nil or start then
        state:start()
    end
end

function Manager:touched(touch)
    self:_touches(touch)
end

function Manager:_touches(touch)
    if touch.state == ENDED then
        if self.currentState ~= nil then
            self.currentState:touched(touch)
        end
        self.touches[touch.id] = nil
    else
        self.touches[touch.id] = touch
    end
end

function Manager:keyboard(key)
    if self.currentState then
        self.currentState:keyboard(key)
    end
end