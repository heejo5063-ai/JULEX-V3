-- [[ JULEX V1 | FINAL MASTERPIECE ]]
-- [ ALL FEATURES ADDED | NAME ESP RESTORED | 2026 ]

local KEY_AUTH = "BOOK"
local INPUT_KEY = "BOOK"

if INPUT_KEY ~= KEY_AUTH then
    game.Players.LocalPlayer:Kick("JULEX: Access Denied!")
    return
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "JULEX V1 | ULTIMATE",
    Footer = "The Final Masterpiece | Key: BOOK",
    NotifySide = "Right",
})

-- [[ ⚙️ GLOBALS ]]
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local targetPlayer = nil
local orbitAngle = 0
local spinAngle = 0

-- [[ 📑 TABS ]]
local Tabs = {
    Combat = Window:AddTab("Combat & Assist", "crosshair"),
    Control = Window:AddTab("Target Control", "eye"),
    Movement = Window:AddTab("Movement", "zap"),
    Visuals = Window:AddTab("Visuals", "eye"),
}

-- [[ 🥊 1. COMBAT ]]
local AimBox = Tabs.Combat:AddLeftGroupbox("Silent Aim Setup")
AimBox:AddToggle("SilentAim", { Text = "Enable Silent Aim", Default = true })
AimBox:AddToggle("HitSound", { Text = "Hit Sound (เสียงติ๊ง)", Default = true })

local AssistBox = Tabs.Combat:AddRightGroupbox("Soft Spin Assist")
AssistBox:AddToggle("AssistEnabled", { Text = "Enable Soft Lock", Default = true })
AssistBox:AddSlider("Smoothness", { Text = "Smoothness", Default = 15, Min = 1, Max = 50 })
AssistBox:AddToggle("ShowSpinX", { Text = "Show Spinning X (ขาว)", Default = true })

-- [[ 🎯 2. TARGET CONTROL ]]
local TargetBox = Tabs.Control:AddLeftGroupbox("Orbit & View System")
TargetBox:AddInput("TargetInput", {
    Text = "ใส่ชื่อเป้าหมาย (ชื่อย่อ)",
    Callback = function(Value)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and (v.Name:lower():find(Value:lower()) or v.DisplayName:lower():find(Value:lower())) then
                targetPlayer = v; Library:Notify("Target Set: " .. v.DisplayName) break
            end
        end
    end
})
TargetBox:AddToggle("EnableOrbit", { Text = "Enable Orbit (บินวน)", Default = false })
TargetBox:AddToggle("EnableView", { Text = "View Camera (ส่องกล้อง)", Default = false })
TargetBox:AddSlider("OrbitRadius", { Text = "Orbit Radius", Default = 8, Min = 1, Max = 30 })

-- [[ ⚡ 3. MOVEMENT ]]
local MoveBox = Tabs.Movement:AddLeftGroupbox("Physical")
MoveBox:AddSlider("WalkSpeed", { Text = "Speed", Default = 32, Min = 16, Max = 300 })
MoveBox:AddSlider("JumpPower", { Text = "Jump Power", Default = 50, Min = 50, Max = 500 })

-- [[ 👁️ 4. VISUALS (เพิ่มมองชื่อให้แล้ว) ]]
local VisualBox = Tabs.Visuals:AddLeftGroupbox("ESP & FOV")
VisualBox:AddToggle("ShowNames", { Text = "Show Names (มองชื่อ)", Default = true }) -- เพิ่มตัวนี้
VisualBox:AddToggle("HealthEsp", { Text = "Health Bar (แถบเลือด)", Default = true })
VisualBox:AddToggle("ShowLines", { Text = "Snaplines (เส้นลาก)", Default = true })
VisualBox:AddToggle("ShowFOV", { Text = "Show FOV Circle", Default = true })
VisualBox:AddSlider("FOVSize", { Text = "FOV Radius", Default = 150, Min = 10, Max = 800 })

-- [[ 🎨 DRAWINGS ]]
local X1 = Drawing.new("Line"); X1.Thickness = 1.5; X1.Color = Color3.fromRGB(255, 255, 255)
local X2 = Drawing.new("Line"); X2.Thickness = 1.5; X2.Color = Color3.fromRGB(255, 255, 255)
local TargetLine = Drawing.new("Line"); TargetLine.Thickness = 1; TargetLine.Color = Color3.fromRGB(255, 255, 255)
local FovCircle = Drawing.new("Circle"); FovCircle.Filled = false; FovCircle.Color = Color3.fromRGB(255, 255, 255)

