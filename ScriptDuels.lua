local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
-- ============================================================
-- KICK WARNING
-- ============================================================
local kickWarningEnabled = (_G._AdaptKickWarningEnabled ~= false)

local function initKickWarning()
    _G._AdaptKickWarningEnabled = kickWarningEnabled ~= false

    if _G._AdaptKickWarning and type(_G._AdaptKickWarning.Destroy) == "function" then
        pcall(_G._AdaptKickWarning.Destroy)
    end

    local playerGui = LP:WaitForChild("PlayerGui")
    local RunService = game:GetService("RunService")
    local DURATION = 2.0
    local DESTROYED = false
    local WARNING_VISIBLE = false
    local WAS_HOLDING = false
    local warningConnection = nil
    local cameraConnection = nil

    local oldGui = playerGui:FindFirstChild("AdaptKickWarning")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdaptKickWarning"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "KickTimerBanner"
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ClipsDescendants = true
    frame.ZIndex = 100
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(255, 0, 0)
    frameStroke.Thickness = 2
    frameStroke.Transparency = 0.05

    local warningIcon = Instance.new("TextLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.fromOffset(34, 34)
    warningIcon.Position = UDim2.new(0, 10, 0.5, -17)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠️"
    warningIcon.TextColor3 = Color3.fromRGB(255, 0, 0)
    warningIcon.Font = Enum.Font.GothamBlack
    warningIcon.TextSize = 23
    warningIcon.TextXAlignment = Enum.TextXAlignment.Center
    warningIcon.TextYAlignment = Enum.TextYAlignment.Center
    warningIcon.ZIndex = 104
    warningIcon.Parent = frame

    local readyFill = Instance.new("Frame")
    readyFill.Name = "ReadyFill"
    readyFill.Size = UDim2.fromScale(1, 1)
    readyFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    readyFill.BackgroundTransparency = 1
    readyFill.BorderSizePixel = 0
    readyFill.ZIndex = 101
    readyFill.Parent = frame
    Instance.new("UICorner", readyFill).CornerRadius = UDim.new(1, 0)

    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressBorderPath"
    progressContainer.BackgroundTransparency = 1
    progressContainer.Size = UDim2.fromScale(1,1)
    progressContainer.ClipsDescendants = true
    progressContainer.ZIndex = 102
    progressContainer.Parent = frame
    Instance.new("UICorner", progressContainer).CornerRadius = UDim.new(1, 0)

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "WarningText"
    textLabel.Size = UDim2.new(1,-70,1,0)
    textLabel.Position = UDim2.new(0,45,0,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "KICK WARNING"
    textLabel.TextColor3 = Color3.fromRGB(255,0,0)
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.ZIndex = 103
    textLabel.Parent = frame

    local bannerWidth, bannerHeight, segmentHeight = 280, 44, 3
    local progressSegments, currentSegment = {}, 0

    local function clearSegments()
        for _,seg in ipairs(progressSegments) do if seg and seg.Parent then seg:Destroy() end end
        progressSegments, currentSegment = {}, 0
    end

    local function buildPath()
        clearSegments()
        local borderOffset, halfWidth = 2, bannerWidth*0.5
        local centerY = bannerHeight*0.5
        local innerWidth = math.max(3,(bannerHeight-4)*0.5)
        local arcRadius = math.max(3,(bannerHeight-4)*0.5)
        local leftStart = borderOffset + innerWidth
        local straightLength = bannerWidth-borderOffset-innerWidth-arcRadius
        local arcLength = math.pi*arcRadius
        local totalLength = straightLength*2+arcLength*2
        local count = math.clamp(math.ceil(totalLength/4),72,180)
        local size = totalLength/count+1.25
        for i=1,count do
            local d=(i-0.5)/count*totalLength
            local x,y,r
            if d<=straightLength then
                x=leftStart+d; y=borderOffset; r=0
            elseif d<=straightLength+arcLength then
                local a=-math.pi/2+(d-straightLength)/arcRadius
                x=bannerWidth-borderOffset-arcRadius+math.cos(a)*arcRadius
                y=centerY+math.sin(a)*arcRadius; r=a+math.pi/2
            elseif d<=straightLength*2+arcLength then
                x=bannerWidth-d+straightLength+arcLength; y=bannerHeight-borderOffset; r=math.pi
            else
                local a=math.pi/2+(d-straightLength*2-arcLength)/arcRadius
                x=leftStart+math.cos(a)*arcRadius; y=centerY+math.sin(a)*arcRadius; r=a+math.pi/2
            end
            local seg=Instance.new("Frame")
            seg.Name="ProgressSegment"; seg.AnchorPoint=Vector2.new(.5,.5)
            seg.Position=UDim2.fromOffset(x,y); seg.Size=UDim2.fromOffset(size,segmentHeight)
            seg.Rotation=math.deg(r); seg.BackgroundColor3=Color3.fromRGB(255,0,0)
            seg.BackgroundTransparency=1; seg.BorderSizePixel=0; seg.ZIndex=102; seg.Parent=progressContainer
            Instance.new("UICorner",seg).CornerRadius=UDim.new(1,0)
            progressSegments[i]=seg
        end
    end

    local function resetProgress()
        readyFill.BackgroundTransparency=1; currentSegment=0
        for _,seg in ipairs(progressSegments) do if seg then seg.BackgroundTransparency=1 end end
    end

    local function updateProgress(v)
        local count=#progressSegments; if count==0 then return end
        local target=math.clamp(math.floor(math.clamp(v,0,1)*count+.5),0,count)
        if target<currentSegment then
            for i=target+1,currentSegment do if progressSegments[i] then progressSegments[i].BackgroundTransparency=1 end end
        elseif currentSegment<target then
            for i=currentSegment+1,target do if progressSegments[i] then progressSegments[i].BackgroundTransparency=0 end end
        end
        currentSegment=target
    end

    local function resize()
        local cam=workspace.CurrentCamera
        local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
        bannerWidth=math.clamp(math.floor(vp.X*.22),240,300)
        frame.Size=UDim2.fromOffset(bannerWidth,bannerHeight)
        buildPath()
        if not frame.Visible then
            resetProgress(); frame.Position=UDim2.new(.5,0,0,-bannerHeight-10)
        end
    end

    local function hide()
        if warningConnection then warningConnection:Disconnect(); warningConnection=nil end
        if frame.Parent then
            frame.Visible=false; resetProgress(); frame.Position=UDim2.new(.5,0,0,-bannerHeight-10)
        end
        WARNING_VISIBLE=false
    end

    local function holding()
        if type(_G._AdaptSafeModeHoldingBrainrot)=="function" then
            local ok,result=pcall(_G._AdaptSafeModeHoldingBrainrot)
            if ok and result then return true end
        end
        if LP:GetAttribute("Stealing")==true then return true end
        local character=LP.Character
        if not character then return false end
        for _,child in ipairs(character:GetChildren()) do
            local name=child.Name:lower()
            if name:find("brainrot") or name:find("brain") or name:find("animal") or name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then return true end
        end
        for attributeName,attributeValue in pairs(character:GetAttributes()) do
            local name=tostring(attributeName):lower()
            if attributeValue==true and (name:find("carrying") or name:find("carry") or name:find("stealing") or name:find("isstealing") or name:find("hasbrainrot")) then return true end
        end
        local humanoid=character:FindFirstChildOfClass("Humanoid")
        return humanoid~=nil and humanoid.WalkSpeed>0 and humanoid.WalkSpeed<=25 and humanoid.WalkSpeed~=16
    end

    local function enabled() return _G._AdaptKickWarningEnabled~=false end

    local function show()
        if DESTROYED or not enabled() or WARNING_VISIBLE then return end
        WARNING_VISIBLE=true; resize(); resetProgress(); textLabel.Text="KICK WARNING"; textLabel.TextColor3=Color3.fromRGB(255,0,0); frame.Visible=true
        frame.Position=UDim2.new(.5,0,0,-bannerHeight-10)
        TweenService:Create(frame,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(.5,0,0,14)}):Play()
        local start=tick(); local completed=false
        if warningConnection then warningConnection:Disconnect() end
        warningConnection=RunService.RenderStepped:Connect(function()
            if DESTROYED then hide(); return end
            if not enabled() then hide(); return end
            if not frame.Parent then if warningConnection then warningConnection:Disconnect(); warningConnection=nil end; return end
            local progress=math.clamp((tick()-start)/DURATION,0,1); updateProgress(progress)
            if progress>=1 and not completed then
                completed=true
                if warningConnection then warningConnection:Disconnect(); warningConnection=nil end
                readyFill.BackgroundTransparency=0
                for _,seg in ipairs(progressSegments) do seg.BackgroundTransparency=0 end
                textLabel.Text="STEAL"; textLabel.TextColor3=Color3.fromRGB(0,255,0)
                warningIcon.TextColor3=Color3.fromRGB(0,255,0)
                task.delay(2.5,function()
                    if DESTROYED then return end
                    if not enabled() then hide(); return end
                    TweenService:Create(frame,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(.5,0,0,-bannerHeight-10)}):Play()
                    task.delay(.45,function() if not DESTROYED then frame.Visible=false; WARNING_VISIBLE=false end end)
                end)
            end
        end)
    end

    local function setEnabled(value)
        _G._AdaptKickWarningEnabled=value==true
        kickWarningEnabled=_G._AdaptKickWarningEnabled
        if not kickWarningEnabled then hide(); WAS_HOLDING=false end
        return kickWarningEnabled
    end

    local function destroy()
        DESTROYED=true; hide()
        if cameraConnection then cameraConnection:Disconnect(); cameraConnection=nil end
        if screenGui.Parent then screenGui:Destroy() end
        if _G._AdaptKickWarning then _G._AdaptKickWarning=nil end
    end

    _G._AdaptKickWarning={SetDuration=function(v) local n=tonumber(v); if n and n>0 then DURATION=n end end,GetDuration=function() return DURATION end,SetEnabled=setEnabled,IsEnabled=enabled,Show=show,Hide=hide,Destroy=destroy}
    resize()
    local cam=workspace.CurrentCamera
    if cam then cameraConnection=cam:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    setEnabled(kickWarningEnabled)
    task.spawn(function()
        while not DESTROYED and screenGui.Parent do
            if enabled() then
                local h=holding()
                if not WAS_HOLDING and h then show() end
                WAS_HOLDING=h
            else
                if WARNING_VISIBLE then hide() end
                WAS_HOLDING=false
            end
            task.wait(.1)
        end
    end)
end

initKickWarning()


if _G.LustHubRunning then return end
_G.LustHubRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
local ContentProvider = game:GetService("ContentProvider")

