
watch: 
	ls *.md pages/**/*.md hooks/* public/* | entr -cr make build 

w: watch 

b: build

build:
	alvu
