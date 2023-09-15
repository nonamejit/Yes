local Players			= game:GetService("Players")
local Replicated		= game:GetService("ReplicatedStorage")
local ReplicatedFirst		= game:GetService("ReplicatedFirst")
local VirtualManager		= game:GetService("VirtualInputManager")

local Player			= Players.LocalPlayer
local PlayerGui			= Player.PlayerGui
local Event			= Replicated.Events.EventCore

local UILibrary 		= loadstring(game:HttpGet(("https://raw.githubusercontent.com/ErrorRat/Yes/main/Test2.lua")))()
local MainWin			= UILibrary:Window("Asura's Demise 😈")

local MainSer			= MainWin:Server("Asura", "")

local Values			= {}

--Fuctions //

local function Eat()
	if PlayerGui.Main.HUD.Hunger.Clipping.Size.X.Scale <= Values["HungerValue"] and Values["HungerEnabled"] == true then
		for i,v in pairs(Player.Backpack:GetDescendants()) do
			if v.Name == "EatAnimation" and v:IsA("Animation") then
				if Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
					local Humanoid	= Player.Character.Humanoid
					Humanoid:EquipTool(v.Parent)

					if v.Parent.Parent == Player.Character then
						v.Parent:Activate()
					end

					task.wait(2)

					if Player.Character:FindFirstChildOfClass("Tool") then
						Humanoid:UnequipTools()
					end
				end
			end
		end
	end
end

local function GetClosestPurchase(Purchase, Distance)
	local ClosestPurDistance 	= Distance
	local ClosestPur			= nil
	local Character				= Player.Character

	for i,v in pairs(game.Workspace.Purchases:GetDescendants()) do
		if v.Name == Purchase then
			if v:FindFirstChild("ClickDetector") and v:FindFirstChild("Part") then
				local Part				= v:FindFirstChildOfClass("Part")
				if (Character.HumanoidRootPart.Position - Part.Position).Magnitude < ClosestPurDistance then
					ClosestPurDistance 	= (Character.HumanoidRootPart.Position - v.Part.Position).Magnitude
					ClosestPur			= v
				end
			end
		end
	end

	return ClosestPur
end

local function GetClosestBag(Distance)
	local ClosestPurDistance 	= Distance
	local ClosestTrain			= nil
	local Character				= Player.Character

	for i,v in pairs(game.Workspace.Trainings:GetDescendants()) do
		if v.Name == "PunchingBag" and v:FindFirstChild("Main") then
			local Part					= v.Main
			if (Character.HumanoidRootPart.Position - Part.Position).Magnitude < ClosestPurDistance then
				ClosestPurDistance 		= (Character.HumanoidRootPart.Position - v.Part.Position).Magnitude
				ClosestTrain			= v
			end
		end
	end

	return ClosestTrain
end

local function GetClosestTreadmil(Distance)
	local closestPurchaseDis	= Distance
	local closestPurchase		= nil
	for i,v in pairs(game.Workspace.Treadmills:GetChildren()) do
		if v.Name == "Treadmill" then
			if v:FindFirstChild("ClickDetector") and v:FindFirstChild("Center") then
				if (Player.Character.HumanoidRootPart.Position - v.Center.Position).Magnitude < closestPurchaseDis then
					closestPurchaseDis 	= (Player.Character.HumanoidRootPart.Position - v.Center.Position).Magnitude
					closestPurchase		= v
				end
			end
		end
	end

	return closestPurchase
end

