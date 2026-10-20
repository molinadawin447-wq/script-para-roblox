--[[
    LocalScript: SpiritControlGUI v7
    Ubicación: StarterPlayer > StarterPlayerScripts
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera    = workspace.CurrentCamera

-- ================== CONFIG ==================
local CONFIG = {
    ButtonSize        = 60,
    ButtonSeparation  = 15,
    DragPadding       = 40,
    TapThreshold      = 10,
    LockSize          = 18,

    -- ==== CLONES CON LAG (teletransporte rápido) ====
    CloneCount        = 3,
    TeleportInterval  = 0.04,   -- cada cuánto se teletransportan (0.04 ≈ 25 Hz)
    CloneRadius       = 12,     -- radio alrededor tuyo
    CloneHeightMin    = -2,     -- altura mínima respecto a ti
    CloneHeightMax    = 8,      -- altura máxima

    -- ==== ATAQUE ====
    AttackDetectRadius = 15,
    AttackCooldown     = 0.6,
    AttackDuration     = 0.35,

    -- ==== SPEED ====
    SpeedDistance = 8,
    SpeedCooldown = 0.15,

    BatAIName        = "BatAI",-- <-- cambia al nombre real de tu bot
    BrainrotToolName = nil,
}

-- ================== ESTADO ==================
local spiritActive    = false
local clones          = {}
local cloneNextJump   = {}    -- [i] = tick en que puede volver a saltar
local spiritConn      = nil
local homeCenter      = nil
local attackCenter    = nil
local attackUntil     = 0
local savedWelds      = {}
local savedWalkSpeed  = nil
local savedJumpPower  = nil
local savedPlayerCF   = nil
local lastSpeedTime   = -math.huge
local lastAttackTime  = -math.huge
local cachedBat       = nil
local nextBatSearch   = 0
local activeDrags     = {}

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
            local isToolPart = d:FindFirstAncestorOfClass("Tool") ~= nil
            if not isToolPart then
                d.LocalTransparencyModifier = visible and 0 or 1
            end
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

local function findNearestAttacker()
    if not homeCenter then return nil end
    local nearest, nearestDist = nil, CONFIG.AttackDetectRadius
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local oc = other.Character
            if oc then
                local ohrp = oc:FindFirstChild("HumanoidRootPart")
                local ohum = oc:FindFirstChildOfClass("Humanoid")
                if ohrp and ohum and ohum.Health > 0 then
                    local d = (ohrp.Position - homeCenter).Magnitude
                    if d <= nearestDist then
                        nearest, nearestDist = oc, d
                    end
                end
            end
        end
    end
    return nearest
end

-- ================== CLONES ==================
local function createSpiritClone()
    local char = player.Character
    if not char then return nil end
    local clone = char:Clone()
    clone.Name = "LocalSpiritClone"

    local root = clone:FindFirstChild("HumanoidRootPart")
    if root then clone.PrimaryPart = root end

    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
            d.LocalTransparencyModifier = 0
        elseif d:IsA("Script") or d:IsA("LocalScript")
            or d:IsA("Tool") or d:IsA("ModuleScript") then
            d:Destroy()
        elseif d:IsA("Humanoid") then
            d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            d.HealthDisplayType   = Enum.HumanoidHealthDisplayType.AlwaysOff
            d.WalkSpeed = 0
            d.JumpPower = 0
            d.AutoRotate = false
        end
    end

    clone.Parent = workspace
    return clone
end

-- Posición aleatoria alrededor del centro (círculo + altura variable)
local function randomOrbitPos(center)
    local theta = math.random() * math.pi * 2
    local r     = math.sqrt(math.random()) * CONFIG.CloneRadius  -- distribución uniforme
    local h     = CONFIG.CloneHeightMin + math.random() * (CONFIG.CloneHeightMax - CONFIG.CloneHeightMin)
    return center + Vector3.new(math.cos(theta) * r, h, math.sin(theta) * r)
end

local function updateClones()
    local now = tick()
    local center = (now < attackUntil and attackCenter) or homeCenter
    if not center then return end

    for i, c in ipairs(clones) do
        if c and c.Parent then
            local nextJump = cloneNextJump[i] or 0
            if now >= nextJump then
                -- Teletransporte instantáneo (efecto lag)
                local pos = randomOrbitPos(center)
                c:PivotTo(CFrame.new(pos))
                -- Cada clon tiene su propio tiempo (aleatorio) → efecto desync
                local jitter = CONFIG.TeleportInterval * (0.6 + math.random() * 0.9)
                cloneNextJump[i] = now + jitter
            end
        end
    end

    -- Brainrot en la mano viaja con el clon principal (teleport instantáneo)
    local char = player.Character
    if char and clones[1] and clones[1].Parent then
        local tool = findBrainrotTool(char)
        if tool then
            local h = tool:FindFirstChild("Handle")
            if h and h:IsA("BasePart") then
                for _, j in ipairs(h:GetJoints()) do
                    if j:IsA("JointInstance") and j.Enabled then
                        savedWelds[j] = true
                        j.Enabled = false
                    end
                end
                local c1root = clones[1]:FindFirstChild("HumanoidRootPart") or clones[1].PrimaryPart
                if c1root then
                    h.CFrame = c1root.CFrame + Vector3.new(0, 1.5, 0)
                    h.LocalTransparencyModifier = 0
                end
            end
        end
    end
end

-- ================== INICIO / FIN ==================
local function startSpirit()
    if spiritActive then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    spiritActive  = true
    homeCenter    = hrp.Position
    savedPlayerCF = hrp.CFrame
    cloneNextJump = {}

    -- 1) Clones visibles (aún en spawn, se teletransportan al primer frame)
    clones = {}
    for i = 1, CONFIG.CloneCount do
        local c = createSpiritClone()
        if c then
            clones[#clones + 1] = c
            cloneNextJump[#clones] = 0
        end
    end

    -- 2) Congelar humanoide
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        savedWalkSpeed = hum.WalkSpeed
        savedJumpPower = hum.JumpPower
        hum.WalkSpeed  = 0
        hum.JumpPower  = 0
    end

    -- 3) Invisible
    setCharacterVisibility(false)

    -- 4) Reducir interacción de tu hitbox (local)
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then
            d.CanQuery = false
            d.CanTouch = false
        end
    end

    -- 5) Desoldar brainrot
    local tool   = findBrainrotTool(char)
    local handle = tool and tool:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then
        detachHandle(handle)
        handle.LocalTransparencyModifier = 0
    end

    cachedBat     = findBat()
    nextBatSearch = tick() + 0.5

    spiritConn = RunService.Heartbeat:Connect(function()
        if not spiritActive then return end
        local now = tick()

        -- A) Detectar atacante
        if now - lastAttackTime >= CONFIG.AttackCooldown then
            local attacker = findNearestAttacker()
            if attacker then
                local ahrp = attacker:FindFirstChild("HumanoidRootPart")
                if ahrp then
                    attackCenter = ahrp.Position + Vector3.new(0, 2, 0)
                    attackUntil  = now + CONFIG.AttackDuration
                    lastAttackTime = now
                end
            end
        end

        -- B) Clones con lag (teletransporte rápido)
        updateClones()

        -- C) Bat siguiendo al clon #1
        if not cachedBat or not cachedBat.Parent or now > nextBatSearch then
            cachedBat = findBat()
            nextBatSearch = now + 0.5
        end
        if cachedBat and clones[1] and clones[1].Parent then
            local bp = getBatPart(cachedBat)
            local c1root = clones[1]:FindFirstChild("HumanoidRootPart") or clones[1].PrimaryPart
            if bp and c1root then
                bp.CFrame = bp.CFrame:Lerp(c1root.CFrame + Vector3.new(0, 2, 0), 0.4)
            end
        end
    end)
