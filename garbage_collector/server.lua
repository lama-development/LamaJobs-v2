--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

RegisterNetEvent("TrashCollector:started", function(garbageTruck)
    if Config.UseND then
        -- source refers to the player who triggered the event
        local player = source 
        -- Check if the entity exists before proceeding
        if DoesEntityExist(garbageTruck) then
            netId = NetworkGetNetworkIdFromEntity(garbageTruck)
            exports["ND_VehicleSystem"]:giveAccess(player, garbageTruck, netId)
            exports["ND_VehicleSystem"]:setVehicleOwned(player, { model = garbageTruck }, false)
            exports["ND_VehicleSystem"]:giveKeys(garbageTruck, player, player)
        else
            print("Invalid garbage truck entity!")
        end
    end
end)

RegisterServerEvent('TrashCollector:GiveReward')
AddEventHandler('TrashCollector:GiveReward', function(pay)
	local player = source 
	NDCore.Functions.AddMoney(pay, player, "bank")
end)