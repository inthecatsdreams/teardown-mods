function tick(dt)
	
	
	
	
	
	--SetInt("game.fire.maxcount", 99999999999)	
	if GetBool("level.alarm") then
		local t = GetFloat("level.alarmtimer")
		local f = GetInt("game.fire.maxcount")	
		
		
		if t > 0 and t <= 60 then
			
			
			
			
			t = t + dt*1
			f = 200
			SetInt("game.fire.maxcount", f)
		
			SetFloat("level.alarmtimer", t)
		end


	end
end


