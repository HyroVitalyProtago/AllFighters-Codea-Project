MakeTakeshiYamamoto = class()

MakeTakeshiYamamoto.isLoaded = false

function MakeTakeshiYamamoto.run()
    
    -- if readProjectData("TakeshiYamamoto") then
    --     displayMode(STANDARD)
    -- print(readProjectData("TakeshiYamamoto"))
    --     takeshiYamamoto = Fighter("TakeshiYamamoto")
    --    for k, v in pairs(table.load("TakeshiYamamoto")) do
    --        takeshiYamamoto[k] = v
    --       end
    --    takeshiYamamoto.comportement = ComportementTakeshiYamamoto(takeshiYamamoto)
    --     player = Player(takeshiYamamoto, FighterController(takeshiYamamoto))
    --     game:setPlayer(player, 50, 200)
    --    MakeTakeshiYamamoto.isLoaded = true
    --    return
    -- end
    
    --takeshiYamamoto = Fighter("TakeshiYamamoto")
    --MakeTakeshiYamamoto.makeStance1()
    
    local location = os.getenv("HOME").."/Documents/Dropbox.spritepack/SpriteAllFighters/TakeshiYamamoto/fighter.xml"
    local txt = file_get_contents(location)
    --print(txt)
    --local xml = XML(txt)
    --print(Test(txt))
    --print(xml)
    takeshiYamamoto = Fighter.fromXml(XML(txt).racine["Fighter"])
    ComportementTakeshiYamamoto(takeshiYamamoto)
    player = Player(takeshiYamamoto, FighterController(takeshiYamamoto))
    game:setPlayer(player, 50, 200)
    MakeTakeshiYamamoto.isLoaded = true
end

function MakeTakeshiYamamoto.init(pstate, psprName, pibegin, piend, pmap, prx, pry, pnext)
    spr = {}
    state = pstate
    sprName = psprName
    i = pibegin
    iend = piend
    map = pmap
    rx = prx
    ry = pry
    next = pnext
    --http.request(GITHUB..ALL_FIGHTERS..SPRITES..TAKESHI_YAMAMOTO..state.."/"..i..".png",loadImage)
    
    --table.insert(spr, FImage(0,0,readImage(SPRITES_LOCATION .. TAKESHI_YAMAMOTO .. state.."/"..i..".png")))
    repeat
        --print(SPRITES_LOCATION .. TAKESHI_YAMAMOTO .. state.."/"..i)
        --sprite(SPRITES_LOCATION .. TAKESHI_YAMAMOTO .. state.."/"..i, WIDTH/2, HEIGHT/2)
        table.insert(spr, FImage(0,0,SPRITES_LOCATION .. TAKESHI_YAMAMOTO .. state.."/"..i))
        i = i + 1
    until i > iend
    
    for i,v in ipairs(spr) do
        v.x = map[i].x
        v.y = map[i].y
    end
    sprR = FSprite(sprName, 0,0,0,0, spr, 10)
    sprR.x = rx
    sprL = sprR:reverse()
    sprL.x = ry
    
    local sprites = {sprR, sprL}
    takeshiYamamoto:addSprites(Fighter.state[sprName], sprites)
        
    if next ~= nil then
        next()
    else
        MakeTakeshiYamamoto.makeFighter()
    end
    
end

function MakeTakeshiYamamoto.makeStance1()
    local map = {vec2(1,0), vec2(0,0), vec2(0,0), vec2(2,0), vec2(0,0), vec2(0,0)}
    MakeTakeshiYamamoto.init("Stance", "stance1", 1, 6, map, -38, -16, MakeTakeshiYamamoto.makeStance2)
end

function MakeTakeshiYamamoto.makeStance2()
    local map = {vec2(0,0), vec2(5,0), vec2(8,0), vec2(5,0), vec2(0,0), vec2(1,0)}
    MakeTakeshiYamamoto.init("Stance", "stance2", 7, 12, map, -39, -15, MakeTakeshiYamamoto.makeWalk)
end

function MakeTakeshiYamamoto.makeWalk()
    local map = {vec2(0,0),vec2(5,0),vec2(2,0),vec2(7,0),vec2(15,0),vec2(10,0)}
    MakeTakeshiYamamoto.init("Walk", "walk", 1, 6, map, -38, -16, MakeTakeshiYamamoto.makeRun)
end

function MakeTakeshiYamamoto.makeRun()
    local map = {vec2(0,0), vec2(5,0), vec2(8,0), vec2(5,0), vec2(0,0), vec2(1,0)} -- TODO
    MakeTakeshiYamamoto.init("Run", "run", 1, 6, map, -38, -25, MakeTakeshiYamamoto.makeJumpUp)
end

function MakeTakeshiYamamoto.makeJumpUp()
    local map = {vec2(0,0), vec2(0,0)}
    MakeTakeshiYamamoto.init("Jump", "jump_up", 1, 2, map, -53, -10, MakeTakeshiYamamoto.makeJumpDown)
end

function MakeTakeshiYamamoto.makeJumpDown()
    local map = {vec2(0,0), vec2(0,0)}
    MakeTakeshiYamamoto.init("Jump", "jump_down", 3, 4, map, -20, -17, MakeTakeshiYamamoto.makeGetUp)
end

function MakeTakeshiYamamoto.makeGetUp()
    local map = {vec2(0,0), vec2(0,0)}
    MakeTakeshiYamamoto.init("Jump", "getup", 5, 6, map, -25, -25, nil) -- speed - 2
end

function loadImage(data, status, headers)
    table.insert(spr, FImage(0,0,data))
    local f = loadImage
    if i == iend - 1 then
        f = makeSprite
    end
    i = i + 1
    http.request(GITHUB..ALL_FIGHTERS..SPRITES..TAKESHI_YAMAMOTO..state.."/"..i..".png",f)
end

function makeSprite(data, status, headers)
    table.insert(spr, FImage(0,0,data))
    for i,v in ipairs(spr) do
        v.x = map[i].x
        v.y = map[i].y
    end
    sprR = FSprite(sprName, 0,0,0,0, spr, 10)
    sprR.x = rx
    sprL = sprR:reverse()
    sprL.x = ry
    
    local sprites = {sprR, sprL}
    takeshiYamamoto:addSprites(Fighter.state[sprName], sprites)
    
    if next ~= nil then
        next()
    else
        MakeTakeshiYamamoto.makeFighter()
    end
end

function MakeTakeshiYamamoto.makeFighter()
    --takeshiYamamoto.x = 150
    --takeshiYamamoto.y = 75
    takeshiYamamoto.width = 25
    takeshiYamamoto.height = 90
    
    --takeshiYamamoto.dir = Direction.LEFT
    --takeshiYamamoto.state = Fighter.state.stance2
    
    local location = os.getenv("HOME").."/Documents/Dropbox.spritepack/SpriteAllFighters/TakeshiYamamoto/fighter.xml"
    file_save(location, takeshiYamamoto:toXml())
    
    ComportementTakeshiYamamoto(takeshiYamamoto)
    
    --obj = takeshiYamamoto
    player = Player(takeshiYamamoto, FighterController(takeshiYamamoto))
    game:setPlayer(player, 50, 200)
    
    --print(tostring(XML(takeshiYamamoto, "TakeshiYamamoto")))
    -- table.save(takeshiYamamoto, "TakeshiYamamoto")
    
    MakeTakeshiYamamoto.isLoaded = true
end