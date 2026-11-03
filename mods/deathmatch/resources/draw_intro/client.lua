local screenWidth, screenHeight = guiGetScreenSize()
local scale = ((screenWidth/1920)+(screenHeight/1080))/2
local screenSource = false
local scalex = (screenWidth/1920)
local scaley = (screenHeight/1080)
local intro = false

--1,2 позиция, 3,4 размер, стартовая позиция, прибытие x,y, хз что
local screenSaver = {
	["intro"] = {
		[1] = {340*scalex, 330*scaley, 165*scalex, 150*scaley, screenWidth/2, 0, true, true, 0},
		[2] = {340*scalex, 500*scaley, 90*scalex, 220*scaley, 0, 0, true, true, 0},
		[3] = {340*scalex, 720*scaley, 100*scalex, 200*scaley, 0, screenHeight, true, true, 0},
		[4] = {460*scalex, 720*scaley, 175*scalex, 120*scaley, screenWidth/2, screenHeight, true, true, 0},
		[5] = {470*scalex, 500*scaley, 165*scalex, 200*scaley, screenWidth, 0, true, true, 0}
	},
	["intro2"] = {
		[1] = {1220*scalex, 370*scaley, 185*scalex, 110*scaley, screenWidth/2, 0, true, true, 0},
		[2] = {1190*scalex, 510*scaley, 225*scalex, 180*scaley, 0, 0, true, true, 0},
		[3] = {1430*scalex, 370*scaley, 175*scalex, 320*scaley, screenWidth, 0, true, true, 0},
		[4] = {1160*scalex, 720*scaley, 475*scalex, 150*scaley, screenWidth/2, screenHeight, true, true, 0},
	}
}

local CameraMatrix = {
	["intro"] = {1698.9, -1538.9, 13.4, 1694.2, -1529, 13.5}, 
	["intro2"] = {-1995.8, 105.9, 30, -2030, 204.8, 40.7}
}

local TriaTargets = {
	["intro"] = {}, 
	["intro2"] = {}
}


local SourceTarget = {
	["intro"] = {}, 
	["intro2"] = {}
}


function DrawTriangle(a, b, c, d, color, revers)
	local x1, y1 = a, b
	local x2, y2 = c, d
	local x3, y3

	if (d > b) then
		x3, y3 = (revers and c or a), (revers and b or d)
	else
		x3, y3 = (revers and a or c), (revers and d or b)
	end

	dxDrawPrimitive("trianglelist", false, 
		{ x = x1, y = y1, color = color },
		{ x = x2, y = y2, color = color },
		{ x = x3, y = y3, color = color }
	)
end

function CreateTriangles()
	for name, dat in pairs(screenSaver) do
		for id, key in pairs(dat) do
			local w, h = key[3], key[4]
		
			TriaTargets[name][id] = dxCreateRenderTarget(w, h, true)
			dxSetRenderTarget(TriaTargets[name][id], true)
			
			local color = tocolor(0,0,0,255)
			
			if(name == "intro") then
				if(id == 1) then
					DrawTriangle(0, w-(130*scalex), h, w,color)
				elseif(id == 5) then
					DrawTriangle(0, (50*scalex), h-(30*scaley), w, color)
					DrawTriangle(h-(60*scaley), w-(20*scalex), h, w-(10*scalex), color)
					dxDrawRectangle(w-(10*scalex), h-(60*scaley), 30*scalex, 61*scaley, color)
				elseif(id == 3) then
					DrawTriangle(20*scaley, 0, 0, w, color,true)
				elseif(id == 2) then
					DrawTriangle(h, 0, h-(17*scaley), w, color)
				elseif(id == 4) then
					DrawTriangle(0, w-(10*scalex), h, w,color)
				end
			elseif(name == "intro2") then
				if(id == 4) then
					DrawTriangle(h-(150*scaley), w-(25*scalex), h, w, color)
					DrawTriangle(0, 25*scalex, h, 2*scalex, color,true)
				elseif(id == 3) then
					DrawTriangle(0, w-(75*scalex), h, w, color)
					DrawTriangle(h, 25*scalex, 0, 2*scalex, color, true)
				elseif(id == 2) then
					DrawTriangle(0, w-(10*scalex), h, w, color)
					DrawTriangle(0, 25*scalex, h, 2*scalex, color,true)
				elseif(id == 1) then
					DrawTriangle(0, w-(5*scalex), h, w, color)
					DrawTriangle(0, 10*scalex, h, 2*scalex, color,true)
				end
			end

			
			dxSetRenderTarget()
		end
	end
