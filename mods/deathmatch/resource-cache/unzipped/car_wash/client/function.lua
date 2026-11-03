setTimer(function()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and getVehicleController(vehicle) == localPlayer then
		local newX, newY, newZ = getElementPosition(vehicle)
		if oldX and oldY and oldZ then
			local curentDistance = getDistanceBetweenPoints3D(oldX, oldY, oldZ, newX, newY, newZ)
			if curentDistance >= 1 then
				local coef = 1
				local _, _, _, _, _, _, _, _, surface = processLineOfSight(newX, newY, newZ, newX, newY, newZ - 5, true, false, false, true)
				if surface then
					if surface ~= 0 and surface ~= 1 and surface ~= 4 then
						coef = dirtCoef
					end
				end
				local curentDirt = getElementData(vehicle, "vehicle:dirt") or 0
				local oldDistance = getElementData(vehicle, "vehicle:distance") or 0
				local totalDistance = oldDistance + curentDistance * coef
				setElementData(vehicle, "vehicle:distance", totalDistance)
				for i = 1, #dirtLevel do
					if totalDistance > dirtLevel[i][1] then
						if curentDirt ~= dirtLevel[i][2] then
							setElementData(vehicle, "vehicle:dirt", dirtLevel[i][2])
						end
						break
					end
				end
			end
		end
		oldX, oldY, oldZ = newX, newY, newZ
	end
end, (updateTime * 1000), 0)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		for _, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
			addDirt(v)
		end
		for i, c in ipairs(clearStation) do
			clearStationList[i] = createMarker(c[1], c[2], c[3], "corona", 3, 25, 255, 25, 50)
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function(theKey)
		if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
			if theKey == "vehicle:dirt" then
				addDirt(source)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function()
		if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
			addDirt(source)
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function()
		if getElementType(source) == "vehicle" then
			removeDirt(source)
		end
	end
)

addEventHandler ( "onClientMarkerHit", getRootElement(),
	function(hitElement, matchingDimension)
		if hitElement == localPlayer then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle and getVehicleController(vehicle) == localPlayer then
				local curentDirt = getElementData(vehicle, "vehicle:dirt") or 0
				if curentDirt > 0 then
					for _, c in ipairs(clearStationList) do
						if source == c and matchingDimension then
							outputChatBox("Чистка автомобиля началась")
							if clearTimer[vehicle] then
								killTimer(clearTimer[vehicle])
								clearTimer[vehicle] = nil
							end
							clearTimer[vehicle] = setTimer(function(vehicle)
								if isElement(vehicle) then
									local curentDirt = getElementData(vehicle, "vehicle:dirt") or 0
									local curentDirt = curentDirt - 1
									setElementData(vehicle, "vehicle:dirt", curentDirt)
									for i = 1, #dirtLevel do
										if dirtLevel[i][2] == curentDirt then
											setElementData(vehicle, "vehicle:distance", dirtLevel[i][1])
										end
									end
									if curentDirt == 0 then
										killTimer(clearTimer[vehicle])
										clearTimer[vehicle] = nil
										outputChatBox("Чистка автомобиля закончена")
									end
								else
									killTimer(clearTimer[vehicle])
									clearTimer[vehicle] = nil
								end
							end, (cleartTime * 1000), 0, vehicle)
							break
						end
					end
				else
					outputChatBox("Ваш автомобиль чистый")
				end
			end
		end
	end
)

addEventHandler ( "onClientMarkerLeave", getRootElement(),
	function(leaveElement, matchingDimension)
		if leaveElement == localPlayer then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle and getVehicleController(vehicle) == localPlayer then
				for _, c in ipairs(clearStationList) do
					if source == c and matchingDimension then
						if clearTimer[vehicle] then
							killTimer(clearTimer[vehicle])
							clearTimer[vehicle] = nil
							outputChatBox("Чистка автомобиля отменена")
						end
					end
				end
			end
		end
	end
)

function addDirt(element)
	local curentDirt = getElementData(element, "vehicle:dirt") or 0
	if curentDirt >= 0 then
		if not dirtShaderVehicle[element] then
			dirtShaderVehicle[element] = dxCreateShader("files/paintjob.fx", 0, 0, false, "vehicle")
		end
		if dirtTextureVehicle[element] then
			destroyElement(dirtTextureVehicle[element])
		end
		dirtTextureVehicle[element] = dxCreateTexture("files/"..curentDirt..".png")
		if dirtShaderVehicle[element] and dirtTextureVehicle[element] then
			dxSetShaderValue(dirtShaderVehicle[element], "paintjobTexture", dirtTextureVehicle[element])
			for i = 1, #textureName do
				engineApplyShaderToWorldTexture(dirtShaderVehicle[element], textureName[i], element)
			end
		end
	end
end

function removeDirt(element)
	if dirtShaderVehicle[element] then
		for i = 1, #textureName do
			engineRemoveShaderFromWorldTexture(dirtShaderVehicle[element], textureName[i], element)
		end
		destroyElement(dirtShaderVehicle[element])
		dirtShaderVehicle[element] = nil
	end
	if dirtTextureVehicle[element] then
		destroyElement(dirtTextureVehicle[element])
		dirtTextureVehicle[element] = nil
	end
end