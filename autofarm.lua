local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UI_CORNER_RADIUS = UDim.new(0, 8)
local UI_COLOR_BG = Color3.fromRGB(25, 25, 30)
local UI_COLOR_SIDEBAR = Color3.fromRGB(35, 35, 45)
local UI_COLOR_TAB_NORMAL = Color3.fromRGB(35, 35, 45)
local UI_COLOR_TAB_HOVER = Color3.fromRGB(50, 50, 60)
local UI_COLOR_TAB_ACTIVE = Color3.fromRGB(20, 150, 255)
local UI_COLOR_TOGGLE_NORMAL = Color3.fromRGB(45, 45, 55)
local UI_COLOR_TOGGLE_HOVER = Color3.fromRGB(60, 60, 70)
local UI_COLOR_CHECKBOX_OFF = Color3.fromRGB(200, 50, 50)
local UI_COLOR_CHECKBOX_ON = Color3.fromRGB(50, 200, 50)

local TWEEN_INFO_TOGGLE = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_INFO_HOVER = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
local TWEEN_INFO_CHECKBOX = TweenInfo.new(0.2, Enum.EasingStyle.Quart)

local function addUICorner(guiObject, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UI_CORNER_RADIUS
	corner.Parent = guiObject
	return corner
end

local function setupHoverAnimation(button, normalColor, hoverColor, scaleFactor)
	local originalSize = button.Size

	local scaleX = originalSize.X.Scale
	local offsetX = originalSize.X.Offset
	local scaleY = originalSize.Y.Scale
	local offsetY = originalSize.Y.Offset

	local hoverSize = UDim2.new(
		scaleX * (scaleFactor or 1.05), offsetX,
		scaleY * (scaleFactor or 1.05), offsetY
	)

	local function resetSize()
		TweenService:Create(button, TWEEN_INFO_HOVER, {Size = originalSize}):Play()
	end

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TWEEN_INFO_HOVER, {BackgroundColor3 = hoverColor, Size = hoverSize}):Play()
	end)

	button.MouseLeave:Connect(function()
		if button.Name:match("TabButton") and button.BackgroundColor3 == UI_COLOR_TAB_ACTIVE then
			resetSize()
			return
		end
		TweenService:Create(button, TWEEN_INFO_HOVER, {BackgroundColor3 = normalColor}):Play()
		resetSize()
	end)
end

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "CustomBlackUI"
MainUI.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = UI_COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
local aspectRatio = 16/9
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0.5, 0, 0.5 / aspectRatio, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Visible = false
MainFrame.BackgroundTransparency = 1
addUICorner(MainFrame, UDim.new(0, 12)) 

local AspectConstraint = Instance.new("UIAspectRatioConstraint")
AspectConstraint.AspectRatio = aspectRatio
AspectConstraint.Parent = MainFrame
MainFrame.Parent = MainUI

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = UI_COLOR_SIDEBAR
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
addUICorner(Sidebar, UDim.new(0, 12)) 

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ListLayout.Parent = Sidebar

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.Parent = Sidebar

local Pages = Instance.new("Frame")
Pages.Name = "Pages"
Pages.BackgroundColor3 = UI_COLOR_BG
Pages.BackgroundTransparency = 1
Pages.Size = UDim2.new(0.7, 0, 1, 0)
Pages.Position = UDim2.new(0.3, 0, 0, 0)
Pages.BorderSizePixel = 0
Pages.Parent = MainFrame

local tabs = {}

