--[[
	Desc: methods to handle text
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

function CutText(w,z)-- 参数:待分割的字符串,用作分割的字符
	local a = { }            --声明a
    while (true) do          --判断循环
        local pos = string.find(w,z,nil,true) --取出分割的字符的位置
        if (not pos) then            --如果位置的值不为空,↓↓↓
            a [#a+1] = w             --因为取不到z的位置,把w保存到数组a中
        	break
           --如果位置的值为空,跳出循环
        end
        local sub_w = string.sub(w, 1, pos - 1) --取文本中间（文本,起始位置,结束位置）,取出的文本保存到sub_w
        a[ #a + 1] = sub_w                      --把sub_w保存到数组a中
        w = string.sub(w, pos + 1, #w)         --把w当前位置到文本末所剩下的文本赋值到w中
                               --[#字符串]=为取字符串长度
    end
		return a   -- 返回:子串表.(含有空串)
end