-- ============================================================
-- INTRO VISUAL COMPLETA (Syn1ze v2) - COLORES MORADOS
-- ============================================================
local function playIntro(callback)
    -- Variables de la intro
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local TextService = game:GetService("TextService")
    local RunService = game:GetService("RunService")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Syn1zeHubIntro"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local introSkipped = false
    local skipConnection = nil
    local introSound = nil

    local SOUND_ID = 120267378058133
    local SKIP_SECONDS = 10
    local introSoundEnabled = true  -- Cambia a false si no quieres sonido

    -- ===== EFECTOS =====
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.3
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = screenGui

    local darkOverlay = Instance.new("Frame")
    darkOverlay.Size = UDim2.fromScale(1, 1)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    darkOverlay.BackgroundTransparency = 0.5
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 1
    darkOverlay.Parent = screenGui

    local vignette = Instance.new("ImageLabel")
    vignette.Size = UDim2.fromScale(1, 1)
    vignette.BackgroundTransparency = 1
    vignette.Image = "rbxassetid://195611797"
    vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
    vignette.ImageTransparency = 0.35
    vignette.ZIndex = 2
    vignette.Parent = screenGui

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 850, 0, 130)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.ZIndex = 5
    container.Parent = screenGui

    -- Texto principal (morado)
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, 0, 1, 0)
    mainLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    mainLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "SYN1ZE HUB"
    mainLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    mainLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    mainLabel.TextStrokeTransparency = 0
    mainLabel.Font = Enum.Font.GothamBlack
    mainLabel.TextSize = 88
    mainLabel.TextXAlignment = Enum.TextXAlignment.Center
    mainLabel.TextTransparency = 1
    mainLabel.ZIndex = 5
    mainLabel.Parent = container

    -- Texto izquierdo (morado)
    local leftLabel = Instance.new("TextLabel")
    leftLabel.Size = UDim2.new(0, 400, 1, 0)
    leftLabel.AnchorPoint = Vector2.new(1, 0.5)
    leftLabel.Position = UDim2.new(0.5, -10, 0.5, 0)
    leftLabel.BackgroundTransparency = 1
    leftLabel.Text = "SYN1ZE"
    leftLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    leftLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    leftLabel.TextStrokeTransparency = 0
    leftLabel.Font = Enum.Font.GothamBlack
    leftLabel.TextSize = 88
    leftLabel.TextXAlignment = Enum.TextXAlignment.Right
    leftLabel.TextTransparency = 1
    leftLabel.ZIndex = 5
    leftLabel.Visible = true
    leftLabel.Parent = container

    -- Texto derecho (morado)
    local rightLabel = Instance.new("TextLabel")
    rightLabel.Size = UDim2.new(0, 200, 1, 0)
    rightLabel.AnchorPoint = Vector2.new(0, 0.5)
    rightLabel.Position = UDim2.new(0.5, -10, 0.5, 0)
    rightLabel.BackgroundTransparency = 1
    rightLabel.Text = "HUB"
    rightLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    rightLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    rightLabel.TextStrokeTransparency = 0
    rightLabel.Font = Enum.Font.GothamBlack
    rightLabel.TextSize = 88
    rightLabel.TextXAlignment = Enum.TextXAlignment.Left
    rightLabel.TextTransparency = 1
    rightLabel.ZIndex = 5
    rightLabel.Visible = true
    rightLabel.Parent = container

    -- Fascio de luz (morado)
    local lightBeam = Instance.new("Frame")
    lightBeam.Size = UDim2.new(0, 0, 1.1, 0)
    lightBeam.AnchorPoint = Vector2.new(0, 0.5)
    lightBeam.Position = UDim2.new(0, -20, 0.5, 0)
    lightBeam.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    lightBeam.BackgroundTransparency = 0.5
    lightBeam.BorderSizePixel = 0
    lightBeam.ZIndex = 6
    lightBeam.Parent = container

    local beamGlow = Instance.new("Frame")
    beamGlow.Size = UDim2.new(0, 0, 1.3, 0)
    beamGlow.AnchorPoint = Vector2.new(0, 0.5)
    beamGlow.Position = UDim2.new(0, -20, 0.5, 0)
    beamGlow.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    beamGlow.BackgroundTransparency = 0.7
    beamGlow.BorderSizePixel = 0
    beamGlow.ZIndex = 5
    beamGlow.Parent = container

    local beamSparkles = Instance.new("Frame")
    beamSparkles.Size = UDim2.new(0, 0, 1, 0)
    beamSparkles.AnchorPoint = Vector2.new(0, 0.5)
    beamSparkles.Position = UDim2.new(0, -20, 0.5, 0)
    beamSparkles.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    beamSparkles.BackgroundTransparency = 0.8
    beamSparkles.BorderSizePixel = 0
    beamSparkles.ZIndex = 7
    beamSparkles.Parent = container

    -- Subtítulos (morado)
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, 0, 0, 40)
    subLabel.AnchorPoint = Vector2.new(0.5, 0)
    subLabel.Position = UDim2.new(0.5, 0, 0.5, 70)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "THE ONE THAT MOGS ALL. . ."
    subLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    subLabel.Font = Enum.Font.GothamBold
    subLabel.TextSize = 14
    subLabel.TextXAlignment = Enum.TextXAlignment.Center
    subLabel.TextTransparency = 1
    subLabel.ZIndex = 5
    subLabel.Parent = screenGui

    local subLabel2 = Instance.new("TextLabel")
    subLabel2.Size = UDim2.new(1, 0, 0, 25)
    subLabel2.AnchorPoint = Vector2.new(0.5, 0)
    subLabel2.Position = UDim2.new(0.5, 0, 0.5, 105)
    subLabel2.BackgroundTransparency = 1
    subLabel2.Text = "TAP THE SCREEN TO SKIP INTRO"
    subLabel2.TextColor3 = Color3.fromRGB(100, 100, 100)
    subLabel2.Font = Enum.Font.Gotham
    subLabel2.TextSize = 11
    subLabel2.TextXAlignment = Enum.TextXAlignment.Center
    subLabel2.TextTransparency = 1
    subLabel2.ZIndex = 5
    subLabel2.Parent = screenGui

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 0, 0, 2)
    accentBar.AnchorPoint = Vector2.new(0.5, 0)
    accentBar.Position = UDim2.new(0.5, 0, 0.5, 62)
    accentBar.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    accentBar.BackgroundTransparency = 0
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 5
    accentBar.Parent = screenGui

    local flashFrame = Instance.new("Frame")
    flashFrame.Size = UDim2.fromScale(1, 1)
    flashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flashFrame.BackgroundTransparency = 1
    flashFrame.BorderSizePixel = 0
    flashFrame.ZIndex = 10
    flashFrame.Parent = screenGui

    local glitchContainer = Instance.new("Frame")
    glitchContainer.Size = UDim2.new(1, 0, 1, 0)
    glitchContainer.BackgroundTransparency = 1
    glitchContainer.ZIndex = 6
    glitchContainer.Parent = screenGui

    local dripContainer = Instance.new("Frame")
    dripContainer.Size = UDim2.new(1, 0, 1, 0)
    dripContainer.BackgroundTransparency = 1
    dripContainer.ZIndex = 7
    dripContainer.Parent = screenGui

    local tapToRemoveLabel = Instance.new("TextLabel")
    tapToRemoveLabel.Size = UDim2.new(0, 150, 0, 24)
    tapToRemoveLabel.AnchorPoint = Vector2.new(0.5, 1)
    tapToRemoveLabel.Position = UDim2.new(0.5, 0, 1, -20)
    tapToRemoveLabel.BackgroundTransparency = 1
    tapToRemoveLabel.Text = "✦ TAP TO REMOVE ✦"
    tapToRemoveLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    tapToRemoveLabel.Font = Enum.Font.GothamBold
    tapToRemoveLabel.TextSize = 10
    tapToRemoveLabel.TextXAlignment = Enum.TextXAlignment.Center
    tapToRemoveLabel.TextTransparency = 0.5
    tapToRemoveLabel.ZIndex = 15
    tapToRemoveLabel.Parent = screenGui

    -- ===== FUNCIONES DE LA INTRO =====
    local function doFlash(color, alpha, duration)
        flashFrame.BackgroundColor3 = color or Color3.new(1,1,1)
        flashFrame.BackgroundTransparency = 1 - (alpha or 0.85)
        task.delay(duration or 0.06, function()
            if not introSkipped then
                TweenService:Create(flashFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
            else
                flashFrame.BackgroundTransparency = 1
            end
        end)
    end

    local function runLightBeam()
        lightBeam.Size = UDim2.new(0, 45, 1.1, 0)
        beamGlow.Size = UDim2.new(0, 65, 1.3, 0)
        beamSparkles.Size = UDim2.new(0, 45, 1, 0)

        lightBeam.BackgroundTransparency = 0.35
        beamGlow.BackgroundTransparency = 0.55
        beamSparkles.BackgroundTransparency = 0.75

        local beamTween = TweenService:Create(lightBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, 20, 0.5, 0)
        })
        beamTween:Play()

        local glowTween = TweenService:Create(beamGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, 20, 0.5, 0)
        })
        glowTween:Play()

        local sparkleTween = TweenService:Create(beamSparkles, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, 20, 0.5, 0)
        })
        sparkleTween:Play()

        local pulseCount = 0
        local pulseConnection
        pulseConnection = RunService.Heartbeat:Connect(function()
            if introSkipped then
                if pulseConnection then pulseConnection:Disconnect() end
                return
            end
            pulseCount = pulseCount + 1
            if pulseCount % 3 == 0 then
                local pulseIntensity = 0.3 + math.sin(pulseCount * 0.5) * 0.15
                lightBeam.BackgroundTransparency = 0.3 - (pulseIntensity * 0.2)
                beamGlow.BackgroundTransparency = 0.5 - (pulseIntensity * 0.1)
                beamSparkles.BackgroundTransparency = 0.7 - (pulseIntensity * 0.15)
            end
        end)

        beamTween.Completed:Wait()

        if pulseConnection then pulseConnection:Disconnect() end

        TweenService:Create(lightBeam, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1.1, 0)
        }):Play()
        TweenService:Create(beamGlow, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1.3, 0)
        }):Play()
        TweenService:Create(beamSparkles, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()
    end

    local function changeToPurple()
        task.wait(0.2)
        TweenService:Create(mainLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            TextColor3 = Color3.fromRGB(180, 80, 255)
        }):Play()
    end

    local glitchChars = {"!", "#", "%", "/", "[", "]", "░", "▒", "▓", "—", "=", "*", "^", "~", "¦", "¤"}

    local function glitchText(lbl, original)
        if introSkipped then return end
        for i = 1, 4 do
            if introSkipped then break end
            local s = ""
            for c in original:gmatch(".") do
                s = s .. (math.random() < 0.35 and glitchChars[math.random(#glitchChars)] or c)
            end
            lbl.Text = s
            task.wait(0.03)
        end
        if not introSkipped then
            lbl.Text = original
        end
    end

    local function addGlitchBar()
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, math.random(2, 12))
        bar.Position = UDim2.new(0, 0, math.random(10, 90)/100, 0)
        bar.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        bar.BackgroundTransparency = math.random(45, 70) / 100
        bar.BorderSizePixel = 0
        bar.ZIndex = 6
        bar.Parent = glitchContainer
        task.delay(0.1, function()
            if bar then
                TweenService:Create(bar, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                task.delay(0.1, function() bar:Destroy() end)
            end
        end)
    end

    local function shakeScreen(intensity, duration)
        if introSkipped then return end
        local baseLeft = UDim2.new(0.5, -8, 0.5, 0)
        local baseRight = UDim2.new(0.5, 8, 0.5, 0)
        local startTime = tick()

        while tick() - startTime < duration and not introSkipped do
            local currentIntensity = intensity * (1 - ((tick() - startTime) / duration))
            local ox = math.random(-math.floor(currentIntensity), math.floor(currentIntensity))
            local oy = math.random(-math.floor(currentIntensity * 0.5), math.floor(currentIntensity * 0.5))
            leftLabel.Position = UDim2.new(0.5, -8 + ox, 0.5, oy)
            rightLabel.Position = UDim2.new(0.5, 8 + ox, 0.5, oy)
            task.wait(0.02)
        end

        if not introSkipped then
            TweenService:Create(leftLabel, TweenInfo.new(0.05), {Position = baseLeft}):Play()
            TweenService:Create(rightLabel, TweenInfo.new(0.05), {Position = baseRight}):Play()
        end
    end

    local function setupAudio()
        if not introSoundEnabled then return nil end
        introSound = Instance.new("Sound")
        introSound.SoundId = "rbxassetid://" .. SOUND_ID
        introSound.Volume = 0.7
        introSound.PlayOnRemove = false
        introSound.Parent = screenGui
        introSound.Loaded:Wait()
        introSound:Play()
        introSound.TimePosition = SKIP_SECONDS
        return introSound
    end

    local function fadeOutAudio(duration)
        if not introSound then return end
        local startVolume = introSound.Volume
        local steps = 30
        for i = 1, steps do
            if introSkipped or not introSound then break end
            introSound.Volume = startVolume * (1 - (i / steps))
            task.wait(duration / steps)
        end
        if introSound then
            introSound.Volume = 0
            introSound:Stop()
        end
    end

    local function stopAudio()
        if introSound then
            introSound:Stop()
            introSound:Destroy()
        end
    end

    local activeDrips = 0
    local function createDrip(startX, startY, width, height, duration, delay)
        task.wait(delay)
        if introSkipped then return end
        activeDrips = activeDrips + 1

        local drip = Instance.new("Frame")
        drip.Size = UDim2.new(0, width, 0, height)
        drip.Position = UDim2.new(0.5, startX, 0.5, startY)
        drip.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        drip.BackgroundTransparency = 0.25
        drip.BorderSizePixel = 0
        drip.ZIndex = 7
        drip.Parent = dripContainer

        local stretch = TweenService:Create(drip, TweenInfo.new(duration * 0.35), {
            Size = UDim2.new(0, width, 0, height + 22),
            BackgroundTransparency = 0.1
        })
        stretch:Play()

        task.wait(duration * 0.35)

        if introSkipped then
            drip:Destroy()
            activeDrips = activeDrips - 1
            return
        end

        local fall = TweenService:Create(drip, TweenInfo.new(duration * 0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, startX + math.random(-3, 3), 0.5, startY + 80),
            BackgroundTransparency = 1
        })
        fall:Play()

        fall.Completed:Connect(function()
            drip:Destroy()
            activeDrips = activeDrips - 1
        end)
    end

    local function startDripping()
        if introSkipped then return end
        local fullText = "SYN1ZE HUB"
        local font = Enum.Font.GothamBlack
        local textSize = 88

        local textBoundsFull = TextService:GetTextSize(fullText, textSize, font, Vector2.new(math.huge, math.huge))
        local textHeight = textBoundsFull.Y

        local drips = {}
        local delayCounter = 0

        for i = 1, #fullText do
            local char = fullText:sub(i, i)
            local charBounds = TextService:GetTextSize(char, textSize, font, Vector2.new(math.huge, math.huge))
            local charWidth = charBounds.X

            local precedingText = fullText:sub(1, i-1)
            local precedingWidth = 0
            if i > 1 then
                precedingWidth = TextService:GetTextSize(precedingText, textSize, font, Vector2.new(math.huge, math.huge)).X
            end

            local totalTextWidth = textBoundsFull.X
            local leftEdgeOffset = -totalTextWidth / 2
            local charLeft = leftEdgeOffset + precedingWidth
            local charCenterX = charLeft + charWidth / 2

            local startY = textHeight / 2 + 3

            local rx = math.random(-2, 2)
            local ry = math.random(0, 4)

            local dripWidth = math.clamp(math.floor(charWidth * 0.35), 3, 7)
            local dripHeight = math.random(4, 7)
            local duration = 0.5 + math.random() * 0.2
            local delay = delayCounter * 0.07

            table.insert(drips, {
                startX = charCenterX + rx,
                startY = startY + ry,
                width = dripWidth,
                height = dripHeight,
                duration = duration,
                delay = delay
            })
            delayCounter = delayCounter + 1
        end

        for _, d in ipairs(drips) do
            if introSkipped then break end
            createDrip(d.startX, d.startY, d.width, d.height, d.duration, d.delay)
        end
    end

    local function skipIntro()
        if introSkipped then return end
        introSkipped = true

        stopAudio()
        if skipConnection then skipConnection:Disconnect() end

        doFlash(Color3.fromRGB(255, 255, 255), 0.8, 0.1)

        mainLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
        mainLabel.Text = "SYN1ZE HUB"

        local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(mainLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(leftLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(rightLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(subLabel2, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(accentBar, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(darkOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()

        task.wait(0.3)
        screenGui:Destroy()
        blur:Destroy()
        callback()
    end

    local function playIntroSequence()
        setupAudio()

        skipConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                skipIntro()
            end
        end)

        -- Animación del botón tap
        task.spawn(function()
            while not introSkipped and tapToRemoveLabel.Parent do
                for t = 0.4, 0.8, 0.05 do
                    if introSkipped then break end
                    tapToRemoveLabel.TextTransparency = t
                    task.wait(0.05)
                end
                for t = 0.8, 0.4, -0.05 do
                    if introSkipped then break end
                    tapToRemoveLabel.TextTransparency = t
                    task.wait(0.05)
                end
            end
        end)

        -- Posiciones iniciales
        leftLabel.Position = UDim2.new(-0.9, 0, -0.6, 0)
        rightLabel.Position = UDim2.new(1.9, 0, 1.6, 0)
        leftLabel.Rotation = -30
        rightLabel.Rotation = 30
        mainLabel.TextTransparency = 1

        TweenService:Create(blur, TweenInfo.new(0.7), {Size = 18}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.7), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(darkOverlay, TweenInfo.new(0.7), {BackgroundTransparency = 0.4}):Play()
        task.wait(0.35)

        if introSkipped then return end

        TweenService:Create(leftLabel, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
        TweenService:Create(rightLabel, TweenInfo.new(0.45), {TextTransparency = 0}):Play()

        TweenService:Create(leftLabel, TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -220, 0.5, -80), Rotation = -15
        }):Play()
        TweenService:Create(rightLabel, TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 120, 0.5, 80), Rotation = 15
        }):Play()
        task.wait(0.45)

        if introSkipped then return end

        local smooth = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -170, 0.5, -50), Rotation = -8}):Play()
        TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, 80, 0.5, 50), Rotation = 8}):Play()
        task.wait(0.35)

        if introSkipped then return end

        TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -120, 0.5, -25), Rotation = -4}):Play()
        TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, 40, 0.5, 25), Rotation = 4}):Play()
        task.wait(0.3)

        if introSkipped then return end

        TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -60, 0.5, -10), Rotation = -2}):Play()
        TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, -10, 0.5, 10), Rotation = 2}):Play()
        task.wait(0.25)

        if introSkipped then return end

        -- Glitch
        local glitchEnd = tick() + 0.9
        while tick() < glitchEnd and not introSkipped do
            local ox = math.random(-20, 20)
            local oy = math.random(-10, 10)
            leftLabel.Position = UDim2.new(0.5, -60 + ox, 0.5, -10 + oy)
            rightLabel.Position = UDim2.new(0.5, -10 + ox, 0.5, 10 + oy)

            if math.random() < 0.35 then task.spawn(glitchText, leftLabel, "SYN1ZE") end
            if math.random() < 0.35 then task.spawn(glitchText, rightLabel, "HUB") end
            if math.random() < 0.4 then addGlitchBar() end
            if math.random() < 0.1 then doFlash(Color3.fromRGB(180, 80, 255), 0.2, 0.03) end

            task.wait(0.045)
        end

        if introSkipped then return end

        leftLabel.Visible = false
        rightLabel.Visible = false
        mainLabel.TextTransparency = 0
        mainLabel.TextColor3 = Color3.fromRGB(180, 80, 255)

        doFlash(Color3.fromRGB(180, 80, 255), 0.5, 0.05)
        task.wait(0.08)
        if introSkipped then return end

        TweenService:Create(mainLabel, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            TextSize = 92
        }):Play()
        task.wait(0.12)

        if introSkipped then return end

        TweenService:Create(mainLabel, TweenInfo.new(0.1), {TextSize = 88}):Play()

        doFlash(Color3.fromRGB(255, 255, 255), 0.95, 0.05)
        task.wait(0.02)
        doFlash(Color3.fromRGB(180, 80, 255), 0.65, 0.08)

        task.spawn(shakeScreen, 10, 0.25)

        runLightBeam()
        changeToPurple()

        TweenService:Create(accentBar, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 420, 0, 2)
        }):Play()

        task.wait(0.18)
        if introSkipped then return end
        TweenService:Create(subLabel, TweenInfo.new(0.4), {TextTransparency = 0.05}):Play()
        TweenService:Create(subLabel2, TweenInfo.new(0.4), {TextTransparency = 0.15}):Play()
        task.wait(0.1)
        doFlash(Color3.fromRGB(255, 255, 255), 0.3, 0.04)

        TweenService:Create(subLabel, TweenInfo.new(0.2), {TextSize = 15}):Play()
        task.wait(0.2)
        TweenService:Create(subLabel, TweenInfo.new(0.2), {TextSize = 14}):Play()

        task.wait(0.65)
        if introSkipped then return end

        startDripping()

        while activeDrips > 0 and not introSkipped do
            task.wait(0.1)
        end

        if introSkipped then return end
        task.wait(0.45)

        fadeOutAudio(1.2)

        local fadeInfo = TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(mainLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(subLabel2, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(accentBar, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(darkOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(blur, TweenInfo.new(0.85), {Size = 0}):Play()
        TweenService:Create(dripContainer, fadeInfo, {BackgroundTransparency = 1}):Play()

        task.wait(0.9)

        stopAudio()
        if skipConnection then skipConnection:Disconnect() end
        screenGui:Destroy()
        blur:Destroy()
        callback()
    end

    -- Iniciar la secuencia de la intro
    playIntroSequence()
end

-- ============================================================


-- ============================================================
-- EJECUCIÓN COMPATIBLE CON DELTA (V2 - NEW ANTI-RAGDOLL)
-- ============================================================
repeat task.wait() until game:IsLoaded()

playIntro(function()
    -- Iniciando script principal después de la intro
-- @SYN1ZEHUB ON TOP
-- SYNNER HUB ON TOP https://discord.gg/pGyyUsEY


-- SYNNER HUB: https://discord.gg/NtAz9rSTF



repeat task.wait() until game:IsLoaded()
local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
local speedMode, antiRagdollEnabled = false, false
local jumpMode = 1
local jumpEnabled = false
local tpDownMode = 1
local laggerToggled = false
local laggerLevel = 1
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce, medusaLastUsed, dropActive = false, 0, false
local autoLeftEnabled, autoRightEnabled = false, false
local autoLeftSetVisual, autoRightSetVisual = nil, nil
local speedLabel = nil
local enemySpeedLabels = {}
local autoBatEnabled = false
local autoBatSetVisual = nil
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_V_OFF = 58, 52, -2.8, 1
local ALTURA_RELATIVA = 3.5
local AUTO_BAT_TURN_SPEED = 480
local AUTO_BAT_MAX_TURN_RATE = 60
local setBatCounterVisual = nil
local startBatCounter, stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local autoLeftWasEnabled = false
local autoRightWasEnabled = false
local dropBrainrotWasActive = false
local dropBrainrotSetVisual = nil

-- ====== DIMENSIONES DEL PANEL MÃ“VIL ======
local MOBILE_PANEL_WIDTH = 128
local MOBILE_PANEL_HEIGHT = 294

-- ====== STRETCH ======
local stretchEnabled = false
local stretchFOV = 120
local stretchConn = nil
local stretchFovConn = nil
local origFOV = 70

local medusaAutoResetEnabled = false
local medusaResetConns = {}
local setMedusaAutoResetVisual = nil

-- ====== IMAGEN DEL MENÃš ======
-- ACTUALIZADO: Nueva imagen para el menÃº
local MENU_IMAGE_ID = "73132663678422"

-- ====== LIMPIEZA TOTAL ======
local function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    stopAntiRagdoll()
    stopJumpMode()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAutoSteal()
    stopAutoTPDown()
    disableAutoBat()
    stopBypassAimbot()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    isStealing = false
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    _hittingCooldown = false
    bypassHittingCooldown = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

local function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        if medusaAutoResetEnabled then
            medusaAutoResetEnabled = false
            if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
            stopMedusaAutoReset()
        end
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
    else
        stopMedusaCounter()
    end
    if setMedusaVisual then setMedusaVisual(state) end
end

local function setMedusaAutoResetState(state)
    medusaAutoResetEnabled = state
    if state then
        if medusaCounterEnabled then
            medusaCounterEnabled = false
            if setMedusaVisual then setMedusaVisual(false) end
            stopMedusaCounter()
        end
        if LP.Character then setupMedusaAutoReset(LP.Character) else stopMedusaAutoReset() end
    else
        stopMedusaAutoReset()
    end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(state) end
end

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local instaResetKeybind = {kb = Enum.KeyCode.G, gp = nil}
local setInstaResetVisual = nil
local instaResetFloatingButton = nil
local instaResetFloatingPos = nil
local insta_reset_cooldown = false

local function insta_reset()
    if insta_reset_cooldown then return end
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
                cursedResetRemote = desc
                break
            end
        end
    end
    if not cursedResetRemote then return end
    insta_reset_cooldown = true
    local old_char = LP.Character
    if not old_char then
        insta_reset_cooldown = false
        return
    end
    task.spawn(function()
        while LP.Character == old_char do
            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
            end)
            task.wait()
        end
        insta_reset_cooldown = false
    end)
end

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end

task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

-- ============================================================
-- ðŸ”¥ Cooldown reducido a 0.1 segundos (mÃ¡xima velocidad)
-- ============================================================
local BAT_AIMBOT_SPEED = 58
local BYPASS_AIMBOT_SPEED = 60
local bypassToggled = false
local bypassFloatingButton = nil
local bypassFloatingPos = nil
local bypassMode = 1
local bypassModeBtnRef = nil
local dropMode = 1
local dropModeBtnRef = nil
local lastDropTime = 0
local BAT_V2_SWING_COOLDOWN = 0.1

local AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47),
}

-- ====== AUTO STEAL MEJORADO ======
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 61.5,
    StealDuration = 1.37,
    Data = {},
    cachedPrompts = {},
    promptCacheTime = 0,
}
local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local STEAL_COOLDOWN = 0.1
local PROMPT_CACHE_REFRESH = 0.15

local Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil,
    autoLeft = nil, autoRight = nil}
