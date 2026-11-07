-- KR7 PANEL (versión reescrita) - Script Lua local (Roblox)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ===================== UTILIDADES =====================
local function nuevo(clase, props, padre)
	local o = Instance.new(clase)
	for k, v in pairs(props) do o[k] = v end
	if padre then o.Parent = padre end
	return o
end

local function redondear(obj, r)
	return nuevo("UICorner", { CornerRadius = UDim.new(0, r) }, obj)
end

local function imagenLocal(...)
	if typeof(getcustomasset) ~= "function" or typeof(isfile) ~= "function" then return "" end
	for _, nombre in ipairs({ ... }) do
		local ok, res = pcall(function()
			if isfile(nombre) then return getcustomasset(nombre) end
		end)
		if ok and res then return res end
	end
	return ""
end

-- ===================== GUARDADO =====================
local ARCHIVO = "KR7_ajustes.json"
local ajustes = { toggles = {}, nums = {}, botones = {}, pos = {}, cont = nil, panelPos = nil, panelAbierto = false }

local puedeGuardar = typeof(writefile) == "function"
	and typeof(readfile) == "function"
	and typeof(isfile) == "function"
local guardadoBloqueado = false

if puedeGuardar then
	local ok, datos = pcall(function()
		if isfile(ARCHIVO) then return HttpService:JSONDecode(readfile(ARCHIVO)) end
	end)
	if ok and type(datos) == "table" then
		for _, campo in ipairs({ "toggles", "nums", "botones", "pos" }) do
			if type(datos[campo]) == "table" then ajustes[campo] = datos[campo] end
		end
		if type(datos.cont) == "table" then ajustes.cont = datos.cont end
		if type(datos.panelPos) == "table" then ajustes.panelPos = datos.panelPos end
		if type(datos.panelAbierto) == "boolean" then ajustes.panelAbierto = datos.panelAbierto end
	end
end

local function guardar()
	if not puedeGuardar or guardadoBloqueado then return end
	pcall(function() writefile(ARCHIVO, HttpService:JSONEncode(ajustes)) end)
end

local function borrarAjustes()
	guardadoBloqueado = true
	if typeof(delfile) == "function" and typeof(isfile) == "function" then
		pcall(function() if isfile(ARCHIVO) then delfile(ARCHIVO) end end)
	end
end

-- ===================== PANTALLA =====================
local ScreenGui = nuevo("ScreenGui", {
	Name = "PanelBotones",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 2147483647,
}, player:WaitForChild("PlayerGui"))

local TAM, GAP = 70, 3
local MARGEN_IZQUIERDA, MARGEN_ARRIBA = 40, 40
local ancho = TAM * 4 + GAP * 3
local alto = TAM * 4 + GAP * 3
local posContDefault = UDim2.new(0, MARGEN_IZQUIERDA, 0, MARGEN_ARRIBA)

local contenedor = nuevo("Frame", {
	Name = "Contenedor",
	Size = UDim2.new(0, ancho, 0, alto),
	Position = posContDefault,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, ScreenGui)

do
	local c = ajustes.cont
	if c and type(c.xs) == "number" and type(c.xo) == "number"
		and type(c.ys) == "number" and type(c.yo) == "number" then
		contenedor.Position = UDim2.new(c.xs, c.xo, c.ys, c.yo)
	end
end

local function pos(col, fila)
	return UDim2.new(0, col * (TAM + GAP), 0, fila * (TAM + GAP))
end

local textos = {
	"RESET", "TP\nBAT", "BAT\nBYPASS", "DROP\nBR", "BAT\nNORMAL", "TP\nDOWN",
	"LAGGER\nNORMAL", "AUTO\nLEFT", "AUTO\nRIGHT", "CARRY\nSPD", "LAGGER\nCARRY",
}
local posiciones = {
	pos(0, 0), pos(1, 0), pos(1, 1), pos(2, 0), pos(2, 1),
	pos(2, 2), pos(2, 3), pos(3, 0), pos(3, 1), pos(3, 2), pos(3, 3),
}

local NEGRO_PURO = Color3.fromRGB(0, 0, 0)
local BLANCO = Color3.fromRGB(255, 255, 255)
local GRIS_BORDE = Color3.fromRGB(150, 150, 150)
local MORADO = Color3.fromRGB(140, 60, 200)
local MORADO_CLARO = Color3.fromRGB(170, 100, 230)
local MORADO_OSCURO = Color3.fromRGB(80, 20, 130)
local MORADO_TEXTO = Color3.fromRGB(170, 80, 230)

local DURACION_CORTA = 0.15
local DURACION_LARGA = 30 * 60

-- ===================== ESTADO =====================
local S = {
	modo = nil,
	tpBat = false,
	batNormal = false,
	carryAuto = false,
	carryPorAuto = false,
	carryManual = false,
	autoLeft = false,
	autoRight = false,
	infJump = ajustes.toggles["Speed/Infinite Jump"] == true,
	esp = false,
	dropModo = (ajustes.toggles["Custom/Drop Mode"] == "Tap Drop") and "tap" or "jump",
	objetivo = nil,
	velJuego = nil,
	usandoMia = false,
	saltoPresionado = false,
	ultimoSalto = 0,
}

local CLAVE_VEL = {
	normal = "Speed/Normal Speed",
	carry = "Speed/Carry Speed",
	lagger = "Speed/Lagger Speed",
	laggerCarry = "Speed/Lagger Carry Spd",
}
local DEF_VEL = { normal = 30, carry = 29, lagger = 15, laggerCarry = 24.5 }
local modoDe = {
	["CARRY\nSPD"] = "carry",
	["LAGGER\nNORMAL"] = "lagger",
	["LAGGER\nCARRY"] = "laggerCarry",
}

local function velocidadObjetivo()
	local modo = S.modo or "normal"
	local v = ajustes.nums[CLAVE_VEL[modo]]
	if type(v) ~= "number" then v = DEF_VEL[modo] end
	return v
end

local function velocidadBatNormal()
	local v = ajustes.nums["Custom/Bat Aimbot Speed"]
	if type(v) ~= "number" then v = 58 end
	return v
end

-- ===================== BASES / BRAINROTS =====================
local obtenerBase, puntoDeBase, primerBrainrotDeBase
do
	local cache = {}

	local function esBaseDe(obj, jn)
		local n = string.lower(obj.Name)
		return string.find(n, jn, 1, true) and (string.find(n, "base") or string.find(n, "plot"))
	end

	local function buscar(jug)
		local jn = string.lower(jug.Name)
		for _, nombreRaiz in ipairs({ "Bases", "Base", "Plots", "Plot", "Spawns", "TeamBases" }) do
			local r = workspace:FindFirstChild(nombreRaiz)
			if r then
				for _, obj in ipairs(r:GetChildren()) do
					if esBaseDe(obj, jn) then return obj end
					if obj:IsA("Folder") or obj:IsA("Model") then
						for _, sub in ipairs(obj:GetChildren()) do
							if esBaseDe(sub, jn) then return sub end
						end
					end
				end
			end
		end
		for _, obj in ipairs(workspace:GetDescendants()) do
			if (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart")) and esBaseDe(obj, jn) then
				return obj
			end
		end
		return nil
	end

	obtenerBase = function(jug)
		if not jug then return nil end
		local c = cache[jug]
		if c and ((c.obj and c.obj.Parent) or os.clock() - c.t < 3) then return c.obj end
		local obj = buscar(jug)
		cache[jug] = { obj = obj, t = os.clock() }
		return obj
	end

	Players.PlayerRemoving:Connect(function(p) cache[p] = nil end)

	puntoDeBase = function(base)
		if not base then return nil end
		if base:IsA("BasePart") then return base.Position end
		if base:IsA("Model") then
			if base.PrimaryPart then return base.PrimaryPart.Position end
			local pp = base:FindFirstChildWhichIsA("BasePart", true)
			if pp then return pp.Position end
		elseif base:IsA("Folder") then
			for _, d in ipairs(base:GetDescendants()) do
				if d:IsA("BasePart") then return d.Position end
			end
		end
		return nil
	end

	primerBrainrotDeBase = function(base)
		local centro = puntoDeBase(base)
		if not centro then return nil end
		local mejor, mejorDist = nil, math.huge
		for _, d in ipairs(base:GetDescendants()) do
			if d:IsA("BasePart") then
				local n = string.lower(d.Name)
				local p = string.lower(d.Parent and d.Parent.Name or "")
				if string.find(n, "brainrot") or string.find(p, "brainrot")
					or string.find(n, "pet") or string.find(p, "pet") then
					local dist = (d.Position - centro).Magnitude
					if dist < mejorDist then mejor, mejorDist = d, dist end
				end
			end
		end
		return mejor
	end
end

local function tieneBrainrotAgarrado()
	local char = player.Character
	if not char then return false end
	for _, d in ipairs(char:GetChildren()) do
		if string.find(string.lower(d.Name), "brainrot") then return true end
	end
	local mochila = player:FindFirstChildOfClass("Backpack")
	if mochila then
		for _, d in ipairs(mochila:GetChildren()) do
			if string.find(string.lower(d.Name), "brainrot") then return true end
		end
	end
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("Model") or d:IsA("Part") then
			local n = string.lower(d.Name)
			if string.find(n, "brainrot") or string.find(n, "pet") then return true end
		end
	end
	return false
end

local function calcularDestinoAuto()
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	if not raiz then return nil end

	local function destinoDe(base)
		if not base then return nil end
		local br = primerBrainrotDeBase(base)
		if br then return br.Position + Vector3.new(0, 3, 0) end
		local punto = puntoDeBase(base)
		if punto then return punto + Vector3.new(0, 3, 0) end
		return nil
	end

	if S.autoLeft then
		local baseEnemiga, mejorDist = nil, math.huge
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				local b = obtenerBase(p)
				local punto = b and puntoDeBase(b)
				if punto then
					local d = (punto - raiz.Position).Magnitude
					if d < mejorDist then mejorDist = d; baseEnemiga = b end
				end
			end
		end
		return destinoDe(baseEnemiga)
	elseif S.autoRight then
		return destinoDe(obtenerBase(player))
	end
	return nil
end

-- ===================== SALTO INFINITO =====================
local COOLDOWN_SALTO = 0.12

local function potenciaSalto(hum)
	if hum.UseJumpPower then
		return hum.JumpPower
	end
	return math.sqrt(2 * workspace.Gravity * hum.JumpHeight)
end

local function forzarSalto()
	if not S.infJump then return end
	local ahora = os.clock()
	if ahora - S.ultimoSalto < COOLDOWN_SALTO then return end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not raiz or hum.Health <= 0 then return end
	local vel = raiz.AssemblyLinearVelocity
	raiz.AssemblyLinearVelocity = Vector3.new(vel.X, potenciaSalto(hum), vel.Z)
	S.ultimoSalto = ahora
end

local function esTeclaSalto(input)
	return input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA
end

UIS.InputBegan:Connect(function(input, procesado)
	if esTeclaSalto(input) then S.saltoPresionado = true end
end)
UIS.InputEnded:Connect(function(input)
	if esTeclaSalto(input) then S.saltoPresionado = false end
end)

UIS.JumpRequest:Connect(forzarSalto)

task.spawn(function()
	local pg = player:WaitForChild("PlayerGui")
	local tg = pg:WaitForChild("TouchGui", 10)
	if not tg then return end
	local marco = tg:WaitForChild("TouchControlFrame", 10)
	local jb = marco and marco:WaitForChild("JumpButton", 10)
	if not jb then return end
	jb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			S.saltoPresionado = true
		end
	end)
	jb.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			S.saltoPresionado = false
		end
	end)
end)

