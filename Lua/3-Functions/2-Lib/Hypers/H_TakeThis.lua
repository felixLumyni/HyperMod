local HM = hypermod
local KNUX_TUMBLEDURATION = TICRATE*3

HM.TakeThis = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		if P_IsObjectOnGround(mo) then
			mo.getdown = TICRATE/2
			S_StartSound(nil, sfx_gdwn)
		else
			mo.takethis = TICRATE/2
			S_StartSound(nil, sfx_kx2a)
		end
	end
end

--yknow the drill. hooks to account for char switch.
HM.DoTakeThis = function(player)
	local mo = player.mo
	if player.playerstate or not HM.valid(mo) then
		return
	end
	if HM.higherthan(mo.getdown, 0) then
		mo.getdown = $-1
		player.powers[pw_nocontrol] = mo.getdown
		mo.state = S_PLAY_GLIDE_LANDING
		if not mo.getdown then
			for mo2 in mobjs.iterate() do
				if mo == mo2 then
					continue
				end
				if (mo2.player or mo2.flags & MF_ENEMY) then
					if P_IsObjectOnGround(mo2) then
						if mo2.player then
							mo2.player.rings = 0
						end
						P_DamageMobj(mo2, mo, mo, 2)
						if mo2.player and CBW_Battle and not mo2.playerstate then
							mo2.state = S_PLAY_FALL
							CBW_Battle.DoPlayerTumble(mo2.player, KNUX_TUMBLEDURATION, mo2.angle, mo2.scale*3, true, true) --no stunbreak
						end
					elseif mo2.player and CBW_Battle and not mo2.playerstate then
						CBW_Battle.DoPlayerTumble(mo2.player, KNUX_TUMBLEDURATION, mo2.angle, mo2.scale*3, true, true) --no stunbreak
					end
				end
			end
			S_StartSound(nil, sfx_pnch)
			P_StartQuake(9*FRACUNIT, 2)
		end
	end
	if HM.higherthan(mo.takethis, 0) and not player.playerstate then
		mo.takethis = $-1
		player.powers[pw_nocontrol] = mo.takethis
		mo.state = S_PLAY_SUPER_TRANS1
		mo.momz = max($,0)
		if not mo.takethis then
			for p in players.iterate do
				P_FlashPal(p, PAL_INVERT, 5)
			end
			for mo2 in mobjs.iterate() do
				if (mo2.player or mo2.flags & MF_ENEMY) then
					if mo == mo2 then
						continue
					end
					if not P_IsObjectOnGround(mo2) then
						if mo2.player then
							mo2.player.rings = 0
						end
						P_DamageMobj(mo2, mo, mo, 2)
						if mo2.player and CBW_Battle and not mo2.playerstate then
							mo2.state = S_PLAY_FALL
							CBW_Battle.DoPlayerTumble(mo2.player, KNUX_TUMBLEDURATION, mo2.angle, mo2.scale*3, true, true) --no stunbreak
						end
					elseif mo2.player and CBW_Battle and not mo2.playerstate then
						CBW_Battle.DoPlayerTumble(mo2.player, KNUX_TUMBLEDURATION, mo2.angle, mo2.scale*3, true, true) --no stunbreak
					end
					--vfx
					local zap = P_SpawnMobj(mo2.x, mo2.y, mo2.z+mo2.height, MT_THOK)
					if HM.valid(zap) then
						zap.state = S_CYBRAKDEMONELECTRICBARRIER_SPARK_RANDOM1 + P_RandomRange(0, 11)
						local g = P_SpawnGhostMobj(zap)
						if HM.valid(g) then
							P_SetOrigin(g, mo2.x, mo2.y, mo2.z)
							g.tics = $*3
							g.blendmode = AST_ADD and AST_ADD or 0
							g.destscale = g.scale * 3
							g.scalespeed = FRACUNIT/2
						end
					end	
				end
			end
			S_StartSound(nil, sfx_s3k79)
			S_StartSound(nil, sfx_litng2+P_RandomRange(0, 2))
			P_StartQuake(9*FRACUNIT, 2)
		end
	end
end
addHook("PlayerThink", HM.DoTakeThis)