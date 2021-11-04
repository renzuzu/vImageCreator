
local screenshot = false
local cam = nil
Citizen.CreateThread(function()
    Wait(500)

    exports('GetModelImage', function(model)
        if not tonumber(model) then
            model = GetHashKey(model)
        end
        model = tostring(model)
        return GlobalState.VehicleImages[model] or 'https://i.imgur.com/NHB74QX.png'
    end)
    local c = 0
    while not LocalPlayer.state.screenshotperms do c = c + 1 Wait(1000) if c >= 30 then break end end
    if LocalPlayer.state.screenshotperms then
        print("PERMS")
        LocalPlayer.state.screenshotnum = GetResourceKvpInt('screenshotnum') and GetResourceKvpInt('screenshotnum') or 1
        RegisterCommand('resetscreenshot', function(source, args, rawCommand)
            LocalPlayer.state.screenshotnum = 1
            SetResourceKvpInt('screenshotnum',LocalPlayer.state.screenshotnum)
        end)

        RegisterCommand('startscreenshot', function(source, args, rawCommand)
            if not screenshot then
                StartScreenShoting()
            end
            screenshot = not screenshot
        end)

        RegisterCommand('getmodelimage', function(source, args, rawCommand)
            print(exports.renzu_vehthumb:GetModelImage(args[1]))
        end)

        function inShowRoom(bool)
            Citizen.CreateThread(function()
                if bool then
                    inshell = true
                    while inshell do
                        Citizen.Wait(0)
                        NetworkOverrideClockTime(22, 00, 00)
                    end
                else
                    inshell = false
                end
            end)
        end

        local fov = 40.0

        function classlist(class)
            if class == '0' then
                name = 40.0
            elseif class == '1' then
                name = 40.0
            elseif class == '2' then
                name = 45.0
            elseif class == '3' then
                name = 40.0
            elseif class == '4' then
                name = 40.0
            elseif class == '5' then
                name = 40.0
            elseif class == '6' then
                name = 40.0
            elseif class == '7' then
                name = 41.0
            elseif class == '8' then
                name = 30.0
            elseif class == '9' then
                name = 45.0
            elseif class == '10' then
                name = 45.0
            elseif class == '11' then
                name = 45.0
            elseif class == '12' then
                name = 45.0
            elseif class == '13' then
                name = 30.0
            elseif class == '14' then
                name = 40.0
            elseif class == '15' then
                name = 48.0
            elseif class == '16' then
                name = 60.0
            elseif class == '17' then
                name = 45.0
            elseif class == '18' then
                name = 44.0
            elseif class == '19' then
                name = 44.0
            elseif class == '20' then
                name = 45.0
            elseif class == '21' then
                name = 70.0
            else
                name = 40.0
            end
            return name
        end

        function GetFovVehicle(vehicle)
            local class = tostring(GetVehicleClass(vehicle))
            return classlist(class)
        end

        function StartScreenShoting()
            inShowRoom(true)
            local returncoord = GetEntityCoords(PlayerPedId())
            screenshot = true
            local ped = PlayerPedId()
            FreezeEntityPosition(PlayerPedId(),true)
            CreateLocation()
            while not IsIplActive("xs_arena_interior") do Wait(0) end

            RequestCollisionAtCoord(2800.5966796875,-3799.7370605469,139.41514587402)
            vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
            local dist = #(vec - GetEntityCoords(ped))
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 2800.5966796875-4.0,-3799.7370605469-4.0,140.9514587402, 360.00, 0.00, 0.00, 60.00, false, 0)
            PointCamAtCoord(cam, 2800.5966796875,-3799.7370605469,139.51514587402)
            SetCamActive(cam, true)
            SetCamFov(cam, 42.0)
            SetCamRot(cam, -15.0, 0.0, 252.063)
            RenderScriptCams(true, true, 1, true, true)
            SetFocusPosAndVel(2800.5966796875,-3799.7370605469,139.41514587402, 0.0, 0.0, 0.0)
            DisplayHud(false)
            DisplayRadar(false)
            Citizen.CreateThread(function()
                local coord = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
                while screenshot do
                    Citizen.Wait(0)
                    -- if LastVehicleFromGarage ~= nil then
                    --     SetEntityHeading(LastVehicleFromGarage, GetEntityHeading(LastVehicleFromGarage) - 0.1)
                    -- end
                    DrawLightWithRange(coord.x-4.0, coord.y-3.0, coord.z+ 0.3, 255,255,255, 40.0, 15.0)
                    DrawSpotLight(coord.x-4.0, coord.y+5.0, coord.z, coord, 255, 255, 255, 20.0, 1.0, 1.0, 20.0, 0.95)
                end
            end)
            Wait(2000)
            --local vehicles = GlobalState.VehiclesFromDB
            print(#GlobalState.VehiclesFromDB,'total vehicles')
            for i = LocalPlayer.state.screenshotnum, #GlobalState.VehiclesFromDB do
                if not screenshot then break end
                LocalPlayer.state.screenshotnum = LocalPlayer.state.screenshotnum + 1
                SetResourceKvpInt('screenshotnum',LocalPlayer.state.screenshotnum)
                local v = GlobalState.VehiclesFromDB[i]
                local hashmodel = GetHashKey(v.model)
                print(v.model,'model')
                if IsModelInCdimage(hashmodel) and not GlobalState.VehicleImages[tostring(hashmodel)] then
                    CreateMobilePhone(1)
                    CellCamActivate(true, true)
                    Citizen.Wait(100)
                    SpawnVehicleLocal(v.model)
                    local wait = promise.new()
                    exports['screenshot-basic']:requestScreenshotUpload(Config.DiscordWebHook, 'files', function(data)
                        local image = json.decode(data)
                        DestroyMobilePhone()
                        CellCamActivate(false, false)
                        print(image.attachments[1].proxy_url)
                        if image.attachments[1].proxy_url == nil then
                            print("HOST UPLOAD ERROR")
                            screenshot = false
                        end
                        local data = {
                            model = v.model,
                            img = image.attachments[1].proxy_url
                        }
                        TriggerServerEvent('renzu_vehthumb:save',data)
                        print("Vehicle Image Save")
                        Wait(500)
                        wait:resolve(image)
                        --cb(json.encode({ url = image.attachments[1].proxy_url }))
                    end)
                    Citizen.Await(wait)
                else
                    print(v.model,' already exist')
                end
            end
            while screenshot do
                --SetEntityAlpha(PlayerPedId(),1,true)
                Citizen.Wait(111)
            end
            RenderScriptCams(false)
            DestroyAllCams(true)
            ClearFocus()
            SetCamActive(cam, false)
            CellCamActivate(false, false)
            inShowRoom(false)
            SetEntityCoords(PlayerPedId(),returncoord)
            Wait(200)
            FreezeEntityPosition(PlayerPedId(),false)
        end

        local arenacoord = vector4(2800.5966796875,-3799.7370605469,139.41514587402,244.5432434082)
        function CreateLocation()
            local ped = PlayerPedId()
            LoadArena()
            SetCoords(ped, arenacoord, 82.0, true)
        end

        function SetCoords(ped, x, y, z, h, freeze)
            RequestCollisionAtCoord(x, y, z)
            while not HasCollisionLoadedAroundEntity(ped) do
                RequestCollisionAtCoord(x, y, z)
                Citizen.Wait(1)
            end
            DoScreenFadeOut(950)
            Wait(1000)                            
            SetEntityCoords(ped, x+5.0, y-5.0, z)
            SetEntityHeading(ped, h)
            DoScreenFadeIn(3000)
        end

        ---------------------------------------------------------------------------------------
        --            Arena Resource by Titch2000 You may edit but please keep credit.
        ---------------------------------------------------------------------------------------
        -- config
        local map = 9
        local scene = "scifi"


        --         NO TOUCHING BELOW THIS POINT, NO HELP WILL BE OFFERED IF YOU DO.
        ---------------------------------------------------------------------------------------
        local maps = {
            ["dystopian"] = {
                "Set_Dystopian_01",
                "Set_Dystopian_02",
                "Set_Dystopian_03",
                "Set_Dystopian_04",
                "Set_Dystopian_05",
                "Set_Dystopian_06",
                "Set_Dystopian_07",
                "Set_Dystopian_08",
                "Set_Dystopian_09",
                "Set_Dystopian_10",
                "Set_Dystopian_11",
                "Set_Dystopian_12",
                "Set_Dystopian_13",
                "Set_Dystopian_14",
                "Set_Dystopian_15",
                "Set_Dystopian_16",
                "Set_Dystopian_17"
            },

            ["scifi"] = {
                "Set_Scifi_01",
                "Set_Scifi_02",
                "Set_Scifi_03",
                "Set_Scifi_04",
                "Set_Scifi_05",
                "Set_Scifi_06",
                "Set_Scifi_07",
                "Set_Scifi_08",
                "Set_Scifi_09",
                "Set_Scifi_10"
            },

            ["wasteland"] = {
                "Set_Wasteland_01",
                "Set_Wasteland_02",
                "Set_Wasteland_03",
                "Set_Wasteland_04",
                "Set_Wasteland_05",
                "Set_Wasteland_06",
                "Set_Wasteland_07",
                "Set_Wasteland_08",
                "Set_Wasteland_09",
                "Set_Wasteland_10"
            }
        }

        function UnloadArena()
            RemoveIpl('xs_arena_interior')
        end

        function LoadArena()
                -- New Arena : 2800.00, -3800.00, 100.00
                RequestIpl("xs_arena_interior")

                -- The below are additional interiors / maps relating to this DLC play around with them at your own risk and want.
                --RequestIpl("xs_arena_interior_mod")
                --RequestIpl("xs_arena_interior_mod_2")
                RequestIpl("xs_arena_interior_vip") -- This is the interior bar for VIP's
                --RequestIpl("xs_int_placement_xs")
                RequestIpl("xs_arena_banners_ipl")
                --RequestIpl("xs_mpchristmasbanners")
                --RequestIpl("xs_mpchristmasbanners_strm_0")

                -- Lets get and save our interior ID for use later
                local interiorID = GetInteriorAtCoords(2800.000, -3800.000, 100.000)

                -- now lets check the interior is ready if not lets just wait a moment
                if (not IsInteriorReady(interiorID)) then
                    Wait(1)
                end
                -- We need to add the crowds as who does stuff on their own for nobody?
                EnableInteriorProp(interiorID, "Set_Crowd_A")
                EnableInteriorProp(interiorID, "Set_Crowd_B")
                EnableInteriorProp(interiorID, "Set_Crowd_C")
                EnableInteriorProp(interiorID, "Set_Crowd_D")

                -- now lets set our map type and scene.
                if (scene == "dystopian") then
                    EnableInteriorProp(interiorID, "Set_Dystopian_Scene")
                    EnableInteriorProp(interiorID, maps[scene][map])
                end
                if (scene == "scifi") then
                    EnableInteriorProp(interiorID, "Set_Scifi_Scene")
                    EnableInteriorProp(interiorID, maps[scene][map])
                end
                if (scene == "wasteland") then
                    EnableInteriorProp(interiorID, "Set_Wasteland_Scene")
                    EnableInteriorProp(interiorID, maps[scene][map])
                end
        end

        local loading = false
        LastVehicleFromGarage = nil
        function SpawnVehicleLocal(model)
            if loading or GetNumberOfStreamingRequests() > 0 then return end
            local ped = PlayerPedId()
            if LastVehicleFromGarage ~= nil then
                ReqAndDelete(LastVehicleFromGarage)
            end
            for i = 1, 2 do
                local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
                if DoesEntityExist(nearveh) then
                    ReqAndDelete(nearveh)
                end
                while DoesEntityExist((nearveh)) do ReqAndDelete(nearveh) Wait(100) end
            end
            vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
            dist = #(vec - GetEntityCoords(ped))
            local hash = GetHashKey(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
                loading = true
            end
            loading = false
            vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
            LastVehicleFromGarage = CreateVehicle(hash, vec, 90.0, 0, 1)
            while not DoesEntityExist(LastVehicleFromGarage) do Wait(0) end
            local minDim, maxDim = GetModelDimensions(hash)
            local modelSize = maxDim - minDim
            local fovval = modelSize.x * modelSize.y * modelSize.z
            fov = fovval + 20
            SetCamFov(cam, fov)
            SetEntityHeading(LastVehicleFromGarage, 80.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            SetVehicleDirtLevel(LastVehicleFromGarage, 0.0)
            --SetVehicleProp(LastVehicleFromGarage, props)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                ReqAndDelete(LastVehicleFromGarage)
                SetModelAsNoLongerNeeded(hash)
            end
            SetModelAsNoLongerNeeded(hash)
            --SetEntityAlpha(PlayerPedId(),1,true)
            SetVehicleEngineOn(LastVehicleFromGarage,true,true,false)
            --TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
            Wait(500)
        end

        function ReqAndDelete(object, detach)
            if DoesEntityExist(object) then
                NetworkRequestControlOfEntity(object)
                local attempt = 0
                while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
                    NetworkRequestControlOfEntity(object)
                    Citizen.Wait(11)
                    attempt = attempt + 1
                end
                --if detach then
                    DetachEntity(object, 0, false)
                --end
                SetEntityCollision(object, false, false)
                SetEntityAlpha(object, 0.0, true)
                SetEntityAsMissionEntity(object, true, true)
                SetEntityAsNoLongerNeeded(object)
                DeleteEntity(object)
            end
        end
    end
end)