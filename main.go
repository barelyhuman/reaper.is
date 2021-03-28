package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"
	"text/template"
	"time"

	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer/html"
	"gopkg.in/yaml.v2"
)

// Config
// TODO: move to a yaml config
const contentPath = "./content"
const templatesPath = "./templates"
const outPath = "./out"
const publicFolder = "./public"
const postIndexPath = "./out/posts/index.html"
const generateRSS = true
const rssOutPath = "./out/blog.xml"

// Metadata - meta data to be extracted from the frontmatter
type Metadata struct {
	Published bool   `yaml:"published"`
	Title     string `yaml:"title"`
	Date      Date   `yaml:"date"`
	Slug      string
	Content   string
}

// Post - container for both metadata and the content of the post
// used to differentiate between a post and just metadata as part of
// other items that might need metadata
type Post struct {
	Meta    Metadata
	Content string
}

// BlogIndex , used for storing metadata indexes for creatings a blog index
// responsible for the /posts url to show a list of all available posts
type BlogIndex struct {
	Files []Metadata
}

// ATOMFeed - Information stuct containing all needed items for for creating a Atom RSS Feed
// TODO: has duplicate structs and can reuse existing structs
type ATOMFeed struct {
	Site struct {
		Name        string
		Link        string
		Description string
	}
	Posts []struct {
		Slug    string
		Title   string
		Link    string
		Content string
		Date    time.Time
	}
}

var (
	markdownProcessor goldmark.Markdown
	parsedTemplates   *template.Template
	filesForIndex     []Metadata
)

func main() {

	// Clean existing out directory
	err := os.RemoveAll(outPath)

	// Copy the public directory to the out folder for the needed public assets
	err = CopyDir(publicFolder, outPath)
	if err != nil {
		log.Fatalln(err)
	}

	// Initiate Markdown Processor
	markdownProcessor = goldmark.New(
		goldmark.WithExtensions(extension.GFM, extension.Footnote),
		goldmark.WithParserOptions(
			parser.WithAutoHeadingID(),
		),
		goldmark.WithRendererOptions(
			html.WithHardWraps(),
			html.WithXHTML(),
			html.WithUnsafe(),
		),
	)

	// Parse all templates from templates directory to hold into
	// the global variable to use later with other dynamic templates generated later
	parsedTemplates, err = template.ParseGlob(templatesPath + "/*")

	// Convert the given content source from config into markdown/compiled HTML files
	err = convertDirectoryToMarkdown(contentPath)
	if err != nil {
		log.Fatal("Failed to convert directory, Error: ", err)
	}

	// Create a blog index file and write contents to it
	// using the existing blog index template
	blogIndexFile, err := os.Create(postIndexPath)
	defer blogIndexFile.Close()

	sort.Slice(filesForIndex, func(i, j int) bool {
		return filesForIndex[j].Date.Time.Before(filesForIndex[i].Date.Time)
	})

	err = parsedTemplates.ExecuteTemplate(blogIndexFile, "blogIndexHTML", BlogIndex{Files: filesForIndex})
	blogIndexFile.Sync()

	// Generate the rss feed if the config variable is set to true
	if generateRSS {
		feed := ATOMFeed{}

		feed.Site = struct {
			Name        string
			Link        string
			Description string
		}{
			Name:        "Reaper",
			Link:        "https://reaper.im",
			Description: "stories, rants, and development",
		}

		for _, fileIndex := range filesForIndex {
			feed.Posts = append(feed.Posts,
				struct {
					Slug    string
					Title   string
					Link    string
					Content string
					Date    time.Time
				}{
					Slug:    fileIndex.Slug,
					Title:   fileIndex.Title,
					Link:    feed.Site.Link + "/" + fileIndex.Slug,
					Date:    fileIndex.Date.Time,
					Content: fileIndex.Content,
				},
			)
		}

		rssWriter, err := os.Create(rssOutPath)
		if err != nil {
			log.Fatal(err)
		}
		defer rssWriter.Close()

		err = parsedTemplates.ExecuteTemplate(rssWriter, "rssTemplate", feed)

		if err != nil {
			log.Fatal(err)
		}

		rssWriter.Sync()
	}

}

