.PHONY: build clean deploy

build:
	( \
		python3 -m venv v-env; \
		source v-env/bin/activate; \
		pip install -r requirements.txt; \
		deactivate; \
	)

	mkdir -p build;
	7z a build/functions.zip ./src/functions/*;
	mkdir -p build/python;
	cp -a ./v-env/lib/python3.8/site-packages/* build/python;
	7z a build/deps.zip ./build/python;

clean:
	rm -rf ./build

deploy: clean build
	sls deploy --verbose
