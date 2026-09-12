package.path = package.path .. ";../lib/?.lua"

ForFile = "resume.html"

local lib = require("lib.utils")
local json = require("json")

local function external_link_template(data)
	return lib.interp(
		[=[<a class="link-item" href="${link}">
<svg
xmlns="http://www.w3.org/2000/svg"
class="icon icon-tabler icon-tabler-external-link"
width="20"
height="20"
viewBox="0 0 24 24"
stroke-width="2"
stroke="currentColor"
fill="none"
stroke-linecap="round"
stroke-linejoin="round"
>
<path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
<path
d="M12 6h-6a2 2 0 0 0 -2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-6"
></path>
<path d="M11 13l9 -9"></path>
<path d="M15 4h5v5"></path>
</svg>
${link}
</a>]=],
		data
	)
end

local function card_template(data)
	return lib.interp(
		[=[<div class="card">
<div class="card-header">
<h3>${name}</h3>
<div class="role">${role}</div>
</div>
<div class="about">
${about}
</div>
<div class="links-group">
${links}
</div>
</div>]=],
		data
	)
end

local function side_project_template(data)
	return lib.interp(
		[=[<div class="card">
<h3>${name}</h3>
<div class="about">
${about}
</div>
</div>]=],
		data
	)
end

local function skill_row_template(data)
	return lib.interp(
		[=[<div class="skill-row">
<span class="skill-name">${name}</span>
<span class="skill-keywords">${keywords}</span>
</div>]=],
		data
	)
end

local function contribution_template(data)
	return lib.interp(
		[=[<div class="contrib-line">
<span class="contrib-name">${name}</span>
<span class="contrib-desc">${description}</span>
</div>]=],
		data
	)
end

local skills = {
	{
		name = "Frontend",
		keywords = "React.js, Angular, Preact, Vue.js, SASS, TypeScript, JavaScript",
	},
	{
		name = "Backend",
		keywords = "Node.js, Fastify, LoopBack.io, Express, GraphQL, REST APIs, Golang, Microservices",
	},
	{
		name = "Testing & Quality",
		keywords = "Jest, Vitest, Mocha, Playwright, Unit Testing, Integration Testing, Custom Testing Utilities",
	},
	{
		name = "Security",
		keywords = "Auth, JWT, OWASP, Auth0, API Security, Opaque Tokens",
	},
	{
		name = "Architecture",
		keywords = "Microservices, Event-Driven Architecture, Message Queues, Kafka, Caching Strategies",
	},
	{
		name = "DevOps & Monitoring",
		keywords = "Docker, CI/CD, GitHub Actions, Infrastructure Automation, Grafana, Dynatrace, Azure Monitoring, Build Systems",
	},
	{
		name = "Databases",
		keywords = "PostgreSQL, MySQL, MongoDB, Redis, Performance Optimization, Sharding, Foreign Data Wrappers",
	},
	{
		name = "Cloud",
		keywords = "AWS, GCP, Azure",
	},
	{
		name = "Project Management",
		keywords = "Kanban, JIRA, Code Reviews, Technical Mentoring",
	},
}

local side_projects = {
	{
		name = "Ping",
		about = "A non intrusive and simple uptime status check",
	},
	{
		name = "preact-island-plugins",
		about = "Low Level plugins to help build island based frameworks and build servers for preact",
	},
	{
		name = "Goblin",
		about = "Builds Go binaries on demand for users without Go installed",
	},
	{
		name = "mark",
		about = "Quick web markdown editor with settings sync and raw mode support",
	},
	{
		name = "commitlog",
		about = "Generate changelogs straight from Git commit history",
	},
}

local contributions = {
	{
		name = "tRPC",
		description = "Migration codemods in the upgrade CLI: TypeScript program scanner for import paths, AST walker fixes (3 merged PRs)",
	},
	{
		name = "zustand",
		description = "Core collaborator on build tooling and ESM/CJS interop fixes across v4 releases",
	},
	{
		name = "jotai",
		description = "Helped fix dual ESM/CJS package exports as a core collaborator",
	},
	{
		name = "eslint-plugin-valtio",
		description = "Maintainer: AST rules, performance fixes, and releases (2nd top contributor)",
	},
	{
		name = "jotai-form",
		description = "Long-time maintainer of form atoms for the jotai ecosystem",
	},
}

