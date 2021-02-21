--[[
    Desc: A new lua class.
    Author: SerDing
    Since: 2018-04-05T02:33:49.469Z+08:00
    Alter: 2020-10-11T02:56:53.386Z+08:00
]]

local _Pathfinder = require "lib.jumper.pathfinder"
local _Grid = require "lib.jumper.grid"
local _MATH = require "engine.math"
local _Node = require "system.navigation.node"


local _Navigation = require("core.class")()

function _Navigation:Ctor(area, scene)

    self.area = {
        [1] = area[1],
        [2] = area[2] + 200, -- y offset
        [3] = area[3],
        [4] = area[4],
    }
    self.scene = scene
    self.nodeSize = 16
    self.rows = math.floor(self.area[4] / self.nodeSize) -- graph height
    self.cols = math.floor(self.area[3] / self.nodeSize) - 1 -- graph width
    
    self.navNodes = {}
    self.map = {}
    self.lastPath = {}
    self.walkable = 1
    self.graphColor = {
        r = 0,
        g = 0,
        b = 150,
        a = 200,
    }

    self.debug = false
end 

function _Navigation:Init()
    -- NEW jumper pathfinder
    self.grid = _Grid(self.map) -- grid nodes table
    self.pathFinder = _Pathfinder(self.grid, 'ASTAR', self.walkable) 
end

function _Navigation:BuildNavGraph()
    self.linearGraph = {}
    for i = self.nodeSize, self.area[4] + (self.nodeSize - self.area[4] % self.nodeSize), self.nodeSize do
        self.map[i / self.nodeSize] = {}
        self.navNodes[i / self.nodeSize] = {}
        for n = self.nodeSize, self.area[3] , self.nodeSize do

            local row = i / self.nodeSize
            local col = n / self.nodeSize
            local x = self.area[1] - (self.nodeSize / 2) + n
            local y = self.area[2] - (self.nodeSize / 2) + i
            local node = _Node.New(x, y, self.nodeSize, col, row)
            
            if self.scene:CollideWithObstacles(node) == false then
                node:SetPass(true)
                self.map[row][col] = 1
            else
                node:SetPass(false)
                self.map[row][col] = 0
            end

            self.navNodes[row][col] = node
            self.linearGraph[#self.linearGraph + 1] = node
            self.linearGraph[#self.linearGraph]:SetIndex(#self.linearGraph)
        end
    end

    -- print("build graph end")

    self:Init()
    
end 

---@param entity Entity
---@param x float
---@param y float 
function _Navigation:FindPath(entity, x, y)

    -------------NEW PATH FINDING-----------------------------------------
    
    -- Clear up last path nodes (set their color to original)
    if self.lastPath ~= {} then
        for i=1,#self.lastPath do
            self.lastPath[i]:SetColor(0, 0, 150, 255)
            self.lastPath[i]:SetDrawType("line")
        end
    end

    -- Define start and goal locations coordinates
    local entityPos = entity.transform.position
    local startIndex = self:GetNodeIndexByPos(entityPos.x, entityPos.y)
    local endIndex = self:GetNodeIndexByPos(x, y)

    local pathNodes = {}
    -- Calculates the path, and its length
    local startFindingTime = love.timer.getTime()
    local path = self.pathFinder:getPath(startIndex.x, startIndex.y, endIndex.x, endIndex.y)
    if path then
        -- print("Path finding cost time:", love.timer.getTime() - _startFindingTime)
        -- print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
            -- print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
            pathNodes[count] = self:GetNodeByIndex(node:getY(), node:getX())
            pathNodes[count]:SetColor(0, 200, 0, 255) -- set walkable nodes color to Green
            pathNodes[count]:SetDrawType("fill")
        end
        
    else
        return false
    end

    self.lastPath = pathNodes
    pathNodes[1]:SetColor(200, 0, 0, 255) -- set end node color to red

    return pathNodes

    --> Output:
    --> Path found! Length: 8.83
    --> Step: 1 - x: 1 - y: 1
    --> Step: 2 - x: 1 - y: 3
    --> Step: 3 - x: 2 - y: 4
    --> Step: 4 - x: 4 - y: 4
    --> Step: 5 - x: 5 - y: 3
    --> Step: 6 - x: 5 - y: 1
end 

function _Navigation:Draw()
    if self.debug == false then
        return
    end

    for i=1,#self.linearGraph do
        if self.linearGraph[i]:GetPass() then
            self.linearGraph[i]:Draw()
        end
        
    end
    
    -- self:DrawConnection()
end

function _Navigation:DrawConnection()
    local node
    local nextNode

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.graphColor.r, self.graphColor.g, self.graphColor.b, self.graphColor.a)

    for i = 1, #self.linearGraph, self.cols do
        for n = i, i - 1 + self.cols  do
            node = self.linearGraph[n]
            if node and node:GetPass() then

                love.graphics.circle("fill", node.x, node.y, 2, 5)

                if n % self.cols ~= 0 then -- not right boundary
                    
                    -- connect rigth 
                    if self.linearGraph[n + 1] and self.linearGraph[n + 1]:GetPass() then 
                        nextNode = self.linearGraph[n + 1]
                        love.graphics.line(node.x, node.y, nextNode.x, nextNode.y)
                    end

                    -- connect right-down
                    if self.linearGraph[n + self.cols + 1] and 
                    self.linearGraph[n + self.cols + 1]:GetPass() then 
                        nextNode = self.linearGraph[n + self.cols + 1]
                        love.graphics.line(node.x, node.y, nextNode.x, nextNode.y)
                    end
                end
                

                if n % self.cols ~= 1 then -- not left boundary
                    
                    -- connect left-down 
                    if self.linearGraph[n + self.cols - 1] and
                    self.linearGraph[n + self.cols - 1]:GetPass() then 
                        nextNode = self.linearGraph[n + self.cols - 1]
                        love.graphics.line(node.x, node.y, nextNode.x, nextNode.y)
                    end

                end
                

                if (i - 1) % self.cols ~= self.rows then -- not down boundary
                    
                    -- connect down 
                    if self.linearGraph[n + self.cols] and 
                    self.linearGraph[n + self.cols]:GetPass() then 
                        nextNode = self.linearGraph[n + self.cols]
                        love.graphics.line(node.x, node.y, nextNode.x, nextNode.y)
                    end
                    
                end

            end
            
        end
    end

    love.graphics.setColor(r, g, b, a)
end

function _Navigation:GetNodeByIndex(row, col)
    -- return self.linearGraph[index]
    return self.navNodes[row][col]
end

function _Navigation:GetNodeIndexByPos(x, y)
    local node
    for i=1,#self.linearGraph do
        if self.linearGraph[i]:IsInNode(x, y) then
            node = self.linearGraph[i]:GetIndex()
            return node
        end
    end

    -- x and y is on the square boundary of node, select shortest distance node
    local d = 0
    local d_min = 3000
    local min_id
    for i=1,#self.linearGraph do
        d = _MATH.GetDistance(self.linearGraph[i]:GetPos(), {x = x, y = y})
        if d < d_min then
            d_min = d
            min_id = i
        end
    end
    node = self.linearGraph[min_id]:GetIndex()
    return node
    
end

function _Navigation:GetNodeSize()
    return self.nodeSize
end

return _Navigation 