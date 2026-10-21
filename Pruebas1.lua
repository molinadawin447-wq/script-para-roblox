
-- LAG SYSTEM + BOTON MOVIL + CANDADO
-- LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local activo = false
local movimientoBloqueado = false
local personajeActual
local clon
local conexion
local tiempo = 0
local distancia = 30
local transparencias = {}

-- INTERFAZ
local gui = Instance.new("ScreenGui")
gui.Name = "LagButtonGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = player:WaitForChild("PlayerGui")

local boton = Instance.new("TextButton")
boton.Name = "LAG"
boton.Size = UDim2.fromOffset(75, 45)
boton.Position = UDim2.new(1, -90, 0.4, 0)
boton.BackgroundColor3 = Color3.new(1, 1, 1)
boton.TextColor3 = Color3.new(0, 0, 0)
boton.Text = "LAG"
boton.TextSize = 18
boton.Font = Enum.Font.GothamBold
boton.AutoButtonColor = false
boton.Active = true
boton.Parent = gui

local esquina = Instance.new("UICorner")
esquina.CornerRadius = UDim.new(0, 10)
esquina.Parent = boton

local borde = Instance.new("UIStroke")
borde.Color = Color3.new(0, 0, 0)
borde.Thickness = 2
borde.Parent = boton

-- CANDADO
local candado = Instance.new("TextButton")
candado.Name = "Candado"
candado.Size = UDim2.fromOffset(23, 21)
candado.Position = UDim2.new(1, 3, 0, -7)
candado.AnchorPoint = Vector2.new(1, 0)
candado.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
candado.Text = "🔓"
candado.TextSize = 13
candado.Font = Enum.Font.GothamBold
candado.ZIndex = 3
candado.Parent = boton

local esquinaCandado = Instance.new("UICorner")
esquinaCandado.CornerRadius = UDim.new(0, 6)
esquinaCandado.Parent = candado

-- MOVIMIENTO TACTIL
local arrastrando = false
local inicioToque
local posicionInicial
local toqueActual
local movimientoRealizado = false

candado.Activated:Connect(function()
    movimientoBloqueado = not movimientoBloqueado

    if movimientoBloqueado then
        candado.Text = "🔒"
        candado.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        arrastrando = false
    else
        candado.Text = "🔓"
        candado.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    end
end)

boton.InputBegan:Connect(function(input)
    if movimientoBloqueado then return end

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        arrastrando = true
        movimientoRealizado = false
        inicioToque = input.Position
        posicionInicial = boton.Position
        toqueActual = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not arrastrando or movimientoBloqueado then return end

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - inicioToque

        if delta.Magnitude > 5 then
            movimientoRealizado = true
        end

        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize
        if not viewport then return end

        local ancho = boton.AbsoluteSize.X
        local alto = boton.AbsoluteSize.Y

        local x = math.clamp(
            posicionInicial.X.Offset + delta.X,
            0,
            viewport.X - ancho
        )

        local y = math.clamp(
            posicionInicial.Y.Offset + delta.Y,
            0,
            viewport.Y - alto
        )

        boton.Position = UDim2.fromOffset(x, y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == toqueActual
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastrando = false
        toqueActual = nil
    end
end)

-- RESTAURAR APARIENCIA
local function restaurarPersonaje()
    for objeto, transparencia in pairs(transparencias) do
        if objeto and objeto.Parent then
            objeto.Transparency = transparencia
        end
    end

    transparencias = {}
end

-- DESACTIVAR LAG
local function desactivar()
    activo = false

    if conexion then
        conexion:Disconnect()
        conexion = nil
    end

    if clon then
        clon:Destroy()
        clon = nil
    end

    restaurarPersonaje()

    boton.BackgroundColor3 = Color3.new(1, 1, 1)
    boton.TextColor3 = Color3.new(0, 0, 0)
end

-- ACTIVAR LAG
local function activar()
    personajeActual = player.Character
    if not personajeActual then return false end

    local raiz = personajeActual:FindFirstChild("HumanoidRootPart")
    local humanoide = personajeActual:FindFirstChildOfClass("Humanoid")

    if not raiz or not humanoide then return false end

    local archivableAnterior = personajeActual.Archivable
    personajeActual.Archivable = true
    clon = personajeActual:Clone()
    personajeActual.Archivable = archivableAnterior

    if not clon then return false end

    clon.Name = "LagClone"

    for _, objeto in ipairs(clon:GetDescendants()) do
        if objeto:IsA("Script") or objeto:IsA("LocalScript") then
            objeto:Destroy()
        elseif objeto:IsA("BasePart") then
            objeto.Anchored = true
            objeto.CanCollide = false
        elseif objeto:IsA("Humanoid") then
            objeto.DisplayDistanceType =
                Enum.HumanoidDisplayDistanceType.None
        end
    end

    clon.Parent = workspace

    -- Ocultar personaje original localmente
    for _, objeto in ipairs(personajeActual:GetDescendants()) do
        if objeto:IsA("BasePart")
        or objeto:IsA("Decal")
        or objeto:IsA("Texture") then
            transparencias[objeto] = objeto.Transparency
            objeto.Transparency = 1
        end
    end

    tiempo = 0

    conexion = RunService.RenderStepped:Connect(function(dt)
        if not activo or not clon or not clon.Parent then
            return
        end

        if not personajeActual or not personajeActual.Parent then
            return
        end

        local raizActual =
            personajeActual:FindFirstChild("HumanoidRootPart")

        if not raizActual then return end

        tiempo += dt

        local angulo = tiempo * 18
        local x = math.cos(angulo) * distancia
        local z = math.sin(angulo) * distancia
        local y = 5 + math.abs(math.sin(tiempo * 22)) * 12

        local posicion = raizActual.Position
            + Vector3.new(x, y, z)

        -- Clon derecho, sin rotación sobre sí mismo
        clon:PivotTo(CFrame.new(posicion))
    end)

    return true
end

-- BOTON LAG
boton.Activated:Connect(function()
    -- No activar si el último gesto fue arrastrar
    if movimientoRealizado then
        movimientoRealizado = false
        return
    end

    if activo then
        desactivar()
        return
    end

    activo = true
    boton.BackgroundColor3 = Color3.new(0, 0, 0)
    boton.TextColor3 = Color3.new(1, 1, 1)

    if not activar() then
        desactivar()
    end
end)

-- LIMPIAR AL REAPARECER
player.CharacterAdded:Connect(function()
    desactivar()
end)
