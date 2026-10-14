-- Parch3 Duels | LocalScript
repeat task.wait() until game:IsLoaded()
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer
_G._OpenAntiBat = nil

_G._FearSky = _G._FearSky or {}
_G._FearSky.TAG = "FearSkyTheme"
_G._FearSky.mode = "Off"
_G._FearSky.original = nil
_G._FearSky.PRESETS = {
["Night"]     = {clock = 22,   brightness = 2,   ambient = {110,100,130}, outAmb = {120,110,140}, sky = {stars = 4000, moon = 18, sun = 0, moonTex = true}, atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2}},
["Galaxy"]    = {clock = 0,    brightness = 1.5, ambient = {70,60,100},   outAmb = {80,70,110},   sky = {stars = 10000, moon = 30, sun = 0}, atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5}},
["Blood Moon"]= {clock = 22.5, brightness = 1.6, ambient = {130,40,40},   outAmb = {150,50,50},   sky = {stars = 1500, moon = 28, sun = 0, moonTex = true}, atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2}, clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}}},
["Vaporwave"] = {clock = 19.5, brightness = 1.2, ambient = {120,95,130}, outAmb = {130,100,140}, sky = {stars = 1000, moon = 14}, atm = {dens = 0.3, color = {255,130,235}, decay = {150,90,255}, glare = 2.6, haze = 1.6}, clouds = {cover = 0.5, dens = 0.55, color = {230,190,255}}},
}
function _G._FearSky.saveOriginal()
if _G._FearSky.original then return end
_G._FearSky.original = {ClockTime=Lighting.ClockTime, OutdoorAmbient=Lighting.OutdoorAmbient, Ambient=Lighting.Ambient, Brightness=Lighting.Brightness, FogStart=Lighting.FogStart, FogEnd=Lighting.FogEnd, FogColor=Lighting.FogColor, ColorShift_Top=Lighting.ColorShift_Top, ColorShift_Bottom=Lighting.ColorShift_Bottom, GlobalShadows=Lighting.GlobalShadows, LightingChildren={}, TerrainChildren={}}
for _,c in ipairs(Lighting:GetChildren()) do if c:IsA("Sky") or c:IsA("Atmosphere") then table.insert(_G._FearSky.original.LightingChildren, c:Clone()) end end
local t = workspace:FindFirstChildOfClass("Terrain")
if t then for _,c in ipairs(t:GetChildren()) do if c:IsA("Clouds") then table.insert(_G._FearSky.original.TerrainChildren, c:Clone()) end end end
end
function _G._FearSky.clear()
for _,c in ipairs(Lighting:GetChildren()) do if c:GetAttribute(_G._FearSky.TAG) then pcall(function() c:Destroy() end) end end
local t = workspace:FindFirstChildOfClass("Terrain")
if t then for _,c in ipairs(t:GetChildren()) do if c:GetAttribute(_G._FearSky.TAG) then pcall(function() c:Destroy() end) end end end
end
function _G._FearSky.apply(mode)
_G._FearSky.saveOriginal(); _G._FearSky.clear()
local t = workspace:FindFirstChildOfClass("Terrain")
local p = _G._FearSky.PRESETS[mode]
if not p then
if _G._FearSky.original then
for k,v in pairs(_G._FearSky.original) do if k ~= "LightingChildren" and k ~= "TerrainChildren" then pcall(function() Lighting[k] = v end) end end
for _,c in ipairs(_G._FearSky.original.LightingChildren or {}) do c:Clone().Parent = Lighting end
if t then for _,c in ipairs(_G._FearSky.original.TerrainChildren or {}) do c:Clone().Parent = t end end
end
_G._FearSky.mode = "Off"
return
end
Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
Lighting.ClockTime = p.clock or 14; Lighting.Brightness = p.brightness or 2
if p.outAmb then Lighting.OutdoorAmbient = Color3.fromRGB(p.outAmb[1], p.outAmb[2], p.outAmb[3]) end
if p.ambient then Lighting.Ambient = Color3.fromRGB(p.ambient[1], p.ambient[2], p.ambient[3]) end
if p.sky then
local s = Instance.new("Sky"); s:SetAttribute(_G._FearSky.TAG, true)
if p.sky.stars then s.StarCount = p.sky.stars end
if p.sky.moon then s.MoonAngularSize = p.sky.moon end
if p.sky.sun then s.SunAngularSize = p.sky.sun end
if p.sky.moonTex then s.MoonTextureId = "rbxasset://sky/moon.jpg" end
s.Parent = Lighting
end
if p.atm then
local a = Instance.new("Atmosphere"); a:SetAttribute(_G._FearSky.TAG, true)
a.Density = p.atm.dens or 0.3
a.Color = Color3.fromRGB(p.atm.color[1], p.atm.color[2], p.atm.color[3])
a.Decay = Color3.fromRGB(p.atm.decay[1], p.atm.decay[2], p.atm.decay[3])
a.Glare = p.atm.glare or 1; a.Haze = p.atm.haze or 1
a.Parent = Lighting
end
if p.clouds and t then
local c = Instance.new("Clouds"); c:SetAttribute(_G._FearSky.TAG, true)
c.Cover = p.clouds.cover or 0.5; c.Density = p.clouds.dens or 0.5
c.Color = Color3.fromRGB(p.clouds.color[1], p.clouds.color[2], p.clouds.color[3])
c.Parent = t
end
_G._FearSky.mode = mode
end
local NS,CS = 60,30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,true
local infJumpMode = "hold"
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
_G._MedReset = _G._MedReset or {enabled=false,pending=false}
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local DROP_TYPES = {STAND="Stand Drop", JUMP="Jump Drop"}
local currentDropType = DROP_TYPES.STAND
local standDropBtn,jumpDropBtn = nil,nil
local _dropConn = nil
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoNearCarryEnabled = true
local antiBatActive = false
local stopAntiBat, setAntiBatVisual, toggleAntiBat
_G._CursedUILocked = true
local autoSwingEnabled = true
local autoBatSetVisual = nil
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local resetAutoBatMotion = nil
local aimbotSpeed = 58
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 58,52,-2.8,4.75,1,285,28
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local _updateMobileAutoLeft, _updateMobileAutoRight
local ragdollTPEnabled=false
local ragdollTPSetVisual=nil
local _ragdollTPConns={}
local _ragdollTPLast=0
_G._Dysnc = _G._Dysnc or {}
do
_G._Dysnc.enabled = _G._Dysnc.enabled or false
_G._Dysnc.range = _G._Dysnc.range or 8
local conn = nil
local hitCooldown = false
local function getBat()
local char = LP.Character
if not char then return nil end
local tool = char:FindFirstChild("Bat")
if tool then return tool end
local bp = LP:FindFirstChild("Backpack")
if bp then
tool = bp:FindFirstChild("Bat")
if tool then tool.Parent = char; return tool end
end
return nil
end
local function tryHitBat()
if hitCooldown then return end
hitCooldown = true
pcall(function()
local bat = getBat()
if bat then
bat:Activate()
local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
if ev then ev:FireServer() end
end
end)
task.delay(0.08,function() hitCooldown = false end)
end
local function getClosest()
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end
local cp, cd = nil, math.huge
for _, p in pairs(Players:GetPlayers()) do
if p ~= LP and p.Character then
local tr = p.Character:FindFirstChild("HumanoidRootPart")
local ph = p.Character:FindFirstChildOfClass("Humanoid")
if tr and ph and ph.Health > 0 then
local d = (hrp.Position - tr.Position).Magnitude
if d < cd then cd = d; cp = p end
end
end
end
return cp
end
local function startDysnc()
if conn then conn:Disconnect() end
conn = RunService.Heartbeat:Connect(function()
if not _G._Dysnc.enabled then return end
local char = LP.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not (hrp and hum) then return end
local target = getClosest()
if target and target.Character then
local tr = target.Character:FindFirstChild("HumanoidRootPart")
if tr then
if sethiddenproperty then pcall(sethiddenproperty,hrp,"PhysicsRepRootPart",tr) end
local targetPos = tr.Position + Vector3.new(0,0.9,0)
if (hrp.Position - targetPos).Magnitude > _G._Dysnc.range then hrp.CFrame = CFrame.new(targetPos) end
local cam = workspace.CurrentCamera
if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
tryHitBat()
end
end
end)
end
local function stopDysnc()
if conn then conn:Disconnect(); conn = nil end
end
_G._Dysnc.start = startDysnc
_G._Dysnc.stop = stopDysnc
end
_G._BodyLock = _G._BodyLock or {}
do
_G._BodyLock.enabled = _G._BodyLock.enabled or false
_G._BodyLock.radius = _G._BodyLock.radius or 20
local conn = nil
local function getClosestPlayer()
local char = LP.Character
if not char then return nil, math.huge end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return nil, math.huge end
local closest, dist = nil, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and p.Character then
local tr = p.Character:FindFirstChild("HumanoidRootPart")
local ph = p.Character:FindFirstChildOfClass("Humanoid")
if tr and ph and ph.Health > 0 then
local d = (hrp.Position - tr.Position).Magnitude
if d < dist then dist = d; closest = p end
end
end
end
return closest, dist
end
local function startBodyLock()
if conn then return end
conn = true
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then hum0.AutoRotate = false end
RunService:BindToRenderStep("CursedBodyLock", Enum.RenderPriority.Character.Value + 1, function()
if not _G._BodyLock.enabled then return end
local char = LP.Character; if not char then return end
local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
if hum.AutoRotate then hum.AutoRotate = false end
local closest, dist = getClosestPlayer()
if not closest or not closest.Character then return end
if dist > _G._BodyLock.radius then return end
local tr = closest.Character:FindFirstChild("HumanoidRootPart"); if not tr then return end
local myPos = root.Position
local flat = Vector3.new(tr.Position.X - myPos.X, 0, tr.Position.Z - myPos.Z)
if flat.Magnitude < 0.01 then return end
flat = flat.Unit
local goalCF = CFrame.lookAt(myPos, myPos + flat)
local diffCF = root.CFrame:Inverse() * goalCF
local _, ry, _ = diffCF:ToEulerAnglesXYZ()
ry = math.clamp(ry, -math.pi, math.pi)
root.RotVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 40, 0))
end)
end
local function stopBodyLock()
if conn then pcall(function() RunService:UnbindFromRenderStep("CursedBodyLock") end); conn = nil end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate = true end
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then root.RotVelocity = Vector3.zero end
end
_G._BodyLock.start = startBodyLock
_G._BodyLock.stop = stopBodyLock
end
local InfJumpPlatform = nil
local function CreateIJP()
if InfJumpPlatform then return end
InfJumpPlatform = Instance.new("Part")
InfJumpPlatform.Name = "InfJumpPlatform"
InfJumpPlatform.Size = Vector3.new(8, 0.5, 8)
InfJumpPlatform.Anchored = true
InfJumpPlatform.CanCollide = true
InfJumpPlatform.Transparency = 1
InfJumpPlatform.Material = Enum.Material.ForceField
InfJumpPlatform.Parent = workspace
end
CreateIJP()
RunService.Heartbeat:Connect(function()
if not infJumpEnabled then
if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
return
end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not (char and root and hum) then
if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
return
end
local isJumping = UIS:IsKeyDown(Enum.KeyCode.Space)
or hum:GetState() == Enum.HumanoidStateType.Jumping
or hum.Jump
if isJumping then
if not InfJumpPlatform then CreateIJP() end
InfJumpPlatform.Position = root.Position - Vector3.new(0, 3.5, 0)
if root.Velocity.Y < 50 then
root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
end
else
if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end
end
end)
task.spawn(function()
local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
pcall(function() HS.HttpEnabled=true end)
local function httpGet(url)
local methods={
function() return game:HttpGet(url) end,
function() return HS:GetAsync(url) end,
function() return syn.request({Url=url,Method="GET"}).Body end,
function() return http_request({Url=url,Method="GET"}).Body end,
function() return request({Url=url,Method="GET"}).Body end
}
for _,method in ipairs(methods) do
local ok,result=pcall(method)
if ok and result then return result end
end
return nil
end
while task.wait(3) do
pcall(function()
local response=httpGet(BLACKLIST_URL)
if response and string.find(response,tostring(LP.UserId),1,true) then
LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
task.wait(999999)
end
end)
end
end)
pcall(function()
if hookfunction and newcclosure then
local oldFire
oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
return oldFire(self,...)
end))
end
end)
task.spawn(function()
task.wait(2)
if cursedResetRemote then return end
for _,desc in ipairs(game:GetDescendants()) do
if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
end
end)
local function cursedInstaReset()
if not cursedResetRemote then
for _,desc in ipairs(game:GetDescendants()) do
if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
end
end
if not cursedResetRemote then return end
local character=LP.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
local resetDetected=false
local conns={}
if humanoid then
table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end))
table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() if humanoid.Health<=0 then resetDetected=true end end))
end
if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
task.spawn(function()
for _=1,50 do
if resetDetected then break end
pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end)
task.wait()
end
for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
end)
end

_G.MiroInstaReset = cursedInstaReset
autoResetOnDeath = false

_G.__Miro_hookDeath = function(char)
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then hum = char:WaitForChild("Humanoid",5) end
if not hum then return end
hum.Died:Connect(function()
if autoResetOnDeath then
task.spawn(function() pcall(cursedInstaReset) end)
end
end)
end

task.spawn(function()
if LP.Character then _G.__Miro_hookDeath(LP.Character) end
LP.CharacterAdded:Connect(function(char)
task.wait(0.2)
_G.__Miro_hookDeath(char)
end)
end)

local KB = {
DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
InstaReset  ={kb=Enum.KeyCode.T,gp=nil},
GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
LaggerToggle={kb=Enum.KeyCode.R,gp=nil},
AntiBat     ={kb=Enum.KeyCode.J,gp=nil},
Dysnc       ={kb=Enum.KeyCode.G,gp=nil},
}
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal = {
AutoStealEnabled=false,StealRadius=8,StealDuration=0.1,
Mode="normal",
HalfFireRange=10,HalfHoldMin=1.3,HalfHoldMax=2.6,HalfEntryDelay=0.3,
Data={}
}
local isStealing = false
local stealStartTime = nil
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local progressRadLbl,progressFill,progressPct
local modeValLbl
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local CARRY_DETECTION_RADIUS = 18
local function isNearPodiumWithPrompt()
local char=LP.Character
local hrpL=char and char:FindFirstChild("HumanoidRootPart")
if not hrpL then return false end
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
for _,plot in ipairs(plots:GetChildren()) do
local podiums=plot:FindFirstChild("AnimalPodiums")
if podiums then
for _,podium in ipairs(podiums:GetChildren()) do
repeat
if not podium:IsA("Model") then break end
local base=podium:FindFirstChild("Base")
if not base then break end
local sp=base:FindFirstChild("Spawn")
if not sp then break end
if (hrpL.Position-podium:GetPivot().Position).Magnitude>CARRY_DETECTION_RADIUS then break end
local att=sp:FindFirstChild("PromptAttachment")
if not att then break end
for _,obj in ipairs(att:GetChildren()) do
if obj:IsA("ProximityPrompt") and obj.Enabled then return true end
end
until true
end
end
end
return false
end
local function isHoldingBrainrot()
local char = LP.Character
if not char then return false end
for _, obj in ipairs(char:GetChildren()) do
if obj:IsA("Tool") then return true end
end
return false
end
local function massImpulse(hrp, direction, targetSpeed)
local mass = hrp.AssemblyMass or 1
local current = hrp.AssemblyLinearVelocity
local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
local delta = desired - current
pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
hrp.AssemblyLinearVelocity = Vector3.new(desired.X, current.Y, desired.Z)
end
local function getActiveMoveSpeed()
if laggerToggled then return laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED end
if speedMode then return CS end
return NS
end
local function getAutoPathSpeed()
return laggerToggled and LAGGER_SPEED or NS
end
local function isRagdollState(hum)
if not hum then return true end
local st=hum:GetState()
return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
local function isMyPlotByName(plotName)
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
local plot=plots:FindFirstChild(plotName)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yb=sign:FindFirstChild("YourBase")
if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
end
return false
end
-- ============================================================
do
-- ============================================================
local player = LP
local function resetProgressBar() _G.__FearStealProg=0 end
local function updateStealProgress(progress) _G.__FearStealProg=math.clamp(progress or 0,0,1) end
local M = {}
M.Steal = Steal
setmetatable(M,{
	__index=function(_,k)
		if k=="isStealing" then return isStealing
		elseif k=="stealMode" then return (Steal.Mode=="half") and "Semi" or "Full" end
	end,
	__newindex=function(_,k,v)
		if k=="isStealing" then
			isStealing=v
			if v then stealStartTime=tick() else stealStartTime=nil end
		else rawset(M,k,v) end
	end,
})

if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt)
        or (genv and genv().fireproximityprompt)
        or function(prompt)
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
        end
end

Semi = {
    HoldMin = 1.3, HoldMax = 2.6, EntryDelay = 0.3, Cooldown = 0.05, StealRange = 9, PrimeRange = 80,
    allAnimalsCache = {}, PromptMemoryCache = {}, InternalStealCache = {}, stealConnection = nil,
    StealState = { active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0 },
    plots = nil, syncRemotes = nil, plotAnimalSync = {caches = {}, connections = {}}, AnimalsData = nil, initialized = false,
}

function Semi.initSync()
    if Semi.initialized then return end
    Semi.plots = Semi.plots or workspace:FindFirstChild("Plots") or workspace:WaitForChild("Plots")
    local RS = game:GetService("ReplicatedStorage")
    local Packages = RS:WaitForChild("Packages")
    local Datas = RS:WaitForChild("Datas")
    Semi.AnimalsData = require(Datas:WaitForChild("Animals"))
    local folder = Packages:WaitForChild("Synchronizer")
    Semi.syncRemotes = {
        channelFolder = folder:WaitForChild("Channel"),
        routeRemote = folder:WaitForChild("CommunicationRoute"),
        requestData = folder:FindFirstChild("RequestData"),
    }
    local function splitSyncPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
        return out
    end
    local function resolveSyncPath(path, root)
        local current = root; local parent = nil; local key = nil
        for _, part in ipairs(splitSyncPath(path)) do
            parent = current; key = part; current = current and current[part] or nil
        end
        return current, parent, key
    end
    local function applyPlotSyncDiff(channelName, packet)
        local cache = Semi.plotAnimalSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolveSyncPath(path, cache)
        if action == "Changed" then if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then if current ~= nil then current[b] = nil end end
    end
    local function attachPlotChannel(remote)
        if Semi.plotAnimalSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not Semi.plots:FindFirstChild(channelName) then return end
        if Semi.syncRemotes.requestData and Semi.plotAnimalSync.caches[channelName] == nil then
            local ok, data = pcall(function() return Semi.syncRemotes.requestData:InvokeServer(channelName) end)
            if ok and typeof(data) == "table" then Semi.plotAnimalSync.caches[channelName] = data
            else Semi.plotAnimalSync.caches[channelName] = {} end
        elseif Semi.plotAnimalSync.caches[channelName] == nil then
            Semi.plotAnimalSync.caches[channelName] = {}
        end
        Semi.plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
        end)
    end
    local function detachPlotChannel(channelName)
        for remote, conn in pairs(Semi.plotAnimalSync.connections) do
            if tostring(remote.Name) == tostring(channelName) then
                conn:Disconnect()
                Semi.plotAnimalSync.connections[remote] = nil
                Semi.plotAnimalSync.caches[tostring(channelName)] = nil
                break
            end
        end
    end
    for _, child in ipairs(Semi.syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    Semi.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    Semi.syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not Semi.plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = Semi.syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
            elseif kind == "ListenerRemoved" then detachPlotChannel(channelName) end
        end
    end)
    Semi.initialized = true
end

function Semi.getPlotChannelData(plotName) return Semi.plotAnimalSync.caches[plotName] end
function Semi.getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end
function Semi.isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = Semi.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return Semi.getPlotOwner(plot) == player.DisplayName
end
function Semi.findProximityPrompt(animalData)
    if not animalData then return nil end
    local cached = Semi.PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = Semi.plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then Semi.PromptMemoryCache[animalData.uid] = p; return p end
    end
    return nil
end
function Semi.getAnimalPosition(animalData)
    local plot = Semi.plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end
function Semi.distToAnimal(animalData)
    local char = player.Character
    if not char then return math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = Semi.getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end
function Semi.pickClosest()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(Semi.allAnimalsCache) do
        if Semi.isMyBaseAnimal(animalData) then continue end
        local pos = Semi.getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > Semi.PrimeRange then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end
