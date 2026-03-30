--[[ 
   GALAXY PREMIUM v18.1 - SCI-FI CINEMATIC
   - DEVELOPER: LeDangKhoi
   - NEW FONT: Changed Intro and Title fonts to 'SciFi' for a cooler look.
   - FEATURES: Fixed Loop Speed, Aim, Fly, Auto Block, Bring, Fling.
   - OPTIMIZED: Samsung A32.
]]

-- =========================================
-- HỆ THỐNG INTRO CINEMATIC v18.1 (4 GIÂY)
-- =========================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TextService = game:GetService("TextService")

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyIntro" or v.Name == "GalaxyKhoi" then v:Destroy() end
end

local IGui = Instance.new("ScreenGui", LP.PlayerGui); IGui.Name = "GalaxyIntro"; IGui.ResetOnSpawn = false

-- 1. MÀN ĐEN
local BG = Instance.new("Frame", IGui); BG.Size = UDim2.new(1, 0, 1, 0); BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0); BG.BackgroundTransparency = 1; BG.ZIndex = 1
local GlowRed = Color3.fromRGB(255, 0, 0)

-- === CẬP NHẬT PHÔNG CHỮ MỚI (NGẦU HƠN) ===
local CoolFont = Enum.Font.SciFi -- Font chữ tương lai, mạnh mẽ
-- =========================================

-- 2. CHỮ GALAXY PREMIUM (PHÁT SÁNG, FONT SCI-FI)
local Title = Instance.new("TextLabel", IGui); Title.Size = UDim2.new(0, 400, 0, 80); Title.Position = UDim2.new(0.5, -200, 0.5, -40); Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "GALAXY Premium"; Title.TextColor3 = Color3.new(1, 1, 1); 
Title.Font = CoolFont; -- Đã đổi font
Title.TextSize = 45; Title.ZIndex = 2; Title.TextTransparency = 1
Instance.new("UIStroke", Title).Color = GlowRed

-- 3. TIA SÉT (CRIMSON LIGHTNING)
local Lightning = Instance.new("Frame", IGui); Lightning.Size = UDim2.new(0, 5, 0, 0); Lightning.Position = UDim2.new(0.5, -2.5, 1, 0); Lightning.BackgroundColor3 = GlowRed; Lightning.ZIndex = 3; Lightning.BackgroundTransparency = 1; Lightning.Rotation = -10
Instance.new("UIStroke", Lightning).Color = Color3.fromRGB(50, 0, 0)

-- === KỊCH BẢN CINEMATIC (4s) ===
task.spawn(function()
    print("⚡ GALAXY PREMIUM v18.1 - INITIATING SCI-FI INTRO...")
    
    for i = 1, 0.5, -0.05 do BG.BackgroundTransparency = i; task.wait(0.05) end
    task.wait(0.5)
    
    for i = 1, 0, -0.05 do Title.TextTransparency = i; Title.BackgroundTransparency = i * 0.5; task.wait(0.05) end
    task.wait(1)
    
    print("⚡ CRIMSON LIGHTNING STRIKE! ⚡")
    Lightning.BackgroundTransparency = 0
    local lStartPos = UDim2.new(0.5, -2.5, 1, 0)
    local lEndPos = UDim2.new(0.5, -2.5, 0, 0)
    
    local s = tick()
    while tick() - s < 0.2 do
        local p = (tick() - s) / 0.2
        Lightning.Size = UDim2.new(0, 5, p, Camera.ViewportSize.Y)
        Lightning.Position = lStartPos:Lerp(lEndPos, p)
        task.wait()
    end
    
    -- Chữ cắt đôi (Giữ nguyên font Sci-Fi)
    local LeftTitle = Title:Clone(); LeftTitle.Parent = IGui; LeftTitle.Text = "GALAXY"; LeftTitle.Size = UDim2.new(0, 200, 0, 80); LeftTitle.Position = UDim2.new(0.5, -200, 0.5, -40); LeftTitle.ZIndex = 4; LeftTitle.Font = CoolFont
    local RightTitle = Title:Clone(); RightTitle.Parent = IGui; RightTitle.Text = "Premium"; RightTitle.Size = UDim2.new(0, 200, 0, 80); RightTitle.Position = UDim2.new(0.5, 0, 0.5, -40); RightTitle.ZIndex = 4; RightTitle.Font = CoolFont
    Title.Visible = false
    
    local dS = tick()
    while tick() - dS < 0.3 do
        local p = (tick() - dS) / 0.3
        LeftTitle.Position = UDim2.new(0.5 - p * 0.4, -200, 0.5, -40); LeftTitle.Rotation = p * -10
        RightTitle.Position = UDim2.new(0.5 + p * 0.4, 0, 0.5, -40); RightTitle.Rotation = p * 10
        task.wait()
    end
    
    Lightning.BackgroundTransparency = 1
    for i = 0.5, 1, 0.05 do BG.BackgroundTransparency = i; LeftTitle.TextTransparency = (i - 0.5) * 2; RightTitle.TextTransparency = (i - 0.5) * 2; task.wait(0.05) end
    
    IGui:Destroy()
    print("⚡ GALAXY PREMIUM v18.1 - GOD MODE ACTIVE! ⚡")
end)

-- =========================================
-- HỆ THỐNG SCRIPT CHÍNH (Sẽ hiện sau 4s)
-- =========================================
task.wait(4)

local RS = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", { Title = "GALAXY PREMIUM"; Text = "Version 18.1 - Sci-Fi Loaded!"; Duration = 5; })

