-- Exported from Faulmor
-- title: NEW RANA DUELS
-- format: faulmor.v2.compat-vm
-- exported_at: 2026-09-12T01:16:38.035Z

-- Faulmor Safe Mode (compat runner — full VM failed)
-- safe-mode (plain loadstring fallback)
do
  local __fm_src = [[-- RANA.VS | BLACK + WHITE EDITION
local BG         = Color3.fromRGB(0, 0, 0)
local SIDEBAR_BG = Color3.fromRGB(1, 1, 1)
local CARD_BG    = Color3.fromRGB(2, 2, 2)
local CARD_HOV   = Color3.fromRGB(4, 4, 4)
local KB_BG      = Color3.fromRGB(16, 16, 16)

local WHITE      = Color3.fromRGB(255, 255, 255)
local DIM        = Color3.fromRGB(115, 115, 115)
local DIM2       = Color3.fromRGB(1, 1, 1)

local BORDER     = Color3.fromRGB(18, 18, 18)
local BORDER2    = Color3.fromRGB(31, 31, 31)
local OPTION_TRANSPARENCY = 0.42
local OPTION_HOVER_TRANSPARENCY = 0.22
local TAB_TRANSPARENCY = 0.35
local TAB_HOVER_TRANSPARENCY = 0.16
local INPUT_TRANSPARENCY = 0.24

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- RANA.VS configuration is declared before the Mechanics UI uses it.
local CONFIG = {AUTO_STEAL_ENABLED=false, STEAL_RANGE=61, AUTO_STEAL_MODE="normal"}


task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__RANA_HIGH_PING_RUN = (env.__RANA_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__RANA_HIGH_PING_RUN
    env.__RANA_INTRO_FINISHED_RUN = 0
    local shown = false

    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end

            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end

            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end

    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

        pcall(function()
            local old = CoreGui:FindFirstChild("RanaHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("RanaHighPingAlert")
            if old then old:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "RanaHighPingAlert"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end

        local bar = Instance.new("Frame")
        bar.Name = "AlertBar"
        bar.AnchorPoint = Vector2.new(0.5, 0)
        bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        bar.BackgroundTransparency = 0.06
        bar.BorderSizePixel = 0
        bar.ClipsDescendants = true
        bar.ZIndex = 100
        bar.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = bar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(30, 30, 30)
        stroke.Transparency = 0.2
        stroke.Thickness = 1
        stroke.Parent = bar

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 9, 9)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(17, 17, 17)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 9, 9)),
        })
        gradient.Parent = bar

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(4, 4, 4)
        label.TextStrokeTransparency = 0.55
        label.TextWrapped = false
        label.TextScaled = false
        label.ZIndex = 102
        label.Parent = bar

        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        task.wait(2)

        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play()
        slideOut.Completed:Wait()
        gui:Destroy()
    end

    while env.__RANA_HIGH_PING_RUN == thisRun and env.__RANA_INTRO_FINISHED_RUN ~= thisRun do
        task.wait(0.1)
    end

    while env.__RANA_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)

do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")

    local noIntroSaved = false
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile("RANA_DUELS_V8_CONFIG.json") then
            local decoded = HttpService:JSONDecode(readfile("RANA_DUELS_V8_CONFIG.json"))
            if type(decoded) == "table" then
                if decoded.noIntro ~= nil then
                    noIntroSaved = decoded.noIntro == true
                elseif decoded.introEnabled ~= nil then
                    noIntroSaved = decoded.introEnabled ~= true
                end
            end
        end
    end)
    local sharedEnv = (getgenv and getgenv()) or _G
    sharedEnv.__RANA_NO_INTRO_SAVED = noIntroSaved

    for _, n in ipairs({"RanaIntro", "RanaHoneypotGui", "AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function()
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
        end)
    end

    if not noIntroSaved then
        local introDone = Instance.new("BindableEvent")
        local introScreenGui = Instance.new("ScreenGui")
        introScreenGui.Name = "RanaIntro"
        introScreenGui.ResetOnSpawn = false
        introScreenGui.IgnoreGuiInset = true
        introScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        introScreenGui.DisplayOrder = 999999
        pcall(function() introScreenGui.Parent = game:GetService("CoreGui") end)
        if not introScreenGui.Parent then
            local lp = game:GetService("Players").LocalPlayer
            if lp then introScreenGui.Parent = lp:WaitForChild("PlayerGui") end
        end
        local screenGui = introScreenGui
        local introFinished = false
        local introSound
        local introLayer

        local function finishIntro()
            if introFinished then return end
            introFinished = true
            pcall(function()
                if introSound then
                    introSound:Stop()
                    introSound:Destroy()
                    introSound = nil
                end
            end)
            pcall(function()
                if introLayer then
                    introLayer:Destroy()
                    introLayer = nil
                end
            end)
            pcall(function() introDone:Fire() end)
        end

        task.delay(5.8, finishIntro)

        introSound = Instance.new("Sound")
        introSound.Name = "RanaIntroSound"
        introSound.SoundId = "rbxassetid://126107591945718"
        introSound.Volume = 0.75
        introSound.Looped = false
        introSound.Parent = game:GetService("SoundService")
        pcall(function()
            introSound:Play()
            local started = os.clock()
            while not introSound.IsLoaded and os.clock() - started < 2 do
                task.wait()
            end
            introSound.TimePosition = 34
        end)

        introLayer = Instance.new("Frame")
        introLayer.Name = "RanaIntro"
        introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introLayer.BackgroundTransparency = 1
        introLayer.BorderSizePixel = 0
        introLayer.Size = UDim2.fromScale(1, 1)
        introLayer.Position = UDim2.fromScale(0, 0)
        introLayer.ClipsDescendants = true
        introLayer.ZIndex = 1000
        introLayer.Parent = screenGui

        local skipIntroButton = Instance.new("TextButton")
        skipIntroButton.Name = "SkipIntroButton"
        skipIntroButton.AnchorPoint = Vector2.new(1, 1)
        skipIntroButton.Position = UDim2.new(1, -18, 1, -18)
        skipIntroButton.Size = UDim2.new(0, 132, 0, 36)
        skipIntroButton.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        skipIntroButton.BackgroundTransparency = 0.08
        skipIntroButton.BorderSizePixel = 0
        skipIntroButton.AutoButtonColor = false
        skipIntroButton.Text = "SKIP INTRO  ›"
        skipIntroButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        skipIntroButton.TextSize = 13
        skipIntroButton.Font = Enum.Font.GothamBold
        skipIntroButton.ZIndex = 1200
        skipIntroButton.Parent = introLayer

        local skipCorner = Instance.new("UICorner")
        skipCorner.CornerRadius = UDim.new(0, 10)
        skipCorner.Parent = skipIntroButton

        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(33, 33, 33)
        skipStroke.Transparency = 0.08
        skipStroke.Thickness = 1
        skipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        skipStroke.Parent = skipIntroButton

        skipIntroButton.MouseEnter:Connect(function()
            if introFinished then return end
            TweenService:Create(skipIntroButton, TweenInfo.new(0.14), {
                BackgroundColor3 = Color3.fromRGB(11, 11, 11)
            }):Play()
        end)

        skipIntroButton.MouseLeave:Connect(function()
            if introFinished then return end
            TweenService:Create(skipIntroButton, TweenInfo.new(0.14), {
                BackgroundColor3 = Color3.fromRGB(8, 8, 8)
            }):Play()
        end)

        skipIntroButton.Activated:Connect(function()
            if introFinished then return end
            skipIntroButton.Active = false
            TweenService:Create(skipIntroButton, TweenInfo.new(0.08), {
                Size = UDim2.new(0, 118, 0, 34),
                BackgroundTransparency = 0.35
            }):Play()
            task.delay(0.06, finishIntro)
        end)

        local introImage = Instance.new("ImageLabel")
        introImage.Name = "IntroBackground"
        introImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introImage.BackgroundTransparency = 1
        introImage.BorderSizePixel = 0
        introImage.AnchorPoint = Vector2.new(0.5, 0.5)
        introImage.Position = UDim2.fromScale(0.5, 0.5)
        introImage.Size = UDim2.fromScale(1.08, 1.08)
        introImage.Image = "rbxassetid://87560534822370"
        introImage.ScaleType = Enum.ScaleType.Crop
        introImage.ImageColor3 = Color3.fromRGB(134, 134, 134)
        introImage.ImageTransparency = 0.52
        introImage.ZIndex = 1001
        introImage.Parent = introLayer

        local introShade = Instance.new("Frame")
        introShade.Name = "RedShade"
        introShade.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
        introShade.BackgroundTransparency = 0.88
        introShade.BorderSizePixel = 0
        introShade.Size = UDim2.fromScale(1, 1)
        introShade.ZIndex = 1002
        introShade.Parent = introLayer

        local introVignette = Instance.new("ImageLabel")
        introVignette.Name = "Vignette"
        introVignette.BackgroundTransparency = 1
        introVignette.Size = UDim2.fromScale(1, 1)
        introVignette.Image = "rbxassetid://4576475446"
        introVignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
        introVignette.ImageTransparency = 0.72
        introVignette.ScaleType = Enum.ScaleType.Stretch
        introVignette.ZIndex = 1003
        introVignette.Parent = introLayer

        local scanlineHolder = Instance.new("Frame")
        scanlineHolder.Name = "Scanlines"
        scanlineHolder.BackgroundTransparency = 1
        scanlineHolder.Size = UDim2.fromScale(1, 1)
        scanlineHolder.ZIndex = 1004
        scanlineHolder.Parent = introLayer
        for y = 0, 1, 0.085 do
            local line = Instance.new("Frame")
            line.BorderSizePixel = 0
            line.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
            line.BackgroundTransparency = 0.985
            line.Position = UDim2.fromScale(0, y)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.ZIndex = 1004
            line.Parent = scanlineHolder
        end

        local introContent = Instance.new("Frame")
        introContent.Name = "IntroContent"
        introContent.AnchorPoint = Vector2.new(0.5, 0.5)
        introContent.BackgroundTransparency = 1
        introContent.Position = UDim2.fromScale(0.5, 0.5)
        introContent.Size = UDim2.new(0.96, 0, 0, 180)
        introContent.ZIndex = 1005
        introContent.Parent = introLayer

        local function makeIntroText(name, color, transparency, zindex)
            local label = Instance.new("TextLabel")
            label.Name = name
            label.BackgroundTransparency = 1
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.Position = UDim2.fromScale(0.5, 0.5)
            label.Size = UDim2.new(1, -12, 0, 110)
            label.Font = Enum.Font.GothamBlack
            label.Text = "↻  RANA  ↻"
            label.TextColor3 = color
            label.TextSize = 58
            label.TextTransparency = transparency
            label.TextStrokeColor3 = Color3.fromRGB(4, 4, 4)
            label.TextStrokeTransparency = 0.18
            label.ZIndex = zindex
            label.Parent = introContent
            return label
        end

        local introGlitchDark = makeIntroText("GlitchDark", Color3.fromRGB(6, 6, 6), 1, 1005)
        local introGlitchBright = makeIntroText("GlitchBright", Color3.fromRGB(25, 25, 25), 1, 1006)
        local introTitleGlow = makeIntroText("IntroTitleGlow", Color3.fromRGB(22, 22, 22), 1, 1007)
        introTitleGlow.TextSize = 64
        introTitleGlow.TextStrokeColor3 = Color3.fromRGB(22, 22, 22)
        introTitleGlow.TextStrokeTransparency = 0.42

        local introTitle = makeIntroText("IntroTitle", Color3.fromRGB(52, 52, 52), 1, 1008)
        local introTitleGradient = Instance.new("UIGradient")
        introTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 9, 9)),
            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(35, 35, 35)),
            ColorSequenceKeypoint.new(0.56, Color3.fromRGB(110, 110, 110)),
            ColorSequenceKeypoint.new(0.76, Color3.fromRGB(24, 24, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))
        })
        introTitleGradient.Offset = Vector2.new(-1, 0)
        introTitleGradient.Parent = introTitle

        local introVsGlow = Instance.new("TextLabel")
        introVsGlow.Name = "IntroVsGlow"
        introVsGlow.BackgroundTransparency = 1
        introVsGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        introVsGlow.Position = UDim2.new(0.5, 0, 0.72, -70)
        introVsGlow.Size = UDim2.new(0.62, 0, 0, 76)
        introVsGlow.Font = Enum.Font.GothamBlack
        introVsGlow.Text = ".vs"
        introVsGlow.TextColor3 = Color3.fromRGB(255, 255, 255)
        introVsGlow.TextSize = 58
        introVsGlow.TextTransparency = 1
        introVsGlow.TextStrokeColor3 = Color3.fromRGB(22, 22, 22)
        introVsGlow.TextStrokeTransparency = 1
        introVsGlow.ZIndex = 1007
        introVsGlow.Parent = introContent

        local introVs = introVsGlow:Clone()
        introVs.Name = "IntroVs"
        introVs.TextColor3 = Color3.fromRGB(255, 255, 255)
        introVs.TextSize = 54
        introVs.TextStrokeColor3 = Color3.fromRGB(5, 5, 5)
        introVs.ZIndex = 1010
        introVs.Parent = introContent

        local introVsGhost = introVs:Clone()
        introVsGhost.Name = "IntroVsGhost"
        introVsGhost.TextColor3 = Color3.fromRGB(255, 255, 255)
        introVsGhost.ZIndex = 1009
        introVsGhost.Parent = introContent

        local function titleEntrance()
            local finalPos = UDim2.fromScale(0.5, 0.5)
            introTitle.Position = UDim2.new(0.5, -95, 0.5, 0)
            introTitleGlow.Position = UDim2.new(0.5, 85, 0.5, 0)
            introGlitchBright.Position = UDim2.new(0.5, 125, 0.5, -7)
            introGlitchDark.Position = UDim2.new(0.5, -125, 0.5, 7)
            introTitle.Rotation = -5
            introTitleGlow.Rotation = 5
            introTitle.TextTransparency = 1
            introTitleGlow.TextTransparency = 1
            introGlitchBright.TextTransparency = 0.3
            introGlitchDark.TextTransparency = 0.42

            TweenService:Create(introTitle, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0
            }):Play()
            TweenService:Create(introTitleGlow, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0.58
            }):Play()
            TweenService:Create(introGlitchBright, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 8, 0.5, -2)
            }):Play()
            TweenService:Create(introGlitchDark, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -8, 0.5, 2)
            }):Play()

            for _ = 1, 9 do
                local dx = math.random(-16, 16)
                local dy = math.random(-4, 4)
                introTitle.Position = UDim2.new(0.5, dx, 0.5, dy)
                introTitleGlow.Position = UDim2.new(0.5, -dx * 0.35, 0.5, -dy)
                introGlitchBright.Position = UDim2.new(0.5, dx + 8, 0.5, dy - 2)
                introGlitchDark.Position = UDim2.new(0.5, dx - 8, 0.5, -dy + 2)
                task.wait(0.025)
            end

            introTitle.Position = finalPos
            introTitleGlow.Position = finalPos
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
        end

        local function vsImpactGlitch()
            introVs.Position = UDim2.new(0.5, 0, 0.72, -68)
            introVsGlow.Position = introVs.Position
            introVsGhost.Position = UDim2.new(0.5, -8, 0.72, -62)
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.58
            introVsGlow.TextStrokeTransparency = 0.48
            introVsGhost.TextTransparency = 0.42
            introVs.Rotation = -8
            introVsGlow.Rotation = 7
            introVsGhost.Rotation = -12

            local impactPos = UDim2.new(0.5, 0, 0.72, 18)
            TweenService:Create(introVs, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGlow, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGhost, TweenInfo.new(0.31, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -10, 0.72, 24), Rotation = 0
            }):Play()
            task.wait(0.30)

            for _ = 1, 13 do
                local dx = math.random(-12, 12)
                local dy = math.random(-5, 5)
                introVs.Position = UDim2.new(0.5, dx, 0.72, 18 + dy)
                introVsGlow.Position = UDim2.new(0.5, -dx * 0.45, 0.72, 18 - dy)
                introVsGhost.Position = UDim2.new(0.5, dx - 7, 0.72, 18 - dy)
                introVs.TextTransparency = math.random(0, 10) / 100
                introVsGlow.TextTransparency = math.random(40, 68) / 100
                introVsGhost.TextTransparency = math.random(25, 58) / 100
                task.wait(math.random(2, 4) / 100)
            end
            introVs.Position = impactPos
            introVsGlow.Position = impactPos
            introVsGhost.Position = impactPos
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.60
            introVsGhost.TextTransparency = 1
        end

        local glitchSlices = {}
        for i = 1, 12 do
            local slice = Instance.new("Frame")
            slice.Name = "GlitchSlice_" .. i
            slice.BorderSizePixel = 0
            slice.BackgroundColor3 = i % 3 == 0 and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(25, 25, 25)
            slice.BackgroundTransparency = 1
            slice.AnchorPoint = Vector2.new(0.5, 0.5)
            slice.Position = UDim2.fromScale(0.5, 0.5)
            slice.Size = UDim2.new(0.5, 0, 0, 2)
            slice.ZIndex = 1009
            slice.Parent = introLayer
            table.insert(glitchSlices, slice)
        end

        for i = 1, 22 do
            local spark = Instance.new("Frame")
            spark.Name = "IntroSpark_" .. i
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.BackgroundColor3 = Color3.fromRGB(255, 20 + (i % 4) * 16, 32)
            spark.BackgroundTransparency = 1
            spark.BorderSizePixel = 0
            spark.Size = UDim2.new(0, 1 + (i % 3), 0, 1 + (i % 3))
            spark.Position = UDim2.fromScale((i * 0.173) % 1, 1.04)
            spark.ZIndex = 1004
            spark.Parent = introLayer
            local sparkCorner = Instance.new("UICorner")
            sparkCorner.CornerRadius = UDim.new(1, 0)
            sparkCorner.Parent = spark
            task.spawn(function()
                while spark.Parent do
                    spark.Position = UDim2.fromScale(math.random(), 1.04)
                    spark.BackgroundTransparency = 0.62 + math.random() * 0.20
                    local rise = TweenService:Create(spark, TweenInfo.new(2.4 + math.random() * 2.5, Enum.EasingStyle.Linear), {
                        Position = UDim2.fromScale(math.clamp(spark.Position.X.Scale + (math.random() - 0.5) * 0.18, 0, 1), -0.04),
                        BackgroundTransparency = 1
                    })
                    rise:Play()
                    rise.Completed:Wait()
                end
            end)
        end

        local function glitchBurst(strength, duration)
            local started = os.clock()
            while introLayer and introLayer.Parent and os.clock() - started < duration do
                local x = math.random(-strength, strength)
                local y = math.random(-math.max(1, math.floor(strength * 0.35)), math.max(1, math.floor(strength * 0.35)))
                introTitle.Position = UDim2.new(0.5, x, 0.5, y)
                introTitleGlow.Position = UDim2.new(0.5, -x * 0.35, 0.5, -y)
                introGlitchBright.Position = UDim2.new(0.5, x + math.random(2, 7), 0.5, y)
                introGlitchDark.Position = UDim2.new(0.5, x - math.random(3, 9), 0.5, -y)
                introGlitchBright.TextTransparency = math.random(15, 48) / 100
                introGlitchDark.TextTransparency = math.random(30, 62) / 100
                introTitle.TextTransparency = math.random(0, 12) / 100
                introTitleGlow.TextTransparency = math.random(38, 68) / 100

                if math.random() > 0.35 then
                    local slice = glitchSlices[math.random(1, #glitchSlices)]
                    slice.Position = UDim2.new(0.5, math.random(-45, 45), 0.5, math.random(-42, 42))
                    slice.Size = UDim2.new(math.random(24, 88) / 100, 0, 0, math.random(1, 4))
                    slice.BackgroundTransparency = math.random(8, 45) / 100
                end
                task.wait(math.random(2, 5) / 100)
                for _, slice in ipairs(glitchSlices) do
                    slice.BackgroundTransparency = 1
                end
            end
            introTitle.Position = UDim2.fromScale(0.5, 0.5)
            introTitleGlow.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchDark.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
            introTitle.TextTransparency = 0
            introTitleGlow.TextTransparency = 0.58
        end

        task.spawn(function()
            local ok, err = xpcall(function()
            if not introImage or not introImage.Parent then return end
            TweenService:Create(introImage, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.45,
                Size = UDim2.fromScale(1.0, 1.0)
            }):Play()
            task.wait(0.28)

            introTitle.Text = "RANA"
            introTitleGlow.Text = "RANA"
            introGlitchBright.Text = "RANA"
            introGlitchDark.Text = "RANA"
            titleEntrance()
            glitchBurst(15, 0.30)

            task.wait(0.10)
            vsImpactGlitch()

            task.spawn(function()
                local offset = -1
                for _ = 1, 150 do
                    offset = offset + 0.018
                    if offset > 1 then offset = -1 end
                    introTitleGradient.Offset = Vector2.new(offset, 0)
                    task.wait(0.018)
                end
            end)

            TweenService:Create(introContent, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1.02, 0, 0, 198)
            }):Play()
            task.wait(0.18)
            glitchBurst(9, 0.25)
            task.wait(0.20)
            vsImpactGlitch()
            task.wait(0.18)
            glitchBurst(13, 0.28)
            task.wait(0.24)
            glitchBurst(7, 0.22)
            task.wait(0.22)
            vsImpactGlitch()
            task.wait(0.16)
            glitchBurst(11, 0.25)
            task.wait(0.18)

            glitchBurst(22, 0.34)
            TweenService:Create(introContent, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1.12, 0, 0, 212)
            }):Play()
            for _, label in ipairs({introTitle, introTitleGlow, introVs, introVsGlow, introVsGhost}) do
                TweenService:Create(label, TweenInfo.new(0.58, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 1, TextStrokeTransparency = 1
                }):Play()
            end
            task.wait(0.30)
            if not introLayer or not introLayer.Parent then return end
            TweenService:Create(introLayer, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1,
                Size = UDim2.fromScale(1.05, 1.05)
            }):Play()
            TweenService:Create(introShade, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(introVignette, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                ImageTransparency = 1
            }):Play()
            task.wait(0.24)
            end, debug.traceback)
            if not ok then
                warn("[RANA Intro] Animation error: " .. tostring(err))
            end
            finishIntro()
        end)
        introDone.Event:Wait()
        introDone:Destroy()
        pcall(function()
            if introScreenGui and introScreenGui.Parent then introScreenGui:Destroy() end
        end)

    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5
