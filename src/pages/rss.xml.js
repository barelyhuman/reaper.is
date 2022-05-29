import rss from "@astrojs/rss";
import dateParser from "../api/posts";

const postImportResult = import.meta.globEager("./writing/**/*.md");
const posts = Object.values(postImportResult);

export const get = () =>
  rss({
    title: "Reaper's Rants,Notes and Stuff",
    description: "Just another developer's public space",
    site: import.meta.env.SITE || "https://reaper.im",
    items: posts.map((postItem) => {
        console.log({postItem})
        return {
            link:postItem.url,
            title: postItem.frontmatter.title,
            pubDate: dateParser(postItem.frontmatter.date),
          }
    }),
  });
