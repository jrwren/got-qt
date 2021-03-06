# Borrowed from:
# https://github.com/silven/go-example/blob/master/Makefile
# https://vic.demuzere.be/articles/golang-makefile-crosscompile/

BINARY = got-qt

# Symlink into GOPATH
GITHUB_USERNAME=amlwwalker
GOT_QT_PROJECTS=got-qt-projects
CONSOLE_DIR=cuiinterface
GUI_DIR=qt
DEV_SOURCE=${GOPATH}/src/github.com
# BUILD_DIR=${DEV_SOURCE}/${GOT_QT_PROJECTS}/${BINARY}
CURRENT_DIR=$(shell pwd)

#install parameters
GOT_QT_REPO=git@github.com:amlwwalker/got-qt.git

# Build the project
all: clean console darwin #linux windows

hardinstall: setup install

setup:
	#install everything including qt
	brew install qt5
#configure the setup for this
install:
	#first go to build dir
	cd ${DEV_SOURCE}; \
	#now make a directory to store the got-qt
	mkdir ${GITHUB_USERNAME}; \
	#now clone got-qt into there
	git clone ${GOT_QT_REPO} ${GITHUB_USERNAME}/ \
	#now make sure the user has therecipe/qt installed
	go get -u -v github.com/therecipe/qt/cmd/...; \
	$GOPATH/bin/qtsetup;

#var topLevel = filepath.Join(os.Getenv("GOPATH"), "src", "github.com", "amlwwalker", "got-qt", "qt", "qml")
createproject: #pass this PROJECTNAME, e.g: make createproject PROJECTNAME=testproject
	#create the directory in github.com
	cd ${DEV_SOURCE}; \
	mkdir -p ${GOT_QT_PROJECTS}/${PROJECTNAME}; \
	cd ${GOT_QT_PROJECTS}/${PROJECTNAME}; \
	rsync -av --exclude=".git" ${DEV_SOURCE}/${GITHUB_USERNAME}/got-qt/* . ; \
	sed -i.bak s/"got-qt"/"${PROJECTNAME}"/g qt/main.go; \
	sed -i.bak s/"amlwwalker"/"${GOT_QT_PROJECTS}"/g qt/main.go;


console:
	cd ${CONSOLE_DIR}; \
	go build -o consoleApp; \
	cd - >/dev/null

# linux:
# 	cd ${BUILD_DIR}; \
# 	#GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-linux-${GOARCH} . ; \

# 	cd - >/dev/null

darwin:
	cd ${GUI_DIR}; \
	qtdeploy build desktop; \
	cd - >/dev/null

#only setup for OSX!
hotload:
	cd ${GUI_DIR}; \
	/deploy/darwin/${GUI_DIR}.app/Contents/MacOS/${GUI_DIR}
# windows:
# 	cd ${BUILD_DIR}; \
# 	cd ${GUI_DIR}; \
# 	#GOOS=windows GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-windows-${GOARCH}.exe . ; \

# 	cd - >/dev/null

# fmt:
# 	cd ${BUILD_DIR}; \
# 	go fmt $$(go list ./... | grep -v /vendor/) ; \
# 	cd - >/dev/null

# clean:
# 	cd ${BUILD_DIR}; \
# 	rm -rf ${CONSOLE_DIR}/${BINARY}-* \
# 	rm -rf ${GUI_DIR}/deploy