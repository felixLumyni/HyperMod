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
		end
		S_StartSound(nil, sfx_god)
		HM.amyhudflash = 100
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
		local colormap = v.getColormap(TC_DEFAULT, SKINCOLOR_GOD)
		shifttable(skincolors[SKINCOLOR_GOD].ramp)
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

local function shifttable(table)
    local lastItem = table[#table]
    for i = #table, 2, -1 do
        table[i] = table[i - 1]
    end
    table[1] = lastItem
end