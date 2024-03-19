local HM = hypermod

HM.SonicSpeed = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
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
		g.fuse = HM.higherthan(mo.sonicspeed, TICRATE*2) and 7 or 2
		g.momx = $ + FixedMul(mo.scale, P_RandomFixed()*8 - P_RandomFixed()*8)
		g.momy = $ + FixedMul(mo.scale, P_RandomFixed()*8 - P_RandomFixed()*8)
		g.momz = $ + FixedMul(mo.scale, P_RandomFixed()*8 - P_RandomFixed()*8)
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
			if MT_BATTLESHIELD then
				local sh = P_SpawnMobjFromMobj(target,0,0,0, MT_BATTLESHIELD)
				sh.target = target
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
		target.player.powers[pw_flashing] = TICRATE/2
	end
end
addHook("ShouldDamage", HM.autop, MT_PLAYER)