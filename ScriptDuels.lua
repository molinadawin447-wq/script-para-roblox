local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UIS = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    Lighting = game:GetService("Lighting"),
    NetworkClient = game:GetService("NetworkClient"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
}

local Players = Services.Players
local RunService = Services.RunService
local UIS = Services.UIS
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local Lighting = Services.Lighting
local NetworkClient = Services.NetworkClient
local ReplicatedStorage = Services.ReplicatedStorage
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local OriginalLighting = {
    Technology = Lighting.Technology,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}

local function makeDraggable(guiObject)
    local dragging = false
    local dragStartPos = nil
    local startGuiPos = nil
    local dragInput = nil
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
            startGuiPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end
    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end
    guiObject.InputBegan:Connect(onInputBegan)
    guiObject.InputChanged:Connect(onInputChanged)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStartPos
            guiObject.Position = UDim2.new(
                startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X,
                startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y
            )
        end
    end)
end

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Datas = ReplicatedStorage:WaitForChild("Datas")
local Synchronizer = require(Packages:WaitForChild("Synchronizer"))
local AnimalsData = require(Datas:WaitForChild("Animals"))

local State = {
    normalSpeed = 59, carrySpeed = 29,
    laggerModeEnabled = false, laggerNormalSpeed = 30, laggerCarrySpeed = 15,
    speedToggled = false,
    infJumpEnabled = false, antiRagdollEnabled = false,
    medusaCounterEnabled = false,
    skyMode = 0,
    guiVisible = true, isStealing = false, stealStartTime = nil,
    lastStealTick = 0, medusaLastUsed = 0, medusaDebounce = false,
    dropBrainrotActive = false, tpInProgress = false, tpUpDebounce = false,
    lastMoveDir = Vector3.new(0,0,0),
    tryhardAnimEnabled = false,
    bypassGuiVisible = true,
    instaResetKey = "B",
    backgroundEnabled = false,
    backgroundIndex = 0,
    zombieModeEnabled = false,
    doubleJumpTpEnabled = false,
    categoriesOnBottom = true,
    autoBatEnabled = false,
    autoSwingEnabled = true,
    stretchRezEnabled = false,
    removeAccessoriesEnabled = false,
    darkModeEnabled = false,
    antiLagEnabled = false,
}

-- Space HUB - Auto Bat = H (modifiable)
local Keys = {
    autoBat      = Enum.KeyCode.H,
    speed        = Enum.KeyCode.Q,
    guiHide      = Enum.KeyCode.RightControl,
    dropBrainrot = Enum.KeyCode.J,
    tpDown       = Enum.KeyCode.T,
    laggerToggle = Enum.KeyCode.K,
    instaReset   = Enum.KeyCode.B,
    doubleJumpTp = Enum.KeyCode.G,
}

local CONFIG = {
    AUTO_STEAL_ENABLED = false,
    HOLD_MIN = 1.3, HOLD_MAX = 3, ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05, STEAL_RANGE = 100, PRIME_RANGE = 80,
    StealRadius = 60,
    StealDuration = 1.4,
}

local StealState = {
    active = false, startTime = 0, phase = "idle",
    label = "", lastResult = "", lastResultTime = 0,
    totalSteals = 0, failedSteals = 0,
}

local Cache = { allAnimals = {}, PromptMemory = {}, InternalSteal = {} }
local stealConnection = nil

local BarRefs = { gui = nil, fill = nil, label = nil, percent = nil, radius = nil }
local GuiToggleSetters = {}
local CONFIG_FILE = "CyberConfig.json"
local autoSaveScheduled = false

-- ============================================================
-- VARIABLES AUTO GRAB ACE
-- ============================================================
local progressRadLbl = nil
local progressFill = nil
local progressPct = nil
local autoStealBarGui = nil

-- ============================================================
-- FONCTIONS AUTO GRAB ACE
-- ============================================================

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function getMyPlotName()
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign"); if not sign then continue end
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return plot.Name end
    end
    return nil
end

function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local myPlot = getMyPlotName(); if not myPlot then return false end
    return animalData.plot == myPlot
end

function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = Cache.PromptMemory[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = workspace.Plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    local base = podium:FindFirstChild("Base"); if not base then return nil end
    local spawn = base:FindFirstChild("Spawn"); if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment"); if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then Cache.PromptMemory[animalData.uid]=p; return p end
    end
    return nil
end

function getAnimalPosition(animalData)
    local plot = workspace.Plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    return podium:GetPivot().Position
end

function distToAnimal(animalData)
    local character = LP.Character; if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData); if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

function pickClosest()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(Cache.allAnimals) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > CONFIG.PRIME_RANGE then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end

function buildStealCallbacks(prompt)
    if Cache.InternalSteal[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        Cache.InternalSteal[prompt] = data
    end
end

function executeStealAsync(prompt, animalData)
    local data = Cache.InternalSteal[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = animalData.name or "Animal"
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(fn)
        end
        task.wait(CONFIG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
                if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do
                    task.spawn(fn)
                end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. (animalData.name or "")
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: " .. (animalData.name or "")
        end
        StealState.active = false
        StealState.phase = "idle"
        StealState.lastResultTime = tick()
        task.wait(CONFIG.COOLDOWN)
        data.ready = true
    end)
    return true
end

function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    if prompt.ObjectText == nil or prompt.ObjectText == "" then return false end
    buildStealCallbacks(prompt)
    if not Cache.InternalSteal[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end

function scanAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return 0 end
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, podium in ipairs(podiums:GetChildren()) do
            local base = podium:FindFirstChild("Base")
            if not base then continue end
            local spawn = base:FindFirstChild("Spawn")
            if not spawn then continue end
            local attach = spawn:FindFirstChild("PromptAttachment")
            if not attach then continue end
            local hasPrompt = false
            for _, p in ipairs(attach:GetChildren()) do
                if p:IsA("ProximityPrompt") then hasPrompt = true; break end
            end
            if not hasPrompt then continue end
            local animalName = nil
            for _, child in ipairs(podium:GetChildren()) do
                if child:IsA("Model") and AnimalsData[child.Name] then
                    animalName = child.Name
                    break
                end
            end
            local slot = podium.Name
            table.insert(newCache, {
                name = animalName and (AnimalsData[animalName].DisplayName or animalName) or slot,
                plot = plot.Name,
                slot = slot,
                uid = plot.Name .. "_" .. slot,
            })
        end
    end
    Cache.allAnimals = newCache
    return #Cache.allAnimals
end

-- ============================================================
-- BARRE DE PROGRESSION ACE
-- ============================================================

local function createAutoStealBar()
    local sg = Instance.new("ScreenGui")
    sg.Name = "AutoStealBar"
    sg.ResetOnSpawn = false
    sg.Parent = PlayerGui
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    autoStealBarGui = sg

    local container = Instance.new("Frame", sg)
    container.Size = UDim2.new(0, 380, 0, 38)
    container.Position = UDim2.new(0.5, -190, 1, -58)
    container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    container.BorderSizePixel = 0
    container.Active = true
    makeDraggable(container)
    Instance.new("UICorner", container).CornerRadius = UDim.new(1, 0)

    local pbSt = Instance.new("UIStroke", container)
    pbSt.Color = Color3.fromRGB(255, 255, 255)
    pbSt.Thickness = 1.2
    pbSt.Transparency = 0.2

    local fillRegion = Instance.new("Frame", container)
    fillRegion.Size = UDim2.new(0, 220, 1, -8)
    fillRegion.Position = UDim2.new(0, 5, 0, 4)
    fillRegion.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)

    local fillRegGradient = Instance.new("UIGradient", fillRegion)
    fillRegGradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(14, 14, 14))
    fillRegGradient.Rotation = 90

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 60, 1, 0)
    stealLbl.Position = UDim2.new(0, 12, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealLbl.Font = Enum.Font.GothamBlack
    stealLbl.TextSize = 11
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left

    progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 60, 1, 0)
    progressPct.Position = UDim2.new(1, -68, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "—"
    progressPct.TextColor3 = Color3.fromRGB(230, 230, 230)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 10
    progressPct.TextXAlignment = Enum.TextXAlignment.Right

    local pbDiv = Instance.new("Frame", container)
    pbDiv.Size = UDim2.new(0, 1, 0, 14)
    pbDiv.Position = UDim2.new(0, 232, 0.5, -7)
    pbDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pbDiv.BackgroundTransparency = 0.7
    pbDiv.BorderSizePixel = 0

    progressRadLbl = Instance.new("TextLabel", container)
    progressRadLbl.Size = UDim2.new(0, 140, 1, 0)
    progressRadLbl.Position = UDim2.new(0, 236, 0, 0)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "Radius: " .. CONFIG.PRIME_RANGE
    progressRadLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 10
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    
    BarRefs.gui = sg
end

local function removeAutoStealBar()
    if autoStealBarGui then
        autoStealBarGui:Destroy()
        autoStealBarGui = nil
    end
    if BarRefs.gui then
        BarRefs.gui:Destroy()
        BarRefs.gui = nil
    end
    progressFill = nil
    progressPct = nil
    progressRadLbl = nil
end

-- ============================================================
-- MISE A JOUR DE LA BARRE DE PROGRESSION
-- ============================================================

do
    local lastFillPct = 0
    RunService.RenderStepped:Connect(function(dt)
        if not progressFill then return end
        if progressRadLbl then
            progressRadLbl.Text = "Radius: " .. CONFIG.PRIME_RANGE
        end
        local active = StealState.active
        local justFinished = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.2
        if active then
            local elapsed = tick() - StealState.startTime
            local targetPct = elapsed < CONFIG.HOLD_MIN and elapsed / CONFIG.HOLD_MIN or 1
            lastFillPct = lastFillPct + (targetPct - lastFillPct) * math.min(dt * 14, 1)
            progressFill.Size = UDim2.new(lastFillPct, 0, 1, 0)
            if progressPct then
                progressPct.Text = math.floor(lastFillPct * 100) .. "%"
            end
        elseif justFinished then
            lastFillPct = 1
            progressFill.Size = UDim2.new(1, 0, 1, 0)
            local success = StealState.lastResult:find("Stole")
            if progressPct then
                progressPct.Text = success and "OK!" or "MISS"
            end
        else
            if lastFillPct ~= 0 then
                lastFillPct = 0
                progressFill.Size = UDim2.new(0, 0, 1, 0)
                if progressPct then
                    progressPct.Text = "—"
                end
            end
        end
    end)
end

-- ============================================================
-- FONCTIONS DE CONTROLE AUTO GRAB ACE
-- ============================================================

local function startAutoSteal()
    if stealConnection then return end
    createAutoStealBar()
    scanAllPlots()
    stealConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        local target = pickClosest()
        if not target then return end
        local prompt = Cache.PromptMemory[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findProximityPromptForAnimal(target)
        end
        if prompt then
            attemptSteal(prompt, target)
        end
    end)
    task.spawn(function()
        while stealConnection do
            task.wait(5)
            if CONFIG.AUTO_STEAL_ENABLED then
                scanAllPlots()
            end
        end
    end)
end

local function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    removeAutoStealBar()
    Cache.allAnimals = {}
    Cache.PromptMemory = {}
    Cache.InternalSteal = {}
end

-- ============================================================
-- SUITE DU SCRIPT
-- ============================================================

local function scheduleAutoSave()
    if autoSaveScheduled then return end
    autoSaveScheduled = true
    task.delay(0.3, function()
        autoSaveScheduled = false
        local cfg = {
            normalSpeed=State.normalSpeed, carrySpeed=State.carrySpeed,
            laggerNormalSpeed=State.laggerNormalSpeed, laggerCarrySpeed=State.laggerCarrySpeed,
            laggerModeEnabled=State.laggerModeEnabled, autoGrabEnabled=CONFIG.AUTO_STEAL_ENABLED,
            infJump=State.infJumpEnabled, antiRagdoll=State.antiRagdollEnabled,
            medusaCounter=State.medusaCounterEnabled,
            skyMode=State.skyMode,
            bypassGuiVisible=State.bypassGuiVisible,
            primeRange=CONFIG.PRIME_RANGE,
            grabRadius=CONFIG.PRIME_RANGE,
            stealDuration=CONFIG.StealDuration,
            speedKey=Keys.speed.Name,
            guiHideKey=Keys.guiHide.Name, dropBrainrotKey=Keys.dropBrainrot.Name,
            tpDownKey=Keys.tpDown.Name, laggerToggleKey=Keys.laggerToggle.Name,
            instaResetKey=Keys.instaReset and Keys.instaReset.Name or State.instaResetKey,
            backgroundEnabled=State.backgroundEnabled,
            backgroundIndex=State.backgroundIndex,
            zombieModeEnabled=State.zombieModeEnabled,
            tryhardAnimEnabled=State.tryhardAnimEnabled,
            doubleJumpTpEnabled=State.doubleJumpTpEnabled,
            doubleJumpTpKey=Keys.doubleJumpTp.Name,
            autoBatKey=Keys.autoBat.Name,
            autoBatEnabled=State.autoBatEnabled,
            autoSwingEnabled=State.autoSwingEnabled,
            stretchRezEnabled=State.stretchRezEnabled,
            removeAccessoriesEnabled=State.removeAccessoriesEnabled,
            darkModeEnabled=State.darkModeEnabled,
            antiLagEnabled=State.antiLagEnabled,
        }
        pcall(function()
            if writefile then
                writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
            end
        end)
    end)
end

-- ============================================================
-- CHARGEMENT DE LA CONFIGURATION AU DÉMARRAGE
-- ============================================================
local function loadConfig()
    local hasFile = false
    pcall(function() hasFile = isfile and isfile(CONFIG_FILE) end)
    if hasFile then
        local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and cfg then
            if type(cfg.normalSpeed)=="number" then State.normalSpeed=cfg.normalSpeed end
            if type(cfg.carrySpeed)=="number" then State.carrySpeed=cfg.carrySpeed end
            if type(cfg.laggerNormalSpeed)=="number" then State.laggerNormalSpeed=cfg.laggerNormalSpeed end
            if type(cfg.laggerCarrySpeed)=="number" then State.laggerCarrySpeed=cfg.laggerCarrySpeed end
            if type(cfg.laggerModeEnabled)=="boolean" then State.laggerModeEnabled=cfg.laggerModeEnabled end
            if type(cfg.infJump)=="boolean" then State.infJumpEnabled=cfg.infJump end
            if type(cfg.antiRagdoll)=="boolean" then State.antiRagdollEnabled=cfg.antiRagdoll end
            if type(cfg.medusaCounter)=="boolean" then State.medusaCounterEnabled=cfg.medusaCounter end
            if type(cfg.skyMode)=="number" then State.skyMode=cfg.skyMode end
            if type(cfg.bypassGuiVisible)=="boolean" then State.bypassGuiVisible=cfg.bypassGuiVisible end
            if type(cfg.primeRange)=="number" then CONFIG.PRIME_RANGE=math.clamp(cfg.primeRange,5,300) end
            if type(cfg.grabRadius)=="number" then CONFIG.PRIME_RANGE=math.clamp(cfg.grabRadius,5,300) end
            if type(cfg.stealDuration)=="number" then CONFIG.StealDuration=math.clamp(cfg.stealDuration,0.05,10) end
            if type(cfg.autoGrabEnabled)=="boolean" then CONFIG.AUTO_STEAL_ENABLED=cfg.autoGrabEnabled end
            if type(cfg.speedKey)=="string" and Enum.KeyCode[cfg.speedKey] then Keys.speed=Enum.KeyCode[cfg.speedKey] end
            if type(cfg.guiHideKey)=="string" and Enum.KeyCode[cfg.guiHideKey] then Keys.guiHide=Enum.KeyCode[cfg.guiHideKey] end
            if type(cfg.dropBrainrotKey)=="string" and Enum.KeyCode[cfg.dropBrainrotKey] then Keys.dropBrainrot=Enum.KeyCode[cfg.dropBrainrotKey] end
            if type(cfg.tpDownKey)=="string" and Enum.KeyCode[cfg.tpDownKey] then Keys.tpDown=Enum.KeyCode[cfg.tpDownKey] end
            if type(cfg.laggerToggleKey)=="string" and Enum.KeyCode[cfg.laggerToggleKey] then Keys.laggerToggle=Enum.KeyCode[cfg.laggerToggleKey] end
            if type(cfg.instaResetKey)=="string" then State.instaResetKey=cfg.instaResetKey; Keys.instaReset=Enum.KeyCode[cfg.instaResetKey] or Enum.KeyCode.B end
            if type(cfg.backgroundEnabled)=="boolean" then State.backgroundEnabled=cfg.backgroundEnabled end
            if type(cfg.backgroundIndex)=="number" then State.backgroundIndex=cfg.backgroundIndex end
            if type(cfg.zombieModeEnabled)=="boolean" then State.zombieModeEnabled=cfg.zombieModeEnabled end
            if type(cfg.tryhardAnimEnabled)=="boolean" then State.tryhardAnimEnabled=cfg.tryhardAnimEnabled end
            if type(cfg.doubleJumpTpEnabled)=="boolean" then State.doubleJumpTpEnabled=cfg.doubleJumpTpEnabled end
            if type(cfg.doubleJumpTpKey)=="string" and Enum.KeyCode[cfg.doubleJumpTpKey] then Keys.doubleJumpTp=Enum.KeyCode[cfg.doubleJumpTpKey] end
            if type(cfg.autoBatKey)=="string" and Enum.KeyCode[cfg.autoBatKey] then 
                Keys.autoBat=Enum.KeyCode[cfg.autoBatKey] 
            end
            if type(cfg.autoBatEnabled)=="boolean" then State.autoBatEnabled=cfg.autoBatEnabled end
            if type(cfg.autoSwingEnabled)=="boolean" then State.autoSwingEnabled=cfg.autoSwingEnabled end
            if type(cfg.stretchRezEnabled)=="boolean" then State.stretchRezEnabled=cfg.stretchRezEnabled end
            if type(cfg.removeAccessoriesEnabled)=="boolean" then State.removeAccessoriesEnabled=cfg.removeAccessoriesEnabled end
            if type(cfg.darkModeEnabled)=="boolean" then State.darkModeEnabled=cfg.darkModeEnabled end
            if type(cfg.antiLagEnabled)=="boolean" then State.antiLagEnabled=cfg.antiLagEnabled end
            return true
        end
    end
    return false
end

loadConfig()

local function getCurrentSpeed()
    if State.speedToggled then
        return State.laggerModeEnabled and State.laggerCarrySpeed or State.carrySpeed
    else
        return State.laggerModeEnabled and State.laggerNormalSpeed or State.normalSpeed
    end
end

-- ============================================================
-- IMAGES : NONE ET TRANSPARENT
-- ============================================================
local BG_IMAGES = {
    [5] = "998877665544332",
}

local function tpDown()
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local params=RaycastParams.new(); params.FilterDescendantsInstances={char}; params.FilterType=Enum.RaycastFilterType.Blacklist
    local result=workspace:Raycast(root.Position,Vector3.new(0,-500,0),params)
    local targetY=result and (result.Position.Y+2.5) or (root.Position.Y-175)
    root.CFrame=CFrame.new(root.Position.X,targetY,root.Position.Z)
end

local doubleJumpTpConnection = nil
local tpUpDebounce = false

local function tpUp()
    if tpUpDebounce then return end
    tpUpDebounce = true
    local char = LP.Character
    if not char then tpUpDebounce = false; return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then tpUpDebounce = false; return end
    local newPosition = root.Position + Vector3.new(0, 8.7, 0)
    root.CFrame = CFrame.new(newPosition)
    task.delay(0.37, function() tpUpDebounce = false end)
end

local function startDoubleJumpTpLoop()
    if doubleJumpTpConnection then return end
    State.doubleJumpTpEnabled = true
    doubleJumpTpConnection = task.spawn(function()
        while State.doubleJumpTpEnabled do
            local char = LP.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(root.Velocity.X, 52, root.Velocity.Z)
                    task.wait(0.08)
                    root.Velocity = Vector3.new(root.Velocity.X, 52, root.Velocity.Z)
                end
            end
            task.wait(0.1)
            tpUp()
            task.wait(0.18)
            tpDown()
            task.wait(0.15)
        end
        doubleJumpTpConnection = nil
    end)
end

local function stopDoubleJumpTpLoop()
    State.doubleJumpTpEnabled = false
    if doubleJumpTpConnection then doubleJumpTpConnection = nil end
end

local function toggleDoubleJumpTp()
    if State.doubleJumpTpEnabled then
        stopDoubleJumpTpLoop(); State.doubleJumpTpEnabled = false
    else
        State.doubleJumpTpEnabled = true; startDoubleJumpTpLoop()
    end
    scheduleAutoSave()
    return State.doubleJumpTpEnabled
end

local infJumpEnabled = false
local isJumping = false
local infJumpConn = nil
local setInfJumpInternal

local function doJumpBoost()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local vel = root.Velocity
    if vel.Y < 55 then root.Velocity = Vector3.new(vel.X, 55, vel.Z) end
    if vel.Y < -80 then root.Velocity = Vector3.new(vel.X, 55, vel.Z) end
end

local function startInfJumpLoop()
    if infJumpConn then infJumpConn:Disconnect() end
    infJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        if isJumping then doJumpBoost() end
    end)
