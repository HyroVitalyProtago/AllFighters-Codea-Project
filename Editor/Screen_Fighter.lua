Screen_Fighter = class(Screen)

Screen_Fighter.sprites = {
    edit = readImage(SDK_DIRECTORY .. "edit"),
    close = readImage(SDK_DIRECTORY .. "close"),
    up = readImage(SDK_DIRECTORY .. "up"),
    down = readImage(SDK_DIRECTORY .. "down"),
    e_prevAll = readImage(SDK_DIRECTORY .. "e_prevAll"),
    e_prev = readImage(SDK_DIRECTORY .. "e_prev"),
    e_play = readImage(SDK_DIRECTORY .. "e_play"),
    e_pause = readImage(SDK_DIRECTORY .. "e_pause"),
    e_next = readImage(SDK_DIRECTORY .. "e_next"),
    e_nextAll = readImage(SDK_DIRECTORY .. "e_nextAll"),
    undo = readImage(SDK_DIRECTORY .. "undo"),
    redo = readImage(SDK_DIRECTORY .. "redo")
}

function Screen_Fighter:init(fighter)
    Screen.init(self, "Fighter")
    
    DEV_SPRITE = false
    
    self.fighter = self:loadFighter(fighter)
    local fighter = self.fighter
    -- ComportementTakeshiYamamoto(self.fighter)
    
    self.room = Room("Editor", (WIDTH/2.2)/2, (HEIGHT/2.5)/2)
    self.room.background = false
    self.room:addWall(0,0,(WIDTH/2.2)/2,5) -- Sol
    self.room:addObject(self.fighter, (WIDTH/2.2)/4, 5)
    
    ------------------------------- Background -----------------------------
    ToolScreen.makeCustomBackground(self)
    ----------------------------------------------------------------------
    
    ------------------------------- Menu top -----------------------------
    ToolScreen.makeMenuTop(self)
    ToolScreen.makeCurrentLocation(self, "Fighter - " .. fighter["name"])
    ToolScreen.makeInfos(self)
    ToolScreen.makePreviousMenuTop(self, "Fighters")
    
    local todo = function()
        local time
        if isKeyboardShowing() then
            hideKeyboard()
            time = 0.5
        else
            time = 0
        end
        
        -- tween.delay(time, function()
        --     for _,v in pairs(self.menuLeftContent) do
        --         local y = v.pos.y
        --         tween(1, v.pos, {y=y-330}, tween.easing.cubicInOut)
        --     end
        -- end)
        -- tween.delay(time + 2, function()
        --     local t = Transition_Miniature(self, Screen_MainMenu(), nil, {
        --         tween.easing.cubicInOut, tween.easing.backInOut, tween.easing.bounceOut
        --     }, Transition_Miniature.directions.left)
        --     for _,v in pairs(self.menuLeftContent) do
        --         self:removeMesh(v)
        --     end
        --     tween.resetAll()
        --     manager:setCurrentState(t)
        -- end)

        local t = Transition_Translate(self, Screen_MainMenu(), 0.5, 
            tween.easing.cubicInOut, Transition_Translate.directions.left)
        tween.delay(time, function() manager:setCurrentState(t) end)
    end
    
    self.previousMenuTop.touched = function(self, touch)
        if self:isTouched(touch) and touch.state == BEGAN then
            todo()
        end
    end
    ----------------------------------------------------------------------
    
    ------------------------------- Content -----------------------------
        -- SpriteList
        
        -- Background
        local spr = image(WIDTH/2, HEIGHT-350)
        setContext(spr)
            local gray = 15
            fill(gray, gray, gray)
            strokeWidth(2)
            stroke(0, 0, 0)
            rect(0, 0, spr.width, spr.height)
        setContext()
        self.spriteList = Mesh.makeMesh(spr, {
            x = WIDTH - WIDTH/4,
            y = HEIGHT - 255,
            z = 6
        }):insertIn({self.meshes})
        self.spriteListContent = {self.spriteList}
        
        -- Liste
        local states = table.inverse(Fighter.state)
        local i = 0
        local txt
        local listElem = {}
        for k, v in pairs(self.fighter.map) do
            local focus = (k == 1)
            txt = states[k]
            txt = txt:sub(1, 1):upper() .. txt:sub(2)
            local spr = ToolScreen.makeListElem(txt, focus)
            local m = Mesh.makeMesh(spr, {
                x = WIDTH - WIDTH/4 - 30,
                y = HEIGHT - 90 - i*55,
                z = 7
            }):insertIn({self.meshes, self.spriteListContent})
            m.sf_txt = txt
            m.sf_focus = focus
            local changeState = function()
                self.fighter:setState(k)
            end
            listElem[#listElem+1] = {m, changeState}
        
            -- Edit
            local m = Mesh.makeMesh(Screen_Fighter.sprites.edit, {
                width = 35,
                height = 35,
                x = WIDTH - 175,
                y = HEIGHT - 90 - i*55,
                z = 8
            }):insertIn({self.meshes, self.spriteListContent})
            m.touched = function(self, touch, firstElementTouch)
                if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                    alert("Edit")
                    return true
                end
            end
            
            -- Remove
            local m = Mesh.makeMesh(Screen_Fighter.sprites.close, {
                width = 37,
                height = 37,
                x = WIDTH - 120,
                y = HEIGHT - 90 - i*55,
                z = 8
            }):insertIn({self.meshes, self.spriteListContent})
            m.touched = function(self, touch, firstElementTouch)
                if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                    alert("Remove")
                    return true
                end
            end
            
            i = i + 1
        end
        
        local disable = function()
            for _,v in pairs(listElem) do
                v[1].mesh.texture = ToolScreen.makeListElem(v[1].sf_txt, false) -- focusout
            end
        end
        for _,v in pairs(listElem) do
            local changeState = v[2]
            v[1].touched = function(self, touch, firstElementTouch)
                if touch.state == ENDED then
                    if (self:isTouched(touch) and firstElementTouch) then
                        changeState()
                        disable()
                        self.mesh.texture = ToolScreen.makeListElem(self.sf_txt, true) -- focusin
                        return true
                    end
                end
            end
        end
        
        -- Scroll Bar
        local spr = image(35, 275)
        setContext(spr)
            local gray = 200
            fill(gray, gray, gray)
            strokeWidth(2)
            stroke(0, 0, 0)
            rect(0, 0, spr.width, spr.height)
        setContext()
        local m = Mesh.makeMesh(spr, {
            x = WIDTH - 25 - 15,
            y = HEIGHT - 255,
            z = 8
        }):insertIn({self.meshes, self.spriteListContent})
        
        -- UP
        local m = Mesh.makeMesh(Screen_Fighter.sprites.up, {
            x = WIDTH - 25 - 15,
            y = HEIGHT - 97,
            z = 9
        }):insertIn({self.meshes, self.spriteListContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                alert("up")
            end
        end
        
        -- DOWN
        local m = Mesh.makeMesh(Screen_Fighter.sprites.down, {
            x = WIDTH - 25 - 14,
            y = HEIGHT - 415,
            z = 9
        }):insertIn({self.meshes, self.spriteListContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                alert("down")
            end
        end
    
        -- SpriteEditor
        -- Background
        local spr = image(WIDTH/2, HEIGHT-350)
        setContext(spr)
            local gray = 50
            fill(gray, gray, gray)
            strokeWidth(2)
            stroke(0, 0, 0)
            rect(0, 0, spr.width, spr.height)
        setContext()
        self.spriteEditor = Mesh.makeMesh(spr, {
            x = WIDTH/4,
            y = HEIGHT - 255,
            z = 6
        }):insertIn({self.meshes})
        self.spriteEditorContent = {self.spriteEditorContent}
        
        -- ActionBar
        local spr = image(WIDTH/2 - 25, 65)
        setContext(spr)
            local gray = 10
            fill(gray, gray, gray)
            strokeWidth(2)
            stroke(0, 0, 0)
            rect(0, 0, spr.width, spr.height)
        setContext()
        self.actionBar = Mesh.makeMesh(spr, {
            x = WIDTH/4,
            y = HEIGHT/2 - 35,
            z = 7
        }):insertIn({self.meshes, self.spriteEditorContent})
    
        local x0 = 150
        local m = Mesh.makeMesh(Screen_Fighter.sprites.e_prevAll, {
            x = x0,
            y = HEIGHT/2 - 35,
            z = 8
        }):insertIn({self.meshes, self.spriteEditorContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                fighter:getCurrentSprite():first()
            end
        end
        local m = Mesh.makeMesh(Screen_Fighter.sprites.e_prev, {
            x = x0 + 50,
            y = HEIGHT/2 - 35,
            z = 8
        }):insertIn({self.meshes, self.spriteEditorContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                fighter:getCurrentSprite():previous()
            end
        end
        local spr
        if DEV_SPRITE then
            spr = Screen_Fighter.sprites.e_play
        else
            spr = Screen_Fighter.sprites.e_pause
        end
        local m = Mesh.makeMesh(spr, {
            x = x0 + 50*2,
            y = HEIGHT/2 - 35,
            z = 8
        }):insertIn({self.meshes, self.spriteEditorContent})
        m._play = function(self)
            DEV_SPRITE = false
            self.mesh.texture = Screen_Fighter.sprites.e_pause
        end
        m._pause = function(self)
            DEV_SPRITE = true
            self.mesh.texture = Screen_Fighter.sprites.e_play
        end
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                if DEV_SPRITE then
                    self:_play()
                else
                    self:_pause()
                end
            end
        end
        local m = Mesh.makeMesh(Screen_Fighter.sprites.e_next, {
            x = x0 + 50*3,
            y = HEIGHT/2 - 35,
            z = 8
        }):insertIn({self.meshes, self.spriteEditorContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                fighter:getCurrentSprite():next()
            end
        end
        local m = Mesh.makeMesh(Screen_Fighter.sprites.e_nextAll, {
            x = x0 + 50*4,
            y = HEIGHT/2 - 35,
            z = 8
        }):insertIn({self.meshes, self.spriteEditorContent})
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                fighter:getCurrentSprite():last()
            end
        end
        
    ----------------------------------------------------------------------
    
    ------------------------------- Menu Bottom -----------------------------
    local spr = image(WIDTH, HEIGHT-50)
    setContext(spr)
        local gray = 22
        fill(gray, gray, gray)
        strokeWidth(2)
        stroke(0, 0, 0)
        rect(0, 0, spr.width, spr.height)
    setContext()
    
    self.menuBottom = Mesh.makeMesh(spr, {
        x = spr.width/2,
        y = -50,
        z = 10
    }):insertIn({self.meshes})
    self.menuBottom.touched = function(self, touch)
        if (touch.state == ENDED and self:isTouched(touch)) then
            return true
        end
    end

        self.menuLeftContent = {self.menuBottom}
        local array = {self.meshes, self.menuLeftContent}
    
        ------------------------------- Apercu Fighter -----------------------------
        local spr = image(300, 200)
        setContext(spr)
            local ap = readImage(SPRITE_DIRECTORY_FULL .. self.fighter["directory"] .. "/SDK/6")
            fill(127, 127, 127, 255)
            local size = 75
            rect(0, 0, 300, 270)
            sprite(ap, spr.width/2, spr.height/2)
        setContext()
        self.af = Mesh.makeMesh(spr, {
            x = spr.width/2 + 8,
            y = (HEIGHT-50)/2 - spr.height/2 - 50,
            z = 13
        }):insertIn(array)
        ----------------------------------------------------------------------
        
        self:addTextInput("Speed", {value=self.fighter.speed})
        
        local n = 75
        
        _label, _field = self:addTextInput("Jump Force", {value=self.fighter.jumpForce})
        _label.pos.y = _label.pos.y - n
        _field.pos.y = _field.pos.y - n
        
        _label, _field = self:addTextInput("Life", {value=self.fighter.life})
        _label.pos.y = _label.pos.y - n*2
        _field.pos.y = _field.pos.y - n*2
        
        _label, _field = self:addTextInput("Power", {value=self.fighter.power})
        _label.pos.x = _label.pos.x + 300
        _field.pos.x = _field.pos.x + 300
        
        _label, _field = self:addTextInput("Force", {value=self.fighter.force})
        _label.pos.x = _label.pos.x + 300
        _field.pos.x = _field.pos.x + 300
        _label.pos.y = _label.pos.y - n
        _field.pos.y = _field.pos.y - n
        
        _label, _field = self:addTextInput("Resistance", {value=self.fighter.resistance})
        _label.pos.x = _label.pos.x + 300
        _field.pos.x = _field.pos.x + 300
        _label.pos.y = _label.pos.y - n*2
        _field.pos.y = _field.pos.y - n*2
        
        local m = Mesh.makeMesh(Screen_Fighter.sprites.undo, {
            x = Screen_Fighter.sprites.undo.width/2 + 8,
            y = 80,
            z = 13
        }):insertIn(array)
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                alert("Undo")
                return true
            end
        end
        
        local m = Mesh.makeMesh(Screen_Fighter.sprites.redo, {
            x = Screen_Fighter.sprites.redo.width/2 + 8,
            y = 35,
            z = 13
        }):insertIn(array)
        m.touched = function(self, touch, firstElementTouch)
            if (touch.state == ENDED and self:isTouched(touch) and firstElementTouch) then
                alert("Redo")
                return true
            end
        end
    ----------------------------------------------------------------------
    
    
end

function Screen_Fighter:start()
    -- tween(1, self.menuLeft.pos, {x=-WIDTH/5}, tween.easing.cubicInOut)
    -- tween(1, self.menuBottom.pos, {y=-50}, tween.easing.cubicInOut)
    -- for k,v in pairs(self.spriteListContent) do
    --     local x = v.pos.x
    --     tween(1, v.pos, {x=x+WIDTH/2}, tween.easing.cubicInOut)
    -- end
    -- displayMode(STANDARD)
end

function Screen_Fighter:addTextInput(labelTxt, args)
    
    local array = {self.meshes, self.menuLeftContent, self.fields}

    local label = Mesh.makeTextMesh(labelTxt, {
        fontSize = 18,
        font = "Helvetica-Light",
        y = 275,
        z = 20
    }):insertIn(array)
    label.pos.x = label.dim.w/2 + 330
    
    args.width = 280
    args.height = 35
    args.x = 280/2 + 330
    args.y = label.pos.y - 35
    args.z = 20
    args.number = true
    local field = IText(args):insertIn(array)
    field.onchange = function(self)
        
    end

    return label, field
end

function Screen_Fighter:loadFighter(fighter)
    local location = FILE_LOCATION .. SPRITE_DIRECTORY .. fighter.directory .. "/fighter.xml"
    local txt = file_get_contents(location)
    xml = XML(txt)
    local result = Fighter.fromXml(xml.racine["Fighter"])
    result.directory = fighter.directory
    
    return result
end

function Screen_Fighter:draw()
    local height = 330
    if self.isKeyboardShowing and not isKeyboardShowing() then
        if self.menuBottom.pos.y ~= 280 then return end
        for _,v in pairs(self.menuLeftContent) do
            local y = v.pos.y
            tween(0.19, v.pos, {y=y-height}, tween.easing.linear)
        end
        tween.delay(0.19, function() self.room:show() end)
    elseif not self.isKeyboardShowing and isKeyboardShowing() then
        if self.menuBottom.pos.y ~= -50 then return end
        for _,v in pairs(self.menuLeftContent) do
            local y = v.pos.y
            tween(0.19, v.pos, {y=y+height}, tween.easing.linear)
        end
        self.room:hide()
    end
    self.isKeyboardShowing = isKeyboardShowing()
    
    Screen.draw(self)
    
    -- sprite editor
    --[[
    pushMatrix()
    pushStyle()
        --translate(self.x + 20, self.y + 390)
        --scale(2)
        --self.room:draw()
    popStyle()
    popMatrix()
    ]]--
    
    pushMatrix()
        translate(self.x + 260, self.y + 390, 500)
        strokeWidth(2)
        self.room:draw()
    popMatrix()
    
end