local function returnAnimation(PlayerInstance, AnimationId)
	if PlayerInstance then
		if PlayerInstance.Character then
			local Character = PlayerInstance.Character
			if Character:FindFirstChildOfClass("Humanoid") then
				if Character.Humanoid:FindFirstChildOfClass("Animator") then
					for i, animationtracks in pairs(Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
						if animationtracks:IsA("AnimationTrack") then
							if animationtracks.Animation and tostring(animationtracks.Animation.AnimationId) and string.match(tostring(animationtracks.Animation.AnimationId), AnimationId) then
								return animationtracks
							end
						end
					end
				end
			end
		end
	end

	return nil
end

local function Raycast(Position, Direction, Ignore)
	local ray		= Ray.new(Position, Direction)

	local Hit		= game.Workspace:FindPartOnRayWithIgnoreList(ray, Ignore)

	if Hit then
		if Hit.Parent and Hit.Parent:FindFirstChildOfClass("Humanoid") and Players:FindFirstChild(Hit.Parent.Name) then
			if Hit.Parent.Name == Values["DuraSelected"] then
				return true
			end
		end
	end

	return false
end

local CanPunch	= false
local function Punch()
	if CanPunch == false and Player.Character and Player.Character:FindFirstChild("Combat") then
		CanPunch = true
		Player.Character["Combat"]:Activate()

		local Animation
		for i,v in pairs(ReplicatedFirst:WaitForChild("Anims"):WaitForChild(Player.Character["Combat"]:GetAttribute("Name")):GetChildren()) do
			if (v.Name == "1" or v.Name == "2" and v.Name == "3" or v.Name == "4" or v.Name == "5") and v:IsA("Animation") then
				if returnAnimation(Player, v.AnimationId) ~= nil  then
					Animation = returnAnimation(Player, v.AnimationId)
				end
			end
		end

		if Animation ~= nil then
			repeat task.wait() until Animation.IsPlaying == false or Values["PunchingBagsEnabled"] == false or Values["DuraEnabled"] == false or Values["ToolEnabled"] == false or Values["ThreadmilEnabled"] == false
		end
		CanPunch = false
	end
end

local function RunPunchingBags()
	local Character			= Player.Character
	local Humanoid			= Character.Humanoid

	if Values["PunchingBagsEnabled"] == true then
		local Purchase		= GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 20)
		local Bag			= GetClosestBag(20)

		if not Character:FindFirstChild("Gloves") then
			if not Player.Backpack:FindFirstChild("Strike "..Values["PunchingBagsType"].." Training") then
				if Purchase ~= nil then
					local Purchase		= GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 20)
					fireclickdetector(Purchase.ClickDetector)
				else 
					if Values["Debug"] == true then
						UILibrary:Notification("Failed", "Make sure you are close to the purchase button")
					end

					repeat task.wait() until GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 20) ~= nil or Values["PunchingBagsEnabled"] == false
					Purchase = GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 20)
					fireclickdetector(Purchase.ClickDetector)
				end 
			end

			task.wait(1)

			if Bag ~= nil then
				if Player.Backpack:FindFirstChild("Strike "..Values["PunchingBagsType"].." Training") then
					Humanoid:EquipTool(Player.Backpack["Strike "..Values["PunchingBagsType"].." Training"])

					if Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool").Name == "Strike "..Values["PunchingBagsType"].." Training" then
						Character:FindFirstChildOfClass("Tool"):Activate()

						if Character:FindFirstChildOfClass("Tool") then
							Humanoid:UnequipTools()
						end
					end
				end
			else
				if Values["Debug"] == true then
					UILibrary:Notification("Failed", "Make sure you are close to the punching bag", "Close")
				end

				repeat task.wait() until GetClosestBag(20) ~= nil or Values["PunchingBagsEnabled"] == false
				Bag = GetClosestBag(20)
				if Player.Backpack:FindFirstChild("Strike "..Values["PunchingBagsType"].." Training") then
					Humanoid:EquipTool(Player.Backpack["Strike "..Values["PunchingBagsType"].." Training"])

					if Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool").Name == "Strike "..Values["PunchingBagsType"].." Training" then
						Character:FindFirstChildOfClass("Tool"):Activate()

						if Character:FindFirstChildOfClass("Tool") then
							Humanoid:UnequipTools()
						end
					end
				end
			end
		end

		repeat task.wait() until Character:FindFirstChild("Gloves") or Values["PunchingBagsEnabled"] == false

		if Character:FindFirstChild("Gloves") then
			if Player.Backpack:FindFirstChild("Combat") then
				Humanoid:EquipTool(Player.Backpack.Combat)
			end

			if Character:FindFirstChild("Combat") then
				if Values["PunchingBagsType"] == "Power" then
					if PlayerGui:FindFirstChildOfClass("BillboardGui") then
						if PlayerGui:FindFirstChildOfClass("BillboardGui").Adornee.Name == "Main" then
							Character:FindFirstChild("Combat"):Activate()
						end
					end

					local HoldOffConnection = false; local Hits = 0; local Connection = nil; Connection = PlayerGui.ChildAdded:Connect(function(Child) 
						if Child:IsA("BillboardGui") and HoldOffConnection == false and PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= Values["StaminaValue"] and Child:FindFirstChild("ImageLabel") and Child.Adornee.Name == "Main" then
							if Hits <= 4 then
								Hits += 1; Punch()
							elseif Hits == 5 then
								Event:FireServer(unpack({[1] = "M2"})); Hits = 0
							end
							
							if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale < Values["StaminaValue"] then
								HoldOffConnection = true
								repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1
								HoldOffConnection = false
							end
						end
					end)

					repeat task.wait() until not Character:FindFirstChild("Gloves") or Values["PunchingBagsEnabled"] == false
					Connection:Disconnect()
				elseif Values["PunchingBagsType"] == "Speed" then
					if PlayerGui:FindFirstChildOfClass("BillboardGui") then
						if PlayerGui:FindFirstChildOfClass("BillboardGui").Adornee.Name == "Main" then
							local HoldOffConnection = false; local Hits = 0; repeat task.wait()
								if PlayerGui:FindFirstChildOfClass("BillboardGui") and HoldOffConnection == false and PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= Values["StaminaValue"] then
									if Hits <= 4 then
										Hits += 1; Punch()
									elseif Hits == 5 then
										Event:FireServer(unpack({[1] = "M2"})); Hits = 0
									end
									
									if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale < Values["StaminaValue"] then
										HoldOffConnection = true
										repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1
										HoldOffConnection = false
									end
								end
							until not PlayerGui:FindFirstChildOfClass("BillboardGui") or Values["PunchingBagsEnabled"] == false
						end
					end
				end

				if Character:FindFirstChildOfClass("Tool") then
					Humanoid:UnequipTools()
				end

				Eat()

				if Values["PunchingBagsEnabled"] == true then
					local S, F = pcall(function()
						RunPunchingBags()
					end)

					if F and Values["Debug"] == true then
						UILibrary:Notification("Failed", tostring(F))
					end
				end
			end
		end
	end
