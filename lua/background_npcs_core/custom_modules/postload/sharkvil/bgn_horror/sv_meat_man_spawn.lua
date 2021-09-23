local startPosDarkRoom = Vector( -3236, -2567, 205 )
local endPosDarkRoom = Vector( -5250, -1052, -168 )

local function InDarkRoom(vec)
	return vec:WithinAABox( startPosDarkRoom, endPosDarkRoom )
end

local function IsGmConstruct()
	return tobool( string.find( game.GetMap(), 'gm_construct' ) )
end

hook.Add('BGN_InitActor', 'BGN_SharkVil_Horror_MeatManSpawn', function(actor)
	if not actor or not actor:IsAlive() then return end

	local npc = actor:GetNPC()
	local npc_type = actor:GetType()

	if npc_type ~= 'meat_man' then return end

	npc:SetModel('models/Zombie/Classic.mdl')
	npc:SetRenderMode(RENDERMODE_TRANSCOLOR)
	npc:SetCollisionGroup(COLLISION_GROUP_WORLD)
	npc:SetMaterial('models/props_combine/prtl_sky_sheet')
	npc:SetColor( Color(255, 0, 0) )

	if not string.find( game.GetMap(), 'gm_construct' ) then
		npc:slibCreateTimer('actor_fade', math.random(10, 20), 1, function()
			if not actor or not actor:IsAlive() then return end
			npc:slibFadeRemove(2.5)
		end)
	end

	npc:slibCreateTimer('spectator_set_state_if_players_near', 0.5, 0, function()
		if not actor or not actor:IsAlive() then return end

		local npc_pos = npc:GetPos()
		local is_gm_construct = IsGmConstruct()

		if is_gm_construct and not InDarkRoom(npc_pos) then
			npc:slibFadeRemove(2.5)
			return
		end

		local enemies_exists = false
		local minDist = 1440000

		if not is_gm_construct then
			minDist = 490000
		end

		for _, ply in ipairs(player.GetAll()) do
			if ply:GetPos():DistToSqr(npc_pos) <= minDist and bgNPC:IsTargetRay(npc, ply) then
				actor:AddEnemy(ply)
				enemies_exists = true
			end
		end

		if enemies_exists and not actor:HasState('berserk') then
			actor:SetState('berserk')
		end
	end)
end)

hook.Add('BGN_PreHorrorRemove', 'BGN_HorrorDontRemoveMatMan', function(actor)
	if not actor or not actor:IsAlive() or actor:GetType() ~= 'meat_man' then return end
	return true
end)

hook.Add('BGN_OnValidSpawnActor', 'BGN_SpectatorSpawnOnlyDarkRoomInGmConstruct',
function(npc_type, _, _, spawnPos)
	if npc_type ~= 'meat_man' then return end
	if not IsGmConstruct() and math.random(0, 100) <= 30 then return true end
	if not InDarkRoom(spawnPos) then return true end
end)