local RANA_SPEED_NORMAL = 60
local RANA_SPEED_CARRY = 30
local RANA_LAGGER_1 = 15
local RANA_LAGGER_2 = 24.5
local RANA_AUTO_SWITCH_THRESHOLD = 25

local laggerPhase = 0 -- 0=off, 1=lagger, 2=lagger carry

local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	antiDieEnabled = false, antiBatEnabled = false, antiDrop404Enabled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	hitboxFollowerEnabled = false,
	guiVisible = true,
	noIntro = (((getgenv and getgenv()) or _G).__RANA_NO_INTRO_SAVED == true),
	introEnabled = (((getgenv and getgenv()) or _G).__RANA_NO_INTRO_SAVED ~= true), selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	unwalkEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
	backgroundAssetId = "139887397490573",
	backgroundAssetIds = {
		"139887397490573",
		"127996260669664",
		"81349726073991",
		"82525224213939",
		"97204072864657",
		"104462721630415",
	},
	imageChoiceVisuals = {},
	autoCarryEnabled = false,
}

local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end  -- no-op, MobilePanel removed
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -298, 1, -334),
	AutoLeft   = UDim2.new(1, -144, 1, -334),
	AutoBat    = UDim2.new(1, -298, 1, -270),
	AutoRight  = UDim2.new(1, -144, 1, -270),
	TPDown     = UDim2.new(1, -298, 1, -206),
	Speed      = UDim2.new(1, -144, 1, -206),
	Lagger     = UDim2.new(1, -144, 1, -142),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	AutoBatV2 = {kb = nil,                      gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}

local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local function ranaIsCarrying()
	local char = LP.Character
	if not char then return false end

	if char:GetAttribute("Stealing") == true then
		return true
	end
	if LP:GetAttribute("Stealing") == true then
		return true
	end

	for _, obj in ipairs(char:GetChildren()) do
		if obj:IsA("Tool") then
			local n = string.lower(obj.Name)
			if string.find(n, "brainrot", 1, true)
				or string.find(n, "carry", 1, true)
				or string.find(n, "steal", 1, true) then
				return true
			end
			local ok, stealing = pcall(function() return obj:GetAttribute("Stealing") end)
			if ok and stealing == true then return true end
		end
	end
	return false
end

-- [RANA_BLEED_SAFE]
-- Self-contained Rana bleed system. It does not replace or redefine any existing Rana helpers.
local RanaBleed = {
    active = "Off",
    originalShirt = nil,
    originalPants = nil,
    originalAccessories = nil,
    originalHeadMesh = nil,
    originalHeadTexture = nil,
    packs = {
        ["Bleed 1"] = {accessory=306969564, offset=Vector3.new(0,0.3,0), headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918", shirt="http://www.roblox.com/asset/?id=10632503795", pants="http://www.roblox.com/asset/?id=123161592384863", korblox="right"},
        ["Bleed 2"] = {accessory=1744060292, offset=Vector3.new(0,1.4,-0.2), headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918", shirt="http://www.roblox.com/asset/?id=11526718530", pants="http://www.roblox.com/asset/?id=93710523210027", korblox="right"},
        ["Bleed 3"] = {accessory=112564966849233, offset=Vector3.new(0,0.6,0), headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918", shirt="http://www.roblox.com/asset/?id=11849088376", pants="http://www.roblox.com/asset/?id=16534673928", korblox="right"},
    },
}

function RanaBleed:save(char)
    if not char then return end
    local s=char:FindFirstChildWhichIsA("Shirt")
    local p=char:FindFirstChildWhichIsA("Pants")
    self.originalShirt=s and s.ShirtTemplate or nil
    self.originalPants=p and p.PantsTemplate or nil
    self.originalAccessories={}
    local head=char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then self.originalHeadMesh=head.MeshId; self.originalHeadTexture=head.TextureID end
    if head then local sm=head:FindFirstChildWhichIsA("SpecialMesh"); if sm then self.originalHeadMesh=sm.MeshId; self.originalHeadTexture=sm.TextureId end end
    for _,v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Hat") then
            local ok,c=pcall(function() return v:Clone() end)
            if ok and c then table.insert(self.originalAccessories,c) end
        end
    end
end

function RanaBleed:clear(char)
    if not char then return end
    for _,v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Hat") or v.Name=="RanaBleedAccessory" or v.Name:find("RanaKorblox_") then
            pcall(function() v:Destroy() end)
        elseif v:IsA("Shirt") or v:IsA("Pants") then
            pcall(function() v:Destroy() end)
        end
    end
    for _,n in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
        local part=char:FindFirstChild(n)
        if part and part:IsA("BasePart") then part.Transparency=0 end
    end
end

function RanaBleed:restore(char)
    if not char then return end
    self:clear(char)
    if self.originalShirt then local s=Instance.new("Shirt"); s.ShirtTemplate=self.originalShirt; s.Parent=char end
    if self.originalPants then local p=Instance.new("Pants"); p.PantsTemplate=self.originalPants; p.Parent=char end
    local head=char:FindFirstChild("Head")
    if head and self.originalHeadMesh then pcall(function()
        if head:IsA("MeshPart") then head.MeshId=self.originalHeadMesh; head.TextureID=self.originalHeadTexture or ""
        else local sm=head:FindFirstChildWhichIsA("SpecialMesh"); if sm then sm.MeshId=self.originalHeadMesh; sm.TextureId=self.originalHeadTexture or "" end end
    end) end
    if self.originalAccessories then
        for _,c in ipairs(self.originalAccessories) do
            pcall(function()
                local n=c:Clone(); n.Parent=char
                for _,w in ipairs(n:GetDescendants()) do
                    if w:IsA("Weld") or w:IsA("WeldConstraint") then
                        local p0=w.Part0 and char:FindFirstChild(w.Part0.Name)
                        local p1=w.Part1 and char:FindFirstChild(w.Part1.Name)
                        if w:IsA("Weld") then w.Part0=p0 or w.Part0; w.Part1=p1 or w.Part1 end
                        if w:IsA("WeldConstraint") then w.Part0=p0 or w.Part0; w.Part1=p1 or w.Part1 end
                    end
                end
            end)
        end
    end
    self.originalShirt=nil; self.originalPants=nil; self.originalAccessories=nil; self.originalHeadMesh=nil; self.originalHeadTexture=nil; self.active="Off"
end

function RanaBleed:apply(name)
    local cfg=self.packs[name]
    local char=LP.Character
    if not cfg or not char then return false end
    local head=char:FindFirstChild("Head")
    if not head then return false end
    if self.originalAccessories==nil then self:save(char) end
    self:clear(char)

    if cfg.headMesh and head:IsA("MeshPart") then
        pcall(function() head.MeshId=cfg.headMesh; head.TextureID=cfg.headTexture or "" end)
    elseif cfg.headMesh then
        local sm=head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
        sm.MeshType=Enum.MeshType.FileMesh; sm.MeshId=cfg.headMesh; sm.TextureId=cfg.headTexture or ""; sm.Parent=head
    end
    local s=Instance.new("Shirt"); s.ShirtTemplate=cfg.shirt; s.Parent=char
    local p=Instance.new("Pants"); p.PantsTemplate=cfg.pants; p.Parent=char

    if cfg.accessory then
        local ok,objs=pcall(function() return game:GetObjects("rbxassetid://"..tostring(cfg.accessory)) end)
        if ok and type(objs)=="table" and #objs>0 then
            local handle=nil
            for _,o in ipairs(objs) do
                if o:IsA("BasePart") then handle=o; break end
                local f=o:FindFirstChildWhichIsA("BasePart",true); if f then handle=f; break end
            end
            if handle then
                local h=handle:Clone(); h.Name="RanaBleedAccessory"; h.CanCollide=false; h.Anchored=false; h.Massless=true; h.Parent=char
                local w=Instance.new("Weld"); w.Part0=head; w.Part1=h; w.C0=CFrame.new(cfg.offset or Vector3.zero); w.Parent=h
            end
            for _,o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if cfg.korblox=="right" then
        local ids={139607718}
        local target=char:FindFirstChild("RightUpperLeg")
        if target then
            for _,n in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"}) do local part=char:FindFirstChild(n); if part and part:IsA("BasePart") then part.Transparency=1 end end
            local ok,objs=pcall(function() return game:GetObjects("rbxassetid://"..ids[1]) end)
            if ok and type(objs)=="table" and #objs>0 then
                local model=objs[1]
                local mesh=model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart",true)
                if mesh then
                    mesh.CanCollide=false; mesh.Massless=true; mesh.CFrame=target.CFrame
                    local w=Instance.new("WeldConstraint"); w.Part0=target; w.Part1=mesh; w.Parent=mesh
                    model.Parent=char
                end
            end
        end
    end
    self.active=name
    return true
end

function RanaBleed:set(name)
    if name=="Off" then self:restore(LP.Character); return end
    self:apply(name)
end

LP.CharacterAdded:Connect(function()
    task.delay(1,function()
        if RanaBleed.active~="Off" then pcall(function() RanaBleed:apply(RanaBleed.active) end) end
    end)
end)
-- [RANA_BLEED_SAFE_END]

local function getProfileNormalSpeed()
	if State.speedProfile == "Lagger" then
		return State.profileLaggerNormalSpeed or 40
	end
	return NS or RANA_SPEED_NORMAL or 60
end

local function getProfileCarrySpeed()
	if State.speedProfile == "Lagger" then
		return State.profileLaggerCarrySpeed or 20
	end
	return CS or RANA_SPEED_CARRY or 30
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local function getClosestPlayerMob2()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08
local function tryHitBatMob()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
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
	return closest
end

stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
	_autoBatTarget = nil
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State._hitboxFollower.pausedByBatAim then
		State._hitboxFollower.pausedByBatAim = false
		if State.hitboxFollowerEnabled and not State.tpBatEnabled then
			State._hitboxFollower.start()
		end
	end
end

startBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect() end
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State.hitboxFollowerEnabled then
		State._hitboxFollower.pausedByBatAim = true
		State._hitboxFollower.stop()
	end

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target = getClosestTarget()
		if not target then
			hum.AutoRotate = true
			return
		end
		_aimbotTarget = target

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
		local chaseSpeed = 60 -- Velocidad fija requerida en 60

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end

		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
				pcall(function() bat:Activate() end)
			end
		end
	end)
end

State._hitboxFollower = State._hitboxFollower or {
    LOCK_RANGE = 150,
    enabled = false,
    conn = nil,
    pausedByBatAim = false,
}
State._hitboxFollower.pausedByBatAim = State._hitboxFollower.pausedByBatAim == true

function State._hitboxFollower.getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

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
    return closest
end

function State._hitboxFollower.tick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local target = State._hitboxFollower.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    local dist = (target.Position - root.Position).Magnitude
    if dist > State._hitboxFollower.LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if hum.AutoRotate then hum.AutoRotate = false end

    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime

    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)
    local toPredict = flatTarget - root.Position

    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function State._hitboxFollower.start()
    State._hitboxFollower.enabled = true
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
    end
    State._hitboxFollower.conn = RunService.RenderStepped:Connect(function()
        if State._hitboxFollower.enabled and not State.autoBatToggled and not State.tpBatEnabled then
            State._hitboxFollower.tick()
        end
    end)
end

function State._hitboxFollower.stop()
    State._hitboxFollower.enabled = false
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
        State._hitboxFollower.conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.hitboxFollowerEnabled and not State.autoBatToggled and not State.tpBatEnabled then
        State._hitboxFollower.stop()
        task.wait(0.2)
        State._hitboxFollower.start()
    elseif State.hitboxFollowerEnabled and (State.autoBatToggled or State.tpBatEnabled) then
        State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
        State._hitboxFollower.stop()
    end
end)
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setSuperJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual, setAntiDrop404ConfigVisual, setAntiDieConfigVisual, setAntiBatConfigVisual
local startAntiDie, stopAntiDie, startAntiBat, stopAntiBat, start404AntiDrop, stop404AntiDrop
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal, ranaApplyStealMode
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLagger1SetActive, mobileLagger2SetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil, nil, nil

State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end

	local environments = {}
	pcall(function()
		if getgenv then table.insert(environments, getgenv()) end
	end)
	pcall(function()
		if getrenv then table.insert(environments, getrenv()) end
	end)
	table.insert(environments, _G)

	for _, environment in ipairs(environments) do
		if type(environment) == "table" then
			local candidate = rawget(environment, name)
			if type(candidate) == "function" then return candidate end
			local synEnvironment = rawget(environment, "syn")
			if type(synEnvironment) == "table" then
				local synCandidate = rawget(synEnvironment, name)
				if type(synCandidate) == "function" then return synCandidate end
			end
		end
	end

	if type(syn) == "table" and type(syn[name]) == "function" then
		return syn[name]
	end
	return nil
end

State._safeWriteFile = function(path, data)
	local writer = State._resolveFileFunction("writefile")
	if type(writer) ~= "function" then
		return false, "writefile no disponible en este ejecutor"
	end
	local ok, err = pcall(writer, path, data)
	if not ok then return false, tostring(err) end
	return true
end

State._safeReadFile = function(path)
	local reader = State._resolveFileFunction("readfile")
	if type(reader) ~= "function" then
		return nil, "readfile no disponible en este ejecutor"
	end
	local ok, result = pcall(reader, path)
	if not ok or type(result) ~= "string" or result == "" then
		return nil, ok and "archivo vacío" or tostring(result)
	end
	return result
end

State._safeDeleteFile = function(path)
	local deleter = State._resolveFileFunction("delfile")
	if type(deleter) ~= "function" then return false end
	local ok = pcall(deleter, path)
	return ok
end

State._readValidJsonFile = function(path)
	local raw = State._safeReadFile(path)
	if type(raw) ~= "string" then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" then return nil, raw end
	return decoded, raw
end

State._writeVerifiedJson = function(path, encoded)
	local writeOk, writeErr = State._safeWriteFile(path, encoded)
	if not writeOk then return false, writeErr end
	local decoded, raw = State._readValidJsonFile(path)
	if type(decoded) ~= "table" or raw ~= encoded then
		return false, "la verificación del archivo falló: " .. tostring(path)
	end
	return true
end

State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
    local decodedOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
    if not decodedOk or type(decoded) ~= "table" then
        return false, "invalid JSON"
    end

    local writer = State._resolveFileFunction("writefile")
    if type(writer) ~= "function" then
        return false, "writefile is unavailable"
    end

    local function put(path, data)
        local ok, err = pcall(writer, path, data)
        if not ok then return false, tostring(err) end
        return true
    end

    -- Write the complete snapshot to the primary file first.
    local ok, err = put(mainPath, encoded)
    if not ok then return false, err end

    -- Keep recovery copies, but do not fail the save if an optional copy fails.
    pcall(writer, tempPath, encoded)
    pcall(writer, backupPath, encoded)

    -- Also maintain the older filename used by previous Rana builds.
    pcall(writer, "FEARV2Config.json", encoded)

    return true
end

State.requestConfigSave = function()
	if State._configLoading or not State._configLoaded then
		State._saveAfterLoad = true
		State._configDirty = true
		return
	end
	-- Allow saves even if previous config load encountered legacy format
	State._configLoadFailed = false

	State._configDirty = true
	State._saveRequestId = State._saveRequestId + 1
	local requestId = State._saveRequestId

	task.delay(0.15, function()
		if requestId ~= State._saveRequestId or State._configLoading then return end
		if not State._configDirty then return end
		if saveConfig then
			local ok, result = pcall(saveConfig)
			if not ok then State._lastSaveError = tostring(result) end
		end
	end)
end
local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local pbFrame, pbScale
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20

local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0
local _autoBatTarget = nil
local _autoBatEquippedThisRun = false

local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local btnInstaReset = nil

State.buttonsSizeValue = State.buttonsSizeValue or 50
State.buttonsShape = State.buttonsShape or "Normal"

function getMobileButtonPixels(value)
	value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	return math.floor(36 + (value * 0.48) + 0.5)
end

function normalizeMobileButtonsShape(shape)
	shape = tostring(shape or "Normal")
	if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
		return shape
	end
	return "Normal"
end

function applyShapeToMobileButton(button)
	if not button or not button.Parent then return end

	local pixels = getMobileButtonPixels(State.buttonsSizeValue)
	local textPixels = math.clamp(math.floor(8 + State.buttonsSizeValue * 0.07 + 0.5), 8, 15)
	local shape = normalizeMobileButtonsShape(State.buttonsShape)
	local width, height = pixels, pixels
	local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))

	if shape == "Circle" then
		radius = UDim.new(1, 0)
	elseif shape == "Square" then
		radius = UDim.new(0, 0)
	elseif shape == "Rectangle" then
		width = math.floor(pixels * 1.55 + 0.5)
		height = math.max(28, math.floor(pixels * 0.75 + 0.5))
		radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
	end

	button.Size = UDim2.new(0, width, 0, height)
	button.TextSize = textPixels

	local corner = button:FindFirstChild("ButtonShapeCorner")
	if not corner or not corner:IsA("UICorner") then
		corner = button:FindFirstChildOfClass("UICorner")
	end
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = button
	end
	corner.Name = "ButtonShapeCorner"
	corner.CornerRadius = radius
end

function applyMobileButtonsShape(shape)
	State.buttonsShape = normalizeMobileButtonsShape(shape)
	for _, mobileBtn in pairs(mobileButtonsByName) do
		applyShapeToMobileButton(mobileBtn)
	end
	for _, specialBtn in ipairs({btnBatV2, btnInstaReset}) do
		applyShapeToMobileButton(specialBtn)
	end
	return State.buttonsShape
end

function applyMobileButtonsSize(value)
	State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	applyMobileButtonsShape(State.buttonsShape)
end

local MedusaConfig = {
	Enabled = false,
	Radius = 15,
	Delay = 0.15,
	LastUsed = 0,
	RadiusPart = nil
}

local SAFETY_VOID_MARGIN = 18
local SAFETY_MAX_FLOOR_RAY = 4000
local safetyLastGroundedCFrame = nil
local safetyRestoring = false

local function safetyVoidY()
	local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
	if ok and type(value) == "number" then return value end
	return -500
end

local function safetyFiniteNumber(value)
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

safetyPositionIsValid = function(position)
	return typeof(position) == "Vector3"
		and safetyFiniteNumber(position.X)
		and safetyFiniteNumber(position.Y)
		and safetyFiniteNumber(position.Z)
		and position.Y > safetyVoidY() + SAFETY_VOID_MARGIN
end

local function safetyCharacterParts()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return nil, nil, nil
	end
	return character, humanoid, root
end

local function safetyFloorPosition(root, character)
	if not root or not character or not safetyPositionIsValid(root.Position) then return nil end

	local ignore = {character}
	if MedusaConfig and MedusaConfig.RadiusPart then
		table.insert(ignore, MedusaConfig.RadiusPart)
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05
	local origin = root.Position + Vector3.new(0, 5, 0)
	local distanceToVoid = math.max(100, origin.Y - safetyVoidY() + 50)
	local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid)
	local hitPosition = nil

	pcall(function()
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignore
		params.FilterType = Enum.RaycastFilterType.Exclude
		pcall(function() params.RespectCanCollide = true end)
		local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
		if result and result.Instance and result.Position then
			hitPosition = result.Position
		end
	end)

	if not hitPosition then
		pcall(function()
			local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
			local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if part and position then hitPosition = position end
		end)
	end

	if not hitPosition then return nil end
	local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
	if not safetyPositionIsValid(landing) then return nil end
	return landing
end

local function safetyTeleport(root, humanoid, destination, preserveYaw)
	if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
	if not safetyPositionIsValid(destination) then return false end

	local yaw = 0
	if preserveYaw ~= false then
		local _, currentYaw, _ = root.CFrame:ToOrientation()
		yaw = currentYaw
	end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function() humanoid.PlatformStand = false end)
	return true
end

local function safetyTeleportToFloor(character, humanoid, root)
	local landing = safetyFloorPosition(root, character)
	if not landing then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return false
	end
	return safetyTeleport(root, humanoid, landing, true)
end

RunService.Heartbeat:Connect(function()
	local character, humanoid, root = safetyCharacterParts()
	if not character then return end

	if safetyPositionIsValid(root.Position)
		and humanoid.FloorMaterial ~= Enum.Material.Air
		and root.AssemblyLinearVelocity.Magnitude < 180 then
		safetyLastGroundedCFrame = root.CFrame
	end

	local riskyMovement = State.dropActive
		or State.dropBrainrotActive
		or autoTPDownEnabled
		or State.tpBatEnabled
		or State.autoBatToggled
		or State.autoBatV2Enabled

	if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
		safetyRestoring = true
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then
			root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0)
		end
		task.defer(function() safetyRestoring = false end)
	end
end)

local function showDiscordInProgressBar()
	if not progressPct or not progressFill then return end

	local originalText = progressPct.Text
	local originalColor = progressPct.TextColor3
	local originalSize = progressPct.TextSize
	local originalAlign = progressPct.TextXAlignment

	progressPct.Text = "🌀 Rana.VS  ·  mogs"
	progressPct.TextColor3 = Color3.fromRGB(255, 255, 255) -- Cambiado a Rosa
	progressPct.TextSize = 13
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 12

	if progressRadLbl then progressRadLbl.Visible = false end

	task.delay(4, function()
		if progressPct then
			progressPct.Text = originalText or "0%"
			progressPct.TextColor3 = originalColor or Color3.fromRGB(15, 15, 15) -- Sigue siendo Rosa
			progressPct.TextSize = originalSize or 11
			progressPct.TextXAlignment = originalAlign or Enum.TextXAlignment.Left
			progressPct.ZIndex = 5
		end
		if progressRadLbl then progressRadLbl.Visible = true end
	end)
end

local function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function startAutoLeft()
	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
				end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local function startAutoRight()
	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
				end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local DROP_ASCEND_DURATION = 0.25
local DROP_ASCEND_SPEED = 240

