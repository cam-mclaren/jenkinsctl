.DEFAULT_GOAL := build
VERSION=$(shell git describe --tags --always --long)
SOURCE_GO=jenkinsctl.go
EXECUTABLE=jenkinsctl
WINDOWS=$(EXECUTABLE)_windows_amd64.exe
LINUX=$(EXECUTABLE)_linux_amd64
DARWIN=$(EXECUTABLE)_darwin_amd64
DEBUG_EXECUTABLE=$(EXECUTABLE)_debug

windows: createmod $(WINDOWS) ## Build for Windows

linux: createmod $(LINUX) ## Build for Linux

darwin: createmod $(DARWIN) ## Build for Darwin (macOS)

debug: createmod $(DEBUG_EXECUTABLE) ## Build with debugging symbols

$(DEBUG_EXECUTABLE):
	rm -f $(EXECUTABLE)
	go build -v -gcflags="all=-N -l" -o $(DEBUG_EXECUTABLE) $(SOURCE_GO)

BIN_ALL_PLATFORMS=$(WINDOWS) $(LINUX) $(DARWIN)

$(WINDOWS):
	rm -f $(EXECUTABLE)
	env GOOS=windows GOARCH=amd64 go build -v -o $(WINDOWS) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(LINUX):
	rm -f $(EXECUTABLE)
	env GOOS=linux GOARCH=amd64 go build -v -o $(LINUX) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(DARWIN):
	rm -f $(EXECUTABLE)
	env GOOS=darwin GOARCH=amd64 go build -v -o $(DARWIN) -ldflags="-s -w -X main.version=$(VERSION)" $(SOURCE_GO)

createmod: clean
	cd jenkins && go mod init github.com/cam-mclaren/jenkinsctl/jenkins
	cd jenkins && go mod tidy
	go mod init github.com/cam-mclaren/jenkinsctl
	go mod tidy

all: createmod build

clean:
	rm -f go.sum go.mod $(BIN_ALL_PLATFORMS)
	cd jenkins && rm -f go.mod go.sum
	go clean --modcache

build: createmod windows linux darwin ## Build binaries
	@echo version: $(VERSION)
