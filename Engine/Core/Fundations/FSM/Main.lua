-- FSM

-- Programming Game AI by Example
-- Mat Buckland
-- Chapter 2

function setup()
end

function draw()
    background(40, 40, 50)
end

local clock = os.clock
function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do end
end