-- ===================== TP DOWN / RESET =====================
local function tpDown()
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not raiz or not hum then return end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { char }
	local res = workspace:Raycast(raiz.Position, Vector3.new(0, -1000, 0), params)
	if not res then return end
	local altura = hum.HipHeight + raiz.Size.Y / 2
	local vel = raiz.AssemblyLinearVelocity
	local rot = raiz.CFrame - raiz.CFrame.Position
	raiz.CFrame = CFrame.new(res.Position + Vector3.new(0, altura, 0)) * rot
	raiz.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
end

local function resetPersonaje()
	if S.infJump and (os.clock() - S.ultimoSalto < 1) then return end
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if raiz then
		raiz.CFrame = CFrame.new(raiz.Position.X, workspace.FallenPartsDestroyHeight - 50, raiz.Position.Z)
	end
	if hum then hum.Health = 0 end
end

-- ===================== JUGADORES / ARMA =====================
local function jugadorMasCercano()
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	if not raiz then return nil end
	local mejor, mejorDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local r = p.Character:FindFirstChild("HumanoidRootPart")
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if r and h and h.Health > 0 then
				local d = (r.Position - raiz.Position).Magnitude
				if d < mejorDist then mejor, mejorDist = p, d end
			end
		end
	end
	return mejor
end

local function objetivoValido(p)
	if not p or not p.Parent or not p.Character then return false end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	return p.Character:FindFirstChild("HumanoidRootPart") ~= nil and h ~= nil and h.Health > 0
end

local function equiparArma()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end
	local equipada = char:FindFirstChildOfClass("Tool")
	if equipada then return equipada end
	local mochila = player:FindFirstChildOfClass("Backpack")
	if not mochila then return nil end
	local elegida = nil
	for _, t in ipairs(mochila:GetChildren()) do
		if t:IsA("Tool") then
			elegida = elegida or t
			if string.find(string.lower(t.Name), "bat") then elegida = t; break end
		end
	end
	if elegida then hum:EquipTool(elegida) end
	return elegida
end

local ultimoGolpe = 0
local DIST_TP = 6
local function perseguirYGolpear()
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not raiz or not hum then return end
	if not objetivoValido(S.objetivo) then
		S.objetivo = jugadorMasCercano()
		if not S.objetivo then return end
	end
	local rEnemigo = S.objetivo.Character.HumanoidRootPart
	local dist = (rEnemigo.Position - raiz.Position).Magnitude

	if dist > DIST_TP then
		local detras = rEnemigo.Position - rEnemigo.CFrame.LookVector * 2.5
		raiz.CFrame = CFrame.lookAt(detras, rEnemigo.Position)
		raiz.AssemblyLinearVelocity = Vector3.zero
	else
		raiz.CFrame = CFrame.lookAt(raiz.Position,
			Vector3.new(rEnemigo.Position.X, raiz.Position.Y, rEnemigo.Position.Z))
	end
	hum.PlatformStand = false

	local arma = equiparArma()
	if arma and arma.Parent == char and os.clock() - ultimoGolpe > 0.12 then
		ultimoGolpe = os.clock()
		arma:Activate()
	end
end

local DIST_BAT = 3.5
local ultimoGolpeNormal, ultimoRefresco = 0, 0
local colisionOriginal = {}
local sinColisionActivo = false

local function aplicarSinColision(char)
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("BasePart") then
			if colisionOriginal[d] == nil then colisionOriginal[d] = d.CanCollide end
			d.CanCollide = false
		end
	end
end

local function restaurarColision()
	for parte, valor in pairs(colisionOriginal) do
		if parte and parte.Parent then parte.CanCollide = valor end
		colisionOriginal[parte] = nil
	end
end

local function batNormalPerseguir(dt)
	local char = player.Character
	local raiz = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not raiz or not hum then return end

	if os.clock() - ultimoRefresco > 0.5 or not objetivoValido(S.objetivo) then
		ultimoRefresco = os.clock()
		S.objetivo = jugadorMasCercano()
	end
	if not objetivoValido(S.objetivo) then
		S.objetivo = nil
		return
	end

	local rEnemigo = S.objetivo.Character.HumanoidRootPart
	local hEnemigo = S.objetivo.Character:FindFirstChildOfClass("Humanoid")
	local dist = (rEnemigo.Position - raiz.Position).Magnitude

	local enAire = math.abs(rEnemigo.AssemblyLinearVelocity.Y) > 4
		or (hEnemigo and hEnemigo.FloorMaterial == Enum.Material.Air)
		or (rEnemigo.Position.Y - raiz.Position.Y) > 6

	local vel = velocidadBatNormal()
	hum.WalkSpeed = vel

	local dirPlano = Vector3.new(raiz.Position.X - rEnemigo.Position.X, 0, raiz.Position.Z - rEnemigo.Position.Z)
	if dirPlano.Magnitude < 0.1 then
		dirPlano = -rEnemigo.CFrame.LookVector
		dirPlano = Vector3.new(dirPlano.X, 0, dirPlano.Z)
		if dirPlano.Magnitude < 0.1 then dirPlano = Vector3.new(0, 0, 1) end
	end
	dirPlano = dirPlano.Unit
	local meta = rEnemigo.Position + dirPlano * DIST_BAT

	if dist > 0.5 then
		raiz.CFrame = CFrame.lookAt(raiz.Position,
			Vector3.new(rEnemigo.Position.X, raiz.Position.Y, rEnemigo.Position.Z))
	end

	if enAire then
		hum.PlatformStand = false
		local falta = meta - raiz.Position
		if falta.Magnitude > 0.3 then
			local paso = falta.Unit * math.min(vel * (dt or 0.016) * 1.5, falta.Magnitude)
			local nueva = raiz.Position + paso
			raiz.CFrame = CFrame.lookAt(nueva,
				Vector3.new(rEnemigo.Position.X, nueva.Y, rEnemigo.Position.Z))
		end
		raiz.AssemblyLinearVelocity = Vector3.zero
		raiz.AssemblyAngularVelocity = Vector3.zero
	else
		local distPlano = (Vector3.new(rEnemigo.Position.X, 0, rEnemigo.Position.Z)
			- Vector3.new(raiz.Position.X, 0, raiz.Position.Z)).Magnitude
		if distPlano > DIST_BAT + 0.3 then
			hum:MoveTo(meta)
		else
			hum:MoveTo(raiz.Position)
		end
	end

	local arma = equiparArma()
	if arma and arma.Parent == char and dist <= 8 and os.clock() - ultimoGolpeNormal > 0.12 then
		ultimoGolpeNormal = os.clock()
		arma:Activate()
	end
end

