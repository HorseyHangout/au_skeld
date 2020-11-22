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

	--- Networks the number of players in each room to all players who are on the admin map
	local function networkMapCounts()
		-- Converts the Player = bool mapping of playersOnAdminMap to a flat list of players
		local playersToSendTo = {}
		for ply, onMap in pairs(playersOnAdminMap) do
			if onMap then
				table.insert(playersToSendTo, ply)
			end
		end

		local roomPlayerCounts = getRoomPlayerCounts()

		if #playersToSendTo == 0 then return end -- Send nothing if we can

		net.Start('au_skeld admin map update')
			net.WriteTable(roomPlayerCounts)
		net.Send(playersToSendTo)
	end

	local function openAdminMap(ply)
		local payload = { adminMap = getRoomPlayerCounts(), positions = roomTriggerPositions }
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
		for _, ent in ipairs(ents.FindByClass('trigger_room_bounds')) do
			if IsValid(ent) and string.sub(ent:GetName(), 1, string.len(ROOM_TRIGGER_NAME_PREFIX)) == ROOM_TRIGGER_NAME_PREFIX then
				local roomName = roomTriggerName(ent)
				roomTriggers[roomName] = ent
				-- Bit of a nasty hack to have the entities network details to clients when OnTouchStart/OnTouchEnd is called
				ent:SetCountChangeCallback(networkMapCounts)
				roomTriggerPositions[roomName] = ent:GetPos()
			end
		end
	end

	-- Re-collect all room boundaries when the map starts and when cleanup is called
	-- Also set our button as useable
	hook.Add('InitPostEntity', 'au_skeld admin map init entities', setupAfterCleanup)
	hook.Add('PostCleanupMap', 'au_skeld admin map init entities', setupAfterCleanup)

	-- Clear out stale player details at start of next game
	hook.Add('GMAU GameStart', function ()
		playersOnAdminMap = {}
	end)

	hook.Add('PlayerUse', 'au_skeld admin map use', function (ply, ent)
		if ent:GetName() == BUTTON_NAME then
			openAdminMap(ply)
		end
	end)

	-- Debugging command. Ignore.
	-- concommand.Add('au_debug_open_admin_map', openAdminMap)
else
	local MAX_ROW_SIZE = 5
	local CREWMATE_COLOR = Color(224, 255, 0)
	local MAP_COLOR = Color(32, 220, 32)

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

	hook.Add('GMAU OpenVGUI', 'au_skeld admin map open', function (payload)
		if not payload.adminMap then return end

		map = vgui.Create('AmongUsMapBase')
		map:SetupFromManifest(GAMEMODE.MapManifest)
		map:SetColor(MAP_COLOR)
		function map:OnClose()
			GAMEMODE:HUD_CloseVGUI()
			self:Remove()
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

						table.insert(rows, row)
					end

					-- Create a crewmate sprite.
					local crewmate = row.container:Add('AmongUsCrewmate')
					crewmate:SetSize(blipSize, blipSize)
					crewmate:SetColor(CREWMATE_COLOR)

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

					local children = row.container:GetChildren()
					if #children == 1 then
						row:Remove()
						blip:NewAnimation(0, 0, 0, function()
							blip:SizeToChildren(true, true)
						end)

						table.remove(rows, #rows)
					else
						children[#children]:Remove()

						row.container:SetWide(blipSize * (#children - 1))

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
