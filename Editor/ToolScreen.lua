ToolScreen = class()

ToolScreen.sprites = {
    background = readImage(SPRITE_DIRECTORY_FULL .. "Background"),
    info = readImage(SDK_DIRECTORY .. "info"),
    previous0 = readImage(SDK_DIRECTORY .. "previous0"),
    previous = readImage(SDK_DIRECTORY .. "previous"),
    next = readImage(SDK_DIRECTORY .. "next"),
}

function ToolScreen.makeCustomBackground(screen)
    local spr = image(WIDTH, HEIGHT)
    setContext(spr)
        local spr2 = ToolScreen.sprites.background
        sprite(spr2, WIDTH/2 + 15, spr2.height/2)
    setContext()
    screen.customBackground2 = Mesh.makeMesh(spr, {z = 5}):insertIn({screen.meshes})
end

function ToolScreen.makeMenuTop(screen)
    local spr = image(WIDTH, 50)
    setContext(spr)
        local gray = 22
        fill(gray, gray, gray)
        strokeWidth(2)
        stroke(0, 0, 0)
        rect(0, 0, spr.width, spr.height)
    setContext()
    
    screen.menuTop = Mesh.makeMesh(spr, {
        x = WIDTH/2,
        y = HEIGHT-spr.height/2-5,
        z = 15
    }):insertIn({screen.meshes})
end

function ToolScreen.makeCurrentLocation(screen, txt)
    screen.currentLocation = Mesh.makeTextMesh(txt,{
        fill=color(255,255,255,255), 
        fontSize=25,
        textWrapWidth=WIDTH/1.1, 
        textAlign=CENTER,
        font="Helvetica-Light"
    })
    screen.currentLocation.pos.x = WIDTH/2
    screen.currentLocation.pos.y = HEIGHT - screen.currentLocation.dim.h - 5
    screen.currentLocation.pos.z = 20
    table.insert(screen.meshes, screen.currentLocation)
end

function ToolScreen.makeInfos(screen)
    local spr = ToolScreen.sprites.info
    local _x = 0.7
    screen.infos = Mesh.makeMesh(spr,{
        width=spr.width*_x,
        height=spr.height*_x
    })
    screen.infos.pos.x = WIDTH - screen.infos.dim.w - 5
    screen.infos.pos.y = HEIGHT - screen.infos.dim.h + 2
    screen.infos.pos.z = 20
    screen.infos.touched = function(self,touch)
        if self:isTouched(touch) and touch.state == BEGAN then
            alert("toggleInfo")
        end
    end
    table.insert(screen.meshes, screen.infos)
end

function ToolScreen.makePreviousMenuTop(screen, txt)
    local spr2 = ToolScreen.sprites.previous0
    local spr = image(spr2.width*0.9, spr2.height*0.9)
    setContext(spr)
        sprite(spr2, spr2.width/2, spr.height/2, spr.width, spr.height)
        fontSize(20)
        local w, h = textSize(txt)
        text(txt, 15, spr.height/2 - h/2)
    setContext()
    
    screen.previousMenuTop = Mesh.makeMesh(spr, {})
    screen.previousMenuTop.pos.x = spr.width/2 + 10
    screen.previousMenuTop.pos.y = HEIGHT - spr.height + 4
    screen.previousMenuTop.pos.z = 20
    table.insert(screen.meshes, screen.previousMenuTop)
end

function ToolScreen.makePrevious(screen)
    local spr = image(50, HEIGHT-50)
    setContext(spr)
        local gray = 39
        fill(gray, gray, gray, 50)
        noStroke()
        rect(0, 0, spr.width, spr.height)
        local spr2 = ToolScreen.sprites.previous
        sprite(spr2, spr2.width/4 - 3, spr.height/2, spr2.width*0.4, spr2.height*0.4)
    setContext()
    
    screen.previous = Mesh.makeMesh(spr, {})
    screen.previous.pos.x = spr.width/2
    screen.previous.pos.y = HEIGHT/2 - 25
    screen.previous.pos.z = -5
    table.insert(screen.meshes, screen.previous)
end

function ToolScreen.makeNext(screen)
    local spr = image(50, HEIGHT-50)
    setContext(spr)
        local gray = 39
        fill(gray, gray, gray, 50)
        noStroke()
        rect(0, 0, spr.width, spr.height)
        local spr2 = ToolScreen.sprites.next
        sprite(spr2, spr2.width/4 - 10, spr.height/2, spr2.width*0.4, spr2.height*0.4)
    setContext()
    
    screen.next = Mesh.makeMesh(spr, {})
    screen.next.pos.x = WIDTH - spr.width/2
    screen.next.pos.y = HEIGHT/2 - 25
    screen.next.pos.z = -5
    table.insert(screen.meshes, screen.next)
end

function ToolScreen.makeListElem(txt, focus)
    local spr = image(WIDTH/2 - 100, 50)
    setContext(spr)
        pushStyle()
        if not focus then
            local gray = 100
            fill(gray, gray, gray)
        else
            fill(0, 41, 255, 255)
        end
        strokeWidth(2)
        stroke(0, 0, 0)
        rect(0, 0, spr.width, spr.height)
        fill(255, 255, 255)
        font("HelveticaNeue-Light")
        fontSize(20)
        local w, h = textSize(txt)
        text(txt, 10, h/2)
        popStyle()
    setContext()
    return spr
end