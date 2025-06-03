.DEFAULT_GOAL := dev
VERSION=$(shell git describe --tags --always --long)
SOURCE_GO=jenkinsctl.go
EXECUTABLE=jenkinsctl
WINDOWS=$(EXECUTABLE)_windows_amd64.exe
LINUX=$(EXECUTABLE)_linux_amd64
DARWIN=$(EXECUTABLE)_darwin_amd64
DEBUG_EXECUTABLE=$(EXECUTABLE)_debug

windows: $(WINDOWS) ## Build for Windows

linux: $(LINUX) ## Build for Linux

darwin: $(DARWIN) ## Build for Darwin (macOS)

debug: $(DEBUG_EXECUTABLE) ## Build with debugging symbols

$(DEBUG_EXECUTABLE):
	rm -f $(DEBUG_EXECUTABLE)
	go build -v -gcflags="all=-N -l" -o $(DEBUG_EXECUTABLE) $(SOURCE_GO)

BIN_ALL_PLATFORMS=$(WINDOWS) $(LINUX) $(DARWIN) $(DEBUG_EXECUTABLE)

$(WINDOWS):
	rm -f $(WINDOWS)
	env GOOS=windows GOARCH=amd64 go build -v -o $(WINDOWS) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(LINUX):
	rm -f $(LINUX)
	env GOOS=linux GOARCH=amd64 go build -v -o $(LINUX) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(DARWIN):
	rm -f $(DARWIN)
	env GOOS=darwin GOARCH=amd64 go build -v -o $(DARWIN) -ldflags="-s -w -X main.version=$(VERSION)" $(SOURCE_GO)

clean:
	rm -f $(BIN_ALL_PLATFORMS)
	go clean --modcache

dev: clean debug
	@echo version: $(VERSION)

# Work file is used for local development. Remove it before building for production.
check_go_work:
	@if [ -f go.work ]; then \
		echo "go.work file found, please remove it"; \
		exit 1; \
	fi

# Pre-requisites: 
# - need to publish dependacy verision
# -  mv work file,
# - use go get to fetch published version (go get github.com/cam-mclaren/jenkinsctl/jenkins@jenkins/v0.0.1) and update the mod file, run go mod tidy. 
prod: check_go_work clean windows linux darwin  ## Build binaries
	@echo version: $(VERSION)
