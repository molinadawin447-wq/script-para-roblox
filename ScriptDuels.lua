--============================================================
--  KosmosHub  ·  Panel GUI (sin fondo) + 9 botones móviles
--  Todo en un solo script, botones conectados al panel.
--============================================================
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Player           = Players.LocalPlayer
local PlayerGui        = Player:WaitForChild("PlayerGui")

local vp       = workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled

local function gethuiSafe()
    local ok, r = pcall(function() return gethui and gethui() end)
    return (ok and r) or PlayerGui
end

-- ───────────────────────── Paleta ─────────────────────────
local C = {
    bg        = Color3.fromRGB(8, 8, 8),
    bgDark    = Color3.fromRGB(0, 0, 0),
    row       = Color3.fromRGB(0, 0, 0),
    accent    = Color3.fromRGB(255, 255, 255),
    accentDim = Color3.fromRGB(180, 180, 180),
    text      = Color3.fromRGB(255, 255, 255),
    textDim   = Color3.fromRGB(200, 200, 200),
    textMuted = Color3.fromRGB(140, 140, 140),
    divider   = Color3.fromRGB(60, 60, 60),
}
local IVORY = Color3.fromRGB(250, 241, 224)
local DARK  = Color3.fromRGB(15, 18, 23)
local selectedColor = Color3.fromRGB(248, 165, 75)

-- ───────────────────────── Estado compartido ─────────────────────────
local toggleStates         = {}
local FeatureToggles       = {}    -- toggle(nombre) -> alternar
local FeaturePostToggle    = {}    -- (nombre, on) -> aplicar
local toggleVisualUpdaters = {}    -- [nombre] = lista de funciones

local function registerVisual(name, fn)
    toggleVisualUpdaters[name] = toggleVisualUpdaters[name] or {}
    table.insert(toggleVisualUpdaters[name], fn)
end
local function callVisual(name)
    for _, fn in ipairs(toggleVisualUpdaters[name] or {}) do pcall(fn) end
end

local function setFeature(name, on)
    on = on == true
    if toggleStates[name] == on then return end
    toggleStates[name] = on
    if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], on) end
    callVisual(name)
end
local function toggleFeature(name) setFeature(name, not toggleStates[name]) end

local FeatureKeybinds = {}
local speedValues = {
    NormalBoost = 59, NormalSteal = 29,
    LaggerBoost = 40, LaggerSteal = 20,
    CypherAimbotApproachSpeed = 60, FOV = 90, AutoTPDownHeight = 20,
}
local autoStealValues = { Radius = 65, Duration = 1.3 }
local carrySpeedMode  = "v1"
local optimizerMode   = "Ultra"
local skyMode         = "BLUE"
local skinMode        = "V1"
local autoplaySide    = "left"

