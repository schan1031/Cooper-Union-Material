; Tremolo effect

Tremolo:
	move 	a,x:Original_Signal
	clr 	a
	clr 	b
	
	move 	x:Knob_3,b
	asr 	#19,b,b
	move 	b,x0
	
	move 	x:LFO_Counter,b
	add		x0,b
	move	b,x:Debug_Read_from_DSP_4
	move 	b,x:LFO_Counter
	
	move 	x:Thresh_1,y0
	cmp		y0,b
	bsle	Below
	
	cmp 	y0,b
	bsgt 	Above
	bsr 	Level_Detection
	
	rts

Below:
	clr 	a
	clr 	b
	
	move 	x:Original_Signal,a
	
	move 	#>$400000,x0
	move 	x0,x:Debug_Read_from_DSP_1
	rts
	
Above:
	clr 	a
	
	move	x:Thresh_2,y0
	cmp 	y0,b
	bsgt 	Restart
	
	clr 	b
	
	move 	x:Original_Signal,a
	move 	a,y0
	move 	x:Knob_2,x0
	mac 	x0,y0,b
	
	clr 	a
	move	b,a
	
	move 	#>$500000,x0
	move 	x0,x:Debug_Read_from_DSP_1
	
	rts
	
Restart:
	move 	#0,x0
	move 	x0,x:LFO_Counter
	rts
	
Level_Detection:
	move	a,x0
	clr 	a
	move 	x:Knob_1,x1
	mac 	x0,x1,a
	rts