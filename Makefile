
# ALVU_EXEC=$(HOME)/code/alvu/alvu
ALVU_EXEC=alvu

watch: 
	$(ALVU_EXEC) --hard-wrap=false --highlight --highlight-theme="algol_nu" --serve

watch_js:
	./scripts/watcher ./js ./scripts/minify


w: watch 

wjs: watch_js

b: build

build:
	alvu --highlight --highlight-theme="algol_nu" --hard-wrap=false
