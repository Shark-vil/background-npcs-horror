bgNPC:SetStateAction('berserk', 'danger', {
	update = function(actor, state, data)
		local enemy = actor:GetNearEnemy()
		local npc = actor:GetNPC()

		if not IsValid(enemy) or not bgNPC:IsTargetRay(npc, enemy) then
			actor:SetState('walk', nil, true)
			return
		end

		data.direction = npc:GetPos() - enemy:GetPos()
		data.delay = data.delay or 0

		if not npc:slibExistsTimer('meatman_punch_enemy') then
			npc:slibCreateTimer('meatman_punch_enemy', 0.2, 0, function()
				if not actor or not actor:HasState('berserk') then
					npc:slibRemoveTimer('meatman_punch_enemy')
					return
				end

				local nearEnemy = actor:GetNearEnemy()
				if not IsValid(nearEnemy) or not nearEnemy:IsPlayer() then
					npc:slibRemoveTimer('meatman_punch_enemy')
					return
				end

				local angle_punch_pitch = math.Rand(-5, 5)
				local angle_punch_yaw = math.sqrt(5 * 5 - angle_punch_pitch * angle_punch_pitch)
				if math.random(0, 1) == 1 then
					angle_punch_yaw = angle_punch_yaw * -1
				end
				nearEnemy:ViewPunch(Angle(angle_punch_pitch, angle_punch_yaw, 0))
				nearEnemy:SetVelocity(data.direction * .5)
			end)
		end

		local lower_distance = enemy:GetPos():DistToSqr( npc:GetPos() ) <= 250000

		if lower_distance or math.random(0, 100) < 50 then
			enemy:EmitSound( 'physics/flesh/flesh_bloody_break.wav' )
			if lower_distance then
				enemy:TakeDamage( math.random(40, 60), npc, npc )
			else
				enemy:TakeDamage( math.random(5, 20), npc, npc )
			end
			enemy:SetVelocity(data.direction * .10)
		end

		if data.delay < CurTime() then
			actor:WalkToTarget(enemy, 'run')
			data.delay = CurTime() + 3
		end
	end,
	not_stop = function(actor, state, data, new_state, new_data)
		return actor:EnemiesCount() > 0 and not actor:HasStateGroup(new_state, 'danger')
	end
})