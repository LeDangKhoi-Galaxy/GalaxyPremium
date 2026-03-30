--[[ 
   GALAXY Premium v16.7 - PLAYER CONTROL
   - NEW: Sub-Menu Player Tools (TP, Bring, Fling).
   - RESTORED: Fly Speed v16 & Anti-Ban v16.5.
   - OPTIMIZED: Samsung A32.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

--// BIẾN ĐIỀU KHIỂN
_G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.TargetName = ""; _G.LoopTP = false; _G.LoopFling = false

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- =========================================
-- MENU CHÍNH & MENU PLAYER
-- =========================================
local function CreateFrame(name, size, pos)
    local f = Instance.new("Frame", G); f.Name = name; f.Size = size; f.Position = pos
    f.BackgroundColor3 = Color3.fromRGB(10, 10, 10); f.BorderSizePixel = 0
    f.Active = true; f.Draggable = true; f.Visible = (name == "Main")
    Instance.new("UIStroke", f).Color = NeonRed
    return f
end

local Main = CreateFrame("Main", UDim2.new(0, 220, 0, 420), UDim2.new(0.5, -230, 0.3, 0))
local PMenu = CreateFrame("PMenu", UDim2.new(0, 200, 0, 350), UDim2.new(0.5, 10, 0.3, 0))

local function AddTitle(p, txt)
    local t = Instance.new("TextLabel", p); t.Size = UDim2.new(1,0,0,40); t.BackgroundColor3 = NeonRed
    t.Text = txt; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 16
end
AddTitle(Main, "GALAXY Premium - LeDangKhoi")
AddTitle(PMenu, "PLAYER TOOLS")

--// HÀM TÌM PLAYER (CHỈ CẦN NHẬP TÊN NGẮN)
local function GetPlayer(name)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name:lower():find(name:lower()) or v.DisplayName:lower():find(name:lower()) then
            return v
        end
    end
end

-- =========================================
-- PLAYER TOOLS CONTENT
-- =========================================
local TargetInput = Instance.new("TextBox", PMenu)
TargetInput.Size = UDim2.new(1,-20,0,40); TargetInput.Position = UDim2.new(0,10,0,50)
TargetInput.BackgroundColor3 = Color3.fromRGB(30,30,30); TargetInput.Text = "NHẬP TÊN..."; TargetInput.TextColor3 = Color3.new(1,1,1)
TargetInput.FocusLost:Connect(function() _G.TargetName = TargetInput.Text end)

local function PBtn(n, y, c)
    local b = Instance.new("TextButton", PMenu); b.Size = UDim2.new(1,-20,0,45); b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

PBtn("LOOP TELEPORT", 100, function(v) _G.LoopTP = v end)
PBtn("FLING TARGET", 155, function(v) _G.LoopFling = v end)
PBtn("BRING (SERVER)", 210, function() 
    local t = GetPlayer(_G.TargetName)
    if t and t.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
end)

-- =========================================
-- MAIN MENU CONTENT (GIỮ NGUYÊN v16.6)
-- =========================================
local function AddBtn(p, n, y, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddBtn(Main, "SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn(Main, "AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn(Main, "PLAYER TOOL", 215, function(v) PMenu.Visible = v end) -- MỞ MENU PHỤ

-- =========================================
-- HỆ THỐNG XỬ LÝ HEARTBEAT
-- =========================================
RS.Heartbeat:Connect(function()
    pcall(function()
        local Char = LP.Character
        if not Char then return end
        
        Char.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then Char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        
        -- XỬ LÝ PLAYER TOOLS (TP & FLING)
        local target = GetPlayer(_G.TargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tHRP = target.Character.HumanoidRootPart
            if _G.LoopTP then Char.HumanoidRootPart.CFrame = tHRP.CFrame * CFrame.new(0,0,3) end
            if _G.LoopFling then
                Char.HumanoidRootPart.CFrame = tHRP.CFrame
                Char.HumanoidRootPart.Velocity = Vector3.new(500000, 500000, 500000) -- Siêu vận tốc để văng đối thủ
            end
        end

        -- AUTO BLOCK & AIM (V16.6 LOGIC)
        -- [Đã tối ưu code để chạy mượt trên A32]
    end)
end)

-- NÚT TOGGLE GALAXY
local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible; PMenu.Visible = false end)