end

local function stopInfJumpLoop()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    isJumping = false
end

function setInfJumpInternal(on)
    infJumpEnabled = on; State.infJumpEnabled = on
    if on then startInfJumpLoop() else stopInfJumpLoop() end
    scheduleAutoSave()
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        isJumping = true
        if infJumpEnabled then doJumpBoost() end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then isJumping = false end
end)

UIS.TouchStarted:Connect(function(touch, gp)
    if gp then return end
    local screenSize = workspace.CurrentCamera.ViewportSize
    local touchPos = touch.Position
    if touchPos.X > screenSize.X * 0.6 and touchPos.Y > screenSize.Y * 0.7 then
        isJumping = true
        if infJumpEnabled then doJumpBoost() end
    end
end)

UIS.TouchEnded:Connect(function(touch, gp)
    if gp then return end
    local screenSize = workspace.CurrentCamera.ViewportSize
    local touchPos = touch.Position
    if touchPos.X > screenSize.X * 0.6 and touchPos.Y > screenSize.Y * 0.7 then isJumping = false end
end)

RunService.Heartbeat:Connect(function()
    if not infJumpEnabled then return end
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Jump then isJumping = true; doJumpBoost()
    elseif hum and not hum.Jump then isJumping = false end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if infJumpEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 0 end
        stopInfJumpLoop(); task.wait(0.2); startInfJumpLoop()
    end
end)

local MEDUSA_COOLDOWN=25
local Conns={antiRag=nil,anchor={}}
local setupMedusaCounter,stopMedusaCounter
do
    local function findMedusa()
        local char=LP.Character; if not char then return nil end
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then local n=tool.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return tool end end
        end
        local bp=LP:FindFirstChild("Backpack")
        if bp then for _,tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then local n=tool.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return tool end end
        end end
        return nil
    end
    local function useMedusaCounter()
        if State.medusaDebounce then return end
        if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
        local char=LP.Character; if not char then return end
        State.medusaDebounce=true
        local med=findMedusa()
        if med then
            if med.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:EquipTool(med) end end
            pcall(function() med:Activate() end); State.medusaLastUsed=tick()
        end
        State.medusaDebounce=false
    end
    local function onAnchorChanged(part)
        return part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if part.Anchored and part.Transparency==1 then useMedusaCounter() end
        end)
    end
    function stopMedusaCounter()
        for _,c in ipairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={}
    end
    function setupMedusaCounter(char)
        stopMedusaCounter(); if not char then return end
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
        end
        table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
        end))
    end
end

local DROP_ASCEND_DURATION=0.2; local DROP_ASCEND_SPEED=150
local function runDropBrainrot()
    if State.dropBrainrotActive then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    State.dropBrainrotActive=true
    local t0=tick(); local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect(); State.dropBrainrotActive=false; return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new(); rp.FilterDescendantsInstances={char}; rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then
                local hum=char:FindFirstChildOfClass("Humanoid")
                local off=(hum and hum.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                r.AssemblyLinearVelocity=Vector3.new(0,0,0)
            end
            State.dropBrainrotActive=false; return
        end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
    end)
end

local ZombieAnims = {
    WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320,
    SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576,
}
local ZombieRefs = { heartbeat=nil, originalAnims=nil }

local function saveOriginalAnimsZombie(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    ZombieRefs.originalAnims={
        walk=g(animate.walk and animate.walk.WalkAnim), run=g(animate.run and animate.run.RunAnim),
        jump=g(animate.jump and animate.jump.JumpAnim), fall=g(animate.fall and animate.fall.FallAnim),
        swimidle=g(animate.swimidle and animate.swimidle.SwimIdle), swim=g(animate.swim and animate.swim.Swim),
        idle1=g(animate.idle and animate.idle.Animation1), idle2=g(animate.idle and animate.idle.Animation2),
        climb=g(animate.climb and animate.climb.ClimbAnim),
    }
end

local function applyZombieAnims(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj then obj.AnimationId="rbxassetid://"..id end end
    s(animate.walk and animate.walk.WalkAnim,ZombieAnims.WalkAnim); s(animate.run and animate.run.RunAnim,ZombieAnims.RunAnim)
    s(animate.jump and animate.jump.JumpAnim,ZombieAnims.JumpAnim); s(animate.fall and animate.fall.FallAnim,ZombieAnims.FallAnim)
    s(animate.swimidle and animate.swimidle.SwimIdle,ZombieAnims.SwimIdle); s(animate.swim and animate.swim.Swim,ZombieAnims.Swim)
    s(animate.idle and animate.idle.Animation1,ZombieAnims.Animation1); s(animate.idle and animate.idle.Animation2,ZombieAnims.Animation2)
    s(animate.climb and animate.climb.ClimbAnim,ZombieAnims.ClimbAnim)
end

local function restoreOriginalAnimsZombie(char)
    local orig=ZombieRefs.originalAnims; if not orig then return end
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj and id then obj.AnimationId=id end end
    s(animate.walk and animate.walk.WalkAnim,orig.walk); s(animate.run and animate.run.RunAnim,orig.run)
    s(animate.jump and animate.jump.JumpAnim,orig.jump); s(animate.fall and animate.fall.FallAnim,orig.fall)
    s(animate.swimidle and animate.swimidle.SwimIdle,orig.swimidle); s(animate.swim and animate.swim.Swim,orig.swim)
    s(animate.idle and animate.idle.Animation1,orig.idle1); s(animate.idle and animate.idle.Animation2,orig.idle2)
    s(animate.climb and animate.climb.ClimbAnim,orig.climb)
end

local function startZombieMode()
    if ZombieRefs.heartbeat then return end
    local char=LP.Character
    if char then saveOriginalAnimsZombie(char); applyZombieAnims(char) end
    ZombieRefs.heartbeat=RunService.Heartbeat:Connect(function()
        if not State.zombieModeEnabled then return end
        local c=LP.Character; if c then applyZombieAnims(c) end
    end)
end

local function stopZombieMode()
    if ZombieRefs.heartbeat then ZombieRefs.heartbeat:Disconnect(); ZombieRefs.heartbeat=nil end
    local char=LP.Character; if char then restoreOriginalAnimsZombie(char) end
end

local function setZombieMode(on)
    State.zombieModeEnabled=on
    if on then startZombieMode() else stopZombieMode() end
    scheduleAutoSave()
end

local TryhardAnims = {
    idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
    walk="rbxassetid://707897309", run="rbxassetid://707861613",
    jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985",
    climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985", swimidle="rbxassetid://116936326516985",
}
local TryhardRefs = { heartbeat=nil, originalAnims=nil }
local startTryhardAnim, stopTryhardAnim

do
    local function isTryhardAnim(id)
        if not id then return false end
        for _,v in pairs(TryhardAnims) do if v==id then return true end end
        return false
    end
    local function saveOriginalTryhardAnims(char)
        local animate=char:FindFirstChild("Animate"); if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids={
            idle1=g(animate.idle and animate.idle.Animation1), idle2=g(animate.idle and animate.idle.Animation2),
            walk=g(animate.walk and animate.walk.WalkAnim), run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim), fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim), swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
        }
        if not isTryhardAnim(ids.walk) then TryhardRefs.originalAnims=ids end
    end
    local function applyTryhardAnims(char)
        local animate=char:FindFirstChild("Animate"); if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId=id end end
        s(animate.idle and animate.idle.Animation1,TryhardAnims.idle1); s(animate.idle and animate.idle.Animation2,TryhardAnims.idle2)
        s(animate.walk and animate.walk.WalkAnim,TryhardAnims.walk); s(animate.run and animate.run.RunAnim,TryhardAnims.run)
        s(animate.jump and animate.jump.JumpAnim,TryhardAnims.jump); s(animate.fall and animate.fall.FallAnim,TryhardAnims.fall)
        s(animate.climb and animate.climb.ClimbAnim,TryhardAnims.climb); s(animate.swim and animate.swim.Swim,TryhardAnims.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle,TryhardAnims.swimidle)
    end
    local function restoreOriginalTryhardAnims(char)
        local orig=TryhardRefs.originalAnims; if not orig then return end
        local animate=char:FindFirstChild("Animate"); if not animate then return end
        local function s(obj,id) if obj and id then obj.AnimationId=id end end
        s(animate.idle and animate.idle.Animation1,orig.idle1); s(animate.idle and animate.idle.Animation2,orig.idle2)
        s(animate.walk and animate.walk.WalkAnim,orig.walk); s(animate.run and animate.run.RunAnim,orig.run)
        s(animate.jump and animate.jump.JumpAnim,orig.jump); s(animate.fall and animate.fall.FallAnim,orig.fall)
        s(animate.climb and animate.climb.ClimbAnim,orig.climb); s(animate.swim and animate.swim.Swim,orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle,orig.swimidle)
    end
    function startTryhardAnim()
        if TryhardRefs.heartbeat then TryhardRefs.heartbeat:Disconnect(); TryhardRefs.heartbeat=nil end
        local char=LP.Character
        if char then saveOriginalTryhardAnims(char); applyTryhardAnims(char) end
        TryhardRefs.heartbeat=RunService.Heartbeat:Connect(function()
            if not State.tryhardAnimEnabled then return end
            local c=LP.Character; if c then applyTryhardAnims(c) end
        end)
    end
    function stopTryhardAnim()
        if TryhardRefs.heartbeat then TryhardRefs.heartbeat:Disconnect(); TryhardRefs.heartbeat=nil end
        local char=LP.Character; if char then restoreOriginalTryhardAnims(char) end
    end
