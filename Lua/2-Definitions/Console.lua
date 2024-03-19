local HM = hypermod

HM.debug = function(player, args)
    player.sp = tonumber(args)
end
COM_AddCommand("hm_debug", HM.debug, COM_ADMIN)