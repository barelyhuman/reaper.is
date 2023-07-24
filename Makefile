.PHONY: build install clean watchStyles watchPages watch

b: build

w: watch 

build:
	./bin/alvu --highlight --highlight-theme="algol_nu" --hard-wrap=false
	npx tailwindcss -i ./public/global.css -o ./dist/styles.css --minify
	npx pagefind@latest --source "dist"

prepareBin:
	mkdir -p ./bin

install: prepareBin installAlvu installTW	

installAlvu:
	# Downloading alvu
	# https://github.com/barelyhuman/alvu
	curl -sf https://goblin.run/github.com/barelyhuman/alvu | PREFIX=./bin sh
	chmod +x ./bin/alvu

installTW:
	npm i tailwindcss

clean:
	rm ./bin/alvu ./bin/tailwindcss

watchStyles:
	./bin/tailwindcss -i ./public/global.css -o ./dist/styles.css --watch

watchPages:
	./bin/alvu -highlight-theme="algol_nu" -hard-wrap=false -serve 

watch:
	${MAKE} -j4 watchPages watchStyles 