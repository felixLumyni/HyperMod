local HM = hypermod
local S = HM.SkinVars

S[-1] = {
	hyper=nil,
	warcry=0,
	auxsounds={}
}
S["sonic"] = {
	hyper=HM.SonicSpeed,
	warcry={sfx_ss1,sfx_ss2},
}
S["tails"] = {
	hyper=nil,
	warcry=sfx_ts2,
}
S["knuckles"] = {
	hyper=nil,
	warcry=sfx_ks1,
	warcry2={sfx_ks2a,sfx_ks2b},
}
S["amy"] = {
	hyper=nil,
	warcry={sfx_as1,sfx_as2},
}
S["fang"] = {
	hyper=HM.LaserRing,
	warcry={sfx_fs2,sfx_fs3},
	auxsounds={sfx_lsr1,sfx_lsr2}
}
S["metalsonic"] = {
	hyper=nil,
	warcry=sfx_ms,
}