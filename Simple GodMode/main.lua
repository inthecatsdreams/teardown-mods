enabled = false
-- 0.030 ---
function tick(dt)
	if PauseMenuButton("Respawn") then
		RespawnPlayer()
	else	
	SetPlayerHealth(1)
	end
	if InputPressed("m") then
		enabled = true
	elseif InputPressed("x") then
		enabled = false
	end


end

-- 0.001 --- 
function update(dt)
	if enabled then
		SetPlayerHealth(1)
	end


		
end

function draw()
	if enabled == true then
		UiFont("regular.ttf", 24)
		UiTranslate(UiWidth()-30, 30)
		UiScale(1.5)
		UiColor(1, 1, 1, 0.5)
		UiAlign("top right")
		UiText("GODMODE IS ON:X to disable")
		UiAlign("top center")
		UiTranslate(-(UiWidth()-30)/2, 30)
		UiFont("regular.ttf", 50)
		UiColor(0, 0, 0, 1)
		UiTranslate(45,5)
	elseif enabled == false then
		UiFont("regular.ttf", 24)
		UiTranslate(UiWidth()-30, 30)
		UiScale(1.5)
		UiColor(1, 1, 1, 0.5)
		UiAlign("top right")
		UiText("GODMODE IS OFF: M to enable")
		UiAlign("top center")
		UiTranslate(-(UiWidth()-30)/2, 30)
		UiFont("regular.ttf", 50)
		UiColor(0, 0, 0, 1)
		UiTranslate(45,5)
	end
	
end