end

if PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame") then
	PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame"):Destroy()
end

local function RunThreadmil()
	local Character			= Player.Character
	local Humanoid			= Character.Humanoid

	if Values["ThreadmilEnabled"] == true then
		local closestThreadmil = GetClosestTreadmil(20)

		if closestThreadmil ~= nil then
			fireclickdetector(closestThreadmil.ClickDetector)
		else
			if Values["Debug"] == true then
				UILibrary:Notification("Failed", "Make sure you are close to the threadmil", "Close")
			end

			repeat task.wait() until GetClosestTreadmil(20) ~= nil or Values["ThreadmilEnabled"] == false	
			fireclickdetector(closestThreadmil.ClickDetector)
		end

		repeat task.wait() until PlayerGui.TreadmillGain.Frame.Visible == true or Values["ThreadmilEnabled"] == false
		firesignal(PlayerGui.TreadmillGain.Frame[Values["ThreadmilType"]].MouseButton1Up)

		if PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame") then
			if Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name] then
				VirtualManager:SendKeyEvent(true, Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name], 	false, nil)
				VirtualManager:SendKeyEvent(false, Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name], false, nil)
			end
		end

		local HoldOffConnection = false; local Connection = PlayerGui.TreadmillGain.Frame2.Keys.ChildAdded:Connect(function(Child)
			if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= Values["StaminaValue"] then
				if Child:IsA("Frame") and HoldOffConnection == false then
					if Enum.KeyCode[Child.Name] then
						VirtualManager:SendKeyEvent(true, Enum.KeyCode[Child.Name], false, nil)
						VirtualManager:SendKeyEvent(false, Enum.KeyCode[Child.Name], false, nil)
						
						if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale <= Values["StaminaValue"] then
							HoldOffConnection = true
							repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1
							HoldOffConnection = false
						end
					end
				end
			end
		end)

		repeat wait() until Player.Character.HumanoidRootPart.Anchored == false or Values["ThreadmilEnabled"] == false
		Connection:Disconnect()

		Eat()
		if Values["ThreadmilEnabled"] == true then
			local S, F = pcall(function()
				RunThreadmil()
			end)

			if F and Values["Debug"] == true then
				UILibrary:Notification("Failed", tostring(F), "Close")
			end
		end
	end
