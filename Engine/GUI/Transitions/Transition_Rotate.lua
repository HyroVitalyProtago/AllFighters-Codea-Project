Transition_Rotate = class(ScreenTransition)

function Transition_Rotate:init(screenFrom, screenTo, time, tweenEasing)
    ScreenTransition.init(self, "RotateToRight", screenFrom, screenTo)
    self.time = time or 2
    self.tweenEasing = tweenEasing
end

function Transition_Rotate:start()
    ScreenTransition.start(self)
    
    self.screenTo.pos.x = WIDTH
    self.screenTo.angle.y = -90
    
    tween(self.time, self.screenFrom.angle, {y=90}, self.tweenEasing)
    tween(self.time, self.screenFrom.pos, {z=-900+WIDTH}, self.tweenEasing)
    
    tween(self.time, self.screenTo.angle, {y=0}, self.tweenEasing)
    
    tween.delay(self.time, function()
        self.isended = true
    end)

end

function Transition_Rotate:draw()
    local teta = -math.rad(self.screenFrom.angle.y)
    local tmp = vec2(WIDTH, 0)
    self.screenTo.pos.x = self.screenFrom.pos.x + math.cos(teta)*tmp.x - math.sin(teta)*tmp.y
    self.screenTo.pos.z = self.screenFrom.pos.z + math.sin(teta)*tmp.x + math.cos(teta)*tmp.y
    
    ScreenTransition.draw(self)
end
