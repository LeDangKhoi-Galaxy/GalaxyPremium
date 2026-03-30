--[[ 
   GALAXY Premium v17.0 - ULTIMATE EDITION
   - VIEW: Fixed (Infinity Yield Style).
   - BRING: Client-Side (Bring ảo, tự reset vị trí).
   - FLING: Xoáy bay đối thủ và quay về vị trí cũ.
   - PROTECTION: Anti-Fling Always On.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--// BIẾN ĐIỀU KHIỂN
_G.Speed = 50; _G.Fly = false; _G.TargetName = ""
_G.LoopTP = false; _G.LoopFling = false; _G.Viewing = false; _G.Bring = false

--// ANTI-FLING (LUÔN BẬT)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end)

--// HÀM TÌM PLAYER
local function GetPlayer(name)
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and (v.Name:lower():find(name) or v.DisplayName:lower():find(name)) then
            return v
        end
    end
end

-- =========================================
-- HỆ THỐNG XỬ LÝ (NO DELAY)
-- =========================================
RS.RenderStepped:Connect(function()
    pcall(function()
        local Char = LP.Character
        local HRP = Char:FindFirstChild("HumanoidRootPart")
        if not Char or not HRP then return end
        
        -- Loop Speed v16.0
        Char.Humanoid.WalkSpeed = _G.Speed
        
        local target = GetPlayer(_G.TargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tHRP = target.Character.HumanoidRootPart
            local tHum = target.Character:FindFirstChild("Humanoid")
            
            -- 1. VIEW FIXED
            if _G.Viewing then
                Camera.CameraSubject = tHum
            else
                Camera.CameraSubject = Char.Humanoid
            end
            
            -- 2. BRING ẢO (CLIENT-SIDE)
            if _G.Bring then
                tHRP.CFrame = HRP.CFrame * CFrame.new(0, 0, -3) -- Kéo về trước mặt
            end
            
            -- 3. LOOP TELEPORT
            if _G.LoopTP then
                HRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
            end
            
            -- 4. FLING V2 (Xoáy & Quay về chỗ cũ)
            if _G.LoopFling then
                local oldPos = HRP.CFrame
                HRP.CFrame = tHRP.CFrame
                HRP.Velocity = Vector3.new(999999, 999999, 999999)
                HRP.RotVelocity = Vector3.new(0, 999999, 0)
                task.wait(0.1) -- Chạm nhanh rồi về
                HRP.CFrame = oldPos
                _G.LoopFling = false -- Tắt sau khi đánh xong để tránh bị kẹt
            end
        else
            if not _G.Viewing then Camera.CameraSubject = Char.Humanoid end
        end
    end)
end)

-- =========================================
-- GIAO DIỆN (UI) - GIỮ NGUYÊN STYLE KHÔI THÍCH
-- =========================================
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

local Main = Instance.new("Frame", G); Main.Size = UDim2.new(0, 220, 0, 480); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
local PMenu = Instance.new("Frame", G); PMenu.Size = UDim2.new(0, 200, 0, 450); PMenu.Position = UDim2.new(0.5, 10, 0.3, 0); PMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10); PMenu.Active = true; PMenu.Draggable = true; PMenu.Visible = false
Instance.new("UIStroke", Main).Color = NeonRed; Instance.new("UIStroke", PMenu).Color = NeonRed

local function AddTitle(p, txt)
    local t = Instance.new("TextLabel", p); t.Size = UDim2.new(1,0,0,40); t.BackgroundColor3 = NeonRed; t.Text = txt; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 16
end
AddTitle(Main, "GALAXY Premium - LeDangKhoi"); AddTitle(PMenu, "PLAYER TOOLS")

local function AddBtn(p, n, y, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

-- MAIN CONTENT
AddBtn(Main, "SMART AIM", 50, function(v) end)
AddBtn(Main, "AUTO BLOCK", 105, function(v) end)
AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn(Main, "PLAYER TOOLS", 215, function(v) PMenu.Visible = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "50"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 16
Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 50 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1, -20, 0, 45); Close.Position = UDim2.new(0, 10, 0, 325); Close.BackgroundColor3 = Color3.fromRGB(40, 0, 0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1, 1, 1); Close.Font = Enum.Font.SourceSansBold; Close.TextSize = 18
Close.MouseButton1Click:Connect(function() G:Destroy(); _G.Viewing = false; Camera.CameraSubject = LP.Character.Humanoid end)

-- PLAYER CONTENT
local TInp = Instance.new("TextBox", PMenu); TInp.Size = UDim2.new(1,-20,0,40); TInp.Position = UDim2.new(0,10,0,50); TInp.BackgroundColor3 = Color3.fromRGB(30,30,30); TInp.Text = "bos"; TInp.TextColor3 = Color3.new(1,1,1)
TInp.FocusLost:Connect(function() _G.TargetName = TInp.Text end)

AddBtn(PMenu, "VIEW PLAYER", 100, function(v) _G.Viewing = v end)
AddBtn(PMenu, "LOOP TELEPORT", 155, function(v) _G.LoopTP = v end)
AddBtn(PMenu, "BRING PLAYER", 210, function(v) _G.Bring = v end)
AddBtn(PMenu, "LOOP FLING", 265, function(v) _G.LoopFling = v end)

local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
