--[[
	BOOTSWARE BEST ANTI TP BAT
	GUI exact + logique Anti TP Bat fonctionnelle
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local environment = (type(getgenv) == "function" and getgenv()) or _G

pcall(function()
	local old = PlayerGui:FindFirstChild("BootswareBestAntiTPBat")
	if old then old:Destroy() end
end)

-- ===================== STATE =====================
local CONFIG_FILE = "BootswareAntiTPBat_Config.json"
local enabled = false
local boundKey = Enum.KeyCode.T
local waitingForKey = false
local version = "V3"

local runtime = {
	alive = true,
	enabled = false,
	character = nil,
	rootPart = nil,
	fakeRoot = nil,
	stepConnection = nil,
}
environment.__BOOTSWARE_RUNTIME = runtime

local function saveConfig()
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode({
				enabled = enabled,
				key = boundKey.Name,
				version = version,
			}))
		end
	end)
end

local function loadConfig()
	pcall(function()
		if isfile and isfile(CONFIG_FILE) then
			local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
			if type(data) == "table" then
				if data.enabled ~= nil then enabled = data.enabled == true end
				if type(data.key) == "string" then
					local ok, kc = pcall(function() return Enum.KeyCode[data.key] end)
					if ok and kc then boundKey = kc end
				end
				if type(data.version) == "string" then version = data.version end
			end
		end
	end)
end
loadConfig()

-- ===================== ANTI TP BAT LOGIC =====================
local FAKE_ROOT_Y = 1e8
local FAKE_ROOT_VELOCITY = Vector3.zero