local progressFill = nil
local progressPct = nil
local progressRadLbl = nil
local pbFrame = nil

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

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
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local np, nd = nil, math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.prompt and data.prompt.Parent and data.prompt.Enabled ~= false then
                local dist = (data.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nd then
                    np = data.prompt
                    nd = dist
                end
            end
        end
        if np then return np, nd end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, math.huge end

    local np, nd = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local att = spawn:FindFirstChild("PromptAttachment")
                    if att then
                        for _, child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                local dist = (spawn.Position - root.Position).Magnitude
                                table.insert(Steal.cachedPrompts, {prompt = child, spawn = spawn})
                                if dist <= Steal.StealRadius and dist < nd then
                                    np = child
                                    nd = dist
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return np, nd
end

local function executeSteal(prompt)
    local ct = tick()
    if ct - lastStealTick < STEAL_COOLDOWN then return end
    if isStealing then return end
    if not prompt or not prompt.Parent or prompt.Enabled == false then return end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true, useFallback = false}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            else
                Steal.Data[prompt].useFallback = true
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = ct
    lastStealTick = ct

    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress = RunService.Heartbeat:Connect(function()
        if not isStealing then
            Conns.progress:Disconnect()
            Conns.progress = nil
            return
        end
        local prog = math.clamp((tick() - stealStartTime) / Steal.StealDuration, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
    end)

    task.spawn(function()
        local ok = false
        pcall(function()
            if not data.useFallback and #data.hold > 0 then
                for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
                task.wait(Steal.StealDuration)
                for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
                ok = true
            end
        end)
        if not ok and type(fireproximityprompt) == "function" then
            pcall(function() fireproximityprompt(prompt) end)
            ok = true
            task.wait(Steal.StealDuration)
        end
        if not ok then
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(Steal.StealDuration)
                prompt:InputHoldEnd()
            end)
            ok = true
        end

        task.wait(Steal.StealDuration * 0.3)
        if Conns.progress then
            Conns.progress:Disconnect()
            Conns.progress = nil
        end
        resetProgressBar()
        task.wait(0.05)
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p = findNearestPrompt()
        if p then
            executeSteal(p)
        else
            if progressPct and not isStealing then
                progressPct.Text = "0%"
            end
        end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    if Conns.progress then
        Conns.progress:Disconnect()
        Conns.progress = nil
    end
    isStealing = false
    lastStealTick = 0
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    resetProgressBar()
end

-- ====== STRETCH ======
local function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = val end)
    end
