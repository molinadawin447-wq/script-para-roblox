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
-- Variables de entorno para las nuevas funciones
-- =========================================================
local LP = player
local _CFnew = CFrame.new
local _V3zero = Vector3.new(0, 0, 0)
local _V3new = Vector3.new
local _tick = tick
local UIS = UserInputService
local NS = 30 -- Velocidad por defecto para Auto Left/Right (ajustar según necesidad)
local AP = { -- Puntos de referencia para Auto Left/Right (ajustar según el mapa)
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
local resetCooldown = false

-- Stubs para evitar errores si no existen en el entorno
_G.AmbitiousSafeModeTryStart = _G.AmbitiousSafeModeTryStart or function() return true end
_G.AceStartAntiBypassAimbot = _G.AceStartAntiBypassAimbot or function() return true end
_G.AceStopAntiBypassAimbot = _G.AceStopAntiBypassAimbot or function() end
_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump or {
    holdPressed = false, holdActive = false,
    controllerActive = false, mobilePressed = false,
    mobileActive = false, hooked = {}
}

-- Funciones de la lógica solicitada
function _G._jumpEnsureProxy()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

function _G.AmbitiousApplyNormalInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local proxy = _G._jumpEnsureProxy()
    if not proxy then return end
    local curVel = proxy.Velocity
    proxy.Velocity = _V3new(curVel.X, boost or 50, curVel.Z)
end

function _G.AmbitiousStopNormalInfJumpHoldState()
    local S = _G.AmbitiousNormalInfJump
    S.holdPressed = false
    S.holdActive = false
    S.controllerActive = false
    S.mobilePressed = false
    S.mobileActive = false
end

UIS.JumpRequest:Connect(function()
    _G.AmbitiousApplyNormalInfJumpBoost(50)
end)

UIS.InputBegan:Connect(function(input)
    if UIS:GetFocusedTextBox() then return end
    local S = _G.AmbitiousNormalInfJump

    if input.UserInputType == Enum.UserInputType.Keyboard
       and input.KeyCode == Enum.KeyCode.Space then
        if infJumpMode == "MANUAL" then return end
        S.holdPressed = true
        task.delay(0.12, function()
            if _G.AmbitiousNormalInfJump.holdPressed and infJumpEnabled then
                _G.AmbitiousNormalInfJump.holdActive = true
                _G.AmbitiousApplyNormalInfJumpBoost(50)
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.ButtonA
       and input.UserInputType.Name:match("^Gamepad") then
        if infJumpMode ~= "MANUAL" then S.controllerActive = true end
    end
end)

UIS.InputEnded:Connect(function(input)
    local S = _G.AmbitiousNormalInfJump
    if input.UserInputType == Enum.UserInputType.Keyboard
       and input.KeyCode == Enum.KeyCode.Space then
        S.holdPressed = false
        S.holdActive  = false
    end
    if input.KeyCode == Enum.KeyCode.ButtonA
       and input.UserInputType.Name:match("^Gamepad") then
        S.controllerActive = false
    end
end)

function _G.AmbitiousHookNormalInfMobileJumpButton(obj)
    local S = _G.AmbitiousNormalInfJump
    if not obj or obj.Name ~= "JumpButton"
       or not obj:IsA("GuiButton") or S.hooked[obj] then return end
    S.hooked[obj] = true
    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
           or not infJumpEnabled then return end
        if infJumpMode == "MANUAL" then return end
        S.mobilePressed = true
        task.delay(0.12, function()
            if S.mobilePressed and infJumpEnabled then
                S.mobileActive = true
                _G.AmbitiousApplyNormalInfJumpBoost(50)
            end
        end)
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            S.mobilePressed = false
            S.mobileActive  = false
        end
    end)
end

do
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, obj in ipairs(pg:GetDescendants()) do
            _G.AmbitiousHookNormalInfMobileJumpButton(obj)
        end
        pg.DescendantAdded:Connect(function(obj)
            task.defer(_G.AmbitiousHookNormalInfMobileJumpButton, obj)
        end)
    end
end

RunService.Heartbeat:Connect(function()
    local S = _G.AmbitiousNormalInfJump
    if infJumpEnabled and infJumpMode == "HOLD"
       and (S.holdActive or S.mobileActive or S.controllerActive) then
        _G.AmbitiousApplyNormalInfJumpBoost(50)
    end
end)

function _G.setInfJumpInternal(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _G.AmbitiousStopNormalInfJumpHoldState()
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function() hrp.Velocity = _V3zero end) end
    end
end

InfiniteJump = {
    start = function() _G.setInfJumpInternal(true)  end,
    stop  = function() _G.setInfJumpInternal(false) end,
    isRunning = function() return infJumpEnabled == true end,
    setJumpPower = function() end,
}

-- Variables de TP BAT
local batDesyncTpConn = nil
local _tpBatHitCooldown = false
local _tpBatUnwalkForced = false
local unwalkEnabled = false

function startAlvaroTP()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end

    batDesyncTpEnabled = true
    _G.AlvaroTP = _G.AlvaroTP or { on = false, conn = nil, h = nil, hrp = nil }
    _G.AlvaroTP.on     = true
    _G.AlvaroTP.conn   = nil
    _tpBatHitCooldown  = false

    local char = LP.Character
    if char then
        _G.AlvaroTP.h   = char:FindFirstChildOfClass("Humanoid")
        _G.AlvaroTP.hrp = char:FindFirstChild("HumanoidRootPart")
    end

    batDesyncTpConn  = RunService.Heartbeat:Connect(function() end) -- tpBatUpdate simulado
    _G.AlvaroTP.conn = batDesyncTpConn
end

function stopAlvaroTP()
    batDesyncTpEnabled = false
    _G.AlvaroTP = _G.AlvaroTP or { on = false, conn = nil, h = nil, hrp = nil }
    _G.AlvaroTP.on     = false

    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    _G.AlvaroTP.conn            = nil
    _G.AlvaroTP.hittingCooldown = false
    _tpBatHitCooldown           = false

    local meRoot = _G.AlvaroTP.hrp
    if meRoot and meRoot.Parent then
        pcall(function()
            if meRoot.SetNetworkOwner then meRoot:SetNetworkOwner(LP) end
        end)
    end
end

function toggleAlvaroTP()
    if batDesyncTpEnabled then stopAlvaroTP() else startAlvaroTP() end
end

function startBatDesyncTp()
    if not _G.AmbitiousSafeModeTryStart() then return end
    if not unwalkEnabled then
        -- startUnwalk() simulado
        unwalkEnabled = true
        _tpBatUnwalkForced = true
    end
    startAlvaroTP()
end

function stopBatDesyncTp()
    stopAlvaroTP()
    if _tpBatUnwalkForced then
        -- stopUnwalk() simulado
        unwalkEnabled = false
        _tpBatUnwalkForced = false
    end
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        -- disableAllAimbots() simulado
        if autoLeftEnabled then
            autoLeftEnabled = false
            if stopAutoLeft then stopAutoLeft() end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if stopAutoRight then stopAutoRight() end
        end
        startBatDesyncTp()
    end
end

-- Variables de DROP BR
local _dropConn = nil
local dropConnections = {}
local lastDropTime = 0
local dropMode = 1
local DROP_ASCEND_DURATION = 1
local DROP_ASCEND_SPEED = 100

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- Lógica simplificada para evitar errores de variables no definidas
    dropActive = true
    task.spawn(function()
        task.wait(1) -- Simula la duración
        dropActive = false
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

-- Variables de INSTA RESET
local resetCooldown = false
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil
local currentResetChar = nil
local resetThread = nil
local _lastInstaResetRequest = 0

local function instaResetFast()
    if resetCooldown then return end
    resetCooldown     = true
    resetSuccessful   = false
    stopResetSequence = false
    cameraLocked      = false

    local character = LP.Character
    if not character then resetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end

    local cam = workspace.CurrentCamera
    if cam then
        lockedCameraCFrame = cam.CFrame
        cameraLocked       = true
        cam.CFrame         = lockedCameraCFrame
    end

    currentResetChar = character
    local isRespawning = false

    resetThread = task.spawn(function()
        local attempts          = 0
        local maxAttempts       = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0
              and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end
            pcall(function()
                humanoid.HipHeight  = 1e30
                humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character or not character.Parent or not humanoid
               or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(0.05)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid
               and humanoid.Health > 0 and not isRespawning then
                pcall(function() humanoid.Health = 0 end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end

        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        cameraLocked      = false
        resetCooldown     = false
        resetThread       = nil
        currentResetChar  = nil
        stopResetSequence = false
    end)
end

local function instaReset()
    local now = os.clock()
    if now - _lastInstaResetRequest < 0.75 then return end
    _lastInstaResetRequest = now
    instaResetFast()
end

-- Variables AUTO LEFT
local alConn = nil
local alPhase = 1
local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    -- _unsuppressBodyLock(true) simulado
end

local function startAutoLeft()
    if not _G.AmbitiousSafeModeTryStart() then
        autoLeftEnabled = false
        return
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
    end
    -- _suppressBodyLock() simulado
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

-- Variables AUTO RIGHT
local arConn = nil
local arPhase = 1
local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
end

local function startAutoRight()
    if not _G.AmbitiousSafeModeTryStart() then
        autoRightEnabled = false
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
    end
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end


-- =========================================================
-- Medir texto
-- =========================================================
local function getTextWidth(text, textSize, font)
    local ok, size = pcall(function()
        return TextService:GetTextSize(text, textSize, font, Vector2.new(10000, 1000))
    end)
    if ok and size then
        return math.ceil(size.X)
    end
    return math.ceil(#text * textSize * 0.6)
end

-- =========================================================
-- Persistencia
-- =========================================================
local SAVE_FILE = "BlazzenDuelsUI.json"
local hasFileAPI = (type(writefile) == "function") and (type(readfile) == "function") and (type(isfile) == "function")

local uiState = {
    panelPosition = nil,
    rightButtonsPosition = nil,
    speeds = { normal = 30, carry = 29, laggerNormal = 24, laggerCarry = 14.5 },
    currentMode = "normal",
    activeTab = "SPEED",
    autoCarryEnabled = false,
}

local function saveSettings()
    if not hasFileAPI then return end
    pcall(function()
        local data = {
            panelPosition = uiState.panelPosition,
            rightButtonsPosition = uiState.rightButtonsPosition,
            speeds = uiState.speeds,
            currentMode = uiState.currentMode,
            activeTab = uiState.activeTab,
            autoCarryEnabled = uiState.autoCarryEnabled,
        }
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadSettings()
    if not hasFileAPI then return nil end
    local ok, content = pcall(function()
        if isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
        return nil
    end)
    if not ok or not content then return nil end
    local ok2, decoded = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if ok2 and type(decoded) == "table" then return decoded end
    return nil
end

local function udim2ToTable(u)
    return { XS = u.X.Scale, XO = u.X.Offset, YS = u.Y.Scale, YO = u.Y.Offset }
end

local function tableToUdim2(t)
    if type(t) ~= "table" then return nil end
    return UDim2.new(t.XS or 0, t.XO or 0, t.YS or 0, t.YO or 0)
end

-- =========================================================
-- Valores
-- =========================================================
local normalSpeedValue = 30
local carrySpeedValue = 29
local laggerNormalSpeedValue = 24
local laggerCarrySpeedValue = 14.5

local currentMode = "normal"
local autoCarryEnabled = false
local autoCarryActivated = false

local modeLabels = {
    normal = "NORMAL",
    carry = "CARRY SPD",
    laggerNormal = "LAGGER NORMAL",
    laggerCarry = "LAGGER CARRY",
}

local function getModeSpeed()
    if currentMode == "carry" then
        return carrySpeedValue
    elseif currentMode == "laggerNormal" then
        return laggerNormalSpeedValue
    elseif currentMode == "laggerCarry" then
        return laggerCarrySpeedValue
    else
        return normalSpeedValue
    end
end

local function clampSpeed(value)
    local n = tonumber(value)
    if n == nil then return nil end
    if n < 0 then n = 0 end
    if n > 68 then n = 68 end
    return n
end

local function isValidSpeedText(text)
    if text == nil or text == "" then return false end
    return string.match(text, "^[0-9]*%.?[0-9]*$") ~= nil
end

local function roundValue(value)
    return math.floor(value * 10 + 0.5) / 10
end

local function formatSpeedNumber(value)
    if value == math.floor(value) then return tostring(value) end
    return string.format("%.1f", value)
end

-- =========================================================
-- HUD
-- =========================================================
local speedLabel = nil
local renderConnection = nil

local function createSpeedLabel()
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SpeedHud"
    billboard.Size = UDim2.new(0, 140, 0, 35)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "SpeedText"
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
    local character = player.Character
    if not character then speedLabel.Text = "0.0 SPEED"; return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        speedLabel.Text = string.format("%.1f SPEED", humanoid.WalkSpeed)
    else
        speedLabel.Text = "0.0 SPEED"
    end
end

local function setupSpeedHud()
    if speedLabel then speedLabel.Parent:Destroy() end
    speedLabel = createSpeedLabel()
    if renderConnection then renderConnection:Disconnect() end
    renderConnection = RunService.RenderStepped:Connect(updateSpeedLabel)
end

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    setupSpeedHud()
end)

setupSpeedHud()

-- =========================================================
-- Referencias
-- =========================================================
local currentModeValueLabel = nil
local modeButtonRefs = {}

local function isHoldingBrainrot()
    local char = player.Character
    if not char then return false end
    return char:FindFirstChildOfClass("Tool") ~= nil
end

local function updateCurrentModeDisplay()
    if currentModeValueLabel then
        currentModeValueLabel.Text = modeLabels[currentMode] or "NORMAL"
    end
end

local function updateModeButtons()
    for mode, btn in pairs(modeButtonRefs) do
        if btn then
            if currentMode == mode then
                btn.BackgroundColor3 = blueActive
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                btn.TextColor3 = blueLight
            end
        end
    end
end

local function applyCurrentSpeed()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.WalkSpeed = getModeSpeed()
    updateSpeedLabel()
    updateCurrentModeDisplay()
    updateModeButtons()
end

local function setMode(mode)
    if mode == "normal" then
        currentMode = "normal"
    else
        if currentMode == mode then
            currentMode = "normal"
        else
            currentMode = mode
        end
    end
    uiState.currentMode = currentMode
    applyCurrentSpeed()
    saveSettings()
end

-- =========================================================
-- Botón BLAZZEN
-- =========================================================
local openButton = Instance.new("TextButton")
openButton.Name = "OpenBlazzenButton"
openButton.Size = UDim2.new(0, 170, 0, 44)
openButton.Position = UDim2.new(0.015, 0, 0.5, -70)
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.BorderSizePixel = 0
openButton.Text = "BLAZZEN"
openButton.TextColor3 = blueLight
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 19
openButton.AutoButtonColor = false
openButton.ZIndex = 1
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 12)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = blueDark
openStroke.Thickness = 1.5
openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
openStroke.Parent = openButton

-- =========================================================
-- Panel
-- =========================================================
local PANEL_W = 265
local PANEL_H = 410

local shownPos = UDim2.new(0, 12, 0.5, -205)
local hiddenPos = UDim2.new(0, -PANEL_W - 40, 0.5, -205)

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = hiddenPos
panel.BackgroundColor3 = panelDark
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 10
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 18)
panelCorner.Parent = panel

local titleWrap = Instance.new("Frame")
titleWrap.Name = "TitleWrap"
titleWrap.Size = UDim2.new(1, -32, 0, 88)
titleWrap.Position = UDim2.new(0, 16, 0, 8)
titleWrap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleWrap.BorderSizePixel = 0
titleWrap.ClipsDescendants = true
titleWrap.Parent = panel

local titleWrapCorner = Instance.new("UICorner")
titleWrapCorner.CornerRadius = UDim.new(0, 10)
titleWrapCorner.Parent = titleWrap

local titleImage = Instance.new("ImageLabel")
titleImage.Name = "TitleImage"
titleImage.Size = UDim2.new(1, -8, 1, -8)
titleImage.Position = UDim2.new(0, 4, 0, 4)
titleImage.BackgroundTransparency = 1
titleImage.BorderSizePixel = 0
titleImage.ScaleType = Enum.ScaleType.Fit
titleImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
titleImage.Parent = titleWrap

pcall(function()
    titleImage.Image = getcustomasset("BLAZZEN.jpg")
end)

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -38, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.AutoButtonColor = false
closeButton.ZIndex = 11
closeButton.Parent = panel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local dividerLine = Instance.new("Frame")
dividerLine.Name = "DividerLine"
dividerLine.Size = UDim2.new(1, -32, 0, 2)
dividerLine.Position = UDim2.new(0, 16, 0, 100)
dividerLine.BackgroundColor3 = blueActive
dividerLine.BorderSizePixel = 0
dividerLine.Parent = panel

local dividerCorner = Instance.new("UICorner")
dividerCorner.CornerRadius = UDim.new(1, 0)
dividerCorner.Parent = dividerLine

-- =========================================================
-- ScrollingFrame
-- =========================================================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -16, 0, 270)
scrollFrame.Position = UDim2.new(0, 8, 0, 108)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = blueDark
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
scrollFrame.Parent = panel

-- =========================================================
-- SPEED content
-- =========================================================
local speedContent = Instance.new("Frame")
speedContent.Name = "SpeedContent"
speedContent.Size = UDim2.new(1, 0, 0, 0)
speedContent.AutomaticSize = Enum.AutomaticSize.Y
speedContent.BackgroundTransparency = 1
speedContent.Visible = true
speedContent.Parent = scrollFrame

local speedContentPadding = Instance.new("UIPadding")
speedContentPadding.PaddingTop = UDim.new(0, 0)
speedContentPadding.PaddingBottom = UDim.new(0, 12)
speedContentPadding.Parent = speedContent

local speedHeader = Instance.new("TextLabel")
speedHeader.Size = UDim2.new(1, -20, 0, 13)
speedHeader.Position = UDim2.new(0, 12, 0, 0)
speedHeader.BackgroundTransparency = 1
speedHeader.Text = "-SPEED"
speedHeader.TextColor3 = blueLight
speedHeader.Font = Enum.Font.GothamBold
speedHeader.TextSize = 10
speedHeader.TextXAlignment = Enum.TextXAlignment.Left
speedHeader.Parent = speedContent

local speedLineWidth = getTextWidth("-SPEED", 10, Enum.Font.GothamBold)
local speedLine = Instance.new("Frame")
speedLine.Name = "SpeedLine"
speedLine.Size = UDim2.new(0, speedLineWidth, 0, 2)
speedLine.Position = UDim2.new(0, 12, 0, 12)
speedLine.BackgroundColor3 = blueActive
speedLine.BorderSizePixel = 0
speedLine.Parent = speedContent

local speedLineCorner = Instance.new("UICorner")
speedLineCorner.CornerRadius = UDim.new(1, 0)
speedLineCorner.Parent = speedLine

local function createSpeedRow(parent, yPos, labelText)
    local row = Instance.new("Frame")
    row.Name = labelText:gsub("%s", "") .. "Row"
    row.Size = UDim2.new(1, -30, 0, 24)
    row.Position = UDim2.new(0, 15, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = labelText
    nameLabel.TextColor3 = blueLight
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 55, 0, 22)
    box.Position = UDim2.new(1, -55, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    box.BorderSizePixel = 0
    box.Text = "0"
    box.TextColor3 = blueLight
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.Parent = row

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = blueDark
    boxStroke.Thickness = 1
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxStroke.Parent = box

    return box
end

-- =========================================================
-- SPEED rows reales
-- =========================================================
local normalSpeedBox = createSpeedRow(speedContent, 18, "NORMAL SPEED")
local carrySpeedBox = createSpeedRow(speedContent, 44, "CARRY SPD")
local laggerNormalSpeedBox = createSpeedRow(speedContent, 70, "LAGGER NORMAL")
local laggerCarrySpeedBox = createSpeedRow(speedContent, 96, "LAGGER CARRY")

-- =========================================================
-- Current mode block
-- =========================================================
local currentModeBox = Instance.new("Frame")
currentModeBox.Name = "CurrentModeBox"
currentModeBox.Size = UDim2.new(1, -30, 0, 42)
currentModeBox.Position = UDim2.new(0, 15, 0, 120)
currentModeBox.BackgroundColor3 = Color3.fromRGB(8, 14, 30)
currentModeBox.BorderSizePixel = 0
currentModeBox.Parent = speedContent

local cmCorner = Instance.new("UICorner")
cmCorner.CornerRadius = UDim.new(0, 8)
cmCorner.Parent = currentModeBox

local cmStroke = Instance.new("UIStroke")
cmStroke.Color = blueDark
cmStroke.Thickness = 1.2
cmStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
cmStroke.Parent = currentModeBox

local cmTitleLabel = Instance.new("TextLabel")
cmTitleLabel.Size = UDim2.new(1, 0, 0, 16)
cmTitleLabel.Position = UDim2.new(0, 0, 0, 3)
cmTitleLabel.BackgroundTransparency = 1
cmTitleLabel.Text = "CURRENT MODE"
cmTitleLabel.TextColor3 = blueLight
cmTitleLabel.Font = Enum.Font.GothamBold
cmTitleLabel.TextSize = 9
cmTitleLabel.Parent = currentModeBox

currentModeValueLabel = Instance.new("TextLabel")
currentModeValueLabel.Size = UDim2.new(1, 0, 0, 20)
currentModeValueLabel.Position = UDim2.new(0, 0, 0, 18)
currentModeValueLabel.BackgroundTransparency = 1
currentModeValueLabel.Text = "NORMAL"
currentModeValueLabel.TextColor3 = blueActive
currentModeValueLabel.Font = Enum.Font.GothamBold
currentModeValueLabel.TextSize = 13
currentModeValueLabel.Parent = currentModeBox

-- =========================================================
-- AUTO CARRY SPEED
-- =========================================================
local autoCarryHeader = Instance.new("TextLabel")
autoCarryHeader.Size = UDim2.new(1, -20, 0, 12)
autoCarryHeader.Position = UDim2.new(0, 12, 0, 180)
autoCarryHeader.BackgroundTransparency = 1
autoCarryHeader.Text = "-AUTO CARRY SPEED"
autoCarryHeader.TextColor3 = blueLight
autoCarryHeader.Font = Enum.Font.GothamBold
autoCarryHeader.TextSize = 9
autoCarryHeader.TextXAlignment = Enum.TextXAlignment.Left
autoCarryHeader.Parent = speedContent

local autoCarryLineWidth = getTextWidth("-AUTO CARRY SPEED", 9, Enum.Font.GothamBold)
local autoCarryLine = Instance.new("Frame")
autoCarryLine.Name = "AutoCarryLine"
autoCarryLine.Size = UDim2.new(0, autoCarryLineWidth, 0, 2)
autoCarryLine.Position = UDim2.new(0, 12, 0, 191)
autoCarryLine.BackgroundColor3 = blueActive
autoCarryLine.BorderSizePixel = 0
autoCarryLine.Parent = speedContent

local autoCarryLineCorner = Instance.new("UICorner")
autoCarryLineCorner.CornerRadius = UDim.new(1, 0)
autoCarryLineCorner.Parent = autoCarryLine

local autoCarryRow = Instance.new("Frame")
autoCarryRow.Name = "AutoCarryRow"
autoCarryRow.Size = UDim2.new(1, -30, 0, 28)
autoCarryRow.Position = UDim2.new(0, 15, 0, 198)
autoCarryRow.BackgroundTransparency = 1
autoCarryRow.Parent = speedContent

local autoCarryLabel = Instance.new("TextLabel")
autoCarryLabel.Size = UDim2.new(1, -70, 1, 0)
autoCarryLabel.BackgroundTransparency = 1
autoCarryLabel.Text = "AUTO CARRY"
autoCarryLabel.TextColor3 = blueLight
autoCarryLabel.Font = Enum.Font.GothamBold
autoCarryLabel.TextSize = 13
autoCarryLabel.TextXAlignment = Enum.TextXAlignment.Left
autoCarryLabel.Parent = autoCarryRow

local autoCarryToggle = Instance.new("TextButton")
autoCarryToggle.Name = "AutoCarryToggle"
autoCarryToggle.Size = UDim2.new(0, 44, 0, 22)
autoCarryToggle.Position = UDim2.new(1, -44, 0.5, -11)
autoCarryToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoCarryToggle.BorderSizePixel = 0
autoCarryToggle.Text = ""
autoCarryToggle.AutoButtonColor = false
autoCarryToggle.Parent = autoCarryRow

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = autoCarryToggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = blueDark
toggleStroke.Thickness = 1
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = autoCarryToggle

local autoCarryBall = Instance.new("Frame")
autoCarryBall.Name = "Ball"
autoCarryBall.Size = UDim2.new(0, 18, 0, 18)
autoCarryBall.Position = UDim2.new(0, 2, 0.5, -9)
autoCarryBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
autoCarryBall.BorderSizePixel = 0
autoCarryBall.Parent = autoCarryToggle

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = autoCarryBall

local function updateToggleVisual(isOn, animate)
    if animate then
        if isOn then
            TweenService:Create(autoCarryToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = blueDark}):Play()
            TweenService:Create(autoCarryBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(autoCarryToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(autoCarryBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            }):Play()
        end
    else
        if isOn then
            autoCarryToggle.BackgroundColor3 = blueDark
            autoCarryBall.Position = UDim2.new(1, -20, 0.5, -9)
            autoCarryBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            autoCarryToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            autoCarryBall.Position = UDim2.new(0, 2, 0.5, -9)
            autoCarryBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        end
    end
end

autoCarryToggle.MouseButton1Click:Connect(function()
    autoCarryEnabled = not autoCarryEnabled
    uiState.autoCarryEnabled = autoCarryEnabled
    updateToggleVisual(autoCarryEnabled, true)
    if not autoCarryEnabled then
        if autoCarryActivated then
            autoCarryActivated = false
            if currentMode == "carry" then
                setMode("normal")
            end
        end
    end
    saveSettings()
end)

RunService.Heartbeat:Connect(function()
    if not autoCarryEnabled then
        autoCarryActivated = false
        return
    end

    local holding = isHoldingBrainrot()
    if holding and not autoCarryActivated then
        autoCarryActivated = true
        if currentMode ~= "carry" then
            setMode("carry")
        end
    elseif not holding and autoCarryActivated then
        autoCarryActivated = false
        if currentMode == "carry" then
            setMode("normal")
        end
    end
end)

-- =========================================================
-- MOVEMENT
-- =========================================================
local movementHeader = Instance.new("TextLabel")
movementHeader.Size = UDim2.new(1, -20, 0, 12)
movementHeader.Position = UDim2.new(0, 12, 0, 248)
movementHeader.BackgroundTransparency = 1
movementHeader.Text = "-MOVEMENT"
movementHeader.TextColor3 = blueLight
movementHeader.Font = Enum.Font.GothamBold
movementHeader.TextSize = 9
movementHeader.TextXAlignment = Enum.TextXAlignment.Left
movementHeader.Parent = speedContent

local movementLineWidth = getTextWidth("-MOVEMENT", 9, Enum.Font.GothamBold)
local movementLine = Instance.new("Frame")
movementLine.Size = UDim2.new(0, movementLineWidth, 0, 2)
movementLine.Position = UDim2.new(0, 12, 0, 259)
movementLine.BackgroundColor3 = blueActive
movementLine.BorderSizePixel = 0
movementLine.Parent = speedContent

local movementLineCorner = Instance.new("UICorner")
movementLineCorner.CornerRadius = UDim.new(1, 0)
movementLineCorner.Parent = movementLine

local function createToggleRow(parent, yPos, labelText)
    local row = Instance.new("Frame")
    row.Name = labelText:gsub("%s", "") .. "Row"
    row.Size = UDim2.new(1, -30, 0, 28)
    row.Position = UDim2.new(0, 15, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = labelText
    nameLabel.TextColor3 = blueLight
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 44, 0, 22)
    toggle.Position = UDim2.new(1, -44, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = row

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle

    local ts = Instance.new("UIStroke")
    ts.Color = blueDark
    ts.Thickness = 1
    ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ts.Parent = toggle

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 18, 0, 18)
    ball.Position = UDim2.new(0, 2, 0.5, -9)
    ball.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    ball.BorderSizePixel = 0
    ball.Parent = toggle

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = ball

    local state = false

    local function updateToggleVisual2(animate)
        if animate then
            if state then
                TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = blueDark}):Play()
                TweenService:Create(ball, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -20, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            else
                TweenService:Create(toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                TweenService:Create(ball, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                }):Play()
            end
        else
            if state then
                toggle.BackgroundColor3 = blueDark
                ball.Position = UDim2.new(1, -20, 0.5, -9)
                ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ball.Position = UDim2.new(0, 2, 0.5, -9)
                ball.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
    end

    toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggleVisual2(true)
    end)

    updateToggleVisual2(false)
    return toggle, ball
end

local autoLeftToggle, _ = createToggleRow(speedContent, 268, "AUTO LEFT")
local autoRightToggle, _ = createToggleRow(speedContent, 298, "AUTO RIGHT")

-- =========================================================
-- TELEPORT
-- =========================================================
local teleportHeader = Instance.new("TextLabel")
teleportHeader.Size = UDim2.new(1, -20, 0, 12)
teleportHeader.Position = UDim2.new(0, 12, 0, 336)
teleportHeader.BackgroundTransparency = 1
teleportHeader.Text = "-TELEPORT"
teleportHeader.TextColor3 = blueLight
teleportHeader.Font = Enum.Font.GothamBold
teleportHeader.TextSize = 9
teleportHeader.TextXAlignment = Enum.TextXAlignment.Left
teleportHeader.Parent = speedContent

local teleportLineWidth = getTextWidth("-TELEPORT", 9, Enum.Font.GothamBold)
local teleportLine = Instance.new("Frame")
teleportLine.Size = UDim2.new(0, teleportLineWidth, 0, 2)
teleportLine.Position = UDim2.new(0, 12, 0, 347)
teleportLine.BackgroundColor3 = blueActive
teleportLine.BorderSizePixel = 0
teleportLine.Parent = speedContent

local teleportLineCorner = Instance.new("UICorner")
teleportLineCorner.CornerRadius = UDim.new(1, 0)
teleportLineCorner.Parent = teleportLine

local tpDownRow = Instance.new("Frame")
tpDownRow.Size = UDim2.new(1, -30, 0, 28)
tpDownRow.Position = UDim2.new(0, 15, 0, 355)
tpDownRow.BackgroundTransparency = 1
tpDownRow.Parent = speedContent

local tpDownLabel = Instance.new("TextLabel")
tpDownLabel.Size = UDim2.new(1, -70, 1, 0)
tpDownLabel.BackgroundTransparency = 1
tpDownLabel.Text = "TP DOWN"
tpDownLabel.TextColor3 = blueLight
tpDownLabel.Font = Enum.Font.GothamBold
tpDownLabel.TextSize = 13
tpDownLabel.TextXAlignment = Enum.TextXAlignment.Left
tpDownLabel.Parent = tpDownRow

local tpDownActivate = Instance.new("TextLabel")
tpDownActivate.Size = UDim2.new(0, 70, 1, 0)
tpDownActivate.Position = UDim2.new(1, -70, 0, 0)
tpDownActivate.BackgroundTransparency = 1
tpDownActivate.Text = "Activate"
tpDownActivate.TextColor3 = blueLight
tpDownActivate.Font = Enum.Font.GothamBold
tpDownActivate.TextSize = 10
tpDownActivate.TextXAlignment = Enum.TextXAlignment.Right
tpDownActivate.Parent = tpDownRow

local autoTpRow = Instance.new("Frame")
autoTpRow.Size = UDim2.new(1, -30, 0, 28)
autoTpRow.Position = UDim2.new(0, 15, 0, 386)
autoTpRow.BackgroundTransparency = 1
autoTpRow.Parent = speedContent

local autoTpLabel = Instance.new("TextLabel")
autoTpLabel.Size = UDim2.new(1, -70, 1, 0)
autoTpLabel.BackgroundTransparency = 1
autoTpLabel.Text = "AUTO TP DOWN"
autoTpLabel.TextColor3 = blueLight
autoTpLabel.Font = Enum.Font.GothamBold
autoTpLabel.TextSize = 13
autoTpLabel.TextXAlignment = Enum.TextXAlignment.Left
autoTpLabel.Parent = autoTpRow

local autoTpToggle = Instance.new("TextButton")
autoTpToggle.Size = UDim2.new(0, 44, 0, 22)
autoTpToggle.Position = UDim2.new(1, -44, 0.5, -11)
autoTpToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoTpToggle.BorderSizePixel = 0
autoTpToggle.Text = ""
autoTpToggle.AutoButtonColor = false
autoTpToggle.Parent = autoTpRow

local autoTpCorner = Instance.new("UICorner")
autoTpCorner.CornerRadius = UDim.new(1, 0)
autoTpCorner.Parent = autoTpToggle

local autoTpStroke = Instance.new("UIStroke")
autoTpStroke.Color = blueDark
autoTpStroke.Thickness = 1
autoTpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
autoTpStroke.Parent = autoTpToggle

local autoTpBall = Instance.new("Frame")
autoTpBall.Size = UDim2.new(0, 18, 0, 18)
autoTpBall.Position = UDim2.new(0, 2, 0.5, -9)
autoTpBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
autoTpBall.BorderSizePixel = 0
autoTpBall.Parent = autoTpToggle

local autoTpBallCorner = Instance.new("UICorner")
autoTpBallCorner.CornerRadius = UDim.new(1, 0)
autoTpBallCorner.Parent = autoTpBall

local autoTpDownEnabled = false

local function updateAutoTpToggleVisual(isOn, animate)
    if animate then
        if isOn then
            TweenService:Create(autoTpToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = blueDark}):Play()
            TweenService:Create(autoTpBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(autoTpToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(autoTpBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            }):Play()
        end
    else
        if isOn then
            autoTpToggle.BackgroundColor3 = blueDark
            autoTpBall.Position = UDim2.new(1, -20, 0.5, -9)
            autoTpBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            autoTpToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            autoTpBall.Position = UDim2.new(0, 2, 0.5, -9)
            autoTpBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        end
    end
end

autoTpToggle.MouseButton1Click:Connect(function()
    autoTpDownEnabled = not autoTpDownEnabled
    updateAutoTpToggleVisual(autoTpDownEnabled, true)
end)

-- =========================================================
-- HOLD JUMP
-- =========================================================
local holdJumpToggle = Instance.new("TextButton")
holdJumpToggle.Size = UDim2.new(0, 44, 0, 22)
holdJumpToggle.Position = UDim2.new(1, -44, 0.5, -11)
holdJumpToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
holdJumpToggle.BorderSizePixel = 0
holdJumpToggle.Text = ""
holdJumpToggle.AutoButtonColor = false
holdJumpToggle.Parent = holdJumpRow

local holdJumpCorner = Instance.new("UICorner")
holdJumpCorner.CornerRadius = UDim.new(1, 0)
holdJumpCorner.Parent = holdJumpToggle

local holdJumpStroke = Instance.new("UIStroke")
holdJumpStroke.Color = blueDark
holdJumpStroke.Thickness = 1
holdJumpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
holdJumpStroke.Parent = holdJumpToggle

local holdJumpBall = Instance.new("Frame")
holdJumpBall.Size = UDim2.new(0, 18, 0, 18)
holdJumpBall.Position = UDim2.new(0, 2, 0.5, -9)
holdJumpBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
holdJumpBall.BorderSizePixel = 0
holdJumpBall.Parent = holdJumpToggle

local holdJumpBallCorner = Instance.new("UICorner")
holdJumpBallCorner.CornerRadius = UDim.new(1, 0)
holdJumpBallCorner.Parent = holdJumpBall

local function updateHoldJumpToggleVisual(isOn, animate)
    if animate then
        if isOn then
            TweenService:Create(holdJumpToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = blueDark}):Play()
            TweenService:Create(holdJumpBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(holdJumpToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(holdJumpBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            }):Play()
        end
    else
        if isOn then
            holdJumpToggle.BackgroundColor3 = blueDark
            holdJumpBall.Position = UDim2.new(1, -20, 0.5, -9)
            holdJumpBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            holdJumpToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            holdJumpBall.Position = UDim2.new(0, 2, 0.5, -9)
            holdJumpBall.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        end
    end
end

holdJumpToggle.MouseButton1Click:Connect(function()
    if InfiniteJump.isRunning() then
        InfiniteJump.stop()
        updateHoldJumpToggleVisual(false, true)
    else
        InfiniteJump.start()
        updateHoldJumpToggleVisual(true, true)
    end
end)

-- =========================================================
-- Bind cajas
-- =========================================================
local function bindSpeedBox(box, getValue, setValue)
    local previousValue = getValue()
    box.Text = formatSpeedNumber(previousValue)

    box.FocusLost:Connect(function()
        local raw = box.Text
        if not isValidSpeedText(raw) then
            box.Text = formatSpeedNumber(previousValue)
            return
        end
        local value = clampSpeed(raw)
        if value == nil then
            box.Text = formatSpeedNumber(previousValue)
            return
        end
        value = roundValue(value)
        previousValue = value
        box.Text = formatSpeedNumber(value)
        setValue(value)
        applyCurrentSpeed()
        saveSettings()
    end)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        if box:IsFocused() then
            local raw = box.Text
            if raw == "" then return end
            if not isValidSpeedText(raw) then
                box.Text = formatSpeedNumber(previousValue)
                return
            end
            local val = clampSpeed(raw)
            if val == nil then
                box.Text = formatSpeedNumber(previousValue)
                return
            end
            box.Text = formatSpeedNumber(roundValue(val))
        end
    end)

    return function(v)
        previousValue = v
        box.Text = formatSpeedNumber(v)
    end
