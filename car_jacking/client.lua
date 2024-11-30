--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

if Config.EnabledJobs['car_jacking'] then
    -- variables, don't touch
    local amount = 0
    local playerCoords = nil
    local jobStarted = false
    local truck, trailer = nil, nil
    local opti

    -- draw blip on the map
    CreateThread(function()
        local blip = AddBlipForCoord(Config.StartBlipLocation.x, Config.StartBlipLocation.y, Config.StartBlipLocation.z)
        SetBlipSprite(blip, 457)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 26)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Boosting")
        EndTextCommandSetBlipName(blip)
    end)

    CreateThread(function()
        while true do
            playerCoords = GetEntityCoords(PlayerPedId())
            Wait(500)
        end
    end)

    -- starting the job
    CreateThread(function()
        AddTextEntry("press_start_vehicleboost", "Press ~INPUT_CONTEXT~ to start stealing cars.")
        while true do
            opti = 2
            -- get distance between blip and player and check if player is near it
            if not jobStarted then
                if #(playerCoords -
                    vector3(Config.StartBlipLocation.x, Config.StartBlipLocation.y, Config.StartBlipLocation.z)) <= 5 then
                    DisplayHelpTextThisFrame("press_start_vehicleboost")
                    if IsControlPressed(1, 51) then
                        if IsPedSittingInAnyVehicle(player) then
                            DisplayNotification("~r~You can't start the job while you're in a vehicle.")
                        else
                            vehicle = SpawnVehicle(math.randomchoice(Config.StartingVehicles), Config.StartingVehicleLocation)
                            -- tell server we are starting the job
                            TriggerServerEvent("vehicleboost:started")
                            Citizen.Wait(1000)
                            showSubtitle("Steal the cars and bring them back to get paid.", 5000)
                            StartCarJob()
                        end
                    end
                else
                    opti = 2000
                end
            end
            Wait(opti)
        end
    end)

    function StartCarJob()
        -- choose random location where the car is going to spawn
        local location = math.randomchoice(Config.VehicleLocations)
        -- choose random car model
        local model = math.randomchoice(Config.VehicleModels)
        -- add car blip to map
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 523)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)
        -- clear area first
        ClearArea(location.x, location.y, location.z, 50, false, false, false, false, false);
        -- delete previous car before spawning a new one
        if trailer then
            DeleteVehicle(trailer)
        end
        trailer = SpawnTrailer(model, location)
        -- lock the car
        SetVehicleDoorsLocked(trailer, 2)
        SetVehicleDoorsLockedForPlayer(trailer, PlayerPedId(), 2)
        jobStarted = true
        while true do
            opti = 2
            -- gets distance between player and car location and check if player is in the vicinity of it
            if #(playerCoords - vector3(location.x, location.y, location.z)) <= 5 then
                -- and check if they have picked up the car 
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    RemoveBlip(blip)
                    DeliverCar()
                    break
                end
            else
                opti = 2000
            end
            Wait(opti)
        end
    end

    -- drive to the location and deliver the car
    function DeliverCar()
        local location = Config.DropoffLocation
        local blip = AddBlipForCoord(location.x, location.y, location.z)

        showSubtitle("Get this car back to the compound as soon as possible!", 5000)
        SetBlipSprite(blip, 478)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)

        if Config.Has911Script then
            -- choose number 0 or 1 (50% chance)
            local alertPolice = math.random(0, 1)
            -- if the number is 1 then alert the police after 15 seconds
            if alertPolice == 1 then
                Wait(15000)
                ExecuteCommand("911 Someone has stolen a car from a parking lot!")
                showSubtitle("The police has been alerted!", 5000)
            end
        end

        while true do
            opti = 2
            -- gets distance between player and task location and check f player is in the vicinity of it
            if #(playerCoords - vector3(location.x, location.y, location.z)) <= 20 then
                -- and check if they don't have a car anymore
                if not IsVehicleAttachedToTrailer(vehicle) then
                    RemoveBlip(blip)
                    NewChoiceCar(location)
                    break
                end
            else
                opti = 2000
            end
            Wait(opti)
        end
    end

    -- choose to press_start_vehicleboost another car or return to depot
    function NewChoiceCar(location)
        amount = amount + Config.PayPerTheft
        -- tell server we delivered something and where
        TriggerServerEvent("vehicleboost:delivered", location)
        DisplayNotification("Press ~b~E~w~ to accept another job.\nPress ~r~X~w~ to end your shift.")
        while true do
            Wait(0)
            -- client has pressed E to accept another job
            if IsControlPressed(1, 51) then
                local vehicle = SpawnVehicle(math.randomchoice(Config.VehicleModels), Config.StartingVehicleLocation)
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                StartCarJob()
                break
            -- client has pressed X to end the job
            elseif IsControlPressed(1, 73) then
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                EndJobCar()
                break
            end
        end
    end

    -- drive back to the depot and get paid
    function EndJobCar()
        local blip = AddBlipForCoord(Config.EndJobLocation.x, Config.EndJobLocation.y, Config.EndJobLocation.z)
        AddTextEntry("press_end_job", "Press ~INPUT_CONTEXT~ to end the job")
        SetBlipSprite(blip, 457)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)
        if Config.UseND then
            showSubtitle("Head around the back to get your money.", 5000)
        else
            showSubtitle("Come back when you need more work.", 5000)
        end
        jobStarted = false
        while true do
            opti = 2
            -- gets distance between player and depot location and check if player is in the vicinity of it
            if #(playerCoords - vector3(Config.EndJobLocation.x, Config.EndJobLocation.y, Config.EndJobLocation.z)) <= 2 then
                DisplayHelpTextThisFrame("press_end_job")
                -- client has pressed E to store the vehicle
                if IsControlPressed(1, 51) then
                    RemoveBlip(blip)
                    if Config.UseND then
                        -- tell server ve've finished the job and need to pay us
                        TriggerServerEvent("vehicleboost:finished")
                        DisplayNotification("You've received ~g~$" .. amount .. " ~w~for completing the job.")
                        amount = 0
                        break
                    else
                        DisplayNotification("~g~You've successfully completed the job.")
                        break
                    end
                end
            else
                opti = 1000
            end
            Wait(opti)
        end
    end

    -- function to spawn vehicle at desired location
	function SpawnVehicle(model, location)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(500)
		end
		starterVehicle = CreateVehicle(model, location.x, location.y, location.z, location.h, true, false)
		
		-- Turn on the engine
		SetVehicleEngineOn(starterVehicle, true, false, false)

		-- Tell the server we started the job and give us access to the vehicle
		TriggerServerEvent("vehicleboost:giveVehicleAccess", starterVehicle)

		SetVehicleOnGroundProperly(starterVehicle)
		SetEntityAsMissionEntity(starterVehicle, true, true)
		SetModelAsNoLongerNeeded(model)
	end

    -- function to trailer vehicle at desired location
	function SpawnVehicle(model, location)
		local vehicleHash = GetHashKey(model)

		RequestModel(vehicleHash)

		Citizen.CreateThread(function() 
			local waiting = 0
			while not HasModelLoaded(vehicleHash) do
				waiting = waiting + 100
				Citizen.Wait(100)
				if waiting > 5000 then
					ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
					break
				end
			end
			
			local vehicle = CreateVehicle(vehicleHash, location.x, location.y, location.z, location.h, true, false)
			
			-- Turn on the engine
			SetVehicleEngineOn(vehicle, true, true, false)

			-- Tell the server we started the job and give us access to the vehicle
			TriggerServerEvent("vehicleboost:giveVehicleAccess", vehicle)

			SetVehicleOnGroundProperly(vehicle)
			SetEntityAsMissionEntity(vehicle, true, true)
			SetModelAsNoLongerNeeded(vehicleHash)
		end)
	end



    -- function to get random items from a table
    function math.randomchoice(table)
        local keys = {}
        for key, value in pairs(table) do
            keys[#keys + 1] = key
        end
        index = keys[math.random(1, #keys)]
        return table[index]
    end

    -- function to display the notification above minimap
    function DisplayNotification(text)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, false)
    end

    -- ShowTitle Function
    function showSubtitle(message, duration)
        BeginTextCommandPrint('STRING')
        AddTextComponentString(message)
        EndTextCommandPrint(duration, true)
    end
end