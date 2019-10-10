--# Cannabis use effects: slight increase in HP + Armor, visual effect for x minutes
--# Required items: lighter, bong/joint or blunt paper, packaged weed
--# Perform animation when smoking, then apply effects
--# by: minipunch
--# OG for: USA REALISM RP (https://usarrp.net)

RegisterNetEvent("drugs:use")
RegisterNetEvent("drugs:cancel")

local wasCanceled = false
local isBusy = false

local anim = {
    rolling = {
        dict = "amb@world_human_partying@female@partying_cellphone@idle_a",
        name = "idle_a"
    },
    smoking = {
        dict = "amb@world_human_smoking_pot@male@idle_a",
        name = "idle_c"
    }
}

--# increase player HP + armor slightly
--# apply visual effects for x minutes
AddEventHandler("drugs:use", function(name)
    local me = PlayerPedId()
    if name == CONFIG.cannabis.itemName then
        if isBusy then 
            exports.globals:notify("You are already rolling!")
            return
        end
        isBusy = true
        -- # playing emote / rolling joint
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < (CONFIG.cannabis.jointRollTimeSeconds) * 1000 and not wasCanceled do 
            exports.globals:DrawTimerBar(startTime, CONFIG.cannabis.jointRollTimeSeconds * 1000, 1.42, 1.475, 'Rolling Joint')
            if not IsEntityPlayingAnim(me, anim.rolling.dict, anim.rolling.name, 3) then
                TriggerEvent("usa:playAnimation", anim.rolling.dict, anim.rolling.name, -8, 1, -1, 16, 0, 0, 0, 0)
                Wait(10)
            end
            Wait(0)
        end

        if wasCanceled then
            wasCanceled = false
            isBusy = false
            return
        end

        StopAnimTask(me, anim.rolling.dict, anim.rolling.name, 1.0)

        exports.globals:notify("You rolled a joint!")
        TriggerServerEvent("drugs:rolledCannabis")

        isBusy = false
    elseif name == CONFIG.joint.itemName then
        if isBusy then 
            exports.globals:notify("You are already smoking!")
            return
        end
        isBusy = true
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < CONFIG.joint.smokeTimeSeconds * 1000 and not wasCanceled do 
            exports.globals:DrawTimerBar(startTime, CONFIG.joint.smokeTimeSeconds * 1000, 1.42, 1.475, 'Consuming')
            if not IsEntityPlayingAnim(me, anim.smoking.dict, anim.smoking.name, 3) then
                TriggerEvent("usa:playAnimation", anim.smoking.dict, anim.smoking.name, -8, 1, -1, 16, 0, 0, 0, 0)
                Wait(10)
            end
            Wait(0)
        end
        StopAnimTask(me, anim.smoking.dict, anim.smoking.name, 1.0)
        if wasCanceled then
            wasCanceled = false
            isBusy = false
            return
        end
        isBusy = false
        ApplyEffects(me)
    end
end)

AddEventHandler("drugs:cancel", function()
    wasCanceled = true
end)

function ApplyEffects(me)
    ApplyHPandArmorBuff(me)
    ApplyVisualEffect(me)
end

function ApplyHPandArmorBuff(me)
    local maxHealth = GetEntityMaxHealth(me)
    SetEntityHealth(me, GetEntityHealth(me) + math.random(0.10*maxHealth, 0.15*maxHealth))
    local maxArmor = GetPlayerMaxArmour(PlayerId())
    local newArmor = GetPedArmour(me) + math.random(0.05*maxArmor, 0.08*maxArmor)
    if newArmor > 0.25 * maxArmor then
        newArmor = 0.25 * maxArmor
        newArmor = math.floor(newArmor)
    end
    SetPedArmour(me, newArmor)
end

function ApplyVisualEffect(me)
    DoScreenFadeOut(1000)
    DoScreenFadeIn(1000)
    
    local visualEffectStr = "HeistCelebPass"
    StartScreenEffect(visualEffectStr, 1000, true)
    SetPedMotionBlur(me, true)

    startTime = GetGameTimer()
    while GetGameTimer() - startTime < CONFIG.joint.effectTimeMinutes * 60 * 1000 do 
        Wait(1)
    end

    SetPedMotionBlur(me, false)
    StopScreenEffect(visualEffectStr)
end

--TODO: create joint object and place in hand when doing joint smoking animation
--TODO: prevent rolling multiple joints simultaneously (to test)