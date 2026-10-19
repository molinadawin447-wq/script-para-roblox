"-- ============================================================
-- #1 deobf by discord.gg/speedhub
-- Printed Duels — cleaned & fixed
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- GLOBAL STATE
-- ============================================================
NS = 60
CS = 30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
AIMBOT_SPEED = 58
LAGGER_AIMBOT_SPEED = 90
AUTO_BAT_SPEED = 82
AUTO_BAT_VERT_SPEED = 52
AUTO_BAT_DIST = -10
AUTO_BAT_HEIGHT = 4.75
AUTO_BAT_V_OFF = 1
AUTO_BAT_TURN_SPEED = 200
AUTO_BAT_MAX_TURN_RATE = 28

speedMode = false
laggerToggled = false
laggerPhase = 0
antiRagdollEnabled = false
infJumpEnabled = false
infJumpMode = "manual"
jumpMode = "Manual"
holdToJumpEnabled = false
holdInfJumpConn = nil
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
medusaDebounce = false
medusaLastUsed = 0
dropActive = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
autoSwingEnabled = false
tpBatEnabled = false
tpBatCamShake = false
tpBatAutoSwing = false
tpBatHittingCD = false
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
mirrorTPDownEnabled = false
antiDieEnabled = false
antiVoidEnabled = false
antiVoidConn = nil
antiVoidSteppedConn = nil
antiVoidSafeCFrame = nil
antiVoidLastGround = 0
bodyLockEnabled = false
bodyLockRadius = 12
bodyLockConn = nil
espEnabled = false
tracersEnabled = false
safeModeEnabled = true
antiLagEnabled = false
removeAccessoriesEnabled = false
antiLagDescConn = nil
stretchRezEnabled = false
stretchRezConn = nil
stretchFOV = 120
uiLocked = false
visible = false
hideMobileButtons = false
currentBackground = 0
skyTheme = "Off"
printedFOVEnabled = false
printedFOVValue = 70
autoCarryEnabled = false
autoPlayAfterCountdown = false
aimbotMode = "V1"
selectedIntroMusic = 1
animPack = "Hit Harder"
animPackEnabled = false
harderHitAnimEnabled = false
headless = false
korblox = false
_introEnabled = true

-- Steal state
tbl19 = { AutoStealEnabled = false, StealRadius = 60, StealDuration = 1.3, Data = {} }
str7 = "Semi"
n32 = 60
flag18 = false
autoGrabStopEnabled = true
autoGrabStopTime = 0.96
autoGrabSetDelayRadius = 9
ENVY_STEAL_RADIUS = 61
ENVY_STEAL_DURATION = 1.3

-- Jump state
JumpState = {
    holdPressed = false,
    holdActive = false,
    controllerActive = false,
    mobilePressed = false,
    mobileActive = false,
    hooked = {},
}

-- Anti-Die state
PrintedAntiDie = {
    enabled = false,
    loop = nil,
    stepLoop = nil,
    healthConn = nil,
    diedConn = nil,
    removeConn = nil,
    charConn = nil,
    invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 1.5,
        ragdollProtection = true,
        autoRevive = true,
    },
}

-- Desync state
PrintedDesync = {
    alive = true,
    enabled = false,
    fakeRoot = nil,
    repRootOwner = nil,
    stepConnection = nil,
    antiBatConn = nil,
    lastSafeCFrame = nil,
    lastCheckTime = 0,
    FAKE_ROOT_NAME = "DavidDesyncRoot",
    FAKE_ROOT_Y = -1000,
    FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0),
    ANTI_BAT_RANGE = 5,
}

-- ESP state
PrintedESP = { enabled = false, data = {}, conns = {} }
PrintedTracer = { enabled = false, data = {}, conn = nil }

-- Medusa
_medusaStoneUntil = 0
_medusaGrabResumeAt = 0
_medusaStealWasOn = false

-- Body lock
_printedBodyLockSuspended = false

-- Keybinds
tbl17 = {
    AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
    AutoRight = { kb = Enum.KeyCode.C, gp = nil },
    AutoBat = { kb = Enum.KeyCode.E, gp = nil },
    CarrySpeed = { kb = Enum.KeyCode.Q, gp = nil },
    DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
    TPDown = { kb = Enum.KeyCode.F, gp = nil },
    LaggerCarry = { kb = Enum.KeyCode.R, gp = nil },
    LaggerSpeed = { kb = Enum.KeyCode.T, gp = nil },
    TPBat = { kb = Enum.KeyCode.V, gp = nil },
}

tbl18 = {
    { id = "AutoLeft", label = "Auto Left" },
    { id = "AutoRight", label = "Auto Right" },
    { id = "AutoBat", label = "Aimbot" },
    { id = "CarrySpeed", label = "Carry" },
    { id = "DropBrainrot", label = "Drop Brainrot" },
    { id = "TPDown", label = "TP Down" },
    { id = "LaggerCarry", label = "Lagger Carry" },
    { id = "LaggerSpeed", label = "Lagger Normal" },
    { id = "TPBat", label = "TP Bat" },
}

-- Mobile button state (bigger default size + scale)
mobileButtonPositions = mobileButtonPositions or {}
mobileButtonScaleValue = mobileButtonScaleValue or 1.0
mobileButtonFrames = mobileButtonFrames or {}
mobileGroupPosition = mobileGroupPosition or { xs = 0.5, x = 0, ys = 0.5, y = 0 }
MobileButtonActions = MobileButtonActions or {}
buttonsAsPanel = nil
_printedBtnSeq = 0
uiScale = nil
visible = false
v88 = nil
v90 = nil
MOBILE_BTN_SIZE = 52  -- slightly smaller (was 64)

-- Config
PRINTED_CONFIG_FILE = "PrintedDuels_MainGUI_Config_V1.json"
PRINTED_KEYBINDS_FILE = "PrintedDuels_Keybinds_V1.json"
_printedConfigLoadedAt = 0
_printed_canSaveConfig = false
_printed_readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile)
_printed_writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile)
_printed_isfile = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile)
_printed_canSaveConfig = type(_printed_readfile) == "function" and type(_printed_writefile) == "function"
_printedConfigDirty = false
_printedConfigSaveTask = nil
-- force re-detect after a short delay (some executors inject funcs late)
task.defer(function()
    task.wait(0.1)
    _printed_readfile = _printed_readfile or readfile or (syn and syn.readfile)
    _printed_writefile = _printed_writefile or writefile or (syn and syn.writefile)
    _printed_isfile = _printed_isfile or isfile or (syn and syn.isfile)
    _printed_canSaveConfig = type(_printed_readfile) == "function" and type(_printed_writefile) == "function"
end)

local function printedPosOf(gui)
    if not gui then return nil end
    local ok, pos = pcall(function() return gui.Position end)
    if not ok or not pos then return nil end
    return {
        xs = pos.X.Scale, x = pos.X.Offset,
        ys = pos.Y.Scale, y = pos.Y.Offset,
    }
end

local function printedApplyPos(gui, data, fallback)
    if not gui or type(data) ~= "table" then return end
    local xs = tonumber(data.xs)
    local x = tonumber(data.x)
    local ys = tonumber(data.ys)
    local y = tonumber(data.y)
    if xs == nil or x == nil or ys == nil or y == nil then
        if fallback then gui.Position = fallback end
        return
    end
    pcall(function()
        gui.Position = UDim2.new(xs, x, ys, y)
    end)
end

local function printedCollectConfig()
    local kb = {}
    for id, bind in pairs(tbl17 or {}) do
        kb[id] = {
            kb = bind.kb and tostring(bind.kb.Name) or nil,
            gp = bind.gp and tostring(bind.gp.Name) or nil,
        }
    end

    -- live positions from UI
    local stealPos = printedPosOf(_G.__PrintedBarFrame)
    local mainPos = printedPosOf(_G.__PrintedMainFrame or _G.__PrintedMain)
    local miniPos = printedPosOf(_G.__PrintedMiniBtn or _G.__PrintedMini)
    local stealDragged = false
    pcall(function()
        if _G.__PrintedBarFrame then
            stealDragged = _G.__PrintedBarFrame:GetAttribute("UserDragged") == true
        end
    end)

    -- snapshot mobile positions from frames if present
    local mbPos = {}
    if type(mobileButtonPositions) == "table" then
        for k, v in pairs(mobileButtonPositions) do mbPos[k] = v end
    end
    for name, d in pairs(mobileButtonFrames or {}) do
        if d and d.frame then
            local p = printedPosOf(d.frame)
            if p then mbPos[name] = p end
        end
    end
    local groupPos = mobileGroupPosition
    local liveBtnScale = tonumber(mobileButtonScaleValue) or tonumber(_G.PrintedBtnScale) or 1.0
    pcall(function()
        if _G.__PrintedBtnScaleObj and _G.__PrintedBtnScaleObj.Parent then
            liveBtnScale = tonumber(_G.__PrintedBtnScaleObj.Scale) or liveBtnScale
            local cont = _G.__PrintedBtnScaleObj.Parent
            if cont and cont:IsA("GuiObject") then
                groupPos = {
                    xs = cont.Position.X.Scale, x = cont.Position.X.Offset,
                    ys = cont.Position.Y.Scale, y = cont.Position.Y.Offset,
                }
            end
        end
    end)
    -- keep globals in sync with live values so next re-execute is correct
    mobileButtonScaleValue = liveBtnScale
    _G.PrintedBtnScale = liveBtnScale
    if groupPos then mobileGroupPosition = groupPos end

    return {
        version = 2,
        NS = NS, CS = CS,
        LAGGER_SPEED = LAGGER_SPEED, LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
        AIMBOT_SPEED = AIMBOT_SPEED, LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
        speedMode = speedMode, laggerToggled = laggerToggled, laggerPhase = laggerPhase,
        antiRagdollEnabled = antiRagdollEnabled,
        infJumpEnabled = infJumpEnabled, infJumpMode = infJumpMode, jumpMode = jumpMode,
        medusaCounterEnabled = medusaCounterEnabled, batCounterEnabled = batCounterEnabled,
        unwalkEnabled = unwalkEnabled,
        autoSwingEnabled = autoSwingEnabled, tpBatCamShake = tpBatCamShake, tpBatAutoSwing = tpBatAutoSwing,
        mirrorTPDownEnabled = mirrorTPDownEnabled,
        antiDieEnabled = antiDieEnabled, antiVoidEnabled = antiVoidEnabled,
        bodyLockEnabled = bodyLockEnabled, bodyLockRadius = bodyLockRadius,
        espEnabled = espEnabled, tracersEnabled = tracersEnabled,
        safeModeEnabled = safeModeEnabled, antiLagEnabled = antiLagEnabled,
        stretchRezEnabled = stretchRezEnabled,
        hideMobileButtons = hideMobileButtons == true,
        uiLocked = uiLocked == true,
        currentBackground = currentBackground, skyTheme = skyTheme,
        printedFOVEnabled = printedFOVEnabled, printedFOVValue = printedFOVValue,
        aimbotMode = aimbotMode, selectedIntroMusic = selectedIntroMusic,
        animPack = animPack, animPackEnabled = animPackEnabled,
        headless = headless, korblox = korblox, _introEnabled = _introEnabled,
        AutoStealEnabled = tbl19 and tbl19.AutoStealEnabled or false,
        StealRadius = tbl19 and tbl19.StealRadius or 60,
        StealMode = str7 or "Semi",
        autoGrabStopEnabled = autoGrabStopEnabled,
        accentTheme = _G.PrintedAccentTheme or "Blue",
        buttonMode = _G.PrintedButtonMode or "Gradient",
        btnTheme = _G.PrintedBtnTheme or 0,
        guiScale = _G.PrintedGuiScale or 0.82,
        btnScale = liveBtnScale,
        barScale = _G.PrintedBarScale or 1,
        mobileButtonsPanel = _G.PrintedMobileButtonsPanel == true,
        mobileButtonPositions = mbPos,
        mobileGroupPosition = groupPos or {},
        mobileButtonScaleValue = liveBtnScale,
        language = PrintedI18n and PrintedI18n.code or "en",
        toggleSound = _G.PrintedToggleSoundVersion or "V1",
        keybinds = kb,
        -- positions
        stealBarPosition = stealPos,
        stealBarDragged = stealDragged,
        mainGuiPosition = mainPos,
        miniBtnPosition = miniPos,
    }
