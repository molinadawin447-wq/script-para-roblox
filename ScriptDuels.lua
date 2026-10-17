"-- ============================================================================
-- LEAKED BY /printed • NUMBER 1
-- Branding pass: readable source markers, console signature, UI micro-watermarks.
-- Original gameplay logic is intentionally left unchanged by this branding pass.
-- ============================================================================
print("[ /printed ] LEAKED BY /printed • NUMBER 1 | VampireHub")

local W = {}
repeat
	task.wait()
until game:IsLoaded()
local bt = game:GetService("Players")
local pt = game:GetService("RunService")
local Mt = game:GetService("UserInputService")
pcall(function()
	if _G._VH_uncapFps then
		_G._VH_uncapFps(999)
	end
end)
local gt = game:GetService("TweenService")
local Ht = game:GetService("HttpService")
local Ft = game:GetService("Lighting")
local Rt = bt.LocalPlayer
local Pt = setmetatable({}, { __mode = "k" })
local ht = 0
local lt
lt = pt.Heartbeat:Connect(function(lt)
	ht = ht + (lt or 0)
	if ht < 0.03333333333333333 then
		return
	end

	ht = 0
	local ht = Rt.Character
	local lt = ht and ht:FindFirstChild("HumanoidRootPart")
	if not lt then
		return
	end

	local ht = os.clock()
	for Dt, Dt in ipairs(bt:GetPlayers()) do
		if Dt ~= Rt then
			local zt = Dt.Character
			local vt = zt and zt:FindFirstChild("HumanoidRootPart")
			local qt = zt and zt:FindFirstChildOfClass("Humanoid")
			if vt and qt and qt.Health > 0 then
				local qt = vt.Position
				local Zt = vt.AssemblyLinearVelocity
				local Et = vt.AssemblyAngularVelocity
				local vt = qt.X == qt.X
					and qt.Y == qt.Y
					and qt.Z == qt.Z
					and math.abs(qt.X) < 1000000
					and math.abs(qt.Y) < 1000000
					and math.abs(qt.Z) < 1000000
				local rt = vt and (lt.Position - qt).Magnitude or math.huge
				local lt = vt
					and qt.Y > -30.0
					and qt.Y < 350
					and rt <= 300
					and Zt.Magnitude <= 180
					and Et.Magnitude <= 45
				local Zt = Pt[Dt]
				if not Zt or Zt.character ~= zt then
					Zt = { character = zt, locked = false, candidate = nil, candidateAt = nil, candidateCount = 0 }
					Pt[Dt] = Zt
				end

				if vt and Zt.lastObserved and (qt - Zt.lastObserved).Magnitude >= 8 then
					Zt.locked = true
				end

				if not lt then
					Zt.locked = true
					Zt.candidate = nil
					Zt.candidateAt = nil
					Zt.candidateCount = 0
				elseif not Zt.locked then
					if Zt.candidate and (qt - Zt.candidate).Magnitude <= 7 then
						Zt.candidate = Zt.candidate:Lerp(qt, 0.35)
						Zt.candidateCount = (Zt.candidateCount or 0) + 1
						if Zt.candidateCount >= 4 and ht - (Zt.candidateAt or ht) >= 0.1 then
							Zt.position = Zt.candidate
							Zt.positionAt = ht
							Zt.confirmed = true
						end
					else
						Zt.candidate = qt
						Zt.candidateAt = ht
						Zt.candidateCount = 1
					end
				end

				if vt then
					Zt.lastObserved = qt
				end
			end
		end
	end
end)
-- [ /printed ] INTRO / BRAND PRESENTATION
local function runIntro()
	local _I, _U, _C, _TI, _Us, _tw, _ts, _UD, _mc, _mf, _ma, _mh, _mx, _mn, _ti, _tr, _EGB, _ESQ, _ESB, _EDO, _EDI, _BgT, _BgC, _BSP, _TC3, _ZI, _TSz =
		Instance.new,
		UDim2.new,
		Color3.fromRGB,
		TweenInfo.new,
		UDim2.fromScale,
		task.wait,
		task.spawn,
		UDim.new,
		math.clamp,
		math.floor,
		math.abs,
		math.huge,
		math.max,
		math.min,
		table.insert,
		table.remove,
		Enum.Font.GothamBold,
		Enum.EasingStyle.Quad,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out,
		Enum.EasingDirection.InOut,
		"BackgroundTransparency",
		"BackgroundColor3",
		"BorderSizePixel",
		"TextColor3",
		"ZIndex",
		"TextSize"
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local Lighting = game:GetService("Lighting")
	local UserInputService = game:GetService("UserInputService")
	local TextService = game:GetService("TextService")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = _I("ScreenGui")
	screenGui.Name = "VampireIntro"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	local introSkipped = false
	local skipConnection = nil
	local introSound = nil
	local SOUND_ID = (_G and _G.__VioletteIntroSoundId and tonumber(_G.__VioletteIntroSoundId)) or 120267378058133
	local SKIP_SECONDS = 10
	local _theme = (_G and _G._VH_introTheme) or "original"
	local _isMono = (_theme ~= "original")
	local _isGreen = (
		_theme == "forest"
		or _theme == "jungle"
		or _theme == "16948826915"
		or _theme == "102609114992392"
	)
	local _isBlue = (_theme == "ocean" or _theme == "79809183056960")
	local _isBlack = (_theme == "79455822331118" or _theme == "8180153808" or _theme == "11761613059")
	local _isPurple = (_theme == "123540425987418" or _theme == "122195659108931")
	local _isBrown = (_theme == "6457947928")
	local _isGray = (_theme == "vampire" or _theme == "139546609567893")
	local _isPink = (_theme == "14430330747" or _theme == "17256388271")
	local _isYellow = (_theme == "golden" or _theme == "132372803152269")
	local PURPLE_MAIN = _isBlack and _C(22, 22, 22)
		or _isGray and _C(155, 155, 155)
		or _isYellow and _C(235, 185, 20)
		or _isGreen and _C(50, 195, 80)
		or _isBlue and _C(50, 130, 255)
		or _isPurple and _C(165, 75, 235)
		or _isBrown and _C(155, 98, 55)
		or _isPink and _C(235, 85, 165)
		or _C(220, 45, 45)
	local PURPLE_GLOW = _isBlack and _C(8, 8, 8)
		or _isGray and _C(100, 100, 100)
		or _isYellow and _C(180, 140, 10)
		or _isGreen and _C(30, 145, 55)
		or _isBlue and _C(30, 90, 210)
		or _isPurple and _C(110, 40, 180)
		or _isBrown and _C(105, 62, 30)
		or _isPink and _C(180, 45, 120)
		or _C(170, 25, 25)
	local PURPLE_LIGHT = _isBlack and _C(58, 58, 58)
		or _isGray and _C(195, 195, 195)
		or _isYellow and _C(255, 220, 70)
		or _isGreen and _C(100, 230, 125)
		or _isBlue and _C(100, 175, 255)
		or _isPurple and _C(210, 140, 255)
		or _isBrown and _C(205, 150, 95)
		or _isPink and _C(255, 145, 205)
		or _C(255, 90, 90)
	local blur = _I("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting
	local overlay = _I("Frame")
	overlay.Size = _Us(1, 1)
	overlay[_BgC] = _C(0, 0, 0)
	overlay[_BgT] = 0.3
	overlay[_BSP] = 0
	overlay[_ZI] = 1
	overlay.Parent = screenGui
	local darkOverlay = _I("Frame")
	darkOverlay.Size = _Us(1, 1)
	darkOverlay[_BgC] = (_isBlack or _isGray) and _C(8, 8, 8)
		or _isYellow and _C(15, 12, 0)
		or _isGreen and _C(0, 15, 5)
		or _isBlue and _C(0, 6, 18)
		or _isPurple and _C(10, 3, 18)
		or _isBrown and _C(16, 8, 3)
		or _isPink and _C(18, 3, 10)
		or _C(15, 0, 0)
	darkOverlay[_BgT] = 0.5
	darkOverlay[_BSP] = 0
	darkOverlay[_ZI] = 1
	darkOverlay.Parent = screenGui
	local vignette = _I("ImageLabel")
	vignette.Size = _Us(1, 1)
	vignette[_BgT] = 1
	vignette.Image = "rbxassetid://195611797"
	vignette.ImageColor3 = _C(0, 0, 0)
	vignette.ImageTransparency = 0.35
	vignette[_ZI] = 2
	vignette.Parent = screenGui
	local container = _I("Frame")
	container.Size = _U(0, 850, 0, 130)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.Position = _U(0.5, 0, 0.5, 0)
	container[_BgT] = 1
	container[_BSP] = 0
	container.ClipsDescendants = false
	container[_ZI] = 5
	container.Parent = screenGui
	local mainLabel = _I("TextLabel")
	mainLabel.Size = _U(1, 0, 1, 0)
	mainLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	mainLabel.Position = _U(0.5, 0, 0.5, 0)
	mainLabel[_BgT] = 1
	mainLabel.Text = "VAMPIRE"
	mainLabel[_TC3] = _C(255, 255, 255)
	mainLabel.TextStrokeColor3 = _C(0, 0, 0)
	mainLabel.TextStrokeTransparency = 0
	mainLabel.Font = Enum.Font.GothamBlack
	mainLabel[_TSz] = 88
	mainLabel.TextXAlignment = Enum.TextXAlignment.Center
	mainLabel.TextTransparency = 1
	mainLabel[_ZI] = 5
	mainLabel.Parent = container
	local leftLabel = _I("TextLabel")
	leftLabel.Size = _U(0, 480, 1, 0)
	leftLabel.AnchorPoint = Vector2.new(1, 0.5)
	leftLabel.Position = _U(0.5, -8, 0.5, 0)
	leftLabel[_BgT] = 1
	leftLabel.Text = "VAMP"
	leftLabel[_TC3] = _C(255, 255, 255)
	leftLabel.TextStrokeColor3 = _C(0, 0, 0)
	leftLabel.TextStrokeTransparency = 0
	leftLabel.Font = Enum.Font.GothamBlack
	leftLabel[_TSz] = 88
	leftLabel.TextXAlignment = Enum.TextXAlignment.Right
	leftLabel.TextTransparency = 1
	leftLabel[_ZI] = 5
	leftLabel.Visible = true
	leftLabel.Parent = container
	local rightLabel = _I("TextLabel")
	rightLabel.Size = _U(0, 200, 1, 0)
	rightLabel.AnchorPoint = Vector2.new(0, 0.5)
	rightLabel.Position = _U(0.5, -8, 0.5, 0)
	rightLabel[_BgT] = 1
	rightLabel.Text = "IRE"
	rightLabel[_TC3] = _C(255, 255, 255)
	rightLabel.TextStrokeColor3 = _C(0, 0, 0)
	rightLabel.TextStrokeTransparency = 0
	rightLabel.Font = Enum.Font.GothamBlack
	rightLabel[_TSz] = 88
	rightLabel.TextXAlignment = Enum.TextXAlignment.Left
	rightLabel.TextTransparency = 1
	rightLabel[_ZI] = 5
	rightLabel.Visible = true
	rightLabel.Parent = container
	local lightBeam = _I("Frame")
	lightBeam.Size = _U(0, 0, 1.1, 0)
	lightBeam.AnchorPoint = Vector2.new(0, 0.5)
	lightBeam.Position = _U(0, -20, 0.5, 0)
	lightBeam[_BgC] = PURPLE_MAIN
	lightBeam[_BgT] = 0.5
	lightBeam[_BSP] = 0
	lightBeam[_ZI] = 6
	lightBeam.Parent = container
	local beamGlow = _I("Frame")
	beamGlow.Size = _U(0, 0, 1.3, 0)
	beamGlow.AnchorPoint = Vector2.new(0, 0.5)
	beamGlow.Position = _U(0, -20, 0.5, 0)
	beamGlow[_BgC] = PURPLE_GLOW
	beamGlow[_BgT] = 0.7
	beamGlow[_BSP] = 0
	beamGlow[_ZI] = 5
	beamGlow.Parent = container
	local beamSparkles = _I("Frame")
	beamSparkles.Size = _U(0, 0, 1, 0)
	beamSparkles.AnchorPoint = Vector2.new(0, 0.5)
	beamSparkles.Position = _U(0, -20, 0.5, 0)
	beamSparkles[_BgC] = _C(255, 255, 255)
	beamSparkles[_BgT] = 0.8
	beamSparkles[_BSP] = 0
	beamSparkles[_ZI] = 7
	beamSparkles.Parent = container
	local subLabel = _I("TextLabel")
	subLabel.Size = _U(1, 0, 0, 40)
	subLabel.AnchorPoint = Vector2.new(0.5, 0)
	subLabel.Position = _U(0.5, 0, 0.5, 70)
	subLabel[_BgT] = 1
	subLabel.Text = "vampire hub  •  LEAKED BY /printed #1"
	subLabel[_TC3] = PURPLE_MAIN
	subLabel.Font = _EGB
	subLabel[_TSz] = 14
	subLabel.TextXAlignment = Enum.TextXAlignment.Center
	subLabel.TextTransparency = 1
	subLabel[_ZI] = 5
	subLabel.Parent = screenGui
	local subLabel2 = _I("TextLabel")
	subLabel2.Size = _U(1, 0, 0, 25)
	subLabel2.AnchorPoint = Vector2.new(0.5, 0)
	subLabel2.Position = _U(0.5, 0, 0.5, 105)
	subLabel2[_BgT] = 1
	subLabel2.Text = "DOUBLE TAP TO SKIP"
	subLabel2[_TC3] = _isMono and _C(140, 140, 140) or _C(160, 70, 70)
	subLabel2.Font = Enum.Font.Gotham
	subLabel2[_TSz] = 11
	subLabel2.TextXAlignment = Enum.TextXAlignment.Center
	subLabel2.TextTransparency = 1
	subLabel2[_ZI] = 5
	subLabel2.Parent = screenGui
	local accentBar = _I("Frame")
	accentBar.Size = _U(0, 0, 0, 2)
	accentBar.AnchorPoint = Vector2.new(0.5, 0)
	accentBar.Position = _U(0.5, 0, 0.5, 62)
	accentBar[_BgC] = PURPLE_MAIN
	accentBar[_BgT] = 0
	accentBar[_BSP] = 0
	accentBar[_ZI] = 5
	accentBar.Parent = screenGui
	local flashFrame = _I("Frame")
	flashFrame.Size = _Us(1, 1)
	flashFrame[_BgC] = _C(255, 255, 255)
	flashFrame[_BgT] = 1
	flashFrame[_BSP] = 0
	flashFrame[_ZI] = 10
	flashFrame.Parent = screenGui
	local glitchContainer = _I("Frame")
	glitchContainer.Size = _U(1, 0, 1, 0)
	glitchContainer[_BgT] = 1
	glitchContainer[_ZI] = 6
	glitchContainer.Parent = screenGui
	local dripContainer = _I("Frame")
	dripContainer.Size = _U(1, 0, 1, 0)
	dripContainer[_BgT] = 1
	dripContainer[_ZI] = 7
	dripContainer.Parent = screenGui
	local skipBtnFrame = _I("Frame")
	skipBtnFrame.Size = _U(0, 90, 0, 34)
	skipBtnFrame.AnchorPoint = Vector2.new(1, 1)
	skipBtnFrame.Position = _U(1, -18, 1, -18)
	skipBtnFrame[_BgC] = _isMono and _C(30, 30, 30) or _C(50, 8, 8)
	skipBtnFrame[_BgT] = 0.25
	skipBtnFrame[_BSP] = 0
	skipBtnFrame[_ZI] = 15
	skipBtnFrame.Parent = screenGui
	local _skipCorner = _I("UICorner")
	_skipCorner.CornerRadius = _UD(0, 8)
	_skipCorner.Parent = skipBtnFrame
	local _skipStroke = _I("UIStroke")
	_skipStroke.Color = PURPLE_MAIN
	_skipStroke.Thickness = 1.5
	_skipStroke.Transparency = 0.3
	_skipStroke.Parent = skipBtnFrame
	local tapToRemoveLabel = _I("TextButton")
	tapToRemoveLabel.Size = _Us(1, 1)
	tapToRemoveLabel[_BgT] = 1
	tapToRemoveLabel.Text = "SKIP  ›"
	tapToRemoveLabel[_TC3] = PURPLE_MAIN
	tapToRemoveLabel.Font = _EGB
	tapToRemoveLabel[_TSz] = 13
	tapToRemoveLabel.TextXAlignment = Enum.TextXAlignment.Center
	tapToRemoveLabel.TextTransparency = 0
	tapToRemoveLabel[_ZI] = 16
	tapToRemoveLabel.Parent = skipBtnFrame
	tapToRemoveLabel.Activated:Connect(function()
		skipIntro()
	end)
	local function doFlash(color, alpha, duration)
		flashFrame[_BgC] = color or Color3.new(1, 1, 1)
		flashFrame[_BgT] = 1 - (alpha or 0.85)
		task.delay(duration or 0.06, function()
			if not introSkipped then
				TweenService:Create(flashFrame, _TI(0.1, _ESQ), { BackgroundTransparency = 1 }):Play()
			else
				flashFrame[_BgT] = 1
			end
		end)
	end
	local function runLightBeam()
		lightBeam.Size = _U(0, 45, 1.1, 0)
		beamGlow.Size = _U(0, 65, 1.3, 0)
		beamSparkles.Size = _U(0, 45, 1, 0)
		lightBeam[_BgT] = 0.35
		beamGlow[_BgT] = 0.55
		beamSparkles[_BgT] = 0.75
		local beamTween = TweenService:Create(lightBeam, _TI(0.8, _ESQ, _EDI), { Position = _U(1, 20, 0.5, 0) })
		beamTween:Play()
		TweenService:Create(beamGlow, _TI(0.8, _ESQ, _EDI), { Position = _U(1, 20, 0.5, 0) }):Play()
		TweenService:Create(beamSparkles, _TI(0.8, _ESQ, _EDI), { Position = _U(1, 20, 0.5, 0) }):Play()
		local pulseCount = 0
		local pulseConnection
		pulseConnection = game:GetService("RunService").Heartbeat:Connect(function()
			if introSkipped then
				if pulseConnection then
					pulseConnection:Disconnect()
				end
				return
			end
			pulseCount = pulseCount + 1
			if pulseCount % 3 == 0 then
				local p = 0.3 + math.sin(pulseCount * 0.5) * 0.15
				lightBeam[_BgT] = 0.3 - (p * 0.2)
				beamGlow[_BgT] = 0.5 - (p * 0.1)
				beamSparkles[_BgT] = 0.7 - (p * 0.15)
			end
		end)
		beamTween.Completed:Wait()
		if pulseConnection then
			pulseConnection:Disconnect()
		end
		TweenService:Create(lightBeam, _TI(0.25), { BackgroundTransparency = 1, Size = _U(0, 0, 1.1, 0) }):Play()
		TweenService:Create(beamGlow, _TI(0.25), { BackgroundTransparency = 1, Size = _U(0, 0, 1.3, 0) }):Play()
		TweenService:Create(beamSparkles, _TI(0.25), { BackgroundTransparency = 1, Size = _U(0, 0, 1, 0) }):Play()
	end
	local function changeToPurple()
		_tw(0.2)
		TweenService
			:Create(mainLabel, _TI(0.4, _ESQ), { TextColor3 = _isMono and _C(180, 180, 180) or _C(220, 40, 40) })
			:Play()
	end
	local glitchChars = { "!", "#", "%", "/", "[", "]", "░", "▒", "▓", "—", "=", "*", "^", "~", "¦", "¤" }
	local function glitchText(lbl, original)
		if introSkipped then
			return
		end
		for i = 1, 4 do
			if introSkipped then
				break
			end
			local s = ""
			for c in original:gmatch(".") do
				s = s .. (math.random() < 0.35 and glitchChars[math.random(#glitchChars)] or c)
			end
			lbl.Text = s
			_tw(0.03)
		end
		if not introSkipped then
			lbl.Text = original
		end
	end
	local function addGlitchBar()
		local bar = _I("Frame")
		bar.Size = _U(1, 0, 0, math.random(2, 12))
		bar.Position = _U(0, 0, math.random(10, 90) / 100, 0)
		bar[_BgC] = PURPLE_MAIN
		bar[_BgT] = math.random(45, 70) / 100
		bar[_BSP] = 0
		bar[_ZI] = 6
		bar.Parent = glitchContainer
		task.delay(0.1, function()
			if bar then
				TweenService:Create(bar, _TI(0.1), { BackgroundTransparency = 1 }):Play()
				task.delay(0.1, function()
					bar:Destroy()
				end)
			end
		end)
	end
	local function shakeScreen(intensity, duration)
		if introSkipped then
			return
		end
		local startTime = tick()
		local steps = math.ceil(duration / 0.05)
		for _ = 1, steps do
			if introSkipped then
				break
			end
			local elapsed = tick() - startTime
			local cur = intensity * (1 - (elapsed / duration))
			if cur < 1 then
				cur = 1
			end
			local ox = math.random(-_mf(cur), _mf(cur))
			local oy = math.random(-_mf(cur * 0.5), _mf(cur * 0.5))
			leftLabel.Position = _U(0.5, -8 + ox, 0.5, oy)
			rightLabel.Position = _U(0.5, 8 + ox, 0.5, oy)
			_tw(0.05)
		end
		if not introSkipped then
			TweenService:Create(leftLabel, _TI(0.05), { Position = _U(0.5, -8, 0.5, 0) }):Play()
			TweenService:Create(rightLabel, _TI(0.05), { Position = _U(0.5, 8, 0.5, 0) }):Play()
		end
	end
	local function setupAudio()
		introSound = _I("Sound")
		introSound.SoundId = "rbxassetid://" .. SOUND_ID
		introSound.Volume = 0.7
		introSound.PlayOnRemove = false
		introSound.Parent = screenGui
		introSound.Loaded:Wait()
		introSound:Play()
		introSound.TimePosition = SKIP_SECONDS
		return introSound
	end
	local function fadeOutAudio(duration)
		if not introSound then
			return
		end
		local startVolume = introSound.Volume
		local steps = 10
		for i = 1, steps do
			if introSkipped or not introSound then
				break
			end
			introSound.Volume = startVolume * (1 - (i / steps))
			_tw(duration / steps)
		end
		if introSound then
			introSound.Volume = 0
			introSound:Stop()
		end
	end
	local function stopAudio()
		if introSound then
			introSound:Stop()
			introSound:Destroy()
		end
	end
	local activeDrips = 0
	local function createDrip(startX, startY, width, height, duration, delay)
		_tw(delay)
		if introSkipped then
			return
		end
		activeDrips = activeDrips + 1
		local drip = _I("Frame")
		drip.Size = _U(0, width, 0, height)
		drip.Position = _U(0.5, startX, 0.5, startY)
		drip[_BgC] = PURPLE_MAIN
		drip[_BgT] = 0.25
		drip[_BSP] = 0
		drip[_ZI] = 7
		drip.Parent = dripContainer
		local stretch = TweenService:Create(
			drip,
			_TI(duration * 0.35),
			{ Size = _U(0, width, 0, height + 22), BackgroundTransparency = 0.1 }
		)
		stretch:Play()
		_tw(duration * 0.35)
		if introSkipped then
			drip:Destroy()
			activeDrips = activeDrips - 1
			return
		end
		local fall = TweenService:Create(drip, _TI(duration * 0.65, _ESQ, Enum.EasingDirection.In), {
			Position = _U(0.5, startX + math.random(-3, 3), 0.5, startY + 80),
			BackgroundTransparency = 1,
		})
		fall:Play()
		fall.Completed:Connect(function()
			drip:Destroy()
			activeDrips = activeDrips - 1
		end)
	end
	local function startDripping()
		if introSkipped then
			return
		end
		local fullText = "VAMPIRE"
		local font = Enum.Font.GothamBlack
		local textSize = 88
		local textBoundsFull = TextService:GetTextSize(fullText, textSize, font, Vector2.new(_mh, _mh))
		local textHeight = textBoundsFull.Y
		local delayCounter = 0
		local drips = {}
		for i = 1, #fullText do
			local char = fullText:sub(i, i)
			local charBounds = TextService:GetTextSize(char, textSize, font, Vector2.new(_mh, _mh))
			local charWidth = charBounds.X
			local precedingWidth = 0
			if i > 1 then
				precedingWidth =
					TextService:GetTextSize(fullText:sub(1, i - 1), textSize, font, Vector2.new(_mh, _mh)).X
			end
			local totalTextWidth = textBoundsFull.X
			local charCenterX = -totalTextWidth / 2 + precedingWidth + charWidth / 2
			local startY = textHeight / 2 + 3
			local dripWidth = _mc(_mf(charWidth * 0.35), 3, 7)
			local dripHeight = math.random(4, 7)
			local dur = 0.5 + math.random() * 0.2
			local del = delayCounter * 0.07
			_ti(drips, {
				startX = charCenterX + math.random(-2, 2),
				startY = startY + math.random(0, 4),
				width = dripWidth,
				height = dripHeight,
				duration = dur,
				delay = del,
			})
			delayCounter = delayCounter + 1
		end
		for _, d in ipairs(drips) do
			if introSkipped then
				break
			end
			createDrip(d.startX, d.startY, d.width, d.height, d.duration, d.delay)
		end
	end
	function skipIntro()
		if introSkipped then
			return
		end
		introSkipped = true
		stopAudio()
		if skipConnection then
			skipConnection:Disconnect()
		end
		doFlash(_isMono and _C(200, 200, 200) or _C(255, 100, 100), 0.8, 0.1)
		mainLabel.Text = "VAMPIRE"
		local fadeInfo = _TI(0.25, _ESQ, Enum.EasingDirection.In)
		TweenService:Create(mainLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(leftLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(rightLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(subLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(subLabel2, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(accentBar, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(overlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(darkOverlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(blur, _TI(0.25), { Size = 0 }):Play()
		_tw(0.3)
		screenGui:Destroy()
		blur:Destroy()
	end
	local function playIntro()
		setupAudio()
		local _lastTapTime = 0
		skipConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end
			if
				input.UserInputType == Enum.UserInputType.Touch
				or input.UserInputType == Enum.UserInputType.MouseButton1
			then
				local now = tick()
				if now - _lastTapTime <= 0.4 then
					skipIntro()
				else
					_lastTapTime = now
				end
			end
		end)
		_ts(function()
			while not introSkipped and skipBtnFrame.Parent do
				for t = 0.25, 0.6, 0.05 do
					if introSkipped then
						break
					end
					skipBtnFrame[_BgT] = t
					_tw(0.06)
				end
				for t = 0.6, 0.25, -0.05 do
					if introSkipped then
						break
					end
					skipBtnFrame[_BgT] = t
					_tw(0.06)
				end
			end
		end)
		leftLabel.Position = _U(-0.9, 0, -0.6, 0)
		rightLabel.Position = _U(1.9, 0, 1.6, 0)
		leftLabel.Rotation = -30
		rightLabel.Rotation = 30
		mainLabel.TextTransparency = 1
		TweenService:Create(blur, _TI(0.7), { Size = 18 }):Play()
		TweenService:Create(overlay, _TI(0.7), { BackgroundTransparency = 0.2 }):Play()
		TweenService:Create(darkOverlay, _TI(0.7), { BackgroundTransparency = 0.4 }):Play()
		_tw(0.35)
		if introSkipped then
			return
		end
		TweenService:Create(leftLabel, _TI(0.45), { TextTransparency = 0 }):Play()
		TweenService:Create(rightLabel, _TI(0.45), { TextTransparency = 0 }):Play()
		TweenService:Create(
			leftLabel,
			_TI(0.55, Enum.EasingStyle.Elastic, _EDO),
			{ Position = _U(0.5, -220, 0.5, -80), Rotation = -15 }
		):Play()
		TweenService:Create(
			rightLabel,
			_TI(0.55, Enum.EasingStyle.Elastic, _EDO),
			{ Position = _U(0.5, 120, 0.5, 80), Rotation = 15 }
		):Play()
		_tw(0.45)
		if introSkipped then
			return
		end
		local smooth = _TI(0.4, _ESQ, _EDO)
		TweenService:Create(leftLabel, smooth, { Position = _U(0.5, -170, 0.5, -50), Rotation = -8 }):Play()
		TweenService:Create(rightLabel, smooth, { Position = _U(0.5, 80, 0.5, 50), Rotation = 8 }):Play()
		_tw(0.35)
		if introSkipped then
			return
		end
		TweenService:Create(leftLabel, smooth, { Position = _U(0.5, -120, 0.5, -25), Rotation = -4 }):Play()
		TweenService:Create(rightLabel, smooth, { Position = _U(0.5, 40, 0.5, 25), Rotation = 4 }):Play()
		_tw(0.3)
		if introSkipped then
			return
		end
		TweenService:Create(leftLabel, smooth, { Position = _U(0.5, -60, 0.5, -10), Rotation = -2 }):Play()
		TweenService:Create(rightLabel, smooth, { Position = _U(0.5, -10, 0.5, 10), Rotation = 2 }):Play()
		_tw(0.25)
		if introSkipped then
			return
		end
		local glitchEnd = tick() + 0.9
		while tick() < glitchEnd and not introSkipped do
			local ox = math.random(-20, 20)
			local oy = math.random(-10, 10)
			leftLabel.Position = _U(0.5, -60 + ox, 0.5, -10 + oy)
			rightLabel.Position = _U(0.5, -10 + ox, 0.5, 10 + oy)
			if math.random() < 0.35 then
				_ts(glitchText, leftLabel, "VAMP")
			end
			if math.random() < 0.35 then
				_ts(glitchText, rightLabel, "IRE")
			end
			if math.random() < 0.4 then
				addGlitchBar()
			end
			if math.random() < 0.1 then
				doFlash(PURPLE_MAIN, 0.2, 0.03)
			end
			_tw(0.045)
		end
		if introSkipped then
			return
		end
		leftLabel.Visible = false
		rightLabel.Visible = false
		mainLabel.TextTransparency = 0
		mainLabel[_TC3] = _C(255, 255, 255)
		doFlash(PURPLE_MAIN, 0.5, 0.05)
		_tw(0.08)
		if introSkipped then
			return
		end
		TweenService
			:Create(
				mainLabel,
				_TI(0.12, _ESB, Enum.EasingDirection.In),
				{ Position = _U(0.5, 0, 0.5, 0), TextSize = 92 }
			)
			:Play()
		_tw(0.12)
		if introSkipped then
			return
		end
		TweenService:Create(mainLabel, _TI(0.1), { TextSize = 88 }):Play()
		doFlash(_C(255, 255, 255), 0.95, 0.05)
		_tw(0.02)
		doFlash(PURPLE_MAIN, 0.65, 0.08)
		_ts(shakeScreen, 10, 0.25)
		runLightBeam()
		changeToPurple()
		TweenService:Create(accentBar, _TI(0.5, Enum.EasingStyle.Elastic, _EDO), { Size = _U(0, 420, 0, 2) }):Play()
		_tw(0.18)
		if introSkipped then
			return
		end
		TweenService:Create(subLabel, _TI(0.4), { TextTransparency = 0.05 }):Play()
		TweenService:Create(subLabel2, _TI(0.4), { TextTransparency = 0.15 }):Play()
		_tw(0.1)
		doFlash(_C(255, 255, 255), 0.3, 0.04)
		TweenService:Create(subLabel, _TI(0.2), { TextSize = 15 }):Play()
		_tw(0.2)
		TweenService:Create(subLabel, _TI(0.2), { TextSize = 14 }):Play()
		_tw(0.65)
		if introSkipped then
			return
		end
		startDripping()
		while activeDrips > 0 and not introSkipped do
			_tw(0.1)
		end
		if introSkipped then
			return
		end
		_tw(0.45)
		fadeOutAudio(1.2)
		local fadeInfo = _TI(0.85, _ESQ, Enum.EasingDirection.In)
		TweenService:Create(mainLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(subLabel, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(subLabel2, fadeInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(accentBar, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(overlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(darkOverlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(blur, _TI(0.85), { Size = 0 }):Play()
		TweenService:Create(dripContainer, fadeInfo, { BackgroundTransparency = 1 }):Play()
		_tw(0.9)
		stopAudio()
		if skipConnection then
			skipConnection:Disconnect()
		end
		screenGui:Destroy()
		blur:Destroy()
	end
	playIntro()
end
local kt = false
do
	local function Ct(ht)
		local lt
		pcall(function()
			if readfile then
				lt = readfile(ht)
			end
		end)
		return lt
	end

	local function ht(lt)
		local Dt = false
		pcall(function()
			if isfile then
				Dt = isfile(lt)
			elseif readfile then
				local zt = readfile(lt)
				Dt = (zt ~= nil)
			end
		end)
		return Dt
	end

	local lt = {
		original = true,
		vampire = true,
		golden = true,
		forest = true,
		jungle = true,
		ocean = true,
		["79809183056960"] = true,
		["79455822331118"] = true,
		["16948826915"] = true,
		["101793424727240"] = true,
		["123540425987418"] = true,
		["122195659108931"] = true,
		["6457947928"] = true,
		["102609114992392"] = true,
		["8180153808"] = true,
		["11761613059"] = true,
		["139546609567893"] = true,
		["14430330747"] = true,
		["17256388271"] = true,
		["132372803152269"] = true,
	}
	_G._VH_introTheme = "original"
	if ht("VampireHubConfig.json") then
		local ht = Ct("VampireHubConfig.json")
		if ht then
			local Dt, zt = pcall(function()
				return game:GetService("HttpService"):JSONDecode(ht)
			end)
			if Dt and type(zt) == "table" then
				if zt.showIntro == false then
					kt = true
				end

				if type(zt.activeBgImg) == "string" and lt[zt.activeBgImg] then
					_G._VH_introTheme = zt.activeBgImg
				end

				_G._VH_monoIntro = (_G._VH_introTheme ~= "original")
				local ht = {}
				if type(zt.favoriteBackgrounds) == "table" then
					for Dt, vt in pairs(zt.favoriteBackgrounds) do
						local zt = type(Dt) == "number" and vt or Dt
						local qt = type(Dt) == "number" or vt == true
						if qt and type(zt) == "string" and lt[zt] then
							ht[zt] = true
						end
					end
				end

				_G._VH_bgFavorites = ht
			end
		end
	end

	local ht = Ct("VampireHubIntro.state")
	if ht == "off" then
		kt = true
	elseif ht == "on" then
		kt = false
	end
end

_G.__VioletteIntroSoundId = 120267378058133
if not kt then
	task.spawn(runIntro)
end

task.wait()
local function It(Ct)
	return Ct == Enum.UserInputType.Gamepad1
		or Ct == Enum.UserInputType.Gamepad2
		or Ct == Enum.UserInputType.Gamepad3
		or Ct == Enum.UserInputType.Gamepad4
end

local function Ct(ht)
	return ht.UserInputType == Enum.UserInputType.Keyboard or It(ht.UserInputType)
end

local function ht(lt, Dt)
	local zt = false
	pcall(function()
		if writefile then
			writefile(lt, Dt)
			zt = true
		end
	end)
	return zt
end

local function lt(Dt)
	local zt = nil
	pcall(function()
		if readfile then
			zt = readfile(Dt)
		end
	end)
	return zt
end

local function Dt(zt)
	local vt = false
	pcall(function()
		if isfile then
			vt = isfile(zt)
		elseif readfile then
			local qt = readfile(zt)
			vt = (qt ~= nil)
		end
	end)
	return vt
end

-- [ /printed ] FEATURE STATE AND CONTROL CONFIGURATION
local zt = {
	normalSpeed = 60,
	carrySpeed = 30,
	speedToggled = false,
	autoBatToggled = false,
	autoBatVersion = "v1",
	speedChangeMethod = "v2",
	speedChangeMethodSaved = "v2",
	hittingCooldown = false,
	infJumpEnabled = false,
	antiRagdollEnabled = false,
	fpsBoostEnabled = false,
	guiVisible = true,
	safeModeEnabled = true,
	safeCarryLock = false,
	dropBrainrotMode = false,
	stopOnCountdown = false,
	countdownSafetyActive = false,
	stealBarPos = nil,
	isStealing = false,
	stealStartTime = nil,
	lastStealTick = 0,
	stealPausedUntil = 0,
	lastKnownHealth = 100,
	autoLeftEnabled = false,
	autoRightEnabled = false,
	autoLeftPhase = 1,
	autoRightPhase = 1,
	medusaLastUsed = 0,
	medusaDebounce = false,
	medusaCounterEnabled = false,
	_tpInProgress = false,
	lastMoveDir = Vector3.new(0, 0, 0),
	unwalkEnabled = false,
	headlessEnabled = false,
	korbloxEnabled = false,
	dropEnabled = false,
	dropType = "Jump Drop",
	holdInfJumpEnabled = true,
	jumpType = "hold",
	jumpPower = 45,
	batCounterEnabled = false,
	autoSwingEnabled = true,
	burstNormalSpeed = 15,
	burstCarrySpeed = 24.5,
	bypassNormalSpeed = 45,
	bypassCarrySpeed = 18,
	laggerMode = 0,
	_prevCarry = nil,
	_prevSpeed = false,
	burstPreset = "lagger",
	autoBatSpeed = 58,
	mirrorTPDownEnabled = false,
	desyncAimbotEnabled = false,
	desyncAimbotVersion = "v1",
	desyncStopAfterHit = false,
	antiDieEnabled = false,
	disablePredictionAt180 = true,
	lockedFOV = workspace.CurrentCamera.FieldOfView,
	stretchRezEnabled = false,
	stretchedResEnabled = false,
	stretchFOV = 120,
	activeSky = "default",
	activeBgImg = "original",
	bgFavorites = _G._VH_bgFavorites or {},
	stealMode = "semi",
	normalV2StopAt = 75,
	semiVersion = "v2",
	animEnabled = false,
	autoTpDownEnabled = false,
	tpDownHeight = 20,
	sideButtonsVisible = true,
	guiScale = 0.75,
	progressBarSize = 1,
	showProgressBar = true,
	stopOnHitEnabled = true,
	showProgressFPS = true,
	showProgressPing = true,
	sideButtonPositions = {},
	sideButtonSizes = {},
	sideButtonScale = 0.85,
	sideButtonType = "square",
	sideButtonLook = "black",
	sideButtonDragMode = "one",
	sideButtonDragModeSaved = "one",
	sideButtonsLocked = false,
	showButtonOutline = false,
	hiddenSideButtons = {},
	safetyLocked = false,
	kickWarningEnabled = true,
	autoCarryOnGrab = false,
	autoCarryVersion = "v2",
	autoPlayMode = "normal",
	introEnabled = not kt,
	lineEspEnabled = false,
	lineEspColor = "red",
	selectedAnim = "None",
	espAuraEnabled = true,
	espLineEnabled = true,
	espHitboxEnabled = true,
	espPanelOpen = false,
}
do
	if _G.SafeMode and type(_G.SafeMode.Stop) == "function" then
		pcall(_G.SafeMode.Stop)
	end

	_G.SafeMode = nil
end

local vt, qt, Zt, rt, jt
local et
local Tt
local Nt
local Kt = {}
local ct
local At, ut
local Ut
local Lt = false
local function Yt(Ot)
	if not pbFrame then
		return
	end

	local Bt = math.clamp(zt.progressBarSize or 1, 0.6, 1.4)
	local St = zt.showProgressFPS or zt.showProgressPing
	local tt = zt.showProgressFPS and zt.showProgressPing and 116
		or zt.showProgressFPS and 58
		or zt.showProgressPing and 76
		or 0
	local Xt = St and 236 + tt or 210
	pbFrame.Size = UDim2.new(0, Xt * Bt, 0, 35 * Bt)
	if Ot or not Lt then
		if zt.stealBarPos then
			local Ot, wt, ot, yt = zt.stealBarPos:match("([^,]+),([^,]+),([^,]+),([^,]+)")
			if Ot then
				pbFrame.Position = UDim2.new(tonumber(Ot), tonumber(wt), tonumber(ot), tonumber(yt))
			else
				pbFrame.Position = UDim2.new(0.5, -(Xt * Bt) / 2, 1, -60.0)
			end
		else
			pbFrame.Position = UDim2.new(0.5, -(Xt * Bt) / 2, 1, -60.0)
		end

		Lt = true
	end

	pbFrame.Visible = zt.showProgressBar == true
	if pbBg then
		pbBg.Size = UDim2.new(0, 210 * Bt, 1, 0)
		pbBg.Position = UDim2.new(0, 0, 0, 0)
	end

	if stealLbl then
		stealLbl.TextSize = 13 * Bt
	end

	if progressPct then
		progressPct.TextSize = 12 * Bt
	end

	if _prl then
		_prl.Visible = St
		_prl.Size = UDim2.new(0, tt * Bt, 1, 0)
		_prl.Position = UDim2.new(0, 222 * Bt, 0, 0)
		_prl.TextSize = 12 * Bt
	end
end

local Lt = {
	autoBat = Enum.KeyCode.E,
	speed = Enum.KeyCode.Q,
	lagger = Enum.KeyCode.Unknown,
	antiDie = Enum.KeyCode.Unknown,
	guiHide = Enum.KeyCode.LeftControl,
	autoLeft = Enum.KeyCode.Z,
	autoRight = Enum.KeyCode.C,
	dropBrainrot = Enum.KeyCode.H,
	tpDown = Enum.KeyCode.T,
	desyncAimbot = Enum.KeyCode.X,
	burst = Enum.KeyCode.C,
}
local Ot = {
	{ key = "drop", label = "DROP" },
	{ key = "autoLeft", label = "AUTO\nLEFT" },
	{ key = "aimbot", label = "AIMBOT" },
	{ key = "autoRight", label = "AUTO\nRIGHT" },
	{ key = "tpDown", label = "TP\nDOWN" },
	{ key = "carrySpeed", label = "CARRY\nSPEED" },
	{ key = "laggerCarry", label = "LAGGER\nCARRY" },
	{ key = "lagger", label = "LAGGER\nSPEED" },
	{ key = "tpDesync", label = "TP\nDESYNC" },
}
W.SIDE_BUTTON_LAYOUT_VERSION = 2
local Bt = {}
W.SIDE_BUTTON_BASE_SIZE = 58
W.SIDE_BUTTON_BASE_GAP = 8
W.SIDE_BUTTON_MIN_WIDTH = 36
W.SIDE_BUTTON_MAX_WIDTH = 220
W.SIDE_BUTTON_MIN_HEIGHT = 32
W.SIDE_BUTTON_MAX_HEIGHT = 130
local function St(tt)
	local Xt = math.clamp(tonumber(zt.sideButtonScale) or 1, 0.5, 1.5)
	local wt = math.floor(W.SIDE_BUTTON_BASE_SIZE * Xt + 0.5)
	local ot = wt
	if tt and tt.wide then
		ot = math.floor(W.SIDE_BUTTON_BASE_SIZE * 2 * Xt + W.SIDE_BUTTON_BASE_GAP + 0.5)
	end

	return ot, wt
end

local function tt(Xt)
	local wt, ot = St(Xt)
	local yt = Xt and zt.sideButtonSizes and zt.sideButtonSizes[Xt.key]
	local Xt = type(yt) == "table" and tonumber(yt.width) or wt
	local dt = type(yt) == "table" and tonumber(yt.height) or ot
	Xt = math.clamp(math.floor((Xt or wt) + 0.5), W.SIDE_BUTTON_MIN_WIDTH, W.SIDE_BUTTON_MAX_WIDTH)
	dt = math.clamp(math.floor((dt or ot) + 0.5), W.SIDE_BUTTON_MIN_HEIGHT, W.SIDE_BUTTON_MAX_HEIGHT)
	if zt.sideButtonType == "circle" then
		local wt = math.min(W.SIDE_BUTTON_MIN_WIDTH, W.SIDE_BUTTON_MIN_HEIGHT)
		local ot = math.max(W.SIDE_BUTTON_MAX_WIDTH, W.SIDE_BUTTON_MAX_HEIGHT)
		local yt = math.clamp(math.floor((Xt + dt) / 2 + 0.5), wt, ot)
		return yt, yt
	end

	return Xt, dt
end

local function Xt(wt)
	local ot = Bt[wt]
	if not (ot and ot.frame) then
		return
	end

	for yt, yt in ipairs(Ot) do
		if yt.key == wt then
			local wt, dt = tt(yt)
			ot.frame.Size = UDim2.new(0, wt, 0, dt)
			return
		end
	end
end

local function wt()
	local ot = zt.sideButtonType == "circle"
	for yt, yt in ipairs(Ot) do
		Xt(yt.key)
		local dt = Bt[yt.key]
		if dt and dt.frame then
			local yt = dt.frame:FindFirstChildOfClass("UICorner")
			if yt then
				yt.CornerRadius = ot and UDim.new(1, 0) or UDim.new(0, 12)
			end
		end
	end

	if _G._VH_refreshMobileSizeUI then
		pcall(_G._VH_refreshMobileSizeUI)
	end
end

local function ot()
	zt.sideButtonSizes = {}
	for yt, yt in ipairs(Ot) do
		Xt(yt.key)
	end

	if _G._VH_refreshMobileSizeUI then
		pcall(_G._VH_refreshMobileSizeUI)
	end
end

local yt = {
	AutoStealEnabled = false,
	StealRadius = 61,
	StealDuration = 1.3,
	NormalRadius = 61,
	NormalDuration = 1.3,
	SemiRadius = 61,
	SemiDuration = 1.3,
	Data = {},
	plotCache = {},
	plotCacheTime = {},
	cachedPrompts = {},
	promptCacheTime = 0,
}
local dt = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Right] = true,
}
W.PLOT_CACHE_DURATION = 2
W.PROMPT_CACHE_REFRESH = Mt.TouchEnabled and not Mt.KeyboardEnabled and 0.3 or 0.15
W.STEAL_COOLDOWN = 0.1
W.AUTO_START_DELAY = 0.7
W.MEDUSA_COOLDOWN = 25
W.DROP_AUTO_OFF_DELAY = 0.15
local W1 = {
	L1 = Vector3.new(-476.48, -6.28, 92.73),
	L2 = Vector3.new(-483.12, -4.95, 94.8),
	R1 = Vector3.new(-476.16, -6.52, 25.62),
	R2 = Vector3.new(-483.04, -5.09, 23.14),
}
local x1 = {
	autoSteal = nil,
	antiRag = nil,
	autoLeft = nil,
	autoRight = nil,
	anchor = {},
	progress = nil,
	batAimbot = nil,
	autoTpDown = nil,
	desyncAimbot = nil,
}
local m1 = RaycastParams.new()
m1.FilterType = Enum.RaycastFilterType.Exclude
m1.IgnoreWater = true
pcall(function()
	m1.RespectCanCollide = true
end)
local Q1 = Mt.TouchEnabled and not Mt.KeyboardEnabled
W._AUTO_WALK_UPDATE_INTERVAL = 0
W._AUTO_WALK_COLLISION_INTERVAL = Q1 and 0.03333333333333333 or 0.022222222222222223
local a1 = nil
local function s1()
	return false
end

local function n1(V1, _1, f1, J1)
	local G1 = Vector3.new(_1.X, 0, _1.Z)
	if not (V1 and V1.Parent) or G1.Magnitude < 0.01 then
		return G1, false
	end

	local _1 = G1.Magnitude
	local i1 = Rt.Character
	m1.FilterDescendantsInstances = i1 and { i1 } or {}
	local b1 = math.clamp(
		math.max(f1 or 0.016666666666666666, 0.011111111111111112),
		0.011111111111111112,
		0.06666666666666667
	)
	local f1 = math.clamp(math.max(V1.Size.X, V1.Size.Z) * 0.5, 0.78, 0.92)
	local p1 = 0.09 + math.max(tonumber(J1) or 0, 0)
	local J1 = false
	local M1 = nil
	local g1 = math.huge
	local H1 = false
	local F1 = G1.Magnitude * b1
	local F1, R1 = s1()
	if F1 and a1 then
		a1(V1, R1)
	end

	for F1 = 1, 3 do
		if G1.Magnitude < 0.02 then
			break
		end

		local F1 = G1.Magnitude * b1
		local R1 = G1.Unit * (F1 + p1)
		local I1 = nil
		local k1 = pcall(function()
			I1 = workspace:Spherecast(V1.Position, f1, R1, m1)
		end)
		if not k1 then
			I1 = workspace:Raycast(V1.Position, G1.Unit * (F1 + f1 + p1), m1)
		end

		if not I1 then
			break
		end

		local f1 = i1 and i1:FindFirstChildOfClass("Humanoid")
		local i1 = f1 and f1.MaxSlopeAngle or 45
		local F1 = math.cos(math.rad(math.clamp(i1, 0, 89)))
		if I1.Normal.Y >= F1 then
			local i1 = f1 and f1.FloorMaterial == Enum.Material.Air
			local f1 = V1.Position.Y - V1.Size.Y * 0.5
			if i1 and I1.Position.Y > f1 + 0.15 and G1.Magnitude > 26 then
				G1 = G1.Unit * 26
				J1 = true
			end

			break
		end

		local f1, i1 = s1()
		if f1 then
			if a1 then
				a1(V1, i1)
			end

			break
		end

		local s1 = Vector3.new(I1.Normal.X, 0, I1.Normal.Z)
		if s1.Magnitude < 0.05 and I1.Position then
			local f1 = V1.Position - I1.Position
			s1 = Vector3.new(f1.X, 0, f1.Z)
		end

		if s1.Magnitude < 0.05 then
			J1 = true
			H1 = true
			G1 = Vector3.zero
			break
		end

		s1 = s1.Unit
		local V1 = G1:Dot(s1)
		if V1 >= 0 then
			break
		end

		J1 = true
		if M1 and M1:Dot(s1) < 0.55 then
			H1 = true
			G1 = Vector3.zero
			break
		end

		M1 = M1 or s1
		local f1 = G1 - s1 * V1
		local i1 = math.max((I1.Distance or 0) - p1, 0)
		if i1 < g1 then
			g1 = i1
		end

		local F1 = (I1.Distance or 0) <= p1 * 0.5
		if F1 then
			G1 = f1
		else
			local p1 = math.min(-V1 * 0.1, i1 / b1)
			G1 = f1 - s1 * p1
		end
	end

	if G1.Magnitude < 0.04 then
		G1 = Vector3.zero
	end

	if G1.Magnitude > _1 then
		G1 = G1.Unit * _1
	end

	return G1, J1, H1, M1, g1
end

local s1 = setmetatable({}, { __mode = "k" })
local function V1(_1)
	if not (_1 and _1.Parent) then
		return false
	end

	local f1 = _1.Parent
	if f1 ~= Rt.Character or s1[f1] then
		return false
	end

	local _1 = f1:FindFirstChildOfClass("Humanoid")
	return _1 ~= nil and _1.Health > 0 and _1:GetState() ~= Enum.HumanoidStateType.Dead
end

local function _1(f1)
	if not f1 or s1[f1] then
		return
	end

	s1[f1] = true
	for s1, s1 in ipairs(f1:GetDescendants()) do
		local f1 = s1.Name:sub(1, 7) == "Vampire" or s1.Name:sub(1, 4) == "WAVE"
		if s1:IsA("LinearVelocity") and f1 then
			pcall(function()
				s1.Enabled = false
			end)
			pcall(function()
				s1.VectorVelocity = Vector3.zero
			end)
			pcall(function()
				s1.PlaneVelocity = Vector2.zero
			end)
			pcall(function()
				s1.LineVelocity = 0
			end)
			pcall(function()
				s1:Destroy()
			end)
		elseif s1:IsA("Attachment") and f1 then
			pcall(function()
				s1:Destroy()
			end)
		elseif s1:IsA("BasePart") then
			pcall(function()
				s1.AssemblyLinearVelocity = Vector3.zero
				s1.AssemblyAngularVelocity = Vector3.zero
				s1.Anchored = true
			end)
		end
	end
end

local s1 = setmetatable({}, { __mode = "k" })
local f1 = setmetatable({}, { __mode = "k" })
local function J1(G1, i1)
	if not V1(G1) then
		return nil
	end

	local b1 = f1[G1]
	local p1 = b1 and b1[i1]
	if p1 and p1.attachment.Parent == G1 and p1.velocity.Parent == G1 then
		return p1.velocity
	end

	local p1 = i1 .. "Attachment"
	local M1 = i1 .. "LinearVelocity"
	local g1 = G1:FindFirstChild(p1)
	if not (g1 and g1:IsA("Attachment")) then
		g1 = Instance.new("Attachment")
		g1.Name = p1
		g1.Parent = G1
	end

	local p1 = G1:FindFirstChild(M1)
	if not (p1 and p1:IsA("LinearVelocity")) then
		p1 = Instance.new("LinearVelocity")
		p1.Name = M1
		p1.Parent = G1
	end

	p1.Attachment0 = g1
	p1.RelativeTo = Enum.ActuatorRelativeTo.World
	pcall(function()
		p1.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	end)
	pcall(function()
		p1.ForceLimitsEnabled = false
	end)
	if not b1 then
		b1 = {}
		f1[G1] = b1
	end

	b1[i1] = { attachment = g1, velocity = p1 }
	return p1
end

local function G1(i1, b1, p1)
	local M1 = J1(i1, b1)
	if not M1 then
		return nil
	end

	s1[M1] = nil
	M1.VectorVelocity = p1 or Vector3.zero
	M1.Enabled = true
	return M1
end

local function i1(b1, p1)
	if not b1 then
		return
	end

	local M1 = f1[b1]
	if M1 then
		M1[p1] = nil
	end

	local f1 = b1:FindFirstChild(p1 .. "LinearVelocity")
	if f1 and f1:IsA("LinearVelocity") then
		s1[f1] = nil
		pcall(function()
			f1.Enabled = false
			f1.VectorVelocity = Vector3.zero
			f1.LineVelocity = 0
			f1:Destroy()
		end)
	end

	local f1 = b1:FindFirstChild(p1 .. "Attachment")
	if f1 and f1:IsA("Attachment") then
		pcall(function()
			f1:Destroy()
		end)
	end
end

local function f1(b1, p1, M1, g1)
	local H1 = J1(b1, p1)
	if not H1 then
		return nil
	end

	local F1 = {}
	s1[H1] = F1
	H1.VectorVelocity = M1 or Vector3.zero
	H1.Enabled = true
	task.delay(g1 or 0.1, function()
		if s1[H1] ~= F1 then
			return
		end

		s1[H1] = nil
		if H1.Parent then
			i1(b1, p1)
		end
	end)
	return H1
end

local function b1(p1, M1)
	if not V1(p1) then
		return nil
	end

	local g1 = M1 .. "Attachment"
	local H1 = M1 .. "LinearVelocity"
	local M1 = p1:FindFirstChild(g1)
	if not (M1 and M1:IsA("Attachment")) then
		M1 = Instance.new("Attachment")
		M1.Name = g1
		M1.Parent = p1
	end

	local g1 = p1:FindFirstChild(H1)
	if not (g1 and g1:IsA("LinearVelocity")) then
		g1 = Instance.new("LinearVelocity")
		g1.Name = H1
		g1.Parent = p1
	end

	g1.Attachment0 = M1
	g1.RelativeTo = Enum.ActuatorRelativeTo.World
	g1.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
	g1.LineDirection = Vector3.new(0, 1, 0)
	pcall(function()
		g1.ForceLimitsEnabled = false
	end)
	return g1
end

local function p1(M1, g1, H1, F1)
	local R1 = b1(M1, g1)
	if not R1 then
		return nil
	end

	local I1 = {}
	s1[R1] = I1
	R1.LineVelocity = H1 or 0
	R1.Enabled = true
	task.delay(F1 or 0.1, function()
		if s1[R1] ~= I1 then
			return
		end

		s1[R1] = nil
		if R1.Parent then
			i1(M1, g1)
		end
	end)
	return R1
end

local function s1(M1)
	if not (M1 and M1.Parent) then
		return Vector3.zero
	end

	local g1, H1 = pcall(function()
		return M1:GetVelocityAtPosition(M1.Position)
	end)
	return g1 and H1 or Vector3.zero
end

local M1 = setmetatable({}, { __mode = "k" })
a1 = function(a1, g1)
	if not V1(a1) or type(g1) ~= "number" or g1 <= a1.Position.Y + 0.05 then
		return
	end

	local H1 = tick()
	local F1 = M1[a1]
	if F1 then
		F1.targetY = math.max(F1.targetY, g1)
		F1.expires = math.max(F1.expires, H1 + 0.32)
		return
	end

	local F1 = { targetY = g1, expires = H1 + 0.32 }
	M1[a1] = F1
	task.spawn(function()
		while M1[a1] == F1 and V1(a1) and tick() < F1.expires do
			local g1 = F1.targetY - a1.Position.Y
			if g1 <= 0.05 then
				break
			end

			local H1 = a1.Parent
			m1.FilterDescendantsInstances = { H1 }
			if a1.AssemblyLinearVelocity.Y > 9 then
				break
			end

			if workspace:Raycast(a1.Position, Vector3.new(0, 3.05 + math.min(g1, 2.35), 0), m1) then
				break
			end

			local H1 = b1(a1, "VampireStep")
			if not H1 then
				break
			end

			H1.LineVelocity = math.clamp(g1 * 9, 5, 12)
			H1.Enabled = true
			pt.Heartbeat:Wait()
		end

		if M1[a1] == F1 then
			M1[a1] = nil
		end

		i1(a1, "VampireStep")
	end)
end

batCounterDebounce = false
NORMAL_STRETCH_FOV = 70
W.LOGO_ID = "rbxassetid://14640607134"
W.IMG_BG = "rbxassetid://14640607134"
-- [ /printed ] THEME AND MAIN UI CONFIGURATION
local a1 = {
	idle1 = "rbxassetid://133806214992291",
	idle2 = "rbxassetid://94970088341563",
	walk = "rbxassetid://707897309",
	run = "rbxassetid://707861613",
	jump = "rbxassetid://116936326516985",
	fall = "rbxassetid://116936326516985",
	climb = "rbxassetid://116936326516985",
	swim = "rbxassetid://116936326516985",
	swimidle = "rbxassetid://116936326516985",
}
local b1 = {
	["Tryhard"] = a1,
	["Adidas Community"] = {
		idle1 = "rbxassetid://122257458498464",
		idle2 = "rbxassetid://102357151005774",
		walk = "rbxassetid://122150855457006",
		run = "rbxassetid://82598234841035",
		jump = "rbxassetid://75290611992385",
		fall = "rbxassetid://98600215928904",
		climb = "rbxassetid://88763136693023",
		swim = "rbxassetid://133308483266208",
		swimidle = "rbxassetid://109346520324160",
	},
	["Vampire"] = {
		idle1 = "rbxassetid://10921315373",
		idle2 = "rbxassetid://10921315373",
		walk = "rbxassetid://10921326949",
		run = "rbxassetid://10921320299",
		jump = "rbxassetid://10921322186",
		fall = "rbxassetid://10921321317",
		climb = "rbxassetid://10921314188",
		swim = "rbxassetid://10921324408",
		swimidle = "rbxassetid://10921325443",
	},
	["Catwalk Glam"] = {
		idle1 = "rbxassetid://133806214992291",
		idle2 = "rbxassetid://94970088341563",
		walk = "rbxassetid://109168724482748",
		run = "rbxassetid://81024476153754",
		jump = "rbxassetid://116936326516985",
		fall = "rbxassetid://92294537340807",
		climb = "rbxassetid://119377220967554",
		swim = "rbxassetid://134591743181628",
		swimidle = "rbxassetid://98854111361360",
	},
	["Astronaut"] = {
		idle1 = "rbxassetid://10921034824",
		idle2 = "rbxassetid://10921036806",
		walk = "rbxassetid://10921046031",
		run = "rbxassetid://10921039308",
		jump = "rbxassetid://10921042494",
		fall = "rbxassetid://10921040576",
		climb = "rbxassetid://10921032124",
		swim = "rbxassetid://10921044000",
		swimidle = "rbxassetid://10921045006",
	},
	["Elder"] = {
		idle1 = "rbxassetid://10921101664",
		idle2 = "rbxassetid://10921102574",
		walk = "rbxassetid://10921111375",
		run = "rbxassetid://10921104374",
		jump = "rbxassetid://10921107367",
		fall = "rbxassetid://10921105765",
		climb = "rbxassetid://10921100400",
		swim = "rbxassetid://10921108971",
		swimidle = "rbxassetid://10921110146",
	},
	["Mage"] = {
		idle1 = "rbxassetid://10921144709",
		idle2 = "rbxassetid://10921145797",
		walk = "rbxassetid://10921152678",
		run = "rbxassetid://10921148209",
		jump = "rbxassetid://10921149743",
		fall = "rbxassetid://10921148939",
		climb = "rbxassetid://10921143404",
		swim = "rbxassetid://10921150788",
		swimidle = "rbxassetid://10921151661",
	},
	["Amazon Unboxed"] = {
		idle1 = "rbxassetid://98281136301627",
		idle2 = "rbxassetid://98281136301627",
		walk = "rbxassetid://90478085024465",
		run = "rbxassetid://134824450619865",
		jump = "rbxassetid://121454505477205",
		fall = "rbxassetid://94788218468396",
		climb = "rbxassetid://121145883950231",
		swim = "rbxassetid://105962919001086",
		swimidle = "rbxassetid://129126268464847",
	},
}
local M1 =
	{ "None", "Tryhard", "Adidas Community", "Vampire", "Catwalk Glam", "Astronaut", "Elder", "Mage", "Amazon Unboxed" }
local g1 = nil
local H1 = nil
local F1 = nil
do
	local function R1(I1)
		if not I1 then
			return false
		end

		for k1, k1 in pairs(a1) do
			if k1 == I1 then
				return true
			end
		end

		return false
	end

	local function I1(k1)
		local C1 = k1:FindFirstChild("Animate")
		if not C1 then
			return
		end

		local function k1(P1)
			return P1 and P1.AnimationId or nil
		end

		local P1 = {
			idle1 = k1(C1.idle and C1.idle.Animation1),
			idle2 = k1(C1.idle and C1.idle.Animation2),
			walk = k1(C1.walk and C1.walk.WalkAnim),
			run = k1(C1.run and C1.run.RunAnim),
			jump = k1(C1.jump and C1.jump.JumpAnim),
			fall = k1(C1.fall and C1.fall.FallAnim),
			climb = k1(C1.climb and C1.climb.ClimbAnim),
			swim = k1(C1.swim and C1.swim.Swim),
			swimidle = k1(C1.swimidle and C1.swimidle.SwimIdle),
		}
		if not R1(P1.walk) then
			H1 = P1
		end
	end

	local function R1(k1)
		local C1 = k1:FindFirstChild("Animate")
		if not C1 then
			return
		end

		local function k1(P1, h1)
			if P1 then
				P1.AnimationId = h1
			end
		end

		k1(C1.idle and C1.idle.Animation1, a1.idle1)
		k1(C1.idle and C1.idle.Animation2, a1.idle2)
		k1(C1.walk and C1.walk.WalkAnim, a1.walk)
		k1(C1.run and C1.run.RunAnim, a1.run)
		k1(C1.jump and C1.jump.JumpAnim, a1.jump)
		k1(C1.fall and C1.fall.FallAnim, a1.fall)
		k1(C1.climb and C1.climb.ClimbAnim, a1.climb)
		k1(C1.swim and C1.swim.Swim, a1.swim)
		k1(C1.swimidle and C1.swimidle.SwimIdle, a1.swimidle)
	end

	local function a1(k1)
		if not H1 then
			return
		end

		local C1 = k1:FindFirstChild("Animate")
		if not C1 then
			return
		end

		local function P1(h1, l1)
			if h1 and l1 then
				h1.AnimationId = l1
			end
		end

		P1(C1.idle and C1.idle.Animation1, H1.idle1)
		P1(C1.idle and C1.idle.Animation2, H1.idle2)
		P1(C1.walk and C1.walk.WalkAnim, H1.walk)
		P1(C1.run and C1.run.RunAnim, H1.run)
		P1(C1.jump and C1.jump.JumpAnim, H1.jump)
		P1(C1.fall and C1.fall.FallAnim, H1.fall)
		P1(C1.climb and C1.climb.ClimbAnim, H1.climb)
		P1(C1.swim and C1.swim.Swim, H1.swim)
		P1(C1.swimidle and C1.swimidle.SwimIdle, H1.swimidle)
		local C1 = k1:FindFirstChildOfClass("Humanoid")
		if C1 then
			for k1, k1 in ipairs(C1:GetPlayingAnimationTracks()) do
				k1:Stop(0)
			end

			C1:ChangeState(Enum.HumanoidStateType.Running)
		end
	end

	startUnwalk = function()
		if zt.unwalkEnabled then
			return
		end

		zt.unwalkEnabled = true
		local k1 = Rt.Character
		if not k1 then
			return
		end

		local C1 = k1:FindFirstChildOfClass("Humanoid")
		if C1 then
			for P1, P1 in ipairs(C1:GetPlayingAnimationTracks()) do
				P1:Stop()
			end
		end

		local C1 = k1:FindFirstChild("Animate")
		if C1 then
			g1 = C1:Clone()
			C1:Destroy()
		end
	end

	stopUnwalk = function()
		if not zt.unwalkEnabled then
			return
		end

		zt.unwalkEnabled = false
		local k1 = Rt.Character
		if k1 and g1 then
			g1.Parent = k1
			g1.Disabled = false
			g1 = nil
		end

		task.spawn(function()
			task.wait(0.15)
			local g1 = Rt.Character
			if not g1 then
				return
			end

			if zt.animEnabled then
				I1(g1)
				R1(g1)
			else
				a1(g1)
			end
		end)
	end

	local g1 = Color3.fromRGB(64, 64, 64)
	local function k1(C1)
		local P1 = C1:FindFirstChild("face")
		if P1 then
			P1:Destroy()
		end
	end

	applyHeadlessToChar = function(C1, P1)
		if not C1 then
			return
		end

		local h1 = C1:FindFirstChild("Head")
		if not h1 then
			return
		end

		if P1 then
			h1.Transparency = 1
			h1.CanCollide = false
			k1(h1)
			if h1:FindFirstChild("HeadlessMesh") then
				return
			end

			for C1, C1 in ipairs(h1:GetChildren()) do
				if C1:IsA("SpecialMesh") and C1.MeshId == "rbxassetid://1095708" then
					C1:Destroy()
				end
			end

			local C1 = Instance.new("SpecialMesh")
			C1.MeshType = Enum.MeshType.FileMesh
			C1.MeshId = "rbxassetid://1095708"
			C1.Scale = Vector3.new(0.001, 0.001, 0.001)
			C1.Name = "HeadlessMesh"
			C1.Parent = h1
			h1:GetPropertyChangedSignal("Transparency"):Connect(function()
				if zt.headlessEnabled and h1.Transparency ~= 1 then
					h1.Transparency = 1
				end
			end)
			h1.ChildAdded:Connect(function(C1)
				if zt.headlessEnabled and C1.Name == "face" and C1:IsA("Decal") then
					C1:Destroy()
				end
			end)
		else
			h1.Transparency = 0
			h1.CanCollide = true
			for C1, C1 in ipairs(h1:GetChildren()) do
				if C1:IsA("SpecialMesh") and C1.Name == "HeadlessMesh" then
					C1:Destroy()
				end
			end

			k1(h1)
		end
	end

	applyKorbloxToChar = function(k1, C1)
		if not k1 then
			return
		end

		local P1 = k1:FindFirstChildOfClass("Humanoid")
		if not P1 then
			return
		end

		if C1 then
			if P1.RigType == Enum.HumanoidRigType.R6 then
				local C1 = k1:FindFirstChild("Right Leg")
				if C1 then
					if C1:FindFirstChild("KorbloxMesh") then
						return
					end

					for h1, h1 in ipairs(C1:GetChildren()) do
						if h1:IsA("SpecialMesh") or h1:IsA("CharacterMesh") then
							h1:Destroy()
						end
					end

					C1.Color = g1
					C1:GetPropertyChangedSignal("Color"):Connect(function()
						if zt.korbloxEnabled and C1.Color ~= g1 then
							C1.Color = g1
						end
					end)
					local h1 = Instance.new("SpecialMesh")
					h1.MeshType = Enum.MeshType.FileMesh
					h1.MeshId = "rbxassetid://101851696"
					h1.TextureId = "rbxassetid://101851254"
					h1.Scale = Vector3.new(1, 1, 1)
					h1.Name = "KorbloxMesh"
					h1.Parent = C1
				end
			elseif P1.RigType == Enum.HumanoidRigType.R15 then
				local C1 = k1:FindFirstChild("RightUpperLeg")
				if C1 then
					if k1:FindFirstChild("KorbloxLeg") then
						return
					end

					C1.Transparency = 1
					local h1 = k1:FindFirstChild("RightLowerLeg")
					local l1 = k1:FindFirstChild("RightFoot")
					if h1 then
						h1.Transparency = 1
					end

					if l1 then
						l1.Transparency = 1
					end

					local h1 = k1:FindFirstChild("KorbloxLeg")
					if h1 then
						h1:Destroy()
					end

					local h1 = Instance.new("Part")
					h1.Name = "KorbloxLeg"
					h1.Size = Vector3.new(1, 2, 1)
					h1.Anchored = false
					h1.CanCollide = false
					h1.Color = g1
					h1.Parent = k1
					local g1 = Instance.new("SpecialMesh")
					g1.MeshType = Enum.MeshType.FileMesh
					g1.MeshId = "rbxassetid://101851696"
					g1.TextureId = "rbxassetid://101851254"
					g1.Scale = Vector3.new(1, 1, 1)
					g1.Name = "KorbloxMesh"
					g1.Parent = h1
					local g1 = Instance.new("Weld")
					g1.Part0 = C1
					g1.Part1 = h1
					g1.C0 = CFrame.new(0, -0.8, 0)
					g1.Name = "KorbloxWeld"
					g1.Parent = h1
				end
			end
		else
			if P1.RigType == Enum.HumanoidRigType.R6 then
				local g1 = k1:FindFirstChild("Right Leg")
				if g1 then
					for C1, C1 in ipairs(g1:GetChildren()) do
						if C1:IsA("SpecialMesh") and C1.Name == "KorbloxMesh" then
							C1:Destroy()
						end
					end

					g1.Color = Color3.fromRGB(255, 255, 255)
				end
			elseif P1.RigType == Enum.HumanoidRigType.R15 then
				local g1 = k1:FindFirstChild("RightUpperLeg")
				if g1 then
					g1.Transparency = 0
					local g1 = k1:FindFirstChild("RightLowerLeg")
					local C1 = k1:FindFirstChild("RightFoot")
					if g1 then
						g1.Transparency = 0
					end

					if C1 then
						C1.Transparency = 0
					end

					local g1 = k1:FindFirstChild("KorbloxLeg")
					if g1 then
						g1:Destroy()
					end
				end
			end
		end
	end

	applyCharterToChar = function(g1)
		if not g1 then
			return
		end

		applyHeadlessToChar(g1, zt.headlessEnabled)
		applyKorbloxToChar(g1, zt.korbloxEnabled)
	end

	startAnim = function()
		if zt.animEnabled then
			return
		end

		zt.animEnabled = true
		if F1 then
			F1:Disconnect()
			F1 = nil
		end

		local g1 = Rt.Character
		if g1 then
			I1(g1)
			R1(g1)
			local k1 = g1:FindFirstChildOfClass("Humanoid")
			if k1 then
				for g1, g1 in ipairs(k1:GetPlayingAnimationTracks()) do
					g1:Stop(0)
				end

				k1:ChangeState(Enum.HumanoidStateType.Running)
			end
		end

		local g1 = 0
		F1 = game:GetService("RunService").Heartbeat:Connect(function(k1)
			if not zt.animEnabled then
				return
			end

			g1 = g1 + (k1 or 0)
			if g1 < (Mt.TouchEnabled and not Mt.KeyboardEnabled and 0.75 or 0.35) then
				return
			end

			g1 = 0
			local g1 = Rt.Character
			if g1 then
				R1(g1)
			end
		end)
	end

	stopAnim = function()
		if not zt.animEnabled then
			return
		end

		zt.animEnabled = false
		if F1 then
			F1:Disconnect()
			F1 = nil
		end

		local g1 = Rt.Character
		if g1 then
			a1(g1)
		end
	end

	local function g1(R1)
		local k1 = b1[zt.selectedAnim]
		if not k1 then
			return
		end

		local C1 = R1:FindFirstChild("Animate")
		if not C1 then
			return
		end

		local function R1(P1, h1)
			if P1 and h1 then
				P1.AnimationId = h1
			end
		end

		R1(C1.idle and C1.idle.Animation1, k1.idle1)
		R1(C1.idle and C1.idle.Animation2, k1.idle2)
		R1(C1.walk and C1.walk.WalkAnim, k1.walk)
		R1(C1.run and C1.run.RunAnim, k1.run)
		R1(C1.jump and C1.jump.JumpAnim, k1.jump)
		R1(C1.fall and C1.fall.FallAnim, k1.fall)
		R1(C1.climb and C1.climb.ClimbAnim, k1.climb)
		R1(C1.swim and C1.swim.Swim, k1.swim)
		R1(C1.swimidle and C1.swimidle.SwimIdle, k1.swimidle)
	end

	setSelectedAnim = function(R1)
		zt.selectedAnim = R1
		local k1 = Rt.Character
		if R1 == "None" then
			zt.animEnabled = false
			if F1 then
				F1:Disconnect()
				F1 = nil
			end

			if k1 then
				a1(k1)
			end

			return
		end

		zt.animEnabled = true
		if F1 then
			F1:Disconnect()
			F1 = nil
		end

		if k1 then
			I1(k1)
			g1(k1)
			local a1 = k1:FindFirstChildOfClass("Humanoid")
			if a1 then
				for R1, R1 in ipairs(a1:GetPlayingAnimationTracks()) do
					R1:Stop(0)
				end

				a1:ChangeState(Enum.HumanoidStateType.Running)
			end
		end

		local a1 = 0
		F1 = game:GetService("RunService").Heartbeat:Connect(function(F1)
			if not zt.animEnabled then
				return
			end

			a1 = a1 + (F1 or 0)
			if a1 < (Mt.TouchEnabled and not Mt.KeyboardEnabled and 0.75 or 0.35) then
				return
			end

			a1 = 0
			local a1 = Rt.Character
			if a1 then
				g1(a1)
			end
		end)
	end
end

for a1, a1 in pairs({ "VAMPIRE HUB", "VampireHub", "VHub" }) do
	local g1 = game:GetService("CoreGui"):FindFirstChild(a1)
	if g1 then
		g1:Destroy()
	end
end

if _G._VH_ESP and _G._VH_ESP.cleanup then
	pcall(_G._VH_ESP.cleanup)
end

local a1 = {
	void = Color3.fromRGB(0, 0, 0),
	ink = Color3.fromRGB(0, 0, 0),
	card = Color3.fromRGB(0, 0, 0),
	row = Color3.fromRGB(55, 55, 55),
	purple = Color3.fromRGB(220, 45, 45),
	dpurple = Color3.fromRGB(170, 25, 25),
	lpurple = Color3.fromRGB(255, 90, 90),
	white = Color3.fromRGB(245, 245, 245),
	dim = Color3.fromRGB(120, 120, 120),
	gold = Color3.fromRGB(180, 180, 180),
	border = Color3.fromRGB(0, 0, 0),
	on = Color3.fromRGB(220, 45, 45),
	off = Color3.fromRGB(0, 0, 0),
	stkBg = Color3.fromRGB(18, 4, 4),
	stkBrd = Color3.fromRGB(80, 22, 22),
	stkAct = Color3.fromRGB(132, 20, 20),
}
local g1 = {}
do
	tw = function(F1, R1, I1, k1, C1)
		gt:Create(F1, TweenInfo.new(R1, k1 or Enum.EasingStyle.Quad, C1 or Enum.EasingDirection.Out), I1):Play()
	end

	gui = Instance.new("ScreenGui")
	gui.Name = "VampireHub"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 10
	gui.IgnoreGuiInset = true
	gui.Enabled = false
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	if not pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end) then
		gui.Parent = Rt:WaitForChild("PlayerGui")
	end

	root = Instance.new("CanvasGroup", gui)
	root.Name = "VampireHub_Root"
	root.Size = UDim2.new(0, 448, 0, 538)
	root.Position = UDim2.new(0, 20, 0, 20)
	root.Visible = false
	root.BackgroundColor3 = a1.ink
	root.BackgroundTransparency = 0
	root.BorderSizePixel = 0
	-- /printed branding is placed in the dedicated screen-corner overlay below.
	root.Active = true
	root.Active = true
	Instance.new("UICorner", root).CornerRadius = UDim.new(0, 40)
	local F1 = Instance.new("UIScale", root)
	F1.Scale = zt.guiScale
	makeDraggable = function(R1, I1, k1)
		local k1, C1, P1, h1 = false, nil, nil, nil
		local l1, D1
		R1.InputBegan:Connect(function(D1)
			if
				D1.UserInputType == Enum.UserInputType.MouseButton1
				or D1.UserInputType == Enum.UserInputType.MouseButton2
			then
				k1 = true
				P1 = D1.Position
				h1 = R1.Position
				if I1 then
					l1 = I1.Position
				end

				D1.Changed:Connect(function()
					if D1.UserInputState == Enum.UserInputState.End then
						k1 = false
					end
				end)
			end
		end)
		R1.InputChanged:Connect(function(D1)
			if D1.UserInputType == Enum.UserInputType.Touch or D1.UserInputType == Enum.UserInputType.MouseButton2 then
				C1 = D1
			end
		end)
		Mt.InputChanged:Connect(function(D1)
			if D1 == C1 and k1 then
				local k1 = D1.Position.X - P1.X
				local C1 = D1.Position.Y - P1.Y
				R1.Position = UDim2.new(h1.X.Scale, h1.X.Offset + k1, h1.Y.Scale, h1.Y.Offset + C1)
				if I1 and l1 then
					I1.Position = UDim2.new(l1.X.Scale, l1.X.Offset + k1, l1.Y.Scale, l1.Y.Offset + C1)
				end
			end
		end)
	end

	makeDraggable(root, nil, true)
	local R1
	local I1 = Instance.new("Frame", root)
	I1.Size = UDim2.new(0, 178, 1, 0)
	I1.Position = UDim2.new(0, 0, 0, 0)
	I1.BackgroundColor3 = a1.ink
	I1.BackgroundTransparency = 1
	I1.BorderSizePixel = 0
	I1.Active = true
	I1.ZIndex = 1
	Instance.new("UICorner", I1).CornerRadius = UDim.new(0, 40)
	do
		local k1 = Instance.new("Frame", I1)
		k1.Size = UDim2.new(0, 40, 1, 0)
		k1.Position = UDim2.new(1, -40.0, 0, 0)
		k1.BackgroundColor3 = a1.ink
		k1.BorderSizePixel = 0
		k1.ZIndex = 1
		Instance.new("UICorner", k1).CornerRadius = UDim.new(0, 40)
		R1 = Instance.new("ImageLabel", I1)
		R1.Size = UDim2.new(1, 0, 1, 0)
		R1.AnchorPoint = Vector2.new(0.5, 0.5)
		R1.Position = UDim2.new(0.5, 0, 0.5, 0)
		R1.BackgroundTransparency = 1
		R1.Image = W.IMG_BG
		R1.ScaleType = Enum.ScaleType.Crop
		R1.ImageTransparency = 0
		R1.ZIndex = 1
		R1.BorderSizePixel = 0
		R1.Active = true
		Instance.new("UICorner", R1).CornerRadius = UDim.new(0, 40)
		local l = Instance.new("Frame", I1)
		l.Size = UDim2.new(0.55, 0, 1, 0)
		l.Position = UDim2.new(0.45, 0, 0, 0)
		l.BackgroundColor3 = a1.void
		l.BorderSizePixel = 0
		l.ZIndex = 2
		local k1 = Instance.new("UIGradient", l)
		k1.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
		})
		k1.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
		local l = Instance.new("Frame", I1)
		l.Size = UDim2.new(1, 0, 0.4, 0)
		l.Position = UDim2.new(0, 0, 0.6, 0)
		l.BackgroundColor3 = a1.void
		l.BorderSizePixel = 0
		l.ZIndex = 2
		Instance.new("UICorner", l).CornerRadius = UDim.new(0, 40)
		local k1 = Instance.new("UIGradient", l)
		k1.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.15) })
		k1.Rotation = 90
		local l = Instance.new("TextLabel", I1)
		l.Size = UDim2.new(1, -8.0, 0, 22)
		l.Position = UDim2.new(0, 16, 1, -46.0)
		l.BackgroundTransparency = 1
		l.Text = "Vampire Hub"
		l.TextColor3 = a1.white
		l.Font = Enum.Font.Gotham
		l.TextSize = 12
		l.TextStrokeTransparency = 0
		l.ZIndex = 3
		local l = Instance.new("Frame", I1)
		l.Size = UDim2.new(0, 95, 0, 2)
		l.Position = UDim2.new(0, 16, 1, -26.0)
		l.BackgroundColor3 = a1.purple
		l.BorderSizePixel = 0
		l.ZIndex = 3
		local k1 = Instance.new("UIGradient", l)
		k1.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, a1.dpurple),
			ColorSequenceKeypoint.new(0.6, a1.lpurple),
			ColorSequenceKeypoint.new(1, a1.dpurple),
		})
		local l = Instance.new("TextLabel", I1)
		l.Size = UDim2.new(1, -8.0, 0, 14)
		l.Position = UDim2.new(0, 16, 1, -24.0)
		l.BackgroundTransparency = 1
		l.Text = "LEAKED BY /printed  •  NUMBER 1"
		l.TextColor3 = a1.dim
		l.Font = Enum.Font.GothamMedium
		l.TextSize = 8
		l.TextStrokeTransparency = 0
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.ZIndex = 3
		local l = Instance.new("Frame", I1)
		l.Size = UDim2.new(1, -12.0, 0, 20)
		l.Position = UDim2.new(0, 6, 0, 6)
		l.BackgroundColor3 = a1.void
		l.BackgroundTransparency = 0.45
		l.BorderSizePixel = 0
		l.ZIndex = 3
		l.Visible = false
		Instance.new("UICorner", l).CornerRadius = UDim.new(0, 7)
		statsLbl = Instance.new("TextLabel", l)
		statsLbl.Size = UDim2.new(1, -8.0, 1, 0)
		statsLbl.Position = UDim2.new(0, 4, 0, 0)
		statsLbl.BackgroundTransparency = 1
		statsLbl.Text = "FPS: -- | PING: --"
		statsLbl.TextColor3 = a1.purple
		statsLbl.Font = Enum.Font.GothamBold
		statsLbl.TextSize = 10
		statsLbl.TextStrokeTransparency = 0
		statsLbl.TextTransparency = 0.6
		statsLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
		statsLbl.ZIndex = 4
	end

	ctrl = Instance.new("Frame", root)
	ctrl.Size = UDim2.new(0, 270, 1, 0)
	ctrl.Position = UDim2.new(0, 178, 0, 0)
	ctrl.BackgroundColor3 = a1.card
	ctrl.BackgroundTransparency = 0.05
	ctrl.BorderSizePixel = 0
	ctrl.Active = true
	Instance.new("UICorner", ctrl).CornerRadius = UDim.new(0, 40)
	local l = Instance.new("Frame", ctrl)
	l.Size = UDim2.new(0, 40, 1, 0)
	l.Position = UDim2.new(0, 0, 0, 0)
	l.BackgroundColor3 = a1.card
	l.BackgroundTransparency = 0.05
	l.BorderSizePixel = 0
	l.ZIndex = 0
	local l = { "Main", "Move", "Custom", "Config" }
	local k1 = {}
	local C1 = nil
	tabStack = Instance.new("Frame", I1)
	tabStack.Size = UDim2.new(0, 118, 0, 280)
	tabStack.Position = UDim2.new(1, -122.0, 0.5, -150.0)
	tabStack.BackgroundTransparency = 1
	tabStack.BorderSizePixel = 0
	tabStack.ZIndex = 8
	local I1 = Instance.new("UIListLayout", tabStack)
	I1.FillDirection = Enum.FillDirection.Vertical
	I1.SortOrder = Enum.SortOrder.LayoutOrder
	I1.HorizontalAlignment = Enum.HorizontalAlignment.Right
	I1.Padding = UDim.new(0, 32)
	pageHost = Instance.new("Frame", ctrl)
	pageHost.Size = UDim2.new(1, 0, 1, -52.0)
	pageHost.Position = UDim2.new(0, 0, 0, 12)
	pageHost.BackgroundTransparency = 1
	pageHost.BorderSizePixel = 0
	pageHost.Active = true
	pageHost.ZIndex = 4
	local function I1()
		local P1 = Instance.new("ScrollingFrame", pageHost)
		P1.Size = UDim2.new(1, 0, 1, 0)
		P1.BackgroundTransparency = 1
		P1.BorderSizePixel = 0
		P1.ScrollBarThickness = 0
		P1.ScrollBarImageColor3 = a1.purple
		P1.ScrollBarImageTransparency = 1
		P1.AutomaticCanvasSize = Enum.AutomaticSize.Y
		P1.CanvasSize = UDim2.new(0, 0, 0, 0)
		P1.Visible = false
		P1.ZIndex = 4
		local h1 = Instance.new("UIListLayout", P1)
		h1.SortOrder = Enum.SortOrder.LayoutOrder
		h1.Padding = UDim.new(0, 4)
		local h1 = Instance.new("UIPadding", P1)
		h1.PaddingLeft = UDim.new(0, 10)
		h1.PaddingRight = UDim.new(0, 16)
		h1.PaddingTop = UDim.new(0, 10)
		h1.PaddingBottom = UDim.new(0, 52)
		return P1
	end

	local P1 = {}
	for h1, h1 in ipairs(l) do
		P1[h1] = I1()
	end

	local function I1(h1)
		if C1 then
			C1.Visible = false
		end

		C1 = P1[h1]
		C1.Visible = true
		for l1, D1 in pairs(k1) do
			if l1 == h1 then
				tw(D1, 0.15, { BackgroundColor3 = a1.purple, BackgroundTransparency = 0.25 })
				D1.TextColor3 = a1.void
				local h1 = D1:FindFirstChildOfClass("UIStroke")
				if h1 then
					tw(h1, 0.15, { Color = a1.purple })
				end
			else
				tw(D1, 0.15, { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.4 })
				D1.TextColor3 = a1.white
				local h1 = D1:FindFirstChildOfClass("UIStroke")
				if h1 then
					tw(h1, 0.15, { Color = a1.border })
				end
			end
		end
	end

	g1 = {}
	local function h1(l1)
		if not P1 then
			return false
		end

		for D1, D1 in pairs(P1) do
			if l1:IsDescendantOf(D1) then
				return D1 ~= C1
			end
		end

		return false
	end

	pcall(function()
		game:GetService("ContextActionService"):BindActionAtPriority("VH_GlobalTap", function(l1, l1, D1)
			if l1 ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			local l1, z1 = D1.Position.X, D1.Position.Y
			local D1 = false
			if root and root.Visible then
				local v1 = root.AbsolutePosition
				local q1 = root.AbsoluteSize
				D1 = (l1 >= v1.X and l1 <= v1.X + q1.X and z1 >= v1.Y and z1 <= v1.Y + q1.Y)
			end

			for v1, v1 in ipairs(g1) do
				if not v1.cd and not v1.ibFired and v1.btn.AbsoluteSize.X > 0 and not h1(v1.btn) then
					if D1 and not v1.btn:IsDescendantOf(root) then
					else
						local D1 = v1.btn.AbsolutePosition
						local q1 = v1.btn.AbsoluteSize
						if l1 >= D1.X and l1 <= D1.X + q1.X and z1 >= D1.Y and z1 <= D1.Y + q1.Y then
							if v1.fire then
								task.spawn(v1.fire)
							end
						end
					end
				end
			end

			return Enum.ContextActionResult.Pass
		end, false, 2001, Enum.UserInputType.MouseButton2)
	end)
	local function P(l1)
		if not l1 then
			return
		end

		local D1, z1 = pcall(function()
			return l1:IsA("GuiObject")
		end)
		if not D1 or not z1 then
			return
		end

		local D1, z1 = pcall(function()
			return l1.Text
		end)
		if l1.BackgroundTransparency >= 1 and (not D1 or z1 == nil or z1 == "") then
			return
		end

		local D1 = l1:FindFirstChild("VHPop")
		if not D1 then
			D1 = Instance.new("UIScale")
			D1.Name = "VHPop"
			D1.Parent = l1
		end

		D1.Scale = 0.93
		tw(D1, 0.13, { Scale = 1 }, Enum.EasingStyle.Quad)
	end

	local function l1(D1, z1)
		local v1 = { btn = D1, cb = z1, cd = false, ibFired = false }
		local function q1()
			if v1.cd then
				return
			end

			if h1(D1) then
				return
			end

			if not (D1 and D1.Parent) then
				return
			end

			if D1.AbsoluteSize.X <= 0 or D1.AbsoluteSize.Y <= 0 then
				return
			end

			v1.cd = true
			task.delay(0.1, function()
				v1.cd = false
				v1.ibFired = false
			end)
			P(D1)
			local callbackSucceeded, callbackError = pcall(z1)
			if not callbackSucceeded then
				warn("[VampireHub] control callback error:", callbackError)
			end
		end

		v1.fire = q1
		table.insert(g1, v1)
		if D1:IsA("GuiButton") then
			D1.Activated:Connect(q1)
		end

		local P = false
		D1.InputBegan:Connect(function(h1)
			if
				h1.UserInputType == Enum.UserInputType.MouseButton1
				or h1.UserInputType == Enum.UserInputType.MouseButton2
			then
				local z1 = D1.AbsolutePosition
				local Z1 = D1.AbsoluteSize
				local E1, r1 = h1.Position.X, h1.Position.Y
				if E1 >= z1.X and E1 <= z1.X + Z1.X and r1 >= z1.Y and r1 <= z1.Y + Z1.Y then
					P = true
				end
			end
		end)
		D1.InputEnded:Connect(function(h1)
			if
				h1.UserInputType == Enum.UserInputType.MouseButton1
				or h1.UserInputType == Enum.UserInputType.MouseButton2
			then
				if P then
					local z1 = D1.AbsolutePosition
					local Z1 = D1.AbsoluteSize
					local D1, E1 = h1.Position.X, h1.Position.Y
					if D1 >= z1.X and D1 <= z1.X + Z1.X and E1 >= z1.Y and E1 <= z1.Y + Z1.Y then
						v1.ibFired = true
						q1()
					end
				end

				P = false
			end
		end)
	end

	local P = 0
	local h1 = {
		Enum.KeyCode.ButtonA,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.ButtonX,
		Enum.KeyCode.ButtonY,
		Enum.KeyCode.ButtonL1,
		Enum.KeyCode.ButtonR1,
		Enum.KeyCode.ButtonL2,
		Enum.KeyCode.ButtonR2,
		Enum.KeyCode.ButtonL3,
		Enum.KeyCode.ButtonR3,
		Enum.KeyCode.ButtonSelect,
		Enum.KeyCode.ButtonStart,
		Enum.KeyCode.DPadLeft,
		Enum.KeyCode.DPadRight,
		Enum.KeyCode.DPadUp,
		Enum.KeyCode.DPadDown,
	}
	local function D1(z1, v1)
		P = P + 1
		local q1 = "VH_Bind_" .. P
		local P = true
		local Z1
		local function E1(r1, j1)
			if not P then
				return
			end

			P = false
			if Z1 then
				Z1:Disconnect()
				Z1 = nil
			end

			pcall(function()
				game:GetService("ContextActionService"):UnbindAction(q1)
			end)
			if j1 then
				if v1 then
					v1()
				end
			elseif z1 then
				z1(r1)
			end
		end

		local z1 = tick()
		Z1 = Mt.InputBegan:Connect(function(v1)
			if not P then
				return
			end

			if tick() - z1 < 0.03 then
				return
			end

			if v1.UserInputType == Enum.UserInputType.Keyboard then
				if v1.KeyCode == Enum.KeyCode.Escape then
					E1(nil, true)
				else
					E1(v1.KeyCode, false)
				end
			elseif It(v1.UserInputType) then
				local It = v1.KeyCode
				if It ~= Enum.KeyCode.Thumbstick1 and It ~= Enum.KeyCode.Thumbstick2 then
					E1(It, false)
				end
			end
		end)
		pcall(function()
			game:GetService("ContextActionService"):BindActionAtPriority(q1, function(It, It, z1)
				if P and It == Enum.UserInputState.Begin then
					E1(z1.KeyCode, false)
				end

				return Enum.ContextActionResult.Sink
			end, false, 3000, table.unpack(h1))
		end)
		return function()
			E1(nil, true)
		end
	end

	do
		Mt.TouchStarted:Connect(function(P)
			local It = P.Position
			for P, P in ipairs(g1) do
				if not P.cd and P.btn and P.btn.Parent and P.btn.AbsoluteSize.X > 0 and P.btn.AbsoluteSize.Y > 0 then
					local h1 = P.btn.AbsolutePosition
					local z1 = P.btn.AbsoluteSize
					if It.X >= h1.X and It.X <= h1.X + z1.X and It.Y >= h1.Y and It.Y <= h1.Y + z1.Y then
						if P.fire then
							task.spawn(P.fire)
						end

						break
					end
				end
			end
		end)
	end

	local P = { Main = "Main", Move = "Other", Config = "Config", Custom = "Customization" }
	for It, h1 in ipairs(l) do
		local l = Instance.new("TextButton", tabStack)
		l.Size = UDim2.new(0, 116, 0, 40)
		l.BackgroundColor3 = h1 == "Main" and a1.purple or Color3.fromRGB(0, 0, 0)
		l.BackgroundTransparency = h1 == "Main" and 0.25 or 0.4
		l.BorderSizePixel = 0
		l.Text = P[h1] or h1
		l.TextColor3 = h1 == "Main" and a1.void or a1.white
		l.Font = Enum.Font.GothamBold
		l.TextSize = 12
		l.LayoutOrder = It
		l.ZIndex = 9
		l.RichText = false
		Instance.new("UICorner", l).CornerRadius = UDim.new(0, 10)
		local P = Instance.new("UIStroke", l)
		P.Color = h1 == "Main" and a1.purple or a1.border
		P.Thickness = 1.5
		k1[h1] = l
		l1(l, function()
			I1(h1)
		end)
	end

	C1 = P1.Main
	C1.Visible = true
	local P = { Main = 0, Move = 0, Config = 0, Custom = 0 }
	local function l(It)
		P[It] = P[It] + 1
		return P[It]
	end

	local function P(It, I1)
		local h1 = Instance.new("Frame", P1[It])
		h1.Size = UDim2.new(1, 0, 0, I1 or 5)
		h1.BackgroundTransparency = 1
		h1.BorderSizePixel = 0
		h1.LayoutOrder = l(It)
	end

	local function It(I1, h1)
		local z1 = Instance.new("Frame", P1[I1])
		z1.Size = UDim2.new(1, 0, 0, 23)
		z1.BackgroundTransparency = 1
		z1.BorderSizePixel = 0
		z1.LayoutOrder = l(I1)
		local I1 = Instance.new("Frame", z1)
		I1.Size = UDim2.new(0, 3, 1, 0)
		I1.BackgroundColor3 = a1.purple
		I1.BorderSizePixel = 0
		Instance.new("UICorner", I1).CornerRadius = UDim.new(1, 0)
		local I1 = Instance.new("TextLabel", z1)
		I1.Size = UDim2.new(1, -12.0, 1, 0)
		I1.Position = UDim2.new(0, 10, 0, 0)
		I1.BackgroundTransparency = 1
		I1.Text = h1:upper()
		I1.TextColor3 = a1.lpurple
		I1.Font = Enum.Font.GothamBold
		I1.TextSize = 11
		I1.TextStrokeTransparency = 0
		return I1
	end

	local function I1(h1)
		local z1 = Instance.new("Frame", P1[h1])
		z1.Size = UDim2.new(0.85, 0, 0, 1)
		z1.Position = UDim2.new(0.075, 0, 0, 0)
		z1.BackgroundColor3 = a1.border
		z1.BorderSizePixel = 0
		z1.LayoutOrder = l(h1)
		local h1 = Instance.new("UIGradient", z1)
		h1.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, a1.card),
			ColorSequenceKeypoint.new(0.3, a1.border),
			ColorSequenceKeypoint.new(0.7, a1.border),
			ColorSequenceKeypoint.new(1, a1.card),
		})
	end

	local function h1(z1, v1)
		local q1 = Instance.new("Frame", P1[z1])
		q1.Size = UDim2.new(1, 0, 0, v1 or 38)
		q1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		q1.BackgroundTransparency = 0
		q1.BorderSizePixel = 0
		q1.LayoutOrder = l(z1)
		Instance.new("UICorner", q1).CornerRadius = UDim.new(0, 12)
		local z1 = Instance.new("UIStroke", q1)
		z1.Color = a1.border
		z1.Thickness = 1.5
		q1.MouseEnter:Connect(function()
			tw(q1, 0.1, { BackgroundTransparency = 0 })
			tw(z1, 0.1, { Color = a1.purple })
		end)
		q1.MouseLeave:Connect(function()
			tw(q1, 0.1, { BackgroundTransparency = 0 })
			tw(z1, 0.1, { Color = a1.border })
		end)
		return q1, z1
	end

	local function z1(v1, q1, Z1, E1, r1, j1, e1, T1, N1, K1)
		local c1 = Instance.new("TextLabel", v1)
		c1.Size = UDim2.new(r1 or 0.55, 0, 0, j1 or 42)
		c1.Position = UDim2.new(0, Z1 or 10, 0, E1 or 0)
		c1.BackgroundTransparency = 1
		c1.Text = q1
		c1.TextColor3 = T1 or a1.white
		c1.Font = N1 or Enum.Font.GothamBold
		c1.TextSize = e1 or 11
		c1.TextStrokeTransparency = K1 or 0
		return c1
	end

	local function v1(q1, Z1, E1, r1, j1, e1)
		local T1, N1 = h1(q1, 42)
		z1(T1, Z1, 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local q1 = nil
		if E1 then
			q1 = Instance.new("TextButton", T1)
			q1.Size = UDim2.new(0, 54, 0, 25)
			q1.Position = UDim2.new(1, -130.0, 0.5, -12.5)
			q1.BackgroundColor3 = a1.void
			q1.BorderSizePixel = 0
			q1.Text = E1.Name
			q1.TextColor3 = a1.dim
			q1.Font = Enum.Font.GothamBold
			q1.TextSize = 9
			q1.ZIndex = 5
			Instance.new("UICorner", q1).CornerRadius = UDim.new(0, 7)
			local Z1 = Instance.new("UIStroke", q1)
			Z1.Color = a1.border
			Z1.Thickness = 1.5
			local E1 = false
			local N1
			local function K1()
				tw(Z1, 0.1, { Color = a1.border })
				q1.TextColor3 = a1.dim
			end

			local function c1(A1)
				E1 = false
				if N1 then
					local u1 = N1
					N1 = nil
					u1()
				end

				K1()
				if A1 then
					q1.Text = A1.Name
					if e1 then
						e1(A1)
					end
				end
			end

			local function e1()
				if E1 then
					c1(nil)
					return
				end

				E1 = true
				q1.Text = "..."
				q1.TextColor3 = a1.purple
				tw(Z1, 0.1, { Color = a1.purple })
				N1 = D1(function(Z1)
					N1 = nil
					c1(Z1)
				end, function()
					N1 = nil
					E1 = false
					K1()
				end)
			end

			l1(q1, e1)
		end

		local Z1 = Instance.new("Frame", T1)
		Z1.Size = UDim2.new(0, 47, 0, 23)
		Z1.Position = UDim2.new(1, -67.0, 0.5, -13.0)
		Z1.BackgroundColor3 = r1 and a1.on or a1.off
		Z1.BorderSizePixel = 0
		Z1.ZIndex = 5
		Instance.new("UICorner", Z1).CornerRadius = UDim.new(1, 0)
		local E1 = Instance.new("UIStroke", Z1)
		E1.Color = r1 and a1.purple or a1.border
		E1.Thickness = 1.5
		local e1 = Instance.new("Frame", Z1)
		e1.Size = UDim2.new(0, 18, 0, 18)
		e1.Position = r1 and UDim2.new(1, -23.0, 0.5, -10.0) or UDim2.new(0, 3, 0.5, -9.0)
		e1.BackgroundColor3 = r1 and a1.white or a1.dim
		e1.BorderSizePixel = 0
		e1.ZIndex = 6
		Instance.new("UICorner", e1).CornerRadius = UDim.new(1, 0)
		local N1 = r1 or false
		local function r1(K1)
			N1 = K1
			tw(Z1, 0.16, { BackgroundColor3 = K1 and a1.on or a1.off })
			tw(E1, 0.16, { Color = K1 and a1.purple or a1.border })
			tw(e1, 0.18, {
				Position = K1 and UDim2.new(1, -23.0, 0.5, -10.0) or UDim2.new(0, 3, 0.5, -9.0),
				BackgroundColor3 = K1 and a1.white or a1.dim,
			}, Enum.EasingStyle.Quad)
		end

		local E1 = Instance.new("TextButton", T1)
		E1.Size = UDim2.new(0, 47, 0, 23)
		E1.Position = UDim2.new(1, -67.0, 0.5, -13.0)
		E1.BackgroundTransparency = 1
		E1.Text = ""
		E1.ZIndex = 7
		l1(E1, function()
			N1 = not N1
			r1(N1)
			if j1 then
				pcall(j1, N1)
			end
		end)
		if q1 then
			q1.ZIndex = 6
		end

		Z1.ZIndex = 5
		e1.ZIndex = 6
		return r1, q1, T1
	end

	local function q1(Z1, E1, r1, j1)
		local e1 = h1(Z1, 42)
		z1(e1, E1, 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local Z1 = Instance.new("TextBox", e1)
		Z1.Size = UDim2.new(0, 88, 0, 32)
		Z1.Position = UDim2.new(1, -96.0, 0.5, -16.0)
		Z1.BackgroundColor3 = a1.void
		Z1.BackgroundTransparency = 0
		Z1.BorderSizePixel = 0
		Z1.Text = tostring(r1)
		Z1.TextColor3 = a1.purple
		Z1.Font = Enum.Font.GothamBold
		Z1.TextSize = 12
		Z1.ClearTextOnFocus = true
		Z1.MultiLine = false
		Instance.new("UICorner", Z1).CornerRadius = UDim.new(0, 8)
		local E1 = Instance.new("UIStroke", Z1)
		E1.Color = a1.border
		E1.Thickness = 1.5
		local e1 = tostring(r1)
		Z1.Focused:Connect(function()
			tw(E1, 0.1, { Color = a1.purple })
		end)
		Z1.FocusLost:Connect(function()
			tw(E1, 0.1, { Color = a1.border })
			if j1 then
				local E1 = tonumber(Z1.Text)
				if E1 then
					j1(Z1.Text)
					e1 = Z1.Text
				else
					Z1.Text = e1
				end
			end
		end)
		Z1.TouchTap:Connect(function()
			Z1:CaptureFocus()
		end)
		return Z1
	end

	local function Z1(E1, r1, j1)
		local e1 = h1(E1, 42)
		z1(e1, r1, 10, 0, 0.5, 42, 10, a1.white, Enum.Font.GothamBold)
		local E1 = Instance.new("TextLabel", e1)
		E1.Size = UDim2.new(0.45, -8.0, 1, 0)
		E1.Position = UDim2.new(0.52, 0, 0, 0)
		E1.BackgroundTransparency = 1
		E1.Text = j1
		E1.TextColor3 = a1.purple
		E1.Font = Enum.Font.Gotham
		E1.TextSize = 12
		E1.TextStrokeTransparency = 0
		return E1
	end

	local function E1(r1, j1, e1, T1)
		local N1 = h1(r1, 42)
		z1(N1, j1, 10, 0, 0.55, 42, 10, a1.white, Enum.Font.GothamBold)
		local r1 = Instance.new("TextButton", N1)
		r1.Size = UDim2.new(0, 76, 0, 25)
		r1.Position = UDim2.new(1, -84.0, 0.5, -12.5)
		r1.BackgroundColor3 = a1.void
		r1.BorderSizePixel = 0
		r1.Text = e1.Name
		r1.TextColor3 = a1.lpurple
		r1.Font = Enum.Font.GothamBold
		r1.TextSize = 10
		Instance.new("UICorner", r1).CornerRadius = UDim.new(0, 8)
		local j1 = Instance.new("UIStroke", r1)
		j1.Color = a1.border
		j1.Thickness = 1.5
		local e1 = false
		local N1
		local function K1()
			tw(j1, 0.1, { Color = a1.border })
			r1.TextColor3 = a1.lpurple
		end

		local function c1(A1)
			e1 = false
			if N1 then
				local u1 = N1
				N1 = nil
				u1()
			end

			K1()
			if A1 then
				r1.Text = A1.Name
				if T1 then
					T1(A1)
				end
			end
		end

		local function T1()
			if e1 then
				c1(nil)
				return
			end

			e1 = true
			r1.Text = "..."
			r1.TextColor3 = a1.purple
			tw(j1, 0.1, { Color = a1.purple })
			N1 = D1(function(D1)
				N1 = nil
				c1(D1)
			end, function()
				N1 = nil
				e1 = false
				K1()
			end)
		end

		l1(r1, T1)
		return r1
	end

	_VH_btnTxt = function()
		local D1 = a1.purple
		return D1.R * 0.299 + D1.G * 0.587 + D1.B * 0.114 < 0.35 and Color3.fromRGB(255, 255, 255) or a1.void
	end

	local function D1(r1, j1, e1)
		local T1 = Instance.new("TextButton", P1[r1])
		T1.Size = UDim2.new(1, 0, 0, 42)
		T1.BorderSizePixel = 0
		T1.LayoutOrder = l(r1)
		T1.Text = j1
		T1.TextColor3 = _VH_btnTxt()
		T1.Font = Enum.Font.Gotham
		T1.TextSize = 12
		T1.BackgroundColor3 = a1.purple
		Instance.new("UICorner", T1).CornerRadius = UDim.new(0, 12)
		local r1 = Instance.new("UIGradient", T1)
		r1.Color =
			ColorSequence.new({ ColorSequenceKeypoint.new(0, a1.dpurple), ColorSequenceKeypoint.new(1, a1.purple) })
		r1.Rotation = 90
		l1(T1, function()
			tw(T1, 0.07, { BackgroundColor3 = a1.lpurple })
			task.delay(0.18, function()
				tw(T1, 0.14, { BackgroundColor3 = a1.purple })
			end)
			if e1 then
				pcall(e1)
			end
		end)
		T1.MouseEnter:Connect(function()
			tw(T1, 0.1, { BackgroundColor3 = a1.lpurple })
			T1.TextColor3 = _VH_btnTxt()
		end)
		T1.MouseLeave:Connect(function()
			tw(T1, 0.1, { BackgroundColor3 = a1.purple })
			T1.TextColor3 = _VH_btnTxt()
		end)
		return T1
	end

	task.wait()
	It("Main", "Speed")
	normalBox = q1("Main", "Normal Speed", zt.normalSpeed, function(r1)
		local j1 = tonumber(r1)
		if j1 and j1 > 0 and j1 <= 500 then
			zt.normalSpeed = j1
		end
	end)
	carryBox = q1("Main", "Carry Speed", zt.carrySpeed, function(r1)
		local j1 = tonumber(r1)
		if j1 and j1 > 0 and j1 <= 500 then
			zt.carrySpeed = j1
		end
	end)
	P("Main", 6)
	do
		setBurstPreset = function(r1)
			zt.burstPreset = "lagger"
		end

		local function r1()
			if Bt and Bt.lagger then
				Bt.lagger.setOn(zt.laggerMode == 1)
			end

			if Bt and Bt.laggerCarry then
				Bt.laggerCarry.setOn(zt.laggerMode == 2)
			end

			if Bt and Bt.carrySpeed then
				Bt.carrySpeed.setOn(zt.laggerMode == 0 and zt.speedToggled)
			end
		end

		_VH_speedToNormal = function()
			zt.speedToggled = false
			zt._prevSpeed = false
			zt._prevCarry = zt.carrySpeed
			if zt.laggerMode ~= 0 then
				zt.laggerMode = 0
				zt.carrySpeed = zt._prevCarry or zt.carrySpeed
			end

			if carryBox then
				carryBox.Text = tostring(zt.normalSpeed)
			end

			if modeValLbl then
				modeValLbl.Text = "Normal"
			end

			if Bt then
				if Bt.lagger then
					Bt.lagger.setOn(false)
				end

				if Bt.laggerCarry then
					Bt.laggerCarry.setOn(false)
				end

				if Bt.carrySpeed then
					Bt.carrySpeed.setOn(false)
				end
			end
		end

		setLaggerMode = function(j1)
			if j1 == 1 and zt.safeModeEnabled and zt.speedToggled and _G._VH_hbCached and _G._VH_hbCached() then
				j1 = 2
			end

			if j1 == zt.laggerMode then
				return
			end

			local e1 = zt.laggerMode
			if j1 == 0 then
				zt.carrySpeed = zt._prevCarry or 30
				zt.speedToggled = zt._prevSpeed or false
				if carryBox then
					carryBox.Text = tostring(zt.speedToggled and zt.carrySpeed or zt.normalSpeed)
				end

				if modeValLbl then
					modeValLbl.Text = zt.speedToggled and "Carry" or "Normal"
				end
			elseif j1 == 1 then
				if e1 == 0 then
					zt._prevCarry = zt.carrySpeed
					zt._prevSpeed = zt.speedToggled
				end

				zt.speedToggled = false
				if modeValLbl then
					modeValLbl.Text = "Lagger"
				end

				if carryBox then
					carryBox.Text = tostring(zt.burstNormalSpeed)
				end
			elseif j1 == 2 then
				if e1 == 0 then
					zt._prevCarry = zt.carrySpeed
					zt._prevSpeed = zt.speedToggled
				end

				zt.speedToggled = false
				if modeValLbl then
					modeValLbl.Text = "Lagger Carry"
				end

				if carryBox then
					carryBox.Text = tostring(zt.burstCarrySpeed)
				end
			end

			zt.laggerMode = j1
			r1()
		end
	end

	toggleLaggerMode = function()
		if zt.laggerMode == 0 then
			setLaggerMode(1)
		elseif zt.laggerMode == 1 then
			setLaggerMode(2)
		else
			setLaggerMode(1)
		end
	end

	burstNormalBox = q1("Main", "Lagger Normal", zt.burstNormalSpeed, function(r1)
		local j1 = tonumber(r1)
		if j1 and j1 > 0 and j1 <= 500 then
			zt.burstNormalSpeed = j1
		end
	end)
	burstCarryBox = q1("Main", "Lagger Carry", zt.burstCarrySpeed, function(r1)
		local j1 = tonumber(r1)
		if j1 and j1 > 0 and j1 <= 500 then
			zt.burstCarrySpeed = j1
		end
	end)
	P("Main", 2)
	modeValLbl = Z1("Main", "Mode", "Normal")
	P("Main", 5)
	speedKeyBtn = E1("Main", "Speed Key", Lt.speed, function(r1)
		Lt.speed = r1
	end)
	do
		local r1, j1
		_lkb = E1("Main", "Lagger Key", Lt.lagger, function(e1)
			Lt.lagger = e1
			Lt.burst = e1
		end)
		j1 = _lkb.Parent
		_bkb = _lkb
		r1 = j1
		P("Main", 5)
		local r1 = h1("Main", 42)
		z1(r1, "Speed Change Method", 10, 0, 0, 42, 8, a1.white, Enum.Font.GothamBold)
		local e1 = Instance.new("TextButton", r1)
		e1.Size = UDim2.new(0, 52, 0, 28)
		e1.Position = UDim2.new(1, -132.0, 0.5, -14.0)
		e1.BorderSizePixel = 0
		e1.Text = "V1"
		e1.Font = Enum.Font.GothamBold
		e1.TextSize = 11
		e1.RichText = false
		e1.ZIndex = 5
		Instance.new("UICorner", e1).CornerRadius = UDim.new(0, 9)
		local T1 = Instance.new("UIStroke", e1)
		T1.Thickness = 1.5
		local N1 = Instance.new("TextButton", r1)
		N1.Size = UDim2.new(0, 52, 0, 28)
		N1.Position = UDim2.new(1, -72.0, 0.5, -14.0)
		N1.BorderSizePixel = 0
		N1.Text = "V2"
		N1.Font = Enum.Font.GothamBold
		N1.TextSize = 11
		N1.RichText = false
		N1.ZIndex = 5
		Instance.new("UICorner", N1).CornerRadius = UDim.new(0, 9)
		local r1 = Instance.new("UIStroke", N1)
		r1.Thickness = 1.5
		local function K1()
			local c1 = zt.speedChangeMethod == "v1"
			tw(e1, 0.15, { BackgroundColor3 = c1 and a1.purple or a1.void })
			e1.TextColor3 = c1 and a1.void or a1.dim
			tw(T1, 0.15, { Color = c1 and a1.purple or a1.border })
			tw(N1, 0.15, { BackgroundColor3 = not c1 and a1.purple or a1.void })
			N1.TextColor3 = not c1 and a1.void or a1.dim
			tw(r1, 0.15, { Color = not c1 and a1.purple or a1.border })
			if j1 then
				j1.Visible = true
			end
		end

		setSpeedChangeMethod = function(r1)
			if r1 == "v2" and burstActive then
				zt.normalSpeed = savedNormalSpeed or zt.normalSpeed
				zt.carrySpeed = savedCarrySpeed or zt.carrySpeed
				if normalBox then
					normalBox.Text = tostring(zt.normalSpeed)
				end

				if carryBox then
					carryBox.Text = tostring(zt.carrySpeed)
				end

				burstActive = false
				_G._VH_burstActive = false
			elseif r1 == "v1" and zt.laggerMode ~= 0 then
				setLaggerMode(0)
			end

			zt.speedChangeMethod = r1
			K1()
		end

		l1(e1, function()
			setSpeedChangeMethod("v1")
		end)
		l1(N1, function()
			setSpeedChangeMethod("v2")
		end)
		K1()
	end

	P("Main", 3)
	I1("Main")
	P("Main", 3)
	It("Main", "Combat")
	do
		local r1 = h1("Main", 42)
		z1(r1, "Aimbot Version", 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local j1 = Instance.new("TextButton", r1)
		j1.Size = UDim2.new(0, 46, 0, 28)
		j1.Position = UDim2.new(1, -160.0, 0.5, -14.0)
		j1.BorderSizePixel = 0
		j1.Text = "V1"
		j1.Font = Enum.Font.GothamBold
		j1.TextSize = 11
		j1.RichText = false
		j1.ZIndex = 5
		Instance.new("UICorner", j1).CornerRadius = UDim.new(0, 9)
		local e1 = Instance.new("UIStroke", j1)
		e1.Thickness = 1.5
		local T1 = Instance.new("TextButton", r1)
		T1.Size = UDim2.new(0, 46, 0, 28)
		T1.Position = UDim2.new(1, -108.0, 0.5, -14.0)
		T1.BorderSizePixel = 0
		T1.Text = "V2"
		T1.Font = Enum.Font.GothamBold
		T1.TextSize = 11
		T1.RichText = false
		T1.ZIndex = 5
		Instance.new("UICorner", T1).CornerRadius = UDim.new(0, 9)
		local N1 = Instance.new("UIStroke", T1)
		N1.Thickness = 1.5
		local K1 = Instance.new("TextButton", r1)
		K1.Size = UDim2.new(0, 46, 0, 28)
		K1.Position = UDim2.new(1, -56.0, 0.5, -14.0)
		K1.BorderSizePixel = 0
		K1.Text = "V3"
		K1.Font = Enum.Font.GothamBold
		K1.TextSize = 11
		K1.RichText = false
		K1.ZIndex = 5
		Instance.new("UICorner", K1).CornerRadius = UDim.new(0, 9)
		local r1 = Instance.new("UIStroke", K1)
		r1.Thickness = 1.5
		local function c1()
			local A1 = zt.autoBatVersion == "v1"
			local u1 = zt.autoBatVersion == "v2"
			local U1 = zt.autoBatVersion == "v3"
			tw(j1, 0.15, { BackgroundColor3 = A1 and a1.purple or a1.void })
			j1.TextColor3 = A1 and a1.void or a1.dim
			tw(e1, 0.15, { Color = A1 and a1.purple or a1.border })
			tw(T1, 0.15, { BackgroundColor3 = u1 and a1.purple or a1.void })
			T1.TextColor3 = u1 and a1.void or a1.dim
			tw(N1, 0.15, { Color = u1 and a1.purple or a1.border })
			tw(K1, 0.15, { BackgroundColor3 = U1 and a1.purple or a1.void })
			K1.TextColor3 = U1 and a1.void or a1.dim
			tw(r1, 0.15, { Color = U1 and a1.purple or a1.border })
		end

		setAimbotVersion = function(r1)
			if zt.autoBatToggled then
				stopBatAimbot()
			end

			zt.autoBatVersion = r1
			c1()
			if zt.autoBatToggled then
				startBatAimbot()
			end
		end

		c1()
		l1(j1, function()
			setAimbotVersion("v1")
		end)
		l1(T1, function()
			setAimbotVersion("v2")
		end)
		l1(K1, function()
			setAimbotVersion("v3")
		end)
	end

	setAutoSwingVisual = v1("Main", "Auto Swing", nil, zt.autoSwingEnabled, function(r1)
		zt.autoSwingEnabled = r1
	end)
	et, _ = v1("Main", "Mirror TP Down", nil, zt.mirrorTPDownEnabled, function(r1)
		zt.mirrorTPDownEnabled = r1
	end)
	setAutoBat, autoBatKeyBtn = v1("Main", "Auto Bat", Lt.autoBat, false, function(r1)
		zt.autoBatToggled = r1
		if r1 then
			_VH_forceDesyncOff()
			startBatAimbot()
		else
			stopBatAimbot()
		end

		if Bt and Bt.aimbot then
			Bt.aimbot.setOn(r1)
		end
	end, function(r1)
		Lt.autoBat = r1
	end)
	autoBatSpeedBox = q1("Main", "Aimbot Speed", zt.autoBatSpeed, function(r1)
		local j1 = tonumber(r1)
		if j1 and j1 > 0 and j1 <= 500 then
			zt.autoBatSpeed = j1
		end
	end)
	predictionStatusLbl = Z1("Main", "Prediction", "ACTIVE")
	v1("Main", "Disable at 180+", nil, zt.disablePredictionAt180, function(Z1)
		zt.disablePredictionAt180 = Z1
	end)
	setBatCounterVisual = v1("Main", "Bat Counter", nil, false, function(Z1)
		zt.batCounterEnabled = Z1
		if Z1 then
			startBatCounter()
		else
			stopBatCounter()
		end
	end)
	P("Main", 3)
	I1("Main")
	P("Main", 3)
	It("Main", "Mechanics")
	setInstaGrab = v1("Main", "Insta Grab", nil, false, function(Z1)
		if Z1 then
			yt.AutoStealEnabled = true
			pcall(function()
				if type(startAutoSteal) == "function" then
					startAutoSteal()
				end
			end)
		else
			yt.AutoStealEnabled = false
			pcall(function()
				if type(stopAutoSteal) == "function" then
					stopAutoSteal()
				end
			end)
		end
	end)
	do
		local Z1 = v1("Main", "Kick Warning", nil, zt.kickWarningEnabled, function(r1)
			zt.kickWarningEnabled = r1
			if not r1 and _G._VH_hideKickWarning then
				pcall(_G._VH_hideKickWarning)
			end
		end)
		_G._VH_setKickWarning = Z1
	end

	do
		local Z1 = h1("Main", 42)
		z1(Z1, "Jump Type", 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local r1 = Instance.new("TextButton", Z1)
		r1.Size = UDim2.new(0, 72, 0, 28)
		r1.Position = UDim2.new(1, -156.0, 0.5, -14.0)
		r1.BorderSizePixel = 0
		r1.Text = "Hold"
		r1.Font = Enum.Font.GothamBold
		r1.TextSize = 10
		r1.RichText = false
		r1.ZIndex = 5
		Instance.new("UICorner", r1).CornerRadius = UDim.new(0, 9)
		local j1 = Instance.new("UIStroke", r1)
		j1.Thickness = 1.5
		local e1 = Instance.new("TextButton", Z1)
		e1.Size = UDim2.new(0, 72, 0, 28)
		e1.Position = UDim2.new(1, -80.0, 0.5, -14.0)
		e1.BorderSizePixel = 0
		e1.Text = "Manual"
		e1.Font = Enum.Font.GothamBold
		e1.TextSize = 10
		e1.RichText = false
		e1.ZIndex = 5
		Instance.new("UICorner", e1).CornerRadius = UDim.new(0, 9)
		local Z1 = Instance.new("UIStroke", e1)
		Z1.Thickness = 1.5
		setJumpTypeUI = function(T1, N1)
			if T1 ~= "manual" then
				T1 = "hold"
			end

			zt.jumpType = T1
			local K1 = T1 == "hold"
			tw(r1, 0.15, { BackgroundColor3 = K1 and a1.purple or a1.void })
			r1.TextColor3 = K1 and a1.void or a1.dim
			tw(j1, 0.15, { Color = K1 and a1.purple or a1.border })
			tw(e1, 0.15, { BackgroundColor3 = not K1 and a1.purple or a1.void })
			e1.TextColor3 = not K1 and a1.void or a1.dim
			tw(Z1, 0.15, { Color = not K1 and a1.purple or a1.border })
			zt.holdInfJumpEnabled = K1
			zt.infJumpEnabled = not K1
			if N1 then
				return
			end

			if K1 then
				if startHoldInfJump then
					startHoldInfJump()
				end
			else
				if stopHoldInfJump then
					stopHoldInfJump()
				end
			end
		end

		l1(r1, function()
			setJumpTypeUI("hold")
		end)
		l1(e1, function()
			setJumpTypeUI("manual")
		end)
		setJumpTypeUI(zt.jumpType, true)
	end

	jumpPowerBox = q1("Main", "Jump Power", zt.jumpPower, function(Z1)
		local r1 = tonumber(Z1)
		if r1 then
			r1 = math.clamp(math.floor(r1 + 0.5), 45, 50)
			zt.jumpPower = r1
			if jumpPowerBox then
				jumpPowerBox.Text = tostring(r1)
			end

			if applyJumpPower then
				applyJumpPower()
			end
		end
	end)
	setAntiRag = function(Z1)
		zt.antiRagdollEnabled = Z1
		if Z1 then
			startAntiRagdoll()
		else
			stopAntiRagdoll()
		end
	end

	antiRagToggleSet, _ = v1("Main", "Anti Ragdoll", nil, false, function(Z1)
		setAntiRag(Z1)
	end)
	setFps = v1("Main", "FPS Boost", nil, false, function(Z1)
		zt.fpsBoostEnabled = Z1
		if Z1 then
			pcall(applyFPSBoost)
			pcall(enableAntiLag)
		else
			pcall(disableFPSBoost)
			pcall(disableAntiLag)
		end
	end)
	setMedusaCounter = v1("Main", "Medusa Counter", nil, false, function(Z1)
		zt.medusaCounterEnabled = Z1
		if Z1 then
			setupMedusaCounter(Rt.Character)
		else
			stopMedusaCounter()
		end
	end)
	setAutoCarryOnGrab = v1("Main", "Auto Carry on Grab", nil, false, function(Z1)
		zt.autoCarryOnGrab = Z1
		if not Z1 and _G._VH_resetAutoCarryRuntime then
			_G._VH_resetAutoCarryRuntime()
		end
	end)
	do
		local Z1 = h1("Main", 42)
		z1(Z1, "Auto Carry Version", 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local r1 = Instance.new("TextButton", Z1)
		r1.Size = UDim2.new(0, 52, 0, 28)
		r1.Position = UDim2.new(1, -132.0, 0.5, -14.0)
		r1.Text = "V1"
		r1.Font = Enum.Font.GothamBold
		r1.TextSize = 12
		r1.RichText = false
		r1.BorderSizePixel = 0
		r1.ZIndex = 5
		Instance.new("UICorner", r1).CornerRadius = UDim.new(0, 8)
		local j1 = Instance.new("UIStroke", r1)
		j1.Thickness = 1.5
		local e1 = Instance.new("TextButton", Z1)
		e1.Size = UDim2.new(0, 52, 0, 28)
		e1.Position = UDim2.new(1, -72.0, 0.5, -14.0)
		e1.Text = "V2"
		e1.Font = Enum.Font.GothamBold
		e1.TextSize = 12
		e1.RichText = false
		e1.BorderSizePixel = 0
		e1.ZIndex = 5
		Instance.new("UICorner", e1).CornerRadius = UDim.new(0, 8)
		local Z1 = Instance.new("UIStroke", e1)
		Z1.Thickness = 1.5
		local function T1()
			local N1 = zt.autoCarryVersion == "v1"
			r1.BackgroundColor3 = N1 and a1.purple or a1.void
			r1.TextColor3 = N1 and a1.white or a1.dim
			j1.Color = N1 and a1.lpurple or a1.border
			e1.BackgroundColor3 = not N1 and a1.purple or a1.void
			e1.TextColor3 = not N1 and a1.white or a1.dim
			Z1.Color = not N1 and a1.lpurple or a1.border
		end

		_G._VH_setAutoCarryVersionUI = function(Z1)
			Z1 = Z1 == "v1" and "v1" or "v2"
			if zt.autoCarryVersion ~= Z1 and _G._VH_resetAutoCarryRuntime then
				_G._VH_resetAutoCarryRuntime()
			end

			zt.autoCarryVersion = Z1
			T1()
		end

		l1(r1, function()
			_G._VH_setAutoCarryVersionUI("v1")
		end)
		l1(e1, function()
			_G._VH_setAutoCarryVersionUI("v2")
		end)
		T1()
	end

	setUnwalkToggle = v1("Main", "Unwalk", nil, false, function(Z1)
		if Z1 then
			startUnwalk()
		else
			stopUnwalk()
		end
	end)
	do
		local Z1 = h1("Main", 42)
		z1(Z1, "Customize ESP", 10, 0, 0, 42, 10, a1.white, Enum.Font.GothamBold)
		local r1 = Instance.new("TextButton", Z1)
		r1.Size = UDim2.new(0, 40, 0, 40)
		r1.Position = UDim2.new(1, -48.0, 0.5, -20.0)
		r1.BackgroundColor3 = a1.void
		r1.BorderSizePixel = 0
		r1.Text = "\226\150\182"
		r1.TextColor3 = a1.lpurple
		r1.Font = Enum.Font.GothamBold
		r1.TextSize = 20
		r1.RichText = false
		r1.ZIndex = 5
		Instance.new("UICorner", r1).CornerRadius = UDim.new(0, 10)
		local Z1 = Instance.new("UIStroke", r1)
		Z1.Color = a1.border
		Z1.Thickness = 1.5
		local function Z1(j1, e1, T1)
			local N1, K1 = h1("Main", 40)
			z1(N1, "  \226\128\162 " .. j1, 10, 0, 0, 40, 10, a1.dim, Enum.Font.GothamBold)
			local j1 = Instance.new("Frame", N1)
			j1.Size = UDim2.new(0, 47, 0, 23)
			j1.Position = UDim2.new(1, -67.0, 0.5, -13.0)
			j1.BackgroundColor3 = e1 and a1.on or a1.off
			j1.BorderSizePixel = 0
			j1.ZIndex = 5
			Instance.new("UICorner", j1).CornerRadius = UDim.new(1, 0)
			local K1 = Instance.new("UIStroke", j1)
			K1.Color = e1 and a1.purple or a1.border
			K1.Thickness = 1.5
			local c1 = Instance.new("Frame", j1)
			c1.Size = UDim2.new(0, 18, 0, 18)
			c1.Position = e1 and UDim2.new(1, -23.0, 0.5, -10.0) or UDim2.new(0, 3, 0.5, -9.0)
			c1.BackgroundColor3 = e1 and a1.white or a1.dim
			c1.BorderSizePixel = 0
			c1.ZIndex = 6
			Instance.new("UICorner", c1).CornerRadius = UDim.new(1, 0)
			local A1 = e1 or false
			local function e1(u1)
				A1 = u1
				tw(j1, 0.16, { BackgroundColor3 = u1 and a1.on or a1.off })
				tw(K1, 0.16, { Color = u1 and a1.purple or a1.border })
				tw(c1, 0.18, {
					Position = u1 and UDim2.new(1, -23.0, 0.5, -10.0) or UDim2.new(0, 3, 0.5, -9.0),
					BackgroundColor3 = u1 and a1.white or a1.dim,
				}, Enum.EasingStyle.Quad)
			end

			local j1 = Instance.new("TextButton", N1)
			j1.Size = UDim2.new(0, 47, 0, 23)
			j1.Position = UDim2.new(1, -67.0, 0.5, -13.0)
			j1.BackgroundTransparency = 1
			j1.Text = ""
			j1.ZIndex = 7
			l1(j1, function()
				A1 = not A1
				e1(A1)
				if T1 then
					pcall(T1, A1)
				end
			end)
			return N1, e1
		end

		local j1, e1 = Z1("Aura (Highlight)", zt.espAuraEnabled, function(T1)
			if _seA then
				_seA(T1)
			else
				zt.espAuraEnabled = T1
			end
		end)
		local T1, N1 = Z1("Line ESP", zt.espLineEnabled, function(K1)
			if _seL then
				_seL(K1)
			else
				zt.espLineEnabled = K1
			end
		end)
		local K1, c1 = Z1("Hitbox", zt.espHitboxEnabled, function(Z1)
			if _seH then
				_seH(Z1)
			else
				zt.espHitboxEnabled = Z1
			end
		end)
		_G._VH_setEspUI = function()
			e1(zt.espAuraEnabled)
			N1(zt.espLineEnabled)
			c1(zt.espHitboxEnabled)
		end

		local function Z1()
			local e1 = zt.espPanelOpen
			j1.Visible = e1
			T1.Visible = e1
			K1.Visible = e1
			r1.Text = e1 and "\226\150\188" or "\226\150\182"
		end

		zt.espPanelOpen = false
		Z1()
		l1(r1, function()
			zt.espPanelOpen = not zt.espPanelOpen
			Z1()
		end)
	end

	do
		local Z1 = h1("Main", 42)
		z1(Z1, "Animations", 10, 0, 0.6, 42, 10, a1.white, Enum.Font.GothamBold)
		local r1 = Instance.new("TextLabel", Z1)
		r1.Size = UDim2.new(0, 100, 1, 0)
		r1.Position = UDim2.new(1, -158.0, 0, 0)
		r1.BackgroundTransparency = 1
		r1.Text = zt.selectedAnim
		r1.TextColor3 = a1.purple
		r1.Font = Enum.Font.GothamBold
…"
 content://media/external/downloads/1000102178#:~:text=%2D%2D%20%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%0A%2D%2D%20LEAKED%20BY%20/printed%20%E2%80%A2%20NUMBER,fn)%0A%09%09end%0A%09end%0Aend)