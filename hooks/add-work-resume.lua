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
<h3><a href="${link}">${name}</a></h3>
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
<span class="contrib-name"><a class="contrib-link" href="${link}">${name}</a></span>
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

local side_projects = {}

local contributions = {
	{
		name = "gardener",
		description = "Cloudflare Workers AI agent that inspects codebases for stale deps, test gaps, doc drift, and anti-patterns; auto-opens PRs with fixes as a composite GitHub Action",
		link = "https://github.com/barelyhuman/gardener",
	},
	{
		name = "adex",
		description = "Preact framework built on top of Vite to make it easier to write full stack apps",
		link = "https://github.com/barelyhuman/adex",
	},
	{
		name = "conflicto",
		description = "Worktree and diff viewer app with a terminal compatible with AI agents",
		link = "https://github.com/barelyhuman/conflicto",
	},
	{
		name = "preact-island-plugins",
		description = "Low level plugins to help build island based frameworks and build servers for preact",
		link = "https://github.com/barelyhuman/preact-island-plugins",
	},
	{
		name = "Goblin",
		description = "Builds Go binaries on demand for users without Go installed",
		link = "https://github.com/barelyhuman/goblin",
	},
	{
		name = "tRPC",
		description = "Migration codemods in the upgrade CLI: TypeScript program scanner for import paths, AST walker fixes (3 merged PRs)",
		link = "https://github.com/trpc/trpc",
	},
	{
		name = "zustand",
		description = "Core collaborator on build tooling and ESM/CJS interop fixes across v4 releases",
		link = "https://github.com/pmndrs/zustand",
	},
	{
		name = "jotai",
		description = "Helped fix dual ESM/CJS package exports as a core collaborator",
		link = "https://github.com/pmndrs/jotai",
	},
	{
		name = "eslint-plugin-valtio",
		description = "Maintainer: AST rules, performance fixes, and releases (2nd top contributor)",
		link = "https://github.com/pmndrs/eslint-plugin-valtio",
	},
	{
		name = "jotai-form",
		description = "Long-time maintainer of form atoms for the jotai ecosystem",
		link = "https://github.com/jotai-labs/jotai-form",
	},
}

local work = {
	{
		name = "Bruno",
		about = [[<ul>
<li>Own the org's AWS infrastructure, security posture, and SOC2 compliance work. Locked down threat surface and access controls, then got audit-ready in ~4 months to unblock enterprise deals</li>
<li>Self-hosted AWS CI that scales with PR load. Cut GitHub runner spend as the team grew by ~10 devs and eliminated queue-based blockers on PRs</li>
<li>Keep CI and test coverage reliable so regressions surface before release. Raised coverage and caught issues pre-release, driving down rollback and patch-fire-drill frequency</li>
<li>Shipped WebSocket support in the OSS desktop app for real-time workflows. Unblocked a top community migration barrier; now serving ~2–3% of the 900K+ MAU userbase</li>
<li>Hardened core product features for reliability under load and edge cases. Improved handling of larger requests where the app historically struggled, lifting customer satisfaction</li>
</ul>]],
		role = "Staff Software Developer, Oct 2025 - Present",
		links = external_link_template({
			link = "https://www.usebruno.com/",
		}),
	},
	{
		name = "NearForm",
		about = [[<ul>
<li>Contributed to Mercurius (Fastify's GraphQL plugin) and @fastify/send</li>
<li>Drove performance initiatives for a high-scale production product</li>
<li>Improved reliability of Redis and search workflows built on top of it</li>
<li>Published on NearForm's blog about JavaScript memory management and garbage collection</li>
<li>Maintained applications at scale and kept infrastructure design practical to work with</li>
</ul>]],
		role = "Senior Software Developer, Jan 2024 - May 2025",
		links = external_link_template({
			link = "https://www.nearform.com/",
		}),
	},
	{
		name = "Fountane",
		about = [[<ul>
<li>Led engineering for Parkpoolr and Trunkdrop; shipped Impowered and Connecting Outdoors from architecture through launch</li>
<li>Owned tech stack, architecture, and CI/CD across web and hybrid mobile client projects</li>
<li>Standardised dev processes and org-wide automation so teams could ship under tight studio deadlines</li>
<li>Rolled out GraphQL/Hasura and internal DIY frameworks to cut API and scaffolding time on new builds</li>
<li>Built mobile release tooling: version sync across npm, Gradle, and iOS; Fastlane/Xcode CI on Mac runners</li>
<li>Mentored developers and maintained multiple production codebases for studio clients</li>
</ul>]],
		role = "Principal Developer, Nov 2019 - Jan 2024",
		links = external_link_template({
			link = "https://fountane.com",
		}),
	},
	{
		name = "Previous Employers",
		about = [[<ul>
<li><a href="https://valuefy.com/">Valuefy</a> — Full Stack Developer, Sep 2018 - Sep 2019. Fintech, curation engines, and wealth management transactions</li>
<li><a href="https://wearexenon.com/">Cartisan</a> — Full Stack Developer, Apr 2018 - Sep 2018. Car service and invoicing platform; managed race conditions and data integrity</li>
<li><a href="https://retailio.in/">RetailIO</a> — Frontend Developer, Jan 2018 - Apr 2018. Built UI for SuperTax (React) and RetailIO (Angular)</li>
</ul>]],
		role = "",
		links = "",
	},
}

function Writer(filedata)
	local source_data = json.decode(filedata)

	local content = source_data.content

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
		skill_rows = skill_rows,
		contribution_rows = contribution_rows,
		work_cards = work_cards,
	})

	source_data.content = content

	return json.encode(source_data)
end
