import { Feed } from 'feed'
import { globby } from 'globby'
import fs from 'node:fs/promises'
import { parse } from 'yaml'

import dateParser from './src/api/posts.js'

const posts = await globby(['./src/pages/writing/*.md'])

const readMarkdownFile = async path => {
  const fileData = await fs.readFile(path, 'utf-8')
  const fileParts = fileData.split('---').filter(x => x)

  const content = fileParts[1]
  const frontMatter = fileParts[0]

  const parsedFM = parse(frontMatter)

  return {
    frontmatter: parsedFM,
    content,
  }
}

const feed = new Feed({
  title: "reaper's rants,notes and stuff",
  description: '',
  link: 'http://reaper.is/',
  copyright: 'All rights reserved 2022, Reaper',
  feedLinks: {
    rss: 'https://reaper.is/rss.xml',
  },
  author: {
    name: 'reaper',
    email: 'ahoy@barelyhuman.dev',
    link: 'https://reaper.is',
  },
})

const postAdditionPromises = posts.map(async file => {
  const { frontmatter, content } = await readMarkdownFile(file)
  const description = `${content.split(' ').slice(0, 100).join(' ')}...`

  // FIXME: replace with proper directory finding and
  // and then getting the base url from the astro config
  const link = `https://reaper.is/writing/${file
    .replace('./src/pages/writing/', '')
    .replace(/.md$/, '')}`

  feed.addItem({
    link,
    description,
    title: frontmatter.title,
    date: dateParser(frontmatter.date),
  })
})

await Promise.all(postAdditionPromises)

await fs.writeFile('dist/rss.xml', feed.rss2(), 'utf-8')
