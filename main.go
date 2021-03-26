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

type Metadata struct {
	Published bool   `yaml:"published"`
	Title     string `yaml:"title"`
	Date      Date   `yaml:"date"`
	Slug      string
	Content   string
}

type Post struct {
	Meta    Metadata
	Content string
}

type BlogIndex struct {
	Files []Metadata
}

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

	err = CopyDir(publicFolder, outPath)
	if err != nil {
		log.Fatalln(err)
	}

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

	parsedTemplates, err = template.ParseGlob(templatesPath + "/*")

	err = convertDirectoryToMarkdown(contentPath)
	if err != nil {
		log.Fatal("Failed to convert directory, Error: ", err)
	}

	blogIndexFile, err := os.Create(postIndexPath)
	defer blogIndexFile.Close()

	sort.Slice(filesForIndex, func(i, j int) bool {
		return filesForIndex[j].Date.Time.Before(filesForIndex[i].Date.Time)
	})

	err = parsedTemplates.ExecuteTemplate(blogIndexFile, "blogIndexHTML", BlogIndex{Files: filesForIndex})
	blogIndexFile.Sync()

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

func changeFileExtension(fileName string, checkFor string, replaceWith string) string {
	return strings.Replace(fileName, checkFor, replaceWith, 1)
}

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

func convertDirectoryToMarkdown(srcFolder string) error {

	pathPrefix := srcFolder
	outPathPrefix := "/"

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

		extension := strings.SplitN(file.Name(), ".", -1)
		isHTMLFile := extension[len(extension)-1] == "html"

		os.MkdirAll(outPath+"/"+outPathPrefix, os.ModePerm)

		fileData, err := ioutil.ReadFile(pathPrefix + "/" + file.Name())

		if extension[len(extension)-1] != "md" && !isHTMLFile {
			log.Println("Skipping file, not a markdown file", file.Name())
			continue
		}

		var parsedHtmlFile *template.Template
		var dynTemplateName string
		if isHTMLFile {
			var err error
			dynTemplateName = file.Name() + "HTML"
			newTemplate := parsedTemplates.New(file.Name() + "HTML")
			if err != nil {
				return err
			}
			parsedHtmlFile, err = newTemplate.Parse(string(fileData))
			if err != nil {
				return err
			}
		}

		if err != nil {
			log.Println(err)
		}

		metadata := Metadata{}

		parts := bytes.SplitN(fileData, []byte("---"), 3)

		fileNameHTML := changeFileExtension(file.Name(), ".md", ".html")

		metadata.Slug = outPathPrefix + "/" + fileNameHTML

		if len(parts) == 3 {
			err = yaml.Unmarshal(parts[1], &metadata)

			if err != nil {
				log.Println(err)
			}

			if metadata.Published {
				var toHTML bytes.Buffer

				err = markdownProcessor.Convert(parts[2], &toHTML)
				if err != nil {
					log.Fatal(err)
				}

				metadata.Content = toHTML.String()
				filesForIndex = append(filesForIndex, metadata)
				writeToBlog(outPathPrefix+"/"+fileNameHTML, metadata)
			}
		} else {
			if isHTMLFile {
				writeParsedHTML(outPath+"/"+outPathPrefix+"/"+fileNameHTML, parsedHtmlFile, dynTemplateName)
			} else {
				simpleFileName := changeFileExtension(file.Name(), ".md", "")
				simpleFileName = strings.ReplaceAll(simpleFileName, "-", "")
				metadata.Title = toTitleCase(simpleFileName)
				writeToPage(outPathPrefix+"/"+fileNameHTML, fileData, metadata)
			}
		}
	}

	return nil
}

func writeParsedHTML(filePath string, templates *template.Template, templateName string) {
	fileToWrite, err := os.Create(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer fileToWrite.Close()
	templates.ExecuteTemplate(fileToWrite, templateName, nil)
	fileToWrite.Sync()
}

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
