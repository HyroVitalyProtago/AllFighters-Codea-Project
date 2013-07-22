Manager = class()

Manager.FPS = 0

function Manager:init(screen, madeWithCodea, viewTouches, viewFps)
    assert(screen ~= nil, "Manager can't start without screen...")

    self.currentState = nil

    self.viewTouches = viewTouches or false
    self.touches = {}

    self.viewFps = self.viewFps or false
    
    madeWithCodea = madeWithCodea or true
    if madeWithCodea then 
        self:setCurrentState(MadeWithCodea(screen))
    else
        self:setCurrentState(screen)
    end
end

function Manager:draw()
    Manager.FPS = Manager.FPS*.9+.1/DeltaTime
    
    if self.currentState == nil then
        return
    end
    
    pushMatrix()
    pushStyle()
        self.currentState:draw()
        if self.currentState:isEnded() then
            self.currentState:ended()
        end
    popStyle()
    popMatrix()

    if (self.viewFps) then
        pushStyle()
            local w, h = 50, 50
            fill(0,0,0)
            rect(WIDTH - w/2, HEIGHT - h/2, w, h)

            fill(255,255,255)
            text(FPS,WIDTH - w/2, HEIGHT - h/2)
        popStyle()
    end
    
    for k,touch in pairs(self.touches) do
        if (self.viewTouches) then
            math.randomseed(touch.id)
            pushStyle()
                fill(math.random(255),math.random(255),math.random(255))
                ellipse(touch.x, touch.y, 100, 100)
            popStyle()
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