module.exports = {
  //-- [REQUIRED] IPv4 Address of your teamspeak 3 server
  TSServer: "147.135.104.174",

  //-- [REQUIRED] Port of the ws_server
	//-- Make sure you open the port you specify below
  WSServerPort: 33251,

  //-- [OPTIONAL] IPv4 Address of the ws_server
  //-- Set by autoconfig
  // WSServerIP: "127.0.0.1",

  //-- [OPTIONAL] IPv4 Adress of your FiveM server
  //-- Set by autoconfig if you run ws_server as FXServer resource or standalone on the same machine
   FivemServerIP: "147.135.104.174",

  //-- [OPTIONAL] Port of your FiveM Server
  //-- Set by autoconfig if you run ws_server as FXServer resource
   FivemServerPort: 30120,

  //-- [OPTIONAL] Enable connection/disconnection logs
  enableLogs: false
};
