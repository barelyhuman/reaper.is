
watch: 
	ls *.md pages/**/*.md | entr -cr make build 

w: watch 

b: build

build:
	alvu