end

local function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then
            c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1)
        end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            applyStretchFOV(stretchFOV)
        else
            stretchFovConn:Disconnect()
            stretchFovConn = nil
        end
    end)
end

local function disableStretch()
    stretchEnabled = false
    if stretchConn then
        stretchConn:Disconnect()
        stretchConn = nil
    end
    if stretchFovConn then
        stretchFovConn:Disconnect()
        stretchFovConn = nil
    end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

-- ====== ENEMY SPEED ======
local enemySpeedConn = nil
local function updateEnemySpeedLabels()
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
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
                        textLabel.Font = Enum.Font.GothamBold
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        label.Parent.Parent = head
                    end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then
                    label.Parent.Parent = nil
                end
                enemySpeedLabels[player] = nil
            end
        end
    end
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then
                label.Parent.Parent = nil
            end
            enemySpeedLabels[player] = nil
        end
    end
end

local function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
    end)
end

local uiLocked = false
local MobilePanel = nil

local MobileButtons = {
    Visible = true,
    Frame = nil,
    Buttons = {}
}
local mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight
local mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2
local antiLagDescConn = nil
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPHeight = 20

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
    AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
    AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
    TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
    GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
    CarryToggle={kb=Enum.KeyCode.Q,gp=nil},
    LaggerMode  ={kb=Enum.KeyCode.R,gp=nil},
    AutoTPDown  ={kb=Enum.KeyCode.T,gp=nil},
    InstaReset  ={kb=Enum.KeyCode.G,gp=nil},
    JumpMode    ={kb=Enum.KeyCode.V,gp=nil},
    Bypass      ={kb=Enum.KeyCode.N,gp=nil},
}

local GAMEPAD_KEYS={
    [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
    [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
    [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
    [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true
}

local function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

local function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

local function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local lastMoveDir = Vector3.new(0,0,0)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local steppedConn = nil
local movementLoop = nil

-- ============================================================
-- ðŸ”§ MEJORA: DesactivaciÃ³n de colisiones con enemigos (versiÃ³n Green Duels)
-- ============================================================
steppedConn = RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

movementLoop = RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd
        if laggerToggled then
            spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
        else
            spd = speedMode and CS or NS
        end
        if md.Magnitude > 0 then
            lastMoveDir = md
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then
                hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
            end
        end
    end
    if speedLabel then
        speedLabel.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
    end
end)

local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
end

local function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if bypassToggled then
        toggleBypass(false)
    end
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
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
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
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
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop() end)
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

local function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("LustHubSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "Syn1zeHUBSpeedIndicator"
    bb.Size = UDim2.new(0, 180, 0, 56)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    local titleLabel = Instance.new("TextLabel", bb)
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Syn1ze HUB"
    titleLabel.TextColor3 = Color3.fromRGB(192,192,192)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextScaled = false
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0, 26)
    speedLabel.Position = UDim2.new(0, 0, 0, 24)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = Color3.fromRGB(192,192,192)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

-- anti ragdoll, evita que te quedes tirado en el suelo
local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdoll()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdoll()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
end
local function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
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
    medusaLastUsed = tick()
    medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
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

local function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local function onMedusaResetAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            insta_reset()
        end
    end)
end

local function setupMedusaAutoReset(char)
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
    if not char or not medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end
    table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end))
end

local function stopMedusaAutoReset()
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
end

local dropConnections = {}

local function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local speedH = 0
    if root then
        local vel = root.AssemblyLinearVelocity
        speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
    end
    local cooldown = 0.25
    if dropMode == 1 then
        if speedH > 5 then
            cooldown = 0.6
        else
            cooldown = 0.25
        end
    end
    if tick() - lastDropTime < cooldown then return end
    lastDropTime = tick()
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local wasAutoBat = false
    if autoBatEnabled then
        wasAutoBat = true
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    local function finishDrop()
        dropActive = false
        local c = LP.Character
        if c then
            local root = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                end
                if hum and hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(0, -1, 0)
                task.wait(0.03)
                root.AssemblyLinearVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
            end
        end
        if wasAutoBat then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        end
        if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
        if mobSetDropBR then mobSetDropBR(false) end
    end
    if dropMode == 1 then
        local flingThread = task.spawn(function()
            local startTime = tick()
            while dropActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end
                local vel = root.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                root.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then
                    root.AssemblyLinearVelocity = vel
                end
                RunService.Stepped:Wait()
                if root and root.Parent then
                    root.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
            finishDrop()
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then
                dropActive = false
                finishDrop()
            end
        end)
    else
        local conn = nil
        local startTime = tick()
        conn = RunService.Heartbeat:Connect(function()
            if not dropActive then
                conn:Disconnect()
                return
            end
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then
                conn:Disconnect()
                finishDrop()
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= 0.2 then
                conn:Disconnect()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                finishDrop()
                return
            end
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 150, root.AssemblyLinearVelocity.Z)
        end)
        table.insert(dropConnections, conn)
    end
end

local function stopDropBrainrot()
    dropActive = false
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then
            pcall(t.Disconnect, t)
        end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

local function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

-- ====== INFINITE JUMP (56 para modo Tap Tap, 54 para Hold) ======
local infJumpConn = nil
local holdJumpConn = nil
local holdJumpJumpConn = nil

local function startJumpMode()
    if not jumpEnabled then return end
    if jumpMode == 1 then
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 56, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
    else
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect() end
        holdJumpJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect() end
        holdJumpConn = RunService.Heartbeat:Connect(function()
            if autoBatEnabled or bypassToggled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
            if jumpHeld and root.Velocity.Y < 30 then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
            if root.Velocity.Y < -120 then
                root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
            end
        end)
        if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    end
end

local function stopJumpMode()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
    if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
end