end

local function printedApplyConfig(data)
    if type(data) ~= "table" then return end
    local function n(v, d) local t = tonumber(v); return t or d end
    local function b(v, d) if v == nil then return d end return v and true or false end
    NS = n(data.NS, NS or 60)
    CS = clampCarrySpeed(data.CS or CS)
    LAGGER_SPEED = n(data.LAGGER_SPEED, LAGGER_SPEED or 15)
    LAGGER_CARRY_SPEED = n(data.LAGGER_CARRY_SPEED, LAGGER_CARRY_SPEED or 24.5)
    AIMBOT_SPEED = n(data.AIMBOT_SPEED, AIMBOT_SPEED or 58)
    LAGGER_AIMBOT_SPEED = n(data.LAGGER_AIMBOT_SPEED, LAGGER_AIMBOT_SPEED or 90)
    antiRagdollEnabled = b(data.antiRagdollEnabled, false)
    pcall(function() if antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end end)
    infJumpEnabled = b(data.infJumpEnabled, false)
    if data.infJumpMode or data.jumpMode then
        pcall(setInfJumpMode, data.infJumpMode or (data.jumpMode == "Hold" and "hold" or "manual"))
    end
    medusaCounterEnabled = b(data.medusaCounterEnabled, false)
    batCounterEnabled = b(data.batCounterEnabled, false)
    pcall(function() if batCounterEnabled then startBatCounter() else stopBatCounter() end end)
    unwalkEnabled = b(data.unwalkEnabled, false)
    autoSwingEnabled = b(data.autoSwingEnabled, false)
    tpBatCamShake = b(data.tpBatCamShake, false)
    tpBatAutoSwing = b(data.tpBatAutoSwing, false)
    mirrorTPDownEnabled = b(data.mirrorTPDownEnabled, false)
    antiDieEnabled = b(data.antiDieEnabled, false)
    pcall(function() if antiDieEnabled and startAntiDie then startAntiDie() elseif stopAntiDie then stopAntiDie() end end)
    antiVoidEnabled = b(data.antiVoidEnabled, false)
    pcall(function() if antiVoidEnabled then startAntiVoid() else stopAntiVoid() end end)
    bodyLockEnabled = b(data.bodyLockEnabled, false)
    bodyLockRadius = math.clamp(n(data.bodyLockRadius, 12), 9, 20)
    pcall(function() if bodyLockEnabled then startBodyLock() else stopBodyLock() end end)
    espEnabled = b(data.espEnabled, false)
    pcall(function() if espEnabled and startPrintedESP then startPrintedESP() elseif stopPrintedESP then stopPrintedESP() end end)
    tracersEnabled = b(data.tracersEnabled, false)
    pcall(function() if tracersEnabled and startPrintedTracers then startPrintedTracers() elseif stopPrintedTracers then stopPrintedTracers() end end)
    safeModeEnabled = b(data.safeModeEnabled, true)
    antiLagEnabled = b(data.antiLagEnabled, false)
    pcall(function() if antiLagEnabled and enableAntiLag then enableAntiLag() elseif disableAntiLag then disableAntiLag() end end)
    stretchRezEnabled = b(data.stretchRezEnabled, false)
    pcall(function() if stretchRezEnabled and enableStretchRez then enableStretchRez() elseif disableStretchRez then disableStretchRez() end end)
    hideMobileButtons = b(data.hideMobileButtons, false)
    uiLocked = b(data.uiLocked, false)
    currentBackground = n(data.currentBackground, currentBackground or 1)
    aimbotMode = tostring(data.aimbotMode or aimbotMode or "V1")
    selectedIntroMusic = n(data.selectedIntroMusic, 1)
    animPack = tostring(data.animPack or animPack or "Hit Harder")
    animPackEnabled = b(data.animPackEnabled, false)
    headless = b(data.headless, false)
    korblox = b(data.korblox, false)
    _introEnabled = b(data._introEnabled, true)
    if tbl19 then
        tbl19.AutoStealEnabled = b(data.AutoStealEnabled, false)
        tbl19.StealRadius = n(data.StealRadius, 60)
    end
    str7 = tostring(data.StealMode or str7 or "Semi")
    autoGrabStopEnabled = b(data.autoGrabStopEnabled, true)
    _G.PrintedAccentTheme = tostring(data.accentTheme or "Blue")
    _G.PrintedButtonMode = tostring(data.buttonMode or "Gradient")
    _G.PrintedBtnTheme = n(data.btnTheme, 0)
    _G.PrintedGuiScale = n(data.guiScale, 0.82)
    _G.PrintedBtnScale = n(data.btnScale, mobileButtonScaleValue or 1.0)
    _G.PrintedBarScale = n(data.barScale, 1)
    _G.PrintedMobileButtonsPanel = b(data.mobileButtonsPanel, false)
    _G.PrintedToggleSoundVersion = tostring(data.toggleSound or "V1")
    if type(data.mobileButtonPositions) == "table" then
        mobileButtonPositions = data.mobileButtonPositions
    end
    if type(data.mobileGroupPosition) == "table" then
        mobileGroupPosition = data.mobileGroupPosition
    end
    mobileButtonScaleValue = n(data.mobileButtonScaleValue, mobileButtonScaleValue or 1.0)
    _G.PrintedBtnScale = mobileButtonScaleValue
    if type(data.keybinds) == "table" and tbl17 then
        for id, bind in pairs(data.keybinds) do
            if tbl17[id] and type(bind) == "table" then
                if bind.kb and Enum.KeyCode[bind.kb] then tbl17[id].kb = Enum.KeyCode[bind.kb] else tbl17[id].kb = nil end
                if bind.gp and Enum.KeyCode[bind.gp] then tbl17[id].gp = Enum.KeyCode[bind.gp] else tbl17[id].gp = nil end
            end
        end
    end
    if data.language and printedApplyLanguage then pcall(printedApplyLanguage, data.language) end
    if _G.__PrintedSetGuiScale then pcall(_G.__PrintedSetGuiScale, _G.PrintedGuiScale) end
    if _G.__PrintedBarScaleObj then _G.__PrintedBarScaleObj.Scale = math.clamp(_G.PrintedBarScale, 0.1, 1.5) end
    if _G.__PrintedBtnScaleObj then
        _G.__PrintedBtnScaleObj.Scale = mobileButtonScaleValue
    end
    if _G.PrintedRefreshLockBtn then pcall(_G.PrintedRefreshLockBtn) end
    -- force mobile panel + positions to match saved config right after load
    if _G.PrintedApplyMobilePanel then pcall(_G.PrintedApplyMobilePanel) end

    -- restore positions
    _G.__PrintedSavedStealPos = data.stealBarPosition
    _G.__PrintedSavedStealDragged = data.stealBarDragged == true
    _G.__PrintedSavedMainPos = data.mainGuiPosition
    _G.__PrintedSavedMiniPos = data.miniBtnPosition

    if _G.__PrintedBarFrame and type(data.stealBarPosition) == "table" then
        printedApplyPos(_G.__PrintedBarFrame, data.stealBarPosition)
        if data.stealBarDragged then
            pcall(function() _G.__PrintedBarFrame:SetAttribute("UserDragged", true) end)
        end
    end
    if _G.__PrintedMainFrame and type(data.mainGuiPosition) == "table" then
        printedApplyPos(_G.__PrintedMainFrame, data.mainGuiPosition)
    elseif _G.__PrintedMain and type(data.mainGuiPosition) == "table" then
        printedApplyPos(_G.__PrintedMain, data.mainGuiPosition)
    end
    if (_G.__PrintedMiniBtn or _G.__PrintedMini) and type(data.miniBtnPosition) == "table" then
        printedApplyPos(_G.__PrintedMiniBtn or _G.__PrintedMini, data.miniBtnPosition)
    end

    if tbl19 and tbl19.AutoStealEnabled and startAutoSteal then pcall(startAutoSteal) end
    pcall(refreshSpeedModeLabel)
    if _G.PrintedApplyMobilePanel then pcall(_G.PrintedApplyMobilePanel) end
    if fn41 then pcall(fn41) end
end

local function flushMobileStateLive()
    pcall(function()
        if _G.__PrintedBtnScaleObj and _G.__PrintedBtnScaleObj.Parent then
            mobileButtonScaleValue = tonumber(_G.__PrintedBtnScaleObj.Scale) or mobileButtonScaleValue or 1.0
            _G.PrintedBtnScale = mobileButtonScaleValue
            local cont = _G.__PrintedBtnScaleObj.Parent
            if cont and cont:IsA("GuiObject") then
                mobileGroupPosition = {
                    xs = cont.Position.X.Scale, x = cont.Position.X.Offset,
                    ys = cont.Position.Y.Scale, y = cont.Position.Y.Offset,
                }
            end
        end
        if type(mobileButtonFrames) == "table" then
            for name, d in pairs(mobileButtonFrames) do
                if d and d.frame and d.frame.Parent then
                    local p = d.frame.Position
                    mobileButtonPositions[name] = {
                        xs = p.X.Scale, x = p.X.Offset,
                        ys = p.Y.Scale, y = p.Y.Offset,
                    }
                end
            end
        end
    end)
end

