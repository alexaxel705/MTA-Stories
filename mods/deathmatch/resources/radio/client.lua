local voi = false
local track = false



setTimer(function()
	local Radio = fromJSON(getElementData(root, "Radio"))
	if(Radio) then
		if(not track) then
			voi = playSound(Radio[1])
			setSoundVolume(voi, 0.0)
			track = Radio[1]
		else
			if(track ~= Radio[1]) then
				track = false
				stopSound(voi)
			else
				local mypos = math.round(getSoundPosition(voi))
				local serverpos = math.round(Radio[2])
				if(Raznica(mypos, serverpos) > 3) then -- если расхождение больше 3-х секунд
					setSoundPosition(voi, Radio[2])
					--outputConsole(mypos.." "..serverpos)
				else
					setSoundVolume(voi, 1)
				end
			end
		end
	end
end, 1000, 0)


function Raznica(var1, var2)
	local var3 = var1-var2
	if(var3 < 0) then
		var3 = var3-var3-var3
	end
	return var3
end




function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
