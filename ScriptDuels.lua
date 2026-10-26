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
-- Variables globales y Stubs (para evitar errores)
-- =========================================================
local LP = player
local _CFnew = CFrame.new
local _V3zero = Vector3.new(0, 0, 0)
local _V3new = Vector3.new
local _tick = tick
local UIS = UserInputService
local NS = 30
local CS = 29
local LAGGER_SPEED = 24
local LAGGER_CARRY_SPEED = 14.5

-- Variables de estado
local speedMode = false
local laggerToggled = false
local laggerCarryToggled = false
local autoLeftEnabled = false
local autoRightEnabled = false
local batCounterEnabled = false
local medusaCounterEnabled = false
local bodyLockEnabled = false
local batCounterV2Enabled = false
local infJumpEnabled = false
local infJumpMode = "HOLD"
local batDesyncTpEnabled = false
local noPlayerCollisionEnabled = false
local antiRagdollMode = "off"
local dropMode = 1
local mirrorTPDownEnabled = false
local autoBatEnabled = false
local autoBatV2Enabled = false

-- Stubs de funciones
local mobSetCarry = function() end
local setCarryModeVisual = function() end
local setLaggerModeVisual = function() end
local setLaggerCarryVisual = function() end
local mobSetAutoLeft = function() end
local mobSetAutoRight = function() end
local _unsuppressBodyLock = function() end
local _suppressBodyLock = function() end
local disableAllAimbots = function() end
local autoLeftSetVisual = function() end
local autoRightSetVisual = function() end
local autoBatSetVisual = function() end
local mobSetAutoBat = function() end
local findBat = function() return nil end
local getClosestTarget = function() return nil end
local _clamp = math.clamp
local _CFlookAt = CFrame.lookAt
local getClosestTargetBody = function() return nil end
local findBatForCounter = function() return nil end
local findMedusa = function() return nil end
local getBatV2Counter = function() return nil end
local batV2FloatingButton = nil
local BAT_AIMBOT_SPEED = 30
local bodyLockRange = 20
local MEDUSA_COOLDOWN = 5
local BAT_COUNTER_V2_SWING_CD = 0.5
local _blSuppressCount = 0
local Conns = { batCounter = nil, anchor = {} }
local medusaDebounce = false
local medusaLastUsed = 0
local batCounterDebounce = false
local batCounterV2Conn = nil
local batCounterV2Debounce = false
local batCounterV2HitCooldown = false
local _bodyLockConn = nil
local _aimbotConn = nil
local _prevAutoRotate = nil
local lastMoveDir = _V3zero
local alConn = nil
local alPhase = 1
local arConn = nil
local arPhase = 1
local AP = {
    L1 = Vector3.new(-10, 0, 0), L2 = Vector3.new(-20, 0, 0), L_FACE = Vector3.new(-10, 0, 10),
    R1 = Vector3.new(10, 0, 0), R2 = Vector3.new(20, 0, 0), R_FACE = Vector3.new(10, 0, 10)
}
local modeValLbl = nil
local antiRagdollValLbl = nil
local tpBatBtnFrame = nil

-- =========================================================
-- 1. SISTEMA DE KEYBINDS
-- =========================================================
_G.AmbitiousKeybinds = _G.AmbitiousKeybinds or {
    AutoBat = Enum.KeyCode.E,
    BatV2 = Enum.KeyCode.Q,
    Carry = Enum.KeyCode.C,
    InfJump = Enum.KeyCode.J,
    InstaReset = Enum.KeyCode.R,
    DropBR = Enum.KeyCode.T,
    TpDown = Enum.KeyCode.G
}

function setKeybind(actionName, keyCode)
    if _G.AmbitiousKeybinds[actionName] ~= nil then
        _G.AmbitiousKeybinds[actionName] = keyCode
        saveKeybinds()
    end
end

function saveKeybinds()
    pcall(function()
        if writefile and HttpService then
            local keyData = {}
            for action, key in pairs(_G.AmbitiousKeybinds) do
                keyData[action] = key.Name
            end
            writefile("AmbitiousKeybinds.json", HttpService:JSONEncode(keyData))
        end
    end)
end

