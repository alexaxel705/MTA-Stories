local theTechnique = {}

function applyShader()
	if(getElementType(source) == "vehicle") then
		theTechnique[source] = dxCreateShader("ped_morph.fx")
		engineApplyShaderToWorldTexture(theTechnique[source], "*", source)
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), applyShader)
addEvent("applyShader", true)
addEventHandler("applyShader", root, applyShader)




addEventHandler("onClientVehicleCollision", root,
    function(collider,force, bodyPart, x, y, z, nx, ny, nz)
         if ( source == getPedOccupiedVehicle(localPlayer) ) then
             local fDamageMultiplier = getVehicleHandling(source).collisionDamageMultiplier
             local m = createMarker(x, y, z, "corona", force * fDamageMultiplier * 0.01, 0, 9, 231)
             setTimer(destroyElement, 2000, 1, m)
         end
    end
)




function DrawOnClientRender()
	for theVehicle, shader in pairs(theTechnique) do
	
	end
end
addEventHandler("onClientRender", root, DrawOnClientRender)


function removeShader(thePlayer, seat)
	if(getElementType(source) == "vehicle") then
        engineRemoveShaderFromWorldTexture(theTechnique[source], "vehiclegrunge256", source)
		destroyElement(theTechnique[source])
        --engineRemoveShaderFromWorldTexture(theTechnique, "?emap*", theVehicle)
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), removeShader)



function Start()
	for _, theVehicle in pairs(getElementsByType("vehicle", root, true)) do
		triggerEvent("applyShader", theVehicle)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), Start)
