DB = {}

CreateThread(function()
    if Config.EnableMySQL then
        DB.fetchAll = function(query, params)
            return MySQL.Sync.fetchAll(query, params)
        end

        DB.fetchScalar = function(query, params)
            return MySQL.Sync.fetchScalar(query, params)
        end

        DB.execute = function(query, params)
            return MySQL.Sync.execute(query, params)
        end
    end

    if Config.EnableOxMySQL then
        DB.fetchAll = function(query, params)
            return exports['oxmysql']:executeSync(query, params)
        end

        DB.fetchScalar = function(query, params)
            return exports['oxmysql']:scalarSync(query, params)
        end

        DB.execute = function(query, params)
            return exports['oxmysql']:executeSync(query, params)
        end
    end

    if Config.EnableGhMattiMySQL then
        DB.fetchAll = function(query, params)
            return exports['ghmattimysql']:executeSync(query, params)
        end

        DB.fetchScalar = function(query, params)
            return exports['ghmattimysql']:scalarSync(query, params)
        end

        DB.execute = function(query, params)
            return exports['ghmattimysql']:executeSync(query, params)
        end
    end
end)