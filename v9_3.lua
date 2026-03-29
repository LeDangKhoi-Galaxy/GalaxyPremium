--[[ 
   GALAXY PREMIUM by LeDangKhoi v14.0 - THE FINAL STABLE
   - FIX HOÀN HẢO: Ưu tiên Tấn công (Nhấn đấm là tự nhả Block).
   - SMART BLOCK: Kết hợp Raycast và Animation để chặn Skill/M1 chuẩn xác.
   - SNIPER AIM: Infinite Range, khóa mục tiêu theo tâm màn hình.
   - OPTIMIZED: Max FPS cho Samsung A32.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- MENU FRAME
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 220, 0, 400); Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY PREMIUM v14.0"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

-- BIẾN ĐIỀU KHIỂN
_G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
local IsAttacking = false -- Kiểm tra xem Khôi có đang nhấn đấm không

-- BẮT SỰ KIỆN KHÔI NHẤN ĐẤM (Để nhả Block ngay)
Mouse.Button1Down:Connect(function() IsAttacking = true end)
Mouse.Button1Up:Connect(function() IsAttacking = false end)

-- =========================================
-- HỆ THỐNG XỬ LÝ SIÊU CẤP
-- =========================================
RS.Heartbeat:Connect(function()
    pcall(function()
        if not LP.Character or not LP.Character:FindFirstChild("Humanoid") then return end
        
        LP.Character.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        
        local myHRP = LP.Character.HumanoidRootPart
        local shouldBlock = false
        local targetHRP = nil
        local minFOV = math.huge
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local dist = (myHRP.Position - hrp.Position).Magnitude
                local hum = v.Character.Humanoid
                
                -- 1. SMART AIM (Infinite Range)
                if _G.Aim and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local fov = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if fov < minFOV then minFOV = fov; targetHRP = hrp end
                    end
                end
                
                -- 2. AUTO BLOCK (New Logic)
                if _G.AutoBlock and dist < 30 and not IsAttacking then
                    -- Kiểm tra nếu đối thủ ra chiêu qua Animation
                    local anim = hum:FindFirstChildOfClass("Animator")
                    if anim then
                        for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                            if t.IsPlaying and t.WeightCurrent > 0.5 then
                                local n = t.Animation.Name:lower()
                                if n:find("attack") or n:find("punch") or n:find("skill") or n:find("hit") or n:find("swing") then
                                    shouldBlock = true; break
                                end
                            end
                        end
                    end
                    -- Chặn theo Velocity (Lao tới nhanh)
                    if hrp.Velocity.Magnitude > 55 then shouldBlock = true end
                end

                -- 3. ESP CHỮ SIÊU TO (Dành cho Samsung A32)
                if _G.ESP then
                    if not v.Character.Head:FindFirstChild("G_Tag") then
                        local b = Instance.new("BillboardGui", v.Character.Head); b.Name = "G_Tag"; b.Size = UDim2.new(0, 200, 0, 100); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 22
                    end
                    v.Character.Head.G_Tag.TextLabel.Text = v.Name.."\nHP: "..math.floor(hum.Health).."\n"..math.floor(dist).."m"
                end
            end
        end
        
        -- THỰC THI AIM
        if _G.Aim and targetHRP then
            LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z))
        end
        
        -- THỰC THI BLOCK (Ép nhả nếu Khôi đang đấm)
        if _G.AutoBlock then
            if IsAttacking then
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            else
                VIM:SendKeyEvent(shouldBlock, Enum.KeyCode.F, false, game)
                if not shouldBlock then VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
            end
        end
    end)
end)

-- UI BUILDER
local function AddBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 20
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn("FLY", 160, function(v) _G.Fly = v end)
AddBtn("PRO ESP", 215, function(v) _G.ESP = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.Text = "SPEED (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 20; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

AddBtn("CLOSE HUB", 345, function() G:Destroy() end)
