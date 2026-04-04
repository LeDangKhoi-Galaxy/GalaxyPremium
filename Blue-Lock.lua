--[[ 
   BLUE LOCK: RIVALS - ULTIMATE CONTROL V14
   - FEATURE: Smart Ball Stalker + Kaiser Steal + Speed.
   - UI: Slider auto-hides, "EXIT SCRIPT" button added.
   - FIX: Perfect Camera return and script cleanup.
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local NeonBlue = Color3.fromRGB(0, 170, 255)
local FontStyle = Enum.Font.GothamBold

-- UI SETUP
if LP.PlayerGui:FindFirstChild("BlueLock_Custom") then LP.PlayerGui.BlueLock_Custom:Destroy() end
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "BlueLock_Custom"; G.ResetOnSpawn = false

_G.Active = true
_G.Speed = 16
_G.BallControl = false
_G.BallSteal = false
_G.BallFlySpeed = 50

-- HÀM RESET CAMERA
local function ResetCamera()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LP.Character.Humanoid
    end
end

-- HÀM TÌM BÓNG
local function GetRealBall()
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

local SliderLabel, SliderBG

local function CreateBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main); btn.Size = UDim2.new(1, -30, 0, 45); btn.Position = UDim2.new(0, 15, 0, y); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = FontStyle; btn.TextSize = 15; Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = name .. (state and ": ON" or ": OFF"); btn.TextColor3 = state and NeonBlue or Color3.new(1, 1, 1)
        callback(state)
        if name == "CONTROL BALL (CAM)" then
            SliderLabel.Visible = state; SliderBG.Visible = state
            if not state then ResetCamera() end
        end
    end)
end

CreateBtn("STEAL BALL", 65, function(v) _G.BallSteal = v end)
CreateBtn("CONTROL BALL", 120, function(v) _G.BallControl = v end)

-- SPEED SETTING
local SpeedLabel = Instance.new("TextLabel", Main); SpeedLabel.Size = UDim2.new(1, 0, 0, 20); SpeedLabel.Position = UDim2.new(0, 0, 0, 180); SpeedLabel.BackgroundTransparency = 1; SpeedLabel.Text = "WALK SPEED"; SpeedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8); SpeedLabel.Font = FontStyle; SpeedLabel.TextSize = 14
local SpeedInp = Instance.new("TextBox", Main); SpeedInp.Size = UDim2.new(0, 100, 0, 40); SpeedInp.Position = UDim2.new(0.5, -50, 0, 205); SpeedInp.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedInp.Text = "16"; SpeedInp.TextColor3 = NeonBlue; SpeedInp.Font = FontStyle; SpeedInp.TextSize = 18; Instance.new("UICorner", SpeedInp); Instance.new("UIStroke", SpeedInp).Color = NeonBlue
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

-- SLIDER
local function CreateBallSlider(y, min, max, default)
    SliderLabel = Instance.new("TextLabel", Main); SliderLabel.Size = UDim2.new(1, 0, 0, 25); SliderLabel.Position = UDim2.new(0, 0, 0, y); SliderLabel.BackgroundTransparency = 1; SliderLabel.Text = "FLY SPEED: " .. default; SliderLabel.TextColor3 = Color3.new(1, 1, 1); SliderLabel.Font = FontStyle; SliderLabel.TextSize = 14; SliderLabel.Visible = false
    SliderBG = Instance.new("Frame", Main); SliderBG.Size = UDim2.new(1, -60, 0, 8); SliderBG.Position = UDim2.new(0, 30, 0, y + 35); SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50); SliderBG.Visible = false; Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG); Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = NeonBlue; Instance.new("UICorner", Fill)
    local Knob = Instance.new("TextButton", SliderBG); Knob.Size = UDim2.new(0, 20, 0, 20); Knob.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10); Knob.BackgroundColor3 = Color3.new(1, 1, 1); Knob.Text = ""; Instance.new("UICorner", Knob)

    local dragging = false
    local function update()
        local pos = math.clamp((LP:GetMouse().X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0); Knob.Position = UDim2.new(pos, -10, 0.5, -10)
        SliderLabel.Text = "FLY SPEED: " .. val; _G.BallFlySpeed = val
    end
    Knob.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RS.RenderStepped:Connect(function() if dragging then update() end end)
end

CreateBallSlider(270, 0, 300, 50)

-- NÚT TẮT SCRIPT HOÀN TOÀN
local ExitBtn = Instance.new("TextButton", Main)
ExitBtn.Size = UDim2.new(1, -30, 0, 45); ExitBtn.Position = UDim2.new(0, 15, 0, 410); ExitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); ExitBtn.Text = "TẮT SCRIPT"; ExitBtn.TextColor3 = Color3.new(1, 1, 1); ExitBtn.Font = FontStyle; ExitBtn.TextSize = 16; Instance.new("UICorner", ExitBtn)

ExitBtn.MouseButton1Click:Connect(function()
    _G.Active = false
    _G.BallControl = false
    _G.BallSteal = false
    ResetCamera()
    G:Destroy()
end)

-- LOGIC CORE
local Connection
Connection = RS.RenderStepped:Connect(function()
    if not _G.Active then 
        if Connection then Connection:Disconnect() end
        return 
    end
    
    local ball = GetRealBall()
    if ball then
        if _G.BallControl then
            Camera.CameraSubject = ball
            local targetPos = Camera.CFrame.Position + (Camera.CFrame.LookVector * 20)
            ball.Velocity = (targetPos - ball.Position) * (_G.BallFlySpeed / 4)
        end

        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and _G.BallSteal and not _G.BallControl then
            if (hrp.Position - ball.Position).Magnitude < 3 then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Team ~= LP.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (p.Character.HumanoidRootPart.Position - ball.Position).Magnitude < 6 then
                            firetouchinterest(hrp, ball, 0)
                            task.wait()
                            firetouchinterest(hrp, ball, 1)
                            ball.CFrame = hrp.CFrame * CFrame.new(0, -1, -2)
                        end
                    end
                end
            end
        end
    end

    if _G.Speed > 16 and LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.MoveDirection.Magnitude > 0 then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (LP.Character.Humanoid.MoveDirection * (_G.Speed / 80))
    end
end)

local Toggle = Instance.new("TextButton", G); Toggle.Size = UDim2.new(0, 80, 0, 40); Toggle.Position = UDim2.new(0, 20, 0.5, -20); Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Toggle.Text = "MENU"; Toggle.TextColor3 = NeonBlue; Toggle.Font = FontStyle; Toggle.TextSize = 16; Instance.new("UICorner", Toggle); Instance.new("UIStroke", Toggle).Color = NeonBlue
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