function printedSaveConfig()
    -- re-detect writefile every save (some executors load late)
    if not _printed_writefile then
        _printed_writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile)
        _printed_readfile = _printed_readfile or readfile or (syn and syn.readfile)
        _printed_isfile = _printed_isfile or isfile or (syn and syn.isfile)
        _printed_canSaveConfig = type(_printed_writefile) == "function"
    end
    if not _printed_canSaveConfig or not _printed_writefile then return false end
    flushMobileStateLive()
    local ok, err = pcall(function()
        local data = printedCollectConfig()
        data.uiLocked = uiLocked == true
        data.hideMobileButtons = hideMobileButtons == true
        data.mobileButtonsPanel = _G.PrintedMobileButtonsPanel == true
        data.mobileButtonScaleValue = tonumber(mobileButtonScaleValue) or 1.0
        data.btnScale = data.mobileButtonScaleValue
        data.mobileGroupPosition = mobileGroupPosition or {}
        data.mobileButtonPositions = mobileButtonPositions or {}
        local json = HttpService:JSONEncode(data)
        _printed_writefile(PRINTED_CONFIG_FILE, json)
        if PRINTED_KEYBINDS_FILE then
            pcall(function()
                _printed_writefile(PRINTED_KEYBINDS_FILE, HttpService:JSONEncode(data.keybinds or {}))
            end)
        end
    end)
    if ok then
        _printedConfigDirty = false
        _printedConfigLoadedAt = tick()
        return true
    end
    warn("[Printed] save config failed: " .. tostring(err))
    return false
end
_G.PrintedSaveConfig = printedSaveConfig

function printedLoadConfig()
    if not _printed_readfile then
        _printed_readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile)
        _printed_writefile = _printed_writefile or writefile or (syn and syn.writefile)
        _printed_isfile = _printed_isfile or isfile or (syn and syn.isfile)
        _printed_canSaveConfig = type(_printed_writefile) == "function"
    end
    if not _printed_readfile then return false end
    local ok, data = pcall(function()
        if _printed_isfile and not _printed_isfile(PRINTED_CONFIG_FILE) then return nil end
        local raw = _printed_readfile(PRINTED_CONFIG_FILE)
        if not raw or raw == "" then return nil end
        return HttpService:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then
        pcall(printedApplyConfig, data)
        -- force lock / hide / panel / scale after apply so re-execute never resets
        if data.uiLocked ~= nil then
            uiLocked = data.uiLocked and true or false
        end
        if data.hideMobileButtons ~= nil then
            hideMobileButtons = data.hideMobileButtons and true or false
        end
        if data.mobileButtonsPanel ~= nil then
            _G.PrintedMobileButtonsPanel = data.mobileButtonsPanel and true or false
        end
        if data.mobileButtonScaleValue ~= nil or data.btnScale ~= nil then
            mobileButtonScaleValue = tonumber(data.mobileButtonScaleValue or data.btnScale) or 1.0
            _G.PrintedBtnScale = mobileButtonScaleValue
        end
        if type(data.mobileGroupPosition) == "table" then
            mobileGroupPosition = data.mobileGroupPosition
        end
        if type(data.mobileButtonPositions) == "table" then
            mobileButtonPositions = data.mobileButtonPositions
        end
        _printedConfigLoadedAt = tick()
        return true
    end
    return false
end
_G.PrintedLoadConfig = printedLoadConfig

function printedMarkDirty()
    _printedConfigDirty = true
    if not _printed_canSaveConfig and not _printed_writefile then
        _printed_writefile = writefile or (syn and syn.writefile)
        _printed_canSaveConfig = type(_printed_writefile) == "function"
    end
    if not _printed_canSaveConfig then return end
    -- save almost instantly (was 0.2, now 0.05)
    if _printedConfigSaveTask then return end
    _printedConfigSaveTask = task.delay(0.05, function()
        _printedConfigSaveTask = nil
        if _printedConfigDirty then
            pcall(printedSaveConfig)
        end
    end)
end
_G.PrintedMarkDirty = printedMarkDirty

function printedSavePositionsNow()
    -- flush live UI positions into tables then save immediately
    pcall(function()
        if _G.__PrintedBarFrame then
            local p = _G.__PrintedBarFrame.Position
            _G.__PrintedSavedStealPos = { xs = p.X.Scale, x = p.X.Offset, ys = p.Y.Scale, y = p.Y.Offset }
            _G.__PrintedSavedStealDragged = _G.__PrintedBarFrame:GetAttribute("UserDragged") == true
        end
        local main = _G.__PrintedMainFrame or _G.__PrintedMain
        if main then
            local p = main.Position
            _G.__PrintedSavedMainPos = { xs = p.X.Scale, x = p.X.Offset, ys = p.Y.Scale, y = p.Y.Offset }
        end
        local mini = _G.__PrintedMiniBtn or _G.__PrintedMini
        if mini then
            local p = mini.Position
            _G.__PrintedSavedMiniPos = { xs = p.X.Scale, x = p.X.Offset, ys = p.Y.Scale, y = p.Y.Offset }
        end
        for name, d in pairs(mobileButtonFrames or {}) do
            if d and d.frame then
                local p = d.frame.Position
                mobileButtonPositions[name] = { xs = p.X.Scale, x = p.X.Offset, ys = p.Y.Scale, y = p.Y.Offset }
            end
        end
        pcall(function()
            if v88 then
                local cont = v88:FindFirstChild("ButtonContainer")
                if cont then
                    mobileGroupPosition = {
                        xs = cont.Position.X.Scale, x = cont.Position.X.Offset,
                        ys = cont.Position.Y.Scale, y = cont.Position.Y.Offset,
                    }
                end
            end
        end)
    end)
    _printedConfigDirty = true
    pcall(printedSaveConfig)
end
_G.PrintedSavePositionsNow = printedSavePositionsNow


-- Intro
INTRO_MUSIC_LINKS = {
    "https://litter.catbox.moe/un88ni.mp3",
    "https://litter.catbox.moe/cnscqt.mp3",
    "https://litter.catbox.moe/yl5qct.mp3",
    "https://litter.catbox.moe/gmy92t.mp3",
    "https://litter.catbox.moe/61rdbi.mp3",
    "https://litter.catbox.moe/2pk71b.mp3",
    "https://litter.catbox.moe/kmszgk.mp3",
    "https://litter.catbox.moe/2kck1d.mp3",
    "https://litter.catbox.moe/lga6r5.mp3",
    "https://litter.catbox.moe/d4vv6y.mp3",
}
INTRO_MUSIC_DURATION = 15
_currentIntroSound = nil
_introAssetCache = {}
stopIntroPreview = nil
stopIntroPlayback = nil
createIntroSound = nil
previewIntroMusic = nil
playIntroSequence = nil
getIntroAsset = nil
_safeNotify = nil

-- Misc state
local tbl20 = {
    autoSteal = nil, antiRag = nil, batCounter = nil,
    anchor = {}, progress = nil, medusaScan = nil,
}
local tbl22 = {}
local now2 = nil
local n33 = 0
local _tpFloorLast = 0
local _PrintedMirrorTPConn = nil
local vector = Vector3.new(-476.47, -6.28, 92.73)
local vector2 = Vector3.new(-483.12, -4.95, -6.28)
local vector3 = Vector3.new(-476.16, -6.52, 7.11)
local vector4 = Vector3.new(-476.75, -4.95, 25.48)
local autoLeftConn = nil
local autoRightConn = nil
local autoLeftPhase = 1
local autoRightPhase = 1
local batCounterLastUse = 0
local aimbotConnection = nil
local autoRotateSaved = nil
local swingCooldown = false
local _v2PrevAutoRotate = nil
local _larpAimTarget = nil
local _autoBatTarget = nil
local unwalkSavedAnimate = nil
local _antiRagLastReset = 0
local unblacklistURL = "https://unblacklist-buddy.lovable.app/api/unblacklist"
local unblacklistPassword = "printed12344"
local _printedSpyWatch = true
local _printedGuiBuildSections = nil
local _printedGuiBuildFunctions = nil

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
local function clampCarrySpeed(v)
    local n = tonumber(v) or CS or 30
    if n < 1 then n = 28.9 end
    return n
end

local function getActiveMoveSpeed()
    if laggerToggled then
        return laggerPhase == 2 and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif speedMode then
        return clampCarrySpeed(CS)
    end
    return NS
end

local function getAutoPathSpeed()
    return laggerToggled and LAGGER_SPEED or NS
end

local function isRagdollState(humanoid)
    if not humanoid then return true end
    local state = humanoid:GetState()
    return humanoid.PlatformStand
        or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
end

local function isCarrySpeedMode()
    if speedMode and not laggerToggled then return true end
    return laggerToggled and laggerPhase == 2
end

local function destroyCarryForce() end

local function applyVelocitySpeed(hrp, humanoid, speed, moveDir)
    if not hrp or not humanoid or humanoid.Health <= 0 then return end
    if isRagdollState(humanoid) then return end
    moveDir = moveDir or humanoid.MoveDirection
    local y = hrp.AssemblyLinearVelocity and hrp.AssemblyLinearVelocity.Y or 0
    if moveDir and moveDir.Magnitude > 0.05 then
        local vec = Vector3.new(moveDir.X, 0, moveDir.Z)
        if vec.Magnitude < 0.05 then return end
        local unit = vec.Unit
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(localPlayer) end
        end)
        hrp.AssemblyLinearVelocity = Vector3.new(unit.X * speed, y, unit.Z * speed)
    end
end

local function isHoldingBrainrotNow()
    return _G.PrintedSafeModeHoldingBrainrot and _G.PrintedSafeModeHoldingBrainrot() or false
end

local function detectMyPlotSidePrinted()
    local side = checkMyPlot()
    if side == "left" then return "left" end
    if side == "right" then return "right" end
    local char = localPlayer.Character
    char = char and char:FindFirstChild("HumanoidRootPart")
    if char then
        return char.Position.Z < 60 and "left" or "right"
    end
    return nil
end

