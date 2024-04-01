local HM = hypermod

HM.satsuhud = function(v, player, cam)
	if HM.valid(player.mo) and not player.playerstate then
		if player.mo.satsued or player.mo.satsuer then
			v.drawFill()
		elseif player.mo.satsuing then
			local flags = V_HUDTRANS|V_SNAPTOBOTTOM|V_PERPLAYER
			local text = (leveltime % 3 == 0) and "" or "COLLIDE!"
			v.drawString(160, 176, text, flags, "thin-center")
		end
	end
end
hud.add(HM.satsuhud, "game")