end

local setNormalBox = bindSpeedBox(normalSpeedBox,
    function() return normalSpeedValue end,
    function(v) normalSpeedValue = v; uiState.speeds.normal = v end)

local setCarryBox = bindSpeedBox(carrySpeedBox,
    function() return carrySpeedValue end,
    function(v) carrySpeedValue = v; uiState.speeds.carry = v end)

local setLaggerNormalBox = bindSpeedBox(laggerNormalSpeedBox,
    function() return laggerNormalSpeedValue end,
    function(v) laggerNormalSpeedValue = v; uiState.speeds.laggerNormal = v end)

local setLaggerCarryBox = bindSpeedBox(laggerCarrySpeedBox,
    function() return laggerCarrySpeedValue end,
    function(v) laggerCarrySpeedValue = v; uiState.speeds.laggerCarry = v end)

-- =========================================================
-- Tabs
-- =========================================================
local customContent = Instance.new("Frame")
customContent.Name = "CustomContent"
customContent.Size = UDim2.new(1, 0, 1, 0)
customContent.BackgroundTransparency = 1
customContent.Visible = false
customContent.Parent = scrollFrame

local visualContent = Instance.new("Frame")
visualContent.Name = "VisualContent"
visualContent.Size = UDim2.new(1, 0, 1, 0)
visualContent.BackgroundTransparency = 1
visualContent.Visible = false
visualContent.Parent = scrollFrame

