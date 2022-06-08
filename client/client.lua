local M = {
    encode = PreLibDeflate.encode ,
    decode = PreLibDeflate.decode ,
    encodeNumber = PreLibDeflate.encodeNumber ,
    decodeNumber = PreLibDeflate.decodeNumber ,
    encodeSql = PreLibDeflate.encodeToSQL  ,
    decodeSql = PreLibDeflate.decodeFromSQL
}

local cam = nil

function SetCoords(ped, x, y, z, h, freeze)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(x, y, z)
        Citizen.Wait(1)
    end
    Wait(1000)                            
    SetEntityCoords(ped, x+5.0, y-5.0, z)
    SetEntityHeading(ped, h)
end 

local maincoords = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
local arenacoord = vector4(maincoords.x,maincoords.y,maincoords.z,244.5432434082)

function CreateLocation()
    LoadArena()
    while not IsIplActive("xs_arena_interior") do Wait(0) end
    RequestCollisionAtCoord(maincoords.x,maincoords.y,maincoords.z)
    SetCoords(PlayerPedId(), arenacoord, 82.0, true)
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



local fov = 40.0

function TakePhoto(model)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    Wait(100)
    local p = promise.new() 
    exports['screenshot-basic']:requestScreenshot({encoding="jpg",quality=0.8},function(data)
        local image = data
        DestroyMobilePhone()
        CellCamActivate(false, false)
        print(data)
        local d = {
            model = model,
            img = M.encode(data)
        }
        TriggerServerEvent('nbk_renzu_vehthumb:save',d)
        print("Vehicle Image Save Next")
        Wait(500)
        p:resolve(image)
        --cb(json.encode({ url = image.attachments[1].proxy_url }))
    end)
    Citizen.Await(p)
end 

function GenerateVehicle(hash)
   local temp = CreateVehicle(hash, maincoords, 90.0, 0, 1)
   while not DoesEntityExist(temp) do Wait(0) end
   local minDim, maxDim = GetModelDimensions(hash)
   local modelSize = maxDim - minDim
   SetEntityHeading(temp, 80.117)
   FreezeEntityPosition(temp, true)
   SetEntityCollision(temp,false)
   SetVehicleDirtLevel(temp, 0.0)
   SetModelAsNoLongerNeeded(hash)
   SetVehicleEngineOn(temp,true,true,false)
   return temp
end 

function DeleteVeh(veh)
    DeleteVehicle(veh)
end 

function ClearEverything()
    ClearAreaLeaveVehicleHealth(maincoords.x,maincoords.y,maincoords.z, 5000.0, false, false, false, false)
end 

function StartScreenShoting(list)
    local ped = PlayerPedId()
    
    print(#list,'total vehicles')
    for i = 1, #list do
       local v = list[i]
       local hashmodel = v
       RequestModel(hashmodel)
       while not HasModelLoaded(hashmodel) do Wait(0) end 
       if HasModelLoaded(hashmodel) then -- and not GlobalState.VehicleImages[tostring(hashmodel)] then
           ClearEverything()
           local temp = GenerateVehicle(hashmodel)
           SetCamera(temp)
           TakePhoto(v)
           DeleteVeh(temp)
           print(v,'model',HasModelLoaded(hashmodel))
       end
    end 
    
    Wait(111)
    RenderScriptCams(false)
    DestroyAllCams(true)
    ClearFocus()
    SetCamActive(cam, false)
    CellCamActivate(false, false)
    Wait(200)
    FreezeEntityPosition(PlayerPedId(),false)
    SetEntityAlpha(PlayerPedId(),255)
end

CreateThread(function()
    --lock time 
    while true do Wait(100)
        NetworkOverrideClockTime(22, 00, 00)
    end 
end)

CreateThread(function()
    --spot light 
    
    while true do Wait(0)
        DrawLightWithRange(maincoords.x-4.0, maincoords.y-3.0, maincoords.z+ 0.3, 255,255,255, 40.0, 15.0)
        DrawSpotLight(maincoords.x-4.0, maincoords.y+5.0, maincoords.z, maincoords, 255, 255, 255, 20.0, 1.0, 1.0, 20.0, 0.95)
    end 
end)

function SetCamera(veh)
    local model = GetEntityModel(veh)
    local size1,size2 = GetModelDimensions(model) 
    local camcoords = GetOffsetFromEntityInWorldCoords(veh,-4.0-(size2-size1).x,3.0+(size2-size1).y,2.0+(size2-size1).z)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camcoords.x,camcoords.y,camcoords.z, 360.00, 0.00, 0.00, 60.00, false, 0)
    PointCamAtEntity(cam, veh,0.0,0.0,0.0,1)
    SetCamActive(cam, true)
    local fov = #(camcoords - GetEntityCoords(veh))/2 + 15.0 + #(vector2(size2.y,size2.z)-vector2(size1.y,size1.z)) * 2
    print(fov)
    SetCamFov(cam, fov)
    --SetCamRot(cam, -15.0, 0.0, 252.063)
    RenderScriptCams(true, true, 1, true, true)

end 

local exported = false 

function GenVehicleImages(list)
    DisplayHud(false)
    DisplayRadar(false)
    CreateLocation()
    SetEntityAlpha(PlayerPedId(),0)
    FreezeEntityPosition(PlayerPedId(),true)
    StartScreenShoting(list)
end 

exports("GenVehicleImages",function(...)
    exported = true 
    GenVehicleImages(...)
end) --exports["vImageCreator"]:GenVehicleImages(list)

Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })
Command["startgen"] = function()
    GenVehicleImages(generatelist)
end
