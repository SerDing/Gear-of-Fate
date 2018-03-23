--[[
	Desc: navigation path finding (using grids)
	Author: Night_Walker 
	Since: 2018-03-07 12:37:49 
	Last Modified time: 2018-03-07 12:37:49 
	Docs: 
		* Write notes here even more 
]]

local _Navigation = require("Src.Core.Class")()

function _Navigation:Ctor(area, scene)
    self.scene = scene
    self.area = area
    self.staticFix = false
end 

function _Navigation:BuildNavGraph()
    self.navGrids = {}
    local _size = 20
    local _grid = {}
    local _area
    
    _area = {
        self.area[1], -- x
        self.area[2] + 200, -- y
        self.area[3], -- width
        self.area[4] -- height
    }

    for i = 1 + _size, _area[4] - _size, _size do
        for n = 1 + _size, _area[3] - _size * 2, _size do
            _grid = {_area[1] + n, _area[2] + i}
            
            local _isInObstacles = self.scene:CollideWithObstacles(unpack(_grid))
            
            if _isInObstacles[1] == false then
                self.navGrids[#self.navGrids + 1] = _grid
            end
            
        end
    end
        
        

end 

function _Navigation:Update(dt)
    --body
end 

function _Navigation:Draw(x,y)
    
    if self.staticFix == false then
        self:FixNodes()
        self.staticFix = true
    end
    for i=1,#self.navGrids do
        love.graphics.circle("fill", self.navGrids[i][1], self.navGrids[i][2], 2, 5)
    end
end

function _Navigation:FixNodes()
    for i = #self.navGrids, 1, -1 do
        local _isInObstacles = self.scene:CollideWithObstacles(unpack(self.navGrids[i]))
        -- print(_isInObstacles[2])
        if _isInObstacles[1] then
            table.remove(self.navGrids, i)
        end
    end
end 


return _Navigation 