RunService.Heartbeat:Connect(function()
    if not jumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

local defLightBrightness,defLightClock,defLightAmbient,defGlobalShadows,defFogEnd

-- ====== ANTI-LAG ======
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    if defLightBrightness == nil then
        defLightBrightness = Lighting.Brightness
    end
    if defLightClock == nil then
        defLightClock = Lighting.ClockTime
    end
    if defLightAmbient == nil then
        defLightAmbient = Lighting.OutdoorAmbient
    end
    if defGlobalShadows == nil then
        defGlobalShadows = Lighting.GlobalShadows
    end
    if defFogEnd == nil then
        defFogEnd = Lighting.FogEnd
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then
            applyAntiLagDerender(obj)
        end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end
    if defLightBrightness ~= nil then
        Lighting.Brightness = defLightBrightness
    end
    if defLightClock ~= nil then
        Lighting.ClockTime = defLightClock
    end
    if defLightAmbient ~= nil then
        Lighting.OutdoorAmbient = defLightAmbient
    end
    if defGlobalShadows ~= nil then
        Lighting.GlobalShadows = defGlobalShadows
    end
    if defFogEnd ~= nil then
        Lighting.FogEnd = defFogEnd
    end
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = true
            end
        end)
    end
end

local batCounterDebounce = false
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

local function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then
                    swingBatForCounter(bat, character)
                end
                task.wait(0.5)
                batCounterDebounce = false
            end)
        end
    end)
end

stopBatCounter = function()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

local function findBat()
    local char = LP.Character
    if not char then return nil end
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

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

local _aimbotConn = nil
local _prevAutoRotate = nil
local _hittingCooldown = false

local function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
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

local function trySwing()
    if _hittingCooldown then return end
    _hittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            _hittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.1, function() _hittingCooldown = false end)
    task.delay(0.2, function()
        if _hittingCooldown then _hittingCooldown = false end
    end)
end

startAimbotAdapt = function()
    if _aimbotConn then return end
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
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 42, ry * 42, rz * 42)
            )
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            trySwing()
        end
    end)
end

-- ============================================================
-- ðŸ”§ MEJORA: DesactivaciÃ³n estable de Auto Bat
-- ============================================================
stopAimbotAdapt = function()
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
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    _hittingCooldown = false
    lastMoveDir = Vector3.zero
end

enableAutoBat = function()
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
                btnFrame.BackgroundColor3 = Color3.fromRGB(30,0,0)
                local lbl = btnFrame:FindFirstChild("TextLabel")
                if lbl then lbl.TextColor3 = Color3.fromRGB(255,50,50) end
            end
        end
        stopBypassAimbot()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

disableAutoBat = function()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

queueAutoBatStart = function()
    if autoLeftEnabled then
        autoLeftEnabled=false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled=false
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
        stopAutoRight()
    end
    if not autoBatEnabled then
        autoBatEnabled = true
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        startAimbotAdapt()
    end
end

-- ====== BYPASS AIMBOT ======
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5

local bypassHittingCooldown = false
local bypassConn = nil

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = p end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            bypassHittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function() bypassHittingCooldown = false end)
    task.delay(0.2, function()
        if bypassHittingCooldown then bypassHittingCooldown = false end
    end)
end

-- ============================================================
-- ðŸ”§ MEJORA: Aimbot Bypass no se ejecuta en ragdoll
-- ============================================================
local function startBypassAimbot()
    if bypassConn then return end
    bypassConn = RunService.Heartbeat:Connect(function()
        if not bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                if bypassMode == 1 then
                    local targetVel = targetRoot.AssemblyLinearVelocity
                    local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                    local offset = moveDir * BAT_V2_FOLLOW_DIST + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                    local desiredPos = targetRoot.Position + offset
                    local toTarget = desiredPos - root.Position
                    if toTarget.Magnitude > 0.5 then
                        local moveVec = toTarget.Unit * BYPASS_AIMBOT_SPEED
                        root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                    else
                        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                        if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
                    end
                    local distToTarget = (root.Position - targetRoot.Position).Magnitude
                    if distToTarget <= BAT_V2_HIT_DIST then
                        tryHitBatV2()
                    end
                else
                    local tr = targetRoot
                    if tr then
                        pcall(function()
                            sethiddenproperty(root, "PhysicsRepRootPart", tr)
                        end)
                        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                        if (root.Position - targetPos).Magnitude > 8 then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        local cam = workspace.CurrentCamera
                        if cam then
                            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                        end
                        tryHitBatV2()
                    end
                end
            end
        else
            if bypassMode == 1 then
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
                if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
            end
        end
    end)
end

-- ============================================================
-- ðŸ”§ MEJORA: DesactivaciÃ³n estable de Bypass Aimbot
-- ============================================================
local function stopBypassAimbot()
    if bypassConn then
        bypassConn:Disconnect()
        bypassConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end)
    end
    bypassHittingCooldown = false
    lastMoveDir = Vector3.zero
end

-- ============================================================
-- ðŸ”¥ BOTÃ“N BYPASS EN ROJO CUANDO ESTÃ ACTIVADO
-- ============================================================
local function toggleBypass(state)
    if state == nil then
        state = not bypassToggled
    end
    bypassToggled = state
    if bypassToggled then
        if autoBatEnabled then
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        if autoLeftEnabled then
            autoLeftEnabled = false
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
            stopAutoLeft()
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
            stopAutoRight()
        end
        startBypassAimbot()
    else
        stopBypassAimbot()
    end
    if bypassFloatingButton then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if bypassToggled then
                btnFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            else
                btnFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
                if label then label.TextColor3 = Color3.fromRGB(255, 50, 50) end
            end
        end
    end
    if bypassSetVisual then bypassSetVisual(bypassToggled) end
end

local function toggleBypassMode()
    bypassMode = bypassMode == 1 and 2 or 1
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if bypassToggled then
        stopBypassAimbot()
        startBypassAimbot()
    end
end

-- ====== TP DOWN CON HUNDIMIENTO Y RESTAURACIÃ“N DE VIDA (SIN COOLDOWN) ======
local autoTPDownEnabled = false
local autoTPDownConn = nil
local autoTPDownThreshold = 20

local function applyTPDown(sinkAmount, forwardForce)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or
       state == Enum.HumanoidStateType.Ragdoll or
       state == Enum.HumanoidStateType.FallingDown then
        return
    end

    local oldHealth = hum.Health

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
    if not ray then return end

    local groundY = ray.Position.Y
    local offset = (hum.HipHeight or 2) + (hrp.Size.Y / 2) - sinkAmount
    local targetY = groundY + offset

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)

    RunService.Heartbeat:Wait()

    if forwardForce > 0 then
        local forwardDir = hrp.CFrame.LookVector
        hrp.AssemblyLinearVelocity = Vector3.new(forwardDir.X * forwardForce, 0, forwardDir.Z * forwardForce)
    end

    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    task.wait(0.05)
    if hum and hum.Health < oldHealth then
        hum.Health = oldHealth
    end
end

local function executeTPDown()
    if tpDownMode == 1 then
        applyTPDown(0.8, 48)
    else
        applyTPDown(0.8, 0)
    end
end

local function startAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect() end
    autoTPDownConn = RunService.RenderStepped:Connect(function()
        if not autoTPDownEnabled then return end
        if autoLeftEnabled or autoRightEnabled or autoBatEnabled or bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            return
        end
        if hrp.Position.Y >= autoTPDownThreshold then
            if tpDownMode == 1 then
                applyTPDown(0.8, 48)
            else
                applyTPDown(0.8, 0)
            end
        end
    end)
end

local function stopAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect(); autoTPDownConn = nil end
end

local modeValLbl = nil
local function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerToggled then
            modeValLbl.Text = laggerLevel == 1 and "Lagger Mode 1" or "Lagger Mode 2"
        elseif speedMode then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal"
        end
    end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        if laggerLevel == 1 then
            laggerLevel = 2
        else
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
    resetMovementState()
end

local function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end
    resetMovementState()
end

local function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = state
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

local function resetFloatingPositions()
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, 0)
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, MOBILE_PANEL_HEIGHT + 10)
        instaResetFloatingPos = nil
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, MOBILE_PANEL_HEIGHT + 10)
        bypassFloatingPos = nil
    end
    savedMobilePanelPos = nil
    instaResetFloatingPos = nil
    bypassFloatingPos = nil
    pcall(saveAllSettings)
end

-- ====== CONFIGURACIÃ“N ======
local CONFIG_FILE = "Syn1zeHUB.json"
local savedMobilePanelPos = nil
local savedProgressBarPos = nil
local savedInstaResetPos = nil
local savedBypassPos = nil
local lastSavedJSON = nil