-- ───────────────────────── Helpers ─────────────────────────
local function corner(parent, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = parent; return c
end
local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color or C.divider; s.Thickness = thickness or 1; s.Parent = parent; return s
end
local activeUiTweens = setmetatable({}, { __mode = "k" })
local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then return end
    local prev = activeUiTweens[obj]; if prev then pcall(function() prev:Cancel() end) end
    local a = TweenService:Create(obj, TweenInfo.new(dur or 0.16, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    activeUiTweens[obj] = a; a:Play()
end
local function keepText(obj) obj:SetAttribute("KosmosHubKeepBlackText", true); obj.TextStrokeTransparency = 1; return obj end
local function placeInsideViewport(gui, sx, ox, sy, oy)
    gui.Position = UDim2.new(sx, ox, sy, oy); return ox, oy
end
local function keyDisplayName(k) return tostring(k or "-") end

-- ───────────────────────── Acciones reales ─────────────────────────
FeatureToggles["TP Down"] = function()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

FeatureToggles["Drop"] = function()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targetY = hrp.Position.Y
    task.spawn(function()
        for _ = 1, 12 do
            if not hrp.Parent then return end
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 150, hrp.AssemblyLinearVelocity.Z)
            task.wait(0.016)
        end
        if hrp.Parent then
            local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

-- ───────────────────────── ScreenGui del panel ─────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "KosmosHub"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 9999990
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = PlayerGui

local modernW = isMobile and math.clamp(math.floor(vp.X * 0.55), 220, 260) or 260
local modernH = isMobile and math.clamp(math.floor(vp.Y * 0.68), 380, 460) or 460

local Panel = Instance.new("Frame")
Panel.Name                   = "KosmosHubModernPanel"
Panel.Size                   = UDim2.fromOffset(modernW, modernH)
Panel.Position               = UDim2.fromOffset(6, 54)
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel        = 0
Panel.ClipsDescendants       = false
Panel.Parent                 = ScreenGui

local mainUIScale = Instance.new("UIScale"); mainUIScale.Scale = 0.78; mainUIScale.Parent = Panel

local MODERN = {
    headerH  = isMobile and 72 or 82,
    inputH   = isMobile and 32 or 38,
    toggleH  = isMobile and 44 or 48,
    textSize = isMobile and 10 or 12,
}

-- Inner SIN fondo
local inner = Instance.new("Frame")
inner.Size                   = UDim2.fromScale(1, 1)
inner.BackgroundTransparency = 1
inner.BorderSizePixel        = 0
inner.ClipsDescendants       = true
inner.Parent                 = Panel
corner(inner, 14)
local innerStroke = stroke(inner, Color3.fromRGB(90, 90, 90), 1.2); innerStroke.Transparency = 0.15
local innerGlow   = stroke(inner, Color3.fromRGB(255, 255, 255), 3);   innerGlow.Transparency   = 0.88

-- Drag
local function makeDraggable(handle, target)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.Active = true
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local d = input.Position - dragStart
            placeInsideViewport(target, startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, MODERN.headerH)
header.BackgroundTransparency = 1
header.ZIndex = 10
header.Parent = inner
makeDraggable(header, Panel)

local title = keepText(Instance.new("TextLabel"))
title.Position = UDim2.new(0, 14, 0, 12)
title.Size     = UDim2.new(1, -90, 0, 28)
title.BackgroundTransparency = 1
title.Text = "KOSMOS HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = isMobile and 20 or 22
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = header

local sub = keepText(Instance.new("TextLabel"))
sub.Position = UDim2.new(0, 14, 0, 40)
sub.Size     = UDim2.new(1, -90, 0, 16)
sub.BackgroundTransparency = 1
sub.Text = "DISCORD.GG/KOSMOSHUB"
sub.TextColor3 = Color3.fromRGB(180, 180, 180)
sub.TextSize = 11
sub.Font = Enum.Font.GothamBold
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 11
sub.Parent = header

local closeBtn = keepText(Instance.new("TextButton"))
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "−"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 12
closeBtn.Parent = header
corner(closeBtn, 8); stroke(closeBtn, Color3.fromRGB(70, 70, 70), 1.1)
closeBtn.MouseEnter:Connect(function() tween(closeBtn, { BackgroundColor3 = C.accentDim }, 0.12) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, { BackgroundColor3 = C.bgDark }, 0.12) end)
closeBtn.MouseButton1Click:Connect(function() Panel.Visible = false end)

local separator = Instance.new("Frame")
separator.Position = UDim2.new(0, 13, 0, MODERN.headerH - 1)
separator.Size = UDim2.new(1, -26, 0, 1)
separator.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
separator.BackgroundTransparency = 0.35
separator.BorderSizePixel = 0
separator.ZIndex = 15
separator.Parent = inner

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -(MODERN.headerH + 44))
content.Position = UDim2.new(0, 10, 0, MODERN.headerH)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.ZIndex = 4
content.Parent = inner

-- Bottom tabs
local TAB_BAR_H = 30
local categoryList = Instance.new("Frame")
categoryList.Size = UDim2.new(1, -20, 0, TAB_BAR_H)
categoryList.Position = UDim2.new(0, 10, 1, -38)
categoryList.BackgroundTransparency = 1
categoryList.ZIndex = 40
categoryList.Parent = inner
local catLayout = Instance.new("UIListLayout", categoryList)
catLayout.SortOrder = Enum.SortOrder.LayoutOrder
catLayout.FillDirection = Enum.FillDirection.Horizontal
catLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
catLayout.VerticalAlignment = Enum.VerticalAlignment.Center
catLayout.Padding = UDim.new(0, 5)
local catPad = Instance.new("UIPadding", categoryList)
catPad.PaddingTop = UDim.new(0, 3); catPad.PaddingBottom = UDim.new(0, 3)

-- Pages
local pageScales = {}
local function newPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name .. "Page"
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    p.ScrollBarImageTransparency = 0.28
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.ZIndex = 5
    p.Parent = content
    local sc = Instance.new("UIScale"); sc.Scale = 1; sc.Parent = p
    pageScales[name] = sc
    local l = Instance.new("UIListLayout", p); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0, 6)
    local pd = Instance.new("UIPadding", p)
    pd.PaddingLeft = UDim.new(0, 4); pd.PaddingRight = UDim.new(0, 4)
    pd.PaddingTop = UDim.new(0, isMobile and 4 or 6); pd.PaddingBottom = UDim.new(0, isMobile and 4 or 6)
    return p
end
local pages = {
    Movement   = newPage("Movement"),
    Combat     = newPage("Combat"),
    Visual     = newPage("Visual"),
    Animations = newPage("Animations"),
}
pages.Movement.Visible = true

-- ═══════════════ Builders ═══════════════
local function sectionLabel(parent, text, order)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, isMobile and 26 or 30)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order
    wrap.Parent = parent
    local lbl = keepText(Instance.new("TextLabel"))
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(tostring(text or ""))
    lbl.TextColor3 = Color3.fromRGB(190, 187, 202)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = wrap
end

local listeningBindBtn, listeningFeature = nil, nil
local function inlineBind(parent, featureName, position)
    local b = keepText(Instance.new("TextButton"))
    b.Size = UDim2.fromOffset(isMobile and 38 or 44, isMobile and 16 or 20)
    b.Position = position
    b.BackgroundColor3 = C.accentDim
    b.BackgroundTransparency = 0.25
    b.BorderSizePixel = 0
    b.TextColor3 = C.text
    b.TextSize = isMobile and 8 or 9
    b.Font = Enum.Font.FredokaOne
    b.Text = FeatureKeybinds[featureName] and keyDisplayName(FeatureKeybinds[featureName]) or "-"
    b.ZIndex = 8
    b.Parent = parent
    corner(b, 5); stroke(b, Color3.fromRGB(55, 55, 60), 1)
    b.MouseButton1Click:Connect(function()
        if listeningBindBtn then listeningBindBtn.Text = "-" end
        listeningBindBtn, listeningFeature = b, featureName
        b.Text = "..."
    end)
    return b
