local Songs = {
	[1] = {"http://109.227.228.4/engine/include/MTA/music/okudjava-moi-kon.mp3", 148}, 
	[2] = {"http://109.227.228.4/engine/include/MTA/music/kim-kavalery.mp3", 129}, 
	[3] = {"http://109.227.228.4/engine/include/MTA/music/nikulin-kloun.mp3", 127}, 
	
	

}


local song = math.random(1,2)
local pos = math.random(Songs[song][2])


setTimer(function()
	pos = pos+1
	if(pos >= Songs[song][2]) then
		if(Songs[song+1]) then
			song = song+1
			pos = 0
		else
			song = 1
			pos = 0
		end
	end
	
	local Radio = {Songs[song][1], pos}
	setElementData(root, "Radio", toJSON(Radio))
end, 1000, 0)