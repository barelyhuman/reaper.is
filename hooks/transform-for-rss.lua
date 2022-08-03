package.path = package.path .. ";../lib/?.lua"

local json = require("json")


function Writer(filedata)
    local source_data = json.decode(filedata);

    if source_data.name == "rss.xml"
    then 
        print("yo, rss here");
    end

    return json.encode(source_data)
end