function Semi.buildStealCallbacks(prompt)
    if Semi.InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then Semi.InternalStealCache[prompt] = data end
end
function Semi.executeStealAsync(prompt, animalData)
    local data = Semi.InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    Semi.StealState.active = true; Semi.StealState.startTime = tick()
    Semi.StealState.phase = "holding"; Semi.StealState.label = label
    M.isStealing = true
    updateStealProgress(0)
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(Semi.HoldMin)
        Semi.StealState.phase = "waitingRange"
        local alreadyInRange = Semi.distToAnimal(animalData) <= Semi.StealRange
        local fired = false
        while true do
            local elapsed = tick() - Semi.StealState.startTime
            if elapsed > Semi.HoldMax then break end
            if not prompt.Parent then break end
            local prog = math.clamp(elapsed / Semi.HoldMax * 0.9, 0, 0.9)
            updateStealProgress(prog)
            if Semi.distToAnimal(animalData) <= Semi.StealRange then
                if not alreadyInRange then task.wait(Semi.EntryDelay) end
                updateStealProgress(1)
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end
        if fired then Semi.StealState.totalSteals = Semi.StealState.totalSteals + 1
        else Semi.StealState.failedSteals = Semi.StealState.failedSteals + 1 end
        Semi.StealState.active = false; Semi.StealState.phase = "idle"; Semi.StealState.lastResultTime = tick()
        task.wait(0.05); M.isStealing = false; updateStealProgress(0); data.ready = true
    end)
    return true
end
function Semi.attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    Semi.buildStealCallbacks(prompt)
    if not Semi.InternalStealCache[prompt] then return false end
    return Semi.executeStealAsync(prompt, animalData)
end
function Semi.scanAllPlots()
    if not Semi.plots then return 0 end
    local newCache = {}
    for _, plot in ipairs(Semi.plots:GetChildren()) do
        local cache = Semi.getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = Semi.AnimalsData and Semi.AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, { name = animalInfo.DisplayName or animalName, plot = plot.Name, slot = tostring(slot), uid = plot.Name .. "_" .. tostring(slot) })
            end
        end
    end
    Semi.allAnimalsCache = newCache
    return #newCache
end
function Semi.startSteal()
    if Semi.stealConnection then return end
    Semi.stealConnection = RunService.Heartbeat:Connect(function()
        if not M.Steal.AutoStealEnabled or M.isStealing then return end
        if Semi.StealState.active then return end
        local target = Semi.pickClosest()
        if not target then return end
        local prompt = Semi.PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then prompt = Semi.findProximityPrompt(target) end
        if prompt then Semi.attemptSteal(prompt, target) end
    end)
    if Semi.rescanThread then task.cancel(Semi.rescanThread) end
    Semi.rescanThread = task.spawn(function()
        local okInit = pcall(Semi.initSync)
        if not okInit then warn("[Fear] autograb sync init failed") end
        while Semi.stealConnection do
            if not Semi.initialized then pcall(Semi.initSync) end
            pcall(Semi.scanAllPlots)
            task.wait(0.5)
        end
    end)
end
function Semi.stopSteal()
    if Semi.stealConnection then Semi.stealConnection:Disconnect(); Semi.stealConnection = nil end
    if Semi.rescanThread then task.cancel(Semi.rescanThread); Semi.rescanThread=nil end
    M.isStealing = false; updateStealProgress(0)
end
function startAutoSteal()
	Steal.AutoStealEnabled=true
	local ok=pcall(Semi.startSteal)
	if not ok then warn("[Fear] autograb start failed") end
end
function stopAutoSteal()
	pcall(Semi.stopSteal)
	isStealing=false
	resetProgressBar()
end
end -- engine scope
RunService.Stepped:Connect(function()
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
for _,part in ipairs(p.Character:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide=false end
end
end
end
end)
RunService.RenderStepped:Connect(function()
local char=LP.Character;if not char then return end
local hum=char:FindFirstChildOfClass("Humanoid")
local hrp=char:FindFirstChild("HumanoidRootPart")
if not hum or not hrp then return end
if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
local md=hum.MoveDirection
local spd=getActiveMoveSpeed()
if md.Magnitude>0 then lastMoveDir=md; massImpulse(hrp, md, spd)
elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
local anyHeld=false
for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
if anyHeld then massImpulse(hrp, lastMoveDir, spd) end
end
end
if speedLabel then speedLabel.Text=string.format("%.0f",getActiveMoveSpeed()) end
end)
local alConn,arConn=nil,nil
local alPhase,arPhase=1,1
local function stopAutoLeft()
if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
if autoLeftSetVisual then autoLeftSetVisual(false) end
if _updateMobileAutoLeft then _updateMobileAutoLeft(false) end
end
local function stopAutoRight()
if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
if autoRightSetVisual then autoRightSetVisual(false) end
if _updateMobileAutoRight then _updateMobileAutoRight(false) end
end
local function startAutoLeft()
if alConn then alConn:Disconnect() end;alPhase=1
alConn=RunService.Heartbeat:Connect(function()
if not autoLeftEnabled then return end
local char=LP.Character;if not char then return end
local hrp=char:FindFirstChild("HumanoidRootPart")
local hum=char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
local spd=getAutoPathSpeed()
if alPhase==1 then
local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
if (tgt-hrp.Position).Magnitude<1 then alPhase=2
local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);return end
local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
elseif alPhase==2 then
local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
if (tgt-hrp.Position).Magnitude<1 then
hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if _updateMobileAutoLeft then _updateMobileAutoLeft(false) end;return end
local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
end
end)
end
local function startAutoRight()
if arConn then arConn:Disconnect() end;arPhase=1
arConn=RunService.Heartbeat:Connect(function()
if not autoRightEnabled then return end
local char=LP.Character;if not char then return end
local hrp=char:FindFirstChild("HumanoidRootPart")
local hum=char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
local spd=getAutoPathSpeed()
if arPhase==1 then
local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
if (tgt-hrp.Position).Magnitude<1 then arPhase=2
local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd);return end
local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
elseif arPhase==2 then
local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
if (tgt-hrp.Position).Magnitude<1 then
hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if _updateMobileAutoRight then _updateMobileAutoRight(false) end;return end
local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
end
end)
end
local function setupSpeedIndicator(char)
local head=char:WaitForChild("Head",5);if not head then return end
if head:FindFirstChild("LonelyHeadIndicator") then head.LonelyHeadIndicator:Destroy() end
local bb=Instance.new("BillboardGui",head)
bb.Name="LonelyHeadIndicator"
bb.Size=UDim2.new(0,180,0,50);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
local discordLabel=Instance.new("TextLabel",bb)
discordLabel.Name="Discord"
discordLabel.Size=UDim2.new(1,0,0.5,0);discordLabel.Position=UDim2.new(0,0,0,0)
discordLabel.BackgroundTransparency=1
discordLabel.Text="Parch3 Duels";discordLabel.TextColor3=Color3.fromRGB(170,0,255)
discordLabel.Font=Enum.Font.GothamBold;discordLabel.TextScaled=false;discordLabel.TextSize=13
discordLabel.TextStrokeTransparency=0;discordLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
speedLabel=Instance.new("TextLabel",bb)
speedLabel.Name="Speed"
speedLabel.Size=UDim2.new(1,0,0.5,0);speedLabel.Position=UDim2.new(0,0,0.5,0)
speedLabel.BackgroundTransparency=1
speedLabel.Text="0";speedLabel.TextColor3=Color3.fromRGB(255,255,255)
speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=false;speedLabel.TextSize=15
speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
end
local arConn = nil
local antiRagResetCooldown = 0
local function startAntiRagdoll()
if arConn then return end
arConn = RunService.Heartbeat:Connect(function()
if not antiRagdollEnabled then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if not hum or not root or hum.Health <= 0 then return end
local state = hum:GetState()
local now = tick()
if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
if now - antiRagResetCooldown > 0.15 then
antiRagResetCooldown = now
pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
root.Velocity = Vector3.zero
root.RotVelocity = Vector3.zero
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") then obj.Enabled = true end end
for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Constraint") then obj.Enabled = true end end
workspace.CurrentCamera.CameraSubject = hum
local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
if PM then local CM = require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end
hum.AutoRotate = true; hum.PlatformStand = false; hum.Sit = false
end)
end
end
end)
end
local function stopAntiRagdoll()
if arConn then arConn:Disconnect(); arConn = nil end
end
local _wfConns={}
local function runStandDrop()
if dropActive then return end
if autoBatEnabled then
autoBatEnabled=false
if resetAutoBatMotion then resetAutoBatMotion() end
if autoBatSetVisual then autoBatSetVisual(false) end
end
dropActive=true
local colConn=RunService.Stepped:Connect(function()
if not dropActive then return end
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
for _,part in ipairs(p.Character:GetChildren()) do
if part:IsA("BasePart") then part.CanCollide=false end
end
end
end
end)
table.insert(_wfConns,colConn)
local flingThread=coroutine.create(function()
while dropActive do
RunService.Heartbeat:Wait()
local c=LP.Character
local root=c and c:FindFirstChild("HumanoidRootPart")
if not root then break end
local vel=root.Velocity
root.Velocity=vel*10000+Vector3.new(0,10000,0)
RunService.RenderStepped:Wait()
if root and root.Parent then root.Velocity=vel end
RunService.Stepped:Wait()
if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
end
end)
table.insert(_wfConns,flingThread)
coroutine.resume(flingThread)
task.delay(0.1,function()
dropActive=false
for _,c in ipairs(_wfConns) do
if typeof(c)=="RBXScriptConnection" then c:Disconnect()
elseif type(c)=="thread" then pcall(coroutine.close,c) end
end
_wfConns={}
end)
end
local DROP_ASCEND_DURATION=0.22
local DROP_ASCEND_SPEED=160
local function runJumpDrop()
if dropActive then return end
local char=LP.Character;if not char then return end
local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
dropActive=true
local t0=tick()
if _dropConn then _dropConn:Disconnect() end
_dropConn=RunService.Heartbeat:Connect(function()
local c=LP.Character
local r=c and c:FindFirstChild("HumanoidRootPart")
if not r then if _dropConn then _dropConn:Disconnect(); _dropConn=nil end; dropActive=false; return end
if not dropActive then if _dropConn then _dropConn:Disconnect(); _dropConn=nil end; return end
if tick()-t0>=DROP_ASCEND_DURATION then
if _dropConn then _dropConn:Disconnect(); _dropConn=nil end
pcall(function()
local rp=RaycastParams.new(); rp.FilterDescendantsInstances={c}; rp.FilterType=Enum.RaycastFilterType.Exclude
local rr=workspace:Raycast(r.Position,Vector3.new(0,-3000,0),rp)
if rr then
local hum=c:FindFirstChildOfClass("Humanoid")
local off=((hum and hum.HipHeight) or 2)+(r.Size.Y/2)
r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
r.AssemblyLinearVelocity=Vector3.zero
end
end)
dropActive=false
return
end
local lv=r.AssemblyLinearVelocity
r.AssemblyLinearVelocity=Vector3.new(lv.X,DROP_ASCEND_SPEED,lv.Z)
end)
end
local function runDrop()
if currentDropType==DROP_TYPES.JUMP then runJumpDrop() else runStandDrop() end
end
local function doAutoTPDown(force)
local char=LP.Character;if not char then return end
local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
if not force then
if hum2.FloorMaterial~=Enum.Material.Air then return end
if hrp.Position.Y<autoTPHeight then return end
end
hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
hrp.AssemblyLinearVelocity=Vector3.zero
end
local function startAutoTP()
if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
autoTPConn=task.spawn(function()
while autoTPEnabled do task.wait(0.1); pcall(function() doAutoTPDown(false) end) end
end)
end
local function stopAutoTP()
autoTPEnabled=false
if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end
local function runTPFloor() pcall(function() doAutoTPDown(true) end) end
local defLightBrightness,defLightClock,defLightAmbient
local stretchFOV = 120
local stretchFovConn = nil
local function applyStretchFOV(val) local cam=workspace.CurrentCamera; if cam then pcall(function() cam.FieldOfView=val end) end end
local function enableStretchRez()
stretchRezEnabled=true
local cam=workspace.CurrentCamera; if not cam then return end
if stretchRezConn then stretchRezConn:Disconnect() end
if stretchFovConn then stretchFovConn:Disconnect() end
stretchFovConn=RunService.RenderStepped:Connect(function() if stretchRezEnabled then applyStretchFOV(stretchFOV) end end)
stretchRezConn=RunService.RenderStepped:Connect(function()
if not stretchRezEnabled then stretchRezConn:Disconnect();stretchRezConn=nil;return end
if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1) end
end)
end
local function disableStretchRez()
stretchRezEnabled=false
if stretchRezConn then stretchRezConn:Disconnect();stretchRezConn=nil end
if stretchFovConn then stretchFovConn:Disconnect();stretchFovConn=nil end
pcall(function() workspace.CurrentCamera.FieldOfView=70 end)
end
local normalFOV=180
local normalFovEnabled=false
local normalFovConn=nil
local function applyNormalFOV() local cam=workspace.CurrentCamera; if cam then pcall(function() cam.FieldOfView=normalFOV end) end end
local function enableNormalFOV()
normalFovEnabled=true
if normalFovConn then normalFovConn:Disconnect() end
normalFovConn=RunService.RenderStepped:Connect(function() if normalFovEnabled then applyNormalFOV() end end)
end
local function disableNormalFOV()
normalFovEnabled=false
if normalFovConn then normalFovConn:Disconnect();normalFovConn=nil end
pcall(function() workspace.CurrentCamera.FieldOfView=70 end)
end
local antiLagDefBrightness, antiLagDefFog, antiLagDefDiffuse, antiLagDefSpecular
local function applyAntiLagDerender(obj)
pcall(function()
if obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic; obj.Reflectance=0; obj.CastShadow=false
elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false
elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
end
end)
end
local function enableAntiLag()
removeAccessoriesEnabled=true; antiLagEnabled=true
antiLagDefBrightness = antiLagDefBrightness or Lighting.Brightness
antiLagDefFog = antiLagDefFog or Lighting.FogEnd
antiLagDefDiffuse = antiLagDefDiffuse or Lighting.EnvironmentDiffuseScale
antiLagDefSpecular = antiLagDefSpecular or Lighting.EnvironmentSpecularScale
Lighting.GlobalShadows=false; Lighting.FogEnd=1e10
Lighting.EnvironmentDiffuseScale=0; Lighting.EnvironmentSpecularScale=0
for _,e in pairs(Lighting:GetChildren()) do
pcall(function()
if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end
end)
end
for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
if antiLagDescConn then antiLagDescConn:Disconnect() end
antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if antiLagEnabled then applyAntiLagDerender(obj) end end)
end
local function disableAntiLag()
removeAccessoriesEnabled=false; antiLagEnabled=false
if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
pcall(function()
Lighting.GlobalShadows=true
if antiLagDefBrightness then Lighting.Brightness=antiLagDefBrightness end
if antiLagDefFog then Lighting.FogEnd=antiLagDefFog end
if antiLagDefDiffuse then Lighting.EnvironmentDiffuseScale=antiLagDefDiffuse end
if antiLagDefSpecular then Lighting.EnvironmentSpecularScale=antiLagDefSpecular end
for _,e in pairs(Lighting:GetChildren()) do
pcall(function()
if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=true end
end)
end
end)
end
local function findMedusa()
local c=LP.Character;if not c then return nil end
for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
local bp=LP:FindFirstChild("Backpack")
if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
return nil
end
local function useMedusaCounter()
if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
local c=LP.Character;if not c then return end;medusaDebounce=true
local med=findMedusa();if not med then medusaDebounce=false;return end
if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if part.Anchored and part.Transparency==1 then
if medusaCounterEnabled then useMedusaCounter() end
if _G._MedReset and _G._MedReset.enabled and not _G._MedReset.pending then
_G._MedReset.pending=true
task.delay(2.3,function() pcall(cursedInstaReset); task.wait(0.5); _G._MedReset.pending=false end)
end
end
end)
end
local function setupMedusa(char)
for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
if not char then return end
for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
end))
end
local function stopMedusaCounter()
for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
local c=LP.Character;if not c then return nil end
local bp=LP:FindFirstChildOfClass("Backpack")
for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end
end
for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
return nil
end
local function swingBatForCounter(bat,char)
local hum2=char:FindFirstChildOfClass("Humanoid")
if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remote and remote:IsA("RemoteEvent") then
pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
if Conns.batCounter then return end
Conns.batCounter=RunService.Heartbeat:Connect(function()
if not batCounterEnabled then return end
if batCounterDebounce then return end
local char=LP.Character;if not char then return end
local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
local st=hum2:GetState()
if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
batCounterDebounce=true
task.spawn(function()
local bat=findBatForCounter()
if bat then swingBatForCounter(bat,char) end
task.wait(0.5);batCounterDebounce=false
end)
end
end)
end
stopBatCounter=function()
if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
batCounterDebounce=false
end
local function getAutoBatTarget()
local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local now=tick()
if now-_autoBatLastScan<=0.1 and _autoBatTarget and _autoBatTarget.Parent then
local hum=_autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
if hum and hum.Health>0 then return _autoBatTarget end
end
_autoBatLastScan=now; _autoBatTarget=nil
local closest,minDist=nil,math.huge
for _,plr in ipairs(Players:GetPlayers()) do
if plr~=LP and plr.Character then
local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
local hum=plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health>0 then
local dist=(tRoot.Position-root.Position).Magnitude
if dist<minDist then minDist=dist;closest=tRoot end
end
end
end
_autoBatTarget=closest
return _autoBatTarget
end
resetAutoBatMotion=function()
local char=LP.Character
local hrp=char and char:FindFirstChild("HumanoidRootPart")
local hum=char and char:FindFirstChildOfClass("Humanoid")
if hrp then hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end
if hum then hum.AutoRotate=true; hum.PlatformStand=false; pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
local _autoTPWasEnabled=false
local function enableAutoBat()
if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
autoBatEquippedThisRun=false
autoBatEnabled=true
end
local function disableAutoBat()
autoBatEnabled=false; autoBatEquippedThisRun=false
local char=LP.Character
if char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate=true end end
if resetAutoBatMotion then resetAutoBatMotion() end
if _autoTPWasEnabled then _autoTPWasEnabled=false; autoTPEnabled=true; if setAutoTPVisual then setAutoTPVisual(true) end; startAutoTP() end
end
local function _offAntiBat() if antiBatActive then antiBatActive=false;if stopAntiBat then stopAntiBat() end;if setAntiBatVisual then setAntiBatVisual(false) end end end

do
local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0
_G.__MirrorTPClear = function() table.clear(mirrorTPPreviousY) end

local function mirrorTPAimbotActive() return (antiBatActive == true) or (_G._Dysnc and _G._Dysnc.enabled == true) end
local function mirrorTPTeleportDown()
	local character = LP.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return end
	local now = tick()
	if now - mirrorTPLastTeleport < 0.08 then return end
	mirrorTPLastTeleport = now
	local _, yaw = root.CFrame:ToEulerAnglesYXZ()
	root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
	root.Velocity = Vector3.zero
	pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
