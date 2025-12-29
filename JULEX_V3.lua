local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "JULEX V3 | SATANIC EDITION",
    SubTitle = "by heejo5063",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc & Satan", Icon = "skull" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ SYSTEM VARIABLES ]]
local lp = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("RunService")

-- [ 🎨 UPGRADED FOV: WHITE OUTLINE ]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1.5
fov_circle.NumSides = 100
fov_circle.Filled = false
fov_circle.Color = Color3.fromRGB(255, 255, 255)
fov_circle.Visible = false

-- [ 😈 SATANIC ASSETS ]
local pentagram = Instance.new("Part")
pentagram.Size = Vector3.new(8, 0.2, 8); pentagram.CanCollide = false; pentagram.Material = Enum.Material.Neon; pentagram.Color = Color3.fromRGB(255, 0, 150); pentagram.Transparency = 1; pentagram.Parent = workspace
local decal = Instance.new("Decal", pentagram); decal.Face = "Top"; decal.Texture = "rbxassetid://121430018"; decal.Transparency = 1

local aura = Instance.new("ParticleEmitter")
aura.Color = ColorSequence.new(Color3.fromRGB(255, 0, 150))
aura.LightEmission = 1
aura.Size = NumberSequence.new(0.5, 0)
aura.Texture = "rbxassetid://243660364"
aura.Transparency = NumberSequence.new(0.5, 1)
aura.Lifetime = NumberRange.new(1, 2)
aura.Rate = 50
aura.Enabled = false

-- [[ FUNCTION: TARGET FINDER ]]
local function GetClosest()
    local target, dist = nil, Options.FOVSize.Value
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if mDist < dist then target = v.Character.Head; dist = mDist end
            end
        end
    end
    return target
end

-- [[ TABS SETUP ]]
Tabs.Main:AddToggle("SilentAim", {Title = "Silent Aim", Default = false})
Tabs.Main:AddToggle("TPKill", {Title = "TP Kill (วาปไปข้างหลัง)", Default = false})
Tabs.Main:AddToggle("ShowFOV", {Title = "แสดงวงกลม FOV", Default = true})
Tabs.Main:AddColorpicker("FOVColor", {Title = "สีของเส้น FOV", Default = Color3.fromRGB(255, 255, 255)})
Tabs.Main:AddSlider("FOVSize", {Title = "ขนาด FOV", Default = 120, Min = 0, Max = 800, Rounding = 0})

Tabs.Visuals:AddToggle("ESP", {Title = "Highlight ESP (White)", Default = false})

Tabs.Misc:AddToggle("SatanMode", {Title = "Satan Morph (ตัวดำ+ออร่าชมพู)", Default = false})
Tabs.Misc:AddSlider("Speed", {Title = "Walk Speed", Default = 16, Min = 16, Max = 250, Rounding = 0})
Tabs.Misc:AddSlider("Jump", {Title = "Jump Power", Default = 50, Min = 50, Max = 400, Rounding = 0})

-- [[ ENGINE HOOK ]]
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if Options.SilentAim.Value and t == lp:GetMouse() and (k == "Hit" or k == "Target") then
        local target = GetClosest()
        if target then return (k == "Hit" and target.CFrame or target) end
    end
    return old(t, k)
end)
setreadonly(mt, true)

-- [[ MAIN LOOP ]]
rs.RenderStepped:Connect(function()
    -- FOV Update
    fov_circle.Visible = Options.ShowFOV.Value
    fov_circle.Radius = Options.FOVSize.Value
    fov_circle.Color = Options.FOVColor.Value
    fov_circle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    local char = lp.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Satan Mode Logic
        if Options.SatanMode.Value then
            pentagram.Transparency = 0.5; decal.Transparency = 0
            pentagram.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, tick() * 2, 0)
            
            if not aura.Parent then aura.Parent = char.HumanoidRootPart end
            aura.Enabled = true
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.new(0, 0, 0)
                    part.Material = Enum.Material.Neon
                elseif part:IsA("Clothing") or part:IsA("ShirtGraphic") then
                    part.Enabled = false
                end
            end
        else
            pentagram.Transparency = 1; decal.Transparency = 1
            aura.Enabled = false
        end
        
        char.Humanoid.WalkSpeed = Options.Speed.Value
        char.Humanoid.JumpPower = Options.Jump.Value
        
        -- TP Kill Logic
        if Options.TPKill.Value then
            local target = GetClosest()
            if target and target.Parent then
                char.HumanoidRootPart.CFrame = target.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end

    -- ESP Logic
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v ~= lp then
            local hl = v.Character:FindFirstChild("JulexESP") or Instance.new("Highlight", v.Character)
            hl.Name = "JulexESP"; hl.Enabled = Options.ESP.Value; hl.FillColor = Color3.new(1,1,1)
        end
    end
end)

-- Finish Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("JulexV3")
SaveManager:SetFolder("JulexV3/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({Title = "JULEX V3", Content = "Satanic Ultimate Loaded!", Duration = 5})
-- [[ ปุ่มกด เปิด-ปิด เมนูสำหรับคนหาปุ่มย่อไม่เจอ ]]
local ToggleButton = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = game.CoreGui
ToggleButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Button.Parent = ToggleButton
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.1, 0, 0.1, 0) -- ตำแหน่งปุ่มบนจอ
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Font = Enum.Font.SourceSansBold
Button.Text = "JULEX"
Button.TextColor3 = Color3.fromRGB(255, 0, 150)
Button.TextSize = 14.0
Button.Draggable = true -- ลากย้ายตำแหน่งปุ่มได้

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = ToolPoint.new(0, 10)
UICorner.Parent = Button

Button.MouseButton1Click:Connect(function()
    if game:GetService("CoreGui"):FindFirstChild("Fluent") then
        local gui = game:GetService("CoreGui").Fluent
        gui.Enabled = not gui.Enabled
    end
end)