-- ============================================================
-- BLAZZEN DUELS THEME (bordes rojos, letras rojas, fondo Limosna)
-- ============================================================
local BLAZZEN_RED = Color3.fromRGB(255, 0, 0)
local BLAZZEN_BG_IMAGE = (function()
    local ok, asset = pcall(function() return getcustomasset("Limosna.jpg") end)
    if ok and type(asset) == "string" then return asset end
    return nil
end)()

local function _blazzenStyleButton(btn)
    if not btn or not btn:IsA("TextButton") then return end
    if btn:GetAttribute("BlazzenStyled") == true then return end
    btn:SetAttribute("BlazzenStyled", true)
    btn:SetAttribute("BlazzenOrigBg", btn.BackgroundColor3)
    btn:SetAttribute("BlazzenOrigTextColor", btn.TextColor3)

    -- Quitar bordes morados/existentes
    for _, c in ipairs(btn:GetChildren()) do
        if c:IsA("UIStroke") then c:Destroy() end
    end

    -- Borde rojo
    local stroke = Instance.new("UIStroke")
    stroke.Name = "BlazzenBorder"
    stroke.Color = BLAZZEN_RED
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    -- Letras rojas
    btn.TextColor3 = BLAZZEN_RED

    -- Fondo Limosna
    if BLAZZEN_BG_IMAGE then
        local img = Instance.new("ImageLabel")
        img.Name = "BlazzenBg"
        img.Size = UDim2.fromScale(1, 1)
        img.Position = UDim2.fromScale(0, 0)
        img.BackgroundTransparency = 1
        img.BorderSizePixel = 0
        img.Image = BLAZZEN_BG_IMAGE
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 0
        img.Parent = btn
        if btn.BackgroundTransparency < 0.5 then
            btn.BackgroundTransparency = 0.55
        end
    end

    -- Activo = rojo (detecta cambio de color del setter)
    btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local orig = btn:GetAttribute("BlazzenOrigBg")
        local current = btn.BackgroundColor3
        if current == orig or current == BLAZZEN_RED then return end
        task.defer(function()
            if btn.Parent and btn.BackgroundColor3 ~= orig and btn.BackgroundColor3 ~= BLAZZEN_RED then
                btn.BackgroundColor3 = BLAZZEN_RED
            end
        end)
    end)
end

local function _blazzenScan(root)
    if not root then return end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextButton") then
            _blazzenStyleButton(obj)
        end
    end
end

task.spawn(function()
    local pg = LP:WaitForChild("PlayerGui", 30)
    if not pg then return end
    _blazzenScan(pg)
    pg.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") then
            task.defer(function()
                if obj.Parent then _blazzenStyleButton(obj) end
            end)
        end
    end)
    while pg.Parent do
        task.wait(1.5)
        _blazzenScan(pg)
    end
end)
-- ============================================================

local CONFIG_FILE = "BlazzenDuels_Config.json"
local BUTTON_POS_FILE = "BlazzenDuels_ButtonPositions.json"

local function _getFileFn(name)
    local direct = rawget(_G, name)
    if type(direct) == "function" then return direct end
    if syn and type(syn[name]) == "function" then return syn[name] end
    if fluxus and type(fluxus[name]) == "function" then return fluxus[name] end
    if getgenv then
        local env = getgenv()
        if type(env[name]) == "function" then return env[name] end
    end
end
local _ace_readfile = _getFileFn("readfile")
local _ace_writefile = _getFileFn("writefile")
local _ace_delfile = _getFileFn("delfile")
local _ace_isfile = _getFileFn("isfile")
if type(_ace_isfile) ~= "function" then
    _ace_isfile = function(path)
        if type(_ace_readfile) ~= "function" then return false end
        local ok, result = pcall(_ace_readfile, path)
        return ok and type(result) == "string"
    end
end
local canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

local function refreshFileApis()
    if type(_ace_readfile) ~= "function" then _ace_readfile = _getFileFn("readfile") end
    if type(_ace_writefile) ~= "function" then _ace_writefile = _getFileFn("writefile") end
    if type(_ace_delfile) ~= "function" then _ace_delfile = _getFileFn("delfile") end
    if type(_ace_isfile) ~= "function" then
        _ace_isfile = _getFileFn("isfile")
        if type(_ace_isfile) ~= "function" then
            _ace_isfile = function(path)
                if type(_ace_readfile) ~= "function" then return false end
                local ok, result = pcall(_ace_readfile, path)
                return ok and type(result) == "string"
            end
        end
    end
    canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")
    return canSaveConfig
end

local function loadDedicatedButtonPositions()
    refreshFileApis()
    if not canSaveConfig then return end
    local ok, raw = pcall(_ace_readfile, BUTTON_POS_FILE)
    if not ok or type(raw) ~= "string" or raw == "" then return end
    local decodedOk, data = pcall(function() return HS:JSONDecode(raw) end)
    if decodedOk and type(data) == "table" then
        local positions = data.positions or data
        if type(positions) == "table" then
            if tonumber(data.version) == BUTTON_LAYOUT_VERSION then
                savedButtonPositions = positions
            else savedButtonPositions = {} end
        end
    end
end

local function saveDedicatedButtonPositions()
    refreshFileApis()
    if not canSaveConfig then return false end
    if not savedButtonPositions then savedButtonPositions = {} end
    local ok, raw = pcall(function()
        return HS:JSONEncode({version = BUTTON_LAYOUT_VERSION, savedAt = os.time(), positions = savedButtonPositions})
    end)
    if not ok then return false end
    local wrote = pcall(_ace_writefile, BUTTON_POS_FILE, raw)
    if not wrote then return false end
    local verified, check = pcall(_ace_readfile, BUTTON_POS_FILE)
    return verified and check == raw
end

local _autoSaveQueued = false
local _autoSaveSerial = 0
local _isBuildingGui = true

-- ============================================================
-- MAIN
-- ============================================================
_G.Lust = _G.Lust or {}
_G.Lust.Connections = {aimbot = nil, bypass = nil, autoLeft = nil, autoRight = nil, bodyLock = nil,
    dropBrainrot = nil, antiRagdoll = nil, infJump = nil, autoTPDown = nil, enemySpeed = nil,
    movement = nil, stepped = nil, stretch = nil, stretchFov = nil, antiLagDesc = nil, esp = nil,
    batCounter = nil, medusa = {}, steal = nil, progress = nil}
_G.Lust.Active = {autoBat = false, bypass = false, autoLeft = false, autoRight = false, bodyLock = false,
    antiRagdoll = false, jump = false, medusa = false, batCounter = false, autoTPDown = false,
    antiLag = false, antiDie = false, stretch = false, esp = false, steal = false}
_G.Lust.SafeModeLocked = false
_G.Lust.OriginalOutfit = {shirt = nil, pants = nil}
_G.Lust.OriginalAccessories = {}local function _getOrMakeLV(hrp)
    local lv = hrp:FindFirstChild("_RHSpeedLV")
    local att = hrp:FindFirstChild("RootAttachment")
    if not att then att = Instance.new("Attachment"); att.Name = "RootAttachment"; att.Parent = hrp end
    if not lv then lv = Instance.new("LinearVelocity"); lv.Name = "_RHSpeedLV"; lv.Parent = hrp end
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.PlaneVelocity = Vector2.new(0, 0)
    lv.MaxForce = math.huge
    return lv
end
local function _speedLVSet(hrp, x, z) local lv = _getOrMakeLV(hrp); lv.PlaneVelocity = Vector2.new(x, z) end
local function _speedLVClear(hrp) local lv = hrp:FindFirstChild("_RHSpeedLV"); if lv then lv:Destroy() end end

function _G.Lust.StopAll()
    for _, conn in pairs(_G.Lust.Connections) do
        if type(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end)
        elseif type(conn) == "table" then
            for _, c in ipairs(conn) do if type(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end end
        end
    end
    for k in pairs(_G.Lust.Connections) do
        if type(_G.Lust.Connections[k]) == "table" then _G.Lust.Connections[k] = {} else _G.Lust.Connections[k] = nil end
    end
    for k in pairs(_G.Lust.Active) do _G.Lust.Active[k] = false end
    _G.Lust.SafeModeLocked = false
    _blSuppressCount = 0; _blWasEnabled = false
    if _blRestoreTimer then task.cancel(_blRestoreTimer); _blRestoreTimer = nil end
end

NS = 60; CS = 29; LAGGER_SPEED_1 = 15; LAGGER_SPEED_2 = 24.5
MEDUSA_COOLDOWN = 25; BAT_AIMBOT_SPEED = 58; BYPASS_AIMBOT_SPEED = 58
MOBILE_PANEL_WIDTH = 250; MOBILE_PANEL_HEIGHT = 390
BUTTON_LAYOUT_VERSION = 5; BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false
speedMode = false; laggerCarryToggled = false; antiRagdollEnabled = false; antiRagdollMode = "v1"; jumpEnabled = false; jumpMode = "Manual"; jumpInputWasHeld = false
laggerToggled = false; laggerLevel = 1
medusaCounterEnabled = false; batCounterEnabled = false
autoLeftEnabled = false; autoRightEnabled = false; autoBatEnabled = false
bypassToggled = false; antiDesyncAutoSwingEnabled = true
_G.AceAntiDesyncAimbotOn = false
dropMode = 1; antiLagEnabled = false; removeAccessoriesEnabled = false; vizFpsBoosterEnabled = false
stretchEnabled = false; povEnabled = false; uiLocked = false; uiScaleValue = 100
antiDieEnabled = false
rainbowJoystickEnabled = false
_antiDieConn = nil; _antiDieHealthConn = nil; _antiDieStateConn = nil
buttonScaleValue = 0.80; espEnabled = false
setRainbowJoystickVisual = nil
CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }

local Steal = {AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {}}
local isStealing = false
local autoGrabSetDelayRadius = 9; local autoGrabStopTime = 0.96; local autoGrabStopEnabled = true
local stealConnection = nil

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot = plots:FindFirstChild(plotName); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character; if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil, nil end
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child; nearestDist = dist; nearestName = pod.Name; break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false; isStealing = true
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = tick(); local duration = Steal.StealDuration; local promptFired = false
        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end
            local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end
            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true; isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true; return
                end
                local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true; return
                    end
                end
                task.wait()
            end
            if isStealing and Steal.AutoStealEnabled then
                local fillStart = tick(); local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = math.floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true; isStealing = false
    end)
end

