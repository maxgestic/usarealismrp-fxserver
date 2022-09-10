Installation process of the RAHE Boosting System.

> Requirements (both available for download at https://github.com/overextended):
* oxmysql (minimum version 2.0.0)
* ox_lib (minimum version 2.3.3)

>Strongly recommended:
* Latest MariaDB as your database (some older MySQL versions might have issues)
* Basic knowledge of coding

>Installing rahe-hackingdevice:
1. Move 'rahe-hackingdevice' into your server resources folder
2. Add 'ensure rahe-hackingdevice' to your server config

**Wish to use rahe-hackingdevice in your own scripts? Use it in client-side as follows:**

`TriggerEvent('rahe-hackingdevice:start-hacking', hackType, gameType, duration, callback)`

* hackType: RANDOM, NUMERIC, ALPHABET, ALPHANUMERIC, GREEK, BRAILLE, RUNES
* gameType: RANDOM, NORMAL, MIRRORED

Example: 
```
local function hackCallback(result)
    print('Hacking result is: ', result)
end

TriggerEvent('rahe-hackingdevice:start-hacking', 'RANDOM', 'RANDOM', 20, hackCallback)
```

>Installing rahe-boosting:
1. Make sure you have installed rahe-hackingdevice described in the previous chapter
2. Move 'rahe-boosting' into your server resources folder
3. Run the SQL file 'db.sql' in your database client (HeidiSQL recommended)
4. Add 'ensure rahe-boosting' to your server config
5. Open the file 'shared.lua' in the folder rahe-boosting/config
6. On line 4, set the framework you are using:
    * If you're using ESX, set line 4 to: framework = 'ESX'
    * If you're using QB, set line 4 to: framework = 'QB'.
      Also open qb-policejob, find an event called 'police:server:UpdateCurrentCops'. Add the following line to the end of the function: 'TriggerEvent('police:SetCopCount', amount)'.
      This makes the script send a server-side event needed for our boosting script.
    * If you're using any other framework (or custom), set line 4 to: framework = 'CUSTOM'

>Resource starting order (ox_lib should start first):
1. ox_lib
2. rahe-hackingdevice
3. rahe-boosting

>Unencrypted, editable files in rahe-boosting:
* /api/client.lua
* /api/server.lua
* /config/client.lua
* /config/server.lua
* /config/shared.lua
* /public/client.lua
* /public/server.lua
* /config/translations.lua
* /tablet/nui/index.html
* /tablet/nui/translations.js

>Using rahe-boosting:
* Commands available:
    * /boosting - Opens the boosting tablet
    * /usehackingdevice - Hacking device use (on A & S class boosts to get into the vehicle & start the vehicle)
    * /usegpshackingdevice - GPS hacking device use (on A & S class boosts to disable the GPS tracker)

  These commands can be made into items. Examples are provided in the API files depending on your framework.


>If you're encountering errors, these might be your mistakes:
* You are not running oxmysql version of at least 2.0.0. Check your version in oxmysql/fxmanifest.lua
* You downloaded ox_lib source, not release. You must download the release from https://github.com/overextended/ox_lib/releases (ox_lib.zip)
* You downloaded oxmysql source, not release. You must download the relase from https://github.com/overextended/oxmysql/releases (oxmysql.zip)


>**IMPORTANT!**
**THESE THINGS ARE NOT IMPLEMENTED BY DEFAULT BECAUSE EVERYONE HAS DIFFERENT IMPLEMENTATIONS**

THINGS TO INTEGRATE YOURSELF:

* Make the tablet, hacking device, GPS hacking device items (instead of commands).
* Make the items available for players (so they can get them from somewhere).
* Fill out the 'giveItem' function so your players would receive items from the store.
* Fill out the 'rahe-boosting:server:vinScratchSuccessful' event to give the player the boosted vehicle
* Fill out the 'rahe-boosting:client:importantBoostStarted' event to send a dispatch call to police about a new boost
* Fill out the 'rahe-boosting:client:giveKeys' event so the player would receive the vehicle keys after hacking an important class vehicle.
* Make VIN scratched vehicles different from normal vehicles when you insert them into DB, for example set is_stolen = 1
* Use the is_stolen field to not display the vehicles in police MDT
* Use the is_stolen field to not allow the vehicle to be sold to other players
* Use the is_stolen field to permanently delete the vehicle when it despawns in game
* The process of doing A/S class boosts:
    * Hack the locked door using the 'hacking device' and complete the minigame. Disable lockpicking!
    * Start the engine using the 'hacking device' and complete the minigame. Disable lockpicking!
    * Disable the tracker using the 'GPS hacking device', complete the minigame 10-20 times
    * Deliver the vehicle
    * If you have a lockpick script, you must not allow A/S boost vehicles to be lockpicked/started!
      To counter this, use the data in that vehicle statebag to stop the lockpicking. Implement this into your inventor/lockpick script. An example:
      ```
      local boostingInfo = Entity(targetVehicle).state.boostingData
      if boostingInfo ~= nil and boostingInfo.advancedSystem then
          TriggerEvent("yourNotificationEvent", 'You need a proffessional system to lockpick this vehicle!')
          return 
      end
      ```


* Boosting vehicles contain data in state bags, called 'boostingData'. Print the statebag out yourself ingame to see all the data it contains.
* Use the data in boostingData statebag to stop other players from taking foreign boosting cars. It's very demotivating if you're searching for a car for an hour, and then discover that someone else has taken it. boostingData has the owner player identifier in it. An example:
     ```
    local boostingInfo = Entity(targetVehicle).state.boostingData
    if boostingInfo ~= nil and boostingInfo.cid ~= getPlayerIdentifier(src) then
        TriggerEvent("yourNotificationEvent", 'This vehicle is not meant for you!')
        return 
    end
    ```

Join our Discord for support and future updates / patch notes: https://discord.gg/Ckm4tVbmRE