end

local function modeButton(row, initialText, callback)
    local btn = keepText(Instance.new("TextButton"))
    btn.Size = UDim2.new(0, isMobile and 58 or 68, 0, isMobile and 26 or 28)
    btn.Position = UDim2.new(1, isMobile and -68 or -78, 0.5, isMobile and -13 or -14)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = initialText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = isMobile and 11 or 12
    btn.Font = Enum.Font.FredokaOne
    btn.ZIndex = 8
    btn.Parent = row
    corner(btn, 12); stroke(btn, C.accent, 1.5)
    local sc = Instance.new("UIScale"); sc.Scale = 1; sc.Parent = btn
    btn.MouseButton1Click:Connect(function()
        sc.Scale = 0.92
        tween(sc, { Scale = 1 }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local t = callback()
        if t then btn.Text = tostring(t) end
    end)
    return btn
end

local function inputRow(parent, labelText, value, order, callback, bindFeatureName)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, MODERN.inputH)
    row.BackgroundColor3 = C.row
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    corner(row, 14); stroke(row, C.divider, 1)

    local lbl = keepText(Instance.new("TextLabel"))
    lbl.Size = bindFeatureName and UDim2.new(1, isMobile and -116 or -142, 1, 0) or UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.text
    lbl.TextSize = MODERN.textSize
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    if bindFeatureName then
        inlineBind(row, bindFeatureName, UDim2.new(1, isMobile and -94 or -116, 0.5, isMobile and -8 or -10))
    end

    local bf = Instance.new("Frame")
    bf.Size = UDim2.new(0, isMobile and 44 or 54, 0, isMobile and 18 or 22)
    bf.Position = UDim2.new(1, isMobile and -51 or -64, 0.5, isMobile and -9 or -11)
    bf.BackgroundColor3 = C.row
    bf.BackgroundTransparency = 0.15
    bf.BorderSizePixel = 0
    bf.Parent = row
    corner(bf, 6); stroke(bf, Color3.fromRGB(55, 55, 60), 1)

    local box = keepText(Instance.new("TextBox"))
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.Text = tostring(value)
    box.TextColor3 = C.text
    box.TextSize = isMobile and 9 or 11
    box.Font = Enum.Font.FredokaOne
    box.ClearTextOnFocus = false
    box.Parent = bf
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then callback(n); box.Text = tostring(n) else box.Text = tostring(value) end
    end)
    return row
end

