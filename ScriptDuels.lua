local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlazzenDuelsUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Colores
local blueDark = Color3.fromRGB(70, 120, 230)
local blueLight = Color3.fromRGB(150, 200, 255)
local blueActive = Color3.fromRGB(110, 175, 255)
local blueActiveDark = Color3.fromRGB(70, 125, 220)
local panelDark = Color3.fromRGB(0, 0, 0)

-- =========================================================
-- Variables de entorno
-- =========================================================
local LP = player
local _CFnew = CFrame.new
local _V3zero = Vector3.new(0, 0, 0)
local _V3new = Vector3.new
local _tick = tick
local UIS = UserInputService
local NS = 30 
local AP = { 
    L1 = Vector3.new(-10, 0, 0), L2 = Vector3.new(-20, 0, 0), L_FACE = Vector3.new(-10, 0, 10),
    R1 = Vector3.new(10, 0, 0), R2 = Vector3.new(20, 0, 0), R_FACE = Vector3.new(10, 0, 10)
}

-- Variables de estado
local autoLeftEnabled = false
local autoRightEnabled = false
local dropActive = false
local batDesyncTpEnabled = false
local infJumpEnabled = false
local infJumpMode = "HOLD"

-- =========================================================
-- MÓDULO DE ESTADOS PARA EL CUSTOM TAB
-- =========================================================
local CustomFeatures = {
    AutoBat = false, BatAimbot = false, BatBypass = false,
    BodyLock = false, SafeMode = false, NoPlayerCollision = false,
    AntiRagdoll = false, Unwalk = false, AntiDie = false,
    DropBrainrot = false, MedusaCounter = false
}

-- Stubs para evitar errores
_G.AmbitiousSafeModeTryStart = _G.AmbitiousSafeModeTryStart or function() return true end
_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump or {
    holdPressed = false, holdActive = false, controllerActive = false, mobilePressed = false, mobileActive = false, hooked = {}
}

-- Funciones de Inf Jump
function _G._jumpEnsureProxy()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
function _G.AmbitiousApplyNormalInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local proxy = _G._jumpEnsureProxy()
    if hum and hum.Health > 0 and proxy then
        local curVel = proxy.Velocity
        proxy.Velocity = _V3new(curVel.X, boost or 50, curVel.Z)
    end
end
function _G.AmbitiousStopNormalInfJumpHoldState()
    local S = _G.AmbitiousNormalInfJump
    S.holdPressed = false; S.holdActive = false; S.controllerActive = false; S.mobilePressed = false; S.mobileActive = false
end

UIS.JumpRequest:Connect(function() _G.AmbitiousApplyNormalInfJumpBoost(50) end)

UIS.InputBegan:Connect(function(input)
    if UIS:GetFocusedTextBox() then return end
    local S = _G.AmbitiousNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        if infJumpMode == "MANUAL" then return end
        S.holdPressed = true
        task.delay(0.12, function()
            if S.holdPressed and infJumpEnabled then S.holdActive = true; _G.AmbitiousApplyNormalInfJumpBoost(50) end
        end)
    end
end)

UIS.InputEnded:Connect(function(input)
    local S = _G.AmbitiousNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        S.holdPressed = false; S.holdActive = false
    end
end)

RunService.Heartbeat:Connect(function()
    local S = _G.AmbitiousNormalInfJump
    if infJumpEnabled and infJumpMode == "HOLD" and (S.holdActive or S.mobileActive) then
        _G.AmbitiousApplyNormalInfJumpBoost(50)
    end
end)

function _G.setInfJumpInternal(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _G.AmbitiousStopNormalInfJumpHoldState()
        local hrp = _G._jumpEnsureProxy()
        if hrp then pcall(function() hrp.Velocity = _V3zero end) end
    end
end

InfiniteJump = {
    start = function() _G.setInfJumpInternal(true) end,
    stop = function() _G.setInfJumpInternal(false) end,
    isRunning = function() return infJumpEnabled == true end,
}

-- TP BAT Logic
local batDesyncTpConn = nil
function startAlvaroTP()
    if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
    batDesyncTpEnabled = true
    batDesyncTpConn = RunService.Heartbeat:Connect(function() end) 
end
function stopAlvaroTP()
    batDesyncTpEnabled = false
    if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
end
function toggleBatDesyncTp()
    if batDesyncTpEnabled then stopAlvaroTP()
    else
        if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
        if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
        startAlvaroTP()
    end
end

-- Drop BR Logic
local _dropConn = nil
function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        dropActive = true
        task.wait(1.5)
        dropActive = false
        if setVisual then setVisual(false) end
    end)
