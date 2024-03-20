local HM = hypermod

HM.LaserRing = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		mo.lasering = 2*TICRATE
		player.usedspecial = 0
		S_StartSound(player.realmo, sfx_lsr3)
	end
	
	if HM.higherthan(mo.lasering, 0) and not player.playerstate then
		local oldseesound = mobjinfo[MT_REDRING].seesound
		mobjinfo[MT_REDRING].seesound = 0
		local hitscan = P_SPMAngle(mo,MT_REDRING,mo.angle,1)
		mobjinfo[MT_REDRING].seesound = oldseesound
		local dummy
		for i = 0, 255 do
			hitscan.flags = ($|MF_NOBLOCKMAP)
			if P_RailThinker(hitscan) then
				if HM.valid(hitscan) then 
					dummy = P_SpawnMobj(hitscan.x, hitscan.y, hitscan.z, MT_THOK)
					dummy.tics = 1
					P_RemoveMobj(hitscan)
				end
				break
			end
		end
		--[[
			explaining WTF is going on here:
			- A_Boss1Laser only works if mo.target exists
			- the laser only has white outlines if the player is standing
			- i made it only do that every other frame so it looks flashy
			- but i also swap the state back after flashing, cause it fits better
			- yeah thats it lol
		]]
		mo.target = dummy
		player.drawangle = mo.angle
		mo.state = S_PLAY_FIRE
		mo.state = leveltime%2==0 and S_PLAY_STND or S_PLAY_FIRE
		if mo.target then A_Boss1Laser(mo, MT_LASER, 3) end
		mo.state = mo.state == S_PLAY_FIRE and S_PLAY_STND or S_PLAY_FIRE
		if mo.state == S_PLAY_FIRE then S_StartSound(mo, sfx_corkp) end
		P_Thrust(mo, player.drawangle, -mo.scale/3)
		P_SetObjectMomZ(mo, mo.scale, false)
		mo.lasering = max(0, $-1)
		player.sp = min(99,mo.lasering*3/2)
		if not mo.lasering then
			mo.state = S_PLAY_FALL
		end
		--VFX
		local circle = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale * 24, MT_THOK)
		local fusefade = {
    	[0] = 0,
    	[1] = FF_TRANS90,
    	[2] = FF_TRANS80,
    	[3] = FF_TRANS70,
    	[4] = FF_TRANS60,
    	[5] = FF_TRANS50,
    	[6] = FF_TRANS40,
    	[7] = FF_TRANS30,
    	[8] = FF_TRANS20,
    	[9] = FF_TRANS10
		}
		local fade = fusefade[1+(mo.lasering/8)]
		circle.sprite = SPR_STAB
		circle.frame = fade|FF_PAPERSPRITE|_G["A"]
		circle.angle = mo.angle + ANGLE_90
		circle.fuse = 7
		circle.scale = mo.scale/3
		circle.scalespeed = mo.scale*2
		circle.destscale = mo.scale*16
		circle.colorized = true
		circle.color = SKINCOLOR_SUPERRED5
		P_StartQuake(9*FRACUNIT, 2)
	end
end

local laser_instantkill = function(mo, inf, src, dmg, dmgt)
	--i hate magic numbers too but these arent listed in srb2's object list so uhh
	if (not inf) or not (inf.type == MT_LASER or inf.type == 65 or inf.type == 530) then
		return
	end
	if (gamemap == 3 and gametype == 0) then --LMAO
		return
	end
	if mo.lasering then
		return true
	else
		P_DamageMobj(mo, inf, src, 999, DMG_INSTAKILL)
	end
end
addHook("MobjDamage", laser_instantkill, MT_PLAYER)