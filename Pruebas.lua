--[[
    LocalScript: SpiritControlGUI v2
    Ubicación: StarterPlayer > StarterPlayerScripts
]]

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera    = workspace.CurrentCamera

-- ================== CONFIG ==================
local CONFIG = {
    ButtonSize        = 70,
    ButtonSeparation  = 20,
    DragPadding       = 40,
    TapThreshold      = 12,

    SpiritRadius       = 15,      -- círculo de ~15 pies alrededor del personaje
    SpiritColor        = Color3.fromRGB(120, 210, 255),
    SpiritTransparency = 0.35,
    SmallStepInterval  = 0.25,    -- cada cuánto da un "pasito"
    SmallStepSize      = 4,       -- tamaño de cada pasito (studs)

    AttackDetectRadius = 15,      -- SOLO detecta enemigos dentro del círculo
    AttackCooldown     = 0.3,

    SpeedSteps      = 10,
    StepDistance    = 6,
    SpeedCooldown   = 0.15,

    BatAIName        = "BatAI",   -- <-- cambia al nombre real de tu bot
    BrainrotToolName = nil,       -- nil = cualquier Tool
}

-- ================== ESTADO ==================
local spiritActive   = false
local spiritPart     = nil
local spiritConn     = nil
local basePos        = nil
local spiritPos      = nil
local savedWelds     = {}
local lastSpeedTime  = -math.huge
local lastStepTime   = 0
local lastAttackTime = -math.huge
local cachedBat      = nil
local nextBatSearch  = 0
local activeDrags    = {}

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

-- ================== HELPERS ==================
local function findBrainrotTool(char)
    if not char then return nil end
    if CONFIG.BrainrotToolName then
        return char:FindFirstChild(CONFIG.BrainrotToolName)
    end
    return char:FindFirstChildOfClass("Tool")
end

local function findBat()
    local char = player.Character
    if char then
        local b = char:FindFirstChild(CONFIG.BatAIName)
        if b then return b end
    end
    return workspace:FindFirstChild(CONFIG.BatAIName, true)
end

local function getBatPart(bat)
    if not bat then return nil end
    if bat:IsA("BasePart") then return bat end
    local p = bat:FindFirstChild("HumanoidRootPart") or bat:FindFirstChild("Head")
    if p and p:IsA("BasePart") then return p end
    for _, d in ipairs(bat:GetDescendants()) do
        if d:IsA("BasePart") then return d end
    end
    return nil
end

local function setCharacterVisibility(visible)
    local char = player.Character
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then
            d.LocalTransparencyModifier = visible and 0 or 1
        end
    end
end

local function detachHandle(handle)
    savedWelds = {}
    if not handle then return end
    for _, j in ipairs(handle:GetJoints()) do
        if j:IsA("JointInstance") then
            savedWelds[j] = j.Enabled
            j.Enabled = false
        end
    end
end

local function reattachHandle()
    for j, s in pairs(savedWelds) do
        if j and j.Parent then j.Enabled = s end
    end
    savedWelds = {}
end

-- Verifica que la posición esté sobre el mapa (con piso debajo)
local function isValidMapPosition(pos)
    if not spiritPart then return false end
    local exclude = {spiritPart}
    if player.Character then table.insert(exclude, player.Character) end
    raycastParams.FilterDescendantsInstances = exclude
    local result = workspace:Raycast(
        pos + Vector3.new(0, 100, 0),
        Vector3.new(0, -500, 0),
        raycastParams
    )
    return result ~= nil
end

-- Encuentra al jugador más cercano dentro del círculo
local function findNearestAttacker()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest, nearestDist = nil, CONFIG.AttackDetectRadius
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local oc = other.Character
            if oc then
                local ohrp = oc:FindFirstChild("HumanoidRootPart")
                local ohum = oc:FindFirstChildOfClass("Humanoid")
                if ohrp and ohum and ohum.Health > 0 then
                    local d = (ohrp.Position - hrp.Position).Magnitude
                    if d <= nearestDist then
                        nearest, nearestDist = oc, d
                    end
                end
            end
        end
    end
    return nearest
end