// changeFileExtension - simple replace statement wrapper to change the extension of files
func changeFileExtension(fileName string, checkFor string, replaceWith string) string {
	return strings.Replace(fileName, checkFor, replaceWith, 1)
}

// writeToBlog - Write the given html to the blog output
// and compile the html using the given the metadata
func writeToBlog(fileNameHTML string, metadata Metadata) {
	fileToWrite, err := os.Create(outPath + "/" + fileNameHTML)
	if err != nil {
		panic(err)
	}
	defer fileToWrite.Close()

	post := Post{
		Meta:    metadata,
		Content: metadata.Content,
	}

	err = parsedTemplates.ExecuteTemplate(fileToWrite, "blogPostHTML", post)
	if err != nil {
		log.Fatal(err)
	}

	fileToWrite.Sync()
}

// writeToPage - write to a simple page instead of blog and use the simple
// page template to create the output file, again uses metadata as needed
func writeToPage(fileNameHTML string, content []byte, metadata Metadata) {
	fileToWrite, err := os.Create(outPath + "/" + fileNameHTML)
	if err != nil {
		panic(err)
	}
	defer fileToWrite.Close()

	var toHTML bytes.Buffer

	if err := markdownProcessor.Convert(content, &toHTML); err != nil {
		panic(err)
	}

	post := Post{
		Meta:    metadata,
		Content: string(toHTML.Bytes()),
	}

	err = parsedTemplates.ExecuteTemplate(fileToWrite, "simplePageHTML", post)
	if err != nil {
		log.Fatal(err)
	}

	fileToWrite.Sync()
}

// Convert the given directory into markdown and write the processed data to
// the out folder
func convertDirectoryToMarkdown(srcFolder string) error {
	// define prefixes for reading and writing
	pathPrefix := srcFolder
	outPathPrefix := "/"

	// if the source folder and the content folder don't match,
	// aka, you are not on the root directory for processing so add the nested values to the path
	if srcFolder != contentPath {
		pathPrefix = contentPath + "/" + srcFolder
		outPathPrefix = strings.Replace(srcFolder, "./", "", 1)
	}

	info, err := os.Stat(pathPrefix)
	if err != nil {
		return err
	}

	if !info.IsDir() {
		return fmt.Errorf("Given source is not a directory")
	}

	files, err := ioutil.ReadDir(pathPrefix)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		if file.IsDir() {
			convertDirectoryToMarkdown(file.Name())
			continue
		}

		err := handleUnprocessedTemplate(pathPrefix, outPathPrefix, file)
		if err != nil {
			return err
		}
	}

	return nil
}

// Check if the extension matches that of a markdown file
func isMarkdownFile(file os.FileInfo) bool {
	extension := strings.SplitN(file.Name(), ".", -1)
	return extension[len(extension)-1] == "md"
}

// Check if the extension matches that of a html file
func isHTMLFile(file os.FileInfo) bool {
	extension := strings.SplitN(file.Name(), ".", -1)
	return extension[len(extension)-1] == "html"
}

// normalizeOtherFileTypeName - as the name specifies, make sure the name doesn't have any spaces when
// used to create a html file
func normalizeOtherFileTypeName(file os.FileInfo) string {
	fileName := changeFileExtension(file.Name(), ".md", "")
	fileName = strings.ReplaceAll(fileName, "-", "")
	return fileName
}

