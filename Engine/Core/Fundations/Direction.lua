Direction = class()

Direction.UP = 1
Direction.LEFT = 2
Direction.RIGHT = 3
Direction.DOWN = 4

function Direction.getValue(dir)
    if (dir == Direction.LEFT) then
        return 2
    elseif (dir == Direction.RIGHT) then
        return 1
    end
    return -1
end

function Direction.getInverse(dir)
    if (dir == Direction.LEFT) then
        return Direction.RIGHT
    elseif (dir == Direction.RIGHT) then
        return Direction.LEFT
    elseif (dir == Direction.UP) then
        return Direction.DOWN
    else
        return Direction.UP
    end
end
