local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
local box = Instance.new("Frame", gui)
box.Size = UDim2.new(0, 80, 0, 80)
box.Position = UDim2.new(0.5, 0, 0.5, 0)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
