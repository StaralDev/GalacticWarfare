-- MIT License
-- 
-- Copyright © 2024 Staral
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function ApplyAnimation(humanoid : Humanoid, animator : Animator, idle : Animation, walk : Animation)
	local currentState: "Idle" | "Walking" = "Idle"

	local idleAnimation = animator:LoadAnimation(idle)
	idleAnimation.Looped = true

	task.defer(function()
		idleAnimation:Play()
	end)

	if (walk) then
		local walkAnimation = animator:LoadAnimation(walk)
		walkAnimation.Looped = true

		local connection = RunService.RenderStepped:Connect(function(dt)
			if (humanoid.MoveDirection.Magnitude > 0) then
				if (currentState == "Idle") then
					currentState = "Walking"
					idleAnimation:Stop()
					walkAnimation:Play()
				end
			else
				if (currentState == "Walking") then
					currentState = "Idle"
					walkAnimation:Stop()
					idleAnimation:Play()
				end
			end
		end)

		return function()
			connection:Disconnect()
		end
	end
end

return ApplyAnimation