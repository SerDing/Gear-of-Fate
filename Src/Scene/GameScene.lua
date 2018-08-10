--[[
    Desc: Battle Scene
    Author: Night_Walker
    Since: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Alter: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Docs: 
        * This module is used to create scene by *.map file
        * Press space to frezen camera 
]]

local _GameScene = require("Src.Core.Class")()

local _Rect = require "Src.Core.Rect"
local _TileBlock = require "Src.Scene.Blocks.TileBlock"
local _AniBlock = require "Src.Scene.Blocks.AniBlock" 
local _ObjectMgr = require "Src.Scene.ObjectManager"
local _Collider = require "Src.Core.Collider"
local _KEYBOARD = require "Src.Core.KeyBoard" 
local _GAMEINI = require "Src.Config.GameConfig" 

local _AUDIOMGR = require "Src.Audio.AudioManager"
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _MonsterSpawner = require "Src.Monster.MonsterSpawner"

local _Navigation = require "Src.Navigation.Navigation"

local _sceneMgr = {} -- Initialize a null pointer of SceneManager

_PassiveObjMgr.Ctor()

_MonsterSpawner.Ctor()

function _GameScene:Ctor(path,res_,sceneMgr) --initialize
    -- ptr
    _sceneMgr = sceneMgr

    -- data and structure
    self.pathHead = "/Data/map/"
    self.map = require(string.gsub(path,".lua",""))
    self.res = {}
    self.layers = {
        ["[normal]"] = {
            ["[animation]"] = {},
            ["[passive object]"] = {},
            ["[monster]"] = {},
        },
        ["[bottom]"] = {
            ["[animation]"] = {},
            ["[passive object]"] = {},
        },
        ["[closeback]"] = {
            ["[animation]"] = {},
            ["[passive object]"] = {},
        },
        ["[close]"] = {
            ["[animation]"] = {},
            ["[passive object]"] = {},
        },
    }   --[[
        these layers just storage objects' id and types, 
        updating and drawing layers equal to find 
        objects by id then update and draw them
    ]]
    -- property
    self.isDgn = false
    self.clear = false
    self.debug = false
    self.iterator = 0
    self.limit = 0
    self.warmSpd = 2.25

    -- instance
    self.rect = _Rect.New(0,0,1,1)
    self.nav = _Navigation.New(self.map["[virtual movable area]"], self)

    -- set directory for loading
    self.directory = string.split(path,"/")
    self.directory = self.directory[#self.directory - 1] .. "/"

    self:LoadBackGround()
    self:LoadTiles()
    self:LoadAnimations()
    self:LoadPassiveObjects()
    self:LoadMonster()

end

function _GameScene:LoadTiles()
   
    if not self.res["[tile]"] then
        self.res["[tile]"] = {}
    end 

    local _tilePath

    for n=1,#self.map["[tile]"] do
        _tilePath = strcat(self.pathHead, self.directory, self.map["[tile]"][n])
        self.res["[tile]"][self.map["[tile]"][n]] = _TileBlock.New(_tilePath)
        self.res["[tile]"][self.map["[tile]"][n]]:SetOffset_2(0, (self.map["[background pos"] or 80))
    end 

end

function _GameScene:LoadAnimations()
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
        table.insert(self.layers[_mapAnimation[n+1]]["[animation]"],n)
    end 
    
end

function _GameScene:LoadPassiveObjects()
    if not self.res["[passive object]"] then
        self.res["[passive object]"] = {}
    end 
    local _objDataArr = self.map["[passive object]"]
    for n=1,#_objDataArr,4 do
        self.res["[passive object]"][n] = _PassiveObjMgr.GeneratePassiveObj(_objDataArr[n]) 
        if self.res["[passive object]"][n] ~= 0 then
            self.res["[passive object]"][n]:SetOffset(0, 200)
            self.res["[passive object]"][n]:SetPos(_objDataArr[n+1], _objDataArr[n+2], _objDataArr[n+3])
            table.insert(self.layers[self.res["[passive object]"][n]:GetLayer()]["[passive object]"],n)
        else
            table.remove(self.res["[passive object]"], n)
        end
    end 

end

function _GameScene:LoadBackGround()
    
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
                self.res[ _bgLayer[n]][ _bgFileName]:SetSubType("MAP_ANI_BACK")
            end 
        end 
        
    end 
 
end

function _GameScene:LoadMonster()
    local _mon
    local _monDataArr = self.map["[monster]"]
    if _monDataArr then
        self.isDgn = true
        for q=1,#_monDataArr,10 do
            _mon = _MonsterSpawner.Spawn(
                _monDataArr[q], 
                _monDataArr[q + 3], 
                _monDataArr[q + 4],
                self.nav
            )
            _mon:SetPos(_monDataArr[q + 3], _monDataArr[q + 4] + 200)
            if _mon ~= 0 then
                table.insert(self.layers["[normal]"]["[monster]"], _mon)
            end
        end
        print("LoadMonster: ",#_monDataArr / 10,"monsters")
    end
end

function _GameScene:Awake() -- ReAdd objects into ObjMgr
    
    local _layer = self.layers["[normal]"]["[animation]"]
    for n=1,#_layer do
        _ObjectMgr.AddObject(self.res["[animation]"][_layer[n]])
    end 
    
    _layer = self.layers["[normal]"]["[passive object]"]
    for n=1,#_layer do
        _ObjectMgr.AddObject(self.res["[passive object]"][_layer[n]])
    end 

    _layer = self.layers["[normal]"]["[monster]"]
    if self.isDgn and self.clear == false then
        for n=1,#_layer do
            _layer[n]:SetScenePtr(self)
            _ObjectMgr.AddObject(_layer[n])
        end
    end
    
    _AUDIOMGR.PlaySceneMusic(self.map["[sound]"])

    self.nav:BuildNavGraph()

end

function _GameScene:Update(dt)
    
    if _KEYBOARD.Press("f1") then
        if not self.debug then
            self.debug = true
        else 
            self.debug = false
        end 
    end

    self:UpdateLayer("[bottom]",dt)
    self:UpdateLayer("[closeback]",dt)
    self:UpdateLayer("[close]",dt)
    self:UpdateLayer("[normal]",dt)

  --[[ limit objects update rate  ]]
    if _KEYBOARD.Press("space") then
		self.limit = 20
	end

	if self.iterator < self.limit then
		self.iterator = self.iterator + 1
		return  
	else 
		self.iterator = 0
		self.limit = self.limit - self.warmSpd
	end


    
    _ObjectMgr.Update(dt)

end

function _GameScene:Draw(cam_x,cam_y)

    self:DrawBackGround("[far]", cam_x,cam_y)
    self:DrawBackGround("[mid]", cam_x,cam_y)
    self:DrawTile(cam_x, cam_y)
    self:DrawLayer("[closeback]",cam_x, cam_y)
    self:DrawLayer("[bottom]",cam_x, cam_y)

    if self.debug then
        self:DrawSpecialArea("movable")
        self:DrawSpecialArea("event")
    end 

    self.nav:Draw()
    _ObjectMgr.Draw(cam_x, cam_y)
    self:DrawLayer("[close]",cam_x, cam_y)
    
end

function _GameScene:UpdateLayer(layer,dt)
    for n=1,#self.layers[layer]["[animation]"] do
        self.res["[animation]"][self.layers[layer]["[animation]"][n]]:Update(dt)
    end 
    for n=1,#self.layers[layer]["[passive object]"] do
        self.res["[passive object]"][self.layers[layer]["[passive object]"][n]]:Update(dt)
    end 
end

function _GameScene:DrawLayer(layer, x, y)
    for n=1,#self.layers[layer]["[animation]"] do
        self.res["[animation]"][self.layers[layer]["[animation]"][n]]:Draw(x, y)
        
    end 
    for n=1,#self.layers[layer]["[passive object]"] do
        self.res["[passive object]"][self.layers[layer]["[passive object]"][n]]:Draw(x, y)
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
        local _x = ex * (self.map[_scroll] - 100) / 100
        local _y = 0
        local _imageWidth = _sprAni:GetWidth()
        _x = (_x % - _imageWidth)
        
        while _x < -ex + _GAMEINI.winSize.width do
			_sprAni:Draw(_x,_y)
            -- print("_x:",_x,"ex...:",-ex + _GAMEINI.winSize.width)
            _x = _x + _imageWidth
		end
    end
end

function _GameScene:DrawTile(ex,ey)
    
    local index = math.floor(math.abs(ex) / 224) +1
	local num = math.ceil(_GAMEINI.winSize.width / 224)
    local endl = (index + num > #self.map["[tile]"]) and ( #self.map["[tile]"]) or index + num
    -- print("index:",index,"endl:", endl)
    for n=index,endl do
		self.res["[tile]"][self.map["[tile]"][n]]:Draw((n - 1) * 224,0)
	end

end

function _GameScene:DrawSpecialArea(type)
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
        self.rect:SetPos(tab[n],200 + tab[n+1])
        self.rect:SetSize(tab[n+2],tab[n+3])
        if type == "movable" then
            self.rect:SetColor(255,255,255,80)
        else -- "event" : send hero to another map
            self.rect:SetColor(255,0,0,80)
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

    if self.map["[virtual movable area]"] then -- town
        return self:IsInArea("movable",x,y)
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

function _GameScene:CheckEvent(x,y)
    local _result = self:IsInArea("event",x,y)
    
    if _result then
        local _index = {area = _result[1], map = _result[2]}
        _sceneMgr.SwitchScene(_result[1],_result[2],_result[3])
    end 
end

function _GameScene:IsInObstacles(x,y)
    
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return {false, "not in scene area"} 
    end 
    if #self.layers["[normal]"]["[passive object]"] == 0 then
        return {false, "no obstacles"}
    end

    for n=1,#self.layers["[normal]"]["[passive object]"] do
        if self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].subType == "OBSTACLE" then
            if _Collider.Point_Rect(x, y, self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].rect) then
                return {true,self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].rect}
            end
        end
    end 

    return {false, "no collision"}

end

function _GameScene:CollideWithObstacles(rect_a)
    local _Layer = self.layers["[normal]"]["[passive object]"]
    local _res = self.res["[passive object]"]
    
    for n=1,#_Layer do
        if _res[_Layer[n]].subType == "OBSTACLE" then
            local rect_b = _res[_Layer[n]]:GetRect()
            if _Collider.Rect_Rect(rect_a, rect_b) then
                return true
            end
        end
    end 

    return false

end

return _GameScene