end

local function stopSpirit()
    if not spiritActive then return end
    spiritActive = false
    if spiritConn then spiritConn:Disconnect(); spiritConn = nil end
    for _, c in ipairs(clones) do
        if c then c:Destroy() end
    end
    clones        = {}
    cloneNextJump = {}
    setCharacterVisibility(true)

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = savedWalkSpeed or 16
            hum.JumpPower = savedJumpPower or 50
        end
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                d.CanQuery = true
                d.CanTouch = true
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and homeCenter then
            hrp.CFrame = CFrame.new(homeCenter) * (savedPlayerCF and savedPlayerCF.Rotation or hrp.CFrame.Rotation)
        end
    end
    savedWalkSpeed = nil
    savedJumpPower = nil
    savedPlayerCF  = nil

    reattachHandle()
    cachedBat = nil
    homeCenter = nil
    attackCenter = nil
end

-- ================== SPEED (8 studs) ==================
local function doSpeed()
    local now = tick()
    if now - lastSpeedTime < CONFIG.SpeedCooldown then return end
    lastSpeedTime = now

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local forward = camera.CFrame.LookVector
    local newPos  = hrp.Position + forward * CONFIG.SpeedDistance

    if spiritActive then
        hrp.CFrame = CFrame.new(newPos) * hrp.CFrame.Rotation
        homeCenter = newPos
    else
        hrp.CFrame = CFrame.new(newPos) * hrp.CFrame.Rotation
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Freefall) end
    end
