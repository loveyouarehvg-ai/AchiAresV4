local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local FlingToggle = Instance.new("TextButton")
local AimToggle = Instance.new("TextButton")
local AntiGrabToggle = Instance.new("TextButton")
local ESPToggle = Instance.new("TextButton") -- เพิ่มปุ่ม ESP
local StrengthInput = Instance.new("TextBox")
local UIListLayout = Instance.new("UIListLayout")

--// Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

--// GUI Setup
ScreenGui.Name = "AchiAresV5_5"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 200, 0, 380) -- เพิ่มขนาดรองรับปุ่มใหม่
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Thickness = 3
UIStroke.Parent = MainFrame

local function ToggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        UserInputService.MouseIconEnabled = true
    else
        UserInputService.MouseIconEnabled = false
    end
end

-- ระบบสีรุ้ง
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    UIStroke.Color = color
    Title.TextColor3 = color
end)

Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ACHI-ARES BY อชิ"
Title.Font = Enum.Font.SpecialElite
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

--// Config
local FlingEnabled = false
local AimbotEnabled = false
local AntiGrabEnabled = false
local ESPEnabled = false -- ESP Toggle
local MenuKey = Enum.KeyCode.K

local function StyleButton(btn, text)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Parent = MainFrame
end

StyleButton(FlingToggle, "Fling: OFF")
StyleButton(AimToggle, "Aimbot: OFF")
StyleButton(AntiGrabToggle, "Anti-Grab: OFF")
StyleButton(ESPToggle, "ESP: OFF") -- ปุ่ม ESP

StrengthInput.Size = UDim2.new(0.9, 0, 0, 35)
StrengthInput.PlaceholderText = "Fling Force..."
StrengthInput.Text = "500"
StrengthInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StrengthInput.TextColor3 = Color3.new(1, 1, 1)
StrengthInput.ZIndex = 3
StrengthInput.Parent = MainFrame
Instance.new("UICorner", StrengthInput).CornerRadius = UDim.new(0, 8)

--// [NEW SECTION] ESP (มองทะลุชื่อ + ระยะทาง)
local function CreateESP(Player)
    local Billboard = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")

    Billboard.Name = "AchiESP"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.Adornee = Player.Character:WaitForChild("Head")
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    Billboard.Parent = Player.Character:WaitForChild("Head")

    TextLabel.Parent = Billboard
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.TextStrokeTransparency = 0

    RunService.RenderStepped:Connect(function()
        if ESPEnabled and Player.Character and Player.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Billboard.Enabled = true
            local dist = (Player.Character.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            TextLabel.Text = string.format("%s\n[%d Studs]", Player.Name, math.floor(dist))
        else
            Billboard.Enabled = false
        end
    end)
end

-- สแกนผู้เล่นใหม่เพื่อใส่ ESP
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1); CreateESP(p) end)
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Character then CreateESP(p) end
end

--// [SECTION 1] AIMBOT Q
local Settings = { BindKey = "Q" }
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if AimbotEnabled and input.KeyCode == Enum.KeyCode[Settings.BindKey:upper()] and not gameProcessed then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

--// [SECTION 2] ANTI-GRAB
local function reconnect()
    if not AntiGrabEnabled then return end
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.Sit = false
    end)
end

--// [SECTION 3] TOGGLES
local function UpdateToggle(btn, state, text)
    btn.Text = text .. (state and ": ON" or ": OFF")
    btn.BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
end

FlingToggle.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    UpdateToggle(FlingToggle, FlingEnabled, "Fling")
end)

AimToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    UpdateToggle(AimToggle, AimbotEnabled, "Aimbot")
end)

AntiGrabToggle.MouseButton1Click:Connect(function()
    AntiGrabEnabled = not AntiGrabEnabled
    UpdateToggle(AntiGrabToggle, AntiGrabEnabled, "Anti-Grab")
end)

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    UpdateToggle(ESPToggle, ESPEnabled, "ESP")
end)

--// FLING LOGIC
workspace.ChildAdded:Connect(function(m)
    if FlingEnabled and m.Name == "GrabParts" then
        task.wait(0.1)
        local gp = m:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local p1 = gp.WeldConstraint.Part1
            if p1 then
                local bv = Instance.new("BodyVelocity", p1)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Camera.CFrame.LookVector * tonumber(StrengthInput.Text)
                Debris:AddItem(bv, 1)
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == MenuKey then ToggleMenu() end
end)

StarterGui:SetCore("SendNotification", {
    Title = "ACHI-ARES V5.5",
    Text = "โหลดฟังก์ชัน ESP เรียบร้อยแล้ว!\nกด K เพื่อเปิดเมนู",
    Duration = 5
})
