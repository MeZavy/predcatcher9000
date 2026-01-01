-- [[ PRED CATCHER 9000: UNIVERSAL ACRYLIC ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Persistence Logic for any Executor
local teleportScript = [[loadstring(game:HttpGet("https://pastebin.com/raw/k32aZXWH"))()]]

local queue = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queue then
    queue(teleportScript)
end

-- Configuration
local FlaggedWords = {
    "moan", "daddy", "daddi", "submissive", "breed", "ahhh", "harder", "mami", "dada", "papi", 
    "mistress", "kneel", "good girl", "good boy", "kitten", "discord?", "disc", "snap?", 
    "how old", "u solo", "age?", "where u live", "show face", "send pic", "vibe?", "priv chat",
    "dadddy", "dadddyy", "mummy", "dommy", "mommy"
}

local AllLogs = {} 

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PredCatcher_Universal"
ScreenGui.Parent = (gethui and gethui()) or CoreGui

-- Main Acrylic Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 520)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.8

-- Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -180, 0, 50)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PRED CATCHER 9000"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Control Buttons
local Controls = Instance.new("Frame")
Controls.Size = UDim2.new(0, 180, 0, 50)
Controls.Position = UDim2.new(1, -185, 0, 0)
Controls.BackgroundTransparency = 1
Controls.Parent = MainFrame

local function CreateBtn(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color or Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Controls
    return btn
end

local CloseBtn = CreateBtn("×", UDim2.new(0, 145, 0, 10), Color3.fromRGB(255, 80, 80))
local MinBtn = CreateBtn("-", UDim2.new(0, 110, 0, 10))
local HopBtn = CreateBtn("🚀", UDim2.new(0, 75, 0, 10), Color3.fromRGB(100, 200, 255))
local SaveBtn = CreateBtn("💾", UDim2.new(0, 40, 0, 10), Color3.fromRGB(100, 255, 100))
local IYBtn = CreateBtn("∞", UDim2.new(0, 5, 0, 10), Color3.fromRGB(150, 100, 255))

-- Control Logic
IYBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

SaveBtn.MouseButton1Click:Connect(function()
    local write = writefile or (appendfile)
    if write then
        local content = table.concat(AllLogs, "\n")
        write("PredLogs_" .. os.date("%H%M") .. ".txt", content)
        SaveBtn.Text = "✅"
        task.wait(1)
        SaveBtn.Text = "💾"
    end
end)

HopBtn.MouseButton1Click:Connect(function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
    for i, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.new(0, 440, 0, 50) or UDim2.new(0, 440, 0, 520)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Scrolling Area
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -25, 1, -75)
ScrollFrame.Position = UDim2.new(0, 12, 0, 65)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 0
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = ScrollFrame
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)

-- Log Logic
local function CreateLog(player, message)
    table.insert(AllLogs, "[" .. os.date("%H:%M:%S") .. "] " .. player.Name .. ": " .. message)
    
    local isFlagged = false
    for _, word in pairs(FlaggedWords) do
        if string.find(string.lower(message), word) then isFlagged = true break end
    end

    local LogBtn = Instance.new("TextButton")
    LogBtn.Size = UDim2.new(1, 0, 0, 45)
    LogBtn.BackgroundColor3 = isFlagged and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(255, 255, 255)
    LogBtn.BackgroundTransparency = isFlagged and 0.85 or 0.96
    LogBtn.Text = ""
    LogBtn.Parent = ScrollFrame
    Instance.new("UICorner", LogBtn).CornerRadius = UDim.new(0, 8)
    
    local BStroke = Instance.new("UIStroke", LogBtn)
    BStroke.Color = isFlagged and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    BStroke.Transparency = 0.8

    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 1, 0)
    Content.Position = UDim2.new(0, 10, 0, 0)
    Content.BackgroundTransparency = 1
    Content.Text = "<b>@" .. player.Name .. "</b>: " .. message
    Content.TextColor3 = isFlagged and Color3.fromRGB(255, 180, 180) or Color3.fromRGB(220, 220, 220)
    Content.RichText = true
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 12
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextWrapped = true
    Content.Parent = LogBtn

    -- Right Click Instant TP
    LogBtn.MouseButton2Click:Connect(function()
        if player.Character then
            LocalPlayer.Character:PivotTo(player.Character:GetPivot() * CFrame.new(0, 0, 3))
        end
    end)

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    ScrollFrame.CanvasPosition = Vector2.new(0, 99999)
end

-- Final Hooks
local function hook(p)
    if p == LocalPlayer then return end
    p.Chatted:Connect(function(m) CreateLog(p, m) end)
end

for _, p in pairs(Players:GetPlayers()) do hook(p) end
Players.PlayerAdded:Connect(hook)
