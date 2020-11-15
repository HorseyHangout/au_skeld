-- Essentially just trigger_multiple but re-implemented so we can hook its StartTouch/EndTouch

AddCSLuaFile()

ENT.Base = 'base_brush'
ENT.Type = 'brush'

function ENT:StartTouch(other)
	if not IsValid(other) or not other:IsPlayer() then return end
	self.__count = (self.__count and self.__count or 0) + 1
	if self.__countChangeCallback then self.__countChangeCallback() end
end

function ENT:EndTouch(other)
	if not IsValid(other) or not other:IsPlayer() then return end
	self.__count = (self.__count and self.__count - 1 or 0)
	if self.__countChangeCallback then self.__countChangeCallback() end
end

function ENT:SetCountChangeCallback(callback)
	self.__countChangeCallback = callback
end

function ENT:GetCount()
	return self.__count
end
