local Lib = {}

function Lib.parseDates(datestr)
    local patterns = {
        '(%d+)-(%d+)-(%d+)',
        '(%d+)/(%d+)/(%d+)',
        '(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)',
    }

    local compiledDate

    for ptrnindex = 1,#patterns do
        local runday, runmonth, runyear = datestr:match(patterns[ptrnindex])
        if runday then
            if tonumber(runday) > 31
            then
                runyear, runmonth, runday = datestr:match(patterns[ptrnindex])
            end
            compiledDate = os.time({ year = runyear, month = runmonth, day = runday, hour = 0, min = 0,
                sec = 0 })
        end
    end
    return compiledDate
end

function Lib.getFirst100Lines(filepath)
    local f = io.open(filepath, "rb")
    if f
    then
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

function Lib.scandir(directory)
    local i, t, popen = 0, {}, io.popen
    
    local pfile = popen('ls -a "' .. directory .. '"')
    if pfile then
        for filename in pfile:lines() do
            i = i + 1
            t[i] = filename
        end
        pfile:close()
    end
    return t
end

return Lib
