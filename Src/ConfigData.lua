-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-16 19:37:50
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-16 23:45:01

ConfigData = class()


function ConfigData:init(path) --initialize

	DataTable = require (path)

end


function ConfigData:readCase(__case,) --读取数据表中的分支数据

end


function ConfigData:draw()

end

return ConfigData