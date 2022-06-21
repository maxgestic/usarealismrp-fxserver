local cooldown = 60
local tick = 0
local checkRaceStatus = false
local casinoAudioBank = 'DLC_VINEWOOD/CASINO_GENERAL' -- Do not edit

local betStationLocations = {
    vector3(1098.4444580078, 260.03732299805, -51.240917205811),
    vector3(1097.0583496094, 258.65353393555, -51.240867614746),
    vector3(1096.4876708984, 261.98519897461, -51.240867614746),
    vector3(1095.1190185547, 260.60177612305, -51.240867614746)
}

local function OpenInsideTrack()
    if Utils.InsideTrackActive then
        return
    end

    Utils.InsideTrackActive = true

    -- Scaleform
    Utils.Scaleform = RequestScaleformMovie('HORSE_RACING_CONSOLE')

    while not HasScaleformMovieLoaded(Utils.Scaleform) do
        Wait(0)
    end

    DisplayHud(false)
    SetPlayerControl(PlayerId(), false, 0)

    while not RequestScriptAudioBank(casinoAudioBank) do
        Wait(0)
    end

    Utils:ShowMainScreen()
    Utils:SetMainScreenCooldown(cooldown)

    -- Add horses
    Utils.AddHorses(Utils.Scaleform)

    Utils:DrawInsideTrack()
    Utils:HandleControls()
end

local function LeaveInsideTrack()
    Utils.InsideTrackActive = false

    DisplayHud(true)
    SetPlayerControl(PlayerId(), true, 0)
    SetScaleformMovieAsNoLongerNeeded(Utils.Scaleform)
    ReleaseNamedScriptAudioBank(casinoAudioBank)

    Utils.Scaleform = -1
end

function Utils:DrawInsideTrack()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            local xMouse, yMouse = GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240)

            -- Fake cooldown
            tick = (tick + 10)

            if (tick == 1000) then
                if (cooldown == 1) then
                    cooldown = 60
                end
                
                cooldown = (cooldown - 1)
                tick = 0

                self:SetMainScreenCooldown(cooldown)
            end
            
            -- Mouse control
            BeginScaleformMovieMethod(self.Scaleform, 'SET_MOUSE_INPUT')
            ScaleformMovieMethodAddParamFloat(xMouse)
            ScaleformMovieMethodAddParamFloat(yMouse)
            EndScaleformMovieMethod()

            -- Draw
            DrawScaleformMovieFullscreen(self.Scaleform, 255, 255, 255, 255)
        end
    end)
end

function Utils:HandleControls()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            if IsControlJustPressed(2, 194) then
                LeaveInsideTrack()

                self:HandleBigScreen()
            end

            -- Left click
            if IsControlJustPressed(2, 237) then
                local clickedButton = self:GetMouseClickedButton()

                if self.ChooseHorseVisible then
                    if (clickedButton ~= 12) and (clickedButton ~= -1) then
                        self.CurrentHorse = (clickedButton - 1)
                        self:ShowBetScreen(self.CurrentHorse)
                        self.ChooseHorseVisible = false
                    end
                end

                -- Rules button
                if (clickedButton == 15) then
                    self:ShowRules()
                end

                -- Close buttons
                if (clickedButton == 12) then
                    if self.ChooseHorseVisible then
                        self.ChooseHorseVisible = false
                    end
                    
                    if self.BetVisible then
                        self:ShowHorseSelection()
                        self.BetVisible = false
                        self.CurrentHorse = -1
                    else
                        self:ShowMainScreen()
                    end
                end

                -- Start bet
                if (clickedButton == 1) then
                    self.PlayerBalance = TriggerServerCallback {
                        eventName = "horse-racing:getCurrentChipBalance",
                        args = {}
                    }
                    self:ShowHorseSelection()
                end

                -- Start race
                if (clickedButton == 10) then
                    
                    -- only start race if player has enough for bet here...
                    local hasEnoughToBet = TriggerServerCallback {
                        eventName = "horse-racing:doesHaveEnoughMoney",
                        args = {self.CurrentBet, true}
                    }
                    
                    if hasEnoughToBet then
                        self.CurrentSoundId = GetSoundId()
                        PlaySoundFrontend(self.CurrentSoundId, 'race_loop', 'dlc_vw_casino_inside_track_betting_single_event_sounds')
                        self:StartRace()
                        checkRaceStatus = true
                    else
                        exports.globals:notify("Do not have enough to bet $" .. exports.globals:comma_value(self.CurrentBet))
                    end
                end

                -- Change bet
                if (clickedButton == 8) then
                    if (self.CurrentBet < self.PlayerBalance) then
                        self.CurrentBet = (self.CurrentBet + 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 9) then
                    if (self.CurrentBet > 100) then
                        self.CurrentBet = (self.CurrentBet - 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 13) then
                    self:ShowMainScreen()
                end

                -- Check race
                while checkRaceStatus do
                    Wait(0)

                    local raceFinished = self:IsRaceFinished()

                    if (raceFinished) then
                        StopSound(self.CurrentSoundId)
                        ReleaseSoundId(self.CurrentSoundId)

                        self.CurrentSoundId = -1

                        if (self.CurrentHorse == self.CurrentWinner) then
                            -- Here you can add money
                            -- Exemple
                            -- TriggerServerEvent('myCoolEventWhoAddMoney', self.CurrentGain)
                            while securityToken == nil do
                                Wait(1)
                            end
                            TriggerServerEvent("horse-racing:winMoney", self.CurrentGain, securityToken)

                            -- Refresh player balance
                            self.PlayerBalance = (self.PlayerBalance + self.CurrentGain)
                            self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                        end

                        self:ShowResults()

                        self.CurrentHorse = -1
                        self.CurrentWinner = -1
                        self.HorsesPositions = {}

                        checkRaceStatus = false
                    end
                end
            end
        end
    end)
end

--RegisterCommand('itrack', OpenInsideTrack)

-- iterate thru bet station locations / draw 3d text / listen for keypress
Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        for i = 1, #betStationLocations do
            local dist = #(mycoords - betStationLocations[i])
            if dist <= 10 then
                if not Utils.InsideTrackActive then
                    DrawText3d(betStationLocations[i].x, betStationLocations[i].y, betStationLocations[i].z, "[E] - Open Bet Station")
                    if dist <= 2 then
                        if IsControlJustPressed(0, 38) then
                            OpenInsideTrack()
                        end
                    end
                end
            end
        end
        Wait(1)
    end
end)

function DrawText3d(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 200)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end