-- ================== SPIRIT ==================
local function updateSpiritPosition(targetPos)
    spiritPos = targetPos

    if spiritPart and spiritPart.Parent then
        spiritPart.CFrame = CFrame.new(targetPos)
    end

    -- Brainrot en la mano teletransporta con el espíritu
    local char = player.Character
    if char then
        local t = findBrainrotTool(char)
        if t then
            local h = t:FindFirstChild("Handle")
            if h and h:IsA("BasePart") then
                for _, j in ipairs(h:GetJoints()) do
                    if j:IsA("JointInstance") and j.Enabled then
                        savedWelds[j] = true
                        j.Enabled = false
                    end
                end
                h.CFrame = CFrame.new(targetPos + Vector3.new(0, 1.5, 0))
            end
        end
    end
end

local function startSpirit()
    if spiritActive then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    spiritActive = true
    basePos      = hrp.Position          -- punto fijo alrededor del cual orbita
    spiritPos    = basePos + Vector3.new(0, 2, 0)
    lastStepTime = tick()

    setCharacterVisibility(false)        -- personaje invisible

    local spirit = Instance.new("Part")
    spirit.Name         = "LocalSpiritPart"
    spirit.Shape        = Enum.PartType.Ball
    spirit.Size         = Vector3.new(2.5, 2.5, 2.5)
    spirit.Anchored     = true
    spirit.CanCollide   = false
    spirit.CanQuery     = false
    spirit.CanTouch     = false
    spirit.Material     = Enum.Material.Neon
    spirit.Color        = CONFIG.SpiritColor
    spirit.Transparency = CONFIG.SpiritTransparency
    spirit.CFrame       = CFrame.new(spiritPos)
    spirit.Parent       = workspace
    spiritPart = spirit

    local tool   = findBrainrotTool(char)
    local handle = tool and tool:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then
        detachHandle(handle)
    end

    cachedBat     = findBat()
    nextBatSearch = tick() + 0.5

    spiritConn = RunService.Heartbeat:Connect(function()
        if not spiritActive then return end
        if not player.Character then return end

        local now = tick()
        local targetPos = nil

        -- 1) Si hay enemigo cerca -> espíritu + bat teletransportan a él
        if now - lastAttackTime >= CONFIG.AttackCooldown then
            local attacker = findNearestAttacker()
            if attacker then
                local ahrp = attacker:FindFirstChild("HumanoidRootPart")
                if ahrp then
                    targetPos = ahrp.Position + Vector3.new(0, 2, 0)
                    lastAttackTime = now
                end
            end
        end

        -- 2) Si no hay enemigo -> pasitos pequeños random (sin salir del mapa)
        if not targetPos and now - lastStepTime >= CONFIG.SmallStepInterval then
            lastStepTime = now
            local currentPos = spiritPos or basePos

            -- paso aleatorio 3D
            local theta = math.random() * math.pi * 2
            local phi   = math.acos(2 * math.random() - 1)
            local stepDist = math.random() * CONFIG.SmallStepSize
            local offset = Vector3.new(
                math.sin(phi) * math.cos(theta),
                math.cos(phi) * 0.6,          -- menos vertical para no irse volando
                math.sin(phi) * math.sin(theta)
            ) * stepDist

            local candidate = currentPos + offset

            -- limitar al círculo de 15 studs de basePos
            local fromBase = candidate - basePos
            if fromBase.Magnitude > CONFIG.SpiritRadius then
                candidate = basePos + fromBase.Unit * CONFIG.SpiritRadius
            end

            -- solo mover si es posición válida del mapa
            if isValidMapPosition(candidate) then
                targetPos = candidate
            end
        end

        -- 3) Aplicar teletransporte
        if targetPos then
            updateSpiritPosition(targetPos)
        end

        -- 4) Bat persiguiendo al espíritu
        if not cachedBat or not cachedBat.Parent or now > nextBatSearch then
            cachedBat = findBat()
            nextBatSearch = now + 0.5
        end
        if cachedBat and spiritPos then
            local bp = getBatPart(cachedBat)
            if bp then
                local targetCF = CFrame.new(spiritPos + Vector3.new(0, 2, 0))
                bp.CFrame = bp.CFrame:Lerp(targetCF, 0.4)
            end
        end
    end)
end

local function stopSpirit()
    if not spiritActive then return end
    spiritActive = false
    if spiritConn then spiritConn:Disconnect(); spiritConn = nil end
    if spiritPart then spiritPart:Destroy(); spiritPart = nil end
    setCharacterVisibility(true)
    reattachHandle()
    cachedBat = nil
    spiritPos = nil
