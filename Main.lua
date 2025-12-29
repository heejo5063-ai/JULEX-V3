--[[
    JULEX V3 - THE OFFICIAL STABLE RELEASE
    Developed by JULEX
    Status: COMPLETE & STABLE
--]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🛡️ JULEX V3 | OFFICIAL HUB",
   LoadingTitle = "JULEX V3 - POWERED BY V3 PROJECT",
   LoadingSubtitle = "STABLE VERSION",
   ConfigurationSaving = { Enabled = false }, 
   KeySystem = false
})

--// [ SETTINGS ]
local Settings = {
    SilentAim = false,
    Prediction = 0.138,
    WalkSpeed = 16,
    JumpPower = 50,
    FlyEnabled = false,
    FlySpeed = 20,
    ESP_Enabled = false,
    AntiAim = false,
    AA_Mode = "Jitter",
    GodMode = false,
    KillAll = false
}

--// [ TABS ]
local CombatTab = Window:CreateTab("V3 Combat", 4483362458)
local GodTab = Window:CreateTab("V3 Godly", 10705030225)
local AATab = Window:CreateTab("V3 Anti-Aim", 11418115425)
local MoveTab = Window:CreateTab("V3 Movement", 4483345998)
local VisualTab = Window:CreateTab("V3 Visuals", 603128912
  
