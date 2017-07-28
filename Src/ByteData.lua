-- @作者: baidwwy
-- @邮箱:  313738139@qq.com
-- @创建时间:   2016-04-22 20:33:10
-- @最后修改来自: baidwwy
-- @Last Modified time: 2017-07-10 23:29:15

local ffi = require("ffi")
local bit = require("bit")
local _ByteData = class()  -- 字节集类

--a=数值,b=空 时,申请空白
--a=数值,b=数值时,指针到字集
--a=文本时,转换
--a=表时,转换
function _ByteData:初始化(a,b)
	if type(a) == 'number' then
		if type(b) == 'number' then--指针
			self.bin = ffi.new("uint8_t[?]",b)
			ffi.copy(self.bin,a,b)
			self.len = b
		else--空白
			self.bin = ffi.new("uint8_t[?]",a)
			self.len = a
		end
	elseif type(a) == 'string' then
		self.len = #a
		self.bin = ffi.new("uint8_t[?]",self.len+1)
		ffi.copy(self.bin,a)
	elseif type(a) == 'table' then
		if #a > 0 then
			self.len = #a
		    self.bin = ffi.new("uint8_t[?]",self.len,a)
		end
	elseif type(a) == 'cdata' then
		if type(b) == 'number' then
			self.bin = ffi.new("uint8_t[?]",b)
			ffi.copy(self.bin,a,b)
			self.len = b
		end
	end
	local mt = getmetatable(self)
	local __oindex = mt.__index
	-- t.__eq 			= _eq
	-- t.__concat 		= _concat
	mt.__tostring = function (t)
		return "ggebin",tostring(t.bin)
	end
	mt.__index 	= function (t,k)
		if __oindex[k] then
		    return __oindex[k]
		elseif type(k) == 'number' then
			if t.bin and k>0 and k<=t.len then
			    return t.bin[k-1]
			end
			return 0
		else
			return rawget(t, k)
		end
	end
	mt.__newindex = function ( t,k,v )
		if type(k) == "number" then
			if t.bin and k>0 and k<=t.len then
			    t.bin[k-1] = v
			end
		else
			rawset(t, k, v)
		end
	end
end
function _ByteData:置指针(p,l)
	self.bin = ffi.cast("uint8_t*",p)
	self.len = l or 0
end
function _ByteData:取长度()
	return self.len
end
function _ByteData:取指针()
	return tonumber(ffi.cast("intptr_t",self.bin))
end
function _ByteData:取地址()
	return self.bin
end
function _ByteData:取文本(i,len)
	return ffi.string(self.bin+(i or 1)-1,len)
end
function _ByteData:取整数(i)
	if i and i+3 <= self.len then
		return bit.bor(bit.lshift(self.bin[i+2], 24),bit.lshift(self.bin[i+1], 16),bit.lshift(self.bin[i], 8),self.bin[i-1])
	    --return bit.lshift(self.bin[i+2], 24)+bit.lshift(self.bin[i+1], 16)+bit.lshift(self.bin[i], 8)+self.bin[i-1] --tonumber(string.format("0x%X%X", self.bin[i],self.bin[i-1]))
	end
	return 0
end
function _ByteData:取短整数(i)
	if i and i+1 <= self.len then
	    return bit.lshift(self.bin[i], 8)+self.bin[i-1] --tonumber(string.format("0x%X%X", self.bin[i],self.bin[i-1]))
	end
	return 0
end
-- function _ByteData:取小数(i)

-- end
function _ByteData:写数据(i,v)
end
function _ByteData:写整数(i,v)
	if i and i+3 <= self.len then
		self.bin[i-1] 	= bit.band(v,0xFF)
		self.bin[i] 	= bit.band(bit.rshift(v, 8),0xFF)
		self.bin[i+1] 	= bit.band(bit.rshift(v, 16),0xFF)
		self.bin[i+2] 	= bit.band(bit.rshift(v, 24),0xFF)
	end
end
function _ByteData:写短整数(i,v)
	if i and i+1 <= self.len then
		self.bin[i-1] 	= bit.band(v,0xFF)
		self.bin[i] 	= bit.band(bit.rshift(v, 8),0xFF)
	end
end

function _ByteData:保存到文件(path,off,len)
	local file = io.open(path,"wb")
	file:write(self:取文本(off,len or self.len))
	file:close()
end
function _ByteData:取左边(len)
	return _ByteData(self.bin,len)
end
function _ByteData:取右边(len)
	return _ByteData(self.bin+self.len-len,len)
end
function _ByteData:取中间(off,len)
	return _ByteData(self.bin+off-1,长度)
end
-- function _ByteData:寻找(字节集,偏移)

-- end
-- function _ByteData:倒找(字节集,偏移)

-- end
-- function _ByteData:替换(偏移,长度,字节集)

-- end
-- function _ByteData:子替换(偏移,长度,字节集)

-- end
-- function _ByteData:分割(偏移,长度,字节集)

-- end
function _ByteData:填充(v,off,len)
	ffi.fill(self.bin+(off or 1)-1,len or self.len ,v or 0)
end
function _ByteData:print(len)
	local len = len or 159
	local l = 1
	local hex = ""
	for i=0,self.len-1 do
		if i > len then
		    break
		else
			hex = hex.. string.format("%02X ", self.bin[i])
			if l == 16 then
			    hex = hex .. "\n"
			    l=0
			end
			l=l+1
		end
	end
	print(hex)
end
return _ByteData