end
local MIRROR_TP_SAMPLE = 0.18
local mirrorTPLastSample = 0
RunService.Heartbeat:Connect(function()
	if not _G.__MirrorTPOn or not mirrorTPAimbotActive() then table.clear(mirrorTPPreviousY); return end
	local now = tick()
	if now - mirrorTPLastSample < MIRROR_TP_SAMPLE then return end
	mirrorTPLastSample = now
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local root = plr.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local currentY = root.Position.Y
				local previousY = mirrorTPPreviousY[plr.UserId]
				if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
					pcall(mirrorTPTeleportDown)
					table.clear(mirrorTPPreviousY)
					return
				end
				mirrorTPPreviousY[plr.UserId] = currentY
			end
		end
	end
end)
end
local function queueAutoLeftStart()
if _G.SafeModeTryStart and not _G.SafeModeTryStart() then return end
autoLeftEnabled=true; _offAntiBat()
if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
startAutoLeft()
end
local function queueAutoRightStart()
if _G.SafeModeTryStart and not _G.SafeModeTryStart() then return end
autoRightEnabled=true; _offAntiBat()
if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
startAutoRight()
end
local safeModeEnabled = true
local setSafeModeVisual = nil
do
local function getCountdownLabel()
    local ok, label = pcall(function()
        return LP.PlayerGui and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
        and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end
local function countdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end
local function inDuelCountdown()
    local label = getCountdownLabel()
    return (label and countdownNumber(label.Text)) or false
end
local function holdingBrainrot()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = LP.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then return true end
        end
    end
    return false
end
_G.SafeModeIsLocked = function()
    if not safeModeEnabled then return false end
    return inDuelCountdown() or holdingBrainrot()
end
_G.SafeModeForceStop = function()
    if autoBatEnabled then disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end
    if autoLeftEnabled then autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
end
_G.SafeModeTryStart = function()
    if _G.SafeModeIsLocked() then _G.SafeModeForceStop(); return false end
    return true
end
if not _G.__SafeModeMonitor then
    _G.__SafeModeMonitor = true
    RunService.Heartbeat:Connect(function()
        if safeModeEnabled and _G.SafeModeIsLocked() then _G.SafeModeForceStop() end
    end)
end
end
local function queueAutoBatStart()
if _G.SafeModeTryStart and not _G.SafeModeTryStart() then return end
_offAntiBat()
if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
enableAutoBat()
end
local speedBypassEnabled=false
local setSpeedBypassVisual=nil
local startSpeedBypass,stopSpeedBypass
_G._Bypass=_G._Bypass or {}
do
_G._Bypass.power=_G._Bypass.power or 72000
local skipCounter=0
local targetSkipFrames=1
local sbConn=nil
local function applyPower(val)
_G._Bypass.power=val
local mn,mx=50000,120000
local t=math.clamp((val-mn)/(mx-mn),0,1)
local lagAmount=math.clamp(t*0.2,0.01,0.5)
targetSkipFrames=math.floor(math.clamp(lagAmount*16,1,8))
end
_G._Bypass.applyPower=applyPower
applyPower(_G._Bypass.power)
startSpeedBypass=function()
if sbConn then sbConn:Disconnect() end
skipCounter=0
sbConn=RunService.Heartbeat:Connect(function()
if not speedBypassEnabled then return end
skipCounter=skipCounter+1
if skipCounter>=targetSkipFrames then skipCounter=0; RunService.Heartbeat:Wait() end
end)
end
stopSpeedBypass=function()
if sbConn then sbConn:Disconnect();sbConn=nil end
skipCounter=0
end
end
local SpeedMeter={Enabled=false,Labels={},Conns={}}
local function smAdd(p)
if p==LP then return end
local function apply(char)
if not char then return end
local head=char:WaitForChild("Head",5)
local hrp=char:FindFirstChild("HumanoidRootPart")
if not head or not hrp then return end
if SpeedMeter.Labels[p] then pcall(function() SpeedMeter.Labels[p].bb:Destroy() end) end
local bb=Instance.new("BillboardGui")
bb.Name="FearSpeedBB"; bb.Adornee=head; bb.Size=UDim2.new(0,100,0,30); bb.StudsOffset=Vector3.new(0,3.2,0); bb.AlwaysOnTop=true; bb.Parent=head
local lbl=Instance.new("TextLabel",bb)
lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text="0.0"
lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.Font=Enum.Font.GothamBlack; lbl.TextScaled=true
lbl.TextStrokeTransparency=0; lbl.TextStrokeColor3=Color3.new(0,0,0)
local conn=RunService.RenderStepped:Connect(function()
if not SpeedMeter.Enabled or not hrp or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity
local hspd=Vector3.new(v.X,0,v.Z).Magnitude
lbl.Text=string.format("%.1f",hspd)
end)
SpeedMeter.Labels[p]={bb=bb,conn=conn}
end
if p.Character then task.spawn(apply,p.Character) end
SpeedMeter.Conns[p]=p.CharacterAdded:Connect(apply)
end
local function smRemove(p)
local e=SpeedMeter.Labels[p]
if e then pcall(function() e.conn:Disconnect() end);pcall(function() e.bb:Destroy() end);SpeedMeter.Labels[p]=nil end
if SpeedMeter.Conns[p] then SpeedMeter.Conns[p]:Disconnect();SpeedMeter.Conns[p]=nil end
end
local function enableSpeedMeter()
if SpeedMeter.Enabled then return end
SpeedMeter.Enabled=true
for _,p in ipairs(Players:GetPlayers()) do smAdd(p) end
SpeedMeter.Conns._add=Players.PlayerAdded:Connect(smAdd)
SpeedMeter.Conns._rem=Players.PlayerRemoving:Connect(smRemove)
end
local function disableSpeedMeter()
if not SpeedMeter.Enabled then return end
SpeedMeter.Enabled=false
for _,e in pairs(SpeedMeter.Labels) do pcall(function() e.conn:Disconnect() end);pcall(function() e.bb:Destroy() end) end
for _,c in pairs(SpeedMeter.Conns) do pcall(function() c:Disconnect() end) end
SpeedMeter.Labels={};SpeedMeter.Conns={}
end
local BAT_AIM_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatAim()
local char=LP.Character
if not char then return nil end
for _,name in ipairs(BAT_AIM_LIST) do
local t=char:FindFirstChild(name)
if t and t:IsA("Tool") then return t end
end
local bp=LP:FindFirstChildOfClass("Backpack")
if bp then
for _,name in ipairs(BAT_AIM_LIST) do
local t=bp:FindFirstChild(name)
if t and t:IsA("Tool") then
local hum=char:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(t) end) end
return t
end
end
end
for _,ch in ipairs(char:GetChildren()) do
if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
end
return nil
end
local _aimHitCD=false
local AIM_SWING_CD=0.35
local AIM_HIT_DIST=8
local function trySwingAim()
if _aimHitCD then return end
_aimHitCD=true
pcall(function()
local char=LP.Character
if char then
local bat=findBatAim()
if bat then
if bat.Parent~=char then
local hum=char:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(bat) end) end
end
pcall(function() bat:Activate() end)
end
end
end)
task.delay(AIM_SWING_CD,function() _aimHitCD=false end)
end
RunService.RenderStepped:Connect(function()
if not autoBatEnabled then return end
local char=LP.Character; if not char then return end
local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
if not char:FindFirstChildOfClass("Tool") then
local bat=findBatAim()
if bat then pcall(function() hum:EquipTool(bat) end) end
end
local target=getAutoBatTarget()
if not target then hum.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero; return end
hum.AutoRotate=false
local myPos=root.Position
local targetPos=target.Position
local targetVel=target.AssemblyLinearVelocity
local predictPos=targetPos+targetVel*0.14
predictPos=predictPos+target.CFrame.LookVector*0.3
local direction=predictPos-myPos
local flatDir=Vector3.new(direction.X,0,direction.Z)
if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end
local chaseSpeed=aimbotSpeed
local desiredHeight=targetPos.Y+3.7
local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
yVel=math.clamp(yVel,-70,110)
local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
local speed3=targetVel.Magnitude
local predictTime=math.clamp(speed3/150,0.05,0.2)
local predictedPos=targetPos+targetVel*predictTime
local toPredict=predictedPos-myPos
if toPredict.Magnitude>0.1 then
local goalCF=CFrame.lookAt(myPos,predictedPos)
local diffCF=root.CFrame:Inverse()*goalCF
local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5)
root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42))
end
local targetDist=(targetPos-myPos).Magnitude
if targetDist<=AIM_HIT_DIST then trySwingAim() end
end)
local ANTI_DIE_HP=25
local _antiDieCD=false
RunService.Heartbeat:Connect(function()
if not autoBatEnabled or _antiDieCD then return end
local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if not hum then return end
if hum.Health>0 and hum.Health<=ANTI_DIE_HP then
_antiDieCD=true
pcall(cursedInstaReset)
task.delay(3,function() _antiDieCD=false end)
end
end)
do
local unwalkLoopConn = nil
function startUnwalk()
if not unwalkEnabled then return end
local char = LP.Character; if not char then return end
local animate = char:FindFirstChild("Animate")
local hum = char:FindFirstChildOfClass("Humanoid")
if animate then pcall(function() animate.Disabled = true end) end
if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end end
if unwalkLoopConn then unwalkLoopConn:Disconnect() end
unwalkLoopConn = RunService.RenderStepped:Connect(function()
if not unwalkEnabled then return end
local c = LP.Character
local h = c and c:FindFirstChildOfClass("Humanoid")
if not h then return end
for _,track in ipairs(h:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
end)
end
function stopUnwalk()
if unwalkLoopConn then unwalkLoopConn:Disconnect();unwalkLoopConn=nil end
local char = LP.Character
if char then
local animate = char:FindFirstChild("Animate")
if animate then pcall(function() animate.Disabled = false end) end
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end
end
end
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
setupSpeedIndicator(char)
if medusaCounterEnabled or _G._MedReset.enabled then setupMedusa(char) end
if batCounterEnabled then startBatCounter() end
if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then setupSpeedIndicator(LP.Character) end
local antiBatConn = nil
local antiBatHitCD = false
local function abx_getBat()
local char=LP.Character; if not char then return nil end
local tool=char:FindFirstChild("Bat")
if tool then return tool end
local bp=LP:FindFirstChild("Backpack")
if bp then local t=bp:FindFirstChild("Bat"); if t then t.Parent=char; return t end end
return nil
end
local function abx_tryHit()
if antiBatHitCD then return end
antiBatHitCD=true
pcall(function()
local bat=abx_getBat()
if bat then
bat:Activate()
local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
if ev then ev:FireServer() end
end
end)
task.delay(0.08,function() antiBatHitCD=false end)
end
local function abx_getClosest()
local char=LP.Character
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return nil,math.huge end
local cp,cd=nil,math.huge
for _,p in pairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local tr=p.Character:FindFirstChild("HumanoidRootPart")
if tr then
local d=(hrp.Position-tr.Position).Magnitude
if d<cd then cd=d;cp=p end
end
end
end
return cp,cd
end
local function startAntiBat()
if antiBatConn then antiBatConn:Disconnect() end
antiBatConn=RunService.RenderStepped:Connect(function()
if not antiBatActive then return end
local char=LP.Character
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local target,dist=abx_getClosest()
if target and target.Character then
local tr=target.Character:FindFirstChild("HumanoidRootPart")
if tr then
if _G.__Miro_batMode=="v2" then
local hum=char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if not char:FindFirstChildOfClass("Tool") then
local bat=findBatAim and findBatAim() or nil
if bat then pcall(function() hum:EquipTool(bat) end) end
end
hum.AutoRotate=false
local myPos=hrp.Position
local targetPos=tr.Position
local direction=targetPos-myPos
local flatDir=Vector3.new(direction.X,0,direction.Z)
if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end
local chaseSpeed=_G.__Miro_bypassSpeed or 58
local desiredHeight=targetPos.Y+3.7
local yVel=(desiredHeight-myPos.Y)*19.5
if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
yVel=math.clamp(yVel,-70,110)
local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
local toTarget=targetPos-myPos
if toTarget.Magnitude>0.1 then
local goalCF=CFrame.lookAt(myPos,targetPos)
local diffCF=hrp.CFrame:Inverse()*goalCF
local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5)
hrp.AssemblyAngularVelocity=hrp.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42))
end
if dist and dist<=8 then abx_tryHit() end
else
if sethiddenproperty then pcall(sethiddenproperty,hrp,"PhysicsRepRootPart",tr) end
local targetPos=tr.Position+Vector3.new(0,0.9,0)
if (hrp.Position-targetPos).Magnitude>8 then hrp.CFrame=CFrame.new(targetPos) end
local cam=workspace.CurrentCamera
if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,tr.Position) end
local fp=tr.Position+tr.CFrame.LookVector*1.5
local d=fp-hrp.Position
if d.Magnitude>0.01 then
local dir=d.Unit
hrp.Velocity=Vector3.new(dir.X*56.5,dir.Y*56.5,dir.Z*56.5)
end
abx_tryHit()
end
end
end
end)
end
stopAntiBat = function()
if antiBatConn then antiBatConn:Disconnect();antiBatConn=nil end
antiBatHitCD=false
local c=LP.Character
local root=c and c:FindFirstChild("HumanoidRootPart")
if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
local hum=c and c:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate=true end
end
toggleAntiBat = function()
antiBatActive=not antiBatActive
if antiBatActive and autoBatEnabled then autoBatEnabled=false;disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
if antiBatActive then startAntiBat() else stopAntiBat() end
if setAntiBatVisual then setAntiBatVisual(antiBatActive) end
end
local quickShape="Square"
local quickBtnSize=58
local function saveConfig()
local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
local cfg={
normalSpeed=NS,carrySpeed=CS,
dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),
speedToggleKey=ks(KB.SpeedToggle),antiBatKey=ks(KB.AntiBat),dysncKey=ks(KB.Dysnc),
grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,stealMode=Steal.Mode,halfFireRange=Steal.HalfFireRange,radiiNormal=(_G.__StealRadii and _G.__StealRadii.Normal) or 62,radiiSemi=(_G.__StealRadii and _G.__StealRadii.Semi) or 9,dropType=currentDropType,
antiRagdoll=antiRagdollEnabled,safeMode=safeModeEnabled,guiSize=0.55,introEnabled=(_G.__LonelyIntroOn~=false),autoStealEnabled=Steal.AutoStealEnabled,espEnabled=(espEnabled==true),
infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,medReset=_G._MedReset and _G._MedReset.enabled or false,
batCounter=batCounterEnabled,mirrorTPDown=(_G.__MirrorTPOn==true),
skyMode=_G.__SkyMode or "Vaporwave",animPack=selectedAnimationPack,carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,autoCarrySpeed=autoCarrySpeedEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,antiBat=antiBatActive,batMode=_G.__Miro_batMode or "bat",
unwalkEnabled=unwalkEnabled,speedBypass=speedBypassEnabled,
bodyLock=_G._BodyLock and _G._BodyLock.enabled or false,bodyLockRadius=_G._BodyLock and _G._BodyLock.radius or 20,
antiLag=antiLagEnabled,
autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
normalFovEnabled=normalFovEnabled,normalFov=normalFOV,
quickShape="Square",quickBtnSize=quickBtnSize,aimbotSpeed=aimbotSpeed,dysnc=_G._Dysnc and _G._Dysnc.enabled or false,
guiPos=_G._CursedGuiPos,
themeIndex=1,
quickHidden=(_G.__Miro_quickHidden==true),
autoResetOnDeath=(autoResetOnDeath==true)
}
if writefile then pcall(function() writefile("cursedPC.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local Vis={}
local Boxes={}
local function refreshSpeedModeLabel()
if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal") end
end
local function toggleCarryMode()
if laggerToggled then laggerToggled=false; laggerPhase=0; speedMode=true
else speedMode=not speedMode end
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.lagger then Vis.lagger(laggerToggled and laggerPhase>=1) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local function toggleLaggerMode()
if laggerToggled then laggerToggled=false; laggerPhase=0; speedMode=false
else speedMode=false; laggerToggled=true; laggerPhase=2 end
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.lagger then Vis.lagger(laggerToggled and laggerPhase>=1) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local function cycleLaggerBind()
speedMode=false; laggerToggled=true
if laggerPhase==2 then laggerPhase=1 else laggerPhase=2 end
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local selectedAnimationPack = "OFF"
local setAnimPackVisual = nil
local AnimationPacks = {
["Zombie"] = {idle = {"rbxassetid://616158929","rbxassetid://616158929"}, walk = "rbxassetid://616168032", run = "rbxassetid://616163682", jump = "rbxassetid://616161997", fall = "rbxassetid://616157476", climb = "rbxassetid://616156119"},
["Ninja"] = {idle = {"rbxassetid://656117400","rbxassetid://656117400"}, walk = "rbxassetid://656121766", run = "rbxassetid://656118852", jump = "rbxassetid://656117878", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359"},
["Knight"] = {idle = {"rbxassetid://657595757","rbxassetid://657595757"}, walk = "rbxassetid://657552124", run = "rbxassetid://657564596", jump = "rbxassetid://658409194", fall = "rbxassetid://657600338", climb = "rbxassetid://658360781"},
["Elder"] = {idle = {"rbxassetid://845397899","rbxassetid://845397899"}, walk = "rbxassetid://845403856", run = "rbxassetid://845386501", jump = "rbxassetid://845398858", fall = "rbxassetid://845397673", climb = "rbxassetid://845392038"},
["Levitate"] = {idle = {"rbxassetid://616006778","rbxassetid://616006778"}, walk = "rbxassetid://616013216", run = "rbxassetid://616013216", jump = "rbxassetid://616008936", fall = "rbxassetid://616005863", climb = "rbxassetid://616003713"},
["Astronaut"] = {idle = {"rbxassetid://891621366","rbxassetid://891621366"}, walk = "rbxassetid://891636393", run = "rbxassetid://891636393", jump = "rbxassetid://891627522", fall = "rbxassetid://891617961", climb = "rbxassetid://891609353"},
["Pirate"] = {idle = {"rbxassetid://750781874","rbxassetid://750781874"}, walk = "rbxassetid://750785693", run = "rbxassetid://750783738", jump = "rbxassetid://750782230", fall = "rbxassetid://750780242", climb = "rbxassetid://750779899"},
["Toy"] = {idle = {"rbxassetid://782841498","rbxassetid://782841498"}, walk = "rbxassetid://782843345", run = "rbxassetid://782842708", jump = "rbxassetid://782847020", fall = "rbxassetid://782846423", climb = "rbxassetid://782843869"},
["Vampire"] = {idle = {"rbxassetid://1083445855","rbxassetid://1083445855"}, walk = "rbxassetid://1083473930", run = "rbxassetid://1083462077", jump = "rbxassetid://1083455352", fall = "rbxassetid://1083443587", climb = "rbxassetid://1083439238"},
["Werewolf"] = {idle = {"rbxassetid://1083195517","rbxassetid://1083195517"}, walk = "rbxassetid://1083178339", run = "rbxassetid://1083216690", jump = "rbxassetid://1083218792", fall = "rbxassetid://1083189019", climb = "rbxassetid://1083182000"},
["Rthro"] = {idle = {"rbxassetid://2510196951","rbxassetid://2510196951"}, walk = "rbxassetid://2510202577", run = "rbxassetid://2510198475", jump = "rbxassetid://2510197830", fall = "rbxassetid://2510195892", climb = "rbxassetid://2510192778"},
["Stylish"] = {idle = {"rbxassetid://616136790","rbxassetid://616136790"}, walk = "rbxassetid://616146177", run = "rbxassetid://616140816", jump = "rbxassetid://616139451", fall = "rbxassetid://616134815", climb = "rbxassetid://616133594"},
}
local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}
local AnimationPackIndex = 1
local OriginalAnims = {}
local applyAnimationPack
do
local function getAnimate(char) char = char or LP.Character; return char and char:FindFirstChild("Animate") or nil end
local function stopCurrentAnimations(char)
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum then return end
for _, track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
end
local function backupAnimations(char)
local animate = getAnimate(char)
if not animate or next(OriginalAnims) ~= nil then return end
local function getId(obj) return obj and obj.AnimationId or nil end
OriginalAnims = {
idle1 = getId(animate.idle and animate.idle:FindFirstChild("Animation1")),
idle2 = getId(animate.idle and animate.idle:FindFirstChild("Animation2")),
walk  = getId(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
run   = getId(animate.run and animate.run:FindFirstChild("RunAnim")),
jump  = getId(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
fall  = getId(animate.fall and animate.fall:FindFirstChild("FallAnim")),
climb = getId(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
}
end
local function setAnimId(obj, id) if obj and id then pcall(function() obj.AnimationId = id end) end end
local function reloadAnimate(animate)
if not animate then return end
pcall(function() animate.Disabled = true; task.wait(); animate.Disabled = false end)
end
local function resetAnimations()
local char = LP.Character
local animate = getAnimate(char)
if not animate or next(OriginalAnims) == nil then return end
stopCurrentAnimations(char)
setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), OriginalAnims.idle1)
setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), OriginalAnims.idle2)
setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), OriginalAnims.walk)
setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), OriginalAnims.run)
setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), OriginalAnims.jump)
setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), OriginalAnims.fall)
setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), OriginalAnims.climb)
reloadAnimate(animate)
end
applyAnimationPack = function(packName)
selectedAnimationPack = packName or "OFF"
if selectedAnimationPack == "OFF" then resetAnimations(); return end
local pack = AnimationPacks[selectedAnimationPack]
local char = LP.Character
local animate = getAnimate(char)
if not pack or not animate then return end
backupAnimations(char)
stopCurrentAnimations(char)
setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle[1])
setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle[2])
setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
reloadAnimate(animate)
end
LP.CharacterAdded:Connect(function()
task.wait(1.2)
OriginalAnims = {}
if selectedAnimationPack ~= "OFF" then pcall(applyAnimationPack, selectedAnimationPack) end
end)
_G.__AnimPacks = {apply = function(n) pcall(applyAnimationPack, n) end}
end

