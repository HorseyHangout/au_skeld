AddCSLuaFile()

local NAV_HALL_OVERRIDES = {
	['en'] = 'Vent to Navigation hallway',
	['de'] = 'Zu Navigationsflur venten',
	['fr'] = 'Vent to Navigation hallway', -- TODO: change?
	['ru'] = 'Телепортироваться в Коридор Навигации',
	-- 'cn': '潜入到 试点室走廊', -- this is probably terrible and should be reviewed by an actual speaker
}

for lang, tab in pairs(GAMEMODE.Lang.__database) do -- dirty hack to enumerate every registered language
	tab['vent.reactorSouth'] = tab['vent.reactor']
	tab['vent.navigationSouth'] = tab['vent.navigation']
	tab['vent.navHallway'] = NAV_HALL_OVERRIDES[lang] or tab['vent.navigation']
end
