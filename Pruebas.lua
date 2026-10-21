--=============================================================
--  BOTÓN "SPEED" ARRASTRABLE + TELETRANSPORTE
--  LocalScript → StarterPlayer > StarterPlayerScripts
--=============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

--==================== CONFIGURACIÓN ==========================
local CONFIG = {
	PIES_POR_SALTO  = 4,      -- pies que avanza por toque
	STUDS_POR_PIE   = 0.93,   -- 1 pie ≈ 0.93 studs (pon 1 si usas 1 stud = 1 pie)
	TAMANO_BOTON    = 70,     -- tamaño del cuadrado en píxeles
	TAMANO_L        = 20,     -- tamaño de la "L"
	UMBRAL_ARRASTRE = 12,     -- píxeles de movimiento para contar como arrastre
}

local DISTANCIA = CONFIG.PIES_POR_SALTO * CONFIG.STUDS_POR_PIE

--==================== COLORES ================================
local COLOR = {
	fondoNormal   = Color3.fromRGB(0, 0, 0),
	textoNormal   = Color3.fromRGB(255, 255, 255),
	fondoPresion  = Color3.fromRGB(255, 255, 255),
	textoPresion  = Color3.fromRGB(0, 0, 0),
	L_libre       = Color3.fromRGB(40, 170, 80),
	L_bloqueado   = Color3.fromRGB(200, 55, 55),
}

--==================== ESTADO =================================
local estado = {
	centro      = Vector2.new(0, 0),
	bloqueado   = false,
	arrastrando = false,
	recorrido   = 0,
	presionado  = false,
}

--==================== INTERFAZ ===============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedButtonGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botón principal
local boton = Instance.new("TextButton")
boton.Name = "SpeedButton"
boton.AnchorPoint = Vector2.new(0.5, 0.5)
boton.Position = UDim2.fromScale(0.5, 0.5)
boton.Size = UDim2.fromOffset(CONFIG.TAMANO_BOTON, CONFIG.TAMANO_BOTON)
boton.BackgroundColor3 = COLOR.fondoNormal
boton.BorderSizePixel = 0
boton.AutoButtonColor = false
boton.Text = "SPEED"
boton.TextColor3 = COLOR.textoNormal
boton.Font = Enum.Font.GothamBold
boton.TextScaled = true
boton.ZIndex = 2
boton.Parent = screenGui

local borde = Instance.new("UIStroke")
borde.Color = Color3.fromRGB(255, 255, 255)
borde.Thickness = 2
borde.Transparency = 0.55
borde.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borde.Parent = boton

-- Botón "L" (arriba a la derecha)
local botonL = Instance.new("TextButton")
botonL.Name = "LockButton"
botonL.AnchorPoint = Vector2.new(0, 0)
botonL.Size = UDim2.fromOffset(CONFIG.TAMANO_L, CONFIG.TAMANO_L)
botonL.BackgroundColor3 = COLOR.L_libre
botonL.BorderSizePixel = 0
botonL.AutoButtonColor = false
botonL.Text = "L"
botonL.TextColor3 = Color3.fromRGB(255, 255, 255)
botonL.Font = Enum.Font.GothamBold
botonL.TextScaled = true
botonL.ZIndex = 3
botonL.Parent = screenGui

local bordeL = borde:Clone()
bordeL.Transparency = 0.3
bordeL.Parent = botonL

--==================== UTILIDADES =============================
local function tamanoPantalla()
	local cam = Workspace.CurrentCamera
	if cam then return cam.ViewportSize end
	return Vector2.new(1280, 720)
end

local function posicionarL()
	local p = boton.Position
	local mitad = CONFIG.TAMANO_BOTON / 2
	local mL = CONFIG.TAMANO_L / 2
	botonL.Position = UDim2.new(
		p.X.Scale, p.X.Offset + mitad - mL,
		p.Y.Scale, p.Y.Offset - mitad - mL
	)
end

local function fijarCentro(nuevoCentro)
	local vp = tamanoPantalla()
	local mitad = CONFIG.TAMANO_BOTON / 2
	estado.centro = Vector2.new(
		math.clamp(nuevoCentro.X, mitad, math.max(mitad, vp.X - mitad)),
		math.clamp(nuevoCentro.Y, mitad, math.max(mitad, vp.Y - mitad))
	)
	boton.Position = UDim2.fromOffset(estado.centro.X, estado.centro.Y)
	posicionarL()
end

local function aplicarVisual()
	if estado.presionado then
		boton.BackgroundColor3 = COLOR.fondoPresion
		boton.TextColor3 = COLOR.textoPresion
	else
		boton.BackgroundColor3 = COLOR.fondoNormal
		boton.TextColor3 = COLOR.textoNormal
	end
end

local function esEntradaValida(input)
	return input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1
end

local function puntaEnBotonL(input)
	local p = botonL.AbsolutePosition
	local s = botonL.AbsoluteSize
	local pos = input.Position
	return pos.X >= p.X and pos.X <= p.X + s.X
		and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

--==================== TELETRANSPORTE =========================
local function teletransportar()
	local personaje = player.Character
	if not personaje then return false end

	local hrp = personaje:FindFirstChild("HumanoidRootPart")
	local humanoide = personaje:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoide or humanoide.Health <= 0 then return false end

	local dir = hrp.CFrame.LookVector
	dir = Vector3.new(dir.X, 0, dir.Z)
	if dir.Magnitude < 0.01 then
		dir = Vector3.new(0, 0, -1)
	end
	dir = dir.Unit

	hrp.CFrame = hrp.CFrame + dir * DISTANCIA
	return true
end

local function usarBoton()
	teletransportar()
end

--==================== ENTRADA DEL BOTÓN ======================
boton.InputBegan:Connect(function(input)
	if not esEntradaValida(input) then return end
	if puntaEnBotonL(input) then return end

	estado.arrastrando = true
	estado.recorrido = 0
	estado.presionado = true
	aplicarVisual()
end)

boton.InputChanged:Connect(function(input)
	if not estado.arrastrando then return end
	if input.UserInputType ~= Enum.UserInputType.Touch
		and input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	local d = input.Delta
	estado.recorrido += d.Magnitude

	if estado.recorrido > CONFIG.UMBRAL_ARRASTRE and not estado.bloqueado then
		fijarCentro(estado.centro + Vector2.new(d.X, d.Y))
	end
end)

boton.InputEnded:Connect(function(input)
	if not esEntradaValida(input) then return end
	if not estado.arrastrando then return end

	estado.arrastrando = false
	local fueToque = estado.recorrido <= CONFIG.UMBRAL_ARRASTRE
	estado.presionado = false
	aplicarVisual()

	if fueToque then
		usarBoton()
	end
end)

--==================== BOTÓN "L" (BLOQUEO) ====================
botonL.InputBegan:Connect(function(input)
	if not esEntradaValida(input) then return end

	estado.bloqueado = not estado.bloqueado

	if estado.bloqueado then
		botonL.BackgroundColor3 = COLOR.L_bloqueado
	else
		botonL.BackgroundColor3 = COLOR.L_libre
	end
end)

--==================== INICIO =================================
fijarCentro(tamanoPantalla() / 2)
aplicarVisual()

local cam = Workspace.CurrentCamera
if cam then
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		fijarCentro(estado.centro)
	end)
end