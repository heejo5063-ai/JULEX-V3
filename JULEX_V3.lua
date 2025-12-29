-- [[ JULEX V3 | SATANIC ULTIMATE EDITION ]]
-- [[ GitHub: https://raw.githubusercontent.com/heejo5063-ai/JULEX-V3/refs/heads/main/JULEX_V3.lua ]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "JULEX V3 | SATANIC ULTIMATE",
    SubTitle = "by heejo5063",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- บังคับปิดเพื่อแก้ปัญหาจอดำบนมือถือ
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Satan = Window:AddTab({ Title = "Satan & Misc", Icon = "skull" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local lp = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local TargetPlayer = ""

-- [[ 🎨 DRAWING SETUP ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1.5; fov_circle.NumSides = 100; fov_circle.Filled = false; fov_circle.Color = Color3.new(1,1,1); fov_circle.Visible = false

-- [[ 😈 SATAN ASSETS ]]
local pentagram = Instance.new("Part")
pentagram.Size = Vector3.new(8, 0.2, 8); pentagram.CanCollide = false; pentagram.Anchored = true; pentagram.Material = "Neon"; pentagram.Color = Color3.fromRGB(255, 0, 150); pentagram.Transparency = 1; pentagram.Parent = workspace
local decal = Instance.new("Decal", pentagram); decal.Face = "Top"; decal.Texture = "rbxassetid://121430018"; decal.Transparency = 1
local aura = Instance.new("ParticleEmitter")
aura.Color = ColorSequence.new(Color3.fromRGB(255, 0, 150)); aura.LightEmission = 1; aura.Size = NumberSequence.new(0.6, 0); aura.Texture = "rbxassetid://243660364"; aura.Transparency = NumberSequence.new(0.2, 1); aura.Lifetime = NumberRange.new(0.8); aura.Rate = 50; aura.Enabled = false

-- [[ 💥 KILL EFFECT ]]
local function KillEffect(pos)
    local orb = Instance.new("Part", workspace)
    orb.Size = Vector3.new(1,1,1); orb.Shape = "Ball"; orb.Color = Color3.fromRGB(255, 0, 150); orb.Material = "Neon"; orb.Anchored = true; orb.CanCollide = false; orb.Position = pos
    ts:Create(orb, TweenInfo.new(0.5), {Size = Vector3.new(12,12,12), Transparency = 1}):Play()
    task.delay(0.6, function() orb:Destroy() end)
end

-- [[ 🎯 SILENT AIM V2 ENGINE ]]
local function GetClosest()
    local target, dist = nil, (Options.FOVSize and Options.FOVSize.Value or 150)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if mDist < dist then target = v.Character; dist = mDist end
            end
        end
    end
    return target
end

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}; local method = getnamecallmethod()
    if Options.SilentAim and Options.SilentAim.Value and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = GetClosest()
        if target and target:FindFirstChild("Head") then return target.Head, target.Head.Position, Vector3.new(0,1,0), target.Head.Material end
    end
    return oldNamecall(self, ...)
end)

-- [[ UI ELEMENTS ]]
Tabs.Main:AddToggle("SilentAim", {Title = "Silent Aim V2 (ยิงเลี้ยวเข้าหัว)", Default = false})
Tabs.Main:AddSlider("FOVSize", {Title = "ระยะล็อก (FOV)", Default = 150, Min = 0, Max = 800, Rounding = 0})

local TargetDropdown = Tabs.Main:AddDropdown("PlayerSelect", {Title = "เลือกเป้าหมาย", Values = {}, Multi = false})
TargetDropdown:OnChanged(function(v) TargetPlayer = v end)
task.spawn(function()
    while task.wait(5) do
        local p = {}
        for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(p, v.Name) end end
        TargetDropdown:SetValues(p)
    end
end)

Tabs.Main:AddToggle("AutoKill", {Title = "Auto Kill (วาปฆ่าออโต้)", Default = false})
Tabs.Visuals:AddToggle("ESP", {Title = "Highlight ESP", Default = false})
Tabs.Satan:AddToggle("SatanMode", {Title = "Satan Morph (ร่างดำออร่าชมพู)", Default = false})
Tabs.Satan:AddSlider("Speed", {Title = "Speed", Default = 16, Min = 16, Max = 250, Rounding = 0})

-- [[ MAIN LOOP ]]
rs.RenderStepped:Connect(function()
    if Options.SilentAim then fov_circle.Visible = Options.SilentAim.Value; fov_circle.Radius = Options.FOVSize.Value end
    fov_circle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    
    local char = lp.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if Options.SatanMode.Value then
            pentagram.Transparency = 0.5; decal.Transparency = 0; pentagram.CFrame = hrp.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, tick()*3, 0)
            if aura.Parent ~= hrp then aura.Parent = hrp end; aura.Enabled = true
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Color = Color3.new(0,0,0); v.Material = "Neon" 
                elseif v:IsA("Clothing") or v:IsA("ShirtGraphic") then v:Destroy() end
            end
        else
            pentagram.Transparency = 1; decal.Transparency = 1; aura.Enabled = false
        end

        if Options.AutoKill.Value and TargetPlayer ~= "" then
            local p = game.Players:FindFirstChild(TargetPlayer)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                hrp.CFrame = CFrame.new(hrp.Position, p.Character.HumanoidRootPart.Position)
                local tool = lp.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool then lp.Character.Humanoid:EquipTool(tool); tool:Activate() end
            end
        end
        char.Humanoid.WalkSpeed = Options.Speed.Value
    end

    if Options.ESP.Value then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v ~= lp then
                local hl = v.Character:FindFirstChild("JulexESP") or Instance.new("Highlight", v.Character)
                hl.Name = "JulexESP"; hl.Enabled = true; hl.FillColor = Color3.new(1,1,1)
            end
        end
    end
end)

-- [[ KILL SENSOR ]]
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        c:WaitForChild("Humanoid").Died:Connect(function() KillEffect(c.HumanoidRootPart.Position) end)
    end)
end)

-- [[ TOGGLE BUTTON ]]
local ToggleButton = Instance.new("ScreenGui", game.CoreGui); local Button = Instance.new("TextButton", ToggleButton)
Button.Size = UDim2.new(0, 60, 0, 60); Button.Position = UDim2.new(0, 10, 0.5, 0); Button.Text = "JULEX"; Button.BackgroundColor3 = Color3.new(0,0,0); Button.TextColor3 = Color3.fromRGB(255, 0, 150); Instance.new("UICorner", Button)
Button.MouseButton1Click:Connect(function() if game:GetService("CoreGui"):FindFirstChild("Fluent") then game:GetService("CoreGui").Fluent.Enabled = not game:GetService("CoreGui").Fluent.Enabled end end)

Fluent:Notify({Title = "JULEX V3", Content = "Script Updated & Ready!", Duration = 5})
