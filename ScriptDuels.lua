--[[
    PARCH3 DUELS - Script v9.1.2
    ✅ Cielos.jpg, Halloween2.jpg, Limosna.jpg, Nube.jpg, Amine.jpg en selector
    ✅ Pestañas horizontales en la parte inferior
    ✅ Sombra oscura vertical en botones derechos
]]

skipIntroEnabled = true
if _G.Parch3DuelsRunning then return end
_G.Parch3DuelsRunning = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

local _tick     = tick
local _clamp    = math.clamp
local _floor    = math.floor
local _abs      = math.abs
local _huge     = math.huge
local _sqrt     = math.sqrt
local _V3new    = Vector3.new
local _V3zero   = Vector3.zero
local _CFnew    = CFrame.new
local _CFlookAt = CFrame.lookAt

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
CONFIG_FILE = "Parch3Duels.json"
_isDraggingButton = false

local PASTEL_PINK  = Color3.fromRGB(255, 170, 220)
local NEON_PINK    = Color3.fromRGB(255, 255, 255)
local BLACK_BG     = Color3.fromRGB(255, 255, 255)
local BLACK_STROKE = Color3.fromRGB(0, 0, 0)
local INACTIVE_BG  = Color3.fromRGB(0, 0, 0)
local INACTIVE_TXT = Color3.fromRGB(255, 255, 255)
local ACTIVE_TXT   = Color3.fromRGB(255, 255, 255)
local GRAY_TRACK   = Color3.fromRGB(0, 0, 0)         

local RIGHT_BTN_ACTIVE_BG   = Color3.fromRGB(255, 0, 0)
local RIGHT_BTN_INACTIVE_BG = Color3.fromRGB(255, 255, 255)
local RIGHT_BTN_TEXT        = Color3.fromRGB(0, 0, 0)
local FUNCTION_BLUE         = Color3.fromRGB(0, 100, 255)
local ACTIVE_TAB_BG         = Color3.fromRGB(255, 0, 0)

local BTN_STROKE_THICKNESS = 2
local BTN_STROKE_TRANSPARENCY = 0
local BTN_BG_DARK = Color3.fromRGB(0, 0, 0)

aimbotMode = "V1"
aimbotModeSetVisual = nil
antiRagSetVisual = nil
customSoundsEnabled     = false
setCustomSoundsVisual   = nil
batBypassEnabled = batBypassEnabled or false
batBypassSetVisual = nil
batBypassFloatingButton = nil
batBypassFloatingPos = nil
antiDieEnabled = antiDieEnabled or false
antiFlingEnabled = antiFlingEnabled or false
setAntiDieVisual = nil
setAntiFlingVisual = nil
_G.RaptureToolAssets = {}

stealMode = "V2"
local STEAL_MODE_LOCKED = "V2"
V2_STOP_PERCENT = 70
NORMAL_STOP_PERCENT = 90

backgroundIndex = 1
backgroundImages = {
    "Halloween.jpg", "Naru.jpg", "Luna.jpg", "Itac.jpg",
    "Chino.jpg", "Chino2.jpg", "Cereso.jpg",
    "Cielos.jpg", "Halloween2.jpg", "Limosna.jpg", "Nube.jpg", "Amine.jpg"
}

backgroundImageTransparency = 0
floatingButtonScale = 1
progressBarScale = 1
_floatingUIScales = {}

titleLbl = nil
miniBtn = nil
bestScripLabel = nil
raptureLinkLabel = nil
skipIntroToggleSet = nil

local PRINTED_SOUND_PACKS = {
    V1 = { toggle = { "rbxassetid://6042053626" }, tab = { "rbxassetid://3398620867" }, pitch = 1, volume = 2 },
    V2 = { toggle = { "rbxassetid://9113822143" }, tab = { "rbxassetid://9113821597" }, pitch = 1.15, volume = 1.6 },
}
currentSoundPack = "V1"
local _soundCache = {}

local function getMenuSound(idList)
    local key = table.concat(idList, "|")
    local cached = _soundCache[key]
    if cached and cached.Parent then return cached end
    for _, id in ipairs(idList) do
        local ok, sound = pcall(function()
            local s = Instance.new("Sound")
            s.Name = "RaptureMenuSound"
            s.SoundId = id
            s.Parent = SoundService
            pcall(function() task.wait() end)
            return s
        end)
        if ok and sound then
            if sound.IsLoaded then _soundCache[key] = sound return sound end
            pcall(function() sound:Destroy() end)
        end
    end
    return nil
end

local function playMenuSound(kind)
    if kind == "tab" then return end
    pcall(function()
        local pack = PRINTED_SOUND_PACKS[currentSoundPack] or PRINTED_SOUND_PACKS.V1
        local sound = getMenuSound(pack.toggle)
        if not sound then return end
        local clone = sound:Clone()
        clone.Volume = pack.volume or 1.5
        clone.PlaybackSpeed = pack.pitch or 1
        clone.Parent = SoundService
        clone:Play()
        task.delay(3, function() pcall(function() clone:Destroy() end) end)
    end)
end

function getThemeColor() return PASTEL_PINK end
local _lastThemeUpdate = 0
local _lastThemeColor = nil
_G._RaptureDynamicSliders = _G._RaptureDynamicSliders or {}

function _RaptureApplyThemeToSliders()
    for _, entry in ipairs(_G._RaptureDynamicSliders) do
        if entry and entry.applyThemeColor then pcall(entry.applyThemeColor, PASTEL_PINK) end
    end
end

function updateAllUIThemeColors(color)
    color = color or PASTEL_PINK
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.05 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then progressFill.BackgroundColor3 = NEON_PINK end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = BLACK_STROKE end
    end

    if speedLabel then speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255) end
    if raptureLinkLabel then raptureLinkLabel.TextColor3 = color end

    local char = LP.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("RaptureDuelSpeedIndicator")
            if bb then
                for _, child in ipairs(bb:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then child.TextColor3 = color end
                end
            end
        end
    end

    if miniBtn then miniBtn.TextColor3 = color end

    for plr, billboard in pairs(espBillboardCache) do
        if billboard and billboard.Parent then
            local container = billboard:FindFirstChild("Frame")
            if container then
                local nameLbl = container:FindFirstChild("TextLabel")
                if nameLbl then nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
    end

    if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled) end
    if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), batBypassEnabled) end

    for _, tab in ipairs(tabButtons or {}) do
        if tab:GetAttribute("IsActiveTab") then
            tab.TextColor3 = ACTIVE_TXT
            tab.BackgroundColor3 = ACTIVE_TAB_BG
        end
    end

    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true) end
                end
            end
        end
    end

    if lockBtn then lockBtn.TextColor3 = color end
end

speedMode = false
antiRagdollEnabled = false
antiRagdollVersion = "v1"
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 2
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
stretchValue = 0.7
uiLocked = true
uiScaleValue = 66
progressBarScaleValue = 55
espEnabled = false
antiLagEnabled = false
ragdollTimerEnabled = false

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espGlowCache = {}
local espConn = nil

antiLagDescConn = nil
_antiLagStored = {}

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil

currentAnimPack = "Off"
tryardHeartbeatConn = nil
useCarrySystem = false
lastMoveDir = _V3zero

local function drag(f, ignoreLock)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        dn = false; di = nil
        if endConn then endConn:Disconnect(); endConn = nil end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked and not ignoreLock then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked and not ignoreLock then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

-- ============================================================
-- PINTAR BOTONES DERECHA (Con sombra oscura de arriba a abajo)
-- ============================================================
function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad"); local label = btnFrame:FindFirstChild("TextLabel"); local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    if active then
        btnFrame.BackgroundColor3 = RIGHT_BTN_ACTIVE_BG
        if bg then 
            bg.Rotation = 90
            bg.Color = ColorSequence.new({ 
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), -- Sombra oscura arriba
                ColorSequenceKeypoint.new(0.30, RIGHT_BTN_ACTIVE_BG:Lerp(Color3.new(0,0,0), 0.2)), 
                ColorSequenceKeypoint.new(1.00, RIGHT_BTN_ACTIVE_BG) 
            }) 
        end
        if label then label.TextColor3 = RIGHT_BTN_TEXT end
        if stroke then stroke.Color = RIGHT_BTN_ACTIVE_BG; stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY end
    else
        btnFrame.BackgroundColor3 = RIGHT_BTN_INACTIVE_BG
        if bg then 
            bg.Rotation = 90
            bg.Color = ColorSequence.new({ 
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), -- Sombra oscura arriba
                ColorSequenceKeypoint.new(0.30, Color3.fromRGB(150, 150, 150)), 
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) 
            }) 
        end
        if label then label.TextColor3 = RIGHT_BTN_TEXT end
        if stroke then stroke.Color = Color3.fromRGB(180, 180, 180); stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY end
    end