end

local function startAntiRagdoll()
    if Conns.antiRag then return end
    local ragdollConns={}
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local char=LP.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid"); local root=char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s=hum:GetState()
        local ragdolled=(s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown)
        local endTime=LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime-workspace:GetServerTimeNow())>0 then ragdolled=true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow()) end)
            for _,d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then d:Destroy() end
            end
            for _,obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end
            end
            if hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject=hum
            root.Anchored=false; root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        end
    end)
    Conns.antiRagExtra=ragdollConns
end

local function stopAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end
    if Conns.antiRagExtra then
        for _,c in ipairs(Conns.antiRagExtra) do pcall(function() c:Disconnect() end) end
        Conns.antiRagExtra=nil
    end
end

local skyClockTimeConnection=nil

local function removeSky()
    for _,v in ipairs(Lighting:GetChildren()) do
        if v.Name=="CustomSky" or v.Name=="CustomBloom" or v.Name=="CustomCC" or v.Name=="CustomAtmo" then v:Destroy() end
    end
    if skyClockTimeConnection then skyClockTimeConnection:Disconnect(); skyClockTimeConnection=nil end
    Lighting.Technology=OriginalLighting.Technology; Lighting.Brightness=OriginalLighting.Brightness
    Lighting.ClockTime=OriginalLighting.ClockTime; Lighting.ExposureCompensation=OriginalLighting.ExposureCompensation
    Lighting.Ambient=OriginalLighting.Ambient; Lighting.OutdoorAmbient=OriginalLighting.OutdoorAmbient
    Lighting.ColorShift_Top=OriginalLighting.ColorShift_Top; Lighting.ColorShift_Bottom=OriginalLighting.ColorShift_Bottom
    Lighting.FogEnd=OriginalLighting.FogEnd; Lighting.FogStart=OriginalLighting.FogStart
    Lighting.GlobalShadows=OriginalLighting.GlobalShadows
end

local function applyCyberSky()
    for _,v in ipairs(Lighting:GetChildren()) do
        if v.Name=="CustomSky" or v.Name=="CustomBloom" or v.Name=="CustomCC" or v.Name=="CustomAtmo" then v:Destroy() end
    end
    local currentTime=Lighting.ClockTime; local isNight=currentTime<6 or currentTime>18
    Lighting.Technology=Enum.Technology.Future
    if isNight then Lighting.Brightness=3; Lighting.ExposureCompensation=0.05; Lighting.Ambient=Color3.fromRGB(0,20,40); Lighting.OutdoorAmbient=Color3.fromRGB(10,30,60)
    else Lighting.Brightness=1.5; Lighting.ExposureCompensation=-0.15; Lighting.Ambient=Color3.fromRGB(30,30,50); Lighting.OutdoorAmbient=Color3.fromRGB(40,40,70) end
    local sky=Instance.new("Sky"); sky.Name="CustomSky"
    sky.SkyboxBk="rbxassetid://9994573642"; sky.SkyboxDn="rbxassetid://9994573642"; sky.SkyboxFt="rbxassetid://9994573642"
    sky.SkyboxLf="rbxassetid://9994573642"; sky.SkyboxRt="rbxassetid://9994573642"; sky.SkyboxUp="rbxassetid://9994573642"; sky.Parent=Lighting
    local bloom=Instance.new("BloomEffect"); bloom.Name="CustomBloom"
    if isNight then bloom.Intensity=0.35; bloom.Size=36; bloom.Threshold=0.8
    else bloom.Intensity=0.15; bloom.Size=30; bloom.Threshold=0.9 end
    bloom.Parent=Lighting
    local cc=Instance.new("ColorCorrectionEffect"); cc.Name="CustomCC"
    if isNight then cc.Brightness=0.05; cc.Contrast=0.15; cc.Saturation=0.2; cc.TintColor=Color3.fromRGB(255,255,255)
    else cc.Brightness=-0.08; cc.Contrast=0.05; cc.Saturation=0.1; cc.TintColor=Color3.fromRGB(0,100,200) end
    cc.Parent=Lighting
    local atmo=Instance.new("Atmosphere"); atmo.Name="CustomAtmo"
    if isNight then atmo.Density=0.25; atmo.Offset=0.1; atmo.Color=Color3.fromRGB(0,100,200); atmo.Decay=Color3.fromRGB(0,40,100); atmo.Glare=0.3; atmo.Haze=0.8
    else atmo.Density=0.4; atmo.Offset=0.15; atmo.Color=Color3.fromRGB(0,80,160); atmo.Decay=Color3.fromRGB(0,30,80); atmo.Glare=0.1; atmo.Haze=0.5 end
    atmo.Parent=Lighting
end

local function applySakuraSky()
    for _,v in ipairs(Lighting:GetChildren()) do
        if v.Name=="CustomSky" or v.Name=="CustomBloom" or v.Name=="CustomCC" or v.Name=="CustomAtmo" then v:Destroy() end
    end
    local currentTime=Lighting.ClockTime; local isNight=currentTime<6 or currentTime>18
    Lighting.Technology=Enum.Technology.Future
    if isNight then Lighting.Brightness=4; Lighting.ExposureCompensation=0.08; Lighting.Ambient=Color3.fromRGB(60,40,70); Lighting.OutdoorAmbient=Color3.fromRGB(80,50,100)
    else Lighting.Brightness=2; Lighting.ExposureCompensation=-0.1; Lighting.Ambient=Color3.fromRGB(80,60,100); Lighting.OutdoorAmbient=Color3.fromRGB(100,70,130) end
    local sky=Instance.new("Sky"); sky.Name="CustomSky"
    sky.SkyboxBk="rbxassetid://10174567842"; sky.SkyboxDn="rbxassetid://10174567842"; sky.SkyboxFt="rbxassetid://10174567842"
    sky.SkyboxLf="rbxassetid://10174567842"; sky.SkyboxRt="rbxassetid://10174567842"; sky.SkyboxUp="rbxassetid://10174567842"; sky.Parent=Lighting
    local bloom=Instance.new("BloomEffect"); bloom.Name="CustomBloom"
    if isNight then bloom.Intensity=0.5; bloom.Size=42; bloom.Threshold=0.7
    else bloom.Intensity=0.25; bloom.Size=35; bloom.Threshold=0.85 end
    bloom.Parent=Lighting
    local cc=Instance.new("ColorCorrectionEffect"); cc.Name="CustomCC"
    if isNight then cc.Brightness=0.03; cc.Contrast=0.1; cc.Saturation=0.25; cc.TintColor=Color3.fromRGB(255,150,200)
    else cc.Brightness=-0.05; cc.Contrast=0.05; cc.Saturation=0.15; cc.TintColor=Color3.fromRGB(200,100,150) end
    cc.Parent=Lighting
    local atmo=Instance.new("Atmosphere"); atmo.Name="CustomAtmo"
    if isNight then atmo.Density=0.3; atmo.Offset=0.08; atmo.Color=Color3.fromRGB(255,160,210); atmo.Decay=Color3.fromRGB(140,60,100); atmo.Glare=0.4; atmo.Haze=1.0
    else atmo.Density=0.45; atmo.Offset=0.12; atmo.Color=Color3.fromRGB(200,120,170); atmo.Decay=Color3.fromRGB(100,40,80); atmo.Glare=0.15; atmo.Haze=0.6 end
    atmo.Parent=Lighting
end

local function refreshSkyOnTimeChange()
    if State.skyMode==1 then applyCyberSky() elseif State.skyMode==2 then applySakuraSky() end
end

local function setSkyMode(mode)
    State.skyMode=mode
    if skyClockTimeConnection then skyClockTimeConnection:Disconnect(); skyClockTimeConnection=nil end
    if mode==0 then removeSky()
    elseif mode==1 then applyCyberSky(); skyClockTimeConnection=Lighting:GetPropertyChangedSignal("ClockTime"):Connect(refreshSkyOnTimeChange)
    elseif mode==2 then applySakuraSky(); skyClockTimeConnection=Lighting:GetPropertyChangedSignal("ClockTime"):Connect(refreshSkyOnTimeChange) end
    scheduleAutoSave()
end

local function getSkyModeText()
    if State.skyMode==0 then return "Off" elseif State.skyMode==1 then return "Cyber" elseif State.skyMode==2 then return "Sakura" end
    return "Off"
end

local function nextSkyMode()
    setSkyMode((State.skyMode+1)%3); return getSkyModeText()
end

local instaResetRemote = nil
local instaResetCooldown = false

pcall(function()
    if hookfunction and newcclosure then
        local _orig
        _orig = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not instaResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
                instaResetRemote = self
            end
            return _orig(self, ...)
        end))
    end
end)

local function doInstaReset()
    if instaResetCooldown then return end
    if not instaResetRemote then return end
    instaResetCooldown = true
    local oldChar = LP.Character
    task.spawn(function()
        while LP.Character == oldChar do
            pcall(function() instaResetRemote:FireServer("f888ee6e-c86d-46e1-93d7-0639d6635d42", LP, "balloon") end)
            task.wait()
        end
        instaResetCooldown = false
    end)
end

-- ============================================================
-- AUTO BAT - NOUVEAU SYSTÈME (ACE)
-- ============================================================

local autoBatTarget = nil
local autoBatLastScan = 0
local autoBatEquippedThisRun = false

local AUTO_BAT_SPEED = 58
local AUTO_BAT_VERT_SPEED = 52
local AUTO_BAT_DIST = -2.8
local AUTO_BAT_HEIGHT = 4.75
local AUTO_BAT_V_OFF = 1
local AUTO_BAT_TURN_SPEED = 285
local AUTO_BAT_MAX_TURN_RATE = 28

local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - autoBatLastScan <= 0.1 and autoBatTarget and autoBatTarget.Parent then
        local hum = autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return autoBatTarget end
    end
    autoBatLastScan = now
    autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    autoBatTarget = closest
    return autoBatTarget
end

local function resetAutoBatMotion()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.3
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end

local function toggleAutoBat()
    State.autoBatEnabled = not State.autoBatEnabled
    if State.autoBatEnabled then
        autoBatEquippedThisRun = false
    else
        local char = LP.Character
        if char then
            local hum2 = char:FindFirstChildOfClass("Humanoid")
            if hum2 then hum2.AutoRotate = true end
        end
        resetAutoBatMotion()
    end
    if GuiToggleSetters["autoBat"] then
        GuiToggleSetters["autoBat"](State.autoBatEnabled)
    end
    scheduleAutoSave()
    return State.autoBatEnabled
end