local function actionRow(parent, labelText, featureName, order, action)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    corner(row, 9); stroke(row, Color3.fromRGB(70, 70, 70), 1.15)
    local sc = Instance.new("UIScale"); sc.Scale = 1; sc.Parent = row
    local btn = keepText(Instance.new("TextButton"))
    btn.Size = UDim2.new(1, featureName and -64 or -24, 1, 0)
    btn.Position = UDim2.new(0, isMobile and 8 or 12, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = labelText
    btn.TextColor3 = C.text
    btn.TextSize = MODERN.textSize
    btn.Font = Enum.Font.FredokaOne
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        sc.Scale = 0.985
        tween(sc, { Scale = 1 }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        action()
    end)
    if featureName then
        inlineBind(row, featureName, UDim2.new(1, isMobile and -45 or -54, 0.5, isMobile and -9 or -11))
    end
    return row
end

local function toggleRow(parent, labelText, featureName, initial, order, hasKeybind, callback)
    local rowH = 36
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, rowH)
    row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.LayoutOrder = order
    row.Parent = parent
    corner(row, 9)
    local rowStroke = stroke(row, Color3.fromRGB(70, 70, 70), 1.15); rowStroke.Transparency = 0.25
    local rowScale = Instance.new("UIScale"); rowScale.Scale = 1; rowScale.Parent = row

    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, 3, 0, 16)
    marker.Position = UDim2.new(0, 6, 0.5, -8)
    marker.BackgroundColor3 = C.accent
    marker.BorderSizePixel = 0
    marker.Parent = row
    corner(marker, 4)

    local rightPad = hasKeybind and 108 or 58
    local lbl = keepText(Instance.new("TextLabel"))
    lbl.Size = UDim2.new(1, -rightPad, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = row

    if hasKeybind and featureName then
        local bind = keepText(Instance.new("TextButton"))
        bind.Size = UDim2.new(0, 40, 0, 22)
        bind.Position = UDim2.new(1, -100, 0.5, -11)
        bind.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bind.BorderSizePixel = 0
        bind.ZIndex = 6
        bind.Text = FeatureKeybinds[featureName] and keyDisplayName(FeatureKeybinds[featureName]) or "-"
        bind.TextColor3 = Color3.fromRGB(255, 255, 255)
        bind.TextSize = 10
        bind.Font = Enum.Font.GothamBold
        bind.Parent = row
        corner(bind, 6); stroke(bind, Color3.fromRGB(90, 90, 90), 1)
        bind.MouseButton1Click:Connect(function()
            if listeningBindBtn then listeningBindBtn.Text = "-" end
            listeningBindBtn, listeningFeature = bind, featureName
            bind.Text = "..."
        end)
    end

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 44, 0, 22)
    sw.Position = UDim2.new(1, -52, 0.5, -11)
    sw.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    sw.BorderSizePixel = 0
    sw.Text = ""
    sw.AutoButtonColor = false
    sw.ZIndex = 5
    sw.Parent = row
    corner(sw, 14)
    local swStroke = stroke(sw, Color3.fromRGB(220, 200, 230), 1.5); swStroke.Transparency = 0.25

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = sw
    corner(knob, 12)

    local function applyVisual(v)
        local act = v == true
        sw.BackgroundColor3 = act and C.accent or Color3.fromRGB(24, 24, 30)
        knob.Position = act and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        marker.BackgroundTransparency = act and 0 or 0.7
        rowStroke.Color = act and C.accent or Color3.fromRGB(70, 70, 70)
        rowStroke.Transparency = act and 0.1 or 0.25
    end
    applyVisual(initial == true)

    local function fire()
        rowScale.Scale = 0.985
        tween(rowScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local desired = not (toggleStates[featureName] == true)
        callback(desired)
        if featureName then
            toggleStates[featureName] = desired
            callVisual(featureName)
        end
    end
    sw.MouseButton1Click:Connect(fire)
    local hit = Instance.new("TextButton")
    keepText(hit)
    hit.Size = UDim2.new(1, hasKeybind and -108 or -58, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 1
    hit.Parent = row
    hit.MouseButton1Click:Connect(fire)

    if featureName then
        registerVisual(featureName, function() applyVisual(toggleStates[featureName] == true) end)
    end
    return row
end

-- ═══════════════ MOVEMENT ═══════════════
local mv = pages.Movement
sectionLabel(mv, "SPEED CONFIGURATION", 0)
inputRow(mv, "Normal Speed", speedValues.NormalBoost, 1, function(v) speedValues.NormalBoost = math.max(1, math.floor(v)) end, "SelectNormalMode")
inputRow(mv, "Carry Speed",  speedValues.NormalSteal, 2, function(v) speedValues.NormalSteal = math.max(1, math.floor(v)) end)

sectionLabel(mv, "LAGGER SPEED", 3)
inputRow(mv, "Lagger Normal", speedValues.LaggerBoost, 4, function(v) speedValues.LaggerBoost = math.max(1, math.floor(v)) end, "SelectLaggerMode")
inputRow(mv, "Lagger Carry",  speedValues.LaggerSteal, 5, function(v) speedValues.LaggerSteal = math.max(1, math.floor(v)) end)

sectionLabel(mv, "CONTROLS", 10)
local _, apRow = toggleRow(mv, "Auto Play", "Autoplay", false, 11, true, function(on) setFeature("Autoplay", on) end)
modeButton(apRow, "FULL", function()
    local cur = apRow:GetAttribute("mode") or "Full"
    local nextMode = cur == "Full" and "Semi" or "Full"
    apRow:SetAttribute("mode", nextMode)
    return string.upper(nextMode)
end)
toggleRow(mv, "Auto Carry Speed", "Auto Carry Speed", false, 12, false, function(on) setFeature("Auto Carry Speed", on) end)
local _, carryRow = toggleRow(mv, "Carry Mode", "Carry Speed", false, 13, true, function(on) setFeature("Carry Speed", on) end)
modeButton(carryRow, "V1", function()
    carrySpeedMode = carrySpeedMode == "v1" and "v2" or "v1"
    return string.upper(carrySpeedMode)
end)

sectionLabel(mv, "MOVEMENT SETTINGS", 20)
local _, ijRow = toggleRow(mv, "Infinite Jump", "Inf Jump", false, 21, false, function(on) setFeature("Inf Jump", on) end)
modeButton(ijRow, "HOLD", function()
    local m = ijRow:GetAttribute("mode") == "manual" and "hold" or "manual"
    ijRow:SetAttribute("mode", m)
    return string.upper(m)
end)
toggleRow(mv, "Unwalk", "Unwalk", false, 22, false, function(on) setFeature("Unwalk", on) end)

sectionLabel(mv, "TP DOWN", 30)
actionRow(mv, "TP Down", "TP Down", 31, function() FeatureToggles["TP Down"]() end)
toggleRow(mv, "Auto TP Down", "Auto TP Down", false, 32, false, function(on) setFeature("Auto TP Down", on) end)
inputRow(mv, "Height (studs)", speedValues.AutoTPDownHeight, 33, function(v) speedValues.AutoTPDownHeight = math.clamp(math.floor(v + 0.5), 1, 1000) end)

-- ═══════════════ COMBAT ═══════════════
local cb = pages.Combat
sectionLabel(cb, "BAT CONTROLS", 0)
toggleRow(cb, "Bat Aimbot", "Aimbot", false, 1, true, function(on) setFeature("Aimbot", on) end)
inputRow(cb, "Aimbot Speed", speedValues.CypherAimbotApproachSpeed, 2, function(v)
    speedValues.CypherAimbotApproachSpeed = math.clamp(math.floor(v + 0.5), 1, 120)
end)
toggleRow(cb, "Lagger Aimbot", "Lagger Aimbot", false, 3, true, function(on) setFeature("Lagger Aimbot", on) end)
toggleRow(cb, "Anti Bat", "Anti Bat", false, 4, true, function(on) setFeature("Anti Bat", on) end)
toggleRow(cb, "Ragdoll Counter", "Ragdoll Counter", false, 5, false, function(on) setFeature("Ragdoll Counter", on) end)
sectionLabel(cb, "RAGDOLL", 10)
toggleRow(cb, "Anti Ragdoll", "Anti Ragdoll", false, 11, false, function(on) setFeature("Anti Ragdoll", on) end)
toggleRow(cb, "Medusa Counter", "Medusa Counter", false, 12, false, function(on) setFeature("Medusa Counter", on) end)
toggleRow(cb, "Anti Die", "Anti Die", false, 13, false, function(on) setFeature("Anti Die", on) end)
sectionLabel(cb, "TP BAT", 20)
toggleRow(cb, "TP Bat", "TP Bat", false, 21, false, function(on) setFeature("TP Bat", on) end)
sectionLabel(cb, "ACTIONS", 30)
actionRow(cb, "Drop Brainrot", "Drop", 31, function() FeatureToggles["Drop"]() end)
actionRow(cb, "TP Down", "TP Down", 32, function() FeatureToggles["TP Down"]() end)
sectionLabel(cb, "AUTO STEAL", 40)
toggleRow(cb, "Auto Steal", "auto steal", false, 41, false, function(on) setFeature("auto steal", on) end)
toggleRow(cb, "Auto Steal Lock", "Auto Steal Lock", false, 42, false, function(on) setFeature("Auto Steal Lock", on) end)
inputRow(cb, "Steal Radius", autoStealValues.Radius, 43, function(v) autoStealValues.Radius = math.clamp(math.floor(v), 10, 150) end)
inputRow(cb, "Hold Duration", autoStealValues.Duration, 44, function(v) autoStealValues.Duration = math.clamp(tonumber(v) or 1.3, 0.3, 5) end)

-- ═══════════════ VISUAL ═══════════════
local vs = pages.Visual
sectionLabel(vs, "VISUAL", 0)
toggleRow(vs, "anti lag", "Anti Lag", false, 1, false, function(on) setFeature("Anti Lag", on) end)
toggleRow(vs, "ESP Players", "ESP Players", false, 2, false, function(on) setFeature("ESP Players", on) end)
toggleRow(vs, "ESP Line", "Player Tracers", false, 3, false, function(on) setFeature("Player Tracers", on) end)
local _, optRow = toggleRow(vs, "Optimizer", "Optimizer", false, 4, false, function(on) setFeature("Optimizer", on) end)
modeButton(optRow, string.upper(optimizerMode), function()
    optimizerMode = optimizerMode == "Ultra" and "Normal" or "Ultra"
    return string.upper(optimizerMode)
end)
toggleRow(vs, "Stretch Rez", "Stretchz Res", false, 5, false, function(on) setFeature("Stretchz Res", on) end)
sectionLabel(vs, "FOV", 10)
toggleRow(vs, "Custom FOV", "Custom FOV", false, 11, false, function(on) setFeature("Custom FOV", on) end)
inputRow(vs, "FOV", speedValues.FOV, 12, function(v)
    speedValues.FOV = math.clamp(math.floor(v), 30, 120)
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = speedValues.FOV end
end)
sectionLabel(vs, "SKY", 20)
local _, skyRow = toggleRow(vs, "Sky Themes", "Sky Changer", false, 21, false, function(on) setFeature("Sky Changer", on) end)
modeButton(skyRow, skyMode, function()
    skyMode = skyMode == "DAY" and "BLUE" or skyMode == "BLUE" and "NIGHT" or "DAY"
    return skyMode
end)
sectionLabel(vs, "SKIN CHANGER", 30)
local _, skinRow = toggleRow(vs, "Skin Changer", "Skin Changer", false, 31, false, function(on) setFeature("Skin Changer", on) end)
modeButton(skinRow, skinMode, function()
    skinMode = skinMode == "V1" and "V2" or skinMode == "V2" and "V3" or "V1"
    return skinMode
end)
toggleRow(vs, "Headless", "Headless Visual", false, 32, false, function(on) setFeature("Headless Visual", on) end)
toggleRow(vs, "Korblox", "Korblox Visual", false, 33, false, function(on) setFeature("Korblox Visual", on) end)
sectionLabel(vs, "GUI", 40)
toggleRow(vs, "Quick Buttons", "Show Buttons", false, 41, false, function(on) setFeature("Show Buttons", on) end)
do
    local row = actionRow(vs, "UI Scale", nil, 42, function() end)
    local box = keepText(Instance.new("TextBox"))
    box.Size = UDim2.fromOffset(64, 26)
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -10, 0.5, 0)
    box.BackgroundColor3 = C.accentDim
    box.BorderSizePixel = 0
    box.TextColor3 = C.text
    box.Font = Enum.Font.FredokaOne
    box.TextSize = 12
    box.Text = "78"
    box.ClearTextOnFocus = false
    box.ZIndex = 8
    box.Parent = row
    corner(box, 5)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            n = math.clamp(math.floor(n + 0.5), 40, 150)
            box.Text = tostring(n)
            mainUIScale.Scale = n / 100
        end
    end)
