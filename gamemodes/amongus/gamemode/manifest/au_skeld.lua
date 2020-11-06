--- Helper function to retrieve a language entry from the gamemode translation table
-- Uses the client's default language
-- @param entry The language entry to retrieve
-- @return The language string from the gamemode
local function _(entry)
	return GM.Lang:GetEntry(entry)()
end

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
			Text = _('area.cafeteria'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.storage'),
			Position = Vector(0, 0),
		},

		-- Left side
		{
			Text = _('area.medbay'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.upperEngine'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.reactor'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.security'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.lowerEngine'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.electrical'),
			Position = Vector(0, 0),
		},

		-- Right side
		{
			Text = _('area.weapons'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.o2'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.navigation'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.admin'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.shields'),
			Position = Vector(0, 0),
		},
		{
			Text = _('area.communications'),
			Position = Vector(0, 0),
		},
	},
	Tasks = {
		-- 'divertPower',
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
		-- 'uploadData',
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
