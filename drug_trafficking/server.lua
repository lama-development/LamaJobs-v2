--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

-- variables, do not touch
local deliveries = {}
local playersOnJob = {}

-- check if player is too far from the job location
function isClientTooFar(location)
    if not location then
        return true
    end
    local distance = #(GetEntityCoords(GetPlayerPed(source)) - vector3(location.x, location.y, location.z))
    -- checking from a distance of 20 because it might not be 100% correct
    if distance > 20 then return true end
    return false
end

RegisterNetEvent("DrugTrafficking:StartedCollecting", function(drugVan)
    local src = source
    playersOnJob[src] = true
    if Config.UseND then
        exports["ND_VehicleSystem"]:giveAccess(src, drugVan)
        exports["ND_VehicleSystem"]:setVehicleOwned(src, { model = drugVan }, false)
        exports["ND_VehicleSystem"]:giveKeys(drugVan, src, src) -- You need to define targetPlayer based on your logic
    end
end)

RegisterNetEvent("FoodDelivery:started", function(spawned_car)
    if Config.UseND then
        -- source refers to the player who triggered the event
        local player = source
        -- Check if the entity exists before proceeding
        if DoesEntityExist(spawned_car) then
            local netId = NetworkGetNetworkIdFromEntity(spawned_car)
            exports["ND_VehicleSystem"]:giveAccess(player, spawned_car, netId)
            exports["ND_VehicleSystem"]:setVehicleOwned(player, { model = spawned_car }, false)
            exports["ND_VehicleSystem"]:giveKeys(spawned_car, player, player) -- You need to define targetPlayer based on your logic
        else
            print("Invalid vehicle entity!")
        end
    end
end)

RegisterNetEvent("DrugTrafficking:DrugsDelivered", function(location)
    local src = source
	if playersOnJob[src] and not isClientTooFar(location) then
		-- keep track of amount of deliveries made
        if not deliveries[src] then
            deliveries[src] = 0
        end
		deliveries[src] = deliveries[src] + 1
	else
		print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has delivered from a too big distance", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
	end
end)

RegisterNetEvent("DrugTrafficking:NeedsPayment", function()
    local src = source
	if not deliveries[src] or deliveries[src] == 0 then
		print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has requested to be paid without completing the job", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
        return
    end
    -- calculate amount of money to give to the player
    local amount = Config.DrugPay * deliveries[src]
    if playersOnJob[src] and not isClientTooFar(Config.DrugStartingPosition) then
        -- give the money to player
        -- if using another framework than ND, simply change the function below to your framework's
        deliveries[src] = 0
        playersOnJob[src] = false
        NDCore.Functions.AddMoney(amount, src, "cash")
        return
    end	
    print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has requested to be paid without being at the job ending location", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
end)
