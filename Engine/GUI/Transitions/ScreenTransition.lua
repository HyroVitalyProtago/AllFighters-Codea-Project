ScreenTransition = class(Screen)

function ScreenTransition:init(name, screenFrom, screenTo)
    Screen.init(self, name)
    self.screenFrom = screenFrom
    self.screenTo = screenTo
    self.isended = false
end
function ScreenTransition:start() end -- @Overwrite
function ScreenTransition:draw()
    self.screenFrom:draw()
    self.screenTo:draw()
    if self:isEnded() then
        self:ended()
    end
end
function ScreenTransition:isEnded()
    return self.isended
end
function ScreenTransition:ended()
    manager:setCurrentState(self.screenTo)
end