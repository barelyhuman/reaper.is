package.path = package.path .. ";../lib/?.lua"

ForFile = "index.md"

local lib = require("lib.utils")
local yaml = require("yaml")
local strings = require("strings")
local json = require("json")
local alvu = require("alvu")

local function sortbydate(postone, posttwo)
	return postone.date > posttwo.date
end

function Writer(filedata)
	local basePath = "pages/writing"
	local files = alvu.files(basePath)
	local meta = {}

	for file = 1, #files do
		if not string.find(files[file], "index.md") then
			local name = string.gsub(files[file], ".md", "")
			name = string.gsub(name, ".html", "")

			local filecontent = lib.getfiledata(basePath .. "/" .. files[file])

			if filecontent then
				local match = strings.split(filecontent, "---")

				if match[2] then
					local frontmatterParsed = yaml.decode(match[2])
					local date = lib.parse_dates(frontmatterParsed.date)
					if not frontmatterParsed.rss_only then
						table.insert(meta, {
							content = match[3],
							slug = name,
							title = frontmatterParsed.title,
							date = date,
							formatteddate = os.date("%d-%m-%Y", date),
						})
					end
				end
			end
		end
	end

	table.sort(meta, sortbydate)

	local source_data = json.decode(filedata)
	local lastPost = meta[1]

  

	source_data = {
		content = "# " .. lastPost.title .. "\n" .. lastPost.content .. source_data.content,
		meta = {
			title = lastPost.title,
			date = lastPost.date,
		},
	}

	return json.encode(source_data)
end
