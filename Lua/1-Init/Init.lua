assert(not hypermod, "Loaded multiple instances of HyperMod!")
rawset(_G,"hypermod",{})

local HM = hypermod
HM.SkinVars = {}
HM.version = "1"
HM.branch = "indev"