function startAutoStealSemi()
    if stealConnection then return end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    _G.Lust.Connections.steal = stealConnection
    _G.Lust.Active.steal = true
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect(); stealConnection = nil
        _G.Lust.Connections.steal = nil; _G.Lust.Active.steal = false
    end
    isStealing = false; Steal.AutoStealEnabled = false
    if progressFill then TS:Create(progressFill, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 1, 0)}):Play() end
    if progressPct then progressPct.Text = "0%" end
end

currentSkyTheme = "Off"; CANDY_SKY_TAG = "LustHubSkyTheme"; candyOriginalLighting = nil
bodyLockEnabled = false; bodyLockRange = 20; bodyLockRangeBox = nil
_bodyLockConn = nil; bodyLockSetVisual = nil
_blSuppressCount = 0; _blWasEnabled = false; _blRestoreTimer = nil; _blSmoothRestore = false
savedProgressBarPos = nil; savedButtonPositions = {}
hideButtonsEnabled = false; setHideButtonsVisual = nil
loadDedicatedButtonPositions()
savedMobilePanelPos = nil; savedMainGuiPos = nil; instaResetFloatingPos = nil; bypassFloatingPos = nil
currentAnimPack = "Off"; originalTryardAnims = nil; tryardHeartbeatConn = nil
animSelectorLabel = nil; unwalkSavedAnimate = nil; unwalkEnabled = false

local ANIM_PACKS = {
    Tryhard = {idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
        walk = "rbxassetid://707897309", run = "rbxassetid://707861613",
        jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985",
        climb = "rbxassetid://116936326516985", swim = "rbxassetid://116936326516985",
        swimidle = "rbxassetid://116936326516985"},
    Crazy = {idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
        walk = "rbxassetid://134824450619865", run = "rbxassetid://134824450619865",
        jump = "rbxassetid://121454505477205", fall = "rbxassetid://94788218468396",
        climb = "rbxassetid://121454505477205", swim = "rbxassetid://121454505477205",
        swimidle = "rbxassetid://121454505477205"},
    Zombie = {
        idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304",
        walk = "rbxassetid://10921355261", run = "rbxassetid://616163682",
        jump = "rbxassetid://104325245285198", fall = "rbxassetid://10921350320",
        climb = "rbxassetid://10921343576", swim = "rbxassetid://10921352344",
        swimidle = "rbxassetid://10921353442"}
}
local ANIM_PACK_ORDER = {{"Off", "Off"}, {"Unwalk", "Unwalk"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}, {"Zombie", "Zombie"}}
local ACCESSORY_PACK_ORDER = {{"Off", "Off"}, {"Outfit 1", "Outfit 1"}, {"Outfit 2", "Outfit 2"}, {"Outfit 3", "Outfit 3"}, {"Outfit 4", "Outfit 4"}, {"Outfit 5", "Outfit 5"}}
currentAccessoryPack = "Off"; accSelectorLabel = nil
avatarCardRefs = {}
local refreshAccessoryCards

-- ============================================================
-- BAT SKIN PICKER
-- ============================================================
local BAT_SKIN_ORDER = {"KATANA", "BAN HAMMER", "SCYTHE"}
currentBatSkin = "KATANA"
local batSkinCardRefs = {}
local refreshBatSkinCards
local batSkinStatusLabel

local function findPlayerBat()
    local char = LP.Character
    if char then
        local bat = char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        local bat = bp:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
    end
end

local batSkinOriginals = {}
local exactBatTemplates = {}
local exactBatSearched = {}
local originalKatanaTemplate = nil

local SOURCE_SKIN_SOUND_IDS = {
    KATANA = "rbxassetid://111808555599832",
    SCYTHE = "rbxassetid://9113305311",
    ["BAN HAMMER"] = "rbxassetid://137964779511233",
}

local SOURCE_TEMPLATE_NAMES = {
    KATANA = {"FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic"},
    SCYTHE = {"Scythe", "SCYTHE", "FlowerSkin_AssetScythe", "FlowerSkin_Scythe", "ScytheSkin"},
    ["BAN HAMMER"] = {"Ban Hammer", "BAN HAMMER", "BanHammer", "Hammer", "BanHammerTool", "FlowerSkin_BanHammer", "Tool"},
}

local function sourceSetPartSafe(part)
    if not part or not part:IsA("BasePart") then return end
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function()
        part.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
        part.AssemblyLinearVelocity = Vector3.zero
        part.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function sourceCleanCosmeticJoints(root)
    if not root then return end
    for _, inst in ipairs(root:GetDescendants()) do
        if inst:IsA("WeldConstraint") or inst:IsA("Weld") or inst:IsA("Motor6D")
            or inst:IsA("ManualWeld") or inst:IsA("Snap") or inst:IsA("Glue") then
            inst:Destroy()
        end
    end
end

local function sourceFindBat()
    local character = LP.Character
    if character then
        local tool = character:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then return tool end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then return tool end
    end
    return nil
end

local function sourceRememberOriginal(tool)
    if not tool then return end
    local handle = tool:FindFirstChild("Handle")
    local slash = tool:FindFirstChild("Slash")
    batSkinOriginals[tool] = batSkinOriginals[tool] or {}
    local original = batSkinOriginals[tool]
    if handle and handle:IsA("BasePart") and not original.Handle then
        original.Handle = {
            Transparency = handle.Transparency,
            LocalTransparencyModifier = handle.LocalTransparencyModifier,
            CastShadow = handle.CastShadow,
        }
    end
    if slash and slash:IsA("Sound") and not original.SlashSoundId then
        original.SlashSoundId = slash.SoundId
    end
end

local function sourceCaptureKatanaTemplate()
    if originalKatanaTemplate then return end
    local function scan(container)
        if not container then return end
        local bat = container:FindFirstChild("Bat")
        if not bat then return end
        local folder = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
        local asset = folder and folder:FindFirstChild("FlowerSkin_AssetKatana")
        if asset then originalKatanaTemplate = asset:Clone() end
    end
    scan(LP:FindFirstChildOfClass("Backpack"))
    scan(LP.Character)
end

local function sourceHideHandle(tool, hidden)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return end
    sourceRememberOriginal(tool)
    if hidden then
        handle.LocalTransparencyModifier = 1
        handle.Transparency = 1
        handle.CastShadow = false
    else
        local original = batSkinOriginals[tool] and batSkinOriginals[tool].Handle
        handle.LocalTransparencyModifier = original and original.LocalTransparencyModifier or 0
        handle.Transparency = original and original.Transparency or 0
        handle.CastShadow = original and original.CastShadow
        if handle.CastShadow == nil then handle.CastShadow = true end
    end
end

local function sourceSetSlashSound(tool, soundId)
    sourceRememberOriginal(tool)
    local slash = tool and tool:FindFirstChild("Slash")
    if slash and slash:IsA("Sound") then
        slash.SoundId = soundId or ((batSkinOriginals[tool] and batSkinOriginals[tool].SlashSoundId) or slash.SoundId)
    end
end

local function sourceRemoveSkin(tool)
    if not tool then return end
    local old1 = tool:FindFirstChild("LustBatSkin")
    if old1 then old1:Destroy() end
    local old2 = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
    if old2 then old2:Destroy() end
    local old3 = tool:FindFirstChild("FlowerSkin_AssetKatana")
    if old3 then old3:Destroy() end
    sourceHideHandle(tool, false)
    sourceSetSlashSound(tool, nil)
end

local function sourceHasBasePart(root)
    if not root then return false end
    if root:IsA("BasePart") then return true end
    return root:FindFirstChildWhichIsA("BasePart", true) ~= nil
end

local function sourceUsableTemplate(root)
    if not root then return nil end
    if root:IsA("Model") or root:IsA("Tool") or root:IsA("Folder") or root:IsA("BasePart") then
        if sourceHasBasePart(root) then return root end
    end
    return nil
end

local function sourceFindNamed(root, names)
    if not root then return nil end
    for _, name in ipairs(names) do
        if root.Name == name then
            local direct = sourceUsableTemplate(root)
            if direct then return direct end
        end
    end
    for _, name in ipairs(names) do
        local found = root:FindFirstChild(name, true)
        local usable = sourceUsableTemplate(found)
        if usable then return usable end
    end
    return nil
end

local function sourceLoadExactTemplateFromId(skinName)
    return nil
end

local function sourceFindExactTemplateInGame(skinName)
    local names = SOURCE_TEMPLATE_NAMES[skinName]
    if not names then return nil end
    local containers = {LP.Character, LP:FindFirstChildOfClass("Backpack"), ReplicatedStorage, Lighting, workspace}
    for _, container in ipairs(containers) do
        local found = sourceFindNamed(container, names)
        if found then
            local clone = found:Clone()
            for _, inst in ipairs(clone:GetDescendants()) do
                if inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
                    inst:Destroy()
                end
            end
            return clone
        end
    end
    return nil
end

local function sourceGetExactTemplate(skinName)
    if skinName == "KATANA" and originalKatanaTemplate then return originalKatanaTemplate end
    if exactBatTemplates[skinName] then return exactBatTemplates[skinName] end
    if exactBatSearched[skinName] then return nil end
    exactBatSearched[skinName] = true
    local loaded = sourceLoadExactTemplateFromId(skinName) or sourceFindExactTemplateInGame(skinName)
    if loaded then exactBatTemplates[skinName] = loaded end
    return loaded
end

