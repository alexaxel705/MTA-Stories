updateTime = 1 -- время обновления пройденной дистанции в секундах

cleartTime = 4 -- скорость удаления каждого уровня загрязнения на маркерах мойки в секундах

dirtCoef = 5 -- на сколько быстрее загрязнается т/с при езде не по дорогам

-- уровни загрязнения т/с
dirtLevel = {
	-- пройденая дистанция (метры) | уровень загрязнения
	{8000, 6},
	{7500, 5},
	{6000, 4},
	{4500, 3},
	{3000, 2},
	{1500, 1},
	{0, 0},
}

-- координаты моек
clearStation = {
	{2360, -657, 128},
	{1911.6395263672, -1775.4776611328, 12.900556564331}, -- Idlewood, Los Santos, at the Going station
	{2454.3850097656, -1460.5235595703, 23.419036865234}, -- East Los Santos, northeast of Cluckin' Bell 
	{1017.7843017578, -917.67077636719, 42.1796875}, -- South Mulholland, Los Santos, behind the Quite Humorous Comedy Club
	{2163.1999511719, 2472.99609375, 10.8203125}, -- Soapys Car Wash, Roca Escalante, Las Venturas
}



-- названия текстур на которые накладывается грязь
textureName = {
	"vehiclegrunge256",
}

-- пустые таблицы
dirtShaderVehicle = {}
dirtTextureVehicle = {}
clearStationList = {}
clearTimer = {}