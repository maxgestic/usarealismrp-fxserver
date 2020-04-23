--------------
--  CONFIG  --
--------------
local kickThreshold = 34        -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
local kickReason = 'We\'ve detected that you\'re using a VPN or Proxy. If you believe this is a mistake please visit our Discord #support channel or contact us through our website at https://usarrp.net.'
local key = "582919-63inb7-06r227-3372e3"
--local testIP = "167.114.5.2" -- VPN Test Case

------- DO NOT EDIT BELOW THIS LINE -------
function splitString(inputstr, sep)
	local t= {}; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	if GetNumPlayerIndices() < GetConvarInt('sv_maxclients', 90) then
		deferrals.defer()
		deferrals.update("Checking Player Information. Please Wait.")
		playerIP = GetPlayerEP(source)
		if string.match(playerIP, ":") then
			playerIP = splitString(playerIP, ":")[1]
		end
		if IsPlayerAceAllowed(source, "blockVPN.bypass") then
			deferrals.done()
		else
			PerformHttpRequest("http://proxycheck.io/v2/"..playerIP.."?key="..key..'&risk=1&vpn=1', function(statusCode, response)
				if response then
					local ipCheckResponse = json.decode(response)
					for key, value in pairs(ipCheckResponse) do
						if key == playerIP then
							for k,v in pairs(value) do
								if k == 'proxy' and v == 'yes' then
									deferrals.done(kickReason)
								elseif k == 'type' and v == 'VPN' then
									deferrals.done(kickReason)
								elseif k == 'risk' and v >= kickThreshold  then
									deferrals.done(kickReason)
								else
									deferrals.done()
								end
							end
						end
					end
				else
					deferrals.done(kickReason)
				end
			end)
		end
	end
end)
