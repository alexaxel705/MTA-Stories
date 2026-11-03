addEvent("updateVehicleDeformation", true)
addEventHandler("updateVehicleDeformation", resourceRoot, function(vehicle)
	triggerClientEvent(root, "updateVehicleDeformation", root, vehicle)
end)

function setVehicleDamageMultiplier(vehicle, multiplier)
	setElementData(vehicle, "damage:multiplier", multiplier)
end

function getVehicleDeformation(vehicle)
	local deformations = getElementData(vehicle, "vehicle:deformationsData")
	return deformations
end

function setVehicleDeformation(vehicle, data)
	deformations = {}
	for i = 1,22 do
		deformations["deformationPos" .. i] = {0, 0, 0}
		deformations["deformationData" .. i] = {0, 0, 0}
		deformations["deformationDistance" .. i] = {0}
	end
	setElementData(vehicle, "vehicle:deformationsData", data)
	triggerClientEvent(root, "updateVehicleDeformation", root, vehicle)
	return true
end

function resetVehicleDeformation(vehicle)
	deformations = {}
	for i = 1,22 do
		deformations["deformationPos" .. i] = {0, 0, 0}
		deformations["deformationData" .. i] = {0, 0, 0}
		deformations["deformationDistance" .. i] = {0}
	end
	setElementData(vehicle, "vehicle:deformationsData", deformations)
	triggerClientEvent(root, "updateVehicleDeformation", root, vehicle)
	triggerClientEvent(root, "reserVehicleComponent", root, vehicle)
	return true
end