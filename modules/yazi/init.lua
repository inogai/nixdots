-- Helper function to convert permission string to octal format
local function perm_to_octal(perm_str)
	if not perm_str or #perm_str < 10 then
		return "-"
	end

	-- Parse drwxr-xr-x format to octal (skip first char which is file type)
	local bits = 0

	-- Owner permissions (positions 2-4)
	if perm_str:sub(2, 2) == "r" then
		bits = bits + 400
	end
	if perm_str:sub(3, 3) == "w" then
		bits = bits + 200
	end
	if perm_str:sub(4, 4) == "x" or perm_str:sub(4, 4) == "s" then
		bits = bits + 100
	end

	-- Group permissions (positions 5-7)
	if perm_str:sub(5, 5) == "r" then
		bits = bits + 40
	end
	if perm_str:sub(6, 6) == "w" then
		bits = bits + 20
	end
	if perm_str:sub(7, 7) == "x" or perm_str:sub(7, 7) == "s" then
		bits = bits + 10
	end

	-- Other permissions (positions 8-10)
	if perm_str:sub(8, 8) == "r" then
		bits = bits + 4
	end
	if perm_str:sub(9, 9) == "w" then
		bits = bits + 2
	end
	if perm_str:sub(10, 10) == "x" or perm_str:sub(10, 10) == "t" then
		bits = bits + 1
	end

	-- Handle special bits (suid, sgid, sticky)
	if perm_str:sub(4, 4) == "s" then
		bits = bits + 4000
	end -- suid
	if perm_str:sub(7, 7) == "s" then
		bits = bits + 2000
	end -- sgid
	if perm_str:sub(10, 10) == "t" then
		bits = bits + 1000
	end -- sticky

	return tostring(bits)
end

-- Helper function to format time in lateral format
local function format_lateral_time(timestamp)
	if not timestamp or timestamp == 0 then
		return "-"
	end

	if timestamp == 1 then
		return "~"
	end

	local now = os.time()
	local diff = now - timestamp

	if diff < 60 then
		return "<1m"
	end

	-- Compute number and unit
	local number, unit
	if diff < 3600 then
		number = math.floor(diff / 60)
		unit = "m"
	elseif diff < 86400 then
		number = math.floor(diff / 3600)
		unit = "h"
	elseif diff < 2592000 then
		number = math.floor(diff / 86400)
		unit = "d"
	elseif diff < 31536000 then
		number = math.floor(diff / 2592000)
		unit = "M"
	else
		number = math.floor(diff / 31536000)
		unit = "y"
	end

	-- Format with space padding if number < 10
	if number < 10 then
		return string.format(" %d%s", number, unit)
	else
		return string.format("%d%s", number, unit)
	end
end

-- Helper function to format file size with 1 decimal place and proper unit scaling
local function format_file_size(size)
	-- Compute number and unit
	local number, unit
	if size <= 100 then
		number = size
		unit = "  B"
	elseif size <= 100 * 1024 then
		number = size / 1024
		unit = "KiB"
	elseif size <= 100 * 1024 * 1024 then
		number = size / (1024 * 1024)
		unit = "MiB"
	elseif size <= 100 * 1024 * 1024 * 1024 then
		number = size / (1024 * 1024 * 1024)
		unit = "GiB"
	else
		number = size / (1024 * 1024 * 1024 * 1024)
		unit = "TiB"
	end

	-- Format with space padding if number < 10
	if number < 10 then
		return string.format(" %.1f %s", number, unit)
	else
		return string.format("%.1f %s", number, unit)
	end
end

function Linemode:custom()
	-- Get permissions using correct method
	local perm_str = self._file.cha:perm()
	local octal = perm_to_octal(perm_str)

	-- Get modification time
	local time = math.floor(self._file.cha.mtime or 0)
	local time_str = format_lateral_time(time)

	-- Get file sizfe
	local size_str = ""

	if not self._file.cha.is_dir then
		local size = self._file:size() or 0
		size_str = format_file_size(size)
	end

	return string.format("%4s %4s %9s", octal, time_str, size_str)
end