end

local function RunAutoTool()
	if Values["ToolEnabled"] == true and PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale > Values["StaminaValue"] then
		local Character			= Player.Character
		local Humanoid			= Character.Humanoid

		if Player.Backpack:FindFirstChild(Values["ToolType"]) then
			Humanoid:EquipTool(Player.Backpack[Values["ToolType"]])
		end

		if Character:FindFirstChild(Values["ToolType"]) then
			repeat task.wait()
				Character[Values["ToolType"]]:Activate()
			until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale <= Values["StaminaValue"] or Values["ToolEnabled"] == false
		end

		Eat()
		repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["ToolEnabled"] == false

		if Values["ToolEnabled"] == true then
			local S, F = pcall(function()
				RunAutoTool()
			end)

			if F and Values["Debug"] == true then
				UILibrary:Notification("Failed", tostring(F), "Close")
			end
		end
	end
end

local DuraBoolValue		= false
local function RunDura()
	if Values["DuraEnabled"] == true then
		local OtherPlayer				= Players[Values["DuraSelected"]]
		local OtherPlayerCharacter 		= OtherPlayer.Character
		local OtherPlayerHumanoid		= OtherPlayerCharacter.Humanoid
		local Character					= Player.Character
		local Humanoid					= Character.Humanoid

		if OtherPlayerCharacter and OtherPlayerHumanoid then
			if DuraBoolValue == true then
				if Humanoid.Health < Humanoid.MaxHealth then
					repeat task.wait() until Humanoid.Health >= Humanoid.MaxHealth or Values["DuraEnabled"] == false
				end

				repeat task.wait() until Raycast(Character.HumanoidRootPart.CFrame.p, Character.HumanoidRootPart.CFrame.LookVector * 10, {Character}) == true and (OtherPlayerCharacter:FindFirstChildOfClass("Tool") and OtherPlayerCharacter:FindFirstChildOfClass("Tool").Name == "Combat") or Values["DuraEnabled"] == false

				local closestPurchase	= GetClosestPurchase("Body Conditioning", 20)
				if not Player.Backpack:FindFirstChild("Body Conditioning") then
					if closestPurchase ~= nil then
						fireclickdetector(closestPurchase.ClickDetector)
					else
						if Values["Debug"] == true then
							UILibrary:Notification("Failed", "Make sure you are close to the purchase button", "Close")
						end

						repeat task.wait() until GetClosestPurchase("Body Conditioning", 20) ~= nil or Values["DuraEnabled"] == false	
						fireclickdetector(closestPurchase.ClickDetector)
					end
				end
	
				if Player.Backpack:FindFirstChild("Body Conditioning") then
					Humanoid:EquipTool(Player.Backpack["Body Conditioning"])
				end
				
				task.wait(2)
				
				if Character:FindFirstChild("Body Conditioning") and Values["DuraEnabled"] == true then
					if returnAnimation(Player, "13470691661") == nil then
						Character:FindFirstChild("Body Conditioning"):Activate()
					end
				end

				repeat task.wait() until not Character:FindFirstChild("Body Conditioning") or Character.HumanoidRootPart.Anchored == false or returnAnimation(Player, "13470691661") == nil or Values["DuraEnabled"] == false
				
				task.wait(2)
				
				if Character:FindFirstChild("Body Conditioning") and returnAnimation(Player, "13470691661") ~= nil then
					Character:FindFirstChild("Body Conditioning"):Activate()
				end
				
				if Character:FindFirstChildOfClass("Tool") then
					Humanoid:UnequipTools()
				end

				Eat()

				if Values["DuraEnabled"] == true then
					local S, F = pcall(function()
						DuraBoolValue = false
						RunDura()
					end)

					if F and Values["Debug"] == true then
						UILibrary:Notification("Failed", tostring(F))
					end
				end
			elseif DuraBoolValue == false then
				if OtherPlayerHumanoid.Health < OtherPlayerHumanoid.MaxHealth then
					repeat task.wait() until OtherPlayerHumanoid.Health >= OtherPlayerHumanoid.MaxHealth or Values["DuraEnabled"] == false
				end
				
				repeat task.wait() until Raycast(Character.HumanoidRootPart.CFrame.p, Character.HumanoidRootPart.CFrame.LookVector * 10, {Character}) == true or Values["DuraEnabled"] == false

				if Player.Backpack:FindFirstChild("Combat") then
					Character.Humanoid:EquipTool(Player.Backpack["Combat"])
				end

				repeat task.wait() until ((returnAnimation(OtherPlayer, "13470691661") ~= nil or OtherPlayerCharacter.HumanoidRootPart.Anchored == true) and OtherPlayerCharacter:FindFirstChild("Body Conditioning")) or Values["DuraEnabled"] == false

				if Player.Character:FindFirstChild("Combat") then
					local StartingHealth = OtherPlayerHumanoid.Health

					if Values["DuraEnabled"] == true then
						local C = nil; C = OtherPlayerHumanoid.HealthChanged:Connect(function(H) 
							StartingHealth = StartingHealth - OtherPlayerHumanoid.Health
							C:Disconnect();
						end)
						
						Player.Character["Combat"]:Activate()
						repeat task.wait() until StartingHealth ~= OtherPlayerHumanoid.Health or Values["DuraEnabled"] == false
					end

					repeat task.wait(0.4)
						if Player.Character:FindFirstChild("Combat") and OtherPlayerCharacter.HumanoidRootPart.Anchored == true and OtherPlayerCharacter:FindFirstChild("Body Conditioning") and (OtherPlayerHumanoid.Health - StartingHealth) > StartingHealth then
							Punch()
						end
					until not OtherPlayerCharacter:FindFirstChild("Body Conditioning") or OtherPlayerCharacter.HumanoidRootPart.Anchored == false or (OtherPlayerCharacter.Humanoid.Health - StartingHealth) <= StartingHealth or Values["DuraEnabled"] == false

					if Character:FindFirstChildOfClass("Tool") then
						Humanoid:UnequipTools()
					end

					Eat()

					if Values["DuraEnabled"] == true then
						local S, F = pcall(function()
							DuraBoolValue = true
							RunDura()
						end)

						if F and Values["Debug"] == true then
							UILibrary:Notification("Failed", tostring(F), "Close")
						end
					end
				end
			end
		end
	end
