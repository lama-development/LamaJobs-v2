--[[
Created by Lama Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

RegisterNetEvent("FoodDelivery:started", function(spawned_car)
    if Config.UseND then
        -- source refers to the player who triggered the event
        local player = source 
        -- Check if the entity exists before proceeding
        if DoesEntityExist(spawned_car) then
            local netId = NetworkGetNetworkIdFromEntity(spawned_car)
            exports["ND_VehicleSystem"]:giveAccess(player, spawned_car, netId)
            exports["ND_VehicleSystem"]:setVehicleOwned(player, { model = spawned_car }, false)
            exports["ND_VehicleSystem"]:giveKeys(spawned_car, player, player)
        else
            print("Invalid vehicle entity!")
        end
    end
end)

RegisterServerEvent('FoodDelivery:success')
AddEventHandler('FoodDelivery:success', function(pay)
    local player = source
    NDCore.Functions.AddMoney(pay, player, "cash")
end)

RegisterServerEvent("FoodDelivery:penalty")
AddEventHandler("FoodDelivery:penalty", function(money)
    local player = source
    NDCore.Functions.DeductMoney(money, player, "cash")
end)
