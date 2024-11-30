--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

-- variables, do not touch
local deliveries = {}
local playersOnJob = {}

-- function to check if the client is actually at the job ending location before giving them the money
function isClientTooFar(location)
	local distance = #(GetEntityCoords(GetPlayerPed(source)) - vector3(location.x, location.y, location.z))
	-- checking from a distance of 15 because it might not be 100% correct
	if distance > 25 then return true
	else return false
	end
end

-- start the job and give the client access to the truck
RegisterNetEvent("TruckDriver:started", function(truck)
    -- source refers to the player who triggered the event
    local src = source
    playersOnJob[src] = true
    if Config.UseND then
        -- Check if the entity exists before proceeding
        if DoesEntityExist(truck) then
            local netId = NetworkGetNetworkIdFromEntity(truck)
            NDCore.giveVehicleAccess(src, truck, true)
        else
            print("Invalid truck entity")
        end
    end
end)



RegisterNetEvent("TruckDriver:delivered", function(location)
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

RegisterNetEvent("TruckDriver:finished", function()
    local src = source
	if not deliveries[src] or deliveries[src] == 0 then
		print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has requested to be paid without completing the job", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
	else
		-- calculate amount of money to give to the player
		local amount = Config.PayPerDelivery * deliveries[src]
			-- only give the money to the client if it is on the job and near the ending location
		if playersOnJob[src] and not isClientTooFar(Config.DepotLocation) then
			-- give the money to player
            deliveries[src] = 0
            playersOnJob[src] = false
            -- if using another framework than ND, simply change the function below to your framework's
            if Config.UseND then
                local player = NDCore.getPlayer(src)
                player.addMoney("bank", amount, "Truck job salary")
            end
		else
			print(string.format("^1Possible exploiter detected\nName: ^0%s\n^1Identifier: ^0%s\n^1Reason: ^0has requested to be paid without being at the job ending location", GetPlayerName(source), GetPlayerIdentifier(source, 0)))
		end	
	end
end)

RegisterNetEvent("TruckDriver:forcequit", function()
    local src = source
    local penalty = Config.Penalty
    if Config.UseND then
        local player = NDCore.getPlayer(src)
        player.deductMoney("bank", penalty, "Truck job penalty")
    end
end)