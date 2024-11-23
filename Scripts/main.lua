ModName = "[Moyogi] SK2Base"
UtilityManagers = {
    --- @class UCustomConsoleManagerAA
    ["Engine"] = FindFirstOf("CustomConsoleManagerAA"),
    --- @class UCustomConsoleManagerAnalytics
    ["Analytics"] = FindFirstOf("CustomConsoleManagerAnalytics"),
    --- @class UCustomConsoleManagerBuild
    ["Build"] = FindFirstOf("CustomConsoleManagerBuild"),
    --- @class UCustomConsoleManagerDC,
    ["Debug"] = FindFirstOf("CustomConsoleManagerDC"),
    --- @class UCustomConsoleManagerRK
    ["PlayerDebug"] = FindFirstOf("CustomConsoleManagerRK"),
    --- @class UCustomConsoleManagerSS
    ["ALife"] = FindFirstOf("CustomConsoleManagerSS"),
    --- @class UCustomConsoleManagerDR
    ["Weather"] = FindFirstOf("CustomConsoleManagerDR")
}

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, NewPawn)
    InitMod()
end )

function InitMod()
    print( "Initializing " .. ModName .. " for the current save" )
end

function GetUtilityManager(type)
    if UtilityManagers[type] == nil then
        return
    end

    return UtilityManagers[type]
end

function GetPlayerUID()
    local playerController = GetPlayerController()
    if not playerController then
        return -1
    end

    local str = tostring(playerController:GetFullName())
    local UID = str:match("C_%d+")

    return UID
end

function GetPlayerController()
    ---@class AStalker2PlayerController
    local controller = FindFirstOf("Stalker2PlayerController")
    if controller == nil then
        print("Failed to find player controller")
    else
        return controller
    end
end

function GetPlayerCharacter()
    --- @class ABP_Stalker2Character_C
    local player = FindFirstOf("BP_Stalker2Character_C")
    if player:IsValid() then
        return player
    else
        print("Failed to find player character")
    end
end

RegisterKeyBind(Key.F5, function()
    local player = GetPlayerController()
    if player then
        --- @class UCustomConsoleManagerRK
        local dbgManager = GetUtilityManager("PlayerDebug")
        if dbgManager and dbgManager:IsValid() then
            local playerUID = GetPlayerUID()
            print("My cool thing: " .. playerUID)
            dbgManager:XModifyBleeding(playerUID, 50)
        end
    end
end )

-- Switch the weather to rain
RegisterKeyBind(Key.F6, function()
    --- @class UCustomConsoleManagerDR
    local weatherManager = GetUtilityManager("Weather")
    if weatherManager and weatherManager:IsValid() then
        weatherManager:XSwitchToWeather(5)
    end
end )