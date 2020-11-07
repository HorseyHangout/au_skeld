-- return -- temporarily disable

if GAMEMODE.Name ~= "Among Us" then return end

if SERVER then
	util.AddNetworkString("au_skeld cameras open")

	hook.Add("PlayerUse", "au_skeld cameras monitor use", function(ply, ent)
		if ent:GetName() == "camera_button" then
			-- This isn't particularly nice, I know.
			-- I just don't have any fancy wrappers yet.
			local playerTable = GAMEMODE.GameData.Lookup_PlayerByEntity[ply]
			if not playerTable then
				return
			end

			local cameraPoint = ents.FindByName("camera_viewpoint_navigation")[1]

			local payload = {
				cameraData = {
					position = cameraPoint:GetPos(),
					angle = cameraPoint:GetAngles()
				}
			}
			GAMEMODE:Player_OpenVGUI(playerTable, "cameraTest", payload) 
		end
	end)
else
	local noop = function() end

	hook.Add("GMAU OpenVGUI", "au_skeld cameras GUI open", function(payload)
		if not payload.cameraData then
			return
		end

		local position = payload.cameraData.position
		local angle = payload.cameraData.angle

		local base = vgui.Create("AmongUsVGUIBase")
		local panel = vgui.Create("DPanel")

		size = 0.7 * math.min(ScrW(), ScrH())
		panel:SetSize(size, size)
		panel:SetBackgroundColor(Color(64, 64, 64))

		insetPanel = panel:Add("DPanel")
		insetPanel:DockMargin(size * 0.03, size * 0.03, size * 0.03, size * 0.03)
		insetPanel:Dock(FILL)

		insetPanel.Paint = function(_, w, h)
			-- XD
			oldHalo = halo.Render
			halo.Render = noop

			local x, y = _:LocalToScreen(0, 0)
			render.RenderView( {
				aspectratio = w/h,
				origin = position,
				angles = angle,
				x = x,
				y = y,
				w = w,
				h = h,
				fov = 75,
				drawviewmodel = false,
				ortho = {
					top = -275,
					bottom = 275,
					left = -250,
					right = 250,
				},
			})

			halo.Render = oldHalo
		end

		base:Setup(panel)
		base:Popup()

		GAMEMODE:HUD_OpenVGUI(base)

		return true
	end)
end