end

-- INSTA RESET Logic
local _lastInstaResetRequest = 0
local function instaResetFast()
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then pcall(function() humanoid.Health = 0 end) end
end
local function instaReset()
    local now = os.clock()
    if now - _lastInstaResetRequest < 0.75 then return end
    _lastInstaResetRequest = now
    instaResetFast()
end

-- Auto Left/Right Logic
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(_V3zero, false) end
end
local function startAutoLeft()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local d = AP.L1 - root.Position; local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
            if (AP.L1 - root.Position).Magnitude < 1 then alPhase = 2 end
        elseif alPhase == 2 then
            local d = AP.L2 - root.Position; local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
            if (AP.L2 - root.Position).Magnitude < 1 then hum:Move(_V3zero, false); autoLeftEnabled = false; stopAutoLeft() end
        end
    end)
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(_V3zero, false) end
end
local function startAutoRight()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local d = AP.R1 - root.Position; local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
            if (AP.R1 - root.Position).Magnitude < 1 then arPhase = 2 end
        elseif arPhase == 2 then
            local d = AP.R2 - root.Position; local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
            if (AP.R2 - root.Position).Magnitude < 1 then hum:Move(_V3zero, false); autoRightEnabled = false; stopAutoRight() end
        end
    end)
end

-- =========================================================
-- Persistencia y HUD
-- =========================================================
local SAVE_FILE = "BlazzenDuelsUI.json"
local hasFileAPI = (type(writefile) == "function") and (type(readfile) == "function") and (type(isfile) == "function")

local uiState = {
    panelPosition = nil, speeds = { normal = 30, carry = 29, laggerNormal = 24, laggerCarry = 14.5 },
    currentMode = "normal", activeTab = "SPEED", autoCarryEnabled = false,
}
local function saveSettings()
    if not hasFileAPI then return end
    pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(uiState)) end)
end
local function loadSettings()
    if not hasFileAPI then return nil end
    local ok, content = pcall(function() if isfile(SAVE_FILE) then return readfile(SAVE_FILE) end end)
    if ok and content then
        local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if ok2 then return decoded end
    end
    return nil
end

local normalSpeedValue, carrySpeedValue = 30, 29
local laggerNormalSpeedValue, laggerCarrySpeedValue = 24, 14.5
local currentMode = "normal"
local autoCarryEnabled, autoCarryActivated = false, false
local modeLabels = { normal = "NORMAL", carry = "CARRY SPD", laggerNormal = "LAGGER NORMAL", laggerCarry = "LAGGER CARRY" }

local speedLabel, renderConnection = nil, nil
local function createSpeedLabel()
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return nil end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 140, 0, 35)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "0.0 SPEED"
    label.TextColor3 = blueLight
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0.5
    label.Parent = billboard
    return label
end
local function updateSpeedLabel()
    if not speedLabel then return end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    speedLabel.Text = hum and string.format("%.1f SPEED", hum.WalkSpeed) or "0.0 SPEED"
end
local function setupSpeedHud()
    if speedLabel then speedLabel.Parent:Destroy() end
    speedLabel = createSpeedLabel()
    if renderConnection then renderConnection:Disconnect() end
    renderConnection = RunService.RenderStepped:Connect(updateSpeedLabel)
end
player.CharacterAdded:Connect(function() task.wait(0.1); setupSpeedHud() end)

local currentModeValueLabel, modeButtonRefs = nil, {}
local function updateCurrentModeDisplay()
    if currentModeValueLabel then currentModeValueLabel.Text = modeLabels[currentMode] or "NORMAL" end
end
local function updateModeButtons()
    for mode, btn in pairs(modeButtonRefs) do
        if btn then
            btn.BackgroundColor3 = (currentMode == mode) and blueActive or Color3.fromRGB(0, 0, 0)
            btn.TextColor3 = (currentMode == mode) and Color3.fromRGB(255, 255, 255) or blueLight
        end
    end
end
local function applyCurrentSpeed()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        local s = normalSpeedValue
        if currentMode == "carry" then s = carrySpeedValue
        elseif currentMode == "laggerNormal" then s = laggerNormalSpeedValue
        elseif currentMode == "laggerCarry" then s = laggerCarrySpeedValue end
        hum.WalkSpeed = s
    end
    updateSpeedLabel(); updateCurrentModeDisplay(); updateModeButtons()
end
local function setMode(mode)
    currentMode = (currentMode == mode) and "normal" or mode
    uiState.currentMode = currentMode
    applyCurrentSpeed(); saveSettings()