local function runDrop()
        if State.dropActive then return end
        local char, hum, root = safetyCharacterParts()
        if not char then return end
        State.dropActive = true; local t0 = tick(); local dc
        dc = RunService.Heartbeat:Connect(function()
                local currentChar = LP.Character
                local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health <= 0 then
                        if dc then dc:Disconnect() end
                        State.dropActive = false
                        return
                end
                if tick() - t0 >= DROP_ASCEND_DURATION then
                        if dc then dc:Disconnect() end
                        r.AssemblyLinearVelocity = Vector3.zero
                        r.AssemblyAngularVelocity = Vector3.zero
                        safetyTeleportToFloor(currentChar, currentHum, r)
                        State.dropActive = false
                        return
                end
                r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
        end)
end
local _tpDownActive = false
local function runTPDown()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local character, humanoid, root = safetyCharacterParts()
		if character then safetyTeleportToFloor(character, humanoid, root) end
	end)
	_tpDownActive = false
end

State._tpBatHittingCooldown = false
State._tpBatHRP = nil
State._tpBatH = nil

State._tpBatGetTool = function()
	local char = LP.Character
	if not char then return nil end

	local bat = char:FindFirstChild("Bat")
	if bat then return bat end

	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		bat = backpack:FindFirstChild("Bat")
		if bat then
			bat.Parent = char
			return bat
		end
	end

	return nil
end

State._tpBatTryHit = function()
	if State._tpBatHittingCooldown then return end
	State._tpBatHittingCooldown = true

	pcall(function()
		local bat = State._tpBatGetTool()
		if bat then
			bat:Activate()

			local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remoteEvent then
				remoteEvent:FireServer()
			end

			local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
			if remoteFunction then
				pcall(function()
					remoteFunction:InvokeServer()
				end)
			end
		end
	end)

	task.delay(0.08, function()
		State._tpBatHittingCooldown = false
	end)
end

State._tpBatClosest = function()
	if not State._tpBatHRP then return nil, math.huge end

	local closest, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closest = player
				end
			end
		end
	end

	return closest, closestDistance
end

RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled then return end

	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
			State._tpBatH = char:FindFirstChildOfClass("Humanoid")
			State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end

			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
			if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then
				State._tpBatHRP.CFrame = CFrame.new(targetPosition)
			end

			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end

			State._tpBatTryHit()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not State.tpBatEnabled then return end
	if not State._tpBatH or not State._tpBatHRP then return end
	if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end
			State._tpBatTryHit()
		end
	end
end)

LP.CharacterAdded:Connect(function(character)
	task.wait(0.2)
	State._tpBatH = character:FindFirstChildOfClass("Humanoid")
	State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)

if LP.Character then
	task.spawn(function()
		task.wait(0.2)
		State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end)
end

local function startAutoTPDown()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				safetyTeleportToFloor(char, hum, root)
			end)
		end
	end)
end

local function stopAutoTPDown()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

pcall(function()
	if hookfunction and newcclosure then
		local oldFire
		oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
			if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
				cursedResetRemote=self
			end
			return oldFire(self,...)
		end))
	end
end)

task.spawn(function()
	task.wait(2)
	if cursedResetRemote then return end
	for _,desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
			cursedResetRemote=desc
			break
		end
	end
end)

local resetCooldown = false
local resetThread = nil
local currentResetChar = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil

local function instaResetFast()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false

    local character = LP.Character
    if not character then resetCooldown = false return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end

    local camera = workspace.CurrentCamera
    if camera then
        lockedCameraCFrame = camera.CFrame
        cameraLocked = true
        camera.CFrame = lockedCameraCFrame
    end

    currentResetChar = character
    local isRespawning = false

    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end

            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end

                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(0.05)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
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
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        cameraLocked = false
        resetCooldown = false
        resetThread = nil
        currentResetChar = nil
        stopResetSequence = false
    end)
end

function instaReset()
    instaResetFast()
end

LP.CharacterAdded:Connect(function()
    stopResetSequence = true
    if resetThread then
        task.cancel(resetThread)
        resetThread = nil
    end
    resetCooldown = false
    currentResetChar = nil
    cameraLocked = false
end)

for _, name in pairs({"FEARV2GUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local moved = false
	frame.Active = true

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	frame.InputBegan:Connect(function(inp)
		if uiLocked then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
			dragStart = inp.Position
			startPos = frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	UIS.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = inp.Position - dragStart
			if math.abs(d.X) > 1 or math.abs(d.Y) > 1 then moved = true end
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
		end
	end)

	UIS.InputEnded:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

gui = Instance.new("ScreenGui")
gui.Name = "FEARV2GUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

_C={
	[1]=Color3.fromRGB(0, 0, 0),
	[2]=Color3.fromRGB(1, 1, 1),
	[3]=Color3.fromRGB(2, 2, 2),
	[4]=Color3.fromRGB(4, 4, 4),
	[5]=Color3.fromRGB(17, 17, 17),
	[6]=Color3.fromRGB(46, 46, 46),
	[7]=Color3.fromRGB(255, 255, 255),
	[8]=Color3.fromRGB(255, 255, 255),
	[9]=Color3.fromRGB(1, 1, 1),
	[10]=Color3.fromRGB(1, 1, 1),
}
BG=_C[1];SIDEBAR_BG=_C[2];CARD_BG=_C[3];CARD_HOV=_C[4]
BORDER=_C[5];BORDER2=_C[6];WHITE=_C[7];DIM=_C[8]
DIM2=_C[9];KB_BG=_C[10];INPUT_BG=_C[10]

function makeDraggableY(guiObject)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    guiObject.Active = true

    local function finishDrag()
        if not dragging then return end
        dragging = false
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then finishDrag() end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.Y) > 1 then moved = true end
            local newY = startPos.Y.Offset + delta.Y
            local visibleOffset = 375

            local frameHeight = guiObject.AbsoluteSize.Y
            local screenHeight = guiObject.Parent.AbsoluteSize.Y

            local minY = visibleOffset - frameHeight
            local maxY = screenHeight - visibleOffset
            local clampedY = math.clamp(newY, minY, maxY)

            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, clampedY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            finishDrag()
        end
    end)
end

W, H, SW = 500, 430, 118
CORNER = 18

uiScaleValue = 80
mainUIScale = nil
main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 70, 0, 12)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 0 -- MODIFICADO: Removida transparencia para que se mantenga sólido tal cual

mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, CORNER)

mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER -- Cambiado a BORDER rojo
mainStroke.Thickness = 1.25
mainStroke.Transparency = 0.08

premiumInnerBorder = Instance.new("Frame", main)
premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8)
premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4)
premiumInnerBorder.BackgroundTransparency = 1
premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2
premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder)
premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0))
premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(17, 17, 17)
premiumInnerStroke.Thickness = 1
premiumInnerStroke.Transparency = 0.48

mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.80

fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
fullUIBackground.BackgroundTransparency = 1
fullUIBackground.BorderSizePixel = 0
fullUIBackground.Image = "rbxassetid://" .. tostring(State.backgroundAssetId)
fullUIBackground.ImageTransparency = 0.18
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 1
fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))

State.applyBackgroundImage = function(assetId, shouldSave)
	assetId = tostring(assetId or "")
	local valid = false
	for _, id in ipairs(State.backgroundAssetIds) do
		if id == assetId then valid = true; break end
	end
	if not valid then assetId = State.backgroundAssetIds[1] end

	State.backgroundAssetId = assetId
	if fullUIBackground and fullUIBackground.Parent then
		fullUIBackground.Image = "rbxassetid://" .. assetId
	end

	for id, visual in pairs(State.imageChoiceVisuals) do
		local selected = id == assetId
		if visual.stroke then
			visual.stroke.Color = selected and WHITE or BORDER
			visual.stroke.Thickness = selected and 2.2 or 1
		end
		if visual.badge then
			visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index)
			visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(1, 1, 1)
			visual.badge.TextColor3 = selected and BG or WHITE
		end
	end

	if shouldSave and State.requestConfigSave then
		State.requestConfigSave()
	end
end

topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = SIDEBAR_BG
topbar.BackgroundTransparency = 0.32
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 0.32
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 11

premiumTopLine = Instance.new("Frame", topbar)
premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2)
premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = WHITE
premiumTopLine.BorderSizePixel = 0
premiumTopLine.ZIndex = 14
premiumTopCorner = Instance.new("UICorner", premiumTopLine)
premiumTopCorner.CornerRadius = UDim.new(1, 0)
premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 46)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})

titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 190, 1, 0)
titleLbl.Position = UDim2.new(0, 17, 0, -3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "🌀 Rana.VS"
titleLbl.TextColor3 = WHITE -- Rojo
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 240, 0, 14)
verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1
verLbl.Text = "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤRana.VS  ·  Rana.VS"
verLbl.TextColor3 = DIM -- Rojo Medio
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12

minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = WHITE -- Rojo
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

do
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	local moved = false

	local dragZone = Instance.new("TextButton", topbar)
	dragZone.Name = "TopbarDragZone"
	dragZone.Size = UDim2.new(1, -48, 1, 0)
	dragZone.Position = UDim2.new(0, 0, 0, 0)
	dragZone.BackgroundTransparency = 1
	dragZone.BorderSizePixel = 0
	dragZone.Text = ""
	dragZone.AutoButtonColor = false
	dragZone.Active = true
	dragZone.ZIndex = 13

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	dragZone.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

		dragging = true
		moved = false
		dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				finishDrag()
			end
		end)
	end)

	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if uiLocked then finishDrag(); return end
		if not dragging then return end
		if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end)

	UIS.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, SW, 1, -48)
sidebar.Position = UDim2.new(0, 0, 0, 48)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 0.32
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.ClipsDescendants = true
do local _sc=Instance.new("UICorner",sidebar); _sc.CornerRadius=UDim.new(0,CORNER) end
do local _st=Instance.new("Frame",main); _st.Size=UDim2.new(0,SW,0,CORNER); _st.Position=UDim2.new(0,0,0,48); _st.BackgroundColor3=SIDEBAR_BG; _st.BackgroundTransparency=0.32; _st.BorderSizePixel=0; _st.ZIndex=4 end
do local _sd=Instance.new("Frame",sidebar); _sd.Size=UDim2.new(0,1,1,0); _sd.Position=UDim2.new(1,-1,0,0); _sd.BackgroundColor3=BORDER; _sd.BorderSizePixel=0; _sd.ZIndex=6 end

content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, -(SW + 1), 1, -48 - CORNER)
content.Position = UDim2.new(0, SW + 1, 0, 48)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 100

mini = Instance.new("TextButton", gui)
mini.Name = "FEARV2Mini"
mini.Size = UDim2.new(0, 110, 0, 32)
mini.Position = UDim2.new(0, 20, 0, 70)
mini.BackgroundColor3 = BG
mini.BorderSizePixel = 0
mini.Text = "🌀 Rana.VS"
mini.TextColor3 = WHITE -- Rojo
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 16)
miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = BORDER -- Rojo
miniStroke.Thickness = 1.5

makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

function showGui()
    main.Visible = true
    mini.Visible = false
    State.guiVisible = true

    main.BackgroundTransparency = 0 -- MODIFICADO: Mantenido en 0 sólido
    mainUIScale.Scale = 0.85

    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()
end

function hideGui()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()

    task.delay(0.2, function()
        main.Visible = false
        mini.Visible = true
        State.guiVisible = false
    end)
end

minBtn.MouseButton1Click:Connect(hideGui)
mini.MouseButton1Click:Connect(showGui)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)

tabs = {}
tabPages = {}
activeTabName = nil
tabDefs = {
	{name="Speed"},
	{name="Bat Aimbot"},
	{name="Mechanics"},
	{name="Movement"},
	{name="Visual"},
	{name="Settings"},
	{name="Background"},
	{name="Songs"},
}
switchTab = nil
pageLOs = {}

tabListFrame = Instance.new("Frame", sidebar)
tabListFrame.Size = UDim2.new(1, 0, 1, 0)
tabListFrame.Position = UDim2.new(0, 0, 0, 0)
tabListFrame.BackgroundTransparency = 1
tabListFrame.BorderSizePixel = 0
tabListFrame.ZIndex = 6

tabLL = Instance.new("UIListLayout", tabListFrame)
tabLL.SortOrder = Enum.SortOrder.LayoutOrder
tabLL.Padding = UDim.new(0, 4)
tabPad = Instance.new("UIPadding", tabListFrame)
tabPad.PaddingTop = UDim.new(0, 12)
tabPad.PaddingLeft = UDim.new(0, 8)
tabPad.PaddingRight = UDim.new(0, 8)

ACTIVE_TAB_BG  = CARD_HOV
ACTIVE_TAB_TXT = WHITE -- Rojo
IDLE_TAB_BG    = CARD_BG
IDLE_TAB_TXT   = WHITE -- Rojo

switchTab = function(name)
	activeTabName = name
	for _, td in ipairs(tabDefs) do
		local t = tabs[td.name]
		local isA = td.name == name
		TweenService:Create(t.frame, TweenInfo.new(0.14), {
			BackgroundColor3 = isA and ACTIVE_TAB_BG or IDLE_TAB_BG,
			BackgroundTransparency = isA and TAB_HOVER_TRANSPARENCY or TAB_TRANSPARENCY
		}):Play()
		TweenService:Create(t.lbl, TweenInfo.new(0.14), {
			TextColor3 = isA and ACTIVE_TAB_TXT or IDLE_TAB_TXT
		}):Play()
		if t.mark then
			TweenService:Create(t.mark, TweenInfo.new(0.14), {
				BackgroundTransparency = isA and 0.02 or 1
			}):Play()
		end
		tabPages[td.name].Visible = isA
	end
end

for i, td in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", tabListFrame)
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = IDLE_TAB_BG
	btn.BackgroundTransparency = TAB_TRANSPARENCY
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = i
	btn.ZIndex = 7
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)
	local bSt = Instance.new("UIStroke", btn)
	bSt.Color = BORDER
	bSt.Thickness = 1

	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.Position = UDim2.new(0, 0, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = td.name
	lbl.TextColor3 = IDLE_TAB_TXT
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = (td.name == "Visual" or td.name == "Background") and 8 or 9
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextWrapped = false
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 9
	local activeMark = Instance.new("Frame", btn)
	activeMark.Name = "ActiveMark"
	activeMark.Size = UDim2.new(0, 3, 0, 14)
	activeMark.Position = UDim2.new(0, 3, 0.5, -7)
	activeMark.BackgroundColor3 = WHITE
	activeMark.BackgroundTransparency = 1
	activeMark.BorderSizePixel = 0
	activeMark.ZIndex = 10
	Instance.new("UICorner", activeMark).CornerRadius = UDim.new(1, 0)

	tabs[td.name] = {frame=btn, lbl=lbl, mark=activeMark}

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = BG
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = BORDER
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 7)
	local pp = Instance.new("UIPadding", page)
	pp.PaddingLeft = UDim.new(0, 13)
	pp.PaddingRight = UDim.new(0, 13)
	pp.PaddingTop = UDim.new(0, 12)
	pp.PaddingBottom = UDim.new(0, 12)
	tabPages[td.name] = page
	pageLOs[td.name] = 0
	btn.Activated:Connect(function() switchTab(td.name) end)
	btn.MouseEnter:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=ACTIVE_TAB_BG, BackgroundTransparency=TAB_HOVER_TRANSPARENCY}):Play() end
	end)
	btn.MouseLeave:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=IDLE_TAB_BG, BackgroundTransparency=TAB_TRANSPARENCY}):Play() end
	end)
end

local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

local function makeSecHeader(tabName, text)
	local f = Instance.new("Frame", pg(tabName))
	f.Size = UDim2.new(1, 0, 0, 24)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.LayoutOrder = lo(tabName)
	f.ZIndex = 4

	local accent = Instance.new("Frame", f)
	accent.Size = UDim2.new(0, 3, 0, 12)
	accent.Position = UDim2.new(0, 0, 0.5, -6)
	accent.BackgroundColor3 = WHITE
	accent.BorderSizePixel = 0
	accent.ZIndex = 5
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, -12, 0, 16)
	t.Position = UDim2.new(0, 9, 0, 1)
	t.BackgroundTransparency = 1
	t.Text = text:upper()
	t.TextColor3 = WHITE -- Rojo
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextWrapped = false
	t.TextTruncate = Enum.TextTruncate.AtEnd
	t.ZIndex = 5

	local line = Instance.new("Frame", f)
	line.Size = UDim2.new(1, -9, 0, 1)
	line.Position = UDim2.new(0, 9, 1, -2)
	line.BackgroundColor3 = BORDER
	line.BackgroundTransparency = 0.25
	line.BorderSizePixel = 0
	line.ZIndex = 4
end

local _unwalkSavedAnimate = nil
local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end

local function baseCard(tabName, h2)
	local c = Instance.new("Frame", pg(tabName))
	c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BackgroundTransparency = OPTION_TRANSPARENCY
	c.BorderSizePixel = 0
	c.LayoutOrder = lo(tabName)
	c.ZIndex = 4
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
	local cSt = Instance.new("UIStroke", c)
	cSt.Color = BORDER -- Rojo
	cSt.Thickness = 1
	cSt.Transparency = 0.18

	local sideAccent = Instance.new("Frame", c)
	sideAccent.Name = "VisualAccent"
	sideAccent.Size = UDim2.new(0, 2, 0.54, 0)
	sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
	sideAccent.BackgroundColor3 = BORDER
	sideAccent.BackgroundTransparency = 0.2
	sideAccent.BorderSizePixel = 0
	sideAccent.ZIndex = 5
	Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)

	local bottomDetail = Instance.new("Frame", c)
	bottomDetail.Name = "BottomDetail"
	bottomDetail.Size = UDim2.new(1, -24, 0, 1)
	bottomDetail.Position = UDim2.new(0, 12, 1, -1)
	bottomDetail.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	bottomDetail.BackgroundTransparency = 0.58
	bottomDetail.BorderSizePixel = 0
	bottomDetail.ZIndex = 5

	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return c
end

local function cLabel(p, text, x, w, sz, col, font, xa)
	local l = Instance.new("TextLabel", p)
	l.Size = UDim2.new(0, w or 140, 1, 0)
	l.Position = UDim2.new(0, x or 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or WHITE -- Rojo por defecto
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.ZIndex = 10
	return l
end

local function makePillToggle(parent, defOn, onToggle)
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", parent)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER -- Rojo o Rosa
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", parent)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV
end

local function makeKB(parent, kbEntry, onChange)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BackgroundTransparency = INPUT_TRANSPARENCY
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
	b.Text = getDisplayText()
	State._bindButtons = State._bindButtons or {}
	State._bindButtons[kbEntry] = b
	b.TextColor3 = WHITE -- Rojo
	b.Font = Enum.Font.GothamBold
	b.TextSize = 8
	b.ZIndex = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
			if onChange then onChange(inp.KeyCode) end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
	end)
	return b
end

local function rowToggle(tabName, label, sub, defOn, onToggle)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	return makePillToggle(c, defOn, onToggle)
end

local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 120, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 150, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10)
	kb.ZIndex = 11
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", c)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV, kb
end

local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	return kb
end

local function rowInput(tabName, label, sub, default, onChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 130, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 160, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(0, 64, 0, 24)
	box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
	box.BorderSizePixel = 0
	box.Text = tostring(default)
	box.TextColor3 = WHITE -- Rojo
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return box
end

local function rowActionBtn(tabName, label, onClick)
	local b = Instance.new("TextButton", pg(tabName))
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = CARD_BG
	b.BackgroundTransparency = OPTION_TRANSPARENCY
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = WHITE -- Rojo
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.LayoutOrder = lo(tabName)
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local bSt = Instance.new("UIStroke", b)
	bSt.Color = BORDER
	bSt.Thickness = 1.2

	local pressScale = Instance.new("UIScale", b)
	pressScale.Scale = 1

	b.MouseButton1Click:Connect(function()
		TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play()
		task.delay(0.08, function()
			if pressScale and pressScale.Parent then
				TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play()
			end
		end)
		task.delay(0.15, function()
			if b and b.Parent then
				TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play()
			end
		end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return b
end

local function rowCycleSelector(tabName, label, options, defaultValue, onChange)
	local c = baseCard(tabName, 40)
	cLabel(c, label, 10, 110, 11, WHITE, Enum.Font.GothamBold)

	local left = Instance.new("TextButton", c)
	left.Size = UDim2.new(0, 26, 0, 24)
	left.Position = UDim2.new(1, -142, 0.5, -12)
	left.BackgroundColor3 = INPUT_BG
	left.BackgroundTransparency = INPUT_TRANSPARENCY
	left.BorderSizePixel = 0
	left.Text = "←"
	left.TextColor3 = WHITE
	left.Font = Enum.Font.GothamBlack
	left.TextSize = 15
	left.ZIndex = 12
	Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12)
	local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = BORDER; leftStroke.Thickness = 1

	local valueLabel = Instance.new("TextLabel", c)
	valueLabel.Size = UDim2.new(0, 78, 0, 24)
	valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
	valueLabel.BackgroundColor3 = INPUT_BG
	valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
	valueLabel.BorderSizePixel = 0
	valueLabel.TextColor3 = WHITE
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 9
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 11
	Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12)
	local valueStroke = Instance.new("UIStroke", valueLabel); valueStroke.Color = BORDER; valueStroke.Thickness = 1

	local right = Instance.new("TextButton", c)
	right.Size = UDim2.new(0, 26, 0, 24)
	right.Position = UDim2.new(1, -30, 0.5, -12)
	right.BackgroundColor3 = INPUT_BG
	right.BackgroundTransparency = INPUT_TRANSPARENCY
	right.BorderSizePixel = 0
	right.Text = "→"
	right.TextColor3 = WHITE
	right.Font = Enum.Font.GothamBlack
	right.TextSize = 15
	right.ZIndex = 12
	Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12)
	local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = BORDER; rightStroke.Thickness = 1

	local index = 1
	for i, option in ipairs(options) do
		if option == defaultValue then index = i; break end
	end

	local function setValue(value, fireCallback)
		if type(value) == "number" then
			index = ((math.floor(value) - 1) % #options) + 1
		else
			for i, option in ipairs(options) do
				if option == value then index = i; break end
			end
		end
		valueLabel.Text = options[index]
		if fireCallback and onChange then pcall(onChange, options[index], index) end
		return options[index]
	end

	local function move(direction)
		setValue(index + direction, true)
		if State.requestConfigSave then State.requestConfigSave() end
	end

	left.Activated:Connect(function() move(-1) end)
	right.Activated:Connect(function() move(1) end)
	left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)

	setValue(defaultValue, false)
	return setValue, function() return options[index] end
