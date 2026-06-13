local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- [BIẾN HỆ THỐNG]
local G = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui")); G.Name = "GalaxyMini_"..math.random(1000,9999)
local SavedPosition = nil
local CurrentTween = nil
local SpeedVal = 25 -- Tốc độ mặc định

local function Notify(msg)
    StarterGui:SetCore("SendNotification", {Title = "GALAXY Mini", Text = msg, Duration = 3})
end

-- [GUI THIẾT KẾ]
local MainFrame = Instance.new("Frame", G); MainFrame.Size = UDim2.new(0, 180, 0, 240); MainFrame.Position = UDim2.new(0.5, -90, 0.3, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); MainFrame.Active = true; MainFrame.Draggable = true
local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = Color3.fromRGB(255, 0, 0); Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "GALAXY Mini"; Title.TextColor3 = Color3.fromRGB(255,0,0); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold
local CloseBtn = Instance.new("TextButton", MainFrame); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255,0,0); CloseBtn.BackgroundColor3 = Color3.fromRGB(30,0,0)
CloseBtn.MouseButton1Click:Connect(function() G:Destroy() end)

local function CreateBtn(name, y)
    local b = Instance.new("TextButton", MainFrame); b.Size = UDim2.new(1, -20, 0, 40); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = name; b.TextColor3 = Color3.fromRGB(255,0,0); b.Font = Enum.Font.SourceSansBold
    Instance.new("UIStroke", b).Color = Color3.fromRGB(150,0,0)
    return b
end

local SaveBtn = CreateBtn("LƯU VỊ TRÍ", 40)
local FlyBtn = CreateBtn("BAY ĐẾN VỊ TRÍ", 90)

-- [Ô NHẬP TỐC ĐỘ]
local SpeedInput = Instance.new("TextBox", MainFrame)
SpeedInput.Size = UDim2.new(1, -20, 0, 40); SpeedInput.Position = UDim2.new(0, 10, 0, 140)
SpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SpeedInput.PlaceholderText = "Tốc độ (VD: 25)"; SpeedInput.Text = tostring(SpeedVal)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255); SpeedInput.Font = Enum.Font.SourceSansBold; SpeedInput.TextSize = 14
Instance.new("UIStroke", SpeedInput).Color = Color3.fromRGB(150,0,0)

SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(SpeedInput.Text)
        if val then SpeedVal = val; Notify("Tốc độ đã chỉnh: " .. val) else SpeedInput.Text = tostring(SpeedVal) end
    end
end)

local SpeedToggle = CreateBtn("SPEED: ON", 190)
local SpeedActive = true
SpeedToggle.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    SpeedToggle.Text = SpeedActive and "SPEED: ON" or "SPEED: OFF"
end)

-- [CHỨC NĂNG BAY]
SaveBtn.MouseButton1Click:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        SavedPosition = LP.Character.HumanoidRootPart.CFrame
        Notify("Lưu vị trí thành công!")
    end
end)

FlyBtn.MouseButton1Click:Connect(function()
    if CurrentTween then CurrentTween:Cancel(); CurrentTween = nil; FlyBtn.Text = "BAY ĐẾN VỊ TRÍ"; return end
    if not SavedPosition then Notify("Chưa có vị trí lưu!"); return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, part in pairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        local dist = (hrp.Position - SavedPosition.Position).Magnitude
        CurrentTween = TS:Create(hrp, TweenInfo.new(dist/200, Enum.EasingStyle.Linear), {CFrame = SavedPosition})
        FlyBtn.Text = "DỪNG BAY"
        CurrentTween.Completed:Connect(function() 
            CurrentTween = nil; FlyBtn.Text = "BAY ĐẾN VỊ TRÍ"
            for _, part in pairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
        end)
        CurrentTween:Play()
    end
end)

-- [SPEED BYPASS LOOP]
RS.Heartbeat:Connect(function()
    if SpeedActive and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        local hrp = LP.Character.HumanoidRootPart
        hum.WalkSpeed = 16
        if hum.MoveDirection.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * SpeedVal, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * SpeedVal)
        end
    end
end)