end

function buildGui()
    local ROW_BG = Color3.fromRGB(0, 0, 0); local WHITE = Color3.fromRGB(255, 255, 255); local INP = Color3.fromRGB(10, 10, 10); local TAB_INACT = Color3.fromRGB(235, 235, 245); local GUI_W, GUI_H = 420, 480
    local old = CoreGui:FindFirstChild("RaptureDuel"); if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui"); if pg then local o = pg:FindFirstChild("RaptureDuel"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui"); gui.Name = "RaptureDuel"; gui.ResetOnSpawn = false; gui.DisplayOrder = 10; gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = CoreGui end); if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui); main.Size = UDim2.new(0, GUI_W, 0, GUI_H); main.Position = UDim2.new(0, 20, 0, 2); main.BackgroundColor3 = Color3.fromRGB(12, 10, 16); main.BackgroundTransparency = 1; main.BorderSizePixel = 0; main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main); bgImage.Name = "BackgroundImage"; bgImage.Size = UDim2.new(1, 0, 1, 0); bgImage.Position = UDim2.new(0, 0, 0, 0); bgImage.BackgroundColor3 = Color3.fromRGB(12, 10, 16); bgImage.BackgroundTransparency = 0
    local bgId = backgroundImages[backgroundIndex]
    local success, asset = pcall(function() return getcustomasset(bgId) end)
    bgImage.Image = success and asset or ""
    bgImage.ImageTransparency = backgroundImageTransparency; bgImage.ScaleType = Enum.ScaleType.Crop; bgImage.ZIndex = 0; bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main); mainUIScale.Scale = uiScaleValue / 100

    local titleFrame = Instance.new("Frame", main); titleFrame.Size = UDim2.new(1, -140, 0, 40); titleFrame.Position = UDim2.new(0, 30, 0, 15); titleFrame.BackgroundTransparency = 1; titleFrame.ZIndex = 20
    titleLbl = Instance.new("ImageLabel", titleFrame); titleLbl.Size = UDim2.new(0, 180, 0, 40); titleLbl.Position = UDim2.new(0, 0, 0, 0); titleLbl.BackgroundTransparency = 1
    titleLbl.Image = getcustomasset("Parch3.jpg"); titleLbl.ScaleType = Enum.ScaleType.Fit
    titleLbl.ZIndex = 21

    local lockBtnFrame = Instance.new("TextButton", main); lockBtnFrame.Size = UDim2.new(0, 32, 0, 32); lockBtnFrame.Position = UDim2.new(1, -80, 0, 20); lockBtnFrame.BackgroundColor3 = Color3.fromRGB(30,30,35); lockBtnFrame.BackgroundTransparency = 0.6; lockBtnFrame.BorderSizePixel = 0
    lockBtnFrame.Text = uiLocked and "🔒" or "🔓"; lockBtnFrame.TextColor3 = getThemeColor(); lockBtnFrame.Font = Enum.Font.GothamBold; lockBtnFrame.TextSize = 18; lockBtnFrame.AutoButtonColor = false; lockBtnFrame.ZIndex = 200
    Instance.new("UICorner", lockBtnFrame).CornerRadius = UDim.new(0, 8); lockBtnFrame.MouseButton1Click:Connect(function() toggleLockUI() end); lockBtn = lockBtnFrame

    local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 32, 0, 32); closeBtn.Position = UDim2.new(1, -42, 0, 20); closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); closeBtn.BackgroundTransparency = 0.6; closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"; closeBtn.TextColor3 = WHITE; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 26; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8); closeBtn.MouseButton1Click:Connect(function() hideGui() end)

    miniBtn = Instance.new("TextButton", gui); miniBtn.Size = UDim2.new(0, 170, 0, 52); miniBtn.Position = UDim2.new(0, 16, 0, 58); miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); miniBtn.BackgroundTransparency = 0; miniBtn.BorderSizePixel = 0; miniBtn.Text = ""; miniBtn.TextColor3 = PASTEL_PINK
    miniBtn.Font = Enum.Font.GothamBlack; miniBtn.TextSize = 16; miniBtn.ZIndex = 20; miniBtn.Visible = false; miniBtn.AutoButtonColor = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn); miniStroke.Color = PASTEL_PINK; miniStroke.Thickness = BTN_STROKE_THICKNESS; miniStroke.Transparency = BTN_STROKE_TRANSPARENCY
    local miniImg = Instance.new("ImageLabel", miniBtn); miniImg.Name = "MiniImage"; miniImg.AnchorPoint = Vector2.new(0.5, 0.5); miniImg.Size = UDim2.new(0, 120, 0, 120); miniImg.Position = UDim2.new(0.5, 0, 0.5, 0); miniImg.BackgroundTransparency = 1; miniImg.Image = getcustomasset("Parch3.jpg"); miniImg.ScaleType = Enum.ScaleType.Fit; miniImg.ZIndex = 21; miniImg.Parent = miniBtn
    miniBtn.MouseButton1Click:Connect(function() showGui() end)

    local slideTween = nil; local mainOriginalPos = main.Position
    showGui = function() if slideTween then slideTween:Cancel() end; if not main then return end; main.Visible = true; miniBtn.Visible = false; main.Position = UDim2.new(0, -GUI_W - 20, 0, 2); slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = mainOriginalPos}); slideTween:Play() end
    hideGui = function() if slideTween then slideTween:Cancel() end; if not main or not main.Visible then return end; local targetPos = UDim2.new(0, -GUI_W - 20, 0, 2); slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}); slideTween:Play(); slideTween.Completed:Connect(function() main.Visible = false; miniBtn.Visible = true; slideTween = nil end) end

    -- ========================================================
    -- PESTAÑAS HORIZONTALES EN LA PARTE INFERIOR
    -- ========================================================
    local tabBar = Instance.new("Frame", main); tabBar.Name = "BottomTabBar"; tabBar.Size = UDim2.new(1, -20, 0, 40); tabBar.Position = UDim2.new(0, 10, 1, -50); tabBar.BackgroundTransparency = 1; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 10
    local tabLayout = Instance.new("UIListLayout", tabBar); tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; tabLayout.Padding = UDim.new(0, 6); tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local tabContent = Instance.new("Frame", main); tabContent.Name = "TabContent"; tabContent.Size = UDim2.new(1, -20, 1, -120); tabContent.Position = UDim2.new(0, 10, 0, 60); tabContent.BackgroundTransparency = 1; tabContent.ClipsDescendants = true; tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    local tabButtonsLocal = {}; local contentPagesLocal = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar); btn.Size = UDim2.new(0, 75, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28); btn.BackgroundTransparency = 0.15; btn.BorderSizePixel = 0; btn.Text = name
        btn.TextColor3 = TAB_INACT; btn.Font = Enum.Font.GothamBlack; btn.TextSize = 11; btn.TextWrapped = true; btn.AutoButtonColor = false; btn.ZIndex = 11; btn.LayoutOrder = i
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10); btn:SetAttribute("IsActiveTab", i == 1)
        if i == 1 then btn.BackgroundColor3 = ACTIVE_TAB_BG; btn.TextColor3 = ACTIVE_TXT; btn.BackgroundTransparency = 0 end
        
        local page = Instance.new("ScrollingFrame", tabContent); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ClipsDescendants = true
        page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = getThemeColor(); page.ScrollBarImageTransparency = 0.3; page.CanvasSize = UDim2.new(0, 0, 0, 0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.ScrollingDirection = Enum.ScrollingDirection.Y; page.ZIndex = 6; page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page); padding.PaddingLeft = UDim.new(0, 2); padding.PaddingRight = UDim.new(0, 2); padding.PaddingTop = UDim.new(0, 4); padding.PaddingBottom = UDim.new(0, 20)
        
        contentPagesLocal[name] = page
        btn.MouseButton1Click:Connect(function()
            playMenuSound("tab"); for _, pg2 in pairs(contentPagesLocal) do pg2.Visible = false end; page.Visible = true
            for _, b in ipairs(tabButtonsLocal) do b.TextColor3 = TAB_INACT; b.BackgroundColor3 = Color3.fromRGB(22, 22, 28); b:SetAttribute("IsActiveTab", false) end
            btn.TextColor3 = ACTIVE_TXT; btn.BackgroundColor3 = ACTIVE_TAB_BG; btn:SetAttribute("IsActiveTab", true)
        end)
        table.insert(tabButtonsLocal, btn)
    end
    tabButtons = tabButtonsLocal; contentPages = contentPagesLocal

    local pageCounters = {}
    local function getNextOrder(page) if not pageCounters[page] then pageCounters[page] = 0 end; pageCounters[page] = pageCounters[page] + 1; return pageCounters[page] end
    local function mkRow(page, h)
        local f = Instance.new("Frame", page); f.Size = UDim2.new(1, -4, 0, h or 40); f.BackgroundColor3 = ROW_BG; f.BackgroundTransparency = 0.05; f.BorderSizePixel = 0; f.LayoutOrder = getNextOrder(page); f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10); local st = Instance.new("UIStroke", f); st.Color = BLACK_STROKE; st.Thickness = BTN_STROKE_THICKNESS; st.Transparency = 0.2
        return f
    end
    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = FUNCTION_BLUE; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextTruncate = Enum.TextTruncate.AtEnd; l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); l.TextStrokeTransparency = 0.5; l.ZIndex = 8
        return l
    end
    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row); pill.Name = "Track"; pill.Size = UDim2.new(0, 46, 0, 22); pill.AnchorPoint = Vector2.new(1, 0.5); pill.Position = UDim2.new(1, -(offset or 10), 0.5, 0); pill.BackgroundColor3 = INACTIVE_BG; pill.BackgroundTransparency = 0; pill.BorderSizePixel = 0; pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0); local stroke = Instance.new("UIStroke", pill); stroke.Color = BLACK_STROKE; stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY
        local dot = Instance.new("Frame", pill); dot.Name = "Knob"; dot.Size = UDim2.new(0, 16, 0, 16); dot.Position = UDim2.new(0, 3, 0.5, -8); dot.BackgroundColor3 = INACTIVE_TXT; dot.BorderSizePixel = 0; dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0); return pill, dot
    end
    local function animPill(pill, dot, on)
        local stroke = pill:FindFirstChildOfClass("UIStroke"); local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, { Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = on and Color3.fromRGB(255,255,255) or INACTIVE_TXT }):Play()
        TS:Create(pill, info, { BackgroundColor3 = on and FUNCTION_BLUE or INACTIVE_BG, BackgroundTransparency = 0 }):Play()
        if stroke then TS:Create(stroke, info, { Color = on and FUNCTION_BLUE or BLACK_STROKE, Transparency = on and 0.1 or 0.3, Thickness = BTN_STROKE_THICKNESS }):Play() end
    end
    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 40); mkLabel(row, txt); local pill, dot = mkPill(row, 10); local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.AutoButtonColor = false; clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function() on = not on; sv(on); pcall(cb, on); task.defer(saveAllSettings) end)
        return sv
    end
    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent); local bw = w or 50; local xo = math.max(xOff or 56, bw + 12); tb.Size = UDim2.new(0, bw, 0, 24); tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP; tb.BackgroundTransparency = 0.3; tb.BorderSizePixel = 0; tb.Text = tostring(default); tb.TextColor3 = WHITE; tb.Font = Enum.Font.GothamBold; tb.TextSize = 11; tb.ClearTextOnFocus = false; tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8); local bs = Instance.new("UIStroke", tb); bs.Color = BLACK_STROKE; bs.Thickness = BTN_STROKE_THICKNESS; bs.Transparency = 0.3
        tb.FocusLost:Connect(function() if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end; task.defer(saveAllSettings) end end); return tb
    end
    local function mkStepRow(page, label, getValue, setValue, minV, maxV, step)
        local row = mkRow(page, 40); mkLabel(row, label)
        local valLabel = Instance.new("TextLabel", row); valLabel.Size = UDim2.new(0, 46, 0, 24); valLabel.Position = UDim2.new(1, -120, 0.5, -12); valLabel.BackgroundColor3 = INP; valLabel.BackgroundTransparency = 0.3; valLabel.BorderSizePixel = 0; valLabel.Text = tostring(getValue()); valLabel.TextColor3 = WHITE; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 11; valLabel.ZIndex = 8
        Instance.new("UICorner", valLabel).CornerRadius = UDim.new(0, 8)
        local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 26, 0, 24); minusBtn.Position = UDim2.new(1, -152, 0.5, -12); minusBtn.BackgroundColor3 = INP; minusBtn.BackgroundTransparency = 0.3; minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = WHITE; minusBtn.Font = Enum.Font.GothamBlack; minusBtn.TextSize = 16; minusBtn.ZIndex = 8
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 8)
        local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 26, 0, 24); plusBtn.Position = UDim2.new(1, -70, 0.5, -12); plusBtn.BackgroundColor3 = INP; plusBtn.BackgroundTransparency = 0.3; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = WHITE; plusBtn.Font = Enum.Font.GothamBlack; plusBtn.TextSize = 16; plusBtn.ZIndex = 8
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 8)
        local function updateLabel() valLabel.Text = tostring(getValue()) end
        minusBtn.MouseButton1Click:Connect(function() local v = getValue() - step; if v < minV then v = minV end; setValue(v); updateLabel(); saveAllSettings() end)
        plusBtn.MouseButton1Click:Connect(function() local v = getValue() + step; if v > maxV then v = maxV end; setValue(v); updateLabel(); saveAllSettings() end); return valLabel
    end
    local function mkCollapsibleSlider(page, label, options, getValue, setValue, opts)
        opts = opts or {}; local wrapper = Instance.new("Frame", page); wrapper.Size = UDim2.new(1, -4, 0, 40); wrapper.BackgroundTransparency = 1; wrapper.LayoutOrder = getNextOrder(page); wrapper.ClipsDescendants = false; wrapper.ZIndex = 7
        local row = Instance.new("Frame", wrapper); row.Size = UDim2.new(1, 0, 0, 40); row.Position = UDim2.new(0, 0, 0, 0); row.BackgroundColor3 = ROW_BG; row.BackgroundTransparency = 0.05; row.BorderSizePixel = 0; row.ZIndex = 8
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10); local rowStroke = Instance.new("UIStroke", row); rowStroke.Color = BLACK_STROKE; rowStroke.Thickness = BTN_STROKE_THICKNESS; rowStroke.Transparency = 0.2
        local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(1, -100, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = label; lbl.TextColor3 = FUNCTION_BLUE; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.ZIndex = 9
        local currentValueLbl = Instance.new("TextLabel", row); currentValueLbl.Size = UDim2.new(0, 60, 1, 0); currentValueLbl.Position = UDim2.new(1, -96, 0, 0); currentValueLbl.BackgroundTransparency = 1; currentValueLbl.Text = tostring(getValue()); currentValueLbl.TextColor3 = PASTEL_PINK; currentValueLbl.Font = Enum.Font.GothamBold; currentValueLbl.TextSize = 11; currentValueLbl.TextXAlignment = Enum.TextXAlignment.Right; currentValueLbl.ZIndex = 9
        local arrowBtn = Instance.new("TextButton", row); arrowBtn.Name = "Arrow"; arrowBtn.Size = UDim2.new(0, 30, 0, 30); arrowBtn.Position = UDim2.new(1, -36, 0.5, -15); arrowBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20); arrowBtn.BackgroundTransparency = 0.25; arrowBtn.BorderSizePixel = 0; arrowBtn.Text = "▲"; arrowBtn.TextColor3 = WHITE; arrowBtn.Font = Enum.Font.GothamBold; arrowBtn.TextSize = 14; arrowBtn.AutoButtonColor = false; arrowBtn.ZIndex = 10
        Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 8); local arrowStroke = Instance.new("UIStroke", arrowBtn); arrowStroke.Color = PASTEL_PINK; arrowStroke.Thickness = BTN_STROKE_THICKNESS; arrowStroke.Transparency = 0.35
        local holder = Instance.new("Frame", wrapper); holder.Size = UDim2.new(1, 0, 0, 0); holder.Position = UDim2.new(0, 0, 0, 42); holder.BackgroundTransparency = 1; holder.ClipsDescendants = true; holder.ZIndex = 7; holder.Visible = false
        local sliderRow = Instance.new("Frame", holder); sliderRow.Size = UDim2.new(1, 0, 0, 42); sliderRow.Position = UDim2.new(0, 0, 0, 0); sliderRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0); sliderRow.BackgroundTransparency = 0.15; sliderRow.BorderSizePixel = 0; sliderRow.ZIndex = 8
        Instance.new("UICorner", sliderRow).CornerRadius = UDim.new(0, 10)
        local sliderBg = Instance.new("Frame", sliderRow); sliderBg.Size = UDim2.new(1, -16, 1, -8); sliderBg.Position = UDim2.new(0, 8, 0, 4); sliderBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0); sliderBg.BackgroundTransparency = 0.2; sliderBg.BorderSizePixel = 0; sliderBg.ClipsDescendants = true; sliderBg.ZIndex = 9
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 14); local sliderBgStroke = Instance.new("UIStroke", sliderBg); sliderBgStroke.Color = BLACK_STROKE; sliderBgStroke.Thickness = BTN_STROKE_THICKNESS; sliderBgStroke.Transparency = 0.32
        local optionBtns = {}; local optionTexts = {}; local segW = 1 / #options
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", sliderBg); optBtn.Name = "Opt_" .. tostring(i); optBtn.AnchorPoint = Vector2.new(0.5, 0.5); optBtn.Size = UDim2.new(segW, -4, 1, -8); optBtn.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0); optBtn.BackgroundColor3 = INACTIVE_BG; optBtn.BackgroundTransparency = 0; optBtn.BorderSizePixel = 0; optBtn.Text = ""; optBtn.AutoButtonColor = false; optBtn.ZIndex = 10
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 13); local optStroke = Instance.new("UIStroke", optBtn); optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; optStroke.Color = BLACK_STROKE; optStroke.Thickness = BTN_STROKE_THICKNESS; optStroke.Transparency = 0.6; optStroke.Parent = optBtn
            local optLbl = Instance.new("TextLabel", optBtn); optLbl.AnchorPoint = Vector2.new(0.5, 0.5); optLbl.Size = UDim2.new(1, 0, 1, 0); optLbl.Position = UDim2.new(0.5, 0, 0.5, 0); optLbl.BackgroundTransparency = 1; optLbl.Text = opt; optLbl.TextColor3 = INACTIVE_TXT; optLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); optLbl.TextStrokeTransparency = 0.4; optLbl.TextSize = 11; optLbl.Font = Enum.Font.GothamBlack; optLbl.TextXAlignment = Enum.TextXAlignment.Center; optLbl.ZIndex = 11; optLbl.Parent = optBtn
            optionBtns[i] = optBtn; optionTexts[i] = optLbl
            optBtn.MouseButton1Click:Connect(function()
                setValue(opt)
                for j, btn in ipairs(optionBtns) do local sel = (j == i); TS:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG }):Play(); local st = btn:FindFirstChildOfClass("UIStroke"); if st then TS:Create(st, TweenInfo.new(0.18), { Color = sel and PASTEL_PINK or BLACK_STROKE, Transparency = sel and 0.1 or 0.6, Thickness = BTN_STROKE_THICKNESS }):Play() end; TS:Create(optionTexts[j], TweenInfo.new(0.14), { TextColor3 = INACTIVE_TXT }):Play() end
                currentValueLbl.Text = tostring(opt); task.defer(saveAllSettings)
            end)
        end
        local function applyVisual(mode)
            local idx = 1; for i, opt in ipairs(options) do if opt == mode then idx = i break end end
            for j, btn in ipairs(optionBtns) do local sel = (j == idx); btn.BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG; local st = btn:FindFirstChildOfClass("UIStroke"); if st then st.Color = sel and PASTEL_PINK or BLACK_STROKE; st.Transparency = sel and 0.1 or 0.6; st.Thickness = BTN_STROKE_THICKNESS end; optionTexts[j].TextColor3 = INACTIVE_TXT end
            currentValueLbl.Text = tostring(mode)
        end
        local function applyThemeColor(newColor)
            local idx = 1; for i, opt in ipairs(options) do if opt == getValue() then idx = i break end end
            for j, btn in ipairs(optionBtns) do if j == idx then btn.BackgroundColor3 = newColor end end; arrowStroke.Color = newColor; sliderBgStroke.Color = newColor; currentValueLbl.TextColor3 = newColor
        end
        table.insert(_G._RaptureDynamicSliders, { applyThemeColor = applyThemeColor })
        local expanded = false
        arrowBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then holder.Visible = true; TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 42) }):Play(); TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, -4, 0, 84) }):Play(); TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0) }):Play(); TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(1, -4, 0, 40) }):Play(); TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 0}):Play(); task.delay(0.22, function() if not expanded then holder.Visible = false end end) end
        end)
        applyVisual(getValue()); return applyVisual, currentValueLbl, optionBtns, optionTexts
    end
    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0, 70, 0, 24); btn.Position = UDim2.new(1, -78, 0.5, -12); btn.BackgroundColor3 = INP; btn.BackgroundTransparency = 0.3; btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel(); btn.TextColor3 = WHITE; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 8; btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
                local isGp = isGamepadInput(inp); if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end; task.defer(saveAllSettings)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry}); return btn
    end
    local function addKeybindRow(page, labelText, kbEntry) local row = mkRow(page, 40); mkLabel(row, labelText); mkKeyButton(row, kbEntry) end

    local speedPage = contentPages["Speed"]
    do local row = mkRow(speedPage); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 60, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 60, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger Carry"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end end) end

    local combatPage = contentPages["Combat"]
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on) batCounterEnabled = on; if on then startBatCounter() else stopBatCounter() end; task.defer(saveAllSettings) end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on) medusaCounterEnabled = on; if on then if LP.Character then setupMedusaCounter(LP.Character) end else stopMedusaCounter() end; task.defer(saveAllSettings) end)
    setRagdollTimerVisual = mkToggle(combatPage, "Ragdoll Countdown", function(on) ragdollCountdownEnabled = on; if on then hookRagdollCountdown(LP.Character) else if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end; if _G._RaptureRCD.charConn then pcall(function() _G._RaptureRCD.charConn:Disconnect() end); _G._RaptureRCD.charConn = nil end; if ragdollCountdownLabel then ragdollCountdownLabel.Visible = false; ragdollCountdownLabel.Text = "" end end; task.defer(saveAllSettings) end)
    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on) antiDieEnabled = on; if on then _antiDie.StartEngine() else _antiDie.StopEngine() end; task.defer(saveAllSettings) end)
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on) antiFlingEnabled = on; if on then startAntiFling() else stopAntiFling() end; task.defer(saveAllSettings) end)
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on) setAntiRagdollEnabled(on) end)
    antiRagSetVisual = mkCollapsibleSlider(combatPage, "Anti Ragdoll Version", {"V1", "V2"}, function() return antiRagdollVersion == "v1" and "V1" or "V2" end, function(v) local newV = (v == "V2") and "v2" or "v1"; setAntiRagdollVersion(newV); if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end end)
    setInstaGrab = mkToggle(combatPage, "Auto Steal", function(on) CONFIG.AUTO_STEAL_ENABLED = on; if on then pcall(startAutoSteal) else stopAutoSteal() end; updateProgressBarVisibility() end)
    do local row = mkRow(combatPage); mkLabel(row, "Steal Radius"); radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 60, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = _floor(v+0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; saveAllSettings() end end) end
    autoBatSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on) if on then enableAutoBat() else disableAutoBat() end; if mobSetAutoBat then mobSetAutoBat(on) end; task.defer(saveAllSettings) end)
    local aimbotModeRefresh
    aimbotModeRefresh = mkCollapsibleSlider(combatPage, "Bat Aimbot Mode", {"V1", "V2"}, function() return aimbotMode end, function(v) if v ~= "V2" then v = "V1" end; aimbotMode = v; selectedAimbotMode = v; if _G.RaptureRefreshAimbotVisual then _G.RaptureRefreshAimbotVisual() end; if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end end)
    aimbotModeSetVisual = aimbotModeRefresh
    do local row = mkRow(combatPage); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 60, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end
    batBypassSetVisual = mkToggle(combatPage, "Bat Bypass", function(on) if on then if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end else if _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end end; task.defer(saveAllSettings) end)
    batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT", function(on) if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end else if batDesyncTpEnabled then toggleBatDesyncTp() end end; task.defer(saveAllSettings) end)
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on) if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v); if mobSetDropBR then mobSetDropBR(v) end end) end end)
    autoLeftSetVisual = mkToggle(combatPage, "Auto Left", function(on) autoLeftEnabled = on; if on then startAutoLeft() else stopAutoLeft() end; if mobSetAutoLeft then mobSetAutoLeft(on) end; task.defer(saveAllSettings) end)
    autoRightSetVisual = mkToggle(combatPage, "Auto Right", function(on) autoRightEnabled = on; if on then startAutoRight() else stopAutoRight() end; if mobSetAutoRight then mobSetAutoRight(on) end; task.defer(saveAllSettings) end)

    local visualPage = contentPages["Visual"]
    setESPVisual = mkToggle(visualPage, "ESP Players", function(on) if on then startESP() else stopESP() end; task.defer(saveAllSettings) end)
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on) if on then enableAntiLag() else disableAntiLag() end; task.defer(saveAllSettings) end)
    do
        local row = mkRow(visualPage, 40); mkLabel(row, "Stretch Rez"); local stretchPill, stretchDot = mkPill(row, 10); local stretchOn = false
        local function setStretch(s) stretchOn = s; animPill(stretchPill, stretchDot, s); if s then enableStretch() else disableStretch() end; stretchEnabled = s; task.defer(saveAllSettings) end
        local stretchClk = Instance.new("TextButton", stretchPill); stretchClk.Size = UDim2.new(1,0,1,0); stretchClk.BackgroundTransparency = 1; stretchClk.Text = ""; stretchClk.ZIndex = 10; stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end); _G.stretchToggleSetter = setStretch
    end
    do local row = mkRow(visualPage); mkLabel(row, "Stretch Value"); stretchValueBox = mkBox(row, stretchValue, 50, 60, function(v) if v and v >= 0.3 and v <= 1.5 then stretchValue = v; if stretchEnabled then disableStretch(); enableStretch() end; saveAllSettings() end end) end
    setFovVisual = mkToggle(visualPage, "FOV", function(on) if on then enableCustomFov() else disableCustomFov() end; task.defer(saveAllSettings) end); if setFovVisual then setFovVisual(fovEnabled) end
    do local row = mkRow(visualPage); mkLabel(row, "FOV Value"); local fovBox = mkBox(row, fovValue, 50, 60, function(v) if v and v >= 20 and v <= 120 then fovValue = _floor(v + 0.5); if not fovEnabled then enableCustomFov(); if setFovVisual then setFovVisual(true) end end; local cam = workspace.CurrentCamera; if cam then pcall(function() cam.FieldOfView = fovValue end) end; saveAllSettings() end end); fovSliderSet = function(val) if fovBox then fovBox.Text = tostring(val) end end end
    do
        local row = mkRow(visualPage, 40); mkLabel(row, "Bat Skin"); local pill, dot = mkPill(row, 10); animPill(pill, dot, false); dot.Visible = false
        local openLbl = Instance.new("TextLabel", pill); openLbl.Name = "OpenLabel"; openLbl.Size = UDim2.new(1, 0, 1, 0); openLbl.BackgroundTransparency = 1; openLbl.Text = "OPEN"; openLbl.TextColor3 = Color3.fromRGB(255, 0, 0); openLbl.Font = Enum.Font.GothamBlack; openLbl.TextSize = 9; openLbl.TextXAlignment = Enum.TextXAlignment.Center; openLbl.ZIndex = 11
        local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.AutoButtonColor = false; clk.ZIndex = 12; clk.MouseButton1Click:Connect(function() openBatSkinPicker() end)
    end
    local customSoundsSetVisual = mkToggle(visualPage, "Custom Sounds", function(on) customSoundsEnabled = on; if _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(on) end; task.defer(saveAllSettings) end); setCustomSoundsVisual = customSoundsSetVisual
    
    local setLockVisual = mkToggle(visualPage, "Lock", function(on) toggleLockUI(on); task.defer(saveAllSettings) end)
    setLockUIVisual = setLockVisual; pcall(setLockUIVisual, uiLocked)

    local configPage = contentPages["Config"]
    uiScaleBox = mkStepRow(configPage, "UI Scale", function() return uiScaleValue end, function(v) uiScaleValue = v; if mainUIScale then mainUIScale.Scale = v / 100 end end, 50, 150, 1)
    progressBarScaleBox = mkStepRow(configPage, "Progress Bar Scale", function() return progressBarScaleValue end, function(v) progressBarScaleValue = v; if pbScale then pbScale.Scale = v / 100 end end, 30, 150, 1)
    mkStepRow(configPage, "Button Scale", function() return _floor(floatingButtonScale * 100) end, function(v) floatingButtonScale = v / 100; applyFloatingButtonScale() end, 50, 200, 1)
    do
        local row = mkRow(configPage, 44); mkLabel(row, "Background Image"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 80, 0, 24); btn.Position = UDim2.new(1, -92, 0.5, -12); btn.BackgroundColor3 = Color3.fromRGB(18, 14, 24); btn.BackgroundTransparency = 0.3; btn.BorderSizePixel = 0; btn.Text = "Selec"; btn.TextColor3 = Color3.fromRGB(255, 0, 0); btn.Font = Enum.Font.GothamBlack; btn.TextSize = 10; btn.ZIndex = 8
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12); btn.Activated:Connect(function() openImagePicker() end)
    end
    do
        local row = mkRow(configPage, 40); local delBtn = Instance.new("TextButton", row); delBtn.Size = UDim2.new(1, -8, 0.85, 0); delBtn.Position = UDim2.new(0, 4, 0.07, 0); delBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); delBtn.BackgroundTransparency = 0.3; delBtn.BorderSizePixel = 0; delBtn.Text = "DELETE CONFIG"; delBtn.TextColor3 = WHITE; delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 12; delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local deleteState = 0; local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then deleteState = 1; delBtn.Text = "CONFIRM?"; task.delay(2, function() if delBtn and delBtn.Parent and deleteState == 1 then deleteState = 0; delBtn.Text = "DELETE CONFIG" end end)
            elseif deleteState == 1 then
                delDebounce = true; pcall(resetToFactoryDefaults)
                task.defer(function()
                    if setAntiRagVisual then setAntiRagVisual(false) end; if setInstaGrab then setInstaGrab(false) end; if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
                    if setBatCounterVisual then setBatCounterVisual(false) end; if setMedusaVisual then setMedusaVisual(false) end; if setRagdollTimerVisual then setRagdollTimerVisual(false) end
                    if autoLeftSetVisual then autoLeftSetVisual(false) end; if autoRightSetVisual then autoRightSetVisual(false) end; if autoBatSetVisual then autoBatSetVisual(false) end
                    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end; if batBypassSetVisual then batBypassSetVisual(false) end; if setESPVisual then setESPVisual(false) end
                    if setAntiLagVisual then setAntiLagVisual(false) end; if setFovVisual then setFovVisual(false) end; if setAntiDieVisual then setAntiDieVisual(false) end; if setAntiFlingVisual then setAntiFlingVisual(false) end
                    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end; if aimbotModeSetVisual then aimbotModeSetVisual("V1") end; if antiRagSetVisual then antiRagSetVisual("V1") end
                    if customSoundsSetVisual then customSoundsSetVisual(false) end; refreshSpeedModeLabel()
                end)
                delBtn.Text = "DELETED"; task.delay(1.5, function() if delBtn and delBtn.Parent then delBtn.Text = "DELETE CONFIG"; delDebounce = false; deleteState = 0 end end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle); addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft); addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat); addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset); addKeybindRow(keyPage, "Bat Bypass", KB.BatBypass)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor); addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    pbFrame = Instance.new("Frame", gui); pbFrame.Size = UDim2.new(0, 480, 0, 76); pbFrame.Position = UDim2.new(0.5, -240, 1, -90); pbFrame.BackgroundTransparency = 1; pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); pbFrame.BorderSizePixel = 0; pbFrame.Active = true; pbFrame.ClipsDescendants = true; pbFrame.Visible = true; pbFrame.ZIndex = 10
    pbScale = Instance.new("UIScale", pbFrame); pbScale.Scale = progressBarScaleValue / 100
    if savedProgressBarPos then pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90) end
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)
    
    local border = Instance.new("UIStroke", pbFrame); border.Color = BLACK_STROKE; border.Thickness = BTN_STROKE_THICKNESS; border.Transparency = 0.3
    local pctRow = Instance.new("Frame", pbFrame); pctRow.Size = UDim2.new(1, 0, 0, 26); pctRow.Position = UDim2.new(0, 0, 0, 4); pctRow.BackgroundTransparency = 1; pctRow.ZIndex = 12
    progressPct = Instance.new("TextLabel", pctRow); progressPct.Size = UDim2.new(1, -28, 1, 0); progressPct.Position = UDim2.new(0, 14, 0, 0); progressPct.BackgroundTransparency = 1; progressPct.Text = "0%"; progressPct.TextColor3 = Color3.fromRGB(255, 255, 255); progressPct.Font = Enum.Font.GothamBlack; progressPct.TextSize = 22; progressPct.TextXAlignment = Enum.TextXAlignment.Right; progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); progressPct.TextStrokeTransparency = 0.2; progressPct.ZIndex = 13
    local infoRow = Instance.new("Frame", pbFrame); infoRow.Size = UDim2.new(1, 0, 0, 26); infoRow.Position = UDim2.new(0, 0, 0, 24); infoRow.BackgroundTransparency = 1; infoRow.ZIndex = 12
    fpsLabel = Instance.new("TextLabel", infoRow); fpsLabel.Size = UDim2.new(0, 130, 1, 0); fpsLabel.Position = UDim2.new(0, 14, 0, 0); fpsLabel.BackgroundTransparency = 1; fpsLabel.Text = "FPS: --"; fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255); fpsLabel.Font = Enum.Font.GothamBlack; fpsLabel.TextSize = 22; fpsLabel.TextXAlignment = Enum.TextXAlignment.Left; fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); fpsLabel.TextStrokeTransparency = 0.2; fpsLabel.ZIndex = 13
    msLabel = Instance.new("TextLabel", infoRow); msLabel.Size = UDim2.new(0, 130, 1, 0); msLabel.Position = UDim2.new(0, 14 + 130 + 12, 0, 0); msLabel.BackgroundTransparency = 1; msLabel.Text = "MS: --"; msLabel.TextColor3 = Color3.fromRGB(255, 255, 255); msLabel.Font = Enum.Font.GothamBlack; msLabel.TextSize = 22; msLabel.TextXAlignment = Enum.TextXAlignment.Left; msLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); msLabel.TextStrokeTransparency = 0.2; msLabel.ZIndex = 13
    local progressRow = Instance.new("Frame", pbFrame); progressRow.Size = UDim2.new(1, -20, 0, 14); progressRow.Position = UDim2.new(0, 10, 0, 56); progressRow.BackgroundTransparency = 1; progressRow.ZIndex = 11
    local fillRegion = Instance.new("Frame", progressRow); fillRegion.Size = UDim2.new(1, 0, 1, 0); fillRegion.BackgroundColor3 = Color3.fromRGB(255, 0, 0); fillRegion.BackgroundTransparency = 0; fillRegion.BorderSizePixel = 0; fillRegion.ClipsDescendants = true; fillRegion.ZIndex = 12
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 10); local frStroke = Instance.new("UIStroke", fillRegion); frStroke.Color = Color3.fromRGB(0, 0, 0); frStroke.Thickness = BTN_STROKE_THICKNESS; frStroke.Transparency = 0; frStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    progressFill = Instance.new("Frame", fillRegion); progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.Position = UDim2.new(0, 0, 0, 0); progressFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0); progressFill.BorderSizePixel = 0; progressFill.ZIndex = 13
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)

    drag(pbFrame, true)
    task.spawn(function()
        local lastFrame = _tick(); local fpsSamples = {}; local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick(); local dt = now - lastFrame; lastFrame = now
            if dt > 0 then table.insert(fpsSamples, 1 / dt); if #fpsSamples > 30 then table.remove(fpsSamples, 1) end; local sum = 0; for _, v in ipairs(fpsSamples) do sum = sum + v end; fpsAvg = sum / #fpsSamples end
        end)
        while true do
            local ping = 0; pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsLabel then fpsLabel.Text = string.format("FPS: %d", _floor(fpsAvg + 0.5)) end
            if msLabel then msLabel.Text = string.format("MS: %d", _floor(ping + 0.5)) end
            task.wait(0.5)
        end
    end)
    drag(main)
