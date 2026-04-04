--[[ 
   BLUE LOCK: RIVALS - SLIDER EDITION
   - UPGRADE: Horizontal Sliders for WalkSpeed & Ball Fly Speed.
   - FEATURES: Ball Shift-Lock Control, Ball Steal.
   - DEVICE: Optimized for S26 Ultra.
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local NeonBlue = Color3.fromRGB(0, 170, 255)

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

-- MAIN MENU
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 250, 0, 400); Main.Position = UDim2.new(0.5, -125, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonBlue
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = NeonBlue; Title.Text = "BLUE LOCK :RIVALS"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.SourceSansBold

-- HÀM TẠO NÚT BẬT/TẮT
local function CreateBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main); btn.Size = UDim2.new(1, -20, 0, 35); btn.Position = UDim2.new(0, 10, 0, y); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.SourceSansBold
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = name .. (state and ": ON" or ": OFF"); btn.TextColor3 = state and NeonBlue or Color3.new(1, 1, 1); callback(state)
    end)
end

-- HÀM TẠO THANH TRƯỢT NGANG (SLIDER)
local function CreateSlider(name, y, min, max, default, callback)
    local Label = Instance.new("TextLabel", Main); Label.Size = UDim2.new(1, -20, 0, 20); Label.Position = UDim2.new(0, 10, 0, y); Label.BackgroundTransparency = 1; Label.Text = name .. ": " .. default; Label.TextColor3 = Color3.new(1, 1, 1); Label.Font = Enum.Font.SourceSansBold; Label.TextSize = 12
    local BG = Instance.new("Frame", Main); BG.Size = UDim2.new(1, -40, 0, 6); BG.Position = UDim2.new(0, 20, 0, y + 25); BG.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", BG)
    local Fill = Instance.new("Frame", BG); Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = NeonBlue; Instance.new("UICorner", Fill)
    local Knob = Instance.new("TextButton", BG); Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8); Knob.BackgroundColor3 = Color3.new(1, 1, 1); Knob.Text = ""; Instance.new("UICorner", Knob)

    local dragging = false
    local function update()
        local pos = math.clamp((LP:GetMouse().X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        Label.Text = name .. ": " .. val
        callback(val)
    end
    Knob.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    game:GetService("RunService").RenderStepped:Connect(function() if dragging then update() end end)
end

-- THIẾT LẬP CÁC CHỨC NĂNG
CreateBtn("AUTO STEAL", 50, function(v) _G.BallSteal = v end)
CreateBtn("SHIFT-LOCK BALL", 95, function(v) _G.BallControl = v end)

-- Slider Tốc độ chạy (16 - 200)
CreateSlider("WALK SPEED", 150, 16, 200, 16, function(v) _G.Speed = v end)

-- Slider Tốc độ bóng bay (0 - 300)
CreateSlider("BALL FLY SPEED", 210, 0, 300, 50, function(v) _G.BallFlySpeed = v end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1, -20, 0, 40); Close.Position = UDim2.new(0, 10, 0, 340); Close.BackgroundColor3 = Color3.fromRGB(40, 0, 0); Close.Text = "TẮT SCRIPT"; Close.TextColor3 = Color3.new(1, 1, 1); Close.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

-- LOGIC XỬ LÝ
RS.Heartbeat:Connect(function()
    if not _G.Active or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    pcall(function()
        local hrp = LP.Character.HumanoidRootPart
        if _G.Speed > 16 and LP.Character.Humanoid.MoveDirection.Magnitude > 0 then 
            LP.Character:TranslateBy(LP.Character.Humanoid.MoveDirection * (_G.Speed / 120)) 
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

local Toggle = Instance.new("TextButton", G); Toggle.Size = UDim2.new(0, 70, 0, 30); Toggle.Position = UDim2.new(0, 10, 0.4, 0); Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Toggle.Text = "MENU"; Toggle.TextColor3 = NeonBlue; Instance.new("UIStroke", Toggle).Color = NeonBlue; Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
