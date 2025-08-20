-- 🌀 SolomonX2 Hub 🌀
-- รวม: FairyEggDelete + PerkSell + Bank + Toggle UI
-- Config จะเซฟอัตโนมัติ

-- โหลด Library
local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- สร้างหน้าต่างหลัก
local Window = Library:CreateWindow({
    Title = "🌙 SolomonX2 Hub",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- สร้าง Tabs
local Tabs = {
    Main = Window:AddTab("⚡ Fairy Egg"),
    Perk = Window:AddTab("🎯 Perk Sell"),
    Bank = Window:AddTab("🏦 Bank"),
    UI = Window:AddTab("🖥 UI Settings"),
}

-------------------------------------------------
-- ⚡ Fairy Egg Auto Delete
-------------------------------------------------
local FairyGroup = Tabs.Main:AddLeftGroupbox("Fairy Egg Delete")

local autoDelete = false
FairyGroup:AddToggle("AutoDeleteFairy", {
    Text = "Auto Delete Fairy Egg",
    Default = false,
    Tooltip = "ลบ Fairy Egg อัตโนมัติ",
    Callback = function(val)
        autoDelete = val
    end
})

-- ฟังก์ชันลบ Fairy Egg
local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local deleteRemote = rs:WaitForChild("Shared", 5):WaitForChild("Inventory", 5):WaitForChild("DeleteItem", 5)

local function deleteFairyEggs()
    local inv = player:WaitForChild("PlayerGui"):WaitForChild("Profile", 10):WaitForChild("Inventory", 10):WaitForChild("Items", 10)
    for _, item in pairs(inv:GetChildren()) do
        if item.Name:lower():match("fairy") then
            deleteRemote:FireServer(item)
            task.wait(0.1)
        end
    end
end

task.spawn(function()
    while task.wait(5) do
        if autoDelete then
            deleteFairyEggs()
        end
    end
end)

-------------------------------------------------
-- 🎯 Perk Sell System
-------------------------------------------------
local PerkGroup = Tabs.Perk:AddLeftGroupbox("Perk Sell Config")

-- เก็บค่า Threshold
local perkThresholds = {
    BurnChance = 2,
    AttackUP = 2,
    Vampiric = 5,
    Glass = 30
}

-- สร้าง Slider
PerkGroup:AddSlider("BurnChance", {
    Text = "🔥 Burn Chance %",
    Default = 2,
    Min = 2,
    Max = 15,
    Rounding = 0,
    Callback = function(val)
        perkThresholds.BurnChance = val
    end
})

PerkGroup:AddSlider("AttackUP", {
    Text = "⚔ Attack UP %",
    Default = 2,
    Min = 2,
    Max = 8,
    Rounding = 0,
    Callback = function(val)
        perkThresholds.AttackUP = val
    end
})

PerkGroup:AddSlider("Vampiric", {
    Text = "🩸 Vampiric %",
    Default = 5,
    Min = 5,
    Max = 15,
    Rounding = 0,
    Callback = function(val)
        perkThresholds.Vampiric = val
    end
})

PerkGroup:AddSlider("Glass", {
    Text = "💎 Glass %",
    Default = 30,
    Min = 30,
    Max = 100,
    Rounding = 0,
    Callback = function(val)
        perkThresholds.Glass = val
    end
})

-- ปุ่ม Sell
local perkAutoSell = false
PerkGroup:AddToggle("AutoSellPerk", {
    Text = "Auto Sell on Dungeon Join",
    Default = false,
    Tooltip = "ขายของตอนเข้าดันเจี้ยน",
    Callback = function(val)
        perkAutoSell = val
    end
})

-- ตัวอย่างโค้ดขาย (ยังไม่เชื่อม Remote จริงเพราะแต่ละเกมไม่เหมือนกัน)
local function sellItemsOnDungeon()
    if not perkAutoSell then return end
    print("🔧 Checking inventory for sell... Thresholds:", perkThresholds)
    -- ที่นี่คุณใส่โค้ดตรวจ perk + fire remote เพื่อขาย
end

-- Hook ตอนเข้าดันเจี้ยน
game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name:match("Dungeon") then
        sellItemsOnDungeon()
    end
end)

-------------------------------------------------
-- 🏦 Bank Button
-------------------------------------------------
local BankGroup = Tabs.Bank:AddLeftGroupbox("Bank Control")

BankGroup:AddButton({
    Text = "🏦 Open Bank",
    Func = function()
        game:GetService("ReplicatedStorage").Shared.Bank.GetBankItems:InvokeServer()
    end,
    Tooltip = "กดเพื่อเปิด Bank"
})

-------------------------------------------------
-- 🖥 UI Settings
-------------------------------------------------
local UIGroup = Tabs.UI:AddLeftGroupbox("UI Controls")

UIGroup:AddButton({
    Text = "🖥 Toggle Menu",
    Func = function()
        if Library.Unloaded then return end
        if Library.MainFrame.Visible then
            Library:Close()
        else
            Library:Open()
        end
    end,
    Tooltip = "ซ่อน/แสดงเมนู"
})

-- Theme + Config Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("SolomonX2Hub")
ThemeManager:SetFolder("SolomonX2Hub")

SaveManager:BuildConfigSection(Tabs.UI)
ThemeManager:ApplyToTab(Tabs.UI)

-------------------------------------------------
Library:Notify("✅ SolomonX2 Hub Loaded!", 5)
