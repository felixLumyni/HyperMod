local HM = hypermod

HM.Blessing = function(player)
	local mo = player.mo
	if not HM.valid(mo) then
		return
	end
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		for mo2 in mobjs.iterate() do
			local sameteam = false
			local p = mo2.player
			if p and p.ctfteam == player.ctfteam and (p == player or gametyperules & GTR_TEAMS) then
				if not p.powers[pw_shield] then
					p.powers[pw_shield] = SH_PINK
					P_SpawnShieldOrb(p)
				end
				if p.shieldmax then
					for n = 1, p.shieldmax do
						if not(p.shieldstock[n]) then
							p.shieldstock[n] = SH_PINK
						end
					end
				end
			elseif p or (mo2.flags & MF_ENEMY) then
				P_DamageMobj(mo2, mo, mo, 1)
			end
		end
		S_StartSound(nil, sfx_god)
		HM.amyhudflash = 100
		player.sp = 89
		player.futuresp = -player.sp
	end
end

--whoa, this one doesnt use additional hooks?? thats crazy



































--bruh

HM.amyhud = function(v, player, cam)
	if HM.higherthan(HM.amyhudflash, 0) then
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP
		local opacity = HM.amyhudflash and HM.TimeTrans(HM.amyhudflash) or 0
		local idk = 98032 -- height is 720?
		if (v.height() == 1200) or (v.height() == 800) or (v.height() == 400) or (v.height() == 200) then
			idk = 65355
		elseif (v.height() == 1080) then
			idk = 82033
		end
		--finally do the drawing
		local patch = v.cachePatch("GOD")
		local color = _G["SKINCOLOR_GOD"+HM.wrapValue((HM.amyhudflash/5)-2, 1, 16)]
		local colormap = v.getColormap(TC_DEFAULT, color)
		v.drawScaled(0, -40*FRACUNIT, idk, patch, flags|opacity, colormap)
	end
end
hud.add(HM.amyhud, "game")

HM.amyhudflashthink = function(player)
	if HM.higherthan(HM.amyhudflash, 0) then
		HM.amyhudflash = $-2
	end
end
addHook("ThinkFrame", HM.amyhudflashthink)