local autoCarrySpeedEnabled = false
local setAutoCarrySpeedVisual = nil
do
local ACS = {fromSteal=false, graceUntil=0, returnMode=nil, waitPickup=false, watchUntil=0}
_G.__ACS = ACS
local function isCarryName(name)
local n=tostring(name or ""):lower()
return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold")
end
local function isIgnoredTool(name)
local n=tostring(name or ""):lower()
return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
end
local function isCarryingBrainrot(char)
if not char then return false end
for _,nm in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
local v=char:FindFirstChild(nm,true)
if v then
if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end
if v:IsA("StringValue") and v.Value~="" then return true end
end
end
for _,child in ipairs(char:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart",true) then
if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
if isCarryName(child.Name) then return true end
elseif child:IsA("Tool") and not isIgnoredTool(child.Name) then return true end
end
return false
end
local function currentModeName()
if laggerToggled then return (laggerPhase==2) and "LaggerCarry" or "LaggerNormal" end
return speedMode and "Carry" or "Normal"
end
local function pushVisuals()
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.lagger then Vis.lagger(laggerToggled and laggerPhase>=1) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local function enableCarryForSteal()
ACS.waitPickup=false; ACS.watchUntil=0
if not ACS.fromSteal then ACS.returnMode=currentModeName() end
ACS.fromSteal=true
ACS.graceUntil=tick()+0.75
local wasLagger = (ACS.returnMode=="LaggerNormal" or ACS.returnMode=="LaggerCarry" or laggerToggled)
if wasLagger then laggerToggled=true; laggerPhase=2; speedMode=false
else laggerToggled=false; laggerPhase=0; speedMode=true end
pushVisuals()
end
local function disableAutoCarry()
if not ACS.fromSteal and not ACS.waitPickup then return end
local wasApplied=ACS.fromSteal
local ret=ACS.returnMode
ACS.fromSteal=false; ACS.waitPickup=false
ACS.graceUntil=0; ACS.watchUntil=0; ACS.returnMode=nil
if not wasApplied then return end
if ret=="LaggerCarry" then laggerToggled=true; laggerPhase=2; speedMode=false
elseif ret=="LaggerNormal" then laggerToggled=true; laggerPhase=1; speedMode=false
elseif ret=="Carry" then laggerToggled=false; laggerPhase=0; speedMode=true
else laggerToggled=false; laggerPhase=0; speedMode=false end
pushVisuals()
end
local function watchPickup(sec)
if not autoCarrySpeedEnabled then return end
ACS.waitPickup=true
ACS.watchUntil=tick()+(sec or 1.25)
end
local _stealWas=false
RunService.RenderStepped:Connect(function()
if not autoCarrySpeedEnabled then
if ACS.fromSteal or ACS.waitPickup then disableAutoCarry() end
_stealWas=false
return
end
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local root=char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then disableAutoCarry(); _stealWas=false; return end
local st=hum:GetState()
local gotHit = st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
local stealingAttr = (LP:GetAttribute("Stealing")==true)
local carrying = isCarryingBrainrot(char)
if stealingAttr and not _stealWas then _stealWas=true; enableCarryForSteal()
elseif not stealingAttr then _stealWas=false end
if ACS.waitPickup then
if gotHit or tick()>(ACS.watchUntil or 0) then ACS.waitPickup=false; ACS.watchUntil=0
elseif carrying then enableCarryForSteal() end
end
if carrying and not ACS.fromSteal then enableCarryForSteal() end
if ACS.fromSteal then
local graceDone = tick()>(ACS.graceUntil or 0)
if gotHit or (graceDone and not carrying and not stealingAttr) then disableAutoCarry() end
end
end)
_G.AutoCarrySpeed = {
IsCarryingBrainrot = isCarryingBrainrot,
Enable = enableCarryForSteal,
Disable = disableAutoCarry,
WatchPickup = watchPickup,
}
end
local function toggleLaggerNormal()
if laggerToggled and laggerPhase==1 then laggerToggled=false;laggerPhase=0
else speedMode=false;laggerToggled=true;laggerPhase=1 end
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local function toggleLaggerCarry()
if laggerToggled and laggerPhase==2 then laggerToggled=false;laggerPhase=0
else speedMode=false;laggerToggled=true;laggerPhase=2 end
refreshSpeedModeLabel()
if Vis.carry then Vis.carry(speedMode) end
if Vis.laggerNormal then Vis.laggerNormal(laggerToggled and laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerToggled and laggerPhase==2) end
end
local mobilePanel = nil
local mainFrame = nil
local poppedFlags = {}
local function createMobilePanel()
if mobilePanel then return end
local gui = Instance.new("ScreenGui")
gui.Name = "CursedHubMobile"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 320)
mainFrame.Position = UDim2.new(1, -180, 0.5, -160)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
local quickButtons = {}
poppedFlags = {}
local function makeButtonDraggable(container, alreadyFree, innerBtn)
quickButtons[#quickButtons+1]=container
local dragging,dStart,startAbs,moved=false,nil,nil,false
local listenTarget=innerBtn or container
listenTarget.InputBegan:Connect(function(i)
if _G._CursedUILocked then return end
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
moved=false;dStart=i.Position
if container.Parent~=gui then
local absPos=container.AbsolutePosition
local inset=game:GetService("GuiService"):GetGuiInset()
container.AnchorPoint=Vector2.new(0,0)
container.Parent=gui
container.Position=UDim2.new(0,absPos.X,0,absPos.Y+inset.Y)
end
startAbs=container.Position
dragging=true
end
end)
UIS.InputChanged:Connect(function(i)
if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
local d=i.Position-dStart
if d.Magnitude>4 then moved=true end
container.Position=UDim2.new(0,startAbs.X.Offset+d.X,0,startAbs.Y.Offset+d.Y)
end
end)
UIS.InputEnded:Connect(function(i)
if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then
if dragging and moved then if _G._CursedSaveBtnPos then _G._CursedSaveBtnPos() end end
dragging=false
end
end)
end
local function createButton(text, isToggle, callback, initialActive)
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 58, 0, 58)
container.BackgroundColor3 = Color3.fromRGB(16,16,16)
container.BorderSizePixel = 0
container.Active = true
local _btnCorner=Instance.new("UICorner", container)
_btnCorner.CornerRadius = UDim.new(0,12)

local btnStroke = Instance.new("UIStroke", container)
btnStroke.Color = Color3.fromRGB(0,255,0)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.25

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,0,1,0)
btn.BackgroundTransparency = 1
btn.Text = text
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
btn.TextWrapped = true
btn.TextScaled = false
btn.AutoButtonColor = false
btn.Parent = container

local active = initialActive or false
local function setActive(state)
active = state
if isToggle then
local col = Color3.fromRGB(0,255,0)
container.BackgroundColor3 = active and col or Color3.fromRGB(15,12,15)
btnStroke.Color = active and col or Color3.fromRGB(0,255,0)
btnStroke.Transparency = active and 0.05 or 0.25
btn.TextColor3 = active and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
end
end

_G.__MiroQuickThemeButtons = _G.__MiroQuickThemeButtons or {}
table.insert(_G.__MiroQuickThemeButtons, {setActive = setActive, isActive = function() return active end, isToggle = isToggle, container = container, stroke = btnStroke, button = btn})

setActive(active)

btn.MouseButton1Down:Connect(function()
if not isToggle then
local col = Color3.fromRGB(0,255,0)
container.BackgroundColor3 = col
btnStroke.Color = col
btnStroke.Transparency = 0.05
btn.TextColor3 = Color3.fromRGB(0,0,0)
task.delay(0.15, function()
if container and container.Parent then
container.BackgroundColor3 = Color3.fromRGB(16,16,16)
btnStroke.Color = Color3.fromRGB(0,255,0)
btnStroke.Transparency = 0.25
btn.TextColor3 = Color3.fromRGB(255,255,255)
end
end)
end
end)

btn.MouseButton1Click:Connect(function()
if isToggle then
local newState = not active
setActive(newState)
if callback then callback(newState, setActive) end
else
if callback then callback(setActive) end
end
end)

return {BG = container, Btn = btn, setActive = setActive, isActive = function() return active end}
end
local row1 = Instance.new("Frame"); row1.Size = UDim2.new(1, 0, 0, 59); row1.BackgroundTransparency = 1; row1.Parent = mainFrame
local row1Layout = Instance.new("UIListLayout"); row1Layout.Parent = row1; row1Layout.FillDirection = Enum.FillDirection.Horizontal; row1Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; row1Layout.Padding = UDim.new(0, 12); row1Layout.SortOrder = Enum.SortOrder.LayoutOrder
local tpBtn = createButton("TP\nDOWN", false, function(setActive) runTPFloor() end, false)
local autoLeftBtn = createButton("AUTO\nLEFT", true, function(state, setActive)
autoLeftEnabled = not autoLeftEnabled
if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
setActive(autoLeftEnabled)
if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
saveConfig()
end, autoLeftEnabled)
local row2 = Instance.new("Frame"); row2.Size = UDim2.new(1, 0, 0, 59); row2.BackgroundTransparency = 1; row2.Parent = mainFrame
local row2Layout = Instance.new("UIListLayout"); row2Layout.Parent = row2; row2Layout.FillDirection = Enum.FillDirection.Horizontal; row2Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; row2Layout.Padding = UDim.new(0, 12); row2Layout.SortOrder = Enum.SortOrder.LayoutOrder
local autoRightBtn = createButton("AUTO\nRIGHT", true, function(state, setActive)
autoRightEnabled = not autoRightEnabled
if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
setActive(autoRightEnabled)
if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
saveConfig()
end, autoRightEnabled)
local dropBtn = createButton("DROP\nBR", false, function(setActive) runDrop() end, false)
local row3 = Instance.new("Frame"); row3.Size = UDim2.new(1, 0, 0, 59); row3.BackgroundTransparency = 1; row3.Parent = mainFrame
local row3Layout = Instance.new("UIListLayout"); row3Layout.Parent = row3; row3Layout.FillDirection = Enum.FillDirection.Horizontal; row3Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; row3Layout.Padding = UDim.new(0, 12); row3Layout.SortOrder = Enum.SortOrder.LayoutOrder
local carrySpeedBtn = createButton("CARRY\nSPEED", true, function(state, setActive)
toggleCarryMode(); saveConfig()
end, speedMode)
Vis.carry = function(s) carrySpeedBtn.setActive(s) end
local autoBatBtn = createButton("BAT\nAIMBOT", true, function(state, setActive)
autoBatEnabled = not autoBatEnabled
if autoBatEnabled then queueAutoBatStart() else disableAutoBat() end
setActive(autoBatEnabled)
if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
saveConfig()
end, autoBatEnabled)
local row4 = Instance.new("Frame"); row4.Size = UDim2.new(1, 0, 0, 59); row4.BackgroundTransparency = 1; row4.Parent = mainFrame
local row4Layout = Instance.new("UIListLayout"); row4Layout.Parent = row4; row4Layout.FillDirection = Enum.FillDirection.Horizontal; row4Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; row4Layout.Padding = UDim.new(0, 12); row4Layout.SortOrder = Enum.SortOrder.LayoutOrder
local antiBatBtn = createButton("ANTI BAT\nBYPASS", true, function(state, setActive)
toggleAntiBat(); setActive(antiBatActive)
end, antiBatActive)
local prevABV=setAntiBatVisual
setAntiBatVisual=function(s) if prevABV then prevABV(s) end; antiBatBtn.setActive(s) end
antiBatBtn.BG.Parent = gui
antiBatBtn.BG.AnchorPoint = Vector2.new(0,0)
antiBatBtn.BG.Position = UDim2.new(1, -250, 0.5, -102)
makeButtonDraggable(antiBatBtn.BG,false,antiBatBtn.Btn)
local instaResetBtn = createButton("INSTANT\nRESET", false, function(setActive) cursedInstaReset() end, false)
local laggerNormalBtn = createButton("LAGGER\nNORMAL", true, function(state, setActive)
toggleLaggerNormal(); saveConfig()
end, laggerToggled and laggerPhase == 1)
Vis.laggerNormal = function(s) laggerNormalBtn.setActive(s) end
local laggerCarryBtn = createButton("LAGGER\nCARRY", true, function(state, setActive)
toggleLaggerCarry(); saveConfig()
end, laggerToggled and laggerPhase == 2)
Vis.laggerCarry = function(s) laggerCarryBtn.setActive(s) end
Vis.lagger = function(s) laggerNormalBtn.setActive(s) end
dropBtn.BG.LayoutOrder=1; dropBtn.BG.Parent=row1
autoLeftBtn.BG.LayoutOrder=2; autoLeftBtn.BG.Parent=row1
autoBatBtn.BG.LayoutOrder=1; autoBatBtn.BG.Parent=row2
autoRightBtn.BG.LayoutOrder=2; autoRightBtn.BG.Parent=row2
tpBtn.BG.LayoutOrder=1; tpBtn.BG.Parent=row3
carrySpeedBtn.BG.LayoutOrder=2; carrySpeedBtn.BG.Parent=row3
laggerNormalBtn.BG.LayoutOrder=1; laggerNormalBtn.BG.Parent=row4
laggerCarryBtn.BG.LayoutOrder=2; laggerCarryBtn.BG.Parent=row4
instaResetBtn.BG.Parent = gui
instaResetBtn.BG.AnchorPoint = Vector2.new(0,0)
instaResetBtn.BG.Position = UDim2.new(1, -250, 0.5, -38)
makeButtonDraggable(dropBtn.BG,false,dropBtn.Btn); makeButtonDraggable(autoLeftBtn.BG,false,autoLeftBtn.Btn)
makeButtonDraggable(autoBatBtn.BG,false,autoBatBtn.Btn); makeButtonDraggable(autoRightBtn.BG,false,autoRightBtn.Btn)
makeButtonDraggable(carrySpeedBtn.BG,false,carrySpeedBtn.Btn); makeButtonDraggable(laggerNormalBtn.BG,false,laggerNormalBtn.Btn)
makeButtonDraggable(laggerCarryBtn.BG,false,laggerCarryBtn.Btn)
makeButtonDraggable(tpBtn.BG,false,tpBtn.Btn); makeButtonDraggable(instaResetBtn.BG,false,instaResetBtn.Btn)
_G._CursedAddQuickButton = createButton
_G._CursedMakeBtnDraggable = makeButtonDraggable
_G._CursedQuickRow4 = row4
_G._CursedMobileGui = gui
_G._CursedQuickLayout = {
{bg=dropBtn.BG,      row=row1, lo=1, id="dropBtn"},
{bg=autoLeftBtn.BG,  row=row1, lo=2, id="autoLeftBtn"},
{bg=autoBatBtn.BG,   row=row2, lo=1, id="autoBatBtn"},
{bg=autoRightBtn.BG, row=row2, lo=2, id="autoRightBtn"},
{bg=tpBtn.BG,        row=row3, lo=1, id="tpBtn"},
{bg=carrySpeedBtn.BG,row=row3, lo=2, id="carrySpeedBtn"},
{bg=laggerNormalBtn.BG,row=row4,lo=1, id="laggerNormalBtn"},
{bg=laggerCarryBtn.BG,row=row4, lo=2, id="laggerCarryBtn"},
{bg=instaResetBtn.BG,row=nil,  lo=1, id="instaResetBtn", standalone=true, defPos=UDim2.new(1, -250, 0.5, -38)},
{bg=antiBatBtn.BG,   row=nil,  lo=1, id="antiBatBtn", standalone=true, defPos=UDim2.new(1, -250, 0.5, -102)},
}
_G._CursedSetQuickVisible=function(v)
for _,e in ipairs(_G._CursedQuickLayout) do if e.bg then e.bg.Visible=v end end
end
_G._CursedSetQuickSize=function(v)
for _,e in ipairs(_G._CursedQuickLayout) do
if e.bg then
e.bg.Size=UDim2.new(0,v,0,v)
local b=e.bg:FindFirstChildOfClass("TextButton")
if b then b.TextSize=math.clamp(math.floor(v*0.21),8,18) end
end
end
end
_G._CursedSetQuickShape=function(shape)
for _,e in ipairs(_G._CursedQuickLayout) do
local c=e.bg and e.bg:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius=UDim.new(0,12) end
end
end
_G._CursedPoppedFlags = poppedFlags
_G._CursedSaveBtnPos = function()
if not writefile then return end
local pos={}
for _,entry in ipairs(_G._CursedQuickLayout) do
local bg=entry.bg
if bg and bg.Parent==gui then pos[entry.id]={x=bg.Position.X.Offset,y=bg.Position.Y.Offset} end
end
pcall(function() writefile("cursedBtnPos.json",HS:JSONEncode(pos)) end)
end
task.spawn(function()
if not(isfile and isfile("cursedBtnPos.json")) then return end
local ok,pos=pcall(function() return HS:JSONDecode(readfile("cursedBtnPos.json")) end)
if not ok or type(pos)~="table" then return end
task.wait(0.1)
for _,entry in ipairs(_G._CursedQuickLayout) do
local saved=pos[entry.id]
if saved then
local bg=entry.bg
local absPos=bg.AbsolutePosition
local inset=game:GetService("GuiService"):GetGuiInset()
bg.AnchorPoint=Vector2.new(0,0)
bg.Parent=gui
bg.Position=UDim2.new(0,saved.x,0,saved.y)
end
end
end)
local spacing = Instance.new("UIPadding"); spacing.PaddingTop = UDim.new(0, 10); spacing.PaddingBottom = UDim.new(0, 10); spacing.Parent = mainFrame
local layout = Instance.new("UIListLayout"); layout.Parent = mainFrame; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 12)
mobilePanel = gui
_updateMobileAutoLeft = autoLeftBtn.setActive
_updateMobileAutoRight = autoRightBtn.setActive
end
local function _ragTPGetOpponentPlot()
local char=LP.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
local plotsFolder=workspace:FindFirstChild("Plots")
if not root or not plotsFolder then return nil end
local best,bestDist=nil,math.huge
for _,plot in ipairs(plotsFolder:GetChildren()) do
if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
local ok,pivot=pcall(function() return plot:GetPivot() end)
if ok then
local dist=(root.Position-pivot.Position).Magnitude
if dist<bestDist then bestDist=dist;best=plot end
end
end
end
return best
end

local function _ragTPGetTarget(plot)
if not plot then return nil end
for _,name in ipairs({"DeliveryHitbox","Spawn","BaseSpawn","Main","Floor"}) do
local obj=plot:FindFirstChild(name,true)
if obj then
if obj:IsA("BasePart") then return obj.Position+Vector3.new(0,4,0) end
if obj:IsA("Attachment") then return obj.WorldPosition+Vector3.new(0,4,0) end
end
end
local ok,pivot=pcall(function() return plot:GetPivot() end)
if ok then return pivot.Position+Vector3.new(0,4,0) end
return nil
end

local function runAutomaticRagdollTP()
if not ragdollTPEnabled or tick()-_ragdollTPLast<1 then return end
local char=LP.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
local hum=char and char:FindFirstChildOfClass("Humanoid")
if not(root and hum and hum.Health>0) then return end
local target=_ragTPGetTarget(_ragTPGetOpponentPlot())
if not target then return end
_ragdollTPLast=tick()
pcall(function()
root.CFrame=CFrame.new(target)
root.AssemblyLinearVelocity=Vector3.zero
root.AssemblyAngularVelocity=Vector3.zero
end)
end

local function disconnectRagdollTP()
for _,conn in ipairs(_ragdollTPConns) do pcall(function() conn:Disconnect() end) end
_ragdollTPConns={}
end

local function setupRagdollTP(char)
disconnectRagdollTP()
if not ragdollTPEnabled or not char then return end
local hum=char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",3)
if not hum then return end
table.insert(_ragdollTPConns,hum.StateChanged:Connect(function(_,state)
if state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Physics then
task.defer(runAutomaticRagdollTP)
end
end))
end

LP.CharacterAdded:Connect(function(char)
if ragdollTPEnabled then task.delay(0.5,function() setupRagdollTP(char) end) end
end)

local function buildGui()
local BG    = Color3.fromRGB(0,0,0)
local BG2   = Color3.fromRGB(15,15,17)
local CARD  = Color3.fromRGB(24,24,26)
local HOV   = Color3.fromRGB(38,38,41)
local RED   = Color3.fromRGB(128,128,128)
local REDDIM= Color3.fromRGB(90,90,90)
local STROKE= Color3.fromRGB(128,128,128)
local W     = Color3.fromRGB(240,240,240)
local DIM   = Color3.fromRGB(150,150,150)
local INP   = Color3.fromRGB(17,17,19)
local OFF   = Color3.fromRGB(48,48,52)
local old=game:GetService("CoreGui"):FindFirstChild("CursedHub");if old then old:Destroy() end
local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("CursedHub");if o then o:Destroy() end end
local gui=Instance.new("ScreenGui")
gui.Name="CursedHub";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end
local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,440,0,640);main.AnchorPoint=Vector2.new(0,0.5);main.Position=UDim2.new(0,30,0.5,0)
main.BackgroundColor3=Color3.fromRGB(0,0,0);main.BackgroundTransparency=1;main.BorderSizePixel=0;main.ClipsDescendants=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,18)

