--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

if Config.EnabledJobs['garbage_collector'] then
    -- variables, do not touch
    local show = false
    local JobStarted = false
    garbagePay = 0

    -- first objective
    function NewBlipGarbage()
        local objective = math.randomchoice(Config.GarbagePos)
        local ped = GetPlayerPed(-1)
        local blip = AddBlipForCoord(objective.x, objective.y, objective.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 2)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 2)
        local coords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, objective.x, objective.y, objective.z, true)

        -- add money to the total for completing the objective
        garbagePay = garbagePay + Config.GarbageAmount

        while true do
            Citizen.Wait(0)
            -- get player coords
            coords = GetEntityCoords(ped)
            -- get distance between player and objective
            distance = GetDistanceBetweenCoords(coords, objective.x, objective.y, objective.z, true)
            AddTextEntry("press_collect_trash2", 'Press ~INPUT_CONTEXT~ to collect the trash')
            if distance <= 10 then
                DisplayHelpTextThisFrame("press_collect_trash2")
                if IsControlJustPressed(1, 38) then
                    RemoveBlip(blip)
                    NotifChoiceGarbage()
                    break
                end
            end
        end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            drawnotifcolor("Bring back the truck.", 25)
            StopService()
        end
    end

    -- choice between a new objective or stop the job
    function NotifChoiceGarbage()
        drawnotifcolor("Press ~g~E~w~ for a new location.\nPress ~r~X~w~ if you want to stop the job.", 140)
        local garbageTimer = 10000
        while garbageTimer >= 1 do
            Citizen.Wait(10)
            garbageTimer = garbageTimer - 1
            -- client has pressed E for a new objective
            if IsControlJustPressed(1, 38) then
                NewChoiseGarbage()
                break
            end
            -- client has pressed X to stop the job
            if IsControlJustPressed(1, 73) then
                drawnotifcolor("Bring back the truck.", 25)
                StopService()
                break
            end
            -- garbageTimer has run out
            if garbageTimer == 1 then
                drawnotifcolor("You took too much time. Bring back the truck.", 25)
                StopService()
                break
            end
        end
    end

    -- new objective
    function NewChoiseGarbage()
        -- get a random objective
        local route = math.randomchoice(Config.GarbagePos)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local blip = AddBlipForCoord(route.x, route.y, route.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 3)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 3)
        drawnotifcolor("New location is set, press \n~r~X~w~ if you want to stop the job.", 140)
        local coords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, route.x, route.y, route.z, true)

        while true do
            Citizen.Wait(0)
            -- get player coords and distance between player and objective
            coords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(coords, route.x, route.y, route.z, true)
            AddTextEntry("press_collect_trash", 'Press ~INPUT_CONTEXT~ to collect the trash')
            if distance <= 10 then
                DisplayHelpTextThisFrame("press_collect_trash")
                -- client has pressed E to collect the trash
                if IsControlJustPressed(1, 38) then
                    RemoveBlip(blip)
                    NewBlipGarbage()
                    break
                end
            end
            -- client has pressed X to stop the job
            if IsControlJustPressed(1, 73) then
                RemoveBlip(blip)
                if Config.UseND then
                    drawnotifcolor("Bring back the truck to get the money.", 140)
                else
                    drawnotifcolor("Bring back the truck to complete the job.", 140)
                end
                StopService()
                break
            end
        end
    end

    function StopService()
        -- get the coords of the end service
        local coordsEndService = vector3(845.46, -2355.36, 30.33)
        local ped = GetPlayerPed(-1)
        AddTextEntry("press_ranger_rubble", 'Press ~INPUT_CONTEXT~ to store the truck')
        local blip = AddBlipForCoord(coordsEndService)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 1)

        while true do
            Citizen.Wait(0)
            local coords = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(coordsEndService, coords, true)
            if distance <= 10 then
                DisplayHelpTextThisFrame("press_ranger_rubble")
                -- client has pressed E to store the truck
                if IsControlPressed(1, 38) then
                    local playerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    -- check if the player is in the initial garbage truck
                    if GetEntityModel(vehicle) == GetHashKey(Config.GarbageTruck) then
                        DeleteEntity(vehicle)
                        RemoveBlip(blip)
                        if Config.UseND then
                            drawnotifcolor("You've received ~g~$" .. garbagePay .. "~w~ for completing the job.", 140)
                            -- tell the server to give the player the money
                            TriggerServerEvent('TrashCollector:GiveReward', garbagePay)
                        else
                            drawnotifcolor("You've completed the job.", 140)
                        end
                        JobStarted, show = false, false
                        break
                    else
                        drawnotifcolor("~r~Bring back the garbage truck to end the job.", 140)
                        JobStarted, show = true, true
                        break
                    end
                end
            end
        end
    end

	function StartGarbageJob()
		local ped = GetPlayerPed(-1)
		local vehicle = Config.GarbageTruck
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(500)
		end

		-- Use the specified spawn location from Config.TrashTruckSpawn
		local spawnCoords = vector3(Config.TrashTruckSpawn.x, Config.TrashTruckSpawn.y, Config.TrashTruckSpawn.z)

		-- Spawn garbage truck
		garbageTruck = CreateVehicle(vehicle, spawnCoords, 0.0, true, false)
		SetVehicleEngineOn(garbageTruck, true, true, false)
        JobStarted = true
        -- Tell the server that the player has started the job and to give access to the truck
        TriggerServerEvent("TrashCollector:started", garbageTruck)
        -- Get the first objective
        NewChoiseGarbage()
	end


    -- draw marker and check when to start the job
    Citizen.CreateThread(function()
        AddTextEntry("press_start_job", "Press ~INPUT_CONTEXT~ to start your shift")
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(vector3(869.58, -2329, 30.35), coords, true)
            DrawMarker(1, 869.61, -2328.52, 29.35, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 1.5001, 80, 134, 238, 75, 0, 0, 0, 0)
            if distance <= 2 then
                DisplayHelpTextThisFrame("press_start_job")
                if IsControlPressed(1, 38) then
                    StartGarbageJob()
                end
            end
        end
    end)

    -- draw notification above the minimap
    function drawnotifcolor(text, color)
        Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, true)
    end

    function math.randomchoice(d)
        local keys = {}
        for key, value in pairs(d) do
            keys[#keys + 1] = key
        end
        index = keys[math.random(1, #keys)]
        return d[index]
    end

    -- drawn blip on the map
    Citizen.CreateThread(function()
        local bliplocation = vector3(869.66, -2328.95, 30.35)
        local blip = AddBlipForCoord(bliplocation.x, bliplocation.y, bliplocation.z)
        SetBlipSprite(blip, 457)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 26)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Trash Collector Job")
        EndTextCommandSetBlipName(blip)
    end)
end