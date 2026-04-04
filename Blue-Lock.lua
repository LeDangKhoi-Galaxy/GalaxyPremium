--[[ 
   BLUE LOCK: RIVALS - CUSTOM EXCLUSIVE SCRIPT
   - FUNCTIONS: Ball Steal, Ball Magnet, Speed Hack (No Rubberband).
   - SECURITY: Anti-Kick & Anti-Report Bypass.
   - DEVICE: Optimized for S26 Ultra.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local NeonBlue = Color3.fromRGB(0, 170, 255) -- Đổi sang màu xanh đặc trưng của Blue Lock

-- =========================================
-- [HỆ THỐNG BẢO VỆ - ANTI KICK]
-- =========================================
local RawMetatable = getrawmetatable(game)
local OldNamecall = RawMetatable.__namecall
if setreadonly then setreadonly(RawMetatable, false) end
RawMetatable.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    if Method == "Kick" or Method == "kick" or Method == "ReportAbuse" then 
        return nil 
    end
    return OldNamecall(self, ...)
end)
if setreadonly then setreadonly(RawMetatable, true) end

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "BlueLock_Custom" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "BlueLock_Custom"; G.ResetOnSpawn = false

-- BIẾN ĐIỀU KHIỂN
_G.Active = true
_G.Speed = 16
_G.BallControl = false
_G.BallSteal = false

-- =========================================
-- [GIAO DIỆN ĐIỀU KHIỂN]
-- =========================================
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonBlue

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = NeonBlue
Title.Text = "BLUE LOCK: RIVALS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local function CreateBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and NeonBlue or Color3.new(1, 1, 1)
        callback(state)
    end)
end

CreateBtn("CƯỚP BÓNG TỰ ĐỘNG", 50, function(v) _G.BallSteal = v end)
CreateBtn("KIỂM SOÁT BÓNG", 100, function(v) _G.BallControl = v end)

local SpeedInp = Instance.new("TextBox", Main)
SpeedInp.Size = UDim2.new(1, -20, 0, 40)
SpeedInp.Position = UDim2.new(0, 10, 0, 150)
SpeedInp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedInp.Text = "TỐC ĐỘ CHẠY (16)"
SpeedInp.TextColor3 = NeonBlue
SpeedInp.Font = Enum.Font.SourceSansBold
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(1, -20, 0, 40)
Close.Position = UDim2.new(0, 10, 0, 260)
Close.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Close.Text = "TẮT SCRIPT"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

-- =========================================
-- [XỬ LÝ LOGIC TRẬN ĐẤU]
-- =========================================
RS.Heartbeat:Connect(function()
    if not _G.Active or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        local hrp = LP.Character.HumanoidRootPart
        local hum = LP.Character.Humanoid

        -- TỐC ĐỘ DI CHUYỂN (No Rubberband)
        if _G.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            LP.Character:TranslateBy(hum.MoveDirection * (_G.Speed / 110))
        end

        -- XỬ LÝ BÓNG
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
                local dist = (hrp.Position - obj.Position).Magnitude

                -- CƯỚP BÓNG (Phạm vi 25 studs)
                if _G.BallSteal and dist < 25 then
                    obj.Velocity = Vector3.new(0, 0, 0)
                    obj.CFrame = hrp.CFrame * CFrame.new(0, -1.2, -3)
                
                -- KIỂM SOÁT BÓNG (Giữ bóng sát chân)
                elseif _G.BallControl and dist < 8 then
                    obj.Velocity = Vector3.new(0, 0, 0)
                    obj.CFrame = hrp.CFrame * CFrame.new(0, -1.2, -2.2)
                end
            end
        end
    end)
end)

-- NÚT ĐÓNG/MỞ MENU NHANH
local Toggle = Instance.new("TextButton", G)
Toggle.Size = UDim2.new(0, 70, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Toggle.Text = "MENU"
Toggle.TextColor3 = NeonBlue
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UIStroke", Toggle).Color = NeonBlue
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