local function sourceContainerToModel(clone, folder)
    if clone:IsA("Model") then
        clone.Name = "FlowerSkin_AssetKatana"
        clone.Parent = folder
        return clone
    end
    if clone:IsA("BasePart") then
        local model = Instance.new("Model")
        model.Name = "FlowerSkin_AssetKatana"
        model.Parent = folder
        clone.Parent = model
        return model
    end
    if clone:IsA("Tool") or clone:IsA("Folder") then
        local nested = clone:FindFirstChild("FlowerSkin_AssetKatana")
            or clone:FindFirstChildWhichIsA("Model")
            or clone:FindFirstChildWhichIsA("BasePart")
        if nested and nested.Parent == clone then
            nested.Parent = nil
            clone:Destroy()
            return sourceContainerToModel(nested, folder)
        end
        local model = Instance.new("Model")
        model.Name = "FlowerSkin_AssetKatana"
        model.Parent = folder
        for _, child in ipairs(clone:GetChildren()) do
            if not (child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript")) then
                child.Parent = model
            end
        end
        clone:Destroy()
        return model
    end
    return nil
end

local function sourceApplyExactMesh(tool, skinName)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end
    local template = sourceGetExactTemplate(skinName)
    if not template then return false end

    local folder = Instance.new("Folder")
    folder.Name = "FlowerSkin_KatanaRealistic"
    folder.Parent = tool
    local model = sourceContainerToModel(template:Clone(), folder)
    if not model or not sourceHasBasePart(model) then
        folder:Destroy()
        return false
    end

    sourceCleanCosmeticJoints(model)
    local firstPart
    for _, inst in ipairs(model:GetDescendants()) do
        if inst:IsA("BasePart") then
            firstPart = firstPart or inst
            sourceSetPartSafe(inst)
            inst.Transparency = 0
            inst.LocalTransparencyModifier = 0
        end
    end
    if not firstPart then folder:Destroy(); return false end
    model.PrimaryPart = model.PrimaryPart or firstPart
    pcall(function() model:PivotTo(handle.CFrame) end)
    for _, inst in ipairs(model:GetDescendants()) do
        if inst:IsA("BasePart") then
            local weld = Instance.new("WeldConstraint")
            weld.Name = "SourceBatSkinWeld"
            weld.Part0 = handle
            weld.Part1 = inst
            weld.Parent = inst
        end
    end
    return true
end

local function sourceBuildProxyModel(tool, skinName, parentOverride)
    local handle = tool and tool:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return nil end

    local parent = parentOverride or tool
    local folder = Instance.new("Folder")
    folder.Name = "FlowerSkin_KatanaRealistic"
    folder.Parent = parent

    local model = Instance.new("Model")
    model.Name = "FlowerSkin_AssetKatana"
    model:SetAttribute("CursedBatSkinsGenerated", true)
    model.Parent = folder

    local parts = {}
    local function add(name, size, offset, color, material)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.Color = color
        part.Material = material or Enum.Material.Neon
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Anchored = parentOverride ~= nil
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = not part.Anchored
        pcall(function()
            part.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end)
        part.CFrame = handle.CFrame * offset
        part.Parent = model
        if not part.Anchored then
            local weld = Instance.new("WeldConstraint")
            weld.Name = "SourceBatSkinWeld"
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
        end
        table.insert(parts, part)
        return part
    end

    local red = Color3.new(0.784314, 0, 0)
    local red2 = Color3.new(1, 0.392157, 0.392157)
    local gold = Color3.new(1, 0.72549, 0.196078)

    if skinName == "SCYTHE" then
        add("Handle2", Vector3.new(0.18, 3.4, 0.18), CFrame.new(0, 0.2, 0), Color3.new(0.06, 0.06, 0.07), Enum.Material.Metal)
        add("SharpParts", Vector3.new(2.4, 0.18, 0.42), CFrame.new(0.75, 1.55, 0) * CFrame.Angles(0, 0, math.rad(-25)), red, Enum.Material.Neon)
        add("WeaponPart", Vector3.new(1.5, 0.16, 0.35), CFrame.new(1.15, 1.2, 0) * CFrame.Angles(0, 0, math.rad(32)), red2, Enum.Material.Neon)
        add("NeonAccent", Vector3.new(0.35, 0.35, 0.35), CFrame.new(0, 1.25, 0), gold, Enum.Material.Neon)
    elseif skinName == "BAN HAMMER" then
        add("Handle2", Vector3.new(0.22, 3.2, 0.22), CFrame.new(0, 0.1, 0), Color3.new(0.08, 0.08, 0.09), Enum.Material.Metal)
        add("WeaponPart", Vector3.new(1.8, 0.75, 0.75), CFrame.new(0, 1.55, 0), red, Enum.Material.Neon)
        add("SharpParts", Vector3.new(2.15, 0.16, 0.9), CFrame.new(0, 1.55, 0), gold, Enum.Material.Neon)
        add("NeonAccent", Vector3.new(0.35, 0.95, 0.95), CFrame.new(1.08, 1.55, 0), red2, Enum.Material.Neon)
    else
        add("Handle2", Vector3.new(0.22, 1.0, 0.22), CFrame.new(0, -0.85, 0), Color3.new(0.04, 0.04, 0.045), Enum.Material.Metal)
        add("SharpParts", Vector3.new(0.22, 3.35, 0.12), CFrame.new(0, 1.05, 0), red2, Enum.Material.Neon)
        add("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), red, Enum.Material.Neon)
        add("NeonAccent", Vector3.new(0.75, 0.12, 0.42), CFrame.new(0, -0.28, 0), gold, Enum.Material.Neon)
    end

    model.PrimaryPart = parts[1]
    return model
end

local function sourceApplySkin(skinName)
    sourceCaptureKatanaTemplate()
    local tool = sourceFindBat()
    if not tool then return false end
    sourceRememberOriginal(tool)
    sourceRemoveSkin(tool)
    sourceHideHandle(tool, false)
    sourceSetSlashSound(tool, SOURCE_SKIN_SOUND_IDS[skinName])

    local applied = sourceApplyExactMesh(tool, skinName)
    if not applied then
        local proxy = sourceBuildProxyModel(tool, skinName)
        applied = proxy ~= nil
    end

    if not applied then
        sourceHideHandle(tool, false)
        sourceSetSlashSound(tool, nil)
        return false
    end

    local skinFolder = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
    if skinFolder then
        for _, inst in ipairs(skinFolder:GetDescendants()) do
            if inst:IsA("BasePart") then
                sourceSetPartSafe(inst)
                inst.Transparency = 0
                inst.LocalTransparencyModifier = 0
            end
        end
    end

    sourceHideHandle(tool, true)
    return true
end

local function applyBatSkin(skinName)
    skinName = tostring(skinName or ""):upper()
    if skinName == "BANHAMMER" then skinName = "BAN HAMMER" end
    if not table.find(BAT_SKIN_ORDER, skinName) then return false end
    currentBatSkin = skinName
    local ok = sourceApplySkin(skinName)
    if refreshBatSkinCards then refreshBatSkinCards() end
    if batSkinStatusLabel then
        batSkinStatusLabel.Text = ok and (skinName .. "  ✓") or (skinName .. "  SOURCE NOT FOUND")
        task.delay(1.5, function()
            if batSkinStatusLabel and batSkinStatusLabel.Parent then batSkinStatusLabel.Text = "" end
        end)
    end
    if not _isBuildingGui and not _isLoading and not _isResetting then pcall(saveAllSettings) end
    return ok
end

local BLEED_PACKS = {
    ["Outfit 1"] = {
        accessory = 10159600649, offset = Vector3.new(0, 1, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "none", label = "Outfit 1", headlessKorblox = true
    },
    ["Outfit 2"] = {
        accessory = 1744060292, offset = Vector3.new(0, 1.3, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "none", label = "Outfit 2", headlessKorblox = true
    },
    ["Outfit 3"] = {
        accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0),
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "right", label = "Outfit 3", headlessKorblox = true
    },
    ["Outfit 4"] = {
        accessory = 121097973925756, offset = Vector3.new(0, 0.9, 0),
        shirt = "http://www.roblox.com/asset/?id=123181702116947",
        pants = "http://www.roblox.com/asset/?id=93330291631062",
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "none", label = "Outfit 4", headlessKorblox = true
    },
    ["Outfit 5"] = {
        accessory = 8349240186, offset = Vector3.new(0, 0.9, 0),
        shirt = "http://www.roblox.com/asset/?id=11926549070",
        pants = "http://www.roblox.com/asset/?id=13189494471",
        headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747",
        headTexture = nil, korblox = "none", label = "Outfit 5", headlessKorblox = true
    },
    ["Bleed 1"] = { accessory = 10159600649, offset = Vector3.new(0, 1, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "none", label = "Outfit 1", headlessKorblox = true },
    ["Bleed 2"] = { accessory = 1744060292, offset = Vector3.new(0, 1.3, -0.2),
        shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041",
        headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "none", label = "Outfit 2", headlessKorblox = true },
    ["Bleed 3"] = { accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0),
        shirt = "http://www.roblox.com/asset/?id=11849088376", pants = "http://www.roblox.com/asset/?id=16534673928",
        headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918",
        korblox = "right", label = "Outfit 3", headlessKorblox = true },
}

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt"); local pants = char:FindFirstChildWhichIsA("Pants")
    _G.Lust.OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    _G.Lust.OriginalOutfit.pants = pants and pants.PantsTemplate or nil
end
local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
    if _G.Lust.OriginalOutfit.shirt then local s = Instance.new("Shirt"); s.ShirtTemplate = _G.Lust.OriginalOutfit.shirt; s.Parent = char end
    if _G.Lust.OriginalOutfit.pants then local p = Instance.new("Pants"); p.PantsTemplate = _G.Lust.OriginalOutfit.pants; p.Parent = char end
    _G.Lust.OriginalOutfit.shirt = nil; _G.Lust.OriginalOutfit.pants = nil
end
local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end end
end
local function saveOriginalAccessories(char)
    _G.Lust.OriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then table.insert(_G.Lust.OriginalAccessories, child:Clone()) end
    end
end
local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy() end
    end
    for _, clone in ipairs(_G.Lust.OriginalAccessories) do
        if clone and clone.Parent == nil then local newAcc = clone:Clone(); newAcc.Parent = char end
    end
    _G.Lust.OriginalAccessories = {}
end
local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy() end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then child:Destroy() end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then head.Transparency = 0 end
end
local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]; if not config then return false end
    local char = LP.Character; if not char then return false end
    char:WaitForChild("Head", 10); local head = char:FindFirstChild("Head"); if not head then return false end
    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function() head.MeshId = config.headMesh; if config.headTexture then head.TextureID = config.headTexture end end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head; sm.MeshType = Enum.MeshType.FileMesh; sm.MeshId = config.headMesh; sm.TextureId = config.headTexture or ""
        end
    end
    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end
    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory"); if old then old:Destroy() end
        local objs = nil
        local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(config.accessory)) end)
        if ok and typeof(res) == "table" and #res > 0 then objs = res
        else
            ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(config.accessory) end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true); if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false; h.Anchored = false; h.Massless = true; h.Parent = char
                local weld = Instance.new("Weld"); weld.Part0 = head; weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero); weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = {left = 139607673, right = 139607718}
            local targets = {left = "LeftUpperLeg", right = "RightUpperLeg"}
            local hides = {left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}, right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}}
            local targetPart = char:FindFirstChild(targets[side]); if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName); if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function() return game:GetObjects("rbxassetid://" .. ids[side]) end)
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then assetModel:Destroy(); return false end
            mainMesh.CanCollide = false; mainMesh.Massless = true; mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint"); weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
            assetModel.Parent = char; return true
        end
        if config.korblox == "left" then attachKorblox("left") elseif config.korblox == "right" then attachKorblox("right") end
    end
    return true