end




function DrawZast(target, i)
	local w, h = screenSaver[target][i][3], screenSaver[target][i][4]
	local zahx, zahy = screenSaver[target][i][1], screenSaver[target][i][2]
	
	if(not isElement(SourceTarget[target][i])) then
		SourceTarget[target][i] = dxCreateRenderTarget(w, h, false)
	end
	
	dxSetRenderTarget(SourceTarget[target][i], true)
	dxDrawImageSection(2,2, w-4,h-4, zahx,zahy, screenSaver[target][i][3], screenSaver[target][i][4], screenSource)
	
	if(TriaTargets[target][i]) then
		dxDrawImage(0,0,w,h, TriaTargets[target][i])
	end
	
	dxSetRenderTarget()

	return SourceTarget[target][i]
end

function DrawIntro()
	dxUpdateScreenSource(screenSource)
	dxDrawRectangle(0,0,screenWidth,screenHeight,tocolor(0,0,0,255))	
	local speed2 = 250
	for i, key in pairs(screenSaver[intro]) do
		sx = (key[1]*(key[9]/speed2))+(key[5]-(key[5]*(key[9]/speed2)))
		local sy = (key[2]*(key[9]/speed2))+(key[6]-(key[6]*(key[9]/speed2)))
		
		if(key[8]) then
			dxDrawImage(sx,sy, key[3], key[4], DrawZast(intro, i))
			
			if(key[9] < speed2) then
				key[9] = key[9]+1
			else
				key[8] = false
				key[7] = false
			end
		else
			local x2, y2, z2, lx, ly, lz, rz = getCameraMatrix ()
			setCameraMatrix(x2+0.0005, y2+0.0005, z2+0.00005, lx+0.0005, ly+0.0005, lz)
			
			dxDrawImage(key[1],key[2], key[3], key[4], DrawZast(intro, i))
			
			sx = key[1]
			sy = key[2]
			if(key[9] > 0) then
				key[9]=key[9]-0.1
			else
				setCameraMatrix(unpack(CameraMatrix[intro]))
				key[8] = true
				key[7] = true
			end
		end
		
	end
end


function StopIntro()
	if(intro) then 
		removeEventHandler("onClientHUDRender", root, DrawIntro)
		for name, dat in pairs(TriaTargets) do
			for key, target in pairs(dat) do
				destroyElement(target)
			end
		end		
		
		for name, dat in pairs(SourceTarget) do
			for key, target in pairs(dat) do
				destroyElement(target)
			end
		end
		
		destroyElement(screenSource)
	end
end
addEvent("StopIntro", true)
addEventHandler("StopIntro", localPlayer, StopIntro)



function StartIntro(name)
	if(intro) then
		StopIntro()
	end
	
	CreateTriangles()
	
	if(not name) then
		local Randv = {}
		for i,v in pairs(screenSaver) do
			Randv[#Randv+1] = i
		end
		name = Randv[math.random(#Randv)]
	end
	intro = name
	screenSource = dxCreateScreenSource(screenWidth, screenHeight)
	setCameraMatrix(unpack(CameraMatrix[intro]))
	addEventHandler("onClientHUDRender", root, DrawIntro, true, "high")
end
addEvent("StartIntro", true)
addEventHandler("StartIntro", localPlayer, StartIntro)



function start_intro(command, h)	
	StartIntro(h)
end
addCommandHandler("start_intro", start_intro)


function stop_intro(command, h)
	StopIntro()
end
addCommandHandler("stop_intro", stop_intro)



