--[[
	Desc. 2D box collider
 	Author. SerDing
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

function _Collider.Rect_Rect(rect_a, rect_b, output)
	
	local vex_a = rect_a:GetVertex()
    local vex_b = rect_b:GetVertex()

	if vex_a[1].x >= vex_b[2].x then
        _Collider.exception("vex_a[1].x >= vex_b[2].x" .. tostring(vex_a[1].x) .. " " .. tostring(vex_b[2].x), output)
        return false
    elseif vex_a[2].x <= vex_b[1].x then
        _Collider.exception("vex_a[2].x <= vex_b[1].x" .. tostring(vex_a[2].x) .. " " .. tostring(vex_b[1].x), output)
        return false
    elseif vex_a[1].y >= vex_b[2].y then
        _Collider.exception("vex_a[1].y >= vex_b[2].y" .. tostring(vex_a[1].y) .. " " .. tostring(vex_b[2].y), output)
        return false
    elseif vex_a[2].y <= vex_b[1].y then
        _Collider.exception("vex_a[2].y <= vex_b[1].y" .. tostring(vex_a[2].y) .. " " .. tostring(vex_b[1].y), output)
        return false
    end
    
    return true
end 

function _Collider.exception(content, output)
    if output then
        print(content)
    end
end

return _Collider 