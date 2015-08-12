; Tremolo effect

Tremolo:
	move 	a,x:Original_Signal
	clr 	a
	clr 	b
	
	move 	x:Knob_3,b
	asr 	#18,b,b
	move 	b,x0
	
	move 	x:LFO_Counter,b
	add		x0,b
	move	b,x:Debug_Read_from_DSP_4
	move 	b,x:LFO_Counter
	
	move 	x:Thresh_3,x0
	cmp 	x0,b
	bsgt 	Restart
	
	move 	x:(r4),x0
	
	clr 	a
	clr 	b
	move 	x:Original_Signal,y0
	mpy 	x0,y0,b
	add 	y0,b
	move 	b,a
	
	bsr 	Level_Detection
	rts
	
Restart:
	move 	#0,x0
	move 	x0,x:LFO_Counter
	
	move 	#1,x0
	move 	r4,a
	add 	x0,a
	move 	a,r4
	
	clr 	a
	clr 	b
	
	move 	x:Thresh_4,y0
	move 	r4,b
	cmp 	y0,b
	bsgt	RestartAgain
	
	rts
	
RestartAgain:
	move 	#$100,x0
	move 	x0,r4
	rts
	
Level_Detection:
	move	a,x0
	clr 	a
	move 	x:Knob_1,x1
	mac 	x0,x1,a
	rts