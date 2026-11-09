local SkinData = {}
local help = {}
local GlobalChat = true -- Для глобального\локального чата
local MainChat = {}
local Zones = {
	[1] = createColRectangle(1441, -1721, 77, 117),
	[2] = createColRectangle(-2364, 72, 79, 155),
	[3] = createColRectangle(2298, 2244, 119, 159),
	[4] = createColRectangle(-2594, -60, 42, 89.5),
	[5] = createColRectangle(-2740, 345, 67.5, 61),
	[6] = createColRectangle(1957.4, 743.3, 20, 20),
	[7] = createColRectangle(1957.4, 643.2, 20, 20),
}
for _,el in pairs(Zones) do
	setElementData(el, "chat", true, false)
end

-- Функция подгрузит данные, если 228 уже запущен, либо дождется его старта
addEventHandler("onResourceStart", root, function(startedRes)
    local resName = getResourceName(startedRes)
    if (startedRes == resource and getResourceFromName("228") and getResourceState(getResourceFromName("228")) == "running") or (resName == "228") then
        SkinData = exports["228"]:GetSkinData()
    end
end)


local Phones = {}
local PhonesAbonent = {}
local PhonesWaiting = {}

function CallPhones(thePlayer, h)
    if(not Phones[thePlayer]) then
		if(h) then
			if(tostring(getElementData(thePlayer, "id")) ~= tostring(h)) then
				for key,thePlayers in pairs(getElementsByType "player") do
					if(tostring(getElementData(thePlayers, "id")) == tostring(h)) then
						if(not PhonesWaiting[thePlayers]) then
							CallIn(thePlayer)
							PhonesAbonent[thePlayer] = thePlayers
							PhonesWaiting[thePlayers] = thePlayer
							OutputChat(thePlayer, "Напиши /call чтобы бросить трубку", "Phone")
							OutputChat(thePlayers, "Напиши /call чтобы взять трубку", "Phone")
							triggerClientEvent(thePlayer, "PlaySFXSoundEvent", thePlayer, 12)
							triggerClientEvent(thePlayers, "PlaySFXSoundEvent", thePlayers, 13)
							return true
						else
							OutputChat(thePlayer, "* Абонент занят", "Phone")
							return true
						end
					end
				end
				OutputChat(thePlayer, "* "..h.." Номер не найден", "Phone")
			else
				OutputChat(thePlayer, "* Абонент занят", "Phone")
			end
		else
			if(PhonesWaiting[thePlayer]) then
				CallIn(thePlayer)
				OutputChat(PhonesWaiting[thePlayer], "* Абонент взял трубку", "Phone")
				PhonesAbonent[thePlayer] = PhonesWaiting[thePlayer]
			else
				OutputChat(thePlayer, "Используй /call id игрока чтобы позвонить", "Phone")
				OutputChat(thePlayer, "Напиши /call чтобы бросить трубку", "Phone")
			end
		end
	else
		if(Phones[PhonesAbonent[thePlayer]]) then
			CallOut(PhonesAbonent[thePlayer])
			OutputChat(PhonesAbonent[thePlayer], "* Абонент положил трубку", "Phone")
		end
		if(PhonesWaiting[PhonesAbonent[thePlayer]]) then
			PhonesWaiting[PhonesAbonent[thePlayer]] = nil
		end
		CallOut(thePlayer)
	end
end
addEvent("call", true)
addEventHandler("call", root, CallPhones)



function CallIn(thePlayer)
	triggerEvent("AddPlayerArmas", thePlayer, thePlayer, 330)
	setPedAnimation(thePlayer, "ped", "phone_in", 1, false, true, true, true)
	Phones[thePlayer] = true
end


function CallOut(thePlayer)
	triggerEvent("RemovePlayerArmas", thePlayer, thePlayer, 330)
	setPedAnimation(thePlayer, "ped", "phone_out", 1, false, true, true, true)
	Phones[thePlayer] = false
	PhonesAbonent[thePlayer] = false
	if(PhonesWaiting[thePlayer]) then
		PhonesWaiting[thePlayer] = nil
	end
end



function CallPhoneOutput(thePlayer, arg)
	CallPhones(thePlayer, arg)
end
addEvent("CallPhoneOutput", true)
addEventHandler("CallPhoneOutput", root, CallPhoneOutput)





function CallPolice(Player)
	if(not Phones[source] and getElementHealth(source) > 20) then
		CallIn(source)
		setTimer(PhoneTalk, 1600, 1, source)
		setTimer(PhoneTalkEnd, 10000, 1, source, Player)
	end
end
addEvent("CallPolice", true)
addEventHandler("CallPolice", root, CallPolice)

function PhoneTalk(thePlayer)
	--StartAnimation(thePlayer, "ped", "phone_talk", 1)
	local x,y,z = getElementPosition(thePlayer)
	triggerEvent("onPlayerChat", thePlayer, "Алло, полиция? Преступник в "..getZoneName(x, y, z), 1)
end


PoliceCallBandints = {}

