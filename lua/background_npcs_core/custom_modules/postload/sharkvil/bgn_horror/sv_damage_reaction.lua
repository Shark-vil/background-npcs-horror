hook.Add('BGN_PreReactionTakeDamage', 'BGN_HorrorEnemiesNotTakeDamage', function(attacker, target)
	local actor = bgNPC:GetActor(target)
	if not actor or not actor:HasTeam('horror') then return end

	local reaction = actor:GetLastReaction()
	if actor:EqualStateGroup('calm') and reaction ~= 'ignore' then
		actor:RemoveAllTargets()
		actor:SetState(reaction, nil, true)
	end

	actor:AddEnemy(attacker, reaction)
	hook.Run('BGN_PostReactionTakeDamage', attacker, target, reaction)

	timer.Simple(.1, function()
		if not IsValid(target) then return end
		target:RemoveAllDecals()
	end)

	return true
end)