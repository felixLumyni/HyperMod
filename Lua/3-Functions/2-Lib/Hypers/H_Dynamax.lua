local HM = hypermod

HM.Dynamax = function(player)
	local mo = player.mo
	if player.playerstate or not HM.valid(mo) then
		return
	end
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		mo.dynamaxxed = TICRATE*20
		player.sp = 89
		player.futuresp = -player.sp
	end
end

HM.DoDynamax = function(mo)
	if HM.higherthan(mo.dynamaxxed, 0) then
		if not mo.oldscalespeed then mo.oldscalespeed = mo.scalespeed end
		mo.scalespeed = FRACUNIT/32
		mo.destscale = 4*FRACUNIT
		mo.dynamaxxed = $-1
		if mo.player then mo.player.sp = min(99,mo.dynamaxxed/7) end
		if not mo.dynamaxxed then
			mo.scalespeed = mo.oldscalespeed or FRACUNIT
			mo.destscale = FRACUNIT
			mo.oldscalespeed = nil
		end
	end
end
addHook("MobjThinker", HM.DoDynamax, MT_PLAYER)

HM.bonk = function(target, inflictor, source, damage, damagetype)
	if target
	and source
	and target.player
	and HM.higherthan(target.dynamaxxed, 0)
	then
		return false
	end
end
addHook("ShouldDamage", HM.bonk, MT_PLAYER)