package.path = package.path .. ";../lib/?.lua"

local json = require("json")
local lib = require("lib.utils")
local strings = require("strings");

local sitemap_tmp_file_name = "dist/sitemap_tmpl.xml"
local sitemap_file_name = "dist/sitemap.xml"

-- this specific implementation only considers the writing
-- section of the blog to be a necessary part of the sitemap
-- if you wish to add more functionatliy
-- you'll have to modify this to do that

local function sitemap_template(data)
    return lib.interp([=[
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http:www.w3.org/1999/xhtml">
  ${itembody}
</urlset>]=], data)
end

local function sitemap_item_template(data)
    return lib.interp([=[<url>
        <loc>${url}</loc>
        <lastmod>${date}</lastmod>
        <priority>1.00</priority>
</url>
]=]  , data)
end

function OnStart()
    os.remove(sitemap_file_name)
    os.remove(sitemap_tmp_file_name)
end

function Writer(filedata)
    local source_data = json.decode(filedata);
    local rssfile = io.open(sitemap_tmp_file_name, "a")
    if rssfile
    then
        if strings.contains(source_data.source_path, "pages/writing")
        then

            local sitemap_info = {}

            if source_data.meta
            then
                local date = lib.parse_dates(source_data.meta.date)
                local offset = lib.get_tzoffset(lib.get_timezone())
                local weekday = lib.totitlecase(os.date("%a", date))
                -- 2022-08-21T11:44:02+00:00
                local pubDate = lib.interp(os.date("!%Y-%m-%dT%X", date) .. "${offset}", {
                    offset = offset
                })

                local nameWithoutExt = strings.trim(source_data.name, ".html")
                nameWithoutExt = strings.trim(source_data.name, ".md")
                local link = "https://reaper.is/" .. nameWithoutExt
                sitemap_info.url = link
                sitemap_info.date = pubDate
                rssfile:write(sitemap_item_template(sitemap_info))
            end
        end

        io.close(rssfile)
    end

    return json.encode(source_data)
end

function OnFinish()
    local sitemap_temp_fd = io.open(sitemap_tmp_file_name, "r")
    local sitemap_fd = io.open(sitemap_file_name, "w")
    if sitemap_temp_fd and sitemap_fd
    then
        local body = ""
        for c in sitemap_temp_fd:lines() do
            body = body .. "\n" .. c
        end

        local sitemap_data = sitemap_template({
            itembody = body
        })

        sitemap_fd:write(sitemap_data)
        os.remove(sitemap_tmp_file_name)
    end
end