local settingContent = Instance.new("Frame")
settingContent.Name = "SettingContent"
settingContent.Size = UDim2.new(1, 0, 1, 0)
settingContent.BackgroundTransparency = 1
settingContent.Visible = false
settingContent.Parent = scrollFrame

-- =========================================================
-- KEYBINDS content
-- =========================================================
local keybindsContent = Instance.new("Frame")
keybindsContent.Name = "KeybindsContent"
keybindsContent.Size = UDim2.new(1, 0, 0, 0)
keybindsContent.AutomaticSize = Enum.AutomaticSize.Y
keybindsContent.BackgroundTransparency = 1
keybindsContent.Visible = false
keybindsContent.Parent = scrollFrame

local kbPadding = Instance.new("UIPadding")
kbPadding.PaddingTop = UDim.new(0, 0)
kbPadding.PaddingBottom = UDim.new(0, 12)
kbPadding.Parent = keybindsContent

local kbHeader = Instance.new("TextLabel")
kbHeader.Size = UDim2.new(1, -20, 0, 13)
kbHeader.Position = UDim2.new(0, 12, 0, 0)
kbHeader.BackgroundTransparency = 1
kbHeader.Text = "-KEYBINDS"
kbHeader.TextColor3 = blueLight
kbHeader.Font = Enum.Font.GothamBold
kbHeader.TextSize = 10
kbHeader.TextXAlignment = Enum.TextXAlignment.Left
kbHeader.Parent = keybindsContent

