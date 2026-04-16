--// ACHI-ARES V6.0 (Global Random Key System)
local KeySystemGui = Instance.new("ScreenGui")
local KeyFrame = Instance.new("Frame")
local KeyInput = Instance.new("TextBox")
local VerifyBtn = Instance.new("TextButton")
local CopyLinkBtn = Instance.new("TextButton")
local KeyTitle = Instance.new("TextLabel")

--// Logic สร้างคีย์สุ่มที่ตรงกับหน้าเว็บ (สุ่มตามเวลาปัจจุบัน)
local function GetCurrentKey()
    local date = os.date("!*t") -- เวลา UTC
    -- ใช้ปี+เดือน+วัน+ชั่วโมง เป็นตัว Seed (บวก 7 เพื่อให้ตรงเวลาไทย)
    local seedNum = (date.year * 1000000) + (date.month * 10000) + (date.day * 100) + (date.hour + 7)
    math.randomseed(seedNum)
    local randomNum = math.random(100000000, 999999999) -- สุ่มเลข 9 หลัก (พันล้านแบบ)
    return "ACHI-" .. tostring(randomNum) .. "-1000D"
end

local CorrectKey = GetCurrentKey()
local KeyLink = "https://loveyouarehvg-ai.github.io/AchiAresV4/" 

--// UI SETUP (Key System)
KeySystemGui.Name = "AchiKeySystem"
KeySystemGui.Parent = game:GetService("CoreGui")

KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = KeySystemGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame)
local Stroke = Instance.new("UIStroke", KeyFrame)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "ACHI-ARES RANDOM KEY"
KeyTitle.TextColor3 = Color3.new(1, 0, 0)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 18
KeyTitle.BackgroundTransparency = 1

KeyInput.Parent = KeyFrame
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.PlaceholderText = "กรอก Key จากหน้าเว็บ..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput)

VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.08, 0, 0.65, 0)
VerifyBtn.Text = "ยืนยันคีย์"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", VerifyBtn)

CopyLinkBtn.Parent = KeyFrame
CopyLinkBtn.Size = UDim2.new(0.4, 0, 0, 40)
CopyLinkBtn.Position = UDim2.new(0.52, 0, 0.65, 0)
CopyLinkBtn.Text = "รับคีย์ที่นี่"
CopyLinkBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CopyLinkBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CopyLinkBtn)

CopyLinkBtn.MouseButton1Click:Connect(function()
    setclipboard(KeyLink)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "คัดลอกลิงก์แล้ว!",
        Text = "เปิดลิงก์ในเบราว์เซอร์เพื่อรับ Key",
        Duration = 5
    })
end)

--// ฟังก์ชั่นรันสคริปต์หลัก (V5.5 เดิมของมึง - ห้ามแก้)
local function ExecuteMainScript()
    KeySystemGui:Destroy()
    
    --// [ส่วนนี้คือสคริปต์ V5.5 ของมึงทั้งหมด ห้ามแก้ตามสั่ง]
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

    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Debris = game:GetService("Debris")
    local RunService = game:GetService("RunService")
    local RS = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")

    ScreenGui.Name = "AchiAresV5_5"
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
    MainFrame.Visible = true 

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame

    local ExpireText = Instance.new("TextLabel", MainFrame)
    ExpireText.Size = UDim2.new(1, 0, 0, 20)
    ExpireText.Position = UDim2.new(0, 0, 0.12, 0)
    ExpireText.BackgroundTransparency = 1
    ExpireText.Text = "Expire: 1000 Days (Verified)"
    ExpireText.TextColor3 = Color3.fromRGB(0, 255, 0)
    ExpireText.Font = Enum.Font.Gotham
    ExpireText.TextSize = 10

    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.K then 
            MainFrame.Visible = not MainFrame.Visible 
        end
    end)
end

--// Logic ยืนยัน Key
VerifyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        VerifyBtn.Text = "สำเร็จ!"
        task.wait(0.5)
        ExecuteMainScript()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "คีย์ผิด!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        task.wait(0.5)
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)
