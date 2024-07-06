-- EnumList
-- Stephen Leitnick
-- January 08, 2021

-- MIT License
-- 
-- Copyright © 2024 Stephen Leitnick
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

type EnumNames = { string }

--[=[
	@interface EnumItem
	.Name string
	.Value number
	.EnumType EnumList
	@within EnumList
]=]
export type EnumItem = {
	Name: string,
	Value: number,
	EnumType: any,
}

local LIST_KEY = newproxy()
local NAME_KEY = newproxy()

local function CreateEnumItem(name: string, value: number, enum: any): EnumItem
	local enumItem = {
		Name = name,
		Value = value,
		EnumType = enum,
	}
	table.freeze(enumItem)
	return enumItem
end

--[=[
	@class EnumList
	Defines a new Enum.
]=]
local EnumList = {}
EnumList.__index = EnumList

--[=[
	@param name string
	@param enums {string}
	@return EnumList
	Constructs a new EnumList.

	```lua
	local directions = EnumList.new("Directions", {
		"Up",
		"Down",
		"Left",
		"Right",
	})

	local direction = directions.Up
	```
]=]
function EnumList.new(name: string, enums: EnumNames)
	assert(type(name) == "string", "Name string required")
	assert(type(enums) == "table", "Enums table required")
	local self = {}
	self[LIST_KEY] = {}
	self[NAME_KEY] = name
	for i, enumName in ipairs(enums) do
		assert(type(enumName) == "string", "Enum name must be a string")
		local enumItem = CreateEnumItem(enumName, i, self)
		self[enumName] = enumItem
		table.insert(self[LIST_KEY], enumItem)
	end
	return table.freeze(setmetatable(self, EnumList))
end

--[=[
	@param obj any
	@return boolean
	Returns `true` if `obj` belongs to the EnumList.
]=]
function EnumList:BelongsTo(obj: any): boolean
	return type(obj) == "table" and obj.EnumType == self
end

--[=[
	Returns an array of all enum items.
	@return {EnumItem}
	@since v2.0.0
]=]
function EnumList:GetEnumItems()
	return self[LIST_KEY]
end

--[=[
	Get the name of the enum.
	@return string
	@since v2.0.0
]=]
function EnumList:GetName()
	return self[NAME_KEY]
end

export type EnumList = typeof(EnumList.new(...))

return EnumList