-- ============================================================
-- I18N
-- ============================================================
PrintedI18n = {
    code = "en",
    order = { "en", "es", "fr", "de", "pt", "ru", "zh", "ja", "ko", "it", "tr", "nl", "pl", "vi", "id", "ar", "hi", "th" },
    names = {
        en = "English", es = "Español", fr = "Français", de = "Deutsch",
        pt = "Português", ru = "Русский", zh = "中文", ja = "日本語",
        ko = "한국어", it = "Italiano", tr = "Türkçe", nl = "Nederlands",
        pl = "Polski", vi = "Tiếng Việt", id = "Indonesia", ar = "العربية",
        hi = "हिन्दी", th = "ไทย",
    },
    registry = {},
    tabLabels = {},
    orderTabs = { "SPEED", "COMBAT", "VISUAL", "MISC", "BINDS" },
    packs = {
        en = {
            SPEED = "SPEED", VISUAL = "VISUAL", MISC = "MISC", BINDS = "BINDS",
            Combat = "Combat", Steal = "Steal", Misc = "Misc", Visual = "Visual",
            ["Accent Color"] = "Accent Color", ["Button Mode"] = "Button Mode",
            Background = "Background", INTRO = "INTRO", Interface = "Interface",
            KEYBINDS = "KEYBINDS", MOVEMENT = "MOVEMENT", CHARTER = "CHARTER",
            ["Body Lock"] = "Body Lock", ["Body Lock Range (9-20)"] = "Body Lock Range (9-20)",
            ["Anti Void"] = "Anti Void", ["Aimbot Mode"] = "Aimbot Mode",
            ["Auto Swing"] = "Auto Swing", ["TP Auto Swing"] = "TP Auto Swing",
            ["Mirror TP Down"] = "Mirror TP Down", ["Bat Counter"] = "Bat Counter",
            ["Auto Grab"] = "Auto Grab", ["Grab Radius"] = "Grab Radius",
            ["Infinite Jump"] = "Infinite Jump", ["Jump Mode"] = "Jump Mode",
            ["Anti Ragdoll"] = "Anti Ragdoll", ["Medusa Counter"] = "Medusa Counter",
            Unwalk = "Unwalk", ["Anti Lag"] = "Anti Lag", ["Stretch Rez"] = "Stretch Rez",
            Tracers = "Tracers", Theme = "Theme",
            ["Auto TP Height"] = "Auto TP Height", ["Lock GUI"] = "Lock GUI",
            ["Controller Overlay"] = "Controller Overlay", ["Keyboard Overlay"] = "Keyboard Overlay",
            ["Hide Mobile Buttons"] = "Hide Mobile Buttons", ["Edit Mobile Buttons"] = "Edit Mobile Buttons",
            ["GUI Scale"] = "GUI Scale", ["Buttons Scale"] = "Buttons Scale",
            ["Steal Bar Scale"] = "Steal Bar Scale", ["Controller Scale"] = "Controller Scale",
            ["Keyboard Scale"] = "Keyboard Scale", ["Toggle Sound"] = "Toggle Sound",
            ["Normal Speed"] = "Normal Speed", ["Carry Speed"] = "Carry Speed",
            ["Lagger Normal Speed"] = "Lagger Normal Speed", ["Lagger Carry Speed"] = "Lagger Carry Speed",
            ["Auto Carry Speed"] = "Auto Carry Speed", Mode = "Mode",
            ["Animation Pack"] = "Animation Pack", Pack = "Pack",
            ["Reset All Settings"] = "Reset All Settings", Hold = "Hold", Manual = "Manual",
            V1 = "V1", V2 = "V2", AntiBypass = "AntiBypass", ON = "ON", OFF = "OFF",
            ["STATUS: ON"] = "STATUS: ON", ["STATUS: OFF"] = "STATUS: OFF",
        },
    },
}

function printedT(key)
    if key == nil then return "" end
    local str = tostring(key)
    local pack = PrintedI18n.packs[PrintedI18n.code] or PrintedI18n.packs.en
    return (pack and pack[str]) or (PrintedI18n.packs.en and PrintedI18n.packs.en[str]) or str
end
_G.PrintedT = printedT

local function fn29(obj, key)
    if not obj or not key then return obj end
    table.insert(PrintedI18n.registry, { obj = obj, key = tostring(key) })
    return obj
end

function printedApplyLanguage(code)
    if not code or not PrintedI18n.packs[code] then return end
    PrintedI18n.code = code
    _G.PrintedLanguage = code
    for _, entry in ipairs(PrintedI18n.registry) do
        if entry.obj and entry.obj.Parent and entry.key then
            pcall(function()
                if entry.obj:IsA("TextLabel") or entry.obj:IsA("TextButton") or entry.obj:IsA("TextBox") then
                    local text = printedT(entry.key)
                    if entry.obj.Font == Enum.Font.GothamBlack and entry.obj.TextSize >= 15 then
                        text = string.upper(text)
                    end
                    entry.obj.Text = text
                end
            end)
        end
    end
    for k, tabLabel in pairs(PrintedI18n.tabLabels) do
        if tabLabel and tabLabel.Parent then
            local orderTab = PrintedI18n.orderTabs and PrintedI18n.orderTabs[k]
            if orderTab then
                pcall(function() tabLabel.Text = printedT(orderTab) end)
            end
        end
    end
end
_G.PrintedApplyLanguage = printedApplyLanguage

-- ============================================================
-- ACCENT THEMES
-- ============================================================
ACCENT_THEMES = {}
ACCENT_THEMES.Blue = {
    title = Color3.fromRGB(40, 140, 255),
    stroke = Color3.fromRGB(120, 190, 255),
    grad = {
        Color3.fromRGB(30, 100, 255),
        Color3.fromRGB(180, 230, 255),
        Color3.fromRGB(80, 170, 255),
        Color3.fromRGB(160, 240, 255),
        Color3.fromRGB(40, 120, 255),
    },
    tab = Color3.fromRGB(28, 90, 180),
    sect = Color3.fromRGB(140, 120, 220),
}
ACCENT_THEMES.Silver = {
    title = Color3.fromRGB(200, 210, 225),
    stroke = Color3.fromRGB(220, 200, 215),
    grad = {
        Color3.fromRGB(140, 150, 170),
        Color3.fromRGB(230, 235, 245),
        Color3.fromRGB(170, 190, 205),
        Color3.fromRGB(240, 200, 255),
        Color3.fromRGB(150, 160, 175),
    },
    tab = Color3.fromRGB(70, 75, 90),
    sect = Color3.fromRGB(160, 180, 210),
}
ACCENT_THEMES.Pink = {
    title = Color3.fromRGB(255, 110, 180),
    stroke = Color3.fromRGB(255, 140, 190),
    grad = {
        Color3.fromRGB(255, 110, 140),
        Color3.fromRGB(255, 160, 220),
        Color3.fromRGB(200, 100, 180),
        Color3.fromRGB(255, 220, 240),
        Color3.fromRGB(220, 50, 190),
    },
    tab = Color3.fromRGB(160, 40, 140),
    sect = Color3.fromRGB(220, 80, 150),
}
ACCENT_THEMES.Green = {
    title = Color3.fromRGB(70, 220, 140),
    stroke = Color3.fromRGB(90, 240, 150),
    grad = {
        Color3.fromRGB(80, 200, 90),
        Color3.fromRGB(200, 255, 160),
        Color3.fromRGB(60, 200, 120),
        Color3.fromRGB(180, 255, 210),
        Color3.fromRGB(40, 170, 100),
    },
    tab = Color3.fromRGB(30, 120, 70),
    sect = Color3.fromRGB(120, 180, 140),
}
ACCENT_THEMES.Gold = {
    title = Color3.fromRGB(255, 200, 140),
    stroke = Color3.fromRGB(255, 180, 100),
    grad = {
        Color3.fromRGB(200, 140, 20),
        Color3.fromRGB(255, 240, 160),
        Color3.fromRGB(240, 190, 50),
        Color3.fromRGB(255, 200, 180),
        Color3.fromRGB(255, 150, 80),
    },
    tab = Color3.fromRGB(140, 100, 60),
    sect = Color3.fromRGB(220, 170, 110),
}

local function getAccent()
    return ACCENT_THEMES[_G.PrintedAccentTheme] or ACCENT_THEMES.Blue
end

_G.PrintedThemeIds = { 135988097101926, 122809280617698, 90207534864065, 75753198764412 }
_G.PrintedBtnTheme = _G.PrintedBtnTheme or 0
_G.PrintedMenuOpenAssets = {
    Blue = 127912104692615,
    Silver = 98581633454219,
    Pink = 109844708419597,
    Green = 98581633454219,
    Gold = 90522270011044,
}

-- ============================================================
-- SOUND
-- ============================================================
local TOGGLE_SOUND_PACKS = {
    V1 = {
        name = "Bubble",
        toggle = { "rbxassetid://6042053626", "rbxassetid://3398620867", "rbxassetid://255881176", "rbxassetid://12222208" },
        tab = { "rbxassetid://3398620867", "rbxassetid://6042053626", "rbxassetid://12222200" },
        pitch = 1, volume = 2,
    },
    V2 = {
        name = "Blip",
        toggle = { "rbxassetid://9113822143", "rbxassetid://6895079853", "rbxassetid://12222208" },
        tab = { "rbxassetid://9113821597", "rbxassetid://6895079733", "rbxassetid://12222200" },
        pitch = 1.15, volume = 1.6,
    },
}
_G.PrintedToggleSoundPacks = TOGGLE_SOUND_PACKS
local soundCache = {}

local function getMenuSound(idList)
    local key = table.concat(idList, "|")
    local cached = soundCache[key]
    if cached and cached.Parent then return cached end
    for _, id in ipairs(idList) do
        local ok, sound = pcall(function()
            local s = Instance.new("Sound")
            s.Name = "PrintedMenuSound"
            s.SoundId = id
            s.Parent = SoundService
            pcall(function() ContentProvider:PreloadAsync({ s }) end)
            return s
        end)
        if ok and sound then
            if sound.IsLoaded then soundCache[key] = sound return sound end
            pcall(function() sound:Destroy() end)
        end
    end
    return nil
end

function playMenuSound(kind)
    pcall(function()
        local pack = TOGGLE_SOUND_PACKS[_G.PrintedToggleSoundVersion or "V1"] or TOGGLE_SOUND_PACKS.V1
        local sound = getMenuSound(kind == "tab" and pack.tab or pack.toggle)
        if not sound then return end
        local clone = sound:Clone()
        clone.Volume = pack.volume or 1.5
        local pitch = pack.pitch or 1
        if kind == "tab" then pitch = pitch * 0.94 end
        clone.PlaybackSpeed = pitch
        clone.Parent = SoundService
        clone:Play()
        task.delay(3, function() pcall(function() clone:Destroy() end) end)
    end)
end
_G.PrintedPlayMenuSound = playMenuSound
local function fn52() playMenuSound("toggle") end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local v89, v90Notif, v91, flag21Notif, fn44Notif
local v92Notif = nil
flag21Notif = false
flag20Notif = false

