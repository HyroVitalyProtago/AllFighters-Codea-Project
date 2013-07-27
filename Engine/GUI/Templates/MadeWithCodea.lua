MadeWithCodea = class(Screen)
MadeWithCodea.sugars = Screen.sugars

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

CLASS = MadeWithCodea
function CLASS:__index(k)
    if CLASS[k] then return CLASS[k] end
    for sugarKey, key in pairs(CLASS.sugars) do
        if k == sugarKey then
            local arr = table.explode(".", key)
            if #arr == 1 then
                return self[key]
            else
                local result = self
                for _,v in pairs(arr) do
                    result = result[v]
                end
                return result
            end
        end
    end
end
function CLASS:__newindex(k, v)
    for sugarKey, key in pairs(CLASS.sugars) do
        if k == sugarKey then
            local arr = table.explode(".", key)
            if #arr == 1 then
                rawset(self, key, v)
            else
                local result = self
                for _,v in pairs(arr) do
                    beforeLastResult = result
                    result = result[v]
                end
                rawset(beforeLastResult, arr[#arr], v)
            end
        end
    end
    rawset(self, k, v)
end