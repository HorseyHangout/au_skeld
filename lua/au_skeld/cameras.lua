
if SERVER then
	-- Entity targetname for the button which opens cameras
	local BUTTON_NAME = 'camera_button'
	-- VGUI state name to use
	local VGUI_NAME = 'securityCams'
	-- Entity targetname for the physical camera props
	local PROP_NAME = 'security_cam'
	-- Prefix of the entity targetname for the invisible camera viewpoints
	-- Not positioned exactly at the security_cam props to allow more viewpoint flexibility
	local VIEWPOINT_NAME_PREFIX = 'camera_viewpoint_'

	local playersOnCameras = {}

	local function getCameraViewpointEnts()
		local cameraData = {}

		for i, v in ipairs(ents.GetAll()) do
			if IsValid(v) and string.sub(v:GetName(), 1, string.len(VIEWPOINT_NAME_PREFIX)) == VIEWPOINT_NAME_PREFIX then
				local viewpointName = string.sub(v:GetName(), string.len(VIEWPOINT_NAME_PREFIX) + 1)
				cameraData[viewpointName] = {
					pos   = v:GetPos(),
					angle = v:GetAngles()
				}
			end
		end

		return cameraData
	end

	local function updateCameraModels()
		local numPlayersOnCams = 0

		for _, v in pairs(playersOnCameras) do
			if v then
				numPlayersOnCams = numPlayersOnCams + 1
			end
		end

		for i, v in ipairs(ents.FindByName(PROP_NAME)) do
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

		GAMEMODE:Player_OpenVGUI(playerTable, VGUI_NAME, payload, function()
			playersOnCameras[playerTable] = false
			updateCameraModels()
		end)
	end

	-- Debugging command. Ignore.
	-- concommand.Add('au_debug_open_cameras', openCameras)

	hook.Add('PlayerUse', 'au_skeld cameras monitor use', function (ply, ent)
		if ent:GetName() == BUTTON_NAME then
			openCameras(ply)
		end
	end)

	hook.Add('SetupPlayerVisibility', 'au_skeld cameras add PVS', function (ply, viewEnt)
		if ply:GetCurrentVGUI() ~= VGUI_NAME then return end -- player not on cams
		if GAMEMODE:GetCommunicationsDisabled() then return end

		for k, v in pairs(getCameraViewpointEnts()) do
			AddOriginToPVS(v.pos)
		end
	end)

	hook.Add('GMAU GameStart', 'au_skeld cameras cleanup', function ()
		playersOnCameras = {}
		updateCameraModels()
	end)

	local function fixupUseHighlight()
		local ent = ents.FindByName(BUTTON_NAME)[1]
		if IsValid(ent) then
			GAMEMODE:SetUseHighlight(ent, true)
			ent:SetNWBool('au_skeld_IsCameraButton', true)
		end
	end

	hook.Add('InitPostEntity', 'au_skeld VGUI_NAME button highlight', fixupUseHighlight)
	hook.Add('PostCleanupMap', 'au_skeld VGUI_NAME button highlight', fixupUseHighlight)
else
	local noop = function() end
	local cameraOrder = {
		'navigation',   'admin',
		'upper_engine', 'security',
	}
	local noiseMat = Material('au_skeld/gui/noise.png')
	local buttonMat = Material('au_skeld/gui/security_button.png')
	local noiseColor = Color(189, 247, 224)
	local colorRed = Color(255, 0, 0)
	local noiseScrollSpeed = 100
	local flashSpeed = 150

	surface.CreateFont('au_skeld comms', {
		font = 'Lucida Console',
		size = ScreenScale(15),
		weight = 400,
		outline = true,
	})

	local function _(str)
		return GAMEMODE.Lang.GetEntry(str)()
	end

	hook.Add('GMAU UseButtonOverride', 'au_skeld cameras use button', function (ent)
		if ent:GetNWBool('au_skeld_IsCameraButton') then return buttonMat end
	end)

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
						local x, y = self:LocalToScreen(0, 0)

						local oldHalo = halo.Render
						halo.Render = noop
						
						if not GAMEMODE:GetCommunicationsDisabled() then
							render.RenderView {
								aspectratio = w/h,
								origin = curCamera.pos,
								angles = curCamera.angle,
								x = x,
								y = y,
								w = w,
								h = h,
								fov = 125,
								drawviewmodel = false,
							}
						else
							-- comms disabled, show noise and flashing text
							surface.SetMaterial(noiseMat)
							local time = SysTime() * noiseScrollSpeed
							render.PushFilterMin(TEXFILTER.LINEAR)
							render.PushFilterMag(TEXFILTER.LINEAR)
							surface.SetDrawColor(noiseColor)
							surface.DrawTexturedRectUV(
								0, 0, w, h,
								time % 1,         0,
								(time + w/h) % 1, 1
							)
							render.PopFilterMag()
							render.PopFilterMin()

							if time % flashSpeed < flashSpeed/2 then
								draw.SimpleText('[' .. string.upper(_('tasks.commsSabotaged')) .. ']', 'au_skeld comms', w/2, h/2, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
						end

						halo.Render = oldHalo
					end
				else
					print('[?!?] Camera ' .. curCameraName .. ' missing from payload?')
					function cam:Paint(w, h)
						surface.SetDrawColor(colorRed)
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
