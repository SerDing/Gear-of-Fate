--[[
    Desc: Battle Scene
    Author: Night_Walker
    Since: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Alter: Sat Sep 09 2017 18:35:30 GMT+0800 (CST)
    Docs: 
        * Every scene is created by a *.map file
        * Press space to freeze camera 
]]

local _GameScene = require("Src.Core.Class")()

local _Rect = require "Src.Core.Rect"
local _Tile = require "Src.Scene.Blocks.Tile"
local _AniBlock = require "Src.Scene.Blocks.AniBlock" 
local _ObjectMgr = require "Src.Scene.ObjectManager"
local _Collider = require "Src.Core.Collider"
local _KEYBOARD = require "Src.Core.KeyBoard" 
local _GAMEINI = require "Src.Config.GameConfig" 

local _AUDIOMGR = require "Src.Audio.AudioManager"
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _MonsterSpawner = require "Src.Monster.MonsterSpawner"

local _Navigation = require "Src.Navigation.Navigation"

_PassiveObjMgr.Ctor()
_MonsterSpawner.Ctor()

local mathFloor = math.floor
local mathCeil = math.ceil
local mathAbs = math.abs

--[[
    new refactoring mission:
    1.changed ACTORMGR to a real factory, it just create and return actor
    2.add new method: SCENEMGR.AddObject(obj, layer)
]]