-- ===================== PLAYER ESP =====================
local setESP, actualizarESP
do
	local carpeta = nuevo("Folder", { Name = "KR7_ESP" }, ScreenGui)
	local cajas = {}

	local function crear(p)
		if not p or p == player or cajas[p] then return end
		local box = nuevo("Frame", {
			Name = "ESP_" .. p.Name, BackgroundTransparency = 1,
			BorderSizePixel = 0, Visible = false, ZIndex = 1,
		}, carpeta)
		nuevo("UIStroke", {
			Color = BLANCO, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, box)
		local lbl = nuevo("TextLabel", {
			Name = "Nombre", BackgroundTransparency = 1, Text = p.Name, TextColor3 = BLANCO,
			Font = Enum.Font.GothamBold, TextSize = 13, TextStrokeTransparency = 0.3,
			TextStrokeColor3 = NEGRO_PURO, Size = UDim2.new(1, 0, 0, 16),
			Position = UDim2.new(0, 0, 0, -18), ZIndex = 2,
		}, box)
		cajas[p] = { box = box, nombre = lbl }
	end

	local function quitar(p)
		local d = cajas[p]
		if d then
			if d.box then d.box:Destroy() end
			cajas[p] = nil
		end
	end

	setESP = function(estado)
		S.esp = estado
		if not estado then
			for p in pairs(cajas) do quitar(p) end
		else
			for _, p in ipairs(Players:GetPlayers()) do crear(p) end
		end
	end

	actualizarESP = function()
		local cam = workspace.CurrentCamera
		if not cam then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if hrp and hum and hum.Health > 0 then
					crear(p)
					local d = cajas[p]
					local posInf, v1 = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.2, 0))
					local posSup, v2 = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
					if v1 and v2 then
						local altoPx = math.abs(posInf.Y - posSup.Y)
						local anchoPx = altoPx * 0.55
						local cx = (posInf.X + posSup.X) / 2
						local cy = (posInf.Y + posSup.Y) / 2
						d.box.Visible = true
						d.box.Size = UDim2.new(0, anchoPx, 0, altoPx)
						d.box.Position = UDim2.new(0, cx - anchoPx / 2, 0, cy - altoPx / 2)
						d.nombre.Text = p.Name
					else
						d.box.Visible = false
					end
				elseif cajas[p] then
					cajas[p].box.Visible = false
				end
			end
		end
	end

	Players.PlayerAdded:Connect(function(p) if S.esp then crear(p) end end)
	Players.PlayerRemoving:Connect(quitar)
end

-- ===================== ANIM PACKS =====================
local ANIM_PACK_ORDER = {
	"Off", "Zombie", "Ninja", "Knight", "Elder", "Levitate",
	"Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish",
}
local setAnimPack
local packActual = "Off"

do
	local function id(n) return "rbxassetid://" .. n end
	local function pack(idle, walk, run, jump, fall, climb)
		return {
			idle1 = id(idle), idle2 = id(idle), walk = id(walk), run = id(run),
			jump = id(jump), fall = id(fall), climb = id(climb),
			swim = id(idle), swimidle = id(idle),
		}
	end

	local ANIM_PACKS = {
		Zombie = {
			idle1 = id(616158929), idle2 = id(616160636), walk = id(616168032),
			run = id(616163682), jump = id(616161997), fall = id(616157476),
			climb = id(616156119), swim = id(616165109), swimidle = id(616166655),
		},
		Ninja = pack(656117400, 656121766, 656118852, 656117878, 656115606, 656114359),
		Knight = pack(657595757, 657552124, 657564596, 658409194, 657600338, 658360781),
		Elder = pack(845397899, 845403856, 845386501, 845398858, 845397673, 845392038),
		Levitate = pack(616006778, 616013216, 616013216, 616008936, 616005863, 616003713),
		Astronaut = pack(891621366, 891636393, 891636393, 891627522, 891617961, 891609353),
		Pirate = pack(750781874, 750785693, 750783738, 750782230, 750780242, 750779899),
		Toy = pack(782841498, 782843345, 782842708, 782847020, 782846423, 782843869),
		Vampire = pack(1083445855, 1083473930, 1083462077, 1083455352, 1083443587, 1083439238),
		Werewolf = pack(1083195517, 1083178339, 1083216690, 1083218792, 1083189019, 1083182000),
		Rthro = pack(2510196951, 2510202577, 2510198475, 2510197830, 2510195892, 2510192778),
		Stylish = pack(616136790, 616146177, 616140816, 616139451, 616134815, 616133594),
	}

	local RUTAS = {
		{ "idle1", "idle", "Animation1" }, { "idle2", "idle", "Animation2" },
		{ "walk", "walk", "WalkAnim" }, { "run", "run", "RunAnim" },
		{ "jump", "jump", "JumpAnim" }, { "fall", "fall", "FallAnim" },
		{ "climb", "climb", "ClimbAnim" }, { "swim", "swim", "Swim" },
		{ "swimidle", "swimidle", "SwimIdle" },
	}

	local original = nil
	local conexion = nil

	local function obtener(an, r)
		local f = an:FindFirstChild(r[2])
		return f and f:FindFirstChild(r[3])
	end

	local function guardarOriginalAnim(char)
		local an = char:FindFirstChild("Animate")
		if not an then return end
		original = {}
		for _, r in ipairs(RUTAS) do
			local a = obtener(an, r)
			original[r[1]] = a and a.AnimationId or nil
		end
	end

	local function aplicar(char, p)
		local an = char:FindFirstChild("Animate")
		if not an then return end
		for _, r in ipairs(RUTAS) do
			local a = obtener(an, r)
			if a and p[r[1]] and a.AnimationId ~= p[r[1]] then a.AnimationId = p[r[1]] end
		end
	end

	setAnimPack = function(nombre)
		packActual = nombre
		if conexion then conexion:Disconnect(); conexion = nil end
		local char = player.Character
		if not char then return end

		if nombre == "Off" then
			if original then aplicar(char, original) end
			return
		end
		local p = ANIM_PACKS[nombre]
		if not p then return end
		if not original then guardarOriginalAnim(char) end
		aplicar(char, p)

		conexion = RunService.Heartbeat:Connect(function()
			local c = player.Character
			if c then aplicar(c, p) end
		end)

		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end
	end

	player.CharacterAdded:Connect(function()
		original = nil
		task.wait(0.5)
		if packActual ~= "Off" then task.defer(function() setAnimPack(packActual) end) end
	end)
end

-- ===================== BAT SKINS (LÁSER + MINECRAFT) =====================
local BatSkins = {
	laserActivo = false,
	laserColor = "Rojo",
	laserSonido = true,
	mcActivo = false,
	mcColor = "Crimson Night",
	mcSonido = true,
	mcVolumen = 3,
	originales = {},
	sonidosGolpe = {},
	ultimoGolpeSonido = 0,
}

local COLORES_SABLE = {
	Rojo    = { hoja = Color3.fromRGB(255, 30, 30),   brillo = Color3.fromRGB(255, 90, 90),   luz = Color3.fromRGB(255, 20, 20) },
	Azul    = { hoja = Color3.fromRGB(60, 140, 255),  brillo = Color3.fromRGB(140, 200, 255), luz = Color3.fromRGB(40, 120, 255) },
	Verde   = { hoja = Color3.fromRGB(60, 255, 120),  brillo = Color3.fromRGB(160, 255, 200), luz = Color3.fromRGB(30, 255, 90)  },
	Púrpura = { hoja = Color3.fromRGB(200, 60, 255),  brillo = Color3.fromRGB(230, 150, 255), luz = Color3.fromRGB(180, 40, 255) },
	Blanco  = { hoja = Color3.fromRGB(240, 240, 255), brillo = Color3.fromRGB(255, 255, 255), luz = Color3.fromRGB(220, 220, 255) },
}

local COLORES_MC = {
	["Crimson Night"] = { hoja = Color3.fromRGB(160, 20, 20),   mango = Color3.fromRGB(60, 30, 10) },
	["Diamond"]       = { hoja = Color3.fromRGB(80, 220, 220),  mango = Color3.fromRGB(40, 30, 10) },
	["Gold"]          = { hoja = Color3.fromRGB(255, 210, 60),  mango = Color3.fromRGB(60, 30, 10) },
	["Emerald"]       = { hoja = Color3.fromRGB(60, 220, 90),   mango = Color3.fromRGB(40, 30, 10) },
	["Netherite"]     = { hoja = Color3.fromRGB(60, 50, 60),    mango = Color3.fromRGB(30, 20, 15) },
	["Iron"]          = { hoja = Color3.fromRGB(210, 210, 210), mango = Color3.fromRGB(60, 30, 10) },
}

local SONIDO_SABLE = "rbxassetid://130113322"
local SONIDO_MC_HIT = "rbxassetid://6534040715"