end

do
makeSecHeader("Speed", "Speed Configuration")

do
	local c = baseCard("Speed", 48)
	cLabel(c, "Speed Profile", 10, 92, 11, WHITE, Enum.Font.GothamBold)

	local holder = Instance.new("Frame", c)
	holder.Name = "SpeedProfileSelector"
	holder.Size = UDim2.new(0, 150, 0, 28)
	holder.Position = UDim2.new(1, -160, 0.5, -14)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 12

	local layout = Instance.new("UIListLayout", holder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)

	local function makeProfileButton(label)
		local b = Instance.new("TextButton", holder)
		b.Name = label .. "Profile"
		b.Size = UDim2.new(0, 72, 0, 28)
		b.BackgroundColor3 = CARD_BG
		b.BackgroundTransparency = 0.12
		b.BorderSizePixel = 0
		b.Text = string.upper(label)
		b.TextColor3 = DIM
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.ZIndex = 13
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", b)
		stroke.Color = Color3.fromRGB(19, 19, 19)
		stroke.Thickness = 1
		stroke.Transparency = 0.3
		return b, stroke
	end

	local normalProfileBtn, normalProfileStroke = makeProfileButton("Normal")
	local laggerProfileBtn, laggerProfileStroke = makeProfileButton("Lagger")

	local function refreshProfileVisual()
		local normalActive = State.speedProfile ~= "Lagger"
		TweenService:Create(normalProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = normalActive and Color3.fromRGB(23, 23, 23) or CARD_BG,
			TextColor3 = normalActive and WHITE or DIM,
			BackgroundTransparency = normalActive and 0.02 or 0.12
		}):Play()
		TweenService:Create(laggerProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = not normalActive and Color3.fromRGB(23, 23, 23) or CARD_BG,
			TextColor3 = not normalActive and WHITE or DIM,
			BackgroundTransparency = not normalActive and 0.02 or 0.12
		}):Play()
		normalProfileStroke.Color = normalActive and Color3.fromRGB(54, 54, 54) or Color3.fromRGB(19, 19, 19)
		laggerProfileStroke.Color = not normalActive and Color3.fromRGB(54, 54, 54) or Color3.fromRGB(19, 19, 19)
	end

	local function selectProfile(profile)
		State.speedProfile = profile == "Lagger" and "Lagger" or "Normal"
		refreshProfileVisual()
		if normalBox then
			normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
		end
		if carryBox then
			carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
		end
		if modeValLbl then
			if State.laggerToggled then
				modeValLbl.Text = laggerPhase == 2 and "Lagger 2" or "Lagger 1"
			elseif State.speedToggled then
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"
			else
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"
			end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	normalProfileBtn.Activated:Connect(function() selectProfile("Normal") end)
	laggerProfileBtn.Activated:Connect(function() selectProfile("Lagger") end)

	State._refreshSpeedProfileVisual = refreshProfileVisual
	State._selectSpeedProfile = selectProfile
	refreshProfileVisual()
end

normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerNormalSpeed = v
		else
			NS = v
			RANA_SPEED_NORMAL = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
carryBox = rowInput("Speed", "Carry Speed", nil, CS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerCarrySpeed = v
		else
			CS = v
			RANA_SPEED_CARRY = v
			_G.CarrySpeedValue = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
laggerBox = rowInput("Speed", "Lagger 1", nil, LS, function(v) if v>0 and v<=500 then LS=v; RANA_LAGGER_1=v end end)
laggerBox2 = rowInput("Speed", "Lagger 2", nil, LS2, function(v) if v>0 and v<=500 then LS2=v; RANA_LAGGER_2=v end end)

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold)
	modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = makeKB(c, KB.Speed, function(k) end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then
			State.laggerToggled = false
			if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		end
		if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.laggerToggled = not State.laggerToggled
		if State.laggerToggled then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
		end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

-- Rana Auto Carry belongs to the Speed section.
State._autoCarrySetVisual = rowToggle("Speed", "Auto Carry", "Automatically switches between Normal and Carry speed", false, function(on)
    State.autoCarryEnabled = on == true
    if State.autoCarryEnabled then
        State.speedToggled = false
        State.laggerToggled = false
        laggerPhase = 0
        if mobileSpeedSetActive then mobileSpeedSetActive(false) end
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = "Auto Carry" end
    else
        if modeValLbl then modeValLbl.Text = "Normal" end
    end
    if State.requestConfigSave then State.requestConfigSave() end
end)

makeSecHeader("Bat Aimbot", "Bat Combat V1 & V2")
do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "Auto Bat V1", "Modo predictivo", KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			startBatAimbot()
		else
			stopBatAimbot()
		end
		if mobileBatV1SetActive then mobileBatV1SetActive(on) end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv
	setAutoBat = sv
end

do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "bat v2", "Versión avanzada ", KB.AutoBatV2, false,
	function(on)
		State.autoBatV2Enabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if mobileBatV2SetActive then mobileBatV2SetActive(on) end
	end,
	function() end)
	autoBatV2SetVisual = sv
	setAutoBatV2 = sv
end

State._setTPBatEnabled = function(on)
	State.tpBatEnabled = on == true

	if State._hitboxFollower then
		if State.tpBatEnabled then
			if State.hitboxFollowerEnabled then
				State._hitboxFollower.stop()
			end
		elseif State.hitboxFollowerEnabled and not State.autoBatToggled then
			State._hitboxFollower.start()
		end
	end
end

State._tpBatConfigSetVisual = rowToggleKB("Bat Aimbot", "TP BAT", "Teleport y golpe automático", KB.TPBat, false,
function(on)
	State._setTPBatEnabled(on)
	if State._tpBatSetter then State._tpBatSetter(on) end
end,
function() end)

makeSecHeader("Mechanics", "Game Mechanics")

if not KB.InstaReset then KB.InstaReset = {kb=nil, gp=nil} end

local cInsta = baseCard("Mechanics", 48)
cInsta.LayoutOrder = lo("Mechanics")
cLabel(cInsta, "Insta Reset", 10, 120, 11, WHITE, Enum.Font.GothamBold)
local slInsta = cLabel(cInsta, "Reset Instantáneo", 10, 150, 9, DIM, Enum.Font.Gotham)
slInsta.Size = UDim2.new(0, 150, 0, 13); slInsta.Position = UDim2.new(0, 10, 0, 24)

