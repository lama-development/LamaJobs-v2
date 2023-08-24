--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

if Config.UseND then
	NDCore = exports["ND_Core"]:GetCoreObject()
end

RegisterNetEvent("TrashCollector:started", function(garbageTruck)
	if Config.UseND then
		exports["ND_VehicleSystem"]:giveAccess(source, garbageTruck)
	end
end)

RegisterServerEvent('TrashCollector:GiveReward')
AddEventHandler('TrashCollector:GiveReward', function(pay)
	local player = source 
	NDCore.Functions.AddMoney(pay, player, "bank")
end)