end
actionRow(vs, "Hide GUI Key", "Toggle UI", 46, function() Panel.Visible = false end)

-- ═══════════════ ANIMATIONS ═══════════════
local an = pages.Animations
local presetOrder = {
    "Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie",
    "Mage","Catwalk Glam","Astronaut",'Wicked "Dancing Through Life"',"Werewolf","Superhero",
    "Toy","No Boundaries","NFL","Amazon Unboxed","Vampire","Ninja","Robot","Levitation",
    "Stylish","Bubbly","Cartoon",
}
sectionLabel(an, "ANIMATION SOURCE", 0)
local selectedPreset = presetOrder[1]
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, 0, 0, isMobile and 180 or 220)
list.BackgroundColor3 = C.bgDark
list.BackgroundTransparency = 0.15
list.BorderSizePixel = 0
list.ScrollBarThickness = 3
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.LayoutOrder = 1
list.ZIndex = 6
list.Parent = an
corner(list, 12); stroke(list, C.divider, 1)
local ll = Instance.new("UIListLayout", list); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 4)
local lpp = Instance.new("UIPadding", list); lpp.PaddingTop = UDim.new(0, 6); lpp.PaddingBottom = UDim.new(0, 6)
local presetButtons = {}
local function refreshPresetButtons()
    for name, btn in pairs(presetButtons) do
        local sel = name == selectedPreset
        btn.BackgroundColor3 = sel and C.accent or C.bgDark
        btn.BackgroundTransparency = sel and 0.15 or 0.35
        btn.TextColor3 = sel and Color3.fromRGB(255, 255, 255) or C.text
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then st.Color = sel and C.accent or C.divider; st.Transparency = sel and 0.25 or 0.6 end
    end
