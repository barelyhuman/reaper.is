local http = require("http")
local json = require("json")

ForFile = "packages.md"

local npm_url = "https://api.npmjs.org/downloads/point/last-month/"

local function get_downloads_for_pkg(pkg_name)
    local response,error_message = http.get(npm_url..pkg_name)
    local body_json = json.decode(response.body)
    return body_json.downloads
end

local packages = {
    "@barelyhuman/tocolor",
    "@barelyhuman/pipe",
    "@barelyhuman/preact-island-plugins",
    "@barelyreaper/themer",
    "jotai-form"
}

function Writer(source_data)
    local source = json.decode(source_data)

    local downloads_table = {}

    for k,pkg_name in ipairs(packages) do
        local download_count = get_downloads_for_pkg(pkg_name)
        table.insert(downloads_table,{
            title = pkg_name,
            downloads = download_count
        })
    end

    return json.encode({
		data = {
			packages = downloads_table,
		},
	})
end
