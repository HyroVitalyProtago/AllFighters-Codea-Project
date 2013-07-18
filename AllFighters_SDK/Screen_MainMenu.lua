Screen_MainMenu = class(Screen)

Screen_MainMenu.sprites = {
    tile = readImage(SDK_DIRECTORY .. "tile"),
    add = readImage(SDK_DIRECTORY .. "add"),
    shadow = readImage(SDK_DIRECTORY .. "shadow")
}

function Screen_MainMenu:init()
    Screen.init(self, "MainMenu")
    
    self.currentIndex = 1
    self.nbFighters = 0
    self.showMakeFighter = false
    self.listOfFighters = loadFighters()
    self.nbFighters = #self.listOfFighters
    
    ------------------------------- Background -----------------------------
    ToolScreen.makeCustomBackground(self)
    ----------------------------------------------------------------------
    
    ------------------------------- Menu top -----------------------------
    ToolScreen.makeMenuTop(self)
    ToolScreen.makeCurrentLocation(self, "AllFighters - Source Development Kit")
    ToolScreen.makeInfos(self)
    ToolScreen.makePreviousMenuTop(self, "Exit")
    
    local screen = self
    self.previousMenuTop.touched = function(self, touch)
        if self:isTouched(touch) and touch.state == BEGAN then
            close()
        end
    end
    ----------------------------------------------------------------------
    
    self.fighters = {}
    ------------------------------- Fighters -----------------------------
    local spr = image(200, 200, function(width, height)
        local _img = Screen_MainMenu.sprites.tile
        tint(0, 0, 0, 255)
        sprite(_img, width/2, height/2, _img.width*1, _img.height*1)
        noTint()
        local _img = Screen_MainMenu.sprites.add
        tint(255,255,0,255)
        sprite(_img, width/2, height/2, _img.width*0.5, _img.height*0.5)
    end)
    
    for i = 1, self.nbFighters + 1 do
        self.fighters[i] = Mesh.makeMesh(spr, {})
        self.fighters[i].pos.x = 250/2 + 50 + ((i-1)%4)*225 + math.floor((i-1)/12)*WIDTH
        self.fighters[i].pos.y = HEIGHT - 60 - (250/2) - (math.ceil(i/4)-1)*225 + math.floor((i-1)/12)*(HEIGHT-90)
        self.fighters[i].pos.z = 10
        
        -- TODO
        --if i <= 12 then
            table.insert(self.meshes, self.fighters[i])
        --end
        local todo = function()
            if i == 1 then
                self:makeFighter()
            else
                tween.resetAll()
                local ns = Screen_Fighter(self.listOfFighters[i-1])
                self.touched = function() end -- disable touch on screen
                -- TODO: icone loading on fighter
                tween.delay(0.2, function()
                    local t = Transition_Translate(self, ns, 0.5, tween.easing.cubicInOut)
                    manager:setCurrentState(t)
                end)
            end
        end
        self.fighters[i].touched = function(self, touch)
            --[[
            if self._clockT and os.clock() - self._clockT > 1 and not self._alert then
                self._alert = true
                alert("Do you want to remove ?") -- active remove mode
            end
            if self:isTouched(touch) and touch.state == BEGAN and not self._clockT then
                self._clockT = os.clock()
            end
            ]]--
            if self:isTouched(touch) and touch.state == ENDED then
                todo()
            end
        end
        
        if i == self.nbFighters + 1 then break end
        
        -- To Optimize
        spr = image(200, 200)
        setContext(spr)
        
            fill(0, 0, 0, 255)
            ellipse(spr.width/2, 17.5,180,35)
        
            local _img = Screen_MainMenu.sprites.tile
            tint(math.random(255), math.random(255), math.random(255), 235)
            sprite(_img, spr.width/2, spr.height/2, _img.width*1, _img.height*1)
            
            noTint()
            
            local directory = self.listOfFighters[i]["name"]:gsub("%s+", "")
            self.listOfFighters[i]["directory"] = directory
            local idImg = math.random(self.listOfFighters[i]["nbImgs"])
            local _img = readImage(SPRITE_DIRECTORY_FULL .. directory .. "/SDK/" .. idImg)
            sprite(_img, spr.width/2, spr.height/2, _img.width*0.9, _img.height*0.9)
            
            local _img = Screen_MainMenu.sprites.shadow
            sprite(_img, spr.width/2, 30, _img.width, _img.height)
            sprite(_img, spr.width/2, 30, _img.width, _img.height)
            
            fill(255, 255, 255)
            fontSize(18)
            
            local _txt = self.listOfFighters[i]["name"]
            text(_txt, spr.width/2 - textSize(_txt)/2, 15)
        setContext()
        
    end
    ----------------------------------------------------------------------
    
    ------------------------------- Previous -----------------------------
    ToolScreen.makePrevious(self)
    ----------------------------------------------------------------------
    
    ------------------------------- Next -----------------------------
    ToolScreen.makeNext(self)
    ----------------------------------------------------------------------
    
    --self.backgroundColor = color(39, 39, 39)
end

function Screen_MainMenu:start()
    -- --[[
    -- tween(1, self, {lookAtX = WIDTH/2 - 50}, tween.easing.quartInOut, function()
    --     tween(1, self, {lookAtX = WIDTH/2 + 50}, tween.easing.quartInOut, function()
    --         tween(1, self, {lookAtX = WIDTH/2}, tween.easing.quartInOut)
    --     end)
    -- end)
    -- ]]--
    -- --[[
    -- if self.currentIndex*12 < self.nbFighters then
    --     tween(1, self.next.pos, {z = 15}, tween.easing.quartInOut)
    -- end
    -- ]]--
end

function Screen_MainMenu:previousFighters()
    if self.currentIndex == 1 then return end
    
    self.currentIndex = self.currentIndex - 1
    self.next.pos.z = 15
    
    -- add new fighter to draw
    
    if self.currentIndex == 1 then
        self.previous.pos.z = -5
    end
    
    for i, fighter in ipairs(self.fighters) do
        local x = fighter.pos.x
        tween(3, fighter.pos, {x = x + WIDTH}, tween.easing.quadInOut, function()
            -- remove old fighters draw
        end)
    end
end

function Screen_MainMenu:nextFighters()
    if self.currentIndex*12 >= self.nbFighters then return end
    
    self.currentIndex = self.currentIndex + 1
    self.previous.pos.z = 15
    
    -- add new fighter to draw
    
    if self.currentIndex*12 >= self.nbFighters then
        self.next.pos.z = -5
    end
    
    for i, fighter in ipairs(self.fighters) do
        local x = fighter.pos.x
        tween(3, fighter.pos, {x = x - WIDTH}, tween.easing.quadInOut, function()
            -- remove old fighters draw
        end)
    end
    
end

function Screen_MainMenu:toggleInfos()
    alert('toggleInfos')
end

function Screen_MainMenu:makeFighter()
    alert("Make Fighter")
end

function Screen_MainMenu:modifyFighter(id)
    manager:setCurrentState(Transition_Translate(self, Screen_Fighter(self.listOfFighters[id])))
end