end

-- ================== SPEED ==================
local function doSpeed()
    local now = tick()
    if now - lastSpeedTime < CONFIG.SpeedCooldown then return end
    lastSpeedTime = now

    local dist = CONFIG.SpeedSteps * CONFIG.StepDistance

    if spiritActive then
        -- Con espíritu activo: el personaje queda quieto, avanza el espíritu
        local forward = camera.CFrame.LookVector
        basePos = basePos + forward * dist
        updateSpiritPosition((spiritPos or basePos) + forward * dist)
    else
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * dist) * hrp.CFrame.Rotation
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Freefall) end
    end
end

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "SpiritControlGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function styleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- blanco
    btn.TextColor3       = Color3.fromRGB(0, 0, 0)        -- texto negro
end

local function createButton(text, offsetX)
    local btn = Instance.new("TextButton")
    btn.Name           = "Btn_" .. text
    btn.Size           = UDim2.fromOffset(CONFIG.ButtonSize, CONFIG.ButtonSize)
    btn.Position       = UDim2.new(0, offsetX, 0.5, -CONFIG.ButtonSize / 2)
    btn.BorderSizePixel= 0
    btn.Text           = text
    btn.Font           = Enum.Font.GothamBold
    btn.TextScaled     = true
    btn.AutoButtonColor= false
    btn.ZIndex         = 50
    styleButton(btn)
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0, 8)
    pad.PaddingRight  = UDim.new(0, 8)
    pad.PaddingTop    = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent        = btn

    return btn
end

local btnFalse = createButton("false", 40)
local btnSpeed = createButton("speed", 40 + CONFIG.ButtonSize + CONFIG.ButtonSeparation)

-- ================== TOGGLE / FLASH ==================
local function toggleSpirit()
    if spiritActive then
        stopSpirit()
        styleButton(btnFalse)
    else
        startSpirit()
        btnFalse.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btnFalse.TextColor3       = Color3.fromRGB(255, 255, 255)
    end
end

local function flashSpeed()
    btnSpeed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnSpeed.TextColor3       = Color3.fromRGB(255, 255, 255)
    task.delay(0.15, function()
        if btnSpeed and btnSpeed.Parent then styleButton(btnSpeed) end
    end)
end

-- ================== DRAG MULTITÁCTIL ==================
local function clampPos(frame, pos)
    local vp = camera.ViewportSize
    local sz = frame.AbsoluteSize
    local p  = CONFIG.DragPadding
    local x  = math.clamp(pos.X.Offset, -p, vp.X - sz.X + p)
    local y  = math.clamp(pos.Y.Offset, -p, vp.Y - sz.Y + p)
    return UDim2.new(0, x, 0, y)
end

local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrags[input] = {
                frame     = frame,
                dragStart = input.Position,
                startPos  = frame.Position,
                moved     = false,
            }
        end
    end)
end

makeDraggable(btnFalse)
makeDraggable(btnSpeed)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local drag = activeDrags[input]
        if drag then
            local delta = input.Position - drag.dragStart
            if delta.Magnitude > CONFIG.TapThreshold then drag.moved = true end
            drag.frame.Position = clampPos(drag.frame, UDim2.new(
                drag.startPos.X.Scale, drag.startPos.X.Offset + delta.X,
                drag.startPos.Y.Scale, drag.startPos.Y.Offset + delta.Y
            ))
        end
    elseif input.UserInputType == Enum.UserInputType.MouseMovement then
        for inp, drag in pairs(activeDrags) do
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                local delta = input.Position - drag.dragStart
                if delta.Magnitude > CONFIG.TapThreshold then drag.moved = true end
                drag.frame.Position = clampPos(drag.frame, UDim2.new(
                    drag.startPos.X.Scale, drag.startPos.X.Offset + delta.X,
                    drag.startPos.Y.Scale, drag.startPos.Y.Offset + delta.Y
                ))
                break
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local drag = activeDrags[input]
    if not drag then return end
    activeDrags[input] = nil
    if not drag.moved then
        if drag.frame == btnFalse then
            toggleSpirit()
        elseif drag.frame == btnSpeed then
            doSpeed()
            flashSpeed()
        end
    end
end)

-- ================== RESPAWN ==================
player.CharacterAdded:Connect(function()
    if spiritActive then
        stopSpirit()
        styleButton(btnFalse)
    end
end)