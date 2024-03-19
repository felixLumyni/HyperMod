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
		mo.target = dummy
		player.drawangle = mo.angle
		mo.state = S_PLAY_FIRE
		mo.state = leveltime%2==0 and S_PLAY_STND or S_PLAY_FIRE
		if mo.target then A_Boss1Laser(mo, MT_LASER, 3) end
		mo.state = mo.state == S_PLAY_FIRE and S_PLAY_STND or S_PLAY_FIRE
		P_Thrust(mo, player.drawangle, -mo.scale/3)
		P_SetObjectMomZ(mo, mo.scale, false)
		mo.lasering = max(0, $-1)
		player.sp = mo.lasering
		if not mo.lasering then
			mo.state = S_PLAY_FALL
		end
	end
end

local laser_instantkill = function(mo, inf, src, dmg, dmgt)
	--i hate magic numbers too but these arent listed in srb2's object list so uhh
	if not (inf.type == MT_LASER or inf.type == 65 or inf.type == 530) then
		return
	end
	if gamemap == 3 and gametype == 0 then --LMAO
		return
	end
	if mo.lasering then
		return true
	else
		P_DamageMobj(mo, inf, src, 999, DMG_INSTAKILL)
	end
end
addHook("MobjDamage", laser_instantkill, MT_PLAYER)