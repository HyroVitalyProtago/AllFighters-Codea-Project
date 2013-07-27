MadeWithCodea = class(Screen)

function MadeWithCodea:init(screenTo)
    Screen.init(self, "MadeWithCodea")
    self.screenTo = screenTo
    Mesh.makeMesh(readImage("Documents:madeWithCodea")):insertIn({self.meshes})
end

function MadeWithCodea:start()
    tween.delay(3, function()
        manager:setCurrentState(Transition_Translate(self, self.screenTo))
    end)
end

function MadeWithCodea:__index(k)
	Screen.__index(self, k)
end
function MadeWithCodea:__newindex(k, v)
	Screen.__newindex(self, k, v)
end