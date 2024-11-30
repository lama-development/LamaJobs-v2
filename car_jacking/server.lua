--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

-- variables, do not touch
local deliveries = {}
local playersOnJob = {}

RegisterNetEvent("vehicleboost:started", function()
    local src = source
    playersOnJob[src] = true
end)

RegisterNetEvent("vehicleboost:giveVehicleAccess", function(starterVehicle)
    if Config.UseND then
		-- source refers to the player who triggered the event
		local player = source 
        -- Check if the entity exists before proceeding
        if DoesEntityExist(starterVehicle) then
            local netId = NetworkGetNetworkIdFromEntity(starterVehicle)
            exports["ND_VehicleSystem"]:giveAccess(player, starterVehicle, netId)
            exports["ND_VehicleSystem"]:setVehicleOwned(player, { model = starterVehicle }, false)
            exports["ND_VehicleSystem"]:giveKeys(starterVehicle, player, player) 
        else
            print("Invalid starter vehicle entity!")
        end
    end
end)


RegisterNetEvent("vehicleboost:delivered", function(location)
    local src = source
	if playersOnJob[src] then
		-- keep track of amount of deliveries made
        if not deliveries[src] then
            deliveries[src] = 0
        end
		deliveries[src] = deliveries[src] + 1
	end
end)

RegisterNetEvent("vehicleboost:finished", function()
    local src = source
	if not deliveries[src] or deliveries[src] == 0 then
		print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has requested to be paid without delivering anything", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
	else
		-- calculate amount of money to give to the player
		local amount = Config.PayPerDelivery * deliveries[src]
		if playersOnJob[src] then
			-- give the money to player
            deliveries[src] = 0
            playersOnJob[src] = false
			-- if using another framework than ND, simply change the function below to your framework's
			NDCore.Functions.AddMoney(amount, src, "cash")
		end	
	end
end)