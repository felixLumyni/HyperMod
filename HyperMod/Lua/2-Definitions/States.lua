states[S_PLAY_SPECIAL] = {
	sprite = SPR_PLAY, 
	frame = SPR2_TRNS|FF_ANIMATE|FF_FULLBRIGHT, 
	tics = 28, 
	action = A_ForceStop, 
	var1 = 6, 
	var2 = 4, 
	nextstate = S_PLAY_FALL
}