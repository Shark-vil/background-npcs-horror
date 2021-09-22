bgNPC:SetStateAction('spectator', 'calm', {
	update = function(actor, state, data)
		local npc = actor:GetNPC()
		if not IsValid(npc) then return end

		local target
		local oldDist

		for _, ply in ipairs(player.GetAll()) do
			if not target or ply:GetPos():DistToSqr(npc:GetPos()) < oldDist then
				target = ply
				oldDist = ply:GetPos():DistToSqr(npc:GetPos())
			end
		end

		if not IsValid(target) or target:GetPos():DistToSqr(npc:GetPos()) > 2560000
			or not bgNPC:IsTargetRay(npc, target)
		then
			actor:SetState('walk', nil, true)
			return
		end

		local npcAngle = npc:GetAngles()
		local npcRotation = (target:GetPos() - npc:GetPos()):Angle()
		local newAngle = Angle(npcAngle.x, npcRotation.y, npcAngle.z)
		npc:SetAngles( newAngle )
	end,
	not_stop = function(actor, state, data)
		return actor:EnemiesCount() == 0
	end
})