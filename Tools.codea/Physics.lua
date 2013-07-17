-- @Author : Hyro Vitaly Protago
-- @Version : 0.0.0 ALPHA

-- New function for physics :
--     - make(img, name) : return physics body of an image

-- @Advise
--     make all different physics body during loading because first construction can be long

-- Image Processing
function image_rotate(imSrc)
    local imDest = image(imSrc.height, imSrc.width)
    for w = 1,imSrc.width do
        for h = 1,imSrc.height do
            imDest:set(h,w,imSrc:get(w,h))
        end
    end
    return imDest
end

function image_getColor(img, w, h)
    if w <= 0 or w > img.width or h <= 0 or h > img.height then return nil end
    local r,g,b,a = img:get(w,h)
    return color(r,g,b,a)
end

function image_histogramme(img)
    local array = {}
    for i = 1,256 do
        array[i] = 0
    end
    
    for w = 1,img.width do
        for h = 1,img.height do
            local r,g,b,a = img:get(w,h)
            r = r + 1
            array[r] = array[r] + 1
        end
    end
    return array
end

function image_moyenne(img)
    local histo = image_histogramme(img)
    local moyenne = 0

    for i = 1,#histo do
        moyenne = moyenne + i*histo[i]
    end
    moyenne = moyenne / (img.height*img.width)

    return moyenne
end

function image_binaries(img)
    local bin = image(img.width, img.height)
    
    for w = 1,img.width do
        for h = 1,img.height do
            local r,g,b,a = img:get(w,h)
            
            if r > 0 then -- moyenne
                bin:set(w,h,color(255, 255, 255, 255))
            end
        end
    end
    return bin
end

function image_getES4()
    local points = {}
    table.insert(points, vec2(1,0))
    table.insert(points, vec2(0,1))
    table.insert(points, vec2(0,0))
    table.insert(points, vec2(-1,0))
    table.insert(points, vec2(0,-1))
    return points
end

function image_getES8()
    local points = image_getES4()
    table.insert(points, vec2(1,1))
    table.insert(points, vec2(-1,1))
    table.insert(points, vec2(-1,-1))
    table.insert(points, vec2(1,-1))
    return points
end

function image_dilatation(img, es)
    local im = image(img.width, img.height)
    for w = 1,img.width do
        for h = 1,img.height do
            --im:set(w,h,color(0, 0, 0, 255))
            for k,p in ipairs(es) do
                local x = w + p.x
                local y = h + p.y
                if image_getColor(img, x, y) == color(255, 255, 255, 255) then
                    im:set(w,h,color(255, 255, 255, 255))
                    break
                end
            end
        end
    end
    return im
end
function image_erosion(img, es)
    local im = image(img.width, img.height)
    for w = 1,img.width do
        for h = 1,img.height do
            --im:set(w,h,color(0, 0, 0, 255))
            local ok = true
            for k,p in ipairs(es) do
                local x = w + p.x
                local y = h + p.y
                if image_getColor(img, x, y) ~= color(255, 255, 255, 255) then
                    ok = false
                    break
                end
            end
            if ok then
                im:set(w,h,color(255, 255, 255, 255))
            end
        end
    end
    return im
end

function image_negate(img1, img2)
    
    assert(img1.width == img2.width, "Impossible de soustraire deux images avec une largeur différente")
    assert(img1.height == img2.height, "Impossible de soustraire deux images avec une hauteur différente")
    
    local im = img1:copy()
    for w = 1,img1.width do
        for h = 1,img1.height do
            if image_getColor(img2, w, h) == color(255, 255, 255, 255) then
                im:set(w,h,color(0,0,0,255))
            end
        end
    end
    return im
end

function image_getContour(imSource)
    local im = image_binaries(imSource)
    local es8 = image_getES8()
    local imD = image_dilatation(im, es8)
    local imE = image_erosion(im, es8)
    local im2 = image_negate(imD,imE)
    return im,imD,imE,im2
end

function image_getList(img)
    local array = {}
    for w = 1,img.width do
        for h = 1,img.height do
            if image_getColor(img, w, h) == color(255, 255, 255, 255) then
                table.insert(array, vec2(w,h))
            end
        end
    end
    return array
end

-- Physics

