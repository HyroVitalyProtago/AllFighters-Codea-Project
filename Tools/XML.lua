XML = class()

-- @Author : Hyro Vitaly Protago
-- @Version : 1.0.1

-- This class is very simple to use :

--     - If you have an object, and you want to export as xml :
--         tostring(XML(obj, nameOfObj))
        
--     - If you have an xml, and you want to remake table :
--         XML(obj).racine or XML(obj).racine[nameOfObj]

--     This doesn't support empty element like "<br />".
--     This doesn't support namespace.
--     This doesn't support attribute. (because is totally useless in this case)

--     Errors message are not really precise, but sometimes, it can help

XML.templates = {}
XML.templates.header = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>"
XML.patterns = {}
XML.patterns.header = "<\?xml[^\?]*\?>"

function XML:init(obj, name)
    if obj ~= nil and type(obj) == "table" then -- mode to xml
        self.xml = self:toXml(obj, 0, name)
    elseif obj ~= nil and type(obj) == "string" then -- mode to tab
        self:tableConstruct(obj)
    else
        error("IllegalArgumentException: @Param (1) obj must be a table or a string")
    end
end

function XML:toXml(tab, level, name)
    level = level or 0
    local str = ""
    if name then
        str = "<" .. name .. ">\n"
        level = level + 1
    end
    for k,v in pairs(tab) do
        for i = 1, level do
            str = str .. "\t"
        end
        if type(v) == "table" then
            str = str .. "<" .. k .. ">\n"
            str = str .. self:toXml(v, level + 1)
            for i = 1, level do
                str = str .. "\t"
            end
            str = str .. "</" .. k .. ">\n"
        else
            str = str .. "<" .. k .. ">" .. tostring(v) .. "</" .. k .. ">\n"
        end
    end
    if name then
        str = str .. "</" .. name .. ">\n"
    end
    return str
end

function XML:tableConstruct(xml)
    local _i, _j = string.find(xml, XML.patterns.header)
    if _i and _j then
        -- header manipulations (namespace)
        xml = string.sub(xml, _j+1)
        xml = xml:gsub(">[\s\b\t\r\n]*<", "><")
        xml = xml:gsub("^%s*(.-)%s*$", "%1")
    end
    
    self.racine = {}
    self.stack = {{name="racine", table=self.racine}}
    
    while string.len(xml) > 0 do
        local i, j = string.find(xml, "^<[^/<>]*>[^<>]*</[^<>]*>")
        if i ~= nil and i == 1 then
            xml = self:simpleNode(xml)
        else
            i, j = string.find(xml, "^</[^<>]*>")
            if i ~= nil and i == 1 then
                xml = self:endOfComplexNode(xml)
            else
                xml = self:complexNode(xml)
            end
        end
    end
    
    assert(#self.stack == 1, "Xml malformed !")
    
end

function XML:simpleNode(xml)
    local b,e,b2,e2,name,name2,value
    b, e = string.find(xml, "<[^<>]*>")
    name = string.sub(xml, b + 1, e - 1)
    assert(string.len(name) > 0, "Xml malformed ! you cannot use tag with no name...")
    b2, e2 = string.find(xml, "</[^<>]*>")
    name2 = string.sub(xml, b2 + 2, e2 - 1)
    assert(name == name2, "Xml malformed ! Opening and Closing Tag incorrect: ("..name..") ~= ("..name2..")...")
    value = string.sub(xml, e + 1, b2 - 1)
    self.stack[#self.stack].table[name] = value
    return string.sub(xml, e2 + 1)
end

function XML:complexNode(xml)
    local b,e,name
    b, e = string.find(xml, "<[^<>]*>")
    name = string.sub(xml, b + 1, e - 1)
    self.stack[#self.stack].table[name] = {}
    table.insert(self.stack, {name=name, table=self.stack[#self.stack].table[name]})
    return string.sub(xml, e + 1)
end

function XML:endOfComplexNode(xml)
    local b,e,name,name2
    b, e = string.find(xml, "</[^<>]*>")
    name = self.stack[#self.stack].name
    name2 = string.sub(xml, b + 2, e - 1)
    assert(name == name2, "Xml malformed ! Opening and Closing Tag incorrect: ("..name..") ~= ("..name2..")...")
    table.remove(self.stack, #self.stack)
    return string.sub(xml, e + 1)
end

function XML:__tostring()
    local toXmlString
    toXmlString = function(tab, level)
        level = level or 0
        local str = ""
        for k,v in pairs(tab) do
            for i = 1, level do
                str = str .. "\t"
            end
            if type(v) == "table" then
                str = str .. k .. ":\n" .. toXmlString(v, level + 1)
            else
                str = str .. k .. ": " .. tostring(v) .. "\n"
            end
        end
        return str
    end
    if self.racine then
        return toXmlString(self.racine)
    elseif self.xml then
        return XML.templates.header .. "\n" .. self.xml
    end
end

function toboolean(var)
    assert(var == "false" or var == "true", "Impossible to convert (" .. var .. ") in boolean !")
    if var == "false" then return false else return true end
end