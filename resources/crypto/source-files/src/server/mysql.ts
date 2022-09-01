import mysql from 'mysql2';
import { AquiverCrypto } from './server-crypto';
import URL from 'url';

export const Database = new (class _ {
    private db: mysql.Connection;
    public connected: boolean = false;

    constructor() {
        console.info('Connecting to Mysql server...');

        const globalSettings = this.getConfigFromConnectionString();

        let connectionSettings: mysql.ConnectionOptions = {
            host: globalSettings.host,
            database: globalSettings.database,
            user: globalSettings.user,
            port: globalSettings.port,
            supportBigNumbers: true,
        };

        /** Set password to a value, if its set. */
        if (globalSettings.password) {
            connectionSettings.password = globalSettings.password;
        }

        this.db = mysql.createConnection(connectionSettings);

        this.db.connect((err) => {
            if (err) {
                console.error('Database could not connect.');
                console.error(err);
                return;
            }

            console.info('Database successfully connected!');
            AquiverCrypto.__init__();
            this.connected = true;
        });
    }
    query(query: string, callback?: Function) {
        this.db.query(query, function (err, rows, fields) {
            typeof callback == 'function' && callback(err, rows, fields);
        });
    }
    private getConfigFromConnectionString() {
        const connectionString = GetConvar('mysql_connection_string', 'mysql://root@localhost/fivem');
        let cfg: Partial<URL.UrlWithParsedQuery> = {};

        if (/(?:database|initial\scatalog)=(?:(.*?);|(.*))/gi.test(connectionString)) {
            const connectionStr = connectionString
                .replace(/(?:host|server|data\s?source|addr(?:ess)?)=/gi, 'host=')
                .replace(/(?:port)=/gi, 'port=')
                .replace(/(?:user\s?(?:id|name)?|uid)=/gi, 'user=')
                .replace(/(?:password|pwd)=/gi, 'password=')
                .replace(/(?:database|initial\scatalog)=/gi, 'database=');
            connectionStr.split(';').forEach((el) => {
                const equal = el.indexOf('=');
                const key = equal > -1 ? el.substr(0, equal) : el;
                const value = equal > -1 ? el.substr(equal + 1) : '';
                cfg[key.trim()] = Number.isNaN(Number(value)) ? value : Number(value);
            });

            return {
                port: (cfg as any).port || 3306,
                host: (cfg as any).host || 'localhost',
                user: (cfg as any).user || 'root',
                database: (cfg as any).database || 'fivem',
                password: (cfg as any).password || null,
            };
        } else if (/mysql:\/\//gi.test(connectionString)) {
            cfg = URL.parse(connectionString, true);

            return {
                port: parseInt(cfg.port) || 3306,
                host: cfg.host || 'localhost',
                database: cfg.pathname?.substring(1) || 'fivem',
                user: cfg.auth?.split(':')[0] || 'root',
                password: cfg.auth?.split(':')[1] || null,
            };
        }
    }
})();
