Config = {}

Config.Debug = false

Config.Webhook = GetConvar("status-channel-webhook", "")
Config.ServerName = 'USA Realism RP'

Config.MessageId = '914841153050902568' --Copy messageid from deployed message and restart script!

Config.UpdateTime = 1000*60*1 -- 1 minute
Config.Use24hClock = true -- false = 12h clock
Config.JoinLink = 'https://cfx.re/join/8kgomm' -- Make sure that JoinLink is URL, like: https://cfx.re/join/xp34mg, currenlty does not support Redm

Config.EmbedColor = 3158326

Config.Locale = 'en'

Config.Locales = {
    ['fi'] = {
        ['date'] = 'Päivä',
        ['time'] = 'Aika',
        ['players'] = 'Pelaajia',
        ['connect'] = 'Yhdistä palvelimelle',
    },
    ['en'] = {
        ['date'] = 'Date',
        ['time'] = 'Time',
        ['players'] = 'Players',
        ['connect'] = 'Connect to server',
    }
}
