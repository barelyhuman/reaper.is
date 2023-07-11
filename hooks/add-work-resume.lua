package.path = package.path .. ";../lib/?.lua"

ForFile = 'resume.html'

local lib = require("lib.utils")
local yaml = require("yaml")
local strings = require("strings")
local json = require("json")
local alvu = require("alvu")

local function external_link_template(data)
    return lib.interp([=[<a class="link-item" href="${link}">
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
</a>]=],data)
end

local function source_link_template(data)
    return lib.interp([=[<a class="link-item" href="${link}">
<svg
xmlns="http://www.w3.org/2000/svg"
class="icon icon-tabler icon-tabler-brand-github"
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
    d="M9 19c-4.3 1.4 -4.3 -2.5 -6 -3m12 5v-3.5c0 -1 .1 -1.4 -.5 -2c2.8 -.3 5.5 -1.4 5.5 -6a4.6 4.6 0 0 0 -1.3 -3.2a4.2 4.2 0 0 0 -.1 -3.2s-1.1 -.3 -3.5 1.3a12.3 12.3 0 0 0 -6.2 0c-2.4 -1.6 -3.5 -1.3 -3.5 -1.3a4.2 4.2 0 0 0 -.1 3.2a4.6 4.6 0 0 0 -1.3 3.2c0 4.6 2.7 5.7 5.5 6c-.6 .6 -.6 1.2 -.5 2v3.5"
></path>
</svg>
${repo}
</a>]=],data)
end

local function card_template(data)
    return lib.interp([=[<div class="card">
<h3>${name}</h3>
<div class="about">
${about}
</div>
<div class="footer">
<div class="role">${role}</div>
<div class="links-group">
${links}
</div>
</div>
</div>]=], data)
end

local oss_work = {
    [1] = {},
    {
        name = "preact-island-plugins",
        about = [[
            Bundler plugins to be able to generate server and client code to write preact components as islands or partially hydrated server rendered components
        ]],
        role = "Author",
        links = source_link_template({
            link = "https://github.com/barelyhuman/preact-island-plugins",
            repo = "barelyhuman/preact-island-plugins",
        }) 
    },
    {
        name = "preact-native",
        about = [[
            An attempt at creating an abstraction layer over the react native bridge to add in support for other 
            web frameworks to be able to make use of the cross platform renderer
        ]],
        role = "Author",
        links = source_link_template({
            link = "https://github.com/barelyhuman/preact-native",
            repo = "barelyhuman/preact-native",
        }) 
    },
    {
        name = "goblin.run",
        about = [[
            A simple service that allows you to build go lang binaries on the fly for the requested system.
            Gives CLI authors a easy way to provide their binaries to the end users.
        ]],
        role = "Author",
        links = source_link_template({
            link = "https://github.com/barelyhuman/goblin",
            repo = "barelyhuman/goblin",
        }) 
        .. external_link_template({
            link = "https://goblin.run"
        }),
    },
    {
        name = "alvu",
        about = [[
            The very static site generator powering this website and the resume. An attempt at building a
            scriptable static site generator that uses the simplicity of Lua to add programmatic computation 
            at build time
        ]],
        role = "Author",
        links = source_link_template({
            link = "https://github.com/barelyhuman/alvu",
            repo = "barelyhuman/alvu",
        }) 
        .. external_link_template({
            link = "https://barelyhuman.github.io/alvu"
        }),
    },
    {
        name = "jotai-form",
        about = "A derivative of jotai state atoms to make it easier to work with forms",
        role = "Maintainer",
        links = source_link_template({
            link = "https://github.com/jotaijs/jotai-form",
            repo = "barelyhuman/alvu",
        }) 
    },
    {
        name = "Zustand",
        about = "A micro state management library for react, also easier to learn when compared to other alternatives",
        role = "Contributor",
        links = source_link_template({
            link = "https://github.com/pmndrs/zustand",
            repo = "pmndrs/zustand",
        }) 
    },
    {
        name = "Jotai",
        about = "Atom based state management for vanilla js and react based on treating primitive state as atoms",
        role = "Contributor",
        links = source_link_template({
            link = "https://github.com/pmndrs/jotai",
            repo = "pmndrs/jotai",
        }) 
    },
    {
        name = "Valtio",
        about = [[
            Proxy based state handling for react and vanilla js. 
            Makes state changes more natural as compared to the hooks
        ]],
        role = "Contributor",
        links = source_link_template({
            link = "https://github.com/pmndrs/valtio",
            repo = "pmndrs/valtio",
        }) 
    },
    {
        name = "eslint-plugin-valtio",
        about = [[
            ESLINT plugin for valtio users to avoid making mistakes when 
            working with proxy and snapshot based state
        ]],
        role = "Contributor",
        links = source_link_template({
            link = "https://github.com/pmndrs/eslint-plugin-valtio",
            repo = "pmndrs/eslint-plugin-valtio",
        }) 
    },
    {
        name = "commitlog",
        about = [[
           A tool built for programmers who work with more than one language and would 
           prefer a common versioning and changelog generation tooling
        ]],
        role = "Author",
        links = source_link_template({
            link = "https://github.com/barelyhuman/commitlog",
            repo = "barelyhuman/commitlog",
        }) 
    },
}  

