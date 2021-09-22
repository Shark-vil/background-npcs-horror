hook.Add('BGN_PostSpawnActor', 'BGN_SharkVil_Horror_SetNPCColor', function(npc, npc_type)
	if npc_type ~= 'ghost' then return end
	npc:SetRenderMode(RENDERMODE_TRANSCOLOR)
	npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
	npc:SetColor( Color(0, 0, 0, math.random(10, 100)) )
	npc:SetMaterial('models/props_pipes/Pipesystem01a_skin3')

	npc:slibCreateTimer('actor_fade', math.random(2, 10), 1, function()
		npc:slibFadeRemove(1.5)
	end)
end)