end

function openImagePicker()
    pcall(function() local old = CoreGui:FindFirstChild("RaptureImagePicker"); if old then old:Destroy() end; local pg = LP:FindFirstChild("PlayerGui"); if pg then local o = pg:FindFirstChild("RaptureImagePicker"); if o then o:Destroy() end end end)
    local viewer = Instance.new("ScreenGui"); viewer.Name = "RaptureImagePicker"; viewer.ResetOnSpawn = false; viewer.IgnoreGuiInset = true; viewer.DisplayOrder = 400
    if not pcall(function() viewer.Parent = CoreGui end) then viewer.Parent = LP:WaitForChild("PlayerGui") end
    local dim = Instance.new("TextButton", viewer); dim.Size = UDim2.new(1, 0, 1, 0); dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0); dim.BackgroundTransparency = 0.45; dim.Text = ""; dim.AutoButtonColor = false; dim.ZIndex = 1; dim.Activated:Connect(function() viewer:Destroy() end)
    local frame = Instance.new("Frame", viewer); frame.Size = UDim2.new(0, 420, 0, 380); frame.Position = UDim2.new(0.5, -210, 0.5, -190); frame.BackgroundColor3 = Color3.fromRGB(12, 10, 16); frame.BorderSizePixel = 0; frame.ZIndex = 2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14); local st = Instance.new("UIStroke", frame); st.Color = Color3.fromRGB(60,50,75); st.Thickness = 1.8
    local title = Instance.new("TextLabel", frame); title.Size = UDim2.new(1, -48, 0, 30); title.Position = UDim2.new(0, 12, 0, 8); title.BackgroundTransparency = 1; title.Text = "BACKGROUND IMAGE"; title.TextColor3 = Color3.fromRGB(255,255,255); title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 3
    local close = Instance.new("TextButton", frame); close.Size = UDim2.new(0, 28, 0, 28); close.Position = UDim2.new(1, -34, 0, 8); close.BackgroundColor3 = Color3.fromRGB(28,26,36); close.BorderSizePixel = 0; close.Text = "X"; close.TextColor3 = Color3.fromRGB(255,255,255); close.Font = Enum.Font.GothamBlack; close.TextSize = 14; close.ZIndex = 4
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8); close.Activated:Connect(function() viewer:Destroy() end)
    local scroll = Instance.new("ScrollingFrame", frame); scroll.Size = UDim2.new(1, -16, 1, -52); scroll.Position = UDim2.new(0, 8, 0, 44); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = getThemeColor(); scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.ZIndex = 3
    local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0, 120, 0, 80); grid.CellPadding = UDim2.new(0, 8, 0, 8); grid.SortOrder = Enum.SortOrder.LayoutOrder
    for i, id in ipairs(backgroundImages) do
        local thumb = Instance.new("TextButton", scroll); thumb.Size = UDim2.new(0, 120, 0, 80); thumb.BackgroundColor3 = Color3.fromRGB(20, 18, 26); thumb.BorderSizePixel = 0; thumb.Text = ""; thumb.LayoutOrder = i; thumb.ZIndex = 4
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8); local thumbSt = Instance.new("UIStroke", thumb); thumbSt.Color = (backgroundIndex == i) and getThemeColor() or Color3.fromRGB(60, 50, 75); thumbSt.Thickness = (backgroundIndex == i) and 2 or 1; thumbSt.Transparency = (backgroundIndex == i) and 0 or 0.4
        local img = Instance.new("ImageLabel", thumb); img.Size = UDim2.new(1, -8, 1, -8); img.Position = UDim2.new(0, 4, 0, 4); img.BackgroundTransparency = 1
        local success, asset = pcall(function() return getcustomasset(id) end)
        img.Image = success and asset or ""
        img.ScaleType = Enum.ScaleType.Crop; img.ZIndex = 5; Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
        thumb.Activated:Connect(function()
            viewer:Destroy()
            task.defer(function()
                pcall(function()
                    backgroundIndex = i; saveAllSettings()
                    local bgImg = main and main:FindFirstChild("BackgroundImage")
                    if bgImg then local s, a = pcall(function() return getcustomasset(id) end); bgImg.Image = s and a or ""; bgImg.ImageTransparency = backgroundImageTransparency end
                end)
            end)
        end)
    end
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui"); panel.Name = "RaptureDuelMobilePanel"; panel.ResetOnSpawn = false; panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local BTN_W, BTN_H = 60, 60; local GAP = 8; local COLUMNS = 2; local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1); local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
    local container = Instance.new("Frame", panel); container.Name = "FloatingPanel"; container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H); container.Position = UDim2.new(1, -PANEL_W - 15, 0, 70); container.BackgroundTransparency = 1; container.BorderSizePixel = 0; container.Active = false; container.ClipsDescendants = false
    local containerScale = Instance.new("UIScale", container); containerScale.Scale = floatingButtonScale; table.insert(_floatingUIScales, containerScale)
    local btnContainer = Instance.new("Frame", container); btnContainer.Name = "ButtonsContainer"; btnContainer.Size = UDim2.new(1, 0, 1, 0); btnContainer.BackgroundTransparency = 1
    local buttons = {}; local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}; local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nCARRY", "LAGGER"}
    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]; local btn = Instance.new("TextButton", btnContainer); btn.Name = name; btn.Size = UDim2.new(0, BTN_W, 0, BTN_H); btn.BackgroundColor3 = BTN_BG_DARK; btn.BorderSizePixel = 0; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos then btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else local defX, defY = getDefaultButtonPosition(name); btn.Position = UDim2.new(0, defX, 0, defY) end
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        local bgGrad = Instance.new("UIGradient", btn); bgGrad.Name = "BtnGrad"; bgGrad.Rotation = 90; bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) })
        local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY
        local label = Instance.new("TextLabel", btn); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = RIGHT_BTN_TEXT; label.Font = Enum.Font.GothamBlack; label.TextSize = 10; label.TextWrapped = true; label.ZIndex = 11
        local active = false
        local function setActive(state) active = state; btn:SetAttribute("MobActive", state and true or false); paintFloatingBtn(btn, state) end
        setActive(false)
        local dragging = false; local hasMoved = false; local dragStart = nil; local startPos = nil; local movedDistance = 0
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0; dragStart = input.Position; startPos = btn.Position; _isDraggingButton = true
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart; movedDistance = delta.Magnitude
                if not uiLocked then hasMoved = true; btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y) end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if name == "DropBR" then if not autoBatEnabled then setActive(true); executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end); task.delay(0.3, function() setActive(false) end) end
                        elseif name == "AutoLeft" then autoLeftEnabled = not autoLeftEnabled; setActive(autoLeftEnabled); if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end; if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                        elseif name == "AutoBat" then if not autoBatEnabled then enableAutoBat() else disableAutoBat() end; setActive(autoBatEnabled)
                        elseif name == "AutoRight" then autoRightEnabled = not autoRightEnabled; setActive(autoRightEnabled); if autoRightEnabled then startAutoRight() else stopAutoRight() end; if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                        elseif name == "TpDown" then doTpDown(); setActive(true); task.delay(0.2, function() setActive(false) end)
                        elseif name == "Carry" then if not speedMode then speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true); if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end; if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end else speedMode = false; setActive(false) end; refreshSpeedModeLabel()
                        elseif name == "Lagger1" then if not laggerToggled then laggerToggled = true; speedMode = false; laggerCarryToggled = false; setActive(true); if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end; if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end else laggerToggled = false; setActive(false) end; refreshSpeedModeLabel()
                        elseif name == "Lagger2" then if not laggerCarryToggled then laggerCarryToggled = true; speedMode = false; laggerToggled = false; setActive(true); if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end; if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end else laggerCarryToggled = false; setActive(false) end; refreshSpeedModeLabel() end
                    elseif not uiLocked and hasMoved then savedButtonPositions[name] = { X = btn.Position.X.Offset, Y = btn.Position.Y.Offset }; task.defer(saveAllSettings) end
                    dragging = false; hasMoved = false; dragStart = nil; startPos = nil; movedDistance = 0; _isDraggingButton = false
                end
            end
        end)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        if name == "AutoBat" then mobSetAutoBat = setActive end; if name == "AutoLeft" then mobSetAutoLeft = setActive end; if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end; if name == "TpDown" then mobSetTpDown = setActive end; if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end; if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui"); panel.Name = "TpBatButton"; panel.ResetOnSpawn = false; panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel); btnFrame.Size = UDim2.new(0, 60, 0, 60); btnFrame.Name = "Frame"; btnFrame.Position = tpBatFloatingPos and UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10) or UDim2.new(0.5, 20, 0, 10); btnFrame.BackgroundColor3 = BTN_BG_DARK; btnFrame.BorderSizePixel = 0; btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18); local bgGrad = Instance.new("UIGradient", btnFrame); bgGrad.Name = "BtnGrad"; bgGrad.Rotation = 90; bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) })
    local stroke = Instance.new("UIStroke", btnFrame); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = "TP\nBAT"; label.TextColor3 = RIGHT_BTN_TEXT; label.Font = Enum.Font.GothamBlack; label.TextSize = 10; label.TextWrapped = true; label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame); uiScale.Scale = floatingButtonScale; table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position end end)
    btnFrame.InputChanged:Connect(function(inp) if not dragging then return end; if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then local delta = inp.Position - dragStart; if delta.Magnitude > 5 then hasMoved = true end; if hasMoved and not uiLocked then btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end end)
    btnFrame.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then if dragging then if not hasMoved then toggleBatDesyncTp(); paintFloatingBtn(btnFrame, batDesyncTpEnabled) elseif not uiLocked and hasMoved then tpBatFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }; task.defer(saveAllSettings) end; dragging = false; hasMoved = false end end end)
    tpBatFloatingButton = panel; paintFloatingBtn(btnFrame, batDesyncTpEnabled); return panel
