Config = {}

--If you dont use esx nor use qbus set UseESX to false and UseQBUS to false
--You can then use the identifier whitelist or the role whitelist

--If you use esx enable this
Config.UseESX = false

--If you use qbus enable this
Config.UseQBUS = false

--Required Job To Use The FireHose
Config.JobName = "fire"

--Standalone identifier whitelist
--Set UseWhitelist To True To Use The Whitelist
Config.UseWhitelist = true