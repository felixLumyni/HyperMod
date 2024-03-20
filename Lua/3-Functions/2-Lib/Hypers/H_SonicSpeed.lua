local HM = hypermod

HM.SonicSpeed = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.justthokked = false
		mo.sonicspeed = TICRATE*20
		S_ChangeMusic("HSHOES", true, player)
		player.usedspecial = 0
		if player.pflags & PF_JUMPED and not (mo.eflags & MFE_SPRUNG) then
			mo.state = S_PLAY_JUMP
		end
	end

	if HM.higherthan(mo.sonicspeed, 0) then	
		player.sp = min(99,mo.sonicspeed/7)
		mo.sonicspeed = $-1
		mo.colorized = true
		local g = P_SpawnGhostMobj(mo)
		g.colorized = true
		g.fuse = HM.higherthan(mo.sonicspeed, TICRATE*2) and 7 or 3
		local spd = (player.speed*2/3/FRACUNIT) + 8
		g.momx = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)
		g.momy = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)
		g.momz = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)/2
		g.scale = mo.scale
		if player.pflags & PF_THOKKED then
			player.justthokked = 3
			player.pflags = $ &~ PF_THOKKED
		else
			player.justthokked = $ and max($-1,0) or 0
		end
		if player.justthokked then
			g.momz = $/8
			g.shadowscale = mo.shadowscale
			g.blendmode = AST_COPY and AST_COPY or 0
			g.flags = $ &~ MF_NOGRAVITY
			g.fuse = $*3/2
			local actionspd = FixedMul(mo.scale, player.actionspd)
			g.angle = P_RandomRange(0, 360) * ANG1
			P_InstaThrust(g, g.angle, actionspd)
		end
		player.charflags = $ | (SF_MULTIABILITY)
		if mo.sonicspeed == 0 then
			mo.colorized = false
			player.charflags = $ &~ (SF_MULTIABILITY)
			P_RestoreMusic(player)
		end
	end
end

HM.autop = function(target, inflictor, source, damage, damagetype)
	if target
	and source
	and target.player
	and HM.higherthan(target.sonicspeed, 0)
	and not target.player.powers[pw_flashing]
	then
		if P_IsObjectOnGround(target) then
			-- SFX
			S_StartSound(target, sfx_cdpcm9)
			S_StartSound(target, sfx_s259)
			-- State
			target.state = S_PLAY_EDGE
			-- VFX
			local UHOH = P_SpawnGhostMobj(target)
			UHOH.colorized = true
			UHOH.destscale = UHOH.scale*2
			UHOH.scalespeed = FRACUNIT/2
			if AST_ADD
				UHOH.blendmode = AST_ADD
			end
			if CBW_Battle and MT_BATTLESHIELD then
				local sh = P_SpawnMobjFromMobj(target,0,0,0, MT_BATTLESHIELD)
				sh.target = target
			end
			-- Affect attacker
			if inflictor and inflictor.player then
				if inflictor.player.powers[pw_invulnerability] then
					inflictor.player.powers[pw_invulnerability] = 0
					P_RestoreMusic(inflictor.player)
				end
				local angle = R_PointToAngle2(target.x-target.momx,target.y-target.momy,inflictor.x-inflictor.momx,inflictor.y-inflictor.momy)
				local thrust = FRACUNIT*10
				P_SetObjectMomZ(inflictor,thrust)
				if CBW_Battle then
					if twodlevel then thrust = CBW_Battle.TwoDFactor($) end
					CBW_Battle.DoPlayerTumble(inflictor.player, 45, angle, inflictor.scale*3, true, true) --no stunbreak
				end
			elseif inflictor then
				P_DamageMobj(inflictor,target,target)
			end
		else
			-- SFX
			S_StartSound(mo, sfx_s3k47)
			S_StartSoundAtVolume(mo, sfx_nbmper, 125)
			-- State
			target.state = S_PLAY_FALL
			target.player.airdodge = 1
			target.player.airdodge_spin = ANGLE_90 + ANG10
			target.intangible = $ and max($,2) or 2
			-- VFX
			local sparkle = P_SpawnMobj(target.x,target.y,target.z,MT_SUPERSPARK)
			sparkle.scale = target.scale
			sparkle.destscale = 0
			if AST_ADD
				sparkle.blendmode = AST_ADD
			end
			sparkle.momx = target.momx / 2
			sparkle.momy = target.momy / 2
			sparkle.momz = target.momz * 2/3
		end
		local player = target.player
		-- Extra (lose SP if auto-evaded)
		target.player.powers[pw_flashing] = max($,TICRATE/2)
		if player and HM.higherthan(player.guardtics, 0) then
			return
		end
		if inflictor and (inflictor.type == MT_LASER
		or inflictor.type == 65 or inflictor.type == 530)
		then
			target.sonicspeed = $/2
		else
			target.sonicspeed = max(1,$-(TICRATE/2))
		end
	end
end
addHook("ShouldDamage", HM.autop, MT_PLAYER)