end

function createBatBypassFloatingButton()
    local panel = Instance.new("ScreenGui"); panel.Name = "BatBypassButton"; panel.ResetOnSpawn = false; panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel); btnFrame.Size = UDim2.new(0, 60, 0, 60); btnFrame.Name = "Frame"; btnFrame.Position = batBypassFloatingPos and UDim2.new(batBypassFloatingPos.XScale or 0.5, batBypassFloatingPos.XOffset or 60, batBypassFloatingPos.YScale or 0, batBypassFloatingPos.YOffset or 10) or UDim2.new(0.5, 60, 0, 10); btnFrame.BackgroundColor3 = BTN_BG_DARK; btnFrame.BorderSizePixel = 0; btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18); local bgGrad = Instance.new("UIGradient", btnFrame); bgGrad.Name = "BtnGrad"; bgGrad.Rotation = 90; bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) })
    local stroke = Instance.new("UIStroke", btnFrame); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = "BAT\nBYPASS"; label.TextColor3 = RIGHT_BTN_TEXT; label.Font = Enum.Font.GothamBlack; label.TextSize = 10; label.TextWrapped = true; label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame); uiScale.Scale = floatingButtonScale; table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position end end)
    btnFrame.InputChanged:Connect(function(inp) if not dragging then return end; if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then local delta = inp.Position - dragStart; if delta.Magnitude > 5 then hasMoved = true end; if hasMoved and not uiLocked then btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end end)
    btnFrame.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then if dragging then if not hasMoved then _G.RaptureToggleBatBypass(); paintFloatingBtn(btnFrame, _G._RaptureBatBypass.enabled) elseif not uiLocked and hasMoved then batBypassFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }; task.defer(saveAllSettings) end; dragging = false; hasMoved = false end end end)
    batBypassFloatingButton = panel; paintFloatingBtn(btnFrame, batBypassEnabled); return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui"); panel.Name = "InstaResetButton"; panel.ResetOnSpawn = false; panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel); btnFrame.Size = UDim2.new(0, 60, 0, 60); btnFrame.Name = "Frame"; btnFrame.Position = instaResetFloatingPos and UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 100, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10) or UDim2.new(0.5, 100, 0, 10); btnFrame.BackgroundColor3 = BTN_BG_DARK; btnFrame.BorderSizePixel = 0; btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18); local bgGrad = Instance.new("UIGradient", btnFrame); bgGrad.Name = "BtnGrad"; bgGrad.Rotation = 90; bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(150, 150, 150)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) })
    local stroke = Instance.new("UIStroke", btnFrame); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = BTN_STROKE_THICKNESS; stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = "INSTA\nRESET"; label.TextColor3 = RIGHT_BTN_TEXT; label.Font = Enum.Font.GothamBlack; label.TextSize = 10; label.TextWrapped = true; label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame); uiScale.Scale = floatingButtonScale; table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos, activeInput
    btnFrame.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then activeInput = inp; dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position end end)
    UIS.InputChanged:Connect(function(inp) if not dragging or not activeInput then return end; local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput; local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement; if not isTouchMove and not isMouseMove then return end; local delta = inp.Position - dragStart; if delta.Magnitude > 12 then hasMoved = true end; if hasMoved and not uiLocked then btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(inp) if inp ~= activeInput then return end; if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end; if dragging then if not hasMoved then if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end elseif not uiLocked and hasMoved then instaResetFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }; task.defer(saveAllSettings) end; dragging = false; hasMoved = false; activeInput = nil end end)
    instaResetFloatingButton = panel; paintFloatingBtn(btnFrame, false); return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end; if carryBox then carryBox.Text = tostring(CS) end; if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end; if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end; if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end; if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end; if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end; if progressBarScaleBox then progressBarScaleBox.Text = tostring(progressBarScaleValue) end; if stretchValueBox then stretchValueBox.Text = tostring(stretchValue) end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do local entry = ref.entry; local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"; ref.btn.Text = label end
    if savedProgressBarPos and pbFrame then pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90) end
    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then local bgId = backgroundImages[backgroundIndex]; local s, a = pcall(function() return getcustomasset(bgId) end); bgImg.Image = s and a or ""; bgImg.ImageTransparency = backgroundImageTransparency end
    applyFloatingButtonScale()
    if setLockUIVisual then pcall(setLockUIVisual, uiLocked) end
    if antiRagdollEnabled then if setAntiRagVisual then setAntiRagVisual(true) end; if antiRagdollVersion == "v1" then AntiRagdollV1.start() elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end end
    if antiDieEnabled then if setAntiDieVisual then setAntiDieVisual(true) end; _antiDie.StartEngine() end
    if antiFlingEnabled then if setAntiFlingVisual then setAntiFlingVisual(true) end; startAntiFling() end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if medusaCounterEnabled and setMedusaVisual then setMedusaVisual(true); if LP.Character then setupMedusaCounter(LP.Character) end end
    if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true); startBatCounter() end
    if ragdollCountdownEnabled and setRagdollTimerVisual then setRagdollTimerVisual(true); hookRagdollCountdown(LP.Character) end
    if espEnabled and setESPVisual then setESPVisual(true); startESP() end
    if antiLagEnabled and setAntiLagVisual then setAntiLagVisual(true); enableAntiLag() end
    if stretchEnabled and _G.stretchToggleSetter then _G.stretchToggleSetter(true) end; if setFovVisual then setFovVisual(fovEnabled) end; if fovSliderSet then fovSliderSet(fovValue) end
    if batDesyncTpEnabled then if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end; if not batDesyncTpConn then startBatDesyncTp() end end
    if batBypassEnabled then if batBypassSetVisual then batBypassSetVisual(true) end; if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end end
    if aimbotModeSetVisual then aimbotModeSetVisual(aimbotMode) end; if antiRagSetVisual then antiRagSetVisual(antiRagdollVersion == "v1" and "V1" or "V2") end
    if customSoundsEnabled and _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(true) end
    if minecraftBatSkinEnabled then MinecraftBatSkin.State.enabled = true; MinecraftBatSkin.SetColorMode(minecraftBatSkinColorMode); task.defer(function() pcall(MinecraftBatSkin.Apply) end) else MinecraftBatSkin.State.enabled = false; task.defer(function() pcall(MinecraftBatSkin.Remove) end) end
    startEnemySpeed(); toggleLockUI(uiLocked)
