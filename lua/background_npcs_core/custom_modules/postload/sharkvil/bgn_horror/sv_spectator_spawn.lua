hook.Add('BGN_PostSpawnActor', 'BGN_SharkVil_Horror_SetSpectator', function(npc, npc_type)
	if npc_type ~= 'spectator' then return end
	npc:SetRenderMode(RENDERMODE_TRANSCOLOR)
	npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
	npc:SetColor( Color(0, 0, 0) )

	npc:slibCreateTimer('actor_fade', math.random(10, 20), 1, function()
		npc:slibFadeRemove(1.5)
	end)

	if string.find( game.GetMap(), 'gm_construct' ) and math.random(0, 100) <= 50 then
		local balconyPos = Vector( 733, -1055, 320 )
		local trueSpawn = true

		for _, ply in ipairs(player.GetAll()) do
			if ply:GetPos():DistToSqr(balconyPos) <= 490000 and ply:slibIsViewVector(balconyPos) then
				trueSpawn = false
				break
			end
		end

		if trueSpawn then
			local balconyAng = Angle( 29, 122, 0 )
			npc:SetPos( balconyPos )
			npc:SetAngles( balconyAng )
			npc:PhysWake()
			npc:slibCreateTimer('spectator_set_state_if_players_near', 0.5, 0, function()
				local actor = bgNPC:GetActor(npc)
				if not actor or not actor:HasState('walk') then return end
				actor:SetState('spectator')
			end)
			return
		end
	end

	npc:slibCreateTimer('spectator_set_state_if_players_near', 0.5, 0, function()
		local actor = bgNPC:GetActor(npc)
		if not actor or not actor:HasState('walk') then return end

		local npc_pos = npc:GetPos()

		for _, ply in ipairs(player.GetAll()) do
			if ply:GetPos():DistToSqr(npc_pos) <= 2250000 and bgNPC:IsTargetRay(npc, ply) then
				actor:SetState('spectator')
				break
			end
		end
	end)
end)