local kbLineWidth = getTextWidth("-KEYBINDS", 10, Enum.Font.GothamBold)
local kbLine = Instance.new("Frame")
kbLine.Name = "KeybindLine"
kbLine.Size = UDim2.new(0, kbLineWidth, 0, 2)
kbLine.Position = UDim2.new(0, 12, 0, 12)
kbLine.BackgroundColor3 = blueActive
kbLine.BorderSizePixel = 0
kbLine.Parent = keybindsContent

local kbLineCorner = Instance.new("UICorner")
kbLineCorner.CornerRadius = UDim.new(1, 0)
kbLineCorner.Parent = kbLine

local keybindList = {
    {name = "Carry Mode", key = "Q"},
    {name = "Lagger Mode", key = "R"},
    {name = "Auto Left", key = "Z"},
    {name = "Auto Right", key = "C"},
    {name = "Auto Bat", key = "E"},
    {name = "TP BAT", key = "X"},
    {name = "Bat Bypass", key = "V"},
    {name = "Insta Reset", key = "H"},
    {name = "TP Down", key = "F"},
    {name = "Drop Brainrot", key = "G"},
    {name = "Hide GUI", key = "LeftCtrl"},
}

local currentY = 25

for i, data in ipairs(keybindList) do
    local row = Instance.new("Frame")
    row.Name = data.name:gsub("%s", "") .. "Row"
    row.Size = UDim2.new(1, -30, 0, 24)
    row.Position = UDim2.new(0, 15, 0, currentY)
    row.BackgroundTransparency = 1
    row.Parent = keybindsContent

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -60, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = data.name
    nameLabel.TextColor3 = blueLight
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0, 40, 0, 20)
    keyButton.Position = UDim2.new(1, -40, 0.5, -10)
    keyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyButton.BorderSizePixel = 0
    keyButton.Text = data.key
    keyButton.TextColor3 = blueLight
    keyButton.Font = Enum.Font.GothamBold
    keyButton.TextSize = 12
    keyButton.AutoButtonColor = false
    keyButton.Parent = row

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 4)
    keyCorner.Parent = keyButton

    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color = blueDark
    keyStroke.Thickness = 1
    keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    keyStroke.Parent = keyButton

    local isAnimating = false
    
    keyButton.MouseButton1Click:Connect(function()
        if isAnimating then return end
        isAnimating = true
        
        local originalText = keyButton.Text
        keyButton.Text = "..."
        keyButton.TextColor3 = blueActive
        
        task.wait(3)
        
        keyButton.Text = originalText
        keyButton.TextColor3 = blueLight
        isAnimating = false
    end)

    keyButton.MouseEnter:Connect(function()
        if not isAnimating then
            keyButton.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
        end
    end)
    keyButton.MouseLeave:Connect(function()
        if not isAnimating then
            keyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
    end)

    currentY = currentY + 24
