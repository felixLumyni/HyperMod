local HM = hypermod
local S = HM.SkinVars

S[-1] = {
	hyper=nil,
	s1=0,
	s2=0
}
S["sonic"] = {
	hyper=HM.SonicSpeed,
	s1=sfx_ss1,
	s2=sfx_ss2
}
S["tails"] = {
	hyper=nil,
	s1=sfx_ts1,
	s2=sfx_ts2
}
S["knuckles"] = {
	hyper=nil,
	s1=sfx_ks1,
	s2=sfx_ks1
}
S["amy"] = {
	hyper=nil,
	s1=sfx_as1,
	s2=sfx_as2
}
S["fang"] = {
	hyper=HM.LaserRing,
	s1=sfx_fs1,
	s2=sfx_fs2
}
S["metalsonic"] = {
	hyper=nil,
	s1=sfx_ms,
	s2=sfx_ms
}