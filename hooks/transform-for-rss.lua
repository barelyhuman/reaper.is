package.path = package.path .. ";../lib/?.lua"

local json = require("json")


-- will run but after the initial processing is done with
-- still not implemented in alvu, so this still needs work
function PostWriter(filedata)
    local source_data = json.decode(filedata);
    if source_data.name == "rss.xml"
    then 
        source_data.data = {
            name="reaper's notes,rants, and other stuff",
            description ="just another developer crying about stuff he doesn't wanna change",
            link="reaper.is",
        }
    end

    return json.encode(source_data)
end