end
local function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then return false end
    if packName == "Off" then
        clearAllAccessories(char); restoreOriginalOutfit(char); restoreOriginalAccessories(char); return true
    end
    if not BLEED_PACKS[packName] then return false end
    if not _G.Lust.OriginalOutfit.shirt and not _G.Lust.OriginalOutfit.pants then saveOriginalOutfit(char) end
    if #_G.Lust.OriginalAccessories == 0 then saveOriginalAccessories(char) end
    clearAllOutfit(char); clearAllAccessories(char)
    return applyBleedOutfit(packName) == true
end
local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do for _, v in pairs(pack) do if v == id then return true end end end
    return false
end
local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate"); if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {idle1 = g(animate.idle and animate.idle.Animation1), idle2 = g(animate.idle and animate.idle.Animation2),
        walk = g(animate.walk and animate.walk.WalkAnim), run = g(animate.run and animate.run.RunAnim),
        jump = g(animate.jump and animate.jump.JumpAnim), fall = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim), swim = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle)}
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end
local function enableUnwalk()
    if unwalkEnabled then return end
    unwalkEnabled = true
    local char = LP.Character; local animate = char and char:FindFirstChild("Animate")
    if animate then
        if not unwalkSavedAnimate then unwalkSavedAnimate = animate:Clone() end
        for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
        animate:Destroy()
    end
end
local function disableUnwalk()
    if not unwalkEnabled then return end
    unwalkEnabled = false
    local char = LP.Character
    if char and not char:FindFirstChild("Animate") and unwalkSavedAnimate then
        local newAnimate = unwalkSavedAnimate:Clone(); newAnimate.Parent = char; task.wait()
        local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
    end
end
local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Unwalk" then
        disableUnwalk(); enableUnwalk()
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    if unwalkEnabled then disableUnwalk() end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run and animate.run.RunAnim, originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]; if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character; if not c then return end
        local animate = c:FindFirstChild("Animate"); if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run and animate.run.RunAnim, pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end
local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char); applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else applyAnimPack(packName) end
    currentAnimPack = packName
end
local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil}, AutoLeft = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight = {kb = Enum.KeyCode.C, gp = nil}, AutoBat = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor = {kb = Enum.KeyCode.F, gp = nil}, CarryToggle = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode = {kb = Enum.KeyCode.R, gp = nil}, LaggerCarry = {kb = Enum.KeyCode.Y, gp = nil},
    ToggleGUI = {kb = Enum.KeyCode.T, gp = nil}, InstaReset = {kb = Enum.KeyCode.G, gp = nil},
    Bypass = {kb = Enum.KeyCode.N, gp = nil},
}
KB = {}
for k, v in pairs(DEFAULT_KB) do KB[k] = {kb = v.kb, gp = v.gp} end

_isResetting = false; _lastSavedJSON = nil; _isLoading = false

local CANDY_SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}, sky = {stars = 4000, moon = 18, sun = 0, moonTex = true}, atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2}},
    ["Aurora"] = {clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,150}, atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3}, clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}}},
    ["Sunset"] = {clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}, sky = {stars = 0, sun = 25, moon = 0}, atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5}, clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}}},
    ["Galaxy"] = {clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}, sky = {stars = 10000, moon = 30, sun = 0}, atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5}},
    ["Cyber"] = {clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}, sky = {stars = 2000, moon = 12}, atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2}, clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}}},
    ["Sakura"] = {clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}, sky = {sun = 8}, atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5}, clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}}},
    ["Pink Night"] = {clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}, sky = {stars = 5000, moon = 22, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4}, clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}}},
    ["Blood Moon"] = {clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}, sky = {stars = 1500, moon = 28, sun = 0, moonTex = true}, atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2}, clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}}},
    ["Emerald Dawn"] = {clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}, sky = {sun = 18, moon = 0, stars = 0}, atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2}, clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}}},
    ["Volcanic"] = {clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}, sky = {stars = 200, sun = 12, moon = 0}, atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5}, clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}}},
    ["Arctic"] = {clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}, sky = {sun = 10, stars = 0, moon = 0}, atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8}, clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}}},
    ["Midnight Ocean"] = {clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}, sky = {stars = 6000, moon = 24, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5}},
    ["Vaporwave"] = {clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}, sky = {stars = 1000, moon = 14}, atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4}, clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}}},
    ["Toxic"] = {clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}, atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6}, clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}}},
    ["Solar Eclipse"] = {clock = 12, brightness = 0.9, ambient = {50,40,60}, outAmb = {60,50,70}, sky = {stars = 3500, sun = 22, moon = 0}, atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8}},
    ["Hellscape"] = {clock = 18, brightness = 1.8, ambient = {200,60,30}, outAmb = {220,70,40}, sky = {stars = 100, sun = 30, moon = 0}, atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4}, clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}}},
    ["Heaven"] = {clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}, sky = {sun = 16, moon = 0, stars = 0}, atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5}, clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}}},
    ["Storm"] = {clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}, sky = {stars = 0, sun = 6, moon = 0}, atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3}, clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}}},
    ["Sunrise"] = {clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}, sky = {sun = 22, stars = 0, moon = 0}, atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2}, clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}}},
    ["Deep Space"] = {clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}, sky = {stars = 15000, moon = 0, sun = 0}, atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3}},
    ["Lavender Dream"] = {clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}, sky = {stars = 800, moon = 16, sun = 0}, atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8}, clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}}},
    ["Inferno"] = {clock = 17.5, brightness = 2.2, ambient = {220,100,40}, outAmb = {235,110,50}, sky = {sun = 26, moon = 0, stars = 0}, atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2}, clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}}},
    ["Mint Sky"] = {clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}, sky = {sun = 10}, atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6}, clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}}},
}
local CANDY_SKY_ORDER = {
    {"Off","Off"}, {"Night","Night"}, {"Aurora","Aurora"}, {"Sunset","Sunset"},
    {"Galaxy","Galaxy"}, {"Cyber","Cyber"}, {"Sakura","Sakura"},
    {"Pink Night","Pink Night"}, {"Blood Moon","Blood Moon"},
    {"Emerald Dawn","Emerald Dawn"}, {"Volcanic","Volcanic"},
    {"Arctic","Arctic"}, {"Midnight Ocean","Midnight Ocean"},
    {"Vaporwave","Vaporwave"}, {"Toxic","Toxic"},
    {"Solar Eclipse","Solar Eclipse"}, {"Hellscape","Hellscape"},
    {"Heaven","Heaven"}, {"Storm","Storm"}, {"Sunrise","Sunrise"},
    {"Deep Space","Deep Space"}, {"Lavender Dream","Lavender Dream"},
    {"Inferno","Inferno"}, {"Mint Sky","Mint Sky"}
}
local function candySaveOriginalLighting()
    if candyOriginalLighting then return end
    candyOriginalLighting = {ClockTime = Lighting.ClockTime, OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient, Brightness = Lighting.Brightness,
        FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor,
        ColorShift_Top = Lighting.ColorShift_Top, ColorShift_Bottom = Lighting.ColorShift_Bottom,
        GeographicLatitude = Lighting.GeographicLatitude, GlobalShadows = Lighting.GlobalShadows,
        LightingChildren = {}, TerrainChildren = {}}
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then table.insert(candyOriginalLighting.LightingChildren, child:Clone()) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:IsA("Clouds") then table.insert(candyOriginalLighting.TerrainChildren, child:Clone()) end
        end
    end
end
local function candyClearSky(removeAll)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then
                pcall(function() child:Destroy() end)
            end
        end
    end
end
local function candyInstance(className, parent, props)
    local inst = Instance.new(className); inst:SetAttribute(CANDY_SKY_TAG, true)
    for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
    inst.Parent = parent; return inst
end
local function candyColor(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end
local function CandyApplyCustomSky(mode)
    candySaveOriginalLighting(); candyClearSky(true)
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    local preset = CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        if candyOriginalLighting then
            for k, v in pairs(candyOriginalLighting) do
                if k ~= "LightingChildren" and k ~= "TerrainChildren" then pcall(function() Lighting[k] = v end) end
            end
            for _, child in ipairs(candyOriginalLighting.LightingChildren or {}) do child:Clone().Parent = Lighting end
            local offTerrain = workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then
                for _, child in ipairs(candyOriginalLighting.TerrainChildren or {}) do child:Clone().Parent = offTerrain end
            end
        end
        currentSkyTheme = "Off"; return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(170, 70, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end
    if preset.sky then
        local skyProps = {}
        if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
        if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
        candyInstance("Sky", Lighting, skyProps)
    end
    if preset.atm then
        candyInstance("Atmosphere", Lighting, {Density = preset.atm.dens or 0.3, Color = candyColor(preset.atm.color),
            Decay = candyColor(preset.atm.decay), Glare = preset.atm.glare or 1, Haze = preset.atm.haze or 1})
    end
    if preset.clouds and terrain then
        candyInstance("Clouds", terrain, {Cover = preset.clouds.cover or 0.5, Density = preset.clouds.dens or 0.5,
            Color = candyColor(preset.clouds.color)})
    end
    currentSkyTheme = mode
end
local function setSkyTheme(theme)
    currentSkyTheme = theme; CandyApplyCustomSky(theme)
    if skySelectorLabel then skySelectorLabel.Text = theme end
endmedusaDebounce = false; medusaLastUsed = 0
dropActive = false; lastDropTime = 0; lastMoveDir = Vector3.new(0,0,0); origFOV = 70
local resetCooldown = false; local resetThread = nil; local currentResetChar = nil
local resetSuccessful = false; local stopResetSequence = false
local cameraLocked = false; local lockedCameraCFrame = nil

local function instaResetFast()
    if resetCooldown then return end
    resetCooldown = true; resetSuccessful = false; stopResetSequence = false; cameraLocked = false
    local character = LP.Character; if not character then resetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid"); if not humanoid then resetCooldown = false return end
    local cam = workspace.CurrentCamera
    if cam then lockedCameraCFrame = cam.CFrame; cameraLocked = true; cam.CFrame = lockedCameraCFrame end
    currentResetChar = character
    local isRespawning = false
    resetThread = task.spawn(function()
        local attempts = 0; local maxAttempts = 40; local originalHipHeight = humanoid.HipHeight
        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then isRespawning = true; break end
            pcall(function()
                humanoid.HipHeight = 1e30; humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart"); if rootPart then rootPart.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
                end
            end)
            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true; break
            end
            attempts = attempts + 1; if attempts >= maxAttempts then break end
            task.wait(0.05)
        end
        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function() humanoid.Health = 0 end); task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then resetSuccessful = true end
            end
        end
        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart"); if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end)
        end
        cameraLocked = false; resetCooldown = false; resetThread = nil
        currentResetChar = nil; stopResetSequence = false
    end)
end
function instaReset() instaResetFast() end
LP.CharacterAdded:Connect(function()
    stopResetSequence = true
    if resetThread then task.cancel(resetThread); resetThread = nil end
    resetCooldown = false; currentResetChar = nil; cameraLocked = false
end)
task.spawn(function()
    local cam = workspace.CurrentCamera
    while true do task.wait(0.016); if cameraLocked and lockedCameraCFrame and cam then cam.CFrame = lockedCameraCFrame end end
end)

_anyKeyListening = false; _prevAutoRotate = nil
bypassConn = nil; enemySpeedConn = nil; movementLoop = nil; steppedConn = nil
alConn = nil; arConn = nil; holdInfJumpConn = nil; autoTPConn = nil
stretchConn = nil; stretchFovConn = nil; antiLagDescConn = nil
dropConnections = {}; enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil; progressPct = nil; progressRadLbl = nil; pbFpsLbl = nil; pbPingLbl = nil; pbRadiusLbl = nil; pbFrame = nil
speedLabel = nil; modeValLbl = nil; aimbotSpeedBox = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, autoTPHeightBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
dropModeBtnRef = nil; setJumpToggleState = nil; setJumpModeVisual = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setAntiLagVisual, setAntiDieVisual, setVizFpsBoosterVisual, setAutoTPDownVisual, setLockUIVisual, setInstaGrab, bypassSetVisual = nil, nil, nil, nil, nil, nil, nil, nil
setAntiRagStyleVisual = nil
setESPVIsual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil; bypassFloatingButton = nil
showGui = nil; hideGui = nil; mainUIScale = nil
skySelectorLabel = nil; animSelectorLabel = nil; pbScale = nil

GAMEPAD_KEYS = {[Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true}
MOVE_KEYS = {[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true}
local BAT_COUNTER_SLAP_LIST = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
AP = {L1 = Vector3.new(-476.48, -6.28, 92.73), L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62), R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47)}
function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end
function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end
function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end
function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end
local function startHoldInfJump()
    if _G.Lust.Connections.infJump then return end
    jumpInputWasHeld = false
    _G.Lust.Connections.infJump = RunService.Heartbeat:Connect(function()
        if not jumpEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)

        if jumpMode == "Hold" then
            if isJumpHeld and root.Velocity.Y < 35 then
                root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
            end
        else
            if isJumpHeld and not jumpInputWasHeld then
                root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
            end
        end

        jumpInputWasHeld = isJumpHeld
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)
end