end
local function clampSpeed(value) local n = tonumber(value); if n then return math.clamp(n, 0, 68) end end
local function formatSpeedNumber(value) return (value == math.floor(value)) and tostring(value) or string.format("%.1f", value) end
local function roundValue(value) return math.floor(value * 10 + 0.5) / 10 end

-- =========================================================
-- UI Principal
-- =========================================================
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 170, 0, 44)
openButton.Position = UDim2.new(0.015, 0, 0.5, -70)
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.Text = "BLAZZEN"
openButton.TextColor3 = blueLight
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 19
openButton.Parent = screenGui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 12)

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 265, 0, 410)
panel.Position = UDim2.new(0, -300, 0.5, -205)
panel.BackgroundColor3 = panelDark
panel.Visible = false
panel.Parent = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -38, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = panel
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 0, 270)
scrollFrame.Position = UDim2.new(0, 8, 0, 108)
scrollFrame.BackgroundTransparency = 1
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = panel

-- =========================================================
-- PESTAÑAS BASE
-- =========================================================
local speedContent = Instance.new("Frame")
speedContent.Size = UDim2.new(1, 0, 0, 0)
speedContent.AutomaticSize = Enum.AutomaticSize.Y
speedContent.BackgroundTransparency = 1
speedContent.Parent = scrollFrame

-- (Lógica visual de Speed mantenida)
local function createSpeedRow(parent, yPos, labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -30, 0, 24); row.Position = UDim2.new(0, 15, 0, yPos); row.BackgroundTransparency = 1; row.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = blueLight; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 55, 0, 22); box.Position = UDim2.new(1, -55, 0.5, -11); box.BackgroundColor3 = Color3.fromRGB(0, 0, 0); box.TextColor3 = blueLight; box.Font = Enum.Font.GothamBold; box.TextSize = 12; box.Parent = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

local normalSpeedBox = createSpeedRow(speedContent, 18, "NORMAL SPEED")
local carrySpeedBox = createSpeedRow(speedContent, 44, "CARRY SPD")
local laggerNormalSpeedBox = createSpeedRow(speedContent, 70, "LAGGER NORMAL")
local laggerCarrySpeedBox = createSpeedRow(speedContent, 96, "LAGGER CARRY")

local function bindSpeedBox(box, getValue, setValue)
    local previousValue = getValue(); box.Text = formatSpeedNumber(previousValue)
    box.FocusLost:Connect(function()
        local value = clampSpeed(box.Text)
        if value then previousValue = roundValue(value); box.Text = formatSpeedNumber(previousValue); setValue(previousValue); applyCurrentSpeed(); saveSettings() 
        else box.Text = formatSpeedNumber(previousValue) end
    end)
end
bindSpeedBox(normalSpeedBox, function() return normalSpeedValue end, function(v) normalSpeedValue = v; uiState.speeds.normal = v end)
bindSpeedBox(carrySpeedBox, function() return carrySpeedValue end, function(v) carrySpeedValue = v; uiState.speeds.carry = v end)
bindSpeedBox(laggerNormalSpeedBox, function() return laggerNormalSpeedValue end, function(v) laggerNormalSpeedValue = v; uiState.speeds.laggerNormal = v end)
bindSpeedBox(laggerCarrySpeedBox, function() return laggerCarrySpeedValue end, function(v) laggerCarrySpeedValue = v; uiState.speeds.laggerCarry = v end)

-- =========================================================
-- PESTAÑA CUSTOM
-- =========================================================
local customContent = Instance.new("Frame")
customContent.Size = UDim2.new(1, 0, 0, 0)
customContent.AutomaticSize = Enum.AutomaticSize.Y
customContent.BackgroundTransparency = 1
customContent.Visible = false
customContent.Parent = scrollFrame

local customUI = Instance.new("UIListLayout")
customUI.Padding = UDim.new(0, 8)
customUI.Parent = customContent

local function createCustomSection(titleText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundTransparency = 1
    section.Parent = customContent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = blueLight
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = section
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 24)
    padding.Parent = section
    return section
end

local function createCustomToggle(parent, featureKey, labelText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24); row.BackgroundTransparency = 1; row.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = blueLight; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20); toggle.Position = UDim2.new(1, -40, 0.5, -10); toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50); toggle.Text = ""; toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 16, 0, 16); ball.Position = UDim2.new(0, 2, 0.5, -8); ball.BackgroundColor3 = Color3.fromRGB(180, 180, 190); ball.Parent = toggle
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

    local function updateVisual(state)
        toggle.BackgroundColor3 = state and blueDark or Color3.fromRGB(40, 40, 50)
        ball.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ball.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
    end
    toggle.MouseButton1Click:Connect(function()
        CustomFeatures[featureKey] = not CustomFeatures[featureKey]
        updateVisual(CustomFeatures[featureKey])
    end)
    updateVisual(CustomFeatures[featureKey])