end

-- =========================================================
-- Unir Tab Contents
-- =========================================================
local tabContents = {
    SPEED = speedContent,
    CUSTOM = customContent,
    VISUAL = visualContent,
    SETTING = settingContent,
    KEYBINDS = keybindsContent,
}

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -20, 0, 32)
tabBar.Position = UDim2.new(0, 10, 1, -42)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 2)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.VerticalAlignment = Enum.VerticalAlignment.Center
tabList.Parent = tabBar

local tabOrder = { "SPEED", "CUSTOM", "VISUAL", "SETTING", "KEYBINDS" }
local tabButtons = {}
local activeTab = "SPEED"

local function setActiveTab(tabName)
    activeTab = tabName
    uiState.activeTab = tabName
    for name, content in pairs(tabContents) do
        content.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if name == tabName then
            btn.BackgroundColor3 = blueDark
            btn.BackgroundTransparency = 0.75
            if stroke then stroke.Color = blueActive; stroke.Thickness = 1.6 end
            btn.TextColor3 = blueActive
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            btn.BackgroundTransparency = 1
            if stroke then stroke.Color = Color3.fromRGB(50, 70, 110); stroke.Thickness = 1 end
            btn.TextColor3 = Color3.fromRGB(130, 160, 200)
        end
    end
    scrollFrame.CanvasPosition = Vector2.new(0, 0)