local function ensureMedusaNotify()
    if v92Notif and v92Notif.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "PrintedMedusaNotify"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    local ok = false
    pcall(function() if gethui then sg.Parent = gethui() ok = true end end)
    if not ok then pcall(function() sg.Parent = CoreGui ok = true end) end
    if not ok then pcall(function() sg.Parent = localPlayer:WaitForChild("PlayerGui", 5) end) end
    v92Notif = sg
    local banner = Instance.new("Frame", sg)
    banner.Name = "Banner"
    banner.AnchorPoint = Vector2.new(0.5, 0)
    banner.Position = UDim2.new(0.5, 0, 0, 18)
    banner.Size = UDim2.new(0, 320, 0, 52)
    banner.BackgroundColor3 = Color3.fromRGB(60, 12, 16)
    banner.BorderSizePixel = 0
    banner.Visible = false
    banner.ZIndex = 50
    Instance.new("UICorner", banner).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", banner)
    stroke.Color = Color3.fromRGB(90, 16, 18)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    local icon = Instance.new("TextLabel", banner)
    icon.Size = UDim2.new(0, 36, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚠"
    icon.TextColor3 = Color3.fromRGB(255, 200, 50)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 22
    icon.ZIndex = 51
    local title = Instance.new("TextLabel", banner)
    title.Size = UDim2.new(1, -56, 0, 24)
    title.Position = UDim2.new(0, 46, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "USER HAS MEDUSA OUT!"
    title.TextColor3 = Color3.fromRGB(255, 140, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    local sub = Instance.new("TextLabel", banner)
    sub.Size = UDim2.new(1, -56, 0, 16)
    sub.Position = UDim2.new(0, 46, 0, 28)
    sub.BackgroundTransparency = 1
    sub.Text = "put it away before steal"
    sub.TextColor3 = Color3.fromRGB(255, 210, 210)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 51
    v89 = banner
    v90Notif = title
    v91 = sub
end

local hideMedNotify
hideMedNotify = function()
    if not flag21Notif or not v89 then return end
    flag21Notif = false
    local tween = TweenService:Create(v89, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -70) })
    tween:Play()
    tween.Completed:Connect(function()
        if not flag21Notif and v89 then v89.Visible = false end
    end)
end

fn44Notif = function(msg)
    ensureMedusaNotify()
    if not v89 then return end
    v90Notif.Text = "USER HAS MEDUSA OUT!"
    v91.Text = tostring(msg or "enemy")
    if not flag21Notif then
        flag21Notif = true
        v89.Visible = true
        v89.Position = UDim2.new(0.5, 0, 0, -60)
        TweenService:Create(v89, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 18) }):Play()
    end
    v92Notif = v92Notif or 0
    local id = (v92Notif or 0) + 1
    v92Notif = id
    task.delay(1.5, function()
        if id == v92Notif and flag21Notif then hideMedNotify() end
    end)
end

local function isMedusaTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return n:find("medusa", 1, true) ~= nil or n:find("medusa's head", 1, true) ~= nil or n:find("medusa head", 1, true) ~= nil
end

local function playerHasMedusa(player)
    if not player or player == localPlayer then return false, nil end
    local char = player.Character
    if not char then return false, nil end
    for _, child in ipairs(char:GetChildren()) do
        if isMedusaTool(child) then return true, child end
    end
    return false, nil
end

-- TP Bat notify
local v89Tp, v90Tp, v91Tp, flag21Tp, flag20Tp
local v92Tp = nil
local function ensureTpBatNotify()
    if v92Tp and v92Tp.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "PrintedTpBatNotify"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    local ok = false
    pcall(function() if gethui then sg.Parent = gethui() ok = true end end)
    if not ok then pcall(function() sg.Parent = CoreGui ok = true end) end
    if not ok then pcall(function() sg.Parent = localPlayer:WaitForChild("PlayerGui", 5) end) end
    v92Tp = sg
    local banner = Instance.new("Frame", sg)
    banner.Name = "Banner"
    banner.AnchorPoint = Vector2.new(0.5, 0)
    banner.Position = UDim2.new(0.5, 0, 0, 18)
    banner.Size = UDim2.new(0, 320, 0, 52)
    banner.BackgroundColor3 = Color3.fromRGB(140, 28, 32)
    banner.BorderSizePixel = 0
    banner.Visible = false
    banner.ZIndex = 50
    Instance.new("UICorner", banner).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", banner)
    stroke.Color = Color3.fromRGB(90, 16, 18)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    local icon = Instance.new("TextLabel", banner)
    icon.Size = UDim2.new(0, 36, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚠"
    icon.TextColor3 = Color3.fromRGB(255, 200, 50)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 22
    icon.ZIndex = 51
    local title = Instance.new("TextLabel", banner)
    title.Size = UDim2.new(1, -56, 0, 24)
    title.Position = UDim2.new(0, 46, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "USER IS USING TP BAT!"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    local sub = Instance.new("TextLabel", banner)
    sub.Size = UDim2.new(1, -56, 0, 16)
    sub.Position = UDim2.new(0, 46, 0, 28)
    sub.BackgroundTransparency = 1
    sub.Text = "opponent speed 100+"
    sub.TextColor3 = Color3.fromRGB(255, 210, 210)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 51
    local dismiss = Instance.new("TextButton", banner)
    dismiss.Name = "Dismiss"
    dismiss.Size = UDim2.new(1, 0, 1, 0)
    dismiss.BackgroundTransparency = 1
    dismiss.Text = ""
    dismiss.AutoButtonColor = false
    dismiss.ZIndex = 52
    dismiss.Activated:Connect(function()
        flag20Tp = true
        if hideTpBatNotify then hideTpBatNotify() end
    end)
    v89Tp = banner
    v90Tp = title
    v91Tp = sub
end

local hideTpBatNotify
hideTpBatNotify = function()
    if not flag21Tp or not v89Tp then return end
    flag21Tp = false
    local tween = TweenService:Create(v89Tp, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -70) })
    tween:Play()
    tween.Completed:Connect(function()
        if not flag21Tp and v89Tp then v89Tp.Visible = false end
    end)
end

local n33Tp = 0
local showTpBatNotify
showTpBatNotify = function(name, speed)
    ensureTpBatNotify()
    if not v89Tp then return end
    if flag21Tp then return end
    if flag20Tp then return end
    v90Tp.Text = "USER IS USING TP BAT!"
    v91Tp.Text = tostring(name or "enemy") .. "  ·  " .. tostring(math.floor(speed or 0)) .. " speed"
    flag21Tp = true
    v89Tp.Visible = true
    v89Tp.Position = UDim2.new(0.5, 0, 0, -60)
    TweenService:Create(v89Tp, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 78) }):Play()
    n33Tp = n33Tp + 1
    local id = n33Tp
    task.delay(1.5, function()
        if id ~= n33Tp then return end
        if hideTpBatNotify then hideTpBatNotify() end
        flag20Tp = true
        task.delay(2.5, function()
            if id == n33Tp then flag20Tp = false end
        end)
    end)
end

-- Safe mode notify
local v88Sm, v89Sm, v90Sm, v91Sm, v92Sm = nil, nil, nil, nil, 0

local function ensureSafeModeGui()
    if v88Sm and v88Sm.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "PrintedSafeMode"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 80
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent = CoreGui end) then
        sg.Parent = localPlayer:WaitForChild("PlayerGui", 5)
    end
    local frame = Instance.new("Frame", sg)
    frame.Name = "Banner"
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Size = UDim2.new(0, 340, 0, 58)
    frame.Position = UDim2.new(0.5, 0, 0, -70)
    frame.BackgroundColor3 = Color3.fromRGB(18, 8, 12)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 50
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(180, 50, 60)
    stroke.Thickness = 1.6
    stroke.Transparency = 0.15
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0, 4, 1, -12)
    bar.Position = UDim2.new(0, 8, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(255, 55, 65)
    bar.BorderSizePixel = 0
    bar.ZIndex = 51
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local icon = Instance.new("TextLabel", frame)
    icon.Size = UDim2.new(0, 28, 1, 0)
    icon.Position = UDim2.new(0, 20, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Text = "!"
    icon.TextColor3 = Color3.fromRGB(255, 120, 80)
    icon.Font = Enum.Font.GothamBlack
    icon.TextSize = 22
    icon.ZIndex = 52
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 22)
    title.Position = UDim2.new(0, 50, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "SAFE MODE : BLOCKED"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 52
    local sub = Instance.new("TextLabel", frame)
    sub.Size = UDim2.new(1, -60, 0, 18)
    sub.Position = UDim2.new(0, 50, 0, 30)
    sub.BackgroundTransparency = 1
    sub.Text = ""
    sub.TextColor3 = Color3.fromRGB(255, 160, 130)
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 52
    v88Sm = sg
    v89Sm = frame
    v90Sm = title
    v91Sm = sub
end

_G.PrintedSafeModeNotify = function(msg)
    ensureSafeModeGui()
    if not v89Sm then return end
    v92Sm = v92Sm + 1
    local id = v92Sm
    v90Sm.Text = "SAFE MODE : BLOCKED"
    v91Sm.Text = tostring(msg or "Action blocked while holding")
    v89Sm.Visible = true
    v89Sm.Position = UDim2.new(0.5, 0, 0, -70)
    TweenService:Create(v89Sm, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 20) }):Play()
    task.delay(1.5, function()
        if id ~= v92Sm then return end
        local tween = TweenService:Create(v89Sm, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -50) })
        tween:Play()
        tween.Completed:Connect(function()
            if id == v92Sm and v89Sm then v89Sm.Visible = false end
        end)
    end)
end

-- Anti-E01 notify
local v89Ae, v90Ae, v91Ae = nil, nil, nil
local n33Ae = 0

local function ensureAntiE01Gui()
    if v89Ae and v89Ae.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "PrintedAntiE01"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 120
    sg.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent = CoreGui end) then
        sg.Parent = localPlayer:WaitForChild("PlayerGui", 5)
    end
    local frame = Instance.new("Frame", sg)
    frame.Name = "Banner"
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, -70)
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(18, 8, 10)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 50
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Name = "Stroke"
    stroke.Color = Color3.fromRGB(200, 55, 65)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.15
    local title = Instance.new("TextLabel", frame)
    title.Name = "Title"
    title.Size = UDim2.new(1, -12, 0, 14)
    title.Position = UDim2.new(0, 6, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "ANTI E01"
    title.TextColor3 = Color3.fromRGB(255, 80, 130)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 52
    local sub = Instance.new("TextLabel", frame)
    sub.Name = "Sub"
    sub.Size = UDim2.new(1, -12, 0, 28)
    sub.Position = UDim2.new(0, 6, 0, 22)
    sub.BackgroundTransparency = 1
    sub.Text = "DONT WIN"
    sub.TextColor3 = Color3.fromRGB(255, 140, 255)
    sub.Font = Enum.Font.GothamBlack
    sub.TextSize = 16
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.ZIndex = 53
    v89Ae = frame
    v90Ae = title
    v91Ae = sub
end

_G.PrintedAntiE01Notify = function()
    ensureAntiE01Gui()
    if not v89Ae then return end
    n33Ae = n33Ae + 1
    local id = n33Ae
    local stroke = v89Ae:FindFirstChild("Stroke") or v89Ae:FindFirstChildOfClass("UIStroke")
    v89Ae.BackgroundColor3 = Color3.fromRGB(52, 8, 12)
    if stroke then stroke.Color = Color3.fromRGB(200, 55, 65) end
    v90Ae.Text = "ANTI E01"
    v90Ae.TextColor3 = Color3.fromRGB(255, 120, 80)
    v91Ae.Text = "DONT WIN"
    v91Ae.TextColor3 = Color3.fromRGB(255, 140, 255)
    v89Ae.Visible = true
    v89Ae.Position = UDim2.new(0.5, 0, 0, -60)
    TweenService:Create(v89Ae, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 16) }):Play()
    task.spawn(function()
        local remain = 2
        while remain > 0 do
            if id ~= n33Ae then return end
            local holding = false
            pcall(function() if _G.PrintedSafeModeHoldingBrainrot then holding = _G.PrintedSafeModeHoldingBrainrot() == true end end)
            if not holding then
                local tween = TweenService:Create(v89Ae, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -60) })
                tween:Play()
                tween.Completed:Connect(function()
                    if id == n33Ae and v89Ae then v89Ae.Visible = false end
                end)
                return
            end
            v90Ae.Text = "DONT WIN"
            v91Ae.Text = string.format("%.1f", remain)
            v91Ae.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.1)
            remain = remain - 0.1
        end
        if id ~= n33Ae then return end
        local holding = false
        pcall(function() if _G.PrintedSafeModeHoldingBrainrot then holding = _G.PrintedSafeModeHoldingBrainrot() == true end end)
        if holding then
            v89Ae.BackgroundColor3 = Color3.fromRGB(32, 22, 12)
            if stroke then stroke.Color = Color3.fromRGB(90, 210, 100) end
            v90Ae.Text = "ANTI E01"
            v90Ae.TextColor3 = Color3.fromRGB(80, 255, 160)
            v91Ae.Text = "SAFE"
            v91Ae.TextColor3 = Color3.fromRGB(90, 255, 140)
            task.wait(1.1)
        end
        if id ~= n33Ae then return end
        local tween = TweenService:Create(v89Ae, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -70) })
        tween:Play()
        tween.Completed:Connect(function()
            if id == n33Ae and v89Ae then
                v89Ae.Visible = false
                v89Ae.BackgroundColor3 = Color3.fromRGB(18, 8, 10)
                if stroke then stroke.Color = Color3.fromRGB(200, 55, 65) end
            end
        end)
    end)
