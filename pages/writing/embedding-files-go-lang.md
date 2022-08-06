---

title: Embedding Files in your Go Lang binary
date: 22/07/2021
published: true
---

We talked about how I built [https://status.barelyhuman.dev](https://status.barelyhuman.dev) and what I was doing to handle adding the html data into the final binary so that the hosting provider could render the html from a single binary.

You can read that post [here](https://reaper.is/posts/status-vercel-and-how-did-it.html)

The previous solution works and was quite easy to do but then it obviously took away my speed since there's no syntax highlighting for css or html as they are all just go strings now. Plus, to format the html or css I have to move them to a separate file format it there and paste it back here which is really not something I wish to do if I have to maintain the repo for a long time.

So i started looking up ways and while I knew about go embed I was waiting for embed filesystem(FS) to get a little more stable and then I forgot about it and never checked the pull requests that were to be merged for embed FS. I happened to randomly check it two days back and so I'm now going to talk about how embed works and how status is using it to handle the HTML and style templates.

### html/template

This assumes that you've worked with `html/templates` in go before and we build up on that.
The basic html/template code flow is something like this

1. Parse the templates, either as files , glob, or the entire file system with a certain pattern.
2. Execute the template with the needed variable data for the actual compilation to be done
3. Write the compiled template to an io.Writer instance, in our case, the http socket

### embed

embed provides two ways to go about embedding files or other static data

1. Read the file into a byte slice
2. Read the file into the embed filesystem

If we were to use the first one the code would look a little something like

```go
package extras

import (
	_"embed"
	"html/template"
)

//go:embed templates/home.html
var homeHTML []byte
```

the modifier you need to look at is `go:embed` this allows you to put a path based on the current file, you cannot use files from folder outside your current `.go` file , which is the current limitation of pattern matching but I really hope changes in the future.

The compiler then reads and embeds the data into the variable `homeHTML` and then you can continue using the file like it's already read.
but in out case we have more than one template and you can add that to each variable , just know that the `go:embed` has to be on the top level and cannot be inside a function (at least, when I'm typing this.)

The other way involves using the embed FS which is basically going to do the same thing but instead creates an in-binary filesystem that you can read through. This is built on the existing go FS interface so you can use the embedFS wherever the FS interface is supported which the `html/template` library does and we are going to use that since I don't want to manually have to go and add the embed since I am parsing all templates anyway.

The code for the same would look something like this

```go
package extras

import (
	"embed"
	"html/template"
)

//go:embed templates/*.html
var embedFS embed.FS


// GetTemplates - parse and get all templates
func GetTemplates() (*template.Template, error) {
	allTemplates, err := template.ParseFS(embedFS, "templates/*.html","styles/styles.html")
	if err != nil {
		return nil, err
	}
	return allTemplates, nil
}
```

The line of focus is again the `go:embed` comment but also focus on the next line this time, we now have a variable that is of the type `embed.FS` which as I mentioned before is an implementation of the filesystem interface that go already has for other io interfaces and since the `html/template` allows you to parse based on filesystem and from the 2nd param you can add in patterns which is of the type `(...strings)` aka infinite patterns on the FS and everything gets parsed into `allTemplates`.

At this point, all I do is call `GetTemplates` from wherever I need them, and follow the normal template code flow

1. Compile them with the required variable data
2. Pass them to the io.Writer interface, in our case the http socket

and we are basically done, as a user, this won't create a difference on what you see when you open status but as a dev, this made it a lot more easier for me to handle changes in the html and style files.
