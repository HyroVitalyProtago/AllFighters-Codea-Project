-- Sugars
-- @Author : Hyro Vitaly Protago
-- @Version : 0.0.0

-- TO-TEST

function sugars(CLASS)
	CLASS.__index(self, k) = function()
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
	CLASS.__newindex(self, k, v) = function()
	    for sugarKey, key in pairs(CLASS.sugars) do
	        if k == sugarKey then
	            local arr = table.explode(".", key)
	            if #arr == 1 then
	                rawset(self, key, v)
	            else
	                local result = self
	                local beforeLastResult
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
end