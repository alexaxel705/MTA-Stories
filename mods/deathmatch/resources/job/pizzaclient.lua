addEvent("openinf_pizza", true)
screenWidth, screenHeight = guiGetScreenSize()
function windm ()
	if not getElementData ( localPlayer, "pizza_working") then
		infowind = guiCreateStaticImage(screenWidth - 700, screenHeight - 500, 300, 359, "background.png", false)
		
		guiMemoSetReadOnly( infotext, true )
		--guiSetFont(text2, "default-bold-small") 
		showCursor(true)
		guiSetVisible ( infowind , true) 
		guiWindowSetSizable(infowind, false) 
		Button_Glose = guiCreateStaticImage(25, 300, 250, 45, "bu2.png", false, infowind)
		Button_Start = guiCreateStaticImage(25, 250, 250, 45, "bu.png", false, infowind)
		
		addEventHandler("onClientGUIClick", Button_Start, kit )
		addEventHandler("onClientGUIClick", Button_Glose, noshow )
	else
		cleanupPickups()
		triggerServerEvent ( "finitoWork_pizza", localPlayer )
		setElementData ( localPlayer, "pizza_working", false )
		outputChatBox ( "Вы закончили работу разносчика пиццы", 255, 255, 255, true )
	end
end
addEventHandler("openinf_pizza", root, windm )
function noshow ()
 if ( source == Button_Glose ) then
   destroyElement ( infowind )
   showCursor ( false ) 
 end
end
function kit ()
 if ( source == Button_Start ) then
	startWorking()
    destroyElement ( infowind )
    showCursor ( false )
  end 
end



pickupSpawns = {
	{ 2225,2520,10 },
    { 2102,2484,11 },
    { 1889,2408,11 },
    { 1934,2306,10 },
	{ 2065,2290,10 },
	{ 2279,2341,10 },
	{ 2258,2289,10 },
	{ 2497,2239,10 },
	{ 2519,2335,10 },		
}

max_pickups_set = 10 -- сколько нужно подобрать пикапов для окончания

createdPickups = {}

max_pickups = max_pickups_set
if max_pickups_set > #pickupSpawns then
	max_pickups = #pickupSpawns
end

function startWorking ()
	if not getElementData ( localPlayer, "pizza_working" ) then
		cleanupPickups()
		triggerServerEvent ( "picku_pizza", localPlayer )
		setElementData ( localPlayer, "pizza_working", true )
		setElementData ( localPlayer, "pizza_working_hit", 0 )
			outputChatBox ( "Вы начали работу.\nЕзжайте на пикап который указан на радаре!", 255, 255, 255, true )		
				
		for i, v in ipairs ( pickupSpawns ) do
			local pick = createMarker ( v[1],v[2],v[3], "checkpoint", 4.0, 0, 0, 255 )
			local pick2 = createPickup ( v[1],v[2],v[3], 3, 1582, 10000 )
			setElementData ( pick, "taken", false )
			setElementData ( pick, "pick2", pick2 )
			setElementData ( pick, "pizza_pickup", true )
			setElementData ( pick, "id", i )
			if i == 1 then
				local icon = createBlipAttachedTo ( pick, 41, 2 )
				setElementData ( pick, "icon", icon )
			end
			table.insert (createdPickups, pick)
		end
	end
end	

-- уничтожаем все созданные маркеры/пикапы/блипы, чтобы ничего не висело на радаре
function cleanupPickups()
	for i, v in ipairs ( createdPickups ) do
		if isElement ( v ) then
			local pick2 = getElementData ( v, "pick2")
			if isElement ( pick2 ) then
				destroyElement ( pick2 )
			end
			local icon = getElementData ( v, "icon" )
			if isElement ( icon ) then
				destroyElement ( icon )
			end
			destroyElement ( v )
		end
	end
	createdPickups = {}
end

-- страховка: при остановке ресурса чистим всё, что могли создать
addEventHandler("onClientResourceStop", resourceRoot,
	function()
		cleanupPickups()
	end
)

-- страховка: смерть во время работы тоже завершает смену и чистит радар
addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		if getElementData ( localPlayer, "pizza_working" ) then
			cleanupPickups()
			triggerServerEvent ( "finitoWork_pizza", localPlayer )
			setElementData ( localPlayer, "pizza_working", false )
			setElementData ( localPlayer, "pizza_working_hit", 0 )
			outputChatBox ( "Вы закончили работу", 255, 255, 255, true )
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() then
			if getElementData ( localPlayer, "pizza_working" ) then
				cleanupPickups()
				triggerServerEvent ( "finitoWork_pizza", localPlayer )
				setElementData ( localPlayer, "pizza_working", false )
				outputChatBox ( "Вы закончили работу", 255, 255, 255, true )
			end
        end
    end
)

function clientPickupHit(thePlayer, matchingDimension)
	if thePlayer == localPlayer and getElementData ( source, "pizza_pickup" ) and not getElementData ( source, "taken" ) then
		setElementData ( source, "taken", true )
					setElementVelocity ( getPedOccupiedVehicle(localPlayer), 0, 0, 0 )
					toggleAllControls ( false, true, false )
					setTimer ( finishBoarding, 5000, 1 )
					outputChatBox("Идёт доставка", 0,153,51)
					setElementData ( localPlayer, "pizza_pickup", 2 )
		local hitted = getElementData ( localPlayer, "pizza_working_hit" ) or 0
		hitted = hitted+1
		local pick2 = getElementData ( source, "pick2" )
		if isElement ( pick2 ) then
			destroyElement ( pick2 )
		end
		local icon = getElementData ( source, "icon" )
		if isElement ( icon ) then
			destroyElement ( icon )
		end
		destroyElement(source)
		setElementData ( localPlayer, "pizza_working_hit", hitted)
		if hitted >= max_pickups then
			cleanupPickups()
			setElementData ( localPlayer, "pizza_working", false )
			triggerServerEvent ( "finitoWork_pizza", localPlayer )
			outputChatBox ( "Вы закончили работу,подождите", 255, 255, 255, true )
			return true
		end
		if createdPickups[hitted+1] then
			local icon = createBlipAttachedTo ( createdPickups[hitted+1], 41, 2 )
			setElementData ( createdPickups[hitted+1], "icon", icon )
		end
	end
end

function finishBoarding ()
	toggleAllControls(true, true, true)
	outputChatBox("вы развезвезли пиццу,ваше вознаграждение - 500$ ", 255, 100, 100, true)
	triggerServerEvent("AddPlayerMoney", localPlayer, localPlayer, 500)
end
addEventHandler ( "onClientMarkerHit", getRootElement(), clientPickupHit )