end

buildGui()
if loadAllSettings() then updateUIFromLoaded() end

task.defer(function()
    task.wait(0.15)
    if _RaptureApplyThemeToSliders then _RaptureApplyThemeToSliders() end
    for _, entry in ipairs(_G._RaptureDynamicSliders) do pcall(function() entry.applyThemeColor(PASTEL_PINK) end) end
end)

speedMode = false; laggerToggled = false; laggerCarryToggled = false; refreshSpeedModeLabel()

MobilePanel = createMobilePanel(); tpBatFloatingButton = createTpBatFloatingButton(); batBypassFloatingButton = createBatBypassFloatingButton(); instaResetFloatingButton = createInstaResetFloatingButton()

if LP.Character then task.wait(0.1); if waitForCharReady(LP.Character, 5) then setupMovementAndIndicators(LP.Character) end end

LP.CharacterAdded:Connect(function(char)
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end; isStealing = false
    stopAutoLeft(); stopAutoRight(); stopBatCounter(); stopMedusaCounter()
    if not _tpBatUnwalkForced then stopUnwalk() end; stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end; if batDesyncTpEnabled then stopBatDesyncTp() end; if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    task.wait(0.5); if not char.Parent then return end; _hookedVelParts = {}; _setupVelChecked(char); setupMovementAndIndicators(char)
    if antiRagdollEnabled then if antiRagdollVersion == "v1" then AntiRagdollV1.start() elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end end
    if antiDieEnabled then _antiDie.StartEngine() end; if antiFlingEnabled then startAntiFling() end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end; if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
    if medusaCounterEnabled then setupMedusaCounter(char) end; if batCounterEnabled then startBatCounter() end
    if espEnabled then stopESP(); task.wait(0.2); startESP() end; if ragdollCountdownEnabled then hookRagdollCountdown(char) end
    if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
    if minecraftBatSkinEnabled then task.wait(0.6); pcall(MinecraftBatSkin.Apply) end
    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0; local LAGGER_COOLDOWN = 0.3
UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode; if not kc then return end
    if kbMatch(KB.LaggerMode, kc) then if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then lastLaggerToggle = _tick(); toggleLaggerCycle() end; return end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then if not dropActive then if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end; executeDropWithToggle(dropBrainrotSetVisual) end; return end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end; return end
    if kbMatch(KB.BatBypass, kc) then _G.RaptureToggleBatBypass(); if batBypassSetVisual then batBypassSetVisual(_G._RaptureBatBypass.enabled) end; return end
    if kbMatch(KB.AutoLeft, kc) then autoLeftEnabled = not autoLeftEnabled; if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end; if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end; if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end; return end
    if kbMatch(KB.AutoRight, kc) then autoRightEnabled = not autoRightEnabled; if autoRightEnabled then startAutoRight() else stopAutoRight() end; if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end; if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end; return end
    if kbMatch(KB.AutoBat, kc) then if not autoBatEnabled then enableAutoBat(); if autoBatSetVisual then autoBatSetVisual(true) end; if mobSetAutoBat then mobSetAutoBat(true) end else disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobSetAutoBat then mobSetAutoBat(false) end end; return end
    if kbMatch(KB.TPBat, kc) then toggleBatDesyncTp(); if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end; return end
    if kbMatch(KB.GuiHide, kc) then if main then if main.Visible then hideGui() else showGui() end end; return end
end)

task.defer(function() task.wait(0.1); _RaptureApplyThemeToSliders() end)

print("===========================================")
print("  PARCH3 DUELS CARGADO v9.1.2")
print("  ✅ Nuevas imágenes personalizadas integradas")
print("  ✅ Pestañas de menú movidas abajo en horizontal")
print("  ✅ Sombra vertical añadida a los botones derechos")
print("===========================================")