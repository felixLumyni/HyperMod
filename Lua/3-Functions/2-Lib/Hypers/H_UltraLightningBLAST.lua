local HM = hypermod
local S = HM.SkinVars

HM.UltraLightningBlast = function(player)
	local mo = player.mo
	if not HM.valid(mo) then
		return
	end
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
		S_StartSound(nil, sfx_zcrash)
		for p in players.iterate do
			if p == player then
				continue
			end
			local sameteam = false
			if p.ctfteam == player.ctfteam and gametyperules & GTR_TEAMS then
				--do nothing
			else
				p.inazumahudflash = 100
				p.inazumahudflashsource = player
				if p.mo then
					p.mo.inazuma_flashed_flashbang = 1
					p.mo.inazuma_flashed_flashbang_max = 1
					p.mo.inazuma_flashed_flashbang_blind = 1
					p.mo.inazuma_flashed = 60*TICRATE
					S_StartSound(p.mo, sfx_kc59)
					S_StopSound(player.realmo, S["inazuma"].warcry)
				end
			end
		end
	end
end

--whoa, this one doesnt use additional hooks?? thats crazy






























--sike

HM.inahud = function(v, player, cam)
	if player.inazumahudflash then	
		local patch_prefix = "KYS"
		local frames = {A,B,silvahorn and C or D, E, F}
		local silvahorn = Inazuma and Inazuma.CheckSilverhorns(player)
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP
		local colormap = player.inazumahudflashsource and v.getColormap(TC_DEFAULT, player.inazumahudflashsource.skincolor) or v.getColormap(TC_DEFAULT, SKINCOLOR_CERULEAN)
		local opacity = player.inazumahudflash and HM.TimeTrans(player.inazumahudflash) or 0
		local idk = 98032 -- height is 720?
		if (v.height() == 1200) or (v.height() == 800) or (v.height() == 400) or (v.height() == 200) then
			idk = 65355
		elseif (v.height() == 1080) then
			idk = 82033
		end
		--finally do the drawing
		for n = 1, #frames do
			local opacity2 = opacity
			if n == #frames and player.inazumahudflash then
				opacity2 = player.inazumahudflash and HM.TimeTrans(1+player.inazumahudflash/2) or V_50TRANS
			end
			local patch = v.cachePatch(patch_prefix+tostring(n))
			v.drawScaled(0, -40*FRACUNIT, idk, patch, flags|opacity2, colormap)
		end
	end
end
hud.add(HM.inahud, "game")

--AAA

HM.inazumahudflash = function(player)
	if player.inazumahudflash then
		player.inazumahudflash = max(0,$-4)
	end
end
addHook("PlayerThink", HM.inazumahudflash)