local IsValid = IsValid
local Vector = Vector
local Sound = Sound
local EmitSound = EmitSound
local math_random = math.random
local table_RandomBySeq = table.RandomBySeq
local player_GetAll = player.GetAll
--
local random_sounds_on_map = {'ambient/levels/streetwar/city_scream3.wav'}

timer.Create('BGN_AmbientRandomsSoundsOnMap', 30, 0, function()
	if math_random(0, 100) <= 5 then return end
	if not GetConVar('bgn_enable'):GetBool() then return end
	if not GetConVar('bgn_horror_mode_enable'):GetBool() then return end

	local players = player_GetAll()
	if #players == 0 then return end

	local ply = table_RandomBySeq(players)
	if not IsValid(ply) then return end

	local offset_x = math_random(-10000, 10000)
	local offset_y = math_random(-10000, 10000)
	local offset_z = math_random(-10000, 10000)
	local ply_pos = ply:GetPos()
	local sound_pos = Vector(ply_pos.x + offset_x, ply_pos.y + offset_y, ply_pos.z + offset_z)
	local snd = Sound(table_RandomBySeq(random_sounds_on_map))
	EmitSound(snd, sound_pos, 0, CHAN_AUTO, 1, 75, 0, 100)
end)