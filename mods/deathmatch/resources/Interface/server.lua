function getVehicleOneGear(engineAcceleration, dragCoeff, numberOfGears) -- engineAcceleration, dragCoeff, numberOfGears
	return (math.sqrt(3300*engineAcceleration/dragCoeff)*1.18)/numberOfGears
end

local Gears = {}


function ManualGear(theVehicle, seat)
	local VH = getVehicleHandling(theVehicle)
	
	--if(not Gears[source]) then Gears[source] = 1 end
	--setElementData(source, "ManualGear", Gears[source])
	--
	--local OneGear = getVehicleOneGear(VH["engineAcceleration"], VH["dragCoeff"], VH["numberOfGears"])
	--setVehicleHandling(theVehicle, "maxVelocity", OneGear*Gears[source])
	--
	--bindKey(source, "lshift", "down", GearUP)
	--bindKey(source, "lctrl", "down", GearDown)
end
addEventHandler("onPlayerVehicleEnter", root, ManualGear)



function GearDown(source)
	local theVehicle = getPedOccupiedVehicle(source)
	local VH = getVehicleHandling(theVehicle)
	if(Gears[source] > 1) then
		Gears[source] = Gears[source]-1
		setElementData(source, "ManualGear", Gears[source])
		
		local OneGear = getVehicleOneGear(VH["engineAcceleration"], VH["dragCoeff"], VH["numberOfGears"])
		setVehicleHandling(theVehicle, "maxVelocity", OneGear*Gears[source])
	end
end


function GearUP(source)
	local theVehicle = getPedOccupiedVehicle(source)
	local VH = getVehicleHandling(theVehicle)
	if(VH["numberOfGears"] > Gears[source]) then
		Gears[source] = Gears[source]+1
		setElementData(source, "ManualGear", Gears[source])
		
		local OneGear = getVehicleOneGear(VH["engineAcceleration"], VH["dragCoeff"], VH["numberOfGears"])
		setVehicleHandling(theVehicle, "maxVelocity", OneGear*Gears[source])
	end
end



function kickme(thePlayer, reason)
	 kickPlayer(thePlayer)
end
addEvent("kickme", true)
addEventHandler("kickme", root, kickme)




function preLoad()
	for theKey,thePlayer in ipairs(getElementsByType("player")) do
		if(getPedOccupiedVehicle(thePlayer)) then
			if(getPedOccupiedVehicleSeat(thePlayer) == 0) then
				triggerEvent("onPlayerVehicleEnter", thePlayer, getPedOccupiedVehicle(thePlayer), 0)
			end
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), preLoad)
