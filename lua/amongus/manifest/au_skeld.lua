AddCSLuaFile()

AddCSLuaFile('au_skeld/cameras.lua')
include('au_skeld/cameras.lua')

local MANIFEST = {
	PrintName = 'The Skeld',
	Map = {
		UI = (function ()
			if CLIENT then return {
				BackgroundMaterial = Material('au_skeld/gui/background.png', 'smooth'),
				OverlayMaterial = Material('au_skeld/gui/overlay.png', 'smooth'),

				Position = Vector(-3576, 1978),
				Scale = 3.5,
				Resolution = 4
			} end
		end)(),
	},
	Labels = {
		-- Center
		{
			Text = 'area.cafeteria',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.storage',
			Position = Vector(0, 0),
		},

		-- Left side
		{
			Text = 'area.medbay',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.upperEngine',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.reactor',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.security',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.lowerEngine',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.electrical',
			Position = Vector(0, 0),
		},

		-- Right side
		{
			Text = 'area.weapons',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.o2',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.navigation',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.admin',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.shields',
			Position = Vector(0, 0),
		},
		{
			Text = 'area.communications',
			Position = Vector(0, 0),
		},
	},
	Tasks = {
		'divertPower',
		'alignEngineOutput',
		'calibrateDistributor',
		'chartCourse',
		'cleanO2Filter',
		'clearAsteroids',
		'emptyGarbage',
		-- 'fixWiring',
		'inspectSample',
		'primeShields',
		'stabilizeSteering',
		'startReactor',
		'submitScan',
		'swipeCard',
		'unlockManifolds',
		'uploadData',
		'fuelEngines',
	},
	Sabotages = {
		-- Left side
		{
			Handler = 'reactor',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_reactor.png', 'smooth'),
					Position = Vector(0, 0)
				} end
			end)(),
		},
		{
			Handler = 'lights',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_lights.png', 'smooth'),
					Position = Vector(0, 0)
				} end
			end)(),
		},

		-- Right side
		{
			Handler = 'o2',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_o2.png', 'smooth'),
					Position = Vector(0, 0)
				} end
			end)(),
		},
		{
			Handler = 'comms',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_comms.png', 'smooth'),
					Position = Vector(0, 0)
				} end
			end)(),
		},

		-- doors added in SABOTAGE_DOORS
	},
}

--  name    position on map
local SABOTAGE_DOORS = {
	['foo'] = Vector(0, 0),
}

-------------------------------------------
-- no need to change anything below here --
-------------------------------------------

-- avoid instantiating the material several times
local DOOR_UI_MAT = Material('au/gui/map/sabotage_doors.png', 'smooth')

local sabotages = MANIFEST.Sabotages

-- initialize all door sabotages
-- since these all share the same details
for k, v in pairs(SABOTAGE_DOORS) do
	sabotages[#sabotages + 1] = {
		Handler = 'doors',
		UI = (function ()
			if CLIENT then return {
				Icon = DOOR_UI_MAT,
				Position = v
			} end
		end)(),
		CustomData = {
			Target = k,
			Cooldown = 30,
			Duration = 10,
		},
	}
end

return MANIFEST
