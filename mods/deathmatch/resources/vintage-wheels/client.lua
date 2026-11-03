-- name/ scale
local CustomModels = {
	[400] = {"wheels/wheel_alloy64.png", 0.8}, 
	[401] = {"wheels/wheel_truck64.png", 0.8}, 
	[402] = {"wheels/whee_rim64.png", 0.7}, 
	[403] = {"wheels/wheel_truck64.png", 1.2}, 
	[404] = {"wheels/wheel_classic64.png", 0.7}, 
	[405] = {"wheels/wheel_saloon64.png", 0.7}, 
	[406] = {"wheels/wheel_offroad64.png", 2.5}, 
	[407] = {"wheels/wheel_truck64.png", 1}, 
	[408] = {"wheels/wheel_truck64.png", 1.1}, 
	[409] = {"wheels/wheel_classic64.png", 0.7}, 
	[410] = {"wheels/wheel_smallcar64.png", 0.6}, 
	[411] = {"wheels/whee_rim64.png", 0.7}, 
	[412] = {"wheels/wheel_classic64.png", 0.7}, 
	[413] = {"wheels/wheel_lightvan64.png", 0.8}, 
	[414] = {"wheels/wheel_truck64.png", 0.8}, 
	[415] = {"wheels/wheel_alloy64.png", 0.7}, 
	[416] = {"wheels/wheel_truck64.png", 0.9}, 
	[417] = {"wheels/wheel_classic64.png", 0.6}, 
	[418] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[419] = {"wheels/wheel_classic64.png", 0.7}, 
	[420] = {"wheels/wheel_sport64.png", 0.7}, 
	[421] = {"wheels/wheel_saloon64.png", 0.7}, 
	[422] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[423] = {"wheels/wheel_old.png", 0.7}, 
	[424] = {"wheels/wheel_offroad64.png", 0.9}, 
	[425] = {"wheels/wheel_classic64.png", 0.6}, 
	[426] = {"wheels/wheel_sport64.png", 0.7}, 
	[427] = {"wheels/wheel_truck64.png", 0.9}, 
	[428] = {"wheels/wheel_truck64.png", 0.9}, 
	[429] = {"wheels/whee_rim64.png", 0.7}, 
	[430] = false, 
	[431] = {"wheels/wheel_truck64.png", 1}, 
	[432] = false, 
	[433] = {"wheels/wheel_truck64.png", 1.2}, 
	[434] = {"wheels/wheel_sport64.png", 0.8}, 
	[435] = {"wheels/wheel_truck64.png", 1.2}, 
	[436] = {"wheels/wheel_smallcar64.png", 0.7}, 
	[437] = {"wheels/wheel_truck64.png", 1}, 
	[438] = {"wheels/wheel_classic64.png", 0.7}, 
	[439] = {"wheels/wheel_classic64.png", 0.7}, 
	[440] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[441] = false, 
	[442] = {"wheels/wheel_classic64.png", 0.7}, 
	[443] = {"wheels/wheel_truck64.png", 1.2}, 
	[444] = {"wheels/wheel_offroad64.png", 1.6}, 
	[445] = {"wheels/wheel_alloy64.png", 0.7}, 
	[446] = false, 
	[447] = false, 
	[448] = false, 
	[449] = false, 
	[450] = {"wheels/wheel_truck64.png", 1.2}, 
	[451] = {"wheels/whee_rim64.png", 0.7}, 
	[452] = false, 
	[453] = false, 
	[454] = false, 
	[455] = {"wheels/wheel_truck64.png", 1.2}, 
	[456] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	[457] = {"wheels/wheel_saloon64.png", 0.5}, 
	[458] = {"wheels/wheel_saloon64.png", 0.7}, 
	[459] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[460] = false,
	[461] = false,
	[462] = false,
	[463] = false,
	[464] = false,
	[465] = false,
	[466] = {"wheels/wheel_classic64.png", 0.75}, 
	[467] = {"wheels/wheel_classic64.png", 0.7}, 
	[468] = false,
	[469] = false,
	[470] = {"wheels/wheel_offroad64.png", 0.9},
	[471] = false,
	[472] = false,
	[473] = false,
	[474] = {"wheels/wheel_classic64.png", 0.7}, 
	[475] = {"wheels/wheel_classic64.png", 0.7}, 
	[476] = false,
	[477] = {"wheels/whee_rim64.png", 0.8}, 
	[478] = {"wheels/wheel_classic64.png", 0.7}, 
	[479] = {"wheels/wheel_saloon64.png", 0.7}, 
	[480] = {"wheels/wheel_sport64.png", 0.7}, 
	[481] = false,
	[482] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[483] = {"wheels/wheel_classic64.png", 0.6}, 
	[484] = false,
	[485] = {"wheels/wheel_lightvan64.png", 0.6}, 
	[486] = {"wheels/wheel_truck64.png", 1.6}, 
	[487] = false,
	[488] = false,
	[489] = {"wheels/wheel_offroad64.png", 0.9}, 
	[490] = {"wheels/wheel_offroad64.png", 0.9}, 
	[491] = {"wheels/wheel_smallcar64.png", 0.7},
	[492] = {"wheels/wheel_saloon64.png", 0.7},
	[493] = false, 
	[494] = {"wheels/wheel_alloy64.png", 0.8},
	[495] = {"wheels/wheel_offroad64.png", 1},
	[496] = {"wheels/wheel_sport64.png", 0.7},
	[497] = false,
	[498] = {"wheels/wheel_old.png", 0.85},
	[499] = {"wheels/wheel_lightvan64.png", 0.8},
	[500] = {"wheels/wheel_alloy64.png", 0.8},
	[501] = false,
	[502] = {"wheels/wheel_alloy64.png", 0.8},
	[503] = {"wheels/wheel_alloy64.png", 0.8},
	[504] = {"wheels/wheel_classic64.png", 0.7},
	[505] = {"wheels/wheel_offroad64.png", 0.9}, 
	[506] = {"wheels/wheel_saloon64.png", 0.7},
	[507] = {"wheels/wheel_sport64.png", 0.7},
	[508] = {"wheels/wheel_sport64.png", 0.7},
	[509] = false,
	[510] = false,
	[511] = {"wheels/wheel_classic64.png", 0.5}, 
	[512] = {"wheels/wheel_classic64.png", 0.5}, 
	[513] = {"wheels/wheel_classic64.png", 0.5}, 
	[514] = {"wheels/wheel_truck64.png", 1.2}, 
	[515] = {"wheels/wheel_truck64.png", 1.2}, 
	[516] = {"wheels/wheel_sport64.png", 0.7},
	[517] = {"wheels/wheel_sport64.png", 0.8},
	[518] = {"wheels/wheel_lightvan64.png", 0.7},
	[519] = {"wheels/wheel_classic64.png", 0.5},
	[520] = {"wheels/wheel_classic64.png", 0.5},
	[521] = false,
	[522] = false,
	[523] = false,
	[524] = {"wheels/wheel_truck64.png", 1}, 
	[525] = {"wheels/wheel_lightvan64.png", 1}, 
	[526] = {"wheels/wheel_sport64.png", 0.7}, 
	[527] = {"wheels/wheel_smallcar64.png", 0.7},
	[528] = {"wheels/wheel_truck64.png", 0.9},
	[529] = {"wheels/wheel_sport64.png", 0.7}, 
	[530] = {"wheels/whee_rim64.png", 0.4}, 
	[531] = false,
	[532] = false,
	[533] = {"wheels/wheel_sport64.png", 0.7}, 
	[534] = {"wheels/wheel_classic64.png", 0.7}, 
	[535] = {"wheels/wheel_classic64.png", 0.8}, 
	[536] = {"wheels/wheel_classic64.png", 0.7}, 
	[537] = false,
	[538] = false,
	[539] = false,
	[540] = {"wheels/wheel_saloon64.png", 0.7}, 
	[541] = {"wheels/whee_rim64.png", 0.7}, 
	[542] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[543] = {"wheels/wheel_classic64.png", 0.7}, 
	[544] = {"wheels/wheel_truck64.png", 1},
	[545] = {"wheels/wheel_classic64.png", 0.7}, 
	[546] = {"wheels/wheel_sport64.png", 0.7}, 
	[547] = {"wheels/wheel_sport64.png", 0.7}, 
	[548] = {"wheels/wheel_classic64.png", 0.5}, 
	[549] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[550] = {"wheels/wheel_sport64.png", 0.7}, 
	[551] = {"wheels/wheel_sport64.png", 0.7}, 
	[552] = {"wheels/wheel_lightvan64.png", 0.9}, 
	[553] = {"wheels/wheel_classic64.png", 0.5}, 
	[554] = {"wheels/wheel_lightvan64.png", 0.9}, 
	[555] = {"wheels/wheel_classic64.png", 0.7}, 
	[556] = {"wheels/wheel_offroad64.png", 1.6}, 
	[557] = {"wheels/wheel_offroad64.png", 1.6}, 
	[558] = {"wheels/wheel_saloon64.png", 0.7}, 
	[559] = {"wheels/wheel_alloy64.png", 0.7}, 
	[560] = {"wheels/whee_rim64.png", 0.7}, 
	[561] = {"wheels/wheel_saloon64.png", 0.7}, 
	[562] = {"wheels/wheel_sport64.png", 0.7}, 
	[563] = {"wheels/wheel_classic64.png", 0.5}, 
	[564] = false,
	[565] = false,
	[566] = {"wheels/wheel_smallcar64.png", 0.7}, 
	[567] = {"wheels/wheel_classic64.png", 0.7}, 
	[568] = false,
	[569] = false,
	[570] = false,
	[571] = false, 
	[572] = false,
	[573] = {"wheels/wheel_offroad64.png", 1.2}, 
	[574] = {"wheels/wheel_classic64.png", 0.5}, 
	[575] = {"wheels/wheel_classic64.png", 0.7}, 
	[576] = {"wheels/wheel_classic64.png", 0.7}, 
	[577] = false,
	[578] = {"wheels/wheel_truck64.png", 1}, 
	[579] = {"wheels/wheel_offroad64.png", 0.9}, 
	[580] = {"wheels/wheel_classic64.png", 0.8}, 
	[581] = false, 
	[582] = {"wheels/wheel_lightvan64.png", 0.8}, 
	[583] = false,
	[584] = {"wheels/wheel_truck64.png", 1.2}, 
	[585] = {"wheels/wheel_sport64.png", 0.7}, 
	[586] = false,
	[587] = {"wheels/wheel_alloy64.png", 0.7}, 
	[588] = {"wheels/wheel_old.png", 0.9}, 
	[589] = {"wheels/wheel_alloy64.png", 0.7}, 
	[590] = false,
	[591] = {"wheels/wheel_truck64.png", 1.2}, 
	[592] = {"wheels/wheel_classic64.png", 0.7}, 
	[593] = {"wheels/wheel_classic64.png", 0.5}, 
	[594] = false, 
	[595] = {"wheels/wheel_sport64.png", 0.7}, 
	[596] = {"wheels/wheel_sport64.png", 0.7}, 
	[597] = {"wheels/wheel_sport64.png", 0.7}, 
	[598] = {"wheels/wheel_classic64.png", 0.7}, 
	[599] = {"wheels/wheel_offroad64.png", 1}, 
	[600] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[601] = {"wheels/wheel_truck64.png", 1.3}, 
	[602] = {"wheels/wheel_sport64.png", 0.7}, 
	[603] = {"wheels/wheel_sport64.png", 0.7}, 
	[604] = {"wheels/wheel_old.png", 0.75}, 
	[605] = {"wheels/wheel_old.png", 0.7}, 
	[606] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[607] = {"wheels/wheel_lightvan64.png", 0.6}, 
	[608] = {"wheels/wheel_lightvan64.png", 0.5}, 
	[609] = {"wheels/wheel_old.png", 0.85}, 
	[610] = {"wheels/wheel_lightvan64.png", 0.3}, 
	[611] = {"wheels/wheel_lightvan64.png", 0.7}, 
	
	[612] = {"wheels/wheel_saloon64.png", 0.7}, 
	[613] = {"wheels/wheel_smallcar64.png", 0.7}, 
	[614] = {"wheels/wheel_truck64.png", 0.9}, 
	[615] = {"wheels/whee_rim64.png", 0.7},
	[616] = {"wheels/wheel_truck64.png", 1.2}, 
	[617] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[618] = {"wheels/wheel_offroad64.png", 0.9}, 
	[619] = {"wheels/wheel_classic64.png", 0.7}, 
	[620] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[621] = {"wheels/wheel_lightvan64.png", 0.8}, 
	[622] = {"wheels/wheel_lightvan64.png", 0.8}, 
	[623] = {"wheels/wheel_classic64.png", 0.7}, 
	[624] = {"wheels/wheel_lightvan64.png", 0.8}, 
	[625] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	[626] = {"wheels/wheel_classic64.png", 0.7}, 
	[627] = {"wheels/wheel_alloy64.png", 0.7}, 
	[628] = {"wheels/wheel_saloon64.png", 0.7}, 
	[629] = {"wheels/wheel_classic64.png", 0.5}, 
	[630] = {"wheels/whee_rim64.png", 0.7}, 
	[631] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	[632] = {"wheels/wheel_classic64.png", 0.7}, 
	[633] = {"wheels/wheel_saloon64.png", 0.7}, 
	[634] = {"wheels/whee_rim64.png", 0.7}, 
	[635] = {"wheels/wheel_lighttruck64.png", 1}, 
	[636] = {"wheels/wheel_truck64.png", 1.2}, 
	[637] = {"wheels/whee_rim64.png", 0.7}, 
	[638] = {"wheels/wheel_classic64.png", 0.7}, 
	[639] = {"wheels/whee_rim64.png", 0.8}, 
	[640] = {"wheels/wheel_truck64.png", 1.2}, 
	[641] = {"wheels/wheel_saloon64.png", 0.7}, 
	[642] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[643] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[644] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	[645] = {"wheels/wheel_offroad64.png", 0.9}, 
	[646] = {"wheels/wheel_classic64.png", 0.7}, 
	[647] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[648] = {"wheels/wheel_saloon64.png", 0.7}, 
	[649] = {"wheels/wheel_saloon64.png", 0.7}, 
	[650] = {"wheels/whee_rim64.png", 0.9}, 
	[651] = false, 
	[652] = false, 
	[653] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[654] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	[655] = {"wheels/whee_rim64.png", 0.7}, 
	[656] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[657] = false, 
	[658] = {"wheels/wheel_classic64.png", 0.7}, 
	[659] = {"wheels/wheel_saloon64.png", 0.7}, 
	[660] = {"wheels/wheel_saloon64.png", 0.7}, 
	[661] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[662] = {"wheels/wheel_lighttruck64.png", 1}, 
	[663] = {"wheels/whee_rim64.png", 0.7}, 
	[664] = {"wheels/wheel_lighttruck64.png", 0.9}, 
	
	[665] = {"wheels/wheel_alloy64.png", 0.7}, 
	[666] = {"wheels/wheel_truck64.png", 0.9}, 
	[667] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[668] = {"wheels/whee_rim64.png", 0.7}, 
	[669] = {"wheels/wheel_truck64.png", 1.2}, 
	[670] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[671] = {"wheels/wheel_offroad64.png", 0.9}, 
	[672] = {"wheels/wheel_classic64.png", 0.7}, 
	[673] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[674] = {"wheels/wheel_lightvan64.png", 0.9}, 
	[675] = {"wheels/wheel_lightvan64.png", 0.9}, 
	[676] = {"wheels/wheel_classic64.png", 0.7}, 
	[677] = {"wheels/whee_rim64.png", 0.7}, 
	[678] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[679] = {"wheels/wheel_lighttruck64.png", 1}, 
	[680] = {"wheels/wheel_classic64.png", 0.7}, 
	[681] = {"wheels/wheel_alloy64.png", 0.7}, 
	[682] = {"wheels/wheel_classic64.png", 0.7}, 
	[683] = {"wheels/wheel_alloy64.png", 0.7}, 
	[684] = {"wheels/wheel_saloon64.png", 0.7}, 
	[685] = {"wheels/wheel_saloon64.png", 0.7}, 
	[686] = {"wheels/wheel_alloy64.png", 0.7}, 
	[687] = {"wheels/wheel_truck64.png", 0.9}, 
	[688] = {"wheels/wheel_classic64.png", 0.7}, 
	[689] = {"wheels/wheel_offroad64.png", 0.9}, 
	[690] = {"wheels/wheel_truck64.png", 1}, 
	[691] = {"wheels/wheel_truck64.png", 1.2}, 
	[692] = {"wheels/wheel_classic64.png", 0.7}, 
	[693] = {"wheels/wheel_classic64.png", 0.7}, 
	[694] = {"wheels/wheel_saloon64.png", 0.7}, 
	[695] = {"wheels/wheel_classic64.png", 0.7}, 
	[696] = {"wheels/wheel_alloy64.png", 0.7}, 
	[697] = {"wheels/wheel_alloy64.png", 0.7}, 
	[698] = {"wheels/wheel_classic64.png", 0.5}, 
	[699] = {"wheels/whee_rim64.png", 0.7}, 
	[700] = {"wheels/wheel_classic64.png", 0.7}, 
	[701] = {"wheels/whee_rim64.png", 0.8}, 
	[702] = {"wheels/wheel_classic64.png", 0.7}, 
	[703] = {"wheels/wheel_smallcar64.png", 0.7}, 
	[704] = false, 
	[705] = {"wheels/wheel_offroad64.png", 0.8}, 
	[706] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[707] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[708] = {"wheels/wheel_smallcar64.png", 0.7}, 
	[709] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[710] = {"wheels/wheel_classic64.png", 0.7}, 
	[711] = {"wheels/wheel_classic64.png", 0.7}, 
	[712] = false, 
	[713] = false, 
	[714] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[715] = {"wheels/wheel_saloon64.png", 0.7}, 
	[716] = {"wheels/wheel_classic64.png", 0.7}, 
	[717] = {"wheels/wheel_offroad64.png", 0.9}, 
	[718] = {"wheels/wheel_saloon64.png", 0.7}, 
	[719] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[720] = {"wheels/wheel_classic64.png", 0.7}, 
	[721] = {"wheels/wheel_classic64.png", 0.7}, 
	[722] = false, 
	[723] = {"wheels/wheel_offroad64.png", 0.9}, 
	[724] = {"wheels/wheel_truck64.png", 0.9}, 
	[725] = {"wheels/wheel_alloy64.png", 0.7}, 
	[726] = false, 
	[727] = {"wheels/wheel_saloon64.png", 0.7}, 
	[728] = {"wheels/wheel_classic64.png", 0.7}, 
	[729] = {"wheels/wheel_sport64.png", 0.7}, 
	[730] = {"wheels/wheel_saloon64.png", 0.7}, 
	[731] = {"wheels/wheel_lightvan64.png", 0.7}, 
	[732] = false, 
	[733] = {"wheels/wheel_classic64.png", 0.7}, 
	[734] = {"wheels/wheel_classic64.png", 0.7}, 
	[735] = {"wheels/wheel_classic64.png", 0.7}, 
	[736] = {"wheels/wheel_lightvan64.png", 0.9}, 
}


