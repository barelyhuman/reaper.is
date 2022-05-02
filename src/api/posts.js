import parse from "date-fns/parse";
import parseISO from "date-fns/parseISO";

export const getLatestPost = (posts) => {
  return posts.sort(sortPost).slice(0, 1)[0];
};

export const sortPost = (postOne, postTwo) => {
  return (
    dateParser(postTwo.frontmatter.date).valueOf() -
    dateParser(postOne.frontmatter.date).valueOf()
  );
};

export default function dateParser(dateString) {
  const formats = [
    "dd-MM-yyyy",
    "yyyy-MM-dd",
    "dd/MM/yyyy",
    "d/MM/yyyy",
    "yyyy-MM-dd HH:mm:ss",
  ];

  let validDate;

  const val = parseISO(dateString);
  if (!String(val).startsWith("Invalid Date")) {
    validDate = val;
  } else {
    for (let format of formats) {
      try {
        const val = parse(dateString, format, new Date());
        if (String(val).startsWith("Invalid Date")) {
          continue;
        }
        validDate = val;
        break;
      } catch (err) {
        continue;
      }
    }
  }

  return new Date(validDate) || "Invalid Date";
}
