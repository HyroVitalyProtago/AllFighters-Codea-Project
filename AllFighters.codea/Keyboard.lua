Keyboard = class()

Keyboard.key = {VK_UP=122, VK_LEFT=113, VK_DOWN=115, VK_RIGHT=100}

function Keyboard:init()
    self.map = {}
    --readImage("Cargo Bot:Command Grab")
    self.map["VK_LEFT"] =  FImage(10, 25, "Cargo Bot:Command Left")
    self.map["VK_RIGHT"] =  FImage(115, 25, "Cargo Bot:Command Right")
    self.map["VK_DOWN"] =  FImage(62.5, 25, "Cargo Bot:Command Grab")
    self.map["VK_UP"] =  FImage(62.5, 85, "Documents:Command Up")
    --self.map["test"] =  FImage(62.5, 85, "Dropbox:BaseGameEngine/dPadW200x200")
end

function Keyboard:draw()
    --fill(69, 104, 144, 207)
    --rect(0,0,WIDTH,150)
    for k,v in pairs(self.map) do
        v:draw()
    end
    noFill()    
end

function Keyboard:touched(touch)
    for k,v in pairs(self.map) do
        if v:contains(touch) then
            --print("contains")
            return {state=touch.state, key=Keyboard.key[k]}
        end
    end
    return nil
end
