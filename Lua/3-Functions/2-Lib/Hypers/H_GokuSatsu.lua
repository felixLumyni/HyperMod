local HM = hypermod

HM.GokuSatsu = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		mo.satsuing = TICRATE*3
		S_StartSound(mo, sfx_tatsu)
	end
end

--it is what it is
HM.DoGokuSatsu = function()
	for player in players.iterate do
		local mo = player.mo
		if not HM.valid(mo) then
			return
		end
		if HM.higherthan(mo.satsuing, 0) then
			local g = P_SpawnGhostMobj(mo)
			if HM.valid(g.tracer) then
				g.tracer.tics = $/2
			end
			mo.satsuing = $-1
			player.sp = min(99,mo.satsuing*9/10)
			player.powers[pw_sneakers] = max($, mo.satsuing)
		end
		if HM.higherthan(mo.satsugrabbed, 0)
		or HM.higherthan(mo.satsugrabbing, 0)
		or HM.higherthan(mo.satsuer, 0)
		then
			player.powers[pw_flashing] = 2
			mo.state = mo.satsugrabbed and S_PLAY_PAIN or S_PLAY_SKID
			mo.momx = 0
			mo.momy = 0
			mo.momz = 0
			player.cmd.buttons = 0
			player.cmd.forwardmove = 0
			player.cmd.sidemove = 0
			mo.satsugrabbed = $ and $-1 or 0
			if not(mo.satsugrabbed or mo.satsugrabbing or mo.satsuer) then
				mo.satsued = $ and $ or 2*TICRATE
			end
			mo.satsugrabbing = $ and $-1 or 0
			if mo.satsugrabbing == 1 then
				mo.satsuer = $ and $ or 2*TICRATE
			end
			mo.satsuer = $ and $-1 or 0
		end
		if HM.higherthan(mo.satsued, 0) then
			local sounds = {sfx_s3k6e, sfx_s3kaa, sfx_s3k49}
			local sound = sounds[P_RandomRange(1, #sounds)]
			S_StartSound(mo, sound)
			mo.satsued = $-1
			if not mo.satsued then
				player.powers[pw_flashing] = 0
				player.lives = 1
				P_DamageMobj(mo, nil, nil, 999, DMG_INSTAKILL)
				S_StartSound(nil, sfx_bsnipe)
			end
		end
	end
end
addHook("PreThinkFrame", HM.DoGokuSatsu)

HM.DoGokuSatsu2 = function(mo1, mo2)
	if mo1.satsuing
	and mo2.player 
	and not (mo2.satsugrabbed or mo2.satsued or mo1.satsuer or mo2.state == S_PLAY_DEAD)
	then
		if not (mo2.player.ctfteam == player.ctfteam and gametyperules & GTR_TEAMS) then
			S_StartSound(mo1, sfx_s3k4a)
			mo2.satsugrabbed = TICRATE/2
			mo1.satsugrabbing = mo2.satsugrabbed
			return false
		end
	end
end
addHook("MobjCollide", HM.DoGokuSatsu2)

assert(hudobjs != nil, "Could not find hudobjs table!")

local n = 1
HM.random = function()
	n = ($ * 3 + 1) % 65535
	return n
end

HM.punch = function(v)
	local _momx = HM.random() % 8 - 3
	local _momy = HM.random() % 8 - 3
	local _scale = (HM.random() % 8 + 1) * FRACUNIT / 6
	table.insert(hudobjs, {
		drawtype = "sprite",
		string = "BARX",
		frame = 1|FF_ANIMATE,
		animlength = 8,
		animspeed = 4,
		animloop = false,
		flags = V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER,
		x = FRACUNIT * (180+v.RandomRange(-180,180)),
		y = FRACUNIT * (140+v.RandomRange(-140,140)),
		momy = _momx * FRACUNIT,
		momx = _momy * FRACUNIT,
		friction = FRACUNIT * 7 / 8,
		scale = _scale,
		skin = TC_RAINBOW,
		color = SKINCOLOR_GREY
	})
end

table.insert(hudobjs, {
-- 	drawtype = "nametag",
-- 	scale = FRACUNIT/4,
-- 	color = SKINCOLOR_BLUE,
-- 	color2 = SKINCOLOR_YELLOW,
	string = "",
	flags = V_SNAPTOBOTTOM,
	align = "right",
	x = 160,
	player = nil,
	rings = nil,
	func = function(v, player, cam, obj)
		if HM.valid(player.mo) and (player.mo.satsued or player.mo.satsuer) then
			HM.punch(v)
		end
	end,
})