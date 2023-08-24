--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

if Config.UseND then
    NDCore = exports["ND_Core"]:GetCoreObject()
end

RegisterNetEvent("FoodDelivery:started", function(spawned_car)
	if Config.UseND then
		exports["ND_VehicleSystem"]:giveAccess(source, spawned_car)
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