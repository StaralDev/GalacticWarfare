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

local Switch = {}
Switch.__index = Switch

type condition = {
	match : any,
	run : () -> nil
}

function Switch.new(expression : any)
	return setmetatable({
		_expression = expression,
		_conditions = {},
		_default = nil
	}, Switch)
end

function Switch:case(condition : any, callback : () -> ())
	table.insert(self._conditions, {match = condition, run = callback} :: condition)
end

function Switch:default(callback : () -> ())
	self._default = callback
end

function Switch:run()
	for _, v : condition in self._conditions do
		if not (v.match == self._expression) then continue end
		v.run()
		return
	end
	if (self._default) then
		self._default()
	end
end

return Switch