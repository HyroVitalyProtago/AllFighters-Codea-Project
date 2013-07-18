Transition_Rotate = class(ScreenTransition)

-- TODO

function Transition_Rotate:init(screenFrom, screenTo, time, tweenEasing)
    ScreenTransition.init(self, "RotateToRight", screenFrom, screenTo)
    self.time = time or 2
    self.tweenEasing = tweenEasing
end

function Transition_Rotate:start()
    ScreenTransition.start(self)
    
    self.screenTo.x = WIDTH
    self.screenTo.angle.y = -90
    
    tween(self.time, self.screenFrom.angle, {y=90}, self.tweenEasing)
    tween(self.time, self.screenFrom, {z=-900+WIDTH}, self.tweenEasing)
    
    tween(self.time, self.screenTo.angle, {y=0}, self.tweenEasing)
    
    --[[
    
    -- Better use of tween, but approximate (z of screenFrom)
    
    self.point = {x=self.screenFrom.x + WIDTH, y=self.screenFrom.z}
    
    local path = {}
    for i=0,90 do
        local teta = -math.rad(i)
        local tmp = vec2(WIDTH, 0)
        local v = {x=0,y=0}
        v.x = self.screenFrom.x + math.cos(teta)*tmp.x - math.sin(teta)*tmp.y
        v.y = self.screenFrom.z + (WIDTH * i/90) + math.sin(teta)*tmp.x + math.cos(teta)*tmp.y
        table.insert(path, v)
    end
    
    tween.path(self.time, self.point, path, self.tweenEasing)
    
    ]]--
    
    tween.delay(self.time, function()
        self.isended = true
    end)

end

function Transition_Rotate:draw()
    local teta = -math.rad(self.screenFrom.angle.y)
    local tmp = vec2(WIDTH, 0)
    self.screenTo.x = self.screenFrom.x + math.cos(teta)*tmp.x - math.sin(teta)*tmp.y
    self.screenTo.z = self.screenFrom.z + math.sin(teta)*tmp.x + math.cos(teta)*tmp.y
    
    ScreenTransition.draw(self)
end
