-- Don't MODIFY, just look --
-- Don't MODIFY, just look --
-- Don't MODIFY, just look --
-- Don't MODIFY, just look --

ip = '127.0.0.1'
port = '5984'
auth = "bWluaXB1bmNoOnVzYXJycA=="

-- for my test server at home
-- auth = 'bWluaXB1bmNoOnVzYXJycA=='

exports("getIP", function()
	return ip
end)

exports("getPort", function()
	return port
end)

exports("getAuth", function()
	return auth
end)