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
local _ObjectMgr = require "Src.Scene.ObjectManager"
local _KEYBOARD = require "Src.Core.KeyBoard" 

local _GAMEINI = require "Src.Config.GameConfig" 

local _screenOffset = {x = 0,y = 0}
local _sceneMgr = {} -- Initialize a null pointer of SceneManager

function _GameScene:Ctor(path,res_,sceneMgr) --initialize
    
    _sceneMgr = sceneMgr

    self.pathHead = "Src/Script/map/"

    self.map = require(string.gsub(path,".lua",""))

    self.res = {}

    self.layers = {
        ["[normal]"] = {},
        ["[bottom]"] = {},
        ["[closeback]"] = {},
        ["[close]"] = {},
    }

    self.directory = string.split(path,"/")
    self.directory = self.directory[#self.directory - 1] .. "/"
    
    self.rect = _Rect.New(0,0,1,1)

    self.debug = false

------[[    load tiles    ]]
    if not self.res["[tile]"] then
        self.res["[tile]"] = {}
    end 
    local _tilePath
    for n=1,#self.map["[tile]"] do
        _tilePath = self.pathHead .. self.directory .. self.map["[tile]"][n]
        self.res["[tile]"][self.map["[tile]"][n]] = _TileBlock.New(_tilePath)
        self.res["[tile]"][self.map["[tile]"][n]]:SetOffset_2(0, -(self.map["[background pos"] or 80) * 2 - 10)
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
        -- self.layers[ self.res["[animation]"][n].layer ][ #self.layers + 1 ] = self.res["[animation]"][n]
        table.insert(self.layers[_mapAnimation[n+1]],n)
        
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
    
------[[    Add normal objcets into ObjcetMgr.objects    ]]

    self:Awake()
    
end

function _GameScene:Awake() -- ReAdd objects into ObjMgr
    for n=1,#self.layers["[normal]"] do
        _ObjectMgr.AddObject(self.res["[animation]"][self.layers["[normal]"][n]])
    end 
end

function _GameScene:Update(dt,screenOffset)
    
    _screenOffset = screenOffset

    self:UpdateLayer("[bottom]",dt)
    self:UpdateLayer("[closeback]",dt)
    self:UpdateLayer("[close]",dt)
    self:UpdateLayer("[normal]",dt)

    _ObjectMgr.Update(dt)

    if _KEYBOARD.Press("f1") then
        if not self.debug then
            self.debug = true
        else 
            self.debug = false
        end 
    end 
    
end

function _GameScene:Draw()

    self:DrawBackGround("[far]",_screenOffset.x,_screenOffset.y)
    self:DrawBackGround("[mid]",_screenOffset.x,_screenOffset.y)
    self:DrawTile(_screenOffset.x,_screenOffset.y)
    self:DrawLayer("[closeback]",_screenOffset.x,_screenOffset.y)
    self:DrawLayer("[bottom]",_screenOffset.x,_screenOffset.y)
    _ObjectMgr.Draw(_screenOffset)
    self:DrawLayer("[close]",_screenOffset.x,_screenOffset.y)
    
    
    if self.debug then
        self:DrawSpecialArea("movable",_screenOffset.x,_screenOffset.y)
        self:DrawSpecialArea("event",_screenOffset.x,_screenOffset.y)
    end 

end

function _GameScene:UpdateLayer(layer,dt)
    for n=1,#self.layers[layer] do
        self.res["[animation]"][self.layers[layer][n]]:Update(dt)
    end 
end

function _GameScene:DrawLayer(layer,x,y)
    for n=1,#self.layers[layer] do
        self.res["[animation]"][self.layers[layer][n]]:Draw(x,y)
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
    local _count = 0
    if type == "movable" then
        _head = "[virtual movable area]"
        _count = 4
    else -- "event"
        _head = "[town movable area]"
        _count = 6
    end 

    local tab = self.map[_head]
	if not tab then
		return false
    end
	for n=1,#tab,_count do
        self.rect:SetPos(x + tab[n],200+y + tab[n+1])
        self.rect:SetSize(tab[n+2],tab[n+3])
        if type == "movable" then
            self.rect:SetColor(0,0,180,255)
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

function _GameScene:IsInMoveableArea(x,y)
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return false 
    end 

    return self:IsInArea("movable",x,y)
end

function _GameScene:CheckEvent(x,y)
    local _result = self:IsInArea("event",x,y)
    
    if _result then
        local _index = {area = _result[1], map = _result[2]}
        _sceneMgr.SwitchScene(_result[1],_result[2],_result[3])
    end 
end

function _GameScene:IsInArea(areaType,x,y)
	local _head = ""
    local _count = 0
    
    if areaType == "movable" then
        _head = "[virtual movable area]"
        _count = 4
    else -- "event"
        _head = "[town movable area]"
        _count = 6
    end 
    
    local tab = self.map[_head]
    
    if not tab then
		return false
    end

	for n=1,#tab,_count do
        self.rect:SetPos( tab[n], 200 + tab[n + 1])
        self.rect:SetSize(tab[n + 2] ,tab[n + 3])
        if self.rect:CheckPoint(x,y) then
            if _count == 4 then -- movable area
                return true
            else -- event area
                
                return {tab[n + 4],tab[n + 5],math.ceil(n / 6)}
            end 
        end 
    end

    return false
end

return _GameScene