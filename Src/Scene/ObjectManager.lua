--[[
	Desc: Objects Manager
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* You can change code in update() to process some special needs 
]]

local _ObjectMgr = {}

local _sort
_sort = function (obj_a,obj_b)
	assert(obj_b:GetY(),obj_b.type)
	return (
		(obj_a:GetY() == obj_b:GetY()) and
		(obj_a.layerId < obj_b.layerId) or
		(obj_a:GetY() < obj_b:GetY())
	)
end

function _ObjectMgr.Ctor()
	_ObjectMgr.objects = {}
	
end 

function _ObjectMgr.Update(dt)
	
	for n=1,#_ObjectMgr.objects do
		if _ObjectMgr.objects[n] and _ObjectMgr.objects[n].Update  then -- and _ObjectMgr.objects[n]:GetType() ~= "HERO"
			if _ObjectMgr.objects[n]:GetType() == "HERO" then
				_ObjectMgr.objects[n]:Update(dt)
			else 
				_ObjectMgr.objects[n]:Update(dt)
			end 
		end 
	end 
	
	for n=#_ObjectMgr.objects,1,-1 do
		if _ObjectMgr.objects[n]:GetType() == "EFFECT" then
			if _ObjectMgr.objects[n]:IsOver() then
				table.remove(_ObjectMgr.objects,n)
			end 
		end 
	end 

end 

function _ObjectMgr.Draw(cam_x, cam_y)
	_ObjectMgr.Sort()
	for n=1,#_ObjectMgr.objects do
		if _ObjectMgr.objects[n].Draw then
			_ObjectMgr.objects[n]:Draw(cam_x, cam_y)
		end 
	end 
end

function _ObjectMgr.Sort()
    table.sort(_ObjectMgr.objects, _sort)
end

function _ObjectMgr.AddObject(obj)
	assert(obj,"Warning: _ObjectMgr:AddObject() got a nil object!")
	_ObjectMgr.objects[#_ObjectMgr.objects + 1] = obj
	_ObjectMgr.objects[#_ObjectMgr.objects]:SetLayerId(1000 + #_ObjectMgr.objects)
end

function _ObjectMgr.RemoveObject(type)
    for n=#_ObjectMgr.objects,1,-1 do
		if _ObjectMgr.objects[n].type == type then
			table.remove(_ObjectMgr.objects,n)
		end 
	end 
end

function _ObjectMgr.GetObjects()
    return _ObjectMgr.objects 
end

function _ObjectMgr.GetHero()
	for n=1,#_ObjectMgr.objects do
		if _ObjectMgr.objects[n]:GetType() == "HERO" then
			return _ObjectMgr.objects[n]
		end 
	end
	
end

return _ObjectMgr 