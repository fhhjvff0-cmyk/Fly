-- Universal Fly Script (Delta / Mobile / PC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local Speed = 80

local BV
local BG

local Keys = {
	W = false,
	A = false,
	S = false,
	D = false
}

local function StartFly()
	if Flying then return end
	Flying = true

	BG = Instance.new("BodyGyro")
	BG.P = 9e4
	BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
	BG.CFrame = HRP.CFrame
	BG.Parent = HRP

	BV = Instance.new("BodyVelocity")
	BV.MaxForce = Vector3.new(9e9,9e9,9e9)
	BV.Velocity = Vector3.zero
	BV.Parent = HRP

	RunService.RenderStepped:Connect(function()
		if not Flying then return end

		local Camera = workspace.CurrentCamera
		local Direction = Vector3.zero

		if Keys.W then
			Direction += Camera.CFrame.LookVector
		end
		if Keys.S then
			Direction -= Camera.CFrame.LookVector
		end
		if Keys.A then
			Direction -= Camera.CFrame.RightVector
		end
		if Keys.D then
			Direction += Camera.CFrame.RightVector
		end

		BG.CFrame = Camera.CFrame

		if Direction.Magnitude > 0 then
			BV.Velocity = Direction.Unit * Speed
		else
			BV.Velocity = Vector3.zero
		end
	end)
end

local function StopFly()
	Flying = false

	if BG then
		BG:Destroy()
	end

	if BV then
		BV:Destroy()
	end
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.F then
		if Flying then
			StopFly()
		else
			StartFly()
		end
	end

	if input.KeyCode == Enum.KeyCode.W then
		Keys.W = true
	end
	if input.KeyCode == Enum.KeyCode.A then
		Keys.A = true
	end
	if input.KeyCode == Enum.KeyCode.S then
		Keys.S = true
	end
	if input.KeyCode == Enum.KeyCode.D then
		Keys.D = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then
		Keys.W = false
	end
	if input.KeyCode == Enum.KeyCode.A then
		Keys.A = false
	end
	if input.KeyCode == Enum.KeyCode.S then
		Keys.S = false
	end
	if input.KeyCode == Enum.KeyCode.D then
		Keys.D = false
	end
end)

print("Fly Script Loaded | Press F")