function startJumpMode()
    jumpEnabled = true; _G.Lust.Active.jump = true
    jumpInputWasHeld = false
    startHoldInfJump(); if setJumpVisual then setJumpVisual(true) end
end

function stopJumpMode()
    jumpEnabled = false; _G.Lust.Active.jump = false
    jumpInputWasHeld = false
    if _G.Lust.Connections.infJump then _G.Lust.Connections.infJump:Disconnect(); _G.Lust.Connections.infJump = nil end
    if setJumpVisual then setJumpVisual(false) end
end

function setJumpMode(mode)
    jumpMode = (mode == "Hold") and "Hold" or "Manual"
    jumpInputWasHeld = false
    if setJumpModeVisual then setJumpModeVisual(jumpMode) end
end
local antiRagdollV1Cooldown = 0
local antiRagdollV2Cooldown = 0

-- ============================================================
-- ANTI RAGDOLL V1
-- ============================================================
local function forceResetV1()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") then
                obj.Enabled = true
            end
        end
        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end
        local playerScripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local controls = require(controlModule)
            if controls then
                controls:Enable()
            end
        end
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function isAntiRagdollState(hum)
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
end

local function startAntiRagdollV1()
    if _G.Lust.Connections.antiRagdoll then return end
    antiRagdollEnabled = true
    _G.Lust.Active.antiRagdoll = true
    _G.Lust.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled or antiRagdollMode ~= "v1" then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping then return end
        if not isAntiRagdollState(hum) then return end
        local now = tick()
        if now - antiRagdollV1Cooldown > 0.15 then
            antiRagdollV1Cooldown = now
            forceResetV1()
        end
    end)
    if setAntiRagVisual then
        setAntiRagVisual(true)
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
end

local function startAntiRagdollV2()
    if _G.Lust.Connections.antiRagdoll then return end
    antiRagdollEnabled = true
    _G.Lust.Active.antiRagdoll = true
    _G.Lust.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled or antiRagdollMode ~= "v2" then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping then return end
        if not isAntiRagdollState(hum) then return end
        local now = tick()
        if now - antiRagdollV2Cooldown > 0.15 then
            antiRagdollV2Cooldown = now
            forceResetV2()
        end
    end)
    if setAntiRagVisual then setAntiRagVisual(true) end
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    _G.Lust.Active.antiRagdoll = false
    if _G.Lust.Connections.antiRagdoll then
        _G.Lust.Connections.antiRagdoll:Disconnect()
        _G.Lust.Connections.antiRagdoll = nil
    end
    antiRagdollV1Cooldown = 0
    antiRagdollV2Cooldown = 0
    if setAntiRagVisual then setAntiRagVisual(false) end
end

function startAntiRagdoll()
    if antiRagdollMode == "v2" then
        startAntiRagdollV2()
    else
        startAntiRagdollV1()
    end
end

function setAntiRagMode(mode)
    mode = (mode == "v2") and "v2" or "v1"
    local wasEnabled = antiRagdollEnabled == true
    if wasEnabled then stopAntiRagdoll() end
    antiRagdollMode = mode
    if wasEnabled then startAntiRagdoll() end
    if setAntiRagStyleVisual then setAntiRagStyleVisual(antiRagdollMode) end
    pcall(function() saveAllSettings() end)
end

function setAntiRag(on)
    if on then
        antiRagdollEnabled = true
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

autoTPDownHeight = 20; autoTPDownEnabled = false
local autoTPConn = nil

local function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if hrp.Position.Y < autoTPDownHeight then return end
    end
    local x, y, z = hrp.Position.X, hrp.Position.Y, hrp.Position.Z
    local _, yRot, _ = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(x, -7, z) * CFrame.Angles(0, yRot, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.Velocity = Vector3.zero
end

function runTPDown()
    pcall(function() doAutoTPDown(true) end)
end

function startAutoTPDown()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    autoTPDownEnabled = true
    _G.Lust.Active.autoTPDown = true
    autoTPConn = task.spawn(function()
        while autoTPDownEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
    if setAutoTPDownVisual then setAutoTPDownVisual(true) end
end

function stopAutoTPDown()
    autoTPDownEnabled = false
    _G.Lust.Active.autoTPDown = false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
end

function setupChar(char) if antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

local espHighlightCache = {}; local espTracerCache = {}; local espConn = nil; local _espLastRun = 0
local function clearESP()
    for plr in pairs(espHighlightCache) do pcall(function() espHighlightCache[plr]:Destroy() end) end
    for plr in pairs(espTracerCache) do
        for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end
    end
    espHighlightCache = {}; espTracerCache = {}
end
local function makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local PINK = Color3.fromRGB(170, 70, 255)
    local outer = Drawing.new("Line"); outer.Color = PINK; outer.Thickness = 2.2; outer.Transparency = 0.90; outer.Visible = false
    local mid = Drawing.new("Line"); mid.Color = PINK; mid.Thickness = 1.2; mid.Transparency = 0.74; mid.Visible = false
    local core = Drawing.new("Line"); core.Color = PINK; core.Thickness = 0.6; core.Transparency = 0.10; core.Visible = false
    return {outer, mid, core}
end
local function updateESP()
    local now = tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local currentPlayers = Players:GetPlayers()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(espHighlightCache) do
        if not plrSet[plr] then pcall(function() espHighlightCache[plr]:Destroy() end); espHighlightCache[plr] = nil end
    end
    for plr in pairs(espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end
            espTracerCache[plr] = nil
        end
    end
    for _, plr in ipairs(currentPlayers) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end); espHighlightCache[plr] = nil end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHead and tHum and tHum.Health > 0
        if alive then
            local hl = espHighlightCache[plr]
            if not hl or not hl.Parent or hl.Parent ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "LustHubESP"; hl.FillColor = Color3.fromRGB(170, 70, 255)
                hl.FillTransparency = 0.72; hl.OutlineColor = Color3.fromRGB(170, 70, 255)
                hl.OutlineTransparency = 0.05; hl.Adornee = char; hl.Parent = char
                espHighlightCache[plr] = hl
            end
            local lines = espTracerCache[plr]
            if not lines then lines = makeESPTracers(); espTracerCache[plr] = lines or {} end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = camera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do ln.From = myVec; ln.To = tVec; ln.Visible = true end
                else
                    for _, ln in ipairs(lines) do ln.Visible = false end
                end
            end
        else
            if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end); espHighlightCache[plr] = nil end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end
            end
        end
    end
end
local function startESPLoop()
    if _G.Lust.Connections.esp then return end
    _G.Lust.Active.esp = true
    _G.Lust.Connections.esp = RunService.RenderStepped:Connect(updateESP)
end
local function stopESPLoop()
    _G.Lust.Active.esp = false
    if _G.Lust.Connections.esp then _G.Lust.Connections.esp:Disconnect(); _G.Lust.Connections.esp = nil end
    clearESP()
end
function toggleESP(on)
    espEnabled = on
    if on then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(on) end
end
local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position; local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char then
                local tRoot = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local dist = (tRoot.Position - myPos).Magnitude
                    if dist < minDist then minDist = dist; closest = tRoot end
                end
            end
        end
    end
    return closest
end
local function getClosestTargetBody() return getClosestTarget() end
local function _bodyLockTick()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local target = getClosestTargetBody()
    if not target then if not hum.AutoRotate then hum.AutoRotate = true end; return end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then if not hum.AutoRotate then hum.AutoRotate = true end; return end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end
function startBodyLock()
    if _G.Lust.Connections.bodyLock then return end
    bodyLockEnabled = true; _G.Lust.Active.bodyLock = true
    _G.Lust.Connections.bodyLock = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        _bodyLockTick()
    end)
    if bodyLockSetVisual then bodyLockSetVisual(true) end
    return true
end
function stopBodyLock()
    bodyLockEnabled = false; _G.Lust.Active.bodyLock = false
    if _G.Lust.Connections.bodyLock then _G.Lust.Connections.bodyLock:Disconnect(); _G.Lust.Connections.bodyLock = nil end
    local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate = true end
    if bodyLockSetVisual then bodyLockSetVisual(false) end
