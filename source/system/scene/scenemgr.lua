--[[
	Desc: Scene Manager
	Author: SerDing
	Since: 2021-01-29 17:20
	Alter: 2021-01-30
]]
local _PLAYERMGR = require("system.playermgr")
local _FACTORY = require("system.entityfactory")
local _GRAPHICS = require("engine.graphics.graphics")
local _Frameani = require("engine.graphics.drawable.frameani")
local _Sprite = require("engine.graphics.drawable.sprite")
local _Layer = require("engine.graphics.drawable.layer")
local _RESOURCE = require("engine.resource")
local _CAMERA = require("system.scene.camera")
local _Background = require("system.scene.background")

---@class SCENEMGR
---@field protected _layers table<string, Engine.Graphics.Drawable.Layer|Engine.Graphics.Drawable.Sprite>
local _SCENEMGR = {
	_mode = "game", -- game|editor
	_setting = nil,
	_DrawEntity = nil,
	_localPlayer = nil,
	_TILE_WIDTH = 224,
	_layers = {
		farback = _Layer.New(),
		midback = _Layer.New(),
		floor = _Sprite.New(),
		closeback = _Layer.New(),
		nearsight = _Layer.New(),
		effect = _Layer.New(), -- ray/fog
	},
}

---@param data table @scene data
---@param key string
local function _LoadBackground(data, key)
	local sceneWidth = data.setting.width
	local scroll = data.setting.scroll[key]
	data = data.background
	if data[key] then
		local aniData = _RESOURCE.LoadAnimData(data[key])
		local bgWidth = aniData.frames[1].data.image:getWidth()
		local n = math.ceil(sceneWidth / bgWidth)
		key = key .. "back"
		for i = 1, n do
			local background = _Background.New(aniData, scroll)
			background:SetRenderValue("position", (i - 1) * bgWidth, 0)
			_SCENEMGR._layers[key]:Add(background)
		end
	end
end

local function _LoadFloor(data)
	local sceneWidth = data.setting.width
	local sceneHeight = data.setting.height
	local spriteTemplate = _Sprite.New()
	local floorCanvas = _GRAPHICS.NewCanvas(sceneWidth, sceneHeight)
	_GRAPHICS.SetCanvas(floorCanvas)

	data = data.floor
	local tileCount = #data.tile
	for i = 1, tileCount do
		local spriteData = _RESOURCE.LoadSpriteData(data.tile[i])
		spriteTemplate:SetData(spriteData)
		spriteTemplate:SetRenderValue("position", (i - 1) * _SCENEMGR._TILE_WIDTH, 0)
		spriteTemplate:Draw()
	end

	if data.extend then
		local spriteData = _RESOURCE.LoadSpriteData(data.extend.path)
		local extileHeight = spriteData.image:getWidth()
		spriteTemplate:SetData(spriteData)
		for row = 1, data.extend.rows do
			for i = 1, tileCount do
				spriteTemplate:SetRenderValue("position", (i - 1) * _SCENEMGR._TILE_WIDTH, (row - 1) * extileHeight)
				spriteTemplate:Draw()
			end
		end
	end
	--draw downtile sprites
	if data.decoration then
		for i = 1, #data.decoration do
			local decoItem = data.decoration[i]
			local spriteData = _RESOURCE.LoadSpriteData(decoItem[1])
			spriteTemplate:SetData(spriteData)
			spriteTemplate:SetRenderValue("position", decoItem[2], decoItem[3])
			spriteTemplate:Draw()
		end
	end

	_GRAPHICS.SetCanvas()
	_SCENEMGR._layers.floor:SetImage(floorCanvas)
	_SCENEMGR._layers.floor:SetRenderValue("position", 0, 0)
end

local function _LoadStuffAnimation(data, key)
	local stuff = data[key]
	for i = 1, #stuff do
		local animData = _RESOURCE.LoadAnimData(stuff[i][1])
		local anim = _Frameani.New(animData)
		anim:SetRenderValue("position", stuff[i][2], stuff[i][3])
		_SCENEMGR._layers[key]:Add(anim)
	end
end

local function _LoadEntities(data)
	data = data.entity
	if not data then
		return
	end

	local enemy = data.enemy
	if enemy then
		local param = {
			x = 0,
			y = 0,
			camp = 3,
			direction = 1,
		}
		for i = 1, #enemy do
			local enemyItem = enemy[i]
			param.x = enemyItem[2]
			param.y = enemyItem[3]
			param.direction = enemyItem[4]
			_FACTORY.NewEntity(enemyItem[1], param)
		end
	end
end

local _loadFuncs = {
	background = _LoadBackground,
	floor = _LoadFloor,
	stuff = _LoadStuffAnimation,
	entity = _LoadEntities,
}

---@param drawEntity fun():void
function _SCENEMGR.Init(drawEntity)
	_SCENEMGR._DrawEntity = drawEntity
	_SCENEMGR._localPlayer = _PLAYERMGR.GetLocalPlayer()
	_CAMERA.Ctor(224 * 5, 600)
end

---@param path string @ subpath of scene, e.g:"lorien/proto".
function _SCENEMGR.Load(path)
	local data = _RESOURCE.LoadSceneData(path)
	_LoadBackground(data, "far")
	_LoadBackground(data, "mid")
	_LoadFloor(data)
	_LoadStuffAnimation(data, "closeback")
	_LoadStuffAnimation(data, "nearsight")
	_LoadEntities(data)

	_CAMERA.SetWorld(data.setting.width, data.setting.height)
end

---@param dt float
function _SCENEMGR.Update(dt)
	local position = _SCENEMGR._localPlayer.transform.position
	_CAMERA.LookAt(position.x, position.y)

	local cx, _ = _CAMERA.GetPosition()
	---@param o System.Scene.Background
	local function SetBgTranslation(o)
		o:SetCameraTranslation(cx)
	end
	_SCENEMGR._layers.farback:DoFuncForAll(SetBgTranslation)
	_SCENEMGR._layers.midback:DoFuncForAll(SetBgTranslation)

	--TODO:sort objects in closeback and nearsight

	--nearsight stuff auto-transpansy when someone of them blcoks player character

end

local function _DrawScene()
	_SCENEMGR._layers.farback:Draw()
	_SCENEMGR._layers.midback:Draw()
	_SCENEMGR._layers.floor:Draw()
	_SCENEMGR._layers.closeback:Draw()
	_SCENEMGR._DrawEntity()
	_SCENEMGR._layers.nearsight:Draw()
end

function _SCENEMGR.Draw()
	_CAMERA.Draw(_DrawScene, true)
end

function _SCENEMGR.GetWidth()
	return _SCENEMGR._setting.width
end

function _SCENEMGR.GetHeight()
	return _SCENEMGR._setting.height
end

function _SCENEMGR.GetLoadFuncs()
	return _loadFuncs
end


return _SCENEMGR