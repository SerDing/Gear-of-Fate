--[[
	Dscribe: A new lua class
 	Author: Night_Walker
	CreatTime:   2017-07-28 21:54:14
 	LastChangedBy: Night_Walker
	Last Modified time: 2017-07-30 01:39:44
	Doc:
		*Write notes here even more
]]

-- @作者: baidwwy
-- @邮箱:  313738139@qq.com
-- @初始化时间:   2015-01-27 03:51:34
-- @最后修改来自: baidwwy
-- @Last Modified time: 2016-06-25 21:36:05


local _class 	= {}--保存父类
local ffi = require("ffi")
local create;
create = function(ctor,ct,...)
	if #ct.super > 0	then--继承属性
		for i,v in ipairs(ct.super) do
		 	create(ctor,v,...)
		end
	end
	if ct.init then ct.init(ctor,...) end -- init表示初始化的意思
end
local function 运行父函数(self,id,name,...)--__super
	if type(id) == 'number' then
		if _class[self.super[id]] and _class[self.super[id]][name] then
		    return _class[self.super[id]][name](self,...)
		end
	else
		if _class[id] and _class[id][name] then
		    return _class[id][name](self,...)
		end
	end
end
function class(...)
	local class_type 	= {}--new的对象 new的意思就是创建
	class_type.super 	= {...}
	class_type.init 	= false -- init表示初始化的意思
	class_type.new 	= function(...)
		local ctor = {}
			setmetatable(ctor,{ __index = _class[class_type] })--继承类属性和函数
			create(ctor,class_type,...)--递归所有父类
		return ctor
	end
	_class[class_type] 	= {运行父函数=运行父函数}--类函数实际保存
	local mt 			= {}
	mt.__newindex 		= _class[class_type]
	mt.__call			= function (t,...) return t.new(...) end
	setmetatable(class_type,mt)

	if #class_type.super > 0 then--继承函数
		setmetatable(_class[class_type],{__index = function (t,k)
		    for i,v in ipairs(class_type.super) do
		        local ret = _class[v][k]
		        if ret then
		            return ret
		        end
		    end
		end})
	end
	return class_type
end
--=============================================================================================
--高级类,带有destroy事件,但性能略低  （destroy就是销毁）
--=============================================================================================
function classex(...)
	local class_type 	= {}--new的对象
	class_type.super 	= {...}
	class_type.init 	= false -- init表示初始化的意思
	class_type.destroy 	= false
	class_type.new 	= function(...)
		local ctor = {}--对像真身
			setmetatable(ctor,{ __index = _class[class_type] })--继承类属性和函数
			create(ctor,class_type,...)--递归所有父类
		local obj 	= {}--用于检测对象destroy
			obj.__gc = ffi.gc(ffi.new('char[1]'),function ()
				local destroy
				destroy = function(c)
					if #c.super > 0	then
						for i,v in ipairs(c.super) do
						 	destroy(v)
						end
					end
					if c.destroy then c.destroy(ctor) end
				end
				destroy(class_type)--递归所有父类
				ctor = nil
			end)
		local cmt 	= getmetatable(ctor)--ctormetatable
		local omt 	= {}				--objmetatable
			for k,v in pairs(cmt) do--获得用户修改的mt
				omt[k] = v
			end
			omt.__index 	= ctor
			omt.__newindex 	= ctor
			setmetatable(obj,omt)
		return obj
	end
	_class[class_type] 	= {运行父函数=运行父函数}--类函数实际保存
	local mt 			= {}
	mt.__newindex 		= _class[class_type]
	mt.__call			= function (t,...) return t.new(...) end
	setmetatable(class_type,mt)
	if #class_type.super > 0 then--继承函数
		setmetatable(_class[class_type],{__index = function (t,k)
		    for i,v in ipairs(class_type.super) do
		        local ret = _class[v][k]
		        if ret then
		            return ret
		        end
		    end
		end})
	end
	return class_type
end