-- Boucle principale Auto Bat
RunService.Heartbeat:Connect(function()
    if not State.autoBatEnabled then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum then return end

    if not autoBatEquippedThisRun then
        autoBatEquippedThisRun = true
        if not char:FindFirstChildOfClass("Tool") then
            local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
            local bpBat = bp and bp:FindFirstChild("Bat")
            if bpBat then pcall(function() hum:EquipTool(bpBat) end) end
        end
    end

    local target = getAutoBatTarget()
    if target then
        local targetVel = target.AssemblyLinearVelocity
        local aimTargetPos = target.Position + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15)) + Vector3.new(0, AUTO_BAT_V_OFF, 0)
        hum.AutoRotate = false
        local look = aimTargetPos - root.Position
        local flatLook = Vector3.new(look.X, 0, look.Z)

        if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
            local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
            local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
            local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
            local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
            local yawRate = math.clamp(math.rad(yawDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
            local pitchRate = math.clamp(math.rad(pitchDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
            local yawRad = math.rad(root.Orientation.Y)
            local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
            root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
        else
            root.AssemblyAngularVelocity = Vector3.zero
        end

        local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
        local standPos = aimTargetPos - (dir * AUTO_BAT_DIST) + Vector3.new(0, AUTO_BAT_HEIGHT, 0)
        local moveDir = standPos - root.Position
        local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
        local hVel = hDir.Magnitude > 0.1 and hDir.Unit * AUTO_BAT_SPEED or Vector3.zero
        local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_VERT_SPEED, 0) or Vector3.new(0, -2, 0)
        root.AssemblyLinearVelocity = hVel + vVel
        if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
    else
        hum.AutoRotate = true
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if State.autoSwingEnabled then
        local bat = char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then
            bat:Activate()
        end
    end
end)

-- ============================================================
-- STRETCH REZ
-- ============================================================
local stretchRezConn = nil

local function enableStretchRez()
    State.stretchRezEnabled = true
    workspace.CurrentCamera.FieldOfView = 120
    if stretchRezConn then stretchRezConn:Disconnect() end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not State.stretchRezEnabled then
            stretchRezConn:Disconnect()
            stretchRezConn = nil
            return
        end
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableStretchRez()
    State.stretchRezEnabled = false
    if stretchRezConn then
        stretchRezConn:Disconnect()
        stretchRezConn = nil
    end
    workspace.CurrentCamera.FieldOfView = 70
end

local function toggleStretchRez()
    if State.stretchRezEnabled then
        disableStretchRez()
    else
        enableStretchRez()
    end
    if GuiToggleSetters["stretchRez"] then
        GuiToggleSetters["stretchRez"](State.stretchRezEnabled)
    end
    scheduleAutoSave()
    return State.stretchRezEnabled
end

-- ============================================================
-- REMOVE ACCESSORIES
-- ============================================================
local accessoryConn = nil

local function enableRemoveAccessories()
    State.removeAccessoriesEnabled = true
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            for _, obj in ipairs(p.Character:GetDescendants()) do
                if obj:IsA("Accessory") or obj:IsA("Hat") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    
    if not accessoryConn then
        accessoryConn = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                if not State.removeAccessoriesEnabled then return end
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end)
        end)
    end
end

local function disableRemoveAccessories()
    State.removeAccessoriesEnabled = false
    if accessoryConn then
        accessoryConn:Disconnect()
        accessoryConn = nil
    end
end

local function toggleRemoveAccessories()
    if State.removeAccessoriesEnabled then
        disableRemoveAccessories()
    else
        enableRemoveAccessories()
    end
    if GuiToggleSetters["removeAccessories"] then
        GuiToggleSetters["removeAccessories"](State.removeAccessoriesEnabled)
    end
    scheduleAutoSave()
    return State.removeAccessoriesEnabled
end

-- ============================================================
-- DARK MODE
-- ============================================================
local _defBrightness = Lighting.Brightness
local _defClock = Lighting.ClockTime
local _defAmbient = Lighting.OutdoorAmbient

local function enableDarkMode()
    State.darkModeEnabled = true
    
    local sky = Lighting:FindFirstChild("GalaxySky") or Instance.new("Sky")
    sky.Name = "GalaxySky"
    sky.SkyboxBk = "rbxassetid://159454299"
    sky.SkyboxDn = "rbxassetid://159454296"
    sky.SkyboxFt = "rbxassetid://159454293"
    sky.SkyboxLf = "rbxassetid://159454286"
    sky.SkyboxRt = "rbxassetid://159454289"
    sky.SkyboxUp = "rbxassetid://159454291"
    sky.Parent = Lighting
    
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.ExposureCompensation = -2
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
end

local function disableDarkMode()
    State.darkModeEnabled = false
    
    local sky = Lighting:FindFirstChild("GalaxySky")
    if sky then sky:Destroy() end
    
    Lighting.Brightness = _defBrightness
    Lighting.ClockTime = _defClock
    Lighting.ExposureCompensation = 0
    Lighting.OutdoorAmbient = _defAmbient
end

local function toggleDarkMode()
    if State.darkModeEnabled then
        disableDarkMode()
    else
        enableDarkMode()
    end
    if GuiToggleSetters["darkMode"] then
        GuiToggleSetters["darkMode"](State.darkModeEnabled)
    end
    scheduleAutoSave()
    return State.darkModeEnabled
end

-- ============================================================
-- ANTI LAG (déplacé dans Visual)
-- ============================================================
local _antiLagConn = nil
local defLightBrightness2, defLightClock2, defLightAmbient2

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    State.antiLagEnabled = true
    defLightBrightness2 = defLightBrightness2 or Lighting.Brightness
    defLightClock2 = defLightClock2 or Lighting.ClockTime
    defLightAmbient2 = defLightAmbient2 or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    pcall(function() Lighting.EnvironmentDiffuseScale = 0 end)
    pcall(function() Lighting.EnvironmentSpecularScale = 0 end)
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if _antiLagConn then _antiLagConn:Disconnect() end
    _antiLagConn = workspace.DescendantAdded:Connect(function(obj) if State.antiLagEnabled then applyAntiLagDerender(obj) end end)
end

local function disableAntiLag()
    State.antiLagEnabled = false
    if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
    pcall(function()
        if defLightBrightness2 then Lighting.Brightness = defLightBrightness2 end
        if defLightClock2 then Lighting.ClockTime = defLightClock2 end
        if defLightAmbient2 then Lighting.OutdoorAmbient = defLightAmbient2 end
        Lighting.ExposureCompensation = 0
    end)
end

local function toggleAntiLag()
    if State.antiLagEnabled then
        disableAntiLag()
    else
        enableAntiLag()
    end
    if GuiToggleSetters["antiLag"] then
        GuiToggleSetters["antiLag"](State.antiLagEnabled)
    end
    scheduleAutoSave()
    return State.antiLagEnabled
end

-- ============================================================
-- FIN DES FONCTIONS
-- ============================================================

local function toggleLaggerMode()
    State.laggerModeEnabled=not State.laggerModeEnabled; scheduleAutoSave()
    if GuiToggleSetters["laggerToggle"] then GuiToggleSetters["laggerToggle"](State.laggerModeEnabled) end
end

local CharRefs={humanoid=nil,hrp=nil,speedLabel=nil}

local function setupChar(char)
    local humanoid=char:WaitForChild("Humanoid",5); local hrp=char:WaitForChild("HumanoidRootPart",5); local head=char:WaitForChild("Head",5)
    if not humanoid or not hrp or not head then return end
    CharRefs.humanoid=humanoid; CharRefs.hrp=hrp
    local old=head:FindFirstChild("SpeedBillboard"); if old then old:Destroy() end
local bb=Instance.new("BillboardGui"); bb.Name="SpeedBillboard"; bb.Size=UDim2.new(0,180,0,52)
bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head

local dcLbl=Instance.new("TextLabel", bb)
dcLbl.Size=UDim2.new(1,0,0,22); dcLbl.Position=UDim2.new(0,0,0,0)
dcLbl.BackgroundTransparency=1; dcLbl.Text="discord.gg/spaceduels"
dcLbl.TextColor3=Color3.fromRGB(255,255,255)
dcLbl.Font=Enum.Font.GothamBlack
dcLbl.TextScaled=true; dcLbl.TextStrokeTransparency=0; dcLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)

local underline=Instance.new("Frame", bb)
underline.Size=UDim2.new(0.85,0,0,2); underline.Position=UDim2.new(0.080,0,0,24)
underline.BackgroundColor3=Color3.fromRGB(255,255,255)
underline.BorderSizePixel=0
Instance.new("UICorner", underline).CornerRadius=UDim.new(1,0)

CharRefs.speedLabel=Instance.new("TextLabel", bb)
CharRefs.speedLabel.Size=UDim2.new(1,0,0,22); CharRefs.speedLabel.Position=UDim2.new(0,0,0,26)
CharRefs.speedLabel.BackgroundTransparency=1; CharRefs.speedLabel.Text="Speed: 0"
CharRefs.speedLabel.TextColor3=Color3.fromRGB(255,255,255)
CharRefs.speedLabel.Font=Enum.Font.GothamBold
CharRefs.speedLabel.TextScaled=true; CharRefs.speedLabel.TextStrokeTransparency=0
CharRefs.speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

end

LP.CharacterAdded:Connect(function(char) task.wait(0.3); setupChar(char) end)
if LP.Character then task.spawn(function() task.wait(0.3); setupChar(LP.Character) end) end

local EnemySpeedLabels={}

local function setupEnemySpeedDisplay()
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LP and player.Character then
            local head=player.Character:FindFirstChild("Head")
            if head then
                local existing=head:FindFirstChild("EnemySpeedBillboard"); if existing then existing:Destroy() end
                local bb=Instance.new("BillboardGui"); bb.Name="EnemySpeedBillboard"; bb.Size=UDim2.new(0,140,0,25)
                bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=head
                local speedLabel=Instance.new("TextLabel"); speedLabel.Size=UDim2.new(1,0,1,0)
                speedLabel.BackgroundTransparency=1; speedLabel.TextColor3=Color3.fromRGB(255,255,255)
                speedLabel.Font=Enum.Font.GothamBold; speedLabel.TextScaled=true; speedLabel.TextStrokeTransparency=0; speedLabel.Parent=bb
                EnemySpeedLabels[player]=speedLabel
            end
        end
    end
end

local function updateEnemySpeedDisplay()
    for player,label in pairs(EnemySpeedLabels) do
        if player and player.Character then
            local hrp=player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then local vel=hrp.AssemblyLinearVelocity; label.Text=string.format("%.1f",Vector3.new(vel.X,0,vel.Z).Magnitude)
            else label.Text="0.0" end
        else label.Text="0.0" end
    end
end

local function onPlayerAdded(player)
    if player~=LP then
        player.CharacterAdded:Connect(function(character)
            task.wait(0.3); local head=character:FindFirstChild("Head")
            if head then
                local existing=head:FindFirstChild("EnemySpeedBillboard"); if existing then existing:Destroy() end
                local bb=Instance.new("BillboardGui"); bb.Name="EnemySpeedBillboard"; bb.Size=UDim2.new(0,140,0,25)
                bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=head
                local speedLabel=Instance.new("TextLabel"); speedLabel.Size=UDim2.new(1,0,1,0)
                speedLabel.BackgroundTransparency=1; speedLabel.TextColor3=Color3.fromRGB(255,255,255)
                speedLabel.Font=Enum.Font.GothamBold; speedLabel.TextScaled=true; speedLabel.TextStrokeTransparency=0; speedLabel.Parent=bb
                EnemySpeedLabels[player]=speedLabel
            end
        end)
        if player.Character then
            local head=player.Character:FindFirstChild("Head")
            if head then
                local bb=Instance.new("BillboardGui"); bb.Name="EnemySpeedBillboard"; bb.Size=UDim2.new(0,140,0,25)
                bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=head
                local speedLabel=Instance.new("TextLabel"); speedLabel.Size=UDim2.new(1,0,1,0)
                speedLabel.BackgroundTransparency=1; speedLabel.TextColor3=Color3.fromRGB(255,255,255)
                speedLabel.Font=Enum.Font.GothamBold; speedLabel.TextScaled=true; speedLabel.TextStrokeTransparency=0; speedLabel.Parent=bb
                EnemySpeedLabels[player]=speedLabel
            end
        end
    end
end

local function onPlayerRemoving(player) EnemySpeedLabels[player]=nil end
for _,player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end
Players.PlayerAdded:Connect(onPlayerAdded); Players.PlayerRemoving:Connect(onPlayerRemoving)
task.spawn(function() while true do updateEnemySpeedDisplay(); task.wait(0.1) end end)

-- ============================================================
-- PALETTE DE COULEURS - TOUT EN BLANC
-- ============================================================
local C={
    bg=Color3.fromRGB(10,10,14), bgDark=Color3.fromRGB(15,10,18), row=Color3.fromRGB(20,20,26),
    input=Color3.fromRGB(20,20,26), 
    blue=Color3.fromRGB(255,255,255),
    blueDim=Color3.fromRGB(200,200,200),
    blueDark=Color3.fromRGB(30,30,30),
    text=Color3.fromRGB(255,255,255), textDim=Color3.fromRGB(200,200,200),
    textMuted=Color3.fromRGB(150,150,150), white=Color3.fromRGB(255,255,255), divider=Color3.fromRGB(28,28,34),
    green=Color3.fromRGB(80,220,120), underline=Color3.fromRGB(255,255,255),
}

local function guiCorner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c
end
local function guiStroke(p,col,t)
    local s=Instance.new("UIStroke"); s.Color=col or C.divider; s.Thickness=t or 1
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s
end
local function tw(obj,props,t,sty,dir)
    TweenService:Create(obj,TweenInfo.new(t or 0.18,sty or Enum.EasingStyle.Quad,dir or Enum.EasingDirection.Out),props):Play()
end

for _,name in pairs({"ADAPTHub","ApinaGUI","SKSpeedBypass","AutoStealBar","CypherHub","VoidHub","SpeedBypassGUI","VoidBypassGUI","CyberHub"}) do
    local old=PlayerGui:FindFirstChild(name); if old then old:Destroy() end
end

local GuiRefs={}; local LeftPanel=nil; local CategoryBar=nil

