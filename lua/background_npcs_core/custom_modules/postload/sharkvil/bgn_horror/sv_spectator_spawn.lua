local MinRemoveDistance = bgNPC.cfg.bgn_horror_options.MinRemoveDistance
local MaxRemoveDistance = bgNPC.cfg.bgn_horror_options.MaxRemoveDistance

local specific_spawns = {
	{ vec = Vector( 733, -1055, 320 ), ang = Angle( 29, 122, 0 ) },
	{ vec = Vector( -2591, -2268, 1344 ), ang = Angle( 26, 39, 0 ) },
	{ vec = Vector( -4324, 4649, 608 ), ang = Angle( 17, -59, 0 ) },
	{ vec = Vector( -2593, -2267, 1216 ), ang = Angle( 31, 47, 0 ) }
}

hook.Add('BGN_InitActor', 'BGN_SharkVil_Horror_SetSpectator', function(actor)
	if not actor or not actor:IsAlive() then return end

	local npc = actor:GetNPC()
	local npc_type = actor:GetType()

	if npc_type ~= 'spectator' then return end

	npc:SetRenderMode(RENDERMODE_TRANSCOLOR)
	npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
	npc:SetColor( Color(0, 0, 0) )

	npc:slibCreateTimer('actor_fade', math.random(10, 20), 1, function()
		npc:slibFadeRemove(2.5)
	end)

	if string.find( game.GetMap(), 'gm_construct' ) and math.random(0, 100) <= 50 then
		local specific_location = table.RandomBySeq( specific_spawns )
		local balconyPos = specific_location.vec
		local balconyAng = specific_location.ang
		local trueSpawn = true

		for _, ply in ipairs(player.GetAll()) do
			if ply:GetPos():DistToSqr(balconyPos) <= 490000 and ply:slibIsViewVector(balconyPos) then
				trueSpawn = false
				break
			end
		end

		if trueSpawn then
			npc:SetPos( balconyPos )
			npc:SetAngles( balconyAng )
			npc:PhysWake()
			npc:slibCreateTimer('spectator_set_state_if_players_near', 0.5, 0, function()
				if not actor or not actor:HasState('walk') then return end
				actor:SetState('spectator')
			end)
			return
		end
	end

	npc:slibCreateTimer('spectator_set_state_if_players_near', 0.5, 0, function()
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

hook.Add('BGN_Horror_PlayerVisibleActor', 'BGN_SpectatorVisible', function(ply, dist, actor)
	if not actor or not actor:IsAlive() or actor:GetType() ~= 'spectator' then return end

	local npc = actor:GetNPC()
	local npc_pos = npc:GetPos()

	if dist > MinRemoveDistance or (dist <= MaxRemoveDistance and not ply:slibIsViewVector(npc_pos)) then
		return true
	end

	ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 1.5)
	ply:SendLua([[ surface.PlaySound('doors/garage_stop1.wav') ]])
end)

hook.Add('BGN_HorrorOnRemove', 'BGN_SpectatorRemove', function(actor)
	if not actor or not actor:IsAlive() or actor:GetType() ~= 'spectator' then return end

	local npc = actor:GetNPC()
	npc:Remove()

	return true
end)