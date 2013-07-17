Transition_Miniature = class(ScreenTransition)

Transition_Miniature.directions = {right=0, top=1, left=2, bottom=3}

-- tweensEasing #3
-- times #3
function Transition_Miniature:init(screenFrom, screenTo, times, tweensEasing, direction, distanceOfFall)
    ScreenTransition.init(self, "Miniature", screenFrom, screenTo)
    self.times = times or {2, 2, 2}
    self.tweensEasing = tweensEasing or {tween.easing.bounceOut, tween.easing.quadInOut, nil}
    assert(direction == nil or (direction >= 0 and direction <= 3), "direction invalid")
    self.direction = direction or 0
    self.distanceOfFall = distanceOfFall or 300
end

function Transition_Miniature:start()
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
    self.screenTo.z = -900 - self.distanceOfFall
    
    tween(self.times[1], self.screenFrom, {z=-900 - self.distanceOfFall}, self.tweensEasing[1],
    function()
        local easing = self.tweensEasing[2]
        tween(self.times[2], self.screenFrom, {x=-self.screenTo.x, y=-self.screenTo.y}, easing)
        tween(self.times[2], self.screenTo, {x=0, y=0}, easing,
        function()
            tween(self.times[3], self.screenTo, {z=-900}, self.tweensEasing[3],
            function()
                self.isended = true
            end)
        end)
    end)
end
