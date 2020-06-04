.PHONY: build clean deploy

build:
	env GOOS=linux go build -ldflags="-s -w" -o bin/users/create users/create/create.go
	env GOOS=linux go build -ldflags="-s -w" -o bin/users/read users/read/read.go
	env GOOS=linux go build -ldflags="-s -w" -o bin/users/update users/update/update.go
	env GOOS=linux go build -ldflags="-s -w" -o bin/users/delete users/delete/delete.go

clean:
	rm -rf ./bin ./vendor Gopkg.lock

deploy: clean build
	sls deploy --verbose
