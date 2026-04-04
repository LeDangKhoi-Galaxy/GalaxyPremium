--[[ 
   BLUE LOCK: RIVALS - KAISER PURE STEAL V18
   - STEAL: Kaiser Glitch (Steal only, No auto-shoot).
   - GK: Auto GK (Teleport & Block).
   - SPEED: Loop Speed (Optimized for S26 Ultra).
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

-- TÌM BÓNG
local function GetBall()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "Ball" or v.Name == "Football") and v.Transparency < 1 then
            return v
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

-- SPEED INPUT
local SpeedLabel = Instance.new("TextLabel", Main); SpeedLabel.Size = UDim2.new(1, 0, 0, 20); SpeedLabel.Position = UDim2.new(0, 0, 0, 180); SpeedLabel.BackgroundTransparency = 1; SpeedLabel.Text = "LOOP SPEED"; SpeedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8); SpeedLabel.Font = FontStyle; SpeedLabel.TextSize = 14
local SpeedInp = Instance.new("TextBox", Main); SpeedInp.Size = UDim2.new(0, 100, 0, 40); SpeedInp.Position = UDim2.new(0.5, -50, 0, 205); SpeedInp.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedInp.Text = "16"; SpeedInp.TextColor3 = NeonBlue; SpeedInp.Font = FontStyle; SpeedInp.TextSize = 18; Instance.new("UICorner", SpeedInp); Instance.new("UIStroke", SpeedInp).Color = NeonBlue
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

local ExitBtn = Instance.new("TextButton", Main); ExitBtn.Size = UDim2.new(1, -30, 0, 45); ExitBtn.Position = UDim2.new(0, 15, 0, 410); ExitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); ExitBtn.Text = "TẮT SCRIPT"; ExitBtn.TextColor3 = Color3.new(1, 1, 1); ExitBtn.Font = FontStyle; ExitBtn.TextSize = 16; Instance.new("UICorner", ExitBtn)
ExitBtn.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

-- LOGIC XỬ LÝ CHÍNH
RS.Stepped:Connect(function()
    if not _G.Active or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local hum = LP.Character.Humanoid
    local ball = GetBall()

    -- 1. LOOP SPEED (KHÔNG GIẬT)
    if _G.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.Speed / 55))
    end

    if ball then
        -- 2. KAISER PURE STEAL (CHỈ CƯỚP)
        if _G.BallSteal then
            -- Quét xem bóng có trong chân địch không
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Team ~= LP.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyDist = (p.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                    local myDist = (hrp.Position - ball.Position).Magnitude
                    
                    -- Nếu địch đang giữ bóng và Khôi ở gần (Phạm vi 10 studs cho mượt)
                    if enemyDist < 6 and myDist < 10 then
                        firetouchinterest(hrp, ball, 0)
                        task.wait()
                        firetouchinterest(hrp, ball, 1)
                        -- Hút bóng về vị trí trước mặt Khôi
                        ball.CFrame = hrp.CFrame * CFrame.new(0, 0, -2.5)
                        ball.Velocity = Vector3.new(0,0,0) -- Triệt tiêu lực sút của địch nếu có
                    end
                end
            end
        end

        -- 3. AUTO GK (TELEPORT CẢN PHÁ)
        if _G.AutoGK then
            local myTeam = LP.Team and LP.Team.Name or ""
            local goal = workspace:FindFirstChild(myTeam .. "Goal") or workspace:FindFirstChild("Goal")
            
            if goal and (ball.Position - goal.Position).Magnitude < 15 then
                hrp.CFrame = ball.CFrame * CFrame.new(0, 0, 1.2)
                firetouchinterest(hrp, ball, 0)
                task.wait(0.03)
                firetouchinterest(hrp, ball, 1)
                -- Giả lập phím cản phá
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
            end
        end
    end
end)

local Toggle = Instance.new("TextButton", G); Toggle.Size = UDim2.new(0, 80, 0, 40); Toggle.Position = UDim2.new(0, 20, 0.5, -20); Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Toggle.Text = "MENU"; Toggle.TextColor3 = NeonBlue; Toggle.Font = FontStyle; Toggle.TextSize = 16; Instance.new("UICorner", Toggle); Instance.new("UIStroke", Toggle).Color = NeonBlue
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
