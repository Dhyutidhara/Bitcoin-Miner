local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Dhyutidhara/Utils/main/UI/Gerard/Library.lua", true))()

local function FireProximityPrompt(ProximityPromptObj, n, ShouldSkipHold)
    if ProximityPromptObj.ClassName == "ProximityPrompt" then
        n = n or 1
        local PromptTime = ProximityPromptObj.HoldDuration
        if ShouldSkipHold then
            ProximityPromptObj.HoldDuration = 0
        end
        for i = 1, n do
            ProximityPromptObj:InputHoldBegin()
            if not ShouldSkipHold then
                wait(ProximityPromptObj.HoldDuration)
            end
            ProximityPromptObj:InputHoldEnd()
        end
        ProximityPromptObj.HoldDuration = PromptTime
    else
        error("userdata<ProximityPrompt> expected")
    end
end

local MainWindow = Library:CreateWindow("Farming")
local BoostsAndCratesWindow = Library:CreateWindow("Boosts & Crates")
local CrystaliserWindow = Library:CreateWindow("Crystaliser")

local GamePlayers = game:GetService("Players")
local GameWorkspace = game:GetService("Workspace")
local GameReplicatedStorage = game:GetService("ReplicatedStorage")

local IMightKillMyselfCauseOfThis = {
    ["Boosts"] = {
        ["WaitingTime"] = {
            ["15 min Mining Boost"] = 930,
            ["30 min Mining Boost"] = 1830,
            ["1H Mining Boost"] = 3630,
            ["15 min Xp Boost"] = 930,
            ["30 min Xp Boost"] = 1830,
            ["1 H Xp Boost"] = 3630,
            ["45 min Offline Mining Boost"] = 2730,
            ["1H Offline Mining Boost"] = 3630,
            ["1H 30M Offline Mining Boost"] = 5430,
            ["15 min Server Mining Boost"] = 930,
            ["30 min Server Mining Boost"] = 1830,
            ["1H Server Mining Boost"] = 3630
        }
    }
}
local Boosts = {
    "15 min Mining Boost", "30 min Mining Boost", "1H Mining Boost", "15 min Xp Boost", "30 min Xp Boost", "1 H Xp Boost", "45 min Offline Mining Boost",
    "1H Offline Mining Boost", "1H 30M Offline Mining Boost", "15 min Server Mining Boost", "30 min Server Mining Boost", "1H Server Mining Boost"
}

MainWindow:Toggle("Auto Exchange Bitcoin", {
    flag = 'ExchangeBitcoin'
}, function(new)
    while wait() and MainWindow.flags.ExchangeBitcoin do
        GameReplicatedStorage.Events.ExchangeMoney:FireServer(unpack({[1] = true}))
    end
end)

MainWindow:Toggle("Auto Exchange Solaris", {
    flag = 'ExchangeSolaris'
}, function(new)
    while wait() and MainWindow.flags.ExchangeSolaris do
        GameReplicatedStorage.Events.ExchangeMoney:FireServer(unpack({[1] = false}))
    end
end)

MainWindow:Toggle("Auto Change Algorithm", {
    flag = 'AutochangeAlgo'
}, function(new)
    while wait() and MainWindow.flags.AutochangeAlgo do
        local Algo, AlgoVal = 1, -1
        for i = 1, 4, 1 do
            if AlgoVal < GameReplicatedStorage.Algo["Al"..i].Value then
                Algo = i
                AlgoVal = GameReplicatedStorage.Algo["Al"..i].Value
            end
        end
        GameReplicatedStorage.Events.AlgoChang:FireServer(unpack({[1] = Algo}))
    end
end)

MainWindow:Toggle("Auto Overclock", {
    flag = 'Overclock'
}, function(new)
    while wait() and MainWindow.flags.Overclock do
        GameReplicatedStorage.Events.Overclk:InvokeServer()
    end
end)

MainWindow:Section("Thx to Gerard#0001 for UI Lib")
MainWindow:Section("Script by BlackBaron#8832")

BoostsAndCratesWindow:Toggle("Auto Claim Free Boost Star", {
    flag = 'ClaimFreeBoostStar'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.ClaimFreeBoostStar do
        GameReplicatedStorage.Events.ClaimFreeBoostStar:FireServer()
    end
end)

BoostsAndCratesWindow:Toggle("Auto Claim Free Crates", {
    flag = 'ClaimFreeCrates'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.ClaimFreeCrates do
        GameReplicatedStorage.Events.ClmFrCrt:FireServer(unpack({[1] = true}))
        GameReplicatedStorage.Events.ClmFrCrt:FireServer(unpack({[1] = false}))
    end
end)

BoostsAndCratesWindow:Section("Buy Boost")

BoostsAndCratesWindow:Toggle("Auto Buy Boost", {
    flag = 'BuyBoost'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.BuyBoost do
        local args = {
            [1] = BoostsAndCratesWindow.flags.SelectedBoostToBuy
        }
        GameReplicatedStorage.Events.BuyBoost:FireServer(unpack(args))
    end
end)

BoostsAndCratesWindow:Dropdown("Select Boost to Buy", {
    flag = 'SelectedBoostToBuy',
    list = Boosts
})

BoostsAndCratesWindow:Section("Use Boost")

BoostsAndCratesWindow:Toggle("Auto Use Boost", {
    flag = 'UseBoost'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.UseBoost do
        local args = {
            [1] = BoostsAndCratesWindow.flags.SelectedBoostToUse
        }
        GameReplicatedStorage.Events.UseBoost:FireServer(unpack(args))
        wait(IMightKillMyselfCauseOfThis.Boosts.WaitingTime[BoostsAndCratesWindow.flags.SelectedBoostToUse])
    end
end)

BoostsAndCratesWindow:Dropdown("Select Boost to Use", {
    flag = 'SelectedBoostToUse',
    list = Boosts
})

CrystaliserWindow:Section("Enable on \"Crystaliser Ready!\"")

local function collectGem(Gem)
    GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = Gem.Part.CFrame * CFrame.new(0, 10, 0)
    wait(0.25)
    FireProximityPrompt(Gem.Part.ProximityPrompt, 1, false)
    wait(1)
end

CrystaliserWindow:Toggle("Auto Collect Gems", {
    flag = 'CollectGems'
}, function(new)
    local Start, Count, GemsSpawned, IsGemCollected
    GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = GameWorkspace.ActiveMecahnicPrompts.CrystalRent.CFrame
    wait(1)
    FireProximityPrompt(GameWorkspace.ActiveMecahnicPrompts.CrystalRent.ProximityPrompt, 1, false)
    while wait() and CrystaliserWindow.flags.CollectGems do
        wait(1.5)
        Start, Count = os.time(), 0
        GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = GameWorkspace.BeachBarrier.CFrame
        wait(1)
        game:GetService("ReplicatedStorage").Events.PlaceCrystaliser:InvokeServer()
        while ((Count < 4) and (os.time() - Start < 121)) and CrystaliserWindow.flags.CollectGems do
            wait(2)
            GemsSpawned, IsGemCollected = GameWorkspace.GemsSpawned:GetChildren(), false
            for Index, Gem in next, GemsSpawned do
                if pcall(collectGem, Gem) then
                    IsGemCollected = true
                end
            end
            if IsGemCollected then
                Count = Count + 1
            end
        end
    end
end)

local GC = getconnections or get_signal_cons
if GC then
    for i, v in pairs(GC(game.Players.LocalPlayer.Idled)) do
        if v["Disable"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
else
    warn("Bad Exploit")
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

print("Everything has loaded fully. Enjoy :)")
