if SERVER then
	local playersOnCameras = {}

	local function getCameraViewpointEnts()
		local cameraPrefix = 'camera_viewpoint_'
		local cameraData = {}

		for i, v in ipairs(ents.GetAll()) do
			if IsValid(v) and string.sub(v:GetName(), 1, string.len(cameraPrefix)) == cameraPrefix then
				local cameraName = string.sub(v:GetName(), string.len(cameraPrefix) + 1)
				cameraData[cameraName] = {
					pos   = v:GetPos(),
					angle = v:GetAngles()
				}
			end
		end

		return cameraData
	end

	local function updateCameraModels()
		local cameraName = 'security_cam'
		local numPlayersOnCams = 0

		for _, v in pairs(playersOnCameras) do
			if v then
				numPlayersOnCams = numPlayersOnCams + 1
			end
		end

		for i, v in ipairs(ents.FindByName(cameraName)) do
			local skin = numPlayersOnCams > 0 and 1 or 0
			v:SetSkin(skin)
		end
	end

	local function openCameras(ply)
		if not ply:IsPlaying() then return end
		local playerTable = ply:GetAUPlayerTable()

		local payload = { cameraData = getCameraViewpointEnts() }
		
		playersOnCameras[playerTable] = true
		updateCameraModels()

		GAMEMODE:Player_OpenVGUI(playerTable, 'securityCams', payload, function()
			playersOnCameras[playerTable] = false
			updateCameraModels()
		end)
	end

	concommand.Add('au_debug_open_cameras', openCameras)

	hook.Add('PlayerUse', 'au_skeld cameras monitor use', function (ply, ent)
		if ent:GetName() == 'camera_button' then
			openCameras(ply)
		end
	end)

	hook.Add('SetupPlayerVisibility', 'au_skeld cameras add PVS', function (ply, viewEnt)
		if ply:GetCurrentVGUI() ~= 'securityCams' then return end -- player not on cams

		for k, v in pairs(getCameraViewpointEnts()) do
			AddOriginToPVS(v.pos)
		end
	end)

	-- TODO: Remove once UI close callback is called on player disconnection
	hook.Add('PlayerDisconnected', 'au_skeld cameras fix player count', function (ply)
		if not ply:IsPlaying() then return end
		local playerTable = ply:GetAUPlayerTable()

		if playersOnCameras[playerTable] then playersOnCameras[playerTable] = false end
		updateCameraModels()
	end)

	hook.Add('GMAU GameStart', function ()
		playersOnCameras = {}
		updateCameraModels()
	end)
else
	local noop = function() end
	local cameraOrder = {
		'navigation',   'admin',
		'upper_engine', 'security',
	}

	hook.Add('GMAU OpenVGUI', 'au_skeld cameras GUI open', function(payload)
		if not payload.cameraData then return end

		local base = vgui.Create('AmongUsVGUIBase')
		local panel = vgui.Create('DPanel')
		local width = 0.55 * ScrW()
		local height = 0.7 * ScrH()
		local margin = math.min(width, height) * 0.03
		panel:SetSize(width, height)
		panel:SetBackgroundColor(Color(64, 64, 64))

		for i = 0, 1 do
			local row = panel:Add('DPanel')
			row:SetTall(height/2)
			row:Dock(TOP)
			row.Paint = function() end

			for j = 1, 2 do
				local curCameraName = cameraOrder[(i * 2) + j]
				local curCamera = payload.cameraData[curCameraName]

				local camContainer = row:Add('DPanel')
				camContainer:SetWide(width/2)
				camContainer:Dock(LEFT)
				camContainer.Paint = function() end

				local cam = camContainer:Add('DPanel')
				cam:DockMargin(
					margin,
					i == 1 and 0 or margin,
					j == 1 and 0 or margin,
					i == 2 and 0 or margin
				)
				cam:Dock(FILL)

				if curCamera then
					function cam:Paint(w, h)
						-- XD
						oldHalo = halo.Render
						halo.Render = noop

						local x, y = self:LocalToScreen(0, 0)
						render.RenderView( {
							aspectratio = w/h,
							origin = curCamera.pos,
							angles = curCamera.angle,
							x = x,
							y = y,
							w = w,
							h = h,
							fov = 125,
							drawviewmodel = false,
						})

						halo.Render = oldHalo
					end
				else
					print('[?!?] Camera ' .. curCameraName .. ' missing from payload?')
					function cam:Paint(w, h)
						surface.SetDrawColor(Color(255, 0, 0))
						surface.DrawRect(0, 0, w, h)
					end
				end
			end
		end

		base:Setup(panel)
		base:Popup()

		GAMEMODE:HUD_OpenVGUI(base)

		return true
	end)
end
