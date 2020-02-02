## USA Realism RP Codebase

To get started with your own testing environment:
1) Download and install [couchDB](http://couchdb.apache.org/)
    * Open a browser and navigate to `<ip>:<port>` to open your couchDB instance
        - `ip` is `127.0.0.1` if you're running couchDB locally
        - Default `port` is `5984`
    * Go to "Your Account" and create an admin account
    * Base64 encode your username and password in the format `username:password`
        - Save it for the next step
2) Create the file `resources/essentialmode/sv_es-DB-config.lua`  
    * Set the variable `ip` to your couchDB IP
    * Set the variable `port` your couchDB port
    * Set your base64 encoded credentials to the variable `auth` as a string
3) Create the file `server_internal.cfg` in the project root directory
    * write `sv_hostname <server name>`, replacing `<server name>` with a name of your choice
    * write `sv_licenseKey <license key>`, replacing `<license key>` with a [FiveM license key](https://keymaster.fivem.net/)
4) Create the path `C:/wamp/www/` to house the auto generated chat log file
    * Temporary step, path should be auto generated
5) Create your database views
6) You can start the server with ``..\run.cmd +exec server.cfg`` from the ``server-data`` folder instead of using the start.bat file to avoid scrambling

**Job Types**
1. "civ"
2. "sheriff" (AKA SASP)
3. "ems"
4. "corrections"
5. "judge"
6. "taxi"
7. "tow"
8. "reporter" (weazel news)
9. "chickenFactory"
10. "gopostal"
11. ... could be more ...

**DB Notes**
1)  Must create following couch db views in a ``vehicleFilters`` design doc in a ``vehicles`` db:  
	* **getMakeModelOwner**  
		- ``emit(doc._id, [doc.owner, doc.make, doc.model]);``  
	* **getMakeModelPlate**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model]);``  
	* **getVehicleCustomizationsByPlate**  
		- ``emit(doc._id, [doc.customizations]);``  
	* **getVehicleInventoryAndCapacityByPlate** 
		- ``emit(doc._id, [doc.inventory, doc.storage_capacity]);``  
	* **getVehicleInventoryByPlate**  
		- ``emit(doc._id, [doc.inventory]);``  
	* **getVehiclesForGarageMenu**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model, doc.impounded, doc.stored, doc.hash, doc.owner, doc.stats, doc.upgrades]);``  
	* **getVehiclesForMenuWithPlates**  
		- ``emit(doc._id, [doc.make, doc.model, doc.price, doc.stored, doc.stored_location, doc._id]);``  
	* **getVehiclesToSellWithPlates**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model, doc.price, doc._rev]);``
2) Must create following couch db views in a ``phoneFilters`` design doc in a ``phones`` db:
	* **getConversationsByNumber**
		- ``emit(doc._id, doc.conversations);``
	* **getContactsByNumber**
		- ``emit(doc._id, doc.contacts);``
3) Must create following couch db views in a ``characterFilters`` design doc in a ``characters``:
	* **getCharactersForSelectionBySteamID**
		- ``emit(doc.created.ownerIdentifier, [doc._id, doc._rev, doc.name, doc.dateOfBirth, doc.money, doc.bank, doc.spawn, doc.created.time]);``
