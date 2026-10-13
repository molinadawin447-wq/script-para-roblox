-- LocalScript: 10 botones negros cuadrados en 2 columnas (5 y 5)
-- Colócalo en: StarterPlayer > StarterPlayerScripts  (o dentro de un ScreenGui)
-- Posicionado arriba del botón de salto en móvil.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- GUI principal
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BotonesNegrosGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

------------------------------------------------------------
-- Contenedor: anclado abajo-derecha, encima del botón de saltar
-- El botón de salto en móvil suele estar ~ a 90-110 px del borde inferior
-- y ~ 90-110 px del borde derecho.
------------------------------------------------------------
local TAMANO_BOTON = 44       -- tamaño de cada botón (px)
local ESPACIO       = 8       -- separación entre botones (px)
local COLUMNAS      = 2
local FILAS         = 5

local anchoTotal = (COLUMNAS * TAMANO_BOTON) + ((COLUMNAS - 1) * ESPACIO)
local altoTotal  = (FILAS    * TAMANO_BOTON) + ((FILAS    - 1) * ESPACIO)

local contenedor = Instance.new("Frame")
contenedor.Name = "Contenedor"
contenedor.BackgroundTransparency = 1
contenedor.Size = UDim2.new(0, anchoTotal, 0, altoTotal)
contenedor.AnchorPoint = Vector2.new(1, 1)          -- anclado abajo-derecha
contenedor.Position = UDim2.new(1, -20, 1, -180)    -- 20px del borde derecho, 180px del inferior
contenedor.Parent = screenGui

------------------------------------------------------------
-- Layout en cuadrícula
------------------------------------------------------------
local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, TAMANO_BOTON, 0, TAMANO_BOTON)
grid.CellPadding = UDim2.new(0, ESPACIO, 0, ESPACIO)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = COLUMNAS
grid.Parent = contenedor

------------------------------------------------------------
-- Crear los 10 botones
------------------------------------------------------------
for i = 1, 10 do
	local boton = Instance.new("TextButton")
	boton.Name = "Boton_" .. i
	boton.Text = ""                              -- sin texto
	boton.AutoButtonColor = true
	boton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- negro
	boton.BorderSizePixel = 0
	boton.LayoutOrder = i
	boton.Parent = contenedor

	-- Esquinas redondeadas sutiles (opcional, pon 0 para cuadrados puros)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = boton

	-- Acción al pulsar (edítala según lo que necesites)
	boton.MouseButton1Click:Connect(function()
		print("Botón " .. i .. " pulsado")
	end)
end