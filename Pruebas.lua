--=============================================================
--  LocalScript  →  StarterPlayer > StarterPlayerScripts
--  Botón "speed": arrastrable + teletransporte 4x8 studs
--=============================================================
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================== CONFIGURACIÓN ==========================
local BUTTON_SIZE   = 110    -- tamaño del cuadrado (px)
local STUDS_PER_STEP = 8     -- "8 pies" por salto (studs)
local STEPS          = 4     -- cantidad de saltos
local STEP_DELAY     = 0.15  -- pausa entre saltos (seg)
--=============================================================

--==================== INTERFAZ ===============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "SpeedButtonGui"
screenGui.ResetOnSpawn    = false
screenGui.IgnoreGuiInset  = true
screenGui.DisplayOrder    = 999
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
screenGui.Parent          = playerGui

local button = Instance.new("TextButton")
button.Name             = "SpeedButton"
button.Size             = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
button.AnchorPoint      = Vector2.new(0, 0)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.BorderSizePixel  = 0
button.Text             = "speed"
button.TextColor3       = Color3.new(1, 1, 1)
button.TextScaled       = true
button.Font             = Enum.Font.GothamBold
button.AutoButtonColor  = false
button.Active           = true
button.Parent           = screenGui

-- Centrar el botón al iniciar
local function centerButton()
    local vp = workspace.CurrentCamera.ViewportSize
    button.Position = UDim2.fromOffset(
        (vp.X - BUTTON_SIZE) / 2,
        (vp.Y - BUTTON_SIZE) / 2
    )
end
centerButton()

--==================== ARRASTRAR ==============================
local dragInput, dragStart, startX, startY, moved

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
        dragStart = input.Position
        startX    = button.Position.X.Offset
        startY    = button.Position.Y.Offset
        moved     = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input ~= dragInput then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    local delta = input.Position - dragStart
    if delta.Magnitude > 10 then moved = true end

    local vp  = workspace.CurrentCamera.ViewportSize
    local newX = math.clamp(startX + delta.X, 0, vp.X - BUTTON_SIZE)
    local newY = math.clamp(startY + delta.Y, 0, vp.Y - BUTTON_SIZE)

    button.Position = UDim2.fromOffset(newX, newY)
end)

UserInputService.InputEnded:Connect(function(input)
    if input ~= dragInput then return end
    dragInput = nil
    if not moved then          -- fue un toque, no un arrastre
        activate()
    end
end)

--==================== TELETRANSPORTE =========================
local function teleportForward()
    local character = player.Character
    if not character then return end

    for i = 1, STEPS do
        character = player.Character
        if not character then break end

        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then break end

        -- Avanza 8 studs hacia donde mira el personaje
        character:PivotTo(character:GetPivot() * CFrame.new(0, 0, -STUDS_PER_STEP))

        task.wait(STEP_DELAY)
    end
end

--==================== ACTIVAR / DESACTIVAR ===================
local used = false

function activate()
    if used then return end
    used = true

    -- 1) Se pone blanco completo
    TweenService:Create(button, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.new(1, 1, 1),
        TextColor3       = Color3.new(1, 1, 1),
    }):Play()

    -- 2) Se desactiva (no se puede volver a tocar ni arrastrar)
    button.Active        = false
    button.AutoButtonColor = false
    dragInput            = nil

    -- 3) Teletransporte
    teleportForward()
end