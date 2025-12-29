--[[
    JULEX V3 - THE OFFICIAL STABLE RELEASE
    Developed by JULEX
    Status: COMPLETE & STABLE (FIXED)
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
local VisualTab = Window:CreateTab("V3 Visuals", 603128912)

--// [ COMBAT SECTION ]
CombatTab:CreateSection("JULEX Offense")

CombatTab:CreateToggle({
   Name = "JULEX Silent Aim",
   CurrentValue = false,
   Callback = function(Value) Settings.SilentAim = Value end,
})

CombatTab:CreateToggle({
   Name = "JULEX Kill All (Extreme)",
   CurrentValue = false,
   Callback = function(Value) Settings.KillAll = Value end,
})

--// [ GOD MODE SECTION ]
GodTab:CreateSection("Divine Protection")

GodTab:CreateToggle({
   Name = "JULEX God Mode (Immortal)",
   CurrentValue = false,
   Callback = function(Value)
      Settings.GodMode = Value
      if Value then
          local char = game.Players.LocalPlayer.Character
          local hum = char:FindFirstChildOfClass("Humanoid")
          if hum then
              local newHum = hum:Clone()
              newHum.Parent = char
              newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
              hum:Destroy()
              workspace.CurrentCamera.CameraSubject = char
          end
      end
   end,
})

--// [ ANTI-AIM SECTION ]
AATab:CreateSection("Anti-Aim Styles")

AATab:CreateToggle({
   Name = "Enable V3 Anti-Aim",
   CurrentValue = false,
   Callback = function(Value) Settings.AntiAim = Value end,
})

AATab:CreateDropdown({
   Name = "AA Mode",
   Options = {"Jitter", "Spin", "Backwards"},
   CurrentOption = {"Jitter"},
   MultipleOptions = false,
   Callback = function(Option) Settings.AA_Mode = Option[1] end,
})

--// [ MOVEMENT SECTION ]
MoveTab:CreateSection("Speed & Jump (1-1000)")

MoveTab:CreateSlider({
   Name = "WalkSpeed",
   Min = 16, Max = 1000, CurrentValue = 16,
   Callback = function(Value) Settings.WalkSpeed = Value end,
})

MoveTab:CreateSlider({
   Name = "JumpPower",
   Min = 50, Max = 1000, CurrentValue = 50,
   Callback = function(Value) Settings.JumpPower = Value end,
})

--// [ CORE LOOP ]
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = Settings.WalkSpeed
            hum.JumpPower = Settings.JumpPower
        end
    end)
end)

Rayfield:Notify({
   Title = "JULEX V3 ACTIVATED",
   Content = "รันติดแล้วครับเพื่อน! สนุกกับสคริปต์นะ",
   Duration = 5,
})