end

local aimbotSection = createCustomSection("- AIMBOTS")
createCustomToggle(aimbotSection, "AutoBat", "Auto Bat")
createCustomToggle(aimbotSection, "BatAimbot", "Bat Aimbot")

local countersSection = createCustomSection("- COUNTERS")
createCustomToggle(countersSection, "BatCounter", "Bat Counter")
createCustomToggle(countersSection, "BatCounterV2", "Bat Counter V2")
createCustomToggle(countersSection, "MedusaCounter", "Medusa Counter")

-- =========================================================
-- PESTAÑA VISUAL (NUEVA - BASADA EN TUS IMÁGENES)
-- =========================================================
local visualContent = Instance.new("Frame")
visualContent.Size = UDim2.new(1, 0, 0, 0)
visualContent.AutomaticSize = Enum.AutomaticSize.Y
visualContent.BackgroundTransparency = 1
visualContent.Visible = false
visualContent.Parent = scrollFrame

local visualUI = Instance.new("UIListLayout")
visualUI.Padding = UDim.new(0, 8)
visualUI.Parent = visualContent

-- Funciones Auxiliares para la UI Visual
local function createVisualSection(titleText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundTransparency = 1
    section.Parent = visualContent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = blueLight
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = section
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 24)
    padding.Parent = section
    return section
end

local function createVisualToggle(parent, labelText, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24); row.BackgroundTransparency = 1; row.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = blueLight; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20); toggle.Position = UDim2.new(1, -40, 0.5, -10); toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50); toggle.Text = ""; toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 16, 0, 16); ball.Position = UDim2.new(0, 2, 0.5, -8); ball.BackgroundColor3 = Color3.fromRGB(180, 180, 190); ball.Parent = toggle
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

    local state = defaultValue or false
    local function updateVisual(animate)
        local info = TweenInfo.new(0.2)
        if animate then
            TweenService:Create(toggle, info, {BackgroundColor3 = state and blueDark or Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(ball, info, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)}):Play()
        else
            toggle.BackgroundColor3 = state and blueDark or Color3.fromRGB(40, 40, 50)
            ball.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ball.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
        end
    end
    toggle.MouseButton1Click:Connect(function() state = not state; updateVisual(true) end)
    updateVisual(false)
    return toggle
end

-- Dropdown (Simula el estilo de la imagen: | Texto ......... v)
local function createVisualDropdown(parent, labelText, defaultText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24); row.BackgroundTransparency = 1; row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 80, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = blueLight; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0); btn.Position = UDim2.new(1, -100, 0, 0); btn.BackgroundTransparency = 1; btn.Text = defaultText .. "  ••••"; btn.TextColor3 = blueLight; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Right; btn.Parent = row
    
    btn.MouseButton1Click:Connect(function()
        -- Aquí puedes añadir la lógica real del dropdown
        print("Dropdown clicked: " .. labelText)
    end)
end

-- 1. Interface
local intSection = createVisualSection("- INTERFACE")
createVisualToggle(intSection, "Edit Button", true)
createVisualToggle(intSection, "Lock UI", false)
createVisualToggle(intSection, "Player ESP", false)

-- 2. Camera
local camSection = createVisualSection("- CAMERA")
createVisualToggle(camSection, "FOV", false)
createVisualToggle(camSection, "FOV Value", true)
createVisualToggle(camSection, "No Cam Collision", false)

-- 3. Performance
local perfSection = createVisualSection("- PERFORMANCE")
createVisualToggle(perfSection, "Anti Lag", false)
createVisualToggle(perfSection, "Show E01 Warning", true)

-- 4. Environment
local envSection = createVisualSection("- ENVIRONMENT")
createVisualDropdown(envSection, "Sky Theme", "Off")

-- 5. Personalización
local persSection = createVisualSection("- PERSONALIZACIÓN")
createVisualToggle(persSection, "Bat Skin", false)
createVisualToggle(persSection, "Minecraft Bat", false)
createVisualDropdown(persSection, "MC Bat Color", "Crimson Night")
createVisualDropdown(persSection, "Anim Pack", "Off")
createVisualDropdown(persSection, "Outfit", "Outfit 2")
createVisualDropdown(persSection, "Background", "BG 2")

