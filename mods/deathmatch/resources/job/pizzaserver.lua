jobpizza = createMarker ( 2103.845,-1809.484,12.554, "cylinder", 1.5, 255, 0, 0, 170 )
myBlip = createBlipAttachedTo ( jobpizza, 29 )

give_skin = 155 -- скин, который выдается работнику
function enter (element)
	if getElementType ( element ) == "player" then
			triggerClientEvent ( element, "openinf_pizza", element)
	end
end
addEventHandler( "onMarkerHit", jobpizza, enter )
addEvent ( "picku_pizza", true )

function create ()
   local jobvehicle = createVehicle ( 448, 2371, 2530, 10, 0, 0, 90 )
	setElementData ( source, "working_veh", jobvehicle )
	setElementModel ( source, give_skin)
end
addEventHandler ( "picku_pizza", root, create )

addEvent ( "finitoWork_pizza", true )

function finitoWorkS ()
	local veh = getElementData ( source, "working_veh" )
	if isElement ( veh ) then
		destroyElement ( veh )
		setElementData ( source, "working_veh", false )
	end
end
addEventHandler ( "finitoWork_pizza", root, finitoWorkS )

-- чистим рабочий байк при выходе игрока с сервера, иначе он остаётся в мире
addEventHandler ( "onPlayerQuit", root,
	function ()
		local veh = getElementData ( source, "working_veh" )
		if isElement ( veh ) then
			destroyElement ( veh )
		end
		setElementData ( source, "working_veh", false )
	end
)

addEvent ( "giveMoneyFromClient_pizza", true )

function giveMoneyFromClientS (amount)
    givePlayerMoney ( source, amount )
end
addEventHandler ( "giveMoneyFromClient_pizza", root, giveMoneyFromClientS )