local work = {
	{
		name = "Bruno",
		about = [[<ul>
<li>Own the org's AWS infrastructure and SOC2 compliance work</li>
<li>Self-hosted AWS CI that scales with PR load</li>
<li>Lead security across the app and infrastructure, including threat surface, access control, and hardening</li>
<li>Keep CI and test coverage reliable so regressions surface before release</li>
<li>Tighten the merge-to-production path for consistent feature releases</li>
</ul>]],
		role = "Senior Software Developer, May 2026 - Present",
		links = external_link_template({
			link = "https://www.usebruno.com/",
		}),
	},
	{
		name = "Bruno",
		about = [[<ul>
<li>Shipped WebSocket support in the OSS desktop app for real-time workflows</li>
<li>Hardened core product features for reliability under load and edge cases</li>
<li>Improved UI consistency and release automation across OSS drops</li>
</ul>]],
		role = "Senior Software Developer, Oct 2025 - May 2026",
		links = external_link_template({
			link = "https://www.usebruno.com/",
		}),
	},
	{
		name = "Turbot",
		about = "Worked on modernising the turbot enterprise app and simplifying overall user experience when dealing with cloud governance",
		role = "Senior Software Architect, May 2025 - Aug 2025",
		links = "",
	},
	{
		name = "NearForm",
		about = "Work with OSS contributions from NearForm to various parts of the Node.js ecosystem. Maintain applications at scale and keep infrastructure design optimal",
		role = "Senior Software Developer, Jan 2024 - May 2025",
		links = external_link_template({
			link = "https://www.nearform.com/",
		}),
	},
	{
		name = "Fountane",
		about = "Managing teams, handling guidance, making sure the architecture and automations work, and getting hands dirty with code",
		role = "Principal Developer, Nov 2019 - Jan 2024",
		links = external_link_template({
			link = "https://fountane.com",
		}),
	},
	{
		name = "Valuefy",
		about = "Fintech is hard, number crunching, maintaining curation engines and handling wealth management based transactions all with the help of some code and making sure it worked",
		role = "Full Stack Developer, Sep 2018 - Sep 2019",
		links = external_link_template({
			link = "https://valuefy.com/",
		}),
	},
	{
		name = "Cartisan",
		about = "Worked with talented individuals on getting the simple car service and invoicing platform for the Indian market. This involved managing sequences of operations and avoiding race conditions, keep data clean, and refactoring some old code",
		role = "Full Stack Developer, Apr 2018 - Sep 2018",
		links = external_link_template({
			link = "https://wearexenon.com/",
		}),
	},
	{
		name = "RetailIO",
		about = "Built UI for SuperTax (React) and RetailIO (Angular); created shared components and a small internal UI library",
		role = "Frontend Developer, Jan 2018 - Apr 2018",
		links = external_link_template({
			link = "https://retailio.in/",
		}),
	},
}

function Writer(filedata)
	local source_data = json.decode(filedata)

	local content = source_data.content
	local side_project_cards = ""

	for _, project in ipairs(side_projects) do
		side_project_cards = side_project_cards .. side_project_template(project)
	end

	local skill_rows = ""
	for _, skill in ipairs(skills) do
		skill_rows = skill_rows .. skill_row_template(skill)
	end

	local contribution_rows = ""
	for _, entry in ipairs(contributions) do
		contribution_rows = contribution_rows .. contribution_template(entry)
	end

	local work_cards = ""
	for _, entry in ipairs(work) do
		work_cards = work_cards .. card_template(entry)
	end

	content = lib.interp(content, {
		side_project_cards = side_project_cards,
		skill_rows = skill_rows,
		contribution_rows = contribution_rows,
		work_cards = work_cards,
	})

	source_data.content = content

	return json.encode(source_data)
end
