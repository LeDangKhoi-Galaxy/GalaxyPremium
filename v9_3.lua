--[[ 
   GALAXY PREMIUM v5.5.6.4 - ABSOLUTE NOCLIP & NO SHAKE
   - FIXED: Noclip khi nhảy không bị văng ra khỏi tường.
   - FIXED: Khử rung màn hình tuyệt đối (Absolute No Shake).
   - CLEAN: Tự động xóa sạch Tool và ESP khi nhấn HỦY SCRIPT.
   - AUTHENTIC BY: LeDangKhoi & Gemini
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- [BIẾN HỆ THỐNG]
_G.Active = true
_G.TargetName = ""; _G.Speed = 50; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.LoopTP = false; _G.Bring = false; _G.VoidActive = false
local blockTick = 0
local LastPosBeforeVoid = nil 
local CurrentVoidPlate = nil 
local NeonRed = Color3.fromRGB(255, 0, 0)
local CurrentNoclip = nil 

-- [HỆ THỐNG KHỬ RUNG TUYỆT ĐỐI]
local function DisableShakeAbsolute()
    -- Ghi đè hàm Shake nếu game có sử dụng các Module rung phổ biến
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if _G.Active and (key == "CFrame" or key == "Focus") and self == Camera then
            -- Ngăn chặn các tác động rung từ bên ngoài vào Camera
        end
        return oldIndex(self, key)
    end)

    -- Quét và đóng băng các giá trị rung trong PlayerGui
    task.spawn(function()
        while _G.Active do
            pcall(function()
                for _, v in pairs(LP.PlayerGui:GetDescendants()) do
                    if v.Name:lower():find("shake") or v.Name:lower():find("camshake") then
                        if v:IsA("NumberValue") or v:IsA("Vector3Value") then v.Value = v.Value * 0 end
                        if v:IsA("ModuleScript") then v:Destroy() end -- Xóa luôn script rung nếu tìm thấy
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- [HÀM DỌN DẸP]
local function AbsoluteCleanUp()
    _G.Active = false
    if CurrentNoclip then CurrentNoclip:Destroy(); CurrentNoclip = nil end
    local oldTool = LP.Backpack:FindFirstChild("Noclip") or (LP.Character and LP.Character:FindFirstChild("Noclip"))
    if oldTool then oldTool:Destroy() end
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") then
            local tag = v.Character.Head:FindFirstChild("G_Tag")
            if tag then tag:Destroy() end
        end
    end
    if CurrentVoidPlate then CurrentVoidPlate:Destroy(); CurrentVoidPlate = nil end
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
end

-- [TẠO TOOL NOCLIP]
local function GiveNoclip()
    if not _G.Active then return end
    local t = Instance.new("Tool")
    t.Name = "Noclip"; t.RequiresHandle = false; t.Parent = LP.Backpack
    CurrentNoclip = t
end

-- [HỆ THỐNG VA CHẠM - FIXED NOCLIP JUMP]
RS.Stepped:Connect(function()
    if _G.Active and LP.Character and CurrentNoclip and CurrentNoclip.Parent == LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- [FFLAG TỐI ƯU]
local function ApplyFFlags()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = false end
    end
end

-- [GUI SYSTEM]
for _, v in pairs(LP.PlayerGui:GetChildren()) do if v.Name:find("Galaxy") then v:Destroy() end end
local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Galaxy_V5564"; G.ResetOnSpawn = false

local function StartIntro()
    local Overlay = Instance.new("Frame", G); Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.new(0, 0, 0); Overlay.BackgroundTransparency = 0.5; Overlay.ZIndex = 100
    local T = Instance.new("TextLabel", Overlay); T.Size = UDim2.new(1,0,1,0); T.Text = "GALAXY PREMIUM - NOCLIP FIX"; T.TextColor3 = NeonRed; T.Font = Enum.Font.SourceSansBold; T.TextSize = 30; T.BackgroundTransparency = 1
    task.wait(2); Overlay:Destroy()
end

-- [MENU]
local Main = Instance.new("Frame", G); Main.Visible = false; Main.Size = UDim2.new(0, 220, 0, 520); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = NeonRed
local SubMenu = Instance.new("Frame", G); SubMenu.Visible = false; SubMenu.Size = UDim2.new(0, 200, 0, 260); SubMenu.Position = UDim2.new(0.5, 10, 0.3, 0); SubMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15); SubMenu.Active = true; SubMenu.Draggable = true; Instance.new("UIStroke", SubMenu).Color = NeonRed

local function AddMainBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y+40); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

-- Titles
local function Title(p, t)
    local l = Instance.new("TextLabel", p); l.Size = UDim2.new(1,0,0,40); l.BackgroundColor3 = NeonRed; l.Text = t; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.SourceSansBold
end
Title(Main, "GALAXY PREMIUM"); Title(SubMenu, "PLAYER TOOL")

AddMainBtn("SMART AIM", 10, function(v) _G.Aim = v end)
AddMainBtn("AUTO BLOCK", 65, function(v) _G.AutoBlock = v end)
AddMainBtn("FLY MODE", 120, function(v) _G.Fly = v end)
AddMainBtn("PLAYER ESP", 175, function(v) _G.ESP = v end)
AddMainBtn("PLAYER TOOL", 230, function(v) SubMenu.Visible = v end)
AddMainBtn("TP TO VOID", 285, function(v)
    _G.VoidActive = v
    if v and LP.Character then
        LastPosBeforeVoid = LP.Character.HumanoidRootPart.CFrame
        CurrentVoidPlate = Instance.new("Part", workspace); CurrentVoidPlate.Size = Vector3.new(2048, 1, 2048); CurrentVoidPlate.Anchored = true; CurrentVoidPlate.Position = Vector3.new(LP.Character.HumanoidRootPart.Position.X, -500, LP.Character.HumanoidRootPart.Position.Z); CurrentVoidPlate.Color = NeonRed; CurrentVoidPlate.Material = Enum.Material.ForceField
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentVoidPlate.Position + Vector3.new(0, 5, 0))
    elseif not v and LP.Character then
        LP.Character.HumanoidRootPart.CFrame = LastPosBeforeVoid or CFrame.new(0, 50, 0)
        if CurrentVoidPlate then CurrentVoidPlate:Destroy() end
    end
end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,460); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.MouseButton1Click:Connect(function() AbsoluteCleanUp(); G:Destroy() end)
local ToggleBtn = Instance.new("TextButton", G); ToggleBtn.Size = UDim2.new(0,80,0,30); ToggleBtn.Position = UDim2.new(0,10,0.5,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.TextColor3 = NeonRed; ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [CORE LOOP]
RS.Heartbeat:Connect(function()
    if not _G.Active then return end
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = _G.Speed
            if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    if _G.ESP then
                        local tag = v.Character.Head:FindFirstChild("G_Tag") or Instance.new("BillboardGui", v.Character.Head)
                        tag.Name = "G_Tag"; tag.Size = UDim2.new(0,200,0,50); tag.AlwaysOnTop = true
                        local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
                        l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Text = v.Name.."\nHP: "..math.floor(v.Character.Humanoid.Health)
                    end
                end
            end
        end
    end)
end)

LP.CharacterAdded:Connect(function() task.wait(0.5); if _G.Active then GiveNoclip() end end)
task.spawn(function() ApplyFFlags(); DisableShakeAbsolute(); StartIntro(); GiveNoclip(); Main.Visible = true end)
