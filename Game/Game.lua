Game = class()

function Game:init()
    self.room = Room("Test", WIDTH, HEIGHT)
    self.room:addWall(-400, 0, WIDTH + 800, 150)
    self.room:addWall(-400, HEIGHT - 25, WIDTH + 800, 25)
    self.room:addWall(-400, 0, 100, HEIGHT)
    self.room:addWall(WIDTH + 400 - 25, 0, 25, HEIGHT)
    
    local obj = FObject("test", nil, false, true)
    obj.width = 100
    obj.height = 50
    self.room:addObject(obj, 250, 400)
    
    local obj = FObject("test", nil, false, true)
    obj.width = 100
    obj.height = 50
    self.room:addObject(obj, 325, 250)
    
    self.player = nil
    self.players = {}
    
    self.controller = nil
    
end

function Game:setPlayer(player, x, y)
    self.player = player
    self.room:addObject(player.fighter, x, y)
    self.controller = player.controller
    table.insert(self.players, player)
end

function Game:addPlayer(player)
    self.room:addObject(player:getFighter(), 125, 50)
    -- player:getController()
    table.insert(self.players, player)
end

function Game:draw()
    
    -- Controller
    self.controller:update()
    
    -- Camera of player
    local x = 0
    local y = 0
    if player ~= nil then
        x = -self.player.fighter.x + WIDTH/2
        y = -self.player.fighter.y + HEIGHT/2
        if y > 0 then y = 0 end
        if x > 400 then x = 400 end -- todo
    end
    
    pushMatrix()
    translate(x, y)
    self.room:draw()
    popMatrix()
    
    -- Life
    -- Power
    
end

function Game:keyboard(k)
    if k.state == BEGAN then
        self.controller:keyPressed(k.key)
    elseif k.state == ENDED then
        self.controller:keyReleased(k.key)
    end
end