local plusBtn = Instance.new("TextButton", cInsta)
plusBtn.Size = UDim2.new(0, 20, 0, 20)
plusBtn.Position = UDim2.new(1, -(44+10+36+8+20+4), 0.5, -10)
plusBtn.BackgroundColor3 = KB_BG
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = WHITE -- Rojo
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.ZIndex = 11
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)
local pbs = Instance.new("UIStroke", plusBtn); pbs.Color = BORDER; pbs.Thickness = 1
plusBtn.MouseButton1Click:Connect(function()
	TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play()
	task.delay(0.1, function() TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

	if btnInstaReset then
		btnInstaReset.Visible = not btnInstaReset.Visible
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local kbInsta = makeKB(cInsta, KB.InstaReset, function() end)
kbInsta.Position = UDim2.new(1, -(44+10+36+8), 0.5, -10)
kbInsta.ZIndex = 11

local setInstaToggleVisual
setInstaToggleVisual = makePillToggle(cInsta, false, function(on)
	State.instaResetEnabled = on
	if on then
		if btnInstaReset then
			TweenService:Create(btnInstaReset, TweenInfo.new(0.08), {BackgroundColor3=WHITE, TextColor3=BG}):Play()
			task.delay(0.22, function()
				TweenService:Create(btnInstaReset, TweenInfo.new(0.15), {BackgroundColor3=BG, TextColor3=WHITE}):Play()
			end)
		end

		task.spawn(instaReset)

		task.wait(0.2)
		if setInstaToggleVisual then setInstaToggleVisual(false) end
	end
end)

-- [RANA_SEPARATE_LAGGER_CONTROLS]
rowToggle("Speed", "Lagger 1", "15 speed", false, function(on)
    State.laggerToggled = on == true
    laggerPhase = on and 1 or 0
    if on then State.speedToggled = false end
    if State.requestConfigSave then State.requestConfigSave() end
end)
rowToggle("Speed", "Lagger 2", "24.5 speed", false, function(on)
    State.laggerToggled = on == true
    laggerPhase = on and 2 or 0
    if on then State.speedToggled = false end
    if State.requestConfigSave then State.requestConfigSave() end
end)

-- [RANA_MECHANICS_CONTROLS]
State._ranaAutoStealSetVisual = rowToggle("Mechanics", "Auto Steal", "ON/OFF · Normal / 73", false, function(on)
    CONFIG.AUTO_STEAL_ENABLED = on == true
    if on then startAutoSteal() else stopAutoSteal() end
    if State._setRanaAutoStealHeadVisible then State._setRanaAutoStealHeadVisible(on == true) end
    if State._setRanaAutoStealHeadMode then State._setRanaAutoStealHeadMode(CONFIG.AUTO_STEAL_MODE) end
    if State.requestConfigSave then State.requestConfigSave() end
end)

CONFIG.AUTO_STEAL_MODE = (CONFIG.AUTO_STEAL_MODE == "normal" or CONFIG.AUTO_STEAL_MODE == "73") and CONFIG.AUTO_STEAL_MODE or "normal"
State._ranaAutoStealMode = CONFIG.AUTO_STEAL_MODE
State._ranaAutoStealModeBtn = nil
do
    local c = baseCard("Mechanics", 44)
    cLabel(c, "Auto Steal Mode", 10, 130, 11, WHITE, Enum.Font.GothamBold)
    local b = Instance.new("TextButton", c)
    b.Size = UDim2.new(0, 132, 0, 24)
    b.Position = UDim2.new(1, -142, 0.5, -12)
    b.BackgroundColor3 = KB_BG
    b.BorderSizePixel = 0
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Text = string.upper(CONFIG.AUTO_STEAL_MODE)
    b.ZIndex = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", b).Color = BORDER
    b.MouseButton1Click:Connect(function()
        local order={"normal","73"}; local cur=CONFIG.AUTO_STEAL_MODE; local idx=1
        for i,v in ipairs(order) do if v==cur then idx=i; break end end
        idx=idx%#order+1; local mode=order[idx]
        local was=Steal.AutoStealEnabled
        if was then stopAutoSteal() end
        ranaApplyStealMode(mode); b.Text=string.upper(mode)
        if was then startAutoSteal() end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    State._ranaAutoStealModeBtn=b
end

rowInput("Mechanics", "Steal Radius", "Rana.VS range (5-300)", CONFIG.STEAL_RANGE, function(v)
    v = tonumber(v)
    if v and v >= 5 and v <= 300 then
        CONFIG.STEAL_RANGE = math.clamp(math.floor(v + 0.5), 5, 300)
        Steal.StealRadius = CONFIG.STEAL_RANGE
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)


-- Mechanics: Anti Die, Anti Bat, and Anti Drop (integrated logic with persistent config)
setAntiDieConfigVisual = rowToggle("Mechanics", "Anti Die", "Infinite health protection", false, function(on)
    State.antiDieEnabled = on == true
    if State.antiDieEnabled then
        if startAntiDie then startAntiDie() end
    else
        if stopAntiDie then stopAntiDie() end
    end
    State._configDirty = true
    State._configLoadFailed = false
    if State.requestConfigSave then State.requestConfigSave() end
    if saveConfig then pcall(saveConfig) end
end)
setAntiBatConfigVisual = rowToggle("Mechanics", "Anti Bat", "Velocity anchor against bat", false, function(on)
    State.antiBatEnabled = on == true
    if State.antiBatEnabled then
        if startAntiBat then startAntiBat() end
    else
        if stopAntiBat then stopAntiBat() end
    end
    State._configDirty = true
    State._configLoadFailed = false
    if State.requestConfigSave then State.requestConfigSave() end
    if saveConfig then pcall(saveConfig) end
end)
setAntiDrop404ConfigVisual = rowToggle("Mechanics", "Anti Drop", "Velocity spoof protection", false, function(on)
    State.antiDrop404Enabled = on == true
    if State.antiDrop404Enabled then
        if start404AntiDrop then start404AntiDrop() end
    else
        if stop404AntiDrop then stop404AntiDrop() end
    end
    if State.requestConfigSave then State.requestConfigSave() end
end)

setInfJump       = rowToggle("Mechanics", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setSuperJump     = rowToggle("Mechanics", "Infinite Jump Hold",     nil, false, function(on) State.superJumpEnabled = on end)
setLinieVisual   = rowToggle("Mechanics", "Linia ESP", nil, false, function(on) State.linieEnabled = on end)
setAntiRag       = rowToggle("Mechanics", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Mechanics", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Mechanics", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
setBatCounter = rowToggle("Mechanics", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)

setAutoMedusaVisual = rowToggle("Mechanics", "Auto Medusa", "Uso automático y predictivo", false, function(on)
	MedusaConfig.Enabled = on
end)

rowInput("Mechanics", "Medusa Radius", "Rango de detección", MedusaConfig.Radius, function(v)
	MedusaConfig.Radius = v
	if MedusaConfig.RadiusPart then
		MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	end
end)

rowInput("Mechanics", "Medusa Delay", "Spam Delay", MedusaConfig.Delay, function(v)
	MedusaConfig.Delay = v
end)

RunService.Heartbeat:Connect(function()
    if not State.superJumpEnabled then return end
    local c = LP.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Jump then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

makeSecHeader("Movement", "Movement & Teleport")
rowKBOnly("Movement", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			local char = LP.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoLeft()
			end
		else stopAutoLeft() end
		if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
			local char = LP.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoRight()
			end
		else stopAutoRight() end
		if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
rowKBOnly("Movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)

do
	setAutoTPDownVisual = rowToggle("Movement", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
		if on then startAutoTPDown() else stopAutoTPDown() end
	end)
	rowInput("Movement", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end

makeSecHeader("Visual", "Visual")

-- Rana.VS Outfit selector in Performance.
State._ranaBleedMenuIndex = 1
State._ranaBleedMenuBtn = nil
do
    local c = baseCard("Visual", 44)
    cLabel(c, "Outfit", 10, 130, 11, WHITE, Enum.Font.GothamBold)
    local b = Instance.new("TextButton", c)
    b.Size = UDim2.new(0, 132, 0, 24)
    b.Position = UDim2.new(1, -142, 0.5, -12)
    b.BackgroundColor3 = KB_BG; b.BorderSizePixel=0; b.TextColor3=WHITE; b.Font=Enum.Font.GothamBold; b.TextSize=10; b.Text="OFF"; b.ZIndex=11
    Instance.new("UICorner", b).CornerRadius=UDim.new(0,12); Instance.new("UIStroke", b).Color=BORDER
    b.MouseButton1Click:Connect(function()
        local names={"Off","Bleed 1","Bleed 2","Bleed 3"}
        State._ranaBleedMenuIndex=State._ranaBleedMenuIndex%#names+1
        local name=names[State._ranaBleedMenuIndex]
        pcall(function() RanaBleed:set(name) end)
        b.Text=(name == "Off") and "OFF" or string.upper(name:gsub("Bleed ","OUTFIT "))
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    State._ranaBleedMenuBtn=b
end


State._setHitboxFollower = rowToggle(
    "Visual",
    "Hitbox Follower",
    "Sigue con la mirada la hitbox más cercana",
    false,
    function(on)
        State.hitboxFollowerEnabled = on == true
        if State.hitboxFollowerEnabled then
            if State.autoBatToggled or State.tpBatEnabled then
                State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
                State._hitboxFollower.stop()
            else
                State._hitboxFollower.pausedByBatAim = false
                State._hitboxFollower.start()
            end
        else
            State._hitboxFollower.pausedByBatAim = false
            State._hitboxFollower.stop()
        end
    end
)

do
	local _Lighting = game:GetService("Lighting")
	local _antiLagConn = nil

	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
			instance.Reflectance = 0
			instance.CastShadow = false
		end
	end

	local function optimizeLighting()
		_Lighting.GlobalShadows = false
		_Lighting.FogEnd = 9e9
		_Lighting.Brightness = 1
		_Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
				child.Enabled = false
			end
		end
	end

	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end

	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end

	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = rowToggle("Visual", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local rawSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end

do
	local connection = nil
	local function rawSet(on)
		State.stretchRezEnabled = on
		if on then
			workspace.CurrentCamera.FieldOfView = 120
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if not State.stretchRezEnabled then
					if connection then connection:Disconnect(); connection = nil end
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		else
			if connection then connection:Disconnect(); connection = nil end
			workspace.CurrentCamera.FieldOfView = 70
		end
	end
	local visual = rowToggle("Visual", "Stretch Rez", nil, false, function(on) rawSet(on) end)
	setStretchRez = function(on) visual(on); rawSet(on) end
end

do
	local connection = nil
	local function removeFromCharacter(character)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("Accessory") or obj:IsA("Hat") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local function rawSet(on)
		State.removeAccessoriesEnabled = on
		if on then
			for _, player in pairs(Players:GetPlayers()) do
				removeFromCharacter(player.Character)
			end
			if not connection then
				connection = Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						if State.removeAccessoriesEnabled then removeFromCharacter(character) end
					end)
				end)
			end
		else
			if connection then connection:Disconnect(); connection = nil end
		end
	end
	local visual = rowToggle("Visual", "Remove Accessories", nil, false, function(on) rawSet(on) end)
	setRemoveAccessories = function(on) visual(on); rawSet(on) end
end

do
	local Lighting = game:GetService("Lighting")
	local defaults = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		ExposureCompensation = Lighting.ExposureCompensation,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
	}
	local styles = {
		{name="Off"},
		{name="Galaxy", tint=Color3.fromRGB(122, 122, 122), ambient=Color3.fromRGB(34, 34, 34), atmosphere=Color3.fromRGB(71, 71, 71), decay=Color3.fromRGB(13, 13, 13)},
		{name="Aurora", tint=Color3.fromRGB(236, 236, 236), ambient=Color3.fromRGB(70, 70, 70), atmosphere=Color3.fromRGB(189, 189, 189), decay=Color3.fromRGB(31, 31, 31)},
		{name="Green", tint=Color3.fromRGB(229, 229, 229), ambient=Color3.fromRGB(76, 76, 76), atmosphere=Color3.fromRGB(190, 190, 190), decay=Color3.fromRGB(39, 39, 39)},
		{name="Blue", tint=Color3.fromRGB(172, 172, 172), ambient=Color3.fromRGB(53, 53, 53), atmosphere=Color3.fromRGB(130, 130, 130), decay=Color3.fromRGB(30, 30, 30)},
		{name="Red", tint=Color3.fromRGB(120, 120, 120), ambient=Color3.fromRGB(31, 31, 31), atmosphere=Color3.fromRGB(76, 76, 76), decay=Color3.fromRGB(14, 14, 14)},
		{name="Pink", tint=Color3.fromRGB(196, 196, 196), ambient=Color3.fromRGB(59, 59, 59), atmosphere=Color3.fromRGB(138, 138, 138), decay=Color3.fromRGB(27, 27, 27)},
		{name="Orange", tint=Color3.fromRGB(203, 203, 203), ambient=Color3.fromRGB(55, 55, 55), atmosphere=Color3.fromRGB(119, 119, 119), decay=Color3.fromRGB(26, 26, 26)},
		{name="Cyan", tint=Color3.fromRGB(232, 232, 232), ambient=Color3.fromRGB(77, 77, 77), atmosphere=Color3.fromRGB(182, 182, 182), decay=Color3.fromRGB(40, 40, 40)},
	}
	local function findStyle(name)
		for _, style in ipairs(styles) do
			if style.name == name then return style end
		end
		return styles[1]
	end
	local function clearSky()
		for _, name in ipairs({"GalaxySky", "RanaColorSky", "RanaSkyTint", "RanaSkyAtmosphere", "RanaSkyBloom"}) do
			local object = Lighting:FindFirstChild(name)
			if object then object:Destroy() end
		end
	end
	local function apply(styleName)
		local style = findStyle(styleName)
		clearSky()
		State.skyStyle = style.name
		State.darkModeEnabled = style.name ~= "Off"
		if style.name == "Off" then
			Lighting.Brightness = defaults.Brightness
			Lighting.ClockTime = defaults.ClockTime
			Lighting.ExposureCompensation = defaults.ExposureCompensation
			Lighting.OutdoorAmbient = defaults.OutdoorAmbient
			Lighting.Ambient = defaults.Ambient
			Lighting.FogColor = defaults.FogColor
			return style.name
		end
		local sky = Instance.new("Sky")
		sky.Name = "RanaColorSky"
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454289"
		sky.SkyboxUp = "rbxassetid://159454291"
		sky.StarCount = 3000
		sky.Parent = Lighting
		local correction = Instance.new("ColorCorrectionEffect")
		correction.Name = "RanaSkyTint"
		correction.TintColor = style.tint
		correction.Brightness = 0.05
		correction.Contrast = 0.16
		correction.Saturation = 0.12
		correction.Parent = Lighting
		local atmosphere = Instance.new("Atmosphere")
		atmosphere.Name = "RanaSkyAtmosphere"
		atmosphere.Color = style.atmosphere
		atmosphere.Decay = style.decay
		atmosphere.Density = 0.20
		atmosphere.Offset = 0.05
		atmosphere.Glare = style.name == "Aurora" and 0.42 or 0.2
		atmosphere.Haze = style.name == "Aurora" and 1.55 or 0.85
		atmosphere.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "RanaSkyBloom"
		bloom.Intensity = style.name == "Aurora" and 0.62 or 0.42
		bloom.Size = 28
		bloom.Threshold = 1.05
		bloom.Parent = Lighting
		Lighting.Brightness = 1.45
		Lighting.ClockTime = 0
		Lighting.ExposureCompensation = 0.10
		Lighting.OutdoorAmbient = style.ambient
		Lighting.Ambient = style.ambient:Lerp(Color3.fromRGB(12, 12, 12), 0.16)
		Lighting.FogColor = style.atmosphere:Lerp(Color3.fromRGB(8, 8, 8), 0.05)
		return style.name
	end
	local names = {}
	for _, style in ipairs(styles) do table.insert(names, style.name) end
	setSkySelectorVisual = rowCycleSelector("Visual", "Sky Color", names, State.skyStyle or "Off", function(styleName)
		apply(styleName)
	end)
	setSkyStyle = function(styleName)
		local applied = apply(styleName)
		if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
		return applied
	end
	setDarkMode = function(on)
		return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
	end
end

-- Full Animation Packs selector (Visual)
local AnimationPacks = {
    ["Zombie"]={idle={{"rbxassetid://616158929",1},{"rbxassetid://616158929",1}},walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997",fall="rbxassetid://616157476",climb="rbxassetid://616156119"},
    ["Ninja"]={idle={{"rbxassetid://656117400",1},{"rbxassetid://656117400",1}},walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878",fall="rbxassetid://656115606",climb="rbxassetid://656114359"},
    ["Knight"]={idle={{"rbxassetid://657595757",1},{"rbxassetid://657595757",1}},walk="rbxassetid://657552124",run="rbxassetid://657564596",jump="rbxassetid://658409194",fall="rbxassetid://657600338",climb="rbxassetid://658360781"},
    ["Elder"]={idle={{"rbxassetid://845397899",1},{"rbxassetid://845397899",1}},walk="rbxassetid://845403856",run="rbxassetid://845386501",jump="rbxassetid://845398858",fall="rbxassetid://845397673",climb="rbxassetid://845392038"},
    ["Levitate"]={idle={{"rbxassetid://616006778",1},{"rbxassetid://616006778",1}},walk="rbxassetid://616013216",run="rbxassetid://616013216",jump="rbxassetid://616008936",fall="rbxassetid://616005863",climb="rbxassetid://616003713"},
    ["Astronaut"]={idle={{"rbxassetid://891621366",1},{"rbxassetid://891621366",1}},walk="rbxassetid://891636393",run="rbxassetid://891636393",jump="rbxassetid://891627522",fall="rbxassetid://891617961",climb="rbxassetid://891609353"},
    ["Pirate"]={idle={{"rbxassetid://750781874",1},{"rbxassetid://750781874",1}},walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782230",fall="rbxassetid://750780242",climb="rbxassetid://750779899"},
    ["Toy"]={idle={{"rbxassetid://782841498",1},{"rbxassetid://782841498",1}},walk="rbxassetid://782843345",run="rbxassetid://782842708",jump="rbxassetid://782847020",fall="rbxassetid://782846423",climb="rbxassetid://782843869"},
    ["Vampire"]={idle={{"rbxassetid://1083445855",1},{"rbxassetid://1083445855",1}},walk="rbxassetid://1083473930",run="rbxassetid://1083462077",jump="rbxassetid://1083455352",fall="rbxassetid://1083443587",climb="rbxassetid://1083439238"},
    ["Werewolf"]={idle={{"rbxassetid://1083195517",1},{"rbxassetid://1083195517",1}},walk="rbxassetid://1083178339",run="rbxassetid://1083216690",jump="rbxassetid://1083218792",fall="rbxassetid://1083189019",climb="rbxassetid://1083182000"},
    ["Rthro"]={idle={{"rbxassetid://2510196951",1},{"rbxassetid://2510196951",1}},walk="rbxassetid://2510202577",run="rbxassetid://2510198475",jump="rbxassetid://2510197830",fall="rbxassetid://2510195892",climb="rbxassetid://2510192778"},
    ["Stylish"]={idle={{"rbxassetid://616136790",1},{"rbxassetid://616136790",1}},walk="rbxassetid://616146177",run="rbxassetid://616140816",jump="rbxassetid://616139451",fall="rbxassetid://616134815",climb="rbxassetid://616133594"},
    -- === Them tu Bless.vs (chua co) ===
    ["Adidas Sports"]={idle={{"rbxassetid://18537376492",1},{"rbxassetid://18537371272",1}},walk="rbxassetid://18537392113",run="rbxassetid://18537384940",jump="rbxassetid://18537380791",fall="rbxassetid://18537367238",climb="rbxassetid://18537363391"},
    ["Adidas Community"]={idle={{"rbxassetid://122257458498464",1},{"rbxassetid://102357151005774",1}},walk="rbxassetid://122150855457006",run="rbxassetid://82598234841035",jump="rbxassetid://75290611992385",fall="rbxassetid://98600215928904",climb="rbxassetid://88763136693023"},
    ["Adidas Aura"]={idle={{"rbxassetid://110211186840347",1},{"rbxassetid://114191137265065",1}},walk="rbxassetid://83842218823011",run="rbxassetid://118320322718866",jump="rbxassetid://109996626521204",fall="rbxassetid://95603166884636",climb="rbxassetid://97824616490448"},
    ["Wicked Popular"]={idle={{"rbxassetid://118832222982049",1},{"rbxassetid://76049494037641",1}},walk="rbxassetid://92072849924640",run="rbxassetid://72301599441680",jump="rbxassetid://104325245285198",fall="rbxassetid://121152442762481",climb="rbxassetid://131326830509784"},
    ["Mage"]={idle={{"rbxassetid://10921144709",1},{"rbxassetid://10921145797",1}},walk="rbxassetid://10921152678",run="rbxassetid://10921148209",jump="rbxassetid://10921149743",fall="rbxassetid://10921148939",climb="rbxassetid://10921143404"},
    ["Catwalk Glam"]={idle={{"rbxassetid://133806214992291",1},{"rbxassetid://94970088341563",1}},walk="rbxassetid://109168724482748",run="rbxassetid://81024476153754",jump="rbxassetid://116936326516985",fall="rbxassetid://92294537340807",climb="rbxassetid://119377220967554"},
    ["Wicked Dance"]={idle={{"rbxassetid://92849173543269",1},{"rbxassetid://132238900951109",1}},walk="rbxassetid://73718308412641",run="rbxassetid://135515454877967",jump="rbxassetid://78508480717326",fall="rbxassetid://78147885297412",climb="rbxassetid://129447497744818"},
    ["Superhero"]={idle={{"rbxassetid://10921288909",1},{"rbxassetid://10921290167",1}},walk="rbxassetid://10921298616",run="rbxassetid://10921291831",jump="rbxassetid://10921294559",fall="rbxassetid://10921293373",climb="rbxassetid://10921286911"},
    ["No Boundaries"]={idle={{"rbxassetid://18747067405",1},{"rbxassetid://18747063918",1}},walk="rbxassetid://18747074203",run="rbxassetid://18747070484",jump="rbxassetid://18747069148",fall="rbxassetid://18747062535",climb="rbxassetid://18747060903"},
    ["NFL"]={idle={{"rbxassetid://92080889861410",1},{"rbxassetid://74451233229259",1}},walk="rbxassetid://110358958299415",run="rbxassetid://117333533048078",jump="rbxassetid://119846112151352",fall="rbxassetid://129773241321032",climb="rbxassetid://134630013742019"},
    ["Amazon Unboxed"]={idle={{"rbxassetid://98281136301627",1},{"rbxassetid://98281136301627",1}},walk="rbxassetid://90478085024465",run="rbxassetid://134824450619865",jump="rbxassetid://121454505477205",fall="rbxassetid://94788218468396",climb="rbxassetid://121145883950231"},
    ["Robot"]={idle={{"rbxassetid://616088211",1},{"rbxassetid://616089559",1}},walk="rbxassetid://616095330",run="rbxassetid://616091570",jump="rbxassetid://616090535",fall="rbxassetid://616087089",climb="rbxassetid://616086039"},
    ["Bubbly"]={idle={{"rbxassetid://910004836",1},{"rbxassetid://910009958",1}},walk="rbxassetid://910034870",run="rbxassetid://910025107",jump="rbxassetid://910016857",fall="rbxassetid://910001910",climb="rbxassetid://909997997"},
    ["Cartoon"]={idle={{"rbxassetid://742637544",1},{"rbxassetid://742638445",1}},walk="rbxassetid://742640026",run="rbxassetid://742638842",jump="rbxassetid://742637942",fall="rbxassetid://742637151",climb="rbxassetid://742636889"},
}
local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Mage","Catwalk Glam","Wicked Dance","Superhero","No Boundaries","NFL","Amazon Unboxed","Robot","Bubbly","Cartoon"}
local AnimationPackIndex = 1
local selectedAnimationPack = "OFF"

-- Dedicated animation-pack persistence. This is kept separate from the
-- general config so the selected pack cannot be lost when another setting
-- rewrites or migrates the main configuration.
local ANIMATION_PACK_CONFIG_FILE = "RanaVS_AnimationPack.txt"
local function saveAnimationPackSelection()
    if type(writefile) ~= "function" then return false end
    local ok = pcall(function()
        writefile(ANIMATION_PACK_CONFIG_FILE, selectedAnimationPack or "OFF")
    end)
    return ok
end
local function loadAnimationPackSelection()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return false end
    local exists = false
    pcall(function() exists = isfile(ANIMATION_PACK_CONFIG_FILE) end)
    if not exists then return false end
    local ok, value = pcall(function() return readfile(ANIMATION_PACK_CONFIG_FILE) end)
    if not ok or type(value) ~= "string" then return false end
    value = value:gsub("^%s+", ""):gsub("%s+$", "")
    if value == "OFF" or AnimationPacks[value] then
        selectedAnimationPack = value
        for i, packName in ipairs(AnimationPackList) do
            if packName == value then AnimationPackIndex = i break end
        end
        return true
    end
    return false
end
local function applySelectedAnimationPack(name)
    local char = LP.Character
    local animate = char and char:FindFirstChild("Animate")
    local pack = AnimationPacks[name]
    if not animate or name == "OFF" or not pack then return end
    local function set(folderName, childName, id)
        local folder = animate:FindFirstChild(folderName)
        local obj = folder and folder:FindFirstChild(childName)
        if obj and id then pcall(function() obj.AnimationId = id end) end
    end
    local idle = pack.idle and pack.idle[1] and pack.idle[1][1]
    set("idle", "Animation1", idle)
    set("idle", "Animation2", (pack.idle and pack.idle[2] and pack.idle[2][1]) or idle)
    set("walk", "WalkAnim", pack.walk)
    set("run", "RunAnim", pack.run)
    set("jump", "JumpAnim", pack.jump)
    set("fall", "FallAnim", pack.fall)
    set("climb", "ClimbAnim", pack.climb)
end
rowCycleSelector("Visual", "Animation Packs", AnimationPackList, selectedAnimationPack, function(name)
    selectedAnimationPack = AnimationPacks[name] and name or "OFF"
    for i, packName in ipairs(AnimationPackList) do
        if packName == selectedAnimationPack then AnimationPackIndex = i break end
    end
    applySelectedAnimationPack(selectedAnimationPack)
    saveAnimationPackSelection()
    if State.requestConfigSave then State.requestConfigSave() end
end)

-- Akai-style Visual font selector
local RanaFontStyles = {
    "Gotham", "GothamBold", "SourceSans", "SourceSansBold",
    "Arial", "ArialBold", "Roboto", "RobotoMono", "Ubuntu",
    "Fantasy", "Antique", "Arcade", "Code", "Creepster",
    "Bodoni", "Cartoon", "SciFi", "Highway", "Legacy"
}
local RanaFontStyleIndex = 1
local RanaSelectedFontStyle = "GothamBold"

local function applyRanaFontStyle(fontName)
    local fontEnum
    pcall(function()
        fontEnum = Enum.Font[fontName]
    end)
    if not fontEnum then
        fontEnum = Enum.Font.GothamBold
    end
    local rootGui = gui
    if not rootGui then return end
    for _, descendant in ipairs(rootGui:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            pcall(function()
                descendant.Font = fontEnum
            end)
        end
    end
    RanaSelectedFontStyle = fontName
    for i, name in ipairs(RanaFontStyles) do
        if name == fontName then RanaFontStyleIndex = i break end
    end
end

setRanaFontStyleVisual = rowCycleSelector(
    "Visual",
    "Font Style",
    RanaFontStyles,
    RanaSelectedFontStyle,
    function(name)
        applyRanaFontStyle(name)
        if State.requestConfigSave then State.requestConfigSave() end
    end
)
applyRanaFontStyle(RanaSelectedFontStyle)


-- Re-apply the selected pack after respawn/reset and whenever Roblox recreates Animate.
-- This prevents the default animation script from replacing the selected pack.
local function reapplyAnimationPackAfterCharacterReady(character)
    if selectedAnimationPack == "OFF" then return end
    task.spawn(function()
        local animate = character:WaitForChild("Animate", 8)
        if not animate then return end
        task.wait(0.15)
        applySelectedAnimationPack(selectedAnimationPack)
    end)
end

if LP.Character then
    reapplyAnimationPackAfterCharacterReady(LP.Character)
end

LP.CharacterAdded:Connect(function(character)
    reapplyAnimationPackAfterCharacterReady(character)
    character.ChildAdded:Connect(function(child)
        if child.Name == "Animate" and selectedAnimationPack ~= "OFF" then
            task.wait(0.15)
            applySelectedAnimationPack(selectedAnimationPack)
        end
    end)
end)

setNoIntroToggle = rowToggle("Visual", "No Intro", "Desactiva la intro al volver a ejecutar", State.noIntro == true, function(on)
    State.noIntro = on == true
    State.introEnabled = not State.noIntro
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

makeSecHeader("Settings", "Interface & Binds")

uiScaleBox = rowInput("Settings", "UI Scale", nil, uiScaleValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 50, 150)
	uiScaleValue = n
	if mainUIScale then mainUIScale.Scale = n / 100 end
	if uiScaleBox then uiScaleBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

buttonsSizeBox = rowInput("Settings", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 0, 100)
	applyMobileButtonsSize(n)
	if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

State._buttonsShapeSelectorVisual = rowCycleSelector(
	"Settings",
	"Buttons Shape",
	{"Circle", "Normal", "Square", "Rectangle"},
	State.buttonsShape,
	function(shapeName)
		applyMobileButtonsShape(shapeName)
	end
)

rowKBOnly("Settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)

setHideButtonsVisual = rowToggle("Settings", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
	State.hideButtonsEnabled = on
	local visible = not on

	if MobilePanel then MobilePanel.Visible = visible end
	for _, mobileBtn in pairs(mobileButtonsByName) do
		if mobileBtn and mobileBtn.Parent then
			mobileBtn.Visible = visible
		end
	end

	if btnBatV2 then btnBatV2.Visible = visible end
	if btnInstaReset then btnInstaReset.Visible = visible end
	if State._setRanaAutoStealHeadVisible then State._setRanaAutoStealHeadVisible(visible) end

	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

setLockUIVisual = rowToggle("Settings", "Lock UI", nil, false, function(on)
	uiLocked = on
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

makeSecHeader("Songs", "Songs")

do
	local songParent = game:GetService("CoreGui")
	local starterGui = game:GetService("StarterGui")
	local assetFunction = getcustomasset or getsynasset

	local function notifySong(title, message)
		warn("[RANA " .. string.upper(title) .. "] " .. tostring(message))
		pcall(function()
			starterGui:SetCore("SendNotification", {
				Title = title,
				Text = tostring(message),
				Duration = 6
			})
		end)
	end

	local function fileExists(path)
		if type(isfile) ~= "function" then
			return false
		end
		local ok, exists = pcall(isfile, path)
		return ok and exists == true
	end

	local function validAudio(data)
		if type(data) ~= "string" or #data < 2048 then
			return false
		end
		local header = data:sub(1, 256):lower()
		return not (
			header:find("<html", 1, true)
			or header:find("<!doctype", 1, true)
			or header:find("access denied", 1, true)
			or header:find("not found", 1, true)
			or header:find("error", 1, true)
		)
	end

	local function downloadAudio(url, path)
		if type(writefile) ~= "function" then
			return false, "writefile no está disponible"
		end

		local data, lastError
		local requestFunction = request
			or http_request
			or (syn and syn.request)
			or (fluxus and fluxus.request)

		if type(requestFunction) == "function" then
			local ok, response = pcall(requestFunction, {
				Url = url,
				Method = "GET",
				Headers = {
					["User-Agent"] = "Mozilla/5.0",
					["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
				}
			})
			if ok and type(response) == "table" then
				local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
				local body = response.Body or response.body
				if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
					data = body
				else
					lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
				end
			elseif not ok then
				lastError = tostring(response)
			end
		end

		if not data then
			local ok, result = pcall(function()
				return game:HttpGet(url, true)
			end)
			if ok and validAudio(result) then
				data = result
			elseif not ok then
				lastError = tostring(result)
			elseif not lastError then
				lastError = "el enlace no devolvió un MP3 válido"
			end
		end

		if not data then
			return false, lastError or "no se pudo descargar el audio"
		end

		local ok, err = pcall(writefile, path, data)
		if not ok then
			return false, tostring(err)
		end
		return true
	end

	local function addSong(config)
		local sound
		local wantedOn = false
		local preparing = false
		local started = false
		local loadedConnection

		local function destroySound()
			if loadedConnection then
				loadedConnection:Disconnect()
				loadedConnection = nil
			end
			if sound then
				pcall(function() sound:Destroy() end)
				sound = nil
			end
			started = false
		end

		local function createSound()
			if type(assetFunction) ~= "function" then
				return false, "getcustomasset/getsynasset no está disponible"
			end

			local ok, assetId = pcall(assetFunction, config.file)
			if not ok or type(assetId) ~= "string" or assetId == "" then
				return false, "el archivo local todavía no está disponible"
			end

			destroySound()
			sound = Instance.new("Sound")
			sound.Name = config.soundName
			sound.SoundId = assetId
			sound.Volume = config.volume
			sound.Looped = true
			sound.Parent = songParent

			if config.startAt and config.startAt > 0 then
				pcall(function() sound.TimePosition = config.startAt end)
				loadedConnection = sound.Loaded:Connect(function()
					if loadedConnection then
						loadedConnection:Disconnect()
						loadedConnection = nil
					end
					if sound and sound.Parent then
						pcall(function() sound.TimePosition = config.startAt end)
					end
				end)
			end
			return true
		end

		local function playNow()
			if not sound or not sound.Parent then
				return
			end
			if started then
				local ok = pcall(function() sound:Resume() end)
				if not ok then
					pcall(function() sound:Play() end)
				end
			else
				if config.startAt and config.startAt > 0 then
					pcall(function() sound.TimePosition = config.startAt end)
				end
				pcall(function() sound:Play() end)
				started = true
			end
		end

		local function prepare()
			if sound and sound.Parent then
				if wantedOn then playNow() end
				return
			end
			if preparing then return end
			preparing = true

			local alreadyDownloaded = fileExists(config.file)
			local created = select(1, createSound())

			if not created then
				if not alreadyDownloaded then
					notifySong(config.title, "Descargando " .. config.title .. " por primera vez...")
				end
				local downloaded, downloadError = downloadAudio(config.url, config.file)
				if not downloaded then
					preparing = false
					if config.notifications then
						notifySong(config.title, "No se pudo descargar: " .. tostring(downloadError))
					else
						warn("[RANA SONGS] " .. config.title .. ": " .. tostring(downloadError))
					end
					return
				end
				local okCreate, createError = createSound()
				if not okCreate then
					preparing = false
					if config.notifications then
						notifySong(config.title, tostring(createError))
					else
						warn("[RANA SONGS] " .. config.title .. ": " .. tostring(createError))
					end
					return
				end
			end

			preparing = false
			if wantedOn then playNow() end
		end

		if fileExists(config.file) then
			task.defer(function()
				if not sound then
					createSound()
				end
			end)
		end

		rowToggle("Songs", config.title, nil, false, function(on)
			wantedOn = on
			if on then
				if sound and sound.Parent then
					playNow()
				else
					task.spawn(prepare)
				end
			elseif sound then
				pcall(function() sound:Pause() end)
			end
		end)
	end

	local songs = {
		{
			title = "Tuff Song",
			url = "https://files.catbox.moe/rvf2vy.mp3",
			file = "tuffsong.mp3",
			soundName = "RANA_TuffSong",
			volume = 0.75
		},
		{
			title = "orula",
			url = "https://files.catbox.moe/v20ko9.mp3",
			file = "friosong.mp3",
			soundName = "RANA_Orula",
			volume = 0.85
		},
		{
			title = "X.O.X.O",
			url = "https://files.catbox.moe/jghp0f.mp3",
			file = "xoxosong.mp3",
			soundName = "RANA_XOXO",
			volume = 0.75
		},
		{
			title = "beretta",
			url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
			file = "overseer_beretta_filegarden.mp3",
			soundName = "RANA_Beretta",
			volume = 0.75,
			startAt = 10,
			notifications = true
		},
		{
			title = "to the O",
			url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
			file = "overseer_to_the_o_filegarden.mp3",
			soundName = "RANA_ToTheO",
			volume = 0.75,
			notifications = true
		},
		{
			title = "LAJA",
			url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
			file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
			soundName = "RANA_LAJA",
			volume = 0.75,
			notifications = true
		},
		{
			title = "HORA 0",
			url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
			file = "overseer_hora_0_filegarden.mp3",
			soundName = "RANA_HORA_0",
			volume = 0.75,
			notifications = true
		},
		{
			title = "Lucid Dreams",
			url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
			file = "overseer_lucid_dreams_filegarden.mp3",
			soundName = "RANA_LucidDreams",
			volume = 0.75,
			notifications = true
		}
	}

	for _, config in ipairs(songs) do
		addSong(config)
	end
end

local saveBtn; saveBtn = rowActionBtn("Settings", "Save Config", function()
	if saveConfig then
		local ok, saved = pcall(saveConfig, saveBtn)
		if (not ok or saved ~= true) and State._lastSaveError then
			warn("[RANA AUTO SAVE] " .. tostring(State._lastSaveError))
		end
	elseif State.savePositionBackup then
		local saved = State.savePositionBackup()
		if saveBtn and saveBtn.Parent then
			local previous = saveBtn.Text
			saveBtn.Text = saved and "Positions Saved!" or "Save Failed!"
			task.delay(1.5, function()
				if saveBtn and saveBtn.Parent then saveBtn.Text = previous end
			end)
		end
	end
end)
rowActionBtn("Settings", "Reset Mobile Buttons", function()
    if resetMobileButtons then
        resetMobileButtons()
    end
    if setAutoGrab then
        setAutoGrab(false)
    end
end)

end

State.buildBackgroundPage = function()
	makeSecHeader("Background", "Background Images")

	local infoCard = baseCard("Background", 46)
	cLabel(infoCard, "Choose a background", 10, 250, 11, WHITE, Enum.Font.GothamBold)
	local infoSub = cLabel(infoCard, "Tap an image to apply and save it", 10, 280, 9, DIM, Enum.Font.Gotham)
	infoSub.Size = UDim2.new(1, -20, 0, 14)
	infoSub.Position = UDim2.new(0, 10, 0, 25)

	local grid = Instance.new("Frame", pg("Background"))
	grid.Name = "BackgroundImageGrid"
	grid.Size = UDim2.new(1, -4, 0, 266)
	grid.BackgroundTransparency = 1
	grid.BorderSizePixel = 0
	grid.ClipsDescendants = true
	grid.LayoutOrder = lo("Background")
	grid.ZIndex = 4

	local layout = Instance.new("UIGridLayout", grid)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.FillDirectionMaxCells = 2
	layout.CellSize = UDim2.new(0.5, -5, 0, 80)
	layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top

	for index, assetId in ipairs(State.backgroundAssetIds) do
		local thumb = Instance.new("ImageButton", grid)
		thumb.Name = "BackgroundImage" .. tostring(index)
		thumb.LayoutOrder = index
		thumb.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
		thumb.BackgroundTransparency = 0.05
		thumb.BorderSizePixel = 0
		thumb.AutoButtonColor = false
		thumb.ClipsDescendants = true
		thumb.Image = "rbxassetid://" .. assetId
		thumb.ImageTransparency = 0.08
		thumb.ScaleType = Enum.ScaleType.Crop
		thumb.ZIndex = 6
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 12)

		local thumbStroke = Instance.new("UIStroke", thumb)
		thumbStroke.Color = BORDER
		thumbStroke.Thickness = 1

		local badge = Instance.new("TextLabel", thumb)
		badge.AnchorPoint = Vector2.new(1, 1)
		badge.Size = UDim2.new(0, 28, 0, 18)
		badge.Position = UDim2.new(1, -5, 1, -5)
		badge.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
		badge.BackgroundTransparency = 0.08
		badge.BorderSizePixel = 0
		badge.Text = tostring(index)
		badge.TextColor3 = WHITE
		badge.Font = Enum.Font.GothamBlack
		badge.TextSize = 9
		badge.ZIndex = 8
		Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)

		State.imageChoiceVisuals[assetId] = {stroke=thumbStroke, badge=badge, index=index}
		thumb.Activated:Connect(function()
			State.applyBackgroundImage(assetId, true)
		end)
	end

	State.applyBackgroundImage(State.backgroundAssetId, false)
end
State.buildBackgroundPage()
State.buildBackgroundPage = nil

do
	local BTN_SIZE = 60
	local BTN_GAP  = 12
	local PADDING  = 6
	MobilePanel = Instance.new("Frame")
	MobilePanel.Name = "MobileButtonsPanel"
	MobilePanel.Size = UDim2.new(0, PADDING * 2 + 3 * BTN_SIZE + 2 * BTN_GAP, 0, PADDING * 2 + 4 * BTN_SIZE + 3 * BTN_GAP)
	MobilePanel.Position = UDim2.new(1, -140, 0, 10)
	MobilePanel.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	MobilePanel.BackgroundTransparency = 1
	MobilePanel.BorderSizePixel = 0
	MobilePanel.ZIndex = 95
	MobilePanel.Parent = gui

	local Q_OFF      = Color3.fromRGB(0, 0, 0)
	local Q_ON       = Color3.fromRGB(255, 255, 255)
	local Q_TEXT_OFF = Color3.fromRGB(255, 255, 255)

	State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
	State._purpleAnimationPeriod = 5.5

	local purpleTextPalette = {
		Color3.fromRGB(42, 42, 42),
		Color3.fromRGB(15, 15, 15),
		Color3.fromRGB(7, 7, 7),
		Color3.fromRGB(1, 1, 1),
		Color3.fromRGB(10, 10, 10),
		Color3.fromRGB(32, 32, 32),
	}

	local function paletteColor(palette, progress)
		local count = #palette
		if count == 0 then return Color3.fromRGB(62, 62, 62) end
		if count == 1 then return palette[1] end
		progress = progress % 1
		local scaled = progress * count
		local index = math.floor(scaled) + 1
		local nextIndex = (index % count) + 1
		local alpha = scaled - math.floor(scaled)
		alpha = alpha * alpha * (3 - 2 * alpha)
		return palette[index]:Lerp(palette[nextIndex], alpha)
	end

	State._registerPurpleAnimatedButton = function(button)
		if not button then return end
		button:SetAttribute("PurpleActive", false)
		button:SetAttribute("PurpleFlash", false)
		button.BackgroundColor3 = Q_OFF
		button.TextColor3 = Q_TEXT_OFF
		State._purpleAnimatedButtons[button] = {
			background = button.BackgroundColor3,
			text = button.TextColor3,
		}
	end

	if not State._purpleAnimationStarted then
		State._purpleAnimationStarted = true
		task.spawn(function()
			local lastClock = os.clock()
			while gui and gui.Parent do
				local now = os.clock()
				local dt = math.min(now - lastClock, 0.1)
				lastClock = now
				local progress = (now / State._purpleAnimationPeriod) % 1
				local animatedRed = Color3.fromRGB(255, 255, 255)
				local blend = 1 - math.exp(-dt * 8)

				for button, visual in pairs(State._purpleAnimatedButtons) do
					if button and button.Parent then
						local active = button:GetAttribute("PurpleActive") == true
						local flash = button:GetAttribute("PurpleFlash") == true
						local targetBackground
						local targetText

						if active or flash then
							targetBackground = Q_ON
							targetText = Color3.fromRGB(0, 0, 0)
						else
							targetBackground = Q_OFF
							targetText = Q_TEXT_OFF
						end

						visual.background = visual.background:Lerp(targetBackground, blend)
						visual.text = visual.text:Lerp(targetText, blend)
						button.BackgroundColor3 = visual.background
						button.TextColor3 = visual.text
					else
						State._purpleAnimatedButtons[button] = nil
					end
				end

				RunService.RenderStepped:Wait()
			end
		end)
	end


	State._blueShineLabels = State._blueShineLabels or {}
	State._blueShineGradients = State._blueShineGradients or {}

	local function attachBlueTextShine(button)
		if not button or button:FindFirstChild("BlueTextShine") then return end

		button.TextTransparency = 1

		local shineText = Instance.new("TextLabel")
		shineText.Name = "BlueTextShine"
		shineText.BackgroundTransparency = 1
		shineText.BorderSizePixel = 0
		shineText.Size = UDim2.fromScale(1, 1)
		shineText.Position = UDim2.fromScale(0, 0)
		shineText.Text = button.Text
		shineText.TextColor3 = Color3.fromRGB(255, 255, 255)
		shineText.TextTransparency = 0
		shineText.TextScaled = button.TextScaled
		shineText.TextSize = button.TextSize
		shineText.Font = button.Font
		shineText.TextWrapped = button.TextWrapped
		shineText.LineHeight = button.LineHeight
		shineText.TextXAlignment = button.TextXAlignment
		shineText.TextYAlignment = button.TextYAlignment
		shineText.ZIndex = button.ZIndex + 1
		shineText.Active = false
		shineText.Selectable = false
		shineText.Parent = button

		local shineGradient = Instance.new("UIGradient")
		shineGradient.Name = "CleanBlueShine"
		shineGradient.Rotation = 0
		shineGradient.Offset = Vector2.new(-1.25, 0)
		shineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(50, 50, 50)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(74, 74, 74)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(201, 201, 201)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(111, 111, 111)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 50, 50)),
		})
		shineGradient.Parent = shineText

		State._blueShineLabels[button] = shineText
		State._blueShineGradients[button] = shineGradient

		-- Actualiza únicamente cuando cambia una propiedad; no revisa cada frame.
		button:GetPropertyChangedSignal("Text"):Connect(function()
			if shineText.Parent then shineText.Text = button.Text end
		end)
		button:GetPropertyChangedSignal("Visible"):Connect(function()
			if shineText.Parent then shineText.Visible = button.Visible end
		end)
		button:GetPropertyChangedSignal("TextSize"):Connect(function()
			if shineText.Parent then shineText.TextSize = button.TextSize end
		end)
		button:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
		end)
	end

	-- Un solo brillo activo a la vez. Evita múltiples tweens infinitos simultáneos.
	if not State._blueShineSequenceStarted then
		State._blueShineSequenceStarted = true
		task.spawn(function()
			while gui and gui.Parent do
				local animatedAny = false
				for button, gradient in pairs(State._blueShineGradients) do
					if not (gui and gui.Parent) then break end
					if button and button.Parent and gradient and gradient.Parent and button.Visible then
						animatedAny = true
						gradient.Offset = Vector2.new(-1.25, 0)
						local tween = TweenService:Create(
							gradient,
							TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{Offset = Vector2.new(1.25, 0)}
						)
						tween:Play()
						tween.Completed:Wait()
						task.wait(0.06)
					elseif button and not button.Parent then
						State._blueShineLabels[button] = nil
						State._blueShineGradients[button] = nil
					end
				end
				if not animatedAny then task.wait(0.5) else task.wait(0.8) end
			end
		end)
	end

	local function createMobileButton(name, displayText, col, row, isToggle, onAction)
		local xPos = PADDING + col * (BTN_SIZE + BTN_GAP)
		local yPos = PADDING + row * (BTN_SIZE + BTN_GAP)

		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
		btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
		local defaultPos = UDim2.new(1, -140 + xPos, 0, 10 + yPos)
		btn.Position = defaultPos
		btn.BackgroundColor3 = Q_OFF
		btn.Text = displayText
		btn.TextColor3 = Q_TEXT_OFF
		btn.TextScaled = false; btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.TextWrapped = true; btn.LineHeight = 1.2
		btn.BorderSizePixel = 0; btn.AutoButtonColor = false
		btn.ZIndex = 99
		btn.Parent = gui
		State._registerPurpleAnimatedButton(btn)
		mobileButtonsByName[name] = btn
		mobileButtonDefaultPositions[name] = defaultPos
		makeDraggable(btn)
		btn.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if State.requestConfigSave then State.requestConfigSave() end
			end
		end)
		Instance.new("UICorner", btn).Name = "ButtonShapeCorner"

		local mobileStroke = Instance.new("UIStroke")
		mobileStroke.Name = "BlueOuterStroke"
		mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		mobileStroke.Color = Color3.fromRGB(107, 107, 107)
		mobileStroke.Thickness = 0.9
		mobileStroke.Transparency = 0.22
		mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
		mobileStroke.Parent = btn

		applyMobileButtonsSize(State.buttonsSizeValue)

		local isOn = false
		local function setter(s)
			isOn = s
			btn:SetAttribute("PurpleActive", s == true)
		end

		local function flash()
			btn:SetAttribute("PurpleFlash", true)
			task.delay(0.35, function()
				if btn and btn.Parent then
					btn:SetAttribute("PurpleFlash", false)
				end
			end)
		end

		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)

		return btn, setter
	end

	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(runDrop) end)

	btnBatV2 = Instance.new("TextButton")
	btnBatV2.Name = "Btn_BatnV2"
	btnBatV2.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
	btnBatV2.BackgroundColor3 = Q_OFF
	btnBatV2.Text = "BAT V2"
	btnBatV2.TextColor3 = Q_TEXT_OFF
	btnBatV2.TextScaled = false; btnBatV2.TextSize = 11
	btnBatV2.Font = Enum.Font.GothamBold
	btnBatV2.TextWrapped = true; btnBatV2.LineHeight = 1.2
	btnBatV2.BorderSizePixel = 0; btnAutoButtonColor = false
	btnBatV2.ZIndex = 100
	btnBatV2.Parent = gui
	State._registerPurpleAnimatedButton(btnBatV2)
	Instance.new("UICorner", btnBatV2).Name = "ButtonShapeCorner"
	local batV2Stroke = Instance.new("UIStroke")
	batV2Stroke.Name = "BlueOuterStroke"
	batV2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	batV2Stroke.Color = Color3.fromRGB(107, 107, 107)
	batV2Stroke.Thickness = 0.9
	batV2Stroke.Transparency = 0.22
	batV2Stroke.LineJoinMode = Enum.LineJoinMode.Round
	batV2Stroke.Parent = btnBatV2
	applyMobileButtonsSize(State.buttonsSizeValue)

	makeDraggable(btnBatV2)
	btnBatV2.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	State._batV2On = false
	State._setBatV2Visual = function(s)
		State._batV2On = s
		btnBatV2:SetAttribute("PurpleActive", s == true)
		if autoBatV2SetVisual then autoBatV2SetVisual(s) end
	end

	btnBatV2.Activated:Connect(function()
		State._batV2On = not State._batV2On
		State._setBatV2Visual(State._batV2On)
		State.autoBatV2Enabled = State._batV2On
		if State._batV2On then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	local oldAutoBatV2SetVisual = autoBatV2SetVisual
	autoBatV2SetVisual = function(on)
		State._batV2On = on
		btnBatV2:SetAttribute("PurpleActive", on == true)
		if oldAutoBatV2SetVisual then oldAutoBatV2SetVisual(on) end
	end
	mobileBatV2SetActive = function(on) autoBatV2SetVisual(on) end

	btnInstaReset = Instance.new("TextButton")
	btnInstaReset.Name = "Btn_InstaReset"
	btnInstaReset.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
	btnInstaReset.BackgroundColor3 = Q_OFF
	btnInstaReset.Text = "INSTA\nRESET"
	btnInstaReset.TextColor3 = Q_TEXT_OFF
	btnInstaReset.TextScaled = false; btnInstaReset.TextSize = 11
	btnInstaReset.Font = Enum.Font.GothamBold
	btnInstaReset.TextWrapped = true; btnInstaReset.LineHeight = 1.2
	btnInstaReset.BorderSizePixel = 0; btnInstaReset.AutoButtonColor = false
	btnInstaReset.ZIndex = 100
	btnInstaReset.Parent = gui
	State._registerPurpleAnimatedButton(btnInstaReset)
	Instance.new("UICorner", btnInstaReset).Name = "ButtonShapeCorner"
	local instaResetStroke = Instance.new("UIStroke")
	instaResetStroke.Name = "BlueOuterStroke"
	instaResetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	instaResetStroke.Color = Color3.fromRGB(107, 107, 107)
	instaResetStroke.Thickness = 0.9
	instaResetStroke.Transparency = 0.22
	instaResetStroke.LineJoinMode = Enum.LineJoinMode.Round
	instaResetStroke.Parent = btnInstaReset
	applyMobileButtonsSize(State.buttonsSizeValue)

	makeDraggable(btnInstaReset)
	btnInstaReset.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	btnInstaReset.Activated:Connect(function()
		btnInstaReset:SetAttribute("PurpleFlash", true)
		task.delay(0.35, function()
			if btnInstaReset and btnInstaReset.Parent then
				btnInstaReset:SetAttribute("PurpleFlash", false)
			end
		end)

		if setInstaToggleVisual then
			setInstaToggleVisual(true)
			task.delay(0.2, function() setInstaToggleVisual(false) end)
		end

		task.spawn(instaReset)
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	resetMobileButtons = function()
		for name, btn in pairs(mobileButtonsByName) do
			local defaultPos = mobileButtonDefaultPositions[name]
			if btn and defaultPos then btn.Position = defaultPos end
		end
		btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
		btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
		if State.requestPositionSave then State.requestPositionSave() end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	do
		local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
			State.autoLeftEnabled = on
			if on then
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoLeft() end
			else
				stopAutoLeft()
			end
		end))
		local previous = autoLeftSetVisual
		autoLeftSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
			State.autoBatToggled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
				end
				startBatAimbot()
			else
				stopBatAimbot()
			end
		end))
		local previous = autoBatSetVisual
		autoBatSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoBat = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
			State.autoRightEnabled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoRight() end
			else
				stopAutoRight()
			end
		end))
		local previous = autoRightSetVisual
		autoRightSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoRight = setter end
	end

	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)

	State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "TP\nBAT", 0, 4, true, function(on)
		State._setTPBatEnabled(on)
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end)
	State._tpBatSetVisual = function(on)
		State._setTPBatEnabled(on)
		if State._tpBatSetter then State._tpBatSetter(on) end
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end

	do
		local setter = select(2, createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
			State.speedToggled = on
			if on then
				State.laggerToggled = false
				laggerPhase = 0
				if mobileLaggerSetActive then mobileLaggerSetActive(false) end
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
			else
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end))
		mobileSpeedSetActive = function(on) setter(on) end
	end

	do
		local setter = select(2, createMobileButton("AutoTP", "AUTO\nTP", 1, 3, true, function(on)
			autoTPDownEnabled = on
			if on then
				if startAutoTPDown then task.spawn(startAutoTPDown) end
			else
				if stopAutoTPDown then stopAutoTPDown() end
			end
		end))
		local previous = setAutoTPDownVisual
		setAutoTPDownVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoTPSetActive = function(on) setAutoTPDownVisual(on) end
	end

	do
		local lagger1Button, lagger1Setter
		local lagger2Button, lagger2Setter

		lagger1Button, lagger1Setter = createMobileButton("Lagger1", "LAGGER 1\nOff", 0, 3, true, function(on)
			if on then
				State.laggerToggled = true
				laggerPhase = 1
				State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if mobileLagger2SetActive then mobileLagger2SetActive(false) end
				if modeValLbl then modeValLbl.Text = "Lagger 1" end
			else
				if laggerPhase == 1 then
					State.laggerToggled = false
					laggerPhase = 0
					if modeValLbl then modeValLbl.Text = "Normal" end
				end
			end
		end)

		lagger2Button, lagger2Setter = createMobileButton("Lagger2", "LAGGER 2\nOff", 1, 3, true, function(on)
			if on then
				State.laggerToggled = true
				laggerPhase = 2
				State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if mobileLagger1SetActive then mobileLagger1SetActive(false) end
				if modeValLbl then modeValLbl.Text = "Lagger 2" end
			else
				if laggerPhase == 2 then
					State.laggerToggled = false
					laggerPhase = 0
					if modeValLbl then modeValLbl.Text = "Normal" end
				end
			end
		end)

		mobileLagger1SetActive = function(on)
			if on then
				laggerPhase = 1
				State.laggerToggled = true
				lagger1Setter(true)
				lagger2Setter(false)
			else
				lagger1Setter(false)
				if laggerPhase == 1 then
					laggerPhase = 0
					State.laggerToggled = false
				end
			end
		end

		mobileLagger2SetActive = function(on)
			if on then
				laggerPhase = 2
				State.laggerToggled = true
				lagger2Setter(true)
				lagger1Setter(false)
			else
				lagger2Setter(false)
				if laggerPhase == 2 then
					laggerPhase = 0
					State.laggerToggled = false
				end
			end
		end

		-- Compatibility wrapper for config/load code that still calls the old name.
		mobileLaggerSetActive = function(on)
			if on then
				if laggerPhase == 2 then
					mobileLagger2SetActive(true)
				else
					mobileLagger1SetActive(true)
				end
			else
				mobileLagger1SetActive(false)
				mobileLagger2SetActive(false)
				State.laggerToggled = false
				laggerPhase = 0
			end
		end
	end

	do
		local wasFrozen = false

		RunService.Heartbeat:Connect(function()
		local char = LP.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")
		if not hrp or not hum then return end

		local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0

		if isCurrentlyFrozen then
			if State.autoBatV2Enabled or State._batV2On then
				State._batV2On = false
				State._setBatV2Visual(false)
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if stopBatAimbotV2 then stopBatAimbotV2() end
			end

			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end

			if not wasFrozen then
				wasFrozen = true
				if State.autoLeftEnabled then stopAutoLeft() end
				if State.autoRightEnabled then stopAutoRight() end
			end
		else
			if wasFrozen then
				wasFrozen = false
				if State.autoLeftEnabled then startAutoLeft() end
				if State.autoRightEnabled then startAutoRight() end
			end
		end
		end)
	end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP[player] then return end

    local Line = Drawing.new("Line")
    Line.Color = Color3.fromRGB(15, 15, 15) -- Se mantiene la línea azul
    Line.Thickness = 0.1 -- Ultra delgada
    Line.Transparency = 0.7 -- Sutil transparencia
    Line.Visible = false

    local Distance = Drawing.new("Text")
    Distance.Color = Color3.fromRGB(1, 1, 1)
    Distance.Size = 11
    Distance.Center = true
    Distance.Outline = true
    Distance.Visible = false

    ESP[player] = {Line, Distance}
