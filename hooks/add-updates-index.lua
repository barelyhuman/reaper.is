package.path = package.path .. ";../lib/?.lua"

ForFile = "updates/index.md"

local lib = require("lib.utils")
local yaml = require("yaml")
local strings = require("strings")
local json = require("json")
local alvu = require("alvu")

local function sortbydate(postone, posttwo)
	return postone.date > posttwo.date
end

function Writer(filedata)
	local basePath = "pages/updates"
	local files = alvu.files(basePath)
	local meta = {}

	for file = 1, #files do
		if not string.find(files[file], "index.md") then
			if not string.find(files[file], "_head.html") then
				local filecontent = lib.getfiledata(basePath .. "/" .. files[file])

				if filecontent then
					local match = strings.split(filecontent, "---")

					if match[2] then
						local frontmatterParsed = yaml.decode(match[2])
						local date = lib.parse_dates(frontmatterParsed.date)
						if not frontmatterParsed.rss_only then
							table.insert(meta, {
								date = date,
								content = match[3],
								formatteddate = os.date("%d-%m-%Y", date),
							})
						end
					end
				end
			end
		end
	end

	table.sort(meta, sortbydate)

	return json.encode({
		data = {
			updates = {
				pages = meta,
			},
		},
	})
end
