package.path = package.path .. ";../lib/?.lua"

local lib = require("lib.utils")
local yaml = require("yaml")
local strings = require("strings")
local json = require("json")

local function sortbydate(postone, posttwo)
    return postone.date > posttwo.date
end

function Writer(filedata)
    local basePath = "pages/writing"
    local files = lib.scandir(basePath)
    local meta = {}
    local source_data = json.decode(filedata)

    for file = 1, #files do
        if not string.find(files[file], "index.md") then
            if not string.find(files[file], ".lua")
                and not (
                string.find(files[file], "^.$")
                    or string.find(files[file], "^..$")
                    or string.find(files[file], "_head.html")
                )
            then
                local name = string.gsub(files[file], ".md", "")
                name = string.gsub(name, ".html", "")

                ---@diagnostic disable-next-line: undefined-global
                local filecontent = lib.getFirst100Lines(basePath .. "/" .. files[file])
                local match = strings.split(filecontent, "---")

                if (match[2]) then
                    local frontmatterParsed = yaml.decode(match[2])
                    local date = lib.parseDates(frontmatterParsed.date)
                    if not frontmatterParsed.rss_only
                    then
                        table.insert(meta, {
                            slug = name,
                            title = frontmatterParsed.title,
                            date = date,
                            formatteddate = os.date("%d-%m-%Y", date)
                        })
                    end
                end
            end
        end
    end

    table.sort(meta, sortbydate)

    return json.encode({
        data = {
            writing = {
                pages = meta
            }
        }
    })
end
