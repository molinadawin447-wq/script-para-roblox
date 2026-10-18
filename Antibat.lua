-- ============================================================
-- ORVYN ANTI BAT (Reconstructed) 
--  BY BRIGHTER
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- File saving for keybind persistence
local keybindFile = "OrvynAntiBat_Keybind.txt"

-- Variables
local AntiBatEnabled = false
local InfiniteJumpEnabled = false
local InfiniteJumpHoldEnabled = false
local IsJumpingHold = false

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local AntiBatConn = nil
local AntiRagdollConn = nil
local JumpHoldConn = nil
local isMinimized = false

-- Keybinds
local CurrentKeybind = Enum.KeyCode.K
local WaitingForKeybind = false

-- Load saved keybind
local function loadKeybind()
    if isfile and isfile(keybindFile) then
        local success, savedData = pcall(function()
            return readfile(keybindFile)
        end)
        if success and savedData then
            for _, enum in ipairs(Enum.KeyCode:GetEnumItems()) do
                if enum.Name == savedData then
                    CurrentKeybind = enum
                    break
                end
            end
        end
    end
end

local function saveKeybind()
    if writefile then
        pcall(function()
            writefile(keybindFile, CurrentKeybind.Name)
        end)
    end
end

loadKeybind()

-- ==================== ANTI BAT CORE ====================
local function startAntiBat()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if AntiBatConn then AntiBatConn:Disconnect() end
    AntiBatConn = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
        RunService.RenderStepped:Wait()
        root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
    end)
end

local function stopAntiBat()
    if AntiBatConn then
        AntiBatConn:Disconnect()
        AntiBatConn = nil
    end
end

-- ==================== INFINITE JUMP LOGIC ====================
local function startJumpHoldLoop()
    if JumpHoldConn then JumpHoldConn:Disconnect() end
    JumpHoldConn = RunService.Heartbeat:Connect(function()
        if not InfiniteJumpHoldEnabled or not IsJumpingHold then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        IsJumpingHold = false
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

-- ==================== ANTI RAGDOLL ====================
local function startAntiRagdoll()
    if AntiRagdollConn then return end
    AntiRagdollConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum2 then
            local st = hum2:GetState()
            if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                hum2:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum2
                pcall(function()
                    local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
                end)
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            end
        end
    end)
end

local function stopAntiRagdoll()
    if AntiRagdollConn then
        AntiRagdollConn:Disconnect()
        AntiRagdollConn = nil
    end
end

-- Cleanup old UI
pcall(function()
    for _, old in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if old.Name == "MainFrame" or old.Name == "OrvynAntiBat" or old.Name == "EthernalHubAntiBat" or old.Name == "BananaHubAntiBat" or old.Name == "EternalHubAntiBat" then
            old:Destroy()
        end
    end
end)

-- ============================================================
-- UI CONSTRUCTION (from UI Grabber Pro output)
-- ============================================================
MainFrame_Gui = Instance.new("ScreenGui")
MainFrame_Gui.Name = "MainFrame"
MainFrame_Gui.DisplayOrder = 999999
MainFrame_Gui.Enabled = true
MainFrame_Gui.IgnoreGuiInset = true
MainFrame_Gui.ResetOnSpawn = false
MainFrame_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainFrame_Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local PW, PH = 220, 240
local MINI_H = 44

MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.None
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 28)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.LayoutOrder = 0
MainFrame.Position = UDim2.new(0.5, -PW / 2, 0.5, -PH / 2)
MainFrame.Rotation = 0
MainFrame.Size = UDim2.new(0, PW, 0, PH)
MainFrame.Visible = true
MainFrame.ZIndex = 1
MainFrame.Parent = MainFrame_Gui

UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(0, 16)
UICorner11.Parent = MainFrame

UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.ZIndex = 1
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke9.Color = Color3.fromRGB(40, 90, 230)
UIStroke9.Enabled = true
UIStroke9.LineJoinMode = Enum.LineJoinMode.Round
UIStroke9.Thickness = 1.8
UIStroke9.Transparency = 0
UIStroke9.Parent = MainFrame

-- ==================== HEADER ====================
Frame11 = Instance.new("Frame")
Frame11.Name = "Header"
Frame11.Active = false
Frame11.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame11.BackgroundTransparency = 1
Frame11.BorderSizePixel = 0
Frame11.Size = UDim2.new(1, 0, 0, 44)
Frame11.Parent = MainFrame

TextLabel6 = Instance.new("TextLabel")
TextLabel6.Name = "TitleLabel"
TextLabel6.BackgroundTransparency = 1
TextLabel6.Position = UDim2.new(0, 16, 0, 0)
TextLabel6.Size = UDim2.new(1, -50, 1, 0)
TextLabel6.Font = Enum.Font.GothamBlack
TextLabel6.Text = "ORVYN ANTI BAT"
TextLabel6.TextColor3 = Color3.fromRGB(170, 200, 255)
TextLabel6.TextSize = 14
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = Frame11