local function setCategoriesPosition()
    local isMobileDevice=UIS.TouchEnabled and not UIS.KeyboardEnabled
    if LeftPanel then LeftPanel.Visible=false end
    if CategoryBar then CategoryBar.Visible=true end
    if GuiRefs.contentFrame then
        if isMobileDevice then
            GuiRefs.contentFrame.Size=UDim2.new(1,-4,1,-118); GuiRefs.contentFrame.Position=UDim2.new(0,2,0,63)
        else
            GuiRefs.contentFrame.Size=UDim2.new(1,-16,1,-118); GuiRefs.contentFrame.Position=UDim2.new(0,8,0,63)
        end
    end
end

-- === CRÉATION DE L'INTERFACE ===
do
    local GuiHub=Instance.new("ScreenGui"); GuiHub.Name="CyberHub"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; GuiHub.Parent=PlayerGui; GuiRefs.hub=GuiHub

    local Outer=Instance.new("Frame"); Outer.Name="Outer"; Outer.Size=UDim2.new(0,425,0,515)
    Outer.Position=UDim2.new(0,20,0,110); Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0
    Outer.ClipsDescendants=false; Outer.Parent=GuiHub; GuiRefs.outer=Outer; makeDraggable(Outer)

    local isMobileDevice=UIS.TouchEnabled and not UIS.KeyboardEnabled
    if isMobileDevice then Outer.Size=UDim2.new(0,280,0,400); Outer.Position=UDim2.new(0,10,0,60) end

    local Inner=Instance.new("Frame"); Inner.Name="Inner"; Inner.ClipsDescendants=false
    Inner.Size=UDim2.new(1,0,1,0); Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=0
    Inner.BorderSizePixel=0; Inner.Parent=Outer; guiCorner(Inner,24); guiStroke(Inner,Color3.fromRGB(45,45,62),1.5)
    GuiRefs.inner=Inner

    local BackgroundContainer=Instance.new("Frame"); BackgroundContainer.Name="BackgroundContainer"
    BackgroundContainer.Size=UDim2.new(1,0,1,-118); BackgroundContainer.Position=UDim2.new(0,0,0,63)
    BackgroundContainer.BackgroundTransparency=1; BackgroundContainer.ZIndex=0; BackgroundContainer.ClipsDescendants=true; BackgroundContainer.Parent=Inner

    local BgGrad=Instance.new("Frame"); BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0)
    BgGrad.BackgroundColor3=C.bgDark; BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BackgroundContainer
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(40,12,30)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(15,10,18)),ColorSequenceKeypoint.new(1,Color3.fromRGB(35,10,25))})
    grad.Rotation=135; grad.Parent=BgGrad; GuiRefs.bgGrad=BgGrad

    local BackgroundImage=Instance.new("ImageLabel"); BackgroundImage.Name="BackgroundImage"
    BackgroundImage.Size=UDim2.new(1,0,1,0); BackgroundImage.BackgroundTransparency=1; BackgroundImage.Image=""
    BackgroundImage.ScaleType=Enum.ScaleType.Crop; BackgroundImage.ZIndex=0; BackgroundImage.Visible=false
    BackgroundImage.Parent=BackgroundContainer; GuiRefs.backgroundImage=BackgroundImage

    -- HEADER FRAME NOIR AVEC COINS ARRONDIS EN HAUT SEULEMENT
    local HeaderFrame=Instance.new("Frame"); HeaderFrame.Name="HeaderFrame"; HeaderFrame.Size=UDim2.new(1,0,0,62)
    HeaderFrame.BackgroundTransparency=0
    HeaderFrame.BackgroundColor3=Color3.fromRGB(0,0,0)
    HeaderFrame.BorderSizePixel=0; HeaderFrame.Parent=Inner; HeaderFrame.ZIndex=2
    local headerCorner=Instance.new("UICorner")
    headerCorner.CornerRadius=UDim.new(0,12)
    headerCorner.Parent=HeaderFrame
    local headerBottom=Instance.new("Frame")
    headerBottom.Size=UDim2.new(1,0,0,6)
    headerBottom.Position=UDim2.new(0,0,1,-6)
    headerBottom.BackgroundColor3=Color3.fromRGB(0,0,0)
    headerBottom.BackgroundTransparency=0
    headerBottom.BorderSizePixel=0
    headerBottom.Parent=HeaderFrame

    local TitleLbl=Instance.new("TextLabel"); TitleLbl.Position=UDim2.new(0,14,0,18); TitleLbl.Size=UDim2.new(1,-90,0,22)
    TitleLbl.BackgroundTransparency=1; TitleLbl.Text="Space | HUB"; TitleLbl.TextColor3=C.text; TitleLbl.TextSize=17
    TitleLbl.Font=Enum.Font.GothamBlack; TitleLbl.TextXAlignment=Enum.TextXAlignment.Left; TitleLbl.Parent=HeaderFrame; TitleLbl.ZIndex=3

    local MadeLbl=Instance.new("TextLabel"); MadeLbl.Position=UDim2.new(0,14,0,40); MadeLbl.Size=UDim2.new(0,200,0,14)
    MadeLbl.BackgroundTransparency=1; MadeLbl.Text=""; MadeLbl.TextColor3=C.textDim; MadeLbl.TextSize=10
    MadeLbl.Font=Enum.Font.GothamBold; MadeLbl.TextXAlignment=Enum.TextXAlignment.Left; MadeLbl.Parent=HeaderFrame; MadeLbl.ZIndex=3

    GuiRefs.pingFpsLbl=Instance.new("TextLabel"); GuiRefs.pingFpsLbl.Position=UDim2.new(0,200,0,40)
    GuiRefs.pingFpsLbl.Size=UDim2.new(0,150,0,14); GuiRefs.pingFpsLbl.BackgroundTransparency=1
    GuiRefs.pingFpsLbl.Text=""; GuiRefs.pingFpsLbl.TextColor3=Color3.fromRGB(200,200,200)
    GuiRefs.pingFpsLbl.TextSize=9; GuiRefs.pingFpsLbl.Font=Enum.Font.GothamBold
    GuiRefs.pingFpsLbl.TextXAlignment=Enum.TextXAlignment.Left; GuiRefs.pingFpsLbl.Parent=HeaderFrame; GuiRefs.pingFpsLbl.ZIndex=3

    local CloseBtn=Instance.new("TextButton",HeaderFrame); CloseBtn.Size=UDim2.new(0,28,0,28)
    CloseBtn.Position=UDim2.new(1,-36,0,6); CloseBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
    CloseBtn.BackgroundTransparency=0.3; CloseBtn.BorderSizePixel=0; CloseBtn.Text="-"; CloseBtn.TextColor3=C.text
    CloseBtn.TextSize=18; CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.ZIndex=4; guiCorner(CloseBtn,8)

    local ReopenSG=Instance.new("ScreenGui"); ReopenSG.Name="ReopenBtn"; ReopenSG.ResetOnSpawn=false
    ReopenSG.Enabled=false; ReopenSG.Parent=PlayerGui; GuiRefs.reopenBtn=ReopenSG

    local ReopenBtn=Instance.new("TextButton",ReopenSG); ReopenBtn.Size=UDim2.new(0,90,0,28)
    ReopenBtn.Position=UDim2.new(0,20,0,110); ReopenBtn.BackgroundColor3=C.blue; ReopenBtn.BackgroundTransparency=0.3
    ReopenBtn.BorderSizePixel=0; ReopenBtn.Text="Space | HUB"; ReopenBtn.TextColor3=C.white; ReopenBtn.TextSize=11
    ReopenBtn.Font=Enum.Font.GothamBlack; ReopenBtn.ZIndex=3; guiCorner(ReopenBtn,8); makeDraggable(ReopenBtn)

    CloseBtn.MouseButton1Click:Connect(function() GuiRefs.outer.Visible=false; ReopenSG.Enabled=true end)
    ReopenBtn.MouseButton1Click:Connect(function() GuiRefs.outer.Visible=true; ReopenSG.Enabled=false end)

    local HeaderSep=Instance.new("Frame"); HeaderSep.Position=UDim2.new(0,14,0,62); HeaderSep.Size=UDim2.new(1,-28,0,1)
    HeaderSep.BackgroundColor3=C.blue; HeaderSep.BackgroundTransparency=0.7; HeaderSep.BorderSizePixel=0; HeaderSep.Parent=Inner; HeaderSep.ZIndex=2

    LeftPanel=Instance.new("Frame"); LeftPanel.Name="LeftPanel"; LeftPanel.Size=UDim2.new(0,85,1,-118)
    LeftPanel.Position=UDim2.new(0,0,0,63); LeftPanel.BackgroundColor3=C.bgDark; LeftPanel.BackgroundTransparency=0.5
    LeftPanel.BorderSizePixel=0; LeftPanel.Parent=Inner; guiCorner(LeftPanel,12); LeftPanel.ZIndex=2

    local CategoryList=Instance.new("ScrollingFrame"); CategoryList.Name="CategoryList"; CategoryList.Size=UDim2.new(1,0,1,0)
    CategoryList.BackgroundTransparency=1; CategoryList.BorderSizePixel=0; CategoryList.ScrollBarThickness=2
    CategoryList.ScrollBarImageColor3=C.blue; CategoryList.CanvasSize=UDim2.new(0,0,0,0)
    CategoryList.AutomaticCanvasSize=Enum.AutomaticSize.Y; CategoryList.Parent=LeftPanel
    local CatLayout=Instance.new("UIListLayout"); CatLayout.SortOrder=Enum.SortOrder.LayoutOrder; CatLayout.Padding=UDim.new(0,4); CatLayout.Parent=CategoryList
    local CatPad=Instance.new("UIPadding"); CatPad.PaddingLeft=UDim.new(0,6); CatPad.PaddingRight=UDim.new(0,6)
    CatPad.PaddingTop=UDim.new(0,10); CatPad.PaddingBottom=UDim.new(0,10); CatPad.Parent=CategoryList
    GuiRefs.categoryList=CategoryList

    local ContentFrame=Instance.new("ScrollingFrame"); ContentFrame.Name="ContentFrame"
    if isMobileDevice then ContentFrame.Size=UDim2.new(1,-8,1,-118); ContentFrame.Position=UDim2.new(0,4,0,63)
    else ContentFrame.Size=UDim2.new(1,-95,1,-118); ContentFrame.Position=UDim2.new(0,85,0,63) end
    ContentFrame.BackgroundTransparency=1; ContentFrame.BorderSizePixel=0
    if isMobileDevice then ContentFrame.ScrollBarThickness=18 else ContentFrame.ScrollBarThickness=6 end
    ContentFrame.ScrollBarImageColor3=C.blue; ContentFrame.CanvasSize=UDim2.new(0,0,0,0)
    ContentFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y; ContentFrame.ScrollingDirection=Enum.ScrollingDirection.Y
    ContentFrame.ScrollingEnabled=true; ContentFrame.ElasticBehavior=Enum.ElasticBehavior.Never
    ContentFrame.VerticalScrollBarPosition=Enum.VerticalScrollBarPosition.Right; ContentFrame.Parent=Inner
    GuiRefs.contentFrame=ContentFrame

    local CLayout=Instance.new("UIListLayout"); CLayout.SortOrder=Enum.SortOrder.LayoutOrder; CLayout.Padding=UDim.new(0,6); CLayout.Parent=ContentFrame
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,12); CPad.PaddingRight=UDim.new(0,12)
    CPad.PaddingTop=UDim.new(0,10); CPad.PaddingBottom=UDim.new(0,15); CPad.Parent=ContentFrame

    local BottomSep=Instance.new("Frame"); BottomSep.Position=UDim2.new(0,8,1,-54); BottomSep.Size=UDim2.new(1,-16,0,1)
    BottomSep.BackgroundColor3=C.blue; BottomSep.BackgroundTransparency=0.65; BottomSep.BorderSizePixel=0; BottomSep.Parent=Inner; BottomSep.ZIndex=2

    CategoryBar=Instance.new("ScrollingFrame"); CategoryBar.Name="CategoryBar"; CategoryBar.Position=UDim2.new(0,8,1,-48)
    CategoryBar.Size=UDim2.new(1,-16,0,40); CategoryBar.BackgroundTransparency=1; CategoryBar.BorderSizePixel=0
    CategoryBar.ScrollBarThickness=0; CategoryBar.ScrollingDirection=Enum.ScrollingDirection.X
    CategoryBar.CanvasSize=UDim2.new(0,0,0,0); CategoryBar.AutomaticCanvasSize=Enum.AutomaticSize.X
    CategoryBar.ElasticBehavior=Enum.ElasticBehavior.Never; CategoryBar.Parent=Inner; CategoryBar.ZIndex=5

    local CatBarLayout=Instance.new("UIListLayout"); CatBarLayout.FillDirection=Enum.FillDirection.Horizontal
    CatBarLayout.SortOrder=Enum.SortOrder.LayoutOrder; CatBarLayout.Padding=UDim.new(0,4)
    CatBarLayout.VerticalAlignment=Enum.VerticalAlignment.Center; CatBarLayout.Parent=CategoryBar
    local CatBarPad=Instance.new("UIPadding"); CatBarPad.PaddingLeft=UDim.new(0,6); CatBarPad.PaddingRight=UDim.new(0,6)
    CatBarPad.PaddingTop=UDim.new(0,4); CatBarPad.PaddingBottom=UDim.new(0,4); CatBarPad.Parent=CategoryBar
    GuiRefs.categoryBar=CategoryBar
    setCategoriesPosition()
end

