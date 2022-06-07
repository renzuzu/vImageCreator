local M = {
    encode = PreLibDeflate.encode ,
    decode = PreLibDeflate.decode ,
    encodeNumber = PreLibDeflate.encodeNumber ,
    decodeNumber = PreLibDeflate.decodeNumber ,
    encodeSql = PreLibDeflate.encodeToSQL  ,
    decodeSql = PreLibDeflate.decodeFromSQL
}

local thumbs = {}

RegisterNetEvent("nbk_renzu_vehthumb:save")
AddEventHandler("nbk_renzu_vehthumb:save", function(data)
    local modelhash = GetHashKey(data.model)
    thumbs[tostring(modelhash)] = M.decode(data.img)
    SaveResourceFile("vImageCreator", "thumbnails.json", json.encode(thumbs), -1)
    local b = M.decode(data.img)
    SaveResourceFile("vImageCreator", "/results/"..modelhash..".base64.txt", b, -1)
    exports["vImageCreator"]:base64toimage(GetResourcePath(GetCurrentResourceName()).."/results/"..modelhash..".jpeg",b)
end)
