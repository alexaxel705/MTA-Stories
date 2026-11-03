fadeCamera(true)
local Images = {}
local screenWidth, screenHeight = guiGetScreenSize()
local scale = ((screenWidth/1920)+(screenHeight/1080))
local scalex = (screenWidth/1920)
local scaley = (screenHeight/1080)
local ScreenGenSource = dxCreateScreenSource(150, 150) -- Устанавливает качество
local Loading = false
local x,y,z = 4000, 4000, 4000
local TexturesPosition = {} -- [name] = {Model, X,Y,Z, lookAtX,lookAtY,lookAtZ, roll, fov, Порог срабатывания хромакея}
local PreloadTextures = {} -- [Name] = Element
local CreateTextureStage = false

function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end

function updateCamera()	
	if(CreateTextureStage) then
		if(CreateTextureStage[2] == 1) then
			local x,y,z = getElementPosition(PreloadTextures[CreateTextureStage[1]])
			local model = CreateTextureStage[1]
			setCameraMatrix(x+TexturesPosition[model][2],y+TexturesPosition[model][3],z+TexturesPosition[model][4], x+TexturesPosition[model][5],y+TexturesPosition[model][6],z+TexturesPosition[model][7], TexturesPosition[model][8], TexturesPosition[model][9])
			
			if(isElementStreamedIn(PreloadTextures[CreateTextureStage[1]])) then
				CreateTextureStage[2] = 4
			else
				CreateTextureStage[2] = 2
			end
		end
	end
end


function DrawOnClientRender()
	if(CreateTextureStage) then
		if(CreateTextureStage[2] == 2) then
			dxUpdateScreenSource(ScreenGenSource)
			CreateTextureStage[2] = 3
		elseif(CreateTextureStage[2] == 4) then
			dxUpdateScreenSource(ScreenGenSource)

			local name = CreateTextureStage[1]
			local pixels = dxGetTexturePixels(ScreenGenSource)
			
			-- Если игра свернута, dxGetTexturePixels вернет false.
			-- Прерываем выполнение этой итерации и ждем разворачивания игры.
			if not pixels then return end 

			local x, y = dxGetPixelsSize(pixels)
			if not x or not y then return end

			local texture = dxCreateTexture(x, y, "argb")
			if not texture then return end

			local pixels2 = dxGetTexturePixels(texture)
			if not pixels2 then return end

			for y2 = 0, y - 1 do
				for x2 = 0, x - 1 do
					local colors = {dxGetPixelColor(pixels, x2, y2)}
					if (colors[CreateTextureStage[3]] < TexturesPosition[name][10]) then
						dxSetPixelColor(pixels2, x2, y2, colors[1], colors[2], colors[3], colors[4])
					end
				end
			end
			
			dxSetTexturePixels(texture, pixels2)
			Images[CreateTextureStage[1]] = texture
			destroyElement(PreloadTextures[CreateTextureStage[1]])
			PreloadTextures[CreateTextureStage[1]] = nil
			CreateTextureStage = false
			GenerateTexture()
		end
	end
	
	if(Loading) then
		dxDrawRectangle(0,0,screenWidth, screenHeight, tocolor(0,0,0,255))
        
		dxDrawRectangle(100*scale, screenHeight-(100*scale),screenWidth-(200*scale), 15*scale, tocolor(45,50,70,255))
		dxDrawRectangle(100*scale, screenHeight-(100*scale),(screenWidth-(200*scale))*(Loading/100), 15*scale, tocolor(83,104,147,255))
	end
end




function StreamIn(restream)
	if(CreateTextureStage) then
		if(CreateTextureStage[2] == 3) then
			if(PreloadTextures[CreateTextureStage[1]] == source) then
				CreateTextureStage[2] = 4
			end
		end
	end
end

function GenerateTexture(data)
	if(not Loading) then
		TexturesPosition = data
		setElementInterior(localPlayer, 0)
		setElementDimension(localPlayer, 0)
		local radius = 0
		for name, dat in pairs(TexturesPosition) do
			x = x-radius
			PreloadTextures[name] = createObject(dat[1],x,y,z)
			setElementInterior(PreloadTextures[name], 0)
			setElementDimension(PreloadTextures[name], 0)
			radius = getElementRadius(PreloadTextures[name])*15
			x = x-radius
		end
	
		Loading = 0
		addEventHandler("onClientPreRender", getRootElement(), updateCamera)
		addEventHandler("onClientRender", root, DrawOnClientRender)
		addEventHandler("onClientElementStreamIn", getRootElement(), StreamIn)
	end

	if(Loading == 100) then
		triggerEvent("GenerateTextureCompleted", root, Images)
	else
		Loading = 100-(getArrSize(PreloadTextures)/100)*getArrSize(TexturesPosition)
		local LoadTexture = false

		for name, _ in pairs(PreloadTextures) do
			LoadTexture = name
			break
		end
		
		setTime(12, 0)
		setWeather(0)
		setFogDistance(600)
		setFarClipDistance(500)
		setMinuteDuration(1000)
		setCloudsEnabled(false)
		if(LoadTexture) then
			setFogDistance(300)
			if(LoadTexture == "Рыба" or LoadTexture == "Кастет" or LoadTexture == "Деньги" or LoadTexture == "Газета" or LoadTexture == "М16") then
				setSkyGradient(0,0,255,0,0,255)
				CreateTextureStage = {LoadTexture, 1, 3} -- 3 Синий хромакей
			elseif(LoadTexture == "Скот") then
				setSkyGradient(255,0,0,255,0,0)
				CreateTextureStage = {LoadTexture, 1, 1} -- 1 Красный хромакей
			else
				setSkyGradient(0,255,0,0,255,0)
				CreateTextureStage = {LoadTexture, 1, 2} -- 2 Зеленый хромакей
			end
		else
			Loading = 100
			setSkyGradient(0,0,0, 0,0,0)
			triggerEvent("GenerateTextureCompleted", root, Images)
			removeEventHandler("onClientPreRender", getRootElement(), updateCamera)
			removeEventHandler("onClientRender", root, DrawOnClientRender)
			removeEventHandler("onClientElementStreamIn", getRootElement(), StreamIn)
		end
	end
end
addEvent("GenerateTexture", true)
addEventHandler("GenerateTexture", root, GenerateTexture)


