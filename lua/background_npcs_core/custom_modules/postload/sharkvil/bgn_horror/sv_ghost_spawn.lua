local MinRemoveDistance = bgNPC.cfg.bgn_horror_options.MinRemoveDistance

hook.Add('BGN_InitActor', 'BGN_SharkVil_Horror_GhostSpawnOptions', function(actor)
	if not actor or not actor:IsAlive() then return end

	local npc = actor:GetNPC()
	local npc_type = actor:GetType()
	local phys = npc:GetPhysicsObject()

	if npc_type ~= 'ghost' then return end

	npc:SetRenderMode(RENDERMODE_TRANSCOLOR)
	if IsValid(phys) then phys:EnableCollisions(false) end
	npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
	npc:SetColor( Color(0, 0, 0, math.random(10, 150)) )
	npc:SetMaterial('models/props_pipes/Pipesystem01a_skin3')

	npc:slibCreateTimer('actor_fade', math.random(2, 10), 1, function()
		if not actor or not actor:IsAlive() then return end
		npc:slibFadeRemove(2.5)
	end)
end)

hook.Add('BGN_Horror_PlayerVisibleActor', 'BGN_GhostVisible', function(ply, dist, actor)
	if not actor or not actor:IsAlive() or actor:GetType() ~= 'ghost' then return end

	local npc = actor:GetNPC()
	local npc_pos = npc:GetPos()

	if (not ply:slibIsViewVector(npc_pos) or not bgNPC:IsTargetRay(npc, ply))
		and dist > MinRemoveDistance
	then
		return true
	end
end)