end

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name             = "SpiritControlGUI"
gui.ResetOnSpawn     = false
gui.IgnoreGuiInset   = true
gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
gui.Parent           = playerGui

local function styleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3       = Color3.fromRGB(0, 0, 0)
end

local function createButton(text, offsetX)
    local btn = Instance.new("TextButton")
    btn.Name            = "Btn_" .. text
    btn.Size            = UDim2.fromOffset(CONFIG.ButtonSize, CONFIG.ButtonSize)
    btn.Position        = UDim2.new(0, offsetX, 0.5, -CONFIG.ButtonSize / 2)
    btn.BorderSizePixel = 0
    btn.Text            = text
    btn.Font            = Enum.Font.GothamBold
    btn.TextScaled      = true
    btn.AutoButtonColor = false
    btn.ZIndex          = 50
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
    pad.Parent = btn

    local lBtn = Instance.new("TextButton")
    lBtn.Name            = "LockL"
    lBtn.Size            = UDim2.fromOffset(CONFIG.LockSize, CONFIG.LockSize)
    lBtn.AnchorPoint     = Vector2.new(1, 0)
    lBtn.Position        = UDim2.new(1, -2, 0, -2)
    lBtn.BackgroundColor3= Color3.fromRGB(220, 220, 220)
    lBtn.BorderSizePixel = 0
    lBtn.Text            = "L"
    lBtn.TextColor3      = Color3.fromRGB(0, 0, 0)
    lBtn.Font            = Enum.Font.GothamBold
    lBtn.TextScaled      = true
    lBtn.AutoButtonColor = false
    lBtn.ZIndex          = 60
    lBtn.Parent          = btn

    local lCorner = Instance.new("UICorner")
    lCorner.CornerRadius = UDim.new(0, 5)
    lCorner.Parent = lBtn

    btn:SetAttribute("Locked", false)

    lBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local locked = not (btn:GetAttribute("Locked") or false)
            btn:SetAttribute("Locked", locked)
            lBtn.BackgroundColor3 = locked and Color3.fromRGB(255, 90, 90) or Color3.fromRGB(220, 220, 220)
        end
    end)

    return btn
end

local btnFalse = createButton("false", 30)
local btnSpeed = createButton("speed", 30 + CONFIG.ButtonSize + CONFIG.ButtonSeparation)

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

-- ================== DRAG + LOCK ==================
local function clampPos(frame, pos)
    local vp = camera.ViewportSize
    local sz = frame.AbsoluteSize
    local p  = CONFIG.DragPadding
    local x  = math.clamp(pos.X.Offset, -p, vp.X - sz.X + p)
    local y  = math.clamp(pos.Y.Offset, -p, vp.Y - sz.Y + p)
    return UDim2.new(0, x, 0, y)
end

local function isOverGui(guiObj, point)
    local abs = guiObj.AbsolutePosition
    local sz  = guiObj.AbsoluteSize
    return point.X >= abs.X and point.X <= abs.X + sz.X
       and point.Y >= abs.Y and point.Y <= abs.Y + sz.Y
end

local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local lBtn = frame:FindFirstChild("LockL")
        if lBtn and isOverGui(lBtn, input.Position) then return end
        if frame:GetAttribute("Locked") then return end

        activeDrags[input] = {
            frame     = frame,
            dragStart = input.Position,
            startPos  = frame.Position,
            moved     = false,
        }
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

player.CharacterAdded:Connect(function()
    if spiritActive then
        stopSpirit()
        styleButton(btnFalse)
    end
end)