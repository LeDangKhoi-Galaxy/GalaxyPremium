--[[ 
   BLUE LOCK: RIVALS - AESTHETIC V6
   - UI UPGRADE: Larger Text, Modern Fonts.
   - DYNAMIC UI: Slider only shows when Ball Control is ON.
   - OPTIMIZED: High-end Device Layout.
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local NeonBlue = Color3.fromRGB(0, 170, 255)
local FontStyle = Enum.Font.GothamBold -- Kiểu chữ hiện đại, đậm nét

-- ANTI-KICK SYSTEM
local RawMetatable = getrawmetatable(game)
local OldNamecall = RawMetatable.__namecall
if setreadonly then setreadonly(RawMetatable, false) end
RawMetatable.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" or getnamecallmethod() == "ReportAbuse" then return nil end
    return OldNamecall(self, ...)
end)
if setreadonly then setreadonly(RawMetatable, true) end

-- UI CLEANUP
if LP.PlayerGui:FindFirstChild("BlueLock_Custom") then LP.PlayerGui.BlueLock_Custom:Destroy() end
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "BlueLock_Custom"; G.ResetOnSpawn = false

_G.Active = true
_G.Speed = 16
_G.BallControl = false
_G.BallSteal = false
_G.BallFlySpeed = 50

-- MAIN MENU (Tăng độ rộng để chứa chữ to)
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 280, 0, 420); Main.Position = UDim2.new(0.5, -140, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = NeonBlue; MainStroke.Thickness = 2
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundColor3 = NeonBlue; Title.Text = "BLUE LOCK : RIVALS"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = FontStyle; Title.TextSize = 20
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local SliderLabel, SliderBG

-- HÀM TẠO NÚT (Chữ to hơn)
local function CreateBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main); btn.Size = UDim2.new(1, -30, 0, 45); btn.Position = UDim2.new(0, 15, 0, y); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = FontStyle; btn.TextSize = 16
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = name .. (state and ": ON" or ": OFF"); btn.TextColor3 = state and NeonBlue or Color3.new(1, 1, 1)
        callback(state)
        if name == "SHIFT-LOCK BALL" and SliderLabel and SliderBG then
            SliderLabel.Visible = state; SliderBG.Visible = state
        end
    end)
end

CreateBtn("AUTO STEAL", 65, function(v) _G.BallSteal = v end)
CreateBtn("CONTROL BALL", 120, function(v) _G.BallControl = v end)

-- WALK SPEED (Chữ to + TextBox đẹp)
local SpeedLabel = Instance.new("TextLabel", Main); SpeedLabel.Size = UDim2.new(1, 0, 0, 25); SpeedLabel.Position = UDim2.new(0, 0, 0, 180); SpeedLabel.BackgroundTransparency = 1; SpeedLabel.Text = "WALK SPEED SETTING"; SpeedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8); SpeedLabel.Font = FontStyle; SpeedLabel.TextSize = 14
local SpeedInp = Instance.new("TextBox", Main); SpeedInp.Size = UDim2.new(0, 100, 0, 40); SpeedInp.Position = UDim2.new(0.5, -50, 0, 210); SpeedInp.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedInp.Text = "16"; SpeedInp.TextColor3 = NeonBlue; SpeedInp.Font = FontStyle; SpeedInp.TextSize = 18
Instance.new("UICorner", SpeedInp); Instance.new("UIStroke", SpeedInp).Color = NeonBlue
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

-- BALL SPEED SLIDER (Chữ to)
local function CreateBallSlider(y, min, max, default)
    SliderLabel = Instance.new("TextLabel", Main); SliderLabel.Size = UDim2.new(1, 0, 0, 25); SliderLabel.Position = UDim2.new(0, 0, 0, y); SliderLabel.BackgroundTransparency = 1; SliderLabel.Text = "BALL SPEED: " .. default; SliderLabel.TextColor3 = Color3.new(1, 1, 1); SliderLabel.Font = FontStyle; SliderLabel.TextSize = 15; SliderLabel.Visible = false
    SliderBG = Instance.new("Frame", Main); SliderBG.Size = UDim2.new(1, -60, 0, 8); SliderBG.Position = UDim2.new(0, 30, 0, y + 35); SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50); SliderBG.Visible = false; Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG); Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = NeonBlue; Instance.new("UICorner", Fill)
    local Knob = Instance.new("TextButton", SliderBG); Knob.Size = UDim2.new(0, 20, 0, 20); Knob.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10); Knob.BackgroundColor3 = Color3.new(1, 1, 1); Knob.Text = ""; Instance.new("UICorner", Knob)

    local dragging = false
    local function update()
        local pos = math.clamp((LP:GetMouse().X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0); Knob.Position = UDim2.new(pos, -10, 0.5, -10)
        SliderLabel.Text = "BALL SPEED: " .. val; _G.BallFlySpeed = val
    end
    Knob.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    game:GetService("RunService").RenderStepped:Connect(function() if dragging then update() end end)
end

CreateBallSlider(270, 0, 300, 50)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1, -40, 0, 45); Close.Position = UDim2.new(0, 20, 0, 355); Close.BackgroundColor3 = Color3.fromRGB(60, 0, 0); Close.Text = "EXIT SCRIPT"; Close.TextColor3 = Color3.new(1, 1, 1); Close.Font = FontStyle; Close.TextSize = 16
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

-- LOGIC CORE
RS.Heartbeat:Connect(function()
    if not _G.Active or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    pcall(function()
        local hrp = LP.Character.HumanoidRootPart
        if _G.Speed > 16 and LP.Character.Humanoid.MoveDirection.Magnitude > 0 then 
            LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection * (_G.Speed / 125)) 
        end
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
                local dist = (hrp.Position - obj.Position).Magnitude
                if _G.BallSteal and dist < 25 and not _G.BallControl then
                    obj.Velocity = Vector3.new(0, 0, 0); obj.CFrame = hrp.CFrame * CFrame.new(0, -1.2, -3)
                elseif _G.BallControl then
                    local targetPos = Camera.CFrame.Position + (Camera.CFrame.LookVector * 10)
                    obj.Velocity = (targetPos - obj.Position) * (_G.BallFlySpeed / 5)
                end
            end
        end
    end)
end)

-- NÚT MENU (To, tròn, dễ bấm)
local Toggle = Instance.new("TextButton", G); Toggle.Size = UDim2.new(0, 80, 0, 40); Toggle.Position = UDim2.new(0, 20, 0.5, -20); Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Toggle.Text = "MENU"; Toggle.TextColor3 = NeonBlue; Toggle.Font = FontStyle; Toggle.TextSize = 16
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Toggle).Color = NeonBlue
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
