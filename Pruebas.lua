--[[ ============================================================
     BOTÓN "LAG" — Script LOCAL
     Ubicación: StarterPlayer > StarterPlayerScripts
     ------------------------------------------------------------
     • Botón pequeño negro con letra blanca "lag"
     • Al activarlo: tu personaje se vuelve invisible y aparece
       un clon con tu mismo vestuario moviéndose súper rápido
       (teleportes erráticos = efecto lag). El botón se pone morado.
     • Al volver a tocarlo: todo se desactiva y el botón vuelve a negro.
     ============================================================ ]]

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== INTERFAZ (GUI) ==================
local gui = Instance.new("ScreenGui")
gui.Name           = "LagGui"
gui.ResetOnSpawn   = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = playerGui

local boton = Instance.new("TextButton")
boton.Name             = "BotonLag"
boton.Size             = UDim2.new(0, 60, 0, 28)   -- botón pequeño
boton.Position         = UDim2.new(0, 16, 0, 16)
boton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)    -- negro
boton.TextColor3       = Color3.fromRGB(255, 255, 255) -- letras blancas
boton.Text             = "lag"
boton.Font             = Enum.Font.SourceSansBold
boton.TextSize         = 16
boton.BorderSizePixel  = 0
boton.AutoButtonColor  = false
boton.Parent           = gui

local COLOR_NORMAL = Color3.fromRGB(0, 0, 0)
local COLOR_ACTIVO = Color3.fromRGB(128, 0, 128)     -- morado

-- ================== ESTADO ==================
local activo         = false
local clon           = nil
local conexionMov    = nil
local transparencias = {}  -- guarda [parte] = transparencia original

-- ================== FUNCIONES ==================

-- Devuelve la transparencia original de tu personaje
local function restaurarPersonaje()
	local char = player.Character
	if not char then return end
	for parte, valor in pairs(transparencias) do
		if parte and parte.Parent then
			parte.Transparency = valor
		end
	end
	transparencias = {}
end

-- Vuelve invisible a tu personaje (solo en tu pantalla)
local function ocultarPersonaje()
	local char = player.Character
	if not char then return end
	transparencias = {}
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			transparencias[obj] = obj.Transparency
			obj.Transparency = 1
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			transparencias[obj] = obj.Transparency
			obj.Transparency = 1
		end
	end
end

-- Crea el clon con tu mismo vestuario
local function crearClon()
	local char = player.Character
	if not char then return nil, nil end

	local copia = char:Clone()
	copia.Name  = "ClonLag"

	for _, obj in ipairs(copia:GetDescendants()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then
			obj:Destroy() -- quitar scripts para que no interfieran
		elseif obj:IsA("BasePart") then
			obj.CanCollide   = false
			obj.Anchored     = false
			obj.Transparency = 0 -- que se vea bien
		end
	end

	local hum = copia:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.DisplayName  = "lag"
		hum.PlatformStand = true
	end

	local root = copia:FindFirstChild("HumanoidRootPart")
		or copia:FindFirstChildWhichIsA("BasePart")
	if root then
		root.Anchored   = true
		root.CanCollide = false
	end

	copia.Parent = workspace
	return copia, root
end

-- Movimiento errático y rapidísimo (efecto lag)
local function iniciarMovimiento(clonObj, root)
	conexionMov = RunService.Heartbeat:Connect(function()
		if not (clonObj and clonObj.Parent and root and root.Parent) then
			return
		end

		local char    = player.Character
		local miRoot  = char and char:FindFirstChild("HumanoidRootPart")
		local base    = miRoot and miRoot.CFrame or root.CFrame

		-- saltos aleatorios cada frame → parece lag/glitch
		local angulo = math.random() * math.pi * 2
		local radio  = math.random(2, 12)
		local altura = math.random(-2, 4)

		local offset = Vector3.new(
			math.cos(angulo) * radio,
			altura,
			math.sin(angulo) * radio
		)

		root.CFrame = base
			* CFrame.new(offset)
			* CFrame.Angles(0, math.random() * math.pi * 2, 0)
	end)
end

-- Activar / Desactivar
local function desactivar()
	activo = false
	boton.BackgroundColor3 = COLOR_NORMAL

	if conexionMov then
		conexionMov:Disconnect()
		conexionMov = nil
	end
	if clon then
		clon:Destroy()
		clon = nil
	end

	restaurarPersonaje()
end

local function activar()
	activo = true
	boton.BackgroundColor3 = COLOR_ACTIVO

	-- 1) Primero el clon (para que copie tu vestuario visible)
	local c, root = crearClon()
	if c and root then
		clon = c
		iniciarMovimiento(c, root)
	end

	-- 2) Luego te ocultas tú
	ocultarPersonaje()
end

-- ================== EVENTOS ==================
boton.MouseButton1Click:Connect(function()
	if activo then
		desactivar()
	else
		activar()
	end
end)

-- Si mueres o respawneas, se limpia todo automáticamente
player.CharacterAdded:Connect(function()
	if activo then
		desactivar()
	end
end)