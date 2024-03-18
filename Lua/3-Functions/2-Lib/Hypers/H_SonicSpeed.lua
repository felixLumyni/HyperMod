local HM = hypermod

HM.SonicSpeed = function(player)
	local mo = player.mo

	if not HM.valid(mo) then
		return
	end

	if player.usedspecial then
		player.mo.sonicspeed = 700
		S_ChangeMusic("HSHOES", true, player)
		player.usedspecial = 0
	end

	if HM.higherthan(player.mo.sonicspeed, 0) then
		player.mo.sonicspeed = $-1
		player.mo.colorized = true
		local g = P_SpawnGhostMobj(player.mo)
		g.colorized = true
		g.fuse = 7
		player.powers[pw_flashing] = player.sonicspeed
		player.charflags = $ | (SF_MULTIABILITY)
		if player.mo.sonicspeed == 0 then
			player.mo.colorized = false
			player.charflags = $ &~ (SF_MULTIABILITY)
			P_RestoreMusic(player)
		end
	end
end