function loadKeybinds()
    pcall(function()
        if readfile and isfile and isfile("AmbitiousKeybinds.json") and HttpService then
            local raw = readfile("AmbitiousKeybinds.json")
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" then
                for action, keyName in pairs(data) do
                    if _G.AmbitiousKeybinds[action] ~= nil and Enum.KeyCode[keyName] then
                        _G.AmbitiousKeybinds[action] = Enum.KeyCode[keyName]
                    end
                end
            end
        end
    end)
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local pressedKey = input.KeyCode

        if pressedKey == _G.AmbitiousKeybinds.AutoBat then
            if autoBatEnabled then disableAutoBat() else enableAutoBat() end
        elseif pressedKey == _G.AmbitiousKeybinds.BatV2 then
            toggleBatV2()
        elseif pressedKey == _G.AmbitiousKeybinds.Carry then
            toggleCarryMode()
        elseif pressedKey == _G.AmbitiousKeybinds.InfJump then
            if infJumpEnabled then _G.setInfJumpInternal(false) else _G.setInfJumpInternal(true) end
        elseif pressedKey == _G.AmbitiousKeybinds.InstaReset then
            pcall(instaReset)
        elseif pressedKey == _G.AmbitiousKeybinds.DropBR then
            runDropBrainrot()
        elseif pressedKey == _G.AmbitiousKeybinds.TpDown then
            doTpDown()
        end
    end
end)

-- =========================================================
-- 2. SISTEMA DE CONFIGURACIÓN (SAVE/LOAD)
-- =========================================================
function saveAllSettings()
    pcall(function()
        local settingsData = {
            autoBatEnabled = autoBatEnabled,
            autoBatV2Enabled = autoBatV2Enabled,
            batCounterEnabled = batCounterEnabled,
            batCounterV2Enabled = batCounterV2Enabled,
            medusaCounterEnabled = medusaCounterEnabled,
            infJumpEnabled = infJumpEnabled,
            infJumpMode = infJumpMode,
            speedMode = speedMode,
            laggerToggled = laggerToggled,
            laggerCarryToggled = laggerCarryToggled,
            bodyLockEnabled = bodyLockEnabled,
            mirrorTPDownEnabled = mirrorTPDownEnabled,
            autoLeftEnabled = autoLeftEnabled,
            autoRightEnabled = autoRightEnabled,
            batDesyncTpEnabled = batDesyncTpEnabled,
            noPlayerCollisionEnabled = noPlayerCollisionEnabled,
            antiRagdollMode = antiRagdollMode,
            dropMode = dropMode
        }
        
        if writefile and HttpService then
            writefile("AmbitiousConfig.json", HttpService:JSONEncode(settingsData))
        end
    end)
end

function loadAllSettings()
    pcall(function()
        if readfile and isfile and isfile("AmbitiousConfig.json") and HttpService then
            local raw = readfile("AmbitiousConfig.json")
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" then
                if data.infJumpEnabled ~= nil then infJumpEnabled = data.infJumpEnabled end
                if data.infJumpMode ~= nil then infJumpMode = data.infJumpMode end
                if data.speedMode ~= nil then speedMode = data.speedMode end
                if data.laggerToggled ~= nil then laggerToggled = data.laggerToggled end
                if data.laggerCarryToggled ~= nil then laggerCarryToggled = data.laggerCarryToggled end
                if data.bodyLockEnabled ~= nil then bodyLockEnabled = data.bodyLockEnabled end
                if data.antiRagdollMode ~= nil then antiRagdollMode = data.antiRagdollMode end
                if data.dropMode ~= nil then dropMode = data.dropMode end
            end
        end
    end)
end

function resetConfigToDefault()
    autoBatEnabled = false
    autoBatV2Enabled = false
    batCounterEnabled = false
    batCounterV2Enabled = false
    medusaCounterEnabled = false
    infJumpEnabled = false
    infJumpMode = "HOLD"
    speedMode = false
    laggerToggled = false
    laggerCarryToggled = false
    bodyLockEnabled = false
    mirrorTPDownEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    batDesyncTpEnabled = false
    noPlayerCollisionEnabled = false
    antiRagdollMode = "off"
    dropMode = 1
    
    resetMovementState()
    saveAllSettings()
end

