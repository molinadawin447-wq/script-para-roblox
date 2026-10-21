
-- MINI HUB: SPEED + TP
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MiniHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local bloqueados = {}
local arrastres = {}
local botones = {}

local function crearBoton(nombre, posicion)
    local boton = Instance.new("TextButton")
    boton.Name = nombre
    boton.Size = UDim2.fromOffset(100, 45)
    boton.Position = posicion
    boton.BackgroundColor3 = Color3.new(1, 1, 1)
    boton.TextColor3 = Color3.new(0, 0, 0)
    boton.Text = nombre
    boton.TextSize = 16
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

    local candado = Instance.new("TextButton")
    candado.Name = "Candado"
    candado.Size = UDim2.fromOffset(22, 20)
    candado.Position = UDim2.new(1, 3, 0, -6)
    candado.AnchorPoint = Vector2.new(1, 0)
    candado.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    candado.Text = "🔓"
    candado.TextSize = 12
    candado.ZIndex = 3
    candado.Parent = boton

    local redondeo = Instance.new("UICorner")
    redondeo.CornerRadius = UDim.new(0, 5)
    redondeo.Parent = candado

    bloqueados[boton] = false
    botones[nombre] = boton

    candado.Activated:Connect(function()
        bloqueados[boton] = not bloqueados[boton]
        candado.Text = bloqueados[boton] and "🔒" or "🔓"
        candado.BackgroundColor3 = bloqueados[boton]
            and Color3.fromRGB(120, 120, 120)
            or Color3.fromRGB(220, 220, 220)

        if bloqueados[boton] then
            arrastres[boton] = nil
        end
    end)

    boton.InputBegan:Connect(function(input)
        if bloqueados[boton] then return end

        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            arrastres[boton] = {
                input = input,
                inicio = input.Position,
                posicion = boton.Position,
                movido = false
            }
        end
    end)

    return boton
end

UserInputService.InputChanged:Connect(function(input)
    for boton, data in pairs(arrastres) do
        if not bloqueados[boton]
        and (input == data.input
        or input.UserInputType == Enum.UserInputType.MouseMovement) then

            local delta = input.Position - data.inicio

            if delta.Magnitude > 6 then
                data.movido = true
            end

            if data.movido then
                local camera = workspace.CurrentCamera
                if not camera then return end

                local size = camera.ViewportSize
                local x = math.clamp(
                    data.posicion.X.Offset + delta.X,
                    0, size.X - boton.AbsoluteSize.X
                )
                local y = math.clamp(
                    data.posicion.Y.Offset + delta.Y,
                    0, size.Y - boton.AbsoluteSize.Y
                )

                boton.Position = UDim2.fromOffset(x, y)
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    for boton, data in pairs(arrastres) do
        if input == data.input
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            arrastres[boton] = nil
        end
    end
end)

local function conectarAccion(boton, accion)
    boton.Activated:Connect(function()
        local data = arrastres[boton]
        if data and data.movido then
            data.movido = false
            return
        end
        accion()
    end)
end

-- BOTONES
local speed = crearBoton(
    "SPEED",
    UDim2.new(1, -110, 0.30, 0)
)

local tp = crearBoton(
    "TP",
    UDim2.new(1, -110, 0.30, 55)
)

-- CAMPO DE VELOCIDAD
local entrada = Instance.new("TextBox")
entrada.Name = "SpeedInput"
entrada.Size = UDim2.fromOffset(100, 40)
entrada.Position = UDim2.new(1, -110, 0.30, 110)
entrada.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
entrada.TextColor3 = Color3.new(1, 1, 1)
entrada.PlaceholderText = "Velocidad 30-60"
entrada.Text = "30"
entrada.TextSize = 14
entrada.Font = Enum.Font.Gotham
entrada.ClearTextOnFocus = false
entrada.Parent = gui

local esquinaEntrada = Instance.new("UICorner")
esquinaEntrada.CornerRadius = UDim.new(0, 8)
esquinaEntrada.Parent = entrada

local velocidad = 30

local function aplicarVelocidad()
    local numero = tonumber(entrada.Text)

    if not numero then
        entrada.Text = tostring(velocidad)
        return
    end

    velocidad = math.clamp(numero, 30, 60)
    entrada.Text = tostring(velocidad)

    local personaje = player.Character
    local humanoide = personaje
        and personaje:FindFirstChildOfClass("Humanoid")

    if humanoide then
        humanoide.WalkSpeed = velocidad
    end
end

entrada.FocusLost:Connect(aplicarVelocidad)
conectarAccion(speed, aplicarVelocidad)

player.CharacterAdded:Connect(function(personaje)
    personaje:WaitForChild("Humanoid").WalkSpeed = velocidad
end)

-- TP: BUSCAR MiBase Y TELETRANSPORTARSE DELANTE
local tpOcupado = false

conectarAccion(tp, function()
    if tpOcupado then return end

    tpOcupado = true
    tp.BackgroundColor3 = Color3.new(0, 0, 0)

    local exito, errorTP = pcall(function()
        local personaje = player.Character
        if not personaje then
            error("No se encontró el personaje.")
        end

        local base = workspace:FindFirstChild("MiBase", true)

        if not base or not base:IsA("BasePart") then
            error("Crea una pieza BasePart llamada MiBase en tu propio juego.")
        end

        -- Posición delante de la base
        local destino = base.CFrame * CFrame.new(
            0,
            3,
            -(base.Size.Z / 2 + 4)
        )

        personaje:PivotTo(destino)
    end)

    tp.BackgroundColor3 = Color3.new(1, 1, 1)
    tpOcupado = false

    if not exito then
        warn("TP: " .. tostring(errorTP))
    end
end)

print("MiniHub cargado: SPEED + TP")