//  handleUnprocessedTemplate - handle the given path, output , file to process
//  by converting an Markdown file with Frontmatter into a blog file
//  a normal markdown file into a simple html file and
//  a html file into a dynamically compiled go html template
func handleUnprocessedTemplate(pathPrefix string, outPathPrefix string, file os.FileInfo) error {
	var err error
	var isHTMLFileBool = isHTMLFile(file)

	os.MkdirAll(outPath+"/"+outPathPrefix, os.ModePerm)

	fileData, err := ioutil.ReadFile(pathPrefix + "/" + file.Name())

	if !isMarkdownFile(file) && !isHTMLFileBool {
		log.Println("Skipping file, not a markdown file", file.Name())
		return nil
	}

	if isHTMLFileBool {
		err = handleHTMLFile(file, fileData, outPathPrefix)
		if err != nil {
			return err
		}
	} else if isMarkdownWithFrontMatter(fileData) {
		return handleMarkdownFile(file, fileData, outPathPrefix)
	} else {
		return handleOtherFile(file, fileData, outPathPrefix)
	}
	return nil
}

// isMarkdownWithFrontMatter - check if the markdown file has any frontmatter
func isMarkdownWithFrontMatter(fileData []byte) bool {
	parts := bytes.SplitN(fileData, []byte("---"), 3)
	if len(parts) != 3 {
		return false
	}
	return true
}

//  handleOtherFile - handle files that are not html templates or blog (with frontmatter)
//  based markdown and just a simple markdown file
func handleOtherFile(file os.FileInfo, fileData []byte, outPathPrefix string) error {
	metadata := Metadata{}
	fileNameHTML := changeFileExtension(file.Name(), ".md", ".html")
	metadata.Slug = outPathPrefix + "/" + fileNameHTML
	name := normalizeOtherFileTypeName(file)
	metadata.Title = toTitleCase(name)
	writeToPage(outPathPrefix+"/"+fileNameHTML, fileData, metadata)
	return nil
}

// handleHTMLFile - handle creation and writing of a html file by dynamically creating
// a template , compiling it and then writing it with the same name as the source
// used to create the compiled index.html page of this blog
func handleHTMLFile(file os.FileInfo, fileData []byte, outPathPrefix string) error {
	fileNameHTML := changeFileExtension(file.Name(), ".md", ".html")
	dynTemplateName := file.Name() + "HTML"
	newTemplate := parsedTemplates.New(file.Name() + "HTML")
	parsedHtmlFile, err := newTemplate.Parse(string(fileData))
	if err != nil {
		return err
	}
	writeParsedHTML(outPath+"/"+outPathPrefix+"/"+fileNameHTML, parsedHtmlFile, dynTemplateName)
	return nil
}

// handleMarkdownFile - specifically handle markdown files with frontmatter available
// and pass them to compile with the blog-post styled template
func handleMarkdownFile(file os.FileInfo, fileData []byte, outPathPrefix string) error {
	metadata := Metadata{}
	fileNameHTML := changeFileExtension(file.Name(), ".md", ".html")
	metadata.Slug = outPathPrefix + "/" + fileNameHTML
	parts := bytes.SplitN(fileData, []byte("---"), 3)
	if len(parts) != 3 {
		return nil
	}

	err := yaml.Unmarshal(parts[1], &metadata)

	if err != nil {
		return err
	}

	if metadata.Published {
		var toHTML bytes.Buffer

		err = markdownProcessor.Convert(parts[2], &toHTML)
		if err != nil {
			return err
		}

		metadata.Content = toHTML.String()
		filesForIndex = append(filesForIndex, metadata)
		writeToBlog(outPathPrefix+"/"+fileNameHTML, metadata)
	}
	return nil
}

// writeParsedHTML - write the parsed html file to the needed out file
func writeParsedHTML(filePath string, templates *template.Template, templateName string) {
	fileToWrite, err := os.Create(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer fileToWrite.Close()
	templates.ExecuteTemplate(fileToWrite, templateName, nil)
	fileToWrite.Sync()
}

// toTitleCase - simple string convertion for strings to title case style
// eg: a fox => A Fox
func toTitleCase(toConv string) string {
	parts := strings.SplitN(toConv, " ", -1)
	result := []string{}
	for _, word := range parts {
		result = append(result,
			strings.ToUpper(string(word[0]))+word[1:],
		)
	}
	return strings.Join(result, " ")
}