local work = {
    [1] = {},
    {
        name = "Fountane",
        about = [[
            Managing teams, handling guidance, 
            making sure the architecture and automations works and finally, get hands dirty with code.
        ]],
        role = "Principal Developer (Nov 2019 - Present)",
        links = external_link_template({
            link = "https://fountane.com"
        })
    },
    {
        name = "Valuefy",
        about = [[
            Fintech is hard, number crunching, maintaing curation engines and handling wealth management based transactions 
            all with the help of some code and making sure it worked
        ]],
        role = "Full Stack Developer (Sep 2018 - Sep 2019)",
        links = external_link_template({
            link = "https://valuefy.com/"
        })
    },
    {
        name = "Cartisan",
        about = [[
            Worked with talented individuals on getting the simple car service and invoicing platform for the Indian market. 
            This involved managing sequences of operations and avoiding race conditions, keep data clean, and refactoring some old code
        ]],
        role = "Full Stack Developer (Apr 2018 - Sep 2018)",
        links = external_link_template({
            link = "https://wearexenon.com/"
        })
    },
    {
        name = "RetailIO",
        about = [[
Met my first set of mentors here, worked on the UI of 2 products. SuperTax and RetailIO, one with React and one with Angular respectively. 
The time spent was short due to various unforseen reasons but it was worth it. 

Made components and a tiny UI library for the above 2 products internally
]],
        role = "Frontend Developer (Apr 2018 - Sep 2018)",
        links = external_link_template({
            link = "https://retailio.in/"
        })
    },
    {
        name = "HoppApp",
        about = [[
Talk about getting lucky before even graduating and working as the Core/Founding frontend engineer for a startup. 

Built the Admin portal for a ride sharing app that HoppApp was building, learnt the basics of industrial standards for
a Senior Developer at Oracle and experience that got me addicted to working with just startups.
]],
        role = "Angular Developer (Sep 2016 - May 2017)",
        links = external_link_template({
            link = "https://www.hoppapp.com/"
        })
    }
}

function Writer(filedata)
    local source_data = json.decode(filedata)

    local content = source_data.content
    local oss_cards = ""

    for k,v in pairs(oss_work) do 
        oss_cards = oss_cards..card_template(v)
    end

    local work_cards = ""
    for k,v in pairs(work) do 
        work_cards = work_cards..card_template(v)
    end

    content = lib.interp(content,{
        oss_cards = oss_cards
    })

    content = lib.interp(content,{
        work_cards = work_cards
    })

    source_data.content = content

    return json.encode(source_data)
end