end
function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true; stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then task.cancel(_blRestoreTimer); _blRestoreTimer = nil end
        _blSmoothRestore = false
    end
end
function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        local function restore()
            if bodyLockEnabled then
                _blSmoothRestore = true; sta
        end
    end
end                _blSmoothRestore = true; startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
            _blRestoreTimer = nil
        end
        if delayed then _blRestoreTimer = task.delay(1, restore) else restore() end
    end
end
function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5); if not head then return end
    local oldBB = head:FindFirstChild("LustHubSpeedIndicator"); if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "LustHubSpeedIndicator"; bb.Size = UDim2.new(0, 200, 0, 70)
    bb.StudsOffset = Vector3.new(0, 2.0, 0); bb.AlwaysOnTop = true
    local mainFrame = Instance.new("Frame", bb); mainFrame.Size = UDim2.new(1, 0, 1, 0); mainFrame.BackgroundTransparency = 1
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 22); titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1; titleLabel.Text = "using Blazzen Duels"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextScaled = true; titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0; titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    local separator = Instance.new("Frame", mainFrame)
    separator.Size = UDim2.new(0.5, 0, 0, 2); separator.Position = UDim2.new(0.25, 0, 0, 24)
    separator.BackgroundColor3 = Color3.fromRGB(255, 0, 0); separator.BackgroundTransparency = 0.3
    separator.BorderSizePixel = 0
    local grad = Instance.new("UIGradient", separator)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))})
    grad.Rotation = 0
    speedLabel = Instance.new("TextLabel", mainFrame)
    speedLabel.Size = UDim2.new(1, 0, 0, 22); speedLabel.Position = UDim2.new(0, 0, 0, 30)
    speedLabel.BackgroundTransparency = 1; speedLabel.Text = "Speed: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255); speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true; speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.TextStrokeTransparency = 0; speedLabel.TextXAlignment = Enum.TextXAlignment.Center
end
function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25); bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true; bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0); textLabel.Font = Enum.Font.GothamBold
                        textLabel.TextScaled = true; textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label = textLabel; enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head"); if head then label.Parent.Parent = head end
                end
                if label then label.Text = string.format("%.1f", speed) end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
            enemySpeedLabels[player] = nil
        end
    end
end
function startEnemySpeed()
    if _G.Lust.Connections.enemySpeed then return end
    _G.Lust.Connections.enemySpeed = RunService.Heartbeat:Connect(function() updateEnemySpeedLabels() end)
end
function stopEnemySpeed()
    if _G.Lust.Connections.enemySpeed then _G.Lust.Connections.enemySpeed:Disconnect(); _G.Lust.Connections.enemySpeed = nil end
end
function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_SPEED_2 end
    if laggerToggled then return LAGGER_SPEED_1 end
    if speedMode then return CS end
    return NS
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED_1 end
    return NS
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false
        laggerCarryToggled = false
        speedMode = true
    else
        speedMode = not speedMode
    end
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
    if _G.Lust.Connections.autoLeft then _G.Lust.Connections.autoLeft:Disconnect(); _G.Lust.Connections.autoLeft = nil end
    _G.Lust.Active.autoLeft = false; alPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end
function startAutoLeft()
    if _G.ForceStopTPBat then pcall(_G.ForceStopTPBat) end
    if _G.Lust.Connections.autoLeft then return end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobSetAutoRight then mobSetAutoRight(false) end end
    disableAllAimbots(); _suppressBodyLock()
    _G.Lust.Active.autoLeft = true; alPhase = 1
    _G.Lust.Connections.autoLeft = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd); return
            end
            local d = AP.L1 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if _G.Lust.Connections.autoLeft then _G.Lust.Connections.autoLeft:Disconnect(); _G.Lust.Connections.autoLeft = nil end
                _G.Lust.Active.autoLeft = false; alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then root.CFrame = CFrame.new(root.Position, facePos) end
                return
            end
            local d = AP.L2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
    if autoLeftSetVisual then autoLeftSetVisual(true) end
    if mobSetAutoLeft then mobSetAutoLeft(true) end
end
function stopAutoRight()
    if _G.Lust.Connections.autoRight then _G.Lust.Connections.autoRight:Disconnect(); _G.Lust.Connections.autoRight = nil end
    _G.Lust.Active.autoRight = false; arPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end
function startAutoRight()
    if _G.ForceStopTPBat then pcall(_G.ForceStopTPBat) end
    if _G.Lust.Connections.autoRight then return end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobSetAutoLeft then mobSetAutoLeft(false) end end
    disableAllAimbots(); _suppressBodyLock()
    _G.Lust.Active.autoRight = true; arPhase = 1
    _G.Lust.Connections.autoRight = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd); return
            end
            local d = AP.R1 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if _G.Lust.Connections.autoRight then _G.Lust.Connections.autoRight:Disconnect(); _G.Lust.Connections.autoRight = nil end
                _G.Lust.Active.autoRight = false; arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then root.CFrame = CFrame.new(root.Position, facePos) end
                return
            end
            local d = AP.R2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
    if autoRightSetVisual then autoRightSetVisual(true) end
    if mobSetAutoRight then mobSetAutoRight(true) end
end

local AUTO_BAT = {
    SPEED_NORMAL = tonumber(_G.AIMBOT_SPEED_NORMAL) or BAT_AIMBOT_SPEED or 58,
    SPEED_BYPASS = tonumber(_G.AIMBOT_SPEED_BYPASS) or BYPASS_AIMBOT_SPEED or 58,
    SWING_COOLDOWN = 0.08,
    AB2_SWING_CD = 0.12,
}

local function setNormalBatSpeed(value)
    value = tonumber(value)
    if not value then return end
    value = math.clamp(value, 1, 200)
    BAT_AIMBOT_SPEED = value
    AUTO_BAT.SPEED_NORMAL = value
    _G.AIMBOT_SPEED_NORMAL = value
end

local function setBypassBatSpeed(value)
    value = tonumber(value)
    if not value then return end
    value = math.clamp(value, 1, 200)
    BYPASS_AIMBOT_SPEED = value
    AUTO_BAT.SPEED_BYPASS = value
    _G.AIMBOT_SPEED_BYPASS = value
end

local function setAimbotSpeed(value)
    value = tonumber(value)
    if not value then return end
    value = math.clamp(value, 1, 200)
    setNormalBatSpeed(value)
    setBypassBatSpeed(value)
end

local function setAimbotMode(mode)
    mode = tostring(mode or "normal"):lower()
    _G.AIMBOT_MODE = (mode == "bypass") and "bypass" or "normal"
end

local _aimbotTarget = nil
local _aimbotLastScan = 0
local _aimbotHitCooldown = false
local _aimbotConnection = nil
local _aimbotCharacterConnection = nil
local _aimbotBypassPart = nil
local _aimbotBypassWeld = nil
local _aimbotAutoRotate = nil

local function aimbotCleanupProxy()
    if _aimbotBypassWeld then pcall(function() _aimbotBypassWeld:Destroy() end) end
    if _aimbotBypassPart then pcall(function() _aimbotBypassPart:Destroy() end) end
    _aimbotBypassWeld, _aimbotBypassPart = nil, nil
end

local function aimbotCreateProxy()
    aimbotCleanupProxy()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    _aimbotBypassPart = Instance.new("Part")
    _aimbotBypassPart.Name = "BLAZZENBatAimbotProxy"
    _aimbotBypassPart.Size = Vector3.new(1,1,1)
    _aimbotBypassPart.Transparency = 1
    _aimbotBypassPart.CanCollide = false
    _aimbotBypassPart.Massless = true
    _aimbotBypassPart.Parent = char
    _aimbotBypassWeld = Instance.new("Weld")
    _aimbotBypassWeld.Part0 = root
    _aimbotBypassWeld.Part1 = _aimbotBypassPart
    _aimbotBypassWeld.C0 = CFrame.new()
    _aimbotBypassWeld.Parent = _aimbotBypassPart
end

local function getClosestTargetForAimbot()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _aimbotLastScan <= 0.1 and _aimbotTarget and _aimbotTarget.Parent then
        local hum = _aimbotTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            return _aimbotTarget
        end
    end
    _aimbotLastScan = now
    _aimbotTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    _aimbotTarget = closest
    return _aimbotTarget
end

local function trySwing()
    if _aimbotHitCooldown then return end
    _aimbotHitCooldown = true
    task.spawn(function()
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local bat = char:FindFirstChildOfClass("Tool")
            if not bat or not isBatTool(bat) then
                bat = findBat()
            end
            if bat then
                if bat.Parent ~= char and hum then
                    pcall(function() hum:EquipTool(bat) end)
                    task.wait(0.05)
                end
                local remote = nil
                for _, d in ipairs(bat:GetDescendants()) do
                    if d:IsA("RemoteEvent") then
                        remote = d
                        break
                    end
                end
                if remote then
                    pcall(function() remote:FireServer() end)
                    task.wait(0.12)
                    pcall(function() remote:FireServer() end)
                else
                    pcall(function() bat:Activate() end)
                    task.wait(0.12)
                    pcall(function() bat:Activate() end)
                end
            end
        end
        task.delay(AUTO_BAT.SWING_COOLDOWN, function()
            _aimbotHitCooldown = false
        end)
    end)
end

function stopAimbotAdapt()
    if _G.Lust.Connections.aimbot then
        _G.Lust.Connections.aimbot:Disconnect()
        _G.Lust.Connections.aimbot = nil
    end
    if _aimbotConnection then
        _aimbotConnection:Disconnect()
        _aimbotConnection = nil
    end
    if _aimbotCharacterConnection then
        _aimbotCharacterConnection:Disconnect()
        _aimbotCharacterConnection = nil
    end
    _G.Lust.Active.autoBat = false
    autoBatEnabled = false
    _aimbotTarget = nil
    _aimbotHitCooldown = false
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_aimbotAutoRotate == nil) and true or _aimbotAutoRotate
        hum.PlatformStand = false
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _aimbotAutoRotate = nil
    aimbotCleanupProxy()
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
end