-- Fondo negro solido (sin imagen)
local _bgImg=Instance.new("Frame",main)
_bgImg.Name="BGImage"
_bgImg.Size=UDim2.new(1,0,1,0)
_bgImg.Position=UDim2.new(0,0,0,0)
_bgImg.BackgroundColor3=Color3.fromRGB(0,0,0)
_bgImg.BackgroundTransparency=0
_bgImg.BorderSizePixel=0
_bgImg.ZIndex=0
Instance.new("UICorner",_bgImg).CornerRadius=UDim.new(0,18)

local _mainStroke=Instance.new("UIStroke",main);_mainStroke.Color=Color3.fromRGB(128,128,128);_mainStroke.Thickness=1;_mainStroke.Transparency=0.35

local _mainScale=Instance.new("UIScale",main)
_G.__Miro_guiSize = 0.55
_mainScale.Scale=0.55*0.9
TS:Create(_mainScale,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Scale=0.55}):Play()
_G.__Miro_setGuiSize=function(v)
_G.__Miro_guiSize=0.55
_mainScale.Scale=0.55
end

local function drag(f)
local dn,ds,sp,di=false
f.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dn=true;ds=i.Position;sp=f.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then
dn=false
if f==main then
_G._CursedGuiPos={f.Position.X.Scale,f.Position.X.Offset,f.Position.Y.Scale,f.Position.Y.Offset}
pcall(saveConfig)
end
end end)
end
end)
f.InputChanged:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
end)
UIS.InputChanged:Connect(function(i)
if i==di and dn then
local nX=sp.X.Offset+(i.Position.X-ds.X)
local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
end
end)
end
drag(main)
main.AnchorPoint=Vector2.new(0,0.5)
main.Position=UDim2.new(0,30,0.5,0)
local hdr=Instance.new("Frame",main)
hdr.Size=UDim2.new(1,0,0,46);hdr.BackgroundColor3=Color3.fromRGB(24,24,27);hdr.BackgroundTransparency=0.45;hdr.BorderSizePixel=0
hdr.ZIndex=2
Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,14)
local ttl=Instance.new("TextLabel",hdr)
ttl.Size=UDim2.new(1,-50,1,0);ttl.Position=UDim2.new(0,16,0,1)
ttl.BackgroundTransparency=1;ttl.Text="Parch3 Duels"
ttl.TextColor3=Color3.fromRGB(170,0,255);ttl.Font=Enum.Font.GothamBold;ttl.TextSize=19
ttl.TextXAlignment=Enum.TextXAlignment.Left
ttl.ZIndex=3
local _ttlGlow=Instance.new("UIStroke",ttl);_ttlGlow.Color=Color3.fromRGB(128,128,128);_ttlGlow.Thickness=1;_ttlGlow.Transparency=0.55

local closeBtn=Instance.new("TextButton",hdr)
closeBtn.Size=UDim2.new(0,28,0,28);closeBtn.Position=UDim2.new(1,-36,0.5,-14)
closeBtn.BackgroundColor3=Color3.fromRGB(20,20,22);closeBtn.BorderSizePixel=0
closeBtn.Text="—";closeBtn.TextColor3=DIM;closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=12
closeBtn.ZIndex=3
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)
local cbStroke=Instance.new("UIStroke",closeBtn);cbStroke.Color=Color3.fromRGB(128,128,128);cbStroke.Thickness=1;cbStroke.Transparency=0.5
closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(48,48,52),TextColor3=Color3.fromRGB(220,220,220)}):Play() end)
closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(20,20,22),TextColor3=DIM}):Play() end)
local hdrDiv=Instance.new("Frame",main)
hdrDiv.Size=UDim2.new(1,-24,0,1);hdrDiv.Position=UDim2.new(0,12,0,46)
hdrDiv.BackgroundColor3=Color3.fromRGB(128,128,128);hdrDiv.BackgroundTransparency=0.6;hdrDiv.BorderSizePixel=0;hdrDiv.ZIndex=3
local accentLine=Instance.new("Frame",main)
accentLine.Size=UDim2.new(0,44,0,2);accentLine.Position=UDim2.new(0,12,0,45)
accentLine.BackgroundColor3=Color3.fromRGB(128,128,128);accentLine.BorderSizePixel=0;accentLine.ZIndex=4
Instance.new("UICorner",accentLine).CornerRadius=UDim.new(1,0)

local MIRO_THEMES={{name="Gray",color=Color3.fromRGB(128,128,128),image=""}}
local _miroThemeIndex=1
local _miroThemeHooks={}
_Miro_onTheme=function(fn)
table.insert(_miroThemeHooks,fn)
pcall(fn,Color3.fromRGB(128,128,128))
end
local function applyMiroColorTheme(index)
_miroThemeIndex=1
_G.__Miro_themeIndex=1
local col=Color3.fromRGB(128,128,128)
_G.__Miro_curThemeCol=col
_ttlGlow.Color=col
_mainStroke.Color=col
hdrDiv.BackgroundColor3=col
accentLine.BackgroundColor3=col
cbStroke.Color=col
for _,fn in ipairs(_miroThemeHooks) do pcall(fn,col) end
if _G.__Miro_applyAutoGrabColor then pcall(_G.__Miro_applyAutoGrabColor,col) end
_G.__Miro_applyTheme=applyMiroColorTheme
if _G.__MiroQuickThemeButtons then
for _,entry in ipairs(_G.__MiroQuickThemeButtons) do
pcall(function()
if entry.isToggle then entry.setActive(entry.isActive())
elseif entry.container and entry.container.Parent then
entry.stroke.Color=Color3.fromRGB(0,255,0); entry.stroke.Transparency=0.25
entry.container.BackgroundColor3=Color3.fromRGB(15,12,15)
entry.button.TextColor3=Color3.fromRGB(255,255,255)
end
end)
end
end
pcall(function()
for _,obj in ipairs(main:GetDescendants()) do
if obj:IsA("UIStroke") then obj.Color=Color3.fromRGB(128,128,128)
elseif obj:IsA("TextButton") then
local bg=obj.BackgroundColor3
local brightness=(bg.R+bg.G+bg.B)/3
local isActive=brightness>0.28 and obj.BackgroundTransparency<0.9
if isActive then obj.BackgroundColor3=Color3.fromRGB(128,128,128); obj.TextColor3=Color3.fromRGB(16,16,18)
else obj.TextColor3=Color3.fromRGB(220,220,220) end
elseif obj:IsA("TextBox") then obj.TextColor3=Color3.fromRGB(220,220,220); obj.PlaceholderColor3=Color3.fromRGB(150,150,150)
elseif obj:IsA("ImageButton") then obj.ImageColor3=Color3.fromRGB(128,128,128)
elseif obj:IsA("Frame") then
local n=string.lower(obj.Name)
if n:find("accent") or n:find("fill") or n:find("indicator") or n:find("active") or n:find("selected") then obj.BackgroundColor3=Color3.fromRGB(128,128,128) end
end
end
end)
end
local TABS = {"Combat","Misc","Movement","Settings"}
local SECTION_TAB = {
Speed="Movement", Combat="Combat", Steal="Combat", Movement="Movement", Misc="Misc",
Visual="Settings", Keybinds="Settings", Interface="Settings", Sky="Settings", Animations="Settings", ["Intro Music"]="Settings",
}
local tabPanel=Instance.new("ImageLabel",main)
tabPanel.Size=UDim2.new(0,0,0,0);tabPanel.Position=UDim2.new(0,0,0,0)
tabPanel.BackgroundTransparency=1;tabPanel.Image=""
tabPanel.ScaleType=Enum.ScaleType.Crop;tabPanel.ImageTransparency=0;tabPanel.BorderSizePixel=0;tabPanel.ZIndex=1
Instance.new("UICorner",tabPanel).CornerRadius=UDim.new(0,12)
local _tpStroke=Instance.new("UIStroke",tabPanel);_tpStroke.Color=STROKE;_tpStroke.Thickness=1;_tpStroke.Transparency=0.5
local SIDEBAR_W = 132
local sidebar=Instance.new("Frame",main)
sidebar.Name="TabStrip"
sidebar.Size=UDim2.new(1,-24,0,38)
sidebar.Position=UDim2.new(0,12,0,50)
sidebar.BackgroundColor3=Color3.fromRGB(0,0,0)
sidebar.BackgroundTransparency=1
sidebar.BorderSizePixel=0;sidebar.ZIndex=4
Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,18)
local _sbStroke=Instance.new("UIStroke",sidebar);_sbStroke.Color=Color3.fromRGB(75,75,75);_sbStroke.Thickness=1;_sbStroke.Transparency=1
do
local rail=Instance.new("Frame",sidebar)
rail.Name="Rail";rail.Size=UDim2.new(1,-10,0,2);rail.Position=UDim2.new(0,5,1,0)
rail.BackgroundColor3=Color3.fromRGB(128,128,128);rail.BorderSizePixel=0;rail.ZIndex=3
Instance.new("UICorner",rail).CornerRadius=UDim.new(1,0)
end
local tabBar=Instance.new("Frame",sidebar)
tabBar.Size=UDim2.new(1,0,1,0);tabBar.Position=UDim2.new(0,0,0,0)
tabBar.BackgroundTransparency=1;tabBar.BorderSizePixel=0;tabBar.ZIndex=5
local tabLL=Instance.new("UIListLayout",tabBar)
tabLL.FillDirection=Enum.FillDirection.Horizontal;tabLL.SortOrder=Enum.SortOrder.LayoutOrder
tabLL.Padding=UDim.new(0,5);tabLL.HorizontalAlignment=Enum.HorizontalAlignment.Center
tabLL.VerticalAlignment=Enum.VerticalAlignment.Center
local statBox=Instance.new("Frame",main)
statBox.Name="StatBox";statBox.Size=UDim2.new(0,0,0,0);statBox.Position=UDim2.new(0,0,0,0);statBox.Visible=false
statBox.BackgroundColor3=Color3.fromRGB(18,16,22);statBox.BackgroundTransparency=0.15;statBox.BorderSizePixel=0;statBox.ZIndex=5
Instance.new("UICorner",statBox).CornerRadius=UDim.new(0,10)
local _statImg=Instance.new("ImageLabel",statBox)
_statImg.Size=UDim2.new(1,0,1,0);_statImg.BackgroundTransparency=1
_statImg.Image="rbxassetid://126465363386821";_statImg.ScaleType=Enum.ScaleType.Fit
_statImg.ImageTransparency=0.15;_statImg.ZIndex=5
Instance.new("UICorner",_statImg).CornerRadius=UDim.new(0,10)
local statStroke=Instance.new("UIStroke",statBox);statStroke.Color=Color3.fromRGB(60,50,80);statStroke.Thickness=1;statStroke.Transparency=0.3
local fpsLbl=Instance.new("TextLabel",statBox);fpsLbl.Size=UDim2.new(1,-16,0,20);fpsLbl.Position=UDim2.new(0,12,0,5)
fpsLbl.BackgroundTransparency=1;fpsLbl.Text="FPS: --";fpsLbl.TextColor3=Color3.fromRGB(255,255,255)
fpsLbl.Font=Enum.Font.GothamBold;fpsLbl.TextSize=12;fpsLbl.TextXAlignment=Enum.TextXAlignment.Left;fpsLbl.ZIndex=6
local pingLbl=Instance.new("TextLabel",statBox);pingLbl.Size=UDim2.new(1,-16,0,20);pingLbl.Position=UDim2.new(0,12,0,27)
pingLbl.BackgroundTransparency=1;pingLbl.Text="Ping: --";pingLbl.TextColor3=Color3.fromRGB(200,190,225)
pingLbl.Font=Enum.Font.GothamBold;pingLbl.TextSize=12;pingLbl.TextXAlignment=Enum.TextXAlignment.Left;pingLbl.ZIndex=6
task.spawn(function()
local frames,acc,fps=0,0,0
local fpsConn=RunService.RenderStepped:Connect(function(dt)
frames=frames+1;acc=acc+dt
if acc>=0.5 then fps=math.floor(frames/acc+0.5);frames=0;acc=0 end
end)
while statBox.Parent do
fpsLbl.Text="FPS: "..fps
local ping="--"
pcall(function() ping=math.floor(LP:GetNetworkPing()*1000).."ms" end)
pingLbl.Text="Ping: "..ping
task.wait(0.5)
end
fpsConn:Disconnect()
end)
local miniBtn=Instance.new("TextButton",gui)
miniBtn.Size=UDim2.new(0,108,0,28);miniBtn.Position=UDim2.new(0,26,0,26)
miniBtn.BackgroundColor3=BG2;miniBtn.BorderSizePixel=0
miniBtn.Text="Parch3 Duels";miniBtn.TextColor3=Color3.fromRGB(170,0,255);miniBtn.Font=Enum.Font.GothamBold;miniBtn.TextSize=11
miniBtn.ZIndex=20;miniBtn.Visible=false
Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
local miniStroke=Instance.new("UIStroke",miniBtn);miniStroke.Color=Color3.fromRGB(128,128,128);miniStroke.Thickness=1.2
drag(miniBtn)
miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=HOV}):Play() end)
miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2}):Play() end)
local function showGui()
main.Visible=true;miniBtn.Visible=false
_mainScale.Scale=0.55*0.9
TS:Create(_mainScale,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=0.55}):Play()
end
local function hideGui()
local tw=TS:Create(_mainScale,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.55*0.9})
tw:Play();tw.Completed:Wait()
main.Visible=false;miniBtn.Visible=false
end
closeBtn.MouseButton1Click:Connect(hideGui)
miniBtn.MouseButton1Click:Connect(showGui)

-- ===== MENU button on the LEFT side of the screen =====
local menuBtn=Instance.new("TextButton",gui)
menuBtn.Name="MenuBtn"
menuBtn.Size=UDim2.new(0,82,0,34)
menuBtn.Position=UDim2.new(0,12,0.5,-17)
menuBtn.BackgroundColor3=Color3.fromRGB(15,15,17)
menuBtn.BorderSizePixel=0
menuBtn.Text="MENU"
menuBtn.TextColor3=Color3.fromRGB(255,255,255)
menuBtn.Font=Enum.Font.GothamBold
menuBtn.TextSize=14
menuBtn.ZIndex=50
menuBtn.AutoButtonColor=false
Instance.new("UICorner",menuBtn).CornerRadius=UDim.new(0,8)
local menuStroke=Instance.new("UIStroke",menuBtn)
menuStroke.Color=Color3.fromRGB(255,255,255)
menuStroke.Thickness=1
menuStroke.Transparency=0.3
menuBtn.MouseEnter:Connect(function() TS:Create(menuBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(35,35,38)}):Play() end)
menuBtn.MouseLeave:Connect(function() TS:Create(menuBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(15,15,17)}):Play() end)
menuBtn.Activated:Connect(function()
if main.Visible then hideGui() else showGui() end
end)

local pages={}
local tabBtns={}
local currentTab=nil
local sf=Instance.new("ScrollingFrame",main)
sf.Size=UDim2.new(1,-26,1,-104);sf.Position=UDim2.new(0,13,0,96)
sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ClipsDescendants=true
sf.ScrollBarThickness=3;sf.ScrollBarImageColor3=REDDIM;sf.ScrollBarImageTransparency=0.35
sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
sf.ZIndex=2
local TAB_IDLE_TXT=Color3.fromRGB(150,150,150)
local function selectTab(name)
currentTab=name
for tn,pg in pairs(pages) do pg.Visible=(tn==name) end
local newPg=pages[name]
if newPg then
newPg.Position=UDim2.new(0,0,0,10)
for _,c in ipairs(newPg:GetChildren()) do
if c:IsA("GuiObject") then
local t0=c.BackgroundTransparency
c.BackgroundTransparency=1
TS:Create(c,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=t0}):Play()
end
end
TS:Create(newPg,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play()
end
for tn,b in pairs(tabBtns) do
local on=(tn==name)
TS:Create(b.bg,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundTransparency=on and 0.28 or 0.72,BackgroundColor3=Color3.fromRGB(5,5,8)}):Play()
TS:Create(b.lbl,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{TextColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,170,180)}):Play()
TS:Create(b.stroke,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Transparency=on and 0.05 or 0.52,Color=Color3.fromRGB(128,128,128)}):Play()
if b.fill then TS:Create(b.fill,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(0,0,1,0)}):Play() end
end
sf.CanvasPosition=Vector2.new(0,0)
end
for i,tn in ipairs(TABS) do
local bg=Instance.new("Frame",tabBar)
bg.Size=UDim2.new(0,(440-24-5*(#TABS-1))/#TABS,1,0);bg.BackgroundColor3=Color3.fromRGB(5,5,8);bg.BackgroundTransparency=0.72;bg.BorderSizePixel=0;bg.LayoutOrder=i;bg.ZIndex=5
bg.ClipsDescendants=true
Instance.new("UICorner",bg).CornerRadius=UDim.new(0,7)
local stroke=Instance.new("UIStroke",bg);stroke.Color=Color3.fromRGB(128,128,128);stroke.Thickness=1;stroke.Transparency=0.5
stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local fill=Instance.new("Frame",bg)
fill.Name="Fill";fill.Size=UDim2.new(0,0,1,0);fill.Position=UDim2.new(0,0,0,0)
fill.BackgroundColor3=Color3.fromRGB(128,128,128);fill.BorderSizePixel=0;fill.ZIndex=6
Instance.new("UICorner",fill).CornerRadius=UDim.new(0,4)
local lbl=Instance.new("TextLabel",bg);lbl.Size=UDim2.new(1,0,1,0);lbl.Position=UDim2.new(0,0,0,0);lbl.BackgroundTransparency=1
lbl.Text=tn;lbl.TextColor3=Color3.fromRGB(170,170,180);lbl.Font=Enum.Font.GothamBlack;lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Center;lbl.ZIndex=7
local b=Instance.new("TextButton",bg);b.Size=UDim2.new(1,0,1,0);b.BackgroundTransparency=1;b.Text="";b.ZIndex=8;b.AutoButtonColor=false
b.MouseEnter:Connect(function() if tn~=currentTab then TS:Create(lbl,TweenInfo.new(0.12),{TextColor3=Color3.fromRGB(210,210,210)}):Play() end end)
b.MouseLeave:Connect(function() if tn~=currentTab then TS:Create(lbl,TweenInfo.new(0.12),{TextColor3=TAB_IDLE_TXT}):Play() end end)
b.Activated:Connect(function() selectTab(tn) end)
tabBtns[tn]={bg=bg,lbl=lbl,stroke=stroke,fill=fill}
local pg=Instance.new("Frame",sf);pg.Name="Page_"..tn;pg.Size=UDim2.new(1,0,0,0)
pg.AutomaticSize=Enum.AutomaticSize.Y;pg.BackgroundTransparency=1;pg.BorderSizePixel=0;pg.Visible=false
local pll=Instance.new("UIListLayout",pg);pll.SortOrder=Enum.SortOrder.LayoutOrder;pll.Padding=UDim.new(0,8)
local ppad=Instance.new("UIPadding",pg)
ppad.PaddingLeft=UDim.new(0,7);ppad.PaddingRight=UDim.new(0,7)
ppad.PaddingTop=UDim.new(0,7);ppad.PaddingBottom=UDim.new(0,10)
pages[tn]=pg
end
local sfLL=Instance.new("UIListLayout",sf);sfLL.SortOrder=Enum.SortOrder.LayoutOrder
local lo=0
local function LO() lo=lo+1;return lo end
local curPage=pages[TABS[1]]
local function mkSect(txt)
local tab=SECTION_TAB[txt] or currentTab or TABS[1]
curPage=pages[tab]
local f=Instance.new("Frame",curPage);f.Size=UDim2.new(1,0,0,17);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO()
local tick=Instance.new("Frame",f);tick.Size=UDim2.new(0,10,0,2);tick.Position=UDim2.new(0,8,0.5,-1)
tick.BackgroundColor3=Color3.fromRGB(160,160,160);tick.BorderSizePixel=0
Instance.new("UICorner",tick).CornerRadius=UDim.new(1,0)
local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-30,1,0);l.Position=UDim2.new(0,24,0,0)
l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=Color3.fromRGB(135,135,145)
l.Font=Enum.Font.GothamBold;l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left
end
local function mkRow(h)
local f=Instance.new("Frame",curPage);f.Size=UDim2.new(1,-2,0,h or 40)
f.BackgroundColor3=Color3.fromRGB(255,255,255);f.BackgroundTransparency=0.82
f.BorderSizePixel=0;f.LayoutOrder=LO()
f.ZIndex=6
Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
local rs=Instance.new("UIStroke",f);rs.Color=Color3.fromRGB(255,255,255);rs.Thickness=1;rs.Transparency=0.6
f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundTransparency=0.72}):Play() end)
f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundTransparency=0.82}):Play() end)
return f
end
local function mkLabel(row,txt)
local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.58,0,1,0);l.Position=UDim2.new(0,11,0,0)
l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=Color3.new(1,1,1)
l.Font=Enum.Font.GothamBold;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left
l.ZIndex=8
end
local function mkPill(row,offset)
local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,34,0,18)
pill.Position=UDim2.new(1,-(offset or 56),0.5,-9)
pill.BackgroundColor3=Color3.fromRGB(24,24,30);pill.BackgroundTransparency=0.2
pill.BorderSizePixel=0;pill.ZIndex=3
Instance.new("UICorner",pill).CornerRadius=UDim.new(0,9)
local ps=Instance.new("UIStroke",pill);ps.Color=Color3.fromRGB(120,120,130);ps.Thickness=1;ps.Transparency=0.45
local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,13,0,13);dot.Position=UDim2.new(0,3,0.5,-6)
dot.BackgroundColor3=Color3.fromRGB(235,235,240);dot.BackgroundTransparency=0
dot.BorderSizePixel=0;dot.ZIndex=4
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
local shine=Instance.new("Frame",dot);shine.Size=UDim2.new(1,-4,0,4);shine.Position=UDim2.new(0,2,0,2)
shine.BackgroundColor3=Color3.fromRGB(255,255,255);shine.BackgroundTransparency=0.72
shine.BorderSizePixel=0;shine.ZIndex=5
Instance.new("UICorner",shine).CornerRadius=UDim.new(0,4)
return pill,dot
end
local function animPill(pill,dot,on)
TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{
BackgroundColor3=on and Color3.fromRGB(60,60,60) or Color3.fromRGB(24,24,30),
BackgroundTransparency=on and 0.03 or 0.2
}):Play()
local ps=pill:FindFirstChildOfClass("UIStroke")
if ps then
TS:Create(ps,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{
Color=on and Color3.fromRGB(220,220,220) or Color3.fromRGB(120,120,130),
Transparency=on and 0.05 or 0.45,
Thickness=on and 1.25 or 1
}):Play()
end
TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{
Position=on and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6)
}):Play()
end
espEnabled = false
do
local _espCam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() _espCam = workspace.CurrentCamera end)
local _espObjects = {}
local function _espHasDrawing() return typeof(Drawing) == "table" and Drawing.new ~= nil end
local function _espMake(p)
	if _espObjects[p] then return _espObjects[p] end
	if not _espHasDrawing() then return nil end
	local function ln()
		local l = Drawing.new("Line")
		l.Thickness = 1.5; l.Color = Color3.fromRGB(255,255,255)
		l.Transparency = 1; l.Visible = false; l.ZIndex = 2
		return l
	end
	local boxTop, boxBot, boxLeft, boxRight = ln(), ln(), ln(), ln()
	local tracer = Drawing.new("Line")
	tracer.Thickness = 1.5; tracer.Color = Color3.fromRGB(255,255,255)
	tracer.Transparency = 1; tracer.Visible = false; tracer.ZIndex = 1
	local o = {boxTop=boxTop, boxBot=boxBot, boxLeft=boxLeft, boxRight=boxRight, tracer=tracer}
	_espObjects[p] = o
	return o
