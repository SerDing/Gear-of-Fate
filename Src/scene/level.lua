--[[
    Desc: Level module
    Author: SerDing
    Since: 2017-09-09
    Alter: 2019-12-12
    Docs: 
        * Every scene is created by a *.map file
        * Press space to freeze camera 
]]

local _Rect = require("engine.graphics.drawable.rect")
local _Tile = require("scene.objects.tile")
local _AnimObj = require("scene.objects.animobj")
local _Animator = require("engine.animation.frameani")
local _EntityMgr = require("system.entitymgr")
local _Collider = require("system.collider")

local _STRING = require("engine.string")
local _RESMGR = require("system.resource.resmgr")
local _AUDIOMGR = require("engine.audio")
-- local _PassiveObjMgr = require("system.passiveobjmgr")
-- local _MonsterSpawner = require("system.monsterspawner")

local _Navigation = require("system.navigation.navigation")

-- _PassiveObjMgr.Ctor()
-- _MonsterSpawner.Ctor()

local mathFloor = math.floor
local mathCeil = math.ceil
local mathAbs = math.abs

---@class Level 
local _Level = require("core.class")()

function _Level:Ctor(path, LEVELMGR) --initialize
    self._LEVELMGR = LEVELMGR

    self.pathHead = "Data/map/"
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
    self.directory = _STRING.split(path, "/")
    self.directory = self.directory[#self.directory - 1] .. "/"

    self:LoadBackGround("[far]")
    self:LoadBackGround("[mid]")
    self:LoadTiles()
    -- self:LoadAnimations()
    -- self:LoadPassiveObjects()
    -- self:LoadPathgate()
    -- self:LoadMonster()

end

function _Level:LoadTiles()
   
    local _tilePath
    for n=1,#self.map["[tile]"] do
        _tilePath = self.pathHead .. self.directory .. self.map["[tile]"][n]
        self.tiles[n] = _Tile.New(_tilePath)
        self.tiles[n]:SetPos((n - 1) * 224, 0)
        self.tiles[n]:SetOffset(0, 80) -- set draw offset
        self.tiles[n]:SetOffset_2(0, 160) -- set grid data offset
    end

    if self.map["[extended tile]"] then
        local filePath = ""
        local n = #self.map["[tile]"] + 1 -- tile_num + 1
        for i,v in ipairs(self.map["[extended tile]"]["[tile map]"]) do
            filePath = self.map["[extended tile]"]["[tile files]"][v]
            -- print("create extended tiles:", self.pathHead .. self.directory .. filePath)
            self.extendedTiles[i] = _Tile.New(self.pathHead .. self.directory .. filePath)
            self.extendedTiles[i]:SetPos(((i - 1) % n) * 224, math.floor(i / n) * self.extendedTiles[i].sprite:GetHeight())
            self.extendedTiles[i]:SetOffset(0, 80) -- set draw offset
            self.extendedTiles[i]:SetOffset_2(0, 480 + 60 + math.floor(i / n) * 120) -- set obstacle grid offset, 120 is default height of any extile.
        end
        self.drawExTile = true
    end

end

function _Level:LoadAnimations()
    local mapAnimation = self.map["[animation]"]
    local aniPath
    local animation
    for n=1,#mapAnimation,5 do
        aniPath = self.pathHead .. self.directory .. mapAnimation[n]
        animation = _AnimObj.New(aniPath, mapAnimation[n + 1])
        animation:SetPos(mapAnimation[n + 2], mapAnimation[n + 3] + 200)
        animation:SetLayer(mapAnimation[n + 1])
        self.animations[#self.animations + 1] = animation
        table.insert(self.layers[mapAnimation[n + 1]], animation)
    end 
end 

function _Level:LoadPassiveObjects()
    local pobj_data = self.map["[passive object]"]
    for n=1,#pobj_data,4 do
        local obj = _PassiveObjMgr.GeneratePassiveObj(pobj_data[n]) 
        if obj ~= nil then
            obj:SetOffset(0, 200)
            obj:SetPos(pobj_data[n + 1], pobj_data[n + 2], pobj_data[n + 3])
            print("passive_obj:GetLayer() = ", obj:GetLayer())
            self.passiveobjs[#self.passiveobjs + 1] = obj
            if obj:GetType() == "OBSTACLE" then
                self.obstacles[#self.obstacles + 1] = obj
            end
            table.insert(self.layers[obj:GetLayer()], obj)
        end
    end
end

function _Level:LoadPathgate()
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

---@param bgLayer string
function _Level:LoadBackGround(bgLayer)
    if self.map["[background animation]"] then
        if not self.res[ bgLayer] then
            self.res[ bgLayer] = {}
        end
        local filename = self.map["[background animation]"][bgLayer]["[filename]"]
        local animPath = self.pathHead .. self.directory .. filename
        if not self.res[ bgLayer][filename] then
            self.res[ bgLayer][filename] = _Animator.New()
            self.res[ bgLayer][filename]:Play(_RESMGR.LoadDataFile(animPath))
        end
    end
end

function _Level:LoadMonster()
    local mon
    local monDataArr = self.map["[monster]"]
    if monDataArr then
        self.isDgn = true
        for q=1,#monDataArr,10 do
            mon = _MonsterSpawner.Spawn(
                monDataArr[q], 
                monDataArr[q + 3], 
                monDataArr[q + 4],
                self.nav
            )
            mon:SetPos(monDataArr[q + 3], monDataArr[q + 4] + 200)
            if mon ~= 0 then
                self.monsters[#self.monsters + 1] = mon
            end
        end
        print("LoadMonster: ",#monDataArr / 10,"monsters")
    end
end

function _Level:Awake() -- ReAdd objects into ObjMgr
    
    -- for n=1,#self.animations do
    --     if self.animations[n]:GetLayer() == "[normal]" then
    --         _ObjectMgr.AddObject(self.animations[n])
    --     end
    -- end 
    
    -- for n=1,#self.passiveobjs do
    --     if self.passiveobjs[n]:GetLayer() == "[normal]" then
    --         _ObjectMgr.AddObject(self.passiveobjs[n])
    --     end
    -- end 

    -- for n=1,#self.pathgates do
    --     if self.pathgates[n]:GetLayer() == "[normal]" then
    --         _ObjectMgr.AddObject(self.pathgates[n])
    --     end
    -- end 

    -- if self.isDgn and self.clear == false then
    --     for n=1,#self.monsters do
    --         _ObjectMgr.AddObject(self.monsters[n])
    --     end
    -- end
    
    -- _AUDIOMGR.PlaySceneMusic(self.map["[sound]"])

    self.nav:BuildNavGraph()
end

function _Level:Update(dt)
    
    self:UpdateLayer("[bottom]",dt)
    self:UpdateLayer("[closeback]",dt)
    self:UpdateLayer("[close]",dt)
    
	if self.iterator < self.limit then
		self.iterator = self.iterator + 1
		return 
	else 
		self.iterator = 0
		self.limit = self.limit - self.warmSpd
    end
    
    _EntityMgr.Update(dt)
end

---@param cam_x number
---@param cam_y number
function _Level:Draw(cam_x,cam_y)

    self:DrawBackGround("[far]", "[far sight scroll]", cam_x)
    self:DrawBackGround("[mid]", "[middle sight scroll]", cam_x)
    self:DrawTile(cam_x, cam_y)
    self:DrawExtendedTile(cam_x, cam_y)

    self:DrawLayer("[bottom]", cam_x, cam_y)
    self:DrawLayer("[closeback]", cam_x, cam_y)

    if gDebug then
        --self:DrawSpecialArea("movable")
        self:DrawSpecialArea("event")
    end 

    self.nav:Draw()
    _EntityMgr.Draw()
    self:DrawLayer("[close]", cam_x, cam_y)
end

---@param layer string 
---@param dt number
function _Level:UpdateLayer(layer, dt)
    for n=1,#self.layers[layer] do
        self.layers[layer][n]:Update(dt)
    end
end

---@param layer string 
---@param x number
---@param y number
function _Level:DrawLayer(layer, x, y)
    for n=1,#self.layers[layer] do
        self.layers[layer][n]:Draw(x, y)
    end 
end

---@param type string
---@param scroll string
---@param ex number
---@param ey number
function _Level:DrawBackGround(type, scroll, ex)

    if self.map["[background animation]"] then
        local name = self.map["[background animation]"][type]["[filename]"]
        local bganim = self.res[type][name]
        local x = ex * (self.map[scroll] - 100) / 100
        local y = self.map["[background pos]"] or 80
        local imageWidth = bganim:GetWidth()
        x = (x % - imageWidth)
        
        while x < -ex + love.graphics.getWidth() do
            bganim.sprite:SetRenderValue("position", x, y)
            bganim:Draw()
            -- print("x:", x, "ex...:", -ex + love.graphics.getWidth())
            x = x + imageWidth
		end
    end
end

---@param ex number
---@param ey number
function _Level:DrawTile(ex, ey)

    if ex >= 480 + 80 then
        return 
    end
    
    -- horizental
    local index = mathFloor(mathAbs(ex) / 224) + 1 -- plus 1 because of floor() maybe return 0
	local num = mathCeil(love.graphics.getWidth() / 224)
    local endl = (index + num > #self.map["[tile]"]) and (#self.map["[tile]"]) or index + num
    -- print("index:", index, "endl:", endl)
    for n = index, endl do
        self.tiles[n]:Update()
        self.tiles[n]:Draw()
	end

end

---@param ex number
---@param ey number
function _Level:DrawExtendedTile(ex, ey)
    
    -- if not self.drawExTile then
    --     return 
    -- end
    -- -- horizental
    -- local XStart = math.floor(math.abs(ex) / 224) + 1 -- 向下取整
	-- local num = math.ceil(love.graphics.getWidth() / 224) -- 向上取整
    -- local XEnd = (XStart + num > #self.map["[tile]"]) and (#self.map["[tile]"]) or XStart + num
    -- -- vertical
    -- local tileNum = #self.map["[tile]"]
    -- local YStart = (ey <= 480) and 1 or math.floor((ey - (480 + 80)) / 120) + 1
    -- local YEnd = math.ceil((ey + love.graphics.getHeight() - (480 + 80)) / 120) --#self.extendedTiles / tileNum、
    -- YEnd = (YEnd > #self.extendedTiles / tileNum) and YEnd - 1 or YEnd
    -- for i = YStart, YEnd do
    --     for n = XStart, XEnd do
    --         -- print("gamescene draw extended tile: (i - 1) * tileNum + n = ", (i - 1) * tileNum + n)
    --         self.extendedTiles[(i - 1) * tileNum + n]:Draw()
    --     end
    -- end

    for i=1,#self.extendedTiles do
        self.extendedTiles[i]:Update()
        self.extendedTiles[i]:Draw()
    end
    
end

---@param type string
function _Level:DrawSpecialArea(type)
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
	for n = 1, #tab, _count do
        self.rect:SetPosition(tab[n],200 + tab[n+1])
        self.rect:SetSize(tab[n+2],tab[n+3])
        if type == "movable" then
            -- self.rect:SetColor(255,255,255,80)
        else -- "event" : send hero to another map
            -- self.rect:SetColor(255,0,0,80)
        end 
        self.rect:Draw(_, "fill")
	end

end

function _Level:GetWidth()
	local w = 0
	for n=1,#self.map["[tile]"] do
		w = w + self.tiles[n]:GetWidth()
	end
	return  w
end

function _Level:GetHeight()
	return 600
end

---@param x number
---@param y number
function _Level:GetTileByPos(x, y)
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

---@param x number
---@param y number
---@return boolean
function _Level:IsPassable(x, y)
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

---@param x number
---@param y number
function _Level:IsInMoveableArea(x, y) 
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return false 
    end 
    if self.map["[virtual movable area]"] then -- town
        return self:IsInArea("movable",x,y)
    end
end

---@param areaType string 
---@param x number
---@param y number
function _Level:IsInArea(areaType, x, y)
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
        self.rect:SetPosition(tab[n], 200 + tab[n + 1])
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

---@param x number
---@param y number
function _Level:CheckEvent(x, y)
    local result = self:IsInArea("event",x,y)
    
    if result then
        local index = {area = result[1], map = result[2]}
        self._LEVELMGR.SwitchScene(result[1],result[2],result[3])
    end 
end

---@param x number
---@param y number
function _Level:IsInObstacles(x, y)
    -- out of scene
    if x > self:GetWidth() or x < 0 or y > self.GetHeight() or y < 0 then
        return {false, "not in scene area"}
    end 
    -- no obstacles
    if #self.obstacles == 0 then
        return {false, "no obstacles"}
    end

    for n=1,#self.obstacles do
        if _Collider.CheckPoint(x, y, self.obstacles[n].rect) then
            return {true, self.obstacles[n].rect}
        end 
    end 

    return {false, "no collision"}
end

---@param rect_a table 
function _Level:CollideWithObstacles(rect_a)
    for n=1,#self.obstacles do
        local rect_b = self.obstacles[n]:GetRect()
        if _Collider.Collide(rect_a, rect_b) then
            return true
        end
    end 
    
    return false
end

return _Level