local function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        autoTPHeight = autoTPHeight,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = Steal.AutoStealEnabled,
        jumpEnabled = jumpEnabled,
        jumpMode = jumpMode,
        tpDownMode = tpDownMode,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        autoBat = autoBatEnabled,
        autoLeft = autoLeftEnabled,
        autoRight = autoRightEnabled,
        unwalk = unwalkEnabled,
        antiLag = antiLagEnabled,
        autoTPDownEnabled = autoTPDownEnabled,
        autoTPDownThreshold = autoTPDownThreshold,
        lockUI = uiLocked,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        bypassToggled = false,
        bypassSpeed = BYPASS_AIMBOT_SPEED,
        bypassMode = bypassMode,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        autoTPDownKey = {kb = KB.AutoTPDown.kb and KB.AutoTPDown.kb.Name, gp = KB.AutoTPDown.gp and KB.AutoTPDown.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        jumpModeKey = {kb = KB.JumpMode.kb and KB.JumpMode.kb.Name, gp = KB.JumpMode.gp and KB.JumpMode.gp.Name},
        bypassKey = {kb = KB.Bypass.kb and KB.Bypass.kb.Name, gp = KB.Bypass.gp and KB.Bypass.gp.Name},
        instaResetFloatingPos = instaResetFloatingPos,
        bypassFloatingPos = bypassFloatingPos,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

local function saveAllSettings()
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == lastSavedJSON then
        return true
    end
    local success, err = pcall(function()
        writefile(CONFIG_FILE, json)
    end)
    if success then
        lastSavedJSON = json
    end
    return success
end

local function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function()
        return HS:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not success or not data then return false end
    if data.normalSpeed then NS = data.normalSpeed end
    if data.carrySpeed then CS = data.carrySpeed end
    if data.laggerSpeed1 then LAGGER_SPEED_1 = data.laggerSpeed1 end
    if data.laggerSpeed2 then LAGGER_SPEED_2 = data.laggerSpeed2 end
    if data.stealRadius then Steal.StealRadius = data.stealRadius end
    if data.stealDuration then Steal.StealDuration = data.stealDuration end
    if data.autoTPHeight then autoTPHeight = data.autoTPHeight end
    if data.autoTPDownEnabled ~= nil then autoTPDownEnabled = data.autoTPDownEnabled end
    if data.autoTPDownThreshold then autoTPDownThreshold = data.autoTPDownThreshold end
    if data.lockUI ~= nil then uiLocked = data.lockUI end
    if data.autoLeft ~= nil then autoLeftEnabled = data.autoLeft end
    if data.autoRight ~= nil then autoRightEnabled = data.autoRight end
    if data.antiRagdoll then antiRagdollEnabled = data.antiRagdoll end
    if data.autoSteal then Steal.AutoStealEnabled = data.autoSteal end
    if data.jumpEnabled ~= nil then jumpEnabled = data.jumpEnabled end
    if data.jumpMode then jumpMode = data.jumpMode end
    if data.tpDownMode then tpDownMode = data.tpDownMode end
    if data.medusaCounter then medusaCounterEnabled = data.medusaCounter end
    if data.batCounter then batCounterEnabled = data.batCounter end
    if data.autoBat then autoBatEnabled = data.autoBat end
    if data.unwalk then unwalkEnabled = data.unwalk end
    if data.antiLag then antiLagEnabled = data.antiLag end
    if data.laggerToggled then
        laggerToggled = true
        speedMode = false
        laggerLevel = data.laggerLevel or 1
    elseif data.carryMode then
        speedMode = true
        laggerToggled = false
    else
        speedMode = false
        laggerToggled = false
        laggerLevel = 1
    end
    if data.medusaAutoReset ~= nil then
        medusaAutoResetEnabled = data.medusaAutoReset
        if medusaAutoResetEnabled and medusaCounterEnabled then
            medusaCounterEnabled = false
        end
    end
    if data.instaResetKey then
        local ik = data.instaResetKey
        if ik.kb and Enum.KeyCode[ik.kb] then
            KB.InstaReset.kb = Enum.KeyCode[ik.kb]
            KB.InstaReset.gp = nil
        end
        if ik.gp and Enum.KeyCode[ik.gp] then
            KB.InstaReset.gp = Enum.KeyCode[ik.gp]
            KB.InstaReset.kb = nil
        end
    end
    if data.jumpModeKey then
        local jk = data.jumpModeKey
        if jk.kb and Enum.KeyCode[jk.kb] then
            KB.JumpMode.kb = Enum.KeyCode[jk.kb]
            KB.JumpMode.gp = nil
        end
        if jk.gp and Enum.KeyCode[jk.gp] then
            KB.JumpMode.gp = Enum.KeyCode[jk.gp]
            KB.JumpMode.kb = nil
        end
    end
    if data.bypassKey then
        local bk = data.bypassKey
        if bk.kb and Enum.KeyCode[bk.kb] then
            KB.Bypass.kb = Enum.KeyCode[bk.kb]
            KB.Bypass.gp = nil
        end
        if bk.gp and Enum.KeyCode[bk.gp] then
            KB.Bypass.gp = Enum.KeyCode[bk.gp]
            KB.Bypass.kb = nil
        end
    end
    if data.instaResetFloatingPos then
        instaResetFloatingPos = data.instaResetFloatingPos
    end
    if data.bypassFloatingPos then
        bypassFloatingPos = data.bypassFloatingPos
    end
    if data.batAimbotSpeed then
        BAT_AIMBOT_SPEED = data.batAimbotSpeed
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    end
    if data.bypassSpeed then
        BYPASS_AIMBOT_SPEED = data.bypassSpeed
        if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    end
    bypassToggled = false
    if data.bypassMode then
        bypassMode = data.bypassMode
        if bypassModeBtnRef then
            bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
        end
    end
    if data.dropMode then
        dropMode = data.dropMode
        if dropModeBtnRef then
            dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
        end
    end
    if data.stretchEnabled ~= nil then
        stretchEnabled = data.stretchEnabled
    end
    if data.stretchFOV then
        stretchFOV = data.stretchFOV
    end
    local function loadKey(kbData, target)
        if kbData and kbData.kb and Enum.KeyCode[kbData.kb] then
            target.kb = Enum.KeyCode[kbData.kb]
            target.gp = nil
        end
        if kbData and kbData.gp and Enum.KeyCode[kbData.gp] then
            target.gp = Enum.KeyCode[kbData.gp]
            target.kb = nil
        end
    end
    loadKey(data.dropBrainrotKey, KB.DropBrainrot)
    loadKey(data.autoLeftKey, KB.AutoLeft)
    loadKey(data.autoRightKey, KB.AutoRight)
    loadKey(data.autoBatKey, KB.AutoBat)
    loadKey(data.tpFloorKey, KB.TPFloor)
    loadKey(data.carryToggleKey, KB.CarryToggle)
    loadKey(data.laggerModeKey, KB.LaggerMode)
    loadKey(data.autoTPDownKey, KB.AutoTPDown)
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    refreshSpeedModeLabel()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
    return true
end

local function resetToDefaults()
    stopAllBackgroundTasks()
    NS = 60
    CS = 30
    LAGGER_SPEED_1 = 15
    LAGGER_SPEED_2 = 10
    Steal.StealRadius = 60.0
    Steal.StealDuration = 1.4
    autoTPHeight = 20
    autoTPDownThreshold = 20
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    jumpEnabled = false
    jumpMode = 1
    tpDownMode = 1
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    autoTPDownEnabled = false
    uiLocked = false
    Steal.AutoStealEnabled = false
    BAT_AIMBOT_SPEED = 58
    BYPASS_AIMBOT_SPEED = 60
    bypassToggled = false
    bypassMode = 1
    dropMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if radInput then radInput.Text = tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text = tostring(Steal.StealDuration) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if progressRadLbl then progressRadLbl.Text = "-- Â· --" end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if setBatCounterVisual then setBatCounterVisual(false) end
    if setMedusaVisual then setMedusaVisual(false) end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    if setAntiRagVisual then setAntiRagVisual(false) end
    if setJumpVisual then setJumpVisual(false) end
    if setUnwalkVisual then setUnwalkVisual(false) end
    if setAntiLagVisual then setAntiLagVisual(false) end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
    if setLockUIVisual then setLockUIVisual(false) end
    if setInstaGrab then setInstaGrab(false) end
    if bypassSetVisual then bypassSetVisual(false) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    if mobSetDropBR then mobSetDropBR(false) end
    if mobSetTpDown then mobSetTpDown(false) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if setJumpToggleState then setJumpToggleState(false) end
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
end

local function deleteAllSettings()
    local success = false
    if isfile and isfile(CONFIG_FILE) then
        success = pcall(function() delfile(CONFIG_FILE); return true end)
    end
    if isfile and isfile("Syn1zeHUB_PanelPos.txt") then
        pcall(delfile, "Syn1zeHUB_PanelPos.txt")
    end
    resetToDefaults()
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -66)
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, 0)
    end
    instaResetFloatingPos = nil
    bypassFloatingPos = nil
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    return success
end

-- ====== GUI ======
local gui = nil
local main = nil
local miniBtn = nil

local function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,50,50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,50,50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

