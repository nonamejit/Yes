local Player = game.Players.LocalPlayer

local function GetClosestPurchase(Purchase, Distance)
	local ClosestPurDistance 	= Distance
	local ClosestPur			= nil
	local Character				= Player.Character

	for i,v in pairs(game.Workspace.Purchases:GetDescendants()) do
		if v.Name == Purchase then
			if v:FindFirstChild("ClickDetector") and v:FindFirstChild("Part") then
				local Part				= v:FindFirstChildOfClass("Part")
				if (Character.HumanoidRootPart.Position - Part.Position).Magnitude < ClosestPurDistance then
					ClosestPurDistance 	= (Character.HumanoidRootPart.Position - Part.Position).Magnitude
					ClosestPur			= v
				end
			end
		end
	end

	return ClosestPur
end

fireclickdetector(GetClosestPurchase("Strike Speed Training", 25))
task.wait(0.1)
Player.Backpack:FindFirstChild("Strike Speed Training").Parent = Player.Character
