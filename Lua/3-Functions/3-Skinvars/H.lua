local HM = hypermod
local S = HM.SkinVars

S["maimy"] = {
	hyper=HM.LaserRing,
	warcry=sfx_ms,
	auxsounds={sfx_lsr1,sfx_lsr2},
}

S["marine"] = {
	hyper=HM.LaserRing,
	warcry=nil,
	auxsounds={sfx_lsr1,sfx_lsr2},
}

S["shadow"] = {
	hyper=HM.ChaosControl,
	warcry=sfx_shsx1,
	auxsounds={sfx_spc2}
}

HM.inazumaloaded = false
HM.inazumaload = function()
	if skins["inazuma"] and not HM.inazumaloaded then
		HM.inazumaloaded = true
		S["inazuma"] = {
			hyper=HM.UltraLightningBlast,
			warcry={sfx_inlaz4}, --reason he needs a hook
		}
	end
end
addHook("ThinkFrame", HM.inazumaload)

S["heavy"] = {
	hyper=HM.Dynamax,
	warcry=sfx_pipe,
	auxsounds={sfx_spc5}
}