function _GameScene:Ctor(path, SCENEMGR) --initialize
    self._SCENEMGR = SCENEMGR

    self.pathHead = "/Data/map/"
    self.map = require(string.gsub(path,".lua",""))

    -- temp proc of [virtual movable area] for test maps
    -- if not self.map["[virtual movable area]"] then
    --     self.map["[virtual movable area]"] = {}
    --     self.map["[virtual movable area]"][1] = self.map["[pathgate pos]"][1] + 20
    --     self.map["[virtual movable area]"][2] = self.map["[pathgate pos]"][2] - 80
    --     self.map["[virtual movable area]"][3] = self.map["[pathgate pos]"][3] - 40
    --     self.map["[virtual movable area]"][4] = self.map["[pathgate pos]"][4] - 50
    -- end
    -- self.map["[sound]"] = {"AMB_FOREST_01","M_FOREST_01_NEW",}

    self.res = {}
    self.layers = {
        ["[normal]"] = {},
        ["[bottom]"] = {},
        ["[closeback]"] = {},
        ["[close]"] = {},
    }
    self.tiles = {}
    self.extendedTiles = {}
    self.pathgates = {}
    self.animations = {}
    self.passiveobjs = {}
    self.obstacles = {}
    self.monsters = {}


    self.isDgn = false
    self.clear = false
    self.debug = false
    self.iterator = 0
    self.limit = 0
    self.warmSpd = 2.25 -- warm after freeze camera
    self.drawExTile = false

    self.rect = _Rect.New(0,0,1,1)
    self.nav = _Navigation.New(self.map["[virtual movable area]"], self)

    -- set directory for loading
    self.directory = string.split(path,"/")
    self.directory = self.directory[#self.directory - 1] .. "/"

    self:LoadBackGround()
    self:LoadTiles()
    self:LoadAnimations()
    self:LoadPassiveObjects()
    self:LoadPathgate()
    self:LoadMonster()
end

function _GameScene:LoadTiles()
   
    local _tilePath
    for n=1,#self.map["[tile]"] do
        _tilePath = strcat(self.pathHead, self.directory, self.map["[tile]"][n])
        self.tiles[n] = _Tile.New(_tilePath)
        self.tiles[n]:SetPos((n - 1) * 224, 0)
        self.tiles[n]:SetOffset(0, 80) -- set draw offset
        self.tiles[n]:SetOffset_2(0, 80 * 2) -- set grid data offset

    end

    if self.map["[extended tile]"] then
        local filePath = ""
        local n = #self.map["[tile]"] + 1 -- tile_num + 1
        for i,v in ipairs(self.map["[extended tile]"]["[tile map]"]) do
            filePath = self.map["[extended tile]"]["[tile files]"][v]
            print("create extended tiles:", strcat(self.pathHead, self.directory, filePath))
            self.extendedTiles[i] = _Tile.New(strcat(self.pathHead, self.directory, filePath))
            self.extendedTiles[i]:SetPos(((i - 1) % n) * 224, math.floor(i / n) * self.extendedTiles[i].sprite:GetHeight())
            self.extendedTiles[i]:SetOffset(0, 80) -- set draw offset
            self.extendedTiles[i]:SetOffset_2(0, 480 + 80 + math.floor(i / n) * 120) -- set obstacle grid offset, 120 is default height of any extile.
        end
        self.drawExTile = true
    end

end

function _GameScene:LoadAnimations()
    local mapAnimation = self.map["[animation]"]
    local aniPath 
    local animation 
    for n=1,#mapAnimation,5 do
        aniPath = self.pathHead .. self.directory .. mapAnimation[n]
        animation = _AniBlock.New(aniPath, mapAnimation[n + 1])
        animation:SetOffset_2(0, 200)
        animation:SetPos(mapAnimation[n + 2], mapAnimation[n + 3])
        animation:SetFilter(true)
        animation:SetLayer(mapAnimation[n + 1])
        self.animations[#self.animations + 1] = animation
        table.insert(self.layers[mapAnimation[n + 1]], animation)
    end 
end 

function _GameScene:LoadPassiveObjects()
    local pobj_data = self.map["[passive object]"]
    for n=1,#pobj_data,4 do
        local obj = _PassiveObjMgr.GeneratePassiveObj(pobj_data[n]) 
        if obj ~= nil then
            obj:SetOffset(0, 200)
            obj:SetPos(pobj_data[n + 1], pobj_data[n + 2], pobj_data[n + 3])
            print("passive_obj:GetLayer() = ", obj:GetLayer())
            self.passiveobjs[#self.passiveobjs + 1] = obj
            if obj.subType == "OBSTACLE" then
                self.obstacles[#self.obstacles + 1] = obj
            end
            table.insert(self.layers[obj:GetLayer()], obj)
        end
    end
end

function _GameScene:LoadPathgate()
    if not self.res["[pathgate]"] then
        self.res["[pathgate]"] = {}
    end
    local pathgates = self.map["[pathgate]"]
    local pathgate
    for n=1,#pathgates, 4 do
        pathgate = _PassiveObjMgr.GeneratePathgate(pathgates[n], pathgates[n + 1], pathgates[n + 2], pathgates[n + 3])
        if pathgate ~= nil then
            self.pathgates[#self.pathgates + 1] = pathgate
            table.insert(self.layers[pathgate.layer], pathgate)
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
                self.monsters[#self.monsters + 1] = _mon
            end
        end
        print("LoadMonster: ",#_monDataArr / 10,"monsters")
    end
end

function _GameScene:Awake() -- ReAdd objects into ObjMgr
    
    for n=1,#self.animations do
        if self.animations[n]:GetLayer() == "[normal]" then
            _ObjectMgr.AddObject(self.animations[n])
        end
    end 
    
    for n=1,#self.passiveobjs do
        if self.passiveobjs[n]:GetLayer() == "[normal]" then
            _ObjectMgr.AddObject(self.passiveobjs[n])
        end
    end 

    for n=1,#self.pathgates do
        if self.pathgates[n]:GetLayer() == "[normal]" then
            _ObjectMgr.AddObject(self.pathgates[n])
        end
    end 

    if self.isDgn and self.clear == false then
        for n=1,#self.monsters do
            self.monsters[n]:SetScenePtr(self)
            _ObjectMgr.AddObject(self.monsters[n])
        end
    end
    
    _AUDIOMGR.PlaySceneMusic(self.map["[sound]"])

    self.nav:BuildNavGraph()

end

function _GameScene:Update(dt)
    
    self:UpdateLayer("[bottom]",dt)
    self:UpdateLayer("[closeback]",dt)
    self:UpdateLayer("[close]",dt)
    
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

---@param cam_x float 
---@param cam_y float 
function _GameScene:Draw(cam_x,cam_y)

    self:DrawBackGround("[far]", cam_x, cam_y)
    self:DrawBackGround("[mid]", cam_x, cam_y)
    self:DrawTile(cam_x, cam_y)
    self:DrawExtendedTile(cam_x, cam_y)

    self:DrawLayer("[bottom]",cam_x, cam_y)
    self:DrawLayer("[closeback]",cam_x, cam_y)

    if GDebug then
        self:DrawSpecialArea("movable")
        self:DrawSpecialArea("event")
    end 

    self.nav:Draw()
    _ObjectMgr.Draw(cam_x, cam_y)
    self:DrawLayer("[close]",cam_x, cam_y)
    
    -- love.graphics.line(100, 0, 100, 480 + 80)
end

---@param layer string 
---@param dt float 
function _GameScene:UpdateLayer(layer, dt)
    for n=1,#self.layers[layer] do
        self.layers[layer][n]:Update(dt)
    end  
end

---@param layer string 
---@param x float 
---@param y float 
function _GameScene:DrawLayer(layer, x, y)
    for n=1,#self.layers[layer] do
        self.layers[layer][n]:Draw(x, y)
    end 
end

---@param type string 
---@param ex float 
---@param ey float 
function _GameScene:DrawBackGround(type, ex, ey)
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
        local name = self.map["[background animation]"][_ani_info]["[filename]"]
        local bganim = self.res[type][name]
        local x = ex * (self.map[_scroll] - 100) / 100
        local y = 0
        local imageWidth = bganim:GetWidth()
        x = (x % - imageWidth)
        
        while x < -ex + _GAMEINI.winSize.width do
			bganim:Draw(x,y)
            -- print("x:", x, "ex...:", -ex + love.graphics.getWidth())
            x = x + imageWidth
		end
    end
end

---@param ex float 
---@param ey float 
function _GameScene:DrawTile(ex, ey)

    if ex >= 480 + 80 then
        return 
    end
    
    -- horizental
    local index = mathFloor(mathAbs(ex) / 224) + 1 -- 向下取整
	local num = mathCeil(_GAMEINI.winSize.width / 224) - 2 -- 向上取整
    local endl = (index + num > #self.map["[tile]"]) and (#self.map["[tile]"]) or index + num
    -- print("index:", index, "endl:", endl)
    for n = index, endl do
        self.tiles[n]:Draw()
	end

end

---@param ex float 
---@param ey float 
function _GameScene:DrawExtendedTile(ex, ey)
    
    if not self.drawExTile then
        return 
    end
    -- horizental
    local XStart = math.floor(math.abs(ex) / 224) + 1 -- 向下取整
	local num = math.ceil(_GAMEINI.winSize.width / 224) - 2 -- 向上取整
    local XEnd = (XStart + num > #self.map["[tile]"]) and (#self.map["[tile]"]) or XStart + num
    -- vertical
    local tileNum = #self.map["[tile]"]
    local YStart = (ey <= 480) and 1 or math.floor((ey - (480 + 80)) / 120) + 1
    local YEnd = math.ceil((ey + _GAMEINI.winSize.height - (480 + 80)) / 120) --#self.extendedTiles / tileNum、
    YEnd = (YEnd > #self.extendedTiles / tileNum) and YEnd - 1 or YEnd
    for i = YStart, YEnd do
        for n = XStart, XEnd do
            self.extendedTiles[(i - 1) * tileNum + n]:Draw()
        end
    end
    
end

--@param string type
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
		w = w + self.tiles[n]:GetWidth()
	end
	return  w
end

function _GameScene:GetHeight()
	return 600
end

---@param x float 
---@param y float 
function _GameScene:GetTileByPos(x, y)
    local nx = 0
    local ny = 0
    if y <= 480 + 80 then -- normal tile
        nx = math.ceil(x / 224)
        return self.tiles[nx]
    else -- extended tile
        nx = math.ceil(x / 224)
        ny = math.floor((y - (480 + 80)) / 120)
        return self.extendedTiles[ny * #self.tiles + nx]
    end
end

---@param x float 
---@param y float 
---@return result bool
function _GameScene:IsPassable(x, y)
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return false
    end 
    for n=1,#self.pathgates do
        if self.pathgates[n].tile:IsInTile(x, y) then
            if self.pathgates[n].tile:IsPassable(x, y) == false then
                return false
            end
        end
    end
    return self:GetTileByPos(x, y):IsPassable(x, y)
end

---@param x float 
---@param y float 
function _GameScene:IsInMoveableArea(x, y) 
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return false 
    end 
    if self.map["[virtual movable area]"] then -- town
        return self:IsInArea("movable",x,y)
    end
end

---@param areaType string 
---@param x float 
---@param y float 
function _GameScene:IsInArea(areaType, x, y)
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

---@param x float 
---@param y float
function _GameScene:CheckEvent(x, y)
    local _result = self:IsInArea("event",x,y)
    
    if _result then
        local _index = {area = _result[1], map = _result[2]}
        self._SCENEMGR.SwitchScene(_result[1],_result[2],_result[3])
    end 
end

---@param x float 
---@param y float
function _GameScene:IsInObstacles(x, y)
    -- out of scene
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return {false, "not in scene area"}
    end 
    -- no obstacles
    if #self.obstacles == 0 then
        return {false, "no obstacles"}
    end

    -- for n=1,#self.layers["[normal]"]["[passive object]"] do
    --     if self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].subType == "OBSTACLE" then
    --         if _Collider.Point_Rect(x, y, self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].rect) then
    --             return {true,self.res["[passive object]"][self.layers["[normal]"]["[passive object]"][n]].rect}
    --         end 
    --     end 
    -- end 

    for n=1,#self.obstacles do
        if _Collider.Point_Rect(x, y, self.obstacles[n].rect) then
            return {true,self.obstacles[n].rect}
        end 
    end 

    return {false, "no collision"}
end

---@param rect_a table 
function _GameScene:CollideWithObstacles(rect_a)
    -- local _Layer = self.layers["[normal]"]["[passive object]"]
    -- local _res = self.res["[passive object]"]
    
    -- for n=1,#_Layer do
    --     if _res[_Layer[n]].subType == "OBSTACLE" then
    --         local rect_b = _res[_Layer[n]]:GetRect()
    --         if _Collider.Rect_Rect(rect_a, rect_b) then
    --             return true
    --         end
    --     end
    -- end 

    for n=1,#self.obstacles do
        local rect_b = self.obstacles[n]:GetRect()
        if _Collider.Rect_Rect(rect_a, rect_b) then
            return true
        end
    end 
    
    return false
end

return _GameScene