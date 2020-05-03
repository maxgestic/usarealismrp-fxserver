--====================================================================================
-- #Author: Jonathan D @ Gannon / modified for CouchDB by minipunch
--====================================================================================

-- make sure DBs exist --
exports["globals"]:PerformDBCheck("gcphone", "twitter-tweets", nil)
exports["globals"]:PerformDBCheck("gcphone", "twitter-accounts", nil)

function TwitterGetTweets (accountId, cb)
  local endpoint = "/twitter-tweets/_design/tweetViews/_view/byCreatedTime?descending=true&limit=130"
  local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
  PerformHttpRequest(url, function(err, responseText, headers)
      if responseText then
        local data = json.decode(responseText)
        if data.rows then
            local tweets = arrayifyDBDocsResponse(data.rows)
            for i = 1, #tweets do
              tweets[i].id = tweets[i]._id -- for front end to read correctly, just renaming id field for now
              if accountId then
                tweets[i].isLikes = hasLikedTweet(tweets[i], accountId)
              end
            end
            cb(tweets)
        else
            cb({})
        end
      end
  end, "GET", "", { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function TwitterGetFavotireTweets (accountId, cb)
  if accountId == nil then
    db.getAllDocumentsFromDbLimit("twitter-tweets", 130, function(docs)
      if docs then
        table.sort(docs, function(a, b) return a.likes > b.likes end)
        for i = 1, #docs do -- see if this account liked this tweet
          docs[i].id = docs[i]._id -- for front end to read correctly, just renaming id field for now
        end
        cb(docs)
      else 
        cb({})
      end
    end)
    --[[
    MySQL.Async.fetchAll([===[
      SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
          ON twitter_tweets.authorId = twitter_accounts.id
      WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], {}, cb)
    --]]
  else
    db.getAllDocumentsFromDbLimit("twitter-tweets", 130, function(docs)
      if docs then
        table.sort(docs, function(a, b) return a.likes > b.likes end)
        for i = 1, #docs do -- see if this account liked this tweet
          docs[i].id = docs[i]._id -- for front end to read correctly, just renaming id field for now
          docs[i].isLikes = hasLikedTweet(docs[i], accountId)
        end
        cb(docs)
      else 
        cb({})
      end
    end)
  end
    --[[
    MySQL.Async.fetchAll([===[
      SELECT twitter_tweets.*,
        twitter_accounts.username as author,
        twitter_accounts.avatar_url as authorIcon,
        twitter_likes.id AS isLikes
      FROM twitter_tweets
        LEFT JOIN twitter_accounts
          ON twitter_tweets.authorId = twitter_accounts.id
        LEFT JOIN twitter_likes 
          ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
      WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], { ['@accountId'] = accountId }, cb)
  end
  --]]
end

function getUser(username, password, cb)
  db.getDocumentById("twitter-accounts", username, function(doc)
    if doc then
      if doc.password == exports.globals:hash256(password) then
        cb(doc)
      else
        cb(nil)
      end
    else 
      cb(nil)
    end
  end)
  --[[
  MySQL.Async.fetchAll("SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password
  }, function (data)
    cb(data[1])
  end)
  --]]
end

function TwitterPostTweet (username, password, message, sourcePlayer, realUser, cb)
  getUser(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    local newTweet = {
      author = user._id,
      authorIcon = user.avatar_url,
      message = message,
      realUser = realUser,
      time = exports.globals:getJavaScriptDateString(exports.globals:currentTimestamp()),
      timeMs = os.time(),
      likes = 0,
      likers = {}
    }
    db.createDocument("twitter-tweets", newTweet, function(docID)
      if docID then
        newTweet["id"] = docID
        TriggerClientEvent('gcPhone:twitter_newTweets', -1, newTweet)
      end
    end)
    --[[
    MySQL.Async.insert("INSERT INTO twitter_tweets (`authorId`, `message`, `realUser`) VALUES(@authorId, @message, @realUser);", {
      ['@authorId'] = user._id,
      ['@message'] = message,
      ['@realUser'] = realUser
    }, function (id)
      MySQL.Async.fetchAll('SELECT * from twitter_tweets WHERE id = @id', {
        ['@id'] = id
      }, function (tweets)
        tweet = tweets[1]
        tweet['author'] = user.author
        tweet['authorIcon'] = user.authorIcon
        TriggerClientEvent('gcPhone:twitter_newTweets', -1, tweet)
        TriggerEvent('gcPhone:twitter_newTweets', tweet)
      end)
    end)
    --]]
  end)
end

function hasLikedTweet(tweet, userId)
  for i = 1, #tweet.likers do
    if tweet.likers[i] == userId then
      return true
    end
  end
  return false
end

function unlikeTweet(tweet, userId)
  for i = 1, #tweet.likers do
    if tweet.likers[i] == userId then
      table.remove(tweet.likers, i)
      return tweet.likers
    end
  end
  return tweet.likers
end

function TwitterToogleLike (username, password, tweetId, sourcePlayer)
  getUser(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    db.getDocumentById("twitter-tweets", tweetId, function(doc)
      if doc then 
        if hasLikedTweet(doc, user._id) then
          doc.likers = unlikeTweet(doc, user._id)
          doc.likes = doc.likes - 1
          TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, doc._id, false)
        else 
          table.insert(doc.likers, user._id)
          doc.likes= doc.likes + 1
          TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, doc._id, true)
        end
        db.updateDocument("twitter-tweets", tweetId, { likes = doc.likes, likers = doc.likers }, function(doc, err, rText) end)
        TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, doc._id, doc.likes)
      else 
        print("invalid tweet id: " .. tweetId)
      end
    end)
    --[[
    MySQL.Async.fetchAll('SELECT * FROM twitter_tweets WHERE id = @id', {
      ['@id'] = tweetId
    }, function (tweets)
      if (tweets[1] == nil) then return end
      local tweet = tweets[1]
      MySQL.Async.fetchAll('SELECT * FROM twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId', {
        ['authorId'] = user.id,
        ['tweetId'] = tweetId
      }, function (row) 
        if (row[1] == nil) then
          MySQL.Async.insert('INSERT INTO twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)', {
            ['authorId'] = user.id,
            ['tweetId'] = tweetId
          }, function (newrow)
            MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes + 1 WHERE id = @id', {
              ['@id'] = tweet.id
            }, function ()
              TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes + 1)
              TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, true)
              TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes + 1)
            end)    
          end)
        else
          MySQL.Async.execute('DELETE FROM twitter_likes WHERE id = @id', {
            ['@id'] = row[1].id,
          }, function (newrow)
            MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes - 1 WHERE id = @id', {
              ['@id'] = tweet.id
            }, function ()
              TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes - 1)
              TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, false)
              TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes - 1)
            end)
          end)
        end
      end)
    end)
    --]]
  end)
