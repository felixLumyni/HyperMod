local HM = hypermod

HM.debug = function(player, args)
    if not player == server then return end
    for p in players.iterate do
        p.sp = tonumber(args)
    end
end
COM_AddCommand("hm_debug", HM.debug, COM_ADMIN)