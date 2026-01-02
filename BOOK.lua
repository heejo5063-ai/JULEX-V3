-- [[ JULEX V1 | FRIEND EDITION ]]
-- [ PC SILENT AIM | HEAD LOCK | ESP & PHYSICS | KEY: BOOK ]

local KEY_AUTH = "BOOK"
local INPUT_KEY = "BOOK"

if INPUT_KEY ~= KEY_AUTH then
    game.Players.LocalPlayer:Kick("JULEX: Access Denied!")
    return
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "JULEX V1 | FRIEND EDITION",
    Footer = "PC Style Silent Aim | Key: BOOK",
    NotifySide = "Right",
})

-- [[ ⚙️ GLOBALS ]]
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local targetPlayer = nil

-- [[ 📑 TABS ]]
local Tabs = {
    Combat = Window:AddTab("Combat & Aim", "crosshair"),
    Movement = Window:AddTab("Physics", "zap"),
    Visuals = Window:AddTab("Visuals", "eye"),
}

-- [[ 🥊 1. PC SILENT AIM (หัวคมๆ) ]]
local AimBox = Tabs.Combat:AddLeftGroupbox("PC Silent Aim")
AimBox:AddToggle("SilentAim", { Text = "Enable Silent Aim", Default = true })
AimBox:AddToggle("LockHead", { Text = "Always Lock Head (ล็อคหัว)", Default = true })
AimBox:AddSlider("Smoothness", { Text = "Smoothness", Default = 3, Min = 1, Max = 50 })

local FovBox = Tabs.Combat:AddRightGroupbox("FOV & Lines")
FovBox:AddToggle("ShowFOV", { Text = "Show FOV Circle", Default = true })
FovBox:AddSlider("FOVSize", { Text = "FOV Radius", Default = 120, Min = 10, Max = 800 })
FovBox:AddToggle("ShowLines", { Text = "Snaplines (เส้นล็อค)", Default = true })

-- [[ ⚡ 2. MOVEMENT (วิ่งเร็ว โดดสูง) ]]
local PhysBox = Tabs.Movement:AddLeftGroupbox("God Movement")
PhysBox:AddSlider("WalkSpeed", { Text = "WalkSpeed (วิ่งเร็ว)", Default = 32, Min = 16, Max = 300 })
PhysBox:AddSlider("JumpPower", { Text = "JumpPower (โดดสูง)", Default = 50, Min = 50, Max = 500 })

-- [[ 👁️ 3. VISUALS (มองชื่อ มองเลือด) ]]
local VisualBox = Tabs.Visuals:AddLeftGroupbox("ESP Settings")
VisualBox:AddToggle("ShowEspName", { Text = "Show Name (มองชื่อ)", Default = true })
VisualBox:AddToggle("ShowEspHealth", { Text = "Show Health (มองเลือด)", Default = true })

-- [[ 🎨 DRAWINGS ]]
local FovCircle = Drawing.new("Circle"); FovCircle.Thickness = 1; FovCircle.Color = Color3.new(1,1,1); FovCircle.Filled = false
local TargetLine = Drawing.new("Line"); TargetLine.Thickness = 1.5; TargetLine.Color = Color3.new(1,1,1)

-- [[ 🔍 SCAN TARGET (PC STYLE) ]]
local function GetClosestTarget()
    local closest, dist = nil, Library.Options.FOVSize.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            -- วัดระยะจากเมาส์ (PC Style)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if mag < dist then closest = v; dist = mag end
        end
    end
    return closest
end

-- [[ 🎯 SILENT AIM HOOK (HEAD) ]]
local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__index
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and Library.Toggles.SilentAim.Value and self == mouse and (idx == "Hit" or idx == "Target") then
        local tar = GetClosestTarget()
        if tar and tar.Character and tar.Character:FindFirstChild("Head") then
            return (idx == "Hit" and tar.Character.Head.CFrame or tar.Character.Head)
        end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

-- [[ 🔄 MASTER LOOP ]]
runService.RenderStepped:Connect(function()
    local tar = GetClosestTarget()
    
    -- FOV ติดเมาส์
    FovCircle.Visible = Library.Toggles.ShowFOV.Value
    FovCircle.Radius = Library.Options.FOVSize.Value
    FovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36) -- ปรับ Offset เมาส์

    -- Physics
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Library.Options.WalkSpeed.Value
        lp.Character.Humanoid.JumpPower = Library.Options.JumpPower.Value
    end

    -- Lines & Lock
    if tar and tar.Character and tar.Character:FindFirstChild("Head") then
        local p, on = cam:WorldToViewportPoint(tar.Character.Head.Position)
        if on then
            if Library.Toggles.ShowLines.Value then
                TargetLine.From = Vector2.new(mouse.X, mouse.Y + 36)
                TargetLine.To = Vector2.new(p.X, p.Y); TargetLine.Visible = true
            else TargetLine.Visible = false end
            
            -- ดึงกล้องเข้าหาหัว
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.p, tar.Character.Head.Position), 1/Library.Options.Smoothness.Value)
        end
    else TargetLine.Visible = false end
end)

-- [[ 🧱 FORCE ESP (NAME & HEALTH) ]]
local function ApplyESP(plr)
    local bg = Instance.new("BillboardGui", game.CoreGui)
    bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 100, 0, 50)
    local nl = Instance.new("TextLabel", bg); nl.Size = UDim2.new(1,0,0.4,0); nl.BackgroundTransparency = 1; nl.TextColor3 = Color3.new(1,1,1); nl.TextStrokeTransparency = 0; nl.Position = UDim2.new(0,0,-0.5,0); nl.Font = Enum.Font.SourceSansBold
    local hf = Instance.new("Frame", bg); hf.Size = UDim2.new(0, 60, 0, 5); hf.Position = UDim2.new(0.2, 0, 0, 0); hf.BackgroundColor3 = Color3.new(0,0,0)
    local hb = Instance.new("Frame", hf); hb.Size = UDim2.new(1,0,1,0); hb.BackgroundColor3 = Color3.new(0,1,0); hb.BorderSizePixel = 0
    
    runService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Humanoid.Health > 0 then
            bg.Adornee = plr.Character.Head; nl.Text = plr.DisplayName; nl.Visible = Library.Toggles.ShowEspName.Value
            hf.Visible = Library.Toggles.ShowEspHealth.Value
            local hp = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth
            hb.Size = UDim2.new(hp, 0, 1, 0); hb.BackgroundColor3 = Color3.fromHSV(hp * 0.3, 1, 1); bg.Enabled = true
        else bg.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then ApplyESP(v) end end
game.Players.PlayerAdded:Connect(ApplyESP)

Library:Notify("FRIEND EDITION READY: ล็อคหัวคมๆ สไตล์คอม พร้อมรบ!")
