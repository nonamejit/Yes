if game.CoreGui:FindFirstChild("Discord") then
	game.CoreGui:FindFirstChild("Discord"):Destroy()
end

local Players			= game:GetService("Players")
local Replicated		= game:GetService("ReplicatedStorage")
local ReplicatedFirst	= game:GetService("ReplicatedFirst")
local VirtualManager	= game:GetService("VirtualInputManager")
local VirtualUser		= game:GetService("VirtualUser")
local TweenService		= game:GetService("TweenService")

local Player			= Players.LocalPlayer
local PlayerGui			= Player.PlayerGui
local Event				= Replicated.Events.EventCore

local UILibrary 		= loadstring(game:HttpGet(("https://raw.githubusercontent.com/ErrorRat/Yes/main/Test2.lua")))()
local MainWin			= UILibrary:Window("Asura's Demise 😈")

local MainSer			= MainWin:Server("Asura", "")

local Values			= {}

--Fuctions //

local function Eat()
	if PlayerGui.Main.HUD.Hunger.Clipping.Size.X.Scale <= Values["HungerValue"] and Values["HungerEnabled"] == true then
		for i,v in pairs(Player.Backpack:GetDescendants()) do
			if v.Name == "EatAnimation" and v:IsA("Animation") then
				if PlayerGui.Main.HUD.Hunger.Clipping.Size.X.Scale < 1 and Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
					local Humanoid	= Player.Character.Humanoid
					Humanoid:EquipTool(v.Parent)

					if v.Parent.Parent == Player.Character then
						v.Parent:Activate()
					end

					task.wait(tonumber(v.Parent:GetAttribute("EatTime")) + 0.5)

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
					ClosestPurDistance 	= (Character.HumanoidRootPart.Position - Part.Position).Magnitude
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
				ClosestPurDistance 		= (Character.HumanoidRootPart.Position - Part.Position).Magnitude
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


local function Punch()
	if Player.Character.Humanoid.WalkSpeed > 10 and Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
		Player.Character["Combat"]:Activate()
	end	
end

local function RunPunchingBags()
	local Character			= Player.Character
	local Humanoid			= Character.Humanoid

	if Values["PunchingBagsEnabled"] == true then
		local Purchase		= GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 25)
		local Bag			= GetClosestBag(15)

		if not Character:FindFirstChild("Gloves") then
			if not Player.Backpack:FindFirstChild("Strike "..Values["PunchingBagsType"].." Training") then
				if Purchase ~= nil then
					local Purchase		= GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 25)
					fireclickdetector(Purchase.ClickDetector)
				else 
					if Values["Debug"] == true then
						UILibrary:Notification("Failed", "Make sure you are close to the purchase button", "Close")
					end

					repeat task.wait() until GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 25) ~= nil or Values["PunchingBagsEnabled"] == false
					Purchase = GetClosestPurchase("Strike "..Values["PunchingBagsType"].." Training", 25)
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

				repeat task.wait() until GetClosestBag(15) ~= nil or Values["PunchingBagsEnabled"] == false
				Bag = GetClosestBag(15)
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
						if Child:IsA("BillboardGui") and Child:FindFirstChild("ImageLabel") and Child.Adornee.Name == "Main" and (HoldOffConnection == false and Values["PunchingRegenStam"] == true) or Values["PunchingRegenStam"] == false then
							if Hits <= 4 then
								Hits += 1; Punch()
							elseif Hits == 5 then
								Event:FireServer(unpack({[1] = "M2"})); Hits = 0
							end
							if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale <= Values["StaminaValue"] and HoldOffConnection == false then
								HoldOffConnection = true
								if Values["PunchingRegenStam"] == true and HoldOffConnection == true then
									repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["PunchingBagsEnabled"] == false
									HoldOffConnection = false
								end
							end
						end
					end)

					repeat task.wait() until not Character:FindFirstChild("Gloves") or Values["PunchingBagsEnabled"] == false
					Connection:Disconnect()

					if HoldOffConnection == true then
						repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["PunchingBagsEnabled"] == false
					end
				elseif Values["PunchingBagsType"] == "Speed" then
					if PlayerGui:FindFirstChildOfClass("BillboardGui") then
						if PlayerGui:FindFirstChildOfClass("BillboardGui").Adornee.Name == "Main" then
							local HoldOffConnection = false; local Hits = 0; 
							repeat task.wait()
								if (HoldOffConnection == true and Values["PunchingRegenStam"] == true) then
									repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["PunchingBagsEnabled"] == false
									HoldOffConnection = false
								end

								if PlayerGui:FindFirstChildOfClass("BillboardGui") and ((HoldOffConnection == false and Values["PunchingRegenStam"] == true) or Values["PunchingRegenStam"] == false) then
									if Hits <= 4 then
										Hits += 1; Punch()
									elseif Hits == 5 then
										Event:FireServer(unpack({[1] = "M2"})); Hits = 0
									end

									if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale <= Values["StaminaValue"] and HoldOffConnection == false then
										HoldOffConnection = true
									end
								end
							until not PlayerGui:FindFirstChildOfClass("BillboardGui") or not Character:FindFirstChild("Gloves") or Values["PunchingBagsEnabled"] == false

							if HoldOffConnection == true and PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale < 1 then
								repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["PunchingBagsEnabled"] == false
							end

							HoldOffConnection = false
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
						UILibrary:Notification("Failed", tostring(F), "Close")
					end
				end
			end
		end
	end