end
local function _espClear(p)
	local o = _espObjects[p]
	if o then
		pcall(function() o.boxTop:Remove() end); pcall(function() o.boxBot:Remove() end)
		pcall(function() o.boxLeft:Remove() end); pcall(function() o.boxRight:Remove() end)
		pcall(function() o.tracer:Remove() end)
		_espObjects[p] = nil
	end
end
local function _espHideAll()
	for _, o in pairs(_espObjects) do
		pcall(function()
			o.boxTop.Visible=false; o.boxBot.Visible=false; o.boxLeft.Visible=false; o.boxRight.Visible=false; o.tracer.Visible=false
		end)
	end
end
Players.PlayerRemoving:Connect(function(p) _espClear(p) end)
RunService.RenderStepped:Connect(function()
	if not espEnabled or not _espHasDrawing() then if next(_espObjects) then _espHideAll() end; return end
	local cam = _espCam
	if not cam then return end
	local espThemeColor = Color3.fromRGB(255,255,255)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local o = _espMake(p)
			if o then
				pcall(function()
					o.boxTop.Color=espThemeColor; o.boxBot.Color=espThemeColor
					o.boxLeft.Color=espThemeColor; o.boxRight.Color=espThemeColor; o.tracer.Color=espThemeColor
				end)
				local char = p.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local head = char and char:FindFirstChild("Head")
				if char and hum and hrp and head and hum.Health > 0 then
					local topPos = (head.Position + Vector3.new(0, 0.8, 0))
					local botPos = (hrp.Position - Vector3.new(0, 3.2, 0))
					local topV, onT = cam:WorldToViewportPoint(topPos)
					local botV, onB = cam:WorldToViewportPoint(botPos)
					if (onT or onB) and topV.Z > 0 and botV.Z > 0 then
						local height = math.abs(botV.Y - topV.Y)
						local width  = height * 0.62
						local myCh = LP.Character
						local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
						if myHrp then
							local d = (myHrp.Position - hrp.Position).Magnitude
							local t = math.clamp((80 - d) / 80, 0, 1)
							local boost = 1 + (t * t) * 2.5
							height = height * boost; width  = width  * boost
						end
						local cx = (topV.X + botV.X) / 2
						local cy = (topV.Y + botV.Y) / 2
						local x1, x2 = cx - width/2, cx + width/2
						local y1, y2 = cy - height/2, cy + height/2
						o.boxTop.From   = Vector2.new(x1, y1); o.boxTop.To   = Vector2.new(x2, y1)
						o.boxBot.From   = Vector2.new(x1, y2); o.boxBot.To   = Vector2.new(x2, y2)
						o.boxLeft.From  = Vector2.new(x1, y1); o.boxLeft.To  = Vector2.new(x1, y2)
						o.boxRight.From = Vector2.new(x2, y1); o.boxRight.To = Vector2.new(x2, y2)
						o.boxTop.Visible=true; o.boxBot.Visible=true; o.boxLeft.Visible=true; o.boxRight.Visible=true
						local fromPt = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
						local myTorso = LP.Character and (LP.Character:FindFirstChild("UpperTorso") or LP.Character:FindFirstChild("Torso") or LP.Character:FindFirstChild("HumanoidRootPart"))
						if myTorso then
							local mv, onScr = cam:WorldToViewportPoint(myTorso.Position)
							if onScr then fromPt = Vector2.new(mv.X, mv.Y) end
						end
						o.tracer.From = fromPt
						o.tracer.To   = Vector2.new(botV.X, y2)
						o.tracer.Visible = true
					else
						o.boxTop.Visible=false; o.boxBot.Visible=false; o.boxLeft.Visible=false; o.boxRight.Visible=false; o.tracer.Visible=false
					end
				else
					o.boxTop.Visible=false; o.boxBot.Visible=false; o.boxLeft.Visible=false; o.boxRight.Visible=false; o.tracer.Visible=false
				end
			end
		end
	end
end)
end

