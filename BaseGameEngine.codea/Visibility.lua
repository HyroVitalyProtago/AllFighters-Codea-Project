-- Remake by Hyro Vitaly Protago

-- Calculate visible area from a position
-- Copyright 2012 Red Blob Games
-- License: Apache v2
 
--[[ 
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
 
       http://www.apache.org/licenses/LICENSE-2.0
 
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]--
 
--[[
   This code uses the Haxe compiler, including some of the basic Haxe
   libraries, which are under the two-clause BSD license: http://haxe.org/doc/license
 
   Copyright (c) 2005, the haXe Project Contributors
   All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
 
   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
 
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
 
   THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND
   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]--
 
--[[
   This code also uses a linked list datastructure class from
   Polygonal, which is Copyright (c) 2009-2010 Michael Baczynski,
   http://www.polygonal.de. It is available under the new BSD license,
   except for two algorithms, which I do not use. See
   https://github.com/polygonal/polygonal/blob/master/LICENSE
]]--
 
-- import de.polygonal.ds.DLL;
 
--typedef Block = {x:Float, y:Float, r:Float};
Block = class()
function Block:init(x, y, r)
    self.x = x
    self.y = y
    self.r = r
end
--typedef Point = {x:Float, y:Float}; ==> vec2
--typedef Segment = {p1:EndPoint, p2:EndPoint, d:Float};
Segment = class()
function Segment:init(p1, p2, d)
    self.p1 = p1
    self.p2 = p2
    self.d = d
end
--typedef EndPoint = {x:Float, y:Float, begin:Bool, segment:Segment, angle:Float, visualize:Bool};
EndPoint = class()
function EndPoint:init(x, y, begin, segment, angle, visualize)
    self.x = x
    self.y = y
    self.begin = begin
    self.segment = segment
    self.angle = angle
    self.visualize = visualize
end
 
--[[ 2d visibility algorithm, for demo
   Usage:
      new Visibility()
   Whenever map data changes:
      loadMap
   Whenever light source changes:
      setLightLocation
   To calculate the area:
      sweep
]]--
 
Visibility = class()
-- Note: DLL is a doubly linked list but an array would be ok too
 
-- These represent the map and the light location:
    -- public var segments:DLL<Segment>;
    -- public var endpoints:DLL<EndPoint>;
    -- public var center:Point;
 
-- These are currently 'open' line segments, sorted so that the nearest
-- segment is first. It's used only during the sweep algorithm, and exposed
-- as a public field here so that the demo can display it.
    -- public var open:DLL<Segment>;
 
-- The output is a series of points that forms a visible area polygon
    -- public var output:Array<Point>;
 
-- For the demo, keep track of wall intersections
    -- public var demo_intersectionsDetected:Array<Array<Point>>;
 
 
-- Construct an empty visibility set
function Visibility:init()
    self.segments = {} -- Segments
    self.endpoints = {} -- EndPoints
    self.open = {} -- Segments
    self.center = {x=0.0, y=0.0}
    self.output = {}
    self.demo_intersectionsDetected = {}
end
 
 
-- Helper function to construct segments along the outside perimeter
function Visibility:_loadEdgeOfMap(size, margin) -- int, int
    self:_addSegment(margin, margin, margin, size-margin)
    self:_addSegment(margin, size-margin, size-margin, size-margin)
    self:_addSegment(size-margin, size-margin, size-margin, margin)
    self:_addSegment(size-margin, margin, margin, margin)
    -- NOTE: if using the simpler distance function (a.d < b.d)
    -- then we need segments to be similarly sized, so the edge of
    -- the map needs to be broken up into smaller segments.
end
 
    
-- Load a set of square blocks, plus any other line segments
function Visibility:loadMap(size, margin, blocks, walls) -- int, int, {Block}, {Segment}
    self.segments = {}
    self.endpoints = {}
    self:_loadEdgeOfMap(size, margin)
    
    for _,block in pairs(blocks) do
        local x = block.x
        local y = block.y
        local r = block.r
        self:_addSegment(x-r, y-r, x-r, y+r)
        self:_addSegment(x-r, y+r, x+r, y+r)
        self:_addSegment(x+r, y+r, x+r, y-r)
        self:_addSegment(x+r, y-r, x-r, y-r)
    end
    for _,wall in pairs(walls) do
        self:_addSegment(wall.p1.x, wall.p1.y, wall.p2.x, wall.p2.y)
    end
end
 
 
-- Add a segment, where the first point shows up in the
-- visualization but the second one does not. (Every endpoint is
-- part of two segments, but we want to only show them once.)
function Visibility:_addSegment(x1, y1, x2, y2) -- floats
    local segment = nil;
    local p1 = EndPoint(0.0, 0.0, false, segment, 0.0, true)
    local p2 = EndPoint(0.0, 0.0, false, segment, 0.0, true)
    segment = Segment(p1, p2, 0.0)
    p1.x = x1
    p1.y = y1
    p2.x = x2
    p2.y = y2
    p1.segment = segment
    p2.segment = segment
    segment.p1 = p1
    segment.p2 = p2
 
    table.insert(self.segments,segment)
    table.insert(self.endpoints,p1)
    table.insert(self.endpoints,p2)
end
 
 
-- Set the light location. Segment and EndPoint data can't be
-- processed until the light location is known.
function Visibility:setLightLocation(x, y) -- floats
    self.center.x = x
    self.center.y = y
    
    for _, segment in pairs(segments) do
        local dx = 0.5 * (segment.p1.x + segment.p2.x) - x
        local dy = 0.5 * (segment.p1.y + segment.p2.y) - y
        -- NOTE: we only use this for comparison so we can use
        -- distance squared instead of distance
        segment.d = dx*dx + dy*dy
 
        -- NOTE: future optimization: we could record the quadrant
        -- and the y/x or x/y ratio, and sort by (quadrant,
        -- ratio), instead of calling atan2. See
        -- <https://github.com/mikolalysenko/compare-slope> for a
        -- library that does this.
        segment.p1.angle = math.atan2(segment.p1.y - y, segment.p1.x - x)
        segment.p2.angle = math.atan2(segment.p2.y - y, segment.p2.x - x)
 
        local dAngle = segment.p2.angle - segment.p1.angle
        if (dAngle <= -math.pi) then dAngle = dAngle + 2*math.pi end
        if (dAngle > math.pi) then dAngle = dAngle - 2*math.pi end
        segment.p1.begin = (dAngle > 0.0)
        segment.p2.begin = not segment.p1.begin
    end
end
 
 
-- Helper: comparison function for sorting points by angle
function Visibility._endpoint_compare(a, b) -- EndPoints
    -- Traverse in angle order
    if (a.angle > b.angle) then return 1 end
    if (a.angle < b.angle) then return -1 end
    -- But for ties (common), we want Begin nodes before End nodes
    if (not a.begin and b.begin) then return 1 end
    if (a.begin and not b.begin) then return -1 end
    return 0
end
 
-- Helper: leftOf(segment, point) returns true if point is
-- "left" of segment treated as a vector
function Visibility.leftOf(s, p) -- Segment, vec2
    local cross = (s.p2.x - s.p1.x) * (p.y - s.p1.y) - (s.p2.y - s.p1.y) * (p.x - s.p1.x)
    return cross < 0
end
 
-- Return p*(1-f) + q*f
function Visibility.interpolate(p, q, f) -- vec2, vec2, float
    return vec2(p.x*(1-f) + q.x*f, p.y*(1-f) + q.y*f)
end
    
-- Helper: do we know that segment a is in front of b?
-- Implementation not anti-symmetric (that is to say,
-- _segment_in_front_of(a, b) != (!_segment_in_front_of(b, a)).
-- Also note that it only has to work in a restricted set of cases
-- in the visibility algorithm; I don't think it handles all
-- cases. See http://www.redblobgames.com/articles/visibility/segment-sorting.html
function Visibility:_segment_in_front_of(a, b, relativeTo) -- Segment, vec2, vec2
    -- NOTE: we slightly shorten the segments so that
    -- intersections of the endpoints (common) don't count as
    -- intersections in this algorithm
    local A1 = Visibility.leftOf(a, Visibility.interpolate(b.p1, b.p2, 0.01));
    local A2 = Visibility.leftOf(a, Visibility.interpolate(b.p2, b.p1, 0.01));
    local A3 = Visibility.leftOf(a, relativeTo);
    local B1 = Visibility.leftOf(b, Visibility.interpolate(a.p1, a.p2, 0.01));
    local B2 = Visibility.leftOf(b, Visibility.interpolate(a.p2, a.p1, 0.01));
    local B3 = Visibility.leftOf(b, relativeTo);
 
    -- NOTE: this algorithm is probably worthy of a short article
    -- but for now, draw it on paper to see how it works. Consider
    -- the line A1-A2. If both B1 and B2 are on one side and
    -- relativeTo is on the other side, then A is in between the
    -- viewer and B. We can do the same with B1-B2: if A1 and A2
    -- are on one side, and relativeTo is on the other side, then
    -- B is in between the viewer and A.
    if (B1 == B2 and B2 ~= B3) then return true end
    if (A1 == A2 and A2 == A3) then return true end
    if (A1 == A2 and A2 ~= A3) then return false end
    if (B1 == B2 and B2 == B3) then return false end
    
    -- If A1 != A2 and B1 != B2 then we have an intersection.
    -- Expose it for the GUI to show a message. A more robust
    -- implementation would split segments at intersections so
    -- that part of the segment is in front and part is behind.
    table.insert(self.demo_intersectionsDetected, {a.p1, a.p2, b.p1, b.p2})
    --demo_intersectionsDetected.push([a.p1, a.p2, b.p1, b.p2]);
    return false
 
    -- NOTE: previous implementation was a.d < b.d. That's simpler
    -- but trouble when the segments are of dissimilar sizes. If
    -- you're on a grid and the segments are similarly sized, then
    -- using distance will be a simpler and faster implementation.
end
    
 
-- Run the algorithm, sweeping over all or part of the circle to find
-- the visible area, represented as a set of triangles
function Visibility:sweep(maxAngle) -- Float=999.0
    maxAngle = maxAngle or 999.0
 
    output = {}  -- output set of triangles
    demo_intersectionsDetected = {}
    table.sort( self.endpoints, self._endpoint_compare )
    --endpoints.sort(_endpoint_compare, true);
    
    self.open = {}
    local beginAngle = 0.0
 
    -- At the beginning of the sweep we want to know which
    -- segments are active. The simplest way to do this is to make
    -- a pass collecting the segments, and make another pass to
    -- both collect and process them. However it would be more
    -- efficient to go through all the segments, figure out which
    -- ones intersect the initial sweep line, and then sort them.
    for pass = 0, 2 do
        for _,p in pairs(endpoints) do
            if (pass == 1 and p.angle > maxAngle) then
                -- Early exit for the visualization to show the sweep process
                break
            end
            
            local current_old
            if (#self.open == 0) then
                current_old = nil
            else
                current_old = self.open[0]
            end
            --local current_old = open.isEmpty()? null : open.head.val;
            
            if (p.begin) then
                -- Insert into the right place in the list
                local node = self.open[0] -- open.head
                while (node ~= nil and self:_segment_in_front_of(p.segment, node.val, center)) do
                    node = node.next
                end
                if (node == nil) then
                    self.open:insert(p.segment)
                else
                    insertBefore(self.open, node, p.segment)
                    --open.insertBefore(node, p.segment);
                end
            else
                removeElement(self.open,p.segment)
            end
 
            local current_new            
            if (#self.open == 0) then
                current_new = nil
            else
                current_new = self.open[0]
            end
            --local current_new = open.isEmpty()? null : open.head.val;
 
            if (current_old ~= current_new) then
                if (pass == 1) then
                    self:_addTriangle(beginAngle, p.angle, current_old)
                end
                beginAngle = p.angle
            end
        end
    end
end
 
function insertBefore(table, before, element)
    table.insert(table, getIndexOf(table, before), element)
end
 
function removeElement(table, element)
    table.remove(table, getIndexOf(table, element))
end
 
function getIndexOf(table, element)
    for k,v in pairs(table) do
        if element == v then
            return k
        end
    end
    return false
end
 
function Visibility:lineIntersection(p1, p2, p3, p4) -- vec2
    -- From http://paulbourke.net/geometry/lineline2d/
    local s = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x))
        / ((p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y));
    return vec2(p1.x + s * (p2.x - p1.x), p1.y + s * (p2.y - p1.y))
end
 
        
function Visibility:_addTriangle(angle1, angle2, segment) -- float, float, Segment
    local p1 = center
    local p2 = vec2(center.x + math.cos(angle1), center.y + math.sin(angle1))
    local p3 = vec2(0.0, 0.0)
    local p4 = vec2(0.0, 0.0)
 
    if (segment ~= nil) then
        -- Stop the triangle at the intersecting segment
        p3.x = segment.p1.x
        p3.y = segment.p1.y
        p4.x = segment.p2.x
        p4.y = segment.p2.y
    else
        -- Stop the triangle at a fixed distance; this probably is
        -- not what we want, but it never gets used in the demo
        p3.x = center.x + math.cos(angle1) * 500
        p3.y = center.y + math.sin(angle1) * 500
        p4.x = center.x + math.cos(angle2) * 500
        p4.y = center.y + math.sin(angle2) * 500
    end
 
    local pBegin = self:lineIntersection(p3, p4, p1, p2)
 
    p2.x = center.x + math.cos(angle2)
    p2.y = center.y + math.sin(angle2)
    local pEnd = self:lineIntersection(p3, p4, p1, p2);
 
 
    table.insert(self.output,pBegin)
    table.insert(self.output,pEnd)
end