end

for i, tabName in ipairs(tabOrder) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(0, 50, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(130, 160, 200)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 9
    tabBtn.AutoButtonColor = false
    tabBtn.LayoutOrder = i
    tabBtn.Parent = tabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 70, 110)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = tabBtn

    tabButtons[tabName] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        setActiveTab(tabName)
        saveSettings()
    end)

    tabBtn.MouseEnter:Connect(function()
        if activeTab ~= tabName then
            tabBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
            tabBtn.BackgroundTransparency = 0.6
        end
    end)

    tabBtn.MouseLeave:Connect(function()
        if activeTab ~= tabName then
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            tabBtn.BackgroundTransparency = 1
        end
    end)
end

setActiveTab("SPEED")

-- =========================================================
-- Botones derecha
-- =========================================================
local root = Instance.new("Frame")
root.Name = "RightButtons"
root.Size = UDim2.new(0, 500, 0, 250)
root.Position = UDim2.new(0.56, 0, 0.5, -150)
root.BackgroundTransparency = 1
root.ZIndex = 2
root.Parent = screenGui

local btnSize = 62
local verticalGap = 10
local columnGap = 12

local columns = {
    {count = 5, labels = {
        "DROP\nBR",
        "BAT\nBYPASS",
        "BAT\nAIMBOT",
        "TP\nDOWN",
        "LAGGER\nNORMAL"
    }},
    {count = 5, labels = {
        "FLOAT",
        "AUTO\nLEFT",
        "AUTO\nRIGHT",
        "CARRY\nSPD",
        "LAGGER\nCARRY"
    }},
    {count = 2, labels = {
        "INSTA\nRESET",
        "TP\nBAT"
    }},
}