-- =========================================================
-- 3. SISTEMA DE VELOCIDAD Y MOVIMIENTO
-- =========================================================
function CarrySystem:getActiveSpeed()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return self.normalSpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange then
            self.softStealLatched = true
            return self.softStealSpeed
        end
        if self.softStealLatched and self:isCarrying() then
            return self.softStealSpeed
        else
            self.softStealLatched = false
        end
    end
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "NORMAL", self.normalSpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange or (self.softStealLatched and self:isCarrying()) then
            return "AUTO CARRY", self.softStealSpeed
        end
    end
    if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
    if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
    if self.speedToggled then return "CARRY", self.carrySpeed end
    return "NORMAL", self.normalSpeed
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then 
            modeValLbl.Text = "Lagger Carry"
            modeValLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        elseif laggerToggled then 
            modeValLbl.Text = "Lagger"
            modeValLbl.TextColor3 = Color3.fromRGB(255, 170, 0)
        elseif speedMode then 
            modeValLbl.Text = "Carry"
            modeValLbl.TextColor3 = Color3.fromRGB(0, 255, 128)
        else 
            modeValLbl.Text = "Normal"
            modeValLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    if laggerCarryToggled then _G.AceCurrentSpeedMode = "Lagger Carry"
    elseif laggerToggled then _G.AceCurrentSpeedMode = "Lagger"
    elseif speedMode then _G.AceCurrentSpeedMode = "Carry"
    else _G.AceCurrentSpeedMode = "Normal" end

    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end

    if CarrySystem then
        CarrySystem.speedToggled = speedMode
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
    if CarrySystem then
        CarrySystem.speedToggled = speedMode
        if laggerCarryToggled then
            CarrySystem:setLaggerMode(2)
        elseif laggerToggled then
            CarrySystem:setLaggerMode(1)
        else
            CarrySystem:setLaggerMode(0)
        end
    end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
end

function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    end
    resetMovementState()
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if not _G.AmbitiousSafeModeTryStart() then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        return
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
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
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if not _G.AmbitiousSafeModeTryStart() then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
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
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

-- =========================================================
-- 4. FUNCIONES DE COMBATE Y UTILIDADES
-- =========================================================
function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)
        local desiredVel = _V3new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.5, 2.5)
            ry = _clamp(ry, -2.5, 2.5)
            rz = _clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if not _G.AmbitiousSafeModeTryStart() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoBatV2Enabled then disableBatV2() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

function enableBatV2()
    selectedAimbotMode = "Bat Bypass"
    local ok = _G.AceStartAntiBypassAimbot()
    if ok ~= false then
        autoBatV2Enabled = true
        if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, true) end
        end
    end
end

function disableBatV2()
    _G.AceStopAntiBypassAimbot()
    autoBatV2Enabled = false
    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, false) end
    end
end

function toggleBatV2()
    if autoBatV2Enabled then disableBatV2() else enableBatV2() end
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function()
        batCounterV2HitCooldown = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
    end)
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function setNoPlayerCollision(on)
    on = on and true or false
    noPlayerCollisionEnabled = on
    if on then
        if _G.SetNoPlayerCollision then _G.SetNoPlayerCollision(true) end
    else
        if _G.SetNoPlayerCollision then _G.SetNoPlayerCollision(false) end
    end
end

-- =========================================================
-- 5. VISUALES (FLOATING BUTTONS / LABELS)
-- =========================================================
function paintFloatingBtn(frame, active)
    pcall(function()
        if not frame then return end
        if active then
            frame.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            local uiStroke = frame:FindFirstChildOfClass("UIStroke")
            if uiStroke then
                uiStroke.Color = Color3.fromRGB(255, 255, 255)
            end
        else
            frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            local uiStroke = frame:FindFirstChildOfClass("UIStroke")
            if uiStroke then
                uiStroke.Color = Color3.fromRGB(90, 90, 90)
            end
        end
    end)
end

function updateTpBatButtonWithAntiDie(on)
    pcall(function()
        if tpBatBtnFrame then
            paintFloatingBtn(tpBatBtnFrame, on)
            local label = tpBatBtnFrame:FindFirstChild("Title") or tpBatBtnFrame:FindFirstChildOfClass("TextLabel")
            if label then
                if on then
                    label.Text = "TP Bat [ON]"
                else
                    label.Text = "TP Bat"
                end
            end
        end
    end)
end

