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
				Resolution = 4,

				-- Labels positions are always relative to 1024x1024, despite cropping of overlay
				Labels = {
					-- Center
					{
						Text = 'area.cafeteria',
						Position = Vector(550/1024, 90/1024),
					},
					{
						Text = 'area.storage',
						Position = Vector(520/1024, 417/1024),
					},
			
					-- Left side
					{
						Text = 'area.medbay',
						Position = Vector(350/1024, 185/1024),
					},
					{
						Text = 'area.upperEngine',
						Position = Vector(160/1024, 110/1024),
					},
					{
						Text = 'area.reactor',
						Position = Vector(58/1024, 240/1024),
					},
					{
						Text = 'area.security',
						Position = Vector(250/1024, 240/1024),
					},
					{
						Text = 'area.lowerEngine',
						Position = Vector(160/1024, 405/1024),
					},
					{
						Text = 'area.electrical',
						Position = Vector(370/1024, 345/1024),
					},
			
					-- Right side
					{
						Text = 'area.weapons',
						Position = Vector(790/1024, 115/1024),
					},
					{
						Text = 'area.o2',
						Position = Vector(725/1024, 215/1024),
					},
					{
						Text = 'area.navigation',
						Position = Vector(975/1024, 260/1024),
					},
					{
						Text = 'area.admin',
						Position = Vector(670/1024, 310/1024),
					},
					{
						Text = 'area.shields',
						Position = Vector(785/1024, 440/1024),
					},
					{
						Text = 'area.communications',
						Position = Vector(660/1024, 500/1024),
					},
				},
			} end
		end)(),
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
					Position = Vector(58/1024, 500/1024)
				} end
			end)(),
		},
		{
			Handler = 'lights',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_electricity.png', 'smooth'),
					Position = Vector(405/1024, 680/1024)
				} end
			end)(),
		},

		-- Right side
		{
			Handler = 'o2',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_o2.png', 'smooth'),
					Position = Vector(720/1024, 445/1024)
				} end
			end)(),
		},
		{
			Handler = 'comms',
			UI = (function ()
				if CLIENT then return {
					Icon = Material('au/gui/map/sabotage_comms.png', 'smooth'),
					Position = Vector(660/1024, 960/1024)
				} end
			end)(),
		},

		-- doors added in SABOTAGE_DOORS
	},
}

--  name    position on map
local SABOTAGE_DOORS = {
	-- Center
	sabotage_door_cafeteria = Vector(550/1024, 220/1024),
	sabotage_door_storage   = Vector(520/1024, 810/1024),

	-- Left side
	sabotage_door_medbay       = Vector(350/1024, 400/1024),
	sabotage_door_upper_engine = Vector(160/1024, 260/1024),
	sabotage_door_security     = Vector(250/1024, 500/1024),
	sabotage_door_lower_engine = Vector(160/1024, 790/1024),
	sabotage_door_electrical   = Vector(340/1024, 680/1024),
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
