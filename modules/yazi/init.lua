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

	local now = os.time()
	local diff = now - timestamp

	if diff < 60 then
		return "just now"
	elseif diff < 3600 then
		local mins = math.floor(diff / 60)
		return mins .. " min" .. (mins > 1 and "s" or "") .. " ago"
	elseif diff < 86400 then
		local hours = math.floor(diff / 3600)
		return hours .. " hr" .. (hours > 1 and "s" or "") .. " ago"
	elseif diff < 2592000 then
		local days = math.floor(diff / 86400)
		return days .. " day" .. (days > 1 and "s" or "") .. " ago"
	elseif diff < 31536000 then
		local months = math.floor(diff / 2592000)
		return months .. " mo" .. (months > 1 and "s" or "") .. " ago"
	else
		local years = math.floor(diff / 31536000)
		return years .. " yr" .. (years > 1 and "s" or "") .. " ago"
	end
end

function Linemode:perm_time()
	-- Get permissions using correct method
	local perm_str = self._file.cha:perm()
	local octal = perm_to_octal(perm_str)

	-- Get modification time
	local time = math.floor(self._file.cha.mtime or 0)
	local time_str = format_lateral_time(time)

	-- Return combined string (not UI components)
	return string.format("%-4s %-12s", octal, time_str)
end