function PhoneTalkEnd(thePlayer, bandit)
	CallOut(thePlayer)
	if(not isPedDead(thePlayer)) then
		local x,y,z = GetPlayerLocation(getPlayerFromName(bandit))
		if(PoliceCallBandints[bandit] ~= getZoneName(x,y,z)) then
			PoliceCallBandints[bandit] = getZoneName(x,y,z)
			local banditPlayer = getPlayerFromName(bandit)
			local x,y,z = GetPlayerLocation(banditPlayer)
			--StartAnimation(thePlayer, "ped", "phone_out", false,false,false,false)
			Respect(thePlayer, "civilian", 1)
			Respect(thePlayer, "police", 1)
			Respect(thePlayer, "ugol", -1)
			MissionCompleted(thePlayer, "УВАЖЕНИЕ +", "ЗАКОНОПОСЛУШНОСТЬ")
			PoliceCallRemove(x,y,z,"Обнаружен преступник")
		else
			outputChatBox("Полиции уже известно о положении преступника.", thePlayer)
			setPedAnimation(thePlayer, "ped", "phone_out", false,false,false,false)
		end
	end
end



function ResultGet()

end

function CallBackGovorilka(thePlayers, voice, gg)
	if(thePlayers) then
		thePlayers = fromJSON(thePlayers)
		if(type(thePlayers) ~= "table") then return end
		for _, thePlayer in pairs(thePlayers) do
			triggerClientEvent(getPlayerFromName(thePlayer), "PlaySound", getPlayerFromName(thePlayer), "http://"..getElementData(root, "IP").."/engine/include/MTA/"..gg.."/"..md5(utf8.upper(voice))..".wav")
		end
	end
end

function onPlayerChat(message, messageType, messagenovision)
	if(type(message) ~= "string") then
		cancelEvent()
		return false
	end
	if(getElementData(source, "auth")) then
		if(string.len(message:gsub("%s+", "")) == 0) then
			cancelEvent()
			return false
		end
		if messageType == 0 then
			if(Phones[source]) then
				local CallTo = PhonesAbonent[source]
				OutputChat(source, "["..getElementData(source, "id").."] "..getPlayerName(source)..": "..message, "Phone")
				
				for key,thePlayers in pairs(getElementsByType "player") do
					triggerClientEvent(thePlayers, "PlayerActionEvent", thePlayers, message, source)
				end
				
				if(getPedOccupiedVehicle(source)) then
					setPedAnimation(source, "ped", "phone_talk", false,false,false,false)
				else
					setPedAnimation(source, "ped", "phone_talk", 1, false, true, true, true)
				end
	
				if(Phones[CallTo]) then
					OutputChat(CallTo, "["..getElementData(source, "id").."] "..getPlayerName(source)..": "..message, "Phone")
				end
				
				local voice = "gg"
				local skin = SkinData[getElementModel(source)]
				if(skin and skin[3] == "Женщина") then
					voice = "dg"
				end
				CheckVoice({getPlayerName(source), getPlayerName(CallTo)}, message, voice, true)
				triggerClientEvent(source, "PlaySound", source, "http://"..getElementData(root, "IP").."/engine/include/MTA/"..voice.."/"..md5(utf8.upper(message))..".wav")
				triggerClientEvent(CallTo, "PlaySound", CallTo, "http://"..getElementData(root, "IP").."/engine/include/MTA/"..voice.."/"..md5(utf8.upper(message))..".wav")

				cancelEvent()
				return true
			else
				-- Облачко над головой видно в радиусе 50 м, текст уходит в общий чат
				local x, y, z = getElementPosition(source)
				for id, player in ipairs(getElementsByType("player")) do
					local x2, y2, z2 = getElementPosition(player)
					if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 50 then
						triggerClientEvent(player, "PlayerActionEvent", player, message, source)
					end
				end

				if(not messagenovision) then -- Для действий
					local color = getElementData(source, "color")
					callRemote("http://"..getElementData(root, "IP").."/engine/include/MTA/index.php", ResultGet, getPlayerName(source):gsub('#%x%x%x%x%x%x', ''), message, color)
					OutputMainChat(message, source)
				end
				cancelEvent()
				return true
			end
		elseif(messageType == 1) then
			for key,thePlayers in pairs(getElementsByType "player") do
				triggerClientEvent(thePlayers, "PlayerActionEvent", thePlayers, message, source)
			end
			cancelEvent()
		elseif(messageType == 2) then
			cancelEvent()
		end
	else
		outputChatBox("Авторизируйся чтобы написать сообщение", source,255,255,255,true)
		cancelEvent()
	end
end
addEvent("onPlayerChat", true)
addEvent("CliendSideonPlayerChat", true)
addEventHandler("onPlayerChat", root, onPlayerChat)
addEventHandler("CliendSideonPlayerChat", root, onPlayerChat)






function sms2(thePlayer, to, message)
	if(to and message) then
		for _, thePlayers in pairs(getElementsByType "player") do
			if(tostring(getElementData(thePlayers, "id")) == tostring(to)) then
				OutputChat(thePlayers, "от ["..getElementData(thePlayer, "id").."] "..getPlayerName(thePlayer)..": "..message, "SMS")
				OutputChat(thePlayer, "для ["..getElementData(thePlayers, "id").."] "..getPlayerName(thePlayers)..": "..message.."", "SMS")
			end
		end
	else
		OutputChat(thePlayer, "Используй /sms id игрока текст", "Phone")
	end
