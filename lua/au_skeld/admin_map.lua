if SERVER then
	util.AddNetworkString('au_skeld admin map update')

	local BUTTON_NAME = 'admin_map_button'
	local ROOM_TRIGGER_NAME_PREFIX = 'admin_map_room_'

	local playersOnAdminMap = {}
	local roomTriggers = {}
	local roomTriggerPositions = {}

	--- Retrieves a room's name from the trigger's targetname
	-- @param ent The trigger_room_bounds entity with the appropriate ROOM_TRIGGER_NAME_PREFIX prefix
	-- @return The name of the trigger_room_bounds entity, without the prefix
	local function roomTriggerName(ent)
		return string.sub(ent:GetName(), string.len(ROOM_TRIGGER_NAME_PREFIX) + 1)
	end

	--- Gets the number of players in each room
	-- @return A table; keys are the room name and values are the numbers of players in the named room
	local function getRoomPlayerCounts()
		local roomPlayerCounts = {}
		for name, ent in pairs(roomTriggers) do
			roomPlayerCounts[name] = ent:GetCount()
		end
		return roomPlayerCounts
	end

	local shouldNetworkMapCounts = true

	--- Networks the number of players in each room to all players who are on the admin map
	local function networkMapCounts()
		-- Converts the Player = bool mapping of playersOnAdminMap to a flat list of players
		local playersToSendTo = {}
		for ply, onMap in pairs(playersOnAdminMap) do
			if onMap then
				table.insert(playersToSendTo, ply)
			end
		end

		if #playersToSendTo == 0 then return end -- Send nothing if we can

		local roomPlayerCounts = {}
		if not shouldNetworkMapCounts then
			-- don't send updates if comms are disabled
			roomPlayerCounts = {}
			for name, _ in pairs(roomTriggers) do
				roomPlayerCounts[name] = 0
			end
		else
			roomPlayerCounts = getRoomPlayerCounts()
		end

		net.Start('au_skeld admin map update')
			net.WriteTable(roomPlayerCounts)
		net.Send(playersToSendTo)
	end

	hook.Add('GMAU SabotageStart', 'au_skeld admin map comms sabotage', function (sabotage)
		if sabotage:GetHandler() ~= 'comms' then return end
		shouldNetworkMapCounts = false
		networkMapCounts()
	end)

	hook.Add('GMAU SabotageEnd', 'au_skeld admin maps comms sabotage', function (sabotage)
		if sabotage:GetHandler() ~= 'comms' then return end
		shouldNetworkMapCounts = true
		networkMapCounts()
	end)

	local function openAdminMap(ply)
		local payload = { adminMap = GAMEMODE:GetCommunicationsDisabled() and {} or getRoomPlayerCounts(), positions = roomTriggerPositions }
		-- Mark player as in the map UI
		-- Not necessary, but a bit faster than checking all players to see what UI they're on
		playersOnAdminMap[ply] = true
		GAMEMODE:Player_OpenVGUI(ply, 'adminMap', payload, function ()
			-- On close, mark player as no longer in the map UI
			playersOnAdminMap[ply] = false
		end)
	end

	local function setupAfterCleanup()
		-- Set admin table button as highlightable
		local button = ents.FindByName(BUTTON_NAME)[1]
		if IsValid(button) then
			GAMEMODE:SetUseHighlight(button, true)
		end

		-- Collect room boundaries and store for later
		local foundRooms = 0

		for _, ent in ipairs(ents.FindByClass('trigger_room_bounds')) do
			if IsValid(ent) and string.sub(ent:GetName(), 1, string.len(ROOM_TRIGGER_NAME_PREFIX)) == ROOM_TRIGGER_NAME_PREFIX then
				local roomName = roomTriggerName(ent)
				roomTriggers[roomName] = ent
				-- Bit of a nasty hack to have the entities network details to clients when OnTouchStart/OnTouchEnd is called
				ent:SetCountChangeCallback(networkMapCounts)
				roomTriggerPositions[roomName] = ent:GetPos()
				foundRooms = foundRooms + 1
			end
		end

		if foundRooms == 0 then
			error('no trigger_room_bounds in level')
		end
	end

	-- Re-collect all room boundaries when the map starts and when cleanup is called
	-- Also set our button as useable
	hook.Add('InitPostEntity', 'au_skeld admin map init entities', setupAfterCleanup)
	hook.Add('PostCleanupMap', 'au_skeld admin map init entities', setupAfterCleanup)

	-- Clear out stale player details at start of next game
	hook.Add('GMAU GameStart', 'au_skeld admin map clear entries', function ()
		playersOnAdminMap = {}
	end)

	hook.Add('PlayerUse', 'au_skeld admin map use', function (ply, ent)
		if ent:GetName() == BUTTON_NAME then
			openAdminMap(ply)
		end
	end)

	hook.Add('GMAU MeetingEnd', 'au_skeld admin map cleanup counts', function ()
		for room, ent in pairs(roomTriggers) do
			if room == 'cafeteria' then
				-- Count all live players, and set cafeteria's player count to that number,
				-- since players all spawn in cafeteria
				-- Terrible hack, I'm sorry
				local livePlayers = 0
				for i, v in ipairs(player.GetAll()) do
					if IsValid(v) and not v:IsDead() then
						livePlayers = livePlayers + 1
					end
				end
				ent:SetCount(livePlayers)
			else
				-- For all other rooms, zero-out their count, since everyone will have been
				-- teleported to cafeteria during hte meeting
				ent:SetCount(0)
			end
		end
	end)

	-- Debugging command. Ignore.
	-- concommand.Add('au_debug_open_admin_map', openAdminMap)