end
for i, name in ipairs(presetOrder) do
    local btn = keepText(Instance.new("TextButton"))
    btn.Size = UDim2.new(1, 0, 0, isMobile and 30 or 34)
    btn.BackgroundColor3 = C.bgDark
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = C.text
    btn.TextSize = isMobile and 11 or 12
    btn.Font = Enum.Font.FredokaOne
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = i
    btn.AutoButtonColor = false
    btn.ZIndex = 7
    btn.Parent = list
    corner(btn, 10); stroke(btn, C.divider, 1)
    presetButtons[name] = btn
    btn.MouseButton1Click:Connect(function() selectedPreset = name; refreshPresetButtons() end)
end
refreshPresetButtons()
toggleRow(an, "Animaciones", "Animaciones", false, 2, false, function(on) setFeature("Animaciones", on) end)
local info = keepText(Instance.new("TextLabel"))
info.Size = UDim2.new(1, -8, 0, 30)
info.BackgroundTransparency = 1
info.LayoutOrder = 4
info.Text = "Tap a preset in the list to apply and save. Use the toggle to enable or disable."
info.TextColor3 = C.textDim
info.TextSize = 10
info.Font = Enum.Font.FredokaOne
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = an

-- ═══════════════ Tabs ═══════════════
local activeCategory = "Movement"
for order, name in ipairs({ "Movement", "Combat", "Visual", "Animations" }) do
    local btn = keepText(Instance.new("TextButton"))
    btn.Size = UDim2.new(0.25, -5, 1, 0)
    btn.BackgroundColor3 = name == activeCategory and C.accent or Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = name == activeCategory and 0.15 or 1
    btn.BorderSizePixel = 0
    btn.Text = string.upper(name)
    btn.TextColor3 = name == activeCategory and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 187, 202)
    btn.TextSize = 11
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = categoryList
    local tsc = Instance.new("UITextSizeConstraint", btn); tsc.MinTextSize = 6; tsc.MaxTextSize = 12
    corner(btn, 9)
    local cs = stroke(btn, name == activeCategory and C.accent or Color3.fromRGB(70, 70, 70), 1.2)
    cs.Transparency = name == activeCategory and 0.05 or 0.35
    btn.MouseButton1Click:Connect(function()
        if activeCategory == name then return end
        activeCategory = name
        for pageName, page in pairs(pages) do
            local sel = pageName == name
            page.Visible = sel
            if sel then local sc = pageScales[pageName]; if sc then sc.Scale = 0.975; tween(sc, { Scale = 1 }, 0.2) end end
        end
        for _, o in ipairs(categoryList:GetChildren()) do
            if o:IsA("TextButton") then
                local isSel = o == btn
                tween(o, {
                    TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 187, 202),
                    BackgroundColor3 = isSel and C.accent or Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = isSel and 0.15 or 1,
                }, 0.18)
                local s = o:FindFirstChildOfClass("UIStroke")
                if s then s.Color = isSel and C.accent or Color3.fromRGB(70, 70, 70); s.Transparency = isSel and 0.1 or 0.4 end
            end
        end
    end)