function inSegment(pdebut,pfin,p)
    local v1 = p - pdebut
    local v2 = pfin - pdebut
    local kx = ( v1.x ) / ( v2.x )
    local ky = ( v1.y ) / ( v2.y )
    return kx == ky and kx > 0 and kx <= 1
end

function sort(points)
    local sortedPoints = {}
    local angles = {}
    table.insert(sortedPoints, points[1])
    table.remove(points, 1)
    
    local ok = true
    while (ok) do
        ok = false
        for i,p in ipairs(points) do
            if p:dist(sortedPoints[#sortedPoints]) == 1 then
                
                table.insert(sortedPoints, p)
                table.remove(points, i)
                ok = true
                break
            end
        end
    end
    
    local segments = {}
    table.insert(segments, {sortedPoints[1], sortedPoints[2]})
    
    for i = 3,#sortedPoints do
        lastSeg = segments[#segments]
        if inSegment(lastSeg[1], lastSeg[2], sortedPoints[i]) then
            segments[#segments][2] = sortedPoints[i]
        else
            table.insert(segments, {sortedPoints[i], sortedPoints[i+1]})
        end

    end
    
    for i = 1,#segments do
        table.insert(angles,segments[i][1])
    end
    
    return angles
end

function image_getAnglesOfContour(src)
    local im,imD,imE,im2 = image_getContour(src)
    local points = image_getList(im2)
    local angles = sort(points)
    
    for i = 1,#angles do
        angles[i].x = angles[i].x - (im2.width/2)
        angles[i].y = angles[i].y - (im2.height/2)
    end
    
    return angles
end

function distance(p, segment)
    local v1 = segment[2] - segment[1]
    local v2 = p - segment[1]
    local v3 = segment[1] - segment[2]
    local v4 = p - segment[2]
    
    local dp1 = math.abs( v1:angleBetween(v2) )
    local dp2 = math.abs( v3:angleBetween(v4) )
    
    if dp1 >= 0 and dp1 <= math.pi/2 and dp2 >= 0 and dp2 <= math.pi/2 then
        return math.sin( dp1 ) * v2:len()
    else
        if inSegment(segment[1], segment[2], p) then
            return 0
        elseif segment[1]:dist(p) < segment[2]:dist(p) then
            return v2:len()
        else
            return v4:len()
        end
    end
    
end

function _douglasPeucker(points, epsilon)
    -- Trouve le point le plus éloigné du segment
    local dmax = 0
    local index = 1
    local fin = #points
    for i = 2, fin-1 do
        d = distance(points[i], {points[1], points[fin]})
        if d  > dmax then
            index = i
            dmax = d
        end
    end
    
    -- si la distance dmax est supérieure au seuil, on simplifie
    if dmax >= epsilon then
        -- Appels récursifs de la fonction
        results1 = _douglasPeucker(table.copy(points,1,index), epsilon)
        results2 = _douglasPeucker(table.copy(points,index,fin), epsilon)
        
        -- construit la liste des résultats
        results = table.add(results1, results2)
    else
        results = {points[1], points[fin]}
    end
    
    return results
end

function DouglasPeucker(p, epsilon)
    local p = _douglasPeucker(p, epsilon)
    
    local i = 2
    while i<=#p do
        if p[i].x == p[i-1].x and p[i].y == p[i-1].y then
            table.remove(p, i)
        else
            i = i + 1
        end
    end
    
    return p
end

function RadiusSimplify(points, rad)
    local newPoints = {}
    local q = points[1]
    local maxdist = rad * rad
    local len = #points
    for i = 2,len do
        p = points[i]
        if((p.x-q.x)*(p.x-q.x)+(p.y-q.y)*(p.y-q.y)>=maxdist) then
            table.insert(newPoints, p)
            q = p
        end
    end
    return newPoints
end

-- 
__physics = {}
function physics.make(img, name)
    if name ~= nil and __physics[name] ~= nil then return physics.body(POLYGON, unpack(__physics[name])) end
    local angles = image_getAnglesOfContour(img)
    table.print(angles)
    angles = RadiusSimplify(angles, 8) -- 8
    table.print(angles)
    angles = DouglasPeucker(angles, 4) -- ~3|4
    table.print(angles)
    if name ~= nil then __physics[name] = angles end
    return physics.body(POLYGON, unpack(angles))
end