TextButton5 = Instance.new("TextButton")
TextButton5.Name = "MinimizeBtn"
TextButton5.Size = UDim2.new(0, 26, 0, 26)
TextButton5.Position = UDim2.new(1, -36, 0.5, -13)
TextButton5.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
TextButton5.BackgroundTransparency = 0.5
TextButton5.Text = "−"
TextButton5.TextColor3 = Color3.fromRGB(170, 200, 255)
TextButton5.Font = Enum.Font.GothamBold
TextButton5.TextSize = 16
TextButton5.BorderSizePixel = 0
TextButton5.Parent = Frame11

UICorner10 = Instance.new("UICorner")
UICorner10.CornerRadius = UDim.new(0, 6)
UICorner10.Parent = TextButton5

UIStroke8 = Instance.new("UIStroke")
UIStroke8.Color = Color3.fromRGB(40, 90, 230)
UIStroke8.Thickness = 1
UIStroke8.Parent = TextButton5

-- ==================== CONTENT CONTAINER ====================
Frame = Instance.new("Frame")
Frame.Name = "Content"
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(0, 16, 0, 44)
Frame.Size = UDim2.new(1, -32, 1, -56)
Frame.BorderSizePixel = 0
Frame.Parent = MainFrame

UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Frame

-- ==================== ROW 1: STATUS ====================
Frame7 = Instance.new("Frame")
Frame7.Name = "StatusRow"
Frame7.LayoutOrder = 1
Frame7.BackgroundTransparency = 1
Frame7.Size = UDim2.new(1, 0, 0, 18)
Frame7.BorderSizePixel = 0
Frame7.Parent = Frame

TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "StatusLabel"
TextLabel3.BackgroundTransparency = 1
TextLabel3.Size = UDim2.new(1, 0, 1, 0)
TextLabel3.Font = Enum.Font.GothamBlack
TextLabel3.Text = "STATUS: OFF"
TextLabel3.TextColor3 = Color3.fromRGB(255, 70, 100)
TextLabel3.TextSize = 12
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = Frame7

-- ==================== ROW 2: ACTIVATE ANTI BAT ====================
Frame6 = Instance.new("Frame")
Frame6.Name = "ActivateRow"
Frame6.LayoutOrder = 2
Frame6.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Frame6.BackgroundTransparency = 0.55
Frame6.Size = UDim2.new(1, 0, 0, 38)
Frame6.BorderSizePixel = 0
Frame6.Parent = Frame

UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0, 8)
UICorner6.Parent = Frame6

UIStroke5 = Instance.new("UIStroke")
UIStroke5.Color = Color3.fromRGB(40, 90, 230)
UIStroke5.Thickness = 1.2
UIStroke5.Parent = Frame6

TextButton3 = Instance.new("TextButton")
TextButton3.Name = "ActivateBtn"
TextButton3.BackgroundTransparency = 1
TextButton3.Size = UDim2.new(1, 0, 1, 0)
TextButton3.Font = Enum.Font.GothamBlack
TextButton3.Text = "ACTIVATE ANTI BAT"
TextButton3.TextColor3 = Color3.fromRGB(170, 200, 255)
TextButton3.TextSize = 11
TextButton3.BorderSizePixel = 0
TextButton3.Parent = Frame6

-- ==================== ROW 3: INF JUMP (NORMAL) ====================
Frame2 = Instance.new("Frame")
Frame2.Name = "InfJumpNormalRow"
Frame2.LayoutOrder = 3
Frame2.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Frame2.BackgroundTransparency = 0.55
Frame2.Size = UDim2.new(1, 0, 0, 32)
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame

UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = Frame2

UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(140, 90, 220)
UIStroke2.Thickness = 1.2
UIStroke2.Parent = Frame2

TextLabel = Instance.new("TextLabel")
TextLabel.Name = "Label"
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 12, 0, 0)
TextLabel.Size = UDim2.new(0.6, 0, 1, 0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Inf Jump (Normal)"
TextLabel.TextColor3 = Color3.fromRGB(170, 200, 255)
TextLabel.TextSize = 11
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame2

-- Toggle pill
Frame3 = Instance.new("Frame")
Frame3.Name = "TogglePill"
Frame3.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
Frame3.BackgroundTransparency = 0.3
Frame3.Position = UDim2.new(1, -50, 0.5, -9)
Frame3.Size = UDim2.new(0, 38, 0, 18)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame2

UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 9)
UICorner2.Parent = Frame3

UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(40, 90, 230)
UIStroke.Thickness = 1.2
UIStroke.Parent = Frame3

