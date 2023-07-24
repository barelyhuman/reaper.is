package.path = package.path .. ";../lib/?.lua"

local strings = require("strings")
local json = require("json")
local alvu = require("alvu")

function Writer(filedata)
    local source_data = json.decode(filedata)
	local ignored_pages = {"index"}
    local name = string.gsub(source_data.name, ".md", "")
    name = string.gsub(name, ".html", "")
    local showNav = true
    
    
        for page_index = 1, #ignored_pages do 
            if name == ignored_pages[page_index] then
                showNav = false
            end 
        end 
    

	return json.encode({
		data = {
			showNav = showNav
		},
	})
end