else
	local MAX_ROW_SIZE = 5
	local CREWMATE_COLOR = Color(224, 255, 0)
	local MAP_COLOR = Color(32, 220, 32)
	local SABOTAGED_MAP_COLOR = Color(128, 128, 128)
	local COLOR_RED = Color(255, 0, 0)
	local COLOR_BLACK = Color(0, 0, 0, 160)
	local FLASH_SPEED = 200

	surface.CreateFont('au_skeld AdminMapSabotaged', {
		font = 'Lucida Console',
		size = ScreenScale(40),
		weight = 400,
	})

	local function _(str)
		return GAMEMODE.Lang.GetEntry(str)()
	end

	local map

	--- Update counts on the map when a new network payload is received
	local function updateCounts(newCounts)
		for roomName, count in pairs(newCounts) do
			blip = map.Blips[roomName]
			if IsValid(blip) then
				blip:SetCount(count)
			end
		end
	end

	net.Receive('au_skeld admin map update', function()
		if IsValid(map) then
			updateCounts(net.ReadTable())
		end
	end)

	hook.Add('GMAU SabotageStart', 'au_skeld admin map comms sabotage', function (sabotage)
		if sabotage:GetHandler() ~= 'comms' then return end
		if not IsValid(map) then return end

		map:SetColor(SABOTAGED_MAP_COLOR)
	end)

	hook.Add('GMAU SabotageEnd', 'au_skeld admin map comms sabotage', function (sabotage)
		if sabotage:GetHandler() ~= 'comms' then return end
		if not IsValid(map) then return end

		map:SetColor(MAP_COLOR)
	end)

	hook.Add('GMAU OpenVGUI', 'au_skeld admin map open', function (payload)
		if not payload.adminMap then return end

		map = vgui.Create('AmongUsMapBase')
		map:SetupFromManifest(GAMEMODE.MapManifest)
		map:SetColor(GAMEMODE:GetCommunicationsDisabled() and SABOTAGED_MAP_COLOR or MAP_COLOR)
		function map:OnClose()
			GAMEMODE:HUD_CloseVGUI()
			self:Remove()
		end

		function map:PaintOver(w, h)
			if not GAMEMODE:GetCommunicationsDisabled() then return end

			if SysTime() * 100 % FLASH_SPEED < FLASH_SPEED/2 then
				draw.SimpleTextOutlined('[' .. string.upper(_('tasks.commsSabotaged')) .. ']', 'au_skeld AdminMapSabotaged', w/2, h/2, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 6, COLOR_BLACK)
			end
		end

		map.Blips = {}
		do
			-- Obligatory wall of variables.
			local size = math.max(map:GetInnerPanel():GetSize())
			local baseW, baseH = map:GetBackgroundMaterialSize()
			local resolution = map:GetResolution()
			local scale = map:GetScale()
			local position = map:GetPosition()
			local blipSize = size * 0.025

			-- Create blips.
			for roomName, roomOrigin in pairs(payload.positions) do
				-- Map the in-game position onto the map.
				local newOriginX = (roomOrigin.x - position.x) / (baseW * scale) * size * resolution
				local newOriginY = (position.y - roomOrigin.y) / (baseW * scale) * size * resolution

				local blip = map:GetInnerPanel():Add('DPanel')
				blip:SetWide(MAX_ROW_SIZE * blipSize)
				blip:InvalidateLayout()
				map.Blips[roomName] = blip

				-- Re-centers the blip every time the size gets changed.
				blip.PerformLayout = function(_, w, h)
					blip:SetPos(newOriginX - w/2, newOriginY - h/2)
				end

				local rows = {}
				local count = 0
				blip.Paint = function() end

				-- Pushes a new crewmate icon on top of the current stack.
				blip.Push = function()
					local rowId = math.floor(count / MAX_ROW_SIZE) + 1
					count = count + 1
					local row = rows[rowId]

					-- Get an existing row or create one if it doesn't exist.
					if not IsValid(row) then
						row = blip:Add('DPanel')
						row:SetSize(blipSize * MAX_ROW_SIZE, blipSize)
						row:Dock(TOP)
						row.Paint = function() end

						row.container = row:Add('DPanel')
						row.container:SetTall(blipSize)
						row.container.Paint = function() end

						-- Have to keep track of the children separately, because apparently :Remove()ing a child
						-- doesn't update the number of children on this frame, even if :InvalidateLayout(true) is called.
						-- I don't know what I'm doing, but this works. It's terrible, but it works.
						-- Man, fuck UI code.
						row.__numChildren = 0

						table.insert(rows, row)
					end

					-- Create a crewmate sprite.
					local crewmate = row.container:Add('AmongUsCrewmate')
					crewmate:SetSize(blipSize, blipSize)
					crewmate:SetColor(CREWMATE_COLOR)
					row.__numChildren = row.__numChildren + 1

					-- Position the crewmate icon.
					-- Because Dock(LEFT) just doesn't work?
					row.container:SetWide(blipSize * #row.container:GetChildren())
					local x = row.container:GetSize()
					crewmate:SetPos(x - blipSize, 0)

					-- Put the container in the middle of the row.
					blip:SetSize(MAX_ROW_SIZE * blipSize, #rows * blipSize)
					row.container:Center()
				end

				-- Removes the last pushed crewmate.
				blip.Pop = function()
					if count <= 0 then return end
					local rowId = math.floor((count - 1) / MAX_ROW_SIZE) + 1

					local row = rows[rowId]
					if not IsValid(row) then
						return
					end

					count = count - 1

					if row.__numChildren == 1 then
						row:Remove()
						blip:NewAnimation(0, 0, 0, function()
							blip:SizeToChildren(true, true)
						end)

						table.remove(rows, #rows)
					else
						row.container:GetChildren()[row.__numChildren]:Remove()
						row.__numChildren = row.__numChildren - 1

						row.container:SetWide(blipSize * (row.__numChildren))

						-- Put the container in the middle of the row.
						blip:SetSize(MAX_ROW_SIZE * blipSize, #rows * blipSize)
						row.container:Center()
					end
				end

				-- Sets the amount of crewmates in the stack.
				-- Basically just a wrapper around the push/pop functions.
				blip.SetCount = function(_, newCount)
					newCount = math.max(0, newCount)

					if count < newCount then
						while count < newCount do blip:Push() end
					elseif count > newCount then
						while count > newCount do blip:Pop() end
					end
				end
			end
		end

		updateCounts(payload.adminMap)

		map:Popup()
		GAMEMODE:HUD_OpenVGUI(map)

		return true
	end)
end