local columnX = {
    [1] = 0,
    [2] = btnSize + columnGap,
    [3] = (btnSize + columnGap) * 2,
}

local function isFastFlashButton(button)
    local value = string.upper((button.Text:gsub("\n", " ")))
    return value == "TP DOWN" or value == "DROP BR" or value == "INSTA RESET" or value == "BAT BYPASS" or value == "BAT AIMBOT" or value == "TP BAT" or value == "AUTO LEFT" or value == "AUTO RIGHT"
end

local function set30MinuteState(button, isActive)
    local oldThread = button:GetAttribute("CooldownThread")
    if oldThread then task.cancel(oldThread) end

    if isActive then
        button:SetAttribute("Active", true)
        button.BackgroundColor3 = blueActive
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        local cooldownThread = task.spawn(function()
            task.wait(1800)
            if button:GetAttribute("Active") == true then
                button:SetAttribute("Active", false)
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                button.TextColor3 = blueLight
            end
        end)
        button:SetAttribute("CooldownThread", cooldownThread)
    else
        button:SetAttribute("Active", false)
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.TextColor3 = blueLight
    end
end

local function flashFastButton(button)
    if button:GetAttribute("QuickFlashing") == true then return end
    button:SetAttribute("QuickFlashing", true)
    button.BackgroundColor3 = blueActive
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.delay(0.2, function()
        button:SetAttribute("QuickFlashing", false)
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.TextColor3 = blueLight
    end)
end

local modeButtonLabels = {
    ["CARRY\nSPD"] = "carry",
    ["LAGGER\nNORMAL"] = "laggerNormal",
    ["LAGGER\nCARRY"] = "laggerCarry",
}

