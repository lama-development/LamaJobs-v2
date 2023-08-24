--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

-- ND_Framework exports
if Config.UseND then
	NDCore = exports["ND_Core"]:GetCoreObject()
end

-- variables, do not touch
local deliveries = {}
local playersOnJob = {}

RegisterNetEvent("vehicleboost:started", function()
    local src = source
    playersOnJob[src] = true
end)

RegisterNetEvent("vehicleboost:giveVehicleAccess", function(starterVehicle)
	if Config.UseND then
		exports["ND_VehicleSystem"]:giveAccess(source, starterVehicle)
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