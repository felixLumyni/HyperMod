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
end

--pointless hook to account for char switch!!
HM.DoSonicSpeed = function(player)
	local mo = player.mo
	if player.playerstate or not HM.valid(mo) then
		return
	end
	if HM.higherthan(mo.sonicspeed, 0) then	
		player.powers[pw_sneakers] = max($,mo.sonicspeed)
		mo.eflags = $|MFE_FORCESUPER
		player.sp = min(99,mo.sonicspeed/7)
		mo.sonicspeed = $-1
		mo.colorized = true
		if mo.color == SKINCOLOR_BLUE then mo.color = SKINCOLOR_SKY end
		if player.followmobj and player.followmobj.color == SKINCOLOR_BLUE then player.followmobj.color = SKINCOLOR_SKY end
		--if AST_ADD then mo.blendmode = AST_ADD end
		--if AST_ADD and player.followmobj then player.followmobj.blendmode = AST_ADD end
		local g = P_SpawnGhostMobj(mo)
		g.colorized = true
		g.fuse = HM.higherthan(mo.sonicspeed, TICRATE*2) and 7 or 3
		local spd = (player.speed*2/3/FRACUNIT) + 8
		g.momx = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)
		g.momy = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)
		g.momz = $ + FixedMul(mo.scale, P_RandomFixed()*spd - P_RandomFixed()*spd)/2
		g.scale = mo.scale
		if AST_ADD then g.blendmode = AST_ADD end
		if HM.valid(g.tracer) then
			g.tracer.colorized = true
			g.tracer.tics = $/2
			if AST_ADD then g.tracer.blendmode = AST_ADD end
			g.tracer.momx = g.momx
			g.tracer.momy = g.momy
			g.tracer.momz = g.momz
		end
		if mo.state == S_PLAY_JUMP and player.pflags & PF_THOKKED and not player.actionstate then
			player.justthokked = 3
			player.pflags = $ &~ PF_THOKKED
		else
			player.justthokked = $ and max($-1,0) or 0
		end
		if player.justthokked then
			g.momz = $/8
			g.shadowscale = mo.shadowscale
			--if AST_ADD then g.blendmode = AST_ADD end
			g.blendmode = 0
			g.flags = $ &~ MF_NOGRAVITY
			g.fuse = $*3/2
			local actionspd = FixedMul(mo.scale, player.actionspd)
			g.angle = P_RandomRange(0, 360) * ANG1
			P_InstaThrust(g, g.angle, actionspd)
			--g.frame = $|FF_TRANS90
		end
		player.charflags = $ | (SF_MULTIABILITY)
		if mo.sonicspeed == 0 then
			mo.eflags = $ &~ MFE_FORCESUPER
			mo.colorized = false
			mo.color = player.skincolor
			if player.followmobj then player.followmobj.color = player.skincolor end
			--mo.blendmode = 0
			--if player.followmobj then player.followmobj.blendmode = 0 end
			player.charflags = $ &~ (SF_MULTIABILITY)
			P_RestoreMusic(player)
		end
	end
end
addHook("PlayerThink", HM.DoSonicSpeed)

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
					CBW_Battle.DoPlayerTumble(inflictor.player, 45, target.angle, inflictor.scale*3, true, true) --no stunbreak
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