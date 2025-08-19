-- FairyEggDelete.lua
-- ✅ Fairy Egg Auto Delete + Config Save (Delta X)

local player = game:GetService("Players").LocalPlayer
local guiService = game:GetService("CoreGui")
local rs = game:GetService("ReplicatedStorage")

-- 📂 ชื่อไฟล์ config ที่จะเซฟใน Delta X
local configFile = "FairyEgg_AutoDelete.txt"

-- โหลดสถานะจากไฟล์
local enabled = false
if isfile and isfile(configFile) then
    local data = readfile(configFile)
    enabled = (data == "on")
else
    if writefile then
        writefile(configFile, "off")
    end
end

-- Remote
local success, deleteRemote = pcall(function()
    return rs:WaitForChild("Shared", 5):WaitForChild("Inventory", 5):WaitForChild("DeleteItem", 5)
end)
if not success or not deleteRemote then
    warn("❌ ไม่เจอ DeleteItem Remote")
    return
end

-- 🌙 UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FairyEggAutoDeleteUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiService

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 160, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 200)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Active = true
toggleBtn.Draggable = true

-- 🧠 ฟังก์ชันอัปเดตปุ่ม
local function updateButtonText()
    if enabled then
        toggleBtn.Text = "🔴 ลบ Fairy Egg: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    else
        toggleBtn.Text = "🟢 ลบ Fairy Egg: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
    end
end

-- 🔁 ฟังก์ชันลบไข่
local function deleteFairyEggs()
    local gui = player:WaitForChild("PlayerGui"):WaitForChild("Profile", 10)
    local inv = gui:WaitForChild("Inventory", 10)
    local items = inv:WaitForChild("Items", 10)

    for _, item in pairs(items:GetChildren()) do
        if item.Name:lower():match("fairy") then
            print("🗑️ ลบ:", item.Name)
            deleteRemote:FireServer(item)
            task.wait(0.15)
        end
    end
end

-- 🔘 ปุ่ม toggle
toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateButtonText()

    -- 💾 เซฟสถานะลงไฟล์ config
    if writefile then
        writefile(configFile, enabled and "on" or "off")
    end

    if enabled then
        deleteFairyEggs()
    end
end)

-- อัปเดต UI ตอนเริ่มต้น
updateButtonText()

-- ⏱️ Auto ลบทุก 5 วิ ถ้าเปิดไว้
task.spawn(function()
    while task.wait(5) do
        if enabled then
            deleteFairyEggs()
        end
    end
end)

-- ⏱️ ลบทันทีถ้าเปิดไว้ตอนเริ่มเกม
if enabled then
    deleteFairyEggs()
end

print("✅ FairyEggDelete script loaded. Config:", enabled and "ON" or "OFF")