_G.updateAntiRagdollUI = function(mode)
    pcall(function()
        if antiRagdollValLbl then
            if mode == "v1" then
                antiRagdollValLbl.Text = "V1"
                antiRagdollValLbl.TextColor3 = Color3.fromRGB(0, 255, 128)
            elseif mode == "v2" then
                antiRagdollValLbl.Text = "V2"
                antiRagdollValLbl.TextColor3 = Color3.fromRGB(0, 170, 255)
            else
                antiRagdollValLbl.Text = "OFF"
                antiRagdollValLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end


-- =========================================================
-- MEDIR TEXTO
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
-- BOTÓN BLAZZEN
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
-- PANEL
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
-- SCROLLING FRAME
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
-- SPEED CONTENT
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

-- Header
local speedHeader = Instance.new("TextLabel")
speedHeader.Size = UDim2.new(1, -20, 0, 13)
speedHeader.Position = UDim2.new(0, 12, 0, 0)
speedHeader.BackgroundTransparency = 1
speedHeader.Text = "-SPEED MODES"
speedHeader.TextColor3 = blueLight
speedHeader.Font = Enum.Font.GothamBold
speedHeader.TextSize = 10
speedHeader.TextXAlignment = Enum.TextXAlignment.Left
speedHeader.Parent = speedContent

local speedLineWidth = getTextWidth("-SPEED MODES", 10, Enum.Font.GothamBold)
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

-- Función para crear botones de toggle
local function createToggleButton(parent, yPos, labelText, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 28)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btn.BorderSizePixel = 0
    btn.Text = labelText
    btn.TextColor3 = blueLight
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = blueDark
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- Botones de Modos
local yPos = 25

local btnCarry = createToggleButton(speedContent, yPos, "Carry Mode", function()
    toggleCarryMode()
    btnCarry.BackgroundColor3 = speedMode and blueActive or Color3.fromRGB(15, 20, 40)
    btnLagger.BackgroundColor3 = laggerToggled and blueActive or Color3.fromRGB(15, 20, 40)
    btnLaggerCarry.BackgroundColor3 = laggerCarryToggled and blueActive or Color3.fromRGB(15, 20, 40)
end)
yPos = yPos + 34

local btnLagger = createToggleButton(speedContent, yPos, "Lagger Mode", function()
    toggleLaggerMode()
    btnCarry.BackgroundColor3 = speedMode and blueActive or Color3.fromRGB(15, 20, 40)
    btnLagger.BackgroundColor3 = laggerToggled and blueActive or Color3.fromRGB(15, 20, 40)
    btnLaggerCarry.BackgroundColor3 = laggerCarryToggled and blueActive or Color3.fromRGB(15, 20, 40)
end)
yPos = yPos + 34

local btnLaggerCarry = createToggleButton(speedContent, yPos, "Lagger Carry Mode", function()
    toggleLaggerCarryMode()
    btnCarry.BackgroundColor3 = speedMode and blueActive or Color3.fromRGB(15, 20, 40)
    btnLagger.BackgroundColor3 = laggerToggled and blueActive or Color3.fromRGB(15, 20, 40)
    btnLaggerCarry.BackgroundColor3 = laggerCarryToggled and blueActive or Color3.fromRGB(15, 20, 40)
end)
yPos = yPos + 34

local btnCycle = createToggleButton(speedContent, yPos, "Cycle Modes", function()
    toggleLaggerCycle()
    btnCarry.BackgroundColor3 = speedMode and blueActive or Color3.fromRGB(15, 20, 40)
    btnLagger.BackgroundColor3 = laggerToggled and blueActive or Color3.fromRGB(15, 20, 40)
    btnLaggerCarry.BackgroundColor3 = laggerCarryToggled and blueActive or Color3.fromRGB(15, 20, 40)
end)
yPos = yPos + 34

-- Separador
local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(1, -30, 0, 1)
sep1.Position = UDim2.new(0, 15, 0, yPos + 5)
sep1.BackgroundColor3 = Color3.fromRGB(50, 70, 110)
sep1.BorderSizePixel = 0
sep1.Parent = speedContent
yPos = yPos + 15

-- Botones de Auto Move
local btnAutoLeft = createToggleButton(speedContent, yPos, "Auto Left", function()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        btnAutoLeft.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    else
        autoLeftEnabled = true
        startAutoLeft()
        btnAutoLeft.BackgroundColor3 = blueActive
        btnAutoRight.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    end
end)
yPos = yPos + 34

local btnAutoRight = createToggleButton(speedContent, yPos, "Auto Right", function()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        btnAutoRight.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    else
        autoRightEnabled = true
        startAutoRight()
        btnAutoRight.BackgroundColor3 = blueActive
        btnAutoLeft.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    end
end)
yPos = yPos + 34

-- Separador
local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(1, -30, 0, 1)
sep2.Position = UDim2.new(0, 15, 0, yPos + 5)
sep2.BackgroundColor3 = Color3.fromRGB(50, 70, 110)
sep2.BorderSizePixel = 0
sep2.Parent = speedContent
yPos = yPos + 15

-- Botones de Counters
local btnBatCounter = createToggleButton(speedContent, yPos, "Bat Counter", function()
    batCounterEnabled = not batCounterEnabled
    if batCounterEnabled then
        startBatCounter()
        btnBatCounter.BackgroundColor3 = blueActive
    else
        stopBatCounter()
        btnBatCounter.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    end
end)
yPos = yPos + 34

local btnMedusaCounter = createToggleButton(speedContent, yPos, "Medusa Counter", function()
    medusaCounterEnabled = not medusaCounterEnabled
    if medusaCounterEnabled then
        setupMedusaCounter(LP.Character)
        btnMedusaCounter.BackgroundColor3 = blueActive
    else
        stopMedusaCounter()
        btnMedusaCounter.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    end
end)
yPos = yPos + 34

-- Separador
local sep3 = Instance.new("Frame")
sep3.Size = UDim2.new(1, -30, 0, 1)
sep3.Position = UDim2.new(0, 15, 0, yPos + 5)
sep3.BackgroundColor3 = Color3.fromRGB(50, 70, 110)
sep3.BorderSizePixel = 0
sep3.Parent = speedContent
yPos = yPos + 15

-- Botón de Body Lock
local btnBodyLock = createToggleButton(speedContent, yPos, "Body Lock", function()
    bodyLockEnabled = not bodyLockEnabled
    if bodyLockEnabled then
        startBodyLock()
        btnBodyLock.BackgroundColor3 = blueActive
    else
        stopBodyLock()
        btnBodyLock.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    end
end)
yPos = yPos + 34

-- Botones de Acción Rápida
local btnTrySwing = createToggleButton(speedContent, yPos, "Force Swing", function()
    trySwing()
end)
yPos = yPos + 34

local btnToggleBatV2 = createToggleButton(speedContent, yPos, "Toggle Bat V2", function()
    toggleBatV2()
end)
yPos = yPos + 34

-- Botón de Reset
local btnResetConfig = createToggleButton(speedContent, yPos, "Reset Config", function()
    resetConfigToDefault()
    btnCarry.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnLagger.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnLaggerCarry.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnAutoLeft.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnAutoRight.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnBatCounter.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnMedusaCounter.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    btnBodyLock.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
end)
yPos = yPos + 34

-- =========================================================
-- TABS
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

-- KEYBINDS content
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
    {name = "Auto Bat", key = "AutoBat"},
    {name = "Bat V2", key = "BatV2"},
    {name = "Carry Mode", key = "Carry"},
    {name = "Inf Jump", key = "InfJump"},
    {name = "Insta Reset", key = "InstaReset"},
    {name = "Drop BR", key = "DropBR"},
    {name = "TP Down", key = "TpDown"},
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
    keyButton.Text = _G.AmbitiousKeybinds[data.key] and _G.AmbitiousKeybinds[data.key].Name or "?"
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
-- UNIR TAB CONTENTS
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
-- BOTONES DERECHA
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

        if button.Text == "BAT\nBYPASS" then
            button.MouseButton1Click:Connect(function()
                if autoBatV2Enabled then
                    disableBatV2()
                    set30MinuteState(button, false)
                else
                    enableBatV2()
                    set30MinuteState(button, true)
                end
            end)
        elseif button.Text == "BAT\nAIMBOT" then
            button.MouseButton1Click:Connect(function()
                if autoBatEnabled then
                    disableAutoBat()
                    set30MinuteState(button, false)
                else
                    enableAutoBat()
                    set30MinuteState(button, true)
                end
            end)
        elseif button.Text == "TP\nDOWN" then
            button.MouseButton1Click:Connect(function()
                doTpDown()
                flashFastButton(button)
            end)
        elseif button.Text == "DROP\nBR" then
            button.MouseButton1Click:Connect(function()
                if dropActive then
                    stopDropBrainrot()
                    set30MinuteState(button, false)
                else
                    executeDropWithToggle(function(active)
                        set30MinuteState(button, active)
                    end)
                end
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
        elseif button.Text == "INSTA\nRESET" then
            button.MouseButton1Click:Connect(function()
                instaReset()
                flashFastButton(button)
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
-- DRAG HELPER
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
end)

-- =========================================================
-- ANIMACIÓN ABRIR/CERRAR
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
-- INICIALIZACIÓN DE ESTADOS
-- =========================================================
btnCarry.BackgroundColor3 = speedMode and blueActive or Color3.fromRGB(15, 20, 40)
btnLagger.BackgroundColor3 = laggerToggled and blueActive or Color3.fromRGB(15, 20, 40)
btnLaggerCarry.BackgroundColor3 = laggerCarryToggled and blueActive or Color3.fromRGB(15, 20, 40)

loadKeybinds()
loadAllSettings()