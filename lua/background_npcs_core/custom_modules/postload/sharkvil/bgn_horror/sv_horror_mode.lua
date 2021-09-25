local cached_npcs_enabled = {}

local function CacheDefaultOptionsEnabled()
	for npc_type, data in pairs(bgNPC.cfg.npcs_template) do
		if data.team and not table.HasValueBySeq(data.team, 'horror') then

			if table.WhereHasValueBySeq(cached_npcs_enabled, function(_, value)
				return value.npc_type == npc_type
			end) then
				continue
			end

			local is_enabled = 0
			if bgNPC:IsActiveNPCType(npc_type) then
				is_enabled = 1
			end

			table.insert(cached_npcs_enabled, {
				npc_type = npc_type,
				enabled = is_enabled
			})

		end
	end
end

local function RemoveByType(npc_type)
	local actors =  bgNPC:GetAllByType(npc_type)
	local count = #actors
	if actors and count ~= 0 then
		for i = count, 1, -1 do
			local actor = actors[i]
			if actor and actor:IsAlive() then
				local npc = actor:GetNPC()
				bgNPC:RemoveNPC(npc)
				npc:Remove()
			end
		end
	end
end

local function ToggleMod( enabled )
	for npc_type, data in pairs(bgNPC.cfg.npcs_template) do
		local _, value = table.WhereFindBySeq(cached_npcs_enabled, function(_, value)
			return value.npc_type == npc_type
		end)

		if enabled then
			if data.team and table.HasValueBySeq(data.team, 'horror') then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '1')
			elseif value and value.enabled == 1 then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '0')
			end
		else
			if data.team and table.HasValueBySeq(data.team, 'horror') then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '0')
			elseif value and value.enabled == 1 then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '1')
			end
		end

		if value and value.enabled == 0 then
			RemoveByType(npc_type)
		end
	end
end

CacheDefaultOptionsEnabled()
ToggleMod( GetConVar('bgn_horror_mode_enable'):GetBool() )

cvars.AddChangeCallback('bgn_horror_mode_enable', function(_, _, new_cvar_value)
	ToggleMod( tobool( new_cvar_value ) )
	table.Empty(cached_npcs_enabled)
	CacheDefaultOptionsEnabled()
end)

hook.Add('BGN_OnValidSpawnActor', 'BGN_HorrorModdeLockSpawn', function(_, npcData, _, spawnPos)
	if not npcData.team or not GetConVar('bgn_horror_mode_enable'):GetBool() then return end

	for _, team_name in ipairs(npcData.team) do
		if team_name == 'horror' then return end
	end

	return true
end)