for colIndex, data in ipairs(columns) do
    local colFrame = Instance.new("Frame")
    colFrame.Name = "Column" .. colIndex
    colFrame.Position = UDim2.new(0, columnX[colIndex], 0, 0)
    colFrame.Size = UDim2.new(0, btnSize, 0, (btnSize * data.count) + (verticalGap * (data.count - 1)))
    colFrame.BackgroundTransparency = 1
    colFrame.ZIndex = 3
    colFrame.Parent = root

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, verticalGap)
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.VerticalAlignment = Enum.VerticalAlignment.Top
    list.Parent = colFrame

    for i = 1, data.count do
        local button = Instance.new("TextButton")
        button.Name = "Button_" .. colIndex .. "_" .. i
        button.Size = UDim2.new(0, btnSize, 0, btnSize)
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.BorderSizePixel = 0
        button.Text = data.labels[i]
        button.TextColor3 = blueLight
        button.Font = Enum.Font.GothamBlack
        button.TextSize = 10
        button.TextWrapped = true
        button.TextScaled = false
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.TextYAlignment = Enum.TextYAlignment.Center
        button.AutoButtonColor = false
        button.ZIndex = 4
        button:SetAttribute("Active", false)
        button:SetAttribute("QuickFlashing", false)
        button.Parent = colFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = button

        local modeKey = modeButtonLabels[button.Text]

        -- Lógica específica para los botones solicitados
        if button.Text == "DROP\nBR" then
            button.MouseButton1Click:Connect(function()
                executeDropWithToggle(function(active)
                    if active then
                        set30MinuteState(button, true)
                    else
                        set30MinuteState(button, false)
                    end
                end)
            end)
        elseif button.Text == "TP\nBAT" then
            button.MouseButton1Click:Connect(function()
                toggleBatDesyncTp()
                if batDesyncTpEnabled then
                    set30MinuteState(button, true)
                else
                    set30MinuteState(button, false)
                end
            end)
        elseif button.Text == "INSTA\nRESET" then
            button.MouseButton1Click:Connect(function()
                instaReset()
                flashFastButton(button)
            end)
        elseif button.Text == "AUTO\nLEFT" then
            button.MouseButton1Click:Connect(function()
                if autoLeftEnabled then
                    autoLeftEnabled = false
                    stopAutoLeft()
                    set30MinuteState(button, false)
                else
                    autoLeftEnabled = true
                    startAutoLeft()
                    set30MinuteState(button, true)
                end
            end)
        elseif button.Text == "AUTO\nRIGHT" then
            button.MouseButton1Click:Connect(function()
                if autoRightEnabled then
                    autoRightEnabled = false
                    stopAutoRight()
                    set30MinuteState(button, false)
                else
                    autoRightEnabled = true
                    startAutoRight()
                    set30MinuteState(button, true)
                end
            end)
        elseif modeKey then
            modeButtonRefs[modeKey] = button
            button.MouseButton1Click:Connect(function()
                setMode(modeKey)
            end)
            button.MouseEnter:Connect(function()
                if currentMode == modeKey then
                    button.BackgroundColor3 = blueActiveDark
                else
                    button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                end
            end)
            button.MouseLeave:Connect(function()
                if currentMode == modeKey then
                    button.BackgroundColor3 = blueActive
                else
                    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                end
            end)
        else
            -- Comportamiento por defecto para los demás botones
            button.MouseEnter:Connect(function()
                if button:GetAttribute("QuickFlashing") == true then
                    button.BackgroundColor3 = blueActiveDark
                    return
                end
                if button:GetAttribute("Active") == true then
                    button.BackgroundColor3 = blueActiveDark
                else
                    button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                end
            end)
            button.MouseLeave:Connect(function()
                if button:GetAttribute("QuickFlashing") == true then
                    button.BackgroundColor3 = blueActive
                    return
                end
                if button:GetAttribute("Active") == true then
                    button.BackgroundColor3 = blueActive
                else
                    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                end
            end)

            button.MouseButton1Click:Connect(function()
                if isFastFlashButton(button) then
                    flashFastButton(button)
                else
                    local active = button:GetAttribute("Active") == true
                    set30MinuteState(button, not active)
                end
            end)
        end
    end
end

-- =========================================================
-- Drag helper
-- =========================================================
local function makeDraggable(frame, handle, onDragEnd)
    handle = handle or frame
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                    if onDragEnd then onDragEnd(frame.Position) end
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(panel, titleWrap, function(newPos)
    shownPos = newPos
    uiState.panelPosition = udim2ToTable(newPos)
    saveSettings()
end)

-- =========================================================
-- Animación abrir/cerrar
-- =========================================================
openButton.MouseButton1Click:Connect(function()
    panel.Visible = true
    openButton.Visible = false
    panel.Position = UDim2.new(0, shownPos.X.Offset - PANEL_W - 40, shownPos.Y.Scale, shownPos.Y.Offset)
    TweenService:Create(panel, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = shownPos
    }):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    shownPos = panel.Position
    uiState.panelPosition = udim2ToTable(shownPos)
    saveSettings()

    local closeTarget = UDim2.new(0, shownPos.X.Offset - PANEL_W - 40, shownPos.Y.Scale, shownPos.Y.Offset)
    local closeTween = TweenService:Create(panel, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = closeTarget
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        panel.Visible = false
        openButton.Visible = true
    end)
end)

openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
end)
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)
closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- =========================================================
-- Cargar estado
-- =========================================================
local saved = loadSettings()
if saved then
    if saved.panelPosition then
        local p = tableToUdim2(saved.panelPosition)
        if p then
            shownPos = p
            panel.Position = p
        end
    end
    if saved.rightButtonsPosition then
        local p = tableToUdim2(saved.rightButtonsPosition)
        if p then root.Position = p end
    end

    if type(saved.speeds) == "table" then
        if tonumber(saved.speeds.normal) then
            normalSpeedValue = roundValue(clampSpeed(saved.speeds.normal) or normalSpeedValue)
            setNormalBox(normalSpeedValue)
        end
        if tonumber(saved.speeds.carry) then
            carrySpeedValue = roundValue(clampSpeed(saved.speeds.carry) or carrySpeedValue)
            setCarryBox(carrySpeedValue)
        end
        if tonumber(saved.speeds.laggerNormal) then
            laggerNormalSpeedValue = roundValue(clampSpeed(saved.speeds.laggerNormal) or laggerNormalSpeedValue)
            setLaggerNormalBox(laggerNormalSpeedValue)
        end
        if tonumber(saved.speeds.laggerCarry) then
            laggerCarrySpeedValue = roundValue(clampSpeed(saved.speeds.laggerCarry) or laggerCarrySpeedValue)
            setLaggerCarryBox(laggerCarrySpeedValue)
        end
    end

    if saved.currentMode and modeLabels[saved.currentMode] then
        currentMode = saved.currentMode
    end

    if saved.autoCarryEnabled ~= nil then
        autoCarryEnabled = saved.autoCarryEnabled and true or false
    end

    if saved.activeTab and tabContents[saved.activeTab] then
        setActiveTab(saved.activeTab)
    end
end

updateToggleVisual(autoCarryEnabled, false)
updateAutoTpToggleVisual(autoTpDownEnabled, false)
updateHoldJumpToggleVisual(holdJumpEnabled, false)

uiState.speeds.normal = normalSpeedValue
uiState.speeds.carry = carrySpeedValue
uiState.speeds.laggerNormal = laggerNormalSpeedValue
uiState.speeds.laggerCarry = laggerCarrySpeedValue

uiState.autoCarryEnabled = autoCarryEnabled

applyCurrentSpeed()

if not saved then
    saveSettings()
end