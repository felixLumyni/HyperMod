local HM = hypermod

HM.debug = function(player, args)
    if not player == server then return end
    for p in players.iterate do
        p.sp = tonumber(args)
    end
end
COM_AddCommand("hm_debug", HM.debug, COM_ADMIN)

HM.enabled = CV_RegisterVar{
	name = "hm_enabled",
	defaultvalue = 1,
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}