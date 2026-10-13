-- LocalScript: 10 botones negros cuadrados en 2 columnas (5 y 5)
-- Colócalo en: StarterPlayer > StarterPlayerScripts

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
-- Configuración
------------------------------------------------------------
local TAMANO_BOTON = 62       -- ⬅️ más grande (antes 56)
local ESPACIO       = 8
local COLUMNAS      = 2
local FILAS         = 5

local anchoTotal = (COLUMNAS * TAMANO_BOTON) + ((COLUMNAS - 1) * ESPACIO)
local altoTotal  = (FILAS    * TAMANO_BOTON) + ((FILAS    - 1) * ESPACIO)

local contenedor = Instance.new("Frame")
contenedor.Name = "Contenedor"
contenedor.BackgroundTransparency = 1
contenedor.Size = UDim2.new(0, anchoTotal, 0, altoTotal)
contenedor.AnchorPoint = Vector2.new(1, 1)          -- anclado abajo-derecha
contenedor.Position = UDim2.new(1, -20, 1, -120)    -- ⬅️ ajustado para ver todo
contenedor.Parent = screenGui

------------------------------------------------------------
-- Layout en cuadrícula (2 columnas x 5 filas)
------------------------------------------------------------
local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, TAMANO_BOTON, 0, TAMANO_BOTON)
grid.CellPadding = UDim2.new(0, ESPACIO, 0, ESPACIO)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = COLUMNAS      -- fuerza 2 columnas
grid.Parent = contenedor

------------------------------------------------------------
-- Crear los 10 botones (5 por columna)
------------------------------------------------------------
for i = 1, 10 do
	local boton = Instance.new("TextButton")
	boton.Name = "Boton_" .. i
	boton.Text = ""
	boton.AutoButtonColor = true
	boton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	boton.BorderSizePixel = 0
	boton.LayoutOrder = i
	boton.Parent = contenedor

	-- ⬅️ Esquinas más redondeadas
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)     -- antes 6, ahora más redondeado
	corner.Parent = boton

	boton.MouseButton1Click:Connect(function()
		print("Botón " .. i .. " pulsado")
	end)
end