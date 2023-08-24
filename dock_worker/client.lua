--[[
Created by Lama	Development
For support - https://discord.gg/etkAKTw3M7
Do not edit below if you don't know what you are doing
]] --

if Config.EnabledJobs['dock_worker'] then
    -- variables, don't touch
    local actualPallet
    local show, JobStarted, isPalletSpawned, isAttached, attachedEntity = false, false, false, nil, {}
    dockPay = 0

    function NewBlipDock()
        local objective = math.randomchoice(Config.CargoPos)
        local ped = GetPlayerPed(-1)
        local blip = AddBlipForCoord(objective.x, objective.y, objective.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 2)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 2)
        local coords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, objective.x, objective.y, objective.z, true)

        while true do
            Citizen.Wait(0)
            coords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(coords, objective.x, objective.y, objective.z, true)
            -- client is near the objective
            if distance <= 4 then
                local carPallet = GetVehiclePedIsIn(ped, false)
                local carEntity = GetEntityModel(carPallet)
                local carName = GetDisplayNameFromVehicleModel(carEntity)
                -- check if client is in the forklift
                if carName == "FORK" then
                    local pallet = GetClosestObjectOfType(coords, 5.0, actualPallet, false, false, false)
                    -- check if client isactually carrying the pallet
                    if DoesEntityExist(pallet) == 1 then
                        RemoveBlip(blip)
                        DeleteEntity(pallet)
                        drawnotifcolor("Delivery completed.", 25)
                        dockPay = dockPay + Config.CargoAmount
                        actualPallet, attachedEntity = nil, nil
                        isPalletSpawned, isAttached = false, false
                        NotifChoiceDock()
                        break
                    else
                        drawnotifcolor("You're not carrying the pallet. Press X to end the job.", 208)
                    end
                end
            end
            -- client has cancelled the job
            if IsControlJustPressed(1, 73) then
                RemoveBlip(blip)
                local pallet = GetClosestObjectOfType(coords, 5.0, actualPallet, false, false, false)
                local doesPalletExist = DoesEntityExist(pallet)
                -- delete the pallet if it exists
                if doesPalletExist == 1 then
                    DeleteEntity(pallet)
                    isPalletSpawned = false
                end
                drawnotifcolor("Bring back the forklift.", 25)
                EndServiceDock()
                break
            end
        end
    end

    -- Stop or continue after objective is finished
    function NotifChoiceDock()
        drawnotifcolor("Press ~g~E~w~ to continue.\nPress ~r~X~w~ to stop working.", 140)
        local timer = 10000
        while timer >= 1 do
            Citizen.Wait(10)
            timer = timer - 1
            -- client has chosen to continue working
            if IsControlJustPressed(1, 38) then
                NewChoiceDock()
                break
            end
            -- client has cancelled the job
            if IsControlJustPressed(1, 73) then
                drawnotifcolor("Bring back the forklift.", 25)
                EndServiceDock()
                isPalletSpawned = false
                break
            end
            -- timer has elapsed
            if timer == 1 then
                drawnotifcolor("You took too much time. Bring back the forklift.", 25)
                EndServiceDock()
                isPalletSpawned = false
                break
            end
        end
    end

    -- Spawns first objetive and blip
    function NewChoiceDock()
        local prop = math.randomchoice(Config.CargoProps)
        local ped = GetPlayerPed(-1)

        while not HasModelLoaded(prop.model) do
            RequestModel(prop.model)
            Citizen.Wait(1)
        end

        local blip = AddBlipForCoord(prop.x, prop.y, prop.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 3)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 3)

        drawnotifcolor("Go to the marked location.\nPress ~r~X~w~ to stop at any moment.", 140)
        local coords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, prop.x, prop.y, prop.z, true)

        while true do
            Citizen.Wait(0)
            -- get distance between client and objective
            coords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(coords, prop.x, prop.y, prop.z, true)
            -- client is near the objective
            if distance <= 60 then
                if not isPalletSpawned then
                    -- spawn the pallet
                    local objcreated2 = CreateObject(prop.model, prop.x, prop.y, prop.z, true, false, true)
                    actualPallet = prop.model
                    SetModelAsNoLongerNeeded(objcreated2)
                    isPalletSpawned = true
                end
                -- client has taken the pallet
                if distance <= 10 and IsControlJustPressed(0, 57) then
                    RemoveBlip(blip)
                    NewBlipDock()
                    break
                end
            end
            -- client has cancelled the job
            if IsControlJustPressed(1, 73) then
                RemoveBlip(blip)
                drawnotifcolor("Bring back the forklift.", 140)
                isPalletSpawned = false
                EndServiceDock()
                break
            end
        end
    end

    -- end job
    function EndServiceDock()
        local coordsEndService = vector3(782.572, -2985.0231, 4.801)
        local ped = GetPlayerPed(-1)
        AddTextEntry("press_ranger_fork", 'Press ~INPUT_CONTEXT~ to store the forklift and complete the job.')
        local blip = AddBlipForCoord(coordsEndService)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 1)

        while true do
            Citizen.Wait(0)
            -- get distance between client and objective
            local coords = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(coordsEndService, coords, true)
            -- client is near the objective
            if distance <= 5 then
                DisplayHelpTextThisFrame("press_ranger_fork")
                -- client has pressed E
                if IsControlPressed(1, 38) then
                    local carPallet = GetVehiclePedIsIn(ped, false)
                    local carEntity = GetEntityModel(carPallet)
                    local carName = GetDisplayNameFromVehicleModel(carEntity)
                    -- check if client is in the forklift
                    if carName ~= "FORK" then
                        drawnotifcolor("You're not in your forklift.", 208)
                    else
                        DeleteVehicle(carPallet)
                        if Config.UseND then
                            TriggerServerEvent("PortCargo:GiveReward", dockPay)
                            drawnotifcolor("You've received ~g~$" .. dockPay .. "~w~ for completing the job.", 140)
                        else
                            drawnotifcolor("You've completed the job.", 140)
                        end
                        RemoveBlip(blip)
                        JobStarted, show, actualPallet = false, false, nil
                        break
                    end
                end
            end
        end
    end

    -- Spawn forklift
    function PriseService()
        local ped = GetPlayerPed(-1)
        local vehicleName = 'forklift'
        RequestModel(vehicleName)

        -- wait for the model to load
        while not HasModelLoaded(vehicleName) do
            Wait(500)
        end

        forklift = CreateVehicle(vehicleName, 782.084, -2977.7004, 4.80, 62.60, true, false)
        SetVehicleEngineOn(forklift, true, true, false)
        -- tell server we started the job and to give access to the forklift
        TriggerServerEvent("DrugTrafficking:StartedCollecting", forklift)
        -- set the player ped into the forklift's driver seat
        SetPedIntoVehicle(ped, forklift, -1)
        SetEntityAsMissionEntity(forklift, true, true)
        -- release the model
        SetModelAsNoLongerNeeded(vehicleName)
        JobStarted = true
        NewChoiceDock()
    end

    -- Start job
    Citizen.CreateThread(function()
        AddTextEntry("press_start_job", "Press ~INPUT_CONTEXT~ to start working.")
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(vector3(785.8201, -2975.85644, 6.02), coords, true)
            if distance <= 5 then
                DisplayHelpTextThisFrame("press_start_job")
                if IsControlPressed(1, 38) then
                    PriseService()
                end
            end
        end
    end)

    -- draw notification above minimap  
    function drawnotifcolor(text, color)
        Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(false, true)
    end

    -- draw job blip and spawn npc
    Citizen.CreateThread(function()
        local blip = AddBlipForCoord(787.0050, -2975.77441, 5.033)
        SetBlipSprite(blip, 457)
        SetBlipColour(blip, 26)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Port Cargo Job")
        EndTextCommandSetBlipName(blip)
        local playerCoords = GetEntityCoords(PlayerPedId())

        while GetDistanceBetweenCoords(playerCoords, 787.0050, -2975.77441, 5.033, true) > 200 do
            Citizen.Wait(100)
            playerCoords = GetEntityCoords(PlayerPedId())
        end

        local modelped = -2039072303
        RequestModel(modelped)
        while not HasModelLoaded(modelped) do
            Wait(1)
        end

        local ped = CreatePed(1, modelped, 787.0050, -2975.77441, 5.033, 87.4387, false, true)
        SetModelAsNoLongerNeeded(modelped)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end)

    function math.randomchoice(d) -- Selects a random item from a table
        local keys = {}
        for key, value in pairs(d) do
            keys[#keys + 1] = key -- Store keys in another table
        end
        index = keys[math.random(1, #keys)]
        return d[index]
    end

    -- All credits to TheIndra 
    -- A simple modification of Enhanced Forklift Script to make it word with the job
    CreateThread(function()
        AddTextEntry("press_attach_vehicle", "Press ~INPUT_DROP_AMMO~ to lift the pallet")
        while true do
            Wait(0)
            if JobStarted then
                if show then
                    DisplayHelpTextThisFrame("press_attach_vehicle")
                end
                -- f10 to attach/detach
                if IsControlJustPressed(0, 57) then
                    -- if already attached detach
                    if isAttached then
                        DetachEntity(attachedEntity, true, true)
                        attachedEntity = nil
                        isAttached = false
                    else
                        -- get vehicle infront
                        local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
                        local veh = GetClosestVehicle(pos, 2.0, 0, 70)
                        local ped = GetPlayerPed(-1)
                        local coords = GetEntityCoords(ped)
                        local object = GetClosestObjectOfType(coords, 5.0, actualPallet, false, false, false)

                        -- if vehicle is found
                        if object and IsPedInAnyVehicle(PlayerPedId(), false) then
                            -- check if player is in forklift
                            local carPallet = GetVehiclePedIsIn(ped, false)
                            local carEntity = GetEntityModel(carPallet)
                            local carName = GetDisplayNameFromVehicleModel(carEntity)
                            if carName == "FORK" then
                                isAttached = true
                                show = false
                                attachedEntity = object
                                -- attach vehicle to forklift
                                AttachEntityToEntity(object, carPallet, 3, 0.0, 1.3, -0.09, 0.0, 0, 90.0, false, false,
                                    false, false, 2, true)
                            end
                        end
                    end
                end
            end
        end
    end)

    CreateThread(function()
        while true do
            -- check every 500ms if helptext should show
            Wait(500)
            if JobStarted then
                local ped = GetPlayerPed(-1)
                local carPallet = GetVehiclePedIsIn(ped, false)
                local carEntity = GetEntityModel(carPallet)
                local carName = GetDisplayNameFromVehicleModel(carEntity)
                if not isAttached and IsPedInAnyVehicle(ped) and carName == "FORK" then
                    local coords = GetEntityCoords(ped)
                    local object = GetClosestObjectOfType(coords, 5.0, actualPallet, false, false, false)
                    if object ~= 0 then
                        show = true
                    end
                else
                    show = false
                end
            end
        end
    end)
end