end

function TwitterCreateAccount(username, password, avatarUrl, cb)
  -- search for account with username
  db.getDocumentById("twitter-accounts", username, function(doc)
    if doc then
      cb(false)
    else
      -- only create if account doesn't exist already
      local newAccount = {
        password = exports.globals:hash256(password),
        avatar_url = avatarUrl
      }
      db.createDocumentWithId("twitter-accounts", newAccount, username, function(ok)
        cb(ok)
      end)
    end
  end)
  --[[
  MySQL.Async.insert('INSERT IGNORE INTO twitter_accounts (`username`, `password`, `avatar_url`) VALUES(@username, @password, @avatarUrl)', {
    ['username'] = username,
    ['password'] = password,
    ['avatarUrl'] = avatarUrl
  }, cb)
  --]]

end
-- ALTER TABLE `twitter_accounts`	CHANGE COLUMN `username` `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci';

function TwitterShowError (sourcePlayer, title, message)
  TriggerClientEvent('gcPhone:twitter_showError', sourcePlayer, message)
end
function TwitterShowSuccess (sourcePlayer, title, message)
  TriggerClientEvent('gcPhone:twitter_showSuccess', sourcePlayer, title, message)
end

RegisterServerEvent('gcPhone:twitter_login')
AddEventHandler('gcPhone:twitter_login', function(username, password)
  local sourcePlayer = tonumber(source)
  getUser(username, password, function (user)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    else
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_SUCCESS')
      TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, user.avatar_url)
    end
  end)
end)

RegisterServerEvent('gcPhone:twitter_changePassword')
AddEventHandler('gcPhone:twitter_changePassword', function(username, password, newPassword)
  local sourcePlayer = tonumber(source)
  getUser(username, password, function (user)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
    else
      newPassword = exports.globals:hash256(newPassword)
      db.updateDocument("twitter-accounts", username, { password = newPassword }, function(ok) end)
      --[[
      MySQL.Async.execute("UPDATE `twitter_accounts` SET `password`= @newPassword WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
        ['@username'] = username,
        ['@password'] = password,
        ['@newPassword'] = newPassword
      }, function (result)
        if (result == 1) then
          TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, newPassword, user.authorIcon)
          TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_SUCCESS')
        else
          TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
        end
      end)
      --]]
    end
  end)
end)


RegisterServerEvent('gcPhone:twitter_createAccount')
AddEventHandler('gcPhone:twitter_createAccount', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  TwitterCreateAccount(username, password, avatarUrl, function (ok)
    if ok then
      TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_ERROR')
    end
  end)
end)

RegisterServerEvent('gcPhone:twitter_getTweets')
AddEventHandler('gcPhone:twitter_getTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getUser(username, password, function (user)
      local accountId = user._id
      TwitterGetTweets(accountId, function (tweets)
        TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
      end)
    end)
  else
    TwitterGetTweets(nil, function (tweets)
      TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
    end)
  end
end)

RegisterServerEvent('gcPhone:twitter_getFavoriteTweets')
AddEventHandler('gcPhone:twitter_getFavoriteTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getUser(username, password, function (user)
      local accountId = user._id
      TwitterGetFavotireTweets(accountId, function (tweets)
        TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
      end)
    end)
  else
    TwitterGetFavotireTweets(nil, function (tweets)
      TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
    end)
  end
end)

RegisterServerEvent('gcPhone:twitter_postTweets')
AddEventHandler('gcPhone:twitter_postTweets', function(username, password, message)
  local sourcePlayer = tonumber(source)
  local srcIdentifier = getPlayerID(source)
  TwitterPostTweet(username, password, message, sourcePlayer, srcIdentifier)
end)

RegisterServerEvent('gcPhone:twitter_toogleLikeTweet')
AddEventHandler('gcPhone:twitter_toogleLikeTweet', function(username, password, tweetId)
  local sourcePlayer = tonumber(source)
  TwitterToogleLike(username, password, tweetId, sourcePlayer)
end)


RegisterServerEvent('gcPhone:twitter_setAvatarUrl')
AddEventHandler('gcPhone:twitter_setAvatarUrl', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  db.updateDocument("twitter-accounts", username, { avatar_url = avatarUrl }, function(ok)
    if ok then
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
  end)
  --[[
  MySQL.Async.execute("UPDATE `twitter_accounts` SET `avatar_url`= @avatarUrl WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password,
    ['@avatarUrl'] = avatarUrl
  }, function (result)
    if (result == 1) then
      TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
  end)
  --]]
end)


--[[
  Discord WebHook
  set discord_webhook 'https//....' in config.cfg
--]]
--[[
AddEventHandler('gcPhone:twitter_newTweets', function (tweet)
  -- print(json.encode(tweet))
  local discord_webhook = GetConvar('discord_webhook', '')
  if discord_webhook == '' then
    return
  end
  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = tweet.author,
    ["embeds"] = {{
      ["thumbnail"] = {
        ["url"] = tweet.authorIcon
      },
      ["color"] = 1942002,
      ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", tweet.time / 1000 )
    }}
  }
  local isHttp = string.sub(tweet.message, 0, 7) == 'http://' or string.sub(tweet.message, 0, 8) == 'https://'
  local ext = string.sub(tweet.message, -4)
  local isImg = ext == '.png' or ext == '.pjg' or ext == '.gif' or string.sub(tweet.message, -5) == '.jpeg'
  if (isHttp and isImg) and true then
    data['embeds'][1]['image'] = { ['url'] = tweet.message }
  else
    data['embeds'][1]['description'] = tweet.message
  end
  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)
--]]