local function findGlobalFunction(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		local v = rawget(environment, name)
		if type(v) == "function" then return v end
		v = rawget(_G, name)
		if type(v) == "function" then return v end
	end
	return nil
end

local function setHidden(instance, property, value)
	if not instance then return false end
	local setter = findGlobalFunction("sethiddenproperty", "set_hidden_property", "sethiddenprop")
	if setter then
		local ok = pcall(setter, instance, property, value)
		if ok then return true end
	end
	return pcall(function() instance[property] = value end)
end

local function getHidden(instance, property)
	if not instance then return false, nil end
	local getter = findGlobalFunction("gethiddenproperty", "get_hidden_property", "gethiddenprop")
	if getter then
		local ok, value = pcall(getter, instance, property)
		if ok then return true, value end
	end
	local ok, value = pcall(function() return instance[property] end)
	return ok, value
end

local function isBasePart(inst)
	if not inst then return false end
	local ok, r = pcall(function() return inst:IsA("BasePart") end)
	return ok and r == true
end

local function getCurrentRoot(character)
	character = character or LocalPlayer.Character
	if not character then return nil end
	local ok, root = pcall(function() return character:FindFirstChild("HumanoidRootPart") end)
	if ok and isBasePart(root) then return root end
	return nil
end

local function destroyFakeRoot()
	if runtime.fakeRoot then
		pcall(function() runtime.fakeRoot:Destroy() end)
		runtime.fakeRoot = nil
	end
end

local function restoreReplicationRoot()
	local root = runtime.rootPart
	if isBasePart(root) then
		setHidden(root, "PhysicsRepRootPart", root)
	end
end

local function createFakeRoot(rootPart)
	destroyFakeRoot()
	if not isBasePart(rootPart) then return nil end
	local fake = Instance.new("Part")
	fake.Name = "BootswareFakeRepRoot"
	fake.Size = Vector3.new(2, 2, 1)
	fake.Transparency = 1
	fake.Anchored = true
	fake.CanCollide = false
	fake.CanQuery = false
	fake.CanTouch = false
	fake.Massless = true
	fake.CFrame = CFrame.new(rootPart.Position.X, FAKE_ROOT_Y, rootPart.Position.Z)
	fake.Parent = workspace
	runtime.fakeRoot = fake
	return fake
end

local function assignFakeReplicationRoot(rootPart, fake)
	if not isBasePart(rootPart) or not isBasePart(fake) then return end
	setHidden(rootPart, "PhysicsRepRootPart", fake)
end

local function stepDesync()
	if not runtime.enabled or not runtime.alive then return end
	local root = runtime.rootPart
	if not isBasePart(root) or not root.Parent then
		root = getCurrentRoot(runtime.character)
		runtime.rootPart = root
		if not root then return end
	end
	if not isBasePart(runtime.fakeRoot) or not runtime.fakeRoot.Parent then
		local fake = createFakeRoot(root)
		if fake then assignFakeReplicationRoot(root, fake) end
		return
	end
	local fake = runtime.fakeRoot
	local ok, rootPos, fakePos = pcall(function() return root.Position, fake.Position end)
	if ok and (math.abs(rootPos.X - fakePos.X) > 0.01 or math.abs(rootPos.Z - fakePos.Z) > 0.01 or math.abs(fakePos.Y - FAKE_ROOT_Y) > 0.01) then
		pcall(function() fake.CFrame = CFrame.new(rootPos.X, FAKE_ROOT_Y, rootPos.Z) end)
	end
	pcall(function()
		fake.Anchored = true
		fake.AssemblyLinearVelocity = FAKE_ROOT_VELOCITY
	end)
	local got, current = getHidden(root, "PhysicsRepRootPart")
	if not got or current ~= fake then
		setHidden(root, "PhysicsRepRootPart", fake)
	end
end

local function stopStepConnection()
	if runtime.stepConnection then
		pcall(function() runtime.stepConnection:Disconnect() end)
		runtime.stepConnection = nil
	end
end

local function startStepConnection()
	stopStepConnection()
	runtime.stepConnection = RunService.Stepped:Connect(stepDesync)
end

local function setEnabled(on)
	on = on == true
	enabled = on
	runtime.enabled = on
	if on then
		local root = getCurrentRoot(LocalPlayer.Character)
		runtime.character = LocalPlayer.Character
		runtime.rootPart = root
		if not root then
			enabled = false
			runtime.enabled = false
			saveConfig()
			return false
		end
		local fake = createFakeRoot(root)
		assignFakeReplicationRoot(root, fake)
		startStepConnection()
	else
		stopStepConnection()
		restoreReplicationRoot()
		destroyFakeRoot()
	end
	saveConfig()
	return enabled
end

local function bindCharacter(character)
	runtime.character = character
	runtime.rootPart = getCurrentRoot(character)
	if runtime.enabled then
		destroyFakeRoot()
		local root = runtime.rootPart
		if not root and character then
			local ok, waited = pcall(function() return character:WaitForChild("HumanoidRootPart", 8) end)
			if ok and isBasePart(waited) then
				root = waited
				runtime.rootPart = root
			end
		end
		if root then
			local fake = createFakeRoot(root)
			assignFakeReplicationRoot(root, fake)
			startStepConnection()
		end
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.defer(bindCharacter, char)
end)
if LocalPlayer.Character then
	bindCharacter(LocalPlayer.Character)
end

-- ===================== GUI =====================
local BootswareBestAntiTPBat = Instance.new("ScreenGui")
BootswareBestAntiTPBat.Name = "BootswareBestAntiTPBat"
BootswareBestAntiTPBat.IgnoreGuiInset = true
BootswareBestAntiTPBat.ResetOnSpawn = false
BootswareBestAntiTPBat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BootswareBestAntiTPBat.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -130, 0.5, -72)
Main.Size = UDim2.new(0, 260, 0, 145)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Parent = BootswareBestAntiTPBat
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(210, 210, 220)
UIStroke.Thickness = 1.2
UIStroke.Transparency = 0.5
UIStroke.Parent = Main

local BG = Instance.new("ImageLabel")
BG.Name = "BG"
BG.ZIndex = 0
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundTransparency = 1
BG.BorderSizePixel = 0
BG.Image = "rbxthumb://type=Asset&id=110992138835956&w=420&h=420"
BG.ScaleType = Enum.ScaleType.Crop
BG.Parent = Main
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 20)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.92
Frame.BorderSizePixel = 0
Frame.Parent = Main
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 20)

