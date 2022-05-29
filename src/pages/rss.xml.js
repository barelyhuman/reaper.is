import rss from "@astrojs/rss";
import dateParser from "../api/posts";

const postImportResult = import.meta.globEager("./writing/**/*.md");
const posts = Object.values(postImportResult);
const site = import.meta.env.SITE || "https://reaper.im";

export const get = () =>
  rss({
    title: "Reaper's Rants,Notes and Stuff",
    description: "Just another developer's public space",
    site,
    items: posts.map((postItem) => {
      const description =
        postItem.rawContent && postItem.rawContent().split(" ").slice(0, 100).join(" ") + `...`;
        
      return {
        link: postItem.url,
        description,
        title: postItem.frontmatter.title,
        pubDate: dateParser(postItem.frontmatter.date),
      };
    }),
  });