local function esBat(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local n = string.lower(tool.Name)
	return string.find(n, "bat", 1, true) ~= nil
end

local function crearSonidoGolpe(handle)
	if BatSkins.sonidosGolpe[handle] then
		return BatSkins.sonidosGolpe[handle]
	end
	local sonido = Instance.new("Sound")
	sonido.Name = "KR7_MCHit"
	sonido.SoundId = SONIDO_MC_HIT
	sonido.Volume = BatSkins.mcVolumen
	sonido.PlaybackSpeed = 1.1
	sonido.RollOffMaxDistance = 60
	sonido.Parent = handle
	BatSkins.sonidosGolpe[handle] = sonido
	return sonido
end

local function restaurarBatOriginal(handle)
	local orig = BatSkins.originales[handle]
	if not orig or not handle.Parent then return end
	for prop, valor in pairs(orig.props) do
		pcall(function() handle[prop] = valor end)
	end
	for _, obj in ipairs(handle:GetChildren()) do
		if obj.Name:sub(1, 4) == "KR7_" then obj:Destroy() end
	end
	BatSkins.originales[handle] = nil
end

local function guardarOriginalBat(handle)
	if BatSkins.originales[handle] then return end
	BatSkins.originales[handle] = {
		props = {
			Size = handle.Size,
			Color = handle.Color,
			Material = handle.Material,
			Transparency = handle.Transparency,
			Reflectance = handle.Reflectance,
		}
	}
end

local function aplicarLaser(handle)
	if not handle or not handle.Parent then return end
	guardarOriginalBat(handle)
	local cfg = COLORES_SABLE[BatSkins.laserColor] or COLORES_SABLE.Rojo

	for _, obj in ipairs(handle:GetChildren()) do
		if obj.Name:sub(1, 4) == "KR7_" then obj:Destroy() end
	end

	local hoja = Instance.new("Part")
	hoja.Name = "KR7_Hoja"
	hoja.Shape = Enum.PartType.Cylinder
	hoja.Material = Enum.Material.Neon
	hoja.Color = cfg.hoja
	hoja.Size = Vector3.new(4, 0.18, 0.18)
	hoja.CanCollide = false
	hoja.Massless = true
	hoja.Anchored = false
	hoja.CFrame = handle.CFrame * CFrame.new(0, 1.8, 0) * CFrame.Angles(0, math.rad(90), 0)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = hoja
	weld.Parent = hoja
	hoja.Parent = handle

	local nucleo = Instance.new("Part")
	nucleo.Name = "KR7_Nucleo"
	nucleo.Shape = Enum.PartType.Cylinder
	nucleo.Material = Enum.Material.Neon
	nucleo.Color = cfg.brillo
	nucleo.Size = Vector3.new(4, 0.07, 0.07)
	nucleo.CanCollide = false
	nucleo.Massless = true
	nucleo.CFrame = hoja.CFrame
	local weld2 = Instance.new("WeldConstraint")
	weld2.Part0 = handle
	weld2.Part1 = nucleo
	weld2.Parent = nucleo
	nucleo.Parent = handle

	local mango = Instance.new("Part")
	mango.Name = "KR7_Mango"
	mango.Shape = Enum.PartType.Cylinder
	mango.Material = Enum.Material.Metal
	mango.Color = Color3.fromRGB(20, 20, 20)
	mango.Size = Vector3.new(0.8, 0.22, 0.22)
	mango.CanCollide = false
	mango.Massless = true
	mango.CFrame = handle.CFrame * CFrame.new(0, -0.2, 0) * CFrame.Angles(0, math.rad(90), 0)
	local weld3 = Instance.new("WeldConstraint")
	weld3.Part0 = handle
	weld3.Part1 = mango
	weld3.Parent = mango
	mango.Parent = handle

	local luz = Instance.new("PointLight")
	luz.Name = "KR7_Luz"
	luz.Color = cfg.luz
	luz.Range = 12
	luz.Brightness = 3
	luz.Shadows = false
	luz.Parent = hoja

	local attach = Instance.new("Attachment")
	attach.Parent = hoja
	local emisor = Instance.new("ParticleEmitter")
	emisor.Name = "KR7_Chispas"
	emisor.Color = ColorSequence.new(cfg.brillo)
	emisor.LightEmission = 1
	emisor.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 0),
	})
	emisor.Lifetime = NumberRange.new(0.2, 0.5)
	emisor.Rate = 25
	emisor.Speed = NumberRange.new(1, 3)
	emisor.SpreadAngle = Vector2.new(180, 180)
	emisor.Parent = attach

	if BatSkins.laserSonido then
		local s = Instance.new("Sound")
		s.Name = "KR7_SonidoSable"
		s.SoundId = SONIDO_SABLE
		s.Volume = 2.5
		s.PlaybackSpeed = 0.9
		s.Parent = handle
		s:Play()
		task.delay(1.5, function() if s and s.Parent then s:Destroy() end end)
	end

	handle.Transparency = 1
	handle.CanCollide = false

	BatSkins.laserActivo = true
end

local function aplicarMinecraft(handle)
	if not handle or not handle.Parent then return end
	guardarOriginalBat(handle)
	local cfg = COLORES_MC[BatSkins.mcColor] or COLORES_MC["Crimson Night"]

	for _, obj in ipairs(handle:GetChildren()) do
		if obj.Name:sub(1, 4) == "KR7_" then obj:Destroy() end
	end

	local mango = Instance.new("Part")
	mango.Name = "KR7_MC_Mango"
	mango.Material = Enum.Material.Wood
	mango.Color = cfg.mango
	mango.Size = Vector3.new(0.35, 0.35, 1.6)
	mango.CanCollide = false
	mango.Massless = true
	mango.CFrame = handle.CFrame * CFrame.new(0, 0, -0.5)
	local w1 = Instance.new("WeldConstraint"); w1.Part0 = handle; w1.Part1 = mango; w1.Parent = mango
	mango.Parent = handle

	local hoja = Instance.new("Part")
	hoja.Name = "KR7_MC_Hoja"
	hoja.Material = Enum.Material.Neon
	hoja.Color = cfg.hoja
	hoja.Size = Vector3.new(0.22, 1.4, 0.22)
	hoja.CanCollide = false
	hoja.Massless = true
	hoja.CFrame = handle.CFrame * CFrame.new(0, 1.1, 0)
	local w2 = Instance.new("WeldConstraint"); w2.Part0 = handle; w2.Part1 = hoja; w2.Parent = hoja
	hoja.Parent = handle

	local guarda = Instance.new("Part")
	guarda.Name = "KR7_MC_Guarda"
	guarda.Material = Enum.Material.Wood
	guarda.Color = cfg.mango
	guarda.Size = Vector3.new(1.0, 0.18, 0.18)
	guarda.CanCollide = false
	guarda.Massless = true
	guarda.CFrame = handle.CFrame * CFrame.new(0, 0.55, 0)
	local w3 = Instance.new("WeldConstraint"); w3.Part0 = handle; w3.Part1 = guarda; w3.Parent = guarda
	guarda.Parent = handle

	local pomo = Instance.new("Part")
	pomo.Name = "KR7_MC_Pomo"
	pomo.Shape = Enum.PartType.Ball
	pomo.Material = Enum.Material.Neon
	pomo.Color = cfg.hoja
	pomo.Size = Vector3.new(0.3, 0.3, 0.3)
	pomo.CanCollide = false
	pomo.Massless = true
	pomo.CFrame = handle.CFrame * CFrame.new(0, -0.55, 0)
	local w4 = Instance.new("WeldConstraint"); w4.Part0 = handle; w4.Part1 = pomo; w4.Parent = pomo
	pomo.Parent = handle

	if BatSkins.mcSonido then
		crearSonidoGolpe(handle)
	end

	handle.Transparency = 1
	handle.CanCollide = false
	BatSkins.mcActivo = true
end

local function vigilarGolpes(tool, handle)
	if tool:GetAttribute("KR7_Vigilando") then return end
	tool:SetAttribute("KR7_Vigilando", true)

	tool.Activated:Connect(function()
		if not BatSkins.mcSonido then return end
		local ahora = os.clock()
		if ahora - BatSkins.ultimoGolpeSonido < 0.15 then return end

		local char = tool.Parent
		if not char then return end
		local raiz = char:FindFirstChild("HumanoidRootPart")
		if not raiz then return end

		local golpeo = false
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local r = p.Character:FindFirstChild("HumanoidRootPart")
				if r and (r.Position - raiz.Position).Magnitude < 8 then
					golpeo = true
					break
				end
			end
		end

		if golpeo then
			BatSkins.ultimoGolpeSonido = ahora
			local sonido = crearSonidoGolpe(handle)
			if sonido then
				sonido.Volume = BatSkins.mcVolumen
				sonido:Play()
			end
		end
	end)
end

local function aplicarSkinsActuales(tool)
	if not tool or not tool:IsA("Tool") then return end
	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	if BatSkins.laserActivo and BatSkins.mcActivo then
		restaurarBatOriginal(handle)
		aplicarLaser(handle)
	elseif BatSkins.laserActivo then
		restaurarBatOriginal(handle)
		aplicarLaser(handle)
	elseif BatSkins.mcActivo then
		restaurarBatOriginal(handle)
		aplicarMinecraft(handle)
		vigilarGolpes(tool, handle)
	else
		restaurarBatOriginal(handle)
	end
end

local function escanearBates()
	local char = player.Character
	if not char then return end

	local function procesar(tool)
		if esBat(tool) then aplicarSkinsActuales(tool) end
	end

	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") then procesar(t) end
	end
	local mochila = player:FindFirstChildOfClass("Backpack")
	if mochila then
		for _, t in ipairs(mochila:GetChildren()) do
			if t:IsA("Tool") then procesar(t) end
		end
	end
end

task.spawn(function()
	while true do
		pcall(escanearBates)
		task.wait(1)
	end
end)

local function hookToolEquipada(tool)
	if not tool or not tool:IsA("Tool") then return end
	if esBat(tool) then
		task.defer(function() aplicarSkinsActuales(tool) end)
	end
end

player.CharacterAdded:Connect(function(char)
	task.wait(2)
	escanearBates()
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") then hookToolEquipada(t) end
	end
	char.ChildAdded:Connect(function(c)
		if c:IsA("Tool") then hookToolEquipada(c) end
	end)
end)

if player.Character then
	for _, t in ipairs(player.Character:GetChildren()) do
		if t:IsA("Tool") then hookToolEquipada(t) end
	end
	player.Character.ChildAdded:Connect(function(c)
		if c:IsA("Tool") then hookToolEquipada(c) end
	end)
end

-- ===================== ARRASTRE DE BOTONES =====================
local arrastre = nil
local ultimoArrastre = -10
local function bloqueado() return ajustes.toggles["Visual/Lock UI"] == true end
local function modoEdicion() return ajustes.toggles["Visual/Edit Button"] == true end

local function iniciarArrastre(btn, indice, input)
	if bloqueado() then return end
	local individual = modoEdicion()
	local objetivo = individual and btn or contenedor
	arrastre = {
		input = input, objetivo = objetivo,
		inicio = Vector2.new(input.Position.X, input.Position.Y),
		pos = objetivo.Position, individual = individual,
		indice = indice, movido = false,
	}
