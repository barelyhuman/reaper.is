package.path = package.path .. ";../lib/?.lua"

local json = require("json")

function Writer(filedata)
	local source_data = json.decode(filedata)
	local ignored_pages = { "index" }
	local name = string.gsub(source_data.name, ".md", "")
	name = string.gsub(name, ".html", "")
	local showNav = true

	for page_index = 1, #ignored_pages do
		if name == ignored_pages[page_index] then
			showNav = false
		end
	end

	local backLink = "/"
	local source_path = source_data.source_path or ""
	local section = source_path:match("pages/([^/]+)/")
	if section then
		backLink = "/" .. section .. "/"
	end


	return json.encode({
		data = {
			showNav = showNav,
			backLink = backLink,
		},
	})
end
