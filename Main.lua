   local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🛡️ JULEX V3 | OFFICIAL HUB",
   LoadingTitle = "JULEX V3 - SECURITY LOADED",
   LoadingSubtitle = "BY JULEX DEVELOPER",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true, -- เปิดใช้งานระบบคีย์
   KeySettings = {
      Title = "JULEX V3 | Key System",
      Subtitle = "กรุณาใส่คีย์เพื่อใช้งาน",
      Note = "คีย์คือ: BOOK", -- ข้อความบอกคีย์ (แก้ตรงนี้ได้)
      FileName = "JulexKey", 
      SaveKey = true, -- จำคีย์ไว้ในเครื่อง
      GrabKeyFromSite = false,
      Key = {"BOOK"} -- คีย์ที่คุณต้องการคือ BOOK
   }
})

local Settings = {
    SilentAim = false,
    Wallbang = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FOVSize = 150
}

-- [ Combat Tab ]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Shooting")

CombatTab:CreateToggle({
   Name = "Silent Aim (ล็อกเป้า)",
   CurrentValue = false,
   Callback = function(v) Settings.SilentAim = v end,
})

CombatTab:CreateToggle({
   Name = "Wallbang (ยิงทะลุ)",
   CurrentValue = false,
   Callback = function(v) Settings.Wallbang = v end,
})

-- [ Movement Tab ]
local MoveTab = Window:CreateTab("Movement", 4483345998)
MoveTab:CreateSection("Physical")

MoveTab:CreateSlider({
   Name = "WalkSpeed (วิ่งเร็ว)",
   Min = 16, Max = 500, CurrentValue = 16,
   Callback = function(v) Settings.WalkSpeed = v end,
})

MoveTab:CreateSlider({
   Name = "JumpPower (กระโดดสูง)",
   Min = 50, Max = 500, CurrentValue = 50,
   Callback = function(v) Settings.JumpPower = v end,
})

-- [ Core Logic ]
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Settings.WalkSpeed
            char.Humanoid.JumpPower = Settings.JumpPower
            char.Humanoid.UseJumpPower = true
        end
    end)
end)

Rayfield:Notify({Title = "JULEX V3", Content = "Key Correct! Welcome BOOK.", Duration = 5})