end

UIS.InputChanged:Connect(function(input)
	if not arrastre then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == arrastre.input then
		if bloqueado() then return end
		local d = Vector2.new(input.Position.X, input.Position.Y) - arrastre.inicio
		if not arrastre.movido and d.Magnitude < 6 then return end
		arrastre.movido = true
		ultimoArrastre = os.clock()
		local p = arrastre.pos
		arrastre.objetivo.Position = UDim2.new(p.X.Scale, p.X.Offset + d.X, p.Y.Scale, p.Y.Offset + d.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if not arrastre then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input == arrastre.input then
		if arrastre.movido then
			ultimoArrastre = os.clock()
			local p = arrastre.objetivo.Position
			if arrastre.individual then
				ajustes.pos[tostring(arrastre.indice)] = { x = p.X.Offset, y = p.Y.Offset }
			else
				ajustes.cont = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
			end
			guardar()
		end
		arrastre = nil
	end
end)

-- ===================== BOTONES =====================
local function crearLuzLateral(btn, nombre, rotacion)
	local luz = nuevo("Frame", {
		Name = nombre, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = MORADO,
		BorderSizePixel = 0, ZIndex = 3,
	})
	redondear(luz, 20)
	nuevo("UIGradient", {
		Rotation = rotacion,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.0, 0.70),
			NumberSequenceKeypoint.new(0.3, 0.88),
			NumberSequenceKeypoint.new(0.6, 1.0),
			NumberSequenceKeypoint.new(1.0, 1.0),
		}),
	}, luz)
	luz.Parent = btn
	return luz
end

local parpadeoCorto = { ["RESET"] = true, ["TP\nDOWN"] = true, ["DROP\nBR"] = true }

local grupos = {
	{ "BAT\nNORMAL", "TP\nBAT", "BAT\nBYPASS" },
	{ "AUTO\nLEFT", "AUTO\nRIGHT" },
	{ "LAGGER\nCARRY", "LAGGER\nNORMAL", "CARRY\nSPD" },
}
local grupoDe = {}
for _, g in ipairs(grupos) do
	for _, nombre in ipairs(g) do grupoDe[nombre] = g end
end

local apagadores = {}
local botonesUI = {}
local refBtnCarry
local setToggleAutoLeft, setToggleAutoRight, setToggleCarryAuto
local setToggleAutoBat, setToggleTpBat
local setToggleBatSkin, setToggleMinecraft

local function soltarBrainrot()
	task.spawn(function()
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if S.dropModo == "jump" and hum then
			hum.Jump = true
			task.wait(0.15)
		end
		if not char then return end
		for _, obj in ipairs(char:GetChildren()) do
			if obj:IsA("Tool") and string.find(string.lower(obj.Name), "brainrot") then
				obj.Parent = workspace
				break
			end
		end
		for _, obj in ipairs(char:GetChildren()) do
			if (obj:IsA("Model") or obj:IsA("Part"))
				and (string.find(string.lower(obj.Name), "brainrot")
					or string.find(string.lower(obj.Name), "pet")) then
				obj.Parent = workspace
			end
		end
	end)
end

for i = 1, #posiciones do
	local miNombre = textos[i]
	local claveBoton = tostring(i)

	local btn = nuevo("TextButton", {
		Name = "Boton" .. i, Size = UDim2.new(0, TAM, 0, TAM), Position = posiciones[i],
		BackgroundColor3 = NEGRO_PURO, BorderSizePixel = 0, Text = "",
		AutoButtonColor = false, ClipsDescendants = true, ZIndex = 2,
	})
	botonesUI[i] = btn

	local pg = ajustes.pos[claveBoton]
	if type(pg) == "table" and type(pg.x) == "number" and type(pg.y) == "number" then
		btn.Position = UDim2.new(0, pg.x, 0, pg.y)
	end

	redondear(btn, 20)
	if i == 1 then
		nuevo("UIStroke", {
			Color = GRIS_BORDE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, btn)
	end

	local luzIzq = crearLuzLateral(btn, "LuzIzquierda", 0)
	local luzDer = crearLuzLateral(btn, "LuzDerecha", 180)

	local sombra = nuevo("Frame", {
		Name = "SombraActiva", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = NEGRO_PURO,
		BorderSizePixel = 0, ZIndex = 6, Visible = false,
	}, btn)
	redondear(sombra, 20)
	local sombraGrad = nuevo("UIGradient", {
		Rotation = 0,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.0, 1),
			NumberSequenceKeypoint.new(0.35, 1),
			NumberSequenceKeypoint.new(0.5, 0.2),
			NumberSequenceKeypoint.new(0.65, 1),
			NumberSequenceKeypoint.new(1.0, 1),
		}),
		Offset = Vector2.new(-1, 0),
	}, sombra)
	local tweenSombra = TweenService:Create(sombraGrad,
		TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
		{ Offset = Vector2.new(1, 0) })

	local etiqueta = nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = miNombre or "",
		TextColor3 = MORADO_TEXTO, Font = Enum.Font.GothamBlack, TextSize = 12,
		TextWrapped = true, ZIndex = 7,
	}, btn)

	local activo = false
	local token = 0

	local function pintar(estado)
		activo = (estado ~= "normal")
		if estado == "blanco" then
			btn.BackgroundColor3 = MORADO_CLARO
			etiqueta.TextColor3 = BLANCO
			luzIzq.BackgroundColor3 = MORADO
			luzDer.BackgroundColor3 = MORADO
			tweenSombra:Cancel(); sombra.Visible = false
		elseif estado == "gris" then
			btn.BackgroundColor3 = MORADO_OSCURO
			etiqueta.TextColor3 = MORADO_TEXTO
			luzIzq.BackgroundColor3 = MORADO_CLARO
			luzDer.BackgroundColor3 = MORADO_CLARO
			sombraGrad.Offset = Vector2.new(-1, 0)
			sombra.Visible = true
			tweenSombra:Play()
			if modoDe[miNombre] then S.modo = modoDe[miNombre] end
			if miNombre == "TP\nBAT" then
				S.tpBat = true; S.objetivo = nil
				ajustes.toggles["Custom/TP BAT"] = true
				if setToggleTpBat then setToggleTpBat(true) end
				guardar()
			elseif miNombre == "BAT\nNORMAL" then
				S.batNormal = true; S.objetivo = nil
				ajustes.toggles["Custom/Auto Bat"] = true
				if setToggleAutoBat then setToggleAutoBat(true) end
				guardar()
			elseif miNombre == "AUTO\nLEFT" then
				S.autoLeft = true; S.autoRight = false
			elseif miNombre == "AUTO\nRIGHT" then
				S.autoRight = true; S.autoLeft = false
			elseif miNombre == "CARRY\nSPD" then
				S.carryManual = true
			end
		else
			btn.BackgroundColor3 = NEGRO_PURO
			etiqueta.TextColor3 = MORADO_TEXTO
			luzIzq.BackgroundColor3 = MORADO
			luzDer.BackgroundColor3 = MORADO
			tweenSombra:Cancel(); sombra.Visible = false
			if modoDe[miNombre] and S.modo == modoDe[miNombre] then S.modo = nil end
			if miNombre == "TP\nBAT" then
				S.tpBat = false; S.objetivo = nil
				ajustes.toggles["Custom/TP BAT"] = false
				if setToggleTpBat then setToggleTpBat(false) end
				guardar()
			elseif miNombre == "BAT\nNORMAL" then
				S.batNormal = false; S.objetivo = nil
				ajustes.toggles["Custom/Auto Bat"] = false
				if setToggleAutoBat then setToggleAutoBat(false) end
				guardar()
			elseif miNombre == "AUTO\nLEFT" then
				S.autoLeft = false
			elseif miNombre == "AUTO\nRIGHT" then
				S.autoRight = false
			elseif miNombre == "CARRY\nSPD" then
				S.carryManual = false
			end
			ajustes.botones[claveBoton] = nil
			guardar()
		end
	end

	local function activarLargo(segundos)
		token += 1
		local miToken = token
		ajustes.botones[claveBoton] = os.time() + math.floor(segundos)
		pintar("gris")
		guardar()
		task.delay(segundos, function()
			if token == miToken then pintar("normal") end
		end)
	end

	apagadores[miNombre] = function()
		if activo then token += 1; pintar("normal") end
	end

	local function toggleExterno(estado)
		if estado and not activo then activarLargo(DURACION_LARGA)
		elseif not estado and activo then token += 1; pintar("normal") end
	end

	if miNombre == "AUTO\nLEFT" then setToggleAutoLeft = toggleExterno
	elseif miNombre == "AUTO\nRIGHT" then setToggleAutoRight = toggleExterno
	elseif miNombre == "CARRY\nSPD" then refBtnCarry = btn; setToggleCarryAuto = toggleExterno
	end

	btn.MouseEnter:Connect(function()
		if not activo then btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
	end)
	btn.MouseLeave:Connect(function()
		if not activo then btn.BackgroundColor3 = NEGRO_PURO end
	end)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			iniciarArrastre(btn, i, input)
		end
	end)

	btn.MouseButton1Click:Connect(function()
		if os.clock() - ultimoArrastre < 0.2 then return end
		token += 1
		local miToken = token
		if parpadeoCorto[miNombre] then
			if miNombre == "TP\nDOWN" then tpDown()
			elseif miNombre == "RESET" then resetPersonaje()
			elseif miNombre == "DROP\nBR" then soltarBrainrot()
			end
			pintar("blanco")
			task.delay(DURACION_CORTA, function()
				if token == miToken then pintar("normal") end
			end)
		elseif activo then
			pintar("normal")
		else
			local g = grupoDe[miNombre]
			if g then
				for _, otro in ipairs(g) do
					if otro ~= miNombre and apagadores[otro] then apagadores[otro]() end
				end
			end
			activarLargo(DURACION_LARGA)
		end
	end)

	btn.Parent = contenedor

	local venceEn = ajustes.botones[claveBoton]
	if type(venceEn) == "number" and venceEn > os.time() and not parpadeoCorto[miNombre] then
		activarLargo(venceEn - os.time())
	else
		ajustes.botones[claveBoton] = nil
	end
