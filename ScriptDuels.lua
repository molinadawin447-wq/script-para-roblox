-- ============================================================
-- NOMBRE DEL SCRIPT: Blazzen Duels
-- Fondo personalizado: Limosna.jpg
-- Botones: Bordes rojos, letras rojas, fondo activo rojo
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer

-- CONFIGURACIÓN VISUAL
local GUI_NAME = "BlazzenDuels"
local BACKGROUND_IMAGE = getcustomasset("Limosna.jpg")
local COLORS = {
    BORDER = Color3.fromRGB(200, 0, 0),        -- Rojo para bordes
    TEXT = Color3.fromRGB(200, 0, 0),          -- Rojo para letras
    BUTTON_IDLE = Color3.fromRGB(30, 30, 30),  -- Botón normal
    BUTTON_ACTIVE = Color3.fromRGB(180, 0, 0), -- Botón activo
    BACKGROUND = Color3.fromRGB(15, 15, 15)
}

-- ============================================================
-- KICK WARNING (sin cambios en lógica, solo nombre del GUI)
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

    local oldGui = playerGui:FindFirstChild("BlazzenDuels_Warning")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlazzenDuels_Warning"
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
    frameStroke.Color = COLORS.BORDER
    frameStroke.Thickness = 2
    frameStroke.Transparency = 0.05

    local warningIcon = Instance.new("TextLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.fromOffset(34, 34)
    warningIcon.Position = UDim2.new(0, 10, 0.5, -17)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠️"
    warningIcon.TextColor3 = COLORS.BORDER
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
    textLabel.TextColor3 = COLORS.BORDER
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
            seg.Rotation=math.deg(r); seg.BackgroundColor3=COLORS.BORDER
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
        WARNING_VISIBLE=true; resize(); resetProgress(); textLabel.Text="KICK WARNING"; textLabel.TextColor3=COLORS.BORDER; frame.Visible=true
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


if _G.BlazzenDuelsRunning then return end
_G.BlazzenDuelsRunning = true

-- ============================================================
-- FUNCIÓN PARA CREAR BOTONES CON ESTILO PERSONALIZADO
-- ============================================================
local function CreateButton(parent, text, position, size, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "Button_" .. text:gsub("%s+", "")
    btn.Parent = parent
    btn.Position = position
    btn.Size = size
    btn.BackgroundColor3 = COLORS.BUTTON_IDLE
    btn.BorderSizePixel = 2
    btn.BorderColor3 = COLORS.BORDER
    btn.Text = text
    btn.TextColor3 = COLORS.TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoLocalize = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    -- Animación al pasar el mouse
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.BORDER:Lerp(COLORS.BUTTON_IDLE, 0.7)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.BUTTON_IDLE}):Play()
    end)

    -- Estado activo
    local isActive = false
    local function SetActive(active)
        isActive = active
        if active then
            btn.BackgroundColor3 = COLORS.BUTTON_ACTIVE
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = COLORS.BUTTON_IDLE
            btn.TextColor3 = COLORS.TEXT
        end
    end

    btn.MouseButton1Click:Connect(function()
        SetActive(not isActive)
        callback(isActive, SetActive)
    end)

    return btn, SetActive
end

-- ============================================================
-- CREACIÓN DEL GUI PRINCIPAL
-- ============================================================
local function CreateMainGUI()
    local playerGui = LP:WaitForChild("PlayerGui")

    -- Limpiar GUI anterior
    local oldGui = playerGui:FindFirstChild(GUI_NAME)
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Fondo principal con imagen
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    MainFrame.Size = UDim2.new(0, 260, 0, 420)
    MainFrame.BackgroundColor3 = COLORS.BACKGROUND
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = COLORS.BORDER

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Imagen de fondo
    local Background = Instance.new("ImageLabel")
    Background.Name = "Background"
    Background.Parent = MainFrame
    Background.Position = UDim2.new(0, 0, 0, 0)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 0.3
    Background.Image = BACKGROUND_IMAGE
    Background.ScaleType = Enum.ScaleType.Crop
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.4

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.Position = UDim2.new(0.5, -75, 0, 10)
    Title.Size = UDim2.new(0, 150, 0, 35)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 Blazzen Duels"
    Title.TextColor3 = COLORS.BORDER
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Center

    -- Línea separadora
    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.Parent = MainFrame
    Line.Position = UDim2.new(0.05, 0, 0, 50)
    Line.Size = UDim2.new(0.9, 0, 2, 0)
    Line.BackgroundColor3 = COLORS.BORDER

    -- Área de botones
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Parent = MainFrame
    ButtonContainer.Position = UDim2.new(0.05, 0, 0, 60)
    ButtonContainer.Size = UDim2.new(0.9, 0, 0.9, 0)
    ButtonContainer.BackgroundTransparency = 1

    -- Aquí se pueden agregar tus botones usando CreateButton()
    -- Ejemplo de estructura lista para tus funciones:
    -- CreateButton(ButtonContainer, "Auto Bat", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 35), function(active, setActive)
    --     _G.Lust.Active.autoBat = active
    -- end)

    return ScreenGui, MainFrame
end

-- Inicializar el GUI
CreateMainGUI()

print("✅ Blazzen Duels cargado correctamente!")
print("🎨 Fondo: Limosna.jpg")
print("🔴 Botones: Bordes rojos, letras rojas, activo = rojo sólido")

-- ====================================================================
-- RESTO DEL CÓDIGO ORIGINAL AQUÍ (funciones, sistemas, lógica del juego)
-- ====================================================================
-- NOTA: Mantén todo tu código original aquí. Solo se modificó la parte visual
-- y el nombre del script. La lógica de funciones sigue igual.

-- ⬇️ PEGA EL RESTO DE TU CÓDIGO DEBAJO DE ESTA LÍNEA ⬇️
