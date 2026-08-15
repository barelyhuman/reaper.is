local json = require("json")
local strings = require("strings")

local linkedin_icon =
	'<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-brand-linkedin" width="14" height="14" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"></path><path d="M8 11v5"></path><path d="M8 8v.01"></path><path d="M12 16v-5"></path><path d="M16 16v-3a2 2 0 1 0 -4 0"></path><path d="M3 7a4 4 0 0 1 4 -4h10a4 4 0 0 1 4 4v10a4 4 0 0 1 -4 4h-10a4 4 0 0 1 -4 -4z"></path></svg>'

local function escape_html(s)
	s = s:gsub("&", "&amp;")
	s = s:gsub("<", "&lt;")
	s = s:gsub(">", "&gt;")
	s = s:gsub('"', "&quot;")
	return s
end

local function titlecase_slug(s)
	s = s:gsub("-", " ")
	return s:gsub("(%a)([%w]*)", function(first, rest)
		return string.upper(first) .. rest
	end)
end

local function strip_query(url)
	return url:gsub("%?.*$", ""):gsub("#.*$", "")
end

local function parse_linkedin(url)
	local clean = strip_query(url)
	local path = clean:match("linkedin%.com(/.*)$")
	if not path then
		return nil
	end

	if not (path:find("^/posts/") or path:find("^/feed/update/")) then
		return nil
	end

	local vanity, slug = path:match("^/posts/([^/_]+)_([%w%-]+)%-activity%-%d+")
	if not vanity then
		vanity, slug = path:match("^/posts/([^/_]+)_([%w%-]+)%-ugcPost%-%d+")
	end

	local title = "LinkedIn post"
	local author = ""
	if slug then
		title = titlecase_slug(slug)
		local display = vanity:gsub("%-%d+$", "")
		if display == "" then
			display = vanity
		end
		author = titlecase_slug(display)
	end

	return {
		href = escape_html(clean),
		title = escape_html(title),
		author = escape_html(author),
	}
end

local function card_html(data)
	local author_line = ""
	if data.author ~= "" then
		author_line = '<div class="mt-1 text-gray text-xs">' .. data.author .. "</div>"
	end

	-- <div> so Goldmark treats this as a raw HTML block, not a paragraph
	return '<div class="linkedin-preview my-4">'
		.. '<a href="'
		.. data.href
		.. '" class="px-4 py-3 block rounded-md border border-light text-dark !no-underline hover:text-dark hover:no-underline hover:border-dark">'
		.. '<span class="flex gap-1 items-center text-gray text-xs">'
		.. linkedin_icon
		.. "LinkedIn</span>"
		.. '<div class="mt-1 font-semibold">'
		.. data.title
		.. "</div>"
		.. author_line
		.. "</a></div>"
end

local function standalone_url(line)
	local trimmed = line:match("^%s*(.-)%s*$")
	if not trimmed then
		return nil
	end

	-- markdown <url> autolink
	local wrapped = trimmed:match("^<(https?://[^>]+)>$")
	if wrapped then
		trimmed = wrapped
	end

	if not trimmed:match("^https?://") then
		return nil
	end

	if not strings.contains(trimmed, "linkedin.com/") then
		return nil
	end

	return trimmed
end

local function rewrite_content(content)
	local out = {}
	local in_fence = false

	for line in (content .. "\n"):gmatch("(.-)\n") do
		line = line:gsub("\r$", "")

		if line:match("^%s*```") then
			in_fence = not in_fence
			table.insert(out, line)
		elseif in_fence then
			table.insert(out, line)
		else
			local url = standalone_url(line)
			local parsed = url and parse_linkedin(url)
			if parsed then
				table.insert(out, "")
				table.insert(out, card_html(parsed))
				table.insert(out, "")
			else
				table.insert(out, line)
			end
		end
	end

	-- gmatch on content.."\n" always yields a final empty line; drop it
	if out[#out] == "" and not content:match("\n$") then
		table.remove(out)
	end

	return table.concat(out, "\n")
end

function Writer(filedata)
	local source_data = json.decode(filedata)

	if not source_data.content or not strings.contains(source_data.content, "linkedin.com") then
		return json.encode(source_data)
	end

	source_data.content = rewrite_content(source_data.content)
	return json.encode(source_data)
end
