function getPlayerCity(thePlayer)
	return getElementData(thePlayer, "City") or "San Andreas"
end

local OriginalSize = 6000
local MapSizeX, MapSizeY = 1024, 1024
local SizeCoeff = MapSizeX/OriginalSize
local MapCenterX, MapCenterY = MapSizeX/2, MapSizeY/2
local MapTarget = false
local PathNodes = exports["vehicle_node"]:GetVehicleNodesClient()
local RailRoadsSA = exports["vehicle_node"]:GetRailnodes()



function map2dDraw()
	dxSetRenderTarget(MapTarget, true)
	dxSetBlendMode("modulate_add")
	
	dxDrawRectangle(0, 0, MapSizeX, MapSizeY, tocolor(202,144,72, 255))
	
	if(getPlayerCity(localPlayer) == "San Andreas") then
		for zone, arr in pairs(RailRoadsSA) do
			for i, arr2 in pairs(arr) do
				
				local nextmarkers = {}
				if(arr2[6]) then
					for _,k in pairs(arr2[6]) do
						table.insert(nextmarkers, {k[1], k[2]})
					end
				end
				
				if(RailRoadsSA[zone][i+1]) then
					table.insert(nextmarkers, {zone, i+1})
				end
				
				local x1 = (arr2[2]*SizeCoeff)+MapCenterX
				local y1 = (-(arr2[3]*SizeCoeff))+MapCenterY
				
				for _, arr3 in pairs(nextmarkers) do
					if(RailRoadsSA[arr3[1]]) then
						local dat = RailRoadsSA[arr3[1]][arr3[2]]
						
						local x2 = (dat[2]*SizeCoeff)+MapCenterX
						local y2 = (-(dat[3]*SizeCoeff))+MapCenterY
						dxDrawLine(x1, y1, x2, y2, tocolor(99,0,0,255), 3)
					end
				end
			end
		end
	end
	
	
	
	for zone, arr in pairs(PathNodes[getPlayerCity(localPlayer)]) do
		if(arr) then 
			for i, arr2 in pairs(arr) do
			
				--dxDrawLine(arr2[2], arr2[3]+1, arr2[2]+1, arr2[3])
			
				local nextmarkers = {}
				if(arr2[6]) then
					for _,k in pairs(arr2[6]) do
						table.insert(nextmarkers, {k[1], k[2]})
					end
				end
				
				if(PathNodes[getPlayerCity(localPlayer)][zone][i+1]) then
					table.insert(nextmarkers, {zone, i+1})
				end
				
				local x1 = (arr2[2]*SizeCoeff)+MapCenterX
				local y1 = (-(arr2[3]*SizeCoeff))+MapCenterY
				for _, arr3 in pairs(nextmarkers) do
					local dat = PathNodes[getPlayerCity(localPlayer)][arr3[1]][arr3[2]]
					local x2 = (dat[2]*SizeCoeff)+MapCenterX
					local y2 = (-(dat[3]*SizeCoeff))+MapCenterY
					local color = tocolor(0,0,0,255)
					if(dat[1] == "Closed") then
						color = tocolor(115,101,82,255)
					end
					dxDrawLine(x1, y1, x2, y2, color, 3)
				end
			end
		end
	end
	
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
	return MapTarget
end




local screenWidth,screenHeight = guiGetScreenSize()
local toggle = false
local pixelsPerMeter = screenHeight/OriginalSize
toggleControl("radar",false)
local hSize = (pixelsPerMeter*OriginalSize)
local vSize = (pixelsPerMeter*OriginalSize)
local CentreX = (screenWidth/2)-(hSize/2)
local CentreY = (screenHeight/2)-(vSize/2)




local RenderQuality = 1
-- RenderTarget, x,y,alpha, Handler для перерисовки
local RenderTargets = {
	["Map"] = {false, screenWidth, screenHeight, true, "drawMapHandler"},
}

