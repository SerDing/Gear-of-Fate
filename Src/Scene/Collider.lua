--[[
	Desc. A new lua class
 	Author. Night_Walker
	Since. 2017-07-28 21.54.14
	Alter. 2017-07-30 12.40.40
	Docs.
		* 
]]

local _Collider = {}

function _Collider.Ctor()
    --body
end 

function _Collider.Point_Rect(x,y,rect)
	return rect:CheckPoint(x, y)
end 

return _Collider 