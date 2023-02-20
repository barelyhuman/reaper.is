
watch: 
	ls *.md pages/**/*.md hooks/* public/* | entr -cr alvu --highlight --serve

w: watch 

b: build

build:
	alvu --highlight
