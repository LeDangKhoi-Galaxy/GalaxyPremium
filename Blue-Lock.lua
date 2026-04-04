--[[ 
   BLUE LOCK: RIVALS - GUARDIAN EDITION V16
   - MENU: BLUE LOCK : RIVALS
   - FEATURE 1: KAISER STEAL (Smart 3 Studs Glitch)
   - FEATURE 2: AUTO GK (Teleport + Tackle/Catch when ball near goal)
   - FEATURE 3: LOOP SPEED (No Rubberband/Smooth move)
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local NeonBlue = Color3.fromRGB(0, 170, 255)
local FontStyle = Enum.Font.GothamBold

-- UI SETUP
if LP.PlayerGui:FindFirstChild("BlueLock_Custom") then LP.PlayerGui.BlueLock_Custom:Destroy() end
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "BlueLock_Custom"; G.ResetOnSpawn = false

_G.Active = true
_G.Speed = 16
_G.BallSteal = false
_G.AutoGK = false

-- HÀM TÌM BÓNG
local function GetBall()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name == "Football") then
            if obj.Transparency < 1 then return obj end
        end
    end
    return nil
end

-- MAIN MENU
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 280, 0, 480); Main.Position = UDim2.new(0.5, -140, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonBlue; Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundColor3 = NeonBlue; Title.Text = "BLUE LOCK : RIVALS"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = FontStyle; Title.TextSize = 18; Instance.new("UICorner", Title)

local function CreateBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main); btn.Size = UDim2.new(1, -30, 0, 45); btn.Position = UDim2.new(0, 15, 0, y); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = FontStyle; btn.TextSize = 15; Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = name .. (state and ": ON" or ": OFF"); btn.TextColor3 = state and NeonBlue or Color3.new(1, 1, 1)
        callback(state)
    end)
end

CreateBtn("STEAL BALL", 65, function(v) _G.BallSteal = v end)
CreateBtn("AUTO GK", 120, function(v) _G.AutoGK = v end)

-- LOOP SPEED SETTING (KHÔNG GIẬT)
local SpeedLabel = Instance.new("TextLabel", Main); SpeedLabel.Size = UDim2.new(1, 0, 0, 20); SpeedLabel.Position = UDim2.new(0, 0, 0, 180); SpeedLabel.BackgroundTransparency = 1; SpeedLabel.Text = "LOOP SPEED"; SpeedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8); SpeedLabel.Font = FontStyle; SpeedLabel.TextSize = 14
local SpeedInp = Instance.new("TextBox", Main); SpeedInp.Size = UDim2.new(0, 100, 0, 40); SpeedInp.Position = UDim2.new(0.5, -50, 0, 205); SpeedInp.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedInp.Text = "16"; SpeedInp.TextColor3 = NeonBlue; SpeedInp.Font = FontStyle; SpeedInp.TextSize = 18; Instance.new("UICorner", SpeedInp); Instance.new("UIStroke", SpeedInp).Color = NeonBlue
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

-- NÚT TẮT SCRIPT
local ExitBtn = Instance.new("TextButton", Main)
ExitBtn.Size = UDim2.new(1, -30, 0, 45); ExitBtn.Position = UDim2.new(0, 15, 0, 410); ExitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); ExitBtn.Text = "TẮT SCRIPT"; ExitBtn.TextColor3 = Color3.new(1, 1, 1); ExitBtn.Font = FontStyle; ExitBtn.TextSize = 16; Instance.new("UICorner", ExitBtn)
ExitBtn.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

-- LOGIC CORE
RS.Heartbeat:Connect(function()
    if not _G.Active or not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    local ball = GetBall()
    if not hrp or not ball then return end

    -- 1. LOOP SPEED (FIX GIẬT)
    if _G.Speed > 16 and LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (LP.Character.Humanoid.MoveDirection * (_G.Speed / 100))
    end

    -- 2. KAISER STEAL (3 STUDS)
    if _G.BallSteal and (hrp.Position - ball.Position).Magnitude < 3 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Team ~= LP.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position - ball.Position).Magnitude < 5 then
                    firetouchinterest(hrp, ball, 0); task.wait(); firetouchinterest(hrp, ball, 1)
                    ball.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
                end
            end
        end
    end

    -- 3. AUTO GK (PHÒNG THỦ KHUNG THÀNH)
    if _G.AutoGK then
        local goal = workspace:FindFirstChild(LP.Team.Name .. "Goal") or workspace:FindFirstChild("Goal") -- Tìm khung thành đội mình
        if goal and (ball.Position - goal.Position).Magnitude < 35 then -- Nếu bóng gần khung thành 35 studs
            hrp.CFrame = ball.CFrame * CFrame.new(0, 0, 1) -- Dịch chuyển đón đầu bóng
            
            -- Phân loại: GK hoặc Người chơi thường
            if LP:FindFirstChild("IsGK") or LP.Name:find("GK") then
                -- Logic GK: Bắt bóng (Giả lập Catch)
                firetouchinterest(hrp, ball, 0); task.wait(); firetouchinterest(hrp, ball, 1)
            else
                -- Logic Thường: Xoạc bóng (Slide Tackle)
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:ClickButton1(Vector2.new(0,0)) -- Giả lập nhấn chuột/nút xoạc
            end
        end
    end
end)

local Toggle = Instance.new("TextButton", G); Toggle.Size = UDim2.new(0, 80, 0, 40); Toggle.Position = UDim2.new(0, 20, 0.5, -20); Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Toggle.Text = "MENU"; Toggle.TextColor3 = NeonBlue; Toggle.Font = FontStyle; Toggle.TextSize = 16; Instance.new("UICorner", Toggle); Instance.new("UIStroke", Toggle).Color = NeonBlue
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
