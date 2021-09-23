timer.Create('BGN_SharkVil_Horror_AutoRemove_IfPlayerNear', 1, 0, function()
	local actors = bgNPC:GetAll()
	local players = player.GetAll()

	for _, actor in ipairs(actors) do
		if actor and actor:IsAlive() and actor:HasTeam('horror') then
			local npc = actor:GetNPC()
			local is_remove = false

			if npc.slibIsFadeRemove or hook.Run('BGN_PreHorrorRemove', actor) then
				continue
			end

			local npc_pos = npc:GetPos()
			for _, ply in ipairs(players) do
				local plyDist = ply:GetPos():DistToSqr(npc_pos)
				if IsValid(ply) and ply:Alive()
					and not hook.Run('BGN_Horror_PlayerVisibleActor', ply, plyDist, actor)
				then
					is_remove = true
				end
			end

			if is_remove and not hook.Run('BGN_HorrorOnRemove', actor) then
				npc:slibFadeRemove(2.5)
			end
		end
	end
end)