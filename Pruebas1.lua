--=============================================================
--  BOTÓN "LAG" - CLON LOCO + INVISIBILIDAD
--  LocalScript → StarterPlayer > StarterPlayerScripts
--=============================================================

local Players    = game:GetService("Players")
local Workspace  = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--==================== CONFIGURACIÓN ==========================
local CONFIG = {
	TAMANO_BOTON          = 70,
	TAMANO_L              = 20,
	UMBRAL_ARRASTRE       = 12,
	POSICION_INICIAL      = UDim2.fromScale(0.5, 0.5),

	RADIO_PIES            = 30,    -- radio de la órbita (pies)
	STUDS_POR_PIE         = 0.93,  -- 1 pie ≈ 0.93 studs
	VELOCIDAD_ANGULAR     = 7,     -- rad/s
	FRECUENCIA_OSCILACION = 4,     -- subidas/bajadas por vuelta
	ALTURA_OSCILACION     = 6,     -- studs de rango vertical
}

--==================== COLORES ================================
local COLOR = {
	fondo       = Color3.fromRGB(0, 0, 0),
	texto       = Color3.fromRGB(255, 255, 255),
	L_libre     = Color3.fromRGB(40, 170, 80),
	L_bloqueado = Color3.fromRGB(200, 55, 55),
}

--==================== ESTADO =================================
local estado = {
	centro         = Vector2.new(0, 0),
	bloqueado      = false,
	arrastrando    = false,
	recorrido      = 0,
	activo         = false,
	clon           = nil,
	conexion       = nil,
	transparencias = {},
}

--==================== INTERFAZ ===============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LagButtonGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.Parent = player:WaitForChild("PlayerGui")

local boton = Instance.new("TextButton")
boton.Name = "LagButton"
boton.AnchorPoint = Vector2.new(0.5, 0.5)
boton.Position = CONFIG.POSICION_INICIAL
boton.Size = UDim2.fromOffset(CONFIG.TAMANO_BOTON, CONFIG.TAMANO_BOTON)
boton.BackgroundColor3 = COLOR.fondo
boton.BorderSizePixel = 0
boton.AutoButtonColor = false
boton.Text = "LAG"
boton.TextColor3 = COLOR.texto
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

--==================== CLON LOCO ==============================
local function crearClon()
	local personaje = player.Character
	if not personaje then return nil end

	local clon = personaje:Clone()
	clon.Name = "ClonLoco"

	for _, obj in ipairs(clon:GetDescendants()) do
		if obj:IsA("BaseScript") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
			obj:Destroy()
		end
	end

	local hum = clon:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.PlatformStand = true
		hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
	for _, obj in ipairs(clon:GetDescendants()) do
		if obj:IsA("BasePart") then obj.CanCollide = false end
	end
	local hrp = clon:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Anchored = true end

	clon.Parent = Workspace
	return clon
end

local function ocultarPersonaje()
	estado.transparencias = {}
	local personaje = player.Character
	if not personaje then return end
	for _, obj in ipairs(personaje:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
			estado.transparencias[obj] = obj.Transparency
			obj.Transparency = 1
		end
	end
end

local function mostrarPersonaje()
	for obj, trans in pairs(estado.transparencias) do
		if obj and obj.Parent then
			obj.Transparency = trans
		end
	end
	estado.transparencias = {}
end

local function activar()
	estado.activo = true
	estado.clon = crearClon()
	if not estado.clon then
		estado.activo = false
		return
	end

	ocultarPersonaje()

	local hrpClon = estado.clon:FindFirstChild("HumanoidRootPart")
	if not hrpClon then return end

	local radio = CONFIG.RADIO_PIES * CONFIG.STUDS_POR_PIE
	local angulo = 0

	estado.conexion = RunService.Heartbeat:Connect(function(dt)
		local personaje = player.Character
		if not personaje or not estado.clon or not estado.clon.Parent then return end
		local hrp = personaje:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		angulo += dt * CONFIG.VELOCIDAD_ANGULAR

		local oscilacionY = math.sin(angulo * CONFIG.FRECUENCIA_OSCILACION) * CONFIG.ALTURA_OSCILACION

		local pos = hrp.Position + Vector3.new(
			math.cos(angulo) * radio,
			oscilacionY,
			math.sin(angulo) * radio
		)

		local diff = hrp.Position - pos
		diff = Vector3.new(diff.X, 0, diff.Z)
		local cf
		if diff.Magnitude > 0.01 then
			cf = CFrame.lookAt(pos, pos + diff.Unit)
		else
			cf = CFrame.new(pos)
		end

		hrpClon.CFrame = cf
	end)
end

local function desactivar()
	estado.activo = false
	if estado.conexion then
		estado.conexion:Disconnect()
		estado.conexion = nil
	end
	if estado.clon then
		estado.clon:Destroy()
		estado.clon = nil
	end
	mostrarPersonaje()
end

local function toggle()
	if estado.activo then desactivar() else activar() end
end

--==================== ENTRADA DEL BOTÓN ======================
boton.InputBegan:Connect(function(input)
	if not esEntradaValida(input) then return end
	if puntaEnBotonL(input) then return end
	estado.arrastrando = true
	estado.recorrido = 0
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
	if estado.recorrido <= CONFIG.UMBRAL_ARRASTRE then
		toggle()
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
local vpIni = tamanoPantalla()
fijarCentro(Vector2.new(
	CONFIG.POSICION_INICIAL.X.Scale * vpIni.X + CONFIG.POSICION_INICIAL.X.Offset,
	CONFIG.POSICION_INICIAL.Y.Scale * vpIni.Y + CONFIG.POSICION_INICIAL.Y.Offset
))

player.CharacterAdded:Connect(function()
	if estado.activo then desactivar() end
end)

local cam = Workspace.CurrentCamera
if cam then
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		fijarCentro(estado.centro)
	end)
end