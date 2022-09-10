translations = {
    GENERAL_CRYPTO = 'sCoin',
    GENERAL_PERSON_SINGULAR = 'inimene',
    GENERAL_PERSON_PLURAL = 'inimest',

    NOTIFICATION_TABLET_CONTRACT_STARTED = 'Alustasid tööotsaga. Vajalik informatsioon on märgitud sinu GPSile..',
    NOTIFICATION_TABLET_ORDER_SUCCESSFUL = 'Tellimus oli edukas, kauba saad kätte Mirror Parkis asuvast varuosade poest. Tellimust ei hoita poes kaua!',
    NOTIFICATION_TABLET_IN_QUEUE = 'Alustasid tööotsade vastu võtmist.',
    NOTIFICATION_TABLET_OUT_OF_QUEUE = 'Lõpetasid tööotsade vastu võtmise.',
    NOTIFICATION_TABLET_ALREADY_ACTIVE = 'Sul juba on aktiivne tööots!',
    NOTIFICATION_TABLET_NO_CRYPTO = 'Sul pole tööotsa vastu võtmiseks piisavalt krüptot.',

    NOTIFICATION_GAME_GPS_TRACKER_INSTALLED = 'Sõidukile on paigaldatud GPS seade. Kuniks GPS seade pole eemaldatud, saab politsei sinu asukoha kohta teateid.',
    NOTIFICATION_GAME_VEHICLE_HACKED = 'Sõiduki häkkimine õnnestus.',
    NOTIFICATION_GAME_VEHICLE_OPENED = 'Sõiduk avatud.',
    NOTIFICATION_GAME_HACKING_FAILED = 'Häkkimine ei õnnestunud!',
    NOTIFICATION_GAME_HACKING_VEHICLE_NOT_FOUND = 'Pole sõidukit, mida häkkida!',
    NOTIFICATION_GAME_HACKING_STARTING = 'Alustad sõidukisse häkkimisega..',
    NOTIFICATION_GAME_NOT_IN_VEHICLE = 'Sa ei ole sõidukis!',
    NOTIFICATION_GAME_INVALID_VEHICLE = 'Ma ei soovi seda sõidukit!',
    NOTIFICATION_GAME_DROP_OFF_TOO_FAR = 'Sõida diilerile lähemale.',

    NOTIFICATION_GAME_HACK_SUCCESSFUL = 'GPS seadme edastamissagedust pikendatud %d sekundi võrra. Tehtud on %d/%d häkkimist.',
    NOTIFICATION_GAME_NO_GPS_DEVICE = 'Sellel autol ei ole GPS seadet, mida häkkida.',
    NOTIFICATION_GAME_HACK_COOLDOWN = 'Järgmine häkkimine on võimalik %d sekundi pärast.',
    NOTIFICATION_GAME_HACK_STARTED = 'Alustasid sõiduki GPS süsteemi häkkimisega.',
    NOTIFICATION_GAME_GPS_STOPPED = 'Suutsid GPS seadme edastamise lõpetada.',
    NOTIFICATION_GAME_POLICE_GPS_STOPPED = 'Auto GPS saatja ei anna enam signaali - sõiduki asukoht teadmata.',

    NOTIFICATION_GAME_NOT_HACKED = 'Sa pead enne minule toimetamist selle GPSi eemaldama!',
    NOTIFICATION_GAME_LATE_DELIVERY = 'Tundub, et jäid sõiduki kohaletoimetamisega hiljaks. Tööots ebaõnnestus.',
    NOTIFICATION_GAME_SUCCESSFUL_DELIVERY = 'Said eduka tööotsa eest $%d ning %d %s',
    NOTIFICATION_GAME_PENALIZED_DELIVERY = 'Said tööotsa eest $%d vähem kui pidanuks, sest auto oli kahjustatud.',
    NOTIFICATION_GAME_SUCCESSFUL_VIN_DELIVERY = 'Isik läheb kraabib autolt VIN koodi maha ning toimetab auto garaaži.',

    LABEL_MAP_BLIP_DELIVER_HERE = 'Toimeta sõiduk siia',
    LABEL_MAP_VEHICLE_LOCATION = 'Sõiduki asukoht',

    INTERACTION_VEHICLE_DROP_OFF = '[E] - Toimeta sõiduk kohale',
    INTERACTION_OPEN_STORE = '[E] - Vaata oma tellimusi',
    NOTIFICATION_GAME_STORE_TOO_FAR = 'Mine poele lähemale.',

    TEXT_STORE_MENU_TITLE = 'Sinu tellimused',
    NOTIFICATION_GAME_NO_ORDERS = 'Sul ei ole ühtegi tellimust ootamas.',
    NOTIFICATION_GAME_ORDER_ACCEPTED = 'Võtsid tellimuse vastu.',

    NOTIFICATION_TABLET_NO_MONEY_FOR_ORDER = 'Sul ei ole tellimuse jaoks piisavalt raha!',
    NOTIFICATION_TABLET_NO_CRYPTO_FOR_ORDER = 'Sul ei ole tellimuse jaoks piisavalt krüptot!',
    NOTIFICATION_TABLET_ITEM_ALREADY_ORDERED = 'Sa oled selle eseme juba tellinud!',

    NOTIFICATION_TABLET_ERROR_NAME_LENGTH = 'Nime pikkus peab olema 3-15 tähemärki pikk.',
    NOTIFICATION_TABLET_INFO_NAME_CHANGED = 'Nimi edukalt vahetatud.',
    NOTIFICATION_TABLET_ERROR_PICTURE_FORMAT = "Profiilipilt peab olema formaadis 'https://i.imgur.com.........jpg/png'",
    NOTIFICATION_TABLET_INFO_PICTURE_CHANGED = 'Profiilipilt edukalt vahetatud.',

    NOTIFICATION_TABLET_INFO_ADMIN_GENERATED = 'Tööotsad genereeritud järjekorras olevatele mängijatele (%d %s)..',
    NOTIFICATION_TABLET_ERROR_ADMIN_CONTRACT_IDENTIFIER_MISSING = 'Tööotsa andmiseks on vajalik sisestada mängija identifikaator.',
    NOTIFICATION_TABLET_ERROR_ADMIN_IDENTIFIER_INVALID = 'Tahvelarvuti süsteemist ei leitud sellise identifikaatoriga mängijat.',
    NOTIFICATION_TABLET_INFO_ADMIN_CONTRACT_GIVEN = "Mängijale identifikaatoriga '%s' on antud %s klassi tööots.",
    NOTIFICATION_TABLET_ERROR_ADMIN_DATA_IDENTIFIER_MISSING = 'Andmete laadimiseks on vajalik sisestada mängija identifikaator.',
    NOTIFICATION_TABLET_INFO_ADMIN_DATA_LOADED = "Mängija identifikaatoriga '%s' andmed edukalt laetud.",
    NOTIFICATION_TABLET_INFO_ADMIN_DATA_SAVED = "Mängija identifikaatoriga '%s' andmed salvestatud.",
    NOTIFICATION_TABLET_INFO_CONTRACT_TRANSFERRED = "Tööots on edukalt määratud mängijale identifikaatoriga '%s'.",
    NOTIFICATION_TABLET_ERROR_RECIPIENT_LEVEL = "Isikul ei ole tööotsa vastu võtmiseks piisavalt kõrge tase.",

    TEXT_INPUT_DIALOG_VIN_SCRATCH = 'Sul on võimalik see auto endale osta %d %s eest. Auto saab täiesti sinu omaks, kuid tööline kraabib VIN koodi maha. Seetõttu eemaldatakse see sõiduk sinult siis, kui see impoundi satub või kaduma läheb.',
    TEXT_INPUT_DIALOG_TRANSFER = 'Sul on võimalik see tööts kellelegi teisele saata. Selle tegemiseks pead sisestama teise osapoole isikukoodi.',
    TEXT_INPUT_DIALOG_IDENTIFIER = 'Isikukood',
    TEXT_PROFILE_DEFAULT_NAME = 'Kasutaja %d'
}
