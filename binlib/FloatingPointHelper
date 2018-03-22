local FloatingPointLib = {}

local function PadNumberText(text, digits)
	local length = text:len()
	if (length < digits) then
		for index = 1, digits - length do
			text = "0" .. text
		end
	end
	return text
end

local function NumberToBase(number, base, digits)
	--This only works for bases <= 10
	local textValue = ""
	repeat
		local mod = number % base
		number = math.floor(number / base)
		textValue = tostring(mod) .. textValue
	until number == 0
		
	if digits ~= nil then
		textValue = PadNumberText(textValue, digits)
	end
	
	return textValue
end

local function ToBinaryFraction(binary)
	local length = binary:len()
	local value = 0
	for index = 1, length do
		local bit = binary:sub(index, index)
		if bit == "1" then
			value = value + 1 / (2^index)
		end
	end
	return value
end

function FloatingPointLib:GetFloatingPoint(value)
	if type(value) ~= "number" and type(value) ~= "string" then
		return
	end
	if type(value) == "string" then
		if value:len() ~= 32 then
			return --Not 32 bits (floating point), stop.
		end
		for idx = 1, value:len() do
			local bit = value:sub(idx, idx)
			if bit ~= "0" and bit ~= "1" then
				return --Not a binary string, stop.
			end
		end
	end
	
	local binaryValue = NumberToBase(value, 2, 32)
	local S = binaryValue:sub(1, 1)
	local E = binaryValue:sub(2, 9)
	local M = binaryValue:sub(10, 32)	
	
	local sigFraction = ToBinaryFraction(M)
	
	local sign = (tonumber(S, 2) == 1) and -1 or 1
	local exponent = 2^(tonumber(E, 2)-127)
	local significand = 1 + sigFraction
	
	return sign * exponent * significand
end

return FloatingPointLib