-- Header
local Frame2 = Instance.new("Frame")
Frame2.ZIndex = 5
Frame2.Position = UDim2.new(0, 6, 0, 4)
Frame2.Size = UDim2.new(1, -12, 0, 34)
Frame2.BackgroundTransparency = 1
Frame2.Parent = Main

local Cube = Instance.new("Frame")
Cube.Name = "Cube"
Cube.ZIndex = 6
Cube.Position = UDim2.new(0, 4, 0.5, -8)
Cube.Size = UDim2.new(0, 16, 0, 16)
Cube.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Cube.BorderSizePixel = 0
Cube.Rotation = 67
Cube.Parent = Frame2
Instance.new("UICorner", Cube).CornerRadius = UDim.new(0, 4)
local cubeStroke = Instance.new("UIStroke", Cube)
cubeStroke.Color = Color3.fromRGB(210, 210, 220)
cubeStroke.Thickness = 1.4
cubeStroke.Transparency = 0.2
local cubeInner = Instance.new("Frame", Cube)
cubeInner.ZIndex = 7
cubeInner.Position = UDim2.new(0.5, -3, 0.5, -3)
cubeInner.Size = UDim2.new(0, 6, 0, 6)
cubeInner.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
cubeInner.BorderSizePixel = 0
Instance.new("UICorner", cubeInner).CornerRadius = UDim.new(0, 2)