-- ====== CONSTRUCCIÃ“N DE GUI ======
local function buildGui()
    local BLACK   = Color3.fromRGB(0,0,0)
    local ACCENT  = Color3.fromRGB(200,0,0)  -- ðŸ”´ ROJO
    local INP     = Color3.fromRGB(12,12,12)
    local CORNER  = 30
    local GUI_W, GUI_H = 420, 470
    local SIDEBAR_W = 195
    local CONTENT_OVERLAP = 8

    local old=game:GetService("CoreGui"):FindFirstChild("Syn1zeHUB");if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("Syn1zeHUB");if o then o:Destroy() end end
    gui=Instance.new("ScreenGui")
    gui.Name="Syn1zeHUB";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,GUI_W,0,GUI_H)
    main.Position=UDim2.new(0,20,0,2)
    local mainGrad = Instance.new("UIGradient", main)
    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    })
    mainGrad.Rotation = 45
    mainGrad.Offset = Vector2.new(0,0)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,CORNER)

    local mainStroke=Instance.new("UIStroke",main)
    mainStroke.Color=ACCENT
    mainStroke.Thickness=1.2
    mainStroke.Transparency=0.55

    task.spawn(function()
        local t=0
        while mainStroke and mainStroke.Parent do
            t = t + 0.04
            local phase = math.sin(t * 1.2)
            mainStroke.Color = Color3.fromRGB(
                128 + 64 * (phase * 0.5 + 0.5),
                0,
                0
            )
            mainStroke.Transparency = 0.35 + 0.2 * math.sin(t * 1.8)
            if mainGrad then
                mainGrad.Offset = Vector2.new(math.sin(t * 0.3) * 0.15, math.cos(t * 0.25) * 0.15)
            end
            task.wait(0.04)
        end
    end)

    local shadow = Instance.new("Frame", main)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, CORNER)

    -- Sidebar
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, CORNER)

    local sidebarCanvas = Instance.new("CanvasGroup", sidebar)
    sidebarCanvas.Size = UDim2.new(1, 60, 1, 0)
    sidebarCanvas.Position = UDim2.new(0, 0, 0, 0)
    sidebarCanvas.BackgroundColor3 = BLACK
    sidebarCanvas.BackgroundTransparency = 0
    sidebarCanvas.BorderSizePixel = 0
    sidebarCanvas.ClipsDescendants = true
    local canvasCorner = Instance.new("UICorner", sidebarCanvas)
    canvasCorner.CornerRadius = UDim.new(0, CORNER)

    sidebarImg = Instance.new("ImageLabel", sidebarCanvas)
    sidebarImg.Size = UDim2.new(1, 0, 1, 0)
    sidebarImg.Position = UDim2.new(0, 0, 0, 0)
    sidebarImg.BackgroundTransparency = 1
    sidebarImg.Image = "rbxassetid://" .. MENU_IMAGE_ID
    sidebarImg.ScaleType = Enum.ScaleType.Crop
    sidebarImg.ClipsDescendants = true

    local sidebarScrim = Instance.new("Frame", sidebarCanvas)
    sidebarScrim.Size = UDim2.new(1, 0, 1, 0)
    sidebarScrim.BackgroundColor3 = Color3.fromRGB(10,10,10)
    sidebarScrim.BackgroundTransparency = 0.92
    sidebarScrim.BorderSizePixel = 0
    sidebarScrim.ClipsDescendants = true

    -- Tab container
    local tabContainer = Instance.new("Frame", sidebar)
    tabContainer.Size = UDim2.new(0, 122, 0, 320)
    tabContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    tabContainer.Position = UDim2.new(0.50, 0, 0.52, 0)
    tabContainer.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 24)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Branding
    local brandFrame = Instance.new("Frame", sidebar)
    brandFrame.Size = UDim2.new(1, -24, 0, 54)
    brandFrame.Position = UDim2.new(0, 12, 1, -58)
    brandFrame.BackgroundTransparency = 1

    local brandTitle = Instance.new("TextLabel", brandFrame)
    brandTitle.Size = UDim2.new(1, 0, 0, 16)
    brandTitle.Position = UDim2.new(0, 0, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "Syn1ze HUB"
    brandTitle.TextColor3 = Color3.fromRGB(255,255,255)
    brandTitle.Font = Enum.Font.GothamBold
    brandTitle.TextSize = 13
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    local titleGrad = Instance.new("UIGradient", brandTitle)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200,0,0))
    })
    titleGrad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t=0
        while titleGrad and titleGrad.Parent do
            t = t + 0.03
            titleGrad.Offset = Vector2.new(math.sin(t * 0.8) * 0.3, 0)
            task.wait(0.04)
        end
    end)

    local brandSub = Instance.new("TextLabel", brandFrame)
    brandSub.Size = UDim2.new(1, 0, 0, 10)
    brandSub.Position = UDim2.new(0, 0, 0, 34)
    brandSub.BackgroundTransparency = 1
    brandSub.Text = "By Syn1ze"
    brandSub.TextColor3 = Color3.fromRGB(200,0,0)
    brandSub.Font = Enum.Font.Gotham
    brandSub.TextSize = 7
    brandSub.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(brandSub, 0.5)

    local brandLine = Instance.new("Frame", brandFrame)
    brandLine.Size = UDim2.new(0, 84, 0, 2)
    brandLine.Position = UDim2.new(0, 0, 0, 24)
    brandLine.BackgroundColor3 = ACCENT
    brandLine.BorderSizePixel = 0
    Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)

    -- BotÃ³n cerrar
    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0, 12)
    closeBtn.BackgroundColor3 = BLACK
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = ACCENT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = ACCENT
    closeStroke.Thickness = 1.2
    closeStroke.Transparency = 0.3
    applyShimmerToText(closeBtn, 1.2)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255,0,0),BackgroundColor3=Color3.fromRGB(20,0,0)}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0,Color=Color3.fromRGB(255,0,0)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=ACCENT,BackgroundColor3=BLACK}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.3,Color=ACCENT}):Play()
    end)

    miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,118,0,30)
    miniBtn.Position=UDim2.new(0,16,0,58)
    miniBtn.BackgroundColor3=BLACK
    miniBtn.BorderSizePixel=0
    miniBtn.Text="Syn1ze HUB"
    miniBtn.TextColor3=Color3.fromRGB(255,0,0)
    miniBtn.Font=Enum.Font.GothamBold
    miniBtn.TextSize=12
    miniBtn.ZIndex=20
    miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
    local miniStroke=Instance.new("UIStroke",miniBtn)
    miniStroke.Color=ACCENT
    miniStroke.Thickness=1.2
    miniStroke.Transparency=0.4
    applyShimmerToText(miniBtn, 0.9)

    local function showGui()
        main.Visible=true
        miniBtn.Visible=false
        setActivePage(mainPage)
    end

    local function hideGui()
        main.Visible=false
        miniBtn.Visible=true
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- Ãrea de contenido
    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -((SIDEBAR_W - CONTENT_OVERLAP)), 1, 0)
    contentArea.Position = UDim2.new(0, (SIDEBAR_W - CONTENT_OVERLAP), 0, 0)
    contentArea.BackgroundColor3 = Color3.fromRGB(38,0,0)
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 26)
    local contentSt=Instance.new("UIStroke",contentArea)
    contentSt.Color=ACCENT; contentSt.Thickness=1; contentSt.Transparency=0.18

    local pageHolder = Instance.new("Frame", contentArea)
    pageHolder.Size = UDim2.new(1, -10, 1, -18)
    pageHolder.Position = UDim2.new(0, 5, 0, 9)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0

    local function buildPage()
        local p = Instance.new("ScrollingFrame", pageHolder)
        p.Size = UDim2.new(1, -2, 1, 0)
        p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = ACCENT
        p.ScrollBarImageTransparency = 0.3
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout", p)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 7)
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 8)
        pd.PaddingRight = UDim.new(0, 8)
        pd.PaddingTop = UDim.new(0, 8)
        pd.PaddingBottom = UDim.new(0, 30)
        return p
    end

    local mainPage = buildPage()
    local otherPage = buildPage()
    otherPage.Visible = false
    local configPage = buildPage()
    configPage.Visible = false
    local keybindsPage = buildPage()
    keybindsPage.Visible = false

    local activePage = mainPage
    local function makeTopTab(label, idx, page)
        local b = Instance.new("TextButton", tabContainer)
        b.Size = UDim2.new(1, 0, 0, 43)
        b.BackgroundColor3 = Color3.fromRGB(18,0,0)
        b.BackgroundTransparency = 0.46
        b.BorderSizePixel = 0
        b.Text = label:sub(1,1) .. label:sub(2):lower()
        b.TextColor3 = Color3.fromRGB(245,245,245)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.AutoButtonColor = false
        b.LayoutOrder = idx
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
        local s = Instance.new("UIStroke", b)
        s.Color = Color3.fromRGB(88,0,0)
        s.Thickness = 1
        s.Transparency = 0.35
        applyShimmerToText(b, 0.7)
        return b
    end

    local btnMain   = makeTopTab("MAIN",   1, mainPage)
    local btnOther  = makeTopTab("OTHER",  2, otherPage)
    local btnConfig = makeTopTab("CONFIG", 3, configPage)
    local btnKeybinds = makeTopTab("KEYBINDS", 4, keybindsPage)
    local allTabs = {
        {btn=btnMain,   page=mainPage},
        {btn=btnOther,  page=otherPage},
        {btn=btnConfig, page=configPage},
        {btn=btnKeybinds, page=keybindsPage},
    }

    local function setActivePage(p)
        activePage = p
        for _, t in ipairs(allTabs) do
            t.page.Visible = (t.page == p)
            local isActive = (t.page == p)
            TS:Create(t.btn, TweenInfo.new(0.22), {
                BackgroundColor3 = isActive and Color3.fromRGB(200,0,0) or Color3.fromRGB(18,0,0),
                BackgroundTransparency = isActive and 0 or 0.46,
                TextColor3 = isActive and Color3.fromRGB(255,255,255) or Color3.fromRGB(245,245,245),
            }):Play()
            local st = t.btn:FindFirstChildWhichIsA("UIStroke")
            if st then
                TS:Create(st, TweenInfo.new(0.22), {
                    Color = isActive and Color3.fromRGB(255,0,0) or Color3.fromRGB(120,0,0),
                    Transparency = isActive and 0.2 or 0.5,
                }):Play()
            end
        end
    end

    btnMain.BackgroundColor3 = Color3.fromRGB(200,0,0)
    btnMain.BackgroundTransparency = 0
    btnMain.TextColor3 = Color3.fromRGB(255,255,255)
    local stMain = btnMain:FindFirstChildWhichIsA("UIStroke")
    if stMain then stMain.Color = Color3.fromRGB(255,0,0); stMain.Transparency = 0.2 end

    btnMain.MouseButton1Click:Connect(function() setActivePage(mainPage) end)
    btnOther.MouseButton1Click:Connect(function() setActivePage(otherPage) end)
    btnConfig.MouseButton1Click:Connect(function() setActivePage(configPage) end)
    btnKeybinds.MouseButton1Click:Connect(function() setActivePage(keybindsPage) end)

    -- Funciones auxiliares
    local function mkSect(txt)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = ACCENT
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        f.LayoutOrder = #activePage:GetChildren() + 1
        applyShimmerToText(l, 0.5)
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 1, -2)
        line.BackgroundColor3 = Color3.fromRGB(200,0,0)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        return f
    end

    local function mkRow(h)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, -2, 0, h or 40)
        f.BackgroundColor3 = BLACK
        f.BorderSizePixel = 0
        f.LayoutOrder = #activePage:GetChildren() + 1
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5,0,0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20,0,0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5,0,0))
        })
        rowGrad.Rotation = 90
        rowGrad.Offset = Vector2.new(0,0)
        task.spawn(function()
            local t=0
            while rowGrad and rowGrad.Parent do
                t = t + 0.02
                rowGrad.Offset = Vector2.new(math.sin(t * 0.2) * 0.1, 0)
                task.wait(0.04)
            end
        end)
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15,0,0)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = BLACK}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.58, 0, 1, 0)
        l.Position = UDim2.new(0, 11, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(255,50,50)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        applyShimmerToText(l, 0.6)
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 46, 0, 24)
        pill.Position = UDim2.new(1, -(offset or 56), 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(42,0,0)
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 18, 0, 18)
        dot.Position = UDim2.new(0, 3, 0.5, -9)
        dot.BackgroundColor3 = Color3.fromRGB(200,0,0)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local pillGrad = Instance.new("UIGradient", pill)
        pillGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60,0,0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90,0,0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60,0,0))
        })
        pillGrad.Rotation = 45
        task.spawn(function()
            local t=0
            while pillGrad and pillGrad.Parent do
                t = t + 0.03
                pillGrad.Offset = Vector2.new(math.sin(t * 0.5) * 0.2, 0)
                task.wait(0.04)
            end
        end)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(255,0,0) or Color3.fromRGB(34,0,0)}):Play()
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,0,0)
        }):Play()
    end

    local function mkToggle(txt, cb)
        local row = mkRow(40)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 56)
        local on = false
        local function sv(s) on=s; animPill(pill,dot,s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 8)
        tb.Size = UDim2.new(0, bw, 0, 26)
        tb.Position = UDim2.new(1, -xo, 0.5, -13)
        tb.BackgroundColor3 = INP
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = ACCENT
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(200,0,0)
        bs.Thickness = 1
        bs.Transparency = 0.28
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=ACCENT,Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(200,0,0),Transparency=0.28}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        applyShimmerToText(tb, 0.7)
        return tb
    end

    local function mkSelector(parent, default, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -56, 0.5, -13)
        btn.BackgroundColor3 = INP
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = ACCENT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(200,0,0)
        stroke.Thickness = 1
        btn.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            if cb then cb(btn) end
        end)
        applyShimmerToText(btn, 0.7)
        return btn
    end

    setActivePage(mainPage)

    mkSect("Speed")
    do local row=mkRow(40); mkLabel(row,"Normal Speed"); normalBox=mkBox(row,NS,50,56,function(v) if v>0 and v<=500 then NS=v end end) end
    do local row=mkRow(40); mkLabel(row,"Carry Speed"); carryBox=mkBox(row,CS,50,56,function(v) if v>0 and v<=500 then CS=v end end) end
    do local row=mkRow(40); mkLabel(row,"Lagger 1 Speed"); laggerBox=mkBox(row,LAGGER_SPEED_1,50,56,function(v) if v>0 and v<=500 then LAGGER_SPEED_1=v end end) end
    do local row=mkRow(40); mkLabel(row,"Lagger 2 Speed"); lagger2Box=mkBox(row,LAGGER_SPEED_2,50,56,function(v) if v>0 and v<=500 then LAGGER_SPEED_2=v end end) end
    do local row=mkRow(40); mkLabel(row,"Current Mode"); modeValLbl=Instance.new("TextLabel",row); modeValLbl.Size=UDim2.new(0,100,1,0); modeValLbl.Position=UDim2.new(1,-104,0,0); modeValLbl.BackgroundTransparency=1; modeValLbl.Text="Normal"; modeValLbl.TextColor3=ACCENT; modeValLbl.Font=Enum.Font.GothamBlack; modeValLbl.TextSize=12; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right; applyShimmerToText(modeValLbl, 0.8); local clk=Instance.new("TextButton",row); clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""; clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode() end) end

    mkSect("Combat")
    autoBatSetVisual = mkToggle("Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do local row=mkRow(40); mkLabel(row,"Bat Aimbot Speed"); batSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,50,56,function(v) if v>0 and v<=200 then BAT_AIMBOT_SPEED=v end end) end

    bypassSetVisual = mkToggle("Bypass Aimbot", function(on)
        toggleBypass(on)
        if bypassFloatingButton then
            local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                local label = btnFrame:FindFirstChild("TextLabel")
                if on then
                    btnFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
                else
                    btnFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(255, 50, 50) end
                end
            end
        end
    end)
    if bypassSetVisual then bypassSetVisual(bypassToggled) end
    do local row=mkRow(40); mkLabel(row,"Bypass Speed"); bypassSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,50,56,function(v) if v>0 and v<=200 then BYPASS_AIMBOT_SPEED=v end end) end
    do
        local row = mkRow(40)
        mkLabel(row, "Bypass Mode")
        bypassModeBtnRef = mkSelector(row, bypassMode == 1 and "Bypass" or "TP Bat", function(btn)
            toggleBypassMode()
            btn.Text = bypassMode == 1 and "Bypass" or "TP Bat"
        end)
    end

    setBatCounterVisual = mkToggle("Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setMedusaVisual = mkToggle("Medusa Counter", function(on)
        setMedusaCounterState(on)
    end)

    setMedusaAutoResetVisual = mkToggle("Medusa Auto Reset", function(on)
        setMedusaAutoResetState(on)
    end)

    setAntiRagVisual = mkToggle("Anti Ragdoll", function(on)
        antiRagdollEnabled = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)

    mkSect("Mechanics")
    setInstaGrab = mkToggle("Auto Steal", function(on)
        Steal.AutoStealEnabled = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    do
        local row = mkRow(40)
        mkLabel(row, "Infinite Jump")
        jumpPill, jumpDot = mkPill(row, 56)
        jumpOn = false
        setJumpToggleState = function(state)
            if jumpOn == state then return end
            jumpOn = state
            animPill(jumpPill, jumpDot, state)
            if state then
                jumpEnabled = true
                startJumpMode()
            else
                jumpEnabled = false
                stopJumpMode()
            end
        end
        local jumpClk = Instance.new("TextButton", jumpPill)
        jumpClk.Size = UDim2.new(1,0,1,0)
        jumpClk.BackgroundTransparency = 1
        jumpClk.Text = ""
        jumpClk.Activated:Connect(function()
            if _anyKeyListening then return end
            setJumpToggleState(not jumpOn)
        end)
        setJumpVisual = function(state) setJumpToggleState(state) end
    end

    do
        local row = mkRow(40)
        mkLabel(row, "Jump Mode")
        modeSelectBtn = mkSelector(row, jumpMode == 1 and "Tap Tap" or "Hold", function(btn)
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            btn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
        end)
    end

    setUnwalkVisual = mkToggle("Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    dropBrainrotSetVisual = mkToggle("Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(40)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "V1" or "V2", function(btn)
            if dropActive then
                stopDropBrainrot()
            end
            dropMode = dropMode == 1 and 2 or 1
            btn.Text = dropMode == 1 and "V1" or "V2"
        end)
    end

    setAntiLagVisual = mkToggle("Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    setActivePage(otherPage)

    mkSect("Auto Left / Right")
    autoLeftSetVisual = mkToggle("Auto Left", function(on)
        if on then
            autoLeftEnabled = true
            startAutoLeft()
        else
            autoLeftEnabled = false
            stopAutoLeft()
        end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle("Auto Right", function(on)
        if on then
            autoRightEnabled = true
            startAutoRight()
        else
            autoRightEnabled = false
            stopAutoRight()
        end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect("Teleport")
    do
        local row = mkRow(40)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function() executeTPDown() end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 60, 1, 0)
        actLbl.Position = UDim2.new(1, -64, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = ACCENT
        actLbl.Font = Enum.Font.GothamBold
        actLbl.TextSize = 10
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        applyShimmerToText(actLbl, 0.8)
    end
    do
        local row = mkRow(40)
        mkLabel(row, "TP Down Mode")
        tpModeSelectBtn = mkSelector(row, tpDownMode == 1 and "V1" or "V2", function(btn)
            tpDownMode = tpDownMode == 1 and 2 or 1
            btn.Text = tpDownMode == 1 and "V1" or "V2"
        end)
    end
    setAutoTPDownVisual = mkToggle("Auto TP Down", function(on)
        autoTPDownEnabled = on
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)
    do local row=mkRow(40); mkLabel(row,"Height Y"); autoTPHeightBox=mkBox(row,autoTPHeight,50,56,function(v) if v>=1 and v<=500 then autoTPHeight=v; autoTPDownThreshold=v end end) end
    setInstaResetVisual = mkToggle("Insta Reset", function(on)
        if on then
            insta_reset()
            if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
                local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
                local label = btnFrame and btnFrame:FindFirstChild("TextLabel")
                if btnFrame then
                    btnFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
                    task.delay(0.3, function()
                        if btnFrame then
                            btnFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
                            if label then label.TextColor3 = Color3.fromRGB(255, 50, 50) end
                        end
                    end)
                end
            end
            task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
        end
    end)

    -- ====== SECCIÃ“N VISUAL CON STRETCH ======
    mkSect("Visual")
    local stretchToggleSetter
    stretchToggleSetter = mkToggle("Stretch", function(on)
        if on then
            enableStretch()
        else
            disableStretch()
        end
        stretchEnabled = on
        pcall(saveAllSettings)
    end)
    _G.stretchToggleSetter = stretchToggleSetter
    stretchToggleSetter(stretchEnabled)

    do
        local row = mkRow(40)
        mkLabel(row, "FOV")
        local btnFrame = Instance.new("Frame", row)
        btnFrame.Size = UDim2.new(0, 150, 0, 28)
        btnFrame.Position = UDim2.new(1, -162, 0.5, -14)
        btnFrame.BackgroundTransparency = 1
        local fovBtns = {}
        local function makeFOVBtn(val, x)
            local btn = Instance.new("TextButton", btnFrame)
            btn.Size = UDim2.new(0, 44, 0, 28)
            btn.Position = UDim2.new(0, x, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(12,0,0)
            btn.BorderSizePixel = 0
            btn.Text = tostring(val)
            btn.TextColor3 = Color3.fromRGB(255,50,50)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(200,0,0)
            stroke.Thickness = 1
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
            end
            applyShimmerToText(btn, 0.7)
            btn.MouseButton1Click:Connect(function()
                stretchFOV = val
                if stretchEnabled then
                    applyStretchFOV(val)
                end
                for _, b in ipairs(btnFrame:GetChildren()) do
                    if b:IsA("TextButton") then
                        local v = tonumber(b.Text)
                        if v == val then
                            b.BackgroundColor3 = Color3.fromRGB(200,0,0)
                            b.TextColor3 = Color3.fromRGB(255,255,255)
                        else
                            b.BackgroundColor3 = Color3.fromRGB(12,0,0)
                            b.TextColor3 = Color3.fromRGB(255,50,50)
                        end
                    end
                end
                pcall(saveAllSettings)
            end)
            table.insert(fovBtns, btn)
            return btn
        end
        makeFOVBtn(90, 0)
        makeFOVBtn(120, 53)
        makeFOVBtn(180, 106)
        _G.fovButtons = fovBtns
    end

    setActivePage(configPage)

    mkSect("Steal")
    do local row=mkRow(40); mkLabel(row,"Steal Radius"); radInput=mkBox(row,Steal.StealRadius,50,56,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end end) end
    do local row=mkRow(40); mkLabel(row,"Steal Duration"); stealDurationBox=mkBox(row,Steal.StealDuration,50,56,function(v) if v>=0.05 and v<=2 then Steal.StealDuration=v end end) end

    mkSect("Interface")
    setLockUIVisual = mkToggle("Lock UI", function(on)
        toggleLockUI(on)
    end)

    mkSect("Config")
    do
        local row = mkRow(40)
        row.Size = UDim2.new(1, -16, 0, 40)
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        resetBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(45,0,0)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET POSITIONS"
        resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 13
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetBtn)
        resetStroke.Color = Color3.fromRGB(200,0,0)
        resetStroke.Thickness = 1.2
        applyShimmerToText(resetBtn, 0.6)
        resetBtn.Activated:Connect(function()
            resetFloatingPositions()
            resetBtn.Text = "RESET âœ“"
            resetBtn.BackgroundColor3 = Color3.fromRGB(30,0,0)
            task.delay(1.2, function()
                if resetBtn and resetBtn.Parent then
                    resetBtn.Text = "RESET POSITIONS"
                    resetBtn.BackgroundColor3 = Color3.fromRGB(45,0,0)
                end
            end)
        end)
    end

    do
        local row = mkRow(50)
        row.Size = UDim2.new(1, -16, 0, 50)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(60,0,0)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 14
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = ACCENT
        delStroke.Thickness = 1.2
        applyShimmerToText(delBtn, 0.6)

        local deleteState=0
        local originalDeleteText="DELETE SETTINGS"
        delBtn.Activated:Connect(function()
            if deleteState==0 then
                deleteState=1
                delBtn.Text="CONFIRM?"
                delBtn.BackgroundColor3=Color3.fromRGB(80,0,0)
                delBtn.TextColor3=Color3.fromRGB(255,255,255)
                task.delay(2,function()
                    if delBtn and delBtn.Parent and deleteState==1 then
                        deleteState=0
                        delBtn.Text=originalDeleteText
                        delBtn.BackgroundColor3=Color3.fromRGB(60,0,0)
                        delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    end
                end)
            elseif deleteState==1 then
                local success=deleteAllSettings()
                if success then
                    delBtn.Text="DELETED âœ“"
                    delBtn.BackgroundColor3=Color3.fromRGB(30,0,0)
                    delBtn.TextColor3=ACCENT
                    task.delay(1.5,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,0,0)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                else
                    delBtn.Text="NO FILE"
                    delBtn.BackgroundColor3=Color3.fromRGB(80,0,0)
                    delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    task.delay(1.2,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,0,0)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                end
            end
        end)
    end

    setActivePage(keybindsPage)

    mkSect("Keybinds")

    local keyButtonRefs = {}

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 85, 0, 26)
        btn.Position = UDim2.new(1, -93, 0.5, -13)
        btn.BackgroundColor3 = INP
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = ACCENT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(200,0,0)
        bs.Thickness = 1
        applyShimmerToText(btn, 0.7)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=ACCENT; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = Color3.fromRGB(255,255,255)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=ACCENT; return end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = ACCENT
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc=nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        return btn
    end

    local function addKeybindRow(labelText, kbEntry)
        local row = mkRow(36)
        mkLabel(row, labelText)
        local btn = mkKeyButton(row, kbEntry)
        table.insert(keyButtonRefs, {btn=btn, entry=kbEntry})
    end

    addKeybindRow("Carry Mode", KB.CarryToggle)
    addKeybindRow("Lagger Mode", KB.LaggerMode)
    addKeybindRow("Auto Left", KB.AutoLeft)
    addKeybindRow("Auto Right", KB.AutoRight)
    addKeybindRow("Auto Bat", KB.AutoBat)
    addKeybindRow("Bypass Aimbot", KB.Bypass)
    addKeybindRow("TP Down", KB.TPFloor)
    addKeybindRow("Drop Brainrot", KB.DropBrainrot)
    addKeybindRow("Insta Reset", KB.InstaReset)

    local spacer = Instance.new("Frame", keybindsPage)
    spacer.Size = UDim2.new(1, 0, 0, 20)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 100
    spacer.Visible = true

    _G.keyButtonRefs = keyButtonRefs

    -- ====== BARRA DE PROGRESO ======
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0, 300, 0, 38)
    pbFrame.Position = UDim2.new(0.5, -150, 1, -58)
    pbFrame.BackgroundColor3 = BLACK
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = Steal.AutoStealEnabled
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
    local pbSt = Instance.new("UIStroke", pbFrame)
    pbSt.Color = ACCENT
    pbSt.Thickness = 1.2
    pbSt.Transparency = 0.2

    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(0, 180, 1, -8)
    fillRegion.Position = UDim2.new(0, 5, 0, 4)
    fillRegion.BackgroundColor3 = BLACK
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = ACCENT
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.6

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = ACCENT
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160,0,0))
    })
    fillGrad.Rotation = 90
    task.spawn(function()
        local t=0
        while fillGrad and fillGrad.Parent do
            t = t + 0.03
            fillGrad.Offset = Vector2.new(math.sin(t * 0.6) * 0.2, 0)
            task.wait(0.04)
        end
    end)

    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 60, 1, 0)
    stealLbl.Position = UDim2.new(0, 12, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(255,255,255)
    stealLbl.Font = Enum.Font.GothamBlack
    stealLbl.TextSize = 11
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(stealLbl, 1.0)

    progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 50, 1, 0)
    progressPct.Position = UDim2.new(1, -58, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "â€”"
    progressPct.TextColor3 = Color3.fromRGB(230,230,230)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 10
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    applyShimmerToText(progressPct, 0.9)

    local pbDiv = Instance.new("Frame", pbFrame)
    pbDiv.Size = UDim2.new(0, 1, 0, 14)
    pbDiv.Position = UDim2.new(0, 192, 0.5, -7)
    pbDiv.BackgroundColor3 = ACCENT
    pbDiv.BackgroundTransparency = 0.7
    pbDiv.BorderSizePixel = 0

    progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Size = UDim2.new(0, 100, 1, 0)
    progressRadLbl.Position = UDim2.new(0, 196, 0, 0)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "-- Â· --"
    progressRadLbl.TextColor3 = Color3.fromRGB(190,190,190)
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 10
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    applyShimmerToText(progressRadLbl, 0.8)

    local function dragProgress(f)
        local dn,ds,sp,di = false
        f.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true
                ds = i.Position
                sp = f.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dn = false end
                end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                di = i
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == di and dn then
                local nX = sp.X.Offset + (i.Position.X - ds.X)
                local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
                f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
            end
        end)
    end
    dragProgress(pbFrame)

    function updateProgressBarVisibility()
        if pbFrame then
            pbFrame.Visible = Steal.AutoStealEnabled
        end
    end

    local _pbState = "IDLE"
    local function setBarState(state, distance)
        if state == _pbState and state ~= "READY" then return end
        _pbState = state
        if state == "STEALING" then
            TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22,0,0)}):Play()
        elseif state == "READY" then
            TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,0,0)}):Play()
            if progressPct then
                progressPct.Text = distance and (math.floor(distance).."m") or "READY"
                progressPct.TextColor3 = Color3.fromRGB(235,235,235)
            end
        else
            TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,0,0)}):Play()
            TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = BLACK}):Play()
            if progressPct and not isStealing then
                progressPct.Text = "â€”"
                progressPct.TextColor3 = Color3.fromRGB(150,0,0)
            end
        end
    end

    task.spawn(function()
        while task.wait(0.25) do
            if isStealing then
                setBarState("STEALING")
            else
                local p, d = findNearestPrompt()
                if p then
                    setBarState("READY", d)
                else
                    setBarState("IDLE")
                end
            end
        end
    end)

    task.spawn(function()
        local lastFrame = tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while true do
            local ping = 0
            pcall(function()
                ping = LP:GetNetworkPing() * 1000
            end)
            if progressRadLbl then
                progressRadLbl.Text = string.format("%d FPS | %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
            end
            task.wait(0.5)
        end
    end)

    local function drag(f)
        local dn,ds,sp,di=false
        f.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true; ds=i.Position; sp=f.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i==di and dn then
                if uiLocked then dn=false; return end
                local nX=sp.X.Offset+(i.Position.X-ds.X)
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
            end
        end)
    end
    drag(main)