end

for _, v in ipairs(Players:GetPlayers()) do
    CreateESP(v)
end

Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        for _, obj in ipairs(ESP[player]) do
            obj:Remove()
        end
        ESP[player] = nil
    end
    if player.Character then
        local hl = player.Character:FindFirstChild("HologramRed")
        if hl then hl:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    for player, objs in pairs(ESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if State.linieEnabled and hrp and hum and head and hum.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

            local holo = char:FindFirstChild("HologramRed")
            if not holo then
                holo = Instance.new("Highlight")
                holo.Name = "HologramRed"
                holo.FillColor = Color3.fromRGB(2, 2, 2)  -- Rojo para el cuerpo
                holo.FillTransparency = 0.5
                holo.OutlineColor = Color3.fromRGB(3, 3, 3)  -- Rojo brillante para el borde
                holo.OutlineTransparency = 0.2
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Siempre al frente
                holo.Parent = char
            else
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end

            if visible then
                local distance = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - feetPos.Y)

                objs[1].Visible = true
                objs[1].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                objs[1].To = Vector2.new(pos.X, pos.Y)

                objs[2].Visible = true
                objs[2].Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                objs[2].Text = distance .. " Studs"

            else
                for _, obj in ipairs(objs) do
                    obj.Visible = false
                end
            end
        else
            if char then
                local hl = char:FindFirstChild("HologramRed")
                if hl then hl:Destroy() end
            end
            for _, obj in ipairs(objs) do
                obj.Visible = false
            end
        end
    end
end)

