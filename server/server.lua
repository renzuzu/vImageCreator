local resultVehicles
local thumbs = {}

RegisterCommand('getperms', function(source, args, rawCommand)
    for i = 0 , GetNumPlayerIdentifiers(source) do
        if GetPlayerIdentifier(source,i) and Config.owners[GetPlayerIdentifier(source,i)] then
            local ply = Player(source).state
            ply.screenshotperms = true
            print("Player ID: "..source.." Granted Permission to use Screenshot Vehicle \n Commands: \n Start Screen Shot Vehicle /startscreenshot \n Reset screenshot index (last vehicle number for continuation purpose) /resetscreenshot")
        end
    end
end)

Citizen.CreateThread(function()
    if Config.save == 'kvp' then
        thumbs = json.decode(GetResourceKvpString('thumbnails') or '[]') or {}
    else
        thumbs = json.decode(LoadResourceFile('vImageCreator', 'thumbnails.json') or '[]') or {}
    end
    if Config.useSQLvehicle then
        resultVehicles = MySQL.Sync.fetchAll('SELECT * FROM '..Config.vehicle_table)
    else
        resultVehicles = SqlVehicleTable
    end
    local temp = {}
    if Config.Category ~= 'all' then
        for k,v in pairs(resultVehicles) do
            if v.category == Config.Category then
                table.insert(temp,v)
            end
        end
    else
        temp = resultVehicles
    end
    GlobalState.VehiclesFromDB = temp
    local thumbtemp = {}
    local c = 0
    for k,v in pairs(thumbs) do
        local k = tostring(k)
        thumbtemp[k] = v
        c = c + 1
    end
    GlobalState.VehicleImages = thumbtemp
end)

RegisterNetEvent("renzu_vehthumb:save")
AddEventHandler("renzu_vehthumb:save", function(data)
    local modelhash = GetHashKey(data.model)
    thumbs[tostring(modelhash)] = data.img
    if Config.save == 'kvp' then
        SetResourceKvp('thumbnails',json.encode(thumbs))
    else
        SaveResourceFile("vImageCreator", "thumbnails.json", json.encode(thumbs), -1)
    end
    GlobalState.VehicleImages = thumbs
end)