end

-- ═════════════════════════════════════════════════════════════
--  BOTONES MÓVILES (9)  ·  sincronizados con el panel
-- ═════════════════════════════════════════════════════════════
local mobileButtons = {}

local BUTTONS = {
    { name = "AutoLeft",     label = "AUTO LEFT",     icon = "◀" },
    { name = "AutoRight",    label = "AUTO RIGHT",    icon = "▶" },
    { name = "AutoBat",      label = "AUTO BAT",      icon = "⚔" },
    { name = "TPDown",       label = "TP DOWN",       icon = "▼", isAction = true },
    { name = "DropBrainrot", label = "DROP BRAINROT", icon = "✖", isAction = true },
    { name = "NormalSpeed",  label = "NORMAL SPEED",  icon = "⇄" },
    { name = "CarrySpeed",   label = "CARRY SPEED",   icon = "⚡" },
    { name = "Activate",     label = "ACTIVATE",      icon = "✦" },
    { name = "HideGUI",      label = "HIDE GUI",      icon = "◉", isAction = true },
}

local SIZE, GAP = 54, 6
local TOTAL_H = (#BUTTONS * (SIZE + GAP)) - GAP

local function paintFloatingBtn(btn, active)
    if not btn or not btn.Parent then return end
    local grad   = btn:FindFirstChild("BtnGrad")
    local s      = btn:FindFirstChildWhichIsA("UIStroke")
    if grad then
        if active then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, selectedColor:Lerp(Color3.new(1,1,1), 0.15)),
                ColorSequenceKeypoint.new(1, selectedColor:Lerp(DARK, 0.35)),
            })
        else
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, IVORY:Lerp(Color3.new(1,1,1), 0.20)),
                ColorSequenceKeypoint.new(1, IVORY:Lerp(DARK, 0.10)),
            })
        end
    end
    if s then
        s.Color = selectedColor
        s.Transparency = active and 0.25 or 0.55
    end
    local icon = btn:FindFirstChild("Icon")
    if icon then icon.TextColor3 = active and DARK or selectedColor end
    local cap = btn:FindFirstChild("Caption")
    if cap then cap.TextColor3 = active and IVORY or DARK end
    btn:SetAttribute("MobActive", active)
end

local mobileScreen = Instance.new("ScreenGui")
mobileScreen.Name = "KosmosHubMobileButtons"
mobileScreen.ResetOnSpawn = false
mobileScreen.IgnoreGuiInset = true
mobileScreen.DisplayOrder = 9999995
mobileScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileScreen.Parent = gethuiSafe()

local MobilePanel = Instance.new("Frame")
MobilePanel.Name = "MobilePanel"
MobilePanel.BackgroundTransparency = 1
MobilePanel.Size = UDim2.fromScale(1, 1)
MobilePanel.Parent = mobileScreen

local function makeMobileBtn(cfg, index)
    local btn = Instance.new("TextButton")
    btn.Name = cfg.name
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -12, 0.5, -TOTAL_H/2 + (index - 1) * (SIZE + GAP) + SIZE/2)
    btn.Size = UDim2.fromOffset(SIZE, SIZE)
    btn.BackgroundColor3 = IVORY
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ClipsDescendants = true
    btn.ZIndex = 10
    btn:SetAttribute("MobActive", false)
    btn.Parent = MobilePanel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 13)
    local s = Instance.new("UIStroke")
    s.Color = selectedColor; s.Transparency = 0.55; s.Thickness = 1
    s.Parent = btn
    local g = Instance.new("UIGradient")
    g.Name = "BtnGrad"; g.Rotation = 90
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, IVORY:Lerp(Color3.new(1,1,1), 0.20)),
        ColorSequenceKeypoint.new(1, IVORY:Lerp(DARK, 0.10)),
    })
    g.Parent = btn
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(1, 0, 0, 24)
    icon.Position = UDim2.fromOffset(0, 4)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.TextColor3 = selectedColor
    icon.Text = cfg.icon
    icon.ZIndex = 11
    icon.Parent = btn
    local cap = Instance.new("TextLabel")
    cap.Name = "Caption"
    cap.BackgroundTransparency = 1
    cap.Size = UDim2.new(1, -4, 0, 12)
    cap.Position = UDim2.new(0, 2, 1, -16)
    cap.Font = Enum.Font.GothamBold
    cap.TextSize = 8
    cap.TextColor3 = DARK
    cap.Text = cfg.label
    cap.ZIndex = 11
    cap.Parent = btn

    btn.MouseEnter:Connect(function() tween(btn, { Size = UDim2.fromOffset(SIZE+4, SIZE+4) }, 0.12) end)
    btn.MouseLeave:Connect(function() tween(btn, { Size = UDim2.fromOffset(SIZE, SIZE) }, 0.12) end)
    paintFloatingBtn(btn, false)
    mobileButtons[cfg.name] = btn
    return btn
end

for i, cfg in ipairs(BUTTONS) do makeMobileBtn(cfg, i) end