end

local AutofarmChan		= MainSer:Channel("Autofarm's")
AutofarmChan:Toggle("Strike Power/Speed Training", false, function(value) 
	Values["PunchingBagsEnabled"] = value
	if value == true then
		local S, F = pcall(function()
			RunPunchingBags()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Power", {"Power", "Speed"}, function(value) 
	Values["PunchingBagsType"] = value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Treadmil Training", false, function(value) 
	Values["ThreadmilEnabled"] = value
	if value == true then
		local S, F = pcall(function()
			RunThreadmil()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Speed", {"Speed", "Stamina"}, function(value) 
	Values["ThreadmilType"] = value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Tool Training", false, function(value) 
	Values["ToolEnabled"] = value

	if value == true then
		local S, F = pcall(function()
			RunAutoTool()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Push Up", {"Push Up", "Squat", "Sit Up"}, function(value) 
	Values["ToolType"]	= value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Dura Training", false, function(value) 
	Values["DuraEnabled"] = value

	if value == true then
		local S, F = pcall(function()
			if Values["DuraStarting"] == false then
				DuraBoolValue = false
			elseif Values["DuraStarting"] == true then
				DuraBoolValue = true
			end
			RunDura()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

local PlayerList = {}; for i,v in pairs(Players:GetPlayers()) do table.insert(PlayerList, v.Name) end
local DuraDropDown = AutofarmChan:Dropdown("Player to dura farm with", "", PlayerList, function(value) 
	Values["DuraSelected"] = value
end)
Players.PlayerAdded		:Connect(function(OtherPlayer) DuraDropDown:Add(OtherPlayer.Name) 	end)
Players.PlayerRemoving	:Connect(function(OtherPlayer) DuraDropDown:Remove(OtherPlayer.Name) end)

AutofarmChan:Label("Whoever is doing the hitting set it to false!")
AutofarmChan:Label("It going to be true for the other person!")
AutofarmChan:Toggle("Starting dura hit", false, function(value) 
	Values["DuraStarting"] 	= value
	DuraBoolValue			= value
end)

local MiscChan			= MainSer:Channel("Miscellaneous")
MiscChan:Toggle("Auto eat", false, function(value) 
	Values["HungerEnabled"] = value
end)

MiscChan:Slider("Hunger limit", 0, 100, 25, function(value) 
	Values["HungerValue"] = value * 0.01
end)

MiscChan:Seperator()

MiscChan:Slider("Stamina limit", 0, 100, 20, function(value) 
	Values["StaminaValue"] = value * 0.01
end)

MiscChan:Seperator()

MiscChan:Label("Does not work for dura cause that doesn't make sense..")
MiscChan:Toggle("Disable on hit", false, function(value) 
	Values["DisableOnHit"] = value
end)

MiscChan:Toggle("Leave after combat", false, function(value) 
	Values["LeaveAfterCombat"] = value
end)

MiscChan:Seperator()

MiscChan:Toggle("Debugger", false, function(value) 
	Values["Debug"] = value
end)

MiscChan:Seperator()

MiscChan:Bind("Turn off/on Gui", Enum.KeyCode.RightShift, function()
	if game.CoreGui.Discord.MainFrame.Size.X.Offset == 681 then
		game.CoreGui.Discord.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
	elseif game.CoreGui.Discord.MainFrame.Size.X.Offset == 0 then
		game.CoreGui.Discord.MainFrame:TweenSize(UDim2.new(0, 681, 0, 396), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
	end
end)

PlayerGui.InCombat.CanvasGroup:GetPropertyChangedSignal("GroupTransparency"):Connect(function(V)
	if V ~= 1 and Values["DisableOnHit"] == true then
		Values["PunchingBagsEnabled"] 	= false
		Values["ToolEnabled"]			= false
		Values["ThreadmilEnabled"]		= false

		if Values["LeaveAfterCombat"] == true and Values["DuraEnabled"] == false then
			repeat task.wait() until PlayerGui.InCombat.CanvasGroup.GroupTransparency == 1
			Player:Kick("Kicked by the leave after combat meanin you we're hit.")
		end
	end
end)

Player.Idled:Connect(function()
	VirtualManager:CaptureController()
	VirtualManager:ClickButton2(Vector2.new())
end)
