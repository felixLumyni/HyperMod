local HM = hypermod
local S = HM.SkinVars

HM.PlayerSpawn = function(player)
	player.usedspecial = 0
	player.sp = $ and $/2 or 0
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
	if HM.valid(player.mo) then
		local func = S[player.mo.skin] and S[player.mo.skin].hyper or S[-1].hyper
		if func then func(player) end

		if player.sp >= 100 and player.sp_history != 100 then
			S_StartSound(player.realmo, sfx_ready)
		end

		local pressing = (player.cmd.buttons & BT_WEAPONNEXT) or (player.cmd.buttons & BT_WEAPONPREV)

		if pressing and player.sp >= 100 then
			player.sp = $-100
			player.usedspecial = 1
			S_StartSound(player.realmo, sfx_spc1)
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
			HM.doSpecialVfx(player)
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
		
		--history (for recharge detection)
		player.sp_history = player.sp
	end
end
addHook("PlayerThink", HM.PlayerThink)

local barColor, specialStatus, specialColor
local charDisplayX, charDisplayY, displaySpeed = 0 -- TODO: TURN INTO PLAYER VARIABLES !!!
local commonFlags = V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANSDOUBLE

HM.specialMeter = function(d, p)
	if HM.valid(p) and HM.valid(p.mo) and p.sp != nil then
		
		--sp meter
		if p.sp >= 100 and not (leveltime % 3 == 0) then
			barColor = 129
		else
			barColor = 130
		end
		local meter = p.mo.state == S_PLAY_SPECIAL and 100 or p.sp
		d.drawFill(82, 186-0, 100/2, 6, commonFlags|138)
		d.drawFill(82, 186-1, 100/2, 2, commonFlags|139)
		d.drawFill(82, 186-0, meter/2, 6, commonFlags|barColor+1)
		d.drawFill(82, 186-1, meter/2, 2, commonFlags|barColor)
		
		--text
		if p.sp and p.sp >= 100 then specialStatus = "WEAPON CHANGE!" else specialStatus = "" end
		if (leveltime % 3 == 0) then specialColor = V_SKYMAP else specialColor = 0 end
		d.drawString(50, 185, specialStatus, V_PERPLAYER|specialColor, "thin")
		
		if paused or not(p == displayplayer) then return end

		--screen tint during special		
		if p.mo.state == S_PLAY_SPECIAL then
			if (leveltime % 3 == 0) then
				d.drawScaled(0, -40*FRACUNIT, 82033, d.cachePatch("BGA0"), V_70TRANS|V_SNAPTOLEFT|V_SNAPTOTOP, d.getColormap(nil, p.skincolor))
			else
				d.drawScaled(320*FRACUNIT, -40*FRACUNIT, 82033, d.cachePatch("BGA0"), V_80TRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_FLIP, d.getColormap(nil, p.skincolor))
			end	
			charDisplayX = min(350,$+displaySpeed)
			displaySpeed = max(1,$-1)
			charDisplayY = 0 --sprite will be on screen
			--hacky method i know, but damn it works
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
		d.draw(charDisplayX, charDisplayY+40, d.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, B), V_HUDTRANSHALF, d.getColormap(TC_RAINBOW, p.skincolor))
	end
end
hud.add(HM.specialMeter, "game")