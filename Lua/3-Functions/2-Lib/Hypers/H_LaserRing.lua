local HM = hypermod

HM.LaserRing = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial then
		mo.lasering = 2*TICRATE
		player.usedspecial = 0
	end
	
	if HM.higherthan(mo.lasering, 0) then
		local hitscan = P_SPMAngle(mo,MT_REDRING,mo.angle,1)
		local dummy
		for i = 0, 255 do
			hitscan.flags = ($|MF_NOBLOCKMAP)
			if P_RailThinker(hitscan) then
				if (hitscan and hitscan.valid) then 
					dummy = P_SpawnMobj(hitscan.x, hitscan.y, hitscan.z, MT_THOK)
					dummy.tics = 1
					--TODO: stop sound and sparks somehow
				end
				break
			end
		end
		if not dummy then return end
		mo.target = dummy
		player.drawangle = mo.angle
		mo.state = leveltime%2==0 and S_PLAY_STND or S_PLAY_FIRE
		A_Boss1Laser(mo, MT_LASER, 3)
		mo.state = S_PLAY_FIRE
		mo.lasering = max(0, $-1)
	end
end

local laser_instantkill = function(mo, inf, src, dmg, dmgt)
	if not (inf.type == MT_LASER) then
		return
	end
	if mo.lasering then
		return false
	else
		P_DamageMobj(mo, inf, src, 999, DMG_INSTAKILL)
	end
end
addHook("MobjDamage", laser_instantkill, MT_PLAYER)