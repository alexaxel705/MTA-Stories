local shaders = {}

function applyDeformationToVehicle(vehicle)
	if not vehicle or not isElement(vehicle) then return end
	if not shaders[vehicle] then
		shaders[vehicle] = dxCreateShader("fx/vertex.fx", 0, 0, false)
		engineApplyShaderToWorldTexture(shaders[vehicle], "*", vehicle)
		engineRemoveShaderFromWorldTexture(shaders[vehicle], 'vehicletyres128', vehicle)
		engineRemoveShaderFromWorldTexture(shaders[vehicle], 'unnamed', vehicle)
	end
	setElementData(vehicle, "used:deformations", {id = 1})
	setElementData(vehicle, "damage:multiplier", 3)
	local deformations = getElementData(vehicle, "vehicle:deformationsData")
	local idl = 1
	if deformations then
		for k,v in pairs(deformations) do
			dxSetShaderValue(shaders[vehicle], k, v)
			setElementData(vehicle, "used:deformations", {id = idl})
			idl = idl + 1
		end
	else
		setElementData(vehicle, "vehicle:deformationsData", {})
	end
end

function getFreeDeformation(vehicle)
	local deformation = getElementData(vehicle, "used:deformations")
	local free = deformation.id
	for i = 1, 22 do
		if not deformation[i] then
			free = i
			break
		end
	end
	deformation[free] = true
	deformation.id = deformation.id + 1
	if deformation.id >= 22 then
		deformation.id = 1
	end
	setElementData(vehicle, "used:deformations", deformation)
	return free
end

function resetVehicleDeformation(theVehicle)
	local deformations = getElementData(theVehicle, "vehicle:deformationsData")
	for i = 1, 22 do
		deformations["deformationDistance" .. i] = {0}
	end
	setElementData(theVehicle, "vehicle:deformationsData", deformations)
	if not isElementLocal(theVehicle) then
		triggerServerEvent("updateVehicleDeformation", resourceRoot, theVehicle)
	end
end


function reserVehicleComponent(vehicle)
	local getComponent = getVehicleComponents(vehicle)
    for k in pairs (getComponent) do
       resetVehicleComponentPosition(vehicle, k) 
    end
end
addEvent("reserVehicleComponent", true)
addEventHandler("reserVehicleComponent", localPlayer, reserVehicleComponent)




function addVehicleColision(theVehicle, bodyPart, x, y, z, dx, dy, dz, force, forceAdd)
	local tick = getElementData(theVehicle, "vehicle:deformationTick") or getTickCount()
	setElementData(theVehicle, "vehicle:deformationTick", getTickCount() + 1000)
	if tick > getTickCount() and not forceAdd then return end
	if not shaders[theVehicle] then
		applyDeformationToVehicle(theVehicle)
	end
	local free = getFreeDeformation(theVehicle)
	local dx, dy, dz = dx * force, dy * force, dz * force

	local deformations = getElementData(theVehicle, "vehicle:deformationsData")
	deformations["deformationPos" .. free] = {x, y, z}
	deformations["deformationData" .. free] = {dx, dy, dz}
	deformations["deformationDistance" .. free] = {force}
	setElementData(theVehicle, "vehicle:deformationsData", deformations)

	if(bodyPart == 3) then
		local dam = math.max(dx, dy)
		
		local x2, y2, z2 = getVehicleComponentPosition(theVehicle, "bonnet_dummy")
		if y2 then
			setVehicleComponentPosition(theVehicle, "bonnet_dummy", x2, y2-math.abs(dam*(force)), z2)
		end
		
		x2, y2, z2 = getVehicleComponentPosition(theVehicle, "bump_front_dummy")
		if y2 then
			setVehicleComponentPosition(theVehicle, "bump_front_dummy", x2, y2-math.abs(dam*(force)), z2)
		end
	elseif(bodyPart == 4) then
		local dam = math.max(dx, dy)/9
		
		local x2, y2, z2 = getVehicleComponentPosition(theVehicle, "boot_dummy")
		if y2 then
			setVehicleComponentPosition(theVehicle, "boot_dummy", x2, y2+math.abs(dam*(force)), z2)
		end
		
		x2, y2, z2 = getVehicleComponentPosition(theVehicle, "bump_rear_dummy")
		if y2 then
			setVehicleComponentPosition(theVehicle, "bump_rear_dummy", x2, y2+math.abs(dam*(force)), z2)
		end
	end

	if not isElementLocal(theVehicle) then
		triggerServerEvent("updateVehicleDeformation", resourceRoot, theVehicle)
	end
end

function loadVehicleDeformation(vehicle)
	local deformations = getElementData(vehicle, "vehicle:deformationsData")
	for k,v in pairs(deformations) do
		if not shaders[vehicle] then
			applyDeformationToVehicle(vehicle)
		end
		dxSetShaderValue(shaders[vehicle], k, v)
	end
end
addEvent("updateVehicleDeformation", true)
addEventHandler("updateVehicleDeformation", localPlayer, loadVehicleDeformation)




function applyInverseRotation(x,y,z, rx,ry,rz) -- https://wiki.multitheftauto.com/wiki/AttachElementsOffsets
    local DEG2RAD = (math.pi * 2) / 360
    rx = rx * DEG2RAD
    ry = ry * DEG2RAD
    rz = rz * DEG2RAD

    local tempY = y
    y =  math.cos ( rx ) * tempY + math.sin ( rx ) * z
    z = -math.sin ( rx ) * tempY + math.cos ( rx ) * z

    local tempX = x
    x =  math.cos ( ry ) * tempX - math.sin ( ry ) * z
    z =  math.sin ( ry ) * tempX + math.cos ( ry ) * z

    tempX = x
    x =  math.cos ( rz ) * tempX + math.sin ( rz ) * y
    y = -math.sin ( rz ) * tempX + math.cos ( rz ) * y

    return x, y, z
end

addEventHandler("onClientVehicleCollision", root, function(collider, force, bodyPart, x, y, z, nx, ny, nz)
	--if source == getPedOccupiedVehicle(localPlayer) then
		Boom(source, force, bodyPart, x, y, z, nx, ny, nz)
	--	Boom(collider, force, bodyPart, x, y, z, nx, ny, nz)
	--end
	cancelEvent()
end)


function Boom(theVehicle, force, bodyPart, x, y, z, nx, ny, nz)
	if not shaders[theVehicle] then
		applyDeformationToVehicle(theVehicle)
	end
	local px, py, pz = getElementPosition(theVehicle)
	local rx, ry, rz = getElementRotation(theVehicle)
	local x, y, z = px - x, py - y, pz  - z
	local x, y, z = applyInverseRotation(x, y, z, rx, ry, rz - 180)
	force = math.min(force, 400)
	local multiplier = getElementData(theVehicle, "damage:multiplier")
	addVehicleColision(theVehicle, bodyPart, x, y, z, -x * force/3000 * multiplier, -y * force/3000 * multiplier, -z * force/3000 * multiplier, force/400)
end




	
	
	
	
addEventHandler("onClientElementStreamIn", root, function ()
	if getElementType(source) == "vehicle" then
		if not shaders[source] then
			applyDeformationToVehicle(source)
			loadVehicleDeformation(source)
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if getElementType(source) == "vehicle" then
		if(shaders[source]) then
			destroyElement(shaders[source])
			shaders[source] = nil
		end
	end
end)



function setVehicleDamageMultiplier(vehicle, multiplier)
	setElementData(vehicle, "damage:multiplier", multiplier)
end



