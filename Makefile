.PHONY: build install clean watchStyles watchPages watch

b: build

w: watch 

build:
	./bin/alvu --highlight --highlight-theme="algol_nu" --hard-wrap=false
	./bin/tailwindcss -i ./public/global.css -o ./dist/styles.css --minify
	./bin/pagefind --source "dist"

install: 
	./scripts/setup

clean:
	rm ./bin/alvu ./bin/tailwindcss

watchStyles:
	./bin/tailwindcss -i ./public/global.css -o ./dist/styles.css --watch

watchPages:
	./bin/alvu -highlight-theme="algol_nu" -hard-wrap=false -serve 

watch:
	${MAKE} -j4 watchPages watchStyles 