end

local function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    refreshSpeedModeLabel()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end
    if Steal.AutoStealEnabled and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else
        if setJumpVisual then setJumpVisual(false) end
    end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if LP.Character then setupMedusaAutoReset(LP.Character) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaCounter()
        stopMedusaAutoReset()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if autoTPDownEnabled then if setAutoTPDownVisual then setAutoTPDownVisual(true) end; startAutoTPDown() end
    if autoBatEnabled and autoBatSetVisual then autoBatSetVisual(true); enableAutoBat() end
    if autoLeftEnabled and autoLeftSetVisual then autoLeftSetVisual(true) end
    if autoRightEnabled and autoRightSetVisual then autoRightSetVisual(true) end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if antiLagEnabled and setAntiLagVisual then enableAntiLag(); setAntiLagVisual(true) end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end
    if _G.fovButtons then
        for _, btn in ipairs(_G.fovButtons) do
            local val = tonumber(btn.Text)
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,0,0)
                btn.TextColor3 = Color3.fromRGB(255,50,50)
            end
        end
    end

    if _G.keyButtonRefs then
        for _, ref in ipairs(_G.keyButtonRefs) do
            local entry = ref.entry
            local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
            ref.btn.Text = label
        end
    end

    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end

    updateProgressBarVisibility()
    startEnemySpeed()
