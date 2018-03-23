--[[
	Desc: Node class
	Author: Night_Walker 
	Since: 2018-03-12 15:25:08 
	Last Modified time: 2018-03-12 15:25:08 
	Docs: 
        * Its core part is a point at centre
        * Its real shape is a rectangle    
]]

local _Node = require("Src.Core.Class")()

function _Node:Ctor(x, y, size, iX, iY)
    self.x = x
    self.y = y
    self.size = size
    self.pass = true
    self.iX = iX or 0 -- x in nav graph matrix
    self.iY = iY or 0 -- y in nav graph matrix
    self.index = 0 -- One-dimensional mark in nav graph
    self.drawType = "line"
    -- calc vertex
    self:Update()

    self.color = {
        r = 0,
        g = 0,
        b = 150,
        a = 255,
    }

end 

function _Node:Update()
    self.vertex = {
        [1] = { -- left up
            x = self.x - self.size / 2,
            y = self.y - self.size / 2,
        },
        [2] = { -- right down
            x = self.x + self.size / 2,
            y = self.y + self.size / 2,
        },
    }
end 

function _Node:Draw(x,y)
    
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    
    love.graphics.rectangle(self.drawType, self.vertex[1].x, self.vertex[1].y, self.size, self.size)

    love.graphics.setColor(r, g, b, a)

    
    if self.pathIndex then
        love.graphics.print(tostring(self.pathIndex), self.x - 12 , self.y - 10)
    else
        -- love.graphics.print(tostring(self.iX) .. "," .. tostring(self.iY), self.x - 15 , self.y - 10)
    end
end

function _Node:SetIndex(index)
    self.index = index
end

function _Node:GetIndex()
    return {x = self.iX, y = self.iY}
end

function _Node:SetPathIndex(pathIndex)
    self.pathIndex = pathIndex
end

function _Node:GetVertex()
    return self.vertex
end

function _Node:SetPass(pass)
    self.pass = pass
end

function _Node:GetPass()
    if self.pass == false then
        self:SetColor(150, 0, 0, 255)
    end
    return self.pass
end

function _Node:GetPos()
    return {x = self.x, y = self.y}
end

function _Node:GetSize()
    return self.size
end

function _Node:IsInNode(x, y)
    if x <= self.x + self.size / 2 and x >= self.x - self.size / 2 then
        if y <= self.y + self.size / 2 and y >= self.y - self.size / 2 then
            return true
        end
    end
    return false
end

function _Node:SetColor(r, g, b, a)
    self.color = {
        r = r,
        g = g,
        b = b,
        a = a,
    }
end

function _Node:SetDrawType(drawType)
    self.drawType = drawType
end

return _Node 