function startAimbotAdapt()
    if _G.ForceStopTPBat then pcall(_G.ForceStopTPBat) end
    if _G.Lust.Connections.aimbot then return end
    _suppressBodyLock()
    local char0 = LP.Character
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _aimbotAutoRotate == nil then
            _aimbotAutoRotate = hum0.AutoRotate
        end
        hum0.AutoRotate = false
    end
    _G.Lust.Active.autoBat = true
    autoBatEnabled = true
    _G.AIMBOT_ENABLED = true
    _G.AIMBOT_MODE = (_G.AIMBOT_MODE == "bypass") and "bypass" or "normal"
    if _aimbotCharacterConnection then
        _aimbotCharacterConnection:Disconnect()
    end
    _aimbotCharacterConnection = LP.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if autoBatEnabled then
            _aimbotTarget = nil
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                _aimbotAutoRotate = hum.AutoRotate
                hum.AutoRotate = false
            end
        end
    end)
    _aimbotConnection = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if not _aimbotBypassPart or _aimbotBypassPart.Parent ~= char then
            aimbotCreateProxy()
        end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end
        local target = getClosestTargetForAimbot()
        if not target then
            hum.AutoRotate = true
            return
        end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        if _G.AIMBOT_MODE == "bypass" then
            hum.AutoRotate = false
            local speed = AUTO_BAT.SPEED_BYPASS
            local targetLead = targetVel.Magnitude > 1 and targetVel.Unit * 2 or Vector3.zero
            local aimPos = targetPos + targetLead + Vector3.new(0, 1.2, 0)
            local look = aimPos - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local absYaw = math.abs(yawDelta)
                local boost = 1 + 5 * math.clamp((absYaw - 20) / 140, 0, 1)
                local yawRate = math.clamp(
                    math.rad(yawDelta) * 360 * boost,
                    -36 * boost,
                    36 * boost
                )
                local angLerp = math.min(
                    (35 + 65 * math.clamp((absYaw - 20) / 140, 0, 1)) * 0.016,
                    1
                )
                pcall(function()
                    root.AssemblyAngularVelocity =
                        root.AssemblyAngularVelocity:Lerp(
                            Vector3.new(0, yawRate, 0),
                            angLerp
                        )
                end)
            end
            local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
            local standPos = aimPos - (dir * -1.8)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * speed or Vector3.zero
            local vVel = math.abs(moveDir.Y) > 0.1
                and Vector3.new(0, math.sign(moveDir.Y) * 65, 0)
                or Vector3.new(0, -2, 0)
            if _aimbotBypassPart then
                _aimbotBypassPart.AssemblyLinearVelocity = hVel + vVel
            end
            if hDir.Magnitude > 0.5 then
                hum:Move(hDir.Unit, false)
            end
            if (targetPos - myPos).Magnitude < 6 then
                trySwing()
            end
            pcall(function()
                if type(sethiddenproperty) == "function" then
                    sethiddenproperty(root, "PhysicsRepRootPart", target)
                end
            end)
        else
            hum.AutoRotate = false
            local chaseSpeed = AUTO_BAT.SPEED_NORMAL
            local vertSpeed = 52
            local targetVel2 = target.AssemblyLinearVelocity
            local leadTime = math.clamp(
                targetVel2.Magnitude / 130,
                0.05,
                0.15
            )
            local aimTargetPos =
                targetPos
                + targetVel2 * leadTime
                + Vector3.new(0, 1, 0)
            local look = aimTargetPos - myPos
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
                local yawRate = math.clamp(math.rad(yawDelta) * 285, -40, 40)
                local pitchRate = math.clamp(math.rad(pitchDelta) * 285, -40, 40)
                local yawRad = math.rad(root.Orientation.Y)
                local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                root.AssemblyAngularVelocity =
                    Vector3.new(0, yawRate, 0)
                    + rightAxis * pitchRate
            else
                root.AssemblyAngularVelocity = Vector3.zero
            end
            local dir = look.Magnitude > 0.01 and look.Unit or Vector3.new(1,0,0)
            local standPos = aimTargetPos - dir + Vector3.new(0, 1.6, 0)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * chaseSpeed or Vector3.zero
            local vVel = math.abs(moveDir.Y) > 0.1
                and Vector3.new(0, math.sign(moveDir.Y) * vertSpeed, 0)
                or Vector3.new(0, -2, 0)
            root.AssemblyLinearVelocity = hVel + vVel
            if hDir.Magnitude > 0.5 then
                hum:Move(hDir.Unit, false)
            end
            if (targetPos - myPos).Magnitude < 6 then
                trySwing()
            end
        end
    end)
    _G.Lust.Connections.aimbot = _aimbotConnection
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
end

function disableAutoBat()
    stopAimbotAdapt()
    autoBatEnabled = false
    _G.Lust.Active.autoBat = false
    _G.AIMBOT_ENABLED = false
end

function enableAutoBat()
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
    if bypassToggled then
        bypassToggled = false
        if bypassFloatingButton then
            local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                TS:Create(
                    btnFrame,
                    TweenInfo.new(0.05, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = Color3.fromRGB(0,0,0)}
                ):Play()
                local lbl = btnFrame:FindFirstChild("TextLabel")
                if lbl then
                    TS:Create(
                        lbl,
                        TweenInfo.new(0.05, Enum.EasingStyle.Quad),
                        {TextColor3 = Color3.fromRGB(255, 0, 0)}
                    ):Play()
                end
            end
        end
        stopBypassAimbot()
    end
    startAimbotAdapt()
end

-- ============================================================
-- TP BAT (Bypass)
-- ============================================================
local TPBat = {
    Enabled = false,
    Connection = nil,
    CharacterConnection = nil,
    Target = nil,
    SwingCooldown = false,
    LastSwing = 0,
    PrevAutoRotate = true,
    AutoTPWasEnabled = false,
}
local TP_RANGE = 1e9
local TP_CLOSE = 6
local TP_OFFSET = 2.4

local function _bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn","_bypassGodHealthConn","_bypassGodDiedConn","_bypassGodCharConn"}) do
        local c = _G[key]
        if c then pcall(function() c:Disconnect() end); _G[key] = nil end
    end
end

local function _bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    if _G._bypassGodHealthConn then pcall(function() _G._bypassGodHealthConn:Disconnect() end) end
    _G._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not TPBat.Enabled then return end
        if hum.Health < hum.MaxHealth then pcall(function() hum.Health = hum.MaxHealth end) end
    end)
    if _G._bypassGodDiedConn then pcall(function() _G._bypassGodDiedConn:Disconnect() end) end
    _G._bypassGodDiedConn = hum.Died:Connect(function()
        if not TPBat.Enabled then return end
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.PlatformStand = false
        end)
    end)
end

local function enableBypassGodmode()
    _bypassClearGodConns()
    local char = LP.Character
    if char then _bypassProtectCharacter(char) end
    _G._bypassGodCharConn = LP.CharacterAdded:Connect(function(c)
        if not TPBat.Enabled then return end
        task.wait(0.15)
        _bypassProtectCharacter(c)
    end)
    _G._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not TPBat.Enabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
            if hum:GetState() == Enum.HumanoidStateType.Dead then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end)
    end)
end

local function disableBypassGodmode()
    _bypassClearGodConns()
end

function TPBat.FindBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

function TPBat.GetClosestTarget()
    local root = tpBatRoot or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist, closest = dist, tRoot end
            end
        end
    end
    return closest, minDist
end

function TPBat.Start()
    stopAimbotAdapt()
    autoBatEnabled = false
    _G.AIMBOT_ENABLED = false
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobSetAutoLeft then mobSetAutoLeft(false) end end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobSetAutoRight then mobSetAutoRight(false) end end
    if TPBat.Connection then pcall(function() TPBat.Connection:Disconnect() end); TPBat.Connection = nil end
    TPBat.Enabled = true
    bypassToggled = true
    _G.AceAntiDesyncAimbotOn = true
    TPBat.Target = nil
    TPBat.SwingCooldown = false
    TPBat.LastSwing = 0

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then TPBat.PrevAutoRotate = hum.AutoRotate; hum.AutoRotate = false end
    enableBypassGodmode()

    TPBat.Connection = RunService.Heartbeat:Connect(function()
        if not TPBat.Enabled or not bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        tpBatRoot = root
        tpBatHumanoid = hum

        local bat = char:FindFirstChildOfClass("Tool") or TPBat.FindBat()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end

        local target, dist = TPBat.GetClosestTarget()
        if not target then TPBat.Target = nil; return end
        TPBat.Target = target

        local targetPos = target.Position
        local myPos = root.Position
        local flat = Vector3.new(targetPos.X-myPos.X, 0, targetPos.Z-myPos.Z)
        local look = flat.Magnitude > 0.05 and flat.Unit or root.CFrame.LookVector
        local stand = targetPos - look * TP_OFFSET
        stand = Vector3.new(stand.X, targetPos.Y, stand.Z)

        if dist > TP_CLOSE * 0.55 then
            root.CFrame = CFrame.new(stand, targetPos)
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.15, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        else
            root.CFrame = CFrame.new(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))
        end

        if autoSwingEnabled and bat and not TPBat.SwingCooldown then
            local now = tick()
            if now - TPBat.LastSwing >= 0.08 then
                TPBat.SwingCooldown = true
                TPBat.LastSwing = now
                pcall(function() bat:Activate() end)
                task.delay(0.08, function() TPBat.SwingCooldown = false end)
            end
        end
    end)
    if bypassSetVisual then bypassSetVisual(true) end
    saveAllSettings()
end

function TPBat.Stop()
    if TPBat.Connection then pcall(function() TPBat.Connection:Disconnect() end); TPBat.Connection = nil end
    TPBat.Enabled = false
    TPBat.Target = nil
    TPBat.SwingCooldown = false
    bypassToggled = false
    _G.AceAntiDesyncAimbotOn = false
    disableBypassGodmode()
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if root then
            local lv = root:FindFirstChild("AkaiSpeedLinearVelocity")
            if lv then lv.PlaneVelocity = Vector2.zero; lv.Enabled = false end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then hum.AutoRotate = TPBat.PrevAutoRotate == nil and true or TPBat.PrevAutoRotate; hum:ChangeState(Enum.HumanoidStateType.Running) end
    end
    if bypassSetVisual then bypassSetVisual(false) end
    saveAllSettings()
end

function TPBat.Toggle(state)
    if state == nil then state = not TPBat.Enabled end
    if state then TPBat.Start() else TPBat.Stop() end
    return TPBat.Enabled
end

function findBatBypass() return TPBat.FindBat() end
function tryHitBatBypass()
    local bat = TPBat.FindBat()
    if bat then pcall(function() bat:Activate() end) end
end
function getClosestPlayerBypass()
    local target, dist = TPBat.GetClosestTarget()
    if not target then return nil, math.huge end
    return target, dist
end
function startBypassAimbot() TPBat.Start() end
function stopBypassAimbot() TPBat.Stop() end
function toggleBypass(state) return TPBat.Toggle(state) end
function findBat()
    local char = LP.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end
function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do if tool.Name == name then return true end end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end