end

local function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "Syn1zeHUBMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = true
    container.Selectable = true

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1

    local grid = Instance.new("UIGridLayout", btnContainer)
    grid.CellSize = UDim2.new(0, BTN_W, 0, BTN_H)
    grid.CellPadding = UDim2.new(0, GAP, 0, GAP + 10)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.FillDirection = Enum.FillDirection.Horizontal
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
    grid.VerticalAlignment = Enum.VerticalAlignment.Top

    -- ðŸ”´ COLORES ROJO PARA BOTONES FLOTANTES
    local ACCENT = Color3.fromRGB(200,0,0)
    local INACTIVE_BG = Color3.fromRGB(10,0,0)
    local INACTIVE_TEXT = Color3.fromRGB(255,50,50)
    local STROKE_COLOR = Color3.fromRGB(200,0,0)
    local ACTIVE_BG = Color3.fromRGB(255,0,0)
    local ACTIVE_TEXT = Color3.fromRGB(255,255,255)

    local buttons = {}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = INACTIVE_TEXT
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextWrapped = true
        applyShimmerToText(label, 0.7)
        local active = false
        local function setActive(state, level)
            active = state
            if active then
                btn.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = ACTIVE_TEXT
                stroke.Color = Color3.fromRGB(255,255,255)
                stroke.Transparency = 0
            else
                btn.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = INACTIVE_TEXT
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0.4
            end
        end
        if callback then
            btn.MouseButton1Click:Connect(function()
                if isToggle then
                    callback(setActive, nil)
                else
                    callback(setActive, active)
                end
            end)
        end
        buttons[name] = {btn=btn, setActive=setActive, label=label}
        return setActive
    end

    mobSetDropBR = createButton("DropBR", "DROP\nBR", 0, true, function(setActive, _)
        if autoBatEnabled then return end
        setActive(true)
        executeDropWithToggle(function(v)
            if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
        end)
        task.delay(0.3, function() setActive(false) end)
    end)
    mobSetAutoLeft = createButton("AutoLeft", "AUTO\nLEFT", 1, true, function(setActive, _)
        autoLeftEnabled = not autoLeftEnabled
        setActive(autoLeftEnabled)
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    end)
    mobSetAutoBat = createButton("AutoBat", "BAT\nAIMBOT", 2, true, function(setActive, _)
        if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
        setActive(autoBatEnabled)
    end)
    mobSetAutoRight = createButton("AutoRight", "AUTO\nRIGHT", 3, true, function(setActive, _)
        autoRightEnabled = not autoRightEnabled
        setActive(autoRightEnabled)
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    end)
    mobSetTpDown = createButton("TpDown", "TP\nDOWN", 4, true, function(setActive, _)
        executeTPDown()
        setActive(true)
        task.delay(0.2, function() setActive(false) end)
    end)
    mobSetCarry = createButton("Carry", "CARRY\nSPD", 5, true, function(setActive, _)
        if not speedMode then
            speedMode=true; laggerToggled=false; laggerLevel=1; setActive(true)
            if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
            if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
        else
            speedMode=false; setActive(false)
        end
        refreshSpeedModeLabel()
    end)
    mobSetLagger1 = createButton("Lagger1", "LAGGER\n1", 6, true, function(setActive, _)
        if speedMode then speedMode=false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 1 then
            laggerToggled = true; laggerLevel = 1; setActive(true)
            if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
        else
            laggerToggled = false; laggerLevel = 1; setActive(false)
        end
        refreshSpeedModeLabel()
    end)
    mobSetLagger2 = createButton("Lagger2", "LAGGER\n2", 7, true, function(setActive, _)
        if speedMode then speedMode=false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 2 then
            laggerToggled = true; laggerLevel = 2; setActive(true)
            if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
        else
            laggerToggled = false; laggerLevel = 1; setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    if buttons.AutoBat then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled and laggerLevel==1) end
    if buttons.Lagger2 then buttons.Lagger2.setActive(laggerToggled and laggerLevel==2) end

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 1,
            savedMobilePanelPos.XOffset or (-PANEL_W - 10),
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    end

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local function startDrag(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = container.Position
            dragStartMousePos = input.Position
        end
    end
    local function onDrag(input)
        if not dragging or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                local newX = dragStartPos.X.Offset + delta.X
                local newY = dragStartPos.Y.Offset + delta.Y
                container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
            end
        end
    end
    local function endDrag()
        if dragging then
            dragging = false
            savedMobilePanelPos = {
                XScale = container.Position.X.Scale,
                XOffset = container.Position.X.Offset,
                YScale = container.Position.Y.Scale,
                YOffset = container.Position.Y.Offset
            }
            pcall(saveAllSettings)
        end
        dragStartPos = nil
        dragStartMousePos = nil
    end
    container.InputBegan:Connect(startDrag)
    container.InputEnded:Connect(endDrag)
    UIS.InputChanged:Connect(onDrag)
    for _, btnData in pairs(buttons) do
        btnData.btn.InputBegan:Connect(startDrag)
        btnData.btn.InputEnded:Connect(endDrag)
    end
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    return panel
end

-- ============================================================
-- ðŸ”¥ BOTÃ“N INSTA RESET EN ROJO
-- ============================================================
local function createInstaResetFloatingButton()
    local ACCENT = Color3.fromRGB(200,0,0)
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 1,
                                      instaResetFloatingPos.XOffset or (-MOBILE_PANEL_WIDTH - 10),
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or (MOBILE_PANEL_HEIGHT + 10))
    else
        btnFrame.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(30,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(255,50,50)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 21
    applyShimmerToText(label, 0.9)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
            label.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved then
                if not uiLocked then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                else
                    dragging = false
                end
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(true)
                    insta_reset()
                    if setInstaResetVisual then
                        setInstaResetVisual(true)
                        task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
                    end
                    task.delay(0.3, function()
                        if btnFrame and btnFrame.Parent then
                            setActive(false)
                        end
                    end)
                elseif not uiLocked and hasMoved then
                    instaResetFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputChanged:Connect(onInputChanged)
    btnFrame.InputEnded:Connect(onInputEnded)

    return panel
end

-- ============================================================
-- ðŸ”¥ BOTÃ“N BYPASS EN ROJO
-- ============================================================
local function createBypassFloatingButton()
    local ACCENT = Color3.fromRGB(200,0,0)
    local panel = Instance.new("ScreenGui")
    panel.Name = "BypassButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if bypassFloatingPos then
        btnFrame.Position = UDim2.new(bypassFloatingPos.XScale or 1,
                                      bypassFloatingPos.XOffset or (-10 - 60),
                                      bypassFloatingPos.YScale or 0,
                                      bypassFloatingPos.YOffset or (MOBILE_PANEL_HEIGHT + 10))
    else
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    btnFrame.BackgroundColor3 = bypassToggled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BYPASS\nAIMBOT"
    label.TextColor3 = bypassToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255,50,50)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    applyShimmerToText(label, 0.9)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
            label.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved then
                if not uiLocked then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                else
                    dragging = false
                end
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(not bypassToggled)
                    toggleBypass()
                elseif not uiLocked and hasMoved then
                    bypassFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputChanged:Connect(onInputChanged)
    btnFrame.InputEnded:Connect(onInputEnded)

    bypassFloatingButton = panel
    return panel
end

buildGui()
if loadAllSettings() then
    updateUIFromLoaded()
end

MobilePanel = createMobilePanel()
instaResetFloatingButton = createInstaResetFloatingButton()
bypassFloatingButton = createBypassFloatingButton()

if LP.Character then
    task.wait(0.0)
    setupSpeedIndicator(LP.Character)
end

LP.CharacterAdded:Connect(function(char)
    stopAutoSteal()
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopAutoTPDown()
    stopAntiRagdoll()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if bypassToggled then stopBypassAimbot() end

    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end

    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
            local md = hum.MoveDirection
            local spd
            if laggerToggled then
                spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
            else
                spd = speedMode and CS or NS
            end
            if md.Magnitude > 0 then
                lastMoveDir = md
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
            elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then anyHeld = true; break end
                end
                if anyHeld then
                    hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
                end
            end
        end

        if speedLabel then
            speedLabel.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
        end
    end)

    setupSpeedIndicator(char)

    if autoBatEnabled then enableAutoBat() end
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
    if bypassToggled then toggleBypass(true) end
    if Steal.AutoStealEnabled then pcall(startAutoSteal) end
    if jumpEnabled then startJumpMode() end
    if antiRagdollEnabled then startAntiRagdoll() end

    if medusaCounterEnabled then
        setupMedusa(char)
        if setMedusaVisual then setMedusaVisual(true) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        setupMedusaAutoReset(char)
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end
    if autoTPDownEnabled then startAutoTPDown() end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode() return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then executeTPDown() return end
    if kbMatch(KB.InstaReset, kc) then insta_reset() return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            startAutoLeft()
        else
            stopAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then
            startAutoRight()
        else
            stopAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.Bypass, kc) then
        toggleBypass()
        return
    end
    if kbMatch(KB.AutoTPDown, kc) then
        autoTPDownEnabled = not autoTPDownEnabled
        if autoTPDownEnabled then
            startAutoTPDown()
        else
            stopAutoTPDown()
        end
        if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
        return
    end
    if kbMatch(KB.JumpMode, kc) then
        if modeSelectBtn then
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        pcall(saveAllSettings)
    end
end)

print("Syn1ze HUB Loaded.")
end)