_G.Speed = 50; _G.TargetName = ""; _G.Fly = false; _G.Aim = false; _G.AutoBlock = false
_G.LoopTP = false; _G.LoopFling = false; _G.Viewing = false; _G.Bring = false

-- Hàm tìm Player và Logic xử lý (Giữ nguyên)
local function GetPlayer(name) if name == "" then return nil end name = name:lower() for _, v in pairs(Players:GetPlayers()) do if v ~= LP and (v.Name:lower():find(name) or v.DisplayName:lower():find(name)) then return v end end return nil end
RS.RenderStepped:Connect(function() pcall(function() local Char = LP.Character; local HRP = Char:FindFirstChild("HumanoidRootPart"); local Hum = Char:FindFirstChild("Humanoid") if not Char or not HRP or not Hum then return end Hum.WalkSpeed = _G.Speed; if _G.Fly then HRP.Velocity = Vector3.new(0, 50, 0) end if _G.AutoBlock then local tool = Char:FindFirstChildOfClass("Tool"); if tool then tool:Activate() end end local target = GetPlayer(_G.TargetName) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local tHRP = target.Character.HumanoidRootPart; if _G.Aim then Camera.CFrame = CFrame.new(Camera.CFrame.Position, tHRP.Position) end if _G.Viewing then Camera.CameraType = Enum.CameraType.Track; Camera.CameraSubject = target.Character.Humanoid else Camera.CameraType = Enum.CameraType.Custom; if Camera.CameraSubject ~= Hum then Camera.CameraSubject = Hum end end if _G.Bring then tHRP.CFrame = HRP.CFrame * CFrame.new(0, 0, -5) end; if _G.LoopTP then HRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3) end; if _G.LoopFling then local oldPos = HRP.CFrame; for _, part in pairs(Char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end; HRP.CFrame = tHRP.CFrame; HRP.Velocity = Vector3.new(999999, 999999, 999999); HRP.RotVelocity = Vector3.new(0, 999999, 0); task.wait(0.2); HRP.CFrame = oldPos; HRP.Velocity = Vector3.new(0,0,0); _G.LoopFling = false; for _, part in pairs(Char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = true end end end else if not _G.Viewing then Camera.CameraType = Enum.CameraType.Custom; Camera.CameraSubject = Hum end end end) end)

-- =========================================
-- GIAO DIỆN UI v18.1 (SYNCHRONIZED FONT)
-- =========================================
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)
local function AddBtn(p, n, y, c) local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16; local s = false; b.MouseButton1Click:Connect(function() s = not s; b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end) end
local Main = Instance.new("Frame", G); Main.Size = UDim2.new(0, 220, 0, 480); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
local PMenu = Instance.new("Frame", G); PMenu.Size = UDim2.new(0, 200, 0, 450); PMenu.Position = UDim2.new(0.5, 10, 0.3, 0); PMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10); PMenu.Active = true; PMenu.Draggable = true; PMenu.Visible = false
Instance.new("UIStroke", Main).Color = NeonRed; Instance.new("UIStroke", PMenu).Color = NeonRed

-- === CẬP NHẬT FONT CHO TITLE MENU ===
local t1 = Instance.new("TextLabel", Main); t1.Size = UDim2.new(1,0,0,40); t1.BackgroundColor3 = NeonRed; t1.Text = "GALAXY PREMIUM"; t1.TextColor3 = Color3.new(1,1,1); 
t1.Font = CoolFont; -- Đã đổi font SciFi
t1.TextSize = 20
local t2 = Instance.new("TextLabel", PMenu); t2.Size = UDim2.new(1,0,0,40); t2.BackgroundColor3 = NeonRed; t2.Text = "PLAYER TOOLS"; t2.TextColor3 = Color3.new(1,1,1); 
t2.Font = CoolFont; -- Đã đổi font SciFi
t2.TextSize = 18

-- Các nút và ô nhập (Giữ nguyên)
AddBtn(Main, "SMART AIM", 50, function(v) _G.Aim = v end); AddBtn(Main, "AUTO BLOCK", 105, function(v) _G.AutoBlock = v end); AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end); AddBtn(Main, "PLAYER TOOLS", 215, function(v) PMenu.Visible = v end)
local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "50"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 50 end)
AddBtn(Main, "HỦY SCRIPT", 325, function() G:Destroy(); _G.Viewing = false; _G.Fly = false; Camera.CameraType = Enum.CameraType.Custom end)
local TInp = Instance.new("TextBox", PMenu); TInp.Size = UDim2.new(1, -20, 0, 50); TInp.Position = UDim2.new(0, 10, 0, 50); TInp.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TInp.Text = "NHẬP TÊN NGƯỜI CHƠI..."; TInp.TextColor3 = Color3.new(1, 1, 1); TInp.Font = Enum.Font.SourceSansBold; TInp.TextSize = 18; TInp.ClearTextOnFocus = true; TInp.FocusLost:Connect(function() _G.TargetName = TInp.Text end)
AddBtn(PMenu, "VIEW PLAYER", 110, function(v) _G.Viewing = v end); AddBtn(PMenu, "LOOP TELEPORT", 165, function(v) _G.LoopTP = v end); AddBtn(PMenu, "BRING PLAYER", 220, function(v) _G.Bring = v end); AddBtn(PMenu, "LOOP FLING", 275, function(v) _G.LoopFling = v end)
local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed; TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
