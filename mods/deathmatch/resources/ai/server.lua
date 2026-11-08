PathNodes = exports["vehicle_node"]:GetVehicleNodes()
PathGrid = exports["vehicle_node"]:GetVehiclePathGrid()
PedGrid = exports["vehicle_node"]:GetPedPathGrid()
SkinData = exports["228"]:GetSkinData()
local JustPeds = {}
local JustVehicle = {}

function getArrSize(arr)
	local i = 0
	for _,_ in pairs(arr) do i=i+1 end
	return i
end



function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end



--function CreateDialogBot(skin,x,y,z,rz,i,d,dialog,name)
--	local ped = createPed(skin, x,y,z,rz, true)
--	setElementInterior(ped, i)
--	setElementDimension(ped, d)
--	setElementData(ped, "dialog", dialog)
--	setElementData(ped, "dialogrz", rz)
--	setElementData(ped, "TINF", "DialogBot"..SData["DialogBot"])
--
--	if(not name) then
--		name = SkinData[skin][3]
--		if(SkinData[skin][6]) then
--			name = SkinData[skin][6][math.random(#SkinData[skin][6])]
--		end
--	end
--	setElementData(ped, "name", name)
--
--	SData["DialogBot"] = SData["DialogBot"]+1
--	return ped
--end
--addEvent("CreateDialogBot", true)
--addEventHandler("CreateDialogBot", resourceRoot, CreateDialogBot)



function GetVehicleNodesInRange(city, x,y,z, rangemin, rangemax, closedroads)
	local out = {}
	x,y = math.round(x), math.round(y)
	for slotx = x-rangemax, x+rangemax do
		for sloty = y-rangemax, y+rangemax do
			if(PathGrid[city][slotx]) then 
				if(PathGrid[city][slotx][sloty]) then
					if(getDistanceBetweenPoints2D(x,y,slotx,sloty) > rangemin) then
						for i, v in pairs(PathGrid[city][slotx][sloty]) do
							out[#out+1] = v
						end
					end
				end
			end
		end
	end
	return out
end



function GetPedGridInRange(city, x,y,z, rangemin, rangemax)
	local out = {}
	x,y = math.round(x), math.round(y)
	for slotx = x-rangemax, x+rangemax do
		for sloty = y-rangemax, y+rangemax do
			if(PedGrid[city][slotx]) then 
				if(PedGrid[city][slotx][sloty]) then
					if(getDistanceBetweenPoints2D(x,y,slotx,sloty) > rangemin) then
						out[#out+1] = PedGrid[city][slotx][sloty]
					end
				end
			end
		end
	end
	return out
end





function GetNextNode(city, node, id)
	local nodes = {}
	if(PathNodes[city][node][id+1]) then
		nodes[#nodes+1] = {node, id+1}
	end
	
	if(PathNodes[city][node][id][6]) then
		if(PathNodes[city][node][id+1]) then
			nodes[#nodes+1] = {node, id+1}
		end -- дважды
		
		for i, v in pairs(PathNodes[city][node][id][6]) do
			nodes[#nodes+1] = {v[1], v[2]}
		end
	end

	return nodes[math.random(#nodes)]
end





function DriverBotNextPath(thePed, size)
	if(not isElement(thePed)) then return false end
	local path = getElementData(thePed, "path")
	if(path) then
		if(size == #path) then -- Для синхронизации
			table.remove(path, 1)
			if(#path == 0) then
				removeElementData(thePed, "path")
			else
				setElementData(thePed, "path", path)
			end
		end
	end
end
addEvent("DriverBotNextPath", true)
addEventHandler("DriverBotNextPath", resourceRoot, DriverBotNextPath)



function table.copy(t)
	local t2 = {};
	for k,v in pairs(t) do
		if type(v) == "table" then
			t2[k] = table.copy(v);
		else
			t2[k] = v;
		end
	end
	return t2;
end


function GPSFind(city, d,n, d2,n2)
	local out = {}
	local tmp = {
		["threads"] = {}, 
		["nextnodes"] = {}, 
		["usablepaths"] = {[d] = {}}
	}
	
	tmp["nextnodes"][1] = {d, n, 1, {[1] = 1}}
	tmp["threads"][1] = {}
	
	for is = 1, 50000 do
		for i, arr in pairs(tmp["nextnodes"]) do
			if(not tmp["usablepaths"][arr[1]]) then 
				tmp["usablepaths"][arr[1]] = {}
			end
			
			
			if(tmp["usablepaths"][arr[1]][arr[2]]) then -- Если попали в петлю
			--	tmp["threads"][arr[3]] = nil
				tmp["nextnodes"][i] = nil
			else
				tmp["usablepaths"][arr[1]][arr[2]] = true
				
				if(PathNodes[city][arr[1]][arr[2]][6]) then
					if(PathNodes[city][arr[1]][arr[2]+1]) then
						table.insert(tmp["threads"], {{arr[1], arr[2]}})
						local newarr = table.copy(arr[4])
						table.insert(newarr, #tmp["threads"])
						table.insert(tmp["nextnodes"], {arr[1], arr[2]+1, #tmp["threads"], newarr})
					end
					
					for i2, k2 in pairs(PathNodes[city][arr[1]][arr[2]][6]) do
						table.insert(tmp["threads"], {{arr[1], arr[2]}})
						local newarr = table.copy(arr[4])
						table.insert(newarr, #tmp["threads"])
						table.insert(tmp["nextnodes"], {k2[1], k2[2], #tmp["threads"], newarr})
					end
				else
					table.insert(tmp["threads"][arr[3]], {arr[1], arr[2]})
					tmp["nextnodes"][i] = {arr[1], arr[2]+1, arr[3], arr[4]}
				end
				
				
				
				if(arr[1] == d2 and arr[2] == n2) then
					local out = {}
					for _, id in pairs(arr[4]) do
						for _, el in pairs(tmp["threads"][id]) do
							table.insert(out, el)
						end
					end
					return out
				end
			end
		end
	end
	return false
end






function FindMyNode(thePed)
	local x,y,z = getElementPosition(thePed)
	local zone = exports["ps2_weather"]:GetZoneName(x,y,z, false, "San Andreas")
	local minDist = 9999
	local node = false
	
	
	for id, v in pairs(PathNodes["San Andreas"][zone]) do
		local dist = getDistanceBetweenPoints3D(x,y,z,v[2],v[3],v[4])
		if(dist < minDist) then
			minDist = dist
			node = {zone, id}
		end
	end
	return node
end









function SyncEl(thePlayer, theEl)
	if(not isElement(theEl)) then return end
	setElementSyncer(theEl, thePlayer)
end
addEvent("SyncEl", true)
addEventHandler("SyncEl", resourceRoot, SyncEl)





local Dimension = {
	["San Andreas"] = 0,
	["Liberty City"] = 1, 
	["Vice City"] = 2
}


function JustDriver(thePed, city, district, i)
	if(JustPeds[thePed]) then
		local paths = {[1] = {district, i}}
		local finddist = district
		local findid = i
		for slot = 0, 10 do	
			local nextnode = GetNextNode(city, finddist, findid)
		
			paths[#paths+1] = {nextnode[1], nextnode[2]}
				
			finddist = nextnode[1]
			findid = nextnode[2]
		end
		setElementData(thePed, "path", paths)
	end
end
addEvent("JustDriver", true)
addEventHandler("JustDriver", resourceRoot, JustDriver)




local VehicleRegionSpecific = {
	["Red County"] = {431,437},
	["Los Santos"] = {431,437},
	["San Fierro"] = {431,437},
	["Las Payasadas"] = {431,437},
	["Whetstone"] = {431,437},
	["Las Venturas"] = {431,437},
	["Flint County"] = {431,437},
	["Tierra Robada"] = {431,437},
	["Bone County"] = {431,437},
	["Julius Thruway South"] = {443, 431,437},
	["Julius Thruway West"] = {443, 431,437},
	["Julius Thruway North"] = {443, 431,437},
	["Julius Thruway East"] = {443, 431,437},
	["Las Venturas Airport"] = {431,437},
	["Easter Bay Airport"] = {431,437},
	["Ocean Docks"] = {515, 514, 403, 499, 524, 609, 498, 455, 414, 456, 440},
}


local WeaponNamesArr = {
	["АК-47"] = 30,
	["Граната"] = 16,
	["Газовая граната"] = 17,
	["Взрывчатка"] = 39,
	["Молотов"] = 18,
	["Кольт 45"] = 22,
	["USP-S"] = 23,
	["Deagle"] = 24,
	["М16"] = 31,
	["Mossberg"] = 25,
	["Sawed-Off"] = 26,
	["SPAS-12"] = 27,
	["Узи"] = 28,
	["MP5"] = 29,
	["Tec-9"] = 32,
	["ИЖ-12"] = 33,
	["M40"] = 34,
	["Dildo XXL"] = 10,
	["Dildo"] = 11,
	["Вибратор"] = 12,
	["Нож"] = 4,
	["Катана"] = 8,
	["Удочка"] = 7,
	["Клюшка"] = 2,
	["Лопата"] = 6,
	["Кастет"] = 1,
	["Миниган"] = 38,
	["Цветы"] = 14,
	["Трость"] = 15,
	["Бита"] = 5,
	["Дубинка"] = 3,
	["Парашют"] = 46,
	["Камера"] = 43,
	["Огнетушитель"] = 42,
	["Спрей"] = 41,
	["Базука"] = 35,
	["Ракетная установка"] = 36,
	["Огнемет"] = 37,
	["Бензопила"] = 9,
}

function FoundWName(id)
	for v,k in pairs(WeaponNamesArr) do
		if(k == id) then
			return v
		end
	end
	return false
end


local VehicleRegionAll = {400,401,402,404,405,410,418,419,420,421,422,426,436,438,439,445,458,466,467,475,474,479,482,489,491,492,496,500,505,507,516,518,526,527,529,533,540,547,546,550,551,576,580,585,602}




function CreateJustPed(pedmodel,x,y,z,rz,city,district)
	if(not pedmodel) then pedmodel = 299 end
	if(not tonumber(pedmodel)) then 
		pedmodel = GetSkinSpecific(pedmodel, district) 
	end
	
	local thePed = createPed(pedmodel, x,y,z, rz)
	local skin = SkinData[pedmodel]
	if(not skin) then skin = SkinData[299]; pedmodel = 299 end -- fallback на CJ-подобный мирный скин
	setElementData(thePed, "team", skin[2])
	setPedWalkingStyle(thePed, skin[1])

	local name = skin[3]
	if(skin[6]) then
		name = skin[6][math.random(#skin[6])]
	end

	local botinv = {}
	if(skin[4]) then
		botinv[#botinv+1] = {["txd"] = FoundWName(skin[4]), ["name"] = FoundWName(skin[4])}
		giveWeapon(thePed, skin[4], 9999, true)
	end

	local randitem = math.random(20)

	if(randitem == 1) then
		if(skin[2] == "Мирные жители") then
			botinv[#botinv+1] = {["txd"] = "Пакет", ["name"] = "Пакет"}
			name=name.." с пакетом"
		end
	elseif(randitem == 2) then
		if(skin[2] == "Мирные жители") then
			botinv[#botinv+1] = {["txd"] = "Чемодан", ["name"] = "Чемодан"}
			name=name.." с чемоданом"
		end
	elseif(randitem == 3) then
		if(skin[3] == "Мужчина") then
			name="Пьяный "..utf8.lower(name)
			setElementData(thePed, "dialog", "Пьяный Мужчина")
		elseif(skin[3] == "Женщина") then
			name="Пьяная "..utf8.lower(name)
		end

		local DrunkObj = {1543, 1544, 1669, 1950, 1951}
		setElementData(thePed, "armasplus", toJSON({[DrunkObj[math.random(#DrunkObj)]] = true}))
		setPedWalkingStyle(thePed, 126)
	elseif(randitem == 4) then
		name=name.." с сигаретой"
		setElementData(thePed, "armasplus", toJSON({[3027] = true}))
	end

	setElementData(thePed, "inv", toJSON({botinv}))
	setElementData(thePed, "name", name)

	setElementDimension(thePed, Dimension[city])
	
	setElementData(thePed, "JustDriver", "true")
	
	JustPeds[thePed] = true
	return thePed
end




function enterVehicle(theVehicle, seat, jacked)
	if(JustVehicle[theVehicle] and seat == 0) then
		JustVehicle[theVehicle] = nil
	end
end
addEventHandler("onPlayerVehicleEnter", root, enterVehicle)



local VehicleTeamData = {
	["Полиция"] = {{523,"POLS 228"}},
	["Гроув-стрит"] = {{567,"GRST 228",{86, 86, 86, 86}}, {492 ,"GROVE4L_",{59,34,86,86}}, {412,"GRST 228",{86, 86, 86, 86}}},
	["Баллас"] = {{517,"BALS 228",{30, 30, 30, 30}}, {412,"BALS 228",{30, 30, 30, 30}}, {566 ,"BALS 228",{30, 30, 30, 30}}},
	["Ацтекас"] = {{466,"AZTC 228",{93, 71, 0, 0}}, {576,"AZTC 228",{93, 71, 0, 0}}, {474 ,"AZTC 228",{93, 71, 0, 0}}},
	["Байкеры"] = {{468,"METAL228"}, {463,"METAL228"}, {586 ,"METAL228"}},
	["Вагос"] = {{474,"VAGOS228",{6, 6, 0, 0}}, {467,"VAGOS228",{6, 6, 0, 0}}, {576 ,"VAGOS228",{6, 6, 0, 0}}},
	["Колумбийский картель"] = {{422,"COKA 228",{116, 116, 116, 116},{2, 2}}, {440,"COKA 228",{116, 116, 116, 116},{1, 1}}, {600 ,"COKA 228",{116, 116, 116, 116},{2, 2}}, {543 ,"COKA 228",{116, 116, 116, 116},{4, 4}}},
	["Русская мафия"] = {{404,"RUSM 228",{1,1,1,1}}, {560,"RUSM 228",{1,1,1,1}}, {445,"RUSM 228",{1,1,1,1}}, {581,"RUSM 228",{1,1,1,1}}, {409,"RUSM 228",{1,1,1,1}}},
	["Триады"] = {{466,"TRIA 228",{0,0,0,0}}, {560,"TRIA 228",{0,0,0,0}}, {445,"TRIA 228",{0,0,0,0}}, {414,"TRIA 228",{83,83,83,83},{5,5}}},
	["Da Nang Boys"] = {{439,"YAZA 228",{177,15,11, 255,255,255}}, {482,"YAZA 228",{177,15,11, 255,255,255}}, {467,"YAZA 228",{177,15,11, 255,255,255}, {0, 0}}},
	["Рифа"] = {{536,"RIFA 228",{94, 94, 0, 0}}, {439,"RIFA 228",{94, 94, 0, 0}}, {475 ,"RIFA 228",{94, 94, 0, 0}}},
	["Деревенщины"] = {{478,"KOLHZ228",{61, 61, 0, 0}}, {543 ,"KOLHZ228",{61, 61, 0, 0}}, {531,"KOLHZ228",{61, 61, 0, 0}}}
}



function findRotation3D( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end



function CreateJustDriver(city, district, i, pedmodel, vehiclemodel)
	local v = PathNodes[city][district][i]
	local nextnode = GetNextNode(city, district, i)
	local vehdata = {[1] = vehiclemodel}
	
	local rx,ry,rz = findRotation3D(v[2], v[3], v[4], PathNodes[city][nextnode[1]][nextnode[2]][2], PathNodes[city][nextnode[1]][nextnode[2]][3], PathNodes[city][nextnode[1]][nextnode[2]][4])
	
	if(pedmodel) then
		if(not tonumber(pedmodel)) then 
			if(VehicleTeamData[pedmodel]) then
				vehdata = VehicleTeamData[pedmodel][math.random(#VehicleTeamData[pedmodel])]
			end
		end
	end
	
	
	if(not vehdata[1]) then
		vehdata[1] = VehicleRegionAll[math.random(#VehicleRegionAll)]
		if(VehicleRegionSpecific[district]) then
			if(math.random(1,10) == 1) then
				vehdata[1] = VehicleRegionSpecific[district][math.random(#VehicleRegionSpecific[district])]
			end
		end
	end
	
	
	if(vehdata[1] == 497 or vehdata[1] == 488) then -- Вертолеты
		v[4] = v[4]+25
	end
				
	local theVehicle = createVehicle(vehdata[1], v[2], v[3], v[4]+exports["228"]:GetVehicleGround(vehdata[1]), rx,ry,rz)
	setElementData(theVehicle, "model", vehdata[1])
	setElementDimension(theVehicle, Dimension[city])
	if(vehdata[2]) then setVehiclePlateText(theVehicle, vehdata[2]) end
	if(vehdata[3]) then
		if(#vehdata[3] == 4) then
			setVehicleColor(theVehicle, vehdata[3][1], vehdata[3][2], vehdata[3][3], vehdata[3][4])
		else
			setVehicleColor(theVehicle, vehdata[3][1], vehdata[3][2], vehdata[3][3], vehdata[3][4], vehdata[3][5], vehdata[3][6])
		end
	end
	
	
	
	local thePed = CreateJustPed(pedmodel, v[2], v[3], v[4], rz,city,district)
	JustDriver(thePed, city, nextnode[1], nextnode[2])
	warpPedIntoVehicle(thePed, theVehicle)
	JustVehicle[theVehicle] = "bot"
	
	local x2, y2, z2 = getPointInFrontOfPoint(v[2], v[3], v[4], rz+90, 0.2)
	local sx, sy, sz = getElementVelocity(theVehicle)
	setElementVelocity(theVehicle, sx-(v[2]-x2), sy-(v[3]-y2), sz-(v[4]-z2))

	return thePed
end



function getPointInFrontOfPoint(x, y, z, rZ, dist)
	local offsetRot = math.rad(rZ)
	local vx = x + dist * math.cos(offsetRot)
	local vy = y + dist * math.sin(offsetRot)
	return vx, vy, z
	
end



function UpdateJustDriver(thePed, x,y,z)
	if(JustPeds[thePed]) then
		local city = getPlayerCity(thePed)
		local district = exports["ps2_weather"]:GetZoneName(x,y,z, false, city)
		
		local positions = GetVehicleNodesInRange(city, x,y,z, 0,100)
		local mindist = 100
		local node = false
		for _, v in pairs(positions) do
			local dist = getDistanceBetweenPoints2D(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3], x,y)
			if(dist < mindist) then
				mindist = dist
				node = v
			end
		end
		
		if(node) then
			removeElementData(thePed, "PedStatus")
			removeElementData(thePed, "attacker")
			JustDriver(thePed, city, node[1], node[2])
		end
	end
end
addEvent("UpdateJustDriver", true)
addEventHandler("UpdateJustDriver", root, UpdateJustDriver)




function getPlayerCity(thePlayer)
	return getElementData(thePlayer, "City") or "San Andreas"
end



function DistanceAllMinimal(x2,y2, ignorePlayer) -- minimal, maximal
	for _,thePlayer in pairs(getElementsByType "player") do -- Проверка на игроков
		if(thePlayer ~= ignorePlayer) then
			local x,y,_ = getElementPosition(thePlayer)
			local dist = getDistanceBetweenPoints2D(x,y,x2,y2)
			if(dist < 80) then
				return false
			end
		end
	end
	
	for thePed,_ in pairs(JustPeds) do -- Проверка на ботов
		local theVehicle = getPedOccupiedVehicle(thePed)
		if(theVehicle) then
			local x,y,_ = getElementPosition(theVehicle)
			local dist = getDistanceBetweenPoints2D(x,y,x2,y2)
			if(dist < 5) then
				return false
			end
		end
	end
	
	
	return true
end


-- [Зона] = {{Модель авто, модель скина}, {Модель авто 2, модель скина 2}}
local PoliceSpecificZone = {
	["Los Santos"] = {{523, 284}, {596, 280}},
	["San Fierro"] = {{597, 281}},
	["Las Venturas"] = {{598, 282}},
	["Red County"] = {{523, 284}, {599, 283}},
	["Whetstone"] = {{523, 284}, {599, 283}},
	["Flint County"] = {{523, 284}, {599, 283}},
	["Bone County"] = {{599, 283}},
	["Tierra Robada"] = {{599, 283}},
	["UNDERWATER"] = {{596, 280}},
	["Unknown"] = {{596, 280}},
}




function getPointInFrontOfPoint(x, y, z, rZ, dist)
	local offsetRot = math.rad(rZ)
	local vx = x + dist * math.cos(offsetRot)
	local vy = y + dist * math.sin(offsetRot)
	return vx, vy, z
end

local BotTeams = {
"Полиция",
"Мирные жители",
"Мирные жители",
"Мирные жители",
"Мирные жители",
"Мирные жители",
"Баллас",
"Гроув-стрит",
"Вагос",
"Рифа",
"Деревенщины",
"Триады",
"Da Nang Boys",
"Ацтекас",
"Русская мафия",
"Колумбийский картель"}





function Streamer(thePlayer, ignorelocalPlayer)
	if(getElementData(thePlayer, "auth")) then 
		local x,y,z = getElementPosition(thePlayer)
		local city = getPlayerCity(thePlayer)
		local district = exports["ps2_weather"]:GetZoneName(x,y,z, false, city)
		local zone = exports["ps2_weather"]:GetZoneName(x,y,z, true, city)
		local MinimalRange = 110
		if(ignorelocalPlayer) then MinimalRange = 0 end
		
		
		local positions = GetVehicleNodesInRange(city, x,y,z, MinimalRange,140)
		for _ = 1, 4 do
			if(#positions > 0) then 
				local pos = math.random(#positions)
				local v = positions[pos]
				if(PathNodes[city][v[1]][v[2]][1] == true) then -- Отсекаем закрытые дороги
					if(DistanceAllMinimal(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3], ignorelocalPlayer)) then
						CreateJustDriver(city, v[1], v[2], BotTeams[math.random(#BotTeams)])
					end
				end
				table.remove(positions, pos)
			end
		end
		
		
		positions = GetPedGridInRange(city, x,y,z, MinimalRange,140)
		for _ = 1, 4 do
			if(#positions > 0) then 
				local pos = math.random(#positions)
				if(DistanceAllMinimal(positions[pos][1], positions[pos][2], ignorelocalPlayer)) then
					CreateJustPed(BotTeams[math.random(#BotTeams)], positions[pos][1], positions[pos][2], positions[pos][3]+1, positions[pos][4], city, district)
				end
				table.remove(positions, pos)
			end
		end
	end		
end
addEvent("Streamer", true)
addEventHandler("Streamer", resourceRoot, Streamer)



function ReleaseStreamer()
	if(#JustPeds <= 50) then
		for thePed, _ in pairs(JustPeds) do
			local x,y,z = getElementPosition(thePed)
			local saveped = false
			for _,thePlayer in pairs(getElementsByType("player")) do
				local px,py,pz = getElementPosition(thePlayer)
				local dist = getDistanceBetweenPoints2D(x,y,px,py)
				if(dist < 140) then
					saveped = true
					break
				end
			end
			
			if(not saveped) then
				local theVehicle = getPedOccupiedVehicle(thePed)
				if(theVehicle) then
					JustVehicle[theVehicle] = nil
					destroyElement(theVehicle)
				end
				JustPeds[thePed] = nil
				destroyElement(thePed)
			end
		end
		
		
		for theVehicle, _ in pairs(JustVehicle) do
			if(not getVehicleOccupant(theVehicle)) then
				local x,y,z = getElementPosition(theVehicle)
				local saveveh = false
				for _,thePlayer in pairs(getElementsByType("player")) do
					local px,py,pz = getElementPosition(thePlayer)
					local dist = getDistanceBetweenPoints2D(x,y,px,py)
					if(dist < 140) then
						saveveh = true
						break
					end
				end
				
				if(not saveveh) then
					JustVehicle[theVehicle] = nil
					destroyElement(theVehicle)
				end
			end
		end
		
		
		
		
		for _,thePlayer in pairs(getElementsByType("player")) do
			if(getElementData(thePlayer, "auth")) then 
				local x,y,z = getElementPosition(thePlayer)
				local city = getPlayerCity(thePlayer)
				local district = exports["ps2_weather"]:GetZoneName(x,y,z, false, city)
				local zone = exports["ps2_weather"]:GetZoneName(x,y,z, true, city)
			
				local wanted = getElementData(thePlayer, "WantedLevel") or 0
				if(wanted > 0) then
					if(wanted >= 5) then
					local rand = math.random(1,6)
					if(rand == 1 or rand == 2) then
						kr(thePlayer, 433, 287) -- Армия
					elseif(rand == 3 or rand == 4) then
						kr(thePlayer, 470, 287) -- Армия
					elseif(rand == 5) then
						kr(thePlayer, 488, 170) -- San News
					elseif(rand == 6) then
						kr(thePlayer, 497, 280) -- Вертолет
					end
					
					elseif(wanted >= 4) then
						kr(thePlayer, 490, 286) -- ФБР
					elseif(wanted >= 3) then
						kr(thePlayer, 427, 285) -- SWAT
					elseif(wanted < 3) then
						local rand = PoliceSpecificZone[zone][math.random(#PoliceSpecificZone[zone])]
						kr(thePlayer, rand[1], rand[2]) -- Выезжает полиция
					end
				end
			end
		end
	end
end



-- Старухи, итд
local BotSkinSpecific = {
	["Мирные жители"] = {
		["Las Venturas"] = {
			["Starfish Casino"] = {27,153,260},
			["Yellow Bell Golf Course"] = {36,37},
			["The Four Dragons Casino"] = {82,83,84,85,141,150,147,233},
			["The Strip"] = {82,83,84,85,141,150,147,233},
			["Greenglass College"] = {23, 56, 60, 72, 93, 141, 150, 181, 190, 188, 193, 195, 211, 226},
			["all"] = {7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,90,92,99,236,56}
		},
		["Tierra Robada"] = {
			["all"] = {38,89, 198, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56,128}
		},
		["Bone County"] = {
			["all"] = {39,129, 198, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56,128}
		},
		["San Fierro"] = {
			["all"] = {196, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,92,99,236,56}
		},
		["Red County"] = {
			["all"] = {130,199, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Whetstone"] = {
			["all"] = {218, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Flint County"] = {
			["all"] = {197, 201, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Los Santos"] = {
			["all"] = {10, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,90,92,99,236,56,243}
		},
		["Unknown"] = {
			["all"] = {10,38,39,89,129,130,196,197,199,218, 7,9,12,13,14,15,17,18,19,20,21,22,23,44,48,72,236,56}
		},
		["Unknown Bar"] = {
			["Unknown Bar"] = {102,103,104, 105,106,107, 108,109,110, 173,174,175, 159,160,161,162, 117,118,120, 121,122,123, 114,115,116, 181,247,248,100, 111,112,113, 222,95,30,242,179}
		}
	},
	["Полиция"] = {
		["Las Venturas"] = {
			["all"] = {282}
		},
		["Tierra Robada"] = {
			["all"] = {283}
		},
		["Bone County"] = {
			["all"] = {283}
		},
		["San Fierro"] = {
			["all"] = {284}
		},
		["Red County"] = {
			["all"] = {288}
		},
		["Whetstone"] = {
			["all"] = {288}
		},
		["Flint County"] = {
			["all"] = {288}
		},
		["Los Santos"] = {
			["all"] = {280}
		},
		["Unknown"] = {
			["all"] = {280, 281, 282, 283, 284, 288}
		},
		["Unknown Bar"] = {
			["Unknown Bar"] = {280, 281, 282, 283, 284, 288}
		}
	}
}

local BotSkin = {
	["Мирные жители"] = {7,9,10,12,13,14,15,17,18,19 ,20,21,22,23,44 ,48,72,236,56},
	["Баллас"] = {102,103,104}, 
	["Гроув-стрит"] = {105,106,107}, 
	["Вагос"] = {108,109,110},
	["Рифа"] = {173,174,175}, 
	["Деревенщины"] = {159,160,161,162}, 
	["Триады"] = {117,118,120}, 
	["Da Nang Boys"] = {121,122,123}, 
	["Ацтекас"] = {114,115,116}, 
	["Байкеры"] = {181,247,248,100,261},
	["Русская мафия"] = {111,112,113}, 
	["Колумбийский картель"] = {222,221,95,30,242,179}, 
}







local ZonesRegion = {
	["Unknown Bar"] = "Unknown Bar",
	["Unknown"] = "Unknown",
	["Linden Side"] = "Las Venturas",
	["Las Venturas Airport"] = "Las Venturas",
	["Harry Gold Parkway"] = "Las Venturas",
	["Los Santos International"] = "Los Santos",
	["Come-A-Lot"] = "Las Venturas",
	["Juniper Hill"] = "San Fierro",
	["City Hall"] = "San Fierro",
	["Julius Thruway North"] = "Las Venturas",
	["Montgomery"] = "Red County",
	["El Corona"] = "Los Santos",
	["Queens"] = "San Fierro",
	["The High Roller"] = "Las Venturas",
	["K.A.C.C. Military Fuels"] = "Las Venturas",
	["Pilson Intersection"] = "Las Venturas",
	["Vinewood"] = "Los Santos",
	["Flint County"] = "Flint County",
	["El Quebrados"] = "Tierra Robada",
	["Tierra Robada"] = "Tierra Robada",
	["Linden Station"] = "Las Venturas",
	["Blackfield Chapel"] = "Las Venturas",
	["San Andreas Sound"] = "Red County",
	["Conference Center"] = "Los Santos",
	["Roca Escalante"] = "Las Venturas",
	["The Camel's Toe"] = "Las Venturas",
	["El Castillo del Diablo"] = "Bone County",
	["Lil' Probe Inn"] = "Bone County",
	["Martin Bridge"] = "Red County",
	["Beacon Hill"] = "Flint County",
	["Battery Point"] = "San Fierro",
	["Missionary Hill"] = "San Fierro",
	["The Pink Swan"] = "Las Venturas",
	["Easter Tunnel"] = "San Fierro",
	["Red County"] = "Red County",
	["Commerce"] = "Los Santos",
	["Palomino Creek"] = "Red County",
	["Blueberry"] = "Red County",
	["Montgomery Intersection"] = "Red County",
	["Santa Maria Beach"] = "Los Santos",
	["Las Barrancas"] = "Tierra Robada",
	["Regular Tom"] = "Bone County",
	["Shady Creeks"] = "Whetstone",
	["Kincaid Bridge"] = "Tierra Robada",
	["Los Flores"] = "Los Santos",
	["Valle Ocultado"] = "Tierra Robada",
	["Julius Thruway West"] = "Las Venturas",
	["Jefferson"] = "Los Santos",
	["Hashbury"] = "San Fierro",
	["'The Big Ear'"] = "Bone County",
	["Back o Beyond"] = "Flint County",
	["Los Santos"] = "Los Santos",
	["Playa del Seville"] = "Los Santos",
	["Last Dime Motel"] = "Las Venturas",
	["Temple"] = "Los Santos",
	["San Fierro"] = "San Fierro",
	["Rockshore East"] = "Las Venturas",
	["The Mako Span"] = "Red County",
	["Hilltop Farm"] = "Red County",
	["Avispa Country Club"] = "San Fierro",
	["The Sherman Dam"] = "Tierra Robada",
	["Ganton"] = "Los Santos",
	["Fisher's Lagoon"] = "Red County",
	["Pirates in Men's Pants"] = "Las Venturas",
	["Ocean Flats"] = "San Fierro",
	["Rockshore West"] = "Las Venturas",
	["Cranberry Station"] = "San Fierro",
	["Hankypanky Point"] = "Red County",
	["The Clown's Pocket"] = "Las Venturas",
	["Doherty"] = "San Fierro",
	["Esplanade North"] = "San Fierro",
	["North Rock"] = "Red County",
	["Bayside Marina"] = "Tierra Robada",
	["The Four Dragons Casino"] = "Las Venturas",
	["Richman"] = "Red County",
	["Calton Heights"] = "San Fierro",
	["The Strip"] = "Las Venturas",
	["Yellow Bell Golf Course"] = "Las Venturas",
	["Spinybed"] = "Las Venturas",
	["Verona Beach"] = "Los Santos",
	["King's"] = "San Fierro",
	["Garver Bridge"] = "Tierra Robada",
	["Easter Basin"] = "San Fierro",
	["LVA Freight Depot"] = "Las Venturas",
	["Restricted Area"] = "Bone County",
	["Greenglass College"] = "Las Venturas",
	["San Fierro Bay"] = "Tierra Robada",
	["Prickle Pine"] = "Las Venturas",
	["Redsands East"] = "Las Venturas",
	["Royal Casino"] = "Las Venturas",
	["Aldea Malvada"] = "Tierra Robada",
	["Verdant Meadows"] = "Bone County",
	["Randolph Industrial Estate"] = "Las Venturas",
	["Arco del Oeste"] = "Tierra Robada",
	["Willowfield"] = "Los Santos",
	["Bayside"] = "Tierra Robada",
	["Julius Thruway East"] = "Las Venturas",
	["Las Brujas"] = "Bone County",
	["Old Venturas Strip"] = "Las Venturas",
	["Leafy Hollow"] = "Flint County",
	["Flint Intersection"] = "Flint County",
	["Redsands West"] = "Las Venturas",
	["Starfish Casino"] = "Las Venturas",
	["Bone County"] = "Bone County",
	["The Visage"] = "Las Venturas",
	["Yellow Bell Station"] = "Las Venturas",
	["Flint Range"] = "Flint County",
	["Sherman Reservoir"] = "Tierra Robada",
	["Fern Ridge"] = "Red County",
	["Sobell Rail Yards"] = "Las Venturas",
	["Hampton Barns"] = "Red County",
	["Caligula's Palace"] = "Las Venturas",
	["Los Santos Inlet"] = "Flint County",
	["Bayside Tunnel"] = "Tierra Robada",
	["Idlewood"] = "Los Santos",
	["Green Palms"] = "Bone County",
	["East Beach"] = "Los Santos",
	["Chinatown"] = "San Fierro",
	["Whitewood Estates"] = "Las Venturas",
	["Rodeo"] = "Los Santos",
	["Garcia"] = "San Fierro",
	["Verdant Bluffs"] = "Los Santos",
	["Downtown Los Santos"] = "Los Santos",
	["Foster Valley"] = "San Fierro",
	["Fallen Tree"] = "Red County",
	["Marina"] = "Los Santos",
	["Las Venturas"] = "Las Venturas",
	["Esplanade East"] = "San Fierro",
	["Gant Bridge"] = "Tierra Robada",
	["Blackfield"] = "Las Venturas",
	["Market Station"] = "Los Santos",
	["Pilgrim"] = "Las Venturas",
	["Financial"] = "San Fierro",
	["Little Mexico"] = "Los Santos",
	["Mulholland"] = "Red County",
	["Angel Pine"] = "Whetstone",
	["Julius Thruway South"] = "Las Venturas",
	["Fort Carson"] = "Bone County",
	["Glen Park"] = "Los Santos",
	["Robada Intersection"] = "Tierra Robada",
	["Mount Chiliad"] = "San Fierro",
	["Juniper Hollow"] = "San Fierro",
	["Mulholland Intersection"] = "Los Santos",
	["The Emerald Isle"] = "Las Venturas", 
	["East Los Santos"] = "Los Santos",
	["Las Payasadas"] = "Bone County",
	["Shady Cabin"] = "Whetstone",
	["Frederick Bridge"] = "Red County",
	["Octane Springs"] = "Bone County",
	["The Panopticon"] = "Red County",
	["Blackfield Intersection"] = "Las Venturas",
	["Paradiso"] = "San Fierro",
	["Flint Water"] = "Red County",
	["Easter Bay Chemicals"] = "Red County",
	["Hunter Quarry"] = "Bone County",
	["Creek"] = "Las Venturas",
	["Las Colinas"] = "Los Santos",
	["Santa Flora"] = "San Fierro",
	["Palisades"] = "San Fierro",
	["Market"] = "Los Santos",
	["Blueberry Acres"] = "Red County",
	["Dillimore"] = "Red County",
	["Pershing Square"] = "Los Santos",
	["Fallow Bridge"] = "Red County",
	["Easter Bay Airport"] = "Red County",
	["Ocean Docks"] = "Los Santos",
	["Whetstone"] = "Whetstone",
	["Unity Station"] = "Los Santos",
	["Downtown"] = "San Fierro"
}






function GetSkinSpecific(team, zone)
	local skin = false
	if(BotSkin[team]) then
		skin = BotSkin[team][math.random(#BotSkin[team])]
	end
	
	if(BotSkinSpecific[team]) then
		if(BotSkinSpecific[team][ZonesRegion[zone]]) then
			if(BotSkinSpecific[team][ZonesRegion[zone]][zone]) then
				skin = BotSkinSpecific[team][ZonesRegion[zone]][zone][math.random(#BotSkinSpecific[team][ZonesRegion[zone]][zone])]
			else
				if(BotSkinSpecific[team][ZonesRegion[zone]]["all"]) then
					skin = BotSkinSpecific[team][ZonesRegion[zone]]["all"][math.random(#BotSkinSpecific[team][ZonesRegion[zone]]["all"])]
				end
			end
		end
	end
	
	return skin
end







function StartJust()
	ReleaseStreamer()
	setTimer(function()
		ReleaseStreamer()
	end, 5000, 0)
	
	for _,thePlayer in pairs(getElementsByType "player") do
		Streamer(thePlayer)
	end
end
addEventHandler("onResourceStart", resourceRoot, StartJust)


function getbots()
	local zones = {}
	for thePed, _ in pairs(JustPeds) do
		local x,y,z = getElementPosition(thePed)
		zone = exports["ps2_weather"]:GetZoneName(x,y,z, false, "San Andreas")
		if(not zones[zone]) then zones[zone] = 0 end
		zones[zone] = zones[zone]+1
	end
	
	
	for zon, count in pairs(zones) do
		outputConsole(zon..": "..count)
	end
	
	outputConsole(getArrSize(JustPeds))
end
addCommandHandler("getbots", getbots)




function RemovePedFromVehicle(thePed, thePlayer)
	if(thePed) then
		local theVehicle = getPedOccupiedVehicle(thePed)
		if(theVehicle) then
			local x,y,z = getElementPosition(theVehicle)
			local _,_,rz = getElementRotation(theVehicle)
			removePedFromVehicle(thePed)
			
			local x1,y1,z1 = getPointInFrontOfPoint(x, y, z, rz-180, 1)
			setElementPosition(thePed, x1,y1,z1, true)
			if(thePlayer) then
				setElementData(thePed, "attacker", getPlayerName(thePlayer))
			end
		end
	end
end
addEvent("RemovePedFromVehicle", true)
addEventHandler("RemovePedFromVehicle", resourceRoot, RemovePedFromVehicle)





local AllFires = {}
function CreateFire(arr)
	arr = fromJSON(arr)
	local x, y, z = false
	for v, k in pairs(arr) do
		x, y, z = k[1], k[2], k[3]
		local fireid = "id"..getArrSize(AllFires)
		AllFires[fireid] = {}
		AllFires[fireid]["obj"] = createColSphere(k[1], k[2], k[3]+1, 1)--createMarker(k[1], k[2], k[3], "checkpoint", 1, 0,0,0,0)
		setElementData(AllFires[fireid]["obj"], "fireid", fireid)
		
		AllFires[fireid]["timer"] = setTimer(function(obj)
			destroyElement(obj)
		end, 60000, 1, AllFires[fireid]["obj"])
	end
end
addEvent("CreateFire", true)
addEventHandler("CreateFire", root, CreateFire)



function hot()
	if(math.random(1,5) == 5) then
	local x,y,z = getElementPosition(source)
		FireTruck(x,y,z,0,0)
		FireTruck(x,y,z,0,0)
	end
end
addEventHandler("onVehicleExplode", root, hot)




function RemoveFire(thePlayer, fireid)
	if(AllFires[fireid]) then
		killTimer(AllFires[fireid]["timer"])
		destroyElement(AllFires[fireid]["obj"])
		AllFires[fireid] = nil
	end
end
addEvent("RemoveFire", true)
addEventHandler("RemoveFire", root, RemoveFire)





function firetruck(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	
	
	local thePed = FireTruck(x,y,z,0,0)
end
addCommandHandler("firetruck", firetruck)




local FireTruckModel = {
	["Los Santos"] = 277,
	["San Fierro"] = 279,
	["Las Venturas"] = 278,
	["Red County"] = 277,
	["Whetstone"] = 279,
	["Flint County"] = 277, 
	["Bone County"] = 278,
	["Tierra Robada"] = 278,
}

function FireTruck(x,y,z,i,d)
	local zone = getZoneName(x,y,z, true)
	
	if(FireTruckModel[zone] and d == 0) then
		local city = "San Andreas"
		
		local positions = GetVehicleNodesInRange(city, x,y,z, 80,140)
		if(#positions == 0) then return false end
		
		local rn = positions[math.random(#positions)]
		local arr = false
		for _,v in pairs(positions) do
			if(DistanceAllMinimal(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3])) then
				arr = exports["vehicle_node"]:NEWGPSFound(city, PathNodes[city][rn[1]][rn[2]][2],PathNodes[city][rn[1]][rn[2]][3],z, x,y,z)
				if(arr) then break end
			end
		end
		
		if(arr) then
			local thePed = CreateJustDriver("San Andreas", arr[1][1], arr[1][2], FireTruckModel[zone], 407)
			setElementData(thePed, "path", arr)
			setElementData(thePed, "PedStatus", "FireTrucker")
			return thePed
		end
	end
end



function kr(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	local city = getPlayerCity(thePlayer)
	local zone = exports["ps2_weather"]:GetZoneName(x,y,z, true, city)
	local rand = PoliceSpecificZone[zone][math.random(#PoliceSpecificZone[zone])]
	kr(thePlayer, rand[1], rand[2]) -- Выезжает полиция
end
addCommandHandler("kr", kr)



function medic(thePlayer)
	local x,y,z = getElementPosition(thePlayer)
	
	local thePed = medic(thePlayer, 416, 274)
end
addCommandHandler("medic", medic)


function medic(thePlayer, vmodel, pedmodel)
	local x,y,z = getElementPosition(thePlayer)
	local i,d = getElementInterior(thePlayer), getElementDimension(thePlayer)
	local city = getPlayerCity(thePlayer)


	local positions = GetVehicleNodesInRange(city, x,y,z, 80,140)
	if(#positions == 0) then return false end
	
	local rn = positions[math.random(#positions)]
	local arr = false
	for _,v in pairs(positions) do
		if(DistanceAllMinimal(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3])) then
			arr = exports["vehicle_node"]:NEWGPSFound(city, PathNodes[city][rn[1]][rn[2]][2],PathNodes[city][rn[1]][rn[2]][3],z, x,y,z)
			if(arr) then break end
		end
	end
	
	if(arr) then
		local thePed = CreateJustDriver(city, arr[1][1], arr[1][2], pedmodel, vmodel)
		
		setElementData(thePed, "path", arr)
		setElementData(thePed, "PedStatus", "Medic")
		setElementData(thePed, "attacker", getPlayerName(thePlayer))
		return thePed
	end
end




function WastedPed(totalAmmo, killer, weapon, bodypart, stealth)
	if(killer) then
		if(getElementType(killer) ~= "player") then return false end
		local rand = math.random(1,5)
		if(rand == 5) then
			medic(killer, 416, 274)
		end
	end
end
addEvent("onPedWasted", true)
addEventHandler("onPedWasted", resourceRoot, WastedPed)







function bandits(thePlayer, team)
	local x,y,z = getElementPosition(thePlayer)
	local i,d = getElementInterior(thePlayer), getElementDimension(thePlayer)
	local city = getPlayerCity(thePlayer)


		
	local positions = GetVehicleNodesInRange(city, x,y,z, 80,140)
	for _ = 1, 4 do
		if(#positions > 0) then 
			local pos = math.random(#positions)
			local v = positions[pos]
			if(PathNodes[city][v[1]][v[2]][1] == true) then -- Отсекаем закрытые дороги
				if(DistanceAllMinimal(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3])) then
					local thePed = CreateJustDriver(city, v[1], v[2], team)
					setElementData(thePed, "attacker", getPlayerName(thePlayer))
				end
			end
			table.remove(positions, pos)
		end
	end
end
addEvent("bandits", true)
addEventHandler("bandits", root, bandits)








function kr(thePlayer, vmodel, pedmodel)
	local x,y,z = getElementPosition(thePlayer)
	local i,d = getElementInterior(thePlayer), getElementDimension(thePlayer)
	local city = getPlayerCity(thePlayer)


	local positions = GetVehicleNodesInRange(city, x,y,z, 80,140)
	if(#positions == 0) then return false end
	
	local rn = positions[math.random(#positions)]
	local arr = false
	for _,v in pairs(positions) do
		if(DistanceAllMinimal(PathNodes[city][v[1]][v[2]][2], PathNodes[city][v[1]][v[2]][3])) then
			arr = exports["vehicle_node"]:NEWGPSFound(city, PathNodes[city][rn[1]][rn[2]][2],PathNodes[city][rn[1]][rn[2]][3],z, x,y,z)
			if(arr) then break end
		end
	end
		
	if(arr) then
		local thePed = CreateJustDriver(city, arr[1][1], arr[1][2], pedmodel, vmodel)
		
		setElementData(thePed, "path", arr)
		setElementData(thePed, "PedStatus", "Police")
		setElementData(thePed, "attacker", getPlayerName(thePlayer))
		return thePed
	end
end
addEvent("kr", true)
addEventHandler("kr", resourceRoot, kr)








function RemoveDriverBot(thePed)
	removeElementData(thePed, "path")
end
addEvent("RemoveDriverBot", true)
addEventHandler("RemoveDriverBot", resourceRoot, RemoveDriverBot)





