
--[Работа таксистом]Название, минимальный вес, максимальный вес}
-- Маркер и интерфейс 
GUIEditor = {
    memo = {},
    button = {},
    window = {},
}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        GUIEditor.window[1] = guiCreateWindow(0.29, 0.24, 0.42, 0.49, "", true)
        guiWindowSetSizable(GUIEditor.window[1], false)
		guiSetVisible(GUIEditor.window[1], false)

        bAccept = guiCreateMemo(0.08, 0.20, 0.41, 0.67, "", true, GUIEditor.window[1])
		
        bAccept = guiCreateButton(0.60, 0.20, 0.34, 0.17, "Accept Job", true, GUIEditor.window[1])
        guiSetFont(GUIEditor.button[1], "sa-header")
        guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
		addEventHandler("onClientGUIClick", bAccept, showGUIbf, false)
		addEventHandler("onClientGUIClick", bAccept, joinTeam, false)
		
        bClose = guiCreateButton(0.67, 0.61, 0.20, 0.16, "CLOSE", true, GUIEditor.window[1])
        guiSetProperty(bClose, "NormalTextColour", "FFAAAAAA") 
		addEventHandler("onClientGUIClick", bClose, showGUIbf, false)
		
		GUIEditor.memo[1] = guiCreateMemo(0.08, 0.20, 0.41, 0.67, "Become a Taxi Driver and get excellent wages at $500 per ride! To start simply enter a Taxi, drive to the Blue Person Icon and Pick them up. Then drop them off at the Waypoint. Easy! Perks : Repairing your Taxi at a Pay'n Spray is free!", true, GUIEditor.window[1])
		
    end
)

local joinBD = createMarker(1777.05078125, -1887.853515625, 12.387156486511, "cylinder", 0.9, 255, 0, 0)


addEventHandler( "onClientResourceStart", getRootElement( ),
    function ( startedRes )
        -- значок точки найма виден только при подъезде (200 м)
        createBlipAttachedTo( joinBD, 60, 2, 255, 0, 0, 255, 0, 200);
    end
);

function showGUIbt(hitElement)
 if getElementType(hitElement) == "player" and (hitElement == localPlayer) then
 guiSetVisible(GUIEditor.window[1], true)
 showCursor( true )
 end
 end
 addEventHandler("onClientMarkerHit", joinBD, showGUIbt) 

function showGUIbf()
	guiSetVisible (GUIEditor.window[1], false )
    showCursor ( false )
end


function joinTeam()
    triggerServerEvent("sTeame", localPlayer, "teamSet")
end

-- Сама работа 



local pickups = {
[1]={ 2060.7685546875, -1941.1181640625, 13.14103603363 },
[2]={ 2114.5068359375, -1611.302734375, 13.167269706726 },
[3]={ 1932.9521484375, -1776.1259765625, 13.16081237793 },
[4]={ 1057.41796875, -1568.4853515625, 13.166387557983 },
[5]={ 1133.2607421875, -1286.6201171875, 13.245727539063 },
[6]={ 1197.380859375, -1576.9228515625, 13.2406873703 },
[7]={ 1275.6181640625, -1717.5087890625, 13.241578102112 },
[8]={ 1041.908203125, -1869.1728515625, 13.15417766571 },
[9]={ 680.9248046875, -1763.6552734375, 13.168544769287 },
[10]={ 597.5556640625, -1598.90234375, 16.215705871582 },
[11]={ 357.197265625, -1443.72265625, 34.185447692871 }
}

local dropoffss = {
[1]={ 1965.54296875 , -1883.013671875, 13.160305023193 },
[2]={ 1467.3916015625, -1736.419921875, 13.242918014526 },
[3]={ 2376.1064453125, -1728.4091796875, 13.162055015564 },
[4]={ 1066.5029296875, -1200.86328125, 18.405519485474 },
[5]={ 584.8916015625, -1328.7021484375, 13.25985622406 },
[6]={ 989.75, -1372.083984375, 13.244333267212 },
[7]={ 1116.333984375, -1410.7666015625, 13.267498970032 },
[8]={ 1437.5244140625, -1039.8212890625, 23.564819335938 },
[9]={ 2124.4521484375, -1116.4931640625, 25.031726837158 },
[10]={ 2700.8857421875, -1091.896484375, 69.064071655273 },
[11]={ 2769.2744140625, -1494.0517578125, 27.58003616333 }
}

 

local pedCus = {
[1]={ 9 },
[2]={ 10 },
[3]={ 14 },
[4]={ 15 },
[5]={ 37 }
}

 

 
function teamSet()
    setElementModel(source, 57)
	createVehicle(420, 1777.3017578125, -1891.779296875, 13.157614707947)
	triggerClientEvent(source, "helpmessageEvent", source, "Теперь вы работаете водителем такси!")

