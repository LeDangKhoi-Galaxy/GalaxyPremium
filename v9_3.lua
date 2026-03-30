--[[ 
   GALAXY Premium v16.6 - PERFECT EDITION
   - RESTORED: Fly Speed từ bản v16 (Bay siêu nhanh).
   - FIREWALL: Giữ nguyên Anti-Ban Metatable (Bản v16.5).
   - OPTIMIZED: Chạy mượt nhất cho Samsung A32 của Khôi.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- =========================================
-- TƯỜNG LỬA BẢO MẬT (GIỮ LẠI TỪ V16.5)
-- =========================================
local MT = getrawmetatable(game)
local OldIndex = MT.__index
setreadonly(MT, false)
MT.__index = newcclosure(function(t, k)
    if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
        return k == "WalkSpeed" and 16 or 50
    end
    return OldIndex(t, k)
end)
setreadonly(MT, true)

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- MENU CHÍNH
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 220, 0, 420); Main.Position = UDim2.new(0.5, -110, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY Premium - LeDangKhoi"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 16

-- NÚT GALAXY TOGGLE
local ToggleBtn = Instance.new("TextButton", G)
ToggleBtn.Size = UDim2.new(0, 70, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.TextColor3 = NeonRed
Instance.new("UIStroke", ToggleBtn).Color = NeonRed
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- BIẾN ĐIỀU KHIỂN
_G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
local blockTick = 0

-- =========================================
-- HỆ THỐNG XỬ LÝ (PHỤC HỒI FLY V16)
-- =========================================
RS.Heartbeat:Connect(function()
    pcall(function()
        local Char = LP.Character
        if not Char or not Char:FindFirstChild("Humanoid") then return end
        
        -- WalkSpeed
        Char.Humanoid.WalkSpeed = _G.Speed
        
        -- PHỤC HỒI FLY CỦA V16 (BAY VÈO VÈO)
        if _G.Fly then 
            Char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) 
        end
        
        local myHRP = Char.HumanoidRootPart
        local shouldBlock = false
        local targetHRP = nil
        local minFOV = math.huge
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local dist = (myHRP.Position - hrp.Position).Magnitude
                local hum = v.Character.Humanoid
                
                -- Smart Aim & ESP
                if _G.Aim and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local fov = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if fov < minFOV then minFOV = fov; targetHRP = hrp end
                    end
                end
                
                if _G.ESP then
                    if not v.Character.Head:FindFirstChild("G_Tag") then
                        local b = Instance.new("BillboardGui", v.Character.Head); b.Name = "G_Tag"; b.Size = UDim2.new(0, 200, 0, 100); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 22
                    end
                    v.Character.Head.G_Tag.TextLabel.Text = v.Name.."\nHP: "..math.floor(hum.Health).."\n"..math.floor(dist).."m"
                end

                -- Auto Block
                if _G.AutoBlock and dist < 25 and dist > 6.5 then
                    local anim = hum:FindFirstChildOfClass("Animator")
                    if anim then
                        for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                            if t.IsPlaying and t.Speed > 1.1 and t.WeightCurrent > 0.55 then
                                shouldBlock = true; break
                            end
                        end
                    end
                end
            end
        end
        
        -- Thực thi Aim
        if _G.Aim and targetHRP then
            Char.HumanoidRootPart.CFrame = CFrame.lookAt(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z))
        end
        
        -- Thực thi Block
        if _G.AutoBlock then
            if shouldBlock then
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                blockTick = tick()
            elseif tick() - blockTick > 0.4 then
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end)
end)

-- UI BUTTONS
local function AddBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn("FLY", 160, function(v) _G.Fly = v end)
AddBtn("PLAYER ESP", 215, function(v) _G.ESP = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "SET SPEED (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,330); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold; Close.MouseButton1Click:Connect(function() G:Destroy() end)