State._positionConfigFile = "RANA_DUELS_V8_POSITIONS.json"
State._positionBackupFile = "RANA_DUELS_V8_POSITIONS.backup.json"
State._positionTempFile = "RANA_DUELS_V8_POSITIONS.tmp.json"
State._positionSaveRequestId = 0

State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end

State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end

State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do
        buttonPositions[name] = State._positionSnapshot(button)
    end

    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        pbPos = State._positionSnapshot(pbFrame),
        batV2Pos = State._positionSnapshot(btnBatV2),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        autoStealBarPos = State._positionSnapshot(State.autoStealBarFrame),
        mobileButtonPositions = buttonPositions,
    }

    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end

    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end

    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end

State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)

    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end

    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false

    local function apply()
        State._restoreSavedPosition(main, data.mainPos)
        State._restoreSavedPosition(mini, data.miniPos)
        State._restoreSavedPosition(MobilePanel, data.panelPos)
        State._restoreSavedPosition(pbFrame, data.pbPos)
        State._restoreSavedPosition(btnBatV2, data.batV2Pos)
        State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        State._restoreSavedPosition(State.autoStealBarFrame, data.autoStealBarPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do
                State._restoreSavedPosition(mobileButtonsByName[name], positionData)
            end
        end
    end

    apply()
    task.delay(0.45, apply)
    task.delay(1.2, apply)

    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end

State.requestPositionSave = function()
    State._positionDirty = true
    State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId

    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end

task.spawn(function()
    task.wait(0.15)
    pcall(State.loadPositionBackup)
end)

local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        local char = _autoBatTarget.Parent
        local hasAntiBat = char:FindFirstChild("Anti-Bat") or char:FindFirstChild("AntiBat") or char:FindFirstChild("Shield")
        if hum and hum.Health > 0 and not hasAntiBat then return _autoBatTarget end
    end
    _autoBatLastScan = now
    _autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local tChar = plr.Character

            local hasAntiBat = tChar:FindFirstChild("Anti-Bat") or tChar:FindFirstChild("AntiBat") or tChar:FindFirstChild("Shield")

            if tRoot and hum and hum.Health > 0 and not hasAntiBat then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    _autoBatTarget = closest
    return _autoBatTarget
end

local LUST_BYPASS_AIMBOT_SPEED = 60
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local BAT_V2_SWING_COOLDOWN = 0.1

local bypassHittingCooldown = false

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local closest, bestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest, bestDistance
end

local function tryHitBypassBat()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true

    pcall(function()
        local char = LP.Character
        if not char then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatToolLust(currentTool) then
            bypassHittingCooldown = false
            return
        end

        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end

            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)

    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then
            bypassHittingCooldown = false
        end
    end)
end

startBatAimbotV2 = function()
    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true

    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end

        local char = LP.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end

        local target = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector

                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position

                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * LUST_BYPASS_AIMBOT_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end

                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false

    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect()
        Conns.aimbotV2 = nil
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(root, "PhysicsRepRootPart", nil)
            end
        end)
    end

    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end

;(function()

local function _isfile(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end
local function _readfile(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end
local function _writefile(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="RANA_DUELS_V8_CONFIG.json"
State._configTempFile="RANA_DUELS_V8_CONFIG.tmp.json"
State._legacyConfigFile="FEARV2Config.json"
State._configBackupFile="RANA_DUELS_V8_CONFIG.backup.json"
State._legacyConfigBackupFile="FEARV2Config.backup.json"
State._legacyConfigTempFile="FEARV2Config.tmp.json"

State.autoLeftPhase=1; State.autoRightPhase=1
State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false
State.batAimbotToggled=false; State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false
State.dropEnabled=false; State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false

Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil
Conns.batCounter=nil; Conns.unwalk=nil

local Presets={}
local PRESET_FILE="FEARV2Presets.json"; local LAST_PRESET_FILE="FEARV2LastPreset.json"
local function buildPresetSnapshot()
    return {normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,stealRadius=Steal.StealRadius,
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,
        autoSteal=Steal.AutoStealEnabled,uiScale=uiScaleValue}
end
local function savePresetsFile()
    local ok,enc=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() _writefile(PRESET_FILE,enc) end) end
end
local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
local function saveLastPresetName(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() _writefile(LAST_PRESET_FILE,enc) end) end
end
local function loadLastPresetName()
    local hasFile=false; pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end

local function createRadiusPart()
	local p = Instance.new("Part")
	p.Name = "MedusaRadius"
	p.Anchored = true
	p.CanCollide = false
	pcall(function() p.CanQuery = false end)
	p.Transparency = 1
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(9, 9, 9)
	p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	p.Parent = workspace
	MedusaConfig.RadiusPart = p
end

local function isMedusaEquipped()
	local char = LP.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == "Medusa's Head" then
			return tool
		end
	end
	return nil
end

RunService.Heartbeat:Connect(function()
	if not MedusaConfig.Enabled then
		if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Transparency = 1 end
		return
	end

	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if not MedusaConfig.RadiusPart then createRadiusPart() end
	MedusaConfig.RadiusPart.Transparency = 0.7
	MedusaConfig.RadiusPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))

	local tool = isMedusaEquipped()
	if tool and (tick() - MedusaConfig.LastUsed >= MedusaConfig.Delay) then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local pRoot = plr.Character.HumanoidRootPart
				if (pRoot.Position - root.Position).Magnitude <= MedusaConfig.Radius then
					tool:Activate()
					MedusaConfig.LastUsed = tick()
					break
				end
			end
		end
	end
end)

local function doTpDown()
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
end

local function runDropBrainrot()
        if State.dropBrainrotActive then return end
        local char, hum, root = safetyCharacterParts()
        if not char then return end
        State.dropBrainrotActive=true; local t0=tick(); local dc
        dc=RunService.Heartbeat:Connect(function()
                local currentChar=LP.Character
                local r=currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum=currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health<=0 then
                        if dc then dc:Disconnect() end
                        State.dropBrainrotActive=false
                        return
                end
                if tick()-t0>=DROP_ASCEND_DURATION then
                        if dc then dc:Disconnect() end
                        r.AssemblyLinearVelocity=Vector3.zero
                        r.AssemblyAngularVelocity=Vector3.zero
                        safetyTeleportToFloor(currentChar,currentHum,r)
                        State.dropBrainrotActive=false
                        return
                end
                r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
        end)
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
local function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
local function stopMedusaCounter() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

local antiRagdollConn = nil

local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)

        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint")
                or obj:IsA("BallSocketConstraint")
                or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

startAntiRagdoll = function()
    if antiRagdollConn then return end

    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end

        local char = LP.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local state = hum:GetState()

        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then

            resetAntiRagdollCharacter(char)
        end
    end)
end

stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end

-- =====================================================
--  LOGIC: ANTI DIE
-- =====================================================
local antiDieHeartConn, antiDieDeathConns, antiDieCharAddedConn = nil, {}, nil

local function protectCharAntiDie(character)
    if not character then return end
    local hum = character:WaitForChild("Humanoid", 5)
    if not hum then return end

    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end)

    local sc = hum.StateChanged:Connect(function(_, new)
        if not State.antiDieEnabled then return end
        if new == Enum.HumanoidStateType.Dead then
            hum.Health = math.huge
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        end
    end)
    table.insert(antiDieDeathConns, sc)

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not State.antiDieEnabled then return end
        if hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
    table.insert(antiDieDeathConns, hc)

    if antiDieHeartConn then antiDieHeartConn:Disconnect() end
    antiDieHeartConn = RunService.Heartbeat:Connect(function()
        if not State.antiDieEnabled then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
end

startAntiDie = function()
    for _, c in ipairs(antiDieDeathConns) do pcall(function() c:Disconnect() end) end
    antiDieDeathConns = {}
    if antiDieHeartConn then antiDieHeartConn:Disconnect(); antiDieHeartConn = nil end
    if antiDieCharAddedConn then antiDieCharAddedConn:Disconnect(); antiDieCharAddedConn = nil end

    protectCharAntiDie(LP.Character)

    antiDieCharAddedConn = LP.CharacterAdded:Connect(function(c)
        if not State.antiDieEnabled then return end
        task.wait(0.1)
        for _, c2 in ipairs(antiDieDeathConns) do pcall(function() c2:Disconnect() end) end
        antiDieDeathConns = {}
        protectCharAntiDie(c)
    end)
end

stopAntiDie = function()
    for _, c in ipairs(antiDieDeathConns) do pcall(function() c:Disconnect() end) end
    antiDieDeathConns = {}
    if antiDieHeartConn then antiDieHeartConn:Disconnect(); antiDieHeartConn = nil end
    if antiDieCharAddedConn then antiDieCharAddedConn:Disconnect(); antiDieCharAddedConn = nil end

    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum.MaxHealth = 100
                hum.Health = 100
            end)
        end
    end
end

-- =====================================================
--  LOGIC: ANTI BAT
-- =====================================================
local antiBatConnection = nil
local AntiBatForceX = 1000
local AntiBatForceZ = 1000

startAntiBat = function()
    if antiBatConnection then return end
    antiBatConnection = RunService.Heartbeat:Connect(function()
        if not State.antiBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(AntiBatForceX, root.Velocity.Y, AntiBatForceZ)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
        end
    end)
end

stopAntiBat = function()
    if antiBatConnection then
        antiBatConnection:Disconnect()
        antiBatConnection = nil
    end
end

-- =====================================================
--  LOGIC: ANTI DROP (spoof velocity without billboard)
-- =====================================================
local rawMt = (type(getrawmetatable) == "function" and getrawmetatable(game)) or nil
local oldRawIdx, oldRawNewIdx
local spoofedVelocity = Vector3.zero
local antiDrop404Active = false

start404AntiDrop = function()
    if antiDrop404Active then return end
    if rawMt and type(setreadonly) == "function" and type(newcclosure) == "function" and type(checkcaller) == "function" then
        pcall(function()
            oldRawIdx = rawMt.__index
            oldRawNewIdx = rawMt.__newindex
            setreadonly(rawMt, false)
            rawMt.__index = newcclosure(function(self, key)
                if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
                   typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
                   self:IsDescendantOf(LP.Character) then
                    return spoofedVelocity
                end
                return oldRawIdx(self, key)
            end)
            rawMt.__newindex = newcclosure(function(self, key, value)
                if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
                   typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
                   self:IsDescendantOf(LP.Character) then
                    spoofedVelocity = value
                    return
                end
                return oldRawNewIdx(self, key, value)
            end)
            setreadonly(rawMt, true)
        end)
    end
    antiDrop404Active = true
end

stop404AntiDrop = function()
    if not antiDrop404Active then return end
    if rawMt and oldRawIdx and type(setreadonly) == "function" then
        pcall(function()
            setreadonly(rawMt, false)
            rawMt.__index = oldRawIdx
            rawMt.__newindex = oldRawNewIdx
            setreadonly(rawMt, true)
            oldRawIdx = nil
            oldRawNewIdx = nil
        end)
    end
    antiDrop404Active = false
end
end

local ContentProvider = game:GetService("ContentProvider")
local Anims = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
    climb = "rbxassetid://116936326516985",
    swim = "rbxassetid://116936326516985",
    swimidle = "rbxassetid://116936326516985"
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)

local function applyAnimPack(char)
    local a = char:FindFirstChild("Animate")
    if not a then return end
    local function s(o, id) if o then o.AnimationId = id end end

    s(a.idle and a.idle.Animation1, Anims.idle1)
    s(a.idle and a.idle.Animation2, Anims.idle2)
    s(a.walk and a.walk.WalkAnim, Anims.walk)
    s(a.run and a.run.RunAnim, Anims.run)
    s(a.jump and a.jump.JumpAnim, Anims.jump)
    s(a.fall and a.fall.FallAnim, Anims.fall)
    s(a.climb and a.climb.ClimbAnim, Anims.climb)
    s(a.swim and a.swim.Swim, Anims.swim)
    s(a.swimidle and a.swimidle.SwimIdle, Anims.swimidle)
end

local animHBConn
function startNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
    local char = LP.Character
    if char then
        applyAnimPack(char)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            for _, t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    animHBConn = RunService.Heartbeat:Connect(function()
        if not State.nuevaAnimacionEnabled then return end
        local c = LP.Character
        if c then applyAnimPack(c) end
    end)
end

function stopNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
end

local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local plots = workspace:WaitForChild("Plots")


local stealMode = "73"

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local stealConnection = nil

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

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil end

    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil

    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
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
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
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
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
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
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0.04, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()

            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0.02, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0.02, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0.02, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
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
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
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

        if progressFill then progressFill.Size = UDim2.new(0.02, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

ranaApplyStealMode = function(mode)
    mode = (mode == "normal" or mode == "73") and mode or "normal"
    stealMode = mode
    CONFIG.AUTO_STEAL_MODE = mode

    if mode == "normal" then
        Steal.StealDuration = 1.30
        Steal.StealDelay = 0.25
        autoGrabStopEnabled = false
        autoGrabSetDelayRadius = 9
    else -- 73
        Steal.StealDuration = 1.30
        Steal.StealDelay = 0.15
        autoGrabStopEnabled = true
        autoGrabStopTime = 0.96
        autoGrabSetDelayRadius = 9
    end
end

startAutoSteal = function()
    if stealConnection then return end
    ranaApplyStealMode(stealMode)
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

stopAutoSteal = function()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then
        TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

ranaApplyStealMode(stealMode)

setAutoGrab = function(on) if on then startAutoSteal() else stopAutoSteal() end end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

saveConfig = function(btn)
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end

    -- Never block manual or auto-saving of newly modified settings
    State._configLoadFailed = false

    if State._saveInProgress then
        State._saveQueued = true
        return false
    end

    State._saveInProgress = true

    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end

    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end

    local savedStealRadius = Steal.StealRadius
    local savedAutoStealEnabled = Steal.AutoStealEnabled == true
    local savedAutoStealMode = CONFIG.AUTO_STEAL_MODE or stealMode or "normal"
    if savedAutoStealMode ~= "normal" and savedAutoStealMode ~= "73" then
        savedAutoStealMode = "normal"
    end
    if CONFIG then
        if type(CONFIG.STEAL_RANGE) == "number" then savedStealRadius = CONFIG.STEAL_RANGE end
        if type(CONFIG.AUTO_STEAL_MODE) == "string" and (CONFIG.AUTO_STEAL_MODE == "normal" or CONFIG.AUTO_STEAL_MODE == "73") then
            savedAutoStealMode = CONFIG.AUTO_STEAL_MODE
        end
    end

    local cfg = {
        configVersion = 8,

        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        stealRadius = savedStealRadius,
        grabRadius = savedStealRadius,
        radius = savedStealRadius,
        stealDuration = Steal.StealDuration,

        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        buttonsSize = State.buttonsSizeValue,
        buttonsShape = State.buttonsShape,
        uiLocked = uiLocked,
        guiVisible = State.guiVisible,

        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),
        guiHideKey = keySnapshot(KB.GuiHide),

        infJump = State.infJumpEnabled,
        superJump = State.superJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        batCounter = State.batCounterEnabled,
        autoStealEnabled = savedAutoStealEnabled,
        autoStealMode = savedAutoStealMode,
        autoCarryEnabled = State.autoCarryEnabled == true,
        outfitMode = RanaBleed and RanaBleed.active or "Off",
        bleedMode = RanaBleed and RanaBleed.active or "Off",
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        hitboxFollower = State.hitboxFollowerEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        animationPack = selectedAnimationPack or "OFF",
        fontStyle = RanaSelectedFontStyle or "GothamBold",
        noIntro = State.noIntro == true,
        introEnabled = State.noIntro ~= true,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,
        antiDieEnabled = State.antiDieEnabled == true,
        antiBatEnabled = State.antiBatEnabled == true,
        antiDrop404Enabled = State.antiDrop404Enabled == true,

        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled == true,
        lagger1Enabled = State.laggerToggled == true and laggerPhase == 1,
        lagger2Enabled = State.laggerToggled == true and laggerPhase == 2,
        laggerPhase = laggerPhase,

        linieEnabled = State.linieEnabled,
        autoMedusaEnabled = MedusaConfig and MedusaConfig.Enabled or nil,
        medusaRadius = MedusaConfig and MedusaConfig.Radius or nil,
        medusaDelay = MedusaConfig and MedusaConfig.Delay or nil,
        nuevaAnimacion = State.nuevaAnimacionEnabled,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,

        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do
                positions[name] = positionSnapshot(mobileBtn)
            end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        batV2Pos = positionSnapshot(btnBatV2),
        instaResetPos = positionSnapshot(btnInstaReset),
        autoStealBarPos = positionSnapshot(frame),
    }

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)

    local saved = false
    if encodeOk and encoded then
        if not btn and encoded == State._lastConfigJson then
            State._configDirty = false
            State._saveInProgress = false
            State._saveQueued = false
            return true
        end

        local atomicOk, atomicResult, atomicErr = pcall(function()
            return State._atomicJsonSave(
                CONFIG_FILE,
                State._configBackupFile,
                State._configTempFile,
                encoded
            )
        end)

        saved = atomicOk and atomicResult == true
        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false

            if State.savePositionBackup then pcall(State.savePositionBackup) end

            State._configDirty = false
        else
            State._lastConfigJson = nil
            State._lastSaveError = tostring((atomicOk and atomicErr) or atomicResult or "No se pudo escribir la configuración")
            warn("[RANA AUTO SAVE] " .. State._lastSaveError)
        end
    else
        State._lastSaveError = "No se pudo convertir la configuración a JSON"
    end

    State._saveInProgress = false

    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end

    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end

    return saved
end

-- Safety autosave loop: catches settings changed by controls that do not emit a click event.
task.spawn(function()
    while gui and gui.Parent do
        task.wait(2)
        if State._configLoaded and State._configDirty and not State._configLoading and saveConfig then
            pcall(saveConfig)
        end
    end
end)

