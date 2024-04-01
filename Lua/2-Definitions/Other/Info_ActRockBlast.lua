freeslot(
	-- Knuckles punch/explosion: Imported from jab patch
	"spr_pucn", "spr_ejab", "s_play_k_charge",
	"s_play_k_punchstart1", "s_play_k_punchstart2",
	"s_play_k_punchactive1", "s_play_k_punchrecovery",
	"s_jab_exploade",
	--"s_play_knuxfall", -- just so that way it wont print errors
	"mt_jabexploade",

	'spr_kdra',
	's_knuckles_drilldive1',
	's_knuckles_drilldive2',
	's_knuckles_drilldive3',
	's_knuckles_drilldive4',
	'spr_kdrb',
	's_knuckles_drillrise1',
	's_knuckles_drillrise2',
	's_knuckles_drillrise3',
	's_knuckles_drillrise4',
	'mt_rockblast',
	'mt_explodespwn', 's_explodespwn_state'
)
-- Knuckles Drill drive states
states[S_KNUCKLES_DRILLDIVE1] = {
	sprite = SPR_KDRA,
	frame = A
}

states[S_KNUCKLES_DRILLDIVE2] = {
	sprite = SPR_KDRA,
	frame = B
}

states[S_KNUCKLES_DRILLDIVE3] = {
	sprite = SPR_KDRA,
	frame = C
}

states[S_KNUCKLES_DRILLDIVE4] = {
	sprite = SPR_KDRA,
	frame = D
}

-- Knuckles drill rise states

states[S_KNUCKLES_DRILLRISE1] = {
	sprite = SPR_KDRB,
	frame = A
}

states[S_KNUCKLES_DRILLRISE2] = {
	sprite = SPR_KDRB,
	frame = B
}

states[S_KNUCKLES_DRILLRISE3] = {
	sprite = SPR_KDRB,
	frame = C
}

states[S_KNUCKLES_DRILLRISE4] = {
	sprite = SPR_KDRB,
	frame = D
}

-- Knuckles charging a punch
states[S_PLAY_K_CHARGE] = { -- active 35 total
	--sprite = SPR_PUCN,
	sprite = SPR_PLAY,
	--frame = A,
	frame = A|SPR2_MLEE,
	tics = -1,
	action = none,
	var1 = 0,
	var2 = 0,
	nextstate = S_PLAY_K_CHARGE
}

-- Knuckles punch states
states[S_PLAY_K_PUNCHSTART1] = { -- start punch 1
	sprite = SPR_PLAY,
	--frame = A|SPR2_WALK,
	frame = A|SPR2_TWIN,
	tics = 7,
	action = none,
	var1 = 0,
	var2 = 3,
	nextstate = S_PLAY_K_PUNCHSTART2
}
states[S_PLAY_K_PUNCHSTART2] = { -- start punch 15total
	sprite = SPR_PLAY,
	--frame = A|SPR2_WALK,
	frame = A|SPR2_TWIN,
	tics = 8,
	action = none,
	var1 = 0,
	var2 = 3,
	nextstate = S_PLAY_K_PUNCHACTIVE1
}

states[S_PLAY_K_PUNCHACTIVE1] = { -- active 35 total
	sprite = SPR_PLAY,
	frame = A|SPR2_MLEL,
	tics = 10,
	action = none,
	var1 = 0,
	var2 = 3,
	nextstate = S_PLAY_K_PUNCHRECOVERY
 }

states[S_PLAY_K_PUNCHRECOVERY] = { --40 total
	sprite = SPR_PLAY,
	frame = A|SPR2_EDGE,
	tics = 15,
	action = none,
	var1 = 0,
	var2 = 3,
	nextstate = S_PLAY_WALK
 }

states[S_JAB_EXPLOADE] = { -- punch hit box and effect
	--sprite = SPR_EJAB,
	sprite = SPR_BARX,
	frame = FF_ANIMATE|FF_FULLBRIGHT|FF_TRANS10|A,
	tics = 11,
	action = none,
	var1 = 10,
	var2 = 2,
	nextstate = S_NULL
}

-- Explosion spawner
states[S_EXPLODESPWN_STATE] = {
	sprite = SPR_NULL,
	frame = A,
	tics = 10,
	var1 = 0,
	var2 = 0,
	nextstate = S_NULL
}

//Knuckles' Debris
mobjinfo[MT_ROCKBLAST] = {
	spawnstate = S_ROCKCRUMBLEA,
	spawnhealth = 1000,
	radius = 8*FRACUNIT,
	height = 16*FRACUNIT,
	mass = 0,
	damage = 0,
	flags = MF_MISSILE|MF_BOUNCE|MF_GRENADEBOUNCE
}

-- Punch projectile
mobjinfo[MT_JABEXPLOADE] = {
	doomednum = -1,
	spawnhealth = 1,
	spawnstate = S_JAB_EXPLOADE,
	radius = 40*FRACUNIT,
	height = 40*FRACUNIT,
	damage = 1,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT
}

mobjinfo[MT_EXPLODESPWN] = {
	spawnstate = S_EXPLODESPWN_STATE,
	height = 48*FRACUNIT,
	damage = 1,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT
}
