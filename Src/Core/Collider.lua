--[[
	Desc. 2D box collider
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

function _Collider.Rect_Rect(rect_a, rect_b, output)
	
	local _vertex_a = rect_a:GetVertex()
    local _vertex_b = rect_b:GetVertex()

	if _vertex_a[1].x >= _vertex_b[2].x then
        _Collider.exception("_vertex_a[1].x >= _vertex_b[2].x" .. tostring(_vertex_a[1].x) .. " " .. tostring(_vertex_b[2].x), output)
        return false
    elseif _vertex_a[2].x <= _vertex_b[1].x then
        _Collider.exception("_vertex_a[2].x <= _vertex_b[1].x" .. tostring(_vertex_a[2].x) .. " " .. tostring(_vertex_b[1].x), output)
        return false
    elseif _vertex_a[1].y >= _vertex_b[2].y then
        _Collider.exception("_vertex_a[1].y >= _vertex_b[2].y" .. tostring(_vertex_a[1].y) .. " " .. tostring(_vertex_b[2].y), output)
        return false
    elseif _vertex_a[2].y <= _vertex_b[1].y then
        _Collider.exception("_vertex_a[2].y <= _vertex_b[1].y" .. tostring(_vertex_a[2].y) .. " " .. tostring(_vertex_b[1].y), output)
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