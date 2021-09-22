local ignore_actors = { 'meat_man' }

timer.Create('BGN_SharkVil_Horror_AutoRemove_IfPlayerNear', 1, 0, function()
	local actors = bgNPC:GetAll()
	local players = player.GetAll()
	local maxDist = 360000
	local minDist = 250000

	for _, actor in ipairs(actors) do
		if actor and actor:IsAlive() and actor:HasTeam('horror')
			and not table.HasValueBySeq(ignore_actors, actor:GetType())
		then
			local npc = actor:GetNPC()
			local is_remove = false

			if npc.slibIsFadeRemove then
				continue
			end

			local npc_pos = npc:GetPos()
			for _, ply in ipairs(players) do
				local plyDist = ply:GetPos():DistToSqr(npc_pos)
				if IsValid(ply) and plyDist <= minDist or (plyDist <= maxDist and ply:slibIsViewVector(npc_pos)) then
					if actor:GetType() == 'spectator' then
						ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 1.5)
						ply:SendLua([[ surface.PlaySound('doors/garage_stop1.wav') ]])
					end
					is_remove = true
				end
			end

			if is_remove then
				if actor:GetType() == 'spectator' then
					npc:Remove()
				else
					npc:slibFadeRemove(2.5)
				end
			end
		end
	end
end)