-- Hamburger para esconder/mostrar los botones
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "miniBtn"
miniBtn.AnchorPoint = Vector2.new(1, 0)
miniBtn.Position = UDim2.new(1, -12, 0, 12)
miniBtn.Size = UDim2.fromOffset(36, 36)
miniBtn.BackgroundColor3 = DARK
miniBtn.Text = "☰"
miniBtn.TextColor3 = IVORY
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 16
miniBtn.BorderSizePixel = 0
miniBtn.AutoButtonColor = false
miniBtn.ZIndex = 12
miniBtn.Parent = mobileScreen
corner(miniBtn, 10); stroke(miniBtn, Color3.fromRGB(255, 140, 0), 1)
miniBtn.Activated:Connect(function() MobilePanel.Visible = not MobilePanel.Visible end)

-- ═════════════════════════════════════════════════════════════
--  CALLBACKS · conectan cada botón con su feature del panel
-- ═════════════════════════════════════════════════════════════
local function flashAction(btn, actionFn)
    paintFloatingBtn(btn, true)
    pcall(actionFn)
    task.delay(0.18, function() paintFloatingBtn(btn, false) end)
end

-- Toggles reales
_G.luckbroomButtonCallbacks = {
    AutoLeft = function(active)
        autoplaySide = "left"
        setFeature("Autoplay", active)
        if active then callVisual("Autoplay") end
    end,
    AutoRight = function(active)
        autoplaySide = "right"
        setFeature("Autoplay", active)
        if active then callVisual("Autoplay") end
    end,
    AutoBat = function(active) setFeature("TP Bat", active) end,
    NormalSpeed = function(active)
        if active then
            setFeature("Speed Boost", true)
            setFeature("Carry Speed", false)
        else
            setFeature("Speed Boost", false)
        end
    end,
    CarrySpeed = function(active)
        if active then
            setFeature("Speed Boost", true)
            setFeature("Carry Speed", true)
        else
            setFeature("Carry Speed", false)
        end
    end,
    Activate = function(active) setFeature("auto steal", active) end,
    -- Acciones (flash y volver a OFF)
    TPDown = function()
        flashAction(mobileButtons.TPDown, function() FeatureToggles["TP Down"]() end)
    end,
    DropBrainrot = function()
        flashAction(mobileButtons.DropBrainrot, function() FeatureToggles["Drop"]() end)
    end,
    HideGUI = function()
        flashAction(mobileButtons.HideGUI, function() Panel.Visible = not Panel.Visible end)
    end,
}

-- Conectar el click de cada botón al callback correspondiente
for _, cfg in ipairs(BUTTONS) do
    local btn = mobileButtons[cfg.name]
    btn.Activated:Connect(function()
        if cfg.isAction then
            if _G.luckbroomButtonCallbacks[cfg.name] then pcall(_G.luckbroomButtonCallbacks[cfg.name]) end
        else
            local active = not (btn:GetAttribute("MobActive") == true)
            paintFloatingBtn(btn, active)
            if _G.luckbroomButtonCallbacks[cfg.name] then
                pcall(_G.luckbroomButtonCallbacks[cfg.name], active)
            end
        end
    end)
end

-- ═════════════════════════════════════════════════════════════
--  SINCRONIZACIÓN panel → botones
-- ═════════════════════════════════════════════════════════════
local BUTTON_FEATURE = {
    AutoBat     = "TP Bat",
    NormalSpeed = "Speed Boost",
    CarrySpeed  = "Carry Speed",
    Activate    = "auto steal",
}

local function syncMobile()
    for name, featureName in pairs(BUTTON_FEATURE) do
        local btn = mobileButtons[name]
        if btn then
            local want = toggleStates[featureName] == true
            if (btn:GetAttribute("MobActive") == true) ~= want then
                paintFloatingBtn(btn, want)
            end
        end
    end
    -- AutoLeft / AutoRight dependen de Autoplay + autoplaySide
    local ap = toggleStates["Autoplay"] == true
    for name, side in pairs({ AutoLeft = "left", AutoRight = "right" }) do
        local btn = mobileButtons[name]
        if btn then
            local want = ap and autoplaySide == side
            if (btn:GetAttribute("MobActive") == true) ~= want then
                paintFloatingBtn(btn, want)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    local ok = pcall(syncMobile)
    if ok then end
end)

-- ═════════════════════════════════════════════════════════════
--  BINDS · asignación de teclas
-- ═════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if listeningBindBtn and listeningFeature then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            if input.KeyCode == Enum.KeyCode.Escape then
                FeatureKeybinds[listeningFeature] = nil
                listeningBindBtn.Text = "-"
            else
                FeatureKeybinds[listeningFeature] = input.KeyCode
                listeningBindBtn.Text = keyDisplayName(input.KeyCode)
            end
            listeningBindBtn, listeningFeature = nil, nil
        end
        return
    end
    if gp then return end
    for feat, key in pairs(FeatureKeybinds) do
        if input.KeyCode == key then
            if feat == "TP Down" then FeatureToggles["TP Down"]()
            elseif feat == "Drop" then FeatureToggles["Drop"]()
            else setFeature(feat, not toggleStates[feat]) end
        end
    end
end)

print("[KosmosHub] Panel + 9 botones cargados y sincronizados.")