bgNPC.cfg.ambient = {
	{ count = 1, sound = 'background_npcs/ambient/bgn_ambient_3.wav' },
}

local random_sounds_on_map = {
	'ambient/levels/streetwar/city_scream3.wav',
}

timer.Create('BGN_AmbientRandomsSoundsOnMap', 30, 0, function()
	if math.random(0, 100) <= 5 then return end
	local ply = table.RandomBySeq( player.GetAll() )
	local offset_x = math.random(-1000, 1000)
	local offset_y = math.random(-1000, 1000)
	local offset_z = math.random(-1000, 1000)
	local plyPos = ply:GetPos()
	local emitPos = Vector( plyPos.x + offset_x, plyPos.y + offset_y, plyPos.z + offset_z )
	local snd = Sound( table.RandomBySeq(random_sounds_on_map) )
	EmitSound(snd, emitPos, 0, CHAN_AUTO, 1, 75, 0, 100)
end)