-- Toggle knob
Frame4 = Instance.new("Frame")
Frame4.Name = "ToggleKnob"
Frame4.BackgroundColor3 = Color3.fromRGB(220, 210, 240)
Frame4.Position = UDim2.new(0, 3, 0.5, -6)
Frame4.Size = UDim2.new(0, 12, 0, 12)
Frame4.BorderSizePixel = 0
Frame4.Parent = Frame3

UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame4

-- Click area
TextButton = Instance.new("TextButton")
TextButton.Name = "ClickArea"
TextButton.BackgroundTransparency = 1
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.Text = ""
TextButton.BorderSizePixel = 0
TextButton.Parent = Frame2

-- ==================== ROW 4: INF JUMP (HOLD) ====================
Frame8 = Instance.new("Frame")
Frame8.Name = "InfJumpHoldRow"
Frame8.LayoutOrder = 4
Frame8.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Frame8.BackgroundTransparency = 0.55
Frame8.Size = UDim2.new(1, 0, 0, 32)
Frame8.BorderSizePixel = 0
Frame8.Parent = Frame

UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(0, 8)
UICorner9.Parent = Frame8

UIStroke7 = Instance.new("UIStroke")
UIStroke7.Color = Color3.fromRGB(140, 90, 220)
UIStroke7.Thickness = 1.2
UIStroke7.Parent = Frame8

TextLabel4 = Instance.new("TextLabel")
TextLabel4.Name = "Label"
TextLabel4.BackgroundTransparency = 1
TextLabel4.Position = UDim2.new(0, 12, 0, 0)
TextLabel4.Size = UDim2.new(0.6, 0, 1, 0)
TextLabel4.Font = Enum.Font.GothamBold
TextLabel4.Text = "Inf Jump (Hold)"
TextLabel4.TextColor3 = Color3.fromRGB(170, 200, 255)
TextLabel4.TextSize = 11
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.Parent = Frame8

-- Toggle pill
Frame9 = Instance.new("Frame")
Frame9.Name = "TogglePill"
Frame9.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
Frame9.BackgroundTransparency = 0.3
Frame9.Position = UDim2.new(1, -50, 0.5, -9)
Frame9.Size = UDim2.new(0, 38, 0, 18)
Frame9.BorderSizePixel = 0
Frame9.Parent = Frame8

UICorner8 = Instance.new("UICorner")
UICorner8.CornerRadius = UDim.new(0, 9)
UICorner8.Parent = Frame9

UIStroke6 = Instance.new("UIStroke")
UIStroke6.Color = Color3.fromRGB(40, 90, 230)
UIStroke6.Thickness = 1.2
UIStroke6.Parent = Frame9

-- Toggle knob
Frame10 = Instance.new("Frame")
Frame10.Name = "ToggleKnob"
Frame10.BackgroundColor3 = Color3.fromRGB(220, 210, 240)
Frame10.Position = UDim2.new(0, 3, 0.5, -6)
Frame10.Size = UDim2.new(0, 12, 0, 12)
Frame10.BorderSizePixel = 0
Frame10.Parent = Frame9

UICorner7 = Instance.new("UICorner")
UICorner7.CornerRadius = UDim.new(0, 6)
UICorner7.Parent = Frame10

-- Click area
TextButton4 = Instance.new("TextButton")
TextButton4.Name = "ClickArea"
TextButton4.BackgroundTransparency = 1
TextButton4.Size = UDim2.new(1, 0, 1, 0)
TextButton4.Text = ""
TextButton4.BorderSizePixel = 0
TextButton4.Parent = Frame8

-- ==================== ROW 5: INTERACTION KEY ====================
Frame5 = Instance.new("Frame")
Frame5.Name = "KeybindRow"
Frame5.LayoutOrder = 5
Frame5.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
Frame5.BackgroundTransparency = 0.55
Frame5.Size = UDim2.new(1, 0, 0, 32)
Frame5.BorderSizePixel = 0
Frame5.Parent = Frame

UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 8)
UICorner5.Parent = Frame5

UIStroke4 = Instance.new("UIStroke")
UIStroke4.Color = Color3.fromRGB(140, 90, 220)
UIStroke4.Thickness = 1.2
UIStroke4.Parent = Frame5

TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "Label"
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(0, 12, 0, 0)
TextLabel2.Size = UDim2.new(0.5, 0, 1, 0)
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.Text = "Interaction Key"
TextLabel2.TextColor3 = Color3.fromRGB(170, 200, 255)
TextLabel2.TextSize = 11
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame5

