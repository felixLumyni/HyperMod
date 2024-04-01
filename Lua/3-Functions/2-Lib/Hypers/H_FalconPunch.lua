local HM = hypermod
local state_punch = 8

HM.FalconPunch = function(player)
	local mo = player.mo
	if player.playerstate or not HM.valid(mo) then
		return
	end
    
	if player.usedspecial and not (mo.state == S_PLAY_SPECIAL) then
		player.usedspecial = 0
        player.sp = 89
		player.futuresp = -player.sp
        if not CBW_Battle then
            assert(false, mo.skin+" tried to use their special, but battlemod isn't loaded. bummer.")
            return
        end
        player.mo.state = S_PLAY_K_PUNCHSTART1
		player.drawangle = player.mo.angle
		player.actionstate = state_punch
		player.actiontime = 0
		player.canguard = false
		player.epunchjump = false
		player.lockmove = true
		player.lockaim = true
		player.mo.friction = FRACUNIT*1 -- slide around
		player.pflags = $&~PF_APPLYAUTOBRAKE -- no auto break
	end
    if not CBW_Battle then
        return
    end
    -- =========== punch code ============== //
	if player.actionstate == state_punch then
		player.actiontime = $+1
		player.lockaim = true
		player.pflags = $ & ~PF_SPINNING
		player.pflags = $|PF_THOKKED
		player.punchthrustedit = true
		player.thrustfactor = skins[mo.skin].thrustfactor*3/5
		if player.actiontime <= 16 then -- start up code
			player.squashstretch = true
			player.pflags = $&~PF_APPLYAUTOBRAKE -- no auto break
			player.mo.friction = FRACUNIT*1
			if player.actiontime < 3 then -- slide
				--player.pflags = $|PF_STASIS -- let the player jump
				if player.actiontime <= 3 then -- start up pose 1
					mo.state = S_PLAY_K_PUNCHSTART1
					mo.frame = 2
				else  -- start up pose 2
					mo.state = S_PLAY_K_PUNCHSTART2
					mo.frame = 0
				end
			elseif player.actiontime == 7 then -- push forward
				player.lockmove = true
				if player == consoleplayer --make it feel powerful
					P_StartQuake(4*FRACUNIT,1)
				end
				P_Thrust(mo,player.drawangle,mo.scale*4)
				mo.state = S_PLAY_K_PUNCHACTIVE1
				local explode_spawner = P_SpawnMobjFromMobj(player.mo,
				FixedMul(player.mo.radius*3, cos(player.mo.angle)),
				FixedMul(player.mo.radius*3, sin(player.mo.angle)), 
				0,MT_EXPLODESPWN)
				--[[local jabhitbox = P_SpawnMobjFromMobj(player.mo, 
					FixedMul(player.mo.radius, cos(player.mo.angle)),
					FixedMul(player.mo.radius, sin(player.mo.angle)), 
					0, 
					MT_JABEXPLOADE) -- spawn exlosion hitbox
				--]]
				explode_spawner.angle = player.mo.angle
				explode_spawner.target = player.mo
				explode_spawner.scale = player.mo.scale
				explode_spawner.tics = TICRATE
				P_InstaThrust(explode_spawner, player.mo.angle, player.mo.scale*55)

				player.mo.momx = 0
				player.mo.momy = 0
				player.mo.momz = 0
				P_SetObjectMomZ(player.mo, player.mo.scale*5, false)
				--S_StartSound(player.mo, sfx_brakrx)
			elseif player.actiontime <= 16
				player.mo.spritexscale = player.mo.scale
				player.mo.spriteyscale = player.mo.scale
				mo.state = S_PLAY_K_PUNCHACTIVE1
				player.lockmove = true -- dont cancle punch into jump
			end
			player.canguard = false
		elseif player.actiontime > 16 then -- recovery
			player.lockmove = true
			player.canguard = true
			mo.state = S_PLAY_K_PUNCHRECOVERY
			mo.frame = 0
		end
    	if player.actiontime >= 35  then
			player.thrustfactor = skins[mo.skin].thrustfactor
			player.punchthrustedit = false
			CBW_Battle.ResetPlayerProperties(player,false,false)
		end
	end
end