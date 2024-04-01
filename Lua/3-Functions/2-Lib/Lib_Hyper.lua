local HM = hypermod
local S = HM.SkinVars

HM.PlayerSpawn = function(player)
	player.usedspecial = 0
	player.futuresp = player.sp and -player.sp/2 or 0
end
addHook("PlayerSpawn", HM.PlayerSpawn)

HM.doSpecialVfx = function(player)
	player.mo.state = S_PLAY_SPECIAL
	
	local px, py, pz = player.realmo.x, player.realmo.y, player.realmo.z + (player.realmo.height/2)
	local rad = player.realmo.scale*256
	for n = 0, 7 do
		P_SpawnParaloop(px, py, pz, rad, 16, MT_SUPERSPARK, n*ANGLE_22h, nil, true)
	end
end

HM.PlayerThink = function(player)
	player.sp = $ or 0
	if player.futuresp then
		local smoothness = 2
		local minimum = (player.futuresp < 0) and -1 or 1
		local nextframe = player.futuresp/smoothness or minimum
		player.futuresp = $-nextframe
		player.sp = $+nextframe
		if player.sp <= 0 then
			player.futuresp = 0
			player.sp = 0
		end
	end
	if HM.valid(player.mo) then
		local func = S[player.mo.skin] and S[player.mo.skin].hyper or S[-1].hyper
		if func then func(player) end

		if player.sp >= 100 and player.sp_history < 100 then
			S_StartSound(player.realmo, sfx_ready)
		end

		local pressing = (player.cmd.buttons & BT_WEAPONNEXT) or (player.cmd.buttons & BT_WEAPONPREV)

		if pressing and player.sp >= 100 then
			player.sp = $-100
			player.usedspecial = 1
			local voice = S[player.mo.skin] and S[player.mo.skin].warcry or S[-1].warcry
			if voice and type(voice) == "table" and #voice then
    			voice = voice[P_RandomRange(1, #voice)]
			end
			if voice then S_StartSound(player.realmo, voice) end
			local auxsounds = S[player.mo.skin] and S[player.mo.skin].auxsounds or S[-1].auxsounds
			if auxsounds then
				for sound=1, #auxsounds do
					S_StartSound(player.realmo, auxsounds[sound])
				end
			end
			player.powers[pw_nocontrol] = states[S_PLAY_SPECIAL].tics
			HM.doSpecialVfx(player)
			--show everyone you are special in the HUD!
			HM.specialplayer = player
		end
		
		--STOP MOVING!! GRAH (also free godmode, youre welcome)
		if player.mo.state == S_PLAY_SPECIAL then
			player.pflags = $ | (PF_FULLSTASIS | PF_GODMODE)
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
		else
			player.pflags = $ &~ (PF_FULLSTASIS | PF_GODMODE)
		end
	end
	--history (for recharge detection)
	player.sp_history = player.sp
end
addHook("PlayerThink", HM.PlayerThink)

local barColor, specialStatus, specialColor
local charDisplayX, charDisplayY, displaySpeed = 0
local commonFlags = V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANSDOUBLE

HM.specialMeter = function(d, p)
	if not HM.valid(p) then
		return
	end
	--sp meter
	if p.sp != nil and not p.spectator then
		if p.sp >= 100 and not (leveltime % 3 == 0) then
			barColor = 129
		else
			barColor = 130
		end
		local x=82
		local y= (CBW_Battle and CBW_Battle.Arena and CBW_Battle.Arena.MyStocksHUD) and 198 or 186
		local meter = (HM.valid(p.mo) and p.mo.state == S_PLAY_SPECIAL) and 100 or p.sp
		local width = (CBW_Battle and CBW_Battle.Arena and CBW_Battle.Arena.MyStocksHUD) and 3 or 8
		d.drawFill(x, y-0, 100/2, width*3/4, commonFlags|138)
		d.drawFill(x, y-1, 100/2, width/4, commonFlags|139)
		d.drawFill(x, y-0, meter/2, width*3/4, commonFlags|barColor+1)
		d.drawFill(x, y-1, meter/2, width/4, commonFlags|barColor)
		
		--hyper is ready!
		if p.sp and p.sp >= 100 then specialStatus = "PREV + NEXT!" else specialStatus = "" end
		if (leveltime % 3 == 0) then specialColor = V_SKYMAP else specialColor = 0 end
		d.drawString(x, y-9, specialStatus, commonFlags|specialColor, "thin")
	end
	
	--fix it looking extra funny in pauses and multiplayer
	if paused or not (p == displayplayer) then return end

	--screen tint during special
	local specialplayer = HM.specialplayer
	if HM.valid(specialplayer) and HM.valid(specialplayer.mo) and specialplayer.mo.state == S_PLAY_SPECIAL then
		local color = d.getColormap(nil, specialplayer.skincolor)
		if (leveltime % 3 == 0) then
			d.drawScaled(0, -40*FRACUNIT, 82033, d.cachePatch("BGA0"), V_70TRANS|V_SNAPTOLEFT|V_SNAPTOTOP, color)
		else
			d.drawScaled(320*FRACUNIT, -40*FRACUNIT, 82033, d.cachePatch("BGA0"), V_80TRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_FLIP, color)
		end
		charDisplayX = min(350,$+displaySpeed)
		displaySpeed = max(1,$-1)
		charDisplayY = 0 --sprite will be on screen
		--hacky method i know, but damn it works (PLEASE DON'T KILL ME, THIS WAS MADE BEFORE I KNEW ABOUT EASING FUNCTIONS)
	else
		--player is no longer on special state but sprite is still on screen: animate it off
		if charDisplayX > -125 and charDisplayX < 350 and charDisplayX != 0 then
			displaySpeed = min(35,$+1)
			charDisplayX = min(350,$+displaySpeed)
		else
			--ready everything up for the next time the player enters special state
			charDisplayX = -125
			displaySpeed = 20
			charDisplayY = 200 --sprite will be offscreen
		end
	end
	local spritepatch = d.getSprite2Patch(specialplayer.realmo.skin, SPR2_XTRA, false, B)
	local color2 = d.getColormap(TC_RAINBOW, specialplayer.skincolor)
	d.draw(charDisplayX, charDisplayY+40, spritepatch, V_HUDTRANSHALF, color2)
end
hud.add(HM.specialMeter, "game")

HM.resetstuff = function(mo, inf, src, dmg, dmgt)
	for p in players.iterate do
		p.sp = 0
		p.futuresp = 0
	end
end
addHook("MapLoad", HM.resetstuff, MT_PLAYER)

HM.spbonus = function(mo, inf, src, dmg, dmgt)
	if not(HM.valid(mo) and HM.valid(src) and mo.player and src.player) then
		return
	end
	if HM.valid(inf) and inf.player then
		inf.player.sp = $ and min(100,$+10) or 10
	else
		src.player.sp = $ and min(100,$+5) or 5
	end
end
addHook("MobjDamage", HM.spbonus, MT_PLAYER)