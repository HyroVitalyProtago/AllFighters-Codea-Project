Transition_Translate = class(ScreenTransition)

Transition_Translate.directions = {right=0, top=1, left=2, bottom=3}

function Transition_Translate:init(screenFrom, screenTo, ptime, tweenEasing, direction)
    ScreenTransition.init(self, "Translate", screenFrom, screenTo)
    self.time = ptime or 2
    self.tweenEasing = tweenEasing or nil
    assert(direction == nil or (direction >= 0 and direction <= 3), "direction invalid")
    self.direction = direction or 0
end

function Transition_Translate:start()
    ScreenTransition.start(self)
    
    if self.direction == 0 then
        self.screenTo.x = WIDTH
    elseif self.direction == 1 then
        self.screenTo.y = HEIGHT
    elseif self.direction == 2 then
        self.screenTo.x = -WIDTH
    elseif self.direction == 3 then
        self.screenTo.y = -HEIGHT
    end
    
    tween(self.time, self.screenFrom, {x=-self.screenTo.x, y=-self.screenTo.y}, self.tweenEasing)
    tween(self.time, self.screenTo, {x=0, y=0}, self.tweenEasing,
    function()
        self.isended = true
    end)
end
