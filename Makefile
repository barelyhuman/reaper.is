.PHONY: build install clean watchStyles watchPages watch

b: build

w: watch 

build:
	./bin/alvu --highlight --highlight-theme="algol_nu" --hard-wrap=false
	./bin/tailwindcss -i ./public/global.css -o ./dist/style.css --minify

install:
	mkdir -p ./bin
	# Downloading alvu
	# https://github.com/barelyhuman/alvu
	curl -sf https://goblin.run/github.com/barelyhuman/alvu | PREFIX=./bin sh
	chmod +x ./bin/alvu
	# Downloading Tailwind CSS CLI for macOS arm64
	# https://github.com/tailwindlabs/tailwindcss/releases/latest
	curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64
	chmod +x ./tailwindcss-macos-arm64
	mv tailwindcss-macos-arm64 ./bin/tailwindcss

clean:
	rm ./bin/alvu ./bin/tailwindcss

watchStyles:
	./bin/tailwindcss -i ./public/global.css -o ./dist/styles.css --watch

watchPages:
	./bin/alvu -highlight-theme="algol_nu" -hard-wrap=false -serve 

watch:
	${MAKE} -j4 watchPages watchStyles 