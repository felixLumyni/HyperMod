local HM = hypermod

HM.Blessing = function(player)
	local mo = player.mo
	if not HM.valid(mo) then
		return
	end
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		for p in players.iterate do
			local sameteam = false
			if p.ctfteam == player.ctfteam and gametyperules & GTR_TEAMS then
				if not p.powers[pw_shield] then
					p.powers[pw_shield] = SH_PINK
					P_SpawnShieldOrb(p)
				end
				if player.shieldmax then
					for n = 1, player.shieldmax do
						if not(player.shieldstock[n]) then
							player.shieldstock[n] = SH_PINK
						end
					end
				end
			elseif p.mo then
				P_DamageMobj(p.mo, mo, mo, 1)
			end
			S_StartSound(sfx_god)
			p.amyhudflash = TICRATE
		end
	end
end

--whoa, this one doesnt use additional hooks?? thats crazy



































--bruh

HM.amyhud = function(v, player, cam)
	local patch = v.cachePatch("VIGNETT") --TODO: correct string
	local flags = V_SNAPTOLEFT|V_SNAPTOTOP
	local colormap = v.getColormap(TC_DEFAULT, SKINCOLOR_BLACK)
	local opacity = 0
	if player.amyhudflash or player.amyhudflashintensity then
		if player.amyhudflashintensity then
			--i am so hecking lazy i know
			if player.amyhudflashintensity < 35 then opacity = V_10TRANS end
			if player.amyhudflashintensity < 32 then opacity = V_20TRANS end
			if player.amyhudflashintensity < 28 then opacity = V_30TRANS end
			if player.amyhudflashintensity < 24 then opacity = V_40TRANS end
			if player.amyhudflashintensity < 20 then opacity = V_50TRANS end
			if player.amyhudflashintensity < 16 then opacity = V_60TRANS end
			if player.amyhudflashintensity < 12 then opacity = V_70TRANS end
			if player.amyhudflashintensity < 8 then opacity = V_80TRANS end
			if player.amyhudflashintensity < 4 then opacity = V_90TRANS end
		end
		if (v.height() == 1200) or (v.height() == 800) or (v.height() == 400) or (v.height() == 200) then
			v.drawScaled(0, -40*FRACUNIT, 65355, patch, flags|opacity, colormap)
		elseif (v.height() == 1080) then
			v.drawScaled(0, -40*FRACUNIT, 82033, patch, flags|opacity, colormap)
		else --720?
			v.drawScaled(0, -40*FRACUNIT, 98032, patch, flags|opacity, colormap)
		end
	end
end
hud.add(HM.amyhud, "game")

--AAA

HM.amyhudflash = function(player)
	player.amyhudflashintensity = $ or 0
	if player.amyhudflash then
		player.amyhudflash = $-1
		player.amyhudflashintensity = min(36,$+1)
	else
		if leveltime % 2 == 0 then player.amyhudflashintensity = max(0,$-1) end
	end
end
addHook("PlayerThink", HM.amyhudflash)