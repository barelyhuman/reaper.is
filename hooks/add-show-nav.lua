package.path = package.path .. ";../lib/?.lua"

local json = require("json")

function Writer(filedata)
	local source_data = json.decode(filedata)
	local name = string.gsub(string.gsub(source_data.name, ".md", ""), ".html", "")
	local showNav = name ~= "index"

	local source_path = source_data.source_path or ""
	local section = source_path:match("pages/([^/]+)/")
	local backLink = (section and source_path ~= "pages/writing/index.md") and "/" .. section .. "/" or "/"

	return json.encode({
		data = {
			showNav = showNav,
			backLink = backLink,
		},
	})
end