end
addEvent("sms", true)
addEventHandler("sms", root, sms2)




function Chat_Enter(thePlayer, matchingDimension)
	if getElementType(thePlayer) == "player" then
		if(getElementData(source, "chat")) then
			MainChat[thePlayer] = true
			OutputChat(thePlayer, "ты зашел в зону общего чата", "Server")
			
			SendWebPlayer()
			callRemote("http://"..getElementData(root, "IP").."/engine/include/MTA/get_online.php", ResultGet)
		end
	end
end
addEventHandler("onColShapeHit", root, Chat_Enter)

function Chat_Exit(thePlayer, matchingDimension)
	if getElementType(thePlayer) == "player" then
		if(getElementData(source, "chat")) then
			MainChat[thePlayer] = false
			OutputChat(thePlayer, "ты покинул зону общего чата", "Server")
			SendWebPlayer()
			callRemote("http://"..getElementData(root, "IP").."/engine/include/MTA/get_online.php", ResultGet)
		end
	end
end
addEventHandler("onColShapeLeave", root, Chat_Exit)



function BurnChatMSG(name, message, nickcolor)
	OutputMainChat(message, name)
end
addEvent("BurnChatMSG", true)
addEventHandler("BurnChatMSG", root, BurnChatMSG)




function SendWebPlayer()
	if(getServerPort() == 22003) then
		local webplay = ''
		for _, thePlayer in ipairs(getElementsByType("player")) do
			if(getElementData(thePlayer, "auth")) then
				if(MainChat[thePlayer]) then
					local color = getElementData(thePlayer, "color") or "#EEEEEE"
					webplay = webplay.."<span style=\"color:"..color..";\">"..getPlayerName(thePlayer)..'</span><br />'
				end
			end
		end
		callRemote("http://"..getElementData(root, "IP").."/engine/include/MTA/online.php", ResultGet, webplay)
	end
end


function Start()
	for _, thePlayer in ipairs(getElementsByType("player")) do
		if(getElementData(thePlayer, "auth")) then
			for _,el in pairs(Zones) do
				if(isElementWithinColShape(thePlayer, el)) then
					MainChat[thePlayer] = true
				end
			end
		end
	end
	SendWebPlayer()
end
addEventHandler("onResourceStart", getResourceRootElement(), Start)


local Avatars = {}

function DownloadPhotoCompleted(responseData, errno, dat)
	if errno == 0 then
		triggerClientEvent(dat[1], "onClientGotImage", dat[1], dat[2], responseData)
		Avatars[dat[2]] = responseData
	end
end


function DownloadPhoto(responseData, errno, dat)
	if errno == 0 then
		fetchRemote("http://"..getElementData(root, "IP").."/database/users/"..dat[2].."/photo/"..responseData, DownloadPhotoCompleted, "", false, dat)
	else
		fetchRemote("http://"..getElementData(root, "IP").."/engine/images/no_photo.jpg", DownloadPhotoCompleted, "", false, dat)
	end
end


function CheckAvatar(thePlayer, theAvatar)
	if(not Avatars[theAvatar]) then
		fetchRemote("http://"..getElementData(root, "IP").."/database/users/"..theAvatar.."/photo.txt", DownloadPhoto, "", false, {thePlayer, theAvatar})
	else
		triggerClientEvent(thePlayer, "onClientGotImage", thePlayer, theAvatar, Avatars[theAvatar])
	end
end
addEvent("CheckAvatar", true)
addEventHandler("CheckAvatar", resourceRoot, CheckAvatar)


function OutputChat(thePlayer, message, from)
	triggerClientEvent(thePlayer, "OutputChat", thePlayer, message, from)
end
addEvent("OutputChat", true)
addEventHandler("OutputChat", root, OutputChat)




function OutputMainChat(message, from, forced)
	for _, thePlayer in pairs(getElementsByType "player") do
		if(MainChat[thePlayer] or forced or GlobalChat) then
			triggerClientEvent(thePlayer, "OutputChat", thePlayer, message, from)
		end
	end
end
addEvent("OutputMainChat", true)
addEventHandler("OutputMainChat", root, OutputMainChat)



function checkChange(theKey, oldValue, newValue)
	if(getElementType(source) == "player") then
		if(theKey == "auth") then
			Avatars[getPlayerName(source)] = nil
			SendWebPlayer()
		end
	end
end
addEventHandler("onElementDataChange", root, checkChange)


function CheckVoice(thePlayers, voice, voicebank, writestatistic)
	if(string.sub(voice, 0, 1) ~= "[") then
		callRemote("http://"..getElementData(root, "IP").."/engine/include/MTA/govorilka.php", CallBackGovorilka, toJSON(thePlayers), utf8.upper(voice), voicebank, writestatistic)
	end
end
addEvent("CheckVoice", true)
addEventHandler("CheckVoice", root, CheckVoice)