end

local function resetearPosiciones()
	contenedor.Position = posContDefault
	for i, b in ipairs(botonesUI) do b.Position = posiciones[i] end
	ajustes.pos = {}
	ajustes.cont = nil
	guardar()
end

-- ===================== PANEL =====================
local FILA_BG = Color3.fromRGB(18, 18, 18)
local CAJA_BG = Color3.fromRGB(34, 34, 34)
local TEXTO_SUAVE = Color3.fromRGB(170, 170, 170)

local PANEL_ANCHO, PANEL_ALTO, PANEL_MARGEN = 340, 420, 25
local PANEL_ESCALA = 0.75
local TABS_ANCHO, TABS_PADDING, CONTENIDO_MARGEN = 78, 10, 14

local function posAbierto()
	local p = ajustes.panelPos
	if p and type(p.xs) == "number" and type(p.xo) == "number"
		and type(p.ys) == "number" and type(p.yo) == "number" then
		return UDim2.new(p.xs, p.xo, p.ys, p.yo)
	end
	return UDim2.new(0, PANEL_MARGEN, 0.5, 0)
end

local function posCerrado()
	local a = posAbierto()
	return UDim2.new(0, (-PANEL_ANCHO - PANEL_MARGEN) * PANEL_ESCALA, a.Y.Scale, a.Y.Offset)
end

local panel = nuevo("Frame", {
	Name = "PanelKR7", Size = UDim2.new(0, PANEL_ANCHO, 0, PANEL_ALTO),
	AnchorPoint = Vector2.new(0, 0.5), Position = posCerrado(),
	BackgroundColor3 = NEGRO_PURO, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5,
}, ScreenGui)
redondear(panel, 12)
nuevo("UIScale", { Scale = PANEL_ESCALA }, panel)

local IMG_KR7 = imagenLocal("KR7.jpg", "Kr7.jpg")

local cabecera = nuevo("ImageLabel", {
	Size = UDim2.new(1, -20, 0, 58), Position = UDim2.new(0, 10, 0, 8),
	BackgroundTransparency = 1, Image = IMG_KR7, ScaleType = Enum.ScaleType.Fit,
}, panel)
if IMG_KR7 == "" then
	nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "KR7",
		TextColor3 = MORADO_TEXTO, Font = Enum.Font.GothamBlack, TextSize = 28,
	}, cabecera)
end

local cerrar = nuevo("TextButton", {
	Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0, 12),
	BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Text = "-",
	TextColor3 = BLANCO, Font = Enum.Font.GothamBlack, TextSize = 18, AutoButtonColor = false,
}, panel)
redondear(cerrar, 6)

local panelAbierto = false
local panelArrastre = nil

cabecera.InputBegan:Connect(function(input)
	if not panelAbierto then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		panelArrastre = {
			input = input,
			inicio = Vector2.new(input.Position.X, input.Position.Y),
			pos = panel.Position,
		}
	end
end)
UIS.InputChanged:Connect(function(input)
	if not panelArrastre then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == panelArrastre.input then
		local d = (Vector2.new(input.Position.X, input.Position.Y) - panelArrastre.inicio) / PANEL_ESCALA
		local p = panelArrastre.pos
		panel.Position = UDim2.new(p.X.Scale, p.X.Offset + d.X, p.Y.Scale, p.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function(input)
	if not panelArrastre then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input == panelArrastre.input then
		local p = panel.Position
		ajustes.panelPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
		guardar()
		panelArrastre = nil
	end
end)

nuevo("Frame", {
	Size = UDim2.new(1, -28, 0, 1), Position = UDim2.new(0, 14, 0, 74),
	BackgroundColor3 = GRIS_BORDE, BorderSizePixel = 0,
}, panel)

local barraTabs = nuevo("Frame", {
	Size = UDim2.new(0, TABS_ANCHO, 1, -122),
	Position = UDim2.new(1, -(TABS_ANCHO + 10), 0, 84),
	BackgroundTransparency = 1,
}, panel)
nuevo("UIListLayout", {
	FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, TABS_PADDING), HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, barraTabs)

local ordenTabs = { "Speed", "Custom", "Visual", "Settings", "Keybinds" }

local contenido = {
	Speed = {
		{ items = {
			{ "toggle", "Auto Carry" },
			{ "num", "Normal Speed", "30" },
			{ "num", "Carry Speed", "29" },
			{ "num", "Lagger Speed", "15" },
			{ "num", "Lagger Carry Spd", "24.5" },
			{ "num", "Soft Steal Speed", "30" },
			{ "num", "Soft Steal Radius", "10" },
		} },
		{ sec = "AUTO MOVEMENT", items = {
			{ "toggle", "Auto Left" },
			{ "toggle", "Auto Right" },
			{ "toggle", "Infinite Jump" },
		} },
		{ sec = "TELEPORT", items = {
			{ "action", "TP Down", "ACTIVATE" },
			{ "num", "TP Down Height", "20" },
			{ "toggle", "Mirror TP Down" },
		} },
	},
	Custom = {
		{ sec = "AIMBOTS", items = {
			{ "toggle", "Auto Bat" },
			{ "num", "Bat Aimbot Speed", "58" },
			{ "toggle", "TP BAT" },
			{ "toggle", "Bat Bypass" },
		} },
		{ sec = "COUNTERS", items = {
			{ "toggle", "Bat Counter" },
			{ "toggle", "Bat Counter V2" },
			{ "toggle", "Medusa Counter" },
		} },
		{ sec = "DEFENSE", items = {
			{ "toggle", "Body Lock" },
			{ "num", "Body Lock Range", "20" },
			{ "toggle", "Safe Mode" },
			{ "toggle", "No Player Collision" },
		} },
		{ sec = "SURVIVAL", items = {
			{ "select", "Anti Ragdoll", "V2" },
			{ "toggle", "Unwalk" },
			{ "toggle", "Anti Die" },
		} },
		{ sec = "DROP", items = {
			{ "toggle", "Drop Brainrot" },
			{ "select", "Drop Mode", "Jump Drop" },
		} },
	},
	Visual = {
		{ sec = "INTERFACE", items = {
			{ "toggle", "Edit Button" },
			{ "toggle", "Lock UI" },
			{ "toggle", "Player ESP" },
		} },
		{ sec = "CAMERA", items = {
			{ "toggle", "FOV" },
			{ "slider", "FOV Value", 0.5 },
			{ "toggle", "No Cam Collision" },
			{ "toggle", "Stretch Rez" },
		} },
		{ sec = "PERFORMANCE", items = {
			{ "toggle", "Anti Lag" },
			{ "toggle", "Show E01 Warning" },
		} },
		{ sec = "ENVIRONMENT", items = {
			{ "select", "Sky Theme", "Off" },
		} },
		{ sec = "PERSONALIZACIÓN", items = {
			{ "toggle", "Bat Skin" },
			{ "select", "Bat Skin Color", "Rojo" },
			{ "toggle", "Bat Skin Sound" },
			{ "toggle", "Minecraft Bat" },
			{ "select", "MC Bat Color", "Crimson Night" },
			{ "toggle", "Minecraft Hit Sound" },
			{ "num", "MC Hit Volume", "3" },
			{ "animpack", "Anim Pack", "Off" },
		} },
	},
	Settings = {
		{ sec = "AUTO STEAL", items = {
			{ "toggle", "Auto Steal" },
			{ "num", "Steal Radius", "61" },
			{ "select", "Steal Version", "Normal" },
		} },
		{ sec = "MOBILE BUTTONS", items = {
			{ "toggle", "Hide Mobile Buttons" },
			{ "select", "Buttons to Hide", "v" },
		} },
		{ sec = "CONFIG MANAGEMENT", items = {
			{ "boton", "SAVE CONFIG", Color3.fromRGB(70, 70, 80), function()
				guardadoBloqueado = false
				guardar()
			end },
			{ "boton", "RESET POSITIONS", Color3.fromRGB(50, 65, 95), resetearPosiciones },
			{ "boton", "DELETE SETTINGS", Color3.fromRGB(150, 30, 70), borrarAjustes },
		} },
	},
	Keybinds = {
		{ sec = "KEYBINDS", items = {
			{ "key", "Carry Mode", "Q" },
			{ "key", "Lagger Mode", "R" },
			{ "key", "Auto Left", "Z" },
			{ "key", "Auto Right", "C" },
			{ "key", "Auto Bat", "E" },
			{ "key", "TP BAT", "X" },
			{ "key", "Bat Bypass", "V" },
			{ "key", "Insta Reset", "H" },
			{ "key", "TP Down", "F" },
			{ "key", "Drop Brainrot", "J" },
			{ "key", "Hide GUI", "LeftControl" },
		} },
	},
}

local function formatear(n)
	if n == math.floor(n) then return tostring(math.floor(n)) end
	return string.format("%.1f", n)
end

local function crearPagina(nombre)
	local sf = nuevo("ScrollingFrame", {
		Name = nombre, Size = UDim2.new(1, -(TABS_ANCHO + CONTENIDO_MARGEN + 20), 1, -86),
		Position = UDim2.new(0, 10, 0, 82), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 3, ScrollBarImageColor3 = GRIS_BORDE,
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
	}, panel)
	nuevo("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sf)
	nuevo("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingLeft = UDim.new(0, 4) }, sf)
	return sf
end

local function crearSeccion(padre, orden, titulo)
	local sec = nuevo("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, LayoutOrder = orden,
	}, padre)
	nuevo("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sec)
	local cab = nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = string.upper(titulo),
		TextColor3 = MORADO_TEXTO, Font = Enum.Font.Gotham, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0,
	}, sec)
	nuevo("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70), BorderSizePixel = 0,
	}, cab)
	local cont = nuevo("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, LayoutOrder = 1,
	}, sec)
	nuevo("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, cont)
	return cont
end

local function crearFila(padre, orden, nombre)
	local fila = nuevo("Frame", {
		Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = FILA_BG,
		BorderSizePixel = 0, LayoutOrder = orden,
	}, padre)
	redondear(fila, 8)
	nuevo("TextLabel", {
		Size = UDim2.new(0.55, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1, Text = string.upper(nombre), TextColor3 = MORADO_TEXTO,
		Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
	}, fila)
	return fila
end

local function crearCaja(fila, anchoCaja, altoCaja, texto, tamTexto)
	local caja = nuevo("Frame", {
		Size = UDim2.new(0, anchoCaja, 0, altoCaja), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0), BackgroundColor3 = CAJA_BG, BorderSizePixel = 0,
	}, fila)
	redondear(caja, 6)
	local t = nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = string.upper(texto),
		TextColor3 = BLANCO, Font = Enum.Font.GothamBold, TextSize = tamTexto or 11,
	}, caja)
	return caja, t
