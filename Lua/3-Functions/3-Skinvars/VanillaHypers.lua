local HM = hypermod
local S = HM.SkinVars

S[-1] = {
	--hyper=nil,
	hyper=HM.SonicSpeed,
	warcry=0,
	auxsounds={sfx_spc1},
	spcost=100, --TODO
	broadcast=true, --TODO
	hypergraphic=nil,
}
S["sonic"] = {
	hyper=HM.SonicSpeed,
	warcry={sfx_ssx1,sfx_ssx2},
	hypergraphic="XTRASS",
}
S["tails"] = {
	hyper=HM.GokuSatsu,
	warcry=sfx_tx1,
}
S["knuckles"] = {
	hyper=HM.TakeThis,
	warcry=sfx_kx1,
}
S["amy"] = {
	hyper=HM.Blessing,
	warcry={sfx_as1,sfx_as2},
	auxsounds={sfx_spc1,sfx_lsr2}
}
S["fang"] = {
	hyper=HM.LaserRing,
	warcry={sfx_fs2,sfx_fs3},
	auxsounds={sfx_lsr1,sfx_lsr2}
}
S["metalsonic"] = {
	hyper=HM.LaserRing,
	warcry=sfx_ms,
	auxsounds={sfx_lsr1,sfx_lsr2},
}