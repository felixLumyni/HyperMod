local HM = hypermod

HM.ChaosControl = function(player)
	local mo = player.mo
	if not HM.valid(mo) then
		return
	end
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		HM.zawarudomaker = mo
		HM.zawarudo = 9*TICRATE --9 seconds... get it guys??
		for p in players.iterate do
			-- store momentum for when its joever
			if HM.valid(p.mo) then
				p.mo.smomx = p.mo.momx
				p.mo.smomy = p.mo.momy
				p.mo.smomz = p.mo.momz
				p.storedexhaustmeter = p.exhaustmeter or 0
				p.storedfly = p.powers[pw_tailsfly]
			end
		end
		S_StartSound(nil, sfx_tstp)
		player.sp = 89
		player.futuresp = -player.sp
	end
end

local restoremomentum = function()
	for p in players.iterate do
		if HM.valid(p.mo) and not (p.mo == HM.zawarudomaker) then
			p.mo.momx = p.mo.smomx or 0
			p.mo.momy = p.mo.smomy or 0
			p.mo.momz = p.mo.smomz or 0
		end
	end
end

--ah, just one more hook, what could possibly-
HM.DoChaosControl = function()
	if HM.higherthan(HM.zawarudo, 0) then
		if not HM.valid(HM.zawarudomaker) then
			HM.zawarudo = 0
			HM.zawarudomaker = nil
			restoremomentum()
			stoppedclock = false
		else
			HM.zawarudo = max(0,$-1)
			stoppedclock = true
			if not HM.zawarudo then
				restoremomentum()
				stoppedclock = false
				HM.zawarudomaker = nil
			end
		end
		for p in players.iterate do
			if HM.valid(p.mo) and not (p.spectator or p.mo == HM.zawarudomaker) then
				p.cmd.buttons = 0
				p.cmd.forwardmove = 0
				p.cmd.sidemove = 0
				p.exhaustmeter = p.storedexhaustmeter or 0
				p.powers[pw_tailsfly] = p.storedfly or 0
			end
			--P_FlashPal(p, PAL_INVERT, 5)
		end
	end
end
addHook("PreThinkFrame", HM.DoChaosControl)

--oh my god. is this a global mobjthinker hook??
--what on earth am i thinking?
HM.DoChaosControl2 = function(mo)
	return (HM.valid(mo) and HM.higherthan(HM.zawarudo, 0) and not(mo == HM.zawarudomaker))
end
addHook("MobjThinker", HM.DoChaosControl2)

HM.DoChaosControl3 = function(mo)
	if HM.valid(mo) and HM.higherthan(HM.zawarudo, 0) and not(mo == HM.zawarudomaker) then
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
	end
end
addHook("MobjThinker", HM.DoChaosControl3, MT_PLAYER)

HM.shadowhud = function(v, player, cam)
	if HM.higherthan(HM.zawarudo, 0) then
		local x = 160
		local y = 176
		local flags = V_SNAPTOBOTTOM|V_HUDTRANSHALF
		local color = (HM.zawarudomaker and HM.zawarudomaker.player) and HM.zawarudomaker.player.skincolor or SKINCOLOR_BLACK
		v.drawScaled((x-15)*FRACUNIT, (y-20)*FRACUNIT, FRACUNIT/4, v.cachePatch("RECCLOCK"), flags, v.getColormap(TC_RAINBOW, color))
		v.drawNum(x, y, HM.zawarudo/TICRATE, nil, "center")
	end
end
hud.add(HM.shadowhud, "game")