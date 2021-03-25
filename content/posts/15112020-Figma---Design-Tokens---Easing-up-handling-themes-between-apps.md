---
title: Figma - Design Tokens - Easing up handling themes between apps.
published: true
date: 15/11/2020
---

As a designer there's often times where I prototype something and then go ahead and handle the colors in a constants file.

It's mostly for colors because that gives me access to be able to handle the changes in theme from a single source of truth.

## Manual Process 

The manual process is pretty common, you create a small block that consists of all the colors and then you just copy the colors out to a simple file which can export the colours. In case of Javascript its a simple JSON file since javascript natively supports handling json. In other languages , like GO I prefer having it written with stricter types and/or enums. 

## Semi-Automatic

The other process is to use a design system library that generates the colours into a usable format for you. You can write a script for using with Illustrator and since I just started using Figma there's a few plugins that figma's community has built that makes it a little more easier. 

The official term of this is a "Style Dictionary" and the most followed standard is the Amazon's Style Dictionary. I don't really want to go in depth of how style dictionaries work and what they are, there's better posts about it on the web. 

We'll just setup Figma so it can export the styles we define as a style dictionary to be used with various services. I'm focusing on React Native and Web frameworks for this so the JSON output works fine. Other languages can use a JSON decoder to get it in the language's native map/hashmap/dictionary format.

### Figma and Design Tokens

People who've been using figma for while might already know about this plugin but this is coming from a person who just started moving towards using Figma for interface design and I came across this plugin a fews weeks back but couldn't recommend it till I was done with my own set of tests.

The plugin is **still in dev** so both the creator and I'd like you to keep that in mind while using the plugin.

[Design Tokens](https://github.com/lukasoppermann/design-tokens) is a simple plugin that you can add to your figma workflow that will allow you to export all your style definitions to a json file.

We'll start small, let's say I setup 2 styles in my Figma File, 

1. for the color #121212 as Black 
2. one for the basic font Roboto as Font-Normal

Once installed I can just right click on the file > Plugins > Design Tokens > Export to JSON and you will be prompted to download a JSON file with the following content



```json
{
  "black": {
    "category": "fill",
    "value": "rgba(18, 18, 18, 1)",
    "type": "color"
  },
  "font-normal": {
    "fontSize": {
      "value": 12,
      "type": "number",
      "unit": "pixel"
    },
    "textDecoration": {
      "value": "none",
      "type": "string"
    },
    "fontFamily": {
      "value": "Roboto",
      "type": "string"
    },
    "fontStyle": {
      "value": "Regular",
      "type": "string"
    },
    "letterSpacing": {
      "value": 0,
      "type": "number",
      "unit": "percent"
    },
    "lineHeight": {
      "value": "normal",
      "type": "string",
      "unit": "auto"
    },
    "paragraphIndent": {
      "value": 0,
      "type": "number",
      "unit": "pixel"
    },
    "paragraphSpacing": {
      "value": 0,
      "type": "number",
      "unit": "pixel"
    },
    "textCase": {
      "value": "none",
      "type": "string"
    }
  }
}
```

As you can see, that's basically every property that you could've edited per style. 



### Simplifying the Copy Paste of JSON

The plugin also allows you to setup a GitHub repository or a server where the updated tokens can be sent and this makes it a painless process for both the design and dev process, if the designer decided to change the theme, he can do so in the figma styles and just export it to the url you've provided in the settings. 

This can point to an existing code repo or a separate design repository that is being used as a submodule and you don't have to manually check if the theme works since the standard is to be followed.

I'll write about more plugins and more design to dev process simplification as I get more and more tools involved in my design process. 

Till then, Adios!