end

if PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame") then
	PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame"):Destroy()
end

local Hold = false
local function RunThreadmil()
	local Character			= Player.Character
	local Humanoid			= Character.Humanoid

	if Values["ThreadmilEnabled"] == true then
		if PlayerGui.TreadmillGain.Frame.Visible == false and PlayerGui.TreadmillGain.Frame2.Visible == false then
			local closestThreadmil = GetClosestTreadmil(15)
			if closestThreadmil ~= nil then
				fireclickdetector(closestThreadmil.ClickDetector)
			else
				if Values["Debug"] == true then
					UILibrary:Notification("Failed", "Make sure you are close to the threadmil", "Close")
				end

				repeat task.wait() until GetClosestTreadmil(15) ~= nil or Values["ThreadmilEnabled"] == false
				closestThreadmil = GetClosestTreadmil(15)
				fireclickdetector(closestThreadmil.ClickDetector)
			end

			repeat task.wait() until PlayerGui.TreadmillGain.Frame.Visible == true or Values["ThreadmilEnabled"] == false
			firesignal(PlayerGui.TreadmillGain.Frame[Values["ThreadmilType"]].MouseButton1Up)
		end
		
		if Hold == true then
			repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["ThreadmilEnabled"] == false
			Hold = false
		end

		task.wait(0.5)

		if PlayerGui.TreadmillGain.Frame2.Visible == true then
			if PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame") then
				if Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name] then
					VirtualManager:SendKeyEvent(true, Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name], 	false, nil)
					VirtualManager:SendKeyEvent(false, Enum.KeyCode[PlayerGui.TreadmillGain.Frame2.Keys:FindFirstChildOfClass("Frame").Name], false, nil)
				end
			end

			local HoldOffConnection = false; local Connection = PlayerGui.TreadmillGain.Frame2.Keys.ChildAdded:Connect(function(Child)
				if PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale > Values["StaminaValue"] and HoldOffConnection == false then
					if Child:IsA("Frame") then
						if Enum.KeyCode[Child.Name] then
							VirtualManager:SendKeyEvent(true, Enum.KeyCode[Child.Name], false, nil)
							VirtualManager:SendKeyEvent(false, Enum.KeyCode[Child.Name], false, nil)
						end
					end
				elseif HoldOffConnection == false then
					HoldOffConnection = true
					repeat task.wait() until PlayerGui.Main.HUD.Stamina.Clipping.Size.X.Scale >= 1 or Values["ThreadmilEnabled"] == false
					HoldOffConnection = false
				end
			end)

			repeat wait() until Player.Character.HumanoidRootPart.Anchored == false or Values["ThreadmilEnabled"] == false
			Connection:Disconnect()

			if HoldOffConnection == true then
				Hold = true
			end

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
		local OtherPlayer				= Players:FindFirstChild(Values["DuraSelected"])

		if OtherPlayer then
			Player.Character.Humanoid:UnequipTools()
			if DuraBoolValue == true then
				local closestPurchase	= GetClosestPurchase("Body Conditioning", 25)

				if not Player.Backpack:FindFirstChild("Body Conditioning") then
					if closestPurchase ~= nil then
						repeat task.wait()
							fireclickdetector(closestPurchase.ClickDetector)
						until Player.Backpack:FindFirstChild("Body Conditioning") or Values["DuraEnabled"] == false
					elseif closestPurchase == nil then
						if Values["Debug"] == true then
							UILibrary:Notification("Failed", "Make sure you are close to the purchase button", "Close")
						end

						repeat task.wait() until GetClosestPurchase("Body Conditioning", 25) ~= nil or Values["DuraEnabled"] == false	
						closestPurchase = GetClosestPurchase("Body Conditioning", 25)
						repeat task.wait()
							fireclickdetector(closestPurchase.ClickDetector)
						until Player.Backpack:FindFirstChild("Body Conditioning") or Values["DuraEnabled"] == false
					end
				end

				repeat task.wait()
					if Player.Backpack:FindFirstChild("Body Conditioning") and Values["DuraEnabled"] == true then
						Player.Character.Humanoid:EquipTool(Player.Backpack["Body Conditioning"])
					end
				until Player.Character:FindFirstChild("Body Conditioning") or Values["DuraEnabled"] == false
				
				local Starting = Player.Character:FindFirstChild("Body Conditioning") and Player.Character["Body Conditioning"]:GetAttribute("Count")
				repeat task.wait() until (Player.Character.HumanoidRootPart.Position - OtherPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 or Values["DuraEnabled"] == false
				repeat task.wait() until (OtherPlayer.Character:FindFirstChildOfClass("Tool") and OtherPlayer.Character:FindFirstChildOfClass("Tool").Name == "Combat") or Values["DuraEnabled"] == false

				repeat task.wait(1)
					if Player.Character.Humanoid.WalkSpeed > 1 and Player.Character:FindFirstChild("Body Conditioning") and Values["DuraEnabled"] == true then
						Player.Character:FindFirstChild("Body Conditioning"):Activate()
					end
				until Player.Character.Humanoid.WalkSpeed <= 1 or Values["DuraEnabled"] == false

				repeat task.wait() until not Player.Character:FindFirstChild("Body Conditioning") or not OtherPlayer.Character:FindFirstChild("Combat") or Values["DuraEnabled"] == false

				if Player.Character:FindFirstChild("Body Conditioning") and Player.Character["Body Conditioning"]:GetAttribute("Count") == Starting  then
					task.wait(1)
					if Player.Character:FindFirstChild("Body Conditioning") and Player.Character["Body Conditioning"]:GetAttribute("Count") == Starting  then
						repeat task.wait(1)
							if Values["DuraEnabled"] == true and Player.Character:FindFirstChild("Body Conditioning") and Player.Character["Body Conditioning"]:GetAttribute("Count") == Starting then
								Player.Character:FindFirstChild("Body Conditioning"):Activate()
							end
						until (Player.Character:FindFirstChild("Body Conditioning") and Player.Character["Body Conditioning"]:GetAttribute("Count") ~= Starting) or not Player.Character:FindFirstChild("Body Conditioning") or Values["DuraEnabled"] == false
					end
				else
					Player.Character.HumanoidRootPart.Anchored = true
				end
				
				task.wait(0.5)
				Player.Character.HumanoidRootPart.Anchored = false
			elseif DuraBoolValue == false then
				repeat task.wait() until ((Player.Character.HumanoidRootPart.Position - OtherPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 and OtherPlayer.Character:FindFirstChild("Body Conditioning")) or Values["DuraEnabled"] == false

				repeat task.wait()
					if Player.Backpack:FindFirstChild("Combat") and Values["DuraEnabled"] == true then
						Player.Character.Humanoid:EquipTool(Player.Backpack["Combat"])
					end	
				until Player.Character:FindFirstChild("Combat") or Values["DuraEnabled"] == false

				repeat task.wait() until (OtherPlayer.Character.Humanoid.WalkSpeed <= 1 and OtherPlayer.Character:FindFirstChild("Body Conditioning")) or Values["DuraEnabled"] == false

				local StartingHealth 	= OtherPlayer.Character.Humanoid.Health
				if Values["DuraEnabled"] == true then
					task.wait(1)
					Punch()
				end
				repeat task.wait() until OtherPlayer.Character.Humanoid.Health ~= StartingHealth
				StartingHealth = StartingHealth - OtherPlayer.Character.Humanoid.Health

				repeat task.wait()
					if Player.Character:FindFirstChild("Combat") and Values["DuraEnabled"] == true then
						if OtherPlayer.Character:FindFirstChild("Body Conditioning") then
							Punch()
						end
					end
				until ((OtherPlayer.Character.Humanoid.Health - StartingHealth) <= (StartingHealth * 3) and OtherPlayer.Character:FindFirstChild("Body Conditioning")) or (not OtherPlayer.Character:FindFirstChild("Body Conditioning")) or Values["DuraEnabled"] == false
			end

			Player.Character.Humanoid:UnequipTools()

			Eat()

			DuraBoolValue = not DuraBoolValue

			if DuraBoolValue == false then
				if OtherPlayer.Character.Humanoid.Health < OtherPlayer.Character.Humanoid.MaxHealth and Values["DuraEnabled"] == true then
					repeat task.wait() until OtherPlayer.Character.Humanoid.Health >= OtherPlayer.Character.Humanoid.MaxHealth or Values["DuraEnabled"] == false
				end	
			end

			if Values["DuraEnabled"] == true then
				local S, F = pcall(function()
					RunDura()
				end)

				if F and Values["Debug"] == true then
					UILibrary:Notification("Failed", tostring(F), "Close")
				end
			end
		end
	end
end

local AutofarmChan		= MainSer:Channel("Autofarm's")
AutofarmChan:Toggle("Strike Power/Speed Training", false, function(Value) 
	Values["PunchingBagsEnabled"] = Value
	if Value == true then
		local S, F = pcall(function()
			RunPunchingBags()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Power", {"Power", "Speed"}, function(Value) 
	Values["PunchingBagsType"] = Value
end)

AutofarmChan:Toggle("Regen stam mid train", false, function(Value) 
	Values["PunchingRegenStam"] = Value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Treadmil Training", false, function(Value) 
	Values["ThreadmilEnabled"] = Value
	if Value == true then
		local S, F = pcall(function()
			RunThreadmil()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Speed", {"Speed", "Stamina"}, function(Value) 
	Values["ThreadmilType"] = Value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Tool Training", false, function(Value) 
	Values["ToolEnabled"] = Value

	if Value == true then
		local S, F = pcall(function()
			RunAutoTool()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

AutofarmChan:Dropdown("Type of training", "Push Up", {"Push Up", "Squat", "Sit Up"}, function(Value) 
	Values["ToolType"]	= Value
end)

AutofarmChan:Seperator()

AutofarmChan:Toggle("Dura Training", false, function(Value) 
	Values["DuraEnabled"] 	= Value

	if Value == true then
		local OtherPlayer	= Players:FindFirstChild(Values["DuraSelected"])

		if OtherPlayer then
			if OtherPlayer.Character then
				if not OtherPlayer.Character:FindFirstChild("Body Conditioning") then
					DuraBoolValue = true
				elseif OtherPlayer.Character:FindFirstChild("Body Conditioning") then
					DuraBoolValue = false
				end
			end
		end

		local S, F = pcall(function()
			RunDura()
		end)

		if F and Values["Debug"] == true then
			UILibrary:Notification("Failed", tostring(F), "Close")
		end
	end
end)

local PlayerList = {}; for i,v in pairs(Players:GetPlayers()) do 
	if v ~= Player then
		table.insert(PlayerList, v.Name) 
	end
end

local DuraDropDown = AutofarmChan:Dropdown("Player to dura farm with", "", PlayerList, function(Value) 
	Values["DuraSelected"] = Value
end)

Players.PlayerAdded		:Connect(function(OtherPlayer) DuraDropDown:Add(OtherPlayer.Name) 	end)
Players.PlayerRemoving	:Connect(function(OtherPlayer) DuraDropDown:Remove(OtherPlayer.Name) end)

local MiscChan			= MainSer:Channel("Miscellaneous")
MiscChan:Toggle("Auto eat", false, function(Value) 
	Values["HungerEnabled"] = Value
end)

MiscChan:Slider("Hunger limit", 0, 100, 25, function(Value) 
	Values["HungerValue"] = Value * 0.01
end)

MiscChan:Seperator()

MiscChan:Slider("Stamina limit", 0, 100, 20, function(Value) 
	Values["StaminaValue"] = Value * 0.01
end)

MiscChan:Seperator()

MiscChan:Toggle("Disable on hit", false, function(Value) 
	Values["DisableOnHit"] = Value
end)
MiscChan:Label("Does not work for dura cause that doesn't make sense..")

MiscChan:Seperator()

MiscChan:Toggle("Disable on gangbase door's being attacked", false, function(Value) 
	Values["DisableGangBaseDoor"] = Value
end)
MiscChan:Label("Disable's everything apon the gang base door's being \nattacked (MUST OWN GANGBASE)")

MiscChan:Seperator()

MiscChan:Toggle("Disable on gangbase vault being attacked", false, function(Value) 
	Values["DisableVaultDoor"] = Value
end)
MiscChan:Label("Disable's everything apon the gang base vault being \nattacked")
MiscChan:Label("Not needed if u have gang base door being attacked on \n(MUST OWN GANGBASE)")

MiscChan:Slider("Disable when vault at health", 1, 100, 10, function(Value) 
	Values["VaultHealth"] = Value * 0.01
end) 

MiscChan:Seperator()

MiscChan:Toggle("Leave after combat", false, function(Value) 
	Values["LeaveAfterCombat"] = Value
end)
MiscChan:Label("If (on) this will kick you if gang base door/vault attacked \n(MUST OWN GANGBASE) Also disable on hit")

MiscChan:Seperator()

MiscChan:Toggle("Notify on gang base doors being attacked", false, function(Value) 
	Values["NotifyOnGangBaseDoors"] = Value
end)

MiscChan:Toggle("Sound on notify", false, function(Value) 
	Values["SoundNotifyEnabled"] = Value
end)

MiscChan:Slider("Sound volume", 0, 5, 1, function(Value) 
	Values["SoundVolume"] = Value
end)

MiscChan:Seperator()

MiscChan:Toggle("Debugger", false, function(Value) 
	Values["Debug"] = Value
end)

MiscChan:Seperator()

MiscChan:Bind("Turn off/on Gui", Enum.KeyCode.RightShift, function()
	if game.CoreGui.Discord.MainFrame.Size.X.Offset == 681 then
		game.CoreGui.Discord.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
	elseif game.CoreGui.Discord.MainFrame.Size.X.Offset == 0 then
		game.CoreGui.Discord.MainFrame:TweenSize(UDim2.new(0, 681, 0, 396), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
	end
end)

MiscChan:Seperator()

local NotifiyDeb = false 
for i,v in pairs(game.Workspace.GangBase.Hitable:GetChildren()) do
	if v.Name == "Door" then
		if v:FindFirstChild("Health") then
			v.Health.Bar.Fill:GetPropertyChangedSignal("Size"):Connect(function() 
				local V = v.Health.Bar.Fill.Size.X.Scale
				if V ~= 1 and NotifiyDeb == false and Player:IsInGroup(tonumber(game.Workspace.GangBase:GetAttribute("BaseOwner"))) then
					NotifiyDeb = true
					if Values["DisableGangBaseDoor"] == true then
						Values["PunchingBagsEnabled"] 	= false
						Values["ToolEnabled"]			= false
						Values["ThreadmilEnabled"]		= false
						Values["DuraEnabled"]			= false

						if Values["LeaveAfterCombat"] == true then
							if PlayerGui.InCombat.CanvasGroup.GroupTransparency ~= 1 then
								repeat task.wait() until PlayerGui.InCombat.CanvasGroup.GroupTransparency == 1
							end

							Player:Kick("Kicked by the leave after combat meanin gang base doors were being attacked.")
						end
					end

					if Values["NotifyOnGangBaseDoors"] == true then
						if not PlayerGui.Regions:FindFirstChild("Noti") then
							if PlayerGui.Regions:FindFirstChild("GYM") then
								local A = PlayerGui.Regions.GYM:Clone()
								A.Name	= "Noti"
								A.Parent = PlayerGui.Regions
							end
						end

						if PlayerGui.Regions:FindFirstChild("Noti") then
							PlayerGui.Regions:FindFirstChild("Noti").Text = "Gang base doors being attacked!"
							if Values["SoundNotifyEnabled"] == true then
								task.spawn(function() 
									local A 	= Instance.new("Sound")
									A.Parent 	= PlayerGui
									A.SoundId	= "rbxassetid://6522880384"
									A.Volume	= Values["SoundVolume"]
									A:Play()
									repeat task.wait() until A.IsPlaying == false
									A:Destroy()
								end)
							end

							TweenService:Create(PlayerGui.Regions:FindFirstChild("Noti"), TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
							task.wait(2)
							TweenService:Create(PlayerGui.Regions:FindFirstChild("Noti"), TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
						end
					end
				elseif NotifiyDeb == true and V >= 1 then
					NotifiyDeb = false
				end 
			end)
		end
	end
end

if not PlayerGui:FindFirstChild("VaultHealth") then
	game.Workspace.GangBase.Main.VaultHealth:Clone().Parent = PlayerGui
end

local function fireVault()
	local V = PlayerGui.VaultHealth.Bar.Fill.Size.X.Scale

	if (game.Workspace.GangBase.Outside.BillboardGui.Label.Text == "You need 10 players in the server for gang bases!" or V <= Values["VaultHealth"]) and Player:IsInGroup(tonumber(game.Workspace.GangBase:GetAttribute("BaseOwner"))) and Values["DisableVaultDoor"] == true then
		Values["PunchingBagsEnabled"] 	= false
		Values["ToolEnabled"]			= false
		Values["ThreadmilEnabled"]		= false
		Values["DuraEnabled"]			= false

		if Values["LeaveAfterCombat"] == true then
			if PlayerGui.InCombat.CanvasGroup.GroupTransparency ~= 1 then
				repeat task.wait() until PlayerGui.InCombat.CanvasGroup.GroupTransparency == 1
			end

			Player:Kick("Kicked by the leave after combat meanin gang base vault were being attacked.")
		end
	end
end

task.spawn(function() 
	while task.wait() do
		fireVault()
	end
end)

PlayerGui.InCombat.CanvasGroup:GetPropertyChangedSignal("GroupTransparency"):Connect(function(V)
	if V ~= 1 and Values["DisableOnHit"] == true and Player.Character.Humanoid.Health < Player.Character.Humanoid.MaxHealth then
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
	VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(0.1)
	VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