end

-- ============================================================
-- CONFIRM DIALOG
-- ============================================================
_G.printedConfirm = function(text, onYes)
    local hui = nil
    pcall(function() if gethui then hui = gethui() end end)
    local usedCore = not hui
    if usedCore then pcall(function() hui = CoreGui end) end
    if usedCore then hui = localPlayer:FindFirstChild("PlayerGui") or localPlayer:WaitForChild("PlayerGui", 3) end
    if not hui then if onYes then pcall(onYes) end return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "PrintedConfirm"
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999
    sg.ResetOnSpawn = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    sg.Parent = hui

    local overlay = Instance.new("Frame", sg)
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 50

    local dialog = Instance.new("Frame", sg)
    dialog.AnchorPoint = Vector2.new(0.5, 0.5)
    dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    dialog.Size = UDim2.new(0, 280, 0, 130)
    dialog.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 11
    Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", dialog).Color = Color3.fromRGB(60, 60, 70)

    local title = Instance.new("TextLabel", dialog)
    title.Size = UDim2.new(1, -20, 0, 28)
    title.Position = UDim2.new(0, 10, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = text or "ARE U SURE?"
    title.TextColor3 = Color3.fromRGB(255, 255, 140)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18
    title.ZIndex = 12

    local sub = Instance.new("TextLabel", dialog)
    sub.Size = UDim2.new(1, -20, 0, 16)
    sub.Position = UDim2.new(0, 10, 0, 46)
    sub.BackgroundTransparency = 1
    sub.Text = "This cannot be undone"
    sub.TextColor3 = Color3.fromRGB(160, 160, 170)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.ZIndex = 12

    local function mkBtn(x, txt, bg, fg, cb)
        local b = Instance.new("TextButton", dialog)
        b.Size = UDim2.new(0, 110, 0, 34)
        b.Position = UDim2.new(0, x, 0, 80)
        b.BackgroundColor3 = bg
        b.BorderSizePixel = 0
        b.Text = txt
        b.TextColor3 = fg
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 13
        b.AutoButtonColor = false
        b.ZIndex = 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.Activated:Connect(function()
            pcall(function() sg:Destroy() end)
            if cb then pcall(cb) end
        end)
        return b
    end
    mkBtn(20, "NO", Color3.fromRGB(140, 40, 48), Color3.fromRGB(220, 180, 170), nil)
    mkBtn(150, "YES", Color3.fromRGB(255, 70, 80), Color3.fromRGB(255, 255, 255), onYes)

    task.delay(5, function()
        if sg and sg.Parent then pcall(function() sg:Destroy() end) end
    end)
end

-- ============================================================
-- SPEED / CARRY / LAGGER
-- ============================================================
local instance_speed = nil
speedLabel = nil

function refreshSpeedModeLabel()
    if instance_speed then
        if laggerToggled then
            instance_speed.Text = (laggerPhase == 2) and "Lagger Carry" or "Lagger Normal"
        elseif speedMode then
            instance_speed.Text = "Carry"
        else
            instance_speed.Text = "Normal"
        end
    end
end

local function blockTurnOffSpeed(msg, btnId)
    if _G.PrintedSafeModeNotify then _G.PrintedSafeModeNotify(msg or "Can't turn off speed while holding") end
    if btnId and _G.PrintedFlashBlockedButton then pcall(_G.PrintedFlashBlockedButton, btnId) end
end

function toggleCarryMode()
    local holding = safeModeEnabled and isHoldingBrainrotNow()
    if laggerToggled then
        laggerToggled = false; laggerPhase = 0; speedMode = true
    elseif speedMode then
        if holding then blockTurnOffSpeed("Can't turn off Carry while holding", "CarrySpeed") return end
        speedMode = false
    else
        speedMode = true
    end
    refreshSpeedModeLabel()
end

function toggleLaggerMode()
    local holding = safeModeEnabled and isHoldingBrainrotNow()
    if laggerToggled then
        if holding then blockTurnOffSpeed("Can't turn off Lagger while holding", "LaggerCarry") return end
        laggerToggled = false; laggerPhase = 0; speedMode = false
    else
        speedMode = false; laggerToggled = true; laggerPhase = 2
    end
    refreshSpeedModeLabel()
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
local function _antiRagForceReset()
    local char = localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("Motor6D") then d.Enabled = true end
            if d:IsA("Constraint") then d.Enabled = true end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local pm = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
        if pm then
            local CM = require(pm:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function startAntiRagdoll()
    if tbl20.antiRag then return end
    tbl20.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = localPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            local now = tick()
            if now - _antiRagLastReset > 0.15 then
                _antiRagLastReset = now
                _antiRagForceReset()
            end
        end
    end)
end

function stopAntiRagdoll()
    if tbl20.antiRag then
        tbl20.antiRag:Disconnect()
        tbl20.antiRag = nil
    end
end

-- ============================================================
-- INFINITE JUMP
-- ============================================================
local function applyInfJumpBoost(force)
    if not infJumpEnabled then return end
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local vel = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(vel.X, force or 50, vel.Z)
end

function setInfJumpMode(mode)
    local str = tostring(mode or ""):lower() == "hold" and "hold" or "manual"
    infJumpMode = str
    jumpMode = str == "hold" and "Hold" or "Manual"
    if str == "hold" then
        holdToJumpEnabled = true
        stopJumpHoldState()
        startHoldInfJump()
    else
        holdToJumpEnabled = false
        stopJumpHoldState()
        stopHoldInfJump()
    end
    if setHoldToJumpVisual then pcall(setHoldToJumpVisual, holdToJumpEnabled) end
    if setJumpModeLabel then pcall(setJumpModeLabel, jumpMode) end
    return jumpMode
end

function startHoldInfJump()
    if holdInfJumpConn then pcall(function() holdInfJumpConn:Disconnect() end) end
    JumpState.holdPressed = false
    JumpState.holdActive = false
    JumpState.mobilePressed = false
    JumpState.mobileActive = false
    JumpState.controllerActive = false
    holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "hold" then return end
        local char = localPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local spaceDown = false
        pcall(function() spaceDown = UserInputService:IsKeyDown(Enum.KeyCode.Space) end)
        local mobileDown = JumpState and JumpState.mobilePressed == true
        local gamepadDown = false
        pcall(function()
            gamepadDown = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
                or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad2, Enum.KeyCode.ButtonA)
        end)
        if not (spaceDown or mobileDown or gamepadDown) then return end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y < 40 then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z) end
        local vel2 = hrp.AssemblyLinearVelocity
        if vel2.Y < -45 then hrp.AssemblyLinearVelocity = Vector3.new(vel2.X, -45, vel2.Z) end
    end)
end

function stopHoldInfJump()
    if holdInfJumpConn then
        pcall(function() holdInfJumpConn:Disconnect() end)
        holdInfJumpConn = nil
    end
end

function stopJumpHoldState()
    JumpState.holdPressed = false
    JumpState.holdActive = false
    JumpState.controllerActive = false
    JumpState.mobilePressed = false
    JumpState.mobileActive = false
end

function startHoldToJump()
    holdToJumpEnabled = true
    infJumpEnabled = true
    infJumpMode = "hold"
    jumpMode = "Hold"
    if setJumpModeLabel then pcall(setJumpModeLabel, "Hold") end
    stopJumpHoldState()
    startHoldInfJump()
end

function stopHoldToJump()
    holdToJumpEnabled = false
    stopJumpHoldState()
    stopHoldInfJump()
end

pcall(function()
    UserInputService.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        if infJumpMode == "manual" or infJumpMode == "hold" then applyInfJumpBoost(50) end
    end)
    UserInputService.InputBegan:Connect(function(input)
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            JumpState.holdPressed = true
            if infJumpEnabled and infJumpMode == "hold" then
                task.delay(0.18, function()
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then JumpState.holdActive = true end
                end)
            end
        elseif input.KeyCode == Enum.KeyCode.ButtonA and tostring(input.UserInputType):find("Gamepad") then
            JumpState.controllerActive = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            JumpState.holdPressed = false
            JumpState.holdActive = false
        end
        if input.KeyCode == Enum.KeyCode.ButtonA then JumpState.controllerActive = false end
    end)
end)

_G.PrintedHookMobileJumpButton = function(btn)
    if not btn or btn.Name ~= "JumpButton" or not btn:IsA("GuiButton") or JumpState.hooked[btn] then return end
    JumpState.hooked[btn] = true
    btn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then return end
        JumpState.mobilePressed = true
        task.delay(0.12, function()
            if JumpState.mobilePressed and infJumpEnabled and infJumpMode == "hold" then JumpState.mobileActive = true end
        end)
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            JumpState.mobilePressed = false
            JumpState.mobileActive = false
        end
    end)
end

task.spawn(function()
    local pg = localPlayer:WaitForChild("PlayerGui", 10)
    if not pg then return end
    for _, d in ipairs(pg:GetDescendants()) do pcall(_G.PrintedHookMobileJumpButton, d) end
    pg.DescendantAdded:Connect(function(d) task.defer(_G.PrintedHookMobileJumpButton, d) end)
end)

-- ============================================================
-- UNWALK
-- ============================================================
function startUnwalk()
    local char = localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop() end end
    local animate = char:FindFirstChild("Animate")
    if animate then
        unwalkSavedAnimate = animate:Clone()
        animate:Destroy()
    end
end

