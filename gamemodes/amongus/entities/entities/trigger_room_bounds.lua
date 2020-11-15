-- Essentially just trigger_multiple but re-implemented so we can hook its StartTouch/EndTouch

AddCSLuaFile()

ENT.Base = 'base_entity'
ENT.Type = 'brush'

--- Update the internal player counter by some amount
-- Helper function; use in StartTouch/EndTouch handlers to avoid repetition
-- @param self The 'self' var from ENT:StartTouch/ENT:EndTouch
-- @param ent  The entity that was passed to ENT:StartTouch/ENT:EndTouch
-- @param incr How much to change the counter by
local function changeCounter(self, ent, incr)
	if not IsValid(ent) or not ent:IsPlayer() or ent:IsDead() then return end -- ignore non-players and ghosts
	self:SetCount(self:GetCount() + incr)
end

function ENT:StartTouch(other)
	changeCounter(self, other, 1)
end

function ENT:EndTouch(other)
	changeCounter(self, other, -1)
end

--- Adds a callback to this entity to be called when the counter changes
-- @param callback The callback function to call
function ENT:SetCountChangeCallback(callback)
	self.__countChangeCallback = callback
end

--- Gets the internal player counter for this room
-- @return The number of players in this room in range [0, #player.GetAll()]
function ENT:GetCount()
	return self.__count and self.__count or 0
end

--- Sets the internal player counter for this room
-- @param count The new counter value; negative values are clamped to 0
function ENT:SetCount(count)
	self.__count = count
	if not self.__count or self.__count < 0 then self.__count = 0 end
	-- May cause a spurious netmessage on meetings just before the UI closes... ¯\_(ツ)_/¯
	if self.__countChangeCallback then self.__countChangeCallback() end
end