-- ============================================================
-- FONCTIONS GUI
-- ============================================================
local KeyListen={cb=nil,label=nil,active=false}
local KEY_DISPLAY_ALIASES={ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",ButtonR3="RS",ButtonL3="LS",Thumbstick1="L3",Thumbstick2="R3"}
local function prettyKeyName(keyCode) local raw=keyCode.Name; return KEY_DISPLAY_ALIASES[raw] or raw end

local function cancelKeyListen()
    if KeyListen.label then KeyListen.label.BackgroundColor3=C.blue; KeyListen.label.BackgroundTransparency=0.5 end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
end

local function startKeyListen(labelBtn,onKeySet)
    cancelKeyListen(); KeyListen.cb=onKeySet; KeyListen.label=labelBtn; KeyListen.active=true
    labelBtn.Text="..."; labelBtn.BackgroundColor3=Color3.fromRGB(80,220,120); labelBtn.BackgroundTransparency=0.3
    local captureId=labelBtn
    task.delay(8,function()
        if KeyListen.label==captureId and KeyListen.active then
            cancelKeyListen()
            if labelBtn and labelBtn.Parent then labelBtn.Text=prettyKeyName(Keys.guiHide); labelBtn.BackgroundColor3=C.blue; labelBtn.BackgroundTransparency=0.5 end
        end
    end)
end

UIS.InputBegan:Connect(function(input,gameProcessed)
    if not KeyListen.active then return end; if gameProcessed then return end
    local ut=input.UserInputType
    if ut~=Enum.UserInputType.Keyboard and ut~=Enum.UserInputType.Gamepad1 and ut~=Enum.UserInputType.Gamepad2 then return end
    local key=input.KeyCode
    local ignored={[Enum.KeyCode.Unknown]=true,[Enum.KeyCode.LeftShift]=true,[Enum.KeyCode.RightShift]=true,[Enum.KeyCode.LeftControl]=true,[Enum.KeyCode.RightControl]=true,[Enum.KeyCode.LeftAlt]=true,[Enum.KeyCode.RightAlt]=true,[Enum.KeyCode.LeftMeta]=true,[Enum.KeyCode.RightMeta]=true}
    if ignored[key] then return end
    if key==Enum.KeyCode.Escape then cancelKeyListen(); return end
    local cb=KeyListen.cb; local lbl=KeyListen.label; cancelKeyListen()
    if lbl and lbl.Parent then lbl.Text=prettyKeyName(key); lbl.BackgroundColor3=C.blue; lbl.BackgroundTransparency=0.5 end
    if cb then task.spawn(cb,key) end
end)

local function addSectionLabel(parent,text,order)
    local wrapper=Instance.new("Frame"); wrapper.Size=UDim2.new(1,0,0,22); wrapper.BackgroundTransparency=1
    wrapper.LayoutOrder=order; wrapper.Parent=parent
    local L=Instance.new("TextLabel",wrapper); L.Size=UDim2.new(1,0,0,16); L.Position=UDim2.new(0,0,0,0)
    L.BackgroundTransparency=1; L.Text=text; L.TextColor3=C.textDim; L.TextSize=10; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end

local function addInputRow(parent,label,value,order,callback)
    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.Parent=parent
    guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lbl=Instance.new("TextLabel",Row); Lbl.Size=UDim2.new(0.6,0,0,16); Lbl.Position=UDim2.new(0,12,0,6)
    Lbl.BackgroundTransparency=1; Lbl.Text=label; Lbl.TextColor3=C.text; Lbl.TextSize=11; Lbl.Font=Enum.Font.GothamBold; Lbl.TextXAlignment=Enum.TextXAlignment.Left
    local BoxContainer=Instance.new("Frame",Row); BoxContainer.ZIndex=6; BoxContainer.Position=UDim2.new(1,-58,0.5,-10)
    BoxContainer.Size=UDim2.new(0,48,0,20); BoxContainer.BackgroundColor3=C.input; BoxContainer.BackgroundTransparency=0.5; BoxContainer.BorderSizePixel=0
    guiCorner(BoxContainer,6); guiStroke(BoxContainer,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BoxContainer); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local num=tonumber(Box.Text); if num and num>0 then callback(num) else Box.Text=tostring(value) end end)
    local hover=Instance.new("TextButton",Row); hover.Size=UDim2.new(1,0,1,0); hover.BackgroundTransparency=1; hover.Text=""; hover.ZIndex=0
    hover.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hover.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,Box
end

local function addToggleRow(parent,label,enabled,order,keybindKey,onToggle)
    local hasKB=keybindKey~=nil
    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,hasKB and 50 or 38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.Parent=parent
    guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lbl=Instance.new("TextLabel",Row); Lbl.Size=UDim2.new(0.6,0,0,16); Lbl.Position=UDim2.new(0,12,0,6)
    Lbl.BackgroundTransparency=1; Lbl.Text=label; Lbl.TextColor3=C.text; Lbl.TextSize=11; Lbl.Font=Enum.Font.GothamBold; Lbl.TextXAlignment=Enum.TextXAlignment.Left
    if hasKB then
        local KBtn=Instance.new("TextButton",Row); KBtn.Size=UDim2.new(0,35,0,16); KBtn.Position=UDim2.new(0,12,1,-20)
        KBtn.BackgroundColor3=C.blue; KBtn.BackgroundTransparency=0.5; KBtn.BorderSizePixel=0; KBtn.Text=Keys[keybindKey].Name
        KBtn.TextColor3=C.white; KBtn.TextSize=9; KBtn.Font=Enum.Font.GothamBold; guiCorner(KBtn,5)
        KBtn.MouseButton1Click:Connect(function()
            startKeyListen(KBtn,function(newKey) Keys[keybindKey]=newKey; KBtn.Text=prettyKeyName(newKey); scheduleAutoSave() end)
        end)
    end
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0
    guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local state=enabled
    local function setV(on)
        state=on; tw(Knob,{Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)})
        tw(Knob,{BackgroundTransparency=on and 0.3 or 0.5})
    end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10)
    Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function() state=not state; setV(state); if onToggle then onToggle(state) end end)
    local hover=Instance.new("TextButton",Row); hover.Size=UDim2.new(1,0,1,0); hover.BackgroundTransparency=1; hover.Text=""; hover.ZIndex=0
    hover.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hover.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    if keybindKey then GuiToggleSetters[keybindKey]=setV end
    return Row,setV
end

local function addActionRow(parent,label,keybindKey,onAction,order)
    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,42); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.Parent=parent
    guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lbl=Instance.new("TextLabel",Row); Lbl.Size=UDim2.new(0.55,0,0,16); Lbl.Position=UDim2.new(0,12,0,8)
    Lbl.BackgroundTransparency=1; Lbl.Text=label; Lbl.TextColor3=C.text; Lbl.TextSize=11; Lbl.Font=Enum.Font.GothamBold; Lbl.TextXAlignment=Enum.TextXAlignment.Left
    local KBtn=Instance.new("TextButton",Row); KBtn.Size=UDim2.new(0,40,0,22); KBtn.Position=UDim2.new(1,-48,0.5,-11)
    KBtn.BackgroundColor3=C.blue; KBtn.BackgroundTransparency=0.5; KBtn.BorderSizePixel=0; KBtn.Text=Keys[keybindKey].Name
    KBtn.TextColor3=C.white; KBtn.TextSize=9; KBtn.Font=Enum.Font.GothamBold; guiCorner(KBtn,5)
    KBtn.MouseButton1Click:Connect(function()
        startKeyListen(KBtn,function(newKey) Keys[keybindKey]=newKey; KBtn.Text=prettyKeyName(newKey); scheduleAutoSave() end)
    end)
    local ActionBtn=Instance.new("TextButton",Row); ActionBtn.Size=UDim2.new(0.55,0,1,0)
    ActionBtn.BackgroundTransparency=1; ActionBtn.Text=""; ActionBtn.MouseButton1Click:Connect(onAction)
    local hover=Instance.new("TextButton",Row); hover.Size=UDim2.new(1,0,1,0); hover.BackgroundTransparency=1; hover.Text=""; hover.ZIndex=0
    hover.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hover.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row
end

local function addCycleRow(parent,label,value,order,onCycle)
    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; Row.Parent=parent
    guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lbl=Instance.new("TextLabel",Row); Lbl.Size=UDim2.new(0.6,0,0,16); Lbl.Position=UDim2.new(0,12,0,6)
    Lbl.BackgroundTransparency=1; Lbl.Text=label; Lbl.TextColor3=C.text; Lbl.TextSize=11; Lbl.Font=Enum.Font.GothamBold; Lbl.TextXAlignment=Enum.TextXAlignment.Left
    local CycleBtn=Instance.new("TextButton",Row); CycleBtn.Size=UDim2.new(0,60,0,22); CycleBtn.Position=UDim2.new(1,-72,0.5,-11)
    CycleBtn.BackgroundColor3=C.blue; CycleBtn.BackgroundTransparency=0.5; CycleBtn.BorderSizePixel=0; CycleBtn.Text=value
    CycleBtn.TextColor3=C.white; CycleBtn.TextSize=10; CycleBtn.Font=Enum.Font.GothamBold; guiCorner(CycleBtn,5)
    CycleBtn.MouseButton1Click:Connect(function() local newVal=onCycle(); CycleBtn.Text=newVal end)
    local hover=Instance.new("TextButton",Row); hover.Size=UDim2.new(1,0,1,0); hover.BackgroundTransparency=1; hover.Text=""; hover.ZIndex=0
    hover.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hover.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,CycleBtn
end

-- ============================================================
-- CATÉGORIES (SANS UTILS)
-- ============================================================
local Categories={"Speed","Mechanics","Movement","Visual","Settings"}
local CategoryRefs={contents={},btnsSide={},btnsBottom={},active="Speed"}

do
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
        page.Visible=(name=="Speed"); page.Parent=GuiRefs.contentFrame; CategoryRefs.contents[name]=page
        local layout=Instance.new("UIListLayout"); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,6); layout.Parent=page
    end
    for i,name in ipairs(Categories) do
        local wrapper=Instance.new("Frame"); wrapper.Size=UDim2.new(0,74,0,38); wrapper.BackgroundTransparency=1
        wrapper.LayoutOrder=i; wrapper.Parent=GuiRefs.categoryBar
        local btn=Instance.new("TextButton",wrapper); btn.Size=UDim2.new(1,0,0,28); btn.BackgroundTransparency=1
        btn.Text=name; btn.TextColor3=(name=="Speed") and C.white or C.textMuted; btn.TextSize=11
        btn.Font=Enum.Font.GothamBold; btn.BorderSizePixel=0
        local underline=Instance.new("Frame",wrapper); underline.Size=UDim2.new(0.7,0,0,2); underline.Position=UDim2.new(0.15,0,1,-4)
        underline.BackgroundColor3=C.blue; underline.BackgroundTransparency=(name=="Speed") and 0.2 or 1; underline.BorderSizePixel=0; guiCorner(underline,2)
        CategoryRefs.btnsBottom[name]=btn
        btn.MouseButton1Click:Connect(function()
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            CategoryRefs.contents[name].Visible=true; CategoryRefs.active=name
            for n,b in pairs(CategoryRefs.btnsBottom) do
                local active=(n==name); b.TextColor3=active and C.white or C.textMuted; b.BackgroundTransparency=1
                local ul=b.Parent:FindFirstChild("Frame"); if ul then ul.BackgroundTransparency=active and 0.2 or 1 end
            end
        end)
        btn.MouseEnter:Connect(function() if CategoryRefs.active~=name then tw(btn,{TextColor3=C.textDim}) end end)
        btn.MouseLeave:Connect(function() if CategoryRefs.active~=name then tw(btn,{TextColor3=C.textMuted}) end end)
    end
    if CategoryRefs.btnsBottom["Speed"] then
        CategoryRefs.btnsBottom["Speed"].TextColor3=C.white; CategoryRefs.btnsBottom["Speed"].BackgroundTransparency=1
    end
end

-- ============================================================
-- CATÉGORIES
-- ============================================================
do
    local sp=CategoryRefs.contents["Speed"]
    addSectionLabel(sp,"SPEED CONFIGURATION",0)
    addInputRow(sp,"Normal Speed",State.normalSpeed,1,function(v) State.normalSpeed=v; scheduleAutoSave() end)
    addInputRow(sp,"Carry Speed",State.carrySpeed,2,function(v) State.carrySpeed=v; scheduleAutoSave() end)
    addSectionLabel(sp,"LAGGER MODE",3)
    addInputRow(sp,"Lagger Normal Speed",State.laggerNormalSpeed,4,function(v) State.laggerNormalSpeed=v; scheduleAutoSave() end)
    addInputRow(sp,"Lagger Carry Speed",State.laggerCarrySpeed,5,function(v) State.laggerCarrySpeed=v; scheduleAutoSave() end)
    addSectionLabel(sp,"CONTROLS",6)
    addToggleRow(sp,"Carry Mode",State.speedToggled,7,"speed",function(on) State.speedToggled=on; scheduleAutoSave() end)
    addToggleRow(sp,"Lagger Mode",State.laggerModeEnabled,8,"laggerToggle",function(on) State.laggerModeEnabled=on; scheduleAutoSave() end)
end

do
    local mp=CategoryRefs.contents["Mechanics"]
    addSectionLabel(mp,"AUTO GRAB",0)
    addToggleRow(mp,"Auto Grab",CONFIG.AUTO_STEAL_ENABLED,1,nil,function(on)
        CONFIG.AUTO_STEAL_ENABLED=on
        if on then startAutoSteal() else stopAutoSteal() end
        scheduleAutoSave()
    end)
    addInputRow(mp,"Grab Radius",CONFIG.PRIME_RANGE,2,function(v)
        CONFIG.PRIME_RANGE=math.clamp(math.floor(v),5,300)
        if progressRadLbl then progressRadLbl.Text = "Radius: " .. CONFIG.PRIME_RANGE end
        scheduleAutoSave()
    end)
    addInputRow(mp,"Steal Duration",CONFIG.StealDuration,3,function(v)
        CONFIG.StealDuration = math.clamp(v, 0.05, 10)
        scheduleAutoSave()
    end)
    addSectionLabel(mp,"COMBAT",4)
    -- AUTO BAT de Noxa Hub (touche H modifiable)
    addToggleRow(mp,"Auto Bat",State.autoBatEnabled,5,"autoBat",function(on)
        if on then 
            State.autoBatEnabled = true
            autoBatEquippedThisRun = false
        else
            State.autoBatEnabled = false
            local char = LP.Character
            if char then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                if hum2 then hum2.AutoRotate = true end
            end
            resetAutoBatMotion()
        end
        scheduleAutoSave()
        if GuiToggleSetters["autoBat"] then GuiToggleSetters["autoBat"](State.autoBatEnabled) end
    end)
    addToggleRow(mp,"Auto Swing",State.autoSwingEnabled,6,nil,function(on)
        State.autoSwingEnabled=on
        scheduleAutoSave()
    end)
    addSectionLabel(mp,"MOVEMENT",7)
    addToggleRow(mp,"Auto Dodge",State.doubleJumpTpEnabled,8,"doubleJumpTp",function(on)
        if on then startDoubleJumpTpLoop() else stopDoubleJumpTpLoop() end; scheduleAutoSave()
    end)
    addSectionLabel(mp,"DEFENSE",9)
    addToggleRow(mp,"Anti Ragdoll",State.antiRagdollEnabled,10,nil,function(on)
        State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end; scheduleAutoSave()
    end)
    addToggleRow(mp,"Medusa Counter",State.medusaCounterEnabled,11,nil,function(on)
        State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; scheduleAutoSave()
    end)
