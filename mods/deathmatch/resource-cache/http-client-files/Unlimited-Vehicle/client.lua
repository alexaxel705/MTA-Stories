local FileProcess = {}


local Txds = {}
local Dffs = {}



local AlreadyReplace = {}
function LoadVehicleToModel(theVehicle, newmodel, model)
	if(Txds[newmodel] and Dffs[newmodel]) then 
		if(AlreadyReplace[newmodel]) then
			if(AlreadyReplace[newmodel] == model) then
				setElementAlpha(theVehicle, 255)
				return false
			end
		end
		
		setElementAlpha(theVehicle, 255)
		AlreadyReplace[newmodel] = model
		engineImportTXD(Txds[newmodel], model)
		engineReplaceModel(Dffs[newmodel], model, true)
	else
		setTimer(function()
			LoadVehicleToModel(theVehicle, newmodel, model)
		end, 1000, 1)
	end
	
end
addEvent("LoadVehicleToModel", true)
addEventHandler("LoadVehicleToModel", getRootElement(), LoadVehicleToModel)





function onDownloadFinish(file, success)
    if(source == resourceRoot) then
        if(success) then
			if(Txds[FileProcess[file]] == true) then
				Txds[FileProcess[file]] = engineLoadTXD(ModelsName[FileProcess[file]][1]..".txd")
			else
				Dffs[FileProcess[file]] = engineLoadDFF(ModelsName[FileProcess[file]][1]..".dff")
			end
			FileProcess[file] = nil
        end
    end
end
addEventHandler("onClientFileDownloadComplete", root, onDownloadFinish)






function VehStreamIn()
	if(getElementType(source) == "vehicle") then
		local model = getElementData(source, "model") or 9999
		if(ModelsName[model]) then
			setElementAlpha(source, 100)
			triggerServerEvent("SyncVehicleEl", root, localPlayer, source)
			if(not Txds[model]) then
				Txds[model] = true
				FileProcess[ModelsName[model][1]..".txd"] = model
				FileProcess[ModelsName[model][1]..".dff"] = model
				downloadFile(ModelsName[model][1]..".txd")
				downloadFile(ModelsName[model][1]..".dff")
			end
		end
	end
end
addEvent("onClientElementStreamIn", true)
addEventHandler("onClientElementStreamIn", getRootElement(), VehStreamIn)





function Start()
	for _, theVehicle in pairs(getElementsByType("vehicle", getRootElement(), true)) do
		triggerEvent("onClientElementStreamIn", theVehicle)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), Start)









