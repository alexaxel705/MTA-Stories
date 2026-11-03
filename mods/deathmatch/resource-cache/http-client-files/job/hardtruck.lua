
local TruckMarker = {}





local SLG = {"Автомобильные запчасти", "Строительные материалы", "Продукты" ,"Фрукты", "Мебель", "Удобрения", "Хлопья", "Сок", "Неизвестный груз", "Пропан", "Электроника", "Одежда", "Игрушки", "Цемент", "Инструменты", "Товары", "Уголь"} -- Генерируемый груз на любых складах
local SUG = {"Автомобильные запчасти", "Строительные материалы" ,"Продукты" ,"Фрукты", "Мебель", "Удобрения", "Хлопья", "Сок", "Неизвестный груз", "Пропан", "Электроника", "Одежда", "Игрушки", "Цемент", "Инструменты", "Товары", "Уголь", "Скот"} -- Принимаемый груз на любых складах






-- theVehicle, x,y,z,rx,ry,rz, {Принимаемый груз (nil - никакой)}, {Генерируемый груз (nil - никакой)},
-- Если false то свободно, если true то в ожидании, если theVehicle то готов к отправке
local TrailersPositions = {
	["Склад «Fallen Tree»"] = {
		[1] = {false, -557.6, -500, 24.1, 0,0,0, SUG, SLG},
		[2] = {false, -529.8, -500, 24.1, 0,0,0, SUG, SLG},
		[3] = {false, -520.5, -500, 24.1, 0,0,0, SUG, SLG},
		[4] = {false, -520.3, -545.5, 24.5, 0,0,180, SUG, SLG},
		[5] = {false, -529.7, -545.5, 24.5, 0,0,180, SUG, SLG},
		[6] = {false, -557.6, -545.5, 24.5, 0,0,180, SUG, SLG},
	},
	["Liberty City"] = {
		[1] = {false, 2786, -2494.6, 12.6, 0,0,90, SUG, SLG},
		[2] = {false, 2786, -2456.2, 12.6, 0,0,90, SUG, SLG},
		[3] = {false, 2786, -2418.1, 12.6, 0,0,90, SUG, SLG},
	},
	["НПЗ «Грин-Палмс»"] = {
		[1] = {false, 283.7, 1380, 9.6, 0,0,90, nil, {"Бензин"}},
		[2] = {false, 283.7, 1385, 9.6, 0,0,90, nil, {"Бензин"}},
		[3] = {false, 283.7, 1390, 9.6, 0,0,90, nil, {"Бензин"}},
		[4] = {false, 283.7, 1395, 9.6, 0,0,90, nil, {"Бензин"}}
	},
	["Easter Bay Chemicals"] = {
		[1] = {false, -1043.5, -696.8, 31, 0,0,0, nil, {"Бензин"}},
		[2] = {false, -992.8, -698.6, 31, 0,0,90, nil, {"Бензин"}},
	},
	["Грузовая станция Los Santos"] = {
		[1] = {false, 1769.5, -2042.6, 12.5, 0,0,270, SUG, SLG},
		[2] = {false, 1769.5, -2038.3, 12.5, 0,0,270, SUG, SLG},
		[3] = {false, 1788.8, -2057, 12.6, 0,0,0, SUG, SLG},
	},
	["RS Haul"] = {
		[1] = {false, -68.6, -1112.5, 0.1, 0,0,90, SUG, SLG},
		[2] = {false, -70, -1121.5, 0.1, 0,0,90, SUG, SLG},
		[3] = {false, -65, -1143, 0.1, 0,0,0, SUG, SLG},
		[4] = {false, -60, -1146, 0.1, 0,0,0, SUG, SLG},
		[5] = {false, -54, -1149, 0.1, 0,0,0, SUG, SLG},
		[6] = {false, -48, -1152, 0.1, 0,0,0, SUG, SLG},
		[7] = {false, -42, -1155, 0.1, 0,0,0, SUG, SLG},
	},
	["Pecker's Feed & Seed"] = {
		[1] = {false, -337, 2682, 62.3, 0,0,90, SUG, {"Скот"}},
		[2] = {false, -337, 2678, 62.3, 0,0,90, SUG, {"Скот"}},
		[3] = {false, -337, 2674, 62.3, 0,0,90, SUG, {"Скот"}},
		[4] = {false, -337, 2670, 62.3, 0,0,90, SUG, {"Скот"}},
		[5] = {false, -286, 2666, 61.7, 0,0,90, SUG, {"Скот"}},
		[6] = {false, -286, 2661, 61.7, 0,0,90, SUG, {"Скот"}},
	},
	["Solarin Industries"] = {
		[1] = {false, -1838, 112.9, 14.1, 0,0,270, nil, nil},
	},
	["Грузовая станция Las Venturas"] = {
		[1] = {false, 2261, 2779.9, 9.8, 0,0,90, SUG, SLG},
		[2] = {false, 2261, 2770.5, 9.8, 0,0,90, SUG, SLG},
		[3] = {false, 2261, 2763.9, 9.8, 0,0,90, SUG, SLG},
		[4] = {false, 2261, 2754.5, 9.8, 0,0,90, SUG, SLG},
		[5] = {false, 2261, 2747.7, 9.8, 0,0,90, SUG, SLG},
		[6] = {false, 2261, 2738.3, 9.8, 0,0,90, SUG, SLG},

		[7] = {false, 2296, 2780, 9.8, 0,0,270, SUG, SLG},
		[8] = {false, 2296, 2770.6, 9.8, 0,0,270, SUG, SLG},
		[9] = {false, 2296, 2763.8, 9.8, 0,0,270, SUG, SLG},
		[10] = {false, 2296, 2754.5, 9.8, 0,0,270, SUG, SLG},
		[11] = {false, 2296, 2747.9, 9.8, 0,0,270, SUG, SLG},
		[12] = {false, 2296, 2738.4, 9.8, 0,0,270, SUG, SLG},

		[13] = {false, 2346.3, 2780, 9.8, 0,0,270, SUG, SLG},
		[14] = {false, 2346.3, 2770.6, 9.8, 0,0,270, SUG, SLG},
		[15] = {false, 2346.3, 2763.8, 9.8, 0,0,270, SUG, SLG},
		[16] = {false, 2346.3, 2754.5, 9.8, 0,0,270, SUG, SLG},
		[17] = {false, 2346.3, 2747.9, 9.8, 0,0,270, SUG, SLG},
		[18] = {false, 2346.3, 2738.4, 9.8, 0,0,270, SUG, SLG},

		[19] = {false, 2311.7, 2780, 9.8, 0,0,90, SUG, SLG},
		[20] = {false, 2311.7, 2770.6, 9.8, 0,0,90, SUG, SLG},
		[21] = {false, 2311.7, 2763.8, 9.8, 0,0,90, SUG, SLG},
		[22] = {false, 2311.7, 2754.5, 9.8, 0,0,90, SUG, SLG},
		[23] = {false, 2311.7, 2747.9, 9.8, 0,0,90, SUG, SLG},
		[24] = {false, 2311.7, 2738.4, 9.8, 0,0,90, SUG, SLG},
	},
	["Склад «Redsands West»"] = {
		[1] = {false, 1638, 2303, 9.3, 0,0,90, SUG, SLG},
		[2] = {false, 1638, 2312.2, 9.2, 0,0,90, SUG, SLG},
		[3] = {false, 1638, 2340.2, 9.3, 0,0,90, SUG, SLG},
		[4] = {false, 1681, 2303, 9.3, 0,0,270, SUG, SLG},
		[5] = {false, 1681, 2312.5, 9.3, 0,0,270, SUG, SLG},
		[6] = {false, 1681, 2340.3, 9.4, 0,0,270, SUG, SLG},
	},
	["Склад №2 Las Venturas"] = {
		[1] = {false, 1133, 1935, 9.8, 0,0,270, SUG, SLG},
		[2] = {false, 1133, 1926.3, 9.8, 0,0,270, SUG, SLG},
		[3] = {false, 1133, 1920.2, 9.8, 0,0,270, SUG, SLG},
		[4] = {false, 1133, 1911.5, 9.8, 0,0,270, SUG, SLG},
		[5] = {false, 1133, 1904, 9.8, 0,0,270, SUG, SLG},
		[6] = {false, 1133, 1896.6, 9.8, 0,0,270, SUG, SLG},

		[7] = {false, 1109, 1935, 9.8, 0,0,90, SUG, SLG},
		[8] = {false, 1109, 1926.3, 9.8, 0,0,90, SUG, SLG},
		[9] = {false, 1109, 1920.2, 9.8, 0,0,90, SUG, SLG},
		[10] = {false, 1109, 1911.5, 9.8, 0,0,90, SUG, SLG},
		[11] = {false, 1109, 1904, 9.8, 0,0,90, SUG, SLG},
		[12] = {false, 1109, 1896.6, 9.8, 0,0,90, SUG, SLG},

		[13] = {false, 1053, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[14] = {false, 1060.4, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[15] = {false, 1067.9, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[16] = {false, 1076.7, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[17] = {false, 1082.8, 1915.7, 9.8, 0,0,0, SUG, SLG},
		[18] = {false, 1091.4, 1915.7, 9.8, 0,0,0, SUG, SLG},

		[19] = {false, 1067.9, 1892, 9.8, 0,0,180, SUG, SLG},
		[20] = {false, 1076.7, 1892, 9.8, 0,0,180, SUG, SLG},
		[21] = {false, 1082.8, 1892, 9.8, 0,0,180, SUG, SLG},
		[22] = {false, 1091.4, 1892, 9.8, 0,0,180, SUG, SLG},
	},
	["Shafted Appliances"] = {
		[1] = {false, 1681, 919.4, 9.7, 0,0,0, nil, {"Электроника"}},
		[2] = {false, 1710.4, 931.4, 9.8, 0,0,90, nil, {"Электроника"}},
	},
	["АЗС «Xoomer»"] = {
		[1] = {false, -1715.1, 394.7, 6.2, 0,0,225, {"Бензин"}, nil}
	},
	["The Uphill Gardener"] = {
		[1] = {false, -2586.8, 304.2, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[2] = {false, -2586.8, 307.7, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[3] = {false, -2586.8, 311.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[4] = {false, -2586.8, 314.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[5] = {false, -2586.8, 318.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[6] = {false, -2586.8, 321.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[7] = {false, -2586.8, 325.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[8] = {false, -2586.8, 328.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[9] = {false, -2586.8, 332.1, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
		[10] = {false, -2586.8, 335.6, 3.9, 0,0,90, {"Удобрения"}, {"Садовые растения"}},
	},

	["Emerald Mart"] = {
		[1] = {false, 2060, 2238.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
		[2] = {false, 2060, 2251.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
		[3] = {false, 2060, 2264.3, 9.4, 0,0,90, {"Продукты", "Одежда"}, nil},
	},
	["LVA Freight Mart"] = {
		[1] = {false, 1528.3, 943.5, 9.8, 0,0,90, {"Продукты", "Игрушки"}, nil},
		[2] = {false, 1528.3, 951.7, 9.8, 0,0,90, {"Продукты", "Игрушки"}, nil},
	},
	["Dillimore Welcome Pump"] = {
		[1] = {false, 680.9, -442.4, 15.3, 0,0,270, {"Продукты"}, nil},
	},
	["Dillimore Watson Automotive"] = {
		[1] = {false, 640, -500.1, 15.3, 0,0,180, {"Автомобильные запчасти"}, nil},
	},
	["Dillimore Big Mike's"] = {
		[1] = {false, 634.4, -514.8, 15.3, 0,0,0, {"Автомобильные запчасти"}, nil},
	},
	["Dillimore Склад"] = {
		[1] = {false, 790, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[2] = {false, 797.7, -617.3, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[3] = {false, 820.1, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[4] = {false, 830.3, -609.8, 15.3, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
	},
	["Montgomery BIO Engineering"] = {
		[1] = {false, 1354.7, 363.6, 19, 352,0,66, nil, {"Химикаты"}},
		[2] = {false, 1351.3, 356, 19, 352,0,66, nil, {"Химикаты"}},
		[3] = {false, 1340.9, 333, 19, 352,0,66, nil, {"Химикаты"}},
		[4] = {false, 1337.7, 325.2, 19, 352,0,66, nil, {"Химикаты"}},
	},
	["Склад «Rockshore East»"] = {
		[1] = {false, 2818.1, 895.7, 9.1, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[2] = {false, 2827.3, 896.9, 9.2, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[3] = {false, 2855.1, 895.9, 9.1, 0,0,0, {"Инструменты"}, {"Фрукты", "Мебель"}},

		[4] = {false, 2818, 853, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[5] = {false, 2827.3, 853, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
		[6] = {false, 2855.3, 852.5, 9.2, 0,0,180, {"Инструменты"}, {"Фрукты", "Мебель"}},
	},
}

function FoundRandomEmptyTruckLocation(banned) -- Генерирует случайный груз [Возвращает {Имя базы, id трейлера}]
	local AllLoc = {}
	for BaseName, arr in pairs(TrailersPositions) do
		if(BaseName ~= banned) then
			for i, key in pairs (arr) do
				if(key[1] == false) then
					if(key[9]) then -- Если станция генерирует грузы
						AllLoc[#AllLoc+1] = {BaseName, i}
					end
				end
			end
		end
	end
	if(#AllLoc == 0) then
		return {"Грузовая станция Las Venturas", 1}
	end
	return AllLoc[math.random(#AllLoc)]
end



function FoundRandomEmptyTruckLocationOut(banned, gruz) -- Ищет для груза конечную станцию [Возвращает {Имя базы, id трейлера}]
	local AllLoc = {}
	for BaseName, arr in pairs(TrailersPositions) do
		if(BaseName ~= banned) then
			for i, key in pairs (arr) do
				if(key[1] == false) then
					if(key[8]) then -- Если станция принимает грузы
						for _, gr in pairs(key[8]) do
							if(gruz == gr) then
								AllLoc[#AllLoc+1] = {BaseName, i}
								break
							end
						end
					end
				end
			end
		end
	end
	if(#AllLoc == 0) then
		return {"Грузовая станция Las Venturas", 1}
	end
	return AllLoc[math.random(#AllLoc)]
end




local TrailersVaritans = {
	[435] = {
		[1] = {"Хлопья", 1},
		[2] = {"Сок", 1},
		[3] = {"Одежда", 1},
		[4] = {"Одежда", 1},
		[5] = {"Неизвестный груз", 1},
		[6] = {"Скот", 1.5}
	},
	[450] = {
		[1] = {"Уголь", 1.5},
	},
	[591] = {
		[1] = {"Товары", 1.2}
	},
	[584] = {
		[1] = {"Бензин", 2},
	},
	[499] = {
		[1] = {"Инструменты", 1.5},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Садовые растения", 1},
		[4] = {"Мебель", 1.2}
	},
	[524] = {
		[1] = {"Цемент", 1.5}
	},
	[609] = {
		[1] = {"Неизвестный груз", 1}
	},
	[498] = {
		[1] = {"Химикаты", 2}
	},
	[455] = {
		[1] = {"Неизвестный груз", 1},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Неизвестный груз", 1}
	},
	[414] = {
		[1] = {"Игрушки", 1},
		[2] = {"Одежда", 1},
		[3] = {"Одежда", 1},
		[4] = {"Электроника", 1},
	},
	[456] = {
		[1] = {"Пропан", 1.5},
		[2] = {"Неизвестный груз", 1},
		[3] = {"Неизвестный груз", 1},
		[4] = {"Удобрения", 1},
	},
	[440] = {
		[1] = {"Хлопья", 1},
		[2] = {"Фрукты", 1},
		[3] = {"Продукты", 1.5},
		[4] = {"Строительные материалы", 1.5},
		[5] = {"Автомобильные запчасти", 1},
		[6] = {"Автомобильные запчасти", 1}
	},
}





function CreateTrailer(BaseDat)

	local arr = TrailersPositions[BaseDat[1]][BaseDat[2]]
	local AllModels = {}
	local randProd = arr[9][math.random(#arr[9])]
	for models, var in pairs(TrailersVaritans) do
		for i, dat in pairs(var) do
			if(dat[1] == randProd) then
				AllModels[#AllModels+1] = {models, i-1}
			end
		end
	end

	local MV = AllModels[math.random(#AllModels)]
	local x,y,z,rx,ry,rz = arr[2], arr[3], arr[4], arr[5], arr[6], arr[7]
	local t = createVehicle(MV[1],x,y,z+1, rx, ry, rz, "", MV[2], MV[2])
	setElementData(t, "resx", x)
	setElementData(t, "resy", y)
	setElementData(t, "resz", z)
	setElementData(t, "resrx", rx, false)
	setElementData(t, "resry", ry, false)
	setElementData(t, "resrz", rz, false)
	setElementData(t, "product", TrailersVaritans[MV[1]][MV[2]+1][1])
	setElementData(t, "type", "jobtruck")--Для JPS

	local rl = FoundRandomEmptyTruckLocationOut(BaseDat[1], randProd)
	local randLoc = TrailersPositions[rl[1]][rl[2]]
	setElementData(t, "x", randLoc[2])
	setElementData(t, "y", randLoc[3])
	setElementData(t, "z", randLoc[4])
	setElementData(t, "BaseDat", toJSON({rl[1], rl[2]}))
	setElementData(t, "RandLoc", toJSON({BaseDat[1], BaseDat[2]}))

	setElementData(t, "money", math.floor(((getDistanceBetweenPoints3D(randLoc[2],randLoc[3],randLoc[4],x,y,z)*2)*TrailersVaritans[MV[1]][MV[2]+1][2])))

	TrailersPositions[BaseDat[1]][BaseDat[2]][1] = t
	TrailersPositions[rl[1]][rl[2]][1] = true
	return t
end

for slot = 1, 50 do
	CreateTrailer(FoundRandomEmptyTruckLocation())
end




function DeattachTrailer(theTruck)
	local occ = getVehicleOccupant(theTruck)
	if(occ) then
		if(getElementModel(theTruck) ~= 525 and getElementModel(theTruck) ~= 531) then
			if(isElement(TruckMarker[occ])) then
				DestroyTruckMarker(occ)
			end
		end
	end
end
addEventHandler("onTrailerDetach", root, DeattachTrailer)

function DestroyTruckMarker(thePlayer)
	destroyElement(TruckMarker[thePlayer])
	triggerClientEvent(thePlayer, "RemoveGPSMarker", thePlayer, "Отвези груз")
end




function MarkerHit(hitElement, Dimension)
    local elementType = getElementType(hitElement) -- get the hit element's type
	if(elementType == "vehicle" and Dimension) then
		local thePlayer = getVehicleOccupant(hitElement, 0)
		if(getVehicleType(hitElement) == "Trailer") then
			local truck = getVehicleTowingVehicle(hitElement)
			if(truck) then thePlayer = getVehicleOccupant(truck, 0) end
		end
		if(thePlayer) then
			local theVehicle = hitElement
			if(getElementData(theVehicle, "type") == "jobtruck" and getElementData(source, "type") == "TruckMarker" and getElementData(source, "player") == getPlayerName(thePlayer)) then
				exports["228"]:AddPlayerMoney(thePlayer, getElementData(theVehicle, "money"), "РАБОТА ВЫПОЛНЕНА!")
				exports["228"]:AddSkill(thePlayer, 161)

				DestroyTruckMarker(thePlayer)		
				exports["228"]:Respect(thePlayer, "civilian", 1)
				local rl = fromJSON(getElementData(theVehicle, "RandLoc"))
				local bd = fromJSON(getElementData(theVehicle, "BaseDat"))
				destroyElement(theVehicle)
				TrailersPositions[rl[1]][rl[2]][1] = false
				TrailersPositions[bd[1]][bd[2]][1] = false
				CreateTrailer(FoundRandomEmptyTruckLocation())
			end
		end
	end
end
addEventHandler("onMarkerHit", root, MarkerHit)




function turnEngineOff(theVehicle, leftSeat, jackerPlayer, unbindkey)
	if(getElementType(source) == "player") then
		if(source) then
			if(getElementModel(theVehicle) == 515 or getElementModel(theVehicle) == 514 or getElementModel(theVehicle) == 403) then
				if(isElement(TruckMarker[source])) then
					DestroyTruckMarker(source)
				end
			end
		end
	end
end
addEventHandler("onPlayerVehicleExit", root, turnEngineOff)






function player_Wasted(ammo, killer, weapon, bodypart, stealth)
	if(isElement(TruckMarker[source])) then
		DestroyTruckMarker(source)
		TruckMarker[source] = nil
	end
end
addEventHandler("onPlayerWasted", root, player_Wasted)



function turnEngineOn(theVehicle, leftSeat, jackerPlayer, unbindkey)
	--setTrainDerailable(theVehicle, false)
	if(getElementType(source) == "player") then
		if(model == 515 or model == 514 or model == 403) then
			if(leftSeat == 0) then
				local trailer = getVehicleTowedByVehicle(theVehicle)
				if(trailer) then
					CreateTruckMarker(source, getElementData(trailer, "x"), getElementData(trailer, "y"), getElementData(trailer, "z"))
				end
			end
		end


		if(getElementData(theVehicle, "type")) then
			if(getElementData(theVehicle, "type") == "jobtruck") then
				CreateTruckMarker(source, getElementData(theVehicle, "x"), getElementData(theVehicle, "y"), getElementData(theVehicle, "z"))
			end
		end
	end
end
addEventHandler("onPlayerVehicleEnter", root, turnEngineOn)




function AttachTrailer(theTruck)
	if(getPedOccupiedVehicleSeat(getVehicleOccupant(theTruck)) == 0) then
		if(getElementModel(theTruck) ~= 525 and getElementModel(theTruck) ~= 531) then
			CreateTruckMarker(getVehicleOccupant(theTruck), getElementData(source, "x"), getElementData(source, "y"), getElementData(source, "z"))
		end
	end
end
addEventHandler("onTrailerAttach", root, AttachTrailer)







function CreateTruckMarker(thePlayer, x, y, z)
	if(isElement(TruckMarker[thePlayer])) then
		DestroyTruckMarker(thePlayer)
	end
	TruckMarker[thePlayer] = createMarker(x, y, z, "checkpoint", 10, 0, 0, 0, 0, thePlayer)
	setElementData(TruckMarker[thePlayer], "type", "TruckMarker")
	setElementData(TruckMarker[thePlayer], "player", getPlayerName(thePlayer))
	triggerClientEvent(thePlayer, "helpmessageEvent", thePlayer, "#FFFFFFОтвези груз на #FF0000красный маркер#FFFFFF\nчтобы получить #32CD32вознаграждение")
	triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, x, y, z, "Отвези груз")
end
