local a = game:GetService("Players")
local b = game:GetService("TweenService")
local c = game:GetService("RunService")
local d = game:GetService("StarterGui")
local e = game:GetService("HttpService")

if not game:IsLoaded() then game.Loaded:Wait() end

local f = a.LocalPlayer

local function g(t, u, v)
	pcall(function()
		d:SetCore("SendNotification", {
			Title = t,
			Text = u,
			Duration = v or 3
		})
	end)
end

local function h()
	local ok, r = pcall(function()
		if isfile and readfile and isfile("crosshair_settings.json") then
			return e:JSONDecode(readfile("crosshair_settings.json"))
		end
	end)
	return ok and r or nil
end

local function i(s)
	pcall(function()
		if writefile then
			writefile("crosshair_settings.json", e:JSONEncode(s))
		end
	end)
end

local function j(k)
	local l = k.Size.X.Offset
	local m = k.ImageColor3
	local n = k.Image:match("rbxassetid://(%d+)")
	local o = k.Position
	local p = {
		Size = l,
		Color = { m.R * 255, m.G * 255, m.B * 255 },
		ImageID = n,
		Position = { o.X.Offset, o.Y.Offset }
	}
	i(p)
end

local q = Instance.new("ScreenGui")
q.Name = "Ui_" .. tostring(math.random(10000, 99999))
q.ResetOnSpawn = false
q.Parent = f:WaitForChild("PlayerGui")

local r = Instance.new("ImageLabel")
r.Name = "X"
r.Size = UDim2.new(0, 100, 0, 100)
r.Position = UDim2.new(0.5, -50, 0.5, -50)
r.BackgroundTransparency = 1
r.Image = "rbxassetid://9947945465"
r.ImageColor3 = Color3.fromRGB(255, 255, 255)
r.Visible = true
r.Active = true
r.Draggable = true
r.Parent = q

local s = Instance.new("Frame")
s.Name = "Y"
s.Size = UDim2.new(0, 220, 0, 290)
s.Position = UDim2.new(0, 10, 0, 10)
s.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
s.BorderSizePixel = 0
s.Parent = q

local t = Instance.new("TextButton")
t.Name = "Z"
t.Size = UDim2.new(0, 60, 0, 25)
t.Position = UDim2.new(0, 10, 0, 10)
t.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.Text = "Hide UI"
t.TextScaled = true
t.BorderSizePixel = 0
t.Parent = q

local function u(n, o, p)
	local x = Instance.new("TextBox")
	x.Name = n
	x.Size = UDim2.new(0, 200, 0, 30)
	x.Position = UDim2.new(0, 10, 0, p)
	x.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	x.TextColor3 = Color3.fromRGB(255, 255, 255)
	x.PlaceholderText = o
	x.Text = o
	x.TextScaled = true
	x.BorderSizePixel = 0
	x.Parent = s
	return x
end

local function v(n, o, p)
	local y = Instance.new("TextButton")
	y.Name = n
	y.Size = UDim2.new(0, 200, 0, 30)
	y.Position = UDim2.new(0, 10, 0, p)
	y.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	y.TextColor3 = Color3.fromRGB(255, 255, 255)
	y.Text = o
	y.TextScaled = true
	y.BorderSizePixel = 0
	y.Parent = s
	return y
end

local w = u("A", "Size (e.g. 100)", 10)
local x = u("B", "Color (R,G,B)", 50)
local y = u("C", "Image ID", 90)
local z = u("D", "Position (X,Y)", 130)
local A = v("E", "Hide Crosshair", 170)

local B = Instance.new("TextLabel")
B.Size = UDim2.new(0, 200, 0, 20)
B.Position = UDim2.new(0, 10, 0, 210)
B.BackgroundTransparency = 1
B.TextColor3 = Color3.fromRGB(200, 200, 200)
B.Text = "X: 0 | Y: 0"
B.TextScaled = true
B.Parent = s

local C = Instance.new("TextLabel")
C.Size = UDim2.new(0, 200, 0, 20)
C.Position = UDim2.new(0, 10, 0, 230)
C.BackgroundTransparency = 1
C.TextColor3 = Color3.fromRGB(120, 120, 120)
C.Text = "version1.0aBETA"
C.TextScaled = true
C.Parent = s

local D, E = true, true

w.FocusLost:Connect(function()
	local F = tonumber(w.Text)
	if F then
		r.Size = UDim2.new(0, F, 0, F)
		j(r)
	else
		g("Error", "Invalid size!")
	end
end)

x.FocusLost:Connect(function()
	local G, H, I = x.Text:match("(%d+),%s*(%d+),%s*(%d+)")
	if G and H and I then
		r.ImageColor3 = Color3.fromRGB(tonumber(G), tonumber(H), tonumber(I))
		j(r)
	else
		g("Error", "Invalid RGB format!")
	end
end)

y.FocusLost:Connect(function()
	local J = y.Text:match("%d+")
	if J then
		r.Image = "rbxassetid://" .. J
		j(r)
	else
		g("Error", "Invalid image ID!")
	end
end)

z.FocusLost:Connect(function()
	local K, L = z.Text:match("(%-?%d+)%s*,%s*(%-?%d+)")
	if K and L then
		r.Position = UDim2.new(0, tonumber(K), 0, tonumber(L))
		j(r)
	else
		g("Error", "Position must be: X, Y")
	end
end)

A.MouseButton1Click:Connect(function()
	D = not D
	r.Visible = D
	A.Text = D and "Hide Crosshair" or "Show Crosshair"
	j(r)
end)

t.MouseButton1Click:Connect(function()
	E = not E
	local M = {}
	M.Position = E and UDim2.new(0, 10, 0, 10) or UDim2.new(0, -240, 0, 10)
	local N = b:Create(s, TweenInfo.new(0.4, Enum.EasingStyle.Quad), M)
	N:Play()
	t.Text = E and "Hide UI" or "Show UI"
end)

c.RenderStepped:Connect(function()
	local O = r.AbsolutePosition
	B.Text = "X: " .. math.floor(O.X) .. " | Y: " .. math.floor(O.Y)
end)

local P = h()
if P then
	pcall(function()
		r.Size = UDim2.new(0, P.Size, 0, P.Size)
		r.ImageColor3 = Color3.fromRGB(P.Color[1], P.Color[2], P.Color[3])
		r.Image = "rbxassetid://" .. P.ImageID
		r.Position = UDim2.new(0, P.Position[1], 0, P.Position[2])
	end)
end