-- [[ 🔊 HIT SOUND ]]
local function PlayHit() if Library.Toggles.HitSound.Value then local s = Instance.new("Sound", game:GetService("SoundService")); s.SoundId = "rbxassetid://12551531051"; s:Play(); game:GetService("Debris"):AddItem(s, 1) end end

-- [[ 🔍 SCAN ]]
local function GetTarget()
    local closest, dist = nil, Library.Options.FOVSize.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if mag < dist then closest = v; dist = mag end
            end
        end
    end
    return closest
end

-- [[ 🎯 SILENT AIM ]]
local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__index
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and Library.Toggles.SilentAim.Value and self == mouse and (idx == "Hit" or idx == "Target") then
        local tar = GetTarget()
        if tar then PlayHit(); return (idx == "Hit" and tar.Character.Head.CFrame or tar.Character.Head) end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

-- [[ 🔄 MASTER LOOP ]]
runService.RenderStepped:Connect(function()
    spinAngle = spinAngle + math.rad(10)
    local scanTar = GetTarget()
    
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.Humanoid.WalkSpeed = Library.Options.WalkSpeed.Value
        lp.Character.Humanoid.JumpPower = Library.Options.JumpPower.Value
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        if Library.Toggles.EnableView.Value then cam.CameraSubject = targetPlayer.Character.Humanoid else cam.CameraSubject = lp.Character.Humanoid end
        if Library.Toggles.EnableOrbit.Value then
            orbitAngle = orbitAngle + math.rad(Library.Options.OrbitSpeed.Value)
            local offset = Vector3.new(math.cos(orbitAngle)*Library.Options.OrbitRadius.Value, 0, math.sin(orbitAngle)*Library.Options.OrbitRadius.Value)
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(targetPlayer.Character.HumanoidRootPart.Position + offset, targetPlayer.Character.HumanoidRootPart.Position)
            lp.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
    end

    FovCircle.Visible = Library.Toggles.ShowFOV.Value; FovCircle.Radius = Library.Options.FOVSize.Value; FovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    if scanTar then
        local p, on = cam:WorldToViewportPoint(scanTar.Character.Head.Position)
        if on then
            if Library.Toggles.ShowSpinX.Value then
                local s = 9; local cos, sin = math.cos(spinAngle)*s, math.sin(spinAngle)*s
                X1.From = Vector2.new(p.X-cos, p.Y-sin); X1.To = Vector2.new(p.X+cos, p.Y+sin); X1.Visible = true
                X2.From = Vector2.new(p.X+sin, p.Y-cos); X2.To = Vector2.new(p.X-sin, p.Y+cos); X2.Visible = true
            end
            if Library.Toggles.ShowLines.Value then
                TargetLine.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2); TargetLine.To = Vector2.new(p.X, p.Y); TargetLine.Visible = true
            end
            if Library.Toggles.AssistEnabled.Value then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.p, scanTar.Character.Head.Position), 1/Library.Options.Smoothness.Value)
            end
        end
    else X1.Visible = false; X2.Visible = false; TargetLine.Visible = false end
end)

-- [[ 🧱 ESP (NAMES & HEALTH) ]]
function CreateESP(plr)
    local bg = Instance.new("BillboardGui", game.CoreGui)
    bg.Size = UDim2.new(0, 100, 0, 50); bg.AlwaysOnTop = true
    
    local name = Instance.new("TextLabel", bg)
    name.Size = UDim2.new(1, 0, 0, 20); name.BackgroundTransparency = 1; name.TextColor3 = Color3.new(1, 1, 1); name.TextStrokeTransparency = 0; name.TextSize = 14
    
    local f = Instance.new("Frame", bg); f.Size = UDim2.new(0, 40, 0, 4); f.Position = UDim2.new(0.5, -20, 0, 25); f.BackgroundColor3 = Color3.new(0,0,0)
    local b = Instance.new("Frame", f); b.Size = UDim2.new(1,0,1,0); b.BackgroundColor3 = Color3.new(0,1,0); b.BorderSizePixel = 0
    
    runService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") and (Library.Toggles.ShowNames.Value or Library.Toggles.HealthEsp.Value) then
            bg.Adornee = plr.Character:FindFirstChild("Head")
            name.Text = plr.DisplayName; name.Visible = Library.Toggles.ShowNames.Value
            local hp = math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1)
            b.Size = UDim2.new(hp, 0, 1, 0); f.Visible = Library.Toggles.HealthEsp.Value
            bg.Enabled = true
        else bg.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
game.Players.PlayerAdded:Connect(CreateESP)

Library:Notify("JULEX V1 COMPLETE: ฟังชั่นครบจบในตัวเดียว พร้อมลุย!")
