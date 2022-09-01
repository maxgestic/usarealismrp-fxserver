--[[
____2.0.1____
* Player who joined the server could only open the crypto when the server owner restarted the script.
(The player was not present in the this.Players, thats why it was fucked up.)

____2.0.2____
* config.lua modified, it is now cleanable and understandable, and events are only loading on serverside if you have the lines inside IsDuplicityVersion
* some undefined error check lines.

____2.0.3____
* Fixed UI loading. (html dependencies downloaded and can be found in the /deps/ folder.)


____3.0.0____
* mysql dependency updated to mysql2 (more updated, less errors)
* Entire crypto got rewrited, now it is more stable.
* Marketcaps now only querying the mysql when the server stars.
* Marketcaps now update realtime when you buy/sell any crypto.
* Export functions has changed a bit, only removeBank/addBank got removed instead we use setBank.
* Notification event changed to export function, and it is handled by one function under the Player class (Player.Notification)
* Shitty formatting in the html got deleted, it always messed up my thinking (the dots, etc.)
* Now you can not sell/buy crypto if the dollar value is less then < 1$. (It did not break anything, but there is no point for this low amount of.)
* NUI (sendCrypto) walletHash did not update when the inserted a non exist target id.
* Some decimal fixes were also made, so it will not give you a huge number 0.0000111111 etc.
* Another export functions are added, if someone wants to add functions to another resource (lua)
* config.lua only loads serverside now.
* and other backend things.

New export functions:
**string** walletHash: avcrypto_getPlayerWalletHash
**int** cryptobalance: avcrypto_getCryptoBalance
**int** cryptoamount: avcrypto_getCryptoAmount
**object** cryptos: avcrypto_getAllCrypto
**void**: avcrypto_open

____3.0.1____
* History / Transactions and other things are attached to a Proxy now. (More performance, we are sending only single datas when update happens.)
* Reduced Server->Client big object sizes. (Chart data only loads data when opening the selected crypto)
* New config: `maximumPlayerTransactions` for limiting the player transaction history in the mysql.
* Histories / Transactions and other things are deleting realtime, do not need to restart the server, it will not overflow your arrays.

____3.0.2____
* Database connection now no need to be set, we are using the mysql-async variable 'set' from the server.cfg. (mysql_connection_string)

]]

--[[
    Documentation: https://docs.aquiver.hu/
    Discord: https://discord.gg/cH6qXQtCgM
    Tebex: https://www.aquiverproducts.eu/
]]

version '3.0.2'
author 'freamee'
description 'Aquiver Crypto'

lua54 'yes'

escrow_ignore {
    '**'
}

server_scripts {
    'config.lua',
    'server/server.js',
    'server/*.lua'
}

client_scripts {
    'client/client.js'
}

dependencies {
    'yarn'
}

ui_page 'html/index.html'

files {
    'html/**',
}

game 'gta5'
fx_version 'adamant'

dependency '/assetpacks'