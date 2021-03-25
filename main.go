package main

import (
	"bytes"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"
	"text/template"

	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer/html"
	"gopkg.in/yaml.v2"
)

// Config
// TODO: move to a yaml config
const postsPath = "./posts"
const templatesPath = "./templates"
const staticRoot = "./out"
const publicFolder = "./public"
const slugPrefix = "posts"
const outPath = staticRoot + "/" + postsPath

type Metadata struct {
	Published bool   `yaml:"published"`
	Title     string `yaml:"title"`
	Date      Date   `yaml:"date"`
	Slug      string
}

type Post struct {
	Meta    Metadata
	Content string
}

type BlogIndex struct {
	Files []Metadata
}

var (
	markdownProcessor goldmark.Markdown
	parsedTemplates   *template.Template
)

func main() {

	// Clean existing out directory
	err := os.RemoveAll(staticRoot)

	if err != nil {
		log.Fatalln(err)
	}

	markdownProcessor = goldmark.New(
		goldmark.WithExtensions(extension.GFM, extension.Footnote),
		goldmark.WithParserOptions(
			parser.WithAutoHeadingID(),
		),
		goldmark.WithRendererOptions(
			html.WithHardWraps(),
			html.WithXHTML(),
		),
	)

	files, err := ioutil.ReadDir(postsPath)
	if err != nil {
		log.Fatal(err)
	}

	if err != nil {
		log.Fatal(err)
	}

	var filesForIndex []Metadata
	parsedTemplates, err = template.ParseGlob(templatesPath + "/*")

	err = CopyDir(publicFolder, staticRoot)
	if err != nil {
		log.Fatalln(err)
	}

	err = os.MkdirAll(outPath, os.ModePerm)

	for _, file := range files {
		fileData, err := ioutil.ReadFile(postsPath + "/" + file.Name())

		if err != nil {
			log.Panicln("Couldn't read file:"+file.Name(), err)
		}

		metadata := Metadata{}

		parts := bytes.SplitN(fileData, []byte("---"), 3)

		err = yaml.Unmarshal(parts[1], &metadata)

		if err != nil {
			log.Println(err)
		}

		if metadata.Published {
			fileNameHTML := changeFileExtension(file.Name(), ".md", ".html")
			metadata.Slug = slugPrefix + "/" + fileNameHTML
			filesForIndex = append(filesForIndex, metadata)
			writeToPublic(fileNameHTML, parts[2], metadata)
		}
	}

	blogIndexFile, err := os.Create(staticRoot + "/index.html")
	defer blogIndexFile.Close()

	sort.Slice(filesForIndex, func(i, j int) bool {
		return filesForIndex[j].Date.Time.Before(filesForIndex[i].Date.Time)
	})

	err = parsedTemplates.ExecuteTemplate(blogIndexFile, "blogIndexHTML", BlogIndex{Files: filesForIndex})
	blogIndexFile.Sync()

}

func changeFileExtension(fileName string, checkFor string, replaceWith string) string {
	return strings.Replace(fileName, checkFor, replaceWith, 1)
}

func writeToPublic(fileNameHTML string, content []byte, metadata Metadata) {
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

	err = parsedTemplates.ExecuteTemplate(fileToWrite, "blogPostHTML", post)
	if err != nil {
		log.Fatal(err)
	}

	fileToWrite.Sync()

}
