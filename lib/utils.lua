local Lib = {}

function Lib.get_timezone()
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)))
end

-- Return a timezone string in ISO 8601:2000 standard form (+hhmm or -hhmm)
function Lib.get_tzoffset(timezone)
	local h, m = math.modf(timezone / 3600)
	return string.format("%+.4d", 100 * h + 60 * m)
end

function Lib.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function Lib.parse_dates(datestr)
	local patterns = {
		"(%d+)-(%d+)-(%d+)",
		"(%d+)/(%d+)/(%d+)",
		"(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)",
	}

	local compiledDate

	for ptrnindex = 1, #patterns do
		local runday, runmonth, runyear = datestr:match(patterns[ptrnindex])
		if runday then
			if tonumber(runday) > 31 then
				runyear, runmonth, runday = datestr:match(patterns[ptrnindex])
			end
			compiledDate = os.time({ year = runyear, month = runmonth, day = runday, hour = 0, min = 0, sec = 0 })
		end
	end
	return compiledDate
end

function Lib.getfiledata(filepath)
	local f = io.open(filepath, "rb")
	if f then
		local lines = ""
		---@diagnostic disable-next-line: undefined-global
		for line in io.lines(filepath) do
			lines = lines .. line .. "\n"
		end
		return lines
	end
	return nil
end

function Lib.totitlecase(name)
	return string
		.gsub(name, "(%l)(%w*)", function(a, b)
			return string.upper(a) .. b
		end)
		:gsub("-", " ")
		:gsub("^%d+", "")
end


function Lib.interp(s, tab)
    return (s:gsub("\r?\n", " "):gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end


return Lib