function UpdateTargets()
	for name, dat in pairs(RenderTargets) do
		if(dat[1]) then
			destroyElement(dat[1])			
		end
		dat[1] = dxCreateRenderTarget(dat[2]*RenderQuality, dat[3]*RenderQuality, dat[4])
		if(dat[5]) then
			triggerEvent(dat[5], localPlayer)
		end
	end
end


function RenderQualityChecker(theKey, oldValue, newValue)
    if theKey == "RenderQuality" and source == localPlayer then
		if(newValue) then
			RenderQuality = tonumber(getElementData(localPlayer, "RenderQuality"))
			if(not MapTarget) then
				MapTarget = dxCreateRenderTarget(MapSizeX, MapSizeX, false)
				map2dDraw()
			end
			SanAndreasRadar(true)
		else
			RenderQuality = 1
			SanAndreasRadar(false)
		end
		UpdateTargets()
    end
end
addEventHandler("onClientElementDataChange", root, RenderQualityChecker)



local DimensionCity = {
	[0] = "San Andreas",
	[1] = "Liberty City", 
	[2] = "Vice City"
}

function drawMap()
	dxSetRenderTarget(RenderTargets["Map"][1], true)
	dxSetBlendMode("modulate_add")
	
	local x = RenderTargets["Map"][2]*RenderQuality
	local y = RenderTargets["Map"][3]*RenderQuality
	
	pixelsPerMeter = y/OriginalSize
	
	local hSize = hSize*RenderQuality
	local vSize = vSize*RenderQuality
	
	CentreX = ((x/2)-(hSize/2))
	CentreY = ((y/2)-(vSize/2))
	
	if(MapTarget) then
		dxDrawImage(CentreX,CentreY,hSize,vSize,MapTarget,0,0,0,tocolor(255,255,255,240),false)
	else
		local city = getPlayerCity(localPlayer)
		if(city == "San Andreas") then
			dxDrawImage(CentreX,CentreY,hSize,vSize,"radar.png",0,0,0,tocolor(255,255,255,240),false)
		elseif(city == "Vice City") then
			dxDrawImage(CentreX,CentreY,hSize,vSize,exports["vc"]:GetVCMap(),0,0,0,tocolor(255,255,255,240),false)
		elseif(city == "Liberty City") then
			dxDrawImage(CentreX,CentreY,hSize,vSize,exports["lc"]:GetLCMap(),0,0,0,tocolor(255,255,255,240),false)
		end
	end
	
	drawRadarAreas()
	drawBlips()
	drawLocalPlayerArrow()
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
	return RenderTargets["Map"][1]
end
addEvent("drawMapHandler", true)
addEventHandler("drawMapHandler", root, drawMap)



function drawMapRender()
	dxDrawImage(0,0,screenWidth,screenHeight, drawMap())
end




function drawRadarAreas()
	local radarareas = getElementsByType("radararea")
	local tick = math.abs(getTickCount()%1000-500)
	local aFactor = tick/500
	
	for k,v in ipairs(radarareas) do
		local x,y = getElementPosition(v)
		local sx,sy = getRadarAreaSize(v)
		local r,g,b,a = getRadarAreaColor(v)
		local flashing = isRadarAreaFlashing(v)
		
		if flashing then
			a=a*aFactor
		end
		
		local hx1,hy1 = getMapFromWorldPosition(x,y+sy)
		local hx2,hy2 = getMapFromWorldPosition(x+sx,y)
		local width = hx2-hx1
		local height = hy2-hy1
		
		dxDrawRectangle(hx1,hy1,width,height,tocolor(r,g,b,a),false)
	end
end



function drawBlips()
	for k,v in ipairs(getElementsByType("blip")) do
		local icon = getBlipIcon(v) or 0
		local size = (getBlipSize(v) or 2)*4
		local r,g,b,a = getBlipColor(v)
		
		if icon ~= 0 then
			r,g,b=255,255,255
			size=16
		end
		
		local x,y,z = getElementPosition(v)
		x,y = getMapFromWorldPosition(x,y)
		
		local size = size*RenderQuality
		local halfsize = size/2
		
		
		dxDrawImage(x-halfsize,y-halfsize,size,size,"blips/"..icon..".png",0,0,0,tocolor(r,g,b,a),false)
	end
