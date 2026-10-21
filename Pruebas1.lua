
-- BOTON LAG - LocalScript
-- Para tu propio juego en Roblox Studio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local activo = false
local personaje
local clon
local conexion
local partesOriginales = {}
local transparenciaOriginal = {}
local distancia = 30
local tiempo = 0

-- Interfaz
local gui = Instance.new("ScreenGui")
gui.Name = "LagButtonGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local boton = Instance.new("TextButton")
boton.Name = "LAG"
boton.Size = UDim2.new(0, 75, 0, 45)
boton.Position = UDim2.new(1, -90, 0.4, 0)
boton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
boton.TextColor3 = Color3.fromRGB(0, 0, 0)
boton.Text = "LAG"
boton.TextSize = 18
boton.Font = Enum.Font.GothamBold
boton.Parent = gui

local esquina = Instance.new("UICorner")
esquina.CornerRadius = UDim.new(0, 10)
esquina.Parent = boton

local borde = Instance.new("UIStroke")
borde.Color = Color3.fromRGB(0, 0, 0)
borde.Thickness = 2
borde.Parent = boton

local function restaurar()
    if conexion then
        conexion:Disconnect()
        conexion = nil
    end

    if clon then
        clon:Destroy()
        clon = nil
    end

    for parte, transparencia in pairs(transparenciaOriginal) do
        if parte and parte.Parent then
            parte.Transparency = transparencia
        end
    end

    transparenciaOriginal = {}
    partesOriginales = {}
end

local function activar()
    personaje = player.Character
    if not personaje then return end

    local humanoide = personaje:FindFirstChildOfClass("Humanoid")
    local raiz = personaje:FindFirstChild("HumanoidRootPart")
    if not humanoide or not raiz then return end

    -- Crear una copia con el mismo aspecto
    personaje.Archivable = true
    clon = personaje:Clone()
    clon.Name = "LagClone"

    for _, objeto in ipairs(clon:GetDescendants()) do
        if objeto:IsA("Script") or objeto:IsA("LocalScript") then
            objeto:Destroy()
        elseif objeto:IsA("BasePart") then
            objeto.Anchored = true
            objeto.CanCollide = false
        end
    end

    clon.Parent = workspace

    -- Ocultar el personaje original localmente
    for _, objeto in ipairs(personaje:GetDescendants()) do
        if objeto:IsA("BasePart") then
            transparenciaOriginal[objeto] = objeto.Transparency
            objeto.Transparency = 1
        elseif objeto:IsA("Decal") or objeto:IsA("Texture") then
            transparenciaOriginal[objeto] = objeto.Transparency
            objeto.Transparency = 1
        end
    end

    tiempo = 0

    conexion = RunService.RenderStepped:Connect(function(dt)
        if not activo or not personaje.Parent or not clon or not clon.Parent then
            return
        end

        local raizActual = personaje:FindFirstChild("HumanoidRootPart")
        if not raizActual then return end

        tiempo += dt * 12

        local x = math.cos(tiempo) * distancia
        local z = math.sin(tiempo) * distancia
        local y = math.abs(math.sin(tiempo * 2)) * 12

        local posicion = raizActual.Position + Vector3.new(x, y, z)
        clon:PivotTo(CFrame.new(posicion) * CFrame.Angles(0, -tiempo, 0))
    end)
end

local function desactivar()
    restaurar()
end

boton.Activated:Connect(function()
    activo = not activo

    if activo then
        boton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        boton.TextColor3 = Color3.fromRGB(255, 255, 255)
        activar()

        -- Si no se pudo activar, vuelve al estado inactivo
        if not clon then
            activo = false
            boton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            boton.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
    else
        desactivar()
        boton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        boton.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

player.CharacterAdded:Connect(function()
    activo = false
    restaurar()
    boton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    boton.TextColor3 = Color3.fromRGB(0, 0, 0)
end)
