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

local Boosts = {
    "15 min Mining Boost", "30 min Mining Boost", "1H Mining Boost",
    "15 min Xp Boost", "30 min Xp Boost", "1 H Xp Boost",
    "45 min Offline Mining Boost", "1H Offline Mining Boost", "1H 30M Offline Mining Boost",
    "15 min Server Mining Boost", "30 min Server Mining Boost", "1H Server Mining Boost"
}

MainWindow:Toggle("Auto Exchange Bitcoin", {
    flag = 'ExchangeBitcoin'
}, function(new)
    while wait() and MainWindow.flags.ExchangeBitcoin do
        GameReplicatedStorage.Events.ExchangeMoney:FireServer(unpack({[1] = true}))
        wait(120)
    end
end)

MainWindow:Toggle("Auto Exchange Solaris", {
    flag = 'ExchangeSolaris'
}, function(new)
    while wait() and MainWindow.flags.ExchangeSolaris do
        GameReplicatedStorage.Events.ExchangeMoney:FireServer(unpack({[1] = false}))
        wait(120)
    end
end)

MainWindow:Toggle("Auto Change Algorithm", {
    flag = 'AutochangeAlgo'
}, function(new)
    while wait() and MainWindow.flags.AutochangeAlgo do
        local Algo, AlgoVal = 1, GameReplicatedStorage.Algo["Al1"].Value
        for i = 2, 4, 1 do
            if AlgoVal < GameReplicatedStorage.Algo["Al"..i].Value then
                Algo = i
                AlgoVal = GameReplicatedStorage.Algo["Al"..i].Value
            end
        end
        if GamePlayers.LocalPlayer.Alsel.Value ~= Algo then
            GameReplicatedStorage.Events.AlgoChang:FireServer(unpack({[1] = Algo}))
            wait(0.5)
        end
    end
end)

MainWindow:Toggle("Auto Overclock", {
    flag = 'Overclock'
}, function(new)
    while wait() and MainWindow.flags.Overclock do
        if os.time() > GamePlayers.LocalPlayer.OvCol.Value then
            if GamePlayers.LocalPlayer.OvcTim.Value > 0 then
                wait(GamePlayers.LocalPlayer.OvcTim.Value - os.time())
            else
                GameReplicatedStorage.Events.Overclk:InvokeServer()
                wait(0.5)
            end
        else
            wait(GamePlayers.LocalPlayer.OvCol.Value - os.time())
        end
    end
end)

MainWindow:Section("Thx to Gerard#0001 for UI Lib")
MainWindow:Section("Script by Dhyutidhara#8832")

BoostsAndCratesWindow:Section("BOOSTS")

BoostsAndCratesWindow:Toggle("Auto Claim Free Boost Star", {
    flag = 'ClaimFreeBoostStar'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.ClaimFreeBoostStar do
        if GamePlayers.LocalPlayer.NxBss.Value == 0 then
            GameReplicatedStorage.Events.ClaimFreeBoostStar:FireServer()
            wait(0.5)
        else
            wait(GamePlayers.LocalPlayer.NxBss.Value)
        end
    end
end)

BoostsAndCratesWindow:Section("Buy Boost")

BoostsAndCratesWindow:Toggle("Auto Buy Boost", {
    flag = 'BuyBoost'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.BuyBoost do
        if GamePlayers.LocalPlayer.BoostStars.Value >= GameReplicatedStorage.Objects[BoostsAndCratesWindow.flags.SelectedBoostToBuy].BtPrice.Value then
            local args = {
                [1] = BoostsAndCratesWindow.flags.SelectedBoostToBuy
            }
            GameReplicatedStorage.Events.BuyBoost:FireServer(unpack(args))
            wait(0.5)
        else
            wait(GamePlayers.LocalPlayer.NxBss.Value)
        end
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
        if GamePlayers.LocalPlayer.CurBoostim.Value == 0 then
            local args = {
                [1] = BoostsAndCratesWindow.flags.SelectedBoostToUse
            }
            GameReplicatedStorage.Events.UseBoost:FireServer(unpack(args))
            wait(0.5)
        else
            wait(GamePlayers.LocalPlayer.CurBoostim.Value)
        end
    end
end)

BoostsAndCratesWindow:Dropdown("Select Boost to Use", {
    flag = 'SelectedBoostToUse',
    list = Boosts
})

BoostsAndCratesWindow:Section("CRATES")

BoostsAndCratesWindow:Toggle("Auto Claim Normal Crate", {
    flag = 'ClaimNormalCrate'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.ClaimNormalCrate do
        if os.time() > GamePlayers.LocalPlayer.NexCrt.Value then
            GameReplicatedStorage.Events.ClmFrCrt:FireServer(unpack({[1] = false}))
            wait(0.5)
        else
            wait(GamePlayers.LocalPlayer.NexCrt.Value - os.time())
        end
    end
end)

BoostsAndCratesWindow:Toggle("Auto Claim Small Crate", {
    flag = 'ClaimSmallCrate'
}, function(new)
    while wait() and BoostsAndCratesWindow.flags.ClaimSmallCrate do
        if os.time() > GamePlayers.LocalPlayer.NexSmmCrt.Value then
            GameReplicatedStorage.Events.ClmFrCrt:FireServer(unpack({[1] = true}))
            wait(0.5)
        else
            wait(GamePlayers.LocalPlayer.NexSmmCrt.Value - os.time())
        end
    end
end)

CrystaliserWindow:Section("Enable on \"Crystaliser Ready!\"")

CrystaliserWindow:Toggle("Auto Collect Gems", {
    flag = 'CollectGems'
}, function(new)
    while wait(1) and CrystaliserWindow.flags.CollectGems do
        GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = GameWorkspace.ActiveMecahnicPrompts.CrystalRent.CFrame
        wait(0.25)
        FireProximityPrompt(GameWorkspace.ActiveMecahnicPrompts.CrystalRent.ProximityPrompt, 1, false)
        wait(1)
        GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = GameWorkspace.BeachBarrier.CFrame
        wait(0.25)
        GameReplicatedStorage.Events.PlaceCrystaliser:InvokeServer()
        wait(1)
        while wait(1) and CrystaliserWindow.flags.CollectGems and GameWorkspace.ActiveMecahnicPrompts.CrystalRent.BillboardGui.State.Text ~= "READY!" do
            local GemsSpawned = GameWorkspace.GemsSpawned:GetChildren()
            for Index, Gem in next, GemsSpawned do
                GamePlayers.LocalPlayer.Character.HumanoidRootPart.CFrame = Gem.Part.CFrame * CFrame.new(0, 10, 0)
                wait(0.25)
                FireProximityPrompt(Gem.Part.ProximityPrompt, 1, false)
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
