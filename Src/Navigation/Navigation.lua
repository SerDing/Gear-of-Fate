
local _Navigation = require("Src.Core.Class")()

local _Pathfinder = require "Src.Navigation.Jumper.pathfinder" -- The pathfinder lass
local _Node = require "Src.Navigation.Node"
local _Grid = require "Src.Navigation.Jumper.grid" -- The grid class
local _Collider = require "Src.Core.Collider"
local _Utility = require "Src.Core.Utility"

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
    -- self.debug = true

end 

function _Navigation:Init()
    -- NEW jumper pathfinder
    self.grid = _Grid(self.map) -- grid nodes table
    self.pathFinder = _Pathfinder(self.grid, 'ASTAR', self.walkable) 
end

function _Navigation:BuildNavGraph()
    self.linearGraph = {}
    local _node = {}
    local _row
    local _col

    for i = self.nodeSize, self.area[4] + (self.nodeSize - self.area[4] % self.nodeSize), self.nodeSize do
        self.map[i / self.nodeSize] = {}
        self.navNodes[i / self.nodeSize] = {}
        for n = self.nodeSize, self.area[3] , self.nodeSize do

            _row = i / self.nodeSize
            _col = n / self.nodeSize
            
            _node = _Node.New(self.area[1] - (self.nodeSize / 2) + n, self.area[2] - (self.nodeSize / 2) + i, self.nodeSize, _col, _row)
            
            if self.scene:CollideWithObstacles(_node) == false then
                _node:SetPass(true)
                self.map[_row][_col] = 1
            else
                _node:SetPass(false)
                self.map[_row][_col] = 0
            end

            self.navNodes[_row][_col] = _node
            
            self.linearGraph[#self.linearGraph + 1] = _node
            self.linearGraph[#self.linearGraph]:SetIndex(#self.linearGraph)

        end
    end

    -- print("build graph end")

    self:Init()
    
end 

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
    local _entityPos = entity:GetPos()
    local startIndex = self:GetNodeIndexByPos(_entityPos.x, _entityPos.y)
    local endIndex = self:GetNodeIndexByPos(x, y)

    local _pathNodes = {}
    -- Calculates the path, and its length
    local _startFindingTime = love.timer.getTime()
    local path = self.pathFinder:getPath(startIndex.x, startIndex.y, endIndex.x, endIndex.y)
    if path then
        -- print("Path finding cost time:", love.timer.getTime() - _startFindingTime)
        -- print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
            -- print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
            _pathNodes[count] = self:GetNodeByIndex(node:getY(), node:getX())
            _pathNodes[count]:SetColor(0, 200, 0, 255) -- set walkable nodes color to Green
            _pathNodes[count]:SetDrawType("fill")
        end
        
    else
        return false
    end

    self.lastPath = _pathNodes
    _pathNodes[1]:SetColor(200, 0, 0, 255) -- set end node color to red

    return _pathNodes

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
    local _node
    local _nextNode

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(self.graphColor.r, self.graphColor.g, self.graphColor.b, self.graphColor.a)

    for i = 1, #self.linearGraph, self.cols do
        for n = i, i - 1 + self.cols  do
            _node = self.linearGraph[n]
            if _node and _node:GetPass() then

                love.graphics.circle("fill", _node.x, _node.y, 2, 5)

                if n % self.cols ~= 0 then -- not right boundary
                    
                    -- connect rigth 
                    if self.linearGraph[n + 1] and self.linearGraph[n + 1]:GetPass() then 
                        _nextNode = self.linearGraph[n + 1]
                        love.graphics.line(_node.x, _node.y, _nextNode.x, _nextNode.y)
                    end

                    -- connect right-down
                    if self.linearGraph[n + self.cols + 1] and 
                    self.linearGraph[n + self.cols + 1]:GetPass() then 
                        _nextNode = self.linearGraph[n + self.cols + 1]
                        love.graphics.line(_node.x, _node.y, _nextNode.x, _nextNode.y)
                    end
                end
                

                if n % self.cols ~= 1 then -- not left boundary
                    
                    -- connect left-down 
                    if self.linearGraph[n + self.cols - 1] and
                    self.linearGraph[n + self.cols - 1]:GetPass() then 
                        _nextNode = self.linearGraph[n + self.cols - 1]
                        love.graphics.line(_node.x, _node.y, _nextNode.x, _nextNode.y)
                    end

                end
                

                if (i - 1) % self.cols ~= self.rows then -- not down boundary
                    
                    -- connect down 
                    if self.linearGraph[n + self.cols] and 
                    self.linearGraph[n + self.cols]:GetPass() then 
                        _nextNode = self.linearGraph[n + self.cols]
                        love.graphics.line(_node.x, _node.y, _nextNode.x, _nextNode.y)
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
    local _node
    for i=1,#self.linearGraph do
        if self.linearGraph[i]:IsInNode(x, y) then
            _node = self.linearGraph[i]:GetIndex()
            return _node
        end
    end

    -- x and y is on the square boundary of node, select shortest distance node
    local _d = 0
    local _d_min = 3000
    local _min_id
    for i=1,#self.linearGraph do
        _d = _Utility.GetDistance(self.linearGraph[i]:GetPos(), {x = x, y = y})
        if _d < _d_min then
            _d_min = _d
            _min_id = i
        end
    end
    _node = self.linearGraph[_min_id]:GetIndex()
    return _node
    
end

function _Navigation:GetNodeSize()
    return self.nodeSize
end

return _Navigation 