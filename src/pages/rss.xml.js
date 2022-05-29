import rss from '@astrojs/rss'
import dateParser from '../api/posts'

export async function get() {
  const postImportResult = import.meta.globEager('./writing/**/*.md')
  const posts = Object.values(postImportResult)
  const site = import.meta.env.SITE || 'https://reaper.im'

  const postPromises = posts.map(async (postItem) => {
    const description
      = `${postItem.rawContent().split(' ').slice(0, 100).join(' ')}...`

    return {
      link: postItem.url,
      description,
      title: postItem.frontmatter.title,
      pubDate: dateParser(postItem.frontmatter.date),
    }
  })

  const postItems = await Promise.all(postPromises)

  const response = await rss({
    title: 'Reaper\'s Rants,Notes and Stuff',
    description: 'Just another developer\'s public space',
    site,
    items: postItems,
  })

  return response
}

