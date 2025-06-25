local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

if not game:IsLoaded() then
        game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 3
		})
	end)
end

local function loadSettings()
	local success, result = pcall(function()
		if isfile and readfile and isfile("crosshair_settings.json") then
			return HttpService:JSONDecode(readfile("crosshair_settings.json"))
		end
	end)
	return success and result or nil
end

local function saveSettings(data)
	pcall(function()
		if writefile then
			writefile("crosshair_settings.json", HttpService:JSONEncode(data))
		end
	end)
end

local function persistCrosshairData(imageLabel)
	local size    = imageLabel.Size.X.Offset
	local color   = imageLabel.ImageColor3
	local imageId = imageLabel.Image:match("rbxassetid://(%d+)")
	local pos     = imageLabel.Position

	local data = {
		Size     = size,
		Color    = { color.R * 255, color.G * 255, color.B * 255 },
		ImageID  = imageId,
		Position = { pos.X.Offset, pos.Y.Offset }
	}
	saveSettings(data)
end

-- UI Setup
local ui = Instance.new("ScreenGui")
ui.Name = "Ui_" .. tostring(math.random(10000, 99999))
ui.ResetOnSpawn = false
ui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local crosshair = Instance.new("ImageLabel")
crosshair.Name = "X"
crosshair.Size = UDim2.new(0, 100, 0, 100)
crosshair.Position = UDim2.new(0.5, -50, 0.5, -50)
crosshair.BackgroundTransparency = 1
crosshair.Image = "rbxassetid://9947945465"
crosshair.ImageColor3 = Color3.fromRGB(255, 255, 255)
crosshair.Visible = true
crosshair.Active = true
crosshair.Draggable = true
crosshair.Parent = ui

local panel = Instance.new("Frame")
panel.Name = "Y"
panel.Size = UDim2.new(0, 220, 0, 290)
panel.Position = UDim2.new(0, 10, 0, 10)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
panel.BorderSizePixel = 0
panel.Parent = ui

local toggleUIBtn = Instance.new("TextButton")
toggleUIBtn.Name = "Z"
toggleUIBtn.Size = UDim2.new(0, 60, 0, 25)
toggleUIBtn.Position = UDim2.new(0, 10, 0, 10)
toggleUIBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleUIBtn.Text = "Hide UI"
toggleUIBtn.TextScaled = true
toggleUIBtn.BorderSizePixel = 0
toggleUIBtn.Parent = ui

-- UI Elements
local function createTextBox(name, placeholder, yOffset)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 200, 0, 30)
	box.Position = UDim2.new(0, 10, 0, yOffset)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderText = placeholder
	box.Text = placeholder
	box.TextScaled = true
	box.BorderSizePixel = 0
	box.Parent = panel
	return box
end

local function createButton(name, text, yOffset)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yOffset)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.Parent = panel
	return btn
end

-- UI Controls
local sizeBox      = createTextBox("A", "Size (e.g. 100)", 10)
local colorBox     = createTextBox("B", "Color (R,G,B)", 50)
local imageBox     = createTextBox("C", "Image ID", 90)
local positionBox  = createTextBox("D", "Position (X,Y)", 130)
local toggleCross  = createButton("E", "Hide Crosshair", 170)

local positionLabel = Instance.new("TextLabel")
positionLabel.Size = UDim2.new(0, 200, 0, 20)
positionLabel.Position = UDim2.new(0, 10, 0, 210)
positionLabel.BackgroundTransparency = 1
positionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
positionLabel.Text = "X: 0 | Y: 0"
positionLabel.TextScaled = true
positionLabel.Parent = panel

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 200, 0, 20)
versionLabel.Position = UDim2.new(0, 10, 0, 230)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
versionLabel.Text = "version1.0aBETA"
versionLabel.TextScaled = true
versionLabel.Parent = panel

local crosshairVisible, panelVisible = true, true

-- Events
sizeBox.FocusLost:Connect(function()
	local size = tonumber(sizeBox.Text)
	if size then
		crosshair.Size = UDim2.new(0, size, 0, size)
		persistCrosshairData(crosshair)
	else
		notify("Error", "Invalid size!")
	end
end)

colorBox.FocusLost:Connect(function()
	local r, g, b = colorBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
	if r and g and b then
		crosshair.ImageColor3 = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
		persistCrosshairData(crosshair)
	else
		notify("Error", "Invalid RGB format!")
	end
end)

imageBox.FocusLost:Connect(function()
	local id = imageBox.Text:match("%d+")
	if id then
		crosshair.Image = "rbxassetid://" .. id
		persistCrosshairData(crosshair)
	else
		notify("Error", "Invalid image ID!")
	end
end)

positionBox.FocusLost:Connect(function()
	local x, y = positionBox.Text:match("(%-?%d+)%s*,%s*(%-?%d+)")
	if x and y then
		crosshair.Position = UDim2.new(0, tonumber(x), 0, tonumber(y))
		persistCrosshairData(crosshair)
	else
		notify("Error", "Position must be: X, Y")
	end
end)

toggleCross.MouseButton1Click:Connect(function()
	crosshairVisible = not crosshairVisible
	crosshair.Visible = crosshairVisible
	toggleCross.Text = crosshairVisible and "Hide Crosshair" or "Show Crosshair"
	persistCrosshairData(crosshair)
end)

toggleUIBtn.MouseButton1Click:Connect(function()
	panelVisible = not panelVisible
	local goal = {
		Position = panelVisible and UDim2.new(0, 10, 0, 10) or UDim2.new(0, -240, 0, 10)
	}
	local tween = TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), goal)
	tween:Play()
	toggleUIBtn.Text = panelVisible and "Hide UI" or "Show UI"
end)

RunService.RenderStepped:Connect(function()
	local abs = crosshair.AbsolutePosition
	positionLabel.Text = "X: " .. math.floor(abs.X) .. " | Y: " .. math.floor(abs.Y)
end)

-- Load saved config
local saved = loadSettings()
if saved then
        pcall(function()
		crosshair.Size = UDim2.new(0, saved.Size, 0, saved.Size)
		crosshair.ImageColor3 = Color3.fromRGB(saved.Color[1], saved.Color[2], saved.Color[3])
		crosshair.Image = "rbxassetid://" .. saved.ImageID
		crosshair.Position = UDim2.new(0, saved.Position[1], 0, saved.Position[2])
	end)
end
