--// ACHI-ARES V5.1 (Fixed Anti-Grab & Tutorial)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local FlingToggle = Instance.new("TextButton")
local AimToggle = Instance.new("TextButton")
local AntiGrabToggle = Instance.new("TextButton")
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
ScreenGui.Name = "AchiAresV5_1"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 200, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Thickness = 3
UIStroke.Parent = MainFrame

-- ระบบสีรุ้ง
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    UIStroke.Color = color
    Title.TextColor3 = color
end)

Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ACHI-ARES BY อชิ"
Title.Font = Enum.Font.SpecialElite -- ฟอนต์เท่ๆ
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
StyleButton(AntiGrabToggle, "Anti-Grab/Struggle: OFF")

StrengthInput.Size = UDim2.new(0.9, 0, 0, 35)
StrengthInput.PlaceholderText = "Fling Force..."
StrengthInput.Text = "500"
StrengthInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StrengthInput.TextColor3 = Color3.new(1, 1, 1)
StrengthInput.ZIndex = 3
StrengthInput.Parent = MainFrame
Instance.new("UICorner", StrengthInput).CornerRadius = UDim.new(0, 8)

--// [SECTION 1] AIMBOT Q (ห้ามแก้โค้ด)
local Settings = { BindKey = "Q" }
local isClicking = false

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

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        if not isClicking then
            isClicking = true
            if mouse1click then mouse1click() end
            isClicking = false
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if AimbotEnabled and input.KeyCode == Enum.KeyCode[Settings.BindKey:upper()] and not gameProcessed then
        local closestPlayer = getClosestPlayer()
        aimAt(closestPlayer)
    end
end)

--// [SECTION 2] ANTI-GRAB STRUGGLE (แก้บัคปิดไม่ได้ / ห้ามแก้ส่วนอื่น)
local CE = RS:WaitForChild("CharacterEvents", 5)
local StruggleEvent = CE and CE:WaitForChild("Struggle", 5)
local BeingHeld = LocalPlayer:WaitForChild("IsHeld", 5)

workspace.DescendantAdded:Connect(function(v)
    if AntiGrabEnabled and v:IsA("Explosion") then
        v.BlastPressure = 0
    end
end)

if BeingHeld then
    BeingHeld.Changed:Connect(function(C)
        if AntiGrabEnabled and C == true then
            local char = LocalPlayer.Character
            if BeingHeld.Value == true and StruggleEvent then
                local Event;
                Event = RunService.RenderStepped:Connect(function()
                    -- เพิ่มการเช็ค AntiGrabEnabled เพื่อให้ปิดใช้งานได้จริง
                    if AntiGrabEnabled and BeingHeld.Value == true then
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char["HumanoidRootPart"].AssemblyLinearVelocity = Vector3.new()
                        end
                        StruggleEvent:FireServer(LocalPlayer)
                    else
                        Event:Disconnect()
                    end
                end)
            end
        end
    end)
end

local function reconnect()
    if not AntiGrabEnabled then return end
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildWhichIsA("Humanoid") or Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    local firePart = HumanoidRootPart:WaitForChild("FirePlayerPart", 2)
    if firePart then firePart:Remove() end

    Humanoid.Changed:Connect(function(C)
        if AntiGrabEnabled and C == "Sit" and Humanoid.Sit == true then
            if Humanoid.SeatPart ~= nil and tostring(Humanoid.SeatPart.Parent) == "CreatureBlobman" then
            elseif Humanoid.SeatPart == nil then
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                Humanoid.Sit = false
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(reconnect)

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
    if AntiGrabEnabled then reconnect() end
    UpdateToggle(AntiGrabToggle, AntiGrabEnabled, "Anti-Grab/Struggle")
end)

--// FLING LOGIC
workspace.ChildAdded:Connect(function(m)
    if FlingEnabled and m.Name == "GrabParts" then
        local gp = m:WaitForChild("GrabPart", 2)
        if gp and gp:FindFirstChild("WeldConstraint") then
            local p1 = gp.WeldConstraint.Part1
            if p1 then
                local bv = Instance.new("BodyVelocity", p1)
                m:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not m.Parent then
                        if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2 then
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = Camera.CFrame.LookVector * tonumber(StrengthInput.Text)
                            Debris:AddItem(bv, 1)
                        else
                            bv:Destroy()
                        end
                    end
                end)
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == MenuKey then MainFrame.Visible = not MainFrame.Visible end
end)

--// สอนใช้งานภาษาไทย 5 วินาที
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "ยินดีต้อนรับ!",
        Text = "ACHI-ARES BY อชิ โหลดเสร็จแล้ว",
        Duration = 5
    })
    task.wait(1.2)
    StarterGui:SetCore("SendNotification", {
        Title = "วิธีเปิดเมนู",
        Text = "กดปุ่ม K เพื่อเปิดหรือปิดเมนูหลัก",
        Duration = 5
    })
    task.wait(1.2)
    StarterGui:SetCore("SendNotification", {
        Title = "วิธีใช้ Aimbot",
        Text = "เปิด ON แล้วกด Q เพื่อล็อคเป้าหมายใกล้ที่สุด",
        Duration = 5
    })
    task.wait(1.2)
    StarterGui:SetCore("SendNotification", {
        Title = "ระบบ Anti-Grab",
        Text = "ถ้าเปิดไว้ ตัวจะหลุดเองทันทีเมื่อโดนจับ",
        Duration = 5
    })
end)