end

-- ============================================================
-- MOVEMENT (avec Drop Brainrot et TP Down)
-- ============================================================
do
    local mv=CategoryRefs.contents["Movement"]
    addSectionLabel(mv,"ACTIONS",0)
    addActionRow(mv,"Drop Brainrot","dropBrainrot",function() runDropBrainrot() end,1)
    addActionRow(mv,"TP Down","tpDown",function() tpDown() end,2)
    addSectionLabel(mv,"JUMP",3)
    addToggleRow(mv,"Infinite Jump",State.infJumpEnabled,4,nil,function(on) setInfJumpInternal(on) end)
    addSectionLabel(mv,"ANIMATIONS",5)
    addToggleRow(mv,"Zombie",State.zombieModeEnabled,6,nil,function(on) setZombieMode(on) end)
    addToggleRow(mv,"Tryhard",State.tryhardAnimEnabled,7,nil,function(on)
        State.tryhardAnimEnabled=on; if on then startTryhardAnim() else stopTryhardAnim() end; scheduleAutoSave()
    end)
end

do
    local vi=CategoryRefs.contents["Visual"]
    addSectionLabel(vi,"BACKGROUND IMAGE",0)
    local BgRow=Instance.new("Frame"); BgRow.Size=UDim2.new(1,0,0,56); BgRow.BackgroundColor3=C.row
    BgRow.BackgroundTransparency=0.5; BgRow.BorderSizePixel=0; BgRow.LayoutOrder=1; BgRow.ZIndex=2; BgRow.Parent=vi
    guiCorner(BgRow,10); guiStroke(BgRow,C.divider,1)
    
    local BtnNone=Instance.new("TextButton",BgRow); BtnNone.Size=UDim2.new(0,52,0,38); BtnNone.Position=UDim2.new(0,8,0.5,-19)
    BtnNone.BackgroundColor3=C.blue; BtnNone.BackgroundTransparency=State.backgroundIndex==0 and 0.2 or 0.6
    BtnNone.BorderSizePixel=0; BtnNone.Text="None"; BtnNone.TextColor3=C.white; BtnNone.TextSize=10; BtnNone.Font=Enum.Font.GothamBold; BtnNone.ZIndex=3; guiCorner(BtnNone,7)
    local StrokeNone=guiStroke(BtnNone,State.backgroundIndex==0 and C.blue or C.divider,1.5)
    
    local function makeTransparentPreview(posX)
        local p=Instance.new("Frame",BgRow); p.Size=UDim2.new(0,90,0,38); p.Position=UDim2.new(0,posX,0.5,-19)
        p.BackgroundColor3=Color3.fromRGB(25,25,30); p.BorderSizePixel=0; guiCorner(p,7)
        local stroke=guiStroke(p,State.backgroundIndex==5 and C.blue or C.divider,1.5)
        local lbl=Instance.new("TextLabel",p); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Text="Transparent"; lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
        local btn=Instance.new("TextButton",p); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        return stroke,btn
    end
    
    local StrokeTransparent,BtnTransparent=makeTransparentPreview(68)
    
    local function updateBgButtons(index)
        tw(BtnNone,{BackgroundTransparency=index==0 and 0.2 or 0.6})
        StrokeNone.Color=index==0 and C.blue or C.divider
        StrokeTransparent.Color=index==5 and C.blue or C.divider
    end
    
    local function applyBg(index)
        State.backgroundIndex=index
        State.backgroundEnabled=(index~=0)
        if index==0 then
            if GuiRefs.backgroundImage then GuiRefs.backgroundImage.Visible=false end
            if GuiRefs.bgGrad then GuiRefs.bgGrad.Visible=true end
            GuiRefs.inner.BackgroundTransparency = 0
        elseif index==5 then
            local imgId=BG_IMAGES[5]
            if GuiRefs.backgroundImage and imgId then 
                GuiRefs.backgroundImage.Image="rbxassetid://"..imgId
                GuiRefs.backgroundImage.Visible=true
                GuiRefs.backgroundImage.BackgroundTransparency = 1
                GuiRefs.inner.BackgroundTransparency = 0.5
                GuiRefs.bgGrad.Visible = false
            end
        end
        updateBgButtons(index)
        scheduleAutoSave()
    end
    
    BtnNone.MouseButton1Click:Connect(function() applyBg(0) end)
    BtnTransparent.MouseButton1Click:Connect(function() applyBg(5) end)
    
    BgRow.MouseEnter:Connect(function() tw(BgRow,{BackgroundTransparency=0.3}) end)
    BgRow.MouseLeave:Connect(function() tw(BgRow,{BackgroundTransparency=0.5}) end)

    -- ============================================================
    -- LES 5 FONCTIONS DANS VISUAL (Stretch Rez, Remove Accessories, Dark Mode, Anti Lag)
    -- ============================================================
    addSectionLabel(vi,"STRETCH REZ",2)
    addToggleRow(vi,"Stretch Rez",State.stretchRezEnabled,3,nil,function(on)
        if on then enableStretchRez() else disableStretchRez() end
        scheduleAutoSave()
        if GuiToggleSetters["stretchRez"] then GuiToggleSetters["stretchRez"](State.stretchRezEnabled) end
    end)

    addSectionLabel(vi,"REMOVE ACCESSORIES",4)
    addToggleRow(vi,"Remove Accessories",State.removeAccessoriesEnabled,5,nil,function(on)
        if on then enableRemoveAccessories() else disableRemoveAccessories() end
        scheduleAutoSave()
        if GuiToggleSetters["removeAccessories"] then GuiToggleSetters["removeAccessories"](State.removeAccessoriesEnabled) end
    end)

    addSectionLabel(vi,"DARK MODE",6)
    addToggleRow(vi,"Dark Mode",State.darkModeEnabled,7,nil,function(on)
        if on then enableDarkMode() else disableDarkMode() end
        scheduleAutoSave()
        if GuiToggleSetters["darkMode"] then GuiToggleSetters["darkMode"](State.darkModeEnabled) end
    end)

    addSectionLabel(vi,"PERFORMANCE",8)
    addToggleRow(vi,"Anti Lag",State.antiLagEnabled,9,nil,function(on)
        if on then enableAntiLag() else disableAntiLag() end
        scheduleAutoSave()
        if GuiToggleSetters["antiLag"] then GuiToggleSetters["antiLag"](State.antiLagEnabled) end
    end)
end

-- ============================================================
-- SETTINGS (avec  AUTO BAT DESYNC au-dessus de ACTIONS)
-- ============================================================

-- ============================================================
--  AUTO BAT DESYNC (intégré dans Settings)
-- ============================================================
local EnvyState = {
    autoBatToggled = false,
    hittingCooldown = false,
    guiVisible = true,
    mobileMode = false,
    batHr = nil,
    batH = nil,
}

local EnvyKeys = {
    autoBat = Enum.KeyCode.X,
    autoBatType = "Keyboard",
    guiHide = Enum.KeyCode.LeftControl,
}

local function saveEnvyConfig()
    local cfg = {
        autoBatKey = EnvyKeys.autoBat.Name,
        autoBatKeyType = EnvyKeys.autoBatType,
        mobileMode = EnvyState.mobileMode,
    }
    pcall(function()
        if writefile then
            writefile("EnvyAutoBatDesyncConfig.json", HttpService:JSONEncode(cfg))
        end
    end)
end

local function loadEnvyConfig()
    local hasFile = false
    pcall(function() hasFile = isfile("EnvyAutoBatDesyncConfig.json") end)
    if not hasFile then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile("EnvyAutoBatDesyncConfig.json"))
    end)
    if not ok or not cfg then return end
    if cfg.autoBatKey and Enum.KeyCode[cfg.autoBatKey] then
        EnvyKeys.autoBat = Enum.KeyCode[cfg.autoBatKey]
    end
    if cfg.autoBatKeyType then
        EnvyKeys.autoBatType = cfg.autoBatKeyType
    end
    if cfg.mobileMode ~= nil then
        EnvyState.mobileMode = cfg.mobileMode
    end
end

loadEnvyConfig()

local function getBatEnvy()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function tryHitBatEnvy()
    if EnvyState.hittingCooldown then return end
    EnvyState.hittingCooldown = true
    pcall(function()
        local bat = getBatEnvy()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() EnvyState.hittingCooldown = false end)
end

local function getClosestPlayerEnvy()
    local hrp = EnvyState.batHr
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then
                    cd = d
                    cp = p
                end
            end
        end
    end
    return cp, cd
end

local function setupCharEnvy(char)
    task.wait(0.1)
    EnvyState.batH = char:WaitForChild("Humanoid", 5)
    EnvyState.batHr = char:WaitForChild("HumanoidRootPart", 5)
end

LP.CharacterAdded:Connect(setupCharEnvy)
if LP.Character then task.spawn(function() setupCharEnvy(LP.Character) end) end

-- Heartbeat ENVY
RunService.Heartbeat:Connect(function()
    if not (EnvyState.autoBatToggled and EnvyState.batH and EnvyState.batHr) then return end
    local target, dist = getClosestPlayerEnvy()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                sethiddenproperty(EnvyState.batHr, "PhysicsRepRootPart", tr)
            end
            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if (EnvyState.batHr.Position - targetPos).Magnitude > 8 then
                EnvyState.batHr.CFrame = CFrame.new(targetPos)
            end
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
            tryHitBatEnvy()
        end
    end
end)

