--[[
	desc: Class for lua.
	author: Musoucrow
	since: 2017-3-7
	alter: 2017-6-21
	docs:
		* When using New() would not automatically use Ctor() of the base class, you should manually use it. (Base.Ctor(self, ...))
		* When accessing attribute of the base class, you should use self.xxx, if the current class has homonymous attribute that will cover the base class.
		* When accessing method of the base class, you should use Base.func(self, ...).
		* When using self:func(), if the current class has not it, that will access the method of the base class and upper untill access it.
		* The class is powered by Wuyinjie.
]]--

local function _Clone(object, table)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

		local new_table = table or {}
        lookup_table[object] = new_table

		for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end

        return setmetatable(new_table, getmetatable(object))
    end

    return _copy(object, table)
end


local function _Class(...) -- super list
    local cls
	local superList = {...}

    if (#superList > 0) then -- inherit
		cls = _Clone(superList[1])

        for n=2, #superList do
			cls = _Clone(superList[n], cls)
		end
    else -- normal class
        cls = {Ctor = function() end}
    end

    function cls.New(...)
        local instance = setmetatable({}, {__index = cls})
        instance.class = cls
        instance:Ctor(...)
        return instance
    end

    return cls
end

return _Class