local Title = Instance.new("TextLabel")
Title.ZIndex = 6
Title.Position = UDim2.new(0, 26, 0, 0)
Title.Size = UDim2.new(1, -94, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "BOOTSWARE BEST ANTI TP BAT"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame2

local VersionBtn = Instance.new("TextButton")
VersionBtn.ZIndex = 7
VersionBtn.Position = UDim2.new(1, -56, 0.5, -11)
VersionBtn.Size = UDim2.new(0, 52, 0, 22)
VersionBtn.BackgroundColor3 = Color3.fromRGB(72, 66, 104)
VersionBtn.BackgroundTransparency = 0.1
VersionBtn.BorderSizePixel = 0
VersionBtn.Text = version
VersionBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
VersionBtn.TextSize = 10
VersionBtn.Font = Enum.Font.GothamBold
VersionBtn.AutoButtonColor = false
VersionBtn.Parent = Frame2
Instance.new("UICorner", VersionBtn).CornerRadius = UDim.new(0, 7)
local vStroke = Instance.new("UIStroke", VersionBtn)
vStroke.Color = Color3.fromRGB(210, 210, 220)
vStroke.Transparency = 0.7

-- Divider
local Divider = Instance.new("Frame")
Divider.ZIndex = 5
Divider.Position = UDim2.new(0, 8, 0, 42)
Divider.Size = UDim2.new(1, -16, 0, 1)
Divider.BackgroundColor3 = Color3.fromRGB(210, 210, 220)
Divider.BackgroundTransparency = 0.55
Divider.BorderSizePixel = 0
Divider.Parent = Main

-- Content
local Content = Instance.new("Frame")
Content.ZIndex = 5
Content.Position = UDim2.new(0, 8, 0, 48)
Content.Size = UDim2.new(1, -16, 1, -56)
Content.BackgroundTransparency = 1
Content.Parent = Main

local list = Instance.new("UIListLayout", Content)
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle row
local ToggleRow = Instance.new("Frame")
ToggleRow.ZIndex = 5
ToggleRow.LayoutOrder = 1
ToggleRow.Size = UDim2.new(1, 0, 0, 34)
ToggleRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
ToggleRow.BackgroundTransparency = 0.55
ToggleRow.BorderSizePixel = 0
ToggleRow.Parent = Content
Instance.new("UICorner", ToggleRow).CornerRadius = UDim.new(0, 12)
local tStroke = Instance.new("UIStroke", ToggleRow)
tStroke.Color = Color3.fromRGB(70, 70, 80)
tStroke.Transparency = 0.55

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.ZIndex = 6
ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
ToggleLabel.Size = UDim2.new(0, 120, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "BEST ANTI TP BAT"
ToggleLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
ToggleLabel.TextSize = 12
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleRow

local ToggleBg = Instance.new("Frame")
ToggleBg.ZIndex = 6
ToggleBg.Position = UDim2.new(1, -60, 0.5, -12)
ToggleBg.Size = UDim2.new(0, 48, 0, 24)
ToggleBg.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
ToggleBg.BorderSizePixel = 0
ToggleBg.Parent = ToggleRow
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleKnob = Instance.new("Frame")
ToggleKnob.ZIndex = 7
ToggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Parent = ToggleBg
Instance.new("UICorner", ToggleKnob).CornerRadius = UDim.new(1, 0)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.ZIndex = 8
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleRow

-- Keybind row
local KeyRow = Instance.new("Frame")
KeyRow.ZIndex = 5
KeyRow.LayoutOrder = 2
KeyRow.Size = UDim2.new(1, 0, 0, 32)
KeyRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
KeyRow.BackgroundTransparency = 0.55
KeyRow.BorderSizePixel = 0
KeyRow.Parent = Content
Instance.new("UICorner", KeyRow).CornerRadius = UDim.new(0, 12)
local kStroke = Instance.new("UIStroke", KeyRow)
kStroke.Color = Color3.fromRGB(70, 70, 80)
kStroke.Transparency = 0.55

local KeyLabel = Instance.new("TextLabel")
KeyLabel.ZIndex = 6
KeyLabel.Position = UDim2.new(0, 12, 0, 0)
KeyLabel.Size = UDim2.new(0, 80, 1, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Keybind"
KeyLabel.TextColor3 = Color3.fromRGB(140, 140, 155)
KeyLabel.TextSize = 12
KeyLabel.Font = Enum.Font.GothamMedium
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = KeyRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.ZIndex = 7
KeyBtn.Position = UDim2.new(1, -72, 0.5, -12)
KeyBtn.Size = UDim2.new(0, 60, 0, 24)
KeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyBtn.BackgroundTransparency = 0.4
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = boundKey.Name
KeyBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
KeyBtn.TextSize = 11
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.AutoButtonColor = false
KeyBtn.Parent = KeyRow
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)
local keyStroke = Instance.new("UIStroke", KeyBtn)
keyStroke.Color = Color3.fromRGB(210, 210, 220)
keyStroke.Transparency = 0.78

-- ===================== UI LOGIC =====================
local function setToggleVisual(on)
	TweenService:Create(ToggleBg, TweenInfo.new(0.15), {
		BackgroundColor3 = on and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(55, 55, 65)
	}):Play()
	TweenService:Create(ToggleKnob, TweenInfo.new(0.15), {
		Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	}):Play()
	cubeStroke.Color = on and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(210, 210, 220)
	UIStroke.Color = on and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(210, 210, 220)
end

ToggleBtn.MouseButton1Click:Connect(function()
	local ok = setEnabled(not enabled)
	setToggleVisual(enabled)
end)

KeyBtn.MouseButton1Click:Connect(function()
	waitingForKey = true
	KeyBtn.Text = "..."
end)

VersionBtn.MouseButton1Click:Connect(function()
	if version == "V3" then
		version = "V2"
	elseif version == "V2" then
		version = "V1"
	else
		version = "V3"
	end
	VersionBtn.Text = version
	saveConfig()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
			boundKey = input.KeyCode
			KeyBtn.Text = boundKey.Name
			saveConfig()
		else
			KeyBtn.Text = boundKey.Name
		end
		waitingForKey = false
		return
	end
	if input.KeyCode == boundKey then
		setEnabled(not enabled)
		setToggleVisual(enabled)
	end
end)

-- Drag
local dragging, dragStart, startPos
Frame2.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- Init
setToggleVisual(enabled)
if enabled then
	setEnabled(true)
end

runtime.destroy = function()
	runtime.alive = false
	stopStepConnection()
	restoreReplicationRoot()
	destroyFakeRoot()
	pcall(function() BootswareBestAntiTPBat:Destroy() end)
end

print("[BOOTSWARE BEST ANTI TP BAT] Loaded")