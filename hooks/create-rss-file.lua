package.path = package.path .. ";../lib/?.lua"

local json = require("json")
local lib = require("lib.utils")
local strings = require("strings");

local function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

local function rss_template(data)
    return interp([=[
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title>${site_name}</title>
  <link>${site_link}</link>
  <description>${site_description}</description>
  <atom:link href="${site_link}/rss.xml" rel="self" type="application/rss+xml" />
  ${itembody}
</channel>
</rss>
    ]=], data)
end

local function item_template(data)
    return interp([=[
    <item>
        <guid>${slug}</guid>
        <title>${title}</title>
        <link>${link}</link>
        <description>
        <![CDATA[${description}]]>
        </description>
        <pubDate>${date}</pubDate>
    </item>
    ]=], data)
end

function OnStart()
    os.remove("dist/rss_tmpl.xml")
end

function Writer(filedata)
    local source_data = json.decode(filedata);
    local rssfile = io.open("dist/rss_tmpl.xml", "a")
    if rssfile
    then
        if strings.contains(source_data.source_path, "pages/writing")
        then

            local post_info = {}

            if source_data.meta
            then
                local date = lib.parse_dates(source_data.meta.date)
                local offset = lib.get_tzoffset(lib.get_timezone())
                local weekday = lib.totitlecase(os.date("%a", date))
                local pubDate = interp("${weekday}, " .. os.date("%d %b %Y %X", date) .. " ${offset}", {
                    weekday = weekday,
                    offset = offset
                })

                local nameWithoutExt = strings.trim(source_data.name, ".html")
                nameWithoutExt = strings.trim(source_data.name, ".md")
                local link = "https://reaper.is/" .. nameWithoutExt
                post_info.slug = link
                post_info.title = source_data.meta.title
                post_info.link = link
                post_info.description = source_data.html
                post_info.date = pubDate
                rssfile:write(item_template(post_info))
            end
        end

        io.close(rssfile)
    end

    return json.encode(source_data)
end

function OnFinish()
    local rss_temp_fd = io.open("dist/rss_tmpl.xml", "r")
    local rss_fd = io.open("dist/rss.xml", "w")
    if rss_temp_fd and rss_fd
    then
        local body = ""
        for c in rss_temp_fd:lines() do
            body = body .. "\n" .. c
        end

        local rss_data = rss_template({
            site_name = "reaper",
            site_link = "https://reaper.is",
            site_description = "reaper's rants,notes and stuff",
            itembody = body
        })

        rss_fd:write(rss_data)
    end
end