end

local OPCIONES_SELECT = {
	["Drop Mode"] = { "Jump Drop", "Tap Drop" },
	["Bat Skin Color"] = { "Rojo", "Azul", "Verde", "Púrpura", "Blanco" },
	["MC Bat Color"] = { "Crimson Night", "Diamond", "Gold", "Emerald", "Netherite", "Iron" },
}

local function crearItem(padre, orden, item, clavePag)
	local tipo = item[1]

	if tipo == "boton" then
		local b = nuevo("TextButton", {
			Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = item[3], BorderSizePixel = 0,
			Text = string.upper(item[2]), TextColor3 = BLANCO, Font = Enum.Font.GothamBlack,
			TextSize = 12, AutoButtonColor = true, LayoutOrder = orden,
		}, padre)
		redondear(b, 10)
		if item[4] then b.MouseButton1Click:Connect(item[4]) end
		return
	end

	local fila = crearFila(padre, orden, item[2])
	local clave = clavePag .. "/" .. item[2]

	if tipo == "animpack" then
		local actual = ajustes.toggles[clave]
		if type(actual) ~= "string" then actual = item[3] end
		packActual = actual

		local caja, t = crearCaja(fila, 130, 24, actual, 11)
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Position = UDim2.new(0, 10, 0, 0)
		t.Size = UDim2.new(1, -16, 1, 0)
		local b = nuevo("TextButton", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "",
		}, caja)

		local idx = 1
		for k, nombre in ipairs(ANIM_PACK_ORDER) do
			if nombre == actual then idx = k end
		end
		b.MouseButton1Click:Connect(function()
			idx = idx % #ANIM_PACK_ORDER + 1
			local elegido = ANIM_PACK_ORDER[idx]
			t.Text = string.upper(elegido)
			ajustes.toggles[clave] = elegido
			guardar()
			setAnimPack(elegido)
		end)
		if actual ~= "Off" then task.defer(function() setAnimPack(actual) end) end

	elseif tipo == "toggle" then
		local pill = nuevo("TextButton", {
			Size = UDim2.new(0, 40, 0, 20), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0), Text = "", AutoButtonColor = false,
			BorderSizePixel = 0,
		}, fila)
		redondear(pill, 10)
		nuevo("UIStroke", { Color = Color3.fromRGB(100, 100, 100), Thickness = 1 }, pill)
		local knob = nuevo("Frame", {
			Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0,
		}, pill)
		redondear(knob, 7)

		local encendido = (ajustes.toggles[clave] == true)
		local function refrescar()
			pill.BackgroundColor3 = encendido and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(210, 210, 210)
			knob.BackgroundColor3 = encendido and BLANCO or Color3.fromRGB(40, 40, 40)
			knob.Position = encendido and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		end
		refrescar()

		local nombre = item[2]
		if nombre == "Infinite Jump" then S.infJump = encendido
		elseif nombre == "Auto Carry" then S.carryAuto = encendido
		elseif nombre == "Auto Left" then S.autoLeft = encendido
		elseif nombre == "Auto Right" then S.autoRight = encendido
		elseif nombre == "Auto Bat" then S.batNormal = encendido
		elseif nombre == "TP BAT" then S.tpBat = encendido
		elseif nombre == "Player ESP" then setESP(encendido)
		elseif nombre == "Bat Skin" then
			BatSkins.laserActivo = encendido
			escanearBates()
		elseif nombre == "Bat Skin Sound" then
			BatSkins.laserSonido = encendido
		elseif nombre == "Minecraft Bat" then
			BatSkins.mcActivo = encendido
			escanearBates()
		elseif nombre == "Minecraft Hit Sound" then
			BatSkins.mcSonido = encendido
		end

		if nombre == "Auto Bat" then
			setToggleAutoBat = function(estado)
				encendido = estado
				ajustes.toggles[clave] = estado
				refrescar(); guardar()
				S.batNormal = estado
				if not estado then
					S.objetivo = nil
					if apagadores["BAT\nNORMAL"] then apagadores["BAT\nNORMAL"]() end
				end
			end
		elseif nombre == "TP BAT" then
			setToggleTpBat = function(estado)
				encendido = estado
				ajustes.toggles[clave] = estado
				refrescar(); guardar()
				S.tpBat = estado
				if not estado then
					S.objetivo = nil
					if apagadores["TP\nBAT"] then apagadores["TP\nBAT"]() end
				end
			end
		elseif nombre == "Bat Skin" then
			setToggleBatSkin = function(estado)
				encendido = estado
				ajustes.toggles[clave] = estado
				refrescar(); guardar()
				BatSkins.laserActivo = estado
				escanearBates()
			end
		elseif nombre == "Minecraft Bat" then
			setToggleMinecraft = function(estado)
				encendido = estado
				ajustes.toggles[clave] = estado
				refrescar(); guardar()
				BatSkins.mcActivo = estado
				escanearBates()
			end
		end

		pill.MouseButton1Click:Connect(function()
			encendido = not encendido
			ajustes.toggles[clave] = encendido
			refrescar()
			guardar()
			if nombre == "Infinite Jump" then S.infJump = encendido
			elseif nombre == "Auto Carry" then S.carryAuto = encendido
			elseif nombre == "Player ESP" then setESP(encendido)
			elseif nombre == "Auto Bat" then
				S.batNormal = encendido
				if not encendido then
					S.objetivo = nil
					if apagadores["BAT\nNORMAL"] then apagadores["BAT\nNORMAL"]() end
				end
			elseif nombre == "TP BAT" then
				S.tpBat = encendido
				if not encendido then
					S.objetivo = nil
					if apagadores["TP\nBAT"] then apagadores["TP\nBAT"]() end
				end
			elseif nombre == "Auto Left" then
				S.autoLeft = encendido
				if encendido then
					S.autoRight = false
					if setToggleAutoRight then setToggleAutoRight(false) end
					if setToggleAutoLeft then setToggleAutoLeft(true) end
				elseif setToggleAutoLeft then
					setToggleAutoLeft(false)
				end
			elseif nombre == "Auto Right" then
				S.autoRight = encendido
				if encendido then
					S.autoLeft = false
					if setToggleAutoLeft then setToggleAutoLeft(false) end
					if setToggleAutoRight then setToggleAutoRight(true) end
				elseif setToggleAutoRight then
					setToggleAutoRight(false)
				end
			elseif nombre == "Bat Skin" then
				BatSkins.laserActivo = encendido
				escanearBates()
			elseif nombre == "Bat Skin Sound" then
				BatSkins.laserSonido = encendido
			elseif nombre == "Minecraft Bat" then
				BatSkins.mcActivo = encendido
				escanearBates()
			elseif nombre == "Minecraft Hit Sound" then
				BatSkins.mcSonido = encendido
			end
		end)

	elseif tipo == "num" then
		local valor = ajustes.nums[clave]
		if type(valor) ~= "number" then
			valor = tonumber(item[3])
			ajustes.nums[clave] = valor
		end
		local caja, t = crearCaja(fila, 54, 22, "", 11)
		t:Destroy()
		local tb = nuevo("TextBox", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = formatear(valor),
			TextColor3 = BLANCO, Font = Enum.Font.GothamBold, TextSize = 11,
			ClearTextOnFocus = false, TextWrapped = false,
		}, caja)
		local ultimoTexto = tb.Text
		tb:GetPropertyChangedSignal("Text"):Connect(function()
			local txt = tb.Text
			if txt == "" or txt:match("^%d+[%.,]?%d?$") then ultimoTexto = txt
			else tb.Text = ultimoTexto end
		end)
		tb.FocusLost:Connect(function()
			local txt = tb.Text:gsub("%s", ""):gsub(",", ".")
			local n = nil
			if txt:match("^%d+%.?%d?$") then n = tonumber(txt) end
			if n and n <= 999.9 then
				n = math.floor(n * 10 + 0.5) / 10
				ajustes.nums[clave] = n
				guardar()
				if item[2] == "MC Hit Volume" then
					BatSkins.mcVolumen = math.clamp(n, 0.1, 10)
				end
			end
			tb.Text = formatear(ajustes.nums[clave])
			ultimoTexto = tb.Text
		end)

	elseif tipo == "select" then
		local opciones = OPCIONES_SELECT[item[2]]
		local actual = item[3]
		local guardado = ajustes.toggles[clave]
		if type(guardado) == "string" then actual = guardado end
		local caja, t = crearCaja(fila, 120, 24, actual, 11)
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Position = UDim2.new(0, 10, 0, 0)
		t.Size = UDim2.new(1, -16, 1, 0)
		if opciones then
			local b = nuevo("TextButton", {
				Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "",
			}, caja)
			local idx = 1
			for k, op in ipairs(opciones) do if op == actual then idx = k end end
			b.MouseButton1Click:Connect(function()
				idx = idx % #opciones + 1
				local elegido = opciones[idx]
				t.Text = string.upper(elegido)
				ajustes.toggles[clave] = elegido
				guardar()
				if item[2] == "Drop Mode" then
					S.dropModo = (elegido == "Jump Drop") and "jump" or "tap"
				elseif item[2] == "Bat Skin Color" then
					BatSkins.laserColor = elegido
					escanearBates()
				elseif item[2] == "MC Bat Color" then
					BatSkins.mcColor = elegido
					escanearBates()
				end
			end)
		end

	elseif tipo == "key" then
		crearCaja(fila, 90, 24, item[3], 10)

	elseif tipo == "action" then
		local b = nuevo("TextButton", {
			Size = UDim2.new(0, 70, 0, 22), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0), BackgroundColor3 = CAJA_BG, BorderSizePixel = 0,
			Text = string.upper(item[3]), TextColor3 = BLANCO, Font = Enum.Font.GothamBold,
			TextSize = 9,
		}, fila)
		redondear(b, 6)
		if item[2] == "TP Down" then b.MouseButton1Click:Connect(tpDown) end

	elseif tipo == "slider" then
		local pista = nuevo("Frame", {
			Size = UDim2.new(0, 110, 0, 4), AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			BorderSizePixel = 0,
		}, fila)
		redondear(pista, 2)
		local bola = nuevo("Frame", {
			Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(item[3], 0, 0.5, 0), BackgroundColor3 = BLANCO, BorderSizePixel = 0,
		}, pista)
		redondear(bola, 6)
	end
