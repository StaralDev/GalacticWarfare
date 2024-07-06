-- MIT License
-- 
-- Copyright (c) 2024 Dylan Marsee
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

local RunService = game:GetService("RunService")

local function UpdateSignal()
	if RunService:IsServer() then
		return RunService.Heartbeat
	else
		return RunService.RenderStepped
	end
end

local function Timer(duration: number, callback: () -> ()): () -> ()
	local accumulator = 0

	local function update(deltaTime: number)
		accumulator += deltaTime

		if accumulator >= duration then
			accumulator -= duration
			callback()
		end
	end

	local connection = UpdateSignal():Connect(update)

	return function()
		connection:Disconnect()
	end
end

return Timer