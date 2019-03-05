local BinaryLibMain = {}

--Yes, I know it's 2^bits - 1
--Shh. You'll see why.
local BYTE_MAX = 2^8
local SHORT_MAX = 2^16
local INT_MAX = 2^32

function BinaryLibMain.PadNumberText(text, digits)
	local length = text:len()
	if (length < digits) then
		for index = 1, digits - length do
			text = "0" .. text
		end
	end
	return text
end

function BinaryLibMain.NumberToBase(number, base, digits)
	--This only works for bases <= 10
	local textValue = ""
	repeat
		local mod = number % base
		number = math.floor(number / base)
		textValue = tostring(mod) .. textValue
	until number == 0
		
	if digits ~= nil then
		textValue = BinaryLibMain.PadNumberText(textValue, digits)
	end
	
	return textValue
end

function BinaryLibMain.newFile(path, mode)
	local BinaryLib = {}
	local fileObj = io.open(path, mode or "r+")

	function BinaryLib:write(value)
		if value < 0 then
			--Signed. To convert this to binary, we have to take the unsigned max + value (value is negative so it will subtract)
			--This new value should be converted over.
			--Luckily, if value is changed, then the condition below will also prevent signed bytes from being too low.
			value = BYTE_MAX + value
		end
		if value > BYTE_MAX then
			error("Error while writing, value is too low or high.")
		end
		
		local binVal = BinaryLibMain.NumberToBase(value, 2, 8)
		local B0 = tonumber(binVal, 2)
		fileObj:write(string.char(B0))
	end

	function BinaryLib:writeShort(value)
		if value < 0 then
			value = SHORT_MAX + value
		end
		if value > SHORT_MAX then
			error("Error while writing, value is too low or high.")
		end
		
		local binVal = NumberToBase(value, 2, 16)
		local B0 = tonumber(binVal:sub(-8), 2) --last 8 digits
		local B1 = tonumber(binVal:sub(-16, -9), 2) --first 8 digits
		local result = string.char(B1) .. string.char(B0)
		fileObj:write(result)
	end

	function BinaryLib:writeInt(value)
		if value < 0 then
			value = INT_MAX + value
		end
		if value > INT_MAX then
			error("Error while writing, value is too low or high.")
		end
		
		local binVal = NumberToBase(value, 2, 32)
		local B0 = tonumber(binVal:sub(-8), 2) --last 8 digits
		local B1 = tonumber(binVal:sub(-16, -9), 2)
		local B2 = tonumber(binVal:sub(-24, -17), 2)
		local B3 = tonumber(binVal:sub(-32, -25), 2) --first 8 digits
		local result = string.char(B3) .. string.char(B2) .. string.char(B1) .. string.char(B0)
		fileObj:write(result)
	end

	function BinaryLib:readByte()
		local R0 = fileObj:read(1)
		return string.byte(R0)
	end

	function BinaryLib:readShort()
		local R = fileObj:read(2)
		local R0 = R:sub(1, 1)
		local R1 = R:sub(2, 2)
				
		local P0 = NumberToBase(string.byte(R0), 2, 8)
		local P1 = NumberToBase(string.byte(R1), 2, 8)
		
		return tonumber(P0 .. P1, 2)
	end

	function BinaryLib:readInt()
		local R = fileObj:read(4)
		local R0 = R:sub(1, 1)
		local R1 = R:sub(2, 2)
		local R2 = R:sub(3, 3)
		local R3 = R:sub(4, 4)
		
		local P0 = NumberToBase(string.byte(R0), 2, 8)
		local P1 = NumberToBase(string.byte(R1), 2, 8)
		local P2 = NumberToBase(string.byte(R2), 2, 8)
		local P3 = NumberToBase(string.byte(R3), 2, 8)
		
		return tonumber(P0 .. P1 .. P2 .. P3, 2)--string.byte(R0) + string.byte(R1) + string.byte(R2) + string.byte(R3)
	end
	
	function BinaryLib:readSignedByte()
		local val = BinaryLib:readByte()
		return val - BYTE_MAX
	end

	function BinaryLib:readSignedShort()
		local val = BinaryLib:readShort()
		return val - SHORT_MAX
	end

	function BinaryLib:readSignedInt()
		local val = BinaryLib:readInt()
		return val - INT_MAX
	end

	function BinaryLib:close()
		fileObj:flush()
		fileObj:close()
		fileObj = nil
	end
	
	return BinaryLib
end


return BinaryLibMain