loadConfig = function()
    -- Read the dedicated animation selection first; the main config may be
    -- absent, migrated, or overwritten by older versions.
    if type(loadAnimationPackSelection) == "function" then pcall(loadAnimationPackSelection) end
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end

    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    if type(mainCfg) == "table" then State._hadConfigFileOnDisk = true end
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)

    local cfg, raw = nil, nil
    local loadedFromBackup = false
    local loadedFromLegacy = false
    local loadedFromTemp = false

    -- Always prefer the primary config. Older patches preferred a stale
    -- temporary file whenever its bytes differed, which caused settings to
    -- appear to reset after every re-execution.
    if type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(tempCfg) == "table" then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true
        loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true
        loadedFromBackup = true
    end

    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = _isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end

    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = false
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false
        State._lastSaveError = hadAnyConfigFile and "Config file exists but could not be decoded" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end

    State._configLoading = true
    State._configLoadFailed = false
    State._allowInitialConfigCreation = false

    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            RANA_SPEED_NORMAL = NS
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            RANA_SPEED_CARRY = CS
            _G.CarrySpeedValue = CS
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end

        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
            if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
        end

        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end

        if type(cfg.buttonsSize) == "number" then
            State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100)
        end
        if cfg.buttonsShape ~= nil then
            State.buttonsShape = normalizeMobileButtonsShape(cfg.buttonsShape)
        end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end
        if State._buttonsShapeSelectorVisual then
            State._buttonsShapeSelectorVisual(State.buttonsShape, false)
        end

        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end

        if cfg.guiVisible ~= nil then
            State.guiVisible = cfg.guiVisible == true
            if main then main.Visible = State.guiVisible end
            if mini then mini.Visible = not State.guiVisible end
        end

        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
            if getgenv and getgenv().FEARV2MusicBtn then
                getgenv().FEARV2MusicBtn.Text = "Music " .. tostring(State.selectedIntroMusic)
            end
        end
        if cfg.noIntro ~= nil then
            State.noIntro = cfg.noIntro == true
        elseif cfg.introEnabled ~= nil then
            State.noIntro = cfg.introEnabled ~= true
        end
        State.introEnabled = not State.noIntro
        if setNoIntroToggle then setNoIntroToggle(State.noIntro, false) end
        if setIntroToggle then setIntroToggle(State.introEnabled, false) end

        if type(cfg.autoTPDownHeight) == "number" then
            autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500)
        end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
        end

        -- Restore the user's saved radius without silently resetting it to 10.
        local savedRadius = tonumber(cfg.stealRadius or cfg.grabRadius or cfg.radius or cfg.STEAL_RANGE or cfg.StealRadius)
        if savedRadius and savedRadius >= 5 and savedRadius <= 300 then
            savedRadius = math.clamp(math.floor(savedRadius + 0.5), 5, 300)
        else
            savedRadius = math.clamp(math.floor((tonumber(CONFIG.STEAL_RANGE) or tonumber(Steal.StealRadius) or 61) + 0.5), 5, 300)
        end
        if type(savedRadius) == "number" then
            Steal.StealRadius = savedRadius
            if progressRadLbl then progressRadLbl.Text = string.upper(CONFIG.AUTO_STEAL_MODE or "normal") end
            if radValBtn then radValBtn.Text = tostring(savedRadius) end
            if radBox then radBox.Text = tostring(savedRadius) end
            if CONFIG then CONFIG.STEAL_RANGE = savedRadius; Steal.StealRadius = savedRadius end
        end
        if type(cfg.stealDuration) == "number" then
            Steal.StealDuration = cfg.stealDuration
            if durValBtn then durValBtn.Text = tostring(Steal.StealDuration) end
        end

        if MedusaConfig then
            if type(cfg.medusaRadius) == "number" then
                MedusaConfig.Radius = cfg.medusaRadius
                if MedusaConfig.RadiusPart then
                    MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius * 2, MedusaConfig.Radius * 2)
                end
            end
            if type(cfg.medusaDelay) == "number" then
                MedusaConfig.Delay = cfg.medusaDelay
            end
        end

        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil
            entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end

            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end

        loadKey(KB.AutoLeft, cfg.autoLeftKey)
        loadKey(KB.AutoRight, cfg.autoRightKey)
        loadKey(KB.Drop, cfg.dropKey)
        loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey)
        loadKey(KB.AutoBatV2, cfg.autoBatV2Key)
        loadKey(KB.InstaReset, cfg.instaResetKey)
        loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey)
        loadKey(KB.Lagger, cfg.laggerKey)
        loadKey(KB.GuiHide, cfg.guiHideKey)

        -- Anti Die / Anti Bat / Anti Drop restore in its own protected pass:
        -- a failure anywhere above can no longer leave these unrestored.
        if cfg.antiDieEnabled == nil and cfg.antiDie ~= nil then cfg.antiDieEnabled = cfg.antiDie end
        if cfg.antiBatEnabled == nil and cfg.antiBat ~= nil then cfg.antiBatEnabled = cfg.antiBat end
        if cfg.antiDrop404Enabled == nil and cfg.antiDrop ~= nil then cfg.antiDrop404Enabled = cfg.antiDrop end
        pcall(function()
            if cfg.antiDieEnabled ~= nil then
                State.antiDieEnabled = cfg.antiDieEnabled == true
                if setAntiDieConfigVisual then pcall(setAntiDieConfigVisual, State.antiDieEnabled) end
                if State.antiDieEnabled then
                    if startAntiDie then startAntiDie() end
                else
                    if stopAntiDie then stopAntiDie() end
                end
            end
            if cfg.antiBatEnabled ~= nil then
                State.antiBatEnabled = cfg.antiBatEnabled == true
                if setAntiBatConfigVisual then pcall(setAntiBatConfigVisual, State.antiBatEnabled) end
                if State.antiBatEnabled then
                    if startAntiBat then startAntiBat() end
                else
                    if stopAntiBat then stopAntiBat() end
                end
            end
            if cfg.antiDrop404Enabled ~= nil then
                State.antiDrop404Enabled = cfg.antiDrop404Enabled == true
                if setAntiDrop404ConfigVisual then pcall(setAntiDrop404ConfigVisual, State.antiDrop404Enabled) end
                if State.antiDrop404Enabled then
                    if start404AntiDrop then start404AntiDrop() end
                else
                    if stop404AntiDrop then stop404AntiDrop() end
                end
            end
        end)

        if cfg.infJump ~= nil then
            State.infJumpEnabled = cfg.infJump == true
            if setInfJump then setInfJump(State.infJumpEnabled) end
        end
        if cfg.superJump ~= nil then
            State.superJumpEnabled = cfg.superJump == true
            if setSuperJump then setSuperJump(State.superJumpEnabled) end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
            if State.medusaCounterEnabled then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        end
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then startBatCounter() else stopBatCounter() end
        end
        -- Rana Auto Steal: restore the saved mode first, then the saved ON/OFF state.
        if cfg.autoStealMode ~= nil then
            local savedMode = tostring(cfg.autoStealMode):lower()
            if savedMode ~= "normal" and savedMode ~= "73" then savedMode = "normal" end
            ranaApplyStealMode(savedMode)
            if State._ranaAutoStealModeBtn then
                State._ranaAutoStealModeBtn.Text = string.upper(savedMode)
            end
        end
        if cfg.autoStealEnabled == nil and cfg.autoSteal ~= nil then
            cfg.autoStealEnabled = cfg.autoSteal
        end
        if cfg.autoStealEnabled ~= nil then
            local autoStealOn = cfg.autoStealEnabled == true
            CONFIG.AUTO_STEAL_ENABLED = false
            pcall(stopAutoSteal)
            if State._ranaAutoStealSetVisual then State._ranaAutoStealSetVisual(autoStealOn) end
            CONFIG.AUTO_STEAL_ENABLED = autoStealOn
            Steal.AutoStealEnabled = autoStealOn
            if autoStealOn then
                pcall(startAutoSteal)
            end
            if State._ranaAutoStealSetVisual then State._ranaAutoStealSetVisual(autoStealOn) end
        end

        if cfg.autoCarryEnabled ~= nil then
            State.autoCarryEnabled = cfg.autoCarryEnabled == true
            if State._autoCarrySetVisual then pcall(State._autoCarrySetVisual, State.autoCarryEnabled) end
        end

        if (cfg.outfitMode ~= nil or cfg.bleedMode ~= nil) and RanaBleed then
            local bleedName = tostring(cfg.outfitMode ~= nil and cfg.outfitMode or cfg.bleedMode)
            if bleedName ~= "Off" and bleedName ~= "Bleed 1" and bleedName ~= "Bleed 2" and bleedName ~= "Bleed 3" then bleedName = "Off" end
            pcall(function() RanaBleed:set(bleedName) end)
            local bleedIndex = ({Off=1,["Bleed 1"]=2,["Bleed 2"]=3,["Bleed 3"]=4})[bleedName] or 1
            State._ranaBleedMenuIndex = bleedIndex
            if State._ranaBleedMenuBtn then
                State._ranaBleedMenuBtn.Text = (bleedName == "Off") and "OFF" or string.upper(bleedName:gsub("Bleed ","OUTFIT "))
            end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
        end

        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true
            setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true
            setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true
            setAntiLag(State.antiLagEnabled)
        end

        if cfg.hitboxFollower ~= nil or cfg.hitboxFollowerEnabled ~= nil then
            State.hitboxFollowerEnabled = (cfg.hitboxFollower ~= nil and cfg.hitboxFollower == true)
                or (cfg.hitboxFollower == nil and cfg.hitboxFollowerEnabled == true)
            if State._setHitboxFollower then
                State._setHitboxFollower(State.hitboxFollowerEnabled)
            end
            if State.hitboxFollowerEnabled then
                State._hitboxFollower.start()
            else
                State._hitboxFollower.stop()
            end
        end

        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end

        if type(cfg.fontStyle) == "string" and applyRanaFontStyle then
            local wantedFont = cfg.fontStyle
            local validFont = false
            for _, fontName in ipairs(RanaFontStyles or {}) do
                if fontName == wantedFont then validFont = true break end
            end
            if validFont then
                pcall(function()
                    applyRanaFontStyle(wantedFont)
                    if setRanaFontStyleVisual then setRanaFontStyleVisual(wantedFont, false) end
                end)
            end
        end

        if type(cfg.animationPack) == "string" then
            local savedPack = cfg.animationPack
            local valid = savedPack == "OFF" or AnimationPacks[savedPack] ~= nil
            if valid then
                selectedAnimationPack = savedPack
                for i, packName in ipairs(AnimationPackList) do
                    if packName == savedPack then AnimationPackIndex = i break end
                end
                task.defer(function()
                    if selectedAnimationPack ~= "OFF" and LP.Character then
                        reapplyAnimationPackAfterCharacterReady(LP.Character)
                    end
                end)
            end
        end

        if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
            task.defer(function()
                if setDesync then setDesync(State.desyncEnabled) end
                if saDesync then saDesync(State.desyncEnabled) end
                if State.desyncEnabled and startDesyncSession then startDesyncSession() end
            end)
        end

        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end
        if cfg.autoMedusaEnabled ~= nil then
            if MedusaConfig then MedusaConfig.Enabled = cfg.autoMedusaEnabled == true end
            if setAutoMedusaVisual then setAutoMedusaVisual(cfg.autoMedusaEnabled == true) end
        end

        if cfg.nuevaAnimacion ~= nil then
            State.nuevaAnimacionEnabled = cfg.nuevaAnimacion == true
            if setNuevaAnimacionVisual then setNuevaAnimacionVisual(State.nuevaAnimacionEnabled) end
            if State.nuevaAnimacionEnabled then
                task.defer(startNuevaAnimacion)
            else
                task.defer(stopNuevaAnimacion)
            end
        end

        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end

        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end

            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnBatV2 then btnBatV2.Visible = visible end
            if btnInstaReset then
                btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false)
            end
            if State._setRanaAutoStealHeadVisible then State._setRanaAutoStealHeadVisible(visible) end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end

        State.speedProfile = cfg.speedProfile == "Lagger" and "Lagger" or "Normal"
        if State._refreshSpeedProfileVisual then State._refreshSpeedProfileVisual() end
        if normalBox then
            normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
        end
        if carryBox then
            carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
        end

        State.speedToggled = cfg.speedToggled == true
        State.laggerToggled = cfg.laggerMode == true
        laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0)
        laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)

        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end

        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if mobileLagger1SetActive then mobileLagger1SetActive(State.laggerToggled and laggerPhase == 1) end
        if mobileLagger2SetActive then mobileLagger2SetActive(State.laggerToggled and laggerPhase == 2) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end

        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end

        local autoBatV1 = cfg.autoBatToggled == true
        local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end

        State.autoBatToggled = autoBatV1
        State.autoBatV2Enabled = autoBatV2

        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end

        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end

        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos)
            restorePosition(mini, cfg.miniPos)
            restorePosition(MobilePanel, cfg.panelPos)

            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do
                    restorePosition(mobileButtonsByName[name], positionData)
                end
            end

            restorePosition(pbFrame, cfg.pbPos)
            restorePosition(btnBatV2, cfg.batV2Pos)
            restorePosition(btnInstaReset, cfg.instaResetPos)
            restorePosition(frame, cfg.autoStealBarPos)
        end

        restoreSavedPositions()
        task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then
                    pcall(State.loadPositionBackup)
                end
            end)
        end)
    end)

    State._configLoading = false
    -- A readable config is still a valid config even if one optional UI
    -- restore callback fails.  Do not let that failure cause defaults or a
    -- remembered preset to overwrite the user's saved values.
    State._configLoaded = true
    State._configLoadFailed = false

    if type(raw) == "string" and raw ~= "" then
        State._lastConfigJson = raw
        State._lastSaveError = applyOk and nil or "Some optional settings could not be applied"
        State._configDirty = false
    else
        State._lastSaveError = nil
    end

    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false

    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end

    return applyOk
end

State._otherSpeedLabels = State._otherSpeedLabels or {}
State._otherSpeedConnections = State._otherSpeedConnections or {}

State._attachOtherSpeedBillboard = function(player, character)
    if not player or player == LP or not character then return end

    task.spawn(function()
        local head = character:WaitForChild("Head", 8)
        local root = character:WaitForChild("HumanoidRootPart", 8)
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
        if not head or not root or not humanoid then return end

        local old = head:FindFirstChild("RANAOtherSpeedBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name = "RANAOtherSpeedBB"
        bb.Adornee = head
        bb.Parent = head
        bb.Size = UDim2.new(0, 180, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 1000

        local label = Instance.new("TextLabel")
        label.Name = "OtherSpeedBillLbl"
        label.Parent = bb
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "0.0"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        State._otherSpeedLabels[player] = {
            label = label,
            root = root,
            humanoid = humanoid,
        }
    end)
end

State._setupOtherPlayerBillboard = function(player)
    if not player or player == LP then return end

    local previousConnection = State._otherSpeedConnections[player]
    if previousConnection then
        pcall(function() previousConnection:Disconnect() end)
    end

    State._otherSpeedConnections[player] = player.CharacterAdded:Connect(function(character)
        State._attachOtherSpeedBillboard(player, character)
    end)

    if player.Character then
        State._attachOtherSpeedBillboard(player, player.Character)
    end
end

task.spawn(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        State._setupOtherPlayerBillboard(otherPlayer)
    end
end)

Players.PlayerAdded:Connect(function(player)
    State._setupOtherPlayerBillboard(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local connection = State._otherSpeedConnections[player]
    if connection then pcall(function() connection:Disconnect() end) end
    State._otherSpeedConnections[player] = nil
    State._otherSpeedLabels[player] = nil
end)

task.spawn(function()
    while gui and gui.Parent do
        for player, data in pairs(State._otherSpeedLabels) do
            local label = data and data.label
            local root = data and data.root
            local humanoid = data and data.humanoid

            if player.Parent and label and label.Parent and root and root.Parent and humanoid and humanoid.Health > 0 then
                local velocity = root.AssemblyLinearVelocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                label.Text = string.format("%.1f", horizontalSpeed)
                label.Visible = true
            elseif label and label.Parent then
                label.Visible = false
            end
        end
        task.wait(0.08)
    end
end)

local h,hrp,speedLbl
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("FEARV2MobileBB"); if oldBB then oldBB:Destroy() end
        local bb=Instance.new("BillboardGui",head); bb.Name="FEARV2MobileBB"
        bb.Size=UDim2.new(0,160,0,24); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        speedLbl=Instance.new("TextLabel",bb); speedLbl.Name="SpeedBillLbl"
        speedLbl.Size=UDim2.new(1,0,0,24); speedLbl.Position=UDim2.new(0,0,0,0); speedLbl.BackgroundTransparency=1
        speedLbl.Text="0.0"; speedLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        speedLbl.Font=Enum.Font.GothamBlack; speedLbl.TextScaled=true
        speedLbl.TextStrokeTransparency=0; speedLbl.TextStrokeColor3=Color3.fromRGB(0, 0, 0)
    end


    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.antiDieEnabled and startAntiDie then task.wait(0.2); startAntiDie() end
    if State.antiBatEnabled and startAntiBat then task.wait(0.2); startAntiBat() end
    if State.antiDrop404Enabled and start404AntiDrop then task.wait(0.2); start404AntiDrop() end

    if State.medusaCounterEnabled then setupMedusaCounter(char) end

    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

local ranaSpeedConnection
local function startRanaSpeedSystem()
	if ranaSpeedConnection then return end

	ranaSpeedConnection = RunService.PreSimulation:Connect(function()
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not hum or not root or hum.Health <= 0 then return end
		if State._tpInProgress then return end

		-- Rana mode priority: Lagger 2 > Lagger 1 > Carry/Normal.
		local speed
		if State.laggerToggled then
			speed = (laggerPhase == 2) and RANA_LAGGER_2 or RANA_LAGGER_1
		elseif State.autoCarryEnabled then
			speed = ranaIsCarrying() and getProfileCarrySpeed() or getProfileNormalSpeed()
		elseif State.speedToggled then
			speed = getProfileCarrySpeed()
		else
			speed = getProfileNormalSpeed()
		end

		-- Other movement systems keep priority over the speed core.
		if State.autoBatToggled or State.autoLeftEnabled or State.autoRightEnabled then
			return
		end

		local dir = hum.MoveDirection
		if dir.Magnitude > 0.05 then
			local unit = dir.Unit
			local current = root.AssemblyLinearVelocity
			local desired = Vector3.new(unit.X * speed, current.Y, unit.Z * speed)
			local delta = desired - current
			local mass = root.AssemblyMass or 1
			pcall(function()
				root:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass)
			end)
		end
	end)
end

startRanaSpeedSystem()

RunService.RenderStepped:Connect(function()
	if not (h and hrp) then return end
	pcall(function()
		if speedLbl then
			local v = hrp.AssemblyLinearVelocity
			speedLbl.Text = string.format("%.1f", Vector3.new(v.X, 0, v.Z).Magnitude)
		end
	end)
end)

UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2; State.laggerToggled = true; State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 2" end
        else
            laggerPhase = 1; State.laggerToggled = true; State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 1" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
    elseif kbMatch(KB.InstaReset,kc) then
        task.spawn(instaReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("PurpleFlash", true)
            task.delay(0.35, function() if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    elseif kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    end

    if State.requestConfigSave then State.requestConfigSave() end
end)

-- [RANA_AUTO_STEAL_HEAD_GUI]
-- Rana.VS Auto Steal status/progress bar (Reset-proof & self-healing)
do
    local headGui = nil
    local card = nil
    State._autoStealBarVisible = true

    local function getSafeGuiParent()
        local target = nil
        pcall(function()
            if gethui then target = gethui() end
        end)
        if not target then
            pcall(function()
                target = game:GetService("CoreGui")
            end)
        end
        if not target then
            target = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        end
        return target
    end

    local function isAlive(inst)
        if not inst then return false end
        local ok, par = pcall(function() return inst.Parent end)
        return ok and par ~= nil
    end

    local function buildOrRebuildBar()
        if isAlive(headGui) and isAlive(card) then
            return headGui
        end

        pcall(function()
            if headGui then headGui:Destroy() end
        end)

        headGui = Instance.new("BillboardGui")
        headGui.Name = "RanaAutoStealBar"
        headGui.ResetOnSpawn = false
        headGui.AlwaysOnTop = true
        headGui.LightInfluence = 0
        headGui.SizeOffset = Vector2.new(0, 0)
        headGui.Size = UDim2.new(0, 300, 0, 42)
        headGui.StudsOffset = Vector3.new(0, 3.9, 0)
        headGui.MaxDistance = 250
        headGui.Enabled = State._autoStealBarVisible == true

        card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 1, 0)
        card.BackgroundColor3 = BG
        card.BackgroundTransparency = 0.12
        card.BorderSizePixel = 0
        card.Parent = headGui
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = BORDER
        stroke.Thickness = 1.5

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -12, 0, 16)
        title.Position = UDim2.new(0, 6, 0, 3)
        title.BackgroundTransparency = 1
        title.Text = "AUTO STEAL"
        title.TextColor3 = WHITE
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 10
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -72, 0, 9)
        track.Position = UDim2.new(0, 6, 1, -14)
        track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        track.BackgroundTransparency = 0
        track.BorderSizePixel = 0
        track.ClipsDescendants = true
        track.Parent = card
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        progressFill = Instance.new("Frame")
        progressFill.Size = UDim2.new(0.02, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
        progressFill.BorderSizePixel = 0
        progressFill.Parent = track
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

        progressPct = Instance.new("TextLabel")
        progressPct.Size = UDim2.new(0, 58, 0, 16)
        progressPct.Position = UDim2.new(1, -64, 1, -18)
        progressPct.BackgroundTransparency = 1
        progressPct.Text = "0%"
        progressPct.TextColor3 = WHITE
        progressPct.Font = Enum.Font.GothamBold
        progressPct.TextSize = 9
        progressPct.TextXAlignment = Enum.TextXAlignment.Right
        progressPct.Parent = card

        progressRadLbl = Instance.new("TextLabel")
        progressRadLbl.Size = UDim2.new(0, 58, 0, 16)
        progressRadLbl.Position = UDim2.new(1, -64, 0, 3)
        progressRadLbl.BackgroundTransparency = 1
        progressRadLbl.Text = string.upper(CONFIG.AUTO_STEAL_MODE or "normal")
        progressRadLbl.TextColor3 = DIM
        progressRadLbl.Font = Enum.Font.GothamBold
        progressRadLbl.TextSize = 8
        progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
        progressRadLbl.Parent = card

        local parentContainer = getSafeGuiParent()
        if parentContainer then
            headGui.Parent = parentContainer
        end

        pbFrame = card
        State.autoStealBarFrame = card
        frame = card

        return headGui
    end

    local function attachToHead(char)
        char = char or LP.Character
        if not char then return false end
        local head = char:FindFirstChild("Head")
        if not head then return false end

        buildOrRebuildBar()

        if headGui then
            headGui.Adornee = head
            local safeParent = getSafeGuiParent()
            if headGui.Parent ~= safeParent and safeParent then
                headGui.Parent = safeParent
            end
            headGui.Enabled = State._autoStealBarVisible == true
            return true
        end
        return false
    end

    -- Initial attachment
    task.spawn(function()
        for _ = 1, 60 do
            if attachToHead(LP.Character) then break end
            task.wait(0.2)
        end
    end)

    -- Persistent reconnection on character reset / respawn
    LP.CharacterAdded:Connect(function(newCharacter)
        task.spawn(function()
            task.wait(0.1)
            for _ = 1, 80 do
                if newCharacter and newCharacter.Parent then
                    local head = newCharacter:FindFirstChild("Head")
                    if head and attachToHead(newCharacter) then
                        break
                    end
                end
                task.wait(0.2)
            end
        end)
    end)

    State._setRanaAutoStealHeadVisible = function(on)
        State._autoStealBarVisible = on == true
        if not isAlive(headGui) or not headGui.Adornee or not headGui.Adornee.Parent then
            attachToHead(LP.Character)
        end
        if headGui then
            headGui.Enabled = State._autoStealBarVisible
        end
    end

    State._setRanaAutoStealHeadMode = function(mode)
        if progressRadLbl and isAlive(progressRadLbl) then
            progressRadLbl.Text = string.upper(mode or "normal")
        end
    end

    -- Background keep-alive watcher: reattaches instantly if adornee or parent is lost
    task.spawn(function()
        while true do
            task.wait(0.5)
            local char = LP.Character
            if char and char:FindFirstChild("Head") then
                if not isAlive(headGui) or headGui.Adornee ~= char:FindFirstChild("Head") or not isAlive(headGui.Parent) then
                    attachToHead(char)
                end
            end
            if progressRadLbl and isAlive(progressRadLbl) then
                progressRadLbl.Text = string.upper(CONFIG.AUTO_STEAL_MODE or "normal")
            end
        end
    end)
end

loadPresetsFile()

-- Open directly on the Mechanics tab so the Rana controls are immediately visible.
pcall(function() switchTab("Mechanics") end)

task.spawn(function()
    -- Load the complete config first. Applying the last preset before this
    -- used to overwrite saved values during startup.
    task.wait(0.2)
    local loaded = loadConfig()

    -- Only apply a remembered preset when no valid main config exists.
    if not loaded and not State._configLoadFailed and State._allowInitialConfigCreation then
        local lastPresetName = loadLastPresetName()
        if lastPresetName and lastPresetName ~= "" then
            for _, preset in ipairs(Presets) do
                if preset.name == lastPresetName then
                    pcall(function() applyPreset(preset.data) end)
                    break
                end
            end
        end
    end

    task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation  and not State._configLoadFailed and not State._hadConfigFileOnDisk then
        pcall(saveConfig)
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then
            pcall(State.savePositionBackup)
        end
    end
end)

pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then
                pcall(State.savePositionBackup)
            end
        end
    end)
end)

print("[RANA.VS] Loaded - RANA.VS Auto Steal + Outfit; Speed Auto Carry")

end)()

end)()
-- [RANA TEST BASELINE] Original Rana Duels source preserved; no merged Rana systems.
]]
  local __fm_load = (type(loadstring) == 'function' and loadstring) or (type(load) == 'function' and load)
  if not __fm_load then warn('[fm] Safe Mode: no loadstring/load') return end
  local __fm_fn, __fm_err = __fm_load(__fm_src, '=fm-safe')
  if not __fm_fn then warn('[fm] Safe Mode load error: ' .. tostring(__fm_err)) return end
  local __fm_ok, __fm_e = pcall(__fm_fn)
  if not __fm_ok then warn('[fm] Safe Mode runtime: ' .. tostring(__fm_e)) end
end