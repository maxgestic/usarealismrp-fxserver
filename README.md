## USA Realism RP Codebase

To get started with your own testing environment:
1) Download and install [couchDB](http://couchdb.apache.org/)
    * Open a browser and navigate to `<ip>:<port>` to open your couchDB instance
        - `ip` is `127.0.0.1` if you're running couchDB locally
        - Default `port` is `5984`
    * Go to "Your Account" and create an admin account
    * Base64 encode your username and password in the format `username:password`
        - Save it for the next step
    * Create databases named `bans`, `correctionaldepartment`, `properties`, `warrants`, 'phones', and `whitelist`
        - Temporary step, these need to be auto created
2) Create the file `resources/essentialmode/sv_es-DB-config.lua`  
    * Set the variable `ip` to your couchDB IP
    * Set the variable `port` your couchDB port
    * Set your base64 encoded credentials to the variable `auth`
3) Create the file `server_internal.cfg` in the project root directory
    * write `sv_hostname <server name>`, replacing `<server name>` with a name of your choice
    * write `sv_licenseKey <license key>`, replacing `<license key>` with a [FiveM license key](https://keymaster.fivem.net/)
4) Create the path `C:/wamp/www/` to house the auto generated chat log file
    * Temporary step, path should be auto generated