TextButton2 = Instance.new("TextButton")
TextButton2.Name = "KeybindBtn"
TextButton2.Size = UDim2.new(0, 75, 0, 20)
TextButton2.Position = UDim2.new(1, -87, 0.5, -10)
TextButton2.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
TextButton2.BackgroundTransparency = 0.2
TextButton2.Text = "[ " .. CurrentKeybind.Name .. " ]"
TextButton2.TextColor3 = Color3.fromRGB(40, 90, 230)
TextButton2.Font = Enum.Font.GothamBlack
TextButton2.TextSize = 10
TextButton2.BorderSizePixel = 0
TextButton2.Parent = Frame5

UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 5)
UICorner4.Parent = TextButton2

UIStroke3 = Instance.new("UIStroke")
UIStroke3.Color = Color3.fromRGB(40, 90, 230)
UIStroke3.Thickness = 1
UIStroke3.Parent = TextButton2

-- ==================== ROW 6: FOOTER ====================
TextLabel5 = Instance.new("TextLabel")
TextLabel5.Name = "Footer"
TextLabel5.LayoutOrder = 6
TextLabel5.BackgroundTransparency = 1
TextLabel5.Size = UDim2.new(1, 0, 0, 16)
TextLabel5.Font = Enum.Font.Code
TextLabel5.Text = ".gg/ethernalhub"
TextLabel5.TextColor3 = Color3.fromRGB(220, 210, 240)
TextLabel5.TextSize = 10
TextLabel5.Parent = Frame

-- ============================================================
-- DRAG SYSTEM
-- ============================================================
local dragging, dragStart, startPos

Frame11.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================================
-- MINIMIZE SYSTEM
-- ============================================================
local function toggleMinimize()
    isMinimized = not isMinimized
    local targetHeight = isMinimized and MINI_H or PH
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, PW, 0, targetHeight)
    }):Play()
    Frame.Visible = not isMinimized
    TextButton5.Text = isMinimized and "+" or "−"
end

TextButton5.MouseButton1Click:Connect(toggleMinimize)

-- ============================================================
-- VISUAL TOGGLE LOGIC
-- ============================================================
local function setVisuals(dot, pillStroke, enabled)
    TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(220, 210, 240)
    }):Play()
    TweenService:Create(pillStroke, TweenInfo.new(0.2), {
        Color = enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(40, 90, 230)
    }):Play()
end

local function updateUI()
    if AntiBatEnabled then
        UIStroke5.Color = Color3.fromRGB(0, 255, 140)
        TextButton3.Text = "DEACTIVATE ANTI BAT"
        TextLabel3.Text = "STATUS: ON"
        TextLabel3.TextColor3 = Color3.fromRGB(0, 255, 140)
    else
        UIStroke5.Color = Color3.fromRGB(40, 90, 230)
        TextButton3.Text = "ACTIVATE ANTI BAT"
        TextLabel3.Text = "STATUS: OFF"
        TextLabel3.TextColor3 = Color3.fromRGB(255, 70, 100)
    end
    TextButton2.Text = WaitingForKeybind and "[ ... ]" or "[ " .. CurrentKeybind.Name .. " ]"
end

-- ============================================================
-- BUTTON CONNECTIONS
-- ============================================================

-- Activate / Deactivate Anti Bat
TextButton3.MouseButton1Click:Connect(function()
    AntiBatEnabled = not AntiBatEnabled
    if AntiBatEnabled then startAntiBat() else stopAntiBat() end
    updateUI()
    saveKeybind()
end)

-- Toggle Inf Jump (Normal)
TextButton.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    setVisuals(Frame4, UIStroke, InfiniteJumpEnabled)
end)

-- Toggle Inf Jump (Hold)
TextButton4.MouseButton1Click:Connect(function()
    InfiniteJumpHoldEnabled = not InfiniteJumpHoldEnabled
    setVisuals(Frame10, UIStroke6, InfiniteJumpHoldEnabled)
    if not InfiniteJumpHoldEnabled then
        IsJumpingHold = false
    end
end)

-- Keybind button
TextButton2.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = true
    updateUI()
end)

-- Keybind input + interaction key toggle
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
        CurrentKeybind = inp.KeyCode
        WaitingForKeybind = false
        updateUI()
        saveKeybind()
    elseif not WaitingForKeybind and inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == CurrentKeybind then
            AntiBatEnabled = not AntiBatEnabled
            if AntiBatEnabled then startAntiBat() else stopAntiBat() end
            updateUI()
            saveKeybind()
        end
    end
end)

-- ============================================================
-- CHARACTER RESPAWN HANDLER
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
    if AntiBatEnabled then
        task.wait(0.3)
        startAntiBat()
    end
    task.wait(0.5)
    startAntiRagdoll()
end)

-- ============================================================
-- INIT
-- ============================================================
startAntiRagdoll()
startJumpHoldLoop()
updateUI()
setVisuals(Frame4, UIStroke, InfiniteJumpEnabled)
setVisuals(Frame10, UIStroke6, InfiniteJumpHoldEnabled)

print("ORVYN ANTI BAT - Loaded!")