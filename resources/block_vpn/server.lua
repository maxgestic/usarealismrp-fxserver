--------------
--  CONFIG  --
--------------
local kickThreshold = 66        -- Anything equal to or higher than this value will be kicked
local kickReason = 'We\'ve detected that you\'re using a VPN or Proxy. If you believe this is a mistake please visit our Discord #support channel or contact us through our website at https://usarrp.net.'
--local key = "582919-63inb7-06r227-3372e3"
local key = "6903tg-49i57q-3t6171-38c374"
--local testIP = "167.114.5.2" -- VPN Test Case

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
			PerformHttpRequest("http://proxycheck.io/v2/"..playerIP.."?key="..key..'&risk=1&vpn=1', function(statusCode, response, headers)
				if response then
					local resp = json.decode(response)
					if resp[playerIP] then
						if resp[playerIP]["proxy"] == "yes" then
							deferrals.done(kickReason)
						end
						if resp[playerIP]["type"] == "VPN" or resp[playerIP]["type"] == "blacklisted" then
							deferrals.done(kickReason)
						end
						if resp[playerIP]["risk"] and resp[playerIP]["risk"] >= kickThreshold then
							deferrals.done(kickReason)
						end
					end
				end
				deferrals.done()
			end)
		end
	end
end)
