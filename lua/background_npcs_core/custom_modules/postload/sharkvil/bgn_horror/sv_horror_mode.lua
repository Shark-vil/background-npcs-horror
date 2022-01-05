local is_first_load = true

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

local cache_config_ambient = table.Copy(bgNPC.cfg.ambient)

local function ToggleMod( enabled )
	if enabled then
		bgNPC.cfg.ambient = {}
	else
		bgNPC.cfg.ambient = cache_config_ambient
	end

	for npc_type, data in pairs(bgNPC.cfg.npcs_template) do
		if enabled then
			if data.team and table.HasValueBySeq(data.team, 'horror') then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '1')
			else
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '0')
				RemoveByType(npc_type)
			end
		elseif not is_first_load then
			if data.team and table.HasValueBySeq(data.team, 'horror') then
				RunConsoleCommand('bgn_npc_type_' .. npc_type, '0')
				RemoveByType(npc_type)
			else
				local default = GetConVar('bgn_npc_type_' .. npc_type):GetDefault()
				RunConsoleCommand('bgn_npc_type_' .. npc_type, default)
			end
		end
	end
end

ToggleMod( GetConVar('bgn_horror_mode_enable'):GetBool() )
is_first_load = false

cvars.AddChangeCallback('bgn_horror_mode_enable', function(_, _, new_cvar_value)
	ToggleMod( tobool( new_cvar_value ) )
end)

hook.Add('BGN_OnValidSpawnActor', 'BGN_HorrorModdeLockSpawn', function(_, npcData, _, spawnPos)
	if not npcData.team or not GetConVar('bgn_horror_mode_enable'):GetBool() then return end

	for _, team_name in ipairs(npcData.team) do
		if team_name == 'horror' then return end
	end

	return true
end)