--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --
if Config.EnabledJobs['truck_driver'] then
    -- variables, do not touch
    local amount = 0
    local playerCoords = nil
    local jobStarted = false
    local truck, trailer = nil, nil
    local opti

    -- draw blip on the map
    CreateThread(function()
        local blip = AddBlipForCoord(Config.BlipLocation.x, Config.BlipLocation.y, Config.BlipLocation.z)
        SetBlipSprite(blip, 457)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 26)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Truck Driver Job")
        EndTextCommandSetBlipName(blip)
    end)

    -- constantly get player coords
    CreateThread(function()
        while true do
            playerCoords = GetEntityCoords(PlayerPedId())
            Wait(500)
        end
    end)

    -- starting the job
    CreateThread(function()
        AddTextEntry("press_start_job", "Press ~INPUT_CONTEXT~ to start your shift")
        while true do
            opti = 2
            -- get distance between blip and player and check if player is near it
            if not jobStarted then
                if #(playerCoords - vector3(Config.BlipLocation.x, Config.BlipLocation.y, Config.BlipLocation.z)) <= 5 then
                    DisplayHelpTextThisFrame("press_start_job")
                    if IsControlPressed(1, 38) then
                        -- check if player is in a vehicle
                        if IsPedSittingInAnyVehicle(player) then
                            DisplayNotification("~r~You can't start the job while you're in a vehicle.")
                        else
                            -- choose random truck model and spawn it
                            local startingTruck = math.randomchoice(Config.TruckModel)
                            SpawnVehicle(startingTruck, Config.DepotLocation)
                            -- tell server we are starting the job
                            TriggerServerEvent("TruckDriver:started", truck)
                            SetPedIntoVehicle(GetPlayerPed(-1), truck, -1)
                            -- start the job
                            StartTruckJob()
                        end
                    end
                else
                    opti = 2000
                end
            end
            Wait(opti)
        end
    end)

    -- drive to the trailer and pick it up
    function StartTruckJob()
        -- choose random location where the trailer is going to spawn
        local location = math.randomchoice(Config.TrailerLocations)
        -- choose random trailer model
        local model = math.randomchoice(Config.TrailerModels)
        -- add trailer blip to map
        blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 479)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)
        -- clear area first
        ClearArea(location.x, location.y, location.z, 50, false, false, false, false, false);
        -- delete previous trailer before spawning a new one
        if trailer then
            DeleteVehicle(trailer)
        end
        -- spawn trailer
        trailer = SpawnTrailer(model, location)
        DisplayNotification("~b~New task: ~w~pick up the trailer at the marked location.")
        if Config.UseND then
            DisplayNotification(
                "Long press ~r~SHIFT~w~ + ~r~X~w~ at any time to force-cancel the job and pay a penalty.")
        else
            DisplayNotification("Long Press ~r~SHIFT~w~ + ~r~X~w~ at any time to force-cancel the job.")
        end
        while true do
            opti = 2
            -- check if forcequit 
            if IsControlPressed(1, 73) then
                ForceQuit()
                break
            end
            -- gets distance between player and trailer location and check if player is in the vicinity of it
            if #(playerCoords - vector3(location.x, location.y, location.z)) <= 20 then
                -- and check if they have picked up the trailer 
                if IsVehicleAttachedToTrailer(truck) then
                    RemoveBlip(blip)
                    DeliverTrailer()
                    break
                end
            else
                opti = 2000
            end
            Wait(opti)
        end
    end

    -- drive to the location and deliver the trailer
    function DeliverTrailer()
        AddTextEntry("press_detach_trailer", "Long press ~INPUT_VEH_HEADLIGHT~ to detach the trailer")
        -- choose random location where the trailer is going to be delivered
        local location = math.randomchoice(Config.Destinations)
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 478)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)
        DisplayNotification("~b~New task: ~w~deliver the trailer at the marked location.")
        while true do
            opti = 2
            -- check if forcequit 
            if IsControlPressed(1, 73) then
                ForceQuit()
                break
            end
            -- gets distance between player and task location and check f player is in the vicinity of it
            if #(playerCoords - vector3(location.x, location.y, location.z)) <= 20 then
                DisplayHelpTextThisFrame("press_detach_trailer")
                -- and check if they don't have a trailer attached anymore
                if not IsVehicleAttachedToTrailer(truck) then
                    RemoveBlip(blip)
                    NewChoice(location)
                    break
                end
            else
                opti = 2000
            end
            Wait(opti)
        end
    end

    -- choose to deliver another trailer or return do depot
    function NewChoice(location)
        amount = amount + Config.PayPerDelivery
        -- tell server we delivered something and where
        TriggerServerEvent("TruckDriver:delivered", location)
        DisplayNotification("Press ~b~E~w~ to accept another job.\nPress ~r~X~w~ to end your shift.")
        while true do
            Wait(0)
            if IsControlPressed(1, 38) then
                StartTruckJob()
                break
            elseif IsControlPressed(1, 73) then
                EndJob()
                break
            end
        end
    end

    -- drive back to the truck depot and get paid
    function EndJob()
        local blip = AddBlipForCoord(Config.DepotLocation.x, Config.DepotLocation.y, Config.DepotLocation.z)
        AddTextEntry("press_end_job", "Press ~INPUT_CONTEXT~ to end your shift")
        SetBlipSprite(blip, 477)
        SetBlipColour(blip, 26)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 26)
        if Config.UseND then
            DisplayNotification("~b~New task: ~w~return the truck to the depot to get paid.")
        else
            DisplayNotification("~b~New task: ~w~return the truck to the depot.")
        end
        jobStarted = false
        while true do
            opti = 2
            -- gets distance between player and depot location and check if player is in the vicinity of it
            if #(playerCoords - vector3(Config.DepotLocation.x, Config.DepotLocation.y, Config.DepotLocation.z)) <= 10 then
                DisplayHelpTextThisFrame("press_end_job")
                if IsControlPressed(1, 38) then
                    RemoveBlip(blip)
                    -- deletes truck and trailer
                    local truck = GetVehiclePedIsIn(PlayerPedId(), false)
                    if GetEntityModel(truck) == GetHashKey(Config.TruckModel) then
                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                    end
                    DeleteVehicle(trailer)
                    -- tell server ve've finished the job and need to pay us
                    TriggerServerEvent("TruckDriver:finished")
                    if Config.UseND then
                        DisplayNotification("You've received ~g~$" .. amount .. " ~w~for completing the job.")
                    else
                        DisplayNotification("~g~You've completed the job.")
                    end
                    amount = 0
                    break
                end
            else
                opti = 1000
            end
            Wait(opti)
        end
    end

    function ForceQuit()
        -- deletes truck and trailer
        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        DeleteVehicle(trailer)
        RemoveBlip(blip)
        TriggerServerEvent("TruckDriver:forcequit")
        if Config.UseND then
            DisplayNotification("You've been fined ~r~$" .. Config.Penalty .. " ~w~for cancelling the job.")
        else
            DisplayNotification("~r~You've cancelled the job.")
        end
        amount = 0
    end

    -- function to spawn truck at desired location
    function SpawnVehicle(model, location)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(500)
        end
        local truck = CreateVehicle(model, location.x, location.y, location.z, location.h, true, false)
        SetVehicleEngineOn(truck, true, true, false)
        SetVehicleOnGroundProperly(truck)
        SetEntityAsMissionEntity(truck, true, true)
        SetModelAsNoLongerNeeded(model)
        local netId = NetworkGetNetworkIdFromEntity(truck) -- Calculate netId
        return truck, netId
    end

    -- Call the function when spawning the truck
    local spawnedTruck, netId = SpawnVehicle(model, location)
    TriggerServerEvent("TruckDriver:started", spawnedTruck, netId)

    -- function to get random items from a table
    function math.randomchoice(table)
        local keys = {}
        for key, value in pairs(table) do
            keys[#keys + 1] = key
        end
        index = keys[math.random(1, #keys)]
        return table[index]
    end

    -- function to trailer truck at desired location
    function SpawnTrailer(model, location)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(500)
        end
        trailer = CreateVehicle(model, location.x, location.y, location.z, location.h, true, false)
        SetVehicleOnGroundProperly(trailer)
        SetEntityAsMissionEntity(trailer, true, true)
        SetModelAsNoLongerNeeded(model)
    end

    -- function to display the notification above minimap
    function DisplayNotification(text)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, false)
    end
end