end
addEvent("sTeame", true)
addEventHandler("sTeame", root, teamSet)


 

local markers = { }
local blips = { }
local peds = { }
local mposi = { }
local mposii = {}


 

function startJob(thePlayer)
    destroyJob(thePlayer) -- чистим возможные старые маркер/блип, чтобы не висели на радаре
    local x, y, z = unpack(pickups[math.random(#pickups)])
    markers [thePlayer] = createMarker(x, y, z, "cylinder", 5.0, 255, 0, 0, 0)
	mposi = {getElementPosition(markers[thePlayer])}
    local skins = unpack(pedCus[math.random(#pedCus)])
    peds[thePlayer] = createPed(skins, x, y, z)  
    blips[thePlayer] = createBlipAttachedTo(markers[thePlayer], 58, 2, 255, 0, 0, 255, 0, 16383.0, thePlayer)
	
	triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, x, y, z, "Пассажир")
	
    addEventHandler("onMarkerHit", markers[thePlayer], warpit)
end
 
 
 
function inVEH(thePlayer)
    if (getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer)) then
        if(getElementModel(source) == 420) then
            -- не стартуем повторную смену, если работа уже активна
            if(isElement(markers[thePlayer])) then return end
            startJob(thePlayer)
        end
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), inVEH )
 
function warpit ( thePlayer )
    if (getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer)) then
	   local vehiclee = getPedOccupiedVehicle ( thePlayer )
		if ( getElementModel ( vehiclee ) == 420 ) then
            setTimer ( warpPedIntoVehicle, 2000, 1, peds [ thePlayer ], vehiclee, 2 )
            destroyJob ( thePlayer )
            local x, y, z = unpack ( dropoffss [ math.random ( #dropoffss ) ] )
            markers [ thePlayer ] = createMarker ( x, y, z - 1, "cylinder", 5.0, 255, 0, 0, 50 )
			mposii = { getElementPosition( markers [ thePlayer ] ) }
            blips[thePlayer] = createBlipAttachedTo(markers[thePlayer], 41, 2, 255, 0, 0, 255, 0, 16383.0, thePlayer)
			triggerClientEvent(thePlayer, "AddGPSMarker", thePlayer, x, y, z, "Точка доставки")

            addEventHandler("onMarkerHit", markers[thePlayer ], pickmeup)
		end
	end
end

 
function pickmeup ( thePlayer )
    if ( getElementType ( thePlayer ) == "player" and isPedInVehicle ( thePlayer ) ) then
        destroyJob ( thePlayer )
		local mx, my, mz = unpack ( mposi )
		local mmx, mmy, mmz = unpack ( mposii )
		local money = getDistanceBetweenPoints2D ( mx, my, mmx, mmy )
		finalmoney = math.floor ( money )
		if finalmoney then
        setTimer(
            function ()
                if (isElement(peds[thePlayer ])) then
                    destroyElement(peds[thePlayer])
                end
				exports["228"]:AddPlayerMoney(thePlayer, finalmoney)
				triggerClientEvent(thePlayer, "helpmessageEvent", thePlayer, "You have earned ".. money .."!")
                startJob(thePlayer)
            end
            ,3000, 1
        )
			end
		end
    end

function deleteOnExit(thePlayer)
    if(isElement(markers[thePlayer])) then
        destroyElement(markers[thePlayer])
    end
    if(isElement(blips[thePlayer])) then
        destroyElement(blips[thePlayer])
    end
    if(isElement(peds[thePlayer])) then
        destroyElement(peds[thePlayer])
    end
end
addEventHandler("onVehicleExit", getRootElement(), deleteOnExit)

-- чистим работу при выходе игрока с сервера, иначе маркер/блип/пед остаются навсегда
function cleanupOnQuit()
    if(isElement(markers[source])) then destroyElement(markers[source]) end
    if(isElement(blips[source])) then destroyElement(blips[source]) end
    if(isElement(peds[source])) then destroyElement(peds[source]) end
    markers[source] = nil
    blips[source] = nil
    peds[source] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), cleanupOnQuit)

 
function destroyJob ( thePlayer )
    if ( isElement ( markers [ thePlayer ] ) ) then
        destroyElement ( markers [ thePlayer ] )
    end
    if ( isElement ( blips [ thePlayer ] ) ) then
        destroyElement ( blips [ thePlayer ] )
    end
    markers [ thePlayer ] = nil
    blips [ thePlayer ] = nil
    peds [ thePlayer ] = nil
end

function consoleSetPlayerPosition ( source, commandName, posX, posY, posZ )
	setElementPosition ( source, posX, posY, posZ )
end
addCommandHandler ( "setpos", consoleSetPlayerPosition  )

