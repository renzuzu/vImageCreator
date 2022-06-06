

This is a rewrite version vImageCreator of renzu from [[UTILS] vImageCreator - Vehicle Image Creator](https://forum.cfx.re/t/utils-vimagecreator-vehicle-image-creator/4775850):
Which is save as base64 thumbnails.json.
Only Support generate under 1024x768 resolution.(otherwise you will get the error message: Reliable network event size overflow) 
It is for developer/local only because images from 'thumbnails.json' will begin rebuild when you start/restart this script.

Github: https://github.com/negbook/vImageCreator

## To Use
1. Set your vehiclelist in generatelist.lua
2. Start/Restart the script(before it , make sure turn your resolution to under 1024x768)
3. Open thumbnails.json in your texteditor / Copy to your other scripts directly.

## To Load in Client

In example resource: 'someResource'
Put these in fxmanifest.lua
```
files {
"somewhere/thumbnails.json"
}
```

```
local cars = json.decode(LoadResourceFile('someResource', 'somewhere/thumbnails.json') or '[]') or {}
for name, base64 in pairs(cars) do 
    print(name,base64)
end 
```