local function mkToggle(txt,cb,initial)
local row=mkRow(40);mkLabel(row,txt)
local pill,dot=mkPill(row,56)
local on=initial==true
local function sv(s) on=s;animPill(pill,dot,s) end
animPill(pill,dot,on)
local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
clk.Activated:Connect(function() on=not on;sv(on);cb(on) end)
pill.ZIndex=3;dot.ZIndex=4
return sv
end
local function mkBox(parent,default,w,xOff,cb)
local tb=Instance.new("TextBox",parent)
tb.Size=UDim2.new(0,w or 50,0,22);tb.Position=UDim2.new(1,-(xOff or 56),0.5,-11)
tb.BackgroundColor3=INP;tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=W
tb.Font=Enum.Font.GothamBold;tb.TextSize=11;tb.ClearTextOnFocus=false;tb.ZIndex=5
Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(60,60,60);bs.Thickness=1
tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(200,200,200)}):Play() end)
tb.FocusLost:Connect(function()
TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(60,60,60)}):Play()
if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
end)
return tb
end
local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
local function isBindableInput(inp)
if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
end
local function kbMatch(entry,kc) return kc and (kc==entry.kb or (entry.gp and kc==entry.gp)) end
local function mkKB(parent,kbEntry,cb)
local btn=Instance.new("TextButton",parent)
btn.Size=UDim2.new(0,46,0,22);btn.Position=UDim2.new(1,-50,0.5,-11)
btn.BackgroundColor3=INP;btn.BorderSizePixel=0
local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
btn.Text=getLabel();btn.TextColor3=W
btn.Font=Enum.Font.GothamBold;btn.TextSize=9;btn.ZIndex=5
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
local li=false;local lc;local pv=btn.Text;local listenStart=0
btn.Activated:Connect(function()
if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
pv=btn.Text;li=true;_anyKeyListening=true;listenStart=tick();btn.Text="...";btn.TextColor3=W
lc=UIS.InputBegan:Connect(function(inp)
if not li then return end
if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
local isGp=isGamepadInput(inp)
if isGp and tick()-listenStart<0.15 then return end
if not isBindableInput(inp) then return end
btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=W
li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
if cb then cb(inp.KeyCode,isGp) end
end)
end)
return btn
end
local function mkToggleKB(txt,kbEntry,onToggle,onKB)
local row=mkRow(40);mkLabel(row,txt)
if kbEntry then mkKB(row,kbEntry,function(k,isGp)
if isGp then kbEntry.gp=k;kbEntry.kb=nil else kbEntry.kb=k;kbEntry.gp=nil end
if onKB then onKB(k,isGp) end
end) end
local pill,dot=mkPill(row,kbEntry and 102 or 42)
local on=false
local function sv(s) on=s;animPill(pill,dot,s) end
local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
pill.ZIndex=3;dot.ZIndex=4
return sv
end
local pbFrame=Instance.new("Frame",gui)
pbFrame.Visible=false
pbFrame.Size=UDim2.new(0,210,0,28);pbFrame.Position=UDim2.new(0.5,-105,0,140)
pbFrame.BackgroundColor3=BG2;pbFrame.BackgroundTransparency=1;pbFrame.BorderSizePixel=0;pbFrame.Active=true;pbFrame.ClipsDescendants=true
Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(0,19)
drag(pbFrame)
do
local downPos,moved=nil,false
pbFrame.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then downPos=i.Position;moved=false end
end)
pbFrame.InputChanged:Connect(function(i)
if downPos and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
if (i.Position-downPos).Magnitude>8 then moved=true end
end
end)
pbFrame.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
if downPos and not moved then if main.Visible then hideGui() else showGui() end end
downPos=nil
end
end)
end
local pbBase=Instance.new("Frame",pbFrame)
pbBase.Size=UDim2.new(1,0,1,0);pbBase.Position=UDim2.new(0,0,0,0)
pbBase.BackgroundColor3=Color3.fromRGB(17,17,20);pbBase.BackgroundTransparency=0.05;pbBase.BorderSizePixel=0;pbBase.ZIndex=0
Instance.new("UICorner",pbBase).CornerRadius=UDim.new(0,8)
local pbStroke=Instance.new("UIStroke",pbBase)
pbStroke.Color=Color3.fromRGB(60,60,60);pbStroke.Thickness=1;pbStroke.Transparency=0.3
progressPct=Instance.new("TextLabel",pbFrame)
progressPct.Size=UDim2.new(0,60,1,0);progressPct.Position=UDim2.new(0,10,0,0)
progressPct.BackgroundTransparency=1;progressPct.Text="0%";progressPct.TextColor3=W
progressPct.Font=Enum.Font.GothamBold;progressPct.TextSize=12;progressPct.TextXAlignment=Enum.TextXAlignment.Left;progressPct.ZIndex=3
local pbTrack=Instance.new("Frame",pbFrame)
pbTrack.Size=UDim2.new(1,-64,0,4);pbTrack.Position=UDim2.new(0,52,0.5,-2)
pbTrack.BackgroundColor3=Color3.fromRGB(32,32,38);pbTrack.BorderSizePixel=0;pbTrack.ZIndex=1
Instance.new("UICorner",pbTrack).CornerRadius=UDim.new(1,0)
progressFill=Instance.new("Frame",pbTrack)
progressFill.Size=UDim2.new(0,0,1,0);progressFill.BackgroundColor3=Color3.fromRGB(235,235,240);progressFill.BorderSizePixel=0;progressFill.ZIndex=2
Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)
progressRadLbl=Instance.new("TextLabel",pbFrame)
progressRadLbl.Visible=false
progressRadLbl.Size=UDim2.new(0,1,0,1);progressRadLbl.BackgroundTransparency=1;progressRadLbl.Text=""
mkSect("Speed")
setAutoCarrySpeedVisual=mkToggle("Auto Carry Speed",function(on)
autoCarrySpeedEnabled=on
if not on and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then pcall(_G.AutoCarrySpeed.Disable) end
saveConfig()
end)
do local row=mkRow(40);mkLabel(row,"Normal Speed");Boxes.normal=mkBox(row,NS,50,48,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) end
do local row=mkRow(40);mkLabel(row,"Carry Speed");Boxes.carry=mkBox(row,CS,50,48,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) end
do local row=mkRow(40);mkLabel(row,"Lagger Normal Speed");Boxes.lagger=mkBox(row,LAGGER_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) end
do local row=mkRow(40);mkLabel(row,"Lagger Carry Speed");Boxes.laggerCarry=mkBox(row,LAGGER_CARRY_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) end
do
local row=mkRow(40);mkLabel(row,"Mode")
modeValLbl=Instance.new("TextLabel",row)
modeValLbl.Size=UDim2.new(0,90,1,0);modeValLbl.Position=UDim2.new(1,-94,0,0)
modeValLbl.BackgroundTransparency=1;modeValLbl.Text="Normal";modeValLbl.TextColor3=Color3.fromRGB(200,200,200)
modeValLbl.Font=Enum.Font.GothamBlack;modeValLbl.TextSize=11;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode(); saveConfig() end)
end
mkSect("Combat")
do
local abRow=mkRow(40);mkLabel(abRow,"Bat Aimbot")
mkKB(abRow,KB.AutoBat,function(k,isGp)
if isGp then KB.AutoBat.gp=k;KB.AutoBat.kb=nil else KB.AutoBat.kb=k;KB.AutoBat.gp=nil end
saveConfig()
end)
local abPill,abDot=mkPill(abRow,102)
abPill.ZIndex=3;abDot.ZIndex=4
local abOn=false
local function svAutoBat(s) abOn=s;animPill(abPill,abDot,s) end
autoBatSetVisual=svAutoBat
local abClk=Instance.new("TextButton",abPill);abClk.Size=UDim2.new(1,0,1,0);abClk.BackgroundTransparency=1;abClk.Text="";abClk.ZIndex=5
abClk.Activated:Connect(function()
if _anyKeyListening then return end
abOn=not abOn;svAutoBat(abOn)
if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end
saveConfig()
end)
end
do
local abtRow=mkRow(40);mkLabel(abtRow,"Anti Bat")
mkKB(abtRow,KB.AntiBat,function(k,isGp)
if isGp then KB.AntiBat.gp=k;KB.AntiBat.kb=nil else KB.AntiBat.kb=k;KB.AntiBat.gp=nil end
saveConfig()
end)
local bseg=Instance.new("Frame",abtRow)
bseg.Size=UDim2.new(0,92,0,18);bseg.Position=UDim2.new(1,-150,0.5,-9)
bseg.BackgroundColor3=Color3.fromRGB(10,10,10);bseg.BorderSizePixel=0;bseg.ZIndex=3
Instance.new("UICorner",bseg).CornerRadius=UDim.new(0,5)
local bsegStroke=Instance.new("UIStroke",bseg);bsegStroke.Color=STROKE;bsegStroke.Thickness=1
local bBat=Instance.new("TextButton",bseg)
bBat.Size=UDim2.new(0.5,-2,1,-4);bBat.Position=UDim2.new(0,2,0,2)
bBat.BorderSizePixel=0;bBat.Text="Anti";bBat.Font=Enum.Font.GothamBold;bBat.TextSize=9;bBat.ZIndex=4;bBat.AutoButtonColor=false
Instance.new("UICorner",bBat).CornerRadius=UDim.new(0,4)
local bV2=Instance.new("TextButton",bseg)
bV2.Size=UDim2.new(0.5,-2,1,-4);bV2.Position=UDim2.new(0.5,0,0,2)
bV2.BorderSizePixel=0;bV2.Text="Bat V2";bV2.Font=Enum.Font.GothamBold;bV2.TextSize=9;bV2.ZIndex=4;bV2.AutoButtonColor=false
Instance.new("UICorner",bV2).CornerRadius=UDim.new(0,4)
local function paintBSeg()
local m1=(_G.__Miro_batMode~="v2")
bBat.BackgroundColor3=m1 and Color3.fromRGB(200,200,200) or Color3.fromRGB(10,10,10)
bBat.TextColor3=m1 and Color3.fromRGB(18,18,18) or DIM
bV2.BackgroundColor3=m1 and Color3.fromRGB(10,10,10) or Color3.fromRGB(200,200,200)
bV2.TextColor3=m1 and DIM or Color3.fromRGB(18,18,18)
end
paintBSeg()
bBat.Activated:Connect(function() _G.__Miro_batMode="bat";paintBSeg();saveConfig() end)
bV2.Activated:Connect(function() _G.__Miro_batMode="v2";paintBSeg();saveConfig() end)
local abtPill,abtDot=mkPill(abtRow,44)
abtPill.ZIndex=3;abtDot.ZIndex=4
local function svAntiBatRow(s) animPill(abtPill,abtDot,s) end
local prevABV2=setAntiBatVisual
setAntiBatVisual=function(s) if prevABV2 then prevABV2(s) end; svAntiBatRow(s) end
svAntiBatRow(antiBatActive)
local abtClk=Instance.new("TextButton",abtPill);abtClk.Size=UDim2.new(1,0,1,0);abtClk.BackgroundTransparency=1;abtClk.Text="";abtClk.ZIndex=5
abtClk.Activated:Connect(function() if _anyKeyListening then return end; toggleAntiBat(); saveConfig() end)
end
do local row=mkRow(40);mkLabel(row,"Aimbot Speed");mkBox(row,aimbotSpeed,50,48,function(v) if v>=10 and v<=200 then aimbotSpeed=v end;saveConfig() end) end
Vis.autoSwing=mkToggle("Auto Swing",function(on) autoSwingEnabled=on; saveConfig() end)
if Vis.autoSwing then Vis.autoSwing(autoSwingEnabled) end
do
setBatCounterVisual=mkToggle("Bat Counter",function(on) batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; saveConfig() end)
Vis.mirrorTPDown=mkToggle("Mirror TP Down",function(on) _G.__MirrorTPOn=on; if not on and _G.__MirrorTPClear then _G.__MirrorTPClear() end; saveConfig() end,_G.__MirrorTPOn==true)
end
mkSect("Auto Grab")
_G.__StealRadii = _G.__StealRadii or {Normal = Steal.StealRadius or 62, Semi = 9}
do
local row=mkRow(40);mkLabel(row,"Grab Radius")
Boxes.rad=mkBox(row,Steal.StealRadius,64,74,function(v)
if v>=5 and v<=300 then
Steal.StealRadius=v
_G.__StealRadii[(Steal.Mode=="half") and "Semi" or "Normal"]=v
if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end
end
saveConfig()
end)
end
do
local row=mkRow(40);mkLabel(row,"Grab Mode")
local seg=Instance.new("Frame",row)
seg.Size=UDim2.new(0,128,0,26);seg.Position=UDim2.new(1,-138,0.5,-13)
seg.BackgroundColor3=INP;seg.BorderSizePixel=0;seg.ZIndex=3
Instance.new("UICorner",seg).CornerRadius=UDim.new(0,6)
local bNormal=Instance.new("TextButton",seg)
bNormal.Size=UDim2.new(0.5,-2,1,-4);bNormal.Position=UDim2.new(0,2,0,2)
bNormal.BorderSizePixel=0;bNormal.Text="Normal";bNormal.Font=Enum.Font.GothamBold
bNormal.TextSize=10;bNormal.ZIndex=4;bNormal.AutoButtonColor=false
Instance.new("UICorner",bNormal).CornerRadius=UDim.new(0,5)
local bSemi=Instance.new("TextButton",seg)
bSemi.Size=UDim2.new(0.5,-2,1,-4);bSemi.Position=UDim2.new(0.5,0,0,2)
bSemi.BorderSizePixel=0;bSemi.Text="Semi";bSemi.Font=Enum.Font.GothamBold
bSemi.TextSize=10;bSemi.ZIndex=4;bSemi.AutoButtonColor=false
Instance.new("UICorner",bSemi).CornerRadius=UDim.new(0,5)
local function paint()
local semi=(Steal.Mode=="half")
bNormal.BackgroundColor3=semi and INP or Color3.fromRGB(128,128,128)
bNormal.TextColor3=semi and DIM or Color3.fromRGB(255,255,255)
bSemi.BackgroundColor3=semi and Color3.fromRGB(128,128,128) or INP
bSemi.TextColor3=semi and Color3.fromRGB(255,255,255) or DIM
end
local function setMode(mode)
if mode~="half" then mode="normal" end
_G.__StealRadii[(Steal.Mode=="half") and "Semi" or "Normal"]=Steal.StealRadius
Steal.Mode=mode
local key=(mode=="half") and "Semi" or "Normal"
local r=_G.__StealRadii[key] or ((mode=="half") and 9 or 62)
Steal.StealRadius=r
if Boxes.rad then Boxes.rad.Text=tostring(r) end
if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",r) end
paint()
saveConfig()
end
paint()
Vis.stealMode=paint
bNormal.Activated:Connect(function() setMode("normal") end)
bSemi.Activated:Connect(function() setMode("half") end)
end
do
local row=mkRow(40);mkLabel(row,"Auto Steal")
local pill,dot=mkPill(row,56)
local on=false
local function sv(s) on=s; animPill(pill,dot,s) end
Vis.instaGrab=sv
local clk=Instance.new("TextButton",row)
clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
clk.Activated:Connect(function()
on=not on; Steal.AutoStealEnabled=on; sv(on)
if on then
local ok=pcall(startAutoSteal)
if not ok then Steal.AutoStealEnabled=false; on=false; sv(false) end
else stopAutoSteal() end
saveConfig()
end)
end
do
local row=mkRow(40);mkLabel(row,"Grab Duration")
Boxes.stealDur=mkBox(row,Steal.StealDuration,64,74,function(v) if v>=0 and v<=5 then Steal.StealDuration=v end; saveConfig() end)
end
mkSect("Misc")
setSafeModeVisual=mkToggle("Safe Mode",function(on)
safeModeEnabled=on
if on and _G.SafeModeIsLocked and _G.SafeModeIsLocked() then if _G.SafeModeForceStop then _G.SafeModeForceStop() end end
saveConfig()
end)
if setSafeModeVisual then setSafeModeVisual(safeModeEnabled) end
do
local row=mkRow(40);mkLabel(row,"Instant Reset")
mkKB(row,KB.InstaReset,function(k,isGp) if isGp then KB.InstaReset.gp=k;KB.InstaReset.kb=nil else KB.InstaReset.kb=k;KB.InstaReset.gp=nil end;saveConfig() end)
local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
clk.Activated:Connect(function() cursedInstaReset() end)
end
Vis.resetOnDeath=mkToggle("Instant Reset on Death",function(on) autoResetOnDeath=on; saveConfig() end)
Vis.infJump=mkToggle("Infinite Jump",function(on) infJumpEnabled=on end)
Vis.infJumpMode=function() end
Vis.antiRag=mkToggle("Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end end)
Vis.esp=mkToggle("ESP (Box + Tracer)",function(on) espEnabled=on; saveConfig() end)
Vis.medusa=mkToggle("Medusa Counter",function(on)
medusaCounterEnabled=on
if on then setupMedusa(LP.Character)
elseif not _G._MedReset.enabled then stopMedusaCounter() end
saveConfig()
end)
Vis.medReset=mkToggle("Auto Reset on Medusa",function(on)
_G._MedReset.enabled=on
if on then setupMedusa(LP.Character)
elseif not medusaCounterEnabled then stopMedusaCounter() end
saveConfig()
end)
if Vis.medReset then Vis.medReset(_G._MedReset.enabled) end
Vis.unwalk=mkToggle("Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end end)
setSpeedBypassVisual=mkToggle("Speed Bypass",function(on) speedBypassEnabled=on; if on then startSpeedBypass() else stopSpeedBypass() end end)
Vis.bodyLockMisc=mkToggle("Body Lock",function(on) _G._BodyLock.enabled=on; if on then _G._BodyLock.start() else _G._BodyLock.stop() end; saveConfig() end)
if Vis.bodyLockMisc then Vis.bodyLockMisc(_G._BodyLock.enabled) end
do local row=mkRow(40);mkLabel(row,"Body Lock Radius");mkBox(row,_G._BodyLock.radius,50,48,function(v) if v>=1 and v<=100 then _G._BodyLock.radius=v end;saveConfig() end) end
mkSect("Visual")
Vis.antiLag=mkToggle("Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end; saveConfig() end)
Vis.normalFov=mkToggle("FOV",function(on) if on then enableNormalFOV() else disableNormalFOV() end; saveConfig() end)
do local row=mkRow(40);mkLabel(row,"FOV Value");mkBox(row,normalFOV,50,48,function(v) if v>=30 and v<=180 then normalFOV=v end;saveConfig() end) end
mkSect("Movement")
do local row=mkRow(40);mkLabel(row,"Speed Bind");mkKB(row,KB.SpeedToggle,function(k,isGp) if isGp then KB.SpeedToggle.gp=k;KB.SpeedToggle.kb=nil else KB.SpeedToggle.kb=k;KB.SpeedToggle.gp=nil end;saveConfig() end) end
do local row=mkRow(40);mkLabel(row,"Lagger Bind");mkKB(row,KB.LaggerToggle,function(k,isGp) if isGp then KB.LaggerToggle.gp=k;KB.LaggerToggle.kb=nil else KB.LaggerToggle.kb=k;KB.LaggerToggle.gp=nil end;saveConfig() end) end
do
local sv=mkToggleKB("Auto Left",KB.AutoLeft,
function(on) autoLeftEnabled=on; if on then queueAutoLeftStart() else stopAutoLeft() end end,
function(k,isGp) if isGp then KB.AutoLeft.gp=k;KB.AutoLeft.kb=nil else KB.AutoLeft.kb=k;KB.AutoLeft.gp=nil end;saveConfig() end)
autoLeftSetVisual=sv
end
do
local sv=mkToggleKB("Auto Right",KB.AutoRight,
function(on) autoRightEnabled=on; if on then queueAutoRightStart() else stopAutoRight() end end,
function(k,isGp) if isGp then KB.AutoRight.gp=k;KB.AutoRight.kb=nil else KB.AutoRight.kb=k;KB.AutoRight.gp=nil end;saveConfig() end)
autoRightSetVisual=sv
end
do
local row=mkRow(40);mkLabel(row,"Drop Brainrot")
mkKB(row,KB.DropBrainrot,function(k,isGp) if isGp then KB.DropBrainrot.gp=k;KB.DropBrainrot.kb=nil else KB.DropBrainrot.kb=k;KB.DropBrainrot.gp=nil end;saveConfig() end)
local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
clk.Activated:Connect(function() runDrop() end)
end
do
local row=mkRow(40);mkLabel(row,"Drop Type")
local ON_BG=Color3.fromRGB(200,200,200); local ON_TX=Color3.fromRGB(0,0,0)
local OFF_BG=Color3.fromRGB(12,12,12); local OFF_TX=Color3.fromRGB(192,192,192)
standDropBtn=Instance.new("TextButton",row)
standDropBtn.Size=UDim2.new(0,58,0,22);standDropBtn.Position=UDim2.new(1,-124,0.5,-11)
standDropBtn.BackgroundColor3=(currentDropType==DROP_TYPES.STAND) and ON_BG or OFF_BG;standDropBtn.BorderSizePixel=0
standDropBtn.Text="Stand";standDropBtn.TextColor3=(currentDropType==DROP_TYPES.STAND) and ON_TX or OFF_TX
standDropBtn.Font=Enum.Font.GothamBold;standDropBtn.TextSize=10;standDropBtn.ZIndex=3
Instance.new("UICorner",standDropBtn).CornerRadius=UDim.new(0,6)
jumpDropBtn=Instance.new("TextButton",row)
jumpDropBtn.Size=UDim2.new(0,58,0,22);jumpDropBtn.Position=UDim2.new(1,-62,0.5,-11)
jumpDropBtn.BackgroundColor3=(currentDropType==DROP_TYPES.JUMP) and ON_BG or OFF_BG;jumpDropBtn.BorderSizePixel=0
jumpDropBtn.Text="Jump";jumpDropBtn.TextColor3=(currentDropType==DROP_TYPES.JUMP) and ON_TX or OFF_TX
jumpDropBtn.Font=Enum.Font.GothamBold;jumpDropBtn.TextSize=10;jumpDropBtn.ZIndex=3
Instance.new("UICorner",jumpDropBtn).CornerRadius=UDim.new(0,6)
standDropBtn.Activated:Connect(function()
currentDropType=DROP_TYPES.STAND
standDropBtn.BackgroundColor3=ON_BG;standDropBtn.TextColor3=ON_TX
jumpDropBtn.BackgroundColor3=OFF_BG;jumpDropBtn.TextColor3=OFF_TX
pcall(saveConfig)
end)
jumpDropBtn.Activated:Connect(function()
currentDropType=DROP_TYPES.JUMP
jumpDropBtn.BackgroundColor3=ON_BG;jumpDropBtn.TextColor3=ON_TX
standDropBtn.BackgroundColor3=OFF_BG;standDropBtn.TextColor3=OFF_TX
pcall(saveConfig)
end)
end
do
local row=mkRow(40);mkLabel(row,"TP Down")
mkKB(row,KB.TPFloor,function(k,isGp) if isGp then KB.TPFloor.gp=k;KB.TPFloor.kb=nil else KB.TPFloor.kb=k;KB.TPFloor.gp=nil end;saveConfig() end)
local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
clk.Activated:Connect(function() runTPFloor() end)
end
do setAutoTPVisual=mkToggle("Auto TP",function(on) autoTPEnabled=on; if on then startAutoTP() else stopAutoTP() end; saveConfig() end) end
do local row=mkRow(40);mkLabel(row,"Auto TP Height");Boxes.autoTP=mkBox(row,autoTPHeight,50,56,function(v) if v>=0 and v<=500 then autoTPHeight=v else Boxes.autoTP.Text=tostring(autoTPHeight) end; saveConfig() end) end
mkSect("Interface")
Vis.introEnabled=mkToggle("Intro",function(on) _G.__LonelyIntroOn=on; saveConfig() end,_G.__LonelyIntroOn~=false)
-- (GUI Size fixed at 55% - no buttons, no +/- function)
Vis.hideQuick=mkToggle("Hide Quick Buttons",function(on)
_G.__Miro_quickHidden=on
if _G._CursedSetQuickVisible then _G._CursedSetQuickVisible(not on) end
saveConfig()
end)
-- (Button Shape removed - always Square)
do local row=mkRow(40);mkLabel(row,"Hide UI");mkKB(row,KB.GuiHide,function(k,isGp) if isGp then KB.GuiHide.gp=k;KB.GuiHide.kb=nil else KB.GuiHide.kb=k;KB.GuiHide.gp=nil end;saveConfig() end) end
do
local row=mkRow(40);mkLabel(row,"Reset Panel Position")
local btn=Instance.new("TextButton",row)
btn.Size=UDim2.new(0,80,0,22);btn.Position=UDim2.new(1,-86,0.5,-11)
btn.BackgroundColor3=Color3.fromRGB(90,90,90);btn.BorderSizePixel=0
btn.Text="Reset";btn.TextColor3=W;btn.Font=Enum.Font.GothamBold;btn.TextSize=11;btn.AutoButtonColor=false;btn.ZIndex=4
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
Instance.new("UIStroke",btn).Color=Color3.fromRGB(128,128,128)
btn.MouseEnter:Connect(function() TS:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(128,128,128)}):Play() end)
btn.MouseLeave:Connect(function() TS:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(90,90,90)}):Play() end)
btn.Activated:Connect(function()
if mainFrame then mainFrame.Position=UDim2.new(1,-180,0.5,-160) end
if _G._CursedQuickLayout then
for _,entry in ipairs(_G._CursedQuickLayout) do
pcall(function()
if entry.standalone then entry.bg.AnchorPoint=Vector2.new(0,0); entry.bg.Parent=gui; entry.bg.Position=entry.defPos
else entry.bg.AnchorPoint=Vector2.new(0,0); entry.bg.Position=UDim2.new(0,0,0,0); entry.bg.LayoutOrder=entry.lo; entry.bg.Parent=entry.row end
end)
end
end
pcall(function() if writefile then writefile("cursedBtnPos.json","{}") end end)
end)
end
do local row=mkRow(40);mkLabel(row,"Lock UI (buttons)");local p,d=mkPill(row);animPill(p,d,_G._CursedUILocked);local hit=Instance.new("TextButton",row);hit.Size=UDim2.new(1,0,1,0);hit.BackgroundTransparency=1;hit.Text="";hit.ZIndex=6;hit.Activated:Connect(function() _G._CursedUILocked=not _G._CursedUILocked;animPill(p,d,_G._CursedUILocked) end) end
mkSect("Sky")
do
local SKY_MODES = {"Off","Night","Galaxy","Blood Moon","Vaporwave"}
local skyBtns = {}
local function refreshSky(active)
for m,b in pairs(skyBtns) do
local on = (m==active)
TS:Create(b.bg,TweenInfo.new(0.12),{BackgroundColor3=on and Color3.fromRGB(128,128,128) or INP}):Play()
TS:Create(b.lbl,TweenInfo.new(0.12),{TextColor3=on and Color3.fromRGB(15,15,15) or W}):Play()
end
end
local function mkSkyRow(modes)
local row=mkRow(40)
local holder=Instance.new("Frame",row);holder.Size=UDim2.new(1,-12,1,-6);holder.Position=UDim2.new(0,6,0,3)
holder.BackgroundTransparency=1;holder.ZIndex=3
local hl=Instance.new("UIListLayout",holder);hl.FillDirection=Enum.FillDirection.Horizontal
hl.Padding=UDim.new(0,4);hl.HorizontalAlignment=Enum.HorizontalAlignment.Center;hl.VerticalAlignment=Enum.VerticalAlignment.Center
for i,m in ipairs(modes) do
local bg=Instance.new("Frame",holder);bg.Size=UDim2.new(0,(#modes==3 and 84 or 130),1,0)
bg.BackgroundColor3=INP;bg.BorderSizePixel=0;bg.LayoutOrder=i;bg.ZIndex=3
Instance.new("UICorner",bg).CornerRadius=UDim.new(0,6)
local lbl=Instance.new("TextLabel",bg);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1
lbl.Text=m;lbl.TextColor3=W;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.ZIndex=4
local b=Instance.new("TextButton",bg);b.Size=UDim2.new(1,0,1,0);b.BackgroundTransparency=1;b.Text="";b.ZIndex=5
b.Activated:Connect(function()
pcall(function() _G._FearSky.apply(m=="Off" and "Off" or m) end)
refreshSky(m); _G.__SkyMode=m; saveConfig()
end)
skyBtns[m]={bg=bg,lbl=lbl}
end
end
mkSkyRow({"Off","Night","Galaxy"})
mkSkyRow({"Blood Moon","Vaporwave"})
do
local savedSky=_G.__SkyMode or "Vaporwave"
pcall(function() _G._FearSky.apply(savedSky=="Off" and "Off" or savedSky) end)
refreshSky(savedSky)
end
end
mkSect("Animations")
do
local row=mkRow(40);mkLabel(row,"Anim Pack")
local box=Instance.new("Frame",row)
box.Size=UDim2.new(0,150,0,26);box.Position=UDim2.new(1,-160,0.5,-13)
box.BackgroundColor3=INP;box.BorderSizePixel=0;box.ZIndex=3
Instance.new("UICorner",box).CornerRadius=UDim.new(0,6)
local bs=Instance.new("UIStroke",box);bs.Color=Color3.fromRGB(60,60,60);bs.Thickness=1
local lbl=Instance.new("TextLabel",box)
lbl.Size=UDim2.new(1,-52,1,0);lbl.Position=UDim2.new(0,26,0,0);lbl.BackgroundTransparency=1
lbl.Text=selectedAnimationPack;lbl.TextColor3=W;lbl.Font=Enum.Font.GothamBold;lbl.TextSize=10;lbl.ZIndex=4
local function arrow(txt,xoff,dir)
local b=Instance.new("TextButton",box)
b.Size=UDim2.new(0,22,0,22);b.Position=UDim2.new(xoff==0 and 0 or 1,xoff==0 and 2 or -24,0.5,-11)
b.BackgroundColor3=BG2;b.BorderSizePixel=0
b.Text=txt;b.TextColor3=Color3.fromRGB(200,200,200);b.Font=Enum.Font.GothamBlack;b.TextSize=12
b.AutoButtonColor=false;b.ZIndex=5
Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
b.Activated:Connect(function()
AnimationPackIndex=AnimationPackIndex+dir
if AnimationPackIndex<1 then AnimationPackIndex=#AnimationPackList end
if AnimationPackIndex>#AnimationPackList then AnimationPackIndex=1 end
local name=AnimationPackList[AnimationPackIndex]
lbl.Text=name
if _G.__AnimPacks then _G.__AnimPacks.apply(name) end
saveConfig()
end)
end
arrow("<",0,-1); arrow(">",1,1)
setAnimPackVisual=function() lbl.Text=selectedAnimationPack end
if selectedAnimationPack and selectedAnimationPack~="OFF" then
lbl.Text=selectedAnimationPack
task.spawn(function() task.wait(0.6); if _G.__AnimPacks then pcall(_G.__AnimPacks.apply,selectedAnimationPack) end end)
end
end

UIS.InputBegan:Connect(function(input,gpe)
if _anyKeyListening then return end
if input.UserInputType==Enum.UserInputType.Keyboard then
if gpe or UIS:GetFocusedTextBox() then return end
elseif not isGamepadInput(input) then return end
if not isBindableInput(input) then return end
local kc=input.KeyCode
if kbMatch(KB.LaggerToggle,kc) then cycleLaggerBind(); saveConfig()
elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode(); saveConfig()
elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset()
elseif kbMatch(KB.AutoLeft,kc) then
autoLeftEnabled=not autoLeftEnabled
if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
if _updateMobileAutoLeft then _updateMobileAutoLeft(autoLeftEnabled) end
elseif kbMatch(KB.AutoRight,kc) then
autoRightEnabled=not autoRightEnabled
if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
if _updateMobileAutoRight then _updateMobileAutoRight(autoRightEnabled) end
elseif kbMatch(KB.AutoBat,kc) then
if not autoBatEnabled then queueAutoBatStart(); if autoBatSetVisual then autoBatSetVisual(true) end
else autoBatEnabled=false;disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end
elseif kbMatch(KB.Dysnc,kc) then
_G._Dysnc.enabled=not _G._Dysnc.enabled
if _G._Dysnc.enabled then _G._Dysnc.start() else _G._Dysnc.stop() end
if Vis.dysnc then Vis.dysnc(_G._Dysnc.enabled) end
saveConfig()
elseif kbMatch(KB.AntiBat,kc) then toggleAntiBat(); saveConfig()
elseif kbMatch(KB.GuiHide,kc) then if main.Visible then hideGui() else showGui() end end
end)
do
local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
if _oldSPG then _oldSPG:Destroy() end
local spScreenGui=Instance.new("ScreenGui")
spScreenGui.Name="StealProgressScreenGui"
spScreenGui.ResetOnSpawn=false
spScreenGui.DisplayOrder=200
spScreenGui.IgnoreGuiInset=true
spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
spScreenGui.Parent=LP.PlayerGui
local ACCENT      = Color3.fromRGB(0,255,0)
local ACCENT_DARK = Color3.fromRGB(0,150,0)
local WHITE       = Color3.fromRGB(255,255,255)
local DARK        = Color3.fromRGB(6,6,7)
local TRACK       = Color3.fromRGB(42,42,42)
local spFrame=Instance.new("Frame",spScreenGui)
spFrame.Name="StealProgressGui"
spFrame.Size=UDim2.new(0,340,0,38)
spFrame.Position=UDim2.new(0.5,0,1,-58)
spFrame.AnchorPoint=Vector2.new(0.5,1)
spFrame.BackgroundColor3=DARK
spFrame.BackgroundTransparency=0
spFrame.BorderSizePixel=0
spFrame.Active=true
spFrame.Visible=true
spFrame.ZIndex=300
Instance.new("UICorner",spFrame).CornerRadius=UDim.new(1,0)
local _spScale=Instance.new("UIScale",spFrame);_spScale.Scale=0.92
local spBorder=Instance.new("UIStroke",spFrame)
spBorder.Color=ACCENT
spBorder.Thickness=1.5
spBorder.Transparency=0.1
local statLbl=Instance.new("TextLabel",spFrame)
statLbl.Name="HudStat"; statLbl.Size=UDim2.new(0,104,1,0); statLbl.Position=UDim2.new(0,4,0,0)
statLbl.BackgroundTransparency=1; statLbl.Text="0 FPS | 0ms"; statLbl.TextColor3=WHITE
statLbl.Font=Enum.Font.GothamBold; statLbl.TextSize=10; statLbl.TextXAlignment=Enum.TextXAlignment.Center; statLbl.ZIndex=304
local divider=Instance.new("Frame",spFrame)
divider.Size=UDim2.new(0,1,0,14); divider.Position=UDim2.new(0,108,0.5,-7)
divider.BackgroundColor3=ACCENT; divider.BackgroundTransparency=0.5; divider.BorderSizePixel=0; divider.ZIndex=303
local center=Instance.new("Frame",spFrame)
center.Name="StealTrack"; center.Size=UDim2.new(0,220,1,-8); center.Position=UDim2.new(1,-225,0,4)
center.BackgroundColor3=TRACK; center.BorderSizePixel=0; center.ClipsDescendants=true; center.ZIndex=302
Instance.new("UICorner",center).CornerRadius=UDim.new(1,0)
local centerStroke=Instance.new("UIStroke",center)
centerStroke.Color=ACCENT; centerStroke.Thickness=1; centerStroke.Transparency=0.5
local spFill=Instance.new("Frame",center)
spFill.Name="ProgressFill"; spFill.Size=UDim2.new(0,0,1,0); spFill.BackgroundColor3=ACCENT; spFill.BorderSizePixel=0; spFill.ZIndex=303
Instance.new("UICorner",spFill).CornerRadius=UDim.new(1,0)
local fillGrad=Instance.new("UIGradient",spFill)
fillGrad.Color=ColorSequence.new(ACCENT,ACCENT_DARK); fillGrad.Rotation=90
local stealLbl=Instance.new("TextLabel",center)
stealLbl.Size=UDim2.new(1,-20,1,0); stealLbl.Position=UDim2.new(0,12,0,0)
stealLbl.BackgroundTransparency=1; stealLbl.Text="Parch3  |        Auto Steal"; stealLbl.TextColor3=WHITE
stealLbl.Font=Enum.Font.GothamBlack; stealLbl.TextSize=11; stealLbl.TextXAlignment=Enum.TextXAlignment.Left; stealLbl.ZIndex=305
local spPct=Instance.new("TextLabel",center)
spPct.Size=UDim2.new(0,60,1,0); spPct.Position=UDim2.new(1,-66,0,0)
spPct.BackgroundTransparency=1; spPct.Text="0%"; spPct.TextColor3=WHITE
spPct.Font=Enum.Font.GothamBold; spPct.TextSize=10; spPct.TextXAlignment=Enum.TextXAlignment.Right; spPct.ZIndex=305
local spRad=Instance.new("TextLabel",spFrame)
spRad.Size=UDim2.new(0,104,0,12); spRad.Position=UDim2.new(0,4,1,-13)
spRad.BackgroundTransparency=1; spRad.Text="Radius: "..tostring(Steal.StealRadius); spRad.TextColor3=WHITE
spRad.Font=Enum.Font.GothamBold; spRad.TextSize=8; spRad.TextXAlignment=Enum.TextXAlignment.Center; spRad.ZIndex=304
spRad.Visible=false
progressRadLbl=spRad
task.spawn(function()
while spFill and spFill.Parent do
local fw=TS:Create(fillGrad,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Offset=Vector2.new(0.5,0)}); fw:Play(); fw.Completed:Wait()
local bk=TS:Create(fillGrad,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Offset=Vector2.new(-0.5,0)}); bk:Play(); bk.Completed:Wait()
end
end)
local spToggleBtn=Instance.new("TextButton",spFrame)
spToggleBtn.Name="ToggleGUIBtn"; spToggleBtn.Size=UDim2.new(1,0,1,0); spToggleBtn.BackgroundTransparency=1
spToggleBtn.Text=""; spToggleBtn.AutoButtonColor=false; spToggleBtn.ZIndex=310; spToggleBtn.Active=true
progressFill=spFill
progressPct=spPct
local shownPct=0
RunService.RenderStepped:Connect(function()
if not spFrame.Visible then return end
local pct=0
if isStealing and stealStartTime then
if (_G.__FearStealProg or 0)>=1 then pct=1; shownPct=1
else
local duration=math.max((Semi and Semi.HoldMin) or Steal.HalfHoldMin or 1.3,0.01)
pct=math.clamp((tick()-stealStartTime)/duration,0,1)*0.5
end
end
shownPct=shownPct+(pct-shownPct)*0.18
local f=math.clamp(shownPct,0,1)
spFill.Size=UDim2.new(f,0,1,0)
spPct.Text=string.format("%d%%",math.floor(f*100+0.5))
end)
do
local frames,acc=0,0
RunService.RenderStepped:Connect(function(dt)
frames=frames+1;acc=acc+dt
if acc>=0.5 then
local fps=math.floor(frames/acc+0.5); frames=0;acc=0
local ping=0; pcall(function() ping=math.floor(LP:GetNetworkPing()*1000+0.5) end)
statLbl.Text=("%d FPS | %dms"):format(fps,ping)
end
end)
end
local function applyAutoGrabColor(col)
local green = Color3.fromRGB(0,255,0)
local white = Color3.fromRGB(255,255,255)
ACCENT = green
spBorder.Color=green
statLbl.TextColor3=white
divider.BackgroundColor3=green
centerStroke.Color=green
stealLbl.TextColor3=white
spPct.TextColor3=white
spRad.TextColor3=white
spFill.BackgroundColor3=green
fillGrad.Color=ColorSequence.new(green,Color3.fromRGB(0,150,0))
end
_G.__Miro_applyAutoGrabColor=applyAutoGrabColor
local _spWasDragged=false
local dragging,dragStart,startPos=false,nil,nil
spToggleBtn.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
end
end)
UIS.InputChanged:Connect(function(inp)
if not dragging then return end
if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
local d=inp.Position-dragStart
if math.abs(d.X)>5 or math.abs(d.Y)>5 then _spWasDragged=true end
spFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
end
end)
_G._CursedSetProgressBarVisible=function(v) spFrame.Visible=v end
end
task.defer(function() applyMiroColorTheme(1) end)
selectTab(TABS[1])
end
local _savedCfg = nil
local function loadConfigKeys()
if not readfile then return end
local ok,cfg=pcall(function() return HS:JSONDecode(readfile("cursedPC.json")) end)
if not ok or type(cfg)~="table" then return end
_savedCfg=cfg
if type(cfg.skyMode)=="string" then _G.__SkyMode=cfg.skyMode end
if type(cfg.introEnabled)=="boolean" then _G.__LonelyIntroOn=cfg.introEnabled end
if type(cfg.animPack)=="string" then
selectedAnimationPack=cfg.animPack
for i,n in ipairs(AnimationPackList) do if n==cfg.animPack then AnimationPackIndex=i break end end
end
local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey)
lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey);lk(KB.AntiBat,cfg.antiBatKey);lk(KB.Dysnc,cfg.dysncKey)
_G.__Miro_themeIndex=1
if cfg.autoResetOnDeath~=nil then autoResetOnDeath=(cfg.autoResetOnDeath==true) end
if cfg.normalSpeed then NS=cfg.normalSpeed end
if cfg.carrySpeed then CS=cfg.carrySpeed end
if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=8 end
if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=0.1 end
if cfg.stealMode=="half" or cfg.stealMode=="normal" then Steal.Mode=cfg.stealMode end
_G.__StealRadii=_G.__StealRadii or {Normal=62,Semi=9}
if type(cfg.radiiNormal)=="number" then _G.__StealRadii.Normal=cfg.radiiNormal end
if type(cfg.radiiSemi)=="number" then _G.__StealRadii.Semi=cfg.radiiSemi end
Steal.StealRadius=_G.__StealRadii[(Steal.Mode=="half") and "Semi" or "Normal"] or Steal.StealRadius
if cfg.dropType==DROP_TYPES.STAND or cfg.dropType==DROP_TYPES.JUMP then currentDropType=cfg.dropType end
if tonumber(cfg.halfFireRange) and cfg.halfFireRange>=1 and cfg.halfFireRange<=100 then Steal.HalfFireRange=cfg.halfFireRange end
if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
if cfg.infJumpMode=="tap" or cfg.infJumpMode=="hold" then infJumpMode=cfg.infJumpMode end
if type(cfg.guiPos)=="table" and #cfg.guiPos==4 then _G._CursedGuiPos=cfg.guiPos end
quickShape="Square"
quickBtnSize=58
if tonumber(cfg.aimbotSpeed) and cfg.aimbotSpeed>=10 and cfg.aimbotSpeed<=200 then aimbotSpeed=cfg.aimbotSpeed end
if tonumber(cfg.bodyLockRadius) and cfg.bodyLockRadius>=1 and cfg.bodyLockRadius<=200 then _G._BodyLock.radius=cfg.bodyLockRadius end
end
local function loadConfigState()
local cfg=_savedCfg;if not cfg then return end
if Boxes.normal then Boxes.normal.Text=tostring(NS) end
if Boxes.carry then Boxes.carry.Text=tostring(CS) end
if Boxes.rad then Boxes.rad.Text=tostring(Steal.StealRadius) end
if Boxes.stealDur then Boxes.stealDur.Text=tostring(Steal.StealDuration) end
if Boxes.halfRange then Boxes.halfRange.Text=tostring(Steal.HalfFireRange) end
if Vis.stealMode then Vis.stealMode() end
if standDropBtn and jumpDropBtn then
local isStand=(currentDropType==DROP_TYPES.STAND)
local onB,onT=Color3.fromRGB(200,200,200),Color3.fromRGB(0,0,0)
local offB,offT=Color3.fromRGB(12,12,12),Color3.fromRGB(192,192,192)
standDropBtn.BackgroundColor3=isStand and onB or offB;standDropBtn.TextColor3=isStand and onT or offT
jumpDropBtn.BackgroundColor3=isStand and offB or onB;jumpDropBtn.TextColor3=isStand and offT or onT
end
if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end
if Boxes.lagger then Boxes.lagger.Text=tostring(LAGGER_SPEED) end
if Boxes.laggerCarry then Boxes.laggerCarry.Text=tostring(LAGGER_CARRY_SPEED) end
if Boxes.autoTP then Boxes.autoTP.Text=tostring(autoTPHeight) end
task.spawn(function()
task.wait(0.15)
if autoResetOnDeath and Vis.resetOnDeath then Vis.resetOnDeath(true) end
if cfg.safeMode ~= nil then safeModeEnabled = (cfg.safeMode == true) else safeModeEnabled = true end
if cfg.autoCarrySpeed then autoCarrySpeedEnabled=true;if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(true) end end
if selectedAnimationPack and selectedAnimationPack~="OFF" and _G.__AnimPacks then
task.spawn(function() task.wait(1.5); pcall(function() _G.__AnimPacks.apply(selectedAnimationPack) end) end)
end
if setAnimPackVisual then setAnimPackVisual() end
if setSafeModeVisual then setSafeModeVisual(safeModeEnabled) end
_G.__Miro_guiSize=0.55
if _G.__Miro_setGuiSize then _G.__Miro_setGuiSize(0.55) end
if cfg.antiRagdoll then antiRagdollEnabled=true;if Vis.antiRag then Vis.antiRag(true) end;startAntiRagdoll() end
if cfg.espEnabled then espEnabled=true;if Vis.esp then Vis.esp(true) end end
if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if Vis.instaGrab then Vis.instaGrab(true) end;pcall(startAutoSteal) end
if cfg.infiniteJump then infJumpEnabled=true;if Vis.infJump then Vis.infJump(true) end end
if cfg.medusaCounter then medusaCounterEnabled=true;if Vis.medusa then Vis.medusa(true) end;setupMedusa(LP.Character) end
if cfg.medReset then _G._MedReset.enabled=true;if Vis.medReset then Vis.medReset(true) end;setupMedusa(LP.Character) end
if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
if cfg.mirrorTPDown then _G.__MirrorTPOn=true;if Vis.mirrorTPDown then Vis.mirrorTPDown(true) end end
if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
if Vis.laggerNormal then Vis.laggerNormal(laggerPhase==1) end
if Vis.laggerCarry then Vis.laggerCarry(laggerPhase==2) end
elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
if cfg.normalFov and type(cfg.normalFov)=="number" and cfg.normalFov>=30 and cfg.normalFov<=180 then normalFOV=cfg.normalFov end
if cfg.normalFovEnabled then enableNormalFOV();if Vis.normalFov then Vis.normalFov(true) end end
if Vis.autoSwing then Vis.autoSwing(autoSwingEnabled) end
if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
if cfg.batMode=="v2" or cfg.batMode=="bat" then _G.__Miro_batMode=cfg.batMode end
if cfg.antiBat then antiBatActive=true;startAntiBat();if setAntiBatVisual then setAntiBatVisual(true) end end
if cfg.unwalkEnabled then unwalkEnabled=true;if Vis.unwalk then Vis.unwalk(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
if cfg.bodyLock then _G._BodyLock.enabled=true;_G._BodyLock.start();if Vis.bodyLockMisc then Vis.bodyLockMisc(true) end end
if cfg.quickHidden then
_G.__Miro_quickHidden=true
if Vis.hideQuick then Vis.hideQuick(true) end
if _G._CursedSetQuickVisible then _G._CursedSetQuickVisible(false) end
end
if cfg.speedBypass then speedBypassEnabled=true;startSpeedBypass();if setSpeedBypassVisual then setSpeedBypassVisual(true) end end
if cfg.antiLag then enableAntiLag();if Vis.antiLag then Vis.antiLag(true) end end
end)
end
loadConfigKeys()
task.spawn(function()
	if _G.__LonelyIntroOn == false then return end
	local URL  = "https://files.catbox.moe/6eigoh.mp3"
	local FILE = "lonely_intro_song5.mp3"
	local IMG  = "rbxassetid://100798770814254"
	local sound = Instance.new("Sound")
	sound.Name = "LonelyIntroMusic"; sound.Volume = 1.6; sound.Looped = false
	sound.Parent = game:GetService("SoundService")
	pcall(function()
		if isfile and isfile(FILE) and getcustomasset then sound.SoundId = getcustomasset(FILE)
		elseif syn and syn.request or request or http_request then
			local req = (syn and syn.request) or request or http_request
			local res = req({Url = URL, Method = "GET"})
			if res and res.Body and writefile and getcustomasset then writefile(FILE, res.Body); sound.SoundId = getcustomasset(FILE) end
		end
	end)
	pcall(function() sound:Play() end)
	local sg = Instance.new("ScreenGui")
	sg.Name = "LonelyIntro"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.DisplayOrder = 999
	pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
	if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end
	local dim = Instance.new("Frame", sg)
	dim.Size = UDim2.new(1,0,1,0); dim.BackgroundColor3 = Color3.fromRGB(0,0,0); dim.BackgroundTransparency = 1; dim.BorderSizePixel = 0; dim.ZIndex = 1
	local img = Instance.new("ImageLabel", sg)
	img.Size = UDim2.new(1,0,1,0); img.BackgroundTransparency = 1; img.Image = IMG; img.ScaleType = Enum.ScaleType.Crop; img.ImageTransparency = 1; img.ZIndex = 2
	local ttl = Instance.new("TextLabel", sg)
	ttl.Size = UDim2.new(1,0,0,90); ttl.Position = UDim2.new(0,0,0.5,-45)
	ttl.BackgroundTransparency = 1; ttl.Text = "Parch3 Duels"; ttl.TextColor3 = Color3.fromRGB(170,0,255)
	ttl.Font = Enum.Font.GothamBlack; ttl.TextSize = 64
	ttl.TextTransparency = 1; ttl.TextStrokeColor3 = Color3.fromRGB(0,0,0); ttl.TextStrokeTransparency = 1; ttl.ZIndex = 3
	local tScale = Instance.new("UIScale", ttl); tScale.Scale = 0.86
	local skipped = false
	local skipBtn = Instance.new("TextButton", sg)
	skipBtn.Size = UDim2.new(0,120,0,34); skipBtn.Position = UDim2.new(1,-136,1,-52)
	skipBtn.BackgroundColor3 = Color3.fromRGB(12,12,14); skipBtn.BackgroundTransparency = 0.25; skipBtn.BorderSizePixel = 0
	skipBtn.Text = "SKIP  >>"; skipBtn.TextColor3 = Color3.fromRGB(235,235,240); skipBtn.Font = Enum.Font.GothamBold; skipBtn.TextSize = 13
	skipBtn.AutoButtonColor = false; skipBtn.TextTransparency = 1; skipBtn.BackgroundTransparency = 1; skipBtn.ZIndex = 5
	Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0,8)
	local skStroke = Instance.new("UIStroke", skipBtn); skStroke.Color = Color3.fromRGB(255,255,255); skStroke.Thickness = 1; skStroke.Transparency = 1
	local function doSkip() skipped = true end
	skipBtn.Activated:Connect(doSkip)
	local skipHit = Instance.new("TextButton", sg)
	skipHit.Size = UDim2.new(1,0,1,0); skipHit.BackgroundTransparency = 1; skipHit.Text = ""; skipHit.AutoButtonColor = false; skipHit.ZIndex = 4
	skipHit.Activated:Connect(doSkip)
	local TWI = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TS:Create(dim, TWI, {BackgroundTransparency = 0.45}):Play()
	TS:Create(img, TWI, {ImageTransparency = 0.65}):Play()
	TS:Create(ttl, TWI, {TextTransparency = 0, TextStrokeTransparency = 0.4}):Play()
	TS:Create(tScale, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TS:Create(skipBtn, TWI, {TextTransparency = 0.1, BackgroundTransparency = 0.25}):Play()
	TS:Create(skStroke, TWI, {Transparency = 0.6}):Play()
	local t0 = tick()
	while tick() - t0 < 3.4 do if skipped then break end; task.wait(0.05) end
	local OUT = TweenInfo.new(skipped and 0.25 or 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	TS:Create(dim, OUT, {BackgroundTransparency = 1}):Play()
	TS:Create(img, OUT, {ImageTransparency = 1}):Play()
	TS:Create(ttl, OUT, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	TS:Create(skipBtn, OUT, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
	TS:Create(skStroke, OUT, {Transparency = 1}):Play()
	pcall(function() TS:Create(sound, TweenInfo.new(skipped and 0.25 or 0.7), {Volume = 0}):Play() end)
	task.wait(skipped and 0.3 or 0.8)
	pcall(function() sound:Stop(); sound:Destroy() end)
	sg:Destroy()
end)
buildGui()
if _G.__Miro_applyTheme then pcall(_G.__Miro_applyTheme,1) end
loadConfigState()
createMobilePanel()
if _G._CursedSetQuickShape then _G._CursedSetQuickShape("Square") end
if _G._CursedSetQuickSize then _G._CursedSetQuickSize(quickBtnSize) end
enableSpeedMeter()
speedBypassEnabled=true
startSpeedBypass()
if setSpeedBypassVisual then setSpeedBypassVisual(true) end

_G.__LonelyPanels = _G.__LonelyPanels or {antibat=false, bypass=false}
_G.__SaveLonelyPanels = function()
    pcall(function()
        if not writefile then return end
        writefile("lonely_panels.json", game:GetService("HttpService"):JSONEncode(_G.__LonelyPanels))
    end)
end
task.spawn(function()
    task.wait(1.5)
    local HS = game:GetService("HttpService")
    local st = {}
    pcall(function()
        if readfile and isfile and isfile("lonely_panels.json") then
            local d = HS:JSONDecode(readfile("lonely_panels.json"))
            if type(d)=="table" then st = d end
        end
    end)
    if st.antibat and _G._OpenAntiBat then pcall(_G._OpenAntiBat); _G.__LonelyPanels.antibat = true end
end)