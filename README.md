# vImageCreator
Vehicle Image Creator - FIVEM

# Description
- Automatically Generate a Image for All your Vanilla GTA Vehicles or Custom Addon Vehicles

# Installation
- start screenshot-basic
- start vImageCreator
- Setup a Webhook in config (this is where the images will be saved)

# Permission Usage
- Upon restarting the script or starting you need to type the /getperms command
- Permission is configurable via config using your identifiers
- When permission is allowed you can use the following command:
- /startscreenshot (iterate all your vehicle and start generating images) (this may take a while this will screenshot your vehicle one by one)
- /resetscreenshot (reset the index number to 1) (important if you want to start over again)

# Config
- Saving logic uses Json Saveresourcefil or resource KVP
```
Config = {}
Config.DiscordWebHook = 'INSERT WEBHOOK'
Config.save = 'json' -- kvp, json
Config.vehicle_table = 'vehicles' -- vehicle table must have model column (name not hash)
Config.useSQLvehicle = true -- use mysql async to fetch vehicle table else SqlVehicleTable will use
Config.SqlVehicleTable = QBCore and QBCore.Shared and QBCore.Shared.Vehicles and QBCore.Shared.Vehicles or {} -- example qbcore shared vehicle

-- Custom Category
Config.Category = 'all' -- select a custom category | set this to 'all' if you want to Screenshot all vehicle categories

-- Permission
Config.owners = {
    ['license:df845523fc29c5159ece2179359f22a741c2a2ca9a'] = true,
    --add more here
}
```

# thumbnails.json
- this file already contain 740 vanilla vehicle images
- what its left is only for you to generate all your custom addon vehicles

# Usage / How to use this in your resource eg. garage, vehicle shop or any vehicle scripts with UI
- You can use the Global State Variable or you can use the Exports
```
# Exports
local img = exports.vImageCreator:GetModelImage('nissanskyline')
print(img)
-- return
-- url of image or the default image if this model is not yet proccessed
```
# Global State
```
local img = GlobalState.VehicleImages['nissanskyline']
print(img)
--return
-- url of image or the default image if model is not yet proccessed
```