end



function drawLocalPlayerArrow()
	local x,y,z = getElementPosition(localPlayer)
	local r = getPedRotation(localPlayer)
	
	local mapX,mapY = getMapFromWorldPosition(x,y)
	
	local size = 16*RenderQuality
	local halfsize = size/2
	
	dxDrawImage(mapX-halfsize,mapY-halfsize,size,size,"blips/2.png",(-r)%360,0,0,tocolor(255,255,255,255),false)
end


function toggleMap()
	if toggle  then
		toggle = false
		removeEventHandler("onClientRender",getRootElement(), drawMapRender)
	else
		toggle = true
		addEventHandler("onClientRender",getRootElement(), drawMapRender)
	end
end
bindKey("F11", "up", toggleMap)



function getMapFromWorldPosition(worldX,worldY)
	local mapX = CentreX+pixelsPerMeter*(worldX-(-3000))
	local mapY = CentreY+pixelsPerMeter*((3000)-worldY)
	return mapX,mapY
end






local radar = {}
local ROW_COUNT = 12
local Size = MapSizeX/ROW_COUNT
local shaders = {}


function SanAndreasRadar(render)
	if(render) then
		for i1 = 1, ROW_COUNT do
			for i2 = 1, ROW_COUNT do
				local GTAID = "radar"..string.format("%02.f", ((i1-1)*ROW_COUNT)+(i2-1))
			
				if(radar[GTAID]) then
					destroyElement(radar[GTAID])
				end
				
				if(not shaders[GTAID]) then
					shaders[GTAID] = dxCreateShader("texreplace.fx")
				end
				
				radar[GTAID] = dxCreateRenderTarget(Size*RenderQuality, Size*RenderQuality, false)
				dxSetRenderTarget(radar[GTAID], true)
				dxSetBlendMode("modulate_add")
				
				dxDrawImageSection(0,0, Size*RenderQuality, Size*RenderQuality, (i2-1)*Size,(i1-1)*Size, Size, Size,MapTarget, 0)
				
				dxSetBlendMode("blend")
				dxSetRenderTarget()
				
				dxSetShaderValue(shaders[GTAID], "gTexture", radar[GTAID])
				engineApplyShaderToWorldTexture(shaders[GTAID], GTAID)
			end
		end
	else
		for GTAID, shader in pairs(shaders) do
			engineRemoveShaderFromWorldTexture(shaders[GTAID], GTAID)
			destroyElement(radar[GTAID])
			radar[GTAID] = false
			destroyElement(shaders[GTAID])
			shaders[GTAID] = false
		end
		destroyElement(MapTarget)
		MapTarget = false
	end
end






local VehiclesInStream = {}




function StreamIn()
	if(getElementType(source) == "vehicle") then
		VehiclesInStream[source] = {}
		if(getElementData(source, "owner")) then
			if(getElementData(source, "owner") == getPlayerName(localPlayer)) then
				VehiclesInStream[source]["blip"] = createBlipAttachedTo(source, 0, 1, 170,170,170,170,1)
			end
		end
	end
end
addEvent("onClientElementStreamIn", true)
addEventHandler("onClientElementStreamIn", getRootElement(), StreamIn)




function StreamOut()
	if(getElementType(source) == "vehicle") then
		if(VehiclesInStream[source]) then
			for _, obj in pairs(VehiclesInStream[source]) do
				if(isElement(obj)) then
					destroyElement(obj)
				end
			end
		end
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), StreamOut)
addEventHandler("onClientVehicleExplode", getRootElement(), StreamOut)
			


function Start()
	for _,theVehicle in pairs(getElementsByType("vehicle", getRootElement(), true)) do
		triggerEvent("onClientElementStreamIn", theVehicle)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), Start)




