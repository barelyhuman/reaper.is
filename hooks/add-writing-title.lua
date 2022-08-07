package.path = package.path .. ";../lib/?.lua"

local json = require("json")
local strings = require("strings")

function Writer(filedata)
    local source_data = json.decode(filedata);
    if (strings.contains(source_data.source_path, "pages/writing"))
    then
        if source_data.meta and source_data.meta.title
        then
            source_data.content = "# " .. source_data.meta.title .. "\n" .. source_data.content
        end
    end
    return json.encode(source_data)
end