function stopUnwalk()
    local char = localPlayer.Character
    if char and unwalkSavedAnimate then
        unwalkSavedAnimate:Clone().Parent = char
        unwalkSavedAnimate = nil
    end
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
function runDrop()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled = false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if disableAutoBat then pcall(disableAutoBat) end
    end
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    dropActive = true
    local startTime = tick()
    local conn = nil
    conn = RunService.Heartbeat:Connect(function()
        local c2 = localPlayer.Character
        local hrp = c2 and c2:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if conn then conn:Disconnect() end
            dropActive = false
            return
        end
        if tick() - startTime >= 0.2 then
            if conn then conn:Disconnect() end
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = { c2 }
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -2000, 0), rp)
            if hit then
                local hum = c2:FindFirstChildOfClass("Humanoid")
                hrp.CFrame = CFrame.new(hrp.Position.X, hit.Position.Y + (hum and hum.HipHeight or 2) + hrp.Size.Y / 2, hrp.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            dropActive = false
            return
        end
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 150, hrp.AssemblyLinearVelocity.Z)
    end)
end

-- ============================================================
-- TP DOWN / MIRROR TP
-- ============================================================
_tpFloorLast = 0

function doAutoTPDown(force)
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if hrp.Position.Y < autoTPHeight then return end
    end
    local _, y = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) * CFrame.Angles(0, y, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

function startAutoTP()
    if autoTPConn then task.cancel(autoTPConn) autoTPConn = nil end
    autoTPConn = task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
end

function stopAutoTP(keepEnabled)
    if autoTPConn then task.cancel(autoTPConn) autoTPConn = nil end
    if not keepEnabled then autoTPEnabled = false end
end

function runTPFloor()
    if suspendBodyLock then pcall(suspendBodyLock) end
    pcall(function() doAutoTPDown(true) end)
    task.delay(0.6, function()
        if not autoBatEnabled and not tpBatEnabled then
            if restoreBodyLock then pcall(restoreBodyLock) end
        end
    end)
end

if not _PrintedMirrorTPConn then
    _PrintedMirrorTPConn = RunService.Heartbeat:Connect(function()
        local active = mirrorTPDownEnabled and (autoBatEnabled == true or tpBatEnabled == true)
        if not active then
            if next(tbl22) then table.clear(tbl22) end
            return
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local y = hrp.Position.Y
                    local last = tbl22[player.UserId]
                    if last and last - y >= 3 then
                        pcall(function()
                            local lc = localPlayer.Character
                            local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
                            lc = lc and lc:FindFirstChildOfClass("Humanoid")
                            if lhrp and lc and lc.Health > 0 then
                                local _, ly = lhrp.CFrame:ToEulerAnglesYXZ()
                                lhrp.CFrame = CFrame.new(lhrp.Position.X, -7, lhrp.Position.Z) * CFrame.Angles(0, ly, 0)
                                lhrp.AssemblyLinearVelocity = Vector3.zero
                            end
                        end)
                        table.clear(tbl22)
                        return
                    end
                    tbl22[player.UserId] = y
                end
            end
        end
    end)
end

-- ============================================================
-- ANTI-VOID
-- ============================================================
local function voidRaycast(pos)
    local origin = pos + Vector3.new(0, 2, 0)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local char = localPlayer.Character
    if char then rp.FilterDescendantsInstances = { char } end
    rp.IgnoreWater = true
    return workspace:Raycast(origin, Vector3.new(0, -80, 0), rp)
end

local function antiVoidRestore(hrp, hum)
    if not antiVoidSafeCFrame then return end
    hrp.CFrame = antiVoidSafeCFrame + Vector3.new(0, 5, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.zero
    hum.PlatformStand = false
    hum.Sit = false
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    pcall(function() if sethiddenproperty then sethiddenproperty(hrp, "NetworkIsSleeping", false) end end)
end

function stopAntiVoid()
    if antiVoidConn then pcall(function() antiVoidConn:Disconnect() end) antiVoidConn = nil end
    if antiVoidSteppedConn then pcall(function() antiVoidSteppedConn:Disconnect() end) antiVoidSteppedConn = nil end
    antiVoidEnabled = false
end

function startAntiVoid()
    stopAntiVoid()
    antiVoidEnabled = true
    antiVoidConn = RunService.Heartbeat:Connect(function()
        if not antiVoidEnabled then return end
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        char = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not char or hum.Health <= 0 then return end
        local threshold = (workspace.FallenPartsDestroyHeight or -500) + 30
        local y = char.Position.Y
        local vel = char.AssemblyLinearVelocity
        if hum.FloorMaterial ~= Enum.Material.Air and y > threshold + 15 then
            antiVoidSafeCFrame = char.CFrame
            antiVoidLastGround = tick()
        else
            local hit = voidRaycast(char)
            if hit and y > threshold + 12 then
                local rot = char.CFrame - char.CFrame.Position
                antiVoidSafeCFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) * rot
                antiVoidLastGround = tick()
            end
        end
        if (y <= threshold or (y <= threshold + 8 and vel.Y < -90) or y < threshold - 20) and antiVoidSafeCFrame then
            antiVoidRestore(char, hum)
        end
    end)
    antiVoidSteppedConn = RunService.Stepped:Connect(function()
        if not antiVoidEnabled then return end
        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        char = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not char then return end
        if hrp.Position.Y <= (workspace.FallenPartsDestroyHeight or -500) + 30 and antiVoidSafeCFrame then
            antiVoidRestore(hrp, char)
        end
    end)
end

function setAntiVoid(enabled)
    if enabled then startAntiVoid() else stopAntiVoid() end
    if setAntiVoidVisual then pcall(setAntiVoidVisual, antiVoidEnabled) end
end

-- ============================================================
-- BODY LOCK
-- ============================================================
local function findBodyLockTarget()
    local char = localPlayer.Character
    char = char and char:FindFirstChild("HumanoidRootPart")
    if not char then return nil end
    local closest, minDist = nil, math.huge
    local radius = math.clamp(tonumber(bodyLockRadius) or 12, 9, 20)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - char.Position).Magnitude
                if d <= radius and d < minDist then
                    minDist = d
                    closest = player
                end
            end
        end
    end
    return closest
end

function startBodyLock()
    if bodyLockConn then return end
    bodyLockEnabled = true
    bodyLockConn = RunService.Heartbeat:Connect(function()
        if not bodyLockEnabled then return end
        if autoBatEnabled or tpBatEnabled then
            local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
            return
        end
        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local target = findBodyLockTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tp = target.Character.HumanoidRootPart.Position
            local sp = hrp.Position
            local look = Vector3.new(tp.X, sp.Y, tp.Z)
            if (look - sp).Magnitude > 0.1 then
                hum.AutoRotate = false
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.lookAt(sp, look), 0.22)
                hrp.AssemblyAngularVelocity = hrp.AssemblyAngularVelocity * Vector3.new(0.5, 0.25, 0.5)
            end
        else
            hum.AutoRotate = true
        end
    end)
end

function stopBodyLock()
    bodyLockEnabled = false
    if bodyLockConn then
        pcall(function() bodyLockConn:Disconnect() end)
        bodyLockConn = nil
    end
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

_printedBodyLockSuspended = false

function forceBodyLockOffForAimbot()
    if bodyLockEnabled or _G.PrintedBodyLockEnabled then
        _printedBodyLockSuspended = true
        bodyLockEnabled = false
        _G.PrintedBodyLockEnabled = false
        pcall(stopBodyLock)
        if setBodyLockVisual then pcall(setBodyLockVisual, false) end
    end
end

function suspendBodyLock() forceBodyLockOffForAimbot() end

function restoreBodyLock()
    if not _printedBodyLockSuspended then return end
    _printedBodyLockSuspended = false
    bodyLockEnabled = true
    _G.PrintedBodyLockEnabled = true
    pcall(startBodyLock)
    if setBodyLockVisual then pcall(setBodyLockVisual, true) end
end

-- ============================================================
-- MEDUSA COUNTER
-- ============================================================
local function findMedusa()
    local char = localPlayer.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return child end
        end
    end
    local bp = localPlayer:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return child end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < 25 then return end
    local char = localPlayer.Character
    if not char then return end
    medusaDebounce = true
    local tool = findMedusa()
    if not tool then medusaDebounce = false return end
    if tool.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:EquipTool(tool) end
    end
    pcall(function() tool:Activate() end)
    medusaLastUsed = tick()
    medusaDebounce = false
end

function onMedusaStoned()
    local now = tick()
    if now < (_medusaStoneUntil or 0) - 2.5 then return end
    _medusaStoneUntil = now + 3
    _medusaGrabResumeAt = now + 1.7
    if flag18 then
        flag18 = false
        if tbl20.progress then pcall(function() tbl20.progress:Disconnect() end) tbl20.progress = nil end
        if _G.resetProgressBar then _G.resetProgressBar() end
        if textLabel2 then textLabel2.Text = "75%" end
        if frame then frame.Size = UDim2.new(0.75, 0, 1, 0) end
    end
    if tbl19.AutoStealEnabled then
        _medusaStealWasOn = true
        if stopNormalSteal then pcall(stopNormalSteal) end
    end
    task.delay(1.7, function()
        if tick() < (_medusaGrabResumeAt or 0) - 0.05 then return end
        if _medusaStealWasOn or tbl19.AutoStealEnabled then
            _medusaStealWasOn = false
            tbl19.AutoStealEnabled = true
            if startAutoSteal then pcall(startAutoSteal) end
            if textLabel2 then textLabel2.Text = "0%" end
            if frame then frame.Size = UDim2.new(0, 0, 1, 0) end
        end
    end)
end

function isMedusaStoneLocked() return tick() < (_medusaGrabResumeAt or 0) end

function setupMedusa(character)
    for _, c in pairs(tbl20.anchor) do pcall(function() c:Disconnect() end) end
    tbl20.anchor = {}
    if not character then return end
    local function hook(part)
        if not part:IsA("BasePart") then return end
        local function check()
            if part and part.Parent and part.Anchored and part.Transparency >= 0.9 then
                pcall(onMedusaStoned)
                if medusaCounterEnabled then useMedusaCounter() end
            end
        end
        table.insert(tbl20.anchor, part:GetPropertyChangedSignal("Anchored"):Connect(check))
        table.insert(tbl20.anchor, part:GetPropertyChangedSignal("Transparency"):Connect(check))
    end
    for _, d in ipairs(character:GetDescendants()) do hook(d) end
    table.insert(tbl20.anchor, character.DescendantAdded:Connect(hook))
end

function stopMedusaCounter()
    for _, c in pairs(tbl20.anchor) do pcall(function() c:Disconnect() end) end
    tbl20.anchor = {}
    if tbl20.medusaScan then pcall(function() tbl20.medusaScan:Disconnect() end) tbl20.medusaScan = nil end
end

-- ============================================================
-- BAT COUNTER
-- ============================================================
local batTools = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap",
    "Galaxy Slap", "Glitched Slap",
}