end

-- ===================== CREAR PÁGINAS Y PESTAÑAS =====================
local paginasUI, botonesTab = {}, {}

for _, nombrePag in ipairs(ordenTabs) do
	local pag = crearPagina(nombrePag)
	paginasUI[nombrePag] = pag
	local ordenPag = 0
	for _, grupo in ipairs(contenido[nombrePag]) do
		if grupo.sec then
			ordenPag += 1
			local cont = crearSeccion(pag, ordenPag, grupo.sec)
			for k, item in ipairs(grupo.items) do crearItem(cont, k, item, nombrePag) end
		else
			for _, item in ipairs(grupo.items) do
				ordenPag += 1
				crearItem(pag, ordenPag, item, nombrePag)
			end
		end
	end
end

task.defer(function()
	if ajustes.toggles["Speed/Auto Left"] == true and setToggleAutoLeft then setToggleAutoLeft(true) end
	if ajustes.toggles["Speed/Auto Right"] == true and setToggleAutoRight then setToggleAutoRight(true) end
end)

local function mostrarTab(nombre)
	for n, pag in pairs(paginasUI) do pag.Visible = (n == nombre) end
	for n, b in pairs(botonesTab) do
		local activa = (n == nombre)
		b.BackgroundColor3 = activa and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(20, 20, 20)
		b.TextColor3 = activa and BLANCO or TEXTO_SUAVE
	end
end

for idx, nombre in ipairs(ordenTabs) do
	local b = nuevo("TextButton", {
		Name = "Tab" .. nombre, Size = UDim2.new(1, 0, 0, 32), BorderSizePixel = 0,
		Text = string.upper(nombre), Font = Enum.Font.GothamBold, TextSize = 10,
		AutoButtonColor = false, LayoutOrder = idx,
	}, barraTabs)
	redondear(b, 6)
	botonesTab[nombre] = b
	b.MouseButton1Click:Connect(function() mostrarTab(nombre) end)
end
mostrarTab("Speed")

for _, d in ipairs(panel:GetDescendants()) do
	if d:IsA("GuiObject") then
		local profundidad, p = 0, d
		while p ~= panel do profundidad += 1; p = p.Parent end
		d.ZIndex = 5 + profundidad
	end
end

-- ===================== BOTÓN KR7 =====================
local kr7 = nuevo("ImageButton", {
	Size = UDim2.new(0, 110, 0, 42), Position = UDim2.new(0, 12, 0, 75),
	BackgroundTransparency = 1, BorderSizePixel = 0, Image = IMG_KR7,
	ScaleType = Enum.ScaleType.Fit, AutoButtonColor = true, ZIndex = 20,
}, ScreenGui)
redondear(kr7, 10)
if IMG_KR7 == "" then
	kr7.BackgroundTransparency = 0
	kr7.BackgroundColor3 = NEGRO_PURO
	nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "KR7",
		TextColor3 = MORADO_TEXTO, Font = Enum.Font.GothamBlack, TextSize = 18, ZIndex = 21,
	}, kr7)
end

local infoTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function setPanel(abierto)
	panelAbierto = abierto
	kr7.Visible = not abierto
	TweenService:Create(panel, infoTween, { Position = abierto and posAbierto() or posCerrado() }):Play()
	ajustes.panelAbierto = abierto
	guardar()
end

kr7.MouseButton1Click:Connect(function() setPanel(true) end)
cerrar.MouseButton1Click:Connect(function() setPanel(false) end)
if ajustes.panelAbierto == true then task.defer(function() setPanel(true) end) end

-- ===================== TEXTO DE VELOCIDAD =====================
local etiquetaVel = nil
local function crearEtiquetaVelocidad(char)
	local cabeza = char:WaitForChild("Head", 10)
	if not cabeza then return end
	local viejo = cabeza:FindFirstChild("KR7Velocidad")
	if viejo then viejo:Destroy() end
	local bb = nuevo("BillboardGui", {
		Name = "KR7Velocidad", Size = UDim2.new(0, 140, 0, 30),
		StudsOffset = Vector3.new(0, 2.6, 0), AlwaysOnTop = true, Adornee = cabeza,
	}, cabeza)
	etiquetaVel = nuevo("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "0.0 SPEED",
		TextColor3 = BLANCO, Font = Enum.Font.GothamBlack, TextSize = 20,
		TextStrokeTransparency = 0.3, TextStrokeColor3 = NEGRO_PURO,
	}, bb)
end
if player.Character then task.spawn(crearEtiquetaVelocidad, player.Character) end
player.CharacterAdded:Connect(function(char)
	S.usandoMia = false
	S.velJuego = nil
	S.objetivo = nil
	colisionOriginal = {}
	sinColisionActivo = false
	crearEtiquetaVelocidad(char)
end)

-- ===================== LOOP PRINCIPAL =====================
local ultimoAutoMovimiento = 0
RunService.Heartbeat:Connect(function(dt)
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local raiz = char:FindFirstChild("HumanoidRootPart")

	if S.esp then actualizarESP() end

	if S.infJump and S.saltoPresionado and hum and raiz and hum.Health > 0 then
		if raiz.AssemblyLinearVelocity.Y <= 0.5 then forzarSalto() end
	end

	if S.carryAuto and refBtnCarry then
		local agarrado = tieneBrainrotAgarrado()
		if agarrado and not S.carryPorAuto and not S.carryManual then
			S.carryPorAuto = true
			if setToggleCarryAuto then setToggleCarryAuto(true) end
		elseif not agarrado and S.carryPorAuto and not S.carryManual then
			S.carryPorAuto = false
			if setToggleCarryAuto then setToggleCarryAuto(false) end
		end
	end

	if hum then
		if not S.usandoMia then S.velJuego = hum.WalkSpeed end
		local v = velocidadObjetivo()
		if S.modo == nil and v == 30 and not S.batNormal then
			if S.usandoMia and S.velJuego then
				hum.WalkSpeed = S.velJuego
				S.usandoMia = false
			end
		else
			hum.WalkSpeed = v
			S.usandoMia = true
		end
	end

	if S.tpBat then perseguirYGolpear() end

	if S.batNormal then
		aplicarSinColision(char)
		sinColisionActivo = true
		batNormalPerseguir(dt)
	elseif sinColisionActivo then
		restaurarColision()
		sinColisionActivo = false
	end

	if (S.autoLeft or S.autoRight) and raiz and hum then
		if os.clock() - ultimoAutoMovimiento > 0.3 then
			ultimoAutoMovimiento = os.clock()
			local destino = calcularDestinoAuto()
			if destino then hum:MoveTo(destino) end
		end
	end

	if raiz and etiquetaVel and etiquetaVel.Parent then
		local vel = raiz.AssemblyLinearVelocity
		etiquetaVel.Text = string.format("%.1f SPEED", Vector3.new(vel.X, 0, vel.Z).Magnitude)
	end
end)