--[[
    Desc: 
    Author: Night_Walker
    Since: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Alter: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Docs: 
        * this module is used to create scene by *.map file
]]

local _GameScene = require("Src.Class")()

local _Rect = require "Src.Core.Rect"
local _TileBlock = require "Src.Scene.TileBlock"
local _AniBlock = require "Src.Scene.AniBlock" 

local _GAMEINI = require "Src.Config.GameConfig" 

local _aniLayerName = {
    "[bottom]",
    "[closeback]",
    "[close]",
    "[normal]",
}
local _screenOffset = {x = 0,y = 0}

function _GameScene:Ctor(path,res_) --initialize
    
    self.pathHead = "Src/Script/map/"

    self.map = require(string.gsub(path,".lua","") )

    self.res = {}

    self.objects = {}

    -- local tmp = {
	-- 	["[normal]"] = {},
	-- 	["[bottom]"] = {},
	-- 	["[closeback]"] = {},
	-- 	["[close]"] = {},
	-- }
	-- setmetatable(_map, {__index = tmp}) 

    self.aniLayer = {
        ["[normal]"] = {},
        ["[bottom]"] = {},
        ["[closeback]"] = {},
        ["[close]"] = {},
    }

    self.directory = string.split(path,"/")
    self.directory = self.directory[#self.directory - 1] .. "/"
    
    self.rect = _Rect.New(0,0,1,1)

------[[    load tiles    ]]
    if not self.res["[tile]"] then
        self.res["[tile]"] = {}
    end 
    local _tilePath
    for n=1,#self.map["[tile]"] do
        _tilePath = self.pathHead .. self.directory .. self.map["[tile]"][n]
        self.res["[tile]"][self.map["[tile]"][n]] = _TileBlock.New(_tilePath)
        self.res["[tile]"][self.map["[tile]"][n]]:SetOffset_2(0, -170 )
    end 

------[[    load animation    ]]
    if not self.res["[animation]"] then
        self.res["[animation]"] = {}
    end 
    local _mapAnimation = self.map["[animation]"]
    local _aniPath
    for n=1,#_mapAnimation,5 do
        _aniPath = self.pathHead .. self.directory .. _mapAnimation[n]
        self.res["[animation]"][n] = _AniBlock.New(_aniPath,_mapAnimation[n+1])
        self.res["[animation]"][n]:SetOffset_2(0,200)
        self.res["[animation]"][n]:SetPos(_mapAnimation[n+2],_mapAnimation[n+3])
        self.res["[animation]"][n]:SetFilter(true)
        self.res["[animation]"][n]:SetLayer(_mapAnimation[n+1])
        -- self.aniLayer[ self.res["[animation]"][n].layer ][ #self.aniLayer + 1 ] = self.res["[animation]"][n]
        table.insert(self.aniLayer[_mapAnimation[n+1]],n)
        
    end 

------[[    load background (far,middle)    ]]

    local _bgLayer = {
        "[far]",
        "[mid]"
    }
    
    if self.map["[background animation]"] then
        
        for n=1,#_bgLayer do
            if not self.res[ _bgLayer[n]] then
                self.res[ _bgLayer[n]] = {}
            end 
            local _bgFileName = self.map["[background animation]"]["[ani info]"]["[filename]"]
            if n==2 then
                _bgFileName = self.map["[background animation]"]["[ani info2]"]["[filename]"]
            end 
            local _bgAniPath = self.pathHead .. self.directory .. _bgFileName
            if not self.res[ _bgLayer[n]][ _bgFileName] then
                self.res[ _bgLayer[n]][ _bgFileName] = _AniBlock.New(_bgAniPath)
                self.res[ _bgLayer[n]][ _bgFileName]:SetOffset_2(0,self.map["[background pos"] or 80)
                self.res[ _bgLayer[n]][ _bgFileName]:SetFilter(true)
            end 
        end 
        
    end 
    

end

function _GameScene:Update(dt,screenOffset)
    
    -- for n=1,#self.obejcts do
	-- 	self.obejcts[n]:Draw()
	-- end
    
    _screenOffset = screenOffset

    -- for n=1,#_aniLayerName do
    --     self:UpdateLayer(_aniLayerName[n],dt)
    -- end 
    self:UpdateLayer("[bottom]",dt)
    self:UpdateLayer("[closeback]",dt)
    self:UpdateLayer("[close]",dt)
    self:UpdateLayer("[normal]",dt)

end


function _GameScene:Draw(x,y)

	-- for n=1,#self.obejcts do
	-- 	self.obejcts[n]:Draw()
	-- end
    
    
    self:DrawBackGround("[far]",_screenOffset.x,_screenOffset.y)
    self:DrawBackGround("[mid]",_screenOffset.x,_screenOffset.y)

    self:DrawTile(_screenOffset.x,_screenOffset.y)
    


    
    self:DrawLayer("[closeback]",_screenOffset.x,_screenOffset.y)
    self:DrawLayer("[bottom]",_screenOffset.x,_screenOffset.y)
    self:DrawLayer("[normal]",_screenOffset.x,_screenOffset.y)
    -- if self.debug then
        self:DrawSpecialArea("movable",_screenOffset.x,_screenOffset.y)
        self:DrawSpecialArea("event",_screenOffset.x,_screenOffset.y)
    -- end 
    

    -- OBJMGR.draw()  -- object manager draw
    
    
    self:DrawLayer("[close]",_screenOffset.x,_screenOffset.y)


end

function _GameScene:UpdateLayer(layer,dt)
    for n=1,#self.aniLayer[layer] do
        -- self.aniLayer[layer][n]:Update(dt)
        self.res["[animation]"][self.aniLayer[layer][n]]:Update(dt)
    end 
end

function _GameScene:DrawLayer(layer,x,y)
    for n=1,#self.aniLayer[layer] do
        self.res["[animation]"][self.aniLayer[layer][n]]:Draw(x,y)
        
    end 
end

function _GameScene:DrawBackGround(type,ex,ey)
    local _scroll = ""
    local _ani_info = ""
    if type == "[far]" then
        _scroll = "[far sight scroll]"
        _ani_info = "[ani info]"
    else -- "[mid]"
        _scroll = "[middle sight scroll]"
        _ani_info = "[ani info2]"
    end 
    
    if self.map["[background animation]"] then
        local _name = self.map["[background animation]"][_ani_info]["[filename]"]
        local _sprAni = self.res[type][_name]
        local _x = ex * self.map[_scroll] / 100
        local _y = ey
        local _w = _sprAni:GetWidth()
        _x = (_x% - _w)
        while _x < _GAMEINI.winSize.width do
			_sprAni:Draw(_x,_y)
			_x = _x + _w
		end
    end
end

function _GameScene:DrawTile(ex,ey)
    local index = math.floor(math.abs(ex) / 224) +1
	local num = math.ceil(_GAMEINI.winSize.width / 224)
	local endl = (index + num > #self.map["[tile]"]) and ( #self.map["[tile]"]) or index + num
    for n=index,endl do
		self.res["[tile]"][self.map["[tile]"][n]]:Draw(math.floor(ex + (n - 1) * 224),math.floor(ey + 0))
	end

end

function _GameScene:DrawSpecialArea(type,x,y)
    local _head = ""
    if type == "movable" then
        _head = "[virtual movable area]"
    else -- "event"
        _head = "[town movable area]"
    end 

    local tab = self.map[_head]
	if not tab then
		return false
	end
	for n=1,#tab,6 do
        self.rect:SetPos(x + tab[n],200+y + tab[n+1])
        self.rect:SetSize(tab[n+2],tab[n+3])
        if type == "movable" then
            self.rect:SetColor(255,200,0,255)
        else -- "event"
            self.rect:SetColor(255,0,0,255)
        end 
        self.rect:Draw()
	end

end

function _GameScene:GetWidth()
	local w = 0
	for n=1,#self.map["[tile]"] do
		w = w + self.res["[tile]"][self.map["[tile]"][n]]:GetWidth()
	end
	return  w 
end

function _GameScene:GetHeight()
	return 600
end

function _GameScene:Notify()
	
end

return _GameScene