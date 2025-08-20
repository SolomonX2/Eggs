-- 📂 FairyEggDelete.lua (มีระบบเซฟ ON/OFF)
local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local guiService = game:GetService("CoreGui")

-- 📁 ไฟล์ config (จะถูกเก็บใน Delta X workspace)
local configFile = "FairyEgg_AutoDelete.txt"

-- โหลดสถานะ
local enabled = false
if isfile and isfile(configFile) then
    enabled = (readfile(configFile) == "on")
else
    if writefile then writefile(configFile, "off") end
end

-- Remote
local deleteRemote = rs:WaitForChild("Shared", 5)
    :WaitForChild("Inventory", 5)
    :WaitForChild("DeleteItem", 5)

-- 🌙 UI
local gui = Instance.new("ScreenGui", guiService)
gui.Name = "FairyEggAutoDeleteUI"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 160, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 200)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Draggable = true

-- ฟังก์ชันเปลี่ยนข้อความ
local function updateBtn()
    if enabled then
        btn.Text = "🔴 ลบ Fairy Egg: ON"
        btn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    else
        btn.Text = "🟢 ลบ Fairy Egg: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
    end
end

-- ฟังก์ชันลบไข่
local function deleteFairyEggs()
    local inv = player:WaitForChild("PlayerGui")
        :WaitForChild("Profile", 10)
        :WaitForChild("Inventory", 10)
        :WaitForChild("Items", 10)

    for _, item in pairs(inv:GetChildren()) do
        if item.Name:lower():match("fairy") then
            deleteRemote:FireServer(item)
            task.wait(0.15)
        end
    end
end

-- Toggle ปุ่ม
btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateBtn()
    if writefile then writefile(configFile, enabled and "on" or "off") end
    if enabled then deleteFairyEggs() end
end)

-- Auto ลบทุก 5 วิ
task.spawn(function()
    while task.wait(5) do
        if enabled then deleteFairyEggs() end
    end
end)

-- เริ่มต้น
updateBtn()
if enabled then deleteFairyEggs() end