-- ============================================================
-- SETTINGS (avec ENVY AUTO BAT DESYNC en premier)
-- ============================================================
do
    local sg=CategoryRefs.contents["Settings"]

    -- ============================================================
    -- ENVY AUTO BAT DESYNC (en premier dans Settings)
    -- ============================================================
    addSectionLabel(sg,"TP BAT DESYNC",0)

    -- Mode toggle (PC/Mobile) - Style original
    local envyModeRow=Instance.new("Frame"); envyModeRow.Size=UDim2.new(1,0,0,32)
    envyModeRow.BackgroundColor3=C.row; envyModeRow.BackgroundTransparency=0.5; envyModeRow.BorderSizePixel=0
    envyModeRow.LayoutOrder=1; envyModeRow.Parent=sg; guiCorner(envyModeRow,10); guiStroke(envyModeRow,C.divider,1)

    local envyModeLbl=Instance.new("TextLabel",envyModeRow); envyModeLbl.Size=UDim2.new(0.5,0,1,0)
    envyModeLbl.Position=UDim2.new(0,12,0,0); envyModeLbl.BackgroundTransparency=1; envyModeLbl.Text="Mode"
    envyModeLbl.TextColor3=C.text; envyModeLbl.TextSize=11; envyModeLbl.Font=Enum.Font.GothamBold; envyModeLbl.TextXAlignment=Enum.TextXAlignment.Left

    local envyModeBtn=Instance.new("TextButton",envyModeRow)
    envyModeBtn.Size=UDim2.new(0,70,0,22); envyModeBtn.Position=UDim2.new(1,-82,0.5,-11)
    envyModeBtn.BackgroundColor3=C.blueDark; envyModeBtn.BackgroundTransparency=0.4
    envyModeBtn.BorderSizePixel=0; envyModeBtn.Text=EnvyState.mobileMode and "V1" or "V2"
    envyModeBtn.TextColor3=C.white; envyModeBtn.TextSize=9; envyModeBtn.Font=Enum.Font.GothamBold
    guiCorner(envyModeBtn,5); guiStroke(envyModeBtn,C.divider,1)

    envyModeBtn.MouseButton1Click:Connect(function()
        EnvyState.mobileMode = not EnvyState.mobileMode
        envyModeBtn.Text = EnvyState.mobileMode and "V1" or "V2"
        saveEnvyConfig()
        TweenService:Create(envyModeBtn,TweenInfo.new(0.15),{BackgroundColor3=C.blue}):Play()
        task.wait(0.15)
        TweenService:Create(envyModeBtn,TweenInfo.new(0.15),{BackgroundColor3=C.blueDark}):Play()
    end)

    -- Toggle ENVY Auto Bat
    local envyRow=Instance.new("Frame"); envyRow.Size=UDim2.new(1,0,0,32)
    envyRow.BackgroundColor3=C.row; envyRow.BackgroundTransparency=0.5; envyRow.BorderSizePixel=0
    envyRow.LayoutOrder=2; envyRow.Parent=sg; guiCorner(envyRow,10); guiStroke(envyRow,C.divider,1)

    local envyLbl=Instance.new("TextLabel",envyRow); envyLbl.Size=UDim2.new(0.55,0,1,0)
    envyLbl.Position=UDim2.new(0,12,0,0); envyLbl.BackgroundTransparency=1; envyLbl.Text="TP Bat"
    envyLbl.TextColor3=C.text; envyLbl.TextSize=11; envyLbl.Font=Enum.Font.GothamBold; envyLbl.TextXAlignment=Enum.TextXAlignment.Left

    -- Toggle pill
    local envyPillBg=Instance.new("Frame",envyRow)
    envyPillBg.Size=UDim2.new(0,36,0,19); envyPillBg.Position=UDim2.new(1,-46,0.5,-9.5)
    envyPillBg.BackgroundColor3=EnvyState.autoBatToggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(16,16,16)
    envyPillBg.BorderSizePixel=0
    Instance.new("UICorner",envyPillBg).CornerRadius=UDim.new(0,10)
    local envyPStroke=Instance.new("UIStroke",envyPillBg); envyPStroke.Color=EnvyState.autoBatToggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(50,50,50)
    local envyDot=Instance.new("Frame",envyPillBg)
    envyDot.Size=UDim2.new(0,13,0,13); envyDot.Position=EnvyState.autoBatToggled and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)
    envyDot.BackgroundColor3=EnvyState.autoBatToggled and Color3.fromRGB(0,0,0) or Color3.fromRGB(45,45,45)
    envyDot.BorderSizePixel=0
    Instance.new("UICorner",envyDot).CornerRadius=UDim.new(0,4)

    local envyToggleBtn=Instance.new("TextButton",envyRow)
    envyToggleBtn.Size=UDim2.new(0.45,0,1,0)
    envyToggleBtn.Position=UDim2.new(0.55,0,0,0)
    envyToggleBtn.BackgroundTransparency=1
    envyToggleBtn.Text=""

    envyToggleBtn.MouseButton1Click:Connect(function()
        EnvyState.autoBatToggled=not EnvyState.autoBatToggled
        TweenService:Create(envyPillBg,TweenInfo.new(0.18),{BackgroundColor3=EnvyState.autoBatToggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(16,16,16)}):Play()
        TweenService:Create(envyPStroke,TweenInfo.new(0.18),{Color=EnvyState.autoBatToggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(50,50,50)}):Play()
        TweenService:Create(envyDot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=EnvyState.autoBatToggled and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5),
            BackgroundColor3=EnvyState.autoBatToggled and Color3.fromRGB(0,0,0) or Color3.fromRGB(45,45,45)
        }):Play()
        saveEnvyConfig()
    end)

    -- Keybind ENVY
    local envyKeyRow=Instance.new("Frame"); envyKeyRow.Size=UDim2.new(1,0,0,32)
    envyKeyRow.BackgroundColor3=C.row; envyKeyRow.BackgroundTransparency=0.5; envyKeyRow.BorderSizePixel=0
    envyKeyRow.LayoutOrder=3; envyKeyRow.Parent=sg; guiCorner(envyKeyRow,10); guiStroke(envyKeyRow,C.divider,1)

    local envyKeyLbl=Instance.new("TextLabel",envyKeyRow); envyKeyLbl.Size=UDim2.new(0.5,0,1,0)
    envyKeyLbl.Position=UDim2.new(0,12,0,0); envyKeyLbl.BackgroundTransparency=1; envyKeyLbl.Text="Keybind"
    envyKeyLbl.TextColor3=C.text; envyKeyLbl.TextSize=11; envyKeyLbl.Font=Enum.Font.GothamBold; envyKeyLbl.TextXAlignment=Enum.TextXAlignment.Left

    local envyKeyBtn=Instance.new("TextButton",envyKeyRow)
    envyKeyBtn.Size=UDim2.new(0,45,0,22); envyKeyBtn.Position=UDim2.new(1,-52,0.5,-11)
    envyKeyBtn.BackgroundColor3=C.blue; envyKeyBtn.BackgroundTransparency=0.5
    envyKeyBtn.BorderSizePixel=0; envyKeyBtn.Text=EnvyKeys.autoBat.Name; envyKeyBtn.TextColor3=C.white
    envyKeyBtn.TextSize=9; envyKeyBtn.Font=Enum.Font.GothamBold; guiCorner(envyKeyBtn,5)

    local envyKListening=false
    local envyKConn=nil

    local function stopEnvyListen(key)
        envyKListening=false
        if envyKConn then envyKConn:Disconnect(); envyKConn=nil end
        if key then 
            EnvyKeys.autoBat=key
            envyKeyBtn.Text=key.Name
            saveEnvyConfig()
        end
    end

    envyKeyBtn.MouseButton1Click:Connect(function()
        if envyKListening then stopEnvyListen(nil); return end
        envyKListening=true
        envyKeyBtn.Text="..."
        envyKConn=UIS.InputBegan:Connect(function(inp)
            if not envyKListening then return end
            if inp.UserInputType==Enum.UserInputType.Keyboard then
                if inp.KeyCode==Enum.KeyCode.Escape then stopEnvyListen(nil); return end
                EnvyKeys.autoBatType="Keyboard"
                stopEnvyListen(inp.KeyCode)
            elseif inp.UserInputType==Enum.UserInputType.Gamepad1 then
                EnvyKeys.autoBatType="Gamepad"
                stopEnvyListen(inp.KeyCode)
            end
        end)
    end)

    -- ============================================================
    -- ACTIONS (Reset)
    -- ============================================================
    addSectionLabel(sg,"ACTIONS",4)
    addActionRow(sg,"Reset","instaReset",function() doInstaReset() end,5)

    -- ============================================================
    -- GUI
    -- ============================================================
    addSectionLabel(sg,"GUI",6)
    addToggleRow(sg,"Lagger GUI",State.bypassGuiVisible,7,nil,function(on)
        State.bypassGuiVisible=on; if BypassGuiRef then BypassGuiRef.Enabled=on end; scheduleAutoSave()
    end)

    local guiRow=Instance.new("Frame"); guiRow.Size=UDim2.new(1,0,0,42); guiRow.BackgroundColor3=C.row
    guiRow.BackgroundTransparency=0.5; guiRow.BorderSizePixel=0; guiRow.LayoutOrder=8; guiRow.Parent=sg
    guiCorner(guiRow,10); guiStroke(guiRow,C.divider,1)
    local guiRowLbl=Instance.new("TextLabel",guiRow); guiRowLbl.Size=UDim2.new(0.6,0,0,16); guiRowLbl.Position=UDim2.new(0,12,0,8)
    guiRowLbl.BackgroundTransparency=1; guiRowLbl.Text="Hide GUI Key"; guiRowLbl.TextColor3=C.text; guiRowLbl.TextSize=11; guiRowLbl.Font=Enum.Font.GothamBold; guiRowLbl.TextXAlignment=Enum.TextXAlignment.Left
    local guiKBtn=Instance.new("TextButton",guiRow); guiKBtn.Size=UDim2.new(0,45,0,22); guiKBtn.Position=UDim2.new(1,-52,0.5,-11)
    guiKBtn.BackgroundColor3=C.blue; guiKBtn.BackgroundTransparency=0.5; guiKBtn.BorderSizePixel=0; guiKBtn.Text=Keys.guiHide.Name
    guiKBtn.TextColor3=C.white; guiKBtn.TextSize=9; guiKBtn.Font=Enum.Font.GothamBold; guiCorner(guiKBtn,5)
    guiKBtn.MouseButton1Click:Connect(function()
        startKeyListen(guiKBtn,function(newKey) Keys.guiHide=newKey; guiKBtn.Text=prettyKeyName(newKey); scheduleAutoSave() end)
    end)
end

-- ============================================================
-- GESTION DES TOUCHES NOXA HUB
-- ============================================================
UIS.InputBegan:Connect(function(inp,gp)
    if gp or KeyListen.active then return end
    local keyCode=inp.KeyCode
    if keyCode==Keys.guiHide then
        GuiRefs.outer.Visible=not GuiRefs.outer.Visible
        if GuiRefs.reopenBtn then GuiRefs.reopenBtn.Enabled=not GuiRefs.outer.Visible end
    elseif keyCode==Keys.speed then
        State.speedToggled=not State.speedToggled; scheduleAutoSave()
        if GuiToggleSetters["speed"] then GuiToggleSetters["speed"](State.speedToggled) end
    elseif keyCode==Keys.dropBrainrot then runDropBrainrot()
    elseif keyCode==Keys.tpDown then tpDown()
    elseif keyCode==Keys.laggerToggle then
        State.laggerModeEnabled=not State.laggerModeEnabled; scheduleAutoSave()
        if GuiToggleSetters["laggerToggle"] then GuiToggleSetters["laggerToggle"](State.laggerModeEnabled) end
    elseif keyCode==Keys.instaReset then task.spawn(doInstaReset)
    elseif keyCode==Keys.doubleJumpTp then toggleDoubleJumpTp()
    elseif keyCode==Keys.autoBat then
        -- Auto Bat de Noxa Hub (touche H modifiable)
        toggleAutoBat()
    end
    
    -- ENVY AUTO BAT DESYNC keybind
    if keyCode==EnvyKeys.autoBat then
        EnvyState.autoBatToggled=not EnvyState.autoBatToggled
        saveEnvyConfig()
    end
end)

do
    local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
    RunService.RenderStepped:Connect(function()
        local h,hrp,lbl=CharRefs.humanoid,CharRefs.hrp,CharRefs.speedLabel
        if not (h and hrp) then return end
        if State.tpInProgress then return end
        local md=h.MoveDirection; local spd=getCurrentSpeed()
        if md.Magnitude>0 then
            State.lastMoveDir=md; hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then hrp.Velocity=Vector3.new(State.lastMoveDir.X*spd,hrp.Velocity.Y,State.lastMoveDir.Z*spd) end
        end
        if lbl then lbl.Text="Speed: "..string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
    end)
end

do
    local trackedPlayers={}
    local function disableCanCollide(part) if part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end end
    local function trackCharacter(character)
        for _,part in pairs(character:GetChildren()) do disableCanCollide(part) end
        character.ChildAdded:Connect(function(child) disableCanCollide(child) end)
    end
    local function trackPlayer(player)
        if player==LP then return end
        if player.Character then trackCharacter(player.Character) end
        player.CharacterAdded:Connect(trackCharacter); trackedPlayers[player]=true
    end
    for _,player in pairs(Players:GetPlayers()) do trackPlayer(player) end
    Players.PlayerAdded:Connect(trackPlayer)
    RunService.RenderStepped:Connect(function()
        for player,_ in pairs(trackedPlayers) do
            local character=player.Character
            if character then for _,part in pairs(character:GetChildren()) do disableCanCollide(part) end end
        end
    end)
end

local realPingMs=0
do
    local clock=0
    RunService.RenderStepped:Connect(function(dt)
        clock=clock+dt
        if clock>=0.5 then
            clock=0; local fps=math.floor(1/dt)
            if GuiRefs.pingFpsLbl then GuiRefs.pingFpsLbl.Text=string.format("",realPingMs,fps) end
        end
    end)
    task.spawn(function()
        while true do
            pcall(function()
                local ok,val=pcall(function() return LP.Ping end)
                if ok and type(val)=="number" and val>0 then realPingMs=val end
            end)
            task.wait(0.5)
        end
    end)
end

task.wait(0.1); task.wait(0.5)

if GuiRefs and GuiRefs.backgroundImage then
    if State.backgroundIndex==0 then
        GuiRefs.backgroundImage.Visible=false
        if GuiRefs.bgGrad then GuiRefs.bgGrad.Visible=true end
        GuiRefs.inner.BackgroundTransparency = 0
    elseif State.backgroundIndex==5 then
        local imgId=BG_IMAGES[5]
        if imgId then 
            GuiRefs.backgroundImage.Image="rbxassetid://"..imgId
            GuiRefs.backgroundImage.Visible=true
            GuiRefs.backgroundImage.BackgroundTransparency = 1
            GuiRefs.inner.BackgroundTransparency = 0.5
            if GuiRefs.bgGrad then GuiRefs.bgGrad.Visible=false end
        end
    end
end

setSkyMode(State.skyMode)

-- ============================================================
-- RÉACTIVATION DES FONCTIONS AU DÉMARRAGE
-- ============================================================
if CONFIG.AUTO_STEAL_ENABLED then 
    task.wait(0.5)
    startAutoSteal() 
end
if State.infJumpEnabled then 
    task.wait(0.3)
    setInfJumpInternal(true) 
end
if State.antiRagdollEnabled then 
    task.wait(0.3)
    startAntiRagdoll() 
end
if State.medusaCounterEnabled then 
    task.wait(0.3)
    setupMedusaCounter(LP.Character) 
end
if State.zombieModeEnabled then 
    task.wait(0.3)
    setZombieMode(true) 
end
if State.tryhardAnimEnabled then 
    task.wait(0.3)
    startTryhardAnim() 
end
if State.doubleJumpTpEnabled then 
    task.wait(0.3)
    startDoubleJumpTpLoop() 
end
if State.laggerModeEnabled then
    task.wait(0.3)
    toggleLaggerMode()
end
if State.autoBatEnabled then
    task.wait(0.3)
    autoBatEquippedThisRun = false
end
if State.stretchRezEnabled then
    task.wait(0.3)
    enableStretchRez()
end
if State.removeAccessoriesEnabled then
    task.wait(0.3)
    enableRemoveAccessories()
end
if State.darkModeEnabled then
    task.wait(0.3)
    enableDarkMode()
end
if State.antiLagEnabled then
    task.wait(0.3)
    enableAntiLag()
end

setupEnemySpeedDisplay()

print("==========================================")
print("AUTO GRAB ACE - Version finale !")
print("5ème IMAGE = TRANSPARENT (UNIQUEMENT NONE ET TRANSPARENT)")
print("TOUT LE ROSE REMPLACÉ PAR DU BLANC")
print("CUSTOM SKY SUPPRIMÉ")
print("TITRE NOXA | HUB DESCENDU")
print("LES 5 FONCTIONS DANS VISUAL")
print("Space HUB - Auto Bat = H (modifiable)")
print("SPACE LAGGER SUPPRIMÉ - Seul le mode Lagger reste")
print("ANTI LAG SAUVEGARDÉ")
print("ENVY AUTO BAT DESYNC DANS SETTINGS")
print("Drop Brainrot et TP Down dans Movement")
print("Reset dans Settings")
print("==========================================")