-- =========================================================
-- Pestaña KEYBINDS
-- =========================================================
local keybindsContent = Instance.new("Frame")
keybindsContent.Size = UDim2.new(1, 0, 0, 0)
keybindsContent.AutomaticSize = Enum.AutomaticSize.Y
keybindsContent.BackgroundTransparency = 1
keybindsContent.Visible = false
keybindsContent.Parent = scrollFrame

-- =========================================================
-- Sistema de Pestañas
-- =========================================================
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 32)
tabBar.Position = UDim2.new(0, 10, 1, -42)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel
local tabList = Instance.new("UIListLayout", tabBar)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.Padding = UDim.new(0, 2)

local tabContents = { SPEED = speedContent, CUSTOM = customContent, VISUAL = visualContent, KEYBINDS = keybindsContent }
local tabButtons = {}
local activeTab = "SPEED"

local function setActiveTab(tabName)
    activeTab = tabName
    for name, content in pairs(tabContents) do content.Visible = (name == tabName) end
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (name == tabName) and blueDark or Color3.fromRGB(0,0,0)
        btn.TextColor3 = (name == tabName) and blueLight or Color3.fromRGB(130, 160, 200)
    end
    scrollFrame.CanvasPosition = Vector2.new(0, 0)
end

for i, tabName in ipairs({"SPEED", "CUSTOM", "VISUAL", "KEYBINDS"}) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 55, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[tabName] = tabBtn
    tabBtn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
end

-- =========================================================
-- Botones Derecha (Mantenidos)
-- =========================================================
local root = Instance.new("Frame")
root.Size = UDim2.new(0, 500, 0, 250)
root.Position = UDim2.new(0.56, 0, 0.5, -150)
root.BackgroundTransparency = 1
root.Parent = screenGui

local btnSize, verticalGap, columnGap = 62, 10, 12
local columns = {
    {count = 5, labels = {"DROP\nBR", "BAT\nBYPASS", "BAT\nAIMBOT", "TP\nDOWN", "LAGGER\nNORMAL"}},
    {count = 5, labels = {"FLOAT", "AUTO\nLEFT", "AUTO\nRIGHT", "CARRY\nSPD", "LAGGER\nCARRY"}},
    {count = 2, labels = {"INSTA\nRESET", "TP\nBAT"}},
}
local columnX = {[1] = 0, [2] = btnSize + columnGap, [3] = (btnSize + columnGap) * 2}

local function set30MinuteState(button, isActive)
    button.BackgroundColor3 = isActive and blueActive or Color3.fromRGB(0, 0, 0)
    button.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or blueLight
end

for colIndex, data in ipairs(columns) do
    local colFrame = Instance.new("Frame")
    colFrame.Position = UDim2.new(0, columnX[colIndex], 0, 0)
    colFrame.Size = UDim2.new(0, btnSize, 0, (btnSize * data.count) + (verticalGap * (data.count - 1)))
    colFrame.BackgroundTransparency = 1
    colFrame.Parent = root
    local list = Instance.new("UIListLayout", colFrame)
    list.Padding = UDim.new(0, verticalGap)

    for i = 1, data.count do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, btnSize, 0, btnSize)
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.Text = data.labels[i]
        button.TextColor3 = blueLight
        button.Font = Enum.Font.GothamBlack
        button.TextSize = 10
        button.Parent = colFrame
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

        if button.Text == "AUTO\nLEFT" then
            button.MouseButton1Click:Connect(function()
                autoLeftEnabled = not autoLeftEnabled
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                set30MinuteState(button, autoLeftEnabled)
            end)
        elseif button.Text == "AUTO\nRIGHT" then
            button.MouseButton1Click:Connect(function()
                autoRightEnabled = not autoRightEnabled
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                set30MinuteState(button, autoRightEnabled)
            end)
        elseif button.Text == "TP\nBAT" then
            button.MouseButton1Click:Connect(function()
                toggleBatDesyncTp()
                set30MinuteState(button, batDesyncTpEnabled)
            end)
        elseif button.Text == "INSTA\nRESET" then
            button.MouseButton1Click:Connect(function() instaReset() end)
        end
    end
end

-- =========================================================
-- Abrir/Cerrar Panel
-- =========================================================
openButton.MouseButton1Click:Connect(function()
    panel.Visible = true; openButton.Visible = false
    TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0, 12, 0.5, -205)}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(panel, TweenInfo.new(0.3), {Position = UDim2.new(0, -300, 0.5, -205)}):Play()
    task.wait(0.3); panel.Visible = false; openButton.Visible = true
end)

-- Iniciar
setupSpeedHud()
setActiveTab("SPEED")
applyCurrentSpeed()