local function findBatForCounter()
    local char = localPlayer.Character
    if not char then return nil end
    local bp = localPlayer:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(batTools) do
        local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t and t:IsA("Tool") then return t end
    end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") then
            local n = c.Name:lower()
            if n:find("bat") or n:find("slap") then return c end
        end
    end
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") then
                local n = c.Name:lower()
                if n:find("bat") or n:find("slap") then return c end
            end
        end
    end
    return nil
end

local function swingBatForCounter(tool, char)
    if not tool or not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end
    local re = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildWhichIsA("RemoteEvent")
    if re then
        pcall(function() re:FireServer() end)
        pcall(function() re:FireServer() end)
    end
    pcall(function() tool:Activate() end)
    pcall(function() tool:Activate() end)
end

local function tryBatCounter()
    if not batCounterEnabled then return end
    local now = tick()
    if now - batCounterLastUse < 0.08 then return end
    local char = localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
        or hum.PlatformStand then
        batCounterLastUse = now
        local tool = findBatForCounter()
        if tool then swingBatForCounter(tool, char) end
    end
end

function startBatCounter()
    if tbl20.batCounter then return end
    tbl20.batCounter = RunService.Heartbeat:Connect(tryBatCounter)
    local function hookChar(char)
        char = char and char:FindFirstChildOfClass("Humanoid")
        if not char then return end
        local c = char.StateChanged:Connect(function(_, new)
            if not batCounterEnabled then return end
            if new == Enum.HumanoidStateType.Physics
                or new == Enum.HumanoidStateType.Ragdoll
                or new == Enum.HumanoidStateType.FallingDown then
                tryBatCounter()
            end
        end)
        tbl20.batStateConns = tbl20.batStateConns or {}
        table.insert(tbl20.batStateConns, c)
    end
    if localPlayer.Character then hookChar(localPlayer.Character) end
    if not tbl20.batCharAdded then
        tbl20.batCharAdded = localPlayer.CharacterAdded:Connect(function(c) task.defer(hookChar, c) end)
    end
end

function stopBatCounter()
    if tbl20.batCounter then tbl20.batCounter:Disconnect() tbl20.batCounter = nil end
    if tbl20.batStateConns then
        for _, c in ipairs(tbl20.batStateConns) do pcall(function() c:Disconnect() end) end
        tbl20.batStateConns = {}
    end
    if tbl20.batCharAdded then pcall(function() tbl20.batCharAdded:Disconnect() end) tbl20.batCharAdded = nil end
    batCounterLastUse = 0
end

-- ============================================================
-- AIMBOT
-- ============================================================
local function getAceAimbotSpeed()
    if laggerToggled then return tonumber(LAGGER_AIMBOT_SPEED) or 90 end
    return tonumber(AIMBOT_SPEED) or 58
end

local function envyGetBat()
    local char = localPlayer.Character
    if not char then return nil end
    for _, name in ipairs(batTools) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = localPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(batTools) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") and (c.Name:lower():find("bat") or c.Name:lower():find("slap")) then return c end
    end
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") and (c.Name:lower():find("bat") or c.Name:lower():find("slap")) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(c) end) end
                return c
            end
        end
    end
    return nil
end

local function envyTrySwing()
    if swingCooldown or not autoSwingEnabled then return end
    swingCooldown = true
    pcall(function()
        local char = localPlayer.Character
        if not char then return end
        local tool = envyGetBat()
        if tool then
            if tool.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(tool) end) end
            end
            pcall(function() tool:Activate() end)
        end
    end)
    task.delay(0.25, function() swingCooldown = false end)
end

local function getClosestTarget()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local phrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if phrp and hum and hum.Health > 0 then
                local d = (phrp.Position - hrp.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = player
                end
            end
        end
    end
    return closest, minDist
end

function resetAutoBatMotion()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y * 0.3, 0)
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then
        hum.AutoRotate = autoRotateSaved == nil and true or autoRotateSaved
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    autoRotateSaved = nil
end

function stopEnvoyOrV1Aimbot()
    if aimbotConnection then
        pcall(function() aimbotConnection:Disconnect() end)
        aimbotConnection = nil
    end
    _larpAimTarget = nil
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    char = char and char:FindFirstChildOfClass("Humanoid")
    if char then char.AutoRotate = autoRotateSaved == nil and true or autoRotateSaved end
    autoRotateSaved = nil
end

function startEnvoyOrV1Aimbot()
    stopEnvoyOrV1Aimbot()
    forceBodyLockOffForAimbot()
    aimbotMode = "V1"
    if autoLeftEnabled then autoLeftEnabled = false if autoLeftSetVisual then autoLeftSetVisual(false) end pcall(stopAutoLeft) end
    if autoRightEnabled then autoRightEnabled = false if autoRightSetVisual then autoRightSetVisual(false) end pcall(stopAutoRight) end
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if autoRotateSaved == nil then autoRotateSaved = hum.AutoRotate end
        hum.AutoRotate = false
    end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled or aimbotMode ~= "V1" then return end
        local char = localPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local tool = envyGetBat()
            if tool then pcall(function() hum:EquipTool(tool) end) end
        end
        local target = getClosestTarget()
        if not target or not target.Character then return end
        local phrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not phrp then return end
        _larpAimTarget = phrp
        local pvel = phrp.AssemblyLinearVelocity
        local sp = hrp.Position
        local tp = phrp.Position
        local delta = tp + pvel * 0.14 + phrp.CFrame.LookVector * 0.3 - sp
        local unit = Vector3.new(delta.X, 0, delta.Z).Unit
        local speed = getAceAimbotSpeed()
        local yForce = (tp.Y + 3.7 - sp.Y) * 19.5 + pvel.Y * 0.8
        local finalY = hum.FloorMaterial == Enum.Material.Air and yForce or math.max(yForce, 13)
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * speed, math.clamp(finalY, -70, 110), unit.Z * speed), 0.8)
        local aimAt = tp + pvel * math.clamp(pvel.Magnitude / 120, 0.05, 0.2)
        if (aimAt - sp).Magnitude > 0.1 then
            local cframe = CFrame.lookAt(sp, aimAt)
            local rx, ry, rz = (hrp.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
            hrp.AssemblyAngularVelocity = hrp.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -2.5, 2.5) * 42,
                math.clamp(ry, -2.5, 2.5) * 42,
                math.clamp(rz, -2.5, 2.5) * 42
            ))
        end
        if autoSwingEnabled then envyTrySwing() end
    end)
end

function stopAntiBypassAimbotConn()
    if aimbotConnection then
        pcall(function() aimbotConnection:Disconnect() end)
        aimbotConnection = nil
    end
    swingCooldown = false
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = autoRotateSaved == nil and true or autoRotateSaved
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    autoRotateSaved = nil
end

function startAntiBypassAimbotConn()
    stopAntiBypassAimbotConn()
    forceBodyLockOffForAimbot()
    if aimbotMode ~= "AntiBypass" then aimbotMode = "V2" end
    if autoLeftEnabled then autoLeftEnabled = false if autoLeftSetVisual then autoLeftSetVisual(false) end pcall(stopAutoLeft) end
    if autoRightEnabled then autoRightEnabled = false if autoRightSetVisual then autoRightSetVisual(false) end pcall(stopAutoRight) end
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if autoRotateSaved == nil then autoRotateSaved = hum.AutoRotate end
        hum.AutoRotate = false
    end
    swingCooldown = false
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        if aimbotMode ~= "V2" and aimbotMode ~= "AntiBypass" then return end
        local char = localPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local tool = envyGetBat()
            if tool then pcall(function() hum:EquipTool(tool) end) end
        end
        local target, dist = getClosestTarget()
        if not target or not target.Character then return end
        local phrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not phrp then return end
        local sp = hrp.Position
        local tp = phrp.Position
        local delta = tp - sp
        local flat = Vector3.new(delta.X, 0, delta.Z)
        local unit = flat.Magnitude > 0 and flat.Unit or Vector3.zero
        local speed = getAceAimbotSpeed()
        local yForce = (tp.Y + 3.7 - sp.Y) * 19.5
        local finalY = hum.FloorMaterial == Enum.Material.Air and yForce or math.max(yForce, 13)
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * speed, math.clamp(finalY, -70, 110), unit.Z * speed), 0.8)
        if (tp - sp).Magnitude > 0.1 then
            local cframe = CFrame.lookAt(sp, tp)
            local rx, ry, rz = (hrp.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
            hrp.AssemblyAngularVelocity = hrp.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -2.5, 2.5) * 42,
                math.clamp(ry, -2.5, 2.5) * 42,
                math.clamp(rz, -2.5, 2.5) * 42
            ))
        end
        if dist <= 8 then envyTrySwing() end
    end)
end

function applyAimbotMode()
    local mode = tostring(aimbotMode or "V1")
    if mode == "AntiBypass" or mode == "Anti Bypass" or mode == "V2" or mode == "Kawatan" then
        aimbotMode = "V2"
        _G.PrintedAntiBypassAimbot = false
    else
        aimbotMode = "V1"
        _G.PrintedAntiBypassAimbot = false
    end
    AUTO_BAT_SPEED = tonumber(AIMBOT_SPEED) or 58
    if fn44 then pcall(fn44, aimbotMode) end
end

function stopKawatanAimbotConn() stopAntiBypassAimbotConn() end
function startKawatanAimbotConn() startAntiBypassAimbotConn() end

function enableAutoBat()
    if autoLeftEnabled then autoLeftEnabled = false if autoLeftSetVisual then autoLeftSetVisual(false) end stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false if autoRightSetVisual then autoRightSetVisual(false) end stopAutoRight() end
    if autoTPEnabled then stopAutoTP() if setAutoTPVisual then setAutoTPVisual(false) end end
    autoBatEnabled = true
    pcall(function()
        local char = localPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local tool = envyGetBat()
        if tool and tool.Parent ~= char then pcall(function() hum:EquipTool(tool) end) end
    end)
    pcall(stopAntiBypassAimbotConn)
    pcall(stopEnvoyOrV1Aimbot)
    applyAimbotMode()
    if aimbotMode == "V1" then
        startEnvoyOrV1Aimbot()
    else
        aimbotMode = "V2"
        startAntiBypassAimbotConn()
    end
end

function disableAutoBat()
    autoBatEnabled = false
    pcall(stopEnvoyOrV1Aimbot)
    pcall(stopAntiBypassAimbotConn)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    char = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.3
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if char then char.AutoRotate = _v2PrevAutoRotate == nil and true or _v2PrevAutoRotate end
    _v2PrevAutoRotate = nil
    if restoreBodyLock then pcall(restoreBodyLock) end
end

function queueAutoBatStart()
    if _G.PrintedSafeModeTryStart and not _G.PrintedSafeModeTryStart("You clicked Aimbot / Auto Bat", "AutoBat") then
        if autoBatSetVisual then autoBatSetVisual(false) end
        return
    end
    if autoLeftEnabled then autoLeftEnabled = false if au…"
 content://media/external/downloads/1000103101#:~:text=%2D%2D%20%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%0A%2D%2D%20%231%20deobf%20by,print(%22%5BPrinted%5D%20ready%22)