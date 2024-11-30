--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

RegisterNetEvent("PortCargo:started", function(forklift)
	if Config.UseND then
		-- source refers to the player who triggered the event
		local player = source 
        -- Check if the entity exists before proceeding
        if DoesEntityExist(forklift) then
            local netId = NetworkGetNetworkIdFromEntity(forklift)
            exports["ND_VehicleSystem"]:giveAccess(player, forklift, netId)
            exports["ND_VehicleSystem"]:setVehicleOwned(player, { model = forklift }, false)
            exports["ND_VehicleSystem"]:giveKeys(forklift, player, player) 
        else
            print("Invalid forklift entity!")
        end
	end
end)

RegisterServerEvent('PortCargo:GiveReward')
AddEventHandler('PortCargo:GiveReward', function(pay)
    local player = source
    NDCore.Functions.AddMoney(pay, player, "bank")
end)