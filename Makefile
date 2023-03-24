
# ALVU_EXEC=$(HOME)/code/alvu/alvu
ALVU_EXEC=alvu

watch: 
	ls *.md pages/**/*.md hooks/* public/* | entr -cr $(ALVU_EXEC) --hard-wrap=false --highlight --serve

w: watch 

b: build

build:
	alvu --highlight
