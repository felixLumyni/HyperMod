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
		end
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
		v.drawScaled(0, -40*FRACUNIT, idk, patch, flags|opacity, colormap)
	end
end
hud.add(HM.amyhud, "game")

HM.amyhudflash = function(player)
	if HM.higherthan(HM.amyhudflash, 0) then
		HM.amyhudflash = $-2
	end
end
addHook("ThinkFrame", HM.amyhudflash)

local function shiftNumbersForward(nums) --TODO
    local lastNum = nums[#nums]
    for i = #nums, 2, -1 do
        nums[i] = nums[i - 1]
    end
    nums[1] = lastNum
end