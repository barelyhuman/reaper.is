const extractor = (content) => {
  return content.match(/[A-z0-9-:.\/]+/g);
};

module.exports = {
  content: ["out/**/*.html"],
  css: ["out/styles/*.css"],
  output: "./out/styles",
  extractors: [
    {
      extractor: extractor,
      extensions: ["html"],
    },
  ],
};
