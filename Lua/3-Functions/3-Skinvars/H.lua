local HM = hypermod
local S = HM.SkinVars

S["maimy"] = {
	hyper=HM.LaserRing,
	warcry=sfx_ms,
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
			warcry={sfx_inlaz4},
		}
	end
end
addHook("ThinkFrame", HM.inazumaload)

--TODO: eggman: HM.brakify
--TODO: eggette: HM.eggify
--TODO: mighty: HM.falconpunch
--TODO: heavy: HM.bigboi
--TODO: blaze: HM.firetornado