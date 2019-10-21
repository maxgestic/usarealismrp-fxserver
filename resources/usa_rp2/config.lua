-- Chat log file --
local LOG_FILE_PATH = "C:/wamp/www/log.txt"

exports("GetLogFilePath", function()
	return LOG_FILE_PATH
end)
