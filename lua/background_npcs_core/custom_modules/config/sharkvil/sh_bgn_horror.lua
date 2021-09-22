bgNPC.cfg.npcs_template = {
	['ghost'] = {
		enabled = true,
		class = 'npc_citizen',
		name = 'Souls of dead players',
		fullness = 100,
		team = { 'souls' },
		health = 1000,
		at_random = {
			['walk'] = 80,
			['idle'] = 10,
			['sit_to_chair'] = 10,
		},
		at_damage = {
			['disappearance'] = 100,
		},
		at_protect = {
			['disappearance'] = 100,
		}
	},
	['spectator'] = {
		enabled = true,
		class = 'npc_gman',
		name = 'Spectator',
		limit = 1,
		team = { 'secret_department' },
		health = 1000,
		at_random = {
			['walk'] = 100,
		},
		at_damage = {
			['disappearance'] = 100,
		},
		at_protect = {
			['ignore'] = 100,
		}
	},
	['meat_man'] = {
		enabled = true,
		class = 'npc_stalker',
		name = 'Meat man',
		limit = 1,
		team = { 'anomaly' },
		health = 1000,
		at_random = {
			['walk'] = 100,
		},
		at_damage = {
			['berserk'] = 100,
		},
		at_protect = {
			['ignore'] = 100,
		}
	}
}