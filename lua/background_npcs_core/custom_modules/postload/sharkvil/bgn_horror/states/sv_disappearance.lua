bgNPC:SetStateAction('disappearance', 'calm', {
	start = function(actor, state, data)
		local npc = actor:GetNPC()
		if not IsValid(npc) then return end
		npc:slibFadeRemove(1.5)
	end,
	not_stop = function(actor, state, data)
		return actor:EnemiesCount() == 0
	end
})