local createdCustomWheels = {}

function VehStreamIn()
	if(getElementType(source) == "vehicle") then
		addVehicleCustomWheel(source)
	end
end
addEvent("onClientElementStreamIn", true)
addEventHandler("onClientElementStreamIn", getRootElement(), VehStreamIn)



function VehStreamOut()
	if(getElementType(source) == "vehicle") then
		removeVehicleCustomWheel(source)
	end
end
addEvent("onClientElementStreamOut", true)
addEventHandler("onClientElementStreamOut", getRootElement(), VehStreamOut)
addEventHandler("onClientElementDestroy", getRootElement(), VehStreamOut)



function VehicleUpgrade(upgrade)
	if(upgrade >= 1073 or upgrade <= 1085) then
		addVehicleCustomWheel(source)
	end
end
addEvent("VehicleUpgrade", true)
addEventHandler("VehicleUpgrade", root, VehicleUpgrade)


local LOD = getVehiclesLODDistance()/3

local WheelsTexture = {
	["wheels/wheel_old.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_truck64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_sport64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_smallcar64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_saloon64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_offroad64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_lightvan64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_lighttruck64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_classic64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/wheel_alloy64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
	["wheels/whee_rim64.png"] = dxCreateShader("shader.fx", 0, LOD, false, "object"),
}

for name, _ in pairs(WheelsTexture) do
	dxSetShaderValue(WheelsTexture[name], "gTexture", dxCreateTexture(name))
end


local tyretread_64H = dxCreateShader("shader.fx")
local typetexture = dxCreateTexture("wheels/tyre64a.png")
dxSetShaderValue(tyretread_64H, "gTexture", typetexture)



function removeVehicleCustomWheel(theVehicle)
	if isElement(theVehicle) then 
		if(createdCustomWheels[theVehicle]) then
			for name, object in pairs(createdCustomWheels[theVehicle]) do
				setVehicleComponentVisible(theVehicle, name, true)
				destroyElement(object)
			end
			createdCustomWheels[theVehicle] = nil
		end
	end
end



local wheels = {"wheel_lf_dummy", "wheel_rf_dummy", "wheel_lb_dummy", "wheel_rb_dummy", "wheel_lm_dummy", "wheel_rm_dummy", "extra_", "extra__"}
function addVehicleCustomWheel(theVehicle)
	local model = getElementData(theVehicle, "model") or getElementModel(theVehicle)
	if(CustomModels[model]) then
		removeVehicleCustomWheel(theVehicle)
		
		if(getVehicleUpgradeOnSlot(theVehicle, 12) == 0) then
			local wheel = {}
			for _, name in pairs(wheels) do
				local x, y, z = getVehicleComponentPosition(theVehicle, name)
				if(x) then
					wheel[name] = createObject(1327, Vector3(), Vector3(), true)
					engineApplyShaderToWorldTexture(tyretread_64H, "tyretread_64H", wheel[name])
					engineApplyShaderToWorldTexture(WheelsTexture[CustomModels[model][1]], "junk_tyre", wheel[name])
				
					setElementCollisionsEnabled(wheel[name], false)
					setObjectScale(wheel[name], CustomModels[model][2]/2)
					
					setVehicleComponentVisible(theVehicle, name, false)
				end
			end
			createdCustomWheels[theVehicle] = wheel
		end
	end
end





function RenderWheels()
	for theVehicle, wheels in pairs(createdCustomWheels) do
		for name, object in pairs(wheels) do
			if(isElement(theVehicle)) then
				local rot = Vector3(getVehicleComponentRotation(theVehicle, name, 'world'))
				local mat = Matrix(Vector3(getVehicleComponentPosition(theVehicle, name, 'world')), rot):transformPosition(Vector3(1.15-getElementRadius(object), 0, 0))
				
				setElementPosition(object, mat)
				setElementRotation(object, rot, "ZYX")
				setElementDimension(object, getElementDimension(theVehicle))
				setElementInterior(object, getElementInterior(theVehicle))
			else
				removeVehicleCustomWheel(theVehicle)
			end
		end
	end
end
addEventHandler("onClientPreRender", root, RenderWheels)



function Start()
	for _, theVehicle in pairs(getElementsByType("vehicle", getRootElement(), true)) do
		triggerEvent("onClientElementStreamIn", theVehicle)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, Start)



function Stop()
	for theVehicle, _ in pairs(createdCustomWheels) do
		removeVehicleCustomWheel(theVehicle)
	end
end
addEventHandler("onClientResourceStop", resourceRoot, Stop)

