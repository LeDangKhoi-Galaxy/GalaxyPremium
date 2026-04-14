--[[ 
    GALAXY PREMIUM v6.7 - NOCLIP RESTORED
    - FIXED: Auto-Spawn Noclip Tool (Cầm trên tay để xuyên tường).
    - RETAINED: Full Intro v4.4 & Loop Speed Core.
    - FEATURES: Fly Up, TP Void, ESP, Aim, Auto Block.
    - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- BIẾN HỆ THỐNG
_G.Active = true
_G.TargetName = ""; _G.Speed = 16; _G.Fly = false; 
_G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.LoopTP = false; _G.Bring = false; _G.VoidActive = false
local blockTick = 0
local LastPosBeforeVoid = nil
local CurrentVoidPlate = nil

-- DỌN DẸP
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name:find("Galaxy") then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Galaxy_"..math.random(1000,9999); G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- [HỆ THỐNG NOCLIP TOOL]
local function GiveNoclip()
    if not _G.Active then return end
    local Tool = Instance.new("Tool")
    Tool.Name = "Noclip"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false
    Tool.ToolTip = "Cầm để đi xuyên tường"
    Tool.Parent = LP.Backpack
end

-- Xử lý xuyên tường khi cầm Tool
RS.Stepped:Connect(function()
    if _G.Active and LP.Character then
        if LP.Character:FindFirstChild("Noclip") then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

LP.CharacterAdded:Connect(function() task.wait(0.5); GiveNoclip() end)

-- [INTRO V4.4]
local function StartIntro()
    local Overlay = Instance.new("Frame", G); Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.new(0, 0, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 100
    local IntroBox = Instance.new("Frame", Overlay); IntroBox.Size = UDim2.new(0, 400, 0, 100); IntroBox.Position = UDim2.new(0.5, -200, 0.5, -50); IntroBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10); IntroBox.BackgroundTransparency = 1
    local BoxStroke = Instance.new("UIStroke", IntroBox); BoxStroke.Color = NeonRed; BoxStroke.Thickness = 2; BoxStroke.Transparency = 1
    local IntroText = Instance.new("TextLabel", IntroBox); IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "GALAXY Premium By LeDangKhoi"; IntroText.TextColor3 = NeonRed; IntroText.Font = Enum.Font.SourceSansBold; IntroText.TextSize = 25; IntroText.TextTransparency = 1
    
    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.5)
    TS:Create(IntroBox, TweenInfo.new(0.8), {BackgroundTransparency = 0.2}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TS:Create(IntroText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    
    task.wait(2.2)
    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(IntroBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TS:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    Overlay:Destroy()
    
    Main.Visible = true
end

-- [GIAO DIỆN CHÍNH]
local Main = Instance.new("Frame", G); Main.Visible = false; Main.Size = UDim2.new(0, 220, 0, 520); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = NeonRed
local SubMenu = Instance.new("Frame", G); SubMenu.Visible = false; SubMenu.Size = UDim2.new(0, 200, 0, 260); SubMenu.Position = UDim2.new(0.5, 10, 0.3, 0); SubMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15); SubMenu.Active = true; SubMenu.Draggable = true; Instance.new("UIStroke", SubMenu).Color = NeonRed

local function CreateTitle(p, txt)
    local T = Instance.new("TextLabel", p); T.Size = UDim2.new(1, 0, 0, 40); T.BackgroundColor3 = NeonRed; T.Text = txt; T.TextColor3 = Color3.new(1,1,1); T.Font = Enum.Font.SourceSansBold; T.TextSize = 16
end
CreateTitle(Main, "GALAXY Premium - LeDangKhoi")
CreateTitle(SubMenu, "PLAYER TOOL")

local function AddMainBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddMainBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddMainBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddMainBtn("FLY MODE", 160, function(v) _G.Fly = v end)
AddMainBtn("PLAYER ESP", 215, function(v) _G.ESP = v end)
AddMainBtn("PLAYER TOOL", 270, function(v) SubMenu.Visible = v end)
AddMainBtn("TP TO VOID", 325, function(v) 
    _G.VoidActive = v 
    if v and LP.Character then 
        LastPosBeforeVoid = LP.Character.HumanoidRootPart.CFrame
        CurrentVoidPlate = CurrentVoidPlate or Instance.new("Part", workspace)
        CurrentVoidPlate.Size = Vector3.new(2048, 1, 2048); CurrentVoidPlate.Anchored = true; CurrentVoidPlate.Color = NeonRed; CurrentVoidPlate.Position = Vector3.new(LP.Character.HumanoidRootPart.Position.X, -500, LP.Character.HumanoidRootPart.Position.Z)
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentVoidPlate.Position + Vector3.new(0, 5, 0))
    elseif not v and LP.Character then 
        LP.Character.HumanoidRootPart.CFrame = LastPosBeforeVoid or CFrame.new(0, 50, 0) 
    end 
end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 380); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.PlaceholderText = "TỐC ĐỘ (16)"; Inp.Text = ""; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18
Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,435); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold
Close.MouseButton1Click:Connect(function() _G.Active = false; G:Destroy() end)

local ToggleBtn = Instance.new("TextButton", G); ToggleBtn.Visible = true; ToggleBtn.Size = UDim2.new(0, 85, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0); ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.TextColor3 = NeonRed; ToggleBtn.Font = Enum.Font.SourceSansBold; ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [HEARTBEAT LOOP]
RS.Heartbeat:Connect(function()
    if not _G.Active then return end
    pcall(function()
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if hum and hum.WalkSpeed ~= _G.Speed then hum.WalkSpeed = _G.Speed end
        if _G.Fly and hrp then hrp.Velocity = Vector3.new(0, 50, 0) end
        
        -- ESP & AIM Logic (Tối giản để tránh lag)
        if _G.ESP or _G.Aim then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    local head = v.Character.Head
                    if _G.ESP then
                        local tag = head:FindFirstChild("G_Tag") or Instance.new("BillboardGui", head)
                        tag.Name = "G_Tag"; tag.Size = UDim2.new(0,100,0,50); tag.AlwaysOnTop = true
                        local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
                        l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Text = v.Name
                    end
                end
            end
        end
    end)
end)

task.spawn(function() StartIntro(); GiveNoclip() end)
