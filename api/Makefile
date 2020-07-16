.PHONY: build clean deploy

build:
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/create users/create/create.go
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/confirm users/confirm/confirm.go
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/read users/read/read.go
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/update users/update/update.go
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/delete users/delete/delete.go
	# env GOOS=linux go build -ldflags="-s -w" -o bin/users/graph users/graph/graph.go
	( \
		python3 -m venv v-env; \
		source v-env/bin/activate; \
		pip install -r requirements.txt; \
		deactivate; \
	)

	( \
		mkdir -p build; \
		cp -a ./v-env/lib/python3.8/site-packages/* build/; \
		cp -a ./src/functions/* build/; \
		cd build; zip -r9 build.zip . \
	)

clean:
	rm -rf ./build

deploy: clean build
	sls deploy --verbose