local function createTab(name)
	local Button = Instance.new("TextButton")
	Button.Name = name .. "TabButton"
	Button.Text = name
	Button.Size = UDim2.new(0.9, 0, 0.1, 0)
	Button.Font = Enum.Font.SourceSansBold
	Button.FontSize = Enum.FontSize.Size18
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.BackgroundColor3 = UI_COLOR_TAB_NORMAL
	Button.Parent = Sidebar
	addUICorner(Button, UDim.new(0, 6))

	local Page = Instance.new("Frame")
	Page.Name = name .. "Page"
	Page.BackgroundColor3 = UI_COLOR_BG
	Page.BackgroundTransparency = 1 
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.Visible = false
	Page.Parent = Pages

	local Checkbox = Instance.new("TextButton")
	Checkbox.Name = "TestCheckbox" .. name
	Checkbox.Text = "Test " .. name .. " Checkbox: OFF"
	Checkbox.Size = UDim2.new(0.8, 0, 0.1, 0)
	Checkbox.Position = UDim2.new(0.1, 0, 0.1, 0)
	Checkbox.Font = Enum.Font.SourceSansBold
	Checkbox.FontSize = Enum.FontSize.Size18
	Checkbox.TextColor3 = Color3.new(1, 1, 1)
	Checkbox.BackgroundColor3 = UI_COLOR_CHECKBOX_OFF
	Checkbox.Parent = Page
	addUICorner(Checkbox, UDim.new(0, 6))

	setupHoverAnimation(Button, UI_COLOR_TAB_NORMAL, UI_COLOR_TAB_HOVER, 1.02)

	tabs[name] = {Button = Button, Page = Page, Checkbox = Checkbox}
end

createTab("Farm")
createTab("Webhook")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Text = "Toggle UI (K)"
ToggleButton.Size = UDim2.new(0.2, 0, 0.05, 0)
ToggleButton.Position = UDim2.new(0.5, 0, 0.95, 0)
ToggleButton.AnchorPoint = Vector2.new(0.5, 1)
ToggleButton.BackgroundColor3 = UI_COLOR_TOGGLE_NORMAL
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainUI
addUICorner(ToggleButton, UDim.new(0, 8))

setupHoverAnimation(ToggleButton, UI_COLOR_TOGGLE_NORMAL, UI_COLOR_TOGGLE_HOVER, 1.1)

local function toggleUI()
	local isVisible = MainFrame.Visible

	if not isVisible then
		MainFrame.Visible = true
		MainFrame.BackgroundTransparency = 1
		local targetSize = UDim2.new(0.5, 0, 0.5 / aspectRatio, 0)

		TweenService:Create(MainFrame, TWEEN_INFO_TOGGLE, {
			BackgroundTransparency = 0,
			Size = targetSize
		}):Play()
	else
		local tween = TweenService:Create(MainFrame, TWEEN_INFO_TOGGLE, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0)
		})
		tween:Play()
		tween.Completed:Wait()
		MainFrame.Visible = false
		MainFrame.Size = UDim2.new(0.5, 0, 0.5 / aspectRatio, 0)
	end
end

local function switchTab(tabName)
	for name, tab in pairs(tabs) do
		local isActive = (name == tabName)
		tab.Page.Visible = isActive

		local targetColor = isActive and UI_COLOR_TAB_ACTIVE or UI_COLOR_TAB_NORMAL
		TweenService:Create(tab.Button, TWEEN_INFO_HOVER, {BackgroundColor3 = targetColor}):Play()
	end
end

local function toggleCheckbox(checkbox, tabName)
	local isCurrentlyOn = checkbox.Text:match("ON") ~= nil
	local newStateText = isCurrentlyOn and "OFF" or "ON"
	local newColor = isCurrentlyOn and UI_COLOR_CHECKBOX_OFF or UI_COLOR_CHECKBOX_ON

	TweenService:Create(checkbox, TWEEN_INFO_CHECKBOX, {BackgroundColor3 = newColor}):Play()

	checkbox.Text = "Test " .. tabName .. " Checkbox: " .. newStateText

	local originalSize = checkbox.Size
	local smallSize = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset, originalSize.Y.Scale * 0.95, originalSize.Y.Offset)

	local pressTween = TweenService:Create(checkbox, TweenInfo.new(0.1), {Size = smallSize})
	local releaseTween = TweenService:Create(checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = originalSize})

	pressTween:Play()
	pressTween.Completed:Wait()
	releaseTween:Play()
end

ToggleButton.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.K and not gameProcessedEvent then
		toggleUI()
	end
end)

tabs.Farm.Button.MouseButton1Click:Connect(function()
	switchTab("Farm")
end)

tabs.Webhook.Button.MouseButton1Click:Connect(function()
	switchTab("Webhook")
end)

tabs.Farm.Checkbox.MouseButton1Click:Connect(function()
	toggleCheckbox(tabs.Farm.Checkbox, "Farm")
end)

tabs.Webhook.Checkbox.MouseButton1Click:Connect(function()
	toggleCheckbox(tabs.Webhook.Checkbox, "Webhook")
end)

switchTab("Farm")
