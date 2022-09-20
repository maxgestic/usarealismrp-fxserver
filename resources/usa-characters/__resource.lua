resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
  'cl_characters.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'classes/character.lua',
  'sv_characters.lua'
}

server_exports {
  'SaveCurrentCharacter',
  'CreateNewCharacter',
  'LoadCharactersForSelection',
  'InitializeCharacter',
  'GetCharacter',
  'GetCharacters',
  'GetCharacterField',
  'SetCharacterField',
  'GetNumCharactersWithJob',
  'DoesCharacterHaveItem',
  "GetPlayerIdsWithJob"
}
