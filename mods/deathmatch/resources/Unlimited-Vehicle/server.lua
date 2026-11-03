function CreateVehicle(model, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	local theVehicle = createVehicle(404, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	setElementData(theVehicle, "model", model)
	return theVehicle
end

--for i = 610, 736 do
--	local v = CreateVehicle(i, -222.2+((i-600)*45), 2672, 100, 0,0,90)
--	setElementFrozen(v, true)
--end

local UsedIds = {}



local FreeIds = {}
for v = 400, 611 do
	local vt = GetVehicleType(v)
	if(not FreeIds[vt]) then FreeIds[vt] = {} end
	FreeIds[vt][#FreeIds[vt]+1] = v
end

function VehicleStreamer()
	local CleanUp = {}
	for _, theVehicle in pairs(getElementsByType "vehicle") do
		local model = getElementData(theVehicle, "model") or 9999
		if(UsedIds[model]) then
			if(not CleanUp[model]) then CleanUp[model] = 0 end
			if(getElementSyncer(theVehicle)) then
				CleanUp[model] = CleanUp[model]+1
			end
		end
	end
	
	for model, count in pairs(CleanUp) do
		if(count == 0) then
			table.insert(FreeIds[ModelsName[model][3]], UsedIds[model])
			UsedIds[model] = nil
		end
	end
	return true
end




function GetFreeIds(VehicleType)
	if(#FreeIds[VehicleType] == 0) then
		VehicleStreamer()
	end
	
	local out = FreeIds[VehicleType][#FreeIds[VehicleType]]
	table.remove(FreeIds[VehicleType], #FreeIds[VehicleType])
	return out
end




function SyncVehicleEl(thePlayer, theVehicle)
	if(isElement(theVehicle)) then
		local model = getElementData(theVehicle, "model")
		if(model) then
			if(not UsedIds[model]) then
				UsedIds[model] = GetFreeIds(ModelsName[model][3])
			end
			
			setElementModel(theVehicle, UsedIds[model])
			for k,h in pairs(getOriginalHandling(411)) do
				setVehicleHandling(theVehicle, k, h)
			end
			
			triggerClientEvent(thePlayer, "LoadVehicleToModel", thePlayer, theVehicle, model, UsedIds[model])
		end
	end
end
addEvent("SyncVehicleEl", true)
addEventHandler("SyncVehicleEl", root, SyncVehicleEl)






function getfreeids(thePlayer, command, h)
	for types, arr in pairs(FreeIds) do
		outputConsole(types.." :"..getArrSize(arr))
	end
end
addEventHandler("getfreeids", root, getfreeids)
addCommandHandler("getfreeids", getfreeids)

function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end


