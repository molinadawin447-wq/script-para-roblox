if _G.BloodHoundsRunning then return end
_G.BloodHoundsRunning = true
​repeat task.wait() until game:IsLoaded()
​-- ============================================================
-- INTRO (Parch3 Duels)
-- ============================================================
​local CleanHubPlayers=game:GetService("Players")
local CleanHubTweenService=game:GetService("TweenService")
local CleanHubRunService=game:GetService("RunService")
local CleanHubPlayer=CleanHubPlayers.LocalPlayer
local CleanHubGuiName="CleanLettersIntro"
local CleanHubSongs={"https://files.catbox.moe/vbyghu.mp3","https://files.catbox.moe/5g2wg1.mp3","https://files.catbox.moe/r29x0i.mp3","https://files.catbox.moe/n53amf.mp3","https://files.catbox.moe/o4di3j.mp3","https://files.catbox.moe/um4hgp.mp3","https://files.catbox.moe/fiiu4a.mp3","https://files.catbox.moe/mdjmee.mp3","https://files.catbox.moe/2eysnf.mp3","https://files.catbox.moe/d4uky5.mp3","https://files.catbox.moe/8v5xra.mp3","https://files.catbox.moe/aneanv.mp3","https://files.catbox.moe/pm6lne.mp3","https://files.catbox.moe/y4q5y3.mp3","https://files.catbox.moe/pcdvty.mp3"}
local CleanHubSongIndex=1
pcall(function()
if isfile and readfile and isfile("FictionHub.json") then
local CleanHubSaved=game:GetService("HttpService"):JSONDecode(readfile("FictionHub.json"))
if type(CleanHubSaved.cleanHubSongIndex)=="number" then CleanHubSongIndex=math.clamp(math.floor(CleanHubSaved.cleanHubSongIndex),1,#CleanHubSongs) end
end
end)
local CleanHubSongUrl=CleanHubSongs[CleanHubSongIndex]
local CleanHubSongFile="cleanhub_intro_song_"..CleanHubSongIndex..".mp3"
local CleanHubIntroSound=nil
local CleanHubSoundEndedConnection=nil
​for _,CleanHubParent in ipairs({game:GetService("CoreGui"),CleanHubPlayer and CleanHubPlayer:FindFirstChildOfClass("PlayerGui")}) do
local CleanHubOld=CleanHubParent and CleanHubParent:FindFirstChild(CleanHubGuiName)
if CleanHubOld then CleanHubOld:Destroy() end
end
​local CleanHubGui=Instance.new("ScreenGui")
CleanHubGui.Name=CleanHubGuiName; CleanHubGui.IgnoreGuiInset=true; CleanHubGui.ResetOnSpawn=false; CleanHubGui.DisplayOrder=100000
CleanHubGui.ZIndexBehavior=Enum.ZIndexBehavior.Global
pcall(function() if syn and syn.protect_gui then syn.protect_gui(CleanHubGui) end end)
if not pcall(function() CleanHubGui.Parent=game:GetService("CoreGui") end) then CleanHubGui.Parent=CleanHubPlayer:WaitForChild("PlayerGui") end
​local CleanHubAssets={
"rbxassetid://102527460927859",
"rbxassetid://115218770459100",
"rbxassetid://79239854929751",
"rbxassetid://132491364078344",
"rbxassetid://88405482927089",
}
​local CleanHubLetters={}
local CleanHubStarted=os.clock()
local CleanHubFloatConnection
local CleanHubFinished=false
​for CleanHubIndex,CleanHubAsset in ipairs(CleanHubAssets) do
local CleanHubLetter=Instance.new("ImageLabel",CleanHubGui)
CleanHubLetter.Name="CleanLetter"..CleanHubIndex
CleanHubLetter.AnchorPoint=Vector2.new(.5,.5)
CleanHubLetter.Size=UDim2.fromOffset(340,340)
CleanHubLetter.Position=UDim2.new(.5,(CleanHubIndex-3)225,.5,-18)
CleanHubLetter.BackgroundTransparency=1
CleanHubLetter.Image=CleanHubAsset
CleanHubLetter.ScaleType=Enum.ScaleType.Fit
CleanHubLetter.ImageTransparency=1
CleanHubLetter.ZIndex=3
CleanHubLetters[CleanHubIndex]={image=CleanHubLetter,base=CleanHubLetter.Position,CleanHubIndex=CleanHubIndex}
task.delay((CleanHubIndex-1).07,function()
if CleanHubLetter.Parent then
CleanHubTweenService:Create(CleanHubLetter,TweenInfo.new(.42,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{ImageTransparency=0}):Play()
end
end)
end
​local function CleanHubFinish()
if CleanHubFinished then return end
CleanHubFinished=true
if CleanHubFloatConnection then CleanHubFloatConnection:Disconnect() end
if CleanHubSoundEndedConnection then CleanHubSoundEndedConnection:Disconnect(); CleanHubSoundEndedConnection=nil end
if CleanHubIntroSound then pcall(function() CleanHubIntroSound:Stop(); CleanHubIntroSound:Destroy() end) end
for _,CleanHubEntry in ipairs(CleanHubLetters) do
if CleanHubEntry.image.Parent then CleanHubTweenService:Create(CleanHubEntry.image,TweenInfo.new(.3),{ImageTransparency=1}):Play() end
end
task.delay(.34,function() if CleanHubGui then CleanHubGui:Destroy() end end)
end
​CleanHubFloatConnection=CleanHubRunService.RenderStepped:Connect(function()
local CleanHubTime=os.clock()-CleanHubStarted
for _,CleanHubEntry in ipairs(CleanHubLetters) do
local CleanHubLetter=CleanHubEntry.image
if CleanHubLetter.Parent then
local CleanHubPhase=CleanHubTime*.9+CleanHubEntry.CleanHubIndex*1.37
CleanHubLetter.Position=CleanHubEntry.base+UDim2.fromOffset(math.sin(CleanHubPhase)18,math.cos(CleanHubPhase1.23)22)
CleanHubLetter.Rotation=math.sin(CleanHubPhase.72)*7
end
end
end)
​task.spawn(function()
local function CleanHubCustomAsset(CleanHubFile)
for _,CleanHubAssetFunction in ipairs({getcustomasset,getsynasset,getasset}) do
if typeof(CleanHubAssetFunction)"function" then
local CleanHubOk,CleanHubAsset=pcall(function() return CleanHubAssetFunction(CleanHubFile) end)
if CleanHubOk and type(CleanHubAsset)"string" and CleanHubAsset~="" then return CleanHubAsset end
end
end
return nil
end
local CleanHubAsset=CleanHubCustomAsset(CleanHubSongFile)
if not CleanHubAsset and isfile and isfile(CleanHubSongFile) then CleanHubAsset=CleanHubCustomAsset(CleanHubSongFile) end
if not CleanHubAsset and writefile then
local CleanHubOk,CleanHubData=pcall(function() return game:HttpGet(CleanHubSongUrl) end)
if CleanHubOk and type(CleanHubData)=="string" and #CleanHubData>100 and pcall(function() writefile(CleanHubSongFile,CleanHubData) end) then
CleanHubAsset=CleanHubCustomAsset(CleanHubSongFile)
end
end
if CleanHubFinished or not CleanHubAsset then return end
CleanHubIntroSound=Instance.new("Sound")
CleanHubIntroSound.Name="CleanIntroSong"; CleanHubIntroSound.SoundId=CleanHubAsset; CleanHubIntroSound.Volume=1; CleanHubIntroSound.Looped=false
CleanHubIntroSound.Parent=game:GetService("SoundService")
CleanHubSoundEndedConnection=CleanHubIntroSound.Ended:Connect(CleanHubFinish)
pcall(function() CleanHubIntroSound:Play() end)
end)
​local CleanHubSkip=Instance.new("TextButton",CleanHubGui)
CleanHubSkip.Size=UDim2.fromScale(1,1)
CleanHubSkip.BackgroundTransparency=1
CleanHubSkip.Text=""
CleanHubSkip.BorderSizePixel=0
CleanHubSkip.AutoButtonColor=false
CleanHubSkip.ZIndex=10
CleanHubSkip.Activated:Connect(CleanHubFinish)
​task.delay(10, CleanHubFinish)
​while not CleanHubFinished do
task.wait(0.05)
end
​task.wait(0.4)
​-- ============================================================
-- FIN INTRO
-- ============================================================
​local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
​local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new
​-- Light Blue Color Theme for Right Side Buttons / Accent UI
local LIGHT_BLUE_COLOR = Color3.fromRGB(135, 206, 250)
local LIGHT_BLUE_ACCENT = Color3.fromRGB(173, 216, 230)
​local _GetPlayersCached
do
local cache, cacheTime = nil, 0
_GetPlayersCached = function()
local now = _tick()
if cache and now - cacheTime < 0.03 then return cache end
cache = Players:GetPlayers()
cacheTime = now
return cache
end
end
​local function waitForCharReady(char, timeout)
timeout = timeout or 5
local deadline = _tick() + timeout
while (not char) or (not char.Parent)
or (not char:FindFirstChild("HumanoidRootPart"))
or (not char:FindFirstChildOfClass("Humanoid")) do
if _tick() > deadline then return false end
task.wait(0.05)
end
return true
end
​NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "Parch3Duels.json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false
​backgroundIndex = 1
backgroundImageTransparency = 0.35
floatingButtonScale = 1
progressBarScale = 1
_floatingUIScales = {}
​local CarrySystem = {
normalSpeed = NS,
carrySpeed = CS,
laggerSpeed = LAGGER_SPEED,
laggerCarrySpeed = LAGGER_CARRY_SPEED,
speedToggled = false,
laggerMode = 0,
softStealEnabled = false,
softStealRadius = 10,
softStealSpeed = 30,
softStealLatched = false,
_isCarrying = false,
_lastCarryCheck = 0,
_lvBoost = nil,
_lvAtt = nil,
_blockedTime = 0,
_maxForce = 2200,
_freeForce = 500,
_heartbeatConn = nil,
_softStealScanner = nil,
_softStealAnimals = {},
_softStealScanning = false,
_state = nil,
_dropInProgress = false,
_batAimbotToggled = false,
_rayParams = nil,
_rayFilter = nil,
_rayFilterTime = 0,
}
​function CarrySystem:isCarrying()
local now = _tick()
if now - (self._lastCarryCheck or 0) < 0.1 then
return self._isCarrying
end
self._lastCarryCheck = now
local char = LP.Character
if not char then self._isCarrying = false; return false end
local hum = char:FindFirstChildOfClass("Humanoid")
local ws = hum and hum.WalkSpeed or 16
local bySpeed = (ws < 25 and ws > 0)
local byAttr = false
local ok, v = pcall(function() return LP:GetAttribute("Stealing") end)
if ok and v == true then byAttr = true end
local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
if ok2 and v2 == true then byAttr = true end
if not byAttr then
for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
local obj = char:FindFirstChild(name)
if obj then
if (obj:IsA("BoolValue") and obj.Value) or
(obj:IsA("ObjectValue") and obj.Value) or
(obj:IsA("StringValue") and obj.Value ~= "") then
byAttr = true; break
end
end
end
end
self._isCarrying = bySpeed or byAttr
return self._isCarrying
end
​function CarrySystem:getActiveSpeed()
if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
return self.normalSpeed
end
if self.softStealEnabled then
local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
local inRange = dist and dist <= self.softStealRadius
if inRange then
self.softStealLatched = true
return self.softStealSpeed
end
if self.softStealLatched and self:isCarrying() then
return self.softStealSpeed
else
self.softStealLatched = false
end
end
if self.laggerMode == 1 then return self.laggerSpeed end
if self.laggerMode == 2 then return self.laggerCarrySpeed end
if self.speedToggled then return self.carrySpeed end
return self.normalSpeed
end
​function CarrySystem:getStatus()
if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
return "NORMAL", self.normalSpeed
end
if self.softStealEnabled then
local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
local inRange = dist and dist <= self.softStealRadius
if inRange or (self.softStealLatched and self:isCarrying()) then
return "AUTO CARRY", self.softStealSpeed
end
end
if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
if self.speedToggled then return "CARRY", self.carrySpeed end
return "NORMAL", self.normalSpeed
end
​local function destroyLV()
if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent then pcall(function() CarrySystem._lvBoost:Destroy() end) end
if CarrySystem._lvAtt and CarrySystem._lvAtt.Parent then pcall(function() CarrySystem._lvAtt:Destroy() end) end
CarrySystem._lvBoost = nil; CarrySystem._lvAtt = nil
end
​local function setupLV(hrp)
if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent == hrp then return end
destroyLV()
local att = Instance.new("Attachment"); att.Parent = hrp
local lv = Instance.new("LinearVelocity")
lv.Name = "CarryBoostLV"
lv.Attachment0 = att
lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
lv.PrimaryTangentAxis = _V3new(1,0,0)
lv.SecondaryTangentAxis = _V3new(0,0,1)
lv.MaxForce = CarrySystem._maxForce
lv.PlaneVelocity = Vector2.zero
lv.RelativeTo = Enum.ActuatorRelativeTo.World
lv.Parent = hrp
CarrySystem._lvAtt = att
CarrySystem._lvBoost = lv
pcall(function() hrp:SetNetworkOwner(LP) end)
end
​function CarrySystem:scanSoftStealAnimals()
self._softStealAnimals = {}
local plots = Workspace:FindFirstChild("Plots")
if not plots then return end
for _, plot in ipairs(plots:GetChildren()) do
if plot:IsA("Model") then
local podiums = plot:FindFirstChild("AnimalPodiums")
if podiums then
for _, podium in ipairs(podiums:GetChildren()) do
if podium:IsA("Model") then
local base = podium:FindFirstChild("Base")
local spawn = base and base:FindFirstChild("Spawn")
if spawn then
table.insert(self.softStealAnimals, {
plot = plot.Name,
slot = podium.Name,
worldPosition = spawn.Position,
uid = plot.Name .. "" .. podium.Name,
})
end
end
end
end
end
end
end
​function CarrySystem:startSoftStealScanner()
if self._softStealScanner then return end
self._softStealScanning = true
self:scanSoftStealAnimals()
self._softStealScanner = RunService.Heartbeat:Connect(function()
if not self._softStealScanning then return end
self:scanSoftStealAnimals()
end)
end
​function CarrySystem:stopSoftStealScanner()
self._softStealScanning = false
if self._softStealScanner then
self._softStealScanner:Disconnect()
self._softStealScanner = nil
end
end
​function CarrySystem:getNearestSoftStealAnimal(radius)
local char = LP.Character
local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
if not root then return nil, _huge end
local best, bestDist = nil, _huge
local animals = self._softStealAnimals
local rpos = root.Position
for i = 1, #animals do
local data = animals[i]
if data.worldPosition then
local dx = rpos.X - data.worldPosition.X
local dy = rpos.Y - data.worldPosition.Y
local dz = rpos.Z - data.worldPosition.Z
local dist = _sqrt(dxdx + dydy + dz*dz)
if dist < bestDist then
best = data; bestDist = dist
end
end
end
if radius and bestDist > radius then return nil, bestDist end
return best, bestDist
end
​function CarrySystem:updateMovement(dt)
local char = LP.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
​local speed = self:getActiveSpeed()
local moveDir = hum.MoveDirection
local moving = moveDir.Magnitude > 0.1
​local wallNormalFlat = nil
if moving then
if not self._rayParams then
self._rayParams = _RayParams_new()
self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
self._rayFilter = {}
self._rayFilterTime = 0
end
local now = _tick()
if now - self._rayFilterTime > 1 then
self._rayFilterTime = now
local filter = self._rayFilter
while #filter > 0 do filter[#filter] = nil end
filter[1] = char
local plist = _GetPlayersCached()
for i = 1, #plist do
local p = plist[i]
if p.Character then
filter[#filter + 1] = p.Character
end
end
self._rayParams.FilterDescendantsInstances = filter
else
local filter = self._rayFilter
local found = false
for i = 1, #filter do
if filter[i] == char then found = true; break end
end
if not found then
filter[1] = char
self._rayParams.FilterDescendantsInstances = filter
end
end
local flatDir = _V3new(moveDir.X, 0, moveDir.Z).Unit
local hit = Workspace:Raycast(hrp.Position + _V3new(0,1,0), flatDir * 2.5, self._rayParams)
if hit and hit.Instance and hit.Instance.CanCollide then
local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
if nf.Magnitude > 0.7 then wallNormalFlat = nf.Unit end
end
end
​local hVel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
local blocked = wallNormalFlat ~= nil or (moving and hVel.Magnitude < 2)
​if blocked then
for _, model in ipairs(char:GetChildren()) do
if model:IsA("Model") then
for _, part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
end
end
end
for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
local v = char:FindFirstChild(name)
if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
for _, part in ipairs(v.Value:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
end
end
end
end
​local state = hum:GetState()
local ragdolled = state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
local moverBlocked = ragdolled or self._dropInProgress or self._batAimbotToggled
​if not moverBlocked then
if not CarrySystem._lvBoost or CarrySystem._lvBoost.Parent ~= hrp then setupLV(hrp) end
local lv = CarrySystem._lvBoost
if lv then
if not lv.Enabled then lv.Enabled = true end
if moveDir.Magnitude > 0.1 then
local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
if wallNormalFlat then
local wanted = flat * speed
local along = wanted - wallNormalFlat * wanted:Dot(wallNormalFlat)
if along.Magnitude < 0.5 then
lv.PlaneVelocity = Vector2.zero
else
lv.PlaneVelocity = Vector2.new(along.X, along.Z)
end
else
lv.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
end
else
lv.PlaneVelocity = Vector2.zero
end
if blocked then
self._blockedTime = self._blockedTime + (dt or 0.016)
else
self._blockedTime = 0
end
if self._blockedTime > 0.35 then
if lv.MaxForce ~= self._freeForce then lv.MaxForce = self._freeForce end
elseif lv.MaxForce ~= self._maxForce then
lv.MaxForce = self._maxForce
end
end
elseif CarrySystem._lvBoost then
CarrySystem._lvBoost.PlaneVelocity = Vector2.zero
if CarrySystem._lvBoost.Enabled then CarrySystem._lvBoost.Enabled = false end
end
end
​function CarrySystem:start()
if self._heartbeatConn then return end
self._heartbeatConn = RunService.Heartbeat:Connect(function(dt) self:updateMovement(dt) end)
if self.softStealEnabled then self:startSoftStealScanner() end
print("[CarrySystem] Parch3 Duels Activado")
end
​function CarrySystem:stop()
if self._heartbeatConn then
self._heartbeatConn:Disconnect()
self._heartbeatConn = nil
end
self:stopSoftStealScanner()
destroyLV()
self.softStealLatched = false
print("[CarrySystem] Parch3 Duels Desactivado")
end
​function CarrySystem:setNormalSpeed(v) self.normalSpeed = _clamp(v,1,500) end
function CarrySystem:setCarrySpeed(v) self.carrySpeed = _clamp(v,1,500) end
function CarrySystem:setLaggerSpeed(v) self.laggerSpeed = _clamp(v,0.1,500) end
function CarrySystem:setLaggerCarrySpeed(v) self.laggerCarrySpeed = _clamp(v,0.1,500) end
function CarrySystem:setSoftStealSpeed(v) self.softStealSpeed = _clamp(v,1,500) end
function CarrySystem:setSoftStealRadius(v) self.softStealRadius = _clamp(v,1,200) end
​function CarrySystem:toggleCarryMode() self.speedToggled = not self.speedToggled end
function CarrySystem:setLaggerMode(mode)
if mode == 0 then self.laggerMode = 0
elseif mode == 1 then self.laggerMode = 1
elseif mode == 2 then self.laggerMode = 2 end
end
function CarrySystem:toggleLaggerMode()
if self.laggerMode == 0 then self.laggerMode = 1
elseif self.laggerMode == 1 then self.laggerMode = 2
else self.laggerMode = 0 end
end
function CarrySystem:setSoftStealEnabled(enabled)
self.softStealEnabled = enabled
if enabled then self:startSoftStealScanner()
else self:stopSoftStealScanner(); self.softStealLatched = false end
end
function CarrySystem:toggleSoftSteal() self:setSoftStealEnabled(not self.softStealEnabled) end
function CarrySystem:isRunning() return self._heartbeatConn ~= nil end
function CarrySystem:getCurrentSpeed() return self:getActiveSpeed() end
​local COLOR_THEMES = {
["Azul Claro"] = LIGHT_BLUE_COLOR,
["Gris"] = Color3.fromRGB(30, 30, 35),
}
​currentColorTheme = "Azul Claro"
selectedColor = COLOR_THEMES["Azul Claro"]
​function getThemeColor() return selectedColor end
​local _lastThemeUpdate = 0
local _lastThemeColor = nil
​function paintFloatingBtn(btn, active)
if not btn then return end
btn.BackgroundColor3 = LIGHT_BLUE_COLOR
local grad = btn:FindFirstChildOfClass("UIGradient")
if grad then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, LIGHT_BLUE_ACCENT),
ColorSequenceKeypoint.new(0.50, LIGHT_BLUE_COLOR),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(100, 180, 240)),
})
end
end
​function applyColorTheme(themeName)
local color = COLOR_THEMES[themeName] or LIGHT_BLUE_COLOR
currentColorTheme = themeName
selectedColor = color
updateAllUIThemeColors(color)
saveAllSettings()
end
​function updateAllUIThemeColors(color)
local now = _tick()
if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
_lastThemeUpdate = now
_lastThemeColor = color
​if progressFill then
progressFill.BackgroundColor3 = LIGHT_BLUE_ACCENT
local fs = progressFill:FindFirstChild("FillStroke")
if fs then fs.Color = LIGHT_BLUE_ACCENT end
local grad = progressFill:FindFirstChildOfClass("UIGradient")
if grad then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, LIGHT_BLUE_COLOR),
ColorSequenceKeypoint.new(0.50, LIGHT_BLUE_ACCENT),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 235, 255)),
})
end
end
if pbFrame then
local pr = pbFrame:FindFirstChild("ProgressRow")
if pr then
local fr = pr:FindFirstChild("FillRegion")
if fr then
local s = fr:FindFirstChild("FillRegionStroke")
if s then s.Color = LIGHT_BLUE_ACCENT end
end
end
local discordLabel = pbFrame:FindFirstChild("DiscordLabel")
if discordLabel then discordLabel.TextColor3 = LIGHT_BLUE_ACCENT end
local fpsNeon = pbFrame:FindFirstChild("FPSNeon")
if fpsNeon then fpsNeon.TextColor3 = LIGHT_BLUE_ACCENT end
end
local function searchAndUpdateText(parent)
for _, child in ipairs(parent:GetDescendants()) do
if child:IsA("TextLabel") then
if child.Text:find("Parch3 Duels") or child.Text:find("Spd:") or child.Name == "DiscordText" or
child.Name == "Parch3DuelsSpeedIndicator" or child.Text:find("FPS") or child.Text:find("speed") then
child.TextColor3 = LIGHT_BLUE_ACCENT
end
end
if child:IsA("UIStroke") then
child.Color = LIGHT_BLUE_COLOR
end
end
end
if gui then searchAndUpdateText(gui) end
if tpBatFloatingButton then
paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
end
if batV2FloatingButton then
paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), autoBatV2Enabled)
end
for _, tab in ipairs(tabButtons or {}) do
tab.TextColor3 = LIGHT_BLUE_COLOR
end
for _, hl in pairs(espHighlightCache) do
if hl then hl.FillColor = LIGHT_BLUE_COLOR; hl.OutlineColor = LIGHT_BLUE_COLOR end
end
for _, lines in pairs(espTracerCache) do
if lines then
for _, ln in ipairs(lines) do
if ln then ln.Color = LIGHT_BLUE_COLOR end
end
end
end
for _, bb in pairs(espBillboardCache) do
if bb then
local img = bb:FindFirstChildOfClass("ImageLabel")
if img then
local stroke = img:FindFirstChildOfClass("UIStroke")
if stroke then stroke.Color = LIGHT_BLUE_COLOR end
end
end
end
if main then
local titleFrame = main:FindFirstChild("TitleFrame")
if titleFrame then
for _, child in ipairs(titleFrame:GetDescendants()) do
if child:IsA("UIStroke") then
child.Color = LIGHT_BLUE_COLOR
end
end
end
end
if miniBtn then
miniBtn.TextColor3 = LIGHT_BLUE_ACCENT
miniBtn.BackgroundColor3 = LIGHT_BLUE_COLOR
end
​local pGui = LP:FindFirstChild("PlayerGui")
if pGui then
local bb = pGui:FindFirstChild("RagCountdownBillboard")
if bb then
local lbl = bb:FindFirstChildOfClass("TextLabel")
if lbl then
lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
local grad = lbl:FindFirstChildOfClass("UIGradient")
if grad then
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, LIGHT_BLUE_ACCENT),
ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
ColorSequenceKeypoint.new(1, LIGHT_BLUE_ACCENT),
})
end
end
end
end
​-- Paint Right Panel / Mobile Panel buttons Light Blue
if MobilePanel then
local container = MobilePanel:FindFirstChild("FloatingPanel")
if container then
local btnContainer = container:FindFirstChild("ButtonsContainer")
if btnContainer then
for _, btn in ipairs(btnContainer:GetChildren()) do
if btn:IsA("TextButton") then
btn.BackgroundColor3 = LIGHT_BLUE_COLOR
paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
end
end
end
end
end
end
​-- ═══════════════════════════════════════════════════════════════
-- OUTFITS
-- ═══════════════════════════════════════════════════════════════
local ECLIPSE_SKIN_PRESETS = {
V1 = { shirt = 74707712629633, pants = 12405320750, hair = 140188532534398 },
V2 = { shirt = 101796619834594, pants = 18975891159, hair = 115520061093937 },
V3 = { shirt = 18552805597,   pants = 5414143509,  hair = 84008082880128  },
}
​local function eclipseAssetUrl(id)
return "http://www.roblox.com/asset/?id=" .. tostring(id)
end
​local TAG = "LocalOutfit_"
​local function loadObjects(id)
local ok, res = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(id))
end)
if ok and typeof(res) == "table" and #res > 0 then return res end
ok, res = pcall(function()
return game:GetService("InsertService"):LoadAsset(id)
end)
if ok and res then return { res } end
return nil
end
​local function collectParts(objs)
local out = {}
for _, o in ipairs(objs) do
if o:IsA("BasePart") then out[#out + 1] = o end
for _, d in ipairs(o:GetDescendants()) do
if d:IsA("BasePart") then out[#out + 1] = d end
end
end
return out
end
​local function findAtt(char, name)
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
return p
end
end
end
​local function applyNoOutfit(char)
if not char then char = LP.Character end
if not char then return end
for _, d in ipairs(char:GetChildren()) do
if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
end
local oldAcc = char:FindFirstChild("AuFfitAccessory")
if oldAcc then pcall(function() oldAcc:Destroy() end) end
local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
for _, d in ipairs(char:GetChildren()) do
if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
pcall(function() d:Destroy() end)
end
end
local head = char:FindFirstChild("Head")
if head then
head.Transparency = 0
head.CanCollide = true
head.LocalTransparencyModifier = 0
local face = head:FindFirstChild("face")
if face then face.Transparency = 0 end
local sm = head:FindFirstChildWhichIsA("SpecialMesh")
if sm then pcall(function() sm:Destroy() end) end
end
pcall(function()
local neck = char:FindFirstChild("Neck")
if neck then neck.Enabled = true end
end)
for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
local limb = char:FindFirstChild(partName)
if limb then limb.Transparency = 0 end
end
local shirt = char:FindFirstChildWhichIsA("Shirt")
if shirt then pcall(function() shirt:Destroy() end) end
local pants = char:FindFirstChildWhichIsA("Pants")
if pants then pcall(function() pants:Destroy() end) end
for _, a in ipairs(char:GetChildren()) do
if a:IsA("Accessory") then
local h = a:FindFirstChild("Handle")
if h then h.Transparency = 0 end
end
end
end
​local OUTFITS = {
{
accessory = 10159600649,
offset = _V3new(0, 1, -0.2),
shirt = "http://www.roblox.com/asset/?id=9683332638",
pants = "http://www.roblox.com/asset/?id=93182020184041",
headMesh = "http://www.roblox.com/asset/?id=134079402",
headTexture = "http://www.roblox.com/asset/?id=133940918 ",
korblox = "none",
label = "Outfit 1",
headlessKorblox = true,
},
{
accessory = 1744060292,
offset = _V3new(0, 1.3, -0.2),
shirt = "http://www.roblox.com/asset/?id=9683332638",
pants = "http://www.roblox.com/asset/?id=93182020184041",
headMesh = "http://www.roblox.com/asset/?id=134079402",
headTexture = "http://www.roblox.com/asset/?id=133940918 ",
korblox = "none",
label = "Outfit 2",
headlessKorblox = true,
},
{
accessory = 121097973925756,
offset = _V3new(0, 0.9, 0),
shirt = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V1.shirt),
pants = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V1.pants),
headMesh = "http://www.roblox.com/asset/?id=134079402",
headTexture = "http://www.roblox.com/asset/?id=133940918",
korblox = "none",
label = "Eclipse V1",
headlessKorblox = true,
},
{
accessory = 10159600649,
offset = _V3new(0, 1, -0.2),
shirt = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V2.shirt),
pants = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V2.pants),
headMesh = "http://www.roblox.com/asset/?id=134079402",
headTexture = "http://www.roblox.com/asset/?id=133940918",
korblox = "none",
label = "Eclipse V2",
headlessKorblox = true,
},
{
accessory = 1744060292,
offset = _V3new(0, 1.3, -0.2),
shirt = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V3.shirt),
pants = eclipseAssetUrl(ECLIPSE_SKIN_PRESETS.V3.pants),
headMesh = "http://www.roblox.com/asset/?id=134079402",
headTexture = "http://www.roblox.com/asset/?id=133940918",
korblox = "none",
label = "Eclipse V3",
headlessKorblox = true,
},
{
label = "NO",
customApply = applyNoOutfit,
},
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil
​BACKGROUND_IMAGES = {
{ label = "Off",  id = nil },
{ label = "BG 1",  id = "rbxassetid://77785523954153" },
{ label = "BG 2",  id = "rbxassetid://122815453745063" },
{ label = "BG 3",  id = "rbxassetid://77581705786454" },
{ label = "BG 4",  id = "rbxassetid://86508089972764" },
{ label = "BG 5",  id = "rbxassetid://99747773532595" },
{ label = "BG 6",  id = "rbxassetid://139362780018712" },
{ label = "BG 7",  id = "rbxassetid://81570223894096" },
{ label = "BG 8",  id = "rbxassetid://94047991986188" },
{ label = "BG 9",  id = "rbxassetid://118783198922289" },
{ label = "BG 10", id = "rbxassetid://101833990704596" },
{ label = "BG 11", id = "rbxassetid://109527418380162" },
}
backgroundSelectorLabel = nil
backgroundImage = nil
backgroundImagePB = nil
​function applyBackground(index)
backgroundIndex = _clamp(index or 1, 1, #BACKGROUND_IMAGES)
local cfg = BACKGROUND_IMAGES[backgroundIndex]
if not cfg then return end
local targetImg = cfg.id or ""
local targetTrans = cfg.id and backgroundImageTransparency or 1
if backgroundImage and backgroundImage.Parent then
backgroundImage.Image = targetImg
backgroundImage.ImageTransparency = targetTrans
end
if backgroundImagePB and backgroundImagePB.Parent then
backgroundImagePB.Image = targetImg
backgroundImagePB.ImageTransparency = targetImg ~= "" and math.min(targetTrans + 0.15, 1) or 1
end
if backgroundSelectorLabel then
backgroundSelectorLabel.Text = cfg.label
end
end
​local function loadObjectsStd(id)
local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
if ok and typeof(res) == "table" and #res > 0 then return res end
ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
if ok and res then return {res} end
return nil
end
​local function applyHeadlessKorblox(char)
if not char then return end
pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
local head = char:FindFirstChild("Head")
if head then
head.Transparency = 1
head.CanCollide = false
head.LocalTransparencyModifier = 1
local face = head:FindFirstChild("face")
if face then face.Transparency = 1 end
end
pcall(function()
local neck = char:FindFirstChild("Neck")
if neck then neck.Enabled = false end
end)
for _, v in pairs(char:GetChildren()) do
if v:IsA("Accessory") then
local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
if w then
local p0, p1 = w.Part0, w.Part1
if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
v.Parent = nil
end
end
end
end
local rightLegConfig = {
id = "rbxassetid://139607718",
targetBodyPart = "RightUpperLeg",
partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
scale = _V3new(1, 1, 1),
offset = _CFnew(0, 0, 0)
}
local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
if targetPart then
local oldAsset = char:FindFirstChild("Korblox_RightLeg")
if oldAsset then oldAsset:Destroy() end
for _, partName in ipairs(rightLegConfig.partsToHide) do
local limb = char:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
end
local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
if success and objects and #objects > 0 then
local assetModel = objects[1]
assetModel.Name = "Korblox_RightLeg"
local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
if mainMesh then
mainMesh.Size = mainMesh.Size * rightLegConfig.scale
mainMesh.CanCollide = false
mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
local weld = Instance.new("WeldConstraint")
weld.Part0 = targetPart
weld.Part1 = mainMesh
weld.Parent = mainMesh
assetModel.Parent = char
end
end
end
end
​function applyOutfitByIndex(index)
local cfg = OUTFITS[index]
if not cfg then return end
local char = LP.Character
if not char then return end
if cfg.customApply then
cfg.customApply(char)
if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
return
end
char:WaitForChild("Head", 5)
local head = char:FindFirstChild("Head")
if not head then return end
for _, d in ipairs(char:GetChildren()) do
if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
pcall(function() d:Destroy() end)
end
end
local done = false
if head:IsA("MeshPart") then
done = pcall(function()
head.MeshId = cfg.headMesh
if cfg.headTexture then head.TextureID = cfg.headTexture end
end)
end
if not done then
local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
sm.Parent = head
sm.MeshType = Enum.MeshType.FileMesh
sm.MeshId = cfg.headMesh
sm.TextureId = cfg.headTexture or ""
end
if cfg.shirt then
local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
s.Name = "Shirt"
s.ShirtTemplate = cfg.shirt
s.Parent = char
end
if cfg.pants then
local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
p.Name = "Pants"
p.PantsTemplate = cfg.pants
p.Parent = char
end
local old = char:FindFirstChild("AuFfitAccessory")
if old then old:Destroy() end
if cfg.accessory and head then
local objs = loadObjectsStd(cfg.accessory)
if objs then
local handle
for _, o in ipairs(objs) do
if o:IsA("BasePart") then handle = o; break end
local f = o:FindFirstChildWhichIsA("BasePart", true)
if f then handle = f; break end
end
if handle then
local h = handle:Clone()
h.Name = "AuFfitAccessory"
h.CanCollide = false
h.Anchored = false
h.Massless = true
h.Parent = char
local weld = Instance.new("Weld")
weld.Part0 = head
weld.Part1 = h
weld.C0 = _CFnew(cfg.offset)
weld.Parent = h
end
for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
end
end
if cfg.headlessKorblox then
applyHeadlessKorblox(char)
else
if char then
local head2 = char:FindFirstChild("Head")
if head2 then
head2.Transparency = 0
head2.CanCollide = true
head2.LocalTransparencyModifier = 0
local face2 = head2:FindFirstChild("face")
if face2 then face2.Transparency = 0 end
end
pcall(function()
local neck = char:FindFirstChild("Neck")
if neck then neck.Enabled = true end
end)
for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
local limb = char:FindFirstChild(partName)
if limb then limb.Transparency = 0 end
end
local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
if oldKorblox then oldKorblox:Destroy() end
end
end
if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end
​speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = true
editModeEnabled = false
uiScaleValue = 78
espEnabled = false
​antiKickEnabled = false
setSafeModeVisual = nil
​mirrorTPDownEnabled = false
mirrorTPDownSetVisual = nil
​infJumpEnabled = false
infJumpMode    = "HOLD"
​bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
​savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batV2FloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil
​neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil
​currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil
​-- ═══════════════════════════════════════════════════════════════
-- BAT BYPASS (Parch3 Duels)
-- ═══════════════════════════════════════════════════════════════
autoBatV2Enabled      = false
autoBatV2SetVisual    = nil
​selectedAimbotMode    = "Normal"
autoSwingEnabled      = false
​_G.AceAntiBypassAimbotSpeed       = _G.AceAntiBypassAimbotSpeed or 60
_G.AceAntiBypassLaggerAimbotSpeed = _G.AceAntiBypassLaggerAimbotSpeed or 40
_G.AceAntiBypassAimbotOn          = _G.AceAntiBypassAimbotOn or false
_G.AceNormalAimbotOn              = _G.AceNormalAimbotOn or false
_G.AceCurrentSpeedMode            = _G.AceCurrentSpeedMode or "Normal"
​_G.AceAntiBypassAimbot = _G.AceAntiBypassAimbot or {
conn           = nil,
swingCooldown  = false,
prevAutoRotate = nil,
}
​_G.AceAntiBypassSlapList = _G.AceAntiBypassSlapList or {
"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
"Emerald Slap", "Ruby Slap", "Dark Matter Slap",
"Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}
​_G.AceSafeModeTryStart      = _G.AceSafeModeTryStart      or _G.AmbitiousSafeModeTryStart
_G.AceStopAutoTPForAction   = _G.AceStopAutoTPForAction   or function()
if batDesyncTpEnabled and type(stopBatDesyncTp) == "function" then
stopBatDesyncTp()
end
end
_G.AceStopNormalAimbot      = _G.AceStopNormalAimbot      or function()
if autoBatEnabled and type(disableAutoBat) == "function" then
disableAutoBat()
end
end
​useCarrySystem = false
lastMoveDir = _V3zero
​-- TP Bat legacy vars (compat)
tpBatVersion = 1
tpBatVersionLabel = nil
tpBatVersionPill = nil
tpBatDistanceBox = nil
_G.__tpBatV2Distance = 8
​local CoreGui = game:GetService("CoreGui")
​katanaSkinEnabled = false
​local KatanaSkin = (function()
local Players       = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local Lighting2     = game:GetService("Lighting")
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local LocalPlayer   = Players.LocalPlayer
​local KC = {
red  = Color3.new(0.784314, 0, 0),
red2 = Color3.new(1, 0.392157, 0.392157),
gold = Color3.new(1, 0.72549, 0.196078),
}
​local State = {
Skin = "KATANA",
SkinOrder = { "KATANA", "NONE" },
LastBat = nil,
LastAppliedSkin = nil,
OriginalKatanaTemplate = nil,
ExactTemplates = {},
ExactTemplateSearched = {},
ExactAssetIds = { KATANA = "" },
Original = {},
}
​local function findBatForKatanaSkin()
local char = LocalPlayer.Character
if char then
local t = char:FindFirstChild("Bat")
if t and t:IsA("Tool") then return t end
end
local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
if bp then
local t = bp:FindFirstChild("Bat")
if t and t:IsA("Tool") then return t end
end
return nil
end
​local function setPartSafe(part)
if not part or not part:IsA("BasePart") then return end
part.Anchored    = false
part.CanCollide  = false
part.CanTouch    = false
part.CanQuery    = false
part.Massless    = true
end
​local function weldToHandle(part, handle)
if not part or not handle or not part:IsA("BasePart") or not handle:IsA("BasePart") then return end
setPartSafe(part)
local w = Instance.new("WeldConstraint")
w.Name   = "FlowerSkin_AssetWeld"
w.Part0  = handle
w.Part1  = part
w.Parent = part
end
​local function rememberOriginal(tool)
if not tool then return end
local handle = tool:FindFirstChild("Handle")
local slash  = tool:FindFirstChild("Slash")
State.Original[tool] = State.Original[tool] or {}
local o = State.Original[tool]
if handle and handle:IsA("BasePart") and not o.Handle then
o.Handle = {
Transparency = handle.Transparency,
LocalTransparencyModifier = handle.LocalTransparencyModifier,
CastShadow = handle.CastShadow,
}
end
if slash and slash:IsA("Sound") and not o.SlashSoundId then
o.SlashSoundId = slash.SoundId
end
end
​local function captureKatanaTemplate()
if State.OriginalKatanaTemplate then return end
local function scan(container)
if not container then return end
local bat = container:FindFirstChild("Bat")
if not bat then return end
local folder = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
local asset  = folder and folder:FindFirstChild("FlowerSkin_AssetKatana")
if asset then State.OriginalKatanaTemplate = asset:Clone() end
end
scan(LocalPlayer:FindFirstChildOfClass("Backpack"))
scan(LocalPlayer.Character)
end
​local function hideOriginalHandle(tool, hidden)
local handle = tool and tool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return end
rememberOriginal(tool)
if hidden then
handle.LocalTransparencyModifier = 1
handle.Transparency = 1
handle.CastShadow = false
else
local o = State.Original[tool] and State.Original[tool].Handle
handle.LocalTransparencyModifier = o and o.LocalTransparencyModifier or 0
handle.Transparency = o and o.Transparency or 0
handle.CastShadow = o and o.CastShadow
if handle.CastShadow == nil then handle.CastShadow = true end
end
end
​local function setSlashSound(tool, soundId)
rememberOriginal(tool)
local slash = tool and tool:FindFirstChild("Slash")
if slash and slash:IsA("Sound") then
slash.SoundId = soundId or ((State.Original[tool] and State.Original[tool].SlashSoundId) or slash.SoundId)
end
end
​local function removeSkin(tool)
if not tool then return end
local oldFolder = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
if oldFolder then oldFolder:Destroy() end
local oldLoose = tool:FindFirstChild("FlowerSkin_AssetKatana")
if oldLoose then oldLoose:Destroy() end
hideOriginalHandle(tool, false)
setSlashSound(tool, nil)
end
​local function addRedVFX(parentPart)
if not parentPart or not parentPart:IsA("BasePart") then return end
local existing = parentPart:FindFirstChild("FlowerSkin_ExtraRedVFX")
if existing then existing:Destroy() end
​local top = Instance.new("Attachment")
top.Name = "FlowerSkin_ExtraRedVFX"
top.Position = Vector3.new(0, parentPart.Size.Y * 0.5, 0)
top.Parent = parentPart
​local bottom = Instance.new("Attachment")
bottom.Name = "FlowerSkin_ExtraRedVFX_End"
bottom.Position = Vector3.new(0, -parentPart.Size.Y * 0.5, 0)
bottom.Parent = parentPart
​local trail = Instance.new("Trail")
trail.Name = "FlowerSkin_ExtraRedVFX"
trail.Attachment0 = top
trail.Attachment1 = bottom
trail.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, KC.red2),
ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
})
trail.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.35),
NumberSequenceKeypoint.new(1, 1),
})
trail.Lifetime = 0.18
trail.LightEmission = 0.55
trail.Parent = parentPart
​local emitter = Instance.new("ParticleEmitter")
emitter.Name = "FlowerSkin_ExtraRedVFX"
emitter.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
ColorSequenceKeypoint.new(1, KC.red2),
})
emitter.LightEmission = 0.55
emitter.Rate = 14
emitter.Lifetime = NumberRange.new(0.25, 0.45)
emitter.Speed = NumberRange.new(0.2, 0.7)
emitter.SpreadAngle = Vector2.new(12, 12)
emitter.Size = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(1, 0),
})
emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
emitter.Parent = parentPart
end
​local function newPart(parent, name, size, offset, color, material)
local p = Instance.new("Part")
p.Name = name
p.Size = size
p.Color = color
p.Material = material or Enum.Material.Neon
p.TopSurface = Enum.SurfaceType.Smooth
p.BottomSurface = Enum.SurfaceType.Smooth
setPartSafe(p)
p.Parent = parent
return p, offset or CFrame.identity
end
​local EXACT_TEMPLATE_NAMES = {
KATANA = { "FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic" },
}
​local function isScriptObject(inst)
return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
end
​local function stripScripts(root)
if not root then return end
if isScriptObject(root) then root:Destroy(); return end
for _, inst in ipairs(root:GetDescendants()) do
if isScriptObject(inst) then inst:Destroy() end
end
end
​local function hasAnyBasePart(root)
if not root then return false end
if root:IsA("BasePart") then return true end
return root:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
​local function isGeneratedProxy(root)
local ok, v = pcall(function() return root:GetAttribute("CursedBatSkinsGenerated") end)
return ok and v == true
end
​local function usableTemplate(root)
if not root or isGeneratedProxy(root) then return nil end
if root:IsA("Model") or root:IsA("Tool") or root:IsA("Folder") or root:IsA("BasePart") then
if hasAnyBasePart(root) then return root end
end
return nil
end
​local function findUsableNamed(root, names)
if not root then return nil end
for _, name in ipairs(names) do
if root.Name == name then
local d = usableTemplate(root)
if d then return d end
end
end
for _, name in ipairs(names) do
local found = root:FindFirstChild(name, true)
local u = usableTemplate(found)
if u then return u end
end
return nil
end
​local function assetTextFromId(assetId)
local raw = tostring(assetId or ""):gsub("%s+", "")
if raw == "" then return nil end
if raw:match("^rbxassetid://") or raw:match("^rbxasset://") then return raw end
if raw:match("^%d+$") then return "rbxassetid://" .. raw end
return raw
end
​local function loadExactTemplateFromAssetId(skinName)
local assetText = assetTextFromId(State.ExactAssetIds[skinName])
if not assetText then return nil end
local loaded = {}
pcall(function() loaded = game:GetObjects(assetText) end)
if #loaded == 0 then
local id = tostring(assetText):match("(%d+)")
if id then
pcall(function()
table.insert(loaded, InsertService:LoadAsset(tonumber(id)))
end)
end
end
local names = EXACT_TEMPLATE_NAMES[skinName] or {}
for _, root in ipairs(loaded) do
local exact = findUsableNamed(root, names) or usableTemplate(root)
if exact then
local clone = exact:Clone()
stripScripts(clone)
return clone
end
end
return nil
end
​local function findExactTemplateInGame(skinName)
local names = EXACT_TEMPLATE_NAMES[skinName]
if not names then return nil end
local containers = {
LocalPlayer.Character,
LocalPlayer:FindFirstChildOfClass("Backpack"),
ReplicatedStorage2,
Lighting2,
workspace,
}
for _, container in ipairs(containers) do
local source = findUsableNamed(container, names)
if source then
local clone = source:Clone()
stripScripts(clone)
return clone
end
end
return nil
end
​local function getExactTemplate(skinName)
if skinName == "KATANA" and State.OriginalKatanaTemplate then
return State.OriginalKatanaTemplate
end
if State.ExactTemplates[skinName] then return State.ExactTemplates[skinName] end
if State.ExactTemplateSearched[skinName] then return nil end
State.ExactTemplateSearched[skinName] = true
local loaded = loadExactTemplateFromAssetId(skinName) or findExactTemplateInGame(skinName)
if loaded then State.ExactTemplates[skinName] = loaded end
return loaded
end
​local function containerToModel(clone, folder)
if clone:IsA("Model") then
clone.Name = "FlowerSkin_AssetKatana"
clone.Parent = folder
return clone
end
if clone:IsA("BasePart") then
local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model.Parent = folder
clone.Parent = model
return model
end
if clone:IsA("Tool") or clone:IsA("Folder") then
local nested = clone:FindFirstChild("FlowerSkin_AssetKatana")
or clone:FindFirstChildWhichIsA("Model")
or clone:FindFirstChildWhichIsA("BasePart")
if nested and nested.Parent == clone then
nested.Parent = nil
clone:Destroy()
return containerToModel(nested, folder)
end
local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model.Parent = folder
for _, child in ipairs(clone:GetChildren()) do
if not isScriptObject(child) then child.Parent = model end
end
clone:Destroy()
return model
end
return nil
end
​local function applyExactMesh(tool, skinName)
local handle = tool and tool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return false end
local template = getExactTemplate(skinName)
if not template then return false end
​local folder = Instance.new("Folder")
folder.Name = "FlowerSkin_KatanaRealistic"
folder.Parent = tool
​local model = containerToModel(template:Clone(), folder)
if not model or not hasAnyBasePart(model) then
folder:Destroy()
return false
end
stripScripts(model)
pcall(function() model:SetAttribute("CursedBatSkinsExactMesh", true) end)
​local firstPart
for _, inst in ipairs(model:GetDescendants()) do
if inst:IsA("BasePart") then
firstPart = firstPart or inst
setPartSafe(inst)
end
end
if not firstPart then folder:Destroy(); return false end
​if model:IsA("Model") then
model.PrimaryPart = model.PrimaryPart or firstPart
pcall(function() model:PivotTo(handle.CFrame) end)
end
for _, inst in ipairs(model:GetDescendants()) do
if inst:IsA("BasePart") then weldToHandle(inst, handle) end
end
​local vfxPart = model:FindFirstChild("SharpParts", true)
or model:FindFirstChild("WeaponPart", true)
or model:FindFirstChild("Handle", true)
or firstPart
if vfxPart and not vfxPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then
addRedVFX(vfxPart)
end
return true
end
​local function buildProxyModel(tool, skinName)
local handle = tool and tool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then return nil end
​local folder = Instance.new("Folder")
folder.Name = "FlowerSkin_KatanaRealistic"
folder.Parent = tool
​local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model:SetAttribute("CursedBatSkinsGenerated", true)
model.Parent = folder
​local parts = {}
local function add(name, size, offset, color, material)
local part, cfOffset = newPart(model, name, size, offset, color, material)
part.CFrame = handle.CFrame * cfOffset
weldToHandle(part, handle)
table.insert(parts, part)
return part
end
​if skinName == "KATANA" then
add("Handle2", Vector3.new(0.22, 1.0, 0.22), CFrame.new(0, -0.85, 0), Color3.new(0.04, 0.04, 0.045), Enum.Material.Metal)
local sharp = add("SharpParts", Vector3.new(0.22, 3.35, 0.12), CFrame.new(0, 1.05, 0), KC.red2, Enum.Material.Neon)
add("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), KC.red, Enum.Material.Neon)
add("NeonAccent", Vector3.new(0.75, 0.12, 0.42), CFrame.new(0, -0.28, 0), KC.gold, Enum.Material.Neon)
addRedVFX(sharp)
end
model.PrimaryPart = parts[1]
return model
end
​local SKIN_SOUND_IDS = {
KATANA = "rbxassetid://111808555599832",
}
​local function applySkin(skinName)
captureKatanaTemplate()
local tool = findBatForKatanaSkin()
if not tool then
State.LastBat = nil
State.LastAppliedSkin = nil
return false
end
rememberOriginal(tool)
removeSkin(tool)
if skinName == "NONE" then
State.LastBat = tool
State.LastAppliedSkin = skinName
return true
end
hideOriginalHandle(tool, true)
setSlashSound(tool, SKIN_SOUND_IDS[skinName])
if not applyExactMesh(tool, skinName) then
buildProxyModel(tool, skinName)
end
local handle = tool:FindFirstChild("Handle")
if handle then
local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
if fire and fire:IsA("Fire") then
fire.Enabled = true
fire.Color = KC.red
fire.SecondaryColor = KC.red2
end
end
State.LastBat = tool
State.LastAppliedSkin = skinName
return true
end
​return {
State = State,
ApplySkin = applySkin,
SetExactAssetId = function(assetId)
State.ExactAssetIds.KATANA = tostring(assetId or "")
State.ExactTemplateSearched.KATANA = nil
State.ExactTemplates.KATANA = nil
end,
}
end)()
​_G.CursedBatKatana = KatanaSkin
​task.spawn(function()
while true do
if katanaSkinEnabled then
local bat
local c = LP.Character
if c then
local t = c:FindFirstChild("Bat")
if t and t:IsA("Tool") then bat = t end
end
if not bat then
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
local t = bp:FindFirstChild("Bat")
if t and t:IsA("Tool") then bat = t end
end
end
if bat and (bat ~= KatanaSkin.State.LastBat or KatanaSkin.State.LastAppliedSkin ~= "KATANA") then
pcall(function() KatanaSkin.ApplySkin("KATANA") end)
end
end
task.wait(0.5)
end
end)
​minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
MinecraftBatSetVisual = nil
MinecraftBatColorSelector = nil
​local MinecraftBatSkin = (function()
local MB_ASSET_ID = "rbxassetid://18566246244"
local MB_POS_OFFSET = _CFnew(-0.02, -0.52, -0.2)
local MB_ROT_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
local MB_SCALE = 2
​local MB_COLORS = {
["Default"]       = nil,
["Abyss Blue"]    = Color3.fromRGB(0, 40, 150),
["Venom Green"]   = Color3.fromRGB(20, 255, 50),
["Royal Gold"]    = Color3.fromRGB(255, 200, 0),
["Velvet Rose"]   = Color3.fromRGB(220, 20, 100),
["Crimson Night"] = Color3.fromRGB(90, 0, 20),
}
​local State = {
enabled = false,
colorMode = "Default",
cachedVisualPart = nil,
rgbConnection = nil,
}
​local okLoad, objects = pcall(function() return game:GetObjects(MB_ASSET_ID) end)
if okLoad and objects and #objects > 0 then
local model = objects[1]
State.cachedVisualPart = model:IsA("BasePart") and model
or model:FindFirstChildWhichIsA("BasePart", true)
end
​local function mbSetColor(visual, color)
if not visual or not color then return end
visual.Color = color
if visual:IsA("UnionOperation") then
pcall(function() visual.UsePartColor = true end)
end
local sm = visual:FindFirstChildWhichIsA("SpecialMesh")
if sm then
sm.VertexColor = Vector3.new(color.R, color.G, color.B)
end
end
​local function mbFindBat()
local char = LP.Character
if char then
local t = char:FindFirstChild("Bat")
if t and t:IsA("Tool") then return t end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
local t = bp:FindFirstChild("Bat")
if t and t:IsA("Tool") then return t end
end
return nil
end
​local function mbRemoveVisual(tool)
if not tool then return end
local old = tool:FindFirstChild("CustomUnionVisual")
if old then pcall(function() old:Destroy() end) end
local handle = tool:FindFirstChild("Handle")
if handle then
handle.Transparency = 0
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
pcall(function() child.Transparency = 0 end)
end
end
end
end
​local function mbApplyVisual(tool)
if not tool or tool.Name ~= "Bat" or not State.cachedVisualPart then return end
local handle = tool:WaitForChild("Handle", 2)
if not handle then return end
​local oldVisual = tool:FindFirstChild("CustomUnionVisual")
if oldVisual then oldVisual:Destroy() end
​handle.Transparency = 1
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
pcall(function() child.Transparency = 1 end)
end
end
​local newVisual = State.cachedVisualPart:Clone()
newVisual.Name = "CustomUnionVisual"
newVisual.CanCollide = false
newVisual.Massless = true
newVisual.Anchored = false
​local tempModel = Instance.new("Model")
newVisual.Parent = tempModel
tempModel.PrimaryPart = newVisual
pcall(function() tempModel:ScaleTo(MB_SCALE) end)
newVisual.Parent = nil
tempModel:Destroy()
​if State.colorMode == "RGB" then
mbSetColor(newVisual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
elseif MB_COLORS[State.colorMode] then
mbSetColor(newVisual, MB_COLORS[State.colorMode])
end
​for _, child in ipairs(newVisual:GetChildren()) do
if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
end
​newVisual.CFrame = handle.CFrame * MB_POS_OFFSET * MB_ROT_OFFSET
newVisual.Parent = tool
​local weld = Instance.new("WeldConstraint")
weld.Part0 = handle
weld.Part1 = newVisual
weld.Parent = newVisual
end
​local function mbStartRGB()
if State.rgbConnection then return end
State.rgbConnection = RunService.RenderStepped:Connect(function()
if not State.enabled or State.colorMode ~= "RGB" then return end
local tool = mbFindBat()
if not tool then return end
local visual = tool:FindFirstChild("CustomUnionVisual")
if visual then
mbSetColor(visual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
end
end)
end
​local function mbStopRGB()
if State.rgbConnection then
State.rgbConnection:Disconnect()
State.rgbConnection = nil
end
end
​return {
State   = State,
Colors  = MB_COLORS,
FindBat = mbFindBat,
Apply   = function()
if not State.enabled then return end
local tool = mbFindBat()
if tool then mbApplyVisual(tool) end
if State.colorMode == "RGB" then mbStartRGB() end
end,
Remove  = function()
mbStopRGB()
local char = LP.Character
if char then
local t = char:FindFirstChild("Bat")
if t then mbRemoveVisual(t) end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
local t = bp:FindFirstChild("Bat")
if t then mbRemoveVisual(t) end
end
end,
SetColorMode = function(mode)
State.colorMode = mode
if not State.enabled then return end
if mode == "RGB" then mbStartRGB() else mbStopRGB() end
local tool = mbFindBat()
if tool then mbApplyVisual(tool) end
end,
}
end)()
​task.spawn(function()
while true do
if minecraftBatSkinEnabled then
MinecraftBatSkin.State.enabled = true
local tool = MinecraftBatSkin.FindBat()
if tool and not tool:FindFirstChild("CustomUnionVisual") then
pcall(MinecraftBatSkin.Apply)
end
else
MinecraftBatSkin.State.enabled = false
end
task.wait(0.5)
end
end)
​_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump or {
holdPressed = false, holdActive = false,
controllerActive = false, mobilePressed = false,
mobileActive = false, hooked = {}
}
​function _G._jumpEnsureProxy()
local char = LP.Character
if not char then return nil end
return char:FindFirstChild("HumanoidRootPart")
end
​function _G.AmbitiousApplyNormalInfJumpBoost(boost)
if not infJumpEnabled then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return end
local proxy = _G._jumpEnsureProxy()
if not proxy then return end
local curVel = proxy.Velocity
proxy.Velocity = _V3new(curVel.X, boost or 50, curVel.Z)
end
​function _G.AmbitiousStopNormalInfJumpHoldState()
local S = _G.AmbitiousNormalInfJump
S.holdPressed = false
S.holdActive = false
S.controllerActive = false
S.mobilePressed = false
S.mobileActive = false
end
​UIS.JumpRequest:Connect(function()
_G.AmbitiousApplyNormalInfJumpBoost(50)
end)
​UIS.InputBegan:Connect(function(input)
if UIS:GetFocusedTextBox() then return end
local S = _G.AmbitiousNormalInfJump
​if input.UserInputType == Enum.UserInputType.Keyboard
and input.KeyCode == Enum.KeyCode.Space then
if infJumpMode == "MANUAL" then return end
S.holdPressed = true
task.delay(0.12, function()
if _G.AmbitiousNormalInfJump.holdPressed and infJumpEnabled then
_G.AmbitiousNormalInfJump.holdActive = true
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
elseif input.KeyCode == Enum.KeyCode.ButtonA
and input.UserInputType.Name:match("^Gamepad") then
if infJumpMode ~= "MANUAL" then S.controllerActive = true end
end
end)
​UIS.InputEnded:Connect(function(input)
local S = _G.AmbitiousNormalInfJump
if input.UserInputType == Enum.UserInputType.Keyboard
and input.KeyCode == Enum.KeyCode.Space then
S.holdPressed = false
S.holdActive  = false
end
if input.KeyCode == Enum.KeyCode.ButtonA
and input.UserInputType.Name:match("^Gamepad") then
S.controllerActive = false
end
end)
​function _G.AmbitiousHookNormalInfMobileJumpButton(obj)
local S = _G.AmbitiousNormalInfJump
if not obj or obj.Name ~= "JumpButton"
or not obj:IsA("GuiButton") or S.hooked[obj] then return end
S.hooked[obj] = true
obj.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.Touch
or not infJumpEnabled then return end
if infJumpMode == "MANUAL" then return end
S.mobilePressed = true
task.delay(0.12, function()
if S.mobilePressed and infJumpEnabled then
S.mobileActive = true
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
end)
obj.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
S.mobilePressed = false
S.mobileActive  = false
end
end)
end
​do
local pg = LP:FindFirstChildOfClass("PlayerGui")
if pg then
for _, obj in ipairs(pg:GetDescendants()) do
_G.AmbitiousHookNormalInfMobileJumpButton(obj)
end
pg.DescendantAdded:Connect(function(obj)
task.defer(_G.AmbitiousHookNormalInfMobileJumpButton, obj)
end)
end
end
​RunService.Heartbeat:Connect(function()
local S = _G.AmbitiousNormalInfJump
if infJumpEnabled and infJumpMode == "HOLD"
and (S.holdActive or S.mobileActive or S.controllerActive) then
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
​function _G.setInfJumpInternal(on)
infJumpEnabled = on and true or false
if not infJumpEnabled then
_G.AmbitiousStopNormalInfJumpHoldState()
local ch = LP.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp then pcall(function() hrp.Velocity = _V3zero end) end
end
end
​InfiniteJump = {
start = function() _G.setInfJumpInternal(true)  end,
stop  = function() _G.setInfJumpInternal(false) end,
isRunning = function() return infJumpEnabled == true end,
setJumpPower = function() end,
}
​local function getCharParts()
local char = LP.Character
if not char then return nil, nil end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if not hum or not root then return nil, nil end
return hum, root
end
​local function claimOwnership(root)
pcall(function() root:SetNetworkOwner(LP) end)
end
​function getActiveMoveSpeed()
if laggerCarryToggled then return LAGGER_CARRY_SPEED
elseif laggerToggled then return LAGGER_SPEED
elseif speedMode then return CS
else return NS end
end
​local _velChecked = {}
local _hookedVelParts = {}
​local function _setupVelChecked(char)
_velChecked = {}
if not char then return end
local hrp = char:WaitForChild("HumanoidRootPart", 5)
if hrp then _velChecked[hrp] = true end
return hrp
end
​local _hookVelSupported = nil
local function _hookVelHRP(hrp)
if not hrp or _hookedVelParts[hrp] then return end
if _hookVelSupported == false then return end
if _hookVelSupported == nil then
_hookVelSupported = (type(getrawmetatable) == "function")
and (type(setreadonly) == "function")
and (type(newcclosure) == "function")
and (type(checkcaller) == "function")
end
if not _hookVelSupported then return end
_hookedVelParts[hrp] = true
local ok = pcall(function()
local mt = getrawmetatable(hrp)
if not mt then return end
setreadonly(mt, false)
local originalVelIndex = rawget(mt, "__index")
mt.__index = newcclosure(function(self, key)
if not checkcaller() and _velChecked[self]
and (key == "AssemblyLinearVelocity" or key == "Velocity") then
local real
if type(originalVelIndex) == "function" then
real = originalVelIndex(self, key)
elseif type(originalVelIndex) == "table" then
real = originalVelIndex[key]
end
if real and real.Magnitude > 20 then return real.Unit * 20 end
return real
end
if type(originalVelIndex) == "function" then
return originalVelIndex(self, key)
elseif type(originalVelIndex) == "table" then
return originalVelIndex[key]
end
end)
setreadonly(mt, true)
end)
if not ok then _hookVelSupported = false end
end
​if LP.Character then
local _hrp0 = _setupVelChecked(LP.Character)
_hookVelHRP(_hrp0)
end
​local function _isRagdollState(hum)
if not hum then return true end
local st = hum:GetState()
return hum.PlatformStand
or st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
end
​local function _applyVelocitySpeed(dir, speed, hrp)
if not hrp or not hrp.Parent then return end
if autoBatV2Enabled or batDesyncTpEnabled or autoBatEnabled then return end
if dir and dir.Magnitude > 0.05 then
pcall(function()
if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
end)
local unit = dir.Unit
local vy = hrp.AssemblyLinearVelocity.Y
hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
else
local vy = hrp.AssemblyLinearVelocity.Y
hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
end
end
​function getAutoPathSpeed()
if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
return NS
end
​ANIM_PACKS = {
["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}
​ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}
​local function isPackAnim(id)
for _, pack in pairs(ANIM_PACKS) do
for _, v in pairs(pack) do
if v == id then return true end
end
end
return false
end
​local function saveOriginalAnims(char)
local animate = char:FindFirstChild("Animate")
if not animate then return end
local function g(obj) return obj and obj.AnimationId or nil end
local ids = {
idle1 = g(animate.idle and animate.idle.Animation1),
idle2 = g(animate.idle and animate.idle.Animation2),
walk  = g(animate.walk and animate.walk.WalkAnim),
run   = g(animate.run  and animate.run.RunAnim),
jump  = g(animate.jump and animate.jump.JumpAnim),
fall  = g(animate.fall and animate.fall.FallAnim),
climb = g(animate.climb and animate.climb.ClimbAnim),
swim  = g(animate.swim and animate.swim.Swim),
swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
}
if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end
​local function applyAnimPack(packName)
currentAnimPack = packName
if animSelectorLabel then animSelectorLabel.Text = packName end
if packName == "Off" then
if originalTryardAnims and LP.Character then
local animate = LP.Character:FindFirstChild("Animate")
if animate then
local function s(obj,id) if obj then obj.AnimationId = id end end
s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
end
end
if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
return
end
local pack = ANIM_PACKS[packName]
if not pack then return end
if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
local c = LP.Character
if not c then return end
local animate = c:FindFirstChild("Animate")
if not animate then return end
local function s(obj,id) if obj then obj.AnimationId = id end end
s(animate.idle and animate.idle.Animation1, pack.idle1)
s(animate.idle and animate.idle.Animation2, pack.idle2)
s(animate.walk and animate.walk.WalkAnim, pack.walk)
s(animate.run  and animate.run.RunAnim,   pack.run)
s(animate.jump and animate.jump.JumpAnim, pack.jump)
s(animate.fall and animate.fall.FallAnim, pack.fall)
s(animate.climb and animate.climb.ClimbAnim, pack.climb)
s(animate.swim and animate.swim.Swim, pack.swim)
s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
end)
end
​local function startAnimPack(packName)
local char = LP.Character
if char then
saveOriginalAnims(char)
applyAnimPack(packName)
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
hum:ChangeState(Enum.HumanoidStateType.Running)
end
else
applyAnimPack(packName)
end
currentAnimPack = packName
end
​local function stopAnimPack()
currentAnimPack = "Off"
if animSelectorLabel then animSelectorLabel.Text = "Off" end
applyAnimPack("Off")
end
​-- ═══════════════════════════════════════════════════════════════
-- KEYBINDS: TPBat en X, DropBrainrot en J
-- ═══════════════════════════════════════════════════════════════
DEFAULT_KB = {
DropBrainrot = {kb = Enum.KeyCode.J, gp = nil},
AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
TPBat        = {kb = Enum.KeyCode.X, gp = nil},
BatV2        = {kb = Enum.KeyCode.V, gp = nil},
InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}
​KB = {
DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}
​_isResetting = false
_lastSavedJSON = nil
_isLoading = false
​CONFIG = {
AUTO_STEAL_ENABLED